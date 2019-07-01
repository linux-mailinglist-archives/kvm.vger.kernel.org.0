Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 028B612B4A
	for <lists+kvm@lfdr.de>; Fri,  3 May 2019 12:09:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727503AbfECKJY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 May 2019 06:09:24 -0400
Received: from mga06.intel.com ([134.134.136.31]:59997 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726514AbfECKJY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 May 2019 06:09:24 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 03 May 2019 03:09:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,425,1549958400"; 
   d="scan'208";a="139552033"
Received: from khuang2-desk.gar.corp.intel.com ([10.254.24.58])
  by orsmga008.jf.intel.com with ESMTP; 03 May 2019 03:09:20 -0700
From:   Kai Huang <kai.huang@linux.intel.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com, rkrcmar@redhat.com
Cc:     sean.j.christopherson@intel.com, junaids@google.com,
        thomas.lendacky@amd.com, brijesh.singh@amd.com,
        guangrong.xiao@gmail.com, tglx@linutronix.de, bp@alien8.de,
        hpa@zytor.com, kai.huang@intel.com,
        Kai Huang <kai.huang@linux.intel.com>
Subject: [PATCH 2/2] kvm: x86: Fix reserved bits related calculation errors caused by MKTME
Date:   Fri,  3 May 2019 22:08:53 +1200
Message-Id: <1fb800cb7a0a89748e2ae1ee55db36b0498b60f3.1556877940.git.kai.huang@linux.intel.com>
X-Mailer: git-send-email 2.13.6
In-Reply-To: <cover.1556877940.git.kai.huang@linux.intel.com>
References: <cover.1556877940.git.kai.huang@linux.intel.com>
In-Reply-To: <cover.1556877940.git.kai.huang@linux.intel.com>
References: <cover.1556877940.git.kai.huang@linux.intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Intel MKTME repurposes several high bits of physical address as 'keyID'
for memory encryption thus effectively reduces platform's maximum
physical address bits. Exactly how many bits are reduced is configured
by BIOS. To honor such HW behavior, the repurposed bits are reduced from
cpuinfo_x86->x86_phys_bits when MKTME is detected in CPU detection.
Similarly, AMD SME/SEV also reduces physical address bits for memory
encryption, and cpuinfo->x86_phys_bits is reduced too when SME/SEV is
detected, so for both MKTME and SME/SEV, boot_cpu_data.x86_phys_bits
doesn't hold physical address bits reported by CPUID anymore.

Currently KVM treats bits from boot_cpu_data.x86_phys_bits to 51 as
reserved bits, but it's not true anymore for MKTME, since MKTME treats
those reduced bits as 'keyID', but not reserved bits. Therefore
boot_cpu_data.x86_phys_bits cannot be used to calculate reserved bits
anymore, although we can still use it for AMD SME/SEV since SME/SEV
treats the reduced bits differently -- they are treated as reserved
bits, the same as other reserved bits in page table entity [1].

Fix by introducing a new 'shadow_phys_bits' variable in KVM x86 MMU code
to store the effective physical bits w/o reserved bits -- for MKTME,
it equals to physical address reported by CPUID, and for SME/SEV, it is
boot_cpu_data.x86_phys_bits.

Note that for the physical address bits reported to guest should remain
unchanged -- KVM should report physical address reported by CPUID to
guest, but not boot_cpu_data.x86_phys_bits. Because for Intel MKTME,
there's no harm if guest sets up 'keyID' bits in guest page table (since
MKTME only works at physical address level), and KVM doesn't even expose
MKTME to guest. Arguably, for AMD SME/SEV, guest is aware of SEV thus it
should adjust boot_cpu_data.x86_phys_bits when it detects SEV, therefore
KVM should still reports physcial address reported by CPUID to guest.

[1] Section 7.10.1 Determining Support for Secure Memory Encryption,
    AMD Architecture Programmer's Manual Volume 2: System Programming.

Reviewed-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Kai Huang <kai.huang@linux.intel.com>
---
 arch/x86/kvm/mmu.c | 34 ++++++++++++++++++++++++++++------
 1 file changed, 28 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index c0a3d120167b..b0899f175db9 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -262,6 +262,12 @@ static const u64 shadow_nonpresent_or_rsvd_mask_len = 5;
  */
 static u64 __read_mostly shadow_nonpresent_or_rsvd_lower_gfn_mask;
 
+/*
+ * The number of non-reserved physical address bits irrespective of features
+ * that repurpose legal bits, e.g. MKTME.
+ */
+static u8 __read_mostly shadow_phys_bits;
+
 
 static void mmu_spte_set(u64 *sptep, u64 spte);
 static union kvm_mmu_page_role
@@ -471,6 +477,21 @@ void kvm_mmu_set_mask_ptes(u64 user_mask, u64 accessed_mask,
 }
 EXPORT_SYMBOL_GPL(kvm_mmu_set_mask_ptes);
 
+static u8 kvm_get_shadow_phys_bits(void)
+{
+	/*
+	 * boot_cpu_data.x86_phys_bits is reduced when MKTME is detected
+	 * in CPU detection code, but MKTME treats those reduced bits as
+	 * 'keyID' thus they are not reserved bits. Therefore for MKTME
+	 * we should still return physical address bits reported by CPUID.
+	 */
+	if (!boot_cpu_has(X86_FEATURE_TME) ||
+	    WARN_ON_ONCE(boot_cpu_data.extended_cpuid_level < 0x80000008))
+		return boot_cpu_data.x86_phys_bits;
+
+	return cpuid_eax(0x80000008) & 0xff;
+}
+
 static void kvm_mmu_reset_all_pte_masks(void)
 {
 	u8 low_phys_bits;
@@ -484,6 +505,8 @@ static void kvm_mmu_reset_all_pte_masks(void)
 	shadow_present_mask = 0;
 	shadow_acc_track_mask = 0;
 
+	shadow_phys_bits = kvm_get_shadow_phys_bits();
+
 	/*
 	 * If the CPU has 46 or less physical address bits, then set an
 	 * appropriate mask to guard against L1TF attacks. Otherwise, it is
@@ -4489,7 +4512,7 @@ reset_shadow_zero_bits_mask(struct kvm_vcpu *vcpu, struct kvm_mmu *context)
 	 */
 	shadow_zero_check = &context->shadow_zero_check;
 	__reset_rsvds_bits_mask(vcpu, shadow_zero_check,
-				boot_cpu_data.x86_phys_bits,
+				shadow_phys_bits,
 				context->shadow_root_level, uses_nx,
 				guest_cpuid_has(vcpu, X86_FEATURE_GBPAGES),
 				is_pse(vcpu), true);
@@ -4526,13 +4549,13 @@ reset_tdp_shadow_zero_bits_mask(struct kvm_vcpu *vcpu,
 
 	if (boot_cpu_is_amd())
 		__reset_rsvds_bits_mask(vcpu, shadow_zero_check,
-					boot_cpu_data.x86_phys_bits,
+					shadow_phys_bits,
 					context->shadow_root_level, false,
 					boot_cpu_has(X86_FEATURE_GBPAGES),
 					true, true);
 	else
 		__reset_rsvds_bits_mask_ept(shadow_zero_check,
-					    boot_cpu_data.x86_phys_bits,
+					    shadow_phys_bits,
 					    false);
 
 	if (!shadow_me_mask)
@@ -4553,7 +4576,7 @@ reset_ept_shadow_zero_bits_mask(struct kvm_vcpu *vcpu,
 				struct kvm_mmu *context, bool execonly)
 {
 	__reset_rsvds_bits_mask_ept(&context->shadow_zero_check,
-				    boot_cpu_data.x86_phys_bits, execonly);
+				    shadow_phys_bits, execonly);
 }
 
 #define BYTE_MASK(access) \
@@ -5992,7 +6015,6 @@ static void mmu_destroy_caches(void)
 static void kvm_set_mmio_spte_mask(void)
 {
 	u64 mask;
-	int maxphyaddr = boot_cpu_data.x86_phys_bits;
 
 	/*
 	 * Set the reserved bits and the present bit of an paging-structure
@@ -6012,7 +6034,7 @@ static void kvm_set_mmio_spte_mask(void)
 	 * If reserved bit is not supported, clear the present bit to disable
 	 * mmio page fault.
 	 */
-	if (IS_ENABLED(CONFIG_X86_64) && maxphyaddr == 52)
+	if (IS_ENABLED(CONFIG_X86_64) && shadow_phys_bits == 52)
 		mask &= ~1ull;
 
 	kvm_mmu_set_mmio_spte_mask(mask, mask);
-- 
2.13.6

