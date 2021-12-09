Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 450C846E7D6
	for <lists+kvm@lfdr.de>; Thu,  9 Dec 2021 12:56:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237029AbhLIL7L (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Dec 2021 06:59:11 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:51578 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237009AbhLIL7K (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 9 Dec 2021 06:59:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1639050937;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Wx9LIKICLlNBvH50QBmtXqjHVxH0joLnNIgLz9x4qyM=;
        b=F4LDa7Ls4hDwYM9xrIte5lMaPK1Xaf+5Jg93QjKJuPUi6Xcz+DfJ2ArhFOJZA6ij8PLxJH
        60efBHZLVhXUlX2UYMMn4XKRBHcTeopSSs8uiQV1jjQF2CC9Y3LWy37Q/5Cf/L4z/+Yf7w
        TUX+7qNgrBTDKv5LwGejJUTnbx8fSUA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-122-6HQcWw2dMj24L-smcfHzQg-1; Thu, 09 Dec 2021 06:55:31 -0500
X-MC-Unique: 6HQcWw2dMj24L-smcfHzQg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 556D5190B2A1;
        Thu,  9 Dec 2021 11:55:30 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.40.192.24])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3B05745D61;
        Thu,  9 Dec 2021 11:55:26 +0000 (UTC)
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
Subject: [PATCH 3/6] KVM: SVM: fix AVIC race of host->guest IPI delivery vs AVIC inhibition
Date:   Thu,  9 Dec 2021 13:54:37 +0200
Message-Id: <20211209115440.394441-4-mlevitsk@redhat.com>
In-Reply-To: <20211209115440.394441-1-mlevitsk@redhat.com>
References: <20211209115440.394441-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

If svm_deliver_avic_intr is called just after the target vcpu's AVIC got
inhibited, it might read a stale value of vcpu->arch.apicv_active
which can lead to the target vCPU not noticing the interrupt.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/svm/avic.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 859ad2dc50f1..8c1b934bfa9b 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -691,6 +691,15 @@ int svm_deliver_avic_intr(struct kvm_vcpu *vcpu, int vec)
 	 * automatically process AVIC interrupts at VMRUN.
 	 */
 	if (vcpu->mode == IN_GUEST_MODE) {
+
+		/*
+		 * At this point we had read the vcpu->arch.apicv_active == true
+		 * and the vcpu->mode == IN_GUEST_MODE.
+		 * Since we have a memory barrier after setting IN_GUEST_MODE,
+		 * it ensures that AVIC inhibition is complete and thus
+		 * the target is really running with AVIC enabled.
+		 */
+
 		int cpu = READ_ONCE(vcpu->cpu);
 
 		/*
@@ -706,10 +715,11 @@ int svm_deliver_avic_intr(struct kvm_vcpu *vcpu, int vec)
 		put_cpu();
 	} else {
 		/*
-		 * Wake the vCPU if it was blocking.  KVM will then detect the
-		 * pending IRQ when checking if the vCPU has a wake event.
+		 * Kick the target vCPU otherwise, to make sure
+		 * it processes the interrupt even if its AVIC is inhibited.
 		 */
-		kvm_vcpu_wake_up(vcpu);
+		kvm_make_request(KVM_REQ_EVENT, vcpu);
+		kvm_vcpu_kick(vcpu);
 	}
 
 	return 0;
-- 
2.26.3

