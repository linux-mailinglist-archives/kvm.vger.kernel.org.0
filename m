Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DA30434E44
	for <lists+kvm@lfdr.de>; Wed, 20 Oct 2021 16:52:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230190AbhJTOyv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Oct 2021 10:54:51 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:32772 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230024AbhJTOyu (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 20 Oct 2021 10:54:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634741556;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=cwjsUEQDwBbKmSYjigmTSvrLl88NO9zDN0d6nZvJV+s=;
        b=VAa6x/m22cjTs6Wf5yqpTzkt92UhNjloA8u2SzxMCcAa+POBJmC0clbasPnYlFnnv6t6vp
        w77S0GNaHSbQ1/coB0S2yfcFBx72KyciOYkePXKXFX+kE0g2woBAgq6RmJw1Xa8bx3TT+G
        Bg02RPnAWeBKdmSKkcRZ9f3WN5MOF9s=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-123-jP0cnAsHN023n2-9t0xI9A-1; Wed, 20 Oct 2021 10:52:34 -0400
X-MC-Unique: jP0cnAsHN023n2-9t0xI9A-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 821E979EE4;
        Wed, 20 Oct 2021 14:52:33 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2275F5C1D5;
        Wed, 20 Oct 2021 14:52:33 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     wanpengli@tencent.com, seanjc@google.com
Subject: [PATCH] KVM: Avoid atomic operations when kicking the running vCPU
Date:   Wed, 20 Oct 2021 10:52:31 -0400
Message-Id: <20211020145231.871299-3-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

If we do have the vcpu mutex, as is the case if kvm_running_vcpu is set
to the target vcpu of the kick, changes to vcpu->mode do not need atomic
operations; cmpxchg is only needed _outside_ the mutex to ensure that
the IN_GUEST_MODE->EXITING_GUEST_MODE change does not race with the vcpu
thread going OUTSIDE_GUEST_MODE.

Use this to optimize the case of a vCPU sending an interrupt to itself.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 virt/kvm/kvm_main.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 3f6d450355f0..9f45f26fce4f 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3325,6 +3325,19 @@ void kvm_vcpu_kick(struct kvm_vcpu *vcpu)
 	if (kvm_vcpu_wake_up(vcpu))
 		return;
 
+	me = get_cpu();
+	/*
+	 * The only state change done outside the vcpu mutex is IN_GUEST_MODE
+	 * to EXITING_GUEST_MODE.  Therefore the moderately expensive "should
+	 * kick" check does not need atomic operations if kvm_vcpu_kick is used
+	 * within the vCPU thread itself.
+	 */
+	if (vcpu == __this_cpu_read(kvm_running_vcpu)) {
+		if (vcpu->mode == IN_GUEST_MODE)
+			WRITE_ONCE(vcpu->mode, EXITING_GUEST_MODE);
+		goto out;
+	}
+
 	/*
 	 * Note, the vCPU could get migrated to a different pCPU at any point
 	 * after kvm_arch_vcpu_should_kick(), which could result in sending an
@@ -3332,12 +3345,12 @@ void kvm_vcpu_kick(struct kvm_vcpu *vcpu)
 	 * IPI is to force the vCPU to leave IN_GUEST_MODE, and migrating the
 	 * vCPU also requires it to leave IN_GUEST_MODE.
 	 */
-	me = get_cpu();
 	if (kvm_arch_vcpu_should_kick(vcpu)) {
 		cpu = READ_ONCE(vcpu->cpu);
 		if (cpu != me && (unsigned)cpu < nr_cpu_ids && cpu_online(cpu))
 			smp_send_reschedule(cpu);
 	}
+out:
 	put_cpu();
 }
 EXPORT_SYMBOL_GPL(kvm_vcpu_kick);
-- 
2.27.0

