Return-Path: <kvm+bounces-7924-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4478D8484EE
	for <lists+kvm@lfdr.de>; Sat,  3 Feb 2024 10:17:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B0532B2B340
	for <lists+kvm@lfdr.de>; Sat,  3 Feb 2024 09:17:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7BC085D72E;
	Sat,  3 Feb 2024 09:17:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OxUcNdp3"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADA685CDC9
	for <kvm@vger.kernel.org>; Sat,  3 Feb 2024 09:17:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706951851; cv=none; b=NtbOEhEa9xWZVOJkL1+A6nzqYQHG7kgbWTpTothAq8ikgyl66KO9LHZcO1GbK9ZD/hmqwOKz/8tFzsYNTpcgkJQg2RvnHKTHi3NaUbadBVH4q7QtPsdbyof9MmXd+U/oTZ+XP9VwQDdH4lEVxyNhTU9BLGvA9i1bUDsAzCFYDY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706951851; c=relaxed/simple;
	bh=An89nTsf2RBLksmwt0+NzzeKNYWSam6kADPQj32WHLQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=DfLBRjdQw1MMOcXL3M6BQERo0mKmaqi7DmElCF88s/lnVQb6Z2AHYkGRmqO7JHfXOpIWMuQRQj0nYKmjJ/U3PArR6ZNO8hPsvZo8dKxrqTIjxPwo++8JVQW28Zr8ztjjQuixareOKLyxGMXuunxBDEDan0EBp4+SEutsmsS5G6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OxUcNdp3; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706951850; x=1738487850;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=An89nTsf2RBLksmwt0+NzzeKNYWSam6kADPQj32WHLQ=;
  b=OxUcNdp33b6ni75sJ1QCcKJvGZsyNWMGqJs1+m9+OkjsECczXSzMa9sC
   bL9iilXmAh66YlewZA+izPy4dXpwtLkn9fbC6mE5Ly9OyW08ardj2RfFj
   NuAywQiZRwLqfmuz5TsGyOSrDsNpPd8UUcMBh5URzD3zzy7kxArtkfvzV
   gYo9zQzI2J/+mhPVj4WAAGj9gl/R3/muK9rTjGNmQYYI57OZEztaKwhrG
   gHZGFmPNBBqC5IEVV5C9z/lQMG/2bAf2DjnwYOACs30HORUTexioGDdy5
   VCp/dtsadXQFRyTVPoV5/uwX21B4dg8lXOagalnai3b+Jr2941vKW5O06
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10971"; a="216354"
X-IronPort-AV: E=Sophos;i="6.05,240,1701158400"; 
   d="scan'208";a="216354"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2024 01:17:29 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,240,1701158400"; 
   d="scan'208";a="31378978"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.36])
  by fmviesa001.fm.intel.com with ESMTP; 03 Feb 2024 01:17:26 -0800
From: Zhao Liu <zhao1.liu@linux.intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	qemu-devel@nongnu.org,
	kvm@vger.kernel.org
Cc: Zhenyu Wang <zhenyu.z.wang@intel.com>,
	Zhuocheng Ding <zhuocheng.ding@intel.com>,
	Dapeng Mi <dapeng1.mi@intel.com>,
	Yanting Jiang <yanting.jiang@intel.com>,
	Yongwei Ma <yongwei.ma@intel.com>,
	Zhao Liu <zhao1.liu@intel.com>
Subject: [RFC 1/6] target/i386: Add support for save/load of ACPI thermal MSRs
Date: Sat,  3 Feb 2024 17:30:49 +0800
Message-Id: <20240203093054.412135-2-zhao1.liu@linux.intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240203093054.412135-1-zhao1.liu@linux.intel.com>
References: <20240203093054.412135-1-zhao1.liu@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Zhuocheng Ding <zhuocheng.ding@intel.com>

The CPUID_ACPI (CPUID.0x01.edx[bit 22]) feature bit has been
introduced as the TCG feature. Currently, based on KVM's ACPI emulation,
add related ACPI support in QEMU.

From SDM [1], ACPI feature means:

"The ACPI flag (bit 22) of the CPUID feature flags indicates the
presence of the IA32_THERM_STATUS, IA32_THERM_INTERRUPT,
IA32_CLOCK_MODULATION MSRs, and the xAPIC thermal LVT entry."

With the emulation of ACPI in KVM, add the support for save/load of ACPI
thermal MSRs: MSR_IA32_THERM_CONTROL, MSR_IA32_THERM_INTERRUPT and
MSR_IA32_THERM_STATUS.

[1]: SDM, vol. 3B, section 15.8.4.1, Detection of Software Controlled
     Clock Modulation Extension.

Tested-by: Yanting Jiang <yanting.jiang@intel.com>
Signed-off-by: Zhuocheng Ding <zhuocheng.ding@intel.com>
Co-developed-by: Zhao Liu <zhao1.liu@intel.com>
Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
 target/i386/cpu.h     |  9 +++++++++
 target/i386/kvm/kvm.c | 25 +++++++++++++++++++++++++
 2 files changed, 34 insertions(+)

diff --git a/target/i386/cpu.h b/target/i386/cpu.h
index 7f0786e8b98f..e453b3f010e2 100644
--- a/target/i386/cpu.h
+++ b/target/i386/cpu.h
@@ -526,6 +526,10 @@ typedef enum X86Seg {
 #define MSR_IA32_XSS                    0x00000da0
 #define MSR_IA32_UMWAIT_CONTROL         0xe1
 
+#define MSR_IA32_THERM_CONTROL          0x0000019a
+#define MSR_IA32_THERM_INTERRUPT        0x0000019b
+#define MSR_IA32_THERM_STATUS           0x0000019c
+
 #define MSR_IA32_VMX_BASIC              0x00000480
 #define MSR_IA32_VMX_PINBASED_CTLS      0x00000481
 #define MSR_IA32_VMX_PROCBASED_CTLS     0x00000482
@@ -1758,6 +1762,11 @@ typedef struct CPUArchState {
     uint64_t msr_lbr_depth;
     LBREntry lbr_records[ARCH_LBR_NR_ENTRIES];
 
+    /* Per-VCPU thermal MSRs */
+    uint64_t therm_control;
+    uint64_t therm_interrupt;
+    uint64_t therm_status;
+
     /* exception/interrupt handling */
     int error_code;
     int exception_is_int;
diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index 76a66246eb72..3bf57b35bfcd 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -138,6 +138,7 @@ static bool has_msr_ucode_rev;
 static bool has_msr_vmx_procbased_ctls2;
 static bool has_msr_perf_capabs;
 static bool has_msr_pkrs;
+static bool has_msr_therm;
 
 static uint32_t has_architectural_pmu_version;
 static uint32_t num_architectural_pmu_gp_counters;
@@ -2455,6 +2456,11 @@ static int kvm_get_supported_msrs(KVMState *s)
             case MSR_IA32_PKRS:
                 has_msr_pkrs = true;
                 break;
+            case MSR_IA32_THERM_CONTROL:
+            case MSR_IA32_THERM_INTERRUPT:
+            case MSR_IA32_THERM_STATUS:
+                has_msr_therm = true;
+                break;
             }
         }
     }
@@ -3302,6 +3308,11 @@ static int kvm_put_msrs(X86CPU *cpu, int level)
     if (has_msr_virt_ssbd) {
         kvm_msr_entry_add(cpu, MSR_VIRT_SSBD, env->virt_ssbd);
     }
+    if (has_msr_therm) {
+        kvm_msr_entry_add(cpu, MSR_IA32_THERM_CONTROL, env->therm_control);
+        kvm_msr_entry_add(cpu, MSR_IA32_THERM_INTERRUPT, env->therm_interrupt);
+        kvm_msr_entry_add(cpu, MSR_IA32_THERM_STATUS, env->therm_status);
+    }
 
 #ifdef TARGET_X86_64
     if (lm_capable_kernel) {
@@ -3774,6 +3785,11 @@ static int kvm_get_msrs(X86CPU *cpu)
         kvm_msr_entry_add(cpu, MSR_IA32_TSC, 0);
         env->tsc_valid = !runstate_is_running();
     }
+    if (has_msr_therm) {
+        kvm_msr_entry_add(cpu, MSR_IA32_THERM_CONTROL, 0);
+        kvm_msr_entry_add(cpu, MSR_IA32_THERM_INTERRUPT, 0);
+        kvm_msr_entry_add(cpu, MSR_IA32_THERM_STATUS, 0);
+    }
 
 #ifdef TARGET_X86_64
     if (lm_capable_kernel) {
@@ -4255,6 +4271,15 @@ static int kvm_get_msrs(X86CPU *cpu)
         case MSR_ARCH_LBR_INFO_0 ... MSR_ARCH_LBR_INFO_0 + 31:
             env->lbr_records[index - MSR_ARCH_LBR_INFO_0].info = msrs[i].data;
             break;
+        case MSR_IA32_THERM_CONTROL:
+            env->therm_control = msrs[i].data;
+            break;
+        case MSR_IA32_THERM_INTERRUPT:
+            env->therm_interrupt = msrs[i].data;
+            break;
+        case MSR_IA32_THERM_STATUS:
+            env->therm_status = msrs[i].data;
+            break;
         }
     }
 
-- 
2.34.1


