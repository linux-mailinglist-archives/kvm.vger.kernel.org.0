Return-Path: <kvm+bounces-10371-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7625286C0E8
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 07:40:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E0D3BB261EE
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 06:40:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1137447F77;
	Thu, 29 Feb 2024 06:39:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VPzpDdQq"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBB7147F5D
	for <kvm@vger.kernel.org>; Thu, 29 Feb 2024 06:39:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709188754; cv=none; b=k/IfRqZ+XTc4eQV2v5Vfe/ur0Fu1vquXolZrWTQT7zaZwUJFTWHTgEm/424eLpTJS3wwMgZIrUUgeu9Pz/usLGp7J4u7J04GOrUnNW6Dfemyezpy2STFVnJgHmA2fku/sXzmn1TK9G+3Vtwll4CNACaUBwW4ma5eK4nfIfjfqX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709188754; c=relaxed/simple;
	bh=0rigCiWKfJ3BvvVjD5ubGByboOvDWRgowrZc5mzgXMY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=RsX2ubuNEq/aMkikxMYA0ZExvXNukv1cCQ9nZqcwcuYUJzojhY2xqGfpYB46z5PtA26d0vChp10NqcqNgaeMfcyh/jr5a94+B0KbUhwDcxzJaTiLyZp2qCutlTlzIPIoU3V78tiLCtE2/AppY+MUXEd2LG2S3uaq8QeUdGpjs70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=VPzpDdQq; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709188752; x=1740724752;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=0rigCiWKfJ3BvvVjD5ubGByboOvDWRgowrZc5mzgXMY=;
  b=VPzpDdQqyCA5OPpvfxBgbprfFDVRxVPwwNLTTtzbecctEQLLoJfnbUpg
   M7dqeaxJj9Q4PsCGvyGk0jvu3tIJd0Somagd4X3N9lEHCyBiLF0au3LVR
   4QovR6j+YEh3ddimjUAFDdqeIUI88ehxMWmUrQq+JziYMC35Ttb8A9TJ2
   nmhpXNlu5aVdNxcsV6CeLJEKVw/z0Kak3vpOzr66pZMj2Ln0oo6FIS8hR
   a73jzbR9AIzFj76W37/K9KSOCv010fYcE5B9Js4XClqGzePiwTAp7LJvS
   rdmJdHy4wxvWYEVCkAgO0XNBuqaCGB8oK6/argB6xJGYevVKRaHl/VBwM
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10998"; a="3802614"
X-IronPort-AV: E=Sophos;i="6.06,192,1705392000"; 
   d="scan'208";a="3802614"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Feb 2024 22:39:12 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,192,1705392000"; 
   d="scan'208";a="8075078"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by orviesa007.jf.intel.com with ESMTP; 28 Feb 2024 22:39:06 -0800
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
Subject: [PATCH v5 15/65] i386/tdx: Get tdx_capabilities via KVM_TDX_CAPABILITIES
Date: Thu, 29 Feb 2024 01:36:36 -0500
Message-Id: <20240229063726.610065-16-xiaoyao.li@intel.com>
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

KVM provides TDX capabilities via sub command KVM_TDX_CAPABILITIES of
IOCTL(KVM_MEMORY_ENCRYPT_OP). Get the capabilities when initializing
TDX context. It will be used to validate user's setting later.

Since there is no interface reporting how many cpuid configs contains in
KVM_TDX_CAPABILITIES, QEMU chooses to try starting with a known number
and abort when it exceeds KVM_MAX_CPUID_ENTRIES.

Besides, introduce the interfaces to invoke TDX "ioctls" at different
scope (KVM, VM and VCPU) in preparation.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
Changes in v4:
- use {} to initialize struct kvm_tdx_cmd, to avoid memset();
- remove tdx_platform_ioctl() because no user;

Changes in v3:
- rename __tdx_ioctl() to tdx_ioctl_internal()
- Pass errp in get_tdx_capabilities();

changes in v2:
  - Make the error message more clear;

changes in v1:
  - start from nr_cpuid_configs = 6 for the loop;
  - stop the loop when nr_cpuid_configs exceeds KVM_MAX_CPUID_ENTRIES;
---
 target/i386/kvm/kvm.c      |  2 -
 target/i386/kvm/kvm_i386.h |  2 +
 target/i386/kvm/tdx.c      | 91 +++++++++++++++++++++++++++++++++++++-
 3 files changed, 92 insertions(+), 3 deletions(-)

diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index 52d99d30bdc8..0e68e80f4291 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -1685,8 +1685,6 @@ static int hyperv_init_vcpu(X86CPU *cpu)
 
 static Error *invtsc_mig_blocker;
 
-#define KVM_MAX_CPUID_ENTRIES  100
-
 static void kvm_init_xsave(CPUX86State *env)
 {
     if (has_xsave2) {
diff --git a/target/i386/kvm/kvm_i386.h b/target/i386/kvm/kvm_i386.h
index 55fb25fa8e2e..c3ef46a97a7b 100644
--- a/target/i386/kvm/kvm_i386.h
+++ b/target/i386/kvm/kvm_i386.h
@@ -13,6 +13,8 @@
 
 #include "sysemu/kvm.h"
 
+#define KVM_MAX_CPUID_ENTRIES  100
+
 #ifdef CONFIG_KVM
 
 #define kvm_pit_in_kernel() \
diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
index d9a1dd46dc69..2b956450a083 100644
--- a/target/i386/kvm/tdx.c
+++ b/target/i386/kvm/tdx.c
@@ -12,18 +12,107 @@
  */
 
 #include "qemu/osdep.h"
+#include "qemu/error-report.h"
+#include "qapi/error.h"
 #include "qom/object_interfaces.h"
+#include "sysemu/kvm.h"
 
 #include "hw/i386/x86.h"
+#include "kvm_i386.h"
 #include "tdx.h"
 
+static struct kvm_tdx_capabilities *tdx_caps;
+
+enum tdx_ioctl_level{
+    TDX_VM_IOCTL,
+    TDX_VCPU_IOCTL,
+};
+
+static int tdx_ioctl_internal(void *state, enum tdx_ioctl_level level, int cmd_id,
+                        __u32 flags, void *data)
+{
+    struct kvm_tdx_cmd tdx_cmd = {};
+    int r;
+
+    tdx_cmd.id = cmd_id;
+    tdx_cmd.flags = flags;
+    tdx_cmd.data = (__u64)(unsigned long)data;
+
+    switch (level) {
+    case TDX_VM_IOCTL:
+        r = kvm_vm_ioctl(kvm_state, KVM_MEMORY_ENCRYPT_OP, &tdx_cmd);
+        break;
+    case TDX_VCPU_IOCTL:
+        r = kvm_vcpu_ioctl(state, KVM_MEMORY_ENCRYPT_OP, &tdx_cmd);
+        break;
+    default:
+        error_report("Invalid tdx_ioctl_level %d", level);
+        exit(1);
+    }
+
+    return r;
+}
+
+static inline int tdx_vm_ioctl(int cmd_id, __u32 flags, void *data)
+{
+    return tdx_ioctl_internal(NULL, TDX_VM_IOCTL, cmd_id, flags, data);
+}
+
+static inline int tdx_vcpu_ioctl(void *vcpu_fd, int cmd_id, __u32 flags,
+                                 void *data)
+{
+    return  tdx_ioctl_internal(vcpu_fd, TDX_VCPU_IOCTL, cmd_id, flags, data);
+}
+
+static int get_tdx_capabilities(Error **errp)
+{
+    struct kvm_tdx_capabilities *caps;
+    /* 1st generation of TDX reports 6 cpuid configs */
+    int nr_cpuid_configs = 6;
+    size_t size;
+    int r;
+
+    do {
+        size = sizeof(struct kvm_tdx_capabilities) +
+               nr_cpuid_configs * sizeof(struct kvm_tdx_cpuid_config);
+        caps = g_malloc0(size);
+        caps->nr_cpuid_configs = nr_cpuid_configs;
+
+        r = tdx_vm_ioctl(KVM_TDX_CAPABILITIES, 0, caps);
+        if (r == -E2BIG) {
+            g_free(caps);
+            nr_cpuid_configs *= 2;
+            if (nr_cpuid_configs > KVM_MAX_CPUID_ENTRIES) {
+                error_setg(errp, "%s: KVM TDX seems broken that number of CPUID "
+                           "entries in kvm_tdx_capabilities exceeds limit %d",
+                           __func__, KVM_MAX_CPUID_ENTRIES);
+                return r;
+            }
+        } else if (r < 0) {
+            g_free(caps);
+            error_setg_errno(errp, -r, "%s: KVM_TDX_CAPABILITIES failed", __func__);
+            return r;
+        }
+    }
+    while (r == -E2BIG);
+
+    tdx_caps = caps;
+
+    return 0;
+}
+
 static int tdx_kvm_init(ConfidentialGuestSupport *cgs, Error **errp)
 {
     MachineState *ms = MACHINE(qdev_get_machine());
+    int r = 0;
 
     ms->require_guest_memfd = true;
 
-    return 0;
+    if (!tdx_caps) {
+        r = get_tdx_capabilities(errp);
+    }
+
+    return r;
 }
 
 /* tdx guest */
-- 
2.34.1


