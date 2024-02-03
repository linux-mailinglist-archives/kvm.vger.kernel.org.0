Return-Path: <kvm+bounces-7916-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1CAF48484D2
	for <lists+kvm@lfdr.de>; Sat,  3 Feb 2024 10:07:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 41D521C29294
	for <lists+kvm@lfdr.de>; Sat,  3 Feb 2024 09:07:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B9D7D6341A;
	Sat,  3 Feb 2024 09:01:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="U+uoOdHJ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 368BC633F1;
	Sat,  3 Feb 2024 09:01:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706950903; cv=none; b=Siu6zYVhcpfpXS95qlZfRs3ahBNUtb9qqAH60eKDbJ7nPPHPps9qS1qzqTAiaIM4tubbmGhZe7Cr8s1Z3r8EBdGrgdIrkzvfA1zrHg3wG8kFJBgMHAD17QtdjzDnUfrDOFCURDEOQEuY9ipSbsy5HjXykiUovOhvLowBh+rY/bk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706950903; c=relaxed/simple;
	bh=tPickwMWphnvoa4nUW5041d+Jv4leQezd407dqDzWtA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ezYkUzvjPGkDbsrBF/PMUP/VFujJoZGXQhuBNQ0eRGR/sFvcNbcZaG2L3++nmh4YKHUBVGqACKxBBXoJUj6QeZstPSqvrNix+1pN61shxVB2pcnj7ZPlEVZnav2+2zG4REwZAsWnEQcPsslgei8ZvYtIM6uJMJrpkXUfTkgEgeQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=U+uoOdHJ; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706950902; x=1738486902;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=tPickwMWphnvoa4nUW5041d+Jv4leQezd407dqDzWtA=;
  b=U+uoOdHJ2mz53GnZP++rPgr8RLw2uc2m55byKaoul3C07JKYnPJmrgjm
   JQmfZxAxct9Klalxx944Pi1b0kjxyFaBY/hR3m/dM0stw31bvkp7TJg4h
   nx1OJ3/C2WNiefm2Hi8WAzKrEB7+5fMHAW1vIV9KxuJ3EqL8EAZMdQePd
   DwJVmWGfl/ipdnWpImp9DqdLwF1gOphyJGBsb8gi2LoYpNR6ZJ9r+udt9
   /GxnUu+0wiiZW+wnqTSgfHih7WLm3OZARLvMEISOrfIx5OQkIwc5pHiMd
   ff7H5+FPWBalMVWW19LGR6hW+/0rprEZ8dI+ypE8MmDeDPenmcM/hud6L
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10971"; a="4132106"
X-IronPort-AV: E=Sophos;i="6.05,240,1701158400"; 
   d="scan'208";a="4132106"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2024 01:01:41 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,240,1701158400"; 
   d="scan'208";a="291526"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.36])
  by fmviesa009.fm.intel.com with ESMTP; 03 Feb 2024 01:01:34 -0800
From: Zhao Liu <zhao1.liu@linux.intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	"Rafael J . Wysocki" <rafael@kernel.org>,
	Daniel Lezcano <daniel.lezcano@linaro.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H . Peter Anvin" <hpa@zytor.com>,
	kvm@vger.kernel.org,
	linux-pm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	x86@kernel.org
Cc: Ricardo Neri <ricardo.neri-calderon@linux.intel.com>,
	Len Brown <len.brown@intel.com>,
	Zhang Rui <rui.zhang@intel.com>,
	Zhenyu Wang <zhenyu.z.wang@intel.com>,
	Zhuocheng Ding <zhuocheng.ding@intel.com>,
	Dapeng Mi <dapeng1.mi@intel.com>,
	Yanting Jiang <yanting.jiang@intel.com>,
	Yongwei Ma <yongwei.ma@intel.com>,
	Vineeth Pillai <vineeth@bitbyteword.org>,
	Suleiman Souhlal <suleiman@google.com>,
	Masami Hiramatsu <mhiramat@google.com>,
	David Dai <davidai@google.com>,
	Saravana Kannan <saravanak@google.com>,
	Zhao Liu <zhao1.liu@intel.com>
Subject: [RFC 20/26] KVM: x86: Expose HFI feature bit and HFI info in CPUID
Date: Sat,  3 Feb 2024 17:12:08 +0800
Message-Id: <20240203091214.411862-21-zhao1.liu@linux.intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240203091214.411862-1-zhao1.liu@linux.intel.com>
References: <20240203091214.411862-1-zhao1.liu@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Zhao Liu <zhao1.liu@intel.com>

The HFI feature contains the following relevant CPUID fields:

* 0x06.eax[bit 19]: HFI feature bit
* 0x06.ecx[bits 08-15]: Number of HFI/ITD supported classes
* 0x06.edx[bits 00-07]: Bitmap of supported HFI capabilities
* 0x06.edx[bits 08-11]: Enumerates the size of the HFI table in number
                        of 4 KB pages
* 0x06.edx[bits 16-31]: HFI table index of processor

Guest's HFI feature bit (0x06.eax[bit 19]) is based on Host's HFI
enabling.

For other HFI related CPUID fields, since they affect the memory
allocation and HFI data filling of the virtual HFI table in KVM, check
the hfi related CPUID fields after KVM_SET_CPUID/KVM_SET_CPUID2 to
ensure the valid HFI feature information and the valid memory size.

And about the HFI table index, since the current KVM creates the same
CPUID template for all vCPUs, we refer to the CPU topology handling and
leave the specific filling of the HFI table index to the user, if the
user does not specifically specify the HFI index, all vCPUs will share
the HFI entry with hfi index 0.

The shared HFI index is valid in spec [1], but considering that the data
of the virtual HFI table is all from the pCPU on which the vCPU is
running, the shared hfi index of vCPUs on different pCPUs might cause
frequent HFI updates, and the virtual HFI table cannot accurately reflect
the actual processor situation, which might have a negative impact on
the Guest performance. Therefore, it is better to assign different HFI
table indexes to different vCPUs.

[1]: SDM, vol. 2A, chap. CPUID--CPU Identification, CPUID.06H.EDX[Bits
     31-16], about HFI table index sharing, it said, "Note that on some
     parts the index may be same for multiple logical processors".

Tested-by: Yanting Jiang <yanting.jiang@intel.com>
Co-developed-by: Zhuocheng Ding <zhuocheng.ding@intel.com>
Signed-off-by: Zhuocheng Ding <zhuocheng.ding@intel.com>
Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
 arch/x86/kvm/cpuid.c   | 136 ++++++++++++++++++++++++++++++++++++-----
 arch/x86/kvm/vmx/vmx.c |   7 +++
 2 files changed, 128 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index eaac2c8d98b9..4da8f3319917 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -17,6 +17,7 @@
 #include <linux/uaccess.h>
 #include <linux/sched/stat.h>
 
+#include <asm/hfi.h>
 #include <asm/processor.h>
 #include <asm/user.h>
 #include <asm/fpu/xstate.h>
@@ -130,12 +131,77 @@ static inline struct kvm_cpuid_entry2 *cpuid_entry2_find(
 	return NULL;
 }
 
+static int kvm_check_hfi_cpuid(struct kvm_vcpu *vcpu,
+			       struct kvm_cpuid_entry2 *entries,
+			       int nent)
+{
+	struct hfi_features hfi_features;
+	struct kvm_cpuid_entry2 *best = NULL;
+	bool has_hfi;
+	int nr_classes, ret;
+	union cpuid6_ecx ecx;
+	union cpuid6_edx edx;
+	unsigned int data_size;
+
+	best = cpuid_entry2_find(entries, nent, 0x6, 0);
+	if (!best)
+		return 0;
+
+	has_hfi = cpuid_entry_has(best, X86_FEATURE_HFI);
+	if (!has_hfi)
+		return 0;
+
+	/*
+	 * Only the platform with 1 HFI instance (i.e., client platform)
+	 * can enable HFI in Guest. For more information, please refer to
+	 * the comment in kvm_set_cpu_caps().
+	 */
+	if (intel_hfi_max_instances() != 1)
+		return -EINVAL;
+
+	/*
+	 * Currently we haven't supported ITD. HFI is the default feature
+	 * with 1 class.
+	 */
+	nr_classes = 1;
+	ret = intel_hfi_build_virt_features(&hfi_features,
+					    nr_classes,
+					    vcpu->kvm->created_vcpus);
+	if (ret)
+		return ret;
+
+	ecx.full = best->ecx;
+	edx.full = best->edx;
+
+	if (ecx.split.nr_classes != hfi_features.nr_classes)
+		return -EINVAL;
+
+	if (hweight8(edx.split.capabilities.bits) != hfi_features.class_stride)
+		return -EINVAL;
+
+	if (edx.split.table_pages + 1 != hfi_features.nr_table_pages)
+		return -EINVAL;
+
+	/*
+	 * The total size of the row corresponding to index and all
+	 * previous data.
+	 */
+	data_size = hfi_features.hdr_size + (edx.split.index + 1) *
+		    hfi_features.cpu_stride;
+	/* Invalid index. */
+	if (data_size > hfi_features.nr_table_pages << PAGE_SHIFT)
+		return -EINVAL;
+
+	return 0;
+}
+
 static int kvm_check_cpuid(struct kvm_vcpu *vcpu,
 			   struct kvm_cpuid_entry2 *entries,
 			   int nent)
 {
 	struct kvm_cpuid_entry2 *best;
 	u64 xfeatures;
+	int ret;
 
 	/*
 	 * The existing code assumes virtual address is 48-bit or 57-bit in the
@@ -155,15 +221,18 @@ static int kvm_check_cpuid(struct kvm_vcpu *vcpu,
 	 * enabling in the FPU, e.g. to expand the guest XSAVE state size.
 	 */
 	best = cpuid_entry2_find(entries, nent, 0xd, 0);
-	if (!best)
-		return 0;
-
-	xfeatures = best->eax | ((u64)best->edx << 32);
-	xfeatures &= XFEATURE_MASK_USER_DYNAMIC;
-	if (!xfeatures)
-		return 0;
+	if (best) {
+		xfeatures = best->eax | ((u64)best->edx << 32);
+		xfeatures &= XFEATURE_MASK_USER_DYNAMIC;
+		if (xfeatures) {
+			ret = fpu_enable_guest_xfd_features(&vcpu->arch.guest_fpu,
+							    xfeatures);
+			if (ret)
+				return ret;
+		}
+	}
 
-	return fpu_enable_guest_xfd_features(&vcpu->arch.guest_fpu, xfeatures);
+	return kvm_check_hfi_cpuid(vcpu, entries, nent);
 }
 
 /* Check whether the supplied CPUID data is equal to what is already set for the vCPU. */
@@ -633,14 +702,27 @@ void kvm_set_cpu_caps(void)
 	);
 
 	/*
-	 * PTS is the dependency of ITD, currently we only use PTS for
-	 * enabling ITD in KVM. Since KVM does not support msr topology at
-	 * present, the emulation of PTS has restrictions on the topology of
-	 * Guest, so we only expose PTS when Host enables ITD.
+	 * PTS and HFI are the dependencies of ITD, currently we only use PTS/HFI
+	 * for enabling ITD in KVM. Since KVM does not support msr topology at
+	 * present, the emulation of PTS/HFI has restrictions on the topology of
+	 * Guest, so we only expose PTS/HFI when Host enables ITD.
+	 *
+	 * We also restrict HFI virtualization support to platforms with only 1 HFI
+	 * instance (i.e., this is the client platform, and ITD is currently a
+	 * client-specific feature), while server platforms with multiple instances
+	 * do not require HFI virtualization. This restriction avoids adding
+	 * additional complex logic to handle notification register updates when
+	 * vCPUs migrate between different HFI instances.
 	 */
-	if (cpu_feature_enabled(X86_FEATURE_ITD)) {
+	if (cpu_feature_enabled(X86_FEATURE_ITD) && intel_hfi_max_instances() == 1) {
 		if (boot_cpu_has(X86_FEATURE_PTS))
 			kvm_cpu_cap_set(X86_FEATURE_PTS);
+		/*
+		 * Set HFI based on hardware capability. Only when the Host has
+		 * the valid HFI instance, KVM can build the virtual HFI table.
+		 */
+		if (intel_hfi_enabled())
+			kvm_cpu_cap_set(X86_FEATURE_HFI);
 	}
 
 	kvm_cpu_cap_mask(CPUID_7_0_EBX,
@@ -986,8 +1068,32 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
 			entry->eax |= 0x4;
 
 		entry->ebx = 0;
-		entry->ecx = 0;
-		entry->edx = 0;
+
+		if (kvm_cpu_cap_has(X86_FEATURE_HFI)) {
+			union cpuid6_ecx ecx;
+			union cpuid6_edx edx;
+
+			ecx.full = 0;
+			edx.full = 0;
+			/* Number of supported HFI classes */
+			ecx.split.nr_classes = 1;
+			/* HFI supports performance and energy efficiency capabilities. */
+			edx.split.capabilities.split.performance = 1;
+			edx.split.capabilities.split.energy_efficiency = 1;
+			/* As default, keep the same HFI table size as host. */
+			edx.split.table_pages = ((union cpuid6_edx)entry->edx).split.table_pages;
+			/*
+			 * Default HFI index = 0. User should be careful that
+			 * the index differ for each CPUs.
+			 */
+			edx.split.index = 0;
+
+			entry->ecx = ecx.full;
+			entry->edx = edx.full;
+		} else {
+			entry->ecx = 0;
+			entry->edx = 0;
+		}
 		break;
 	/* function 7 has additional index. */
 	case 7:
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 9c28d4ea0b2d..636f2bd68546 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -8434,6 +8434,13 @@ static void vmx_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 		vmx->msr_ia32_feature_control_valid_bits &=
 			~FEAT_CTL_SGX_LC_ENABLED;
 
+	if (guest_cpuid_has(vcpu, X86_FEATURE_HFI) && intel_hfi_enabled()) {
+		struct kvm_cpuid_entry2 *best = kvm_find_cpuid_entry_index(vcpu, 0x6, 0);
+
+		if (best)
+			vmx->hfi_table_idx = ((union cpuid6_edx)best->edx).split.index;
+	}
+
 	/* Refresh #PF interception to account for MAXPHYADDR changes. */
 	vmx_update_exception_bitmap(vcpu);
 }
-- 
2.34.1


