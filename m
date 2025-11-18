Return-Path: <kvm+bounces-63466-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id D9DCBC671C2
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 04:20:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by tor.lore.kernel.org (Postfix) with ESMTPS id 453E629D4D
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 03:20:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3CA6432862D;
	Tue, 18 Nov 2025 03:20:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="R1COJY13"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF3C4328B4F
	for <kvm@vger.kernel.org>; Tue, 18 Nov 2025 03:20:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763436039; cv=none; b=cs8UPpVUCVo89ryvZO2/KYBs90kfXTa3QxD9fm7hKZgQsEaLoMLWIMeh2IIHtzM2ti7HtgxpAVVPh1wlZbnyrlGA/ZcMJAHdf2lzo50xuqxVQ/AuX5CCORoolKjjiPSUDyHl5lzBTuLVpLwxSc+WI6Z5AhTurhXpwBvmvTiHWFg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763436039; c=relaxed/simple;
	bh=itRs9sDLTa1KpZpW5WfGEJxQx/1ikIuO3q3OzD0yhqQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=oH8JujacPKEA5iZbfXVxiTVIMWXRJ1iUpLuJluKPB0pxb91v4lLe14toKwJZpnoM3nJMqTcP031g6wyqEIbo3/KHJdXSTAD8wKavJvoivFiqN34NIvy1B0qGYdBZol1i6vo1BVSaJ2c9N6B2zPHj+0e7elya4g3zVisJyNeZKDY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=R1COJY13; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763436038; x=1794972038;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=itRs9sDLTa1KpZpW5WfGEJxQx/1ikIuO3q3OzD0yhqQ=;
  b=R1COJY13QBjfQ16HSOZ75/1uoe8Q3R9T0/xV8zank+0OyHVOgh579bT3
   4RIfk7zBDTHt/K9CoYMKFi1zYThrU4OIEuxji68NOtGM9gm8a9xhZvVca
   Pib2mllADbXW/KunFGZpER7fD/x5vK7RqnuF83amTgl2p/eMStElyJgTs
   ByRe0WFdJ33UuH/rDBRGzPJiz12sjiq8a9vrmqOg7qZVUQUCEdZkLm6eH
   zzDIL51zMj8UWuNSkHDky3gcIrYnOVay2cUpCFNtWqBymhLGbIKEthFP2
   izQDjc7fyx1hRj7ck+oSOAN34Qc9irg7sLJWL0dioQJwp86D5JCSbc2gd
   g==;
X-CSE-ConnectionGUID: 5TOPclK1SO2lNOQQbwYMkw==
X-CSE-MsgGUID: esczzmi0QFeYKn0bIkdIig==
X-IronPort-AV: E=McAfee;i="6800,10657,11616"; a="68053777"
X-IronPort-AV: E=Sophos;i="6.19,313,1754982000"; 
   d="scan'208";a="68053777"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2025 19:20:38 -0800
X-CSE-ConnectionGUID: +RhnrtYQTviyFlq2NTlZug==
X-CSE-MsgGUID: 2T4g6T12T0uBMeJ7MFDFzA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,313,1754982000"; 
   d="scan'208";a="221537175"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.39])
  by fmviesa001.fm.intel.com with ESMTP; 17 Nov 2025 19:20:34 -0800
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
Subject: [PATCH v4 06/23] i386/kvm: Initialize x86_ext_save_areas[] based on KVM support
Date: Tue, 18 Nov 2025 11:42:14 +0800
Message-Id: <20251118034231.704240-7-zhao1.liu@intel.com>
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

At present, in KVM, x86_ext_save_areas[] is initialized based on Host
CPUIDs.

Except AMX xstates, both user & supervisor xstates have their
information exposed in KVM_GET_SUPPORTED_CPUID. Therefore, their entries
in x86_ext_save_areas[] should be filled based on KVM support.

For AMX xstates (XFEATURE_MASK_XTILE_DATA and XFEATURE_MASK_XTILE_CFG),
KVM doesn't report their details before they (mainly
XSTATE_XTILE_DATA_MASK) get permission on host. But this happens within
the function kvm_request_xsave_components(), after the current
initialization. So still fill AMX entries with Host CPUIDs.

In addition, drop a check: "if (eax != 0)" when assert the assert the
size of xstate. In fact, this check is incorrect, since any valid
xstate should have non-zero size of xstate area.

Tested-by: Farrah Chen <farrah.chen@intel.com>
Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
Changes Since v3:
 - New commit.
---
 target/i386/cpu.h         |  3 +++
 target/i386/kvm/kvm-cpu.c | 23 +++++++++++++++++------
 2 files changed, 20 insertions(+), 6 deletions(-)

diff --git a/target/i386/cpu.h b/target/i386/cpu.h
index 3d74afc5a8e7..f065527757c4 100644
--- a/target/i386/cpu.h
+++ b/target/i386/cpu.h
@@ -609,6 +609,9 @@ typedef enum X86Seg {
 
 #define XSTATE_DYNAMIC_MASK             (XSTATE_XTILE_DATA_MASK)
 
+#define XSTATE_XTILE_MASK               (XSTATE_XTILE_DATA_MASK | \
+                                         XSTATE_XTILE_CFG_MASK)
+
 #define ESA_FEATURE_ALIGN64_BIT         1
 #define ESA_FEATURE_XFD_BIT             2
 
diff --git a/target/i386/kvm/kvm-cpu.c b/target/i386/kvm/kvm-cpu.c
index 9c25b5583955..2e2d47d2948a 100644
--- a/target/i386/kvm/kvm-cpu.c
+++ b/target/i386/kvm/kvm-cpu.c
@@ -136,7 +136,7 @@ static void kvm_cpu_max_instance_init(X86CPU *cpu)
 static void kvm_cpu_xsave_init(void)
 {
     static bool first = true;
-    uint32_t eax, ebx, ecx, edx;
+    uint32_t eax, ebx, ecx, unused;
     int i;
 
     if (!first) {
@@ -154,12 +154,23 @@ static void kvm_cpu_xsave_init(void)
         if (!esa->size) {
             continue;
         }
-        host_cpuid(0xd, i, &eax, &ebx, &ecx, &edx);
-        if (eax != 0) {
-            assert(esa->size == eax);
-            esa->offset = ebx;
-            esa->ecx = ecx;
+
+        /*
+         * AMX xstates are supported in KVM_GET_SUPPORTED_CPUID only when
+         * XSTATE_XTILE_DATA_MASK gets guest permission in
+         * kvm_request_xsave_components().
+         */
+        if (!((1 << i) & XSTATE_XTILE_MASK)) {
+            eax = kvm_arch_get_supported_cpuid(kvm_state, 0xd, i, R_EAX);
+            ebx = kvm_arch_get_supported_cpuid(kvm_state, 0xd, i, R_EBX);
+            ecx = kvm_arch_get_supported_cpuid(kvm_state, 0xd, i, R_ECX);
+        } else {
+            host_cpuid(0xd, i, &eax, &ebx, &ecx, &unused);
         }
+
+        assert(esa->size == eax);
+        esa->offset = ebx;
+        esa->ecx = ecx;
     }
 }
 
-- 
2.34.1


