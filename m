Return-Path: <kvm+bounces-7897-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 19E18848497
	for <lists+kvm@lfdr.de>; Sat,  3 Feb 2024 10:00:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 988961F278F5
	for <lists+kvm@lfdr.de>; Sat,  3 Feb 2024 09:00:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 520B35D72C;
	Sat,  3 Feb 2024 08:59:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OqxgokOW"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6D515CDD3;
	Sat,  3 Feb 2024 08:59:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706950793; cv=none; b=jB2FYW8QvJ1N970S63K/2qVzkMsdA3/3mCU/AssqXuULmQJYDOsQIC6ZTX6hr4P/+yaWU2jK7a2fEvyaUHKfzaGtZ5p49D1ZBpYjql1/hPsXHvkyXPIsJsDGI6VqngCMOwbLFcf3AwNR7wVINlw39TJVzkDnoNgyx01MCcU/GL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706950793; c=relaxed/simple;
	bh=O309/Vt9MktFf0PdG6Lw5tGr+fycilz2bwzopTCTR0Y=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=sh+l+RyY4JMFnWNvCkbH5znmfsdaEkEfhbq+CFyJSGOtHD3/FqZk6mVG2HDYtwTBroJgMfmDMjo2MmaGDUR2JB7lXkrRFbbzoixGEJdXTNE968Xwzrk2Y5d5iTuBi5bQfpl++X2HJd+1WgUnRdW+z7c6+tKw0+57XSUwPDf2kCE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OqxgokOW; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706950792; x=1738486792;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=O309/Vt9MktFf0PdG6Lw5tGr+fycilz2bwzopTCTR0Y=;
  b=OqxgokOWH3FKqLfnco6VJfiyyvGuBZbnJ6NynOs6fn4KIPjx1LE1FNB9
   xgzQzA3Y4SBTDWyBiYuKjXUInV0AZl1T4T9UPXlB5L9+pImPGPGxW+6lQ
   PcBH8/v5fwYQWd1X4KV76Zg1vfkPLzA1YUitqhExME5Mzp2ZLDLmYJoPp
   JlWG3CppyELiyTjKUCOOaQFH7rADn3njTs6jBquyCE6TuwXOYfIOY09Tf
   4aZMgtpPekVpAtxonDLwh1eiCSpAl9dZpoUYIs3pQytIVwGGQhIxGX4gf
   wE+X9ioOvTNCMH/tXmlAIJLI+Uo05ST0/nbYyFXfMlFpolNR4ZNi3Ffkn
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10971"; a="4131855"
X-IronPort-AV: E=Sophos;i="6.05,240,1701158400"; 
   d="scan'208";a="4131855"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2024 00:59:52 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,240,1701158400"; 
   d="scan'208";a="291146"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.36])
  by fmviesa009.fm.intel.com with ESMTP; 03 Feb 2024 00:59:45 -0800
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
Subject: [RFC 01/26] thermal: Add bit definition for x86 thermal related MSRs
Date: Sat,  3 Feb 2024 17:11:49 +0800
Message-Id: <20240203091214.411862-2-zhao1.liu@linux.intel.com>
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

Add the definition of more bits of these MSRs:

* MSR_IA32_THERM_CONTROL
* MSR_IA32_THERM_INTERRUPT
* MSR_IA32_THERM_STATUS
* MSR_IA32_PACKAGE_THERM_STATUS
* MSR_IA32_PACKAGE_THERM_INTERRUPT

The virtualization of thermal events need these extra definitions.

While here, regroup the definitions and use the BIT_ULL() and
GENMASK_ULL() macro to improve readability.

Tested-by: Yanting Jiang <yanting.jiang@intel.com>
Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
 arch/x86/include/asm/msr-index.h    | 54 +++++++++++++++++++----------
 drivers/thermal/intel/therm_throt.c |  1 -
 2 files changed, 35 insertions(+), 20 deletions(-)

diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index 65b1bfb9c304..4f7ebfafa46a 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -829,17 +829,26 @@
 #define MSR_IA32_MPERF			0x000000e7
 #define MSR_IA32_APERF			0x000000e8
 
-#define MSR_IA32_THERM_CONTROL		0x0000019a
-#define MSR_IA32_THERM_INTERRUPT	0x0000019b
-
-#define THERM_INT_HIGH_ENABLE		(1 << 0)
-#define THERM_INT_LOW_ENABLE		(1 << 1)
-#define THERM_INT_PLN_ENABLE		(1 << 24)
-
-#define MSR_IA32_THERM_STATUS		0x0000019c
+#define MSR_IA32_THERM_CONTROL			0x0000019a
+#define THERM_ON_DEM_CLO_MOD_DUTY_CYC_MASK	GENMASK_ULL(3, 1)
+#define THERM_ON_DEM_CLO_MOD_ENABLE		BIT_ULL(4)
 
-#define THERM_STATUS_PROCHOT		(1 << 0)
-#define THERM_STATUS_POWER_LIMIT	(1 << 10)
+#define MSR_IA32_THERM_INTERRUPT	0x0000019b
+#define THERM_INT_HIGH_ENABLE		BIT_ULL(0)
+#define THERM_INT_LOW_ENABLE		BIT_ULL(1)
+#define THERM_INT_PROCHOT_ENABLE	BIT_ULL(2)
+#define THERM_INT_FORCEPR_ENABLE	BIT_ULL(3)
+#define THERM_INT_CRITICAL_TEM_ENABLE	BIT_ULL(4)
+#define THERM_INT_PLN_ENABLE		BIT_ULL(24)
+
+#define MSR_IA32_THERM_STATUS			0x0000019c
+#define THERM_STATUS_PROCHOT			BIT_ULL(0)
+#define THERM_STATUS_PROCHOT_LOG		BIT_ULL(1)
+#define THERM_STATUS_PROCHOT_FORCEPR_EVENT	BIT_ULL(2)
+#define THERM_STATUS_PROCHOT_FORCEPR_LOG	BIT_ULL(3)
+#define THERM_STATUS_CRITICAL_TEMP		BIT_ULL(4)
+#define THERM_STATUS_CRITICAL_TEMP_LOG		BIT_ULL(5)
+#define THERM_STATUS_POWER_LIMIT		BIT_ULL(10)
 
 #define MSR_THERM2_CTL			0x0000019d
 
@@ -861,17 +870,24 @@
 #define ENERGY_PERF_BIAS_POWERSAVE		15
 
 #define MSR_IA32_PACKAGE_THERM_STATUS		0x000001b1
-
-#define PACKAGE_THERM_STATUS_PROCHOT		(1 << 0)
-#define PACKAGE_THERM_STATUS_POWER_LIMIT	(1 << 10)
-#define PACKAGE_THERM_STATUS_HFI_UPDATED	(1 << 26)
+#define PACKAGE_THERM_STATUS_PROCHOT		BIT_ULL(0)
+#define PACKAGE_THERM_STATUS_PROCHOT_LOG	BIT_ULL(1)
+#define PACKAGE_THERM_STATUS_PROCHOT_EVENT	BIT_ULL(2)
+#define PACKAGE_THERM_STATUS_PROCHOT_EVENT_LOG	BIT_ULL(3)
+#define PACKAGE_THERM_STATUS_CRITICAL_TEMP	BIT_ULL(4)
+#define PACKAGE_THERM_STATUS_CRITICAL_TEMP_LOG	BIT_ULL(5)
+#define PACKAGE_THERM_STATUS_POWER_LIMIT	BIT_ULL(10)
+#define PACKAGE_THERM_STATUS_POWER_LIMIT_LOG	BIT_ULL(11)
+#define PACKAGE_THERM_STATUS_DIG_READOUT_MASK	GENMASK_ULL(22, 16)
+#define PACKAGE_THERM_STATUS_HFI_UPDATED	BIT_ULL(26)
 
 #define MSR_IA32_PACKAGE_THERM_INTERRUPT	0x000001b2
-
-#define PACKAGE_THERM_INT_HIGH_ENABLE		(1 << 0)
-#define PACKAGE_THERM_INT_LOW_ENABLE		(1 << 1)
-#define PACKAGE_THERM_INT_PLN_ENABLE		(1 << 24)
-#define PACKAGE_THERM_INT_HFI_ENABLE		(1 << 25)
+#define PACKAGE_THERM_INT_HIGH_ENABLE		BIT_ULL(0)
+#define PACKAGE_THERM_INT_LOW_ENABLE		BIT_ULL(1)
+#define PACKAGE_THERM_INT_PROCHOT_ENABLE	BIT_ULL(2)
+#define PACKAGE_THERM_INT_OVERHEAT_ENABLE	BIT_ULL(4)
+#define PACKAGE_THERM_INT_PLN_ENABLE		BIT_ULL(24)
+#define PACKAGE_THERM_INT_HFI_ENABLE		BIT_ULL(25)
 
 /* Thermal Thresholds Support */
 #define THERM_INT_THRESHOLD0_ENABLE    (1 << 15)
diff --git a/drivers/thermal/intel/therm_throt.c b/drivers/thermal/intel/therm_throt.c
index e69868e868eb..4c72fee32bf2 100644
--- a/drivers/thermal/intel/therm_throt.c
+++ b/drivers/thermal/intel/therm_throt.c
@@ -191,7 +191,6 @@ static const struct attribute_group thermal_attr_group = {
 #endif /* CONFIG_SYSFS */
 
 #define THERM_THROT_POLL_INTERVAL	HZ
-#define THERM_STATUS_PROCHOT_LOG	BIT(1)
 
 static u64 therm_intr_core_clear_mask;
 static u64 therm_intr_pkg_clear_mask;
-- 
2.34.1


