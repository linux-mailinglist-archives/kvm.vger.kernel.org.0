Return-Path: <kvm+bounces-63476-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id A79D8C671DD
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 04:21:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id D85DA362551
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 03:21:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B1BBD31577D;
	Tue, 18 Nov 2025 03:21:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nZNZU6AL"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6414732862D
	for <kvm@vger.kernel.org>; Tue, 18 Nov 2025 03:21:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763436075; cv=none; b=cnGy0D+HAIYJ3L/jCofySk4P53D0QTRRdXgt6oToLbp5Pa0K1l5mKadH8Yp29LN+KU6c5uH7cR9cf4QTQPG5pii+hqxaX1Q9n69C7kGEwrGM1xhF0uGY4bUFXVOVs9QVfJH3QoqHG2+lyzagDoi70YHEgtYPZnf/dBPwNguRrwY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763436075; c=relaxed/simple;
	bh=7Y+10AA8RxhybijSx1coYUp7NV9ph4l57Sz0FOZYoxA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=kgNRGF4F1CsF8On8rLjdk2nD+HredhPO/xAu/O34s9jU0p/zfQPGGZHLGnkSj/hiYxmlVpu2MTxdPjDYV0qJ/Rd0qkPizvYKU5ENHAqDrdahqMlgmuQmRRGa6RagUa6g4WKfskJOhWWsDcOxOnYeO7ahpMcrb28RYuyXynpXp44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nZNZU6AL; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763436074; x=1794972074;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=7Y+10AA8RxhybijSx1coYUp7NV9ph4l57Sz0FOZYoxA=;
  b=nZNZU6ALuwa8qGOENkAzG6+G39N6r99I3sKWiOSJfXHe4ugcq4HJQSOx
   cp8qKAZaPoEnczLz1QxUMJPtslbj1UdaJvXeMHoysVn6qyMbQCwdPZ9A0
   Cue8/tDxU2D5L9M+1nHf+FzQmbCjUt9HuPxD9sZPOebnpqOd88Y2Jl1E9
   +p6i/Tq/XvOpN4jsQp8YiOrJqFdCPIqFJQ7LJcXuF2rzTmcHD/XNE7sou
   jxEhsQDUR2aJwIv6qfM5DQYBkOfcOB6blNomxUPInE+JLNm9kxtskrBfK
   y10rtS3FCahbYjIRe9iz5aq5MMibK+Sg9L6HouT9ZXKxvT5UOMS/cdHnC
   g==;
X-CSE-ConnectionGUID: y3YQ7cchRUydTwFu6JBb9g==
X-CSE-MsgGUID: HXrOHK1yQ4+ZuldwAi3DfQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11616"; a="68053894"
X-IronPort-AV: E=Sophos;i="6.19,313,1754982000"; 
   d="scan'208";a="68053894"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2025 19:21:13 -0800
X-CSE-ConnectionGUID: 2j+ZZLwKShGHa6BNPVxORA==
X-CSE-MsgGUID: qs9qdH5nQLGfGnDJ/i30Rg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,313,1754982000"; 
   d="scan'208";a="221537320"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.39])
  by fmviesa001.fm.intel.com with ESMTP; 17 Nov 2025 19:21:09 -0800
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
	Zhao Liu <zhao1.liu@intel.com>,
	Yang Weijiang <weijiang.yang@intel.com>
Subject: [PATCH v4 16/23] i386/kvm: Add save/restore support for KVM_REG_GUEST_SSP
Date: Tue, 18 Nov 2025 11:42:24 +0800
Message-Id: <20251118034231.704240-17-zhao1.liu@intel.com>
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

From: Yang Weijiang <weijiang.yang@intel.com>

CET provides a new architectural register, shadow stack pointer (SSP),
which cannot be directly encoded as a source, destination or memory
operand in instructions. But Intel VMCS & VMCB provide fields to
save/load guest & host's ssp.

It's necessary to save & restore Guest's ssp before & after migration.
To support this, KVM implements Guest's SSP as a special KVM internal
register - KVM_REG_GUEST_SSP, and allows QEMU to save & load it via
KVM_GET_ONE_REG/KVM_SET_ONE_REG.

Cache KVM_REG_GUEST_SSP in X86CPUState.

Tested-by: Farrah Chen <farrah.chen@intel.com>
Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
Co-developed-by: Chao Gao <chao.gao@intel.com>
Signed-off-by: Chao Gao <chao.gao@intel.com>
Co-developed-by: Zhao Liu <zhao1.liu@intel.com>
Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
 target/i386/cpu.h     |  3 ++-
 target/i386/kvm/kvm.c | 39 +++++++++++++++++++++++++++++++++++++++
 2 files changed, 41 insertions(+), 1 deletion(-)

diff --git a/target/i386/cpu.h b/target/i386/cpu.h
index 661b798da4d0..c4412012c780 100644
--- a/target/i386/cpu.h
+++ b/target/i386/cpu.h
@@ -1982,7 +1982,7 @@ typedef struct CPUArchState {
     uint64_t fred_config;
 #endif
 
-    /* CET MSRs */
+    /* CET MSRs and register */
     uint64_t u_cet;
     uint64_t s_cet;
     uint64_t pl0_ssp; /* also used for FRED */
@@ -1992,6 +1992,7 @@ typedef struct CPUArchState {
 #ifdef TARGET_X86_64
     uint64_t int_ssp_table;
 #endif
+    uint64_t guest_ssp;
 
     uint64_t tsc_adjust;
     uint64_t tsc_deadline;
diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index 4eb58ca19d79..1ebe20f7fb57 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -4292,6 +4292,35 @@ static int kvm_put_msrs(X86CPU *cpu, KvmPutState level)
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
@@ -5445,6 +5474,11 @@ int kvm_arch_put_registers(CPUState *cpu, KvmPutState level, Error **errp)
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
@@ -5517,6 +5551,11 @@ int kvm_arch_get_registers(CPUState *cs, Error **errp)
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


