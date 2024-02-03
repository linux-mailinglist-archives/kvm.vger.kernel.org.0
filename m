Return-Path: <kvm+bounces-7919-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 41DC48484DB
	for <lists+kvm@lfdr.de>; Sat,  3 Feb 2024 10:08:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BEFF21F2CEE4
	for <lists+kvm@lfdr.de>; Sat,  3 Feb 2024 09:08:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CC2F267C55;
	Sat,  3 Feb 2024 09:02:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VdseGHXE"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AA4A6775C;
	Sat,  3 Feb 2024 09:01:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706950919; cv=none; b=iZRycaHAchAEpswdDobEl4fyuNXW9+zAdVpXLUTWe2iAJR34Y3MA9BVOct9Gjsc65w+O8t8ibpetkY49GxTMGJyy5gpxEnloZuLbze/INW7e08KuHjhHlLrk0Jsf5KTn9t2MqK+CQUaL+RQ5ps+GLtKoo6MNOPR4QqJprFPSuL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706950919; c=relaxed/simple;
	bh=VCv51ZKM2GW64nR2mDsrfM6GGX/jccl5W1ec8CqBGLo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=S2kbMQ2Pg0UMjRQGIWZnoF4GC46BEIxmzZfRw7+yLKbglE1Rk4CigkDS+97btCWk3CtwG0VVr4RKa0Mb6U9PghIjhYJpTBN1jYdgFaMpu5hNVeTQW3uZGw35tlLx4NtqYbH+ncRo7eqoTnJI9jA563+pB+GG3Jte3Tdcl2CRwcs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=VdseGHXE; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706950919; x=1738486919;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=VCv51ZKM2GW64nR2mDsrfM6GGX/jccl5W1ec8CqBGLo=;
  b=VdseGHXEhR8GTHqm6waOSbYG2+7VoEhbB9O/wxaW1kEGyVt1b+3sgjc1
   TAr5g2JuGxAhRNF4T68573D6axKhLa2mIwPQqnfXNSXRhfyQNu5TJf2+n
   93q73yd5QQANXA0NDgDk6FifxLWyDHYSb7MI+jWD8D/Ppsh2oGgEARBl1
   wk57uC24NnmCdnXfSfLzAX+u6zRgx7uWuSBz7IObkrWQmt/Km5yXJJzRm
   nKwbVrnfy4Km7ebDJG1frSXMcv+N2jcjZRBpHFVKtg6Uj/iUiRbow5PbH
   QqqDteyW8ykwHwi7574//y7cnpZ0yyJ28zGd3XfhxP1PzW9P46Tc55AOT
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10971"; a="4132204"
X-IronPort-AV: E=Sophos;i="6.05,240,1701158400"; 
   d="scan'208";a="4132204"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2024 01:01:58 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,240,1701158400"; 
   d="scan'208";a="291576"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.36])
  by fmviesa009.fm.intel.com with ESMTP; 03 Feb 2024 01:01:52 -0800
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
Subject: [RFC 23/26] KVM: x86: Expose ITD feature bit and related info in CPUID
Date: Sat,  3 Feb 2024 17:12:11 +0800
Message-Id: <20240203091214.411862-24-zhao1.liu@linux.intel.com>
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

The Guest's Intel Thread Director (ITD) feature bit is not only
dependent on the Host ITD's enablement, but is also based on the Guest's
HFI feature bit.

When the Host supports both HFI and ITD, try to support HFI and ITD for
the Guest.

If Host doesn't support ITD, we won't allow Guest to enable HFI or ITD.

Tested-by: Yanting Jiang <yanting.jiang@intel.com>
Co-developed-by: Zhuocheng Ding <zhuocheng.ding@intel.com>
Signed-off-by: Zhuocheng Ding <zhuocheng.ding@intel.com>
Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
 arch/x86/kvm/cpuid.c | 55 +++++++++++++++++++++++++++++++-------------
 1 file changed, 39 insertions(+), 16 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 4da8f3319917..9e78398f29dc 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -137,7 +137,7 @@ static int kvm_check_hfi_cpuid(struct kvm_vcpu *vcpu,
 {
 	struct hfi_features hfi_features;
 	struct kvm_cpuid_entry2 *best = NULL;
-	bool has_hfi;
+	bool has_hfi, has_itd;
 	int nr_classes, ret;
 	union cpuid6_ecx ecx;
 	union cpuid6_edx edx;
@@ -148,9 +148,14 @@ static int kvm_check_hfi_cpuid(struct kvm_vcpu *vcpu,
 		return 0;
 
 	has_hfi = cpuid_entry_has(best, X86_FEATURE_HFI);
-	if (!has_hfi)
+	has_itd = cpuid_entry_has(best, X86_FEATURE_ITD);
+	if (!has_hfi && !has_itd)
 		return 0;
 
+	/* ITD must base on HFI. */
+	if (!has_hfi && has_itd)
+		return -EINVAL;
+
 	/*
 	 * Only the platform with 1 HFI instance (i.e., client platform)
 	 * can enable HFI in Guest. For more information, please refer to
@@ -159,11 +164,11 @@ static int kvm_check_hfi_cpuid(struct kvm_vcpu *vcpu,
 	if (intel_hfi_max_instances() != 1)
 		return -EINVAL;
 
-	/*
-	 * Currently we haven't supported ITD. HFI is the default feature
-	 * with 1 class.
-	 */
-	nr_classes = 1;
+	/* Guest's ITD must base on Host's ITD enablement. */
+	if (!cpu_feature_enabled(X86_FEATURE_ITD) && has_itd)
+		return -EINVAL;
+
+	nr_classes = has_itd ? 4 : 1;
 	ret = intel_hfi_build_virt_features(&hfi_features,
 					    nr_classes,
 					    vcpu->kvm->created_vcpus);
@@ -718,11 +723,13 @@ void kvm_set_cpu_caps(void)
 		if (boot_cpu_has(X86_FEATURE_PTS))
 			kvm_cpu_cap_set(X86_FEATURE_PTS);
 		/*
-		 * Set HFI based on hardware capability. Only when the Host has
+		 * Set HFI/ITD based on hardware capability. Only when the Host has
 		 * the valid HFI instance, KVM can build the virtual HFI table.
 		 */
-		if (intel_hfi_enabled())
+		if (intel_hfi_enabled()) {
 			kvm_cpu_cap_set(X86_FEATURE_HFI);
+			kvm_cpu_cap_set(X86_FEATURE_ITD);
+		}
 	}
 
 	kvm_cpu_cap_mask(CPUID_7_0_EBX,
@@ -1069,19 +1076,35 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
 
 		entry->ebx = 0;
 
-		if (kvm_cpu_cap_has(X86_FEATURE_HFI)) {
+		/*
+		 * When Host enables ITD, we will expose ITD and HFI,
+		 * otherwise, HFI/ITD will not be exposed to Guest.
+		 * ITD is an extension of HFI, so after KVM supports ITD
+		 * emulation, HFI-related info in 0x6 leaf should be consistent
+		 * with the Host, that is, use the Host's ITD info, except
+		 * for the HFI index.
+		 *
+		 * HFI table size is related to the HFI table indexes, but
+		 * this item will be checked in kvm_check_cpuid() after
+		 * KVM_SET_CPUID/KVM_SET_CPUID2.
+		 */
+		if (kvm_cpu_cap_has(X86_FEATURE_ITD)) {
 			union cpuid6_ecx ecx;
 			union cpuid6_edx edx;
+			union cpuid6_ecx *host_ecx = (union cpuid6_ecx *)&entry->ecx;
+			union cpuid6_edx *host_edx = (union cpuid6_edx *)&entry->edx;
 
 			ecx.full = 0;
 			edx.full = 0;
-			/* Number of supported HFI classes */
-			ecx.split.nr_classes = 1;
-			/* HFI supports performance and energy efficiency capabilities. */
-			edx.split.capabilities.split.performance = 1;
-			edx.split.capabilities.split.energy_efficiency = 1;
+			/* Number of supported HFI/ITD classes. */
+			ecx.split.nr_classes = host_ecx->split.nr_classes;
+			/* HFI/ITD supports performance and energy efficiency capabilities. */
+			edx.split.capabilities.split.performance =
+				host_edx->split.capabilities.split.performance;
+			edx.split.capabilities.split.energy_efficiency =
+				host_edx->split.capabilities.split.energy_efficiency;
 			/* As default, keep the same HFI table size as host. */
-			edx.split.table_pages = ((union cpuid6_edx)entry->edx).split.table_pages;
+			edx.split.table_pages = host_edx->split.table_pages;
 			/*
 			 * Default HFI index = 0. User should be careful that
 			 * the index differ for each CPUs.
-- 
2.34.1


