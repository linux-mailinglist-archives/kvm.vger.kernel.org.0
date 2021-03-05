Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C04D832F2B0
	for <lists+kvm@lfdr.de>; Fri,  5 Mar 2021 19:35:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230476AbhCESfY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Mar 2021 13:35:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230194AbhCESbz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Mar 2021 13:31:55 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 098ECC061756
        for <kvm@vger.kernel.org>; Fri,  5 Mar 2021 10:31:55 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id v6so3376314ybk.9
        for <kvm@vger.kernel.org>; Fri, 05 Mar 2021 10:31:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=oPnB+15Iks7tPihY57VTLY3xzIc6/gS7fJ46t5oskwQ=;
        b=cXraSC8Gn8J0EJA/KmySSEC0IcGtyz9uOZmMQR0FryXSvIJvLVvuRrmZP1Q7ENv2vM
         zKHtE4wLxIAHMtUTTp3rPg+/rc7g0B5e56tIKi/oiDty5qodIEM6blAhaJ4KpMaTPVQb
         0fP/uA1TXyY7QJ+NhfGT4uuvITF5/qiU38BMjweRzIVbIkIP03KSRN0V+xW6/YW8ocpw
         2+2vFinOxxg8q79YXOfUlYUH6AA2KbZriu/KP8eyC7vWOXVOnWxPnGBRPBq8xqH7otvX
         XHn3rw/ddddY5X9ppDQSN1YbYffMrb+dzy4mv8Z3wytM+h6orKWP78DEAO+x589jXSyI
         4Iww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=oPnB+15Iks7tPihY57VTLY3xzIc6/gS7fJ46t5oskwQ=;
        b=KH+lcRt3zCFwHaQM5V6+Xb9doH6GnstiZ8z2Ibrwzs9seTMUJ8zPoUQdorq6rzdrik
         t9dqsHV/KKonT1HopQjcDEsZ+d0vqmgvuKoGUepE9W0BVYgmGSZBxtVE7gz4PJHGd1OA
         JRD7+fUdvbFJM4TSF7uY299yO6nrZm50BlUuKu8QMAM5d+xKB0B5MbTwWBNrzvSMhJcS
         7rc5wkLUBq35KKNu7gW7RzMKr3YKi+y+WfufZ5d6/WtVSLjM9FzmS7ex6oKni+cBZb9A
         /IxoXZpGG7kLmGdmCatNyLtQNUHLUlIVQJsTvXf76PcPyBYrOP2LXgeY1hugA+cji7Zo
         cqOQ==
X-Gm-Message-State: AOAM531Ls8hoaBc4Xw0/s5ln9iccS85A7a3xrzomqQrCY9hB4dCozQ5U
        KLLVepGsFRnW/EKxtVi97ZfO4my8RLs=
X-Google-Smtp-Source: ABdhPJxvzzCdnXSgD6gNL8R+EsmkLrp9RaC/yeM4CegXhGkzvzA71cjvMwng2d1RCujiYhEozU/+oiTk3ao=
Sender: "seanjc via sendgmr" <seanjc@seanjc798194.pdx.corp.google.com>
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:9857:be95:97a2:e91c])
 (user=seanjc job=sendgmr) by 2002:a25:c090:: with SMTP id c138mr15081978ybf.314.1614969114273;
 Fri, 05 Mar 2021 10:31:54 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri,  5 Mar 2021 10:31:23 -0800
In-Reply-To: <20210305183123.3978098-1-seanjc@google.com>
Message-Id: <20210305183123.3978098-12-seanjc@google.com>
Mime-Version: 1.0
References: <20210305183123.3978098-1-seanjc@google.com>
X-Mailer: git-send-email 2.30.1.766.gb4fecdf3b7-goog
Subject: [PATCH v4 11/11] KVM: VMX: Track root HPA instead of EPTP for
 paravirt Hyper-V TLB flush
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

Track the address of the top-level EPT struct, a.k.a. the root HPA,
instead of the EPTP itself for Hyper-V's paravirt TLB flush.  The
paravirt API takes only the address, not the full EPTP, and in theory
tracking the EPTP could lead to false negatives, e.g. if the HPA matched
but the attributes in the EPTP do not.  In practice, such a mismatch is
extremely unlikely, if not flat out impossible, given how KVM generates
the EPTP.

Opportunsitically rename the related fields to use the 'root'
nomenclature, and to prefix them with 'hv_' to connect them to Hyper-V's
paravirt TLB flushing.

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/vmx.c | 83 ++++++++++++++++++++----------------------
 arch/x86/kvm/vmx/vmx.h |  6 +--
 2 files changed, 42 insertions(+), 47 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 720dcfe2a57d..ef826594365f 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -481,18 +481,14 @@ static int kvm_fill_hv_flush_list_func(struct hv_guest_mapping_flush_list *flush
 			range->pages);
 }
 
-static inline int hv_remote_flush_eptp(u64 eptp, struct kvm_tlb_range *range)
+static inline int hv_remote_flush_root_ept(hpa_t root_ept,
+					   struct kvm_tlb_range *range)
 {
-	/*
-	 * FLUSH_GUEST_PHYSICAL_ADDRESS_SPACE hypercall needs address
-	 * of the base of EPT PML4 table, strip off EPT configuration
-	 * information.
-	 */
 	if (range)
-		return hyperv_flush_guest_mapping_range(eptp & PAGE_MASK,
+		return hyperv_flush_guest_mapping_range(root_ept,
 				kvm_fill_hv_flush_list_func, (void *)range);
 	else
-		return hyperv_flush_guest_mapping(eptp & PAGE_MASK);
+		return hyperv_flush_guest_mapping(root_ept);
 }
 
 static int hv_remote_flush_tlb_with_range(struct kvm *kvm,
@@ -500,56 +496,55 @@ static int hv_remote_flush_tlb_with_range(struct kvm *kvm,
 {
 	struct kvm_vmx *kvm_vmx = to_kvm_vmx(kvm);
 	struct kvm_vcpu *vcpu;
-	int ret = 0, i, nr_unique_valid_eptps;
-	u64 tmp_eptp;
+	int ret = 0, i, nr_unique_valid_roots;
+	hpa_t root;
 
-	spin_lock(&kvm_vmx->ept_pointer_lock);
+	spin_lock(&kvm_vmx->hv_root_ept_lock);
 
-	if (!VALID_PAGE(kvm_vmx->hv_tlb_eptp)) {
-		nr_unique_valid_eptps = 0;
+	if (!VALID_PAGE(kvm_vmx->hv_root_ept)) {
+		nr_unique_valid_roots = 0;
 
 		/*
-		 * Flush all valid EPTPs, and see if all vCPUs have converged
-		 * on a common EPTP, in which case future flushes can skip the
-		 * loop and flush the common EPTP.
+		 * Flush all valid roots, and see if all vCPUs have converged
+		 * on a common root, in which case future flushes can skip the
+		 * loop and flush the common root.
 		 */
 		kvm_for_each_vcpu(i, vcpu, kvm) {
-			tmp_eptp = to_vmx(vcpu)->ept_pointer;
-			if (!VALID_PAGE(tmp_eptp) ||
-			    tmp_eptp == kvm_vmx->hv_tlb_eptp)
+			root = to_vmx(vcpu)->hv_root_ept;
+			if (!VALID_PAGE(root) || root == kvm_vmx->hv_root_ept)
 				continue;
 
 			/*
-			 * Set the tracked EPTP to the first valid EPTP.  Keep
-			 * this EPTP for the entirety of the loop even if more
-			 * EPTPs are encountered as a low effort optimization
-			 * to avoid flushing the same (first) EPTP again.
+			 * Set the tracked root to the first valid root.  Keep
+			 * this root for the entirety of the loop even if more
+			 * roots are encountered as a low effort optimization
+			 * to avoid flushing the same (first) root again.
 			 */
-			if (++nr_unique_valid_eptps == 1)
-				kvm_vmx->hv_tlb_eptp = tmp_eptp;
+			if (++nr_unique_valid_roots == 1)
+				kvm_vmx->hv_root_ept = root;
 
 			if (!ret)
-				ret = hv_remote_flush_eptp(tmp_eptp, range);
+				ret = hv_remote_flush_root_ept(root, range);
 
 			/*
-			 * Stop processing EPTPs if a failure occurred and
-			 * there is already a detected EPTP mismatch.
+			 * Stop processing roots if a failure occurred and
+			 * multiple valid roots have already been detected.
 			 */
-			if (ret && nr_unique_valid_eptps > 1)
+			if (ret && nr_unique_valid_roots > 1)
 				break;
 		}
 
 		/*
-		 * The optimized flush of a single EPTP can't be used if there
-		 * are multiple valid EPTPs (obviously).
+		 * The optimized flush of a single root can't be used if there
+		 * are multiple valid roots (obviously).
 		 */
-		if (nr_unique_valid_eptps > 1)
-			kvm_vmx->hv_tlb_eptp = INVALID_PAGE;
+		if (nr_unique_valid_roots > 1)
+			kvm_vmx->hv_root_ept = INVALID_PAGE;
 	} else {
-		ret = hv_remote_flush_eptp(kvm_vmx->hv_tlb_eptp, range);
+		ret = hv_remote_flush_root_ept(kvm_vmx->hv_root_ept, range);
 	}
 
-	spin_unlock(&kvm_vmx->ept_pointer_lock);
+	spin_unlock(&kvm_vmx->hv_root_ept_lock);
 	return ret;
 }
 static int hv_remote_flush_tlb(struct kvm *kvm)
@@ -584,17 +579,17 @@ static int hv_enable_direct_tlbflush(struct kvm_vcpu *vcpu)
 
 #endif /* IS_ENABLED(CONFIG_HYPERV) */
 
-static void hv_load_mmu_eptp(struct kvm_vcpu *vcpu, u64 eptp)
+static void hv_track_root_ept(struct kvm_vcpu *vcpu, hpa_t root_ept)
 {
 #if IS_ENABLED(CONFIG_HYPERV)
 	struct kvm_vmx *kvm_vmx = to_kvm_vmx(vcpu->kvm);
 
 	if (kvm_x86_ops.tlb_remote_flush == hv_remote_flush_tlb) {
-		spin_lock(&kvm_vmx->ept_pointer_lock);
-		to_vmx(vcpu)->ept_pointer = eptp;
-		if (eptp != kvm_vmx->hv_tlb_eptp)
-			kvm_vmx->hv_tlb_eptp = INVALID_PAGE;
-		spin_unlock(&kvm_vmx->ept_pointer_lock);
+		spin_lock(&kvm_vmx->hv_root_ept_lock);
+		to_vmx(vcpu)->hv_root_ept = root_ept;
+		if (root_ept != kvm_vmx->hv_root_ept)
+			kvm_vmx->hv_root_ept = INVALID_PAGE;
+		spin_unlock(&kvm_vmx->hv_root_ept_lock);
 	}
 #endif
 }
@@ -3137,7 +3132,7 @@ static void vmx_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa,
 		eptp = construct_eptp(vcpu, root_hpa, root_level);
 		vmcs_write64(EPT_POINTER, eptp);
 
-		hv_load_mmu_eptp(vcpu, eptp);
+		hv_track_root_ept(vcpu, root_hpa);
 
 		if (!enable_unrestricted_guest && !is_paging(vcpu))
 			guest_cr3 = to_kvm_vmx(kvm)->ept_identity_map_addr;
@@ -6929,7 +6924,7 @@ static int vmx_create_vcpu(struct kvm_vcpu *vcpu)
 	vmx->pi_desc.sn = 1;
 
 #if IS_ENABLED(CONFIG_HYPERV)
-	vmx->ept_pointer = INVALID_PAGE;
+	vmx->hv_root_ept = INVALID_PAGE;
 #endif
 	return 0;
 
@@ -6948,7 +6943,7 @@ static int vmx_create_vcpu(struct kvm_vcpu *vcpu)
 static int vmx_vm_init(struct kvm *kvm)
 {
 #if IS_ENABLED(CONFIG_HYPERV)
-	spin_lock_init(&to_kvm_vmx(kvm)->ept_pointer_lock);
+	spin_lock_init(&to_kvm_vmx(kvm)->hv_root_ept_lock);
 #endif
 
 	if (!ple_gap)
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 6d97b5a64b62..0fb3236b0283 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -326,7 +326,7 @@ struct vcpu_vmx {
 	u64 msr_ia32_feature_control;
 	u64 msr_ia32_feature_control_valid_bits;
 #if IS_ENABLED(CONFIG_HYPERV)
-	u64 ept_pointer;
+	u64 hv_root_ept;
 #endif
 
 	struct pt_desc pt_desc;
@@ -348,8 +348,8 @@ struct kvm_vmx {
 	gpa_t ept_identity_map_addr;
 
 #if IS_ENABLED(CONFIG_HYPERV)
-	hpa_t hv_tlb_eptp;
-	spinlock_t ept_pointer_lock;
+	hpa_t hv_root_ept;
+	spinlock_t hv_root_ept_lock;
 #endif
 };
 
-- 
2.30.1.766.gb4fecdf3b7-goog

