Return-Path: <kvm+bounces-56663-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DB4DDB4156B
	for <lists+kvm@lfdr.de>; Wed,  3 Sep 2025 08:47:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 974C53BF205
	for <lists+kvm@lfdr.de>; Wed,  3 Sep 2025 06:47:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 09D562D94A4;
	Wed,  3 Sep 2025 06:47:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="I2uj9oo1"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BD132D8DBB;
	Wed,  3 Sep 2025 06:47:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756882045; cv=none; b=sA1/97DtMU7zhqRkihQ7HJ18yOezni+Z67rFNXydJScm6Uecgu0S12QG54DCwawzrEP0zhEvBBWgRvYEaYenSM9SvMi9mNUwJO7I7N8eqIpKMlc8ipWYProbK/Irqwzhgn13N2Dvgj3N7NUP+No+afTPQN5GDuIF0h93LWWYwc4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756882045; c=relaxed/simple;
	bh=fT3sDIHjSujlwY4VLBHqNBqr18zjKD3cM+JhfiCXGY0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=U0ZylNs8vUBl46Zdm/72C9FV+/tz8O4WggTF/7YWx7SFHvkONb8woSX5kulw8io2Q5W9VDYxWkt3K3EY/ySXiYmQolCPGv/ioAAXck5Oki9k4z6wSxQpz+Q6850jwH7spNDy89qLSAeqrbPIYmXN3ROx3bB8OcyACjHrVOIdY9s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=I2uj9oo1; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756882043; x=1788418043;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=fT3sDIHjSujlwY4VLBHqNBqr18zjKD3cM+JhfiCXGY0=;
  b=I2uj9oo1yUC0A1ySH1AGxZHynazr4MmB4u17uV36k0a8SpJlCmozXo/O
   z8l2Fnstx5G5fgp7HI+MIF5uLJUgo0aQS8IkzirtHIvUomVHO+gDm9Fh6
   FQS396ThJpV77RjT2HCjcfHgTjNd6MRwxv8L7QRhSoVu3TWrCVZzUZbqa
   ZlYlnXhWsy7kq+6OT3LGodHrR/rUDp2bpwItQmhS4YtvNmnavZx+AyJHB
   ws4ePSZbfTqJpwMgdMEWGrMyT/4/Gl7OmlHnMcx0sXOOyZQ8DRartxvJB
   XcAjei0BIpjx+FqvkfkYT/d6spqyujxuvJiuHmZ71NslVCTO+jkrtkRnY
   w==;
X-CSE-ConnectionGUID: Y5Su2BURQ+Cr723a9IoxVg==
X-CSE-MsgGUID: VBMplUriQmabEXLVCSi/lg==
X-IronPort-AV: E=McAfee;i="6800,10657,11541"; a="63003767"
X-IronPort-AV: E=Sophos;i="6.18,233,1751266800"; 
   d="scan'208";a="63003767"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2025 23:47:23 -0700
X-CSE-ConnectionGUID: 9DDQH7J6Q7eCm4Mq+wy5CA==
X-CSE-MsgGUID: 2aLHXF9aRl+b6l31inNhvg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,233,1751266800"; 
   d="scan'208";a="171656534"
Received: from spr.sh.intel.com ([10.112.230.239])
  by orviesa008.jf.intel.com with ESMTP; 02 Sep 2025 23:47:19 -0700
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
	Xiaoyao Li <xiaoyao.li@intel.com>,
	Dapeng Mi <dapeng1.mi@intel.com>,
	dongsheng <dongsheng.x.zhang@intel.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	Yi Lai <yi1.lai@intel.com>
Subject: [kvm-unit-tests patch v3 1/8] x86/pmu: Add helper to detect Intel overcount issues
Date: Wed,  3 Sep 2025 14:45:54 +0800
Message-Id: <20250903064601.32131-2-dapeng1.mi@linux.intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250903064601.32131-1-dapeng1.mi@linux.intel.com>
References: <20250903064601.32131-1-dapeng1.mi@linux.intel.com>
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
 lib/x86/processor.h | 27 ++++++++++++++++++++++++++
 x86/pmu.c           | 47 +++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 74 insertions(+)

diff --git a/lib/x86/processor.h b/lib/x86/processor.h
index 62f3d578..937f75e4 100644
--- a/lib/x86/processor.h
+++ b/lib/x86/processor.h
@@ -1188,4 +1188,31 @@ static inline bool is_lam_u57_enabled(void)
 	return !!(read_cr3() & X86_CR3_LAM_U57);
 }
 
+/* Copy from kernel arch/x86/lib/cpu.c */
+static inline u32 x86_family(u32 sig)
+{
+	u32 x86;
+
+	x86 = (sig >> 8) & 0xf;
+
+	if (x86 == 0xf)
+		x86 += (sig >> 20) & 0xff;
+
+	return x86;
+}
+
+static inline u32 x86_model(u32 sig)
+{
+	u32 fam, model;
+
+	fam = x86_family(sig);
+
+	model = (sig >> 4) & 0xf;
+
+	if (fam >= 0x6)
+		model += ((sig >> 16) & 0xf) << 4;
+
+	return model;
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
2.34.1


