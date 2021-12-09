Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3201446E7DC
	for <lists+kvm@lfdr.de>; Thu,  9 Dec 2021 12:56:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237063AbhLIL7i (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Dec 2021 06:59:38 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:39011 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235515AbhLIL7g (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 9 Dec 2021 06:59:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1639050963;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9AIjnWSPopPo72C8su8KdOslM5Yv6hEf0Yg46BrMqEs=;
        b=J/VPD+Yp6Nr+JLEo9PVMipBXQgGfVh9KnpSx/MtVtvX2PPNdiHfCWo4sVhE5scqsuF4ojh
        99v+qMvl4iNo5DDPDAMy3Tho2usq4BfZXUZDg49nmYagD38J2aJNJjzDHgAv+JlUVx6hxQ
        tqi4wbZLrmKueByLssWbCZAUaYduK+A=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-275-SF3NOLIGNcGLqk7tjWv6CA-1; Thu, 09 Dec 2021 06:55:36 -0500
X-MC-Unique: SF3NOLIGNcGLqk7tjWv6CA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E9E4285B663;
        Thu,  9 Dec 2021 11:55:34 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.40.192.24])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C7F3967840;
        Thu,  9 Dec 2021 11:55:30 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org (open list:X86 ARCHITECTURE (32-BIT AND
        64-BIT)), Wanpeng Li <wanpengli@tencent.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Joerg Roedel <joro@8bytes.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        x86@kernel.org (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)),
        Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jim Mattson <jmattson@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH 4/6] KVM: SVM: fix races in the AVIC incomplete IPI delivery to vCPUs
Date:   Thu,  9 Dec 2021 13:54:38 +0200
Message-Id: <20211209115440.394441-5-mlevitsk@redhat.com>
In-Reply-To: <20211209115440.394441-1-mlevitsk@redhat.com>
References: <20211209115440.394441-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

If the target vCPU has AVIC inhibited while the source vCPU isn't,
we need to set irr_pending, for the target to notice the interrupt.
Do it always to be safe, the same as in svm_deliver_avic_intr.

Also if the target has AVIC inhibited, the same kind of races
that happen in svm_deliver_avic_intr can happen here as well,
so apply the same approach of kicking the target vCPUs.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/svm/avic.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 8c1b934bfa9b..bdfc37caa64a 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -304,8 +304,17 @@ static void avic_kick_target_vcpus(struct kvm *kvm, struct kvm_lapic *source,
 	kvm_for_each_vcpu(i, vcpu, kvm) {
 		if (kvm_apic_match_dest(vcpu, source, icrl & APIC_SHORT_MASK,
 					GET_APIC_DEST_FIELD(icrh),
-					icrl & APIC_DEST_MASK))
-			kvm_vcpu_wake_up(vcpu);
+					icrl & APIC_DEST_MASK)) {
+
+			vcpu->arch.apic->irr_pending = true;
+			kvm_make_request(KVM_REQ_EVENT, vcpu);
+			/*
+			 * The target vCPU might have AVIC inhibited,
+			 * so we have to kick it, to make sure it processes
+			 * the interrupt.
+			 */
+			kvm_vcpu_kick(vcpu);
+		}
 	}
 }
 
-- 
2.26.3

