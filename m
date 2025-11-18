Return-Path: <kvm+bounces-63467-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 4F2D3C671C5
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 04:20:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 09F79362398
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 03:20:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 02867329361;
	Tue, 18 Nov 2025 03:20:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GPkUAAzt"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C27F31C597
	for <kvm@vger.kernel.org>; Tue, 18 Nov 2025 03:20:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763436042; cv=none; b=inGiIqfCqMzAsuibwPNz4B63YXtOW/0iQDNtLz6QCjDZMqSxjYk1nJkspnDoLnhue2+C4PLueLiFZxYt+XyseCBbr+UYyGejJJlS3jmXp+voA1xvDXllG2S0lO83hLTMCyHlM66BZNqrTbFtVkApbP/N7NHq6jcc38vFFltdATU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763436042; c=relaxed/simple;
	bh=sPgQ6HV3cQvKboeym46NGXGdw3g89C4CiandiaMUJkA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Rq5SA41wQZstA+LH9X1TCijfnS29eRepnGh0b2HLbAKSrgVl8uPas7tinTYVPKXXbRMLwvqqfaY8MiKGz9LfMMiTQdKT8ZxKmzXbi7935mZjMfCNVYfoEwjoekGeOwgY/HjAKFM/J0vSBX5V7yA69Au78Ph1JBOshwo1Ix1cWMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=GPkUAAzt; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763436041; x=1794972041;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=sPgQ6HV3cQvKboeym46NGXGdw3g89C4CiandiaMUJkA=;
  b=GPkUAAzt2qucF5tlE9fpKpxGLkArZYnWFWYjdqT3crNHxZwqDPt1KJMb
   uX5tivW5SF6tIzG8Brfs0n7liZfq4TO7E6N4Gk9bmr4TOF4T0m61kFqoc
   lAs1cRQvu3uE49ZYEj4ac37dX8LCrqqlXIUPdnzzzDXg6AFByZut1GMa7
   h9vXA4tYoiNEdyb8mt5G75cF4Y6yv9YUi4hLDzLHUR/agYiU2V6/ahj9P
   M/WvwKiySZ+gSGPKdF1pgLFWRjnTm67tTtyAYMfU7bcTmGXTfM0xIPt5K
   TDQYAmy1i2njfCx2WPui8eBYgdpOcKKORE1P4ihMQBTElRAf8jgQSvbWm
   Q==;
X-CSE-ConnectionGUID: +CxOQLoYThm+FKT2DtW4oQ==
X-CSE-MsgGUID: t4HHgsMwR3evqPPv5N5JyA==
X-IronPort-AV: E=McAfee;i="6800,10657,11616"; a="68053786"
X-IronPort-AV: E=Sophos;i="6.19,313,1754982000"; 
   d="scan'208";a="68053786"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2025 19:20:41 -0800
X-CSE-ConnectionGUID: hPrQoh4mR9CkxfFu66VihQ==
X-CSE-MsgGUID: kMHQ5/8FR7iaD6GvwOPUqQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,313,1754982000"; 
   d="scan'208";a="221537178"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.39])
  by fmviesa001.fm.intel.com with ESMTP; 17 Nov 2025 19:20:38 -0800
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
Subject: [PATCH v4 07/23] i386/cpu: Use x86_ext_save_areas[] for CPUID.0XD subleaves
Date: Tue, 18 Nov 2025 11:42:15 +0800
Message-Id: <20251118034231.704240-8-zhao1.liu@intel.com>
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

The x86_ext_save_areas[] is expected to be well initialized by
accelerators and its xstate detail information cannot be changed by
user. So use x86_ext_save_areas[] to encode CPUID.0XD subleaves directly
without other hardcoding & masking.

And for arch LBR case, since its entry in x86_ext_save_areas[] has been
initialized based KVM support in kvm_cpu_xsave_init(), so use
x86_ext_save_areas[] for encoding.

Tested-by: Farrah Chen <farrah.chen@intel.com>
Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
Changes Since v3:
 - New commit.
---
 target/i386/cpu.c | 19 ++++++++-----------
 1 file changed, 8 insertions(+), 11 deletions(-)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index 70a282668f72..f3bf7f892214 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -8188,20 +8188,17 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
             }
         } else if (count == 0xf && cpu->enable_pmu
                    && (env->features[FEAT_7_0_EDX] & CPUID_7_0_EDX_ARCH_LBR)) {
-            x86_cpu_get_supported_cpuid(0xD, count, eax, ebx, ecx, edx);
+            const ExtSaveArea *esa = &x86_ext_save_areas[count];
+
+            *eax = esa->size;
+            *ebx = esa->offset;
+            *ecx = esa->ecx;
         } else if (count < ARRAY_SIZE(x86_ext_save_areas)) {
             const ExtSaveArea *esa = &x86_ext_save_areas[count];
 
-            if (x86_cpu_xsave_xcr0_components(cpu) & (1ULL << count)) {
-                *eax = esa->size;
-                *ebx = esa->offset;
-                *ecx = esa->ecx &
-                       (ESA_FEATURE_ALIGN64_MASK | ESA_FEATURE_XFD_MASK);
-            } else if (x86_cpu_xsave_xss_components(cpu) & (1ULL << count)) {
-                *eax = esa->size;
-                *ebx = 0;
-                *ecx = 1;
-            }
+            *eax = esa->size;
+            *ebx = esa->offset;
+            *ecx = esa->ecx;
         }
         break;
     }
-- 
2.34.1


