Return-Path: <kvm+bounces-45910-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7711BAAFE52
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 17:08:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9AB8E9C1B98
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 15:07:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BD5AF27D77A;
	Thu,  8 May 2025 15:05:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JuIvXjCU"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 467D527FB04
	for <kvm@vger.kernel.org>; Thu,  8 May 2025 15:05:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746716716; cv=none; b=JylMrLFYgk3Kz2DCEwXrnkliStUVr/YMvLZVyNA4QrZWqy+CGlYg92JYbO3yNFyIx8cjUAGNCFnzR5biK+2nNy0RIJ0kkhhDMgHbV46TQVxB9JfBQ4eVxFbiQ47/d2Lldwrrlco8mxM9IVCTfloTNODoNklazCpJRbwKiFVMHck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746716716; c=relaxed/simple;
	bh=qoT1JIDDqSzLAQ9yAGC1Gf0a3c1lDg4uQlWiHklN3fc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kKMGRVsAXDBI6U0k4H152zI4aFH5Z641MQmAF/Mn9CL7EOU1gHUXId8btt+9lBGMKuBz0K1PyYbJ7x5swpkCkssmqYDqDs/7I+FJL4CBZYgSFKE6QHR2II/zC/tKVCKxsM6RXAs6EL6mOoVF+GolCwO+FupitCBkPxJcmPx+N08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JuIvXjCU; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746716715; x=1778252715;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=qoT1JIDDqSzLAQ9yAGC1Gf0a3c1lDg4uQlWiHklN3fc=;
  b=JuIvXjCUpzbKmURexAmTBIgjG4C61Zka7S6qok7X2hfGPdDbbwk3dn5/
   haWn1q9oRdf/cXPkfwwBDdrqQRGsnHMSPHDEk8QyCvBWZG5iGlcSCRdIL
   DFGE/KKJQ2A0OpPfjcmIk3C2849i22KqOwxNSoGnMeN14M/nxT5NenIxa
   d5rqbVMmGZd2e5OXK4J3gFb9m9NKj+FP+dwHhwEu3egLwLDHJXVxYoqO5
   RqV/AZwQeAPmZ67cJwDUICT3EapbHHoH5comRs66KqWx82lstuMmFgIog
   NOP+Bg0cmk2JSK9GkOI+JNEi6Scmf3sAe6f+/taCrHdQ+wLkGAeocx/H8
   w==;
X-CSE-ConnectionGUID: pUclU9AyStu7wC5ieyb2Jw==
X-CSE-MsgGUID: MRz7JJThTwu0iY9FXdm9Yg==
X-IronPort-AV: E=McAfee;i="6700,10204,11427"; a="73888034"
X-IronPort-AV: E=Sophos;i="6.15,272,1739865600"; 
   d="scan'208";a="73888034"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2025 08:05:15 -0700
X-CSE-ConnectionGUID: UnEgqF9YSCWsZcIo9jhM4Q==
X-CSE-MsgGUID: oWiO9CSxRBGtojoOCgXC7g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,272,1739865600"; 
   d="scan'208";a="141439824"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by orviesa005.jf.intel.com with ESMTP; 08 May 2025 08:05:12 -0700
From: Xiaoyao Li <xiaoyao.li@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Francesco Lavra <francescolavra.fl@gmail.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	kvm@vger.kernel.org,
	qemu-devel@nongnu.org,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Zhao Liu <zhao1.liu@intel.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [PATCH v9 07/55] kvm: Introduce kvm_arch_pre_create_vcpu()
Date: Thu,  8 May 2025 10:59:13 -0400
Message-ID: <20250508150002.689633-8-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250508150002.689633-1-xiaoyao.li@intel.com>
References: <20250508150002.689633-1-xiaoyao.li@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Introduce kvm_arch_pre_create_vcpu(), to perform arch-dependent
work prior to create any vcpu. This is for i386 TDX because it needs
call TDX_INIT_VM before creating any vcpu.

The specific implementation for i386 will be added in the future patch.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Acked-by: Gerd Hoffmann <kraxel@redhat.com>
Reviewed-by: Daniel P. Berrangé <berrange@redhat.com>
Reviewed-by: Zhao Liu <zhao1.liu@intel.com>
---
Changes in v7:
- Implement stub for all the ARCHes instead of defining it with weak
  attribute; (Philippe)

Changes in v3:
- pass @errp to kvm_arch_pre_create_vcpu(); (Per Daniel)
---
 accel/kvm/kvm-all.c        | 5 +++++
 include/system/kvm.h       | 1 +
 target/arm/kvm.c           | 5 +++++
 target/i386/kvm/kvm.c      | 5 +++++
 target/loongarch/kvm/kvm.c | 4 ++++
 target/mips/kvm.c          | 5 +++++
 target/ppc/kvm.c           | 5 +++++
 target/riscv/kvm/kvm-cpu.c | 5 +++++
 target/s390x/kvm/kvm.c     | 5 +++++
 9 files changed, 40 insertions(+)

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index f89568bfa397..df9840e53a35 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -540,6 +540,11 @@ int kvm_init_vcpu(CPUState *cpu, Error **errp)
 
     trace_kvm_init_vcpu(cpu->cpu_index, kvm_arch_vcpu_id(cpu));
 
+    ret = kvm_arch_pre_create_vcpu(cpu, errp);
+    if (ret < 0) {
+        goto err;
+    }
+
     ret = kvm_create_vcpu(cpu);
     if (ret < 0) {
         error_setg_errno(errp, -ret,
diff --git a/include/system/kvm.h b/include/system/kvm.h
index ab17c09a551f..d7dfa25493a2 100644
--- a/include/system/kvm.h
+++ b/include/system/kvm.h
@@ -374,6 +374,7 @@ int kvm_arch_get_default_type(MachineState *ms);
 
 int kvm_arch_init(MachineState *ms, KVMState *s);
 
+int kvm_arch_pre_create_vcpu(CPUState *cpu, Error **errp);
 int kvm_arch_init_vcpu(CPUState *cpu);
 int kvm_arch_destroy_vcpu(CPUState *cpu);
 
diff --git a/target/arm/kvm.c b/target/arm/kvm.c
index da30bdbb2349..93f1a7245b3f 100644
--- a/target/arm/kvm.c
+++ b/target/arm/kvm.c
@@ -1874,6 +1874,11 @@ static int kvm_arm_sve_set_vls(ARMCPU *cpu)
 
 #define ARM_CPU_ID_MPIDR       3, 0, 0, 0, 5
 
+int kvm_arch_pre_create_vcpu(CPUState *cpu, Error **errp)
+{
+    return 0;
+}
+
 int kvm_arch_init_vcpu(CPUState *cs)
 {
     int ret;
diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index b4fa35405fe1..1a4dd19e24ab 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -2050,6 +2050,11 @@ full:
     abort();
 }
 
+int kvm_arch_pre_create_vcpu(CPUState *cpu, Error **errp)
+{
+    return 0;
+}
+
 int kvm_arch_init_vcpu(CPUState *cs)
 {
     struct {
diff --git a/target/loongarch/kvm/kvm.c b/target/loongarch/kvm/kvm.c
index f0e3cfef037f..64c967297617 100644
--- a/target/loongarch/kvm/kvm.c
+++ b/target/loongarch/kvm/kvm.c
@@ -1071,7 +1071,11 @@ static int kvm_cpu_check_pv_features(CPUState *cs, Error **errp)
             env->pv_features |= BIT(KVM_FEATURE_VIRT_EXTIOI);
         }
     }
+    return 0;
+}
 
+int kvm_arch_pre_create_vcpu(CPUState *cpu, Error **errp)
+{
     return 0;
 }
 
diff --git a/target/mips/kvm.c b/target/mips/kvm.c
index d67b7c1a8ecb..ec53acb51a1f 100644
--- a/target/mips/kvm.c
+++ b/target/mips/kvm.c
@@ -61,6 +61,11 @@ int kvm_arch_irqchip_create(KVMState *s)
     return 0;
 }
 
+int kvm_arch_pre_create_vcpu(CPUState *cpu, Error **errp)
+{
+    return 0;
+}
+
 int kvm_arch_init_vcpu(CPUState *cs)
 {
     CPUMIPSState *env = cpu_env(cs);
diff --git a/target/ppc/kvm.c b/target/ppc/kvm.c
index 992356cb7593..20fabccecd54 100644
--- a/target/ppc/kvm.c
+++ b/target/ppc/kvm.c
@@ -479,6 +479,11 @@ static void kvmppc_hw_debug_points_init(CPUPPCState *cenv)
     }
 }
 
+int kvm_arch_pre_create_vcpu(CPUState *cpu, Error **errp)
+{
+    return 0;
+}
+
 int kvm_arch_init_vcpu(CPUState *cs)
 {
     PowerPCCPU *cpu = POWERPC_CPU(cs);
diff --git a/target/riscv/kvm/kvm-cpu.c b/target/riscv/kvm/kvm-cpu.c
index 0f4997a9186f..6f15f727dea0 100644
--- a/target/riscv/kvm/kvm-cpu.c
+++ b/target/riscv/kvm/kvm-cpu.c
@@ -1383,6 +1383,11 @@ static int kvm_vcpu_enable_sbi_dbcn(RISCVCPU *cpu, CPUState *cs)
     return kvm_set_one_reg(cs, kvm_sbi_dbcn.kvm_reg_id, &reg);
 }
 
+int kvm_arch_pre_create_vcpu(CPUState *cpu, Error **errp)
+{
+    return 0;
+}
+
 int kvm_arch_init_vcpu(CPUState *cs)
 {
     int ret = 0;
diff --git a/target/s390x/kvm/kvm.c b/target/s390x/kvm/kvm.c
index 4d56e653ddf6..1f592733f4e2 100644
--- a/target/s390x/kvm/kvm.c
+++ b/target/s390x/kvm/kvm.c
@@ -404,6 +404,11 @@ unsigned long kvm_arch_vcpu_id(CPUState *cpu)
     return cpu->cpu_index;
 }
 
+int kvm_arch_pre_create_vcpu(CPUState *cpu, Error **errp)
+{
+    return 0;
+}
+
 int kvm_arch_init_vcpu(CPUState *cs)
 {
     unsigned int max_cpus = MACHINE(qdev_get_machine())->smp.max_cpus;
-- 
2.43.0


