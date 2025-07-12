Return-Path: <kvm+bounces-52455-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 21952B054FA
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 10:33:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C0B947B94E7
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 08:30:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BD265276047;
	Tue, 15 Jul 2025 08:31:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nk/RrHBK"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63C83275851;
	Tue, 15 Jul 2025 08:31:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752568305; cv=none; b=g3iJ/RpX9D8F0OOyXZrkuh7x1p4sBXQ3q/ixgXcs0T/qG88rGRccVOLb1f50b24AI7J/iBvixkqH8kxmyrmasct2zGXph0aMibFNYSCKzAgj/gcpOknS5ZST4MytUNkn4TDL40b697Hdqoj67iwIX0qtDsM/jokvrdygXtUyE3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752568305; c=relaxed/simple;
	bh=f/GBaWhzt8SY797GdaCdkYWcJqOPaoevRGjaBPfPDJM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GCBQInjK3IgqB34jkqpv/ZBefwXBVRv0kk+8zlXhJ3cis28oBEbceq/RgUb8bm9K/3WKcTwxLS4XXXqUbdhW0yILFcb1zI836IYnKeCbQLaJvz2tDbul0gT4i0Uc9RU9vFUalIx1O+3iz62Mu4PXulXHA4KIHi1YgdLVzmlqZB0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nk/RrHBK; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752568304; x=1784104304;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=f/GBaWhzt8SY797GdaCdkYWcJqOPaoevRGjaBPfPDJM=;
  b=nk/RrHBKRc2Iwlv5LFjb3fFSsT1IyijXxZvj2btJoLjbZxt3vBkG8e+8
   cGGAbhyWwWhuObwQl9BF97zIOlBtwAe9Bl7z+24wHt31hImAU7sD1kut3
   2HMiH9i+cPp7bPRFUPzK/XxN0tpTGz52C32SJ5M/fcQ1DxU2Bs+kso6Bw
   COMl49p0bDCIksSEj9Jqsm15iNJTZWwonR03+VJ08Wecd1oClR1IWxQjY
   dRqwtDI0VC499pT8LUeAtR+2azZEtY5ZjeWtHjSl/bynrRlKHPmNQ1Em8
   VLaStuNHsdzgmCPcbjWPaGnDvYD+Ju2/hU8UUsMYih68J2b0APa18yOuT
   w==;
X-CSE-ConnectionGUID: CEWPwH6XStCBlDvwHU4ZAQ==
X-CSE-MsgGUID: jivmdw4MRF2pcrpX8xhZ3w==
X-IronPort-AV: E=McAfee;i="6800,10657,11491"; a="54632085"
X-IronPort-AV: E=Sophos;i="6.16,313,1744095600"; 
   d="scan'208";a="54632085"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2025 01:31:43 -0700
X-CSE-ConnectionGUID: 5irYBWQDSDqPdLui1GV4FA==
X-CSE-MsgGUID: icVPE1kWQmCcCWHaa+yfBg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,313,1744095600"; 
   d="scan'208";a="156572568"
Received: from emr.sh.intel.com ([10.112.229.56])
  by orviesa010.jf.intel.com with ESMTP; 15 Jul 2025 01:31:40 -0700
From: Dapeng Mi <dapeng1.mi@linux.intel.com>
To: Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Jim Mattson <jmattson@google.com>,
	Mingwei Zhang <mizhang@google.com>,
	Zide Chen <zide.chen@intel.com>,
	Das Sandipan <Sandipan.Das@amd.com>,
	Shukla Manali <Manali.Shukla@amd.com>,
	Yi Lai <yi1.lai@intel.com>,
	Dapeng Mi <dapeng1.mi@intel.com>,
	dongsheng <dongsheng.x.zhang@intel.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>
Subject: [kvm-unit-tests patch 1/5] x86/pmu: Add helper to detect Intel overcount issues
Date: Sat, 12 Jul 2025 17:49:11 +0000
Message-ID: <20250712174915.196103-2-dapeng1.mi@linux.intel.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250712174915.196103-1-dapeng1.mi@linux.intel.com>
References: <20250712174915.196103-1-dapeng1.mi@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: dongsheng <dongsheng.x.zhang@intel.com>

For Intel Atom CPUs, the PMU events "Instruction Retired" or
"Branch Instruction Retired" may be overcounted for some certain
instructions, like FAR CALL/JMP, RETF, IRET, VMENTRY/VMEXIT/VMPTRLD
and complex SGX/SMX/CSTATE instructions/flows.

The detailed information can be found in the errata (section SRF7):
https://edc.intel.com/content/www/us/en/design/products-and-solutions/processors-and-chipsets/sierra-forest/xeon-6700-series-processor-with-e-cores-specification-update/errata-details/

For the Atom platforms before Sierra Forest (including Sierra Forest),
Both 2 events "Instruction Retired" and "Branch Instruction Retired" would
be overcounted on these certain instructions, but for Clearwater Forest
only "Instruction Retired" event is overcounted on these instructions.

So add a helper detect_inst_overcount_flags() to detect whether the
platform has the overcount issue and the later patches would relax the
precise count check by leveraging the gotten overcount flags from this
helper.

Signed-off-by: dongsheng <dongsheng.x.zhang@intel.com>
[Rewrite comments and commit message - Dapeng]
Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Tested-by: Yi Lai <yi1.lai@intel.com>
---
 lib/x86/processor.h | 17 ++++++++++++++++
 x86/pmu.c           | 47 +++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 64 insertions(+)

diff --git a/lib/x86/processor.h b/lib/x86/processor.h
index 62f3d578..3f475c21 100644
--- a/lib/x86/processor.h
+++ b/lib/x86/processor.h
@@ -1188,4 +1188,21 @@ static inline bool is_lam_u57_enabled(void)
 	return !!(read_cr3() & X86_CR3_LAM_U57);
 }
 
+static inline u32 x86_family(u32 eax)
+{
+	u32 x86;
+
+	x86 = (eax >> 8) & 0xf;
+
+	if (x86 == 0xf)
+		x86 += (eax >> 20) & 0xff;
+
+	return x86;
+}
+
+static inline u32 x86_model(u32 eax)
+{
+	return ((eax >> 12) & 0xf0) | ((eax >> 4) & 0x0f);
+}
+
 #endif
diff --git a/x86/pmu.c b/x86/pmu.c
index a6b0cfcc..87365aff 100644
--- a/x86/pmu.c
+++ b/x86/pmu.c
@@ -159,6 +159,14 @@ static struct pmu_event *gp_events;
 static unsigned int gp_events_size;
 static unsigned int fixed_counters_num;
 
+/*
+ * Flags for Intel "Instruction Retired" and "Branch Instruction Retired"
+ * overcount flaws.
+ */
+#define INST_RETIRED_OVERCOUNT BIT(0)
+#define BR_RETIRED_OVERCOUNT   BIT(1)
+static u32 intel_inst_overcount_flags;
+
 static int has_ibpb(void)
 {
 	return this_cpu_has(X86_FEATURE_SPEC_CTRL) ||
@@ -959,6 +967,43 @@ static void check_invalid_rdpmc_gp(void)
 	       "Expected #GP on RDPMC(64)");
 }
 
+/*
+ * For Intel Atom CPUs, the PMU events "Instruction Retired" or
+ * "Branch Instruction Retired" may be overcounted for some certain
+ * instructions, like FAR CALL/JMP, RETF, IRET, VMENTRY/VMEXIT/VMPTRLD
+ * and complex SGX/SMX/CSTATE instructions/flows.
+ *
+ * The detailed information can be found in the errata (section SRF7):
+ * https://edc.intel.com/content/www/us/en/design/products-and-solutions/processors-and-chipsets/sierra-forest/xeon-6700-series-processor-with-e-cores-specification-update/errata-details/
+ *
+ * For the Atom platforms before Sierra Forest (including Sierra Forest),
+ * Both 2 events "Instruction Retired" and "Branch Instruction Retired" would
+ * be overcounted on these certain instructions, but for Clearwater Forest
+ * only "Instruction Retired" event is overcounted on these instructions.
+ */
+static u32 detect_inst_overcount_flags(void)
+{
+	u32 flags = 0;
+	struct cpuid c = cpuid(1);
+
+	if (x86_family(c.a) == 0x6) {
+		switch (x86_model(c.a)) {
+		case 0xDD: /* Clearwater Forest */
+			flags = INST_RETIRED_OVERCOUNT;
+			break;
+
+		case 0xAF: /* Sierra Forest */
+		case 0x4D: /* Avaton, Rangely */
+		case 0x5F: /* Denverton */
+		case 0x86: /* Jacobsville */
+			flags = INST_RETIRED_OVERCOUNT | BR_RETIRED_OVERCOUNT;
+			break;
+		}
+	}
+
+	return flags;
+}
+
 int main(int ac, char **av)
 {
 	int instruction_idx;
@@ -985,6 +1030,8 @@ int main(int ac, char **av)
 		branch_idx = INTEL_BRANCHES_IDX;
 		branch_miss_idx = INTEL_BRANCH_MISS_IDX;
 
+		intel_inst_overcount_flags = detect_inst_overcount_flags();
+
 		/*
 		 * For legacy Intel CPUS without clflush/clflushopt support,
 		 * there is no way to force to trigger a LLC miss, thus set
-- 
2.43.0


