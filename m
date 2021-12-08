Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 348BD46CA81
	for <lists+kvm@lfdr.de>; Wed,  8 Dec 2021 02:55:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243418AbhLHB6n (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Dec 2021 20:58:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243323AbhLHB6g (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Dec 2021 20:58:36 -0500
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49093C061756
        for <kvm@vger.kernel.org>; Tue,  7 Dec 2021 17:55:04 -0800 (PST)
Received: by mail-pj1-x104a.google.com with SMTP id p8-20020a17090a748800b001a6cceee8afso688836pjk.4
        for <kvm@vger.kernel.org>; Tue, 07 Dec 2021 17:55:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=ubKaUKBLNmscD+a3SeZQyfO/SnsUn3R2x3pqUaMRRWU=;
        b=q4lQsDkJTgHl+2yoht+vVP93CTkCaT7wE7IowKnCX3k4dPDPnMAs3X37zJQUbFaU3c
         1iCMHxZl55owo9ie7mhUk9qQ4Zj66LOwfh5wXj/X6YGoHRyUh3f1FK+NwsZTEoCb8V18
         Ov7OSrf1k5AqUoHUra7Wf/g8YNPefJgqWdUUxn9LcyjXh8DYd0GVr2qqfZmhw8Q9kYRR
         GHZOeaWcS3SgKjstJ6jA9kWWfjSMWNzYxuqhaivzcza5fFyKXi+MFSeD1pdyUP0G9ADD
         4aw7KNThSCq4y59OELcH/eh/2XBvXlf7ep28ZCvariMiVZ7oCMqO0am08ZI95LMdoCvb
         uGUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=ubKaUKBLNmscD+a3SeZQyfO/SnsUn3R2x3pqUaMRRWU=;
        b=M3BxHHvnY47FGjKT135MRIXvkqAfBmqyXgGD55KGZEjV8Mhn3OusjcUeCtGDV8aVD/
         RV2FnJOsyA7InBXaO+VV8w/7KkR4ow3SI0I0RItorAEZTHgM0y+0PoBVeY/TIfcNlJt2
         4V1QfGR/TufV5pR5j9co6tIb99dSChAt3ohyxRvTVQcXl+/OV30ZzA8vD/TuwMxvNy6o
         YBZNOykX8t/inHjcdTUf9nDifggPs77/lb6SvCsCqfDLVGKHpkT15MbEJKGp+bjmoXzw
         2Ju8R3fiSZNtQBt4InijCKbznGo6wAV1Hm4wfBFaT6Zr3zELGzo7RFXJTvelEP6DxMQH
         ecNg==
X-Gm-Message-State: AOAM530vlhJKZytSeFBbFRVX33zR8rIaltfKL+hxLIf5aNqWu/MnhgCA
        yvwRDN83A0W0x/XLhex9jR/gyPCiQjA=
X-Google-Smtp-Source: ABdhPJx04oxzGnbwJs3aAuGW/R98Z2oolg+A8xq1n3WCg/qpbISnK5Yk2KiQTm+tvTeNHqYR7nJq0yfT7fY=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:aa7:9004:0:b0:4a2:e58e:9442 with SMTP id
 m4-20020aa79004000000b004a2e58e9442mr2949977pfo.24.1638928503771; Tue, 07 Dec
 2021 17:55:03 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  8 Dec 2021 01:52:20 +0000
In-Reply-To: <20211208015236.1616697-1-seanjc@google.com>
Message-Id: <20211208015236.1616697-11-seanjc@google.com>
Mime-Version: 1.0
References: <20211208015236.1616697-1-seanjc@google.com>
X-Mailer: git-send-email 2.34.1.400.ga245620fadb-goog
Subject: [PATCH v3 10/26] KVM: SVM: Signal AVIC doorbell iff vCPU is in guest mode
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, Joerg Roedel <joro@8bytes.org>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        kvm@vger.kernel.org, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Signal the AVIC doorbell iff the vCPU is running in the guest.  If the vCPU
is not IN_GUEST_MODE, it's guaranteed to pick up any pending IRQs on the
next VMRUN, which unconditionally processes the vIRR.

Add comments to document the logic.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/avic.c | 22 ++++++++++++++++++++--
 1 file changed, 20 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index d7132a4551a2..e2e4e9f04458 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -672,9 +672,22 @@ int svm_deliver_avic_intr(struct kvm_vcpu *vcpu, int vec)
 		return -1;
 
 	kvm_lapic_set_irr(vec, vcpu->arch.apic);
+
+	/*
+	 * Pairs with the smp_mb_*() after setting vcpu->guest_mode in
+	 * vcpu_enter_guest() to ensure the write to the vIRR is ordered before
+	 * the read of guest_mode, which guarantees that either VMRUN will see
+	 * and process the new vIRR entry, or that the below code will signal
+	 * the doorbell if the vCPU is already running in the guest.
+	 */
 	smp_mb__after_atomic();
 
-	if (avic_vcpu_is_running(vcpu)) {
+	/*
+	 * Signal the doorbell to tell hardware to inject the IRQ if the vCPU
+	 * is in the guest.  If the vCPU is not in the guest, hardware will
+	 * automatically process AVIC interrupts at VMRUN.
+	 */
+	if (vcpu->mode == IN_GUEST_MODE) {
 		int cpu = READ_ONCE(vcpu->cpu);
 
 		/*
@@ -688,8 +701,13 @@ int svm_deliver_avic_intr(struct kvm_vcpu *vcpu, int vec)
 		if (cpu != get_cpu())
 			wrmsrl(SVM_AVIC_DOORBELL, kvm_cpu_get_apicid(cpu));
 		put_cpu();
-	} else
+	} else {
+		/*
+		 * Wake the vCPU if it was blocking.  KVM will then detect the
+		 * pending IRQ when checking if the vCPU has a wake event.
+		 */
 		kvm_vcpu_wake_up(vcpu);
+	}
 
 	return 0;
 }
-- 
2.34.1.400.ga245620fadb-goog

