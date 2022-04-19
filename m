Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4605A506994
	for <lists+kvm@lfdr.de>; Tue, 19 Apr 2022 13:17:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350968AbiDSLUO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Apr 2022 07:20:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350952AbiDSLUK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Apr 2022 07:20:10 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6986915813;
        Tue, 19 Apr 2022 04:17:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650367048; x=1681903048;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=qXUC0JW6X2U4JInupot3/lviCS3TrbWUtQI18BZne9k=;
  b=eZgSSppmO3JL3B+aw1vf9rI8M8KwzKqrjSftgUkYk4CSR8c0PUXTIzuo
   e/1gL5Agm9a35+KEjvhbwcKr6FiYVSX1gmtNHpgy+I6xUMKw0uxc93lOv
   qihKX2vox+IV2/3DzVM2QIgWJuEE1NAWZRjpSXh0CZ2+Q0zhmGa+jQYWD
   KwveiJKMffKNv3PLhWPptZGMpWAc+zsVZLBliaDTp84eoqiG5bx2L19y+
   3ygfC9kWqsXhpkQZQuB982hQFYBQqGkI9uwBJ8tRzu5zIjWxBu3mLsEFV
   iEeYYpScAqsvbV1oVmWjYYS/LdfZr/w6n4YUwv8IX4ipkQu1A357uV9p0
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10321"; a="350189765"
X-IronPort-AV: E=Sophos;i="5.90,272,1643702400"; 
   d="scan'208";a="350189765"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Apr 2022 04:17:20 -0700
X-IronPort-AV: E=Sophos;i="5.90,272,1643702400"; 
   d="scan'208";a="554683759"
Received: from csambran-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.254.58.20])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Apr 2022 04:17:18 -0700
From:   Kai Huang <kai.huang@intel.com>
To:     kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, pbonzini@redhat.com,
        seanjc@google.com, vkuznets@redhat.com, jmattson@google.com,
        joro@8bytes.org, wanpengli@tencent.com
Subject: [PATCH 3/3] KVM: VMX: Include MKTME KeyID bits to shadow_zero_check
Date:   Tue, 19 Apr 2022 23:17:04 +1200
Message-Id: <27bc10e97a3c0b58a4105ff9107448c190328239.1650363789.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <cover.1650363789.git.kai.huang@intel.com>
References: <cover.1650363789.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Intel MKTME KeyID bits (including Intel TDX private KeyID bits) should
never be set to SPTE.  Set shadow_me_value to 0 and shadow_me_mask to
include all MKTME KeyID bits to include them to shadow_zero_check.

Signed-off-by: Kai Huang <kai.huang@intel.com>
---
 arch/x86/kvm/mmu.h      | 19 +++++++++++++++++++
 arch/x86/kvm/mmu/spte.c | 19 -------------------
 arch/x86/kvm/vmx/vmx.c  | 31 +++++++++++++++++++++++++++++++
 3 files changed, 50 insertions(+), 19 deletions(-)

diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index 60c669494c4c..ce953885362b 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -65,6 +65,25 @@ static __always_inline u64 rsvd_bits(int s, int e)
 	return ((2ULL << (e - s)) - 1) << s;
 }
 
+static inline u8 kvm_get_shadow_phys_bits(void)
+{
+	/*
+	 * boot_cpu_data.x86_phys_bits is reduced when MKTME or SME are detected
+	 * in CPU detection code, but the processor treats those reduced bits as
+	 * 'keyID' thus they are not reserved bits. Therefore KVM needs to look at
+	 * the physical address bits reported by CPUID.
+	 */
+	if (likely(boot_cpu_data.extended_cpuid_level >= 0x80000008))
+		return cpuid_eax(0x80000008) & 0xff;
+
+	/*
+	 * Quite weird to have VMX or SVM but not MAXPHYADDR; probably a VM with
+	 * custom CPUID.  Proceed with whatever the kernel found since these features
+	 * aren't virtualizable (SME/SEV also require CPUIDs higher than 0x80000008).
+	 */
+	return boot_cpu_data.x86_phys_bits;
+}
+
 void kvm_mmu_set_mmio_spte_mask(u64 mmio_value, u64 mmio_mask, u64 access_mask);
 void kvm_mmu_set_me_spte_mask(u64 me_value, u64 me_mask);
 void kvm_mmu_set_ept_masks(bool has_ad_bits, bool has_exec_only);
diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
index a6da94f441c4..c2b785f08cf7 100644
--- a/arch/x86/kvm/mmu/spte.c
+++ b/arch/x86/kvm/mmu/spte.c
@@ -283,25 +283,6 @@ u64 kvm_mmu_changed_pte_notifier_make_spte(u64 old_spte, kvm_pfn_t new_pfn)
 	return new_spte;
 }
 
-static u8 kvm_get_shadow_phys_bits(void)
-{
-	/*
-	 * boot_cpu_data.x86_phys_bits is reduced when MKTME or SME are detected
-	 * in CPU detection code, but the processor treats those reduced bits as
-	 * 'keyID' thus they are not reserved bits. Therefore KVM needs to look at
-	 * the physical address bits reported by CPUID.
-	 */
-	if (likely(boot_cpu_data.extended_cpuid_level >= 0x80000008))
-		return cpuid_eax(0x80000008) & 0xff;
-
-	/*
-	 * Quite weird to have VMX or SVM but not MAXPHYADDR; probably a VM with
-	 * custom CPUID.  Proceed with whatever the kernel found since these features
-	 * aren't virtualizable (SME/SEV also require CPUIDs higher than 0x80000008).
-	 */
-	return boot_cpu_data.x86_phys_bits;
-}
-
 u64 mark_spte_for_access_track(u64 spte)
 {
 	if (spte_ad_enabled(spte))
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index cf8581978bce..65494caf75f0 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7883,6 +7883,31 @@ static __init void vmx_setup_user_return_msrs(void)
 		kvm_add_user_return_msr(vmx_uret_msrs_list[i]);
 }
 
+static void __init vmx_setup_me_spte_mask(void)
+{
+	u64 me_mask = 0;
+
+	/*
+	 * kvm_get_shadow_phys_bits() returns shadow_phys_bits.  Use
+	 * the former to avoid exposing shadow_phys_bits.
+	 *
+	 * On pre-MKTME system, boot_cpu_data.x86_phys_bits equals to
+	 * shadow_phys_bits.  On MKTME and/or TDX capable systems,
+	 * boot_cpu_data.x86_phys_bits holds the actual physical address
+	 * w/o the KeyID bits, and shadow_phys_bits equals to MAXPHYADDR
+	 * reported by CPUID.  Those bits between are KeyID bits.
+	 */
+	if (boot_cpu_data.x86_phys_bits != kvm_get_shadow_phys_bits())
+		me_mask = rsvd_bits(boot_cpu_data.x86_phys_bits,
+			kvm_get_shadow_phys_bits() - 1);
+	/*
+	 * Unlike to SME, host kernel doesn't support setting up any
+	 * MKTME KeyID to any mapping for Intel platforms.  No memory
+	 * encryption bits should be included into the SPTE.
+	 */
+	kvm_mmu_set_me_spte_mask(0, me_mask);
+}
+
 static struct kvm_x86_init_ops vmx_init_ops __initdata;
 
 static __init int hardware_setup(void)
@@ -7985,6 +8010,12 @@ static __init int hardware_setup(void)
 		kvm_mmu_set_ept_masks(enable_ept_ad_bits,
 				      cpu_has_vmx_ept_execute_only());
 
+	/*
+	 * Setup shadow_me_value/shadow_me_mask to include MKTME KeyID
+	 * bits to shadow_zero_check.
+	 */
+	vmx_setup_me_spte_mask();
+
 	kvm_configure_mmu(enable_ept, 0, vmx_get_max_tdp_level(),
 			  ept_caps_to_lpage_level(vmx_capability.ept));
 
-- 
2.35.1

