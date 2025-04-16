Return-Path: <kvm+bounces-43495-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id DA3BAA90E1C
	for <lists+kvm@lfdr.de>; Wed, 16 Apr 2025 23:58:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 407CF189810C
	for <lists+kvm@lfdr.de>; Wed, 16 Apr 2025 21:58:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E3FD324BBF2;
	Wed, 16 Apr 2025 21:58:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="WorluwUj"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7826924887A
	for <kvm@vger.kernel.org>; Wed, 16 Apr 2025 21:58:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744840684; cv=none; b=Dh+/dczFkXcbScFs+Np22Xn/R5P9KGl77A8qZYcZEd8KQDybe0Nwfjfcxp7HHl6fWET/61YbDBRAp3W8iZ4xrM1q6vbILmD+VKRIi0vnu2ZzRwRNyfLGSdvKnBJRyVnXYsyDU0F+mJWk9kQsegkMHU16o8xCcin2Zrk0qlwklps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744840684; c=relaxed/simple;
	bh=7fSM0kS/bBlnL+6h9gVp6/Gr90m8H3RKpVS1zy6nwyI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UPiUrAjDy2cp+piHA6IJvH9llD0rw/yWTpCmPXDqh8DI7HsIn2Px99vSezdvmc9CsnRUV3I88+BOEOTulYyfGmFYDFKF2vKc15dLkTURot5RxTrA33Qw+KevBP9SLT1yvVG9VtXYiLJKLdDpRbqcrRiIb0cK53TYUwf+SdR6+eA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=WorluwUj; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 53GLMx1d019722;
	Wed, 16 Apr 2025 21:57:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=2lnIBN5KJbkcBf1EPifbRJMmBH9Fug6xLrkwvcHfQ5M=; b=
	WorluwUjkhfYLimcZtQaQ7VnZYV0Rc+CsaBWeM6Y0IRFhZSNoQBoBxEP9wGbcBC1
	T0P+Y0ARPR78BAeYHSQynGgD8TyN5QxQJk/6Qupyzpc6fSF0kOHdxz0T9Y37g2GR
	XmZ/PrRNKIVgVAO5xdM+609iDVP3iQO5los+sATDT9UmTX1FXZscdP5zbbpknzFm
	NzpEB3R6YZBDj1fv9sDoqeT0mbaBhuSueDT2mfDj0i8RvBdotTNNiiTNEwq/b+Cd
	h7Fx7QdP8ZMO/PuNs4/MaXny84A3X4gqTzvG7LtKWaSPxA9Rf2Yl/vJ2qmFezsI5
	oJ3JV0L5U5QPAats7A8YOQ==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4619444xq8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 16 Apr 2025 21:57:13 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 53GKk54C005736;
	Wed, 16 Apr 2025 21:57:12 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 460d5xhvjc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 16 Apr 2025 21:57:12 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 53GLv1qW036583;
	Wed, 16 Apr 2025 21:57:11 GMT
Received: from localhost.localdomain (ca-dev80.us.oracle.com [10.211.9.80])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 460d5xhvcp-5;
	Wed, 16 Apr 2025 21:57:11 +0000
From: Dongli Zhang <dongli.zhang@oracle.com>
To: qemu-devel@nongnu.org, kvm@vger.kernel.org, qemu-arm@nongnu.org,
        qemu-ppc@nongnu.org, qemu-riscv@nongnu.org, qemu-s390x@nongnu.org
Cc: pbonzini@redhat.com, zhao1.liu@intel.com, mtosatti@redhat.com,
        sandipan.das@amd.com, babu.moger@amd.com, likexu@tencent.com,
        like.xu.linux@gmail.com, groug@kaod.org, khorenko@virtuozzo.com,
        alexander.ivanov@virtuozzo.com, den@virtuozzo.com,
        davydov-max@yandex-team.ru, xiaoyao.li@intel.com,
        dapeng1.mi@linux.intel.com, joe.jin@oracle.com,
        peter.maydell@linaro.org, gaosong@loongson.cn, chenhuacai@kernel.org,
        philmd@linaro.org, aurelien@aurel32.net, jiaxun.yang@flygoat.com,
        arikalo@gmail.com, npiggin@gmail.com, danielhb413@gmail.com,
        palmer@dabbelt.com, alistair.francis@wdc.com, liwei1518@gmail.com,
        zhiwei_liu@linux.alibaba.com, pasic@linux.ibm.com,
        borntraeger@linux.ibm.com, richard.henderson@linaro.org,
        david@redhat.com, iii@linux.ibm.com, thuth@redhat.com,
        flavra@baylibre.com, ewanhai-oc@zhaoxin.com, ewanhai@zhaoxin.com,
        cobechen@zhaoxin.com, louisqi@zhaoxin.com, liamni@zhaoxin.com,
        frankzhu@zhaoxin.com, silviazhao@zhaoxin.com, kraxel@redhat.com,
        berrange@redhat.com
Subject: [PATCH v4 04/11] kvm: Introduce kvm_arch_pre_create_vcpu()
Date: Wed, 16 Apr 2025 14:52:29 -0700
Message-ID: <20250416215306.32426-5-dongli.zhang@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20250416215306.32426-1-dongli.zhang@oracle.com>
References: <20250416215306.32426-1-dongli.zhang@oracle.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1095,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-04-16_08,2025-04-15_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999
 suspectscore=0 spamscore=0 bulkscore=0 malwarescore=0 adultscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2502280000 definitions=main-2504160177
X-Proofpoint-GUID: vRhKiTwugRWlC8C7DEIYFzbK2MujU19W
X-Proofpoint-ORIG-GUID: vRhKiTwugRWlC8C7DEIYFzbK2MujU19W

From: Xiaoyao Li <xiaoyao.li@intel.com>

Introduce kvm_arch_pre_create_vcpu(), to perform arch-dependent
work prior to create any vcpu. This is for i386 TDX because it needs
call TDX_INIT_VM before creating any vcpu.

The specific implementation of i386 will be added in the future patch.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Acked-by: Gerd Hoffmann <kraxel@redhat.com>
Reviewed-by: Daniel P. Berrangé <berrange@redhat.com>
Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
Reviewed-by: Zhao Liu <zhao1.liu@intel.com>
---
Changed since v2:
  - Add my Signed-off-by.
Changed since v3:
  - Pick new reviewed version from:
https://lore.kernel.org/all/20250401130205.2198253-8-xiaoyao.li@intel.com/
    I have fixed the typo as suggested by Daniel.
  - Keep Zhao's review.

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
index f89568bfa3..df9840e53a 100644
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
index ab17c09a55..d7dfa25493 100644
--- a/include/system/kvm.h
+++ b/include/system/kvm.h
@@ -374,6 +374,7 @@ int kvm_arch_get_default_type(MachineState *ms);
 
 int kvm_arch_init(MachineState *ms, KVMState *s);
 
+int kvm_arch_pre_create_vcpu(CPUState *cpu, Error **errp);
 int kvm_arch_init_vcpu(CPUState *cpu);
 int kvm_arch_destroy_vcpu(CPUState *cpu);
 
diff --git a/target/arm/kvm.c b/target/arm/kvm.c
index da30bdbb23..93f1a7245b 100644
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
index 6c749d4ee8..f41e190fb8 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -2051,6 +2051,11 @@ full:
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
index f0e3cfef03..64c9672976 100644
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
index d67b7c1a8e..ec53acb51a 100644
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
index 992356cb75..20fabccecd 100644
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
index 0f4997a918..6f15f727de 100644
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
index 4d56e653dd..1f592733f4 100644
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
2.39.3


