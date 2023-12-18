Return-Path: <kvm+bounces-4725-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0535F817259
	for <lists+kvm@lfdr.de>; Mon, 18 Dec 2023 15:08:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AEA9B1F24463
	for <lists+kvm@lfdr.de>; Mon, 18 Dec 2023 14:08:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1F75449895;
	Mon, 18 Dec 2023 14:05:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WrewiUUf"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEAED42386
	for <kvm@vger.kernel.org>; Mon, 18 Dec 2023 14:05:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1702908353; x=1734444353;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Ccm3LoWl9JBPlFQ2Ojl1RY6OO+r61fopH529GyTWfIA=;
  b=WrewiUUfWJcjUZPk8uQakXFgpttroIVWSLhLrjfdGJ1IX/E7pa56nnrO
   8x4Gl51bZmfXaw0W/GM1gLvojn7usLF0ePKGT7sC8rF4ezj0bbBkHdaiy
   IUe+JD2OgViKgeImgC+HVudxC1rp4vIKmFo8arel8puiev8ZCWjAeJO8p
   bD7oSAzVoObh6Ye9fOdasRTRE+Yazv3rk3oh/lXSCArdQqkNcSK+HwYjz
   +/PXWnl5wDko+HbLGbcGVeVVSWkUdxEH3piAgrXrbtuWNs5dh8DXPOxXp
   rP08149XF8MOBgdBabHZfbwVQIlCcLwD2I51OChn0FBZwHaB97+UvFMY/
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10927"; a="2346360"
X-IronPort-AV: E=Sophos;i="6.04,285,1695711600"; 
   d="scan'208";a="2346360"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Dec 2023 06:05:51 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10927"; a="1106957768"
X-IronPort-AV: E=Sophos;i="6.04,285,1695711600"; 
   d="scan'208";a="1106957768"
Received: from st-server.bj.intel.com ([10.240.193.102])
  by fmsmga005.fm.intel.com with ESMTP; 18 Dec 2023 06:05:47 -0800
From: Tao Su <tao1.su@linux.intel.com>
To: kvm@vger.kernel.org
Cc: seanjc@google.com,
	pbonzini@redhat.com,
	eddie.dong@intel.com,
	chao.gao@intel.com,
	xiaoyao.li@intel.com,
	yuan.yao@linux.intel.com,
	yi1.lai@intel.com,
	xudong.hao@intel.com,
	chao.p.peng@intel.com,
	tao1.su@linux.intel.com
Subject: [PATCH 1/2] x86: KVM: Limit guest physical bits when 5-level EPT is unsupported
Date: Mon, 18 Dec 2023 22:05:42 +0800
Message-Id: <20231218140543.870234-2-tao1.su@linux.intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231218140543.870234-1-tao1.su@linux.intel.com>
References: <20231218140543.870234-1-tao1.su@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

When host doesn't support 5-level EPT, bits 51:48 of the guest physical
address must all be zero, otherwise an EPT violation always occurs and
current handler can't resolve this if the gpa is in RAM region. Hence,
instruction will keep being executed repeatedly, which causes infinite
EPT violation.

Six KVM selftests are timeout due to this issue:
    kvm:access_tracking_perf_test
    kvm:demand_paging_test
    kvm:dirty_log_test
    kvm:dirty_log_perf_test
    kvm:kvm_page_table_test
    kvm:memslot_modification_stress_test

The above selftests add a RAM region close to max_gfn, if host has 52
physical bits but doesn't support 5-level EPT, these will trigger infinite
EPT violation when access the RAM region.

Since current Intel CPUID doesn't report max guest physical bits like AMD,
introduce kvm_mmu_tdp_maxphyaddr() to limit guest physical bits when tdp is
enabled and report the max guest physical bits which is smaller than host.

When guest physical bits is smaller than host, some GPA are illegal from
guest's perspective, but are still legal from hardware's perspective,
which should be trapped to inject #PF. Current KVM already has a parameter
allow_smaller_maxphyaddr to support the case when guest.MAXPHYADDR <
host.MAXPHYADDR, which is disabled by default when EPT is enabled, user
can enable it when loading kvm-intel module. When allow_smaller_maxphyaddr
is enabled and guest accesses an illegal address from guest's perspective,
KVM will utilize EPT violation and emulate the instruction to inject #PF
and determine #PF error code.

Reported-by: Yi Lai <yi1.lai@intel.com>
Signed-off-by: Tao Su <tao1.su@linux.intel.com>
Tested-by: Yi Lai <yi1.lai@intel.com>
Tested-by: Xudong Hao <xudong.hao@intel.com>
---
 arch/x86/kvm/cpuid.c   | 5 +++--
 arch/x86/kvm/mmu.h     | 1 +
 arch/x86/kvm/mmu/mmu.c | 7 +++++++
 3 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index dda6fc4cfae8..91933ca739ad 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -1212,12 +1212,13 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
 		 *
 		 * If TDP is enabled but an explicit guest MAXPHYADDR is not
 		 * provided, use the raw bare metal MAXPHYADDR as reductions to
-		 * the HPAs do not affect GPAs.
+		 * the HPAs do not affect GPAs, but ensure guest MAXPHYADDR
+		 * doesn't exceed the bits that TDP can translate.
 		 */
 		if (!tdp_enabled)
 			g_phys_as = boot_cpu_data.x86_phys_bits;
 		else if (!g_phys_as)
-			g_phys_as = phys_as;
+			g_phys_as = min(phys_as, kvm_mmu_tdp_maxphyaddr());
 
 		entry->eax = g_phys_as | (virt_as << 8);
 		entry->ecx &= ~(GENMASK(31, 16) | GENMASK(11, 8));
diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index bb8c86eefac0..1c7d649fcf6b 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -115,6 +115,7 @@ int kvm_handle_page_fault(struct kvm_vcpu *vcpu, u64 error_code,
 				u64 fault_address, char *insn, int insn_len);
 void __kvm_mmu_refresh_passthrough_bits(struct kvm_vcpu *vcpu,
 					struct kvm_mmu *mmu);
+unsigned int kvm_mmu_tdp_maxphyaddr(void);
 
 int kvm_mmu_load(struct kvm_vcpu *vcpu);
 void kvm_mmu_unload(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index c57e181bba21..72634d6b61b2 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5177,6 +5177,13 @@ void __kvm_mmu_refresh_passthrough_bits(struct kvm_vcpu *vcpu,
 	reset_guest_paging_metadata(vcpu, mmu);
 }
 
+/* guest-physical-address bits limited by TDP */
+unsigned int kvm_mmu_tdp_maxphyaddr(void)
+{
+	return max_tdp_level == 5 ? 57 : 48;
+}
+EXPORT_SYMBOL_GPL(kvm_mmu_tdp_maxphyaddr);
+
 static inline int kvm_mmu_get_tdp_level(struct kvm_vcpu *vcpu)
 {
 	/* tdp_root_level is architecture forced level, use it if nonzero */
-- 
2.34.1


