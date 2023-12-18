Return-Path: <kvm+bounces-4682-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9EFF181671A
	for <lists+kvm@lfdr.de>; Mon, 18 Dec 2023 08:11:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5B0EF282B40
	for <lists+kvm@lfdr.de>; Mon, 18 Dec 2023 07:11:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2555279FC;
	Mon, 18 Dec 2023 07:11:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="h0iKdezn"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB2A279EB
	for <kvm@vger.kernel.org>; Mon, 18 Dec 2023 07:11:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1702883461; x=1734419461;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=jOpPNSfiK1BCYnfzEUhtM/2efju3p7iSSXcPR1iti9g=;
  b=h0iKdeznen4ri9UyDfIw4DKG3lBH5T1ho70R64v8G0lkI4KkVNGstW1A
   KT84A0rccJmcb9BOopWQrVSD9tKyxwG6tPNft89FzKK3VYKWHhhAW6s5T
   CJLdEaHoxk4rk5XXW5uXoy0E4aMi3jWzgviasbuwlcBxAP7eeZERud7Ss
   Exu/SD/s+C4HavBKiedcudr4o3kKCrDp+VMgsFH5pcMxDB9aI3OBT3CWY
   6pIwEqmJ5hSXRyx/ZvCHKu6Ziaw49fvr3WFGE77ujEizbGlVnyn5hVoSe
   SVD6LGLcCsyG66EIIpvia5YzbH+lQ4G9GYUMVgTZnTBKTsntga5X+j1/b
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10927"; a="2667992"
X-IronPort-AV: E=Sophos;i="6.04,284,1695711600"; 
   d="scan'208";a="2667992"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Dec 2023 23:11:01 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10927"; a="1106824822"
X-IronPort-AV: E=Sophos;i="6.04,284,1695711600"; 
   d="scan'208";a="1106824822"
Received: from pc.sh.intel.com ([10.238.200.75])
  by fmsmga005.fm.intel.com with ESMTP; 17 Dec 2023 23:10:58 -0800
From: Qian Wen <qian.wen@intel.com>
To: kvm@vger.kernel.org,
	seanjc@google.com,
	pbonzini@redhat.com
Cc: nikos.nikoleris@arm.com,
	shahuang@redhat.com,
	alexandru.elisei@arm.com,
	yu.c.zhang@intel.com,
	zhenzhong.duan@intel.com,
	isaku.yamahata@intel.com,
	chenyi.qiang@intel.com,
	ricarkol@google.com,
	qian.wen@intel.com
Subject: [kvm-unit-tests RFC v2 16/18] x86 TDX: Modify the MSR test to be compatible with TDX
Date: Mon, 18 Dec 2023 15:22:45 +0800
Message-Id: <20231218072247.2573516-17-qian.wen@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20231218072247.2573516-1-qian.wen@intel.com>
References: <20231218072247.2573516-1-qian.wen@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Zhenzhong Duan <zhenzhong.duan@intel.com>

According to TDX Module 1.5 ABI Sepc, Table 2.1 MSR Virtualization, the
following modifications are made in MSRs test.

1. Skip sub-tests about MSR_IA32_MISC_ENABLE and MSR_CSTAR, since
changing those MSRs are unsupported:
  - MSR_IA32_MISC_ENABLE is reading native and #VE in writing.
  - MSR_CSTAR is #VE in reading/writing and its simulation is not
    supported in TDX host side.

2. Skip the x2apic-msrs test in x2apic disabled mode. The TDX guest only
supports X2APIC, and cannot disable APIC.

3. Add readable flag for x2apic MSRs if TDX guest.

There is a gap between VMX and TDX about read registers in the virtual
APIC page. KVM will intercept reads to non-existent MSRs[1], the TDX
doesn't validate it and directly reads **native**. So add a readable
flag for x2apic MSRs if TDX guest to avoid #GP checking for RDMSR.

4. Add #VE check for MSR operation fault.

For some MSRs, e.g., MCE-related MSR, they are virtualized by #VE in
tdx. The exception of invalid RDMSR/WRMSR for it is #VE instead of #GP,
so correct it in the test_rdmsr_fault() and test_wrmsr_fault().

[1] KVM: VMX: Always intercept accesses to unsupported "extended" x2APIC
regs, https://lore.kernel.org/r/20230107011025.565472-6-seanjc@google.com

Signed-off-by: Zhenzhong Duan <zhenzhong.duan@intel.com>
Reviewed-by: Yu Zhang <yu.c.zhang@intel.com>
Link: https://lore.kernel.org/r/20220303071907.650203-16-zhenzhong.duan@intel.com
Co-developed-by: Qian Wen <qian.wen@intel.com>
Signed-off-by: Qian Wen <qian.wen@intel.com>
---
 x86/msr.c | 46 ++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 38 insertions(+), 8 deletions(-)

diff --git a/x86/msr.c b/x86/msr.c
index 3a041fab..b1392487 100644
--- a/x86/msr.c
+++ b/x86/msr.c
@@ -5,6 +5,7 @@
 #include "processor.h"
 #include "msr.h"
 #include <stdlib.h>
+#include "tdx.h"
 
 /*
  * This test allows two modes:
@@ -97,9 +98,11 @@ static void test_wrmsr(u32 msr, const char *name, unsigned long long val)
 static void test_wrmsr_fault(u32 msr, const char *name, unsigned long long val)
 {
 	unsigned char vector = wrmsr_safe(msr, val);
-
-	report(vector == GP_VECTOR,
-	       "Expected #GP on WRSMR(%s, 0x%llx), got vector %d",
+	bool pass = false;
+	if (vector == GP_VECTOR || (vector == VE_VECTOR && is_tdx_guest()))
+		pass = true;
+	report(pass,
+	       "Expected #GP/#VE on WRSMR(%s, 0x%llx), got vector %d",
 	       name, val, vector);
 }
 
@@ -107,13 +110,20 @@ static void test_rdmsr_fault(u32 msr, const char *name)
 {
 	uint64_t ignored;
 	unsigned char vector = rdmsr_safe(msr, &ignored);
-
-	report(vector == GP_VECTOR,
-	       "Expected #GP on RDSMR(%s), got vector %d", name, vector);
+	bool pass = false;
+	if (vector == GP_VECTOR || (vector == VE_VECTOR && is_tdx_guest()))
+		pass = true;
+	report(pass,
+	       "Expected #GP/#VE on RDSMR(%s), got vector %d", name, vector);
 }
 
 static void test_msr(struct msr_info *msr, bool is_64bit_host)
 {
+	/* Changing MSR_IA32_MISC_ENABLE and MSR_CSTAR is unsupported in TDX */
+	if ((msr->index == MSR_IA32_MISC_ENABLE || msr->index == MSR_CSTAR) &&
+	    is_tdx_guest())
+		return;
+
 	if (is_64bit_host || !msr->is_64bit_only) {
 		__test_msr_rw(msr->index, msr->name, msr->value, msr->keep);
 
@@ -223,6 +233,24 @@ static void test_mce_msrs(void)
 	}
 }
 
+static enum x2apic_reg_semantics get_x2apic_reg_semantics2(u32 reg)
+{
+	enum x2apic_reg_semantics ret;
+	ret = get_x2apic_reg_semantics(reg);
+
+	if (is_tdx_guest()) {
+		switch (reg) {
+		case APIC_ARBPRI:
+		case APIC_EOI:
+		case APIC_RRR:
+		case APIC_DFR:
+		case APIC_SELF_IPI:
+			ret |= X2APIC_RO;
+		}
+	}
+	return ret;
+}
+
 static void __test_x2apic_msrs(bool x2apic_enabled)
 {
 	enum x2apic_reg_semantics semantics;
@@ -234,7 +262,7 @@ static void __test_x2apic_msrs(bool x2apic_enabled)
 		snprintf(msr_name, sizeof(msr_name), "x2APIC MSR 0x%x", index);
 
 		if (x2apic_enabled)
-			semantics = get_x2apic_reg_semantics(i);
+			semantics = get_x2apic_reg_semantics2(i);
 		else
 			semantics = X2APIC_INVALID;
 
@@ -270,13 +298,15 @@ static void __test_x2apic_msrs(bool x2apic_enabled)
 
 static void test_x2apic_msrs(void)
 {
+	if (is_tdx_guest())
+		goto test_x2apic;
 	reset_apic();
 
 	__test_x2apic_msrs(false);
 
 	if (!enable_x2apic())
 		return;
-
+test_x2apic:
 	__test_x2apic_msrs(true);
 }
 
-- 
2.25.1


