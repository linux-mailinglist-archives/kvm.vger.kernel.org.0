Return-Path: <kvm+bounces-63469-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 543E2C671CB
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 04:21:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sin.lore.kernel.org (Postfix) with ESMTPS id AFEA529B44
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 03:21:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B18A032548A;
	Tue, 18 Nov 2025 03:20:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="EBsmRQAj"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18191328632
	for <kvm@vger.kernel.org>; Tue, 18 Nov 2025 03:20:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763436049; cv=none; b=H3U1Esl7Pxh9tLyOGIxUNmi7Fnh5bBypvtImX2DmywiyrbkFXUD870klUKZbDLhWH4fFLQp8DIZFgEYbU411LHA7VhswG1glT1gct2z6I38pXniWji+3zAlMPwsfK8+2sAPStoPgnqHoqpG5X1lYiAZeYs/2nAxw4+OH/kDNzKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763436049; c=relaxed/simple;
	bh=fJBFcQVoKmgeoUmwsBmvZdBtcnTJvhtd89N47vMSmQc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Yy+XHgT/S2voF/gKmRQUVtckY3IiPNRUQBT0MqG1pj6QJkNXLcx4mvsu4nr5kxMXLuW1uLVFa0SdOZ2wFBhg3bw/g9gCoG5wSbzDaMwuXHxkj+djqLTUZfJbyvSIr8CRFebBl/PGgaMx2pSBjoNfFlmA5L8wxVACJGv2Bug+1u8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=EBsmRQAj; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763436048; x=1794972048;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=fJBFcQVoKmgeoUmwsBmvZdBtcnTJvhtd89N47vMSmQc=;
  b=EBsmRQAjfnU0pHssFy2aVPR/pf1LpDVFIOhhB/FXSSQl5QJkt/q/GGty
   Mp+gvrQCBd64ZB8DPfBQm9gf1P1D52SVVeupBQXEjslHMC9W4N9lJ8TmI
   K7SnzrP/V/7Y7LVx+F9TkS9Hq4uUk3hwIQWN04ytBSbO/E3tqOwwpBiyE
   5TNqiTo0IpibnUI/5UzH4/oYQ6IajLteOoe2rSY2c2gbklKP9zlt4bmQL
   15hC3bL86nPtq1Ki0ffC1t3kNQYwbgTy3XjxXjPastzi+1diWyxPMVf2h
   qR4DGnTuEcrgl1GKkW0AELqCWLHo7lJByExzZAJqnxFC32as0sQsSnbN0
   Q==;
X-CSE-ConnectionGUID: aKQWhFuhTjWzM1v1P48rjA==
X-CSE-MsgGUID: mVm2qfabSQOZX08VMqsRKQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11616"; a="68053807"
X-IronPort-AV: E=Sophos;i="6.19,313,1754982000"; 
   d="scan'208";a="68053807"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2025 19:20:48 -0800
X-CSE-ConnectionGUID: eNy4ULW9SyW1mjd4plv9QQ==
X-CSE-MsgGUID: VpWYT4o1RpyXQV4OX8Lw4Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,313,1754982000"; 
   d="scan'208";a="221537190"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.39])
  by fmviesa001.fm.intel.com with ESMTP; 17 Nov 2025 19:20:44 -0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>
Cc: qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	Chao Gao <chao.gao@intel.com>,
	Xin Li <xin@zytor.com>,
	John Allen <john.allen@amd.com>,
	Babu Moger <babu.moger@amd.com>,
	Mathias Krause <minipli@grsecurity.net>,
	Dapeng Mi <dapeng1.mi@intel.com>,
	Zide Chen <zide.chen@intel.com>,
	Xiaoyao Li <xiaoyao.li@intel.com>,
	Chenyi Qiang <chenyi.qiang@intel.com>,
	Farrah Chen <farrah.chen@intel.com>,
	Zhao Liu <zhao1.liu@intel.com>
Subject: [PATCH v4 09/23] i386/cpu: Drop pmu check in CPUID 0x1C encoding
Date: Tue, 18 Nov 2025 11:42:17 +0800
Message-Id: <20251118034231.704240-10-zhao1.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251118034231.704240-1-zhao1.liu@intel.com>
References: <20251118034231.704240-1-zhao1.liu@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Since CPUID_7_0_EDX_ARCH_LBR will be masked off if pmu is disabled,
there's no need to check CPUID_7_0_EDX_ARCH_LBR feature with pmu.

Tested-by: Farrah Chen <farrah.chen@intel.com>
Reviewed-by: Zide Chen <zide.chen@intel.com>
Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
 target/i386/cpu.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index 56b4c57969c1..62769db3ebb7 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -8273,11 +8273,16 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
         }
         break;
     }
-    case 0x1C:
-        if (cpu->enable_pmu && (env->features[FEAT_7_0_EDX] & CPUID_7_0_EDX_ARCH_LBR)) {
-            x86_cpu_get_supported_cpuid(0x1C, 0, eax, ebx, ecx, edx);
-            *edx = 0;
+    case 0x1C: /* Last Branch Records Information Leaf */
+        *eax = 0;
+        *ebx = 0;
+        *ecx = 0;
+        *edx = 0;
+        if (!(env->features[FEAT_7_0_EDX] & CPUID_7_0_EDX_ARCH_LBR)) {
+            break;
         }
+        x86_cpu_get_supported_cpuid(0x1C, 0, eax, ebx, ecx, edx);
+        *edx = 0; /* EDX is reserved. */
         break;
     case 0x1D: {
         /* AMX TILE, for now hardcoded for Sapphire Rapids*/
-- 
2.34.1


