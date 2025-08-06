Return-Path: <kvm+bounces-54096-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4B320B1C268
	for <lists+kvm@lfdr.de>; Wed,  6 Aug 2025 10:49:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 66A9A7A186D
	for <lists+kvm@lfdr.de>; Wed,  6 Aug 2025 08:47:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6FAA5270EC1;
	Wed,  6 Aug 2025 08:49:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=rsg.ci.i.u-tokyo.ac.jp header.i=@rsg.ci.i.u-tokyo.ac.jp header.b="hQhHqmmz"
X-Original-To: kvm@vger.kernel.org
Received: from www3579.sakura.ne.jp (www3579.sakura.ne.jp [49.212.243.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69EF0367
	for <kvm@vger.kernel.org>; Wed,  6 Aug 2025 08:49:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=49.212.243.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754470158; cv=none; b=LKAl9bSSmJrP5Fr4Y+tfPXo+MGzdGPnym0DMfed8tJJRs+TnpHXX0lfxCALrI6k56vZyBNyHGXfZeUDGaKU+6PZQG8gyTfu1e06eJFkFoqqBmxoZ/3FfiB/mxBawW0kUHE3POW3XVma70/e17Zjma/LuC7LpLagDEax8uuBC8Qc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754470158; c=relaxed/simple;
	bh=bcfnuyg9XdVAUV7e12buB8UsANlxLZCpn9KBH0nrc+U=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=UWo5y/bt/RpNwt36J2fV37F53V1NzZBtMs84fGN5+R8idhf5GP79dUGnvv7uCV7XfOLKVsxNoMeAbvWmEFOApj3Q0jGikrHw3aT3kjdn7OuWI1QCAXL3gsF+B0xcUNjJZmD6Z0vafTao6GxXtdbV/syZ50+Rz5tS++MtmkL54C4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rsg.ci.i.u-tokyo.ac.jp; spf=pass smtp.mailfrom=rsg.ci.i.u-tokyo.ac.jp; dkim=fail (0-bit key) header.d=rsg.ci.i.u-tokyo.ac.jp header.i=@rsg.ci.i.u-tokyo.ac.jp header.b=hQhHqmmz reason="key not found in DNS"; arc=none smtp.client-ip=49.212.243.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rsg.ci.i.u-tokyo.ac.jp
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rsg.ci.i.u-tokyo.ac.jp
Received: from h205.csg.ci.i.u-tokyo.ac.jp (h205.csg.ci.i.u-tokyo.ac.jp [133.11.54.205])
	(authenticated bits=0)
	by www3579.sakura.ne.jp (8.16.1/8.16.1) with ESMTPSA id 5768mqW0098507
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Wed, 6 Aug 2025 17:49:06 +0900 (JST)
	(envelope-from odaki@rsg.ci.i.u-tokyo.ac.jp)
DKIM-Signature: a=rsa-sha256; bh=WLF/L6fgTCzFt+haK6Eq3Htky80jMkJDx/lrXfxmmRg=;
        c=relaxed/relaxed; d=rsg.ci.i.u-tokyo.ac.jp;
        h=From:Date:Subject:Message-Id:To;
        s=rs20250326; t=1754470146; v=1;
        b=hQhHqmmzEIw/YFxlQ0FFvuUNviA1ncKivKVlpRE3YHIG71/uhfpnwOTgApk4JQJN
         N5yNheJ1muMkIXgRVV9tCtcl26+W0DiNppIVrNp4cdlHG0T06TU2WQpWhNiRxR4b
         MfMoncaHlhJ00WKp7vfUKnfmqu6JjUQ/IO4Pv2qvklnQhGtlGU8MDNXsBkuZlis+
         DFtu7D4oxqj80d7XKmbiwC4u1qOabo4imKUczwtoZH054vTIAo+ogft8L2hgH7IX
         xZ4kwc2ScYVvau9SUpuZJcMqJSnflAPbMwRSeBZLT2D/7RxquxtWD+Alww6r8/5R
         3z1lYlhrFbfTr2kTx+Plig==
From: Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
Date: Wed, 06 Aug 2025 17:48:40 +0900
Subject: [PATCH RFC] target/arm/kvm: Choose PMU backend
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250806-kvm-v1-1-d1d50b7058cd@rsg.ci.i.u-tokyo.ac.jp>
X-B4-Tracking: v=1; b=H4sIAOcWk2gC/6tWKk4tykwtVrJSqFYqSi3LLM7MzwNyDHUUlJIzE
 vPSU3UzU4B8JSMDI1MDc2MD3eyyXF2LtGQDs2SLNHMjo0QloMqCotS0zAqwKdFKQW7OSrG1tQA
 7r8fXWgAAAA==
X-Change-ID: 20250730-kvm-8fc06c8f722a
To: qemu-devel@nongnu.org
Cc: Eduardo Habkost <eduardo@habkost.net>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        =?utf-8?q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        Yanan Wang <wangyanan55@huawei.com>, Zhao Liu <zhao1.liu@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>, kvm@vger.kernel.org,
        qemu-arm@nongnu.org, Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
X-Mailer: b4 0.14.2

Commit 6ee7fca2a4a0 ("KVM: arm64: Add KVM_ARM_VCPU_PMU_V3_SET_PMU
attribute") of Linux describes the KVM_ARM_VCPU_PMU_V3_SET_PMU
attribute, which allows choosing a PMU backend, and its motivation:
> KVM: arm64: Add KVM_ARM_VCPU_PMU_V3_SET_PMU attribute
>
> When KVM creates an event and there are more than one PMUs present on
> the system, perf_init_event() will go through the list of available
> PMUs and will choose the first one that can create the event. The
> order of the PMUs in this list depends on the probe order, which can
> change under various circumstances, for example if the order of the
> PMU nodes change in the DTB or if asynchronous driver probing is
> enabled on the kernel command line (with the
> driver_async_probe=armv8-pmu option).
>
> Another consequence of this approach is that on heteregeneous systems
> all virtual machines that KVM creates will use the same PMU. This
> might cause unexpected behaviour for userspace: when a VCPU is
> executing on the physical CPU that uses this default PMU, PMU events
> in the guest work correctly; but when the same VCPU executes on
> another CPU, PMU events in the guest will suddenly stop counting.
>
> Fortunately, perf core allows user to specify on which PMU to create
> an event by using the perf_event_attr->type field, which is used by
> perf_init_event() as an index in the radix tree of available PMUs.
>
> Add the KVM_ARM_VCPU_PMU_V3_CTRL(KVM_ARM_VCPU_PMU_V3_SET_PMU) VCPU
> attribute to allow userspace to specify the arm_pmu that KVM will use
> when creating events for that VCPU. KVM will make no attempt to run
> the VCPU on the physical CPUs that share the PMU, leaving it up to
> userspace to manage the VCPU threads' affinity accordingly.
>
> To ensure that KVM doesn't expose an asymmetric system to the guest,
> the PMU set for one VCPU will be used by all other VCPUs. Once a VCPU
> has run, the PMU cannot be changed in order to avoid changing the
> list of available events for a VCPU, or to change the semantics of
> existing events.

Choose a PMU backend with the following priority order:

1. The event source specified with the kvm-pmu property. It is a user's
   responsibility to ensure that the VCPUs runs on PCPUs associated with
   the event source.

2. The default backend if the machine version is old. This ensures
   backward compatibility but the resulting PMU may or may not work.

3. An event source that covers all PCPUs. This exposes its full feature
   set to the guest. If multiple such physical PMUs exist, selection is
   deterministic, based on device hierarchy.

4. The composite PMU if composing all compatible event sources can cover
   all PCPUs. It will expose only a single cycle counter.

Disable PMU if no backend can be chosen.

Signed-off-by: Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
---
Based-on: <20250531-pmu-v6-1-2bb6c828ade3@rsg.ci.i.u-tokyo.ac.jp>
("[PATCH v6] target/arm: Always add pmu property for host")

This is an RFC patch to demonstrate the usage of a new device attribute
which will be added with a new version of the following series:
https://lore.kernel.org/r/20250319-hybrid-v1-1-4d1ada10e705@daynix.com/
("[PATCH RFC] KVM: arm64: PMU: Use multiple host PMUs")
---
 include/system/kvm_int.h |   2 +
 hw/core/machine.c        |   2 +
 target/arm/kvm.c         | 342 +++++++++++++++++++++++++++++++++++++++++++++--
 qemu-options.hx          |  20 +++
 target/arm/trace-events  |   2 +
 5 files changed, 357 insertions(+), 11 deletions(-)

diff --git a/include/system/kvm_int.h b/include/system/kvm_int.h
index 9247493b029912547e284c5177fe9b6ee10e6b04..dd925565d4fa64b132d7e81c32cdb7eaaab53146 100644
--- a/include/system/kvm_int.h
+++ b/include/system/kvm_int.h
@@ -157,6 +157,8 @@ struct KVMState
     uint64_t kvm_dirty_ring_bytes;  /* Size of the per-vcpu dirty ring */
     uint32_t kvm_dirty_ring_size;   /* Number of dirty GFNs per ring */
     bool kvm_dirty_ring_with_bitmap;
+    bool backcompat_pmu;
+    uint64_t pmu;
     uint64_t kvm_eager_split_size;  /* Eager Page Splitting chunk size */
     struct KVMDirtyRingReaper reaper;
     struct KVMMsrEnergy msr_energy;
diff --git a/hw/core/machine.c b/hw/core/machine.c
index bd47527479a7947ca293a47c9a6f49916d24bad3..b2d67a068c39336fbd3fceb3b0afbaaf8d7de959 100644
--- a/hw/core/machine.c
+++ b/hw/core/machine.c
@@ -23,6 +23,7 @@
 #include "qemu/madvise.h"
 #include "qom/object_interfaces.h"
 #include "system/cpus.h"
+#include "system/kvm.h"
 #include "system/system.h"
 #include "system/reset.h"
 #include "system/runstate.h"
@@ -38,6 +39,7 @@
 #include "audio/audio.h"
 
 GlobalProperty hw_compat_10_0[] = {
+    { TYPE_KVM_ACCEL, "backcompat-pmu", "true" },
     { "scsi-hd", "dpofua", "off" },
     { "vfio-pci", "x-migration-load-config-after-iter", "off" },
     { "ramfb", "use-legacy-x86-rom", "true"},
diff --git a/target/arm/kvm.c b/target/arm/kvm.c
index 667234485547a71c3da72c197629c45b215e6408..a604880699a6ac4bee53c7f23a44b93a160dcbe2 100644
--- a/target/arm/kvm.c
+++ b/target/arm/kvm.c
@@ -15,6 +15,7 @@
 
 #include <linux/kvm.h>
 
+#include "qemu/cutils.h"
 #include "qemu/timer.h"
 #include "qemu/error-report.h"
 #include "qemu/main-loop.h"
@@ -42,6 +43,8 @@
 #include "target/arm/gtimer.h"
 #include "migration/blocker.h"
 
+#define KVM_ARM_VCPU_PMU_V3_COMPOSITION 5
+
 const KVMCapabilityInfo kvm_arch_required_capabilities[] = {
     KVM_CAP_INFO(DEVICE_CTRL),
     KVM_CAP_LAST_INFO
@@ -51,12 +54,21 @@ static bool cap_has_mp_state;
 static bool cap_has_inject_serror_esr;
 static bool cap_has_inject_ext_dabt;
 
+typedef enum PMU {
+    PMU_NONE,
+    PMU_DEFAULT,
+    PMU_SINGLE,
+    PMU_COMPOSITE
+} PMU;
+
 /**
  * ARMHostCPUFeatures: information about the host CPU (identified
  * by asking the host kernel)
  */
 typedef struct ARMHostCPUFeatures {
     ARMISARegisters isar;
+    PMU pmu;
+    uint32_t pmu_single_type;
     uint64_t features;
     uint32_t target;
     const char *dtb_compatible;
@@ -219,6 +231,251 @@ static bool kvm_arm_pauth_supported(void)
             kvm_check_extension(kvm_state, KVM_CAP_ARM_PTRAUTH_GENERIC));
 }
 
+static bool read_pmu_attr(int fd, const struct dirent *ent, const char *name,
+                          char **buf, size_t *n)
+{
+    FILE *attr_file;
+    g_autofree char *rel_name = g_build_filename(ent->d_name, name, NULL);
+    int attr_fd = openat(fd, rel_name, O_RDONLY);
+    bool ret;
+
+    if (attr_fd < 0) {
+        return false;
+    }
+
+    attr_file = fdopen(attr_fd, "r");
+    assert(attr_file);
+    ret = getline(buf, n, attr_file) >= 0;
+    assert(!fclose(attr_file));
+
+    return ret;
+}
+
+static bool parse_cpus(const char *list, unsigned long **bitmap,
+                       unsigned long *nr)
+{
+    unsigned long start, end;
+
+    bitmap_clear(*bitmap, 0, *nr);
+
+    while (*list && *list != '\n') {
+        if (qemu_strtoul(list, &list, 0, &start) == -EINVAL) {
+            return false;
+        }
+
+        if (*list == '-') {
+            if (qemu_strtoul(list + 1, &list, 0, &end) == -EINVAL) {
+                return false;
+            }
+
+            if (end < start) {
+                return false;
+            }
+        } else {
+            end = start;
+        }
+
+        if (end > *nr) {
+            unsigned long new_nr = ROUND_UP(end, BITS_PER_LONG);
+            *bitmap = g_realloc(*bitmap, new_nr / BITS_PER_BYTE);
+            bitmap_clear(*bitmap, *nr, new_nr);
+            *nr = new_nr;
+        }
+
+        bitmap_set(*bitmap, start, end - start + 1);
+
+        if (*list == ',') {
+            list++;
+        }
+    }
+
+    return true;
+}
+
+static int set_pmu(int fd, uint32_t type)
+{
+    int ret = kvm_device_access(fd, KVM_ARM_VCPU_PMU_V3_CTRL,
+                                KVM_ARM_VCPU_PMU_V3_SET_PMU, &type, true, NULL);
+    trace_kvm_arm_set_pmu(type, ret);
+    return ret;
+}
+
+static PMU choose_pmu(uint32_t *single_type, bool backcompat)
+{
+    DIR *devices = NULL;
+    FILE *file;
+    PMU pmu = PMU_NONE;
+    size_t n = 64;
+    g_autofree char *buf = g_malloc(n);
+    g_autofree unsigned long *possible_cpus = NULL;
+    g_autofree unsigned long *pmu_cpus = NULL;
+    int devices_fd;
+    int fdarray[3];
+    struct dirent *ent;
+    unsigned long npossible_cpus = 0;
+    unsigned long npmu_cpus;
+    ssize_t ret;
+
+    struct kvm_vcpu_init init = {
+        .target = -1,
+        .features[0] = BIT(KVM_ARM_VCPU_PMU_V3),
+    };
+
+    if (backcompat) {
+        return PMU_DEFAULT;
+    }
+
+    file = fopen("/sys/devices/system/cpu/possible", "r");
+    if (!file) {
+        goto out;
+    }
+
+    ret = getline(&buf, &n, file);
+    assert(!fclose(file));
+    if (ret < 0) {
+        goto out;
+    }
+
+    if (!parse_cpus(buf, &possible_cpus, &npossible_cpus)) {
+        goto out;
+    }
+
+    npmu_cpus = npossible_cpus;
+    pmu_cpus = bitmap_new(npmu_cpus);
+
+    if (!kvm_arm_create_scratch_host_vcpu(fdarray, &init)) {
+        goto out;
+    }
+
+    if (kvm_device_check_attr(fdarray[2], KVM_ARM_VCPU_PMU_V3_CTRL,
+                              KVM_ARM_VCPU_PMU_V3_SET_PMU)) {
+        g_autofree char *link = NULL;
+        g_autofree unsigned long *uncovered_cpus = bitmap_new(npossible_cpus);
+
+        bitmap_copy(uncovered_cpus, possible_cpus, npossible_cpus);
+
+        devices = opendir("/sys/bus/event_source/devices");
+        if (!devices) {
+            goto out;
+        }
+
+        devices_fd = dirfd(devices);
+        if (devices_fd < 0) {
+            goto out;
+        }
+
+        while ((ent = readdir(devices))) {
+            unsigned long new_type = ULONG_MAX;
+            const char *endptr;
+
+            /*
+             * Check if this event source exposes type and cpus and
+             * KVM can use it.
+             */
+            if (!read_pmu_attr(devices_fd, ent, "type", &buf, &n) ||
+                qemu_strtoul(buf, &endptr, 0, &new_type) == -EINVAL ||
+                (*endptr && *endptr != '\n') ||
+                !read_pmu_attr(devices_fd, ent, "cpus", &buf, &n) ||
+                !parse_cpus(buf, &pmu_cpus, &npmu_cpus) ||
+                set_pmu(fdarray[2], new_type)) {
+                continue;
+            }
+
+            bitmap_andnot(uncovered_cpus, uncovered_cpus,
+                          pmu_cpus, npossible_cpus);
+
+            if (bitmap_andnot(pmu_cpus, possible_cpus, pmu_cpus,
+                              npossible_cpus)) {
+                continue;
+            }
+
+            /* Order by the device location to ensure stable selection. */
+            while (true) {
+                ret = readlinkat(devices_fd, ent->d_name, buf, n);
+                if (ret < n) {
+                    break;
+                }
+
+                n *= 2;
+                buf = g_realloc(buf, n);
+            }
+
+            if (ret < 0) {
+                continue;
+            }
+
+            buf[ret] = 0;
+
+            if (link && strcmp(link, buf) <= 0) {
+                continue;
+            }
+
+            *single_type = new_type;
+            link = g_realloc(link, ret + 1);
+            strcpy(link, buf);
+        }
+
+        /* Choose an event source covers all PCPUs if available. */
+        if (link) {
+            pmu = PMU_SINGLE;
+            goto out;
+        }
+
+        /*
+         * Choose the composite PMU if all PCPUs are covered by the available
+         * event sources and composition is supported.
+         */
+        if (bitmap_empty(uncovered_cpus, npossible_cpus) &&
+            kvm_device_check_attr(fdarray[2], KVM_ARM_VCPU_PMU_V3_CTRL,
+                                  KVM_ARM_VCPU_PMU_V3_COMPOSITION)) {
+            pmu = PMU_COMPOSITE;
+            goto out;
+        }
+
+        /* No event source that covers all PCPUs was found. */
+        goto out;
+    }
+
+    /*
+     * The old kernels that lack KVM_ARM_VCPU_PMU_V3_SET_PMU only support
+     * armv8-pmu for KVM so inspect it.
+     */
+    devices = opendir("/sys/bus/platform/drivers/armv8-pmu");
+    if (!devices) {
+        goto out;
+    }
+
+    devices_fd = dirfd(devices);
+    if (devices_fd < 0) {
+        goto out;
+    }
+
+    while ((ent = readdir(devices))) {
+        if (!read_pmu_attr(devices_fd, ent, "cpus", &buf, &n) ||
+            !parse_cpus(buf, &pmu_cpus, &npossible_cpus)) {
+            continue;
+        }
+
+        /*
+         * This device is the only available armv8-pmu device if it covers
+         * all PCPUs because an armv8-pmu device occupies fixed system
+         * registers.
+         */
+        if (!bitmap_andnot(pmu_cpus, possible_cpus, pmu_cpus,
+                            npossible_cpus)) {
+            pmu = PMU_DEFAULT;
+            break;
+        }
+    }
+
+out:
+    if (devices) {
+        assert(!closedir(devices));
+    }
+
+    return pmu;
+}
+
 
 static uint64_t idregs_sysreg_to_kvm_reg(ARMSysRegs sysreg)
 {
@@ -242,7 +499,8 @@ static int get_host_cpu_reg(int fd, ARMHostCPUFeatures *ahcf,
     return ret;
 }
 
-static bool kvm_arm_get_host_cpu_features(ARMHostCPUFeatures *ahcf)
+static bool kvm_arm_get_host_cpu_features(ARMHostCPUFeatures *ahcf,
+                                          bool backcompat_pmu)
 {
     /* Identify the feature bits corresponding to the host CPU, and
      * fill out the ARMHostCPUClass fields accordingly. To do this
@@ -291,13 +549,19 @@ static bool kvm_arm_get_host_cpu_features(ARMHostCPUFeatures *ahcf)
     if (kvm_arm_pmu_supported()) {
         init.features[0] |= 1 << KVM_ARM_VCPU_PMU_V3;
         pmu_supported = true;
-        features |= 1ULL << ARM_FEATURE_PMU;
     }
 
     if (!kvm_arm_create_scratch_host_vcpu(fdarray, &init)) {
         return false;
     }
 
+    if (pmu_supported) {
+        ahcf->pmu = choose_pmu(&ahcf->pmu_single_type, backcompat_pmu);
+        if (ahcf->pmu != PMU_NONE) {
+            features |= 1ULL << ARM_FEATURE_PMU;
+        }
+    }
+
     ahcf->target = init.target;
     ahcf->dtb_compatible = "arm,armv8";
     int fd = fdarray[2];
@@ -398,12 +662,6 @@ static bool kvm_arm_get_host_cpu_features(ARMHostCPUFeatures *ahcf)
             ahcf->isar.dbgdidr = dbgdidr;
         }
 
-        if (pmu_supported) {
-            /* PMCR_EL0 is only accessible if the vCPU has feature PMU_V3 */
-            err |= read_sys_reg64(fd, &ahcf->isar.reset_pmcr_el0,
-                                  ARM64_SYS_REG(3, 3, 9, 12, 0));
-        }
-
         if (sve_supported) {
             /*
              * There is a range of kernels between kernel commit 73433762fcae
@@ -447,7 +705,8 @@ void kvm_arm_set_cpu_features_from_host(ARMCPU *cpu)
 
     if (!arm_host_cpu_features.dtb_compatible) {
         if (!kvm_enabled() ||
-            !kvm_arm_get_host_cpu_features(&arm_host_cpu_features)) {
+            !kvm_arm_get_host_cpu_features(&arm_host_cpu_features,
+                                           kvm_state->backcompat_pmu)) {
             /* We can't report this error yet, so flag that we need to
              * in arm_cpu_realizefn().
              */
@@ -1622,8 +1881,53 @@ static void kvm_arch_set_eager_split_size(Object *obj, Visitor *v,
     s->kvm_eager_split_size = value;
 }
 
+static bool kvm_arch_get_backcompat_pmu(Object *obj, Error **errp)
+{
+    KVMState *s = KVM_STATE(obj);
+
+    return s->backcompat_pmu;
+}
+
+static void kvm_arch_set_backcompat_pmu(Object *obj, bool value, Error **errp)
+{
+    KVMState *s = KVM_STATE(obj);
+
+    s->backcompat_pmu = value;
+}
+
+static void kvm_arch_get_pmu(Object *obj, Visitor *v, const char *name,
+                             void *opaque, Error **errp)
+{
+    KVMState *s = KVM_STATE(obj);
+    visit_type_uint64(v, name, &s->pmu, errp);
+}
+
+static void kvm_arch_set_pmu(Object *obj, Visitor *v, const char *name,
+                             void *opaque, Error **errp)
+{
+    KVMState *s = KVM_STATE(obj);
+    uint64_t value;
+
+    if (!visit_type_uint64(v, name, &value, errp)) {
+        return;
+    }
+
+    s->pmu = value;
+}
+
 void kvm_arch_accel_class_init(ObjectClass *oc)
 {
+    ObjectProperty *property;
+
+    object_class_property_add_bool(oc, "backcompat-pmu",
+                                   kvm_arch_get_backcompat_pmu,
+                                   kvm_arch_set_backcompat_pmu);
+
+    property = object_class_property_add(oc, "pmu", "uint64", kvm_arch_get_pmu,
+                                         kvm_arch_set_pmu, NULL, NULL);
+    object_property_set_default_uint(property, UINT64_MAX);
+    object_class_property_set_description(oc, "pmu", "KVM PMU event type");
+
     object_class_property_add(oc, "eager-split-size", "size",
                               kvm_arch_get_eager_split_size,
                               kvm_arch_set_eager_split_size, NULL, NULL);
@@ -1693,12 +1997,13 @@ static bool kvm_arm_set_device_attr(ARMCPU *cpu, struct kvm_device_attr *attr,
 
 void kvm_arm_pmu_init(ARMCPU *cpu)
 {
+    CPUARMState *env = &cpu->env;
     struct kvm_device_attr attr = {
         .group = KVM_ARM_VCPU_PMU_V3_CTRL,
         .attr = KVM_ARM_VCPU_PMU_V3_INIT,
     };
 
-    if (!cpu->has_pmu) {
+    if (!arm_feature(env, ARM_FEATURE_PMU)) {
         return;
     }
     if (!kvm_arm_set_device_attr(cpu, &attr, "PMU")) {
@@ -1709,13 +2014,14 @@ void kvm_arm_pmu_init(ARMCPU *cpu)
 
 void kvm_arm_pmu_set_irq(ARMCPU *cpu, int irq)
 {
+    CPUARMState *env = &cpu->env;
     struct kvm_device_attr attr = {
         .group = KVM_ARM_VCPU_PMU_V3_CTRL,
         .addr = (intptr_t)&irq,
         .attr = KVM_ARM_VCPU_PMU_V3_IRQ,
     };
 
-    if (!cpu->has_pmu) {
+    if (!arm_feature(env, ARM_FEATURE_PMU)) {
         return;
     }
     if (!kvm_arm_set_device_attr(cpu, &attr, "PMU")) {
@@ -1911,6 +2217,20 @@ int kvm_arch_init_vcpu(CPUState *cs)
         return ret;
     }
 
+    if (cs->kvm_state->pmu <= UINT32_MAX) {
+        ret = set_pmu(cs->kvm_fd, cs->kvm_state->pmu);
+    } else if (arm_host_cpu_features.pmu == PMU_SINGLE) {
+        ret = set_pmu(cs->kvm_fd, arm_host_cpu_features.pmu_single_type);
+    } else if (arm_host_cpu_features.pmu == PMU_COMPOSITE) {
+        ret = kvm_device_access(cs->kvm_fd, KVM_ARM_VCPU_PMU_V3_CTRL,
+                                KVM_ARM_VCPU_PMU_V3_COMPOSITION, NULL, true,
+                                NULL);
+        trace_kvm_arm_set_pmu_composition(ret);
+    }
+    if (ret) {
+        return ret;
+    }
+
     if (cpu_isar_feature(aa64_sve, cpu)) {
         ret = kvm_arm_sve_set_vls(cpu);
         if (ret) {
diff --git a/qemu-options.hx b/qemu-options.hx
index ab23f14d21782764c591c58efcb2d881c713c56d..0020a5ae8467eab3a3c3c250f48d05fe164cf0de 100644
--- a/qemu-options.hx
+++ b/qemu-options.hx
@@ -235,6 +235,7 @@ DEF("accel", HAS_ARG, QEMU_OPTION_accel,
     "                tb-size=n (TCG translation block cache size)\n"
     "                dirty-ring-size=n (KVM dirty ring GFN count, default 0)\n"
     "                eager-split-size=n (KVM Eager Page Split chunk size, default 0, disabled. ARM only)\n"
+    "                pmu=n (KVM PMU event type. ARM only)\n"
     "                notify-vmexit=run|internal-error|disable,notify-window=n (enable notify VM exit and set notify window, x86 only)\n"
     "                thread=single|multi (enable multi-threaded TCG)\n"
     "                device=path (KVM device path, default /dev/kvm)\n", QEMU_ARCH_ALL)
@@ -308,6 +309,25 @@ SRST
         impact on the memory. By default, this feature is disabled
         (eager-split-size=0).
 
+    ``pmu=n``
+        Specifies the event source to be used for Arm PMUv3 emulation. The value
+        specified here is identical to the one used in perf_event_open(2), but
+        not all event sources are compatible.
+
+        Since QEMU 10.1, the default behavior is to select a backend that
+        supports all host CPUs. The emulation cannot be enabled if there is no
+        such backend exists. Use this property to choose a specific event source
+        when there are several such event sources or to choose one that only
+        supports a subset of the host CPUs. If you specify an event source that
+        only supports a subset of host CPUs, you must ensure that guest CPUs run
+        exclusively on those supported host CPUs.
+
+        Prior to 10.1, KVM chose an arbitrary host PMU that supports at least
+        one CPU in the process's affinity.
+
+        Ensure that the CPU's ``pmu`` property is also set to ``on`` to enable
+        the emulation when setting this property.
+
     ``notify-vmexit=run|internal-error|disable,notify-window=n``
         Enables or disables notify VM exit support on x86 host and specify
         the corresponding notify window to trigger the VM exit if enabled.
diff --git a/target/arm/trace-events b/target/arm/trace-events
index 4438dce7becc27be0c366631610dd79aafdd5359..3264283b8c4391c03e000e0e83e0805273679019 100644
--- a/target/arm/trace-events
+++ b/target/arm/trace-events
@@ -13,3 +13,5 @@ arm_gt_update_irq(int timer, int irqstate) "gt_update_irq: timer %d irqstate %d"
 
 # kvm.c
 kvm_arm_fixup_msi_route(uint64_t iova, uint64_t gpa) "MSI iova = 0x%"PRIx64" is translated into 0x%"PRIx64
+kvm_arm_set_pmu(uint32_t type, int ret) "type %" PRIu32 " ret %d"
+kvm_arm_set_pmu_composition(int ret) "ret %d"

---
base-commit: 91b5d79fd6eb230a1af5cf74cf8236bca5d1256d
change-id: 20250730-kvm-8fc06c8f722a

Best regards,
-- 
Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>


