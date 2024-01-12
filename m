Return-Path: <kvm+bounces-6128-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DEFA182BB1C
	for <lists+kvm@lfdr.de>; Fri, 12 Jan 2024 07:01:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8D1B128A97A
	for <lists+kvm@lfdr.de>; Fri, 12 Jan 2024 06:01:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A4C295C8FA;
	Fri, 12 Jan 2024 06:00:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XmbDPNQq"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 667A95C8E0
	for <kvm@vger.kernel.org>; Fri, 12 Jan 2024 06:00:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1705039254; x=1736575254;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=TjGvkLnFdATYJZjMoetdlVNdiuJsV6qD9qhxqSL1S54=;
  b=XmbDPNQq/mcOh47rMELk9Vy9RM3lyrptMRLvXZ17B/5KsOAdrgZMsqBF
   RKKARZQqqjwFr9XXM3zeKCOhEQiDhG9ncq3gp6KiGwkA3+LhO/vY3pkNW
   pfG2KWOW6HnojJlhYUYa6TuP763Ke/C2V7hDvOWOZBwgeQMunVsNANlbl
   BUZdb8H5KG6yw7Ycgjc3Tl070vUaNbdL3TM03Q6c4WHCFlKWS1mdAT4vD
   +yPNxGY+DA/A7xe8AA/D+iMc8dog0cRdjfrQhTTIABUI3F7Wvm2gnacYF
   IvlV71iDA50s7FMaYK6FVLOTrbIf00Zqicx5UxhXMOu0Nn+GVbkf/C/8z
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10950"; a="5815755"
X-IronPort-AV: E=Sophos;i="6.04,188,1695711600"; 
   d="scan'208";a="5815755"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jan 2024 22:00:51 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10950"; a="873274718"
X-IronPort-AV: E=Sophos;i="6.04,188,1695711600"; 
   d="scan'208";a="873274718"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO binbinwu-mobl.sh.intel.com) ([10.238.2.99])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jan 2024 22:00:48 -0800
From: Binbin Wu <binbin.wu@linux.intel.com>
To: qemu-devel@nongnu.org,
	kvm@vger.kernel.org
Cc: pbonzini@redhat.com,
	xiaoyao.li@intel.com,
	chao.gao@intel.com,
	robert.hu@linux.intel.com,
	binbin.wu@linux.intel.com
Subject: [PATCH v4 1/2] target/i386: add support for LAM in CPUID enumeration
Date: Fri, 12 Jan 2024 14:00:41 +0800
Message-Id: <20240112060042.19925-2-binbin.wu@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240112060042.19925-1-binbin.wu@linux.intel.com>
References: <20240112060042.19925-1-binbin.wu@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Robert Hoo <robert.hu@linux.intel.com>

Linear Address Masking (LAM) is a new Intel CPU feature, which allows
software to use of the untranslated address bits for metadata.

The bit definition:
CPUID.(EAX=7,ECX=1):EAX[26]

Add CPUID definition for LAM.

Note LAM feature is not supported for TCG of target-i386, LAM CPIUD bit
will not be added to TCG_7_1_EAX_FEATURES.

More info can be found in Intel ISE Chapter "LINEAR ADDRESS MASKING(LAM)"
https://cdrdv2.intel.com/v1/dl/getContent/671368

Signed-off-by: Robert Hoo <robert.hu@linux.intel.com>
Co-developed-by: Binbin Wu <binbin.wu@linux.intel.com>
Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
Tested-by: Xuelian Guo <xuelian.guo@intel.com>
Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 target/i386/cpu.c | 2 +-
 target/i386/cpu.h | 2 ++
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index 2524881ce2..fc862dfeb1 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -967,7 +967,7 @@ FeatureWordInfo feature_word_info[FEATURE_WORDS] = {
             "fsrc", NULL, NULL, NULL,
             NULL, NULL, NULL, NULL,
             NULL, "amx-fp16", NULL, "avx-ifma",
-            NULL, NULL, NULL, NULL,
+            NULL, NULL, "lam", NULL,
             NULL, NULL, NULL, NULL,
         },
         .cpuid = {
diff --git a/target/i386/cpu.h b/target/i386/cpu.h
index 7f0786e8b9..18ea755644 100644
--- a/target/i386/cpu.h
+++ b/target/i386/cpu.h
@@ -925,6 +925,8 @@ uint64_t x86_cpu_get_supported_feature_word(FeatureWord w,
 #define CPUID_7_1_EAX_AMX_FP16          (1U << 21)
 /* Support for VPMADD52[H,L]UQ */
 #define CPUID_7_1_EAX_AVX_IFMA          (1U << 23)
+/* Linear Address Masking */
+#define CPUID_7_1_EAX_LAM               (1U << 26)
 
 /* Support for VPDPB[SU,UU,SS]D[,S] */
 #define CPUID_7_1_EDX_AVX_VNNI_INT8     (1U << 4)
-- 
2.25.1


