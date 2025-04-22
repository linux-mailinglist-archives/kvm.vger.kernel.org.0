Return-Path: <kvm+bounces-43782-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2411EA961BD
	for <lists+kvm@lfdr.de>; Tue, 22 Apr 2025 10:33:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9E27D3A3B36
	for <lists+kvm@lfdr.de>; Tue, 22 Apr 2025 08:32:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F30427587A;
	Tue, 22 Apr 2025 08:24:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="KfOau+bN"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE383266B44;
	Tue, 22 Apr 2025 08:23:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745310241; cv=none; b=lLbNiuCiP23OskEgxx1YcnuXbh1sggdRXiwh4S3Jz6YNg1WKcuLkX5zHHLVRHyI5O6Ell8Fh1J1D5ZpDF2exbURngxFxfTEHv8v811QQrsTU9180q5mqe50MT137VnE9ZS2P/g8w8zEk3OarzLUsf2i3JfCLSj2ejlQYYFS24H8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745310241; c=relaxed/simple;
	bh=NjhZjsi1bq0OQ2uRA3fVR+7VFKZYXxi+qmgMj+yEiTM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WN4FP2wjWSuAjjgTUGfM7hAxZuSWjAWwg6nuAV3vh5h7rPN1MOATy9jBUzBCpDGFjH8jA4lpnWkoHSTuUipuK1skY1vLcDlBQr7SKNAmIJY2M3d+2NeBFRRIvwps/Lha7nOtaSPMYSRTAUAtjLe86uKrp72Bz9cJLSia0tTCoWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=KfOau+bN; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from terminus.zytor.com (terminus.zytor.com [IPv6:2607:7c80:54:3:0:0:0:136])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 53M8MG9k1954391
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Tue, 22 Apr 2025 01:23:26 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 53M8MG9k1954391
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025042001; t=1745310207;
	bh=RsMt57mlaVk9CocrxjydLh4eE9MOuCS2P68NuQfut0U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KfOau+bNZ/tY6KfWMZGNcMxqK1rglE1wkeTuZolxBRhAickqGvWKN/4Qz9B2mmuIl
	 oDw6BUhQMWrY3r31kLQPr8RGOOK8cTYW2QNw2b+TEbZi/tWFs5DlaKiKWVjJEV3bGW
	 wl3qqGp4z5D6tJ7OOmN6yeKxXJzggCTzeNwMfC/dA7ESam0+T6sxHCsX50uhF54bxD
	 HkHgd2xOgyQRa/LcauymKkTW/1LS+6P1DhPyORguEzAyNoN+DEZ+6Xw5/xIQDR/ldR
	 RvnM1+AxAR+4uk/vjBOgTRs8JOEl8GDXbY9oZ9+HCOdGf2CGGSi1yBlqpHC/R8fIIc
	 VCxpAQ46OhJbA==
From: "Xin Li (Intel)" <xin@zytor.com>
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-perf-users@vger.kernel.org, linux-hyperv@vger.kernel.org,
        virtualization@lists.linux.dev, linux-pm@vger.kernel.org,
        linux-edac@vger.kernel.org, xen-devel@lists.xenproject.org,
        linux-acpi@vger.kernel.org, linux-hwmon@vger.kernel.org,
        netdev@vger.kernel.org, platform-driver-x86@vger.kernel.org
Cc: tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
        acme@kernel.org, jgross@suse.com, andrew.cooper3@citrix.com,
        peterz@infradead.org, namhyung@kernel.org, mark.rutland@arm.com,
        alexander.shishkin@linux.intel.com, jolsa@kernel.org,
        irogers@google.com, adrian.hunter@intel.com, kan.liang@linux.intel.com,
        wei.liu@kernel.org, ajay.kaher@broadcom.com,
        bcm-kernel-feedback-list@broadcom.com, tony.luck@intel.com,
        pbonzini@redhat.com, vkuznets@redhat.com, seanjc@google.com,
        luto@kernel.org, boris.ostrovsky@oracle.com, kys@microsoft.com,
        haiyangz@microsoft.com, decui@microsoft.com
Subject: [RFC PATCH v2 32/34] x86/msr: Rename native_read_msr_safe() to native_rdmsrq_safe()
Date: Tue, 22 Apr 2025 01:22:13 -0700
Message-ID: <20250422082216.1954310-33-xin@zytor.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250422082216.1954310-1-xin@zytor.com>
References: <20250422082216.1954310-1-xin@zytor.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Signed-off-by: Xin Li (Intel) <xin@zytor.com>
---
 arch/x86/include/asm/msr.h |  4 ++--
 arch/x86/kvm/svm/svm.c     | 10 +++++-----
 arch/x86/xen/pmu.c         |  4 ++--
 3 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/arch/x86/include/asm/msr.h b/arch/x86/include/asm/msr.h
index 4c7aa9e7fbac..b4447ba4d6c2 100644
--- a/arch/x86/include/asm/msr.h
+++ b/arch/x86/include/asm/msr.h
@@ -157,7 +157,7 @@ static __always_inline bool is_msr_imm_insn(void *ip)
  *                         __native_rdmsrq()   -----------------------
  *                            /     \                                |
  *                           /       \                               |
- *        native_rdmsrq_no_trace()    native_read_msr_safe()         |
+ *        native_rdmsrq_no_trace()    native_rdmsrq_safe()           |
  *                   /      \                                        |
  *                  /        \                                       |
  * native_rdmsr_no_trace()    native_rdmsrq()                        |
@@ -273,7 +273,7 @@ static inline u64 native_rdmsrq(u32 msr)
 	return val;
 }
 
-static inline int native_read_msr_safe(u32 msr, u64 *val)
+static inline int native_rdmsrq_safe(u32 msr, u64 *val)
 {
 	int err;
 
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 01dd3cd20730..251fd9366b35 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -481,7 +481,7 @@ static void svm_init_erratum_383(void)
 		return;
 
 	/* Use _safe variants to not break nested virtualization */
-	if (native_read_msr_safe(MSR_AMD64_DC_CFG, &val))
+	if (native_rdmsrq_safe(MSR_AMD64_DC_CFG, &val))
 		return;
 
 	val |= (1ULL << 47);
@@ -649,9 +649,9 @@ static int svm_enable_virtualization_cpu(void)
 		u64 len, status = 0;
 		int err;
 
-		err = native_read_msr_safe(MSR_AMD64_OSVW_ID_LENGTH, &len);
+		err = native_rdmsrq_safe(MSR_AMD64_OSVW_ID_LENGTH, &len);
 		if (!err)
-			err = native_read_msr_safe(MSR_AMD64_OSVW_STATUS, &status);
+			err = native_rdmsrq_safe(MSR_AMD64_OSVW_STATUS, &status);
 
 		if (err)
 			osvw_status = osvw_len = 0;
@@ -2148,7 +2148,7 @@ static bool is_erratum_383(void)
 	if (!erratum_383_found)
 		return false;
 
-	if (native_read_msr_safe(MSR_IA32_MC0_STATUS, &value))
+	if (native_rdmsrq_safe(MSR_IA32_MC0_STATUS, &value))
 		return false;
 
 	/* Bit 62 may or may not be set for this mce */
@@ -2161,7 +2161,7 @@ static bool is_erratum_383(void)
 	for (i = 0; i < 6; ++i)
 		native_wrmsrq_safe(MSR_IA32_MCx_STATUS(i), 0);
 
-	if (!native_read_msr_safe(MSR_IA32_MCG_STATUS, &value)) {
+	if (!native_rdmsrq_safe(MSR_IA32_MCG_STATUS, &value)) {
 		value &= ~(1ULL << 2);
 		native_wrmsrq_safe(MSR_IA32_MCG_STATUS, value);
 	}
diff --git a/arch/x86/xen/pmu.c b/arch/x86/xen/pmu.c
index ee908dfcff48..66d2c6fc7bfa 100644
--- a/arch/x86/xen/pmu.c
+++ b/arch/x86/xen/pmu.c
@@ -323,7 +323,7 @@ static u64 xen_amd_read_pmc(int counter)
 		u64 val;
 
 		msr = amd_counters_base + (counter * amd_msr_step);
-		native_read_msr_safe(msr, &val);
+		native_rdmsrq_safe(msr, &val);
 		return val;
 	}
 
@@ -349,7 +349,7 @@ static u64 xen_intel_read_pmc(int counter)
 		else
 			msr = MSR_IA32_PERFCTR0 + counter;
 
-		native_read_msr_safe(msr, &val);
+		native_rdmsrq_safe(msr, &val);
 		return val;
 	}
 
-- 
2.49.0


