Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE5E4265C81
	for <lists+kvm@lfdr.de>; Fri, 11 Sep 2020 11:32:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725820AbgIKJcC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Sep 2020 05:32:02 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:24566 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725554AbgIKJcA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Sep 2020 05:32:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599816717;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=K4DFyJXY8m+V25NE+T5vQS6MN0ZdnFjFO0L25fv/fME=;
        b=EYfN7uYRaluIVseqYa+ObOLd0QwCztGQJt8293fz0QMQrFvCH8gZKlF6nkhNqYYZnSHWFt
        hlwUzUPkgPRMIV5idFXq9ts2iMMMelBKwMP70NAHM8pcZuzu3iBSR4FjTnfYY7U9SjE7zV
        /cL1Lzs8dX3q5544CamOA+UIFp8tKjQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-472-5qZrdsEbNLaKlaFb9QaiCw-1; Fri, 11 Sep 2020 05:31:53 -0400
X-MC-Unique: 5qZrdsEbNLaKlaFb9QaiCw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A2C1B18B9F01;
        Fri, 11 Sep 2020 09:31:51 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.193.114])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A4A8427BCC;
        Fri, 11 Sep 2020 09:31:48 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: x86: always allow writing '0' to MSR_KVM_ASYNC_PF_EN
Date:   Fri, 11 Sep 2020 11:31:47 +0200
Message-Id: <20200911093147.484565-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Even without in-kernel LAPIC we should allow writing '0' to
MSR_KVM_ASYNC_PF_EN as we're not enabling the mechanism. In
particular, QEMU with 'kernel-irqchip=off' fails to start
a guest with

qemu-system-x86_64: error: failed to set MSR 0x4b564d02 to 0x0

Fixes: 9d3c447c72fb2 ("KVM: X86: Fix async pf caused null-ptr-deref")
Reported-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/x86.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index d39d6cf1d473..44a86f7f2397 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2730,9 +2730,6 @@ static int kvm_pv_enable_async_pf(struct kvm_vcpu *vcpu, u64 data)
 	if (data & 0x30)
 		return 1;
 
-	if (!lapic_in_kernel(vcpu))
-		return 1;
-
 	vcpu->arch.apf.msr_en_val = data;
 
 	if (!kvm_pv_async_pf_enabled(vcpu)) {
@@ -2741,6 +2738,9 @@ static int kvm_pv_enable_async_pf(struct kvm_vcpu *vcpu, u64 data)
 		return 0;
 	}
 
+	if (!lapic_in_kernel(vcpu))
+		return 1;
+
 	if (kvm_gfn_to_hva_cache_init(vcpu->kvm, &vcpu->arch.apf.data, gpa,
 					sizeof(u64)))
 		return 1;
-- 
2.25.4

