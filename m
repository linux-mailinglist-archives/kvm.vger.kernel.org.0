Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51ADB32581D
	for <lists+kvm@lfdr.de>; Thu, 25 Feb 2021 21:56:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234781AbhBYUzQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Feb 2021 15:55:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234220AbhBYUwY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Feb 2021 15:52:24 -0500
Received: from mail-qv1-xf4a.google.com (mail-qv1-xf4a.google.com [IPv6:2607:f8b0:4864:20::f4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B774C0611BD
        for <kvm@vger.kernel.org>; Thu, 25 Feb 2021 12:48:42 -0800 (PST)
Received: by mail-qv1-xf4a.google.com with SMTP id u15so4274764qvo.13
        for <kvm@vger.kernel.org>; Thu, 25 Feb 2021 12:48:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=/7xTLuHtPMz8ccvejSO8UR7nmAyPLxW40HeF3dwYprM=;
        b=PvLXG6psi++BpRCK3IkTPXetFp0jysKlfLyaWeoTic9vanP3TXYHw6fieclyhZKyDX
         7VpymOPuRluvJA9Gi/U9p2hjyJsgE6eK9H1mF2gZ/pGLidE1yjCTSNfjBWZwFp1ZTsnt
         9XRTnF/rUlE2Ug4Y+oGAJsDIINuafW+YUIzppzjB3rJ8xhDqd1Cy3+dUQU9ysgOCA1zh
         5RY5jliebVJ8nfqkKc1/WzsmqCydgoTmpbdLYeuy8Wnqp3MvzgytQbZ1v9g4dU0Psgtp
         wxYrsT0KkH7z08F2C2tswBvyxY7G72iUkJraqpIeqolpMKIivCGRyqSuktQm27iAAePO
         uJqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=/7xTLuHtPMz8ccvejSO8UR7nmAyPLxW40HeF3dwYprM=;
        b=VcY6QODgymiMA/VAeSjT6XNJJgMoplWx2hM0RthD3m7QcywxOBxbXCJQM5mLY8ahu4
         i/92xds+2xVefmb2SuG7wex5F/hscAnPw1v4ymsj/5NRTHcm56feVxxUWqAopvnfFdKP
         CrbPMLe1/BzHb4g5yLbXvGNUUBFU4hDFZWkk7kua1Ooj2hOtYrXzxcC8PJvdbAXbaLIh
         IimIXZh5HnkURxtDuLMQfjMriNn3vJqvw3xkshBesC/rpIod3Am5zJyCEOCkceIS2zpg
         If+76FOe4os0U34O55qsp0J7PBaWrNzK2YNaPy71yi4QlwJuvRZkKu/syUJzvJnvEE00
         Ujtg==
X-Gm-Message-State: AOAM531iPY7R2lT/mLzAkUvud+zNNVzLMR5DW5QCwVwB8bFImQrywuK8
        Z/Jc6KgbmxdixRVjgLIqcti7cFoO3go=
X-Google-Smtp-Source: ABdhPJyXy6fkpXq9oB+zOCMM1oxTbSWmXHUo16dC71mvM//Fc0kPmwc4KpG+HwQTn14mFqBVaYqrt3oq7Zw=
Sender: "seanjc via sendgmr" <seanjc@seanjc798194.pdx.corp.google.com>
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:34c4:7c1d:f9ba:4576])
 (user=seanjc job=sendgmr) by 2002:ad4:53ac:: with SMTP id j12mr4752602qvv.3.1614286121398;
 Thu, 25 Feb 2021 12:48:41 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 25 Feb 2021 12:47:41 -0800
In-Reply-To: <20210225204749.1512652-1-seanjc@google.com>
Message-Id: <20210225204749.1512652-17-seanjc@google.com>
Mime-Version: 1.0
References: <20210225204749.1512652-1-seanjc@google.com>
X-Mailer: git-send-email 2.30.1.766.gb4fecdf3b7-goog
Subject: [PATCH 16/24] KVM: x86/mmu: Co-locate code for setting various SPTE masks
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Squish all the code for (re)setting the various SPTE masks into one
location.  With the split code, it's not at all clear that the masks are
set once during module initialization.  This will allow a future patch to
clean up initialization of the masks without shuffling code all over
tarnation.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c  | 25 -------------------------
 arch/x86/kvm/mmu/spte.c | 19 +++++++++++++++++++
 arch/x86/kvm/vmx/vmx.c  | 17 ++++++-----------
 3 files changed, 25 insertions(+), 36 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 99d9c85a1820..1fb500db46e0 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5710,25 +5710,6 @@ static void mmu_destroy_caches(void)
 	kmem_cache_destroy(mmu_page_header_cache);
 }
 
-static void kvm_set_mmio_spte_mask(void)
-{
-	u64 mask;
-
-	/*
-	 * Set a reserved PA bit in MMIO SPTEs to generate page faults with
-	 * PFEC.RSVD=1 on MMIO accesses.  64-bit PTEs (PAE, x86-64, and EPT
-	 * paging) support a maximum of 52 bits of PA, i.e. if the CPU supports
-	 * 52-bit physical addresses then there are no reserved PA bits in the
-	 * PTEs and so the reserved PA approach must be disabled.
-	 */
-	if (shadow_phys_bits < 52)
-		mask = BIT_ULL(51) | PT_PRESENT_MASK;
-	else
-		mask = 0;
-
-	kvm_mmu_set_mmio_spte_mask(mask, mask, ACC_WRITE_MASK | ACC_USER_MASK);
-}
-
 static bool get_nx_auto_mode(void)
 {
 	/* Return true when CPU has the bug, and mitigations are ON */
@@ -5794,12 +5775,6 @@ int kvm_mmu_module_init(void)
 
 	kvm_mmu_reset_all_pte_masks();
 
-	kvm_set_mmio_spte_mask();
-
-	kvm_mmu_set_mask_ptes(PT_USER_MASK, PT_ACCESSED_MASK,
-			PT_DIRTY_MASK, PT64_NX_MASK, 0,
-			PT_PRESENT_MASK, 0, sme_me_mask);
-
 	pte_list_desc_cache = kmem_cache_create("pte_list_desc",
 					    sizeof(struct pte_list_desc),
 					    0, SLAB_ACCOUNT, NULL);
diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
index cf0e20b34cd3..b15d6006dbee 100644
--- a/arch/x86/kvm/mmu/spte.c
+++ b/arch/x86/kvm/mmu/spte.c
@@ -310,6 +310,7 @@ EXPORT_SYMBOL_GPL(kvm_mmu_set_mask_ptes);
 void kvm_mmu_reset_all_pte_masks(void)
 {
 	u8 low_phys_bits;
+	u64 mask;
 
 	shadow_user_mask = 0;
 	shadow_accessed_mask = 0;
@@ -344,4 +345,22 @@ void kvm_mmu_reset_all_pte_masks(void)
 
 	shadow_nonpresent_or_rsvd_lower_gfn_mask =
 		GENMASK_ULL(low_phys_bits - 1, PAGE_SHIFT);
+
+	/*
+	 * Set a reserved PA bit in MMIO SPTEs to generate page faults with
+	 * PFEC.RSVD=1 on MMIO accesses.  64-bit PTEs (PAE, x86-64, and EPT
+	 * paging) support a maximum of 52 bits of PA, i.e. if the CPU supports
+	 * 52-bit physical addresses then there are no reserved PA bits in the
+	 * PTEs and so the reserved PA approach must be disabled.
+	 */
+	if (shadow_phys_bits < 52)
+		mask = BIT_ULL(51) | PT_PRESENT_MASK;
+	else
+		mask = 0;
+
+	kvm_mmu_set_mmio_spte_mask(mask, mask, ACC_WRITE_MASK | ACC_USER_MASK);
+
+	kvm_mmu_set_mask_ptes(PT_USER_MASK, PT_ACCESSED_MASK,
+			PT_DIRTY_MASK, PT64_NX_MASK, 0,
+			PT_PRESENT_MASK, 0, sme_me_mask);
 }
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 8a8423a97f13..730076b3832f 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4314,16 +4314,6 @@ static void vmx_compute_secondary_exec_control(struct vcpu_vmx *vmx)
 	vmx->secondary_exec_control = exec_control;
 }
 
-static void ept_set_mmio_spte_mask(void)
-{
-	/*
-	 * EPT Misconfigurations can be generated if the value of bits 2:0
-	 * of an EPT paging-structure entry is 110b (write/execute).
-	 */
-	kvm_mmu_set_mmio_spte_mask(VMX_EPT_MISCONFIG_WX_VALUE,
-				   VMX_EPT_RWX_MASK, 0);
-}
-
 #define VMX_XSS_EXIT_BITMAP 0
 
 /*
@@ -5462,7 +5452,12 @@ static void vmx_enable_tdp(void)
 		cpu_has_vmx_ept_execute_only() ? 0ull : VMX_EPT_READABLE_MASK,
 		VMX_EPT_RWX_MASK, 0ull);
 
-	ept_set_mmio_spte_mask();
+	/*
+	 * EPT Misconfigurations can be generated if the value of bits 2:0
+	 * of an EPT paging-structure entry is 110b (write/execute).
+	 */
+	kvm_mmu_set_mmio_spte_mask(VMX_EPT_MISCONFIG_WX_VALUE,
+				   VMX_EPT_RWX_MASK, 0);
 }
 
 /*
-- 
2.30.1.766.gb4fecdf3b7-goog

