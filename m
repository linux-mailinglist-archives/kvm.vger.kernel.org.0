Return-Path: <kvm+bounces-10380-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id ECB3E86C0F2
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 07:41:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A20382821FE
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 06:41:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 34F0948792;
	Thu, 29 Feb 2024 06:40:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="htBlHU6l"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA558482F2
	for <kvm@vger.kernel.org>; Thu, 29 Feb 2024 06:40:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709188814; cv=none; b=G4+aQfxatkGVVwWlleZlYthJGdvNeX8jG0dSAdGONG2sa5KGhXnsHDWdcNpTPMNSvtHGCVBjiB6UNzSVZ3+RqnpBXQfBYGomwsySYIG4x3EEaHVVHcLPy8ztT1jnBQ1Jds4+d+wJ3s7r1lhEvoAUUom9lGnUdl2OgBKMcvAG0U8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709188814; c=relaxed/simple;
	bh=d7ErL0mTQw1DNunIEXJ7lHlPCrWNQxYCOtF+gdnFFFc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=elKYsgR2J7BpBTMJ/s3UMIY9b0wNAaNfkDltcYVssGb+qQpsYMmQkU8YFaHe/xMVq1mi+O2AwMicKTZB+r36G2MiQR7kK7C8gpAObrQKDV6XtRCciUiYdj7IG9zvXvVizsa6QoD9Olycqn8VtWTzEygZsKLTYciP2GMWEAsQPnM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=htBlHU6l; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709188812; x=1740724812;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=d7ErL0mTQw1DNunIEXJ7lHlPCrWNQxYCOtF+gdnFFFc=;
  b=htBlHU6lP2L/R83T9FNudh077OTR39KQBvbtS00X7TOOHurfOX2aLil6
   sueFiyGwHCfjM/IZEg2Tkjp9lDHmTm6ueX4Qu9YYPwAXMxuCeqAdiS8zq
   3U2RuQQC+/wtpawaS/tF5opZZ/kQV40O3pK/fZLo/zvyTfzjzNDHKrSJw
   YyT/xm0VWwszrAttmxKFxmB/Rr6etLT1IKvQkPuNhvUJ3yQUuB1kkeimk
   AZSOgIIU/kLc2tCTvBD+OriSinXNXODtZ3xYuTaM0Yjv89Hnfv1zyURhg
   vWlbZMUljbSgeQPCLJxQyCeLDBdYe161xOBgnYSIMSe582jBhCkPS+JZz
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10998"; a="3802712"
X-IronPort-AV: E=Sophos;i="6.06,192,1705392000"; 
   d="scan'208";a="3802712"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Feb 2024 22:40:12 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,192,1705392000"; 
   d="scan'208";a="8075487"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by orviesa007.jf.intel.com with ESMTP; 28 Feb 2024 22:40:06 -0800
From: Xiaoyao Li <xiaoyao.li@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	David Hildenbrand <david@redhat.com>,
	Igor Mammedov <imammedo@redhat.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Yanan Wang <wangyanan55@huawei.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Ani Sinha <anisinha@redhat.com>,
	Peter Xu <peterx@redhat.com>,
	Cornelia Huck <cohuck@redhat.com>,
	=?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Eric Blake <eblake@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>
Cc: kvm@vger.kernel.org,
	qemu-devel@nongnu.org,
	Michael Roth <michael.roth@amd.com>,
	Claudio Fontana <cfontana@suse.de>,
	Gerd Hoffmann <kraxel@redhat.com>,
	Isaku Yamahata <isaku.yamahata@gmail.com>,
	Chenyi Qiang <chenyi.qiang@intel.com>,
	xiaoyao.li@intel.com
Subject: [PATCH v5 24/65] i386/tdx: Initialize TDX before creating TD vcpus
Date: Thu, 29 Feb 2024 01:36:45 -0500
Message-Id: <20240229063726.610065-25-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240229063726.610065-1-xiaoyao.li@intel.com>
References: <20240229063726.610065-1-xiaoyao.li@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Invoke KVM_TDX_INIT in kvm_arch_pre_create_vcpu() that KVM_TDX_INIT
configures global TD configurations, e.g. the canonical CPUID config,
and must be executed prior to creating vCPUs.

Use kvm_x86_arch_cpuid() to setup the CPUID settings for TDX VM.

Note, this doesn't address the fact that QEMU may change the CPUID
configuration when creating vCPUs, i.e. punts on refactoring QEMU to
provide a stable CPUID config prior to kvm_arch_init().

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Acked-by: Gerd Hoffmann <kraxel@redhat.com>
Acked-by: Markus Armbruster <armbru@redhat.com>
---
Changes in v4:
- mark init_vm with g_autofree() and use QEMU_LOCK_GUARD() to eliminate
  the goto labels; (Daniel)
Changes in v3:
- Pass @errp in tdx_pre_create_vcpu() and pass error info to it. (Daniel)
---
 accel/kvm/kvm-all.c         |  9 +++++++-
 target/i386/kvm/kvm.c       |  9 ++++++++
 target/i386/kvm/meson.build |  2 +-
 target/i386/kvm/tdx-stub.c  |  8 ++++++++
 target/i386/kvm/tdx.c       | 41 +++++++++++++++++++++++++++++++++++++
 target/i386/kvm/tdx.h       |  4 ++++
 6 files changed, 71 insertions(+), 2 deletions(-)
 create mode 100644 target/i386/kvm/tdx-stub.c

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index a8a99d48e4ce..c9df41efa484 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -431,8 +431,15 @@ int kvm_init_vcpu(CPUState *cpu, Error **errp)
 
     trace_kvm_init_vcpu(cpu->cpu_index, kvm_arch_vcpu_id(cpu));
 
+    /*
+     * tdx_pre_create_vcpu() may call cpu_x86_cpuid(). It in turn may call
+     * kvm_vm_ioctl(). Set cpu->kvm_state in advance to avoid NULL pointer
+     * dereference.
+     */
+    cpu->kvm_state = s;
     ret = kvm_arch_pre_create_vcpu(cpu, errp);
     if (ret < 0) {
+        cpu->kvm_state = NULL;
         goto err;
     }
 
@@ -440,11 +447,11 @@ int kvm_init_vcpu(CPUState *cpu, Error **errp)
     if (ret < 0) {
         error_setg_errno(errp, -ret, "kvm_init_vcpu: kvm_get_vcpu failed (%lu)",
                          kvm_arch_vcpu_id(cpu));
+        cpu->kvm_state = NULL;
         goto err;
     }
 
     cpu->kvm_fd = ret;
-    cpu->kvm_state = s;
     cpu->vcpu_dirty = true;
     cpu->dirty_pages = 0;
     cpu->throttle_us_per_full = 0;
diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index 315998c8f7e5..1664ac49005e 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -2271,6 +2271,15 @@ int kvm_arch_init_vcpu(CPUState *cs)
     return r;
 }
 
+int kvm_arch_pre_create_vcpu(CPUState *cpu, Error **errp)
+{
+    if (is_tdx_vm()) {
+        return tdx_pre_create_vcpu(cpu, errp);
+    }
+
+    return 0;
+}
+
 int kvm_arch_destroy_vcpu(CPUState *cs)
 {
     X86CPU *cpu = X86_CPU(cs);
diff --git a/target/i386/kvm/meson.build b/target/i386/kvm/meson.build
index 26a1ab038513..460c5f8f85f3 100644
--- a/target/i386/kvm/meson.build
+++ b/target/i386/kvm/meson.build
@@ -7,7 +7,7 @@ i386_kvm_ss.add(files(
 
 i386_kvm_ss.add(when: 'CONFIG_XEN_EMU', if_true: files('xen-emu.c'))
 
-i386_kvm_ss.add(when: 'CONFIG_TDX', if_true: files('tdx.c'))
+i386_kvm_ss.add(when: 'CONFIG_TDX', if_true: files('tdx.c'), if_false: files('tdx-stub.c'))
 
 i386_system_ss.add(when: 'CONFIG_HYPERV', if_true: files('hyperv.c'), if_false: files('hyperv-stub.c'))
 
diff --git a/target/i386/kvm/tdx-stub.c b/target/i386/kvm/tdx-stub.c
new file mode 100644
index 000000000000..b614b46d3f4a
--- /dev/null
+++ b/target/i386/kvm/tdx-stub.c
@@ -0,0 +1,8 @@
+#include "qemu/osdep.h"
+
+#include "tdx.h"
+
+int tdx_pre_create_vcpu(CPUState *cpu, Error **errp)
+{
+    return -EINVAL;
+}
diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
index 144acd8c9912..d548ec340285 100644
--- a/target/i386/kvm/tdx.c
+++ b/target/i386/kvm/tdx.c
@@ -475,6 +475,45 @@ static int tdx_kvm_init(ConfidentialGuestSupport *cgs, Error **errp)
     return 0;
 }
 
+int tdx_pre_create_vcpu(CPUState *cpu, Error **errp)
+{
+    MachineState *ms = MACHINE(qdev_get_machine());
+    X86CPU *x86cpu = X86_CPU(cpu);
+    CPUX86State *env = &x86cpu->env;
+    g_autofree struct kvm_tdx_init_vm *init_vm = NULL;
+    int r = 0;
+
+    QEMU_LOCK_GUARD(&tdx_guest->lock);
+    if (tdx_guest->initialized) {
+        return r;
+    }
+
+    init_vm = g_malloc0(sizeof(struct kvm_tdx_init_vm) +
+                        sizeof(struct kvm_cpuid_entry2) * KVM_MAX_CPUID_ENTRIES);
+
+    r = kvm_vm_enable_cap(kvm_state, KVM_CAP_MAX_VCPUS, 0, ms->smp.cpus);
+    if (r < 0) {
+        error_setg(errp, "Unable to set MAX VCPUS to %d", ms->smp.cpus);
+        return r;
+    }
+
+    init_vm->cpuid.nent = kvm_x86_arch_cpuid(env, init_vm->cpuid.entries, 0);
+
+    init_vm->attributes = tdx_guest->attributes;
+
+    do {
+        r = tdx_vm_ioctl(KVM_TDX_INIT_VM, 0, init_vm);
+    } while (r == -EAGAIN);
+    if (r < 0) {
+        error_setg_errno(errp, -r, "KVM_TDX_INIT_VM failed");
+        return r;
+    }
+
+    tdx_guest->initialized = true;
+
+    return 0;
+}
+
 /* tdx guest */
 OBJECT_DEFINE_TYPE_WITH_INTERFACES(TdxGuest,
                                    tdx_guest,
@@ -487,6 +526,8 @@ static void tdx_guest_init(Object *obj)
 {
     TdxGuest *tdx = TDX_GUEST(obj);
 
+    qemu_mutex_init(&tdx->lock);
+
     tdx->attributes = 0;
 }
 
diff --git a/target/i386/kvm/tdx.h b/target/i386/kvm/tdx.h
index f62fe8ece982..0df910725b52 100644
--- a/target/i386/kvm/tdx.h
+++ b/target/i386/kvm/tdx.h
@@ -17,6 +17,9 @@ typedef struct TdxGuestClass {
 typedef struct TdxGuest {
     ConfidentialGuestSupport parent_obj;
 
+    QemuMutex lock;
+
+    bool initialized;
     uint64_t attributes;    /* TD attributes */
 } TdxGuest;
 
@@ -28,5 +31,6 @@ bool is_tdx_vm(void);
 
 void tdx_get_supported_cpuid(uint32_t function, uint32_t index, int reg,
                              uint32_t *ret);
+int tdx_pre_create_vcpu(CPUState *cpu, Error **errp);
 
 #endif /* QEMU_I386_TDX_H */
-- 
2.34.1


