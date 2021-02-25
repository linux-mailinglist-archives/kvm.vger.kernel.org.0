Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3D1132581A
	for <lists+kvm@lfdr.de>; Thu, 25 Feb 2021 21:56:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232290AbhBYUyu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Feb 2021 15:54:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234112AbhBYUwM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Feb 2021 15:52:12 -0500
Received: from mail-qk1-x74a.google.com (mail-qk1-x74a.google.com [IPv6:2607:f8b0:4864:20::74a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAA55C061786
        for <kvm@vger.kernel.org>; Thu, 25 Feb 2021 12:48:44 -0800 (PST)
Received: by mail-qk1-x74a.google.com with SMTP id y64so4130755qkc.7
        for <kvm@vger.kernel.org>; Thu, 25 Feb 2021 12:48:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=OnI6w6icsmTuNVXFI6cQ8RuOMnt7x3dOFjkRcgEIyN4=;
        b=aeDxs/m+PaufMKC82eLzi6Rr37DzXsrwS8A86hV3eKFh/ITch19q0xJHEfXhdwtWI+
         zUeuVjrBJ2ufZYUHLmp9xxwpm8RRTLxxBZ8SMyGT9jhrYxWE1Ezx+6k+YNs+xoNflAeM
         6IL+mbsLGwO0IUN8N2sGXmD4cONrVWsYnJc8ItRus2EejcB+RFeceZ7PUu0aqKmcNK4y
         hAFgkRowoUKN40qboF5pe0X2PZ2Zs+e9CD7NjKPrVfAwDdLBhyWhKAhMY1WqbMpA6qWJ
         Qsuoo3tpzjPu/MT30LNVSzHc/jgPJk+cw47Q3vjh2aCaU52A/z1Yn30R0nGGjvxl1O0x
         AuzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=OnI6w6icsmTuNVXFI6cQ8RuOMnt7x3dOFjkRcgEIyN4=;
        b=j2Nc6h6KsF6C7PAI8DOjTv23Fj+5atlN1ZCsizhfT3YUxzVWVh2z5+ve3/64Hsl8qB
         v3H7I0NtPO+JhbS0Uc73IJEkHZZkBreGavbvMUPdIWSTToZoMKtGNb2Nz/r+oWto4bTg
         mKlGLzLplSu2g+e5mGXhM+Hdx9IFWXx6Si2B+8ciH/QChWTTb83LnLB+sK/5aLEiv/5n
         cZ842E7cUekKCXNHOxyXKJV828kUF2ge8glRx2sYbNuYquGEzixnAxfov3gSsh2H/o2f
         hjoqgUEM7i+BKqV0RFtv6rPtf4DWulswg/pXCT2CqfZ5QFhyzPlJ7wQhGpDdH/DU2StN
         wo7g==
X-Gm-Message-State: AOAM532hbMFINY6HHvY2Jiw3ftxVXGaOaVNg22wXqRlY1evAzyFoBTxq
        XuRH2bBbZk78Ehjla84fsljQBLlwdio=
X-Google-Smtp-Source: ABdhPJwrjLlGlIPjHktPX5MROQiVD8AZ5jez8jaHsq3LbJkwdzRz9Q2ba+0ECJFRupG6TM+PN0drsy1rOeg=
Sender: "seanjc via sendgmr" <seanjc@seanjc798194.pdx.corp.google.com>
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:34c4:7c1d:f9ba:4576])
 (user=seanjc job=sendgmr) by 2002:ad4:5ec9:: with SMTP id jm9mr4681101qvb.56.1614286123922;
 Thu, 25 Feb 2021 12:48:43 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 25 Feb 2021 12:47:42 -0800
In-Reply-To: <20210225204749.1512652-1-seanjc@google.com>
Message-Id: <20210225204749.1512652-18-seanjc@google.com>
Mime-Version: 1.0
References: <20210225204749.1512652-1-seanjc@google.com>
X-Mailer: git-send-email 2.30.1.766.gb4fecdf3b7-goog
Subject: [PATCH 17/24] KVM: x86/mmu: Move logic for setting SPTE masks for EPT
 into the MMU proper
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

Let the MMU deal with the SPTE masks to avoid splitting the logic and
knowledge across the MMU and VMX.

The SPTE masks that are used for EPT are very, very tightly coupled to
the MMU implementation.  The use of available bits, the existence of A/D
types, the fact that shadow_x_mask even exists, and so on and so forth
are all baked into the MMU implementation.  Cross referencing the params
to the masks is also a nightmare, as pretty much every param is a u64.

A future patch will make the location of the MMU_WRITABLE and
HOST_WRITABLE bits MMU specific, to free up bit 11 for a MMU_PRESENT bit.
Doing that change with the current kvm_mmu_set_mask_ptes() would be an
absolute mess.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_host.h |  3 --
 arch/x86/kvm/mmu.h              |  1 +
 arch/x86/kvm/mmu/spte.c         | 60 ++++++++++++++-------------------
 arch/x86/kvm/vmx/vmx.c          | 20 ++---------
 4 files changed, 29 insertions(+), 55 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index cc376327a168..629f74f2a00a 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1407,9 +1407,6 @@ void kvm_mmu_destroy(struct kvm_vcpu *vcpu);
 int kvm_mmu_create(struct kvm_vcpu *vcpu);
 void kvm_mmu_init_vm(struct kvm *kvm);
 void kvm_mmu_uninit_vm(struct kvm *kvm);
-void kvm_mmu_set_mask_ptes(u64 user_mask, u64 accessed_mask,
-		u64 dirty_mask, u64 nx_mask, u64 x_mask, u64 p_mask,
-		u64 acc_track_mask, u64 me_mask);
 
 void kvm_mmu_reset_context(struct kvm_vcpu *vcpu);
 void kvm_mmu_slot_remove_write_access(struct kvm *kvm,
diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index 00f4a541e04d..11cf7793cfee 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -60,6 +60,7 @@ static __always_inline u64 rsvd_bits(int s, int e)
 }
 
 void kvm_mmu_set_mmio_spte_mask(u64 mmio_value, u64 mmio_mask, u64 access_mask);
+void kvm_mmu_set_ept_masks(bool has_ad_bits, bool has_exec_only);
 
 void
 reset_shadow_zero_bits_mask(struct kvm_vcpu *vcpu, struct kvm_mmu *context);
diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
index b15d6006dbee..ac5ea6fda969 100644
--- a/arch/x86/kvm/mmu/spte.c
+++ b/arch/x86/kvm/mmu/spte.c
@@ -16,6 +16,7 @@
 #include "spte.h"
 
 #include <asm/e820/api.h>
+#include <asm/vmx.h>
 
 static bool __read_mostly enable_mmio_caching = true;
 module_param_named(mmio_caching, enable_mmio_caching, bool, 0444);
@@ -281,45 +282,31 @@ void kvm_mmu_set_mmio_spte_mask(u64 mmio_value, u64 mmio_mask, u64 access_mask)
 }
 EXPORT_SYMBOL_GPL(kvm_mmu_set_mmio_spte_mask);
 
-/*
- * Sets the shadow PTE masks used by the MMU.
- *
- * Assumptions:
- *  - Setting either @accessed_mask or @dirty_mask requires setting both
- *  - At least one of @accessed_mask or @acc_track_mask must be set
- */
-void kvm_mmu_set_mask_ptes(u64 user_mask, u64 accessed_mask,
-		u64 dirty_mask, u64 nx_mask, u64 x_mask, u64 p_mask,
-		u64 acc_track_mask, u64 me_mask)
+void kvm_mmu_set_ept_masks(bool has_ad_bits, bool has_exec_only)
 {
-	BUG_ON(!dirty_mask != !accessed_mask);
-	BUG_ON(!accessed_mask && !acc_track_mask);
-	BUG_ON(acc_track_mask & SPTE_TDP_AD_MASK);
+	shadow_user_mask	= VMX_EPT_READABLE_MASK;
+	shadow_accessed_mask	= has_ad_bits ? VMX_EPT_ACCESS_BIT : 0ull;
+	shadow_dirty_mask	= has_ad_bits ? VMX_EPT_DIRTY_BIT : 0ull;
+	shadow_nx_mask		= 0ull;
+	shadow_x_mask		= VMX_EPT_EXECUTABLE_MASK;
+	shadow_present_mask	= has_exec_only ? 0ull : VMX_EPT_READABLE_MASK;
+	shadow_acc_track_mask	= VMX_EPT_RWX_MASK;
+	shadow_me_mask		= 0ull;
 
-	shadow_user_mask = user_mask;
-	shadow_accessed_mask = accessed_mask;
-	shadow_dirty_mask = dirty_mask;
-	shadow_nx_mask = nx_mask;
-	shadow_x_mask = x_mask;
-	shadow_present_mask = p_mask;
-	shadow_acc_track_mask = acc_track_mask;
-	shadow_me_mask = me_mask;
+	/*
+	 * EPT Misconfigurations are generated if the value of bits 2:0
+	 * of an EPT paging-structure entry is 110b (write/execute).
+	 */
+	kvm_mmu_set_mmio_spte_mask(VMX_EPT_MISCONFIG_WX_VALUE,
+				   VMX_EPT_RWX_MASK, 0);
 }
-EXPORT_SYMBOL_GPL(kvm_mmu_set_mask_ptes);
+EXPORT_SYMBOL_GPL(kvm_mmu_set_ept_masks);
 
 void kvm_mmu_reset_all_pte_masks(void)
 {
 	u8 low_phys_bits;
 	u64 mask;
 
-	shadow_user_mask = 0;
-	shadow_accessed_mask = 0;
-	shadow_dirty_mask = 0;
-	shadow_nx_mask = 0;
-	shadow_x_mask = 0;
-	shadow_present_mask = 0;
-	shadow_acc_track_mask = 0;
-
 	shadow_phys_bits = kvm_get_shadow_phys_bits();
 
 	/*
@@ -346,6 +333,15 @@ void kvm_mmu_reset_all_pte_masks(void)
 	shadow_nonpresent_or_rsvd_lower_gfn_mask =
 		GENMASK_ULL(low_phys_bits - 1, PAGE_SHIFT);
 
+	shadow_user_mask	= PT_USER_MASK;
+	shadow_accessed_mask	= PT_ACCESSED_MASK;
+	shadow_dirty_mask	= PT_DIRTY_MASK;
+	shadow_nx_mask		= PT64_NX_MASK;
+	shadow_x_mask		= 0;
+	shadow_present_mask	= PT_PRESENT_MASK;
+	shadow_acc_track_mask	= 0;
+	shadow_me_mask		= sme_me_mask;
+
 	/*
 	 * Set a reserved PA bit in MMIO SPTEs to generate page faults with
 	 * PFEC.RSVD=1 on MMIO accesses.  64-bit PTEs (PAE, x86-64, and EPT
@@ -359,8 +355,4 @@ void kvm_mmu_reset_all_pte_masks(void)
 		mask = 0;
 
 	kvm_mmu_set_mmio_spte_mask(mask, mask, ACC_WRITE_MASK | ACC_USER_MASK);
-
-	kvm_mmu_set_mask_ptes(PT_USER_MASK, PT_ACCESSED_MASK,
-			PT_DIRTY_MASK, PT64_NX_MASK, 0,
-			PT_PRESENT_MASK, 0, sme_me_mask);
 }
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 730076b3832f..6d7e760fdfa0 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -5443,23 +5443,6 @@ static void shrink_ple_window(struct kvm_vcpu *vcpu)
 	}
 }
 
-static void vmx_enable_tdp(void)
-{
-	kvm_mmu_set_mask_ptes(VMX_EPT_READABLE_MASK,
-		enable_ept_ad_bits ? VMX_EPT_ACCESS_BIT : 0ull,
-		enable_ept_ad_bits ? VMX_EPT_DIRTY_BIT : 0ull,
-		0ull, VMX_EPT_EXECUTABLE_MASK,
-		cpu_has_vmx_ept_execute_only() ? 0ull : VMX_EPT_READABLE_MASK,
-		VMX_EPT_RWX_MASK, 0ull);
-
-	/*
-	 * EPT Misconfigurations can be generated if the value of bits 2:0
-	 * of an EPT paging-structure entry is 110b (write/execute).
-	 */
-	kvm_mmu_set_mmio_spte_mask(VMX_EPT_MISCONFIG_WX_VALUE,
-				   VMX_EPT_RWX_MASK, 0);
-}
-
 /*
  * Indicate a busy-waiting vcpu in spinlock. We do not enable the PAUSE
  * exiting, so only get here on cpu with PAUSE-Loop-Exiting.
@@ -7788,7 +7771,8 @@ static __init int hardware_setup(void)
 	set_bit(0, vmx_vpid_bitmap); /* 0 is reserved for host */
 
 	if (enable_ept)
-		vmx_enable_tdp();
+		kvm_mmu_set_ept_masks(enable_ept_ad_bits,
+				      cpu_has_vmx_ept_execute_only());
 
 	if (!enable_ept)
 		ept_lpage_level = 0;
-- 
2.30.1.766.gb4fecdf3b7-goog

