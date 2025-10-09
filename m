Return-Path: <kvm+bounces-59697-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 21881BC8665
	for <lists+kvm@lfdr.de>; Thu, 09 Oct 2025 12:04:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EB5C93AC225
	for <lists+kvm@lfdr.de>; Thu,  9 Oct 2025 10:04:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 47C7F2D77FF;
	Thu,  9 Oct 2025 10:04:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="a9a7pAkg"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7517E1EF36B
	for <kvm@vger.kernel.org>; Thu,  9 Oct 2025 10:04:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760004259; cv=none; b=WRUTi6u3glbUPgtJNli6EpyKsDVizaGRmTH4ut/VnEk419f/HSGeHXQIuWGyJgVOHnDWFrOBJpFWfTrpkRtH2UxS4sMzuasGaSPu+pYoFEl7Cq9NR8KgQxPOO3qh9yK3SZWNoExSuGCgoDPUlnTOFQzrTEDPZrYTlawNKK7OKys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760004259; c=relaxed/simple;
	bh=2gVCDPu3YfJeSTX7WFhgTDshtR7sqC1jsHNW+IknaJs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=lCeGIysofXB+T1M5euOhBBCN3l1cJIsAtgX/v4i4v8REEu7QjQ6G0D6iwsRgBSljzhNch85tQpdcr15CeClUTRTktYDWJcHIPnu5bIVjdMhKSiQDQBEQOe0hFS49CNDDDVd+ZJmPSEIixf9kYLqnlYJHrraRq5Ur7DrCSaDuXVk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=a9a7pAkg; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5997u4Ux011879;
	Thu, 9 Oct 2025 10:03:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=corp-2025-04-25; bh=lwGExlen9vGR1GGrrc9JkUD+Tt+Pq
	wW6A8dF9YCEiSE=; b=a9a7pAkgKG0KqF4P+9iCwVKr9rjkNLSqhfQENkyvSSv41
	D9J/x+zDoCI7vbWcUsw4O4IMrWy4cxL9IipupHNgTWaNtFCJIi/udDOnJLaYep0I
	Nks0GsIzE2eRrZ9CyKuUD/iXNvyZUAWwz5OfNcQDsW3piN1ca4AeYDR066bbxqT5
	lMOYZeNwZTRj7wadxmTMjcjcQgna0evavG9o944dDU7pVIdiqDQub4bNJmjP7LBW
	LZI1mT8Fjf8otxvRtRsnMSx5j1BmEBM4wir8c8szkEePMNQB2Kn5F/5rJPCSi+IB
	hW18eDe3OUSsYiJVJ/Z9Eu1wnb0giK6lpySzNzhYg==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49nv8ps9jj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 09 Oct 2025 10:03:42 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5999EWtY014356;
	Thu, 9 Oct 2025 10:03:41 GMT
Received: from localhost.localdomain (ca-dev80.us.oracle.com [10.211.9.80])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 49nv675q79-1;
	Thu, 09 Oct 2025 10:03:41 +0000
From: Dongli Zhang <dongli.zhang@oracle.com>
To: qemu-devel@nongnu.org, kvm@vger.kernel.org
Cc: mst@redhat.com, marcel.apfelbaum@gmail.com, pbonzini@redhat.com,
        richard.henderson@linaro.org, eduardo@habkost.net, mtosatti@redhat.com,
        dwmw2@infradead.org
Subject: [PATCH 1/1] target/i386/kvm: account blackout downtime for kvm-clock and guest TSC
Date: Thu,  9 Oct 2025 02:58:31 -0700
Message-ID: <20251009095831.46297-1-dongli.zhang@oracle.com>
X-Mailer: git-send-email 2.43.5
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-09_03,2025-10-06_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 malwarescore=0 adultscore=0 phishscore=0 spamscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510020000 definitions=main-2510090057
X-Proofpoint-GUID: kaw1_-jQqB3EgdylB7zItoGPa0D-ZRng
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDA4MDEyMiBTYWx0ZWRfXwZqAONGOX9Zc
 jiIXfvHeCfmKss07VAcijO8VdjONKPeiRR6aY+v+ntInG5sbDaFn6OaCBcpqQaGubmIAWzQr9TV
 JsF+u1U4krx6XsLX2uJ/PJMfaJC/WRAw+TLOJyEawAQXGpLvUfU3/yAm0jacJf/9ccfc/65MhsS
 nqVmRvFqqi37dA9v2tcf5qfT2WsfI+dI+7zwT1W1/vTQhWmnzhC8mHP8NZdTJIksv/h6IBwa7L2
 sM9wpQwAdRECyyhfx+sNIZ4ZbcxzipIhosF275UC1PpF4WOZ+x3JVEcD1Lgqm19oVNY4ldvDoCe
 DMt0fdTVjhd+9CpfEjpFdi9myiD0Di7inDIyQMONqMTDUqvau5e7kN5KFySHcnXnoIl2aCWEsL5
 TQxtBcDT1A4Blhq7tVLBgajKgKTUIg==
X-Proofpoint-ORIG-GUID: kaw1_-jQqB3EgdylB7zItoGPa0D-ZRng
X-Authority-Analysis: v=2.4 cv=U6SfzOru c=1 sm=1 tr=0 ts=68e7887e cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=x6icFKpwvdMA:10 a=VwQbUJbxAAAA:8 a=1XWaLZrsAAAA:8 a=yPCof4ZbAAAA:8
 a=JfrnYn6hAAAA:8 a=Zv9mPx-HKjNCLyymYHQA:9 a=KH3HcEfJi14A:10
 a=1CNFftbPRP8L7MoqJWF3:22 a=cPQSjfK2_nFv0Q5t_7PE:22

So far, QEMU/KVM live migration does not account all elapsed blackout
downtimes. For example, if a guest is live-migrated to a file, left idle
for one hour, and then restored from that file to the target host, the
one-hour blackout period will not be reflected in the kvm-clock or guest
TSC.

Typically, the elapsed time between KVM_GET_CLOCK (on the source QEMU) and
KVM_SET_CLOCK (on the target QEMU) is not accounted in the kvm-clock.
Similarly, the elapsed time between reading MSR_IA32_TSC on the source QEMU
and writing it on the target QEMU is not reflected in the guest TSC.

The KVM patchset [1] introduced KVM_VCPU_TSC_CTRL, KVM_CLOCK_REALTIME, and
KVM_CLOCK_HOST_TSC to account the elapsed time during live migration
blackouts in the guest's system counter view.

The core idea is to use the realtime clock (KVM_CLOCK_REALTIME) from both
the source and target hosts as a reference to calculate the elapsed
downtime in nanoseconds and adjust kvm-clock. In addition, these
nanoseconds are converted into TSC cycles using the vCPU's virtual TSC
frequency, and the corresponding elapsed cycles are compensated in the
guest TSC as well (KVM_CLOCK_HOST_TSC and KVM_VCPU_TSC_CTRL).

The following steps are copied from the Linux kernel documentation [2].

From the source VMM process:

1. Invoke the KVM_GET_CLOCK ioctl to record the host TSC (tsc_src),
kvmclock nanoseconds (guest_src), and host CLOCK_REALTIME nanoseconds
(host_src).

2. Read the KVM_VCPU_TSC_OFFSET attribute for every vCPU to record the
guest TSC offset (ofs_src[i]).

3. Invoke the KVM_GET_TSC_KHZ ioctl to record the frequency of the guest's
TSC (freq).

From the destination VMM process:

4. Invoke the KVM_SET_CLOCK ioctl, providing the source nanoseconds from
kvmclock (guest_src) and CLOCK_REALTIME (host_src) in their respective
fields. Ensure that the KVM_CLOCK_REALTIME flag is set in the provided
structure.

KVM will advance the VM's kvmclock to account for elapsed time since
recording the clock values. Note that this will cause problems in the guest
(e.g., timeouts) unless CLOCK_REALTIME is synchronized between the source
and destination, and a reasonably short time passes between the source
pausing the VMs and the destination executing steps 4-7.

5. Invoke the KVM_GET_CLOCK ioctl to record the host TSC (tsc_dest) and
kvmclock nanoseconds (guest_dest).

6. Adjust the guest TSC offsets for every vCPU to account for (1) time
elapsed since recording state and (2) difference in TSCs between the
source and destination machine:

ofs_dst[i] = ofs_src[i] -
    (guest_src - guest_dest) * freq + (tsc_src - tsc_dest)

("ofs[i] + tsc - guest * freq" is the guest TSC value corresponding to a
time of 0 in kvmclock. The above formula ensures that it is the same on
the destination as it was on the source).

7. Write the KVM_VCPU_TSC_OFFSET attribute for every vCPU with the
respective value derived in the previous step.

Introduce 'realtime', 'host_tsc', and 'flags' fields to KVMClockState,
and enable their live migration. Re-use CPUX86State->tsc_offset (currently
used by TCG) for the KVM accelerator.

References:
[1] https://lore.kernel.org/all/20210916181538.968978-8-oupton@google.com/
[2] https://docs.kernel.org/virt/kvm/devices/vcpu.html
[3] https://lore.kernel.org/qemu-devel/2d375ec3-a071-4ae3-b03a-05a823c48016@oracle.com/

Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
---
This patch takes advantage of existing mainline linux kernel features,
excluding WIP features:
https://lore.kernel.org/all/20240522001817.619072-8-dwmw2@infradead.org/

 hw/i386/kvm/clock.c        | 89 +++++++++++++++++++++++++++++++++++++-
 hw/i386/pc.c               |  4 +-
 target/i386/kvm/kvm.c      | 73 +++++++++++++++++++++++++++++++
 target/i386/kvm/kvm_i386.h |  6 +++
 4 files changed, 170 insertions(+), 2 deletions(-)

diff --git a/hw/i386/kvm/clock.c b/hw/i386/kvm/clock.c
index f56382717f..b0fd18ac0c 100644
--- a/hw/i386/kvm/clock.c
+++ b/hw/i386/kvm/clock.c
@@ -38,6 +38,9 @@ struct KVMClockState {
     /*< public >*/
 
     uint64_t clock;
+    uint64_t realtime;
+    uint64_t host_tsc;
+    uint32_t flags;
     bool clock_valid;
 
     /* whether the 'clock' value was obtained in the 'paused' state */
@@ -49,6 +52,12 @@ struct KVMClockState {
     /* whether the 'clock' value was obtained in a host with
      * reliable KVM_GET_CLOCK */
     bool clock_is_reliable;
+
+    /*
+     * whether to account downtimes by taking advantage of
+     * KVM_CLOCK_REALTIME, KVM_CLOCK_HOST_TSC and KVM_VCPU_TSC_CTRL.
+     */
+    bool account_downtime;
 };
 
 struct pvclock_vcpu_time_info {
@@ -100,6 +109,7 @@ static uint64_t kvmclock_current_nsec(KVMClockState *s)
 static void kvm_update_clock(KVMClockState *s)
 {
     struct kvm_clock_data data;
+    bool has_aux;
     int ret;
 
     ret = kvm_vm_ioctl(kvm_state, KVM_GET_CLOCK, &data);
@@ -109,6 +119,18 @@ static void kvm_update_clock(KVMClockState *s)
     }
     s->clock = data.clock;
 
+    s->realtime = 0;
+    s->host_tsc = 0;
+    s->flags = 0;
+
+    has_aux = with_kvmclock_aux_flags(data.flags);
+
+    if (s->account_downtime && kvm_support_clock_downtime() && has_aux) {
+        s->realtime = data.realtime;
+        s->host_tsc = data.host_tsc;
+        s->flags = data.flags & KVM_CLOCK_AUX_FLAGS;
+    }
+
     /* If kvm_has_adjust_clock_stable() is false, KVM_GET_CLOCK returns
      * essentially CLOCK_MONOTONIC plus a guest-specific adjustment.  This
      * can drift from the TSC-based value that is computed by the guest,
@@ -160,6 +182,30 @@ static void do_kvmclock_ctrl(CPUState *cpu, run_on_cpu_data data)
     }
 }
 
+static void kvmclock_adjust_tsc_offset(KVMClockState *s)
+{
+    CPUX86State *env = cpu_env(first_cpu);
+    struct kvm_clock_data data;
+    uint64_t delta;
+    int ret;
+
+    ret = kvm_vm_ioctl(kvm_state, KVM_GET_CLOCK, &data);
+    if (ret < 0) {
+        fprintf(stderr, "KVM_GET_CLOCK failed: %s\n", strerror(-ret));
+        abort();
+    }
+
+    if (!with_kvmclock_aux_flags(data.flags)) {
+        fprintf(stderr, "warning: cannot adjust tsc offset\n");
+        return;
+    }
+
+    delta = ((data.clock - s->clock) * env->tsc_khz + 999999) / 1000000 +
+            (s->host_tsc - data.host_tsc);
+
+    kvm_write_all_tsc_offset(delta);
+}
+
 static void kvmclock_vm_state_change(void *opaque, bool running,
                                      RunState state)
 {
@@ -170,6 +216,7 @@ static void kvmclock_vm_state_change(void *opaque, bool running,
 
     if (running) {
         struct kvm_clock_data data = {};
+        bool account_downtime;
 
         /*
          * If the host where s->clock was read did not support reliable
@@ -184,14 +231,28 @@ static void kvmclock_vm_state_change(void *opaque, bool running,
         }
 
         s->clock_valid = false;
-
         data.clock = s->clock;
+
+        account_downtime = s->account_downtime &&
+            kvm_support_clock_downtime() &&
+            with_kvmclock_aux_flags(s->flags);
+
+        if (account_downtime) {
+            data.realtime = s->realtime;
+            data.host_tsc = s->host_tsc;
+            data.flags = s->flags & KVM_CLOCK_AUX_FLAGS;
+        }
+
         ret = kvm_vm_ioctl(kvm_state, KVM_SET_CLOCK, &data);
         if (ret < 0) {
             fprintf(stderr, "KVM_SET_CLOCK failed: %s\n", strerror(-ret));
             abort();
         }
 
+        if (account_downtime) {
+            kvmclock_adjust_tsc_offset(s);
+        }
+
         if (!cap_clock_ctrl) {
             return;
         }
@@ -250,6 +311,26 @@ static const VMStateDescription kvmclock_reliable_get_clock = {
     }
 };
 
+static bool kvmclock_account_downtime(void *opaque)
+{
+    KVMClockState *s = opaque;
+
+    return s->account_downtime;
+}
+
+static const VMStateDescription kvmclock_auxiliary = {
+    .name = "kvmclock/auxiliary",
+    .version_id = 1,
+    .minimum_version_id = 1,
+    .needed = kvmclock_account_downtime,
+    .fields = (VMStateField[]) {
+        VMSTATE_UINT32(flags, KVMClockState),
+        VMSTATE_UINT64(realtime, KVMClockState),
+        VMSTATE_UINT64(host_tsc, KVMClockState),
+        VMSTATE_END_OF_LIST()
+    }
+};
+
 /*
  * When migrating, assume the source has an unreliable
  * KVM_GET_CLOCK unless told otherwise.
@@ -259,6 +340,9 @@ static int kvmclock_pre_load(void *opaque)
     KVMClockState *s = opaque;
 
     s->clock_is_reliable = false;
+    s->realtime = 0;
+    s->host_tsc = 0;
+    s->flags = 0;
 
     return 0;
 }
@@ -300,6 +384,7 @@ static const VMStateDescription kvmclock_vmsd = {
     },
     .subsections = (const VMStateDescription * const []) {
         &kvmclock_reliable_get_clock,
+        &kvmclock_auxiliary,
         NULL
     }
 };
@@ -307,6 +392,8 @@ static const VMStateDescription kvmclock_vmsd = {
 static const Property kvmclock_properties[] = {
     DEFINE_PROP_BOOL("x-mach-use-reliable-get-clock", KVMClockState,
                       mach_use_reliable_get_clock, true),
+    DEFINE_PROP_BOOL("x-account-downtime", KVMClockState,
+                      account_downtime, true),
 };
 
 static void kvmclock_class_init(ObjectClass *klass, const void *data)
diff --git a/hw/i386/pc.c b/hw/i386/pc.c
index 34b00663f2..322375a2ca 100644
--- a/hw/i386/pc.c
+++ b/hw/i386/pc.c
@@ -81,7 +81,9 @@
     { "qemu64-" TYPE_X86_CPU, "model-id", "QEMU Virtual CPU version " v, },\
     { "athlon-" TYPE_X86_CPU, "model-id", "QEMU Virtual CPU version " v, },
 
-GlobalProperty pc_compat_10_1[] = {};
+GlobalProperty pc_compat_10_1[] = {
+    { "kvmclock", "x-account-downtime", "off" },
+};
 const size_t pc_compat_10_1_len = G_N_ELEMENTS(pc_compat_10_1);
 
 GlobalProperty pc_compat_10_0[] = {
diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index 6a3a1c1ed8..92930be353 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -178,6 +178,9 @@ static int has_triple_fault_event;
 
 static bool has_msr_mcg_ext_ctl;
 
+static bool has_kvmclock_aux;
+static bool has_tsc_offset;
+
 static struct kvm_cpuid2 *cpuid_cache;
 static struct kvm_cpuid2 *hv_cpuid_cache;
 static struct kvm_msr_list *kvm_feature_msrs;
@@ -259,6 +262,11 @@ bool kvm_has_exception_payload(void)
     return has_exception_payload;
 }
 
+bool kvm_support_clock_downtime(void)
+{
+    return has_kvmclock_aux && has_tsc_offset;
+}
+
 static bool kvm_x2apic_api_set_flags(uint64_t flags)
 {
     KVMState *s = KVM_STATE(current_accel());
@@ -304,6 +312,20 @@ static int kvm_get_tsc(CPUState *cs)
     uint64_t value;
     int ret;
 
+    if (kvm_support_clock_downtime()) {
+        struct kvm_device_attr attr;
+
+        attr.group = KVM_VCPU_TSC_CTRL;
+        attr.attr = KVM_VCPU_TSC_OFFSET;
+        attr.flags = 0;
+        attr.addr = (uint64_t)&env->tsc_offset;
+
+        ret = kvm_vcpu_ioctl(cs, KVM_GET_DEVICE_ATTR, &attr);
+        if (ret) {
+            return ret;
+        }
+    }
+
     if (env->tsc_valid) {
         return 0;
     }
@@ -335,6 +357,40 @@ void kvm_synchronize_all_tsc(void)
     }
 }
 
+static inline void do_kvm_write_tsc_offset(CPUState *cs, run_on_cpu_data arg)
+{
+    uint64_t delta = arg.host_ulong;
+    X86CPU *cpu = X86_CPU(cs);
+    CPUX86State *env = &cpu->env;
+    struct kvm_device_attr attr;
+    int ret;
+
+    env->tsc_offset += delta;
+
+    attr.group = KVM_VCPU_TSC_CTRL;
+    attr.attr = KVM_VCPU_TSC_OFFSET;
+    attr.flags = 0;
+    attr.addr = (uint64_t)&env->tsc_offset;
+
+    ret = kvm_vcpu_ioctl(cs, KVM_SET_DEVICE_ATTR, &attr);
+    if (ret) {
+        error_report("KVM_SET_DEVICE_ATTR: %s", strerror(-ret));
+        exit(1);
+    }
+}
+
+void kvm_write_all_tsc_offset(uint64_t delta)
+{
+    CPUState *cpu;
+
+    if (kvm_enabled() && !is_tdx_vm()) {
+        CPU_FOREACH(cpu) {
+            run_on_cpu(cpu, do_kvm_write_tsc_offset,
+                       RUN_ON_CPU_HOST_ULONG(delta));
+        }
+    }
+}
+
 static struct kvm_cpuid2 *try_get_cpuid(KVMState *s, int max)
 {
     struct kvm_cpuid2 *cpuid;
@@ -2378,6 +2434,18 @@ int kvm_arch_init_vcpu(CPUState *cs)
 
     kvm_init_msrs(cpu);
 
+    if (cs == first_cpu) {
+        struct kvm_device_attr attr = {
+            .group = KVM_VCPU_TSC_CTRL,
+            .attr = KVM_VCPU_TSC_OFFSET,
+            .flags = 0,
+        };
+
+        if (!kvm_vcpu_ioctl(cs, KVM_HAS_DEVICE_ATTR, &attr)) {
+            has_tsc_offset = true;
+        }
+    }
+
     return 0;
 
  fail:
@@ -3371,6 +3439,11 @@ int kvm_arch_init(MachineState *ms, KVMState *s)
         }
     }
 
+    ret = kvm_check_extension(s, KVM_CAP_ADJUST_CLOCK);
+    if (ret) {
+        has_kvmclock_aux = with_kvmclock_aux_flags(ret);
+    }
+
     return 0;
 }
 
diff --git a/target/i386/kvm/kvm_i386.h b/target/i386/kvm/kvm_i386.h
index 5f83e8850a..0f658527f0 100644
--- a/target/i386/kvm/kvm_i386.h
+++ b/target/i386/kvm/kvm_i386.h
@@ -51,10 +51,16 @@ typedef struct KvmCpuidInfo {
     struct kvm_cpuid_entry2 entries[KVM_MAX_CPUID_ENTRIES];
 } KvmCpuidInfo;
 
+#define KVM_CLOCK_AUX_FLAGS (KVM_CLOCK_REALTIME | KVM_CLOCK_HOST_TSC)
+#define with_kvmclock_aux_flags(flags) \
+    ((flags & KVM_CLOCK_AUX_FLAGS) == KVM_CLOCK_AUX_FLAGS)
+
 bool kvm_is_vm_type_supported(int type);
 bool kvm_has_adjust_clock_stable(void);
 bool kvm_has_exception_payload(void);
+bool kvm_support_clock_downtime(void);
 void kvm_synchronize_all_tsc(void);
+void kvm_write_all_tsc_offset(uint64_t delta);
 
 void kvm_get_apic_state(DeviceState *d, struct kvm_lapic_state *kapic);
 void kvm_put_apicbase(X86CPU *cpu, uint64_t value);
-- 
2.39.3


