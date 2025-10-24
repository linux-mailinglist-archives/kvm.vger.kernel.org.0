Return-Path: <kvm+bounces-60975-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E13A5C04848
	for <lists+kvm@lfdr.de>; Fri, 24 Oct 2025 08:35:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9A64B3BA593
	for <lists+kvm@lfdr.de>; Fri, 24 Oct 2025 06:35:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A7345277C98;
	Fri, 24 Oct 2025 06:35:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YckYsp03"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D843022370D
	for <kvm@vger.kernel.org>; Fri, 24 Oct 2025 06:35:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761287736; cv=none; b=JqFIob2j0jvKHyzrK9sshzLGlvJySXQu72UVsbhy0p2xBVXgtWhT5PctNf0lfFfcxHs1AwYgQsB26nxiBGu02vRPGP2mmgSPW/Oqgdkbc774xOgOGzfSL1H4bvJjHVfaoGV9VyJqk/J+vEuxkSlyUe5W7ZBOF3Etc8zP65+++OY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761287736; c=relaxed/simple;
	bh=X9mZMY7GCwdN4r2ezl65+y+sTCP8LT+K5xyesugEdsI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=hTF3WQxBU292tUqeHRMC21I4+llS7ecO+LDkbG2+YJ0TbNYWfSpRjQo0/WB6NykixCmcX/GMC0Pe+e9nebNuFA6C2URg0uiMCtY5gDW4DqHtMhswiAs0oUTFbALB8qfogipPwAsCNeO9VRuD8AtjxbVxWq69qGLGEIyaEw+oN/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=YckYsp03; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761287734; x=1792823734;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=X9mZMY7GCwdN4r2ezl65+y+sTCP8LT+K5xyesugEdsI=;
  b=YckYsp03lCCBcEVS60KnO4g5UZzmyjOh2j4PffyhzSAcW99z+6GnjYH+
   j6HS6hgs+5qL0praCePeK65s57qfKBfUVvhv4lG07veXzgy+YKdbISEAI
   0SrNoIQ6Wg+L2CdjlRuX7pY//SBybrOg3KrPnJslmSrg+ggFKV+ZD46Lk
   Vz5ghqkgpHJ10o3fP07Igyg3pJUKN/q4LWBstkvhGx+ZL39fCoZ4e+0XB
   CkbWI/MiCBdFbTCkhKnCFHh/nPx17iM/gDQ+SbwKr+HuDSzOlAxts2YJk
   T5EDLtii2iUyBtAdtgjwRXEVYfNt6LNAWMUEg5bqxr1Kg8BFHyAXQQLYX
   w==;
X-CSE-ConnectionGUID: xZBGDiJ1TZKCSwixZdPkRg==
X-CSE-MsgGUID: kQgovwCRS8yADkw/tJZiiQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11586"; a="62675694"
X-IronPort-AV: E=Sophos;i="6.19,251,1754982000"; 
   d="scan'208";a="62675694"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Oct 2025 23:35:33 -0700
X-CSE-ConnectionGUID: jD+M9+PjSPOEKLdIgJOBeA==
X-CSE-MsgGUID: KF/E+hlwSPGCQTCB+6H/cA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,251,1754982000"; 
   d="scan'208";a="184276104"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.39])
  by fmviesa006.fm.intel.com with ESMTP; 23 Oct 2025 23:35:30 -0700
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
Subject: [PATCH v3 14/20] i386/kvm: Add save/load support for KVM_REG_GUEST_SSP
Date: Fri, 24 Oct 2025 14:56:26 +0800
Message-Id: <20251024065632.1448606-15-zhao1.liu@intel.com>
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

CET provides a new architectural register, shadow stack pointer (SSP),
which cannot be directly encoded as a source, destination or memory
operand in instructions. But Intel VMCS & VMCB provide fields to
save/load guest & host's ssp.

It's necessary to save & load Guest's ssp before & after migration. To
support this, KVM implements Guest's SSP as a special KVM internal
register - KVM_REG_GUEST_SSP, and allows QEMU to save & load it via
KVM_GET_ONE_REG/KVM_SET_ONE_REG.

Cache KVM_REG_GUEST_SSP in X86CPUState.

Tested-by: Farrah Chen <farrah.chen@intel.com>
Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
Co-developed-by: Chao Gao <chao.gao@intel.com>
Signed-off-by: Chao Gao <chao.gao@intel.com>
Co-developed-by: Zhao Liu <zhao1.liu@intel.com>
Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
 target/i386/cpu.h     |  1 +
 target/i386/kvm/kvm.c | 39 +++++++++++++++++++++++++++++++++++++++
 2 files changed, 40 insertions(+)

diff --git a/target/i386/cpu.h b/target/i386/cpu.h
index 4edb977575e2..ad4287822831 100644
--- a/target/i386/cpu.h
+++ b/target/i386/cpu.h
@@ -2105,6 +2105,7 @@ typedef struct CPUArchState {
     uint64_t pl2_ssp;
     uint64_t pl3_ssp;
     uint64_t int_ssp_table;
+    uint64_t guest_ssp;
 
     /* Fields up to this point are cleared by a CPU reset */
     struct {} end_reset_fields;
diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index 92c2fd6d6aee..412e99ba5b53 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -4280,6 +4280,35 @@ static int kvm_put_msrs(X86CPU *cpu, KvmPutState level)
     return kvm_buf_set_msrs(cpu);
 }
 
+static int kvm_put_kvm_regs(X86CPU *cpu)
+{
+    CPUX86State *env = &cpu->env;
+    int ret;
+
+    if ((env->features[FEAT_7_0_ECX] & CPUID_7_0_ECX_CET_SHSTK)) {
+        ret = kvm_set_one_reg(CPU(cpu), KVM_X86_REG_KVM(KVM_REG_GUEST_SSP),
+                              &env->guest_ssp);
+        if (ret) {
+            return ret;
+        }
+    }
+    return 0;
+}
+
+static int kvm_get_kvm_regs(X86CPU *cpu)
+{
+    CPUX86State *env = &cpu->env;
+    int ret;
+
+    if ((env->features[FEAT_7_0_ECX] & CPUID_7_0_ECX_CET_SHSTK)) {
+        ret = kvm_get_one_reg(CPU(cpu), KVM_X86_REG_KVM(KVM_REG_GUEST_SSP),
+                              &env->guest_ssp);
+        if (ret) {
+            return ret;
+        }
+    }
+    return 0;
+}
 
 static int kvm_get_xsave(X86CPU *cpu)
 {
@@ -5425,6 +5454,11 @@ int kvm_arch_put_registers(CPUState *cpu, KvmPutState level, Error **errp)
         error_setg_errno(errp, -ret, "Failed to set MSRs");
         return ret;
     }
+    ret = kvm_put_kvm_regs(x86_cpu);
+    if (ret < 0) {
+        error_setg_errno(errp, -ret, "Failed to set KVM type registers");
+        return ret;
+    }
     ret = kvm_put_vcpu_events(x86_cpu, level);
     if (ret < 0) {
         error_setg_errno(errp, -ret, "Failed to set vCPU events");
@@ -5497,6 +5531,11 @@ int kvm_arch_get_registers(CPUState *cs, Error **errp)
         error_setg_errno(errp, -ret, "Failed to get MSRs");
         goto out;
     }
+    ret = kvm_get_kvm_regs(cpu);
+    if (ret < 0) {
+        error_setg_errno(errp, -ret, "Failed to get KVM type registers");
+        goto out;
+    }
     ret = kvm_get_apic(cpu);
     if (ret < 0) {
         error_setg_errno(errp, -ret, "Failed to get APIC");
-- 
2.34.1


