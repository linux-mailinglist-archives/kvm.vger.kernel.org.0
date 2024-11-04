Return-Path: <kvm+bounces-30477-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 2FE7A9BAFFE
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2024 10:43:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 9053AB2466E
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2024 09:43:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 12F581AF0A3;
	Mon,  4 Nov 2024 09:42:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="dxuYMhMH"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB5E71AF0A6
	for <kvm@vger.kernel.org>; Mon,  4 Nov 2024 09:42:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730713353; cv=none; b=DsFC0rJngw0cj6wTjobU5ZpQS/GEM94ALjuCvFHleVgJtqbPPEZGmwGpGobWyj4jqkrxe41mY1LHnNwWQ8fHs7U0Yy8WYabIjVHSsp9SHU/P51AzvQIz1OUQHXrwB89I/0wTB/2hnzAoNyqNwpBgYo8D22yLCmqOFFoPgKyiTb0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730713353; c=relaxed/simple;
	bh=PvrYLdYLm3zwzq6rog1/gQwgqsU+UC9Ra8aLpqdNcvg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GYahjYTLa4KxXBy3T4QIjnR8seWT+tieYWhxouXi8JDNkKtNQKiW2rpe4n8aL2t2kyT00dtMPaju6aStPEySTwM4yZy4WMJiDy21r+M5rB01QoZFTioNuSkHfytghzA8rtOmPOJhIDZ6P13Tfa7hvnEHVUxvS2UaBoTZGaILanY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=dxuYMhMH; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4A48gHuK004180;
	Mon, 4 Nov 2024 09:41:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=corp-2023-11-20; bh=bfLnj
	bxcSPm6lnfdVUJ780ERZUAYKYTQqq6FUng196c=; b=dxuYMhMH5AjRDPqLOREeT
	hmt78JhXZJXgnn5T/Ymq+vGMJeCfOKIR/y09h4S0u4U8SHkOiT0H1dzITAilUavs
	gPIQJETp55L1fL7KeQ0u2StgztyWY7edfvnf2c7HMKENiO+e11f/bBxAIs86+49H
	dlHzVqSvUmtXZIfiY84hcdk0iPRS4vOFttlCF2HEUFvK1EclKCIiNZubBZ5rBT6w
	4Atn1aDd4qIjGIlEm/lTaSpTyBIagXXQlz/Own3MNXL2FIG/TEf9EcTmlQLpXQS1
	Hg+KB75aly7BVbbB41EL0D5QRK3qRQEYolBhVfx2oaM2rRAEL5bRmXf53uah5kX3
	g==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 42nav22acy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 04 Nov 2024 09:41:57 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4A47NvkB009709;
	Mon, 4 Nov 2024 09:41:56 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 42nahbt0a0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 04 Nov 2024 09:41:56 +0000
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 4A49fqfg018519;
	Mon, 4 Nov 2024 09:41:55 GMT
Received: from localhost.localdomain (ca-dev80.us.oracle.com [10.211.9.80])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 42nahbt06k-3;
	Mon, 04 Nov 2024 09:41:55 +0000
From: Dongli Zhang <dongli.zhang@oracle.com>
To: qemu-devel@nongnu.org, kvm@vger.kernel.org
Cc: pbonzini@redhat.com, mtosatti@redhat.com, sandipan.das@amd.com,
        babu.moger@amd.com, zhao1.liu@intel.com, likexu@tencent.com,
        like.xu.linux@gmail.com, zhenyuw@linux.intel.com, groug@kaod.org,
        lyan@digitalocean.com, khorenko@virtuozzo.com,
        alexander.ivanov@virtuozzo.com, den@virtuozzo.com, joe.jin@oracle.com,
        davydov-max@yandex-team.ru
Subject: [PATCH 2/7] target/i386/kvm: introduce 'pmu-cap-disabled' to set KVM_PMU_CAP_DISABLE
Date: Mon,  4 Nov 2024 01:40:17 -0800
Message-ID: <20241104094119.4131-3-dongli.zhang@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20241104094119.4131-1-dongli.zhang@oracle.com>
References: <20241104094119.4131-1-dongli.zhang@oracle.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-11-04_07,2024-11-01_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0
 mlxlogscore=999 mlxscore=0 suspectscore=0 bulkscore=0 malwarescore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2409260000 definitions=main-2411040085
X-Proofpoint-GUID: akal7AZncT7cVfEwlijF__SDIscOosvs
X-Proofpoint-ORIG-GUID: akal7AZncT7cVfEwlijF__SDIscOosvs

The AMD PMU virtualization is not disabled when configuring
"-cpu host,-pmu" in the QEMU command line on an AMD server. Neither
"-cpu host,-pmu" nor "-cpu EPYC" effectively disables AMD PMU
virtualization in such an environment.

As a result, VM logs typically show:

[    0.510611] Performance Events: Fam17h+ core perfctr, AMD PMU driver.

whereas the expected logs should be:

[    0.596381] Performance Events: PMU not available due to virtualization, using software events only.
[    0.600972] NMI watchdog: Perf NMI watchdog permanently disabled

This discrepancy occurs because AMD PMU does not use CPUID to determine
whether PMU virtualization is supported.

To address this, we introduce a new property, 'pmu-cap-disabled', for KVM
acceleration. This property sets KVM_PMU_CAP_DISABLE if
KVM_CAP_PMU_CAPABILITY is supported. Note that this feature currently
supports only x86 hosts, as KVM_CAP_PMU_CAPABILITY is used exclusively for
x86 systems.

Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
---
Another previous solution to re-use '-cpu host,-pmu':
https://lore.kernel.org/all/20221119122901.2469-1-dongli.zhang@oracle.com/

 accel/kvm/kvm-all.c        |  1 +
 include/sysemu/kvm_int.h   |  1 +
 qemu-options.hx            |  9 ++++++-
 target/i386/cpu.c          |  2 +-
 target/i386/kvm/kvm.c      | 52 ++++++++++++++++++++++++++++++++++++++
 target/i386/kvm/kvm_i386.h |  2 ++
 6 files changed, 65 insertions(+), 2 deletions(-)

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index 801cff16a5..8b5ba45cf7 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -3933,6 +3933,7 @@ static void kvm_accel_instance_init(Object *obj)
     s->xen_evtchn_max_pirq = 256;
     s->device = NULL;
     s->msr_energy.enable = false;
+    s->pmu_cap_disabled = false;
 }
 
 /**
diff --git a/include/sysemu/kvm_int.h b/include/sysemu/kvm_int.h
index a1e72763da..cdee1a481c 100644
--- a/include/sysemu/kvm_int.h
+++ b/include/sysemu/kvm_int.h
@@ -166,6 +166,7 @@ struct KVMState
     uint16_t xen_gnttab_max_frames;
     uint16_t xen_evtchn_max_pirq;
     char *device;
+    bool pmu_cap_disabled;
 };
 
 void kvm_memory_listener_register(KVMState *s, KVMMemoryListener *kml,
diff --git a/qemu-options.hx b/qemu-options.hx
index dacc9790a4..9684424835 100644
--- a/qemu-options.hx
+++ b/qemu-options.hx
@@ -191,7 +191,8 @@ DEF("accel", HAS_ARG, QEMU_OPTION_accel,
     "                eager-split-size=n (KVM Eager Page Split chunk size, default 0, disabled. ARM only)\n"
     "                notify-vmexit=run|internal-error|disable,notify-window=n (enable notify VM exit and set notify window, x86 only)\n"
     "                thread=single|multi (enable multi-threaded TCG)\n"
-    "                device=path (KVM device path, default /dev/kvm)\n", QEMU_ARCH_ALL)
+    "                device=path (KVM device path, default /dev/kvm)\n"
+    "                pmu-cap-disabled=true|false (disable KVM_CAP_PMU_CAPABILITY, x86 only, default false)\n", QEMU_ARCH_ALL)
 SRST
 ``-accel name[,prop=value[,...]]``
     This is used to enable an accelerator. Depending on the target
@@ -277,6 +278,12 @@ SRST
         option can be used to pass the KVM device to use via a file descriptor
         by setting the value to ``/dev/fdset/NN``.
 
+    ``pmu-cap-disabled=true|false``
+        When using the KVM accelerator, it controls the disabling of
+        KVM_CAP_PMU_CAPABILITY via KVM_PMU_CAP_DISABLE. When this capability is
+        disabled, PMU virtualization is turned off at the KVM module level.
+        Note that this functionality is supported for x86 hosts only.
+
 ERST
 
 DEF("smp", HAS_ARG, QEMU_OPTION_smp,
diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index 4490a7a8d6..c97ed74a47 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -7102,7 +7102,7 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
     case 0x80000022:
         *eax = *ebx = *ecx = *edx = 0;
         /* AMD Extended Performance Monitoring and Debug */
-        if (kvm_enabled() && cpu->enable_pmu &&
+        if (kvm_enabled() && cpu->enable_pmu && !kvm_pmu_cap_disabled() &&
             (env->features[FEAT_8000_0001_ECX] & CPUID_EXT3_PERFCORE) &&
             (env->features[FEAT_8000_0022_EAX] & CPUID_8000_0022_EAX_PERFMON_V2)) {
             *eax |= CPUID_8000_0022_EAX_PERFMON_V2;
diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index 8e17942c3b..ed73b1e7e0 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -166,6 +166,7 @@ static bool has_msr_vmx_procbased_ctls2;
 static bool has_msr_perf_capabs;
 static bool has_msr_pkrs;
 static bool has_msr_hwcr;
+static bool has_pmu_cap;
 
 static uint32_t has_architectural_pmu_version;
 static uint32_t num_architectural_pmu_gp_counters;
@@ -3196,6 +3197,11 @@ static void kvm_vm_enable_energy_msrs(KVMState *s)
     return;
 }
 
+bool kvm_pmu_cap_disabled(void)
+{
+    return kvm_state->pmu_cap_disabled;
+}
+
 int kvm_arch_init(MachineState *ms, KVMState *s)
 {
     int ret;
@@ -3335,6 +3341,23 @@ int kvm_arch_init(MachineState *ms, KVMState *s)
         }
     }
 
+    has_pmu_cap = kvm_check_extension(s, KVM_CAP_PMU_CAPABILITY);
+
+    if (s->pmu_cap_disabled) {
+        if (has_pmu_cap) {
+            ret = kvm_vm_enable_cap(s, KVM_CAP_PMU_CAPABILITY, 0,
+                                    KVM_PMU_CAP_DISABLE);
+            if (ret < 0) {
+                s->pmu_cap_disabled = false;
+                error_report("kvm: Failed to disable pmu cap: %s",
+                             strerror(-ret));
+            }
+        } else {
+            s->pmu_cap_disabled = false;
+            error_report("kvm: KVM_CAP_PMU_CAPABILITY is not supported");
+        }
+    }
+
     return 0;
 }
 
@@ -6525,6 +6548,29 @@ static void kvm_arch_set_xen_evtchn_max_pirq(Object *obj, Visitor *v,
     s->xen_evtchn_max_pirq = value;
 }
 
+static void kvm_set_pmu_cap_disabled(Object *obj, Visitor *v,
+                                     const char *name, void *opaque,
+                                     Error **errp)
+{
+    KVMState *s = KVM_STATE(obj);
+    bool pmu_cap_disabled;
+    Error *error = NULL;
+
+    if (s->fd != -1) {
+        error_setg(errp, "Cannot set properties after the accelerator has "
+                         "been initialized");
+        return;
+    }
+
+    visit_type_bool(v, name, &pmu_cap_disabled, &error);
+    if (error) {
+        error_propagate(errp, error);
+        return;
+    }
+
+    s->pmu_cap_disabled = pmu_cap_disabled;
+}
+
 void kvm_arch_accel_class_init(ObjectClass *oc)
 {
     object_class_property_add_enum(oc, "notify-vmexit", "NotifyVMexitOption",
@@ -6564,6 +6610,12 @@ void kvm_arch_accel_class_init(ObjectClass *oc)
                               NULL, NULL);
     object_class_property_set_description(oc, "xen-evtchn-max-pirq",
                                           "Maximum number of Xen PIRQs");
+
+    object_class_property_add(oc, "pmu-cap-disabled", "bool",
+                              NULL, kvm_set_pmu_cap_disabled,
+                              NULL, NULL);
+    object_class_property_set_description(oc, "pmu-cap-disabled",
+                                          "Disable KVM_CAP_PMU_CAPABILITY");
 }
 
 void kvm_set_max_apic_id(uint32_t max_apic_id)
diff --git a/target/i386/kvm/kvm_i386.h b/target/i386/kvm/kvm_i386.h
index 9de9c0d303..03522de9d1 100644
--- a/target/i386/kvm/kvm_i386.h
+++ b/target/i386/kvm/kvm_i386.h
@@ -49,6 +49,8 @@ uint64_t kvm_arch_get_supported_msr_feature(KVMState *s, uint32_t index);
 void kvm_set_max_apic_id(uint32_t max_apic_id);
 void kvm_request_xsave_components(X86CPU *cpu, uint64_t mask);
 
+bool kvm_pmu_cap_disabled(void);
+
 #ifdef CONFIG_KVM
 
 bool kvm_is_vm_type_supported(int type);
-- 
2.39.3


