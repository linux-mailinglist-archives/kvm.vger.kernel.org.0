Return-Path: <kvm+bounces-7921-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A91248484E2
	for <lists+kvm@lfdr.de>; Sat,  3 Feb 2024 10:09:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DC72D1C29A1D
	for <lists+kvm@lfdr.de>; Sat,  3 Feb 2024 09:09:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DCF996E2B9;
	Sat,  3 Feb 2024 09:02:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CkZuKTJ1"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0E9369D13;
	Sat,  3 Feb 2024 09:02:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706950931; cv=none; b=Oa8fSH4IG/oZqErhRbiU078Qx+dkhOT+Mo1qRS/ZwwR3T4OYtYYZ3TYDbIJm3Ka7ucGsZmxaNsI2vZys744zeYc1JpaRwkf+AEID6iDhuq/VnnwcPqGrkT9GbN1dz+Ih/sX6oie8ozW3BGo6sfa4JZvM0sOTUFpXbWoH8TlO748=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706950931; c=relaxed/simple;
	bh=McvWIfrMDVQQK98OonhC4shsYqFjFCcrohaIF+ih4cY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=mUB5f/K/wtDBQ/W9tZ1mVaI8JVBiVhoQSxv9PXwDs6K0IsuzDS5fy8s7umVFo1CURDYuy1r9voI8P7bS87d8ept4wJJlB9UGVmJgS62l3DOturN8UWucLej8RB3hnau4v61uGnAfHB3oWM28pRK61LUJRfcF5RSMPxGDClCt7eI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=CkZuKTJ1; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706950930; x=1738486930;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=McvWIfrMDVQQK98OonhC4shsYqFjFCcrohaIF+ih4cY=;
  b=CkZuKTJ1SXWDRkQOtDVAYmKcvQUPUsrmemyaHFXpRknte9OGcIP/e9Qr
   kycoguiF6c7fcsgC39hZjBF8zuYmvklm8nxuTztkLhgx7lNEnAqyDYhUA
   3L+F3tkDbmZv9KwTvdJVJtCCftjAwIr86E3weiEd5nPDoVct7EUh5rDia
   oxFB1INPCOsk14R0bYmcrpjJ4pLQFHeVR8RrgWB5Y7DDKfjpWkAjVc3JG
   8vGndeEv5N7D/FkELrHXf+mgl/NMOpmksCFeq18JPxlPs+i8lkljKLBqZ
   6qw4vFpxBsm4mjQy7JsaLpU8k2rtVZuAcprQnpqkI5FU0REWjt1PxViXZ
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10971"; a="4132259"
X-IronPort-AV: E=Sophos;i="6.05,240,1701158400"; 
   d="scan'208";a="4132259"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2024 01:02:09 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,240,1701158400"; 
   d="scan'208";a="291606"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.36])
  by fmviesa009.fm.intel.com with ESMTP; 03 Feb 2024 01:02:03 -0800
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
Subject: [RFC 25/26] KVM: x86: Expose HRESET feature's CPUID to Guest
Date: Sat,  3 Feb 2024 17:12:13 +0800
Message-Id: <20240203091214.411862-26-zhao1.liu@linux.intel.com>
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

From: Zhuocheng Ding <zhuocheng.ding@intel.com>

The HRESET feature needs to have not only the feature bit of 0x07.0x01.
eax[bit 22] in the CPUID, but also the associated 0x20 leaf, so, pass-
through the Host's 0x20 leaf to Guest.

Since currently, HRESET is only used to clear ITD's classification
history, only expose HRESET related CPUID when Guest has the ITD
capability.

Tested-by: Yanting Jiang <yanting.jiang@intel.com>
Signed-off-by: Zhuocheng Ding <zhuocheng.ding@intel.com>
Co-developed-by: Zhao Liu <zhao1.liu@intel.com>
Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
 arch/x86/kvm/cpuid.c | 26 +++++++++++++++++++++++++-
 1 file changed, 25 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 9e78398f29dc..726b723ee34b 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -197,6 +197,16 @@ static int kvm_check_hfi_cpuid(struct kvm_vcpu *vcpu,
 	if (data_size > hfi_features.nr_table_pages << PAGE_SHIFT)
 		return -EINVAL;
 
+	/*
+	 * Check HRESET leaf since Guest's control of MSR_IA32_HW_HRESET_ENABLE
+	 * needs to take effect on hardware.
+	 */
+	best = cpuid_entry2_find(entries, nent, 0x20, 0);
+
+	/* Cannot set the Guest bit that is unsopported by Host. */
+	if (best && best->ebx & ~cpuid_ebx(0x20))
+		return -EINVAL;
+
 	return 0;
 }
 
@@ -784,6 +794,10 @@ void kvm_set_cpu_caps(void)
 		F(AMX_FP16) | F(AVX_IFMA) | F(LAM)
 	);
 
+	/* Currently HRESET is used to reset the ITD related history. */
+	if (kvm_cpu_cap_has(X86_FEATURE_ITD))
+		kvm_cpu_cap_set(X86_FEATURE_HRESET);
+
 	kvm_cpu_cap_init_kvm_defined(CPUID_7_1_EDX,
 		F(AVX_VNNI_INT8) | F(AVX_NE_CONVERT) | F(PREFETCHITI) |
 		F(AMX_COMPLEX)
@@ -1030,7 +1044,7 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
 	switch (function) {
 	case 0:
 		/* Limited to the highest leaf implemented in KVM. */
-		entry->eax = min(entry->eax, 0x1fU);
+		entry->eax = min(entry->eax, 0x20U);
 		break;
 	case 1:
 		cpuid_entry_override(entry, CPUID_1_EDX);
@@ -1300,6 +1314,16 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
 			break;
 		}
 		break;
+	/* Intel HRESET */
+	case 0x20:
+		if (!kvm_cpu_cap_has(X86_FEATURE_HRESET)) {
+			entry->eax = 0;
+			entry->ebx = 0;
+			entry->ecx = 0;
+			entry->edx = 0;
+			break;
+		}
+		break;
 	case KVM_CPUID_SIGNATURE: {
 		const u32 *sigptr = (const u32 *)KVM_SIGNATURE;
 		entry->eax = KVM_CPUID_FEATURES;
-- 
2.34.1


