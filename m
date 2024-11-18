Return-Path: <kvm+bounces-32032-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 552D89D1B4F
	for <lists+kvm@lfdr.de>; Mon, 18 Nov 2024 23:56:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 17EB628291F
	for <lists+kvm@lfdr.de>; Mon, 18 Nov 2024 22:56:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8127F1EE012;
	Mon, 18 Nov 2024 22:54:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="c70ZJqlA"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE9E61EC01E
	for <kvm@vger.kernel.org>; Mon, 18 Nov 2024 22:54:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731970481; cv=none; b=e3qzsDZ1968GkACrAPkePCgjWqCk5508XWGyKwKyIlQ6MQLy+FippjNAmsMYK1IN5RDmMABTeeYrfrUjicMn5QIDjamOYJKu/Bo7QHqKdsCPLwDJ5X9SEYu4SmSxFXGFiw0iqqmQVgFHkE1YskeMEQcvWK+U8sRTgFYcrNXaZ3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731970481; c=relaxed/simple;
	bh=H4yiDXfMMpv/Z55e9PVMBTH/yEnT82ghVphY/gryc3E=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=CnG0hCDaxSjpvm/Axi2vH1iopbrrZdJj/356UMUU+dRjcfs7jVHDGcfWO4MkqWIcvfA6jyoXrDf4ydJI5pu7mFAUirDHVa44VD1IskyVPEmEkgBWQki93LeZpx+j3EjatVAB4ltp98B4mogtGWI0ivujzkO00Vv9SmqKBDMRewQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=c70ZJqlA; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1731970480; x=1763506480;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=H4yiDXfMMpv/Z55e9PVMBTH/yEnT82ghVphY/gryc3E=;
  b=c70ZJqlAFCGZozun4YqKOBP4TWw2dDjJXFmNKmAp28faqJ6IU/U+OMN1
   67rxWKEZknDJc154VX+SDBiucBAAgQ/+MksULWwxF6xlAn8Q/6rDsmwPj
   pb2kmFAoPJRf1Q6NEnF6zDw/XwXmCxiS4pLT7ClnDNs/UUUweI7fATrU4
   TIMUNHI298sxAeoL12iSqnCyk73mCOD/2TXkkLwdzvx+yreL953rREAKV
   uoKfrSP1mqYkdPl+8WbVCH927Q1+U3U0szEwu3XRD2278LLt6lgYSuyDP
   YsYfFbYagUeFTDGqPaKgYn/9tywbe5FRZaY2b/g46YPy+n6V9MobMSHqz
   A==;
X-CSE-ConnectionGUID: xIGi5u9hSsGdb/RwLNatEg==
X-CSE-MsgGUID: YKlXKyYeRzmhduh7O3s71w==
X-IronPort-AV: E=McAfee;i="6700,10204,11260"; a="42579574"
X-IronPort-AV: E=Sophos;i="6.12,165,1728975600"; 
   d="scan'208";a="42579574"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Nov 2024 14:54:39 -0800
X-CSE-ConnectionGUID: 6sPQ1VqPQQa3+SLKDcuutw==
X-CSE-MsgGUID: juMtCHHvRauT9jX563W1eg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,165,1728975600"; 
   d="scan'208";a="89145919"
Received: from 9cc2c43eec6b.jf.intel.com ([10.54.77.44])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Nov 2024 14:54:39 -0800
From: Zide Chen <zide.chen@intel.com>
To: kvm@vger.kernel.org
Cc: Zide Chen <zide.chen@intel.com>,
	Zhenyu Wang <zhenyuw@linux.intel.com>
Subject: [kvm-unit-test PATCH 1/3] nVMX: fixed-function performance counters could be not contiguous
Date: Mon, 18 Nov 2024 14:52:05 -0800
Message-Id: <20241118225207.16596-1-zide.chen@intel.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The fixed counters may not be contiguous.  Intel SDM recommends how to
use CPUID.0AH to determine if a Fixed Counter is supported:
	FxCtr[i]_is_supported := ECX[i] || (EDX[4:0] > i);

For example, it's perfectly valid to have CPUID.0AH.EDX[4:0] == 3 and
CPUID.0AH.ECX == 0x77, but checking the fixed counter index against
CPUID.0AH.EDX[4:0] only, will deem that FxCtr[6:4] are not supported.

Additionally, according to the latest Intel SDM, changed the definition
of cpuidA_edx and renamed num_counters_fixed to num_contiguous_fixed.

Signed-off-by: Zide Chen <zide.chen@intel.com>
Reviewed-by: Zhenyu Wang <zhenyuw@linux.intel.com>
---
 x86/vmx_tests.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index ffe7064c9221..5261927ad2a4 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -7332,11 +7332,17 @@ union cpuidA_eax {
 	unsigned int full;
 };
 
+union cpuidA_ecx {
+	unsigned int fixed_mask;
+};
+
 union cpuidA_edx {
 	struct {
-		unsigned int num_counters_fixed:5;
+		unsigned int num_contiguous_fixed:5;
 		unsigned int bit_width_fixed:8;
-		unsigned int reserved:9;
+		unsigned int reserved1:2;
+		unsigned int anythread_deprecated:1;
+		unsigned int reserved2:16;
 	} split;
 	unsigned int full;
 };
@@ -7345,14 +7351,19 @@ static bool valid_pgc(u64 val)
 {
 	struct cpuid id;
 	union cpuidA_eax eax;
+	union cpuidA_ecx ecx;
 	union cpuidA_edx edx;
 	u64 mask;
 
 	id = cpuid(0xA);
 	eax.full = id.a;
+	ecx.fixed_mask = id.c;
 	edx.full = id.d;
+
+	/* FxCtr[i]_is_supported := ECX[i] || (EDX[4:0] > i); */
 	mask = ~(((1ull << eax.split.num_counters_gp) - 1) |
-		 (((1ull << edx.split.num_counters_fixed) - 1) << 32));
+		 (((1ull << edx.split.num_contiguous_fixed) - 1) << 32) |
+		 ((u64)ecx.fixed_mask << 32));
 
 	return !(val & mask);
 }
-- 
2.34.1


