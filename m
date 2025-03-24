Return-Path: <kvm+bounces-41784-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B33CBA6D499
	for <lists+kvm@lfdr.de>; Mon, 24 Mar 2025 08:09:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E16D13ABCF5
	for <lists+kvm@lfdr.de>; Mon, 24 Mar 2025 07:08:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C2BA2505CF;
	Mon, 24 Mar 2025 07:08:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="H58ZqUp5"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FC54250BE8
	for <kvm@vger.kernel.org>; Mon, 24 Mar 2025 07:08:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742800131; cv=none; b=SsMHsUuf00OZBeWZqQaq7jg1fdIuiE51RfU64DzZyfqxs7l4Xcmy5Obgn4MuO7AyBQz8o8dEP8iZkoDIbxzC7PHuEgPhV27SDvvSMDVsbCkJ+bTiVBYToPSMmfBEufHQ2D5T6H7/zYyujJNUDszISyXhaj2vJJU2RoyxRjUrjvY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742800131; c=relaxed/simple;
	bh=bcLIsmrOKPi83DhR2wgRbrkYxT7RJ0kVGYi7GuXJLOQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=IkKr0CaI9qiQKP8EH4HLwE/lPye0+CYZmkPh8M8Ds+op8sXAQr0ta9LhyyiEbd4IiipPpqHQzcFDNcZubVKhXDsH4Vcda0nEmnSly4AhChfLpOhKh37V4LnsnGZv6KO7vbR4B3A3mjRC5nSgGkpII/m0O+GDOumnZJWy39cUWZ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=H58ZqUp5; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1742800130; x=1774336130;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=bcLIsmrOKPi83DhR2wgRbrkYxT7RJ0kVGYi7GuXJLOQ=;
  b=H58ZqUp5H5o7F4CysD639lKhtmJCmjHnn3eU7fXnWRA0JGEM3HIN0C9x
   m6TTjx2pVTEf0m+wggKbSon8toCIRz/88TPuVKcWo/iH4eQqnKlU0Iahu
   6CBtjrxdvgIfhXEwGRB+PC43ztd/RQ10RMQLo4MU80fsigHvLvKeyNa8i
   TcX27y4Xu1asX1IJCpJb4MP8/SlMSLy+hJXr4H66nZhX1XnxmLIepRsqg
   LyAjuo+MFv1uS2c7ppGHDtoo376lnitPsBBCEv1AhF6vpAMyKJE8JGUIX
   H5RURN0d+se20Er24hgjRSrQqvsKM+v4hLoJe3uSwIzthSyn5w0x32gIA
   w==;
X-CSE-ConnectionGUID: AAbSt+AHSqOvX+hphiWlBg==
X-CSE-MsgGUID: xOkhPNAiQma/9XTMsGFkgg==
X-IronPort-AV: E=McAfee;i="6700,10204,11382"; a="31588479"
X-IronPort-AV: E=Sophos;i="6.14,271,1736841600"; 
   d="scan'208";a="31588479"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Mar 2025 00:08:50 -0700
X-CSE-ConnectionGUID: N3YfX5fhRDWeGrJegQyyAw==
X-CSE-MsgGUID: Gqadn5AZR9ejQjmgIv0XLA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,271,1736841600"; 
   d="scan'208";a="123944422"
Received: from emr.sh.intel.com ([10.112.229.56])
  by fmviesa007.fm.intel.com with ESMTP; 24 Mar 2025 00:08:47 -0700
From: Dapeng Mi <dapeng1.mi@linux.intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>
Cc: qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	Zhao Liu <zhao1.liu@intel.com>,
	Zide Chen <zide.chen@intel.com>,
	Xiaoyao Li <xiaoyao.li@intel.com>,
	Dongli Zhang <dongli.zhang@oracle.com>,
	Mingwei Zhang <mizhang@google.com>,
	Das Sandipan <Sandipan.Das@amd.com>,
	Shukla Manali <Manali.Shukla@amd.com>,
	Dapeng Mi <dapeng1.mi@intel.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>
Subject: [PATCH 3/3] target/i386: Support VMX_VM_EXIT_SAVE_IA32_PERF_GLOBAL_CTRL
Date: Mon, 24 Mar 2025 12:37:12 +0000
Message-Id: <20250324123712.34096-4-dapeng1.mi@linux.intel.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20250324123712.34096-1-dapeng1.mi@linux.intel.com>
References: <20250324123712.34096-1-dapeng1.mi@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Since Sapphire Rapids starts, VMX instrocude a new bit
SAVE_IA32_PERF_GLOBAL_CTRL in VMCS VM-EXIT control field to manage if
vmx can save guest PERF_GLOBAL_CTRL MSR.

This patch enables this feature.

Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
---
 target/i386/cpu.c | 12 ++++++++----
 target/i386/cpu.h |  1 +
 2 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index 1b64ceaaba..317ccc8b0a 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -1481,7 +1481,8 @@ FeatureWordInfo feature_word_info[FEATURE_WORDS] = {
             "vmx-exit-save-efer", "vmx-exit-load-efer",
                 "vmx-exit-save-preemption-timer", "vmx-exit-clear-bndcfgs",
             NULL, "vmx-exit-clear-rtit-ctl", NULL, NULL,
-            NULL, "vmx-exit-load-pkrs", NULL, "vmx-exit-secondary-ctls",
+            NULL, "vmx-exit-load-pkrs", "vmx-exit-save-perf-global-ctrl",
+            "vmx-exit-secondary-ctls",
         },
         .msr = {
             .index = MSR_IA32_VMX_TRUE_EXIT_CTLS,
@@ -4212,7 +4213,8 @@ static const X86CPUDefinition builtin_x86_defs[] = {
             VMX_VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL |
             VMX_VM_EXIT_ACK_INTR_ON_EXIT | VMX_VM_EXIT_SAVE_IA32_PAT |
             VMX_VM_EXIT_LOAD_IA32_PAT | VMX_VM_EXIT_SAVE_IA32_EFER |
-            VMX_VM_EXIT_LOAD_IA32_EFER | VMX_VM_EXIT_SAVE_VMX_PREEMPTION_TIMER,
+            VMX_VM_EXIT_LOAD_IA32_EFER | VMX_VM_EXIT_SAVE_VMX_PREEMPTION_TIMER |
+            VMX_VM_EXIT_SAVE_IA32_PERF_GLOBAL_CTRL,
         .features[FEAT_VMX_MISC] =
             MSR_VMX_MISC_STORE_LMA | MSR_VMX_MISC_ACTIVITY_HLT |
             MSR_VMX_MISC_VMWRITE_VMEXIT,
@@ -4368,7 +4370,8 @@ static const X86CPUDefinition builtin_x86_defs[] = {
             VMX_VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL |
             VMX_VM_EXIT_ACK_INTR_ON_EXIT | VMX_VM_EXIT_SAVE_IA32_PAT |
             VMX_VM_EXIT_LOAD_IA32_PAT | VMX_VM_EXIT_SAVE_IA32_EFER |
-            VMX_VM_EXIT_LOAD_IA32_EFER | VMX_VM_EXIT_SAVE_VMX_PREEMPTION_TIMER,
+            VMX_VM_EXIT_LOAD_IA32_EFER | VMX_VM_EXIT_SAVE_VMX_PREEMPTION_TIMER |
+            VMX_VM_EXIT_SAVE_IA32_PERF_GLOBAL_CTRL,
         .features[FEAT_VMX_MISC] =
             MSR_VMX_MISC_STORE_LMA | MSR_VMX_MISC_ACTIVITY_HLT |
             MSR_VMX_MISC_VMWRITE_VMEXIT,
@@ -4511,7 +4514,8 @@ static const X86CPUDefinition builtin_x86_defs[] = {
             VMX_VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL |
             VMX_VM_EXIT_ACK_INTR_ON_EXIT | VMX_VM_EXIT_SAVE_IA32_PAT |
             VMX_VM_EXIT_LOAD_IA32_PAT | VMX_VM_EXIT_SAVE_IA32_EFER |
-            VMX_VM_EXIT_LOAD_IA32_EFER | VMX_VM_EXIT_SAVE_VMX_PREEMPTION_TIMER,
+            VMX_VM_EXIT_LOAD_IA32_EFER | VMX_VM_EXIT_SAVE_VMX_PREEMPTION_TIMER |
+            VMX_VM_EXIT_SAVE_IA32_PERF_GLOBAL_CTRL,
         .features[FEAT_VMX_MISC] =
             MSR_VMX_MISC_STORE_LMA | MSR_VMX_MISC_ACTIVITY_HLT |
             MSR_VMX_MISC_VMWRITE_VMEXIT,
diff --git a/target/i386/cpu.h b/target/i386/cpu.h
index 76f24446a5..ad387e6ee7 100644
--- a/target/i386/cpu.h
+++ b/target/i386/cpu.h
@@ -1312,6 +1312,7 @@ uint64_t x86_cpu_get_supported_feature_word(X86CPU *cpu, FeatureWord w);
 #define VMX_VM_EXIT_PT_CONCEAL_PIP                  0x01000000
 #define VMX_VM_EXIT_CLEAR_IA32_RTIT_CTL             0x02000000
 #define VMX_VM_EXIT_LOAD_IA32_PKRS                  0x20000000
+#define VMX_VM_EXIT_SAVE_IA32_PERF_GLOBAL_CTRL      0x40000000
 #define VMX_VM_EXIT_ACTIVATE_SECONDARY_CONTROLS     0x80000000
 
 #define VMX_VM_ENTRY_LOAD_DEBUG_CONTROLS            0x00000004
-- 
2.40.1


