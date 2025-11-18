Return-Path: <kvm+bounces-63474-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id C06E4C671DA
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 04:21:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 82B1E3624DE
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 03:21:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A5399328607;
	Tue, 18 Nov 2025 03:21:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JAbZM3UX"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E126630FC25
	for <kvm@vger.kernel.org>; Tue, 18 Nov 2025 03:21:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763436067; cv=none; b=k8Wh8BBCwx7eQT2mLTf29rfmvACGQmIWTAdfwWXhfd/CFeh9vuCzInLMGXcXS1XxfvMhVdj23RtiTqy1kRZP+Sj2CmZ3jDLnfz6kexdFyrDncAc5Hy7CkLlRDxV8eoySNW3/qDwbFkuYMkysy2YNxstRVwD082mbMslPsLe/Hew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763436067; c=relaxed/simple;
	bh=EiFQ+knKkDk9BKUUUsyAcXreteNsFUSkKVPkud90lxo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=fKwvGm69pGPuHUD3vG4Zp3sRumWCIkKcVOzOQYiVTLpLjZXz8/Uyl4UZtzEoj4tYVCwoBANJNkbYf09ObmCuvRIU5RGDK8ICw9LH/UwYnBicemq8srrN9ku83ogicgNtMOo7i32IKxntvq0ktpoia3/bAoWz8TZ+rIvLH9aUXbk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JAbZM3UX; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763436066; x=1794972066;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=EiFQ+knKkDk9BKUUUsyAcXreteNsFUSkKVPkud90lxo=;
  b=JAbZM3UXVJS9Te1viGo8UwCdcb/abPa7l50pVnE6CbI9fX/NrmVxbfYc
   Q/Z6c1v/3xJVCzBwYhwm0lnmHn4EtcPm1gRxpgAruBtTRN7Er7uEDKz8I
   kc7LgBehE7ebNfknLAquWgq4J/G7bhDazyi9cxOjIDcTp9AHtfEnjaWDE
   4hG5ZrwARG1Bs4KhvQlCYSrt8iZ8Sj3TCHmrCyYn1kRiCmGPdA14ae98u
   1+mPXMpAgNQGW8OZpTBp3pcUe9KcI5tntDHY5zpO0F+Cciz3P0YTfs5nW
   bV2/RSkaJ0I12+Hqu+VnjI48Kp+YhgDb62iRgJCvVJZlCtn+O0189U/y1
   Q==;
X-CSE-ConnectionGUID: ht2mulz3Qg2F1q7T2N2Bpw==
X-CSE-MsgGUID: j1MoeDsATFS8WxAnaAFNTQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11616"; a="68053869"
X-IronPort-AV: E=Sophos;i="6.19,313,1754982000"; 
   d="scan'208";a="68053869"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2025 19:21:06 -0800
X-CSE-ConnectionGUID: 56zVilAaRvSGRUFQ32iv+Q==
X-CSE-MsgGUID: 8QnPUr7LRKGCdFHene0yNQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,313,1754982000"; 
   d="scan'208";a="221537272"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.39])
  by fmviesa001.fm.intel.com with ESMTP; 17 Nov 2025 19:21:02 -0800
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
Subject: [PATCH v4 14/23] i386/cpu: Save/restore SSP0 MSR for FRED
Date: Tue, 18 Nov 2025 11:42:22 +0800
Message-Id: <20251118034231.704240-15-zhao1.liu@intel.com>
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
index f4cb1dc49b71..0432af1769d2 100644
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
@@ -1973,6 +1976,9 @@ typedef struct CPUArchState {
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


