Return-Path: <kvm+bounces-60974-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 2760FC04845
	for <lists+kvm@lfdr.de>; Fri, 24 Oct 2025 08:35:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B2C5E1A07D57
	for <lists+kvm@lfdr.de>; Fri, 24 Oct 2025 06:36:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 39001273D6C;
	Fri, 24 Oct 2025 06:35:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="EGapQkRe"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D84A223F422
	for <kvm@vger.kernel.org>; Fri, 24 Oct 2025 06:35:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761287735; cv=none; b=pyjh+XFFSUQ8ZSwDCBn01bdyaa3kxA8zsGcXKkDNCEyP6wEgPVh6NUh7zbbl4VjFgW74p3EJPJ+zl6rp0wShhCmYdrfH8mMjkXLvdf7uIfqOM8S1gUehex7ZazyXcHsTOm733LGBFUaq2L+iu6dbCzUw9bWFkEbyHA8AsWncvnM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761287735; c=relaxed/simple;
	bh=J041AyqDu393CENrSjsYGiKHkAgugONGgNt6ugUkk3A=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ZFFdBKeFDgu1yh4WJTUlrVdxd1sjbwv6tw8FWQgpxUHURx3gHK9OLGBN8+Vf7r20xNizF0h3VbJgDxPzAj5IEutr/ssmxiEhNUqhL/zLHookr2gAQqV1uaH+6pwo0Fbrhc6mAmIxqHTkkBHYaQ5Nrf7fDhwwGsw4cqAt5qEg54w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=EGapQkRe; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761287734; x=1792823734;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=J041AyqDu393CENrSjsYGiKHkAgugONGgNt6ugUkk3A=;
  b=EGapQkReXCKGSgKdhdxae47ogMQFBtfI3fNjBt1z6GKTl9h9pJKGbOUi
   ZaC1bKwT9ktQhaB+eEATqpqW/PGyD+PFku1pqu3tidbOVWXLOaRh73hxq
   wA1XAKpIWyoV4cw4/TgTxqoKzynd7DQ/MbqURtiDXrfqQwDatkF4jkfw+
   KTY0Sl0TWQ0tiL7E2TUeh/wGNSfXBs1N6tcYNCLJj3N6D1ZRQsTh0StRD
   b0Tiw1BNOPiD6G8LjUeqQ/cr4C3qJywNTytNitqop4+3qtEpLj7I1IR0k
   emPi6OFGR/z84TNx7K6U1xvAOGHCjWldIl8gVYVzWHNHSdjmCXEweOQdy
   w==;
X-CSE-ConnectionGUID: HI2R+O4aTvqFKL9bH2hOwg==
X-CSE-MsgGUID: /FLAE9meT2mwSOd0BUGafg==
X-IronPort-AV: E=McAfee;i="6800,10657,11586"; a="62675693"
X-IronPort-AV: E=Sophos;i="6.19,251,1754982000"; 
   d="scan'208";a="62675693"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Oct 2025 23:35:32 -0700
X-CSE-ConnectionGUID: Ha6JoebcTaezDh11zjjpDA==
X-CSE-MsgGUID: aNZv1DHrSRy9ZHsUbcgWgg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,251,1754982000"; 
   d="scan'208";a="184276097"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.39])
  by fmviesa006.fm.intel.com with ESMTP; 23 Oct 2025 23:35:24 -0700
From: Zhao Liu <zhao1.liu@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>
Cc: qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	Chao Gao <chao.gao@intel.com>,
	John Allen <john.allen@amd.com>,
	Babu Moger <babu.moger@amd.com>,
	Mathias Krause <minipli@grsecurity.net>,
	Dapeng Mi <dapeng1.mi@intel.com>,
	Zide Chen <zide.chen@intel.com>,
	Chenyi Qiang <chenyi.qiang@intel.com>,
	Xiaoyao Li <xiaoyao.li@intel.com>,
	Farrah Chen <farrah.chen@intel.com>,
	Zhao Liu <zhao1.liu@intel.com>,
	Yang Weijiang <weijiang.yang@intel.com>
Subject: [PATCH v3 13/20] i386/kvm: Add save/load support for CET MSRs
Date: Fri, 24 Oct 2025 14:56:25 +0800
Message-Id: <20251024065632.1448606-14-zhao1.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251024065632.1448606-1-zhao1.liu@intel.com>
References: <20251024065632.1448606-1-zhao1.liu@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Yang Weijiang <weijiang.yang@intel.com>

CET (architectural) MSRs include:
MSR_IA32_U_CET - user mode CET control bits.
MSR_IA32_S_CET - supervisor mode CET control bits.
MSR_IA32_PL{0,1,2,3}_SSP - linear addresses of SSPs for user/kernel modes.
MSR_IA32_SSP_TBL_ADDR - linear address of interrupt SSP table

Tested-by: Farrah Chen <farrah.chen@intel.com>
Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
Co-developed-by: Chao Gao <chao.gao@intel.com>
Signed-off-by: Chao Gao <chao.gao@intel.com>
Co-developed-by: Zhao Liu <zhao1.liu@intel.com>
Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
Changes Since v2:
 - Rename MSR_IA32_SSP_TBL_ADDR to MSR_IA32_INT_SSP_TAB.
 - Rename X86CPUState.ssp_table_addr to X86CPUState.int_ssp_table.
 - Drop X86CPUStete.guest_ssp since it is not used in current commit.
 - Do not check CET-S & CET-U xtates when get/set MSTs since CET
   is XSAVE-managed feature but is not XSAVE-enabled.
---
 target/i386/cpu.h     | 16 +++++++++++
 target/i386/kvm/kvm.c | 64 +++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 80 insertions(+)

diff --git a/target/i386/cpu.h b/target/i386/cpu.h
index 86fbfd5e4023..4edb977575e2 100644
--- a/target/i386/cpu.h
+++ b/target/i386/cpu.h
@@ -580,6 +580,14 @@ typedef enum X86Seg {
 #define MSR_APIC_START                  0x00000800
 #define MSR_APIC_END                    0x000008ff
 
+#define MSR_IA32_U_CET                  0x000006a0       /* user mode cet */
+#define MSR_IA32_S_CET                  0x000006a2       /* kernel mode cet */
+#define MSR_IA32_PL0_SSP                0x000006a4       /* ring-0 shadow stack pointer */
+#define MSR_IA32_PL1_SSP                0x000006a5       /* ring-1 shadow stack pointer */
+#define MSR_IA32_PL2_SSP                0x000006a6       /* ring-2 shadow stack pointer */
+#define MSR_IA32_PL3_SSP                0x000006a7       /* ring-3 shadow stack pointer */
+#define MSR_IA32_INT_SSP_TAB            0x000006a8       /* exception shadow stack table */
+
 #define XSTATE_FP_BIT                   0
 #define XSTATE_SSE_BIT                  1
 #define XSTATE_YMM_BIT                  2
@@ -2090,6 +2098,14 @@ typedef struct CPUArchState {
     uint64_t msr_rapl_power_unit;
     uint64_t msr_pkg_energy_status;
 
+    uint64_t u_cet;
+    uint64_t s_cet;
+    uint64_t pl0_ssp;
+    uint64_t pl1_ssp;
+    uint64_t pl2_ssp;
+    uint64_t pl3_ssp;
+    uint64_t int_ssp_table;
+
     /* Fields up to this point are cleared by a CPU reset */
     struct {} end_reset_fields;
 
diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index f7a6ef650af7..92c2fd6d6aee 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -4255,6 +4255,28 @@ static int kvm_put_msrs(X86CPU *cpu, KvmPutState level)
         }
     }
 
+    if (env->features[FEAT_7_0_ECX] & CPUID_7_0_ECX_CET_SHSTK ||
+        env->features[FEAT_7_0_EDX] & CPUID_7_0_EDX_CET_IBT) {
+        kvm_msr_entry_add(cpu, MSR_IA32_U_CET, env->u_cet);
+        kvm_msr_entry_add(cpu, MSR_IA32_S_CET, env->s_cet);
+
+        if (env->features[FEAT_7_0_ECX] & CPUID_7_0_ECX_CET_SHSTK) {
+            kvm_msr_entry_add(cpu, MSR_IA32_PL0_SSP, env->pl0_ssp);
+            kvm_msr_entry_add(cpu, MSR_IA32_PL1_SSP, env->pl1_ssp);
+            kvm_msr_entry_add(cpu, MSR_IA32_PL2_SSP, env->pl2_ssp);
+            kvm_msr_entry_add(cpu, MSR_IA32_PL3_SSP, env->pl3_ssp);
+
+            /*
+             * This MSR is not present on processors that do not support
+             * Intel 64 architecture.
+             */
+            if (env->features[FEAT_8000_0001_EDX] & CPUID_EXT2_LM) {
+                kvm_msr_entry_add(cpu, MSR_IA32_INT_SSP_TAB,
+                                  env->int_ssp_table);
+            }
+        }
+    }
+
     return kvm_buf_set_msrs(cpu);
 }
 
@@ -4646,6 +4668,27 @@ static int kvm_get_msrs(X86CPU *cpu)
         }
     }
 
+    if (env->features[FEAT_7_0_ECX] & CPUID_7_0_ECX_CET_SHSTK ||
+        env->features[FEAT_7_0_EDX] & CPUID_7_0_EDX_CET_IBT) {
+        kvm_msr_entry_add(cpu, MSR_IA32_U_CET, 0);
+        kvm_msr_entry_add(cpu, MSR_IA32_S_CET, 0);
+
+        if (env->features[FEAT_7_0_EDX] & CPUID_7_0_ECX_CET_SHSTK) {
+            kvm_msr_entry_add(cpu, MSR_IA32_PL0_SSP, 0);
+            kvm_msr_entry_add(cpu, MSR_IA32_PL1_SSP, 0);
+            kvm_msr_entry_add(cpu, MSR_IA32_PL2_SSP, 0);
+            kvm_msr_entry_add(cpu, MSR_IA32_PL3_SSP, 0);
+
+            /*
+             * This MSR is not present on processors that do not support
+             * Intel 64 architecture.
+             */
+            if (env->features[FEAT_8000_0001_EDX] & CPUID_EXT2_LM) {
+                kvm_msr_entry_add(cpu, MSR_IA32_INT_SSP_TAB, 0);
+            }
+        }
+    }
+
     ret = kvm_vcpu_ioctl(CPU(cpu), KVM_GET_MSRS, cpu->kvm_msr_buf);
     if (ret < 0) {
         return ret;
@@ -4993,6 +5036,27 @@ static int kvm_get_msrs(X86CPU *cpu)
         case MSR_ARCH_LBR_INFO_0 ... MSR_ARCH_LBR_INFO_0 + 31:
             env->lbr_records[index - MSR_ARCH_LBR_INFO_0].info = msrs[i].data;
             break;
+        case MSR_IA32_U_CET:
+            env->u_cet = msrs[i].data;
+            break;
+        case MSR_IA32_S_CET:
+            env->s_cet = msrs[i].data;
+            break;
+        case MSR_IA32_PL0_SSP:
+            env->pl0_ssp = msrs[i].data;
+            break;
+        case MSR_IA32_PL1_SSP:
+            env->pl1_ssp = msrs[i].data;
+            break;
+        case MSR_IA32_PL2_SSP:
+            env->pl2_ssp = msrs[i].data;
+            break;
+        case MSR_IA32_PL3_SSP:
+            env->pl3_ssp = msrs[i].data;
+            break;
+        case MSR_IA32_INT_SSP_TAB:
+            env->int_ssp_table = msrs[i].data;
+            break;
         case MSR_K7_HWCR:
             env->msr_hwcr = msrs[i].data;
             break;
-- 
2.34.1


