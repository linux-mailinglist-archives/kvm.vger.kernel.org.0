Return-Path: <kvm+bounces-65706-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id D14E5CB4CFF
	for <lists+kvm@lfdr.de>; Thu, 11 Dec 2025 06:51:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 75545300EE42
	for <lists+kvm@lfdr.de>; Thu, 11 Dec 2025 05:51:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B411129D26D;
	Thu, 11 Dec 2025 05:44:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LfBvhv9t"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 851EA299928
	for <kvm@vger.kernel.org>; Thu, 11 Dec 2025 05:44:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765431855; cv=none; b=KxW/H6sQesO44amUz9GyyNRgtmHS9AtEhtGv4sy8slGSnmjbSee6aTHGMb8E0u/4SJsC3KrJbOCplTX+Hp4egPc9pCpW65JFmchd/VMMdTh+UYbx2ruGoBRIfhYG/VId7PlPYWjx0z8cBzKi0fRFkLdtSrArLqDWTVlal0lgtM8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765431855; c=relaxed/simple;
	bh=MoFwaE7HCu9hCP09pscNetCaYn3cG1uOpKDAv/wkIAM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=QowGBge0F33CBHByoFkJhjYItB5lHoPK9GlSceDBmuttzaQ7BH0HDE5ut6ekYULFOthyfoQmlE52U/1hQRRx7qvWDy08PyMcBOSvccz/RauGXf2Z8fcfqDYIFckKaE4OwXaqlWltBSA3Vu34IhTwbgsB9ZjkXNpmAR1s3VZArUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LfBvhv9t; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765431854; x=1796967854;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=MoFwaE7HCu9hCP09pscNetCaYn3cG1uOpKDAv/wkIAM=;
  b=LfBvhv9td1zupmBJEzZNN3OWzksJhQj+O2fM1UzNeBnmQjeqfLLvkF3t
   KuhEkfWHgbbw4+eCE/iqMguURfiZAIfuJeK0k29fuwapIUvKBSKFle2ad
   tqxnnrWIuqv767YyVp79Y7G0mvDUuWaylxr8xdBkkjEccZEGrZZ0Mk+/U
   rNQL+BY7D5JjJfbqPIvyoZR08EPNlVAcxWOoCqcOIzE/cLoQTInjQAFxG
   ODUK3O6NVhooEt0DbeBmYimzhs5cO9t7jajoTEcHUiu9U8icdNekwIFO8
   vAlzviqrTcvKZnvLq9h6iXrTDTC3TeNJb1CLFs22e/g6FowK+jNVfB13n
   w==;
X-CSE-ConnectionGUID: z+tQGdwOT0idVGJRk3F10g==
X-CSE-MsgGUID: hShRorFORGSmyeS8j7MEVQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11638"; a="66409925"
X-IronPort-AV: E=Sophos;i="6.20,265,1758610800"; 
   d="scan'208";a="66409925"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Dec 2025 21:44:14 -0800
X-CSE-ConnectionGUID: SviPlzvqQHKVfZiY+MWIxA==
X-CSE-MsgGUID: tDQ4DGX+RY2hBQ0RgCnhHw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,265,1758610800"; 
   d="scan'208";a="227366140"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.39])
  by orviesa002.jf.intel.com with ESMTP; 10 Dec 2025 21:44:08 -0800
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
Subject: [PATCH v5 13/22] i386/cpu: Save/restore SSP0 MSR for FRED
Date: Thu, 11 Dec 2025 14:07:52 +0800
Message-Id: <20251211060801.3600039-14-zhao1.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251211060801.3600039-1-zhao1.liu@intel.com>
References: <20251211060801.3600039-1-zhao1.liu@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Xin Li (Intel)" <xin@zytor.com>

Both FRED and CET shadow stack define the MSR MSR_IA32_PL0_SSP (aka
MSR_IA32_FRED_SSP0 in FRED spec).

MSR_IA32_PL0_SSP is a FRED SSP MSR, so that if a processor doesn't
support CET shadow stack, FRED transitions won't use MSR_IA32_PL0_SSP,
but this MSR would still be accessible using MSR-access instructions
(e.g., RDMSR, WRMSR).

Therefore, save/restore SSP0 MSR for FRED.

Tested-by: Farrah Chen <farrah.chen@intel.com>
Signed-off-by: Xin Li (Intel) <xin@zytor.com>
Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
Changes Since v3:
 - New commit.
---
 target/i386/cpu.h     |  6 ++++++
 target/i386/kvm/kvm.c | 13 +++++++++++++
 2 files changed, 19 insertions(+)

diff --git a/target/i386/cpu.h b/target/i386/cpu.h
index a1ff2ceb0c38..84e5cf0ab0c1 100644
--- a/target/i386/cpu.h
+++ b/target/i386/cpu.h
@@ -554,6 +554,9 @@ typedef enum X86Seg {
 #define MSR_IA32_FRED_SSP3              0x000001d3       /* Stack level 3 shadow stack pointer in ring 0 */
 #define MSR_IA32_FRED_CONFIG            0x000001d4       /* FRED Entrypoint and interrupt stack level */
 
+/* FRED and CET MSR */
+#define MSR_IA32_PL0_SSP                0x000006a4       /* ring-0 shadow stack pointer (aka MSR_IA32_FRED_SSP0 for FRED) */
+
 #define MSR_IA32_BNDCFGS                0x00000d90
 #define MSR_IA32_XSS                    0x00000da0
 #define MSR_IA32_UMWAIT_CONTROL         0xe1
@@ -1970,6 +1973,9 @@ typedef struct CPUArchState {
     uint64_t fred_config;
 #endif
 
+    /* MSR used for both FRED and CET (SHSTK) */
+    uint64_t pl0_ssp;
+
     uint64_t tsc_adjust;
     uint64_t tsc_deadline;
     uint64_t tsc_aux;
diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index 60c798113823..00fead0827ed 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -4008,6 +4008,11 @@ static int kvm_put_msrs(X86CPU *cpu, KvmPutState level)
             kvm_msr_entry_add(cpu, MSR_IA32_FRED_SSP2, env->fred_ssp2);
             kvm_msr_entry_add(cpu, MSR_IA32_FRED_SSP3, env->fred_ssp3);
             kvm_msr_entry_add(cpu, MSR_IA32_FRED_CONFIG, env->fred_config);
+            /*
+             * Aka MSR_IA32_FRED_SSP0. This MSR is accessible even if
+             * CET shadow stack is not supported.
+             */
+            kvm_msr_entry_add(cpu, MSR_IA32_PL0_SSP, env->pl0_ssp);
         }
     }
 #endif
@@ -4495,6 +4500,11 @@ static int kvm_get_msrs(X86CPU *cpu)
             kvm_msr_entry_add(cpu, MSR_IA32_FRED_SSP2, 0);
             kvm_msr_entry_add(cpu, MSR_IA32_FRED_SSP3, 0);
             kvm_msr_entry_add(cpu, MSR_IA32_FRED_CONFIG, 0);
+            /*
+             * Aka MSR_IA32_FRED_SSP0. This MSR is accessible even if
+             * CET shadow stack is not supported.
+             */
+            kvm_msr_entry_add(cpu, MSR_IA32_PL0_SSP, 0);
         }
     }
 #endif
@@ -4746,6 +4756,9 @@ static int kvm_get_msrs(X86CPU *cpu)
         case MSR_IA32_FRED_CONFIG:
             env->fred_config = msrs[i].data;
             break;
+        case MSR_IA32_PL0_SSP: /* aka MSR_IA32_FRED_SSP0 */
+            env->pl0_ssp = msrs[i].data;
+            break;
 #endif
         case MSR_IA32_TSC:
             env->tsc = msrs[i].data;
-- 
2.34.1


