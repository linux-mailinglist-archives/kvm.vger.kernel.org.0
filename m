Return-Path: <kvm+bounces-51522-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 589E1AF7F0A
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 19:36:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 50CCF1C86B2B
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 17:36:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C3E87289E23;
	Thu,  3 Jul 2025 17:36:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="RrIfeLbN"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFEFC288C96
	for <kvm@vger.kernel.org>; Thu,  3 Jul 2025 17:36:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751564182; cv=none; b=oP37+sldvVDWfQbuTM8aWpBkfNPKqQ3b8k6OpPMkQXRA6ROELe4rXFheAhL10IxgvCgEP6Kk0NHIoCiEcU11BgdnLMAAYjLANbevfGGiQL3Tq8+XEL+OFPJ+CYkMkRZFRMabUAk6gM0NagYD6q+Hk+W5YhWIfbP2gcIxYBgkGh4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751564182; c=relaxed/simple;
	bh=8IDJemO4fs58GLVb+iUbe6XLDqZMi3e/cq7DbcM0yBs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=t2KObdB13JVefoneyhq0Hfap8OfSkt/46hwO6p2MhFpeKBUYExQiXcPXv/xsoTIxkf2ZrX1vmH8ZvmPKPir9ohLj1umEUXp/F0GcIjq20OX7FCfsN7RCB8pyuIBIzddgkCllQM5NrpLMXiPo1ABC0xq7JgvsUXM6wHrolBdPHCU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=RrIfeLbN; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-451dbe494d6so1401725e9.1
        for <kvm@vger.kernel.org>; Thu, 03 Jul 2025 10:36:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1751564179; x=1752168979; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5E/SAxbdiV3TRF5Yfo8PH+PsmR3gvFEsRHLctVVyuPU=;
        b=RrIfeLbN+TFn1JNbgkYpCAxotbHqTHUCeUfYUKYSvXv69UAjBA0l683YgthZDIsYGp
         3lG78w+Gt5fxPKHHs7ZW8Xl8liX71aBObFqFiEYetZMSr/HtuXWsdt2IaaxhxHndSnuV
         Zrwvw9XXyzcE0PSC6i0rMMGXaWO/Vn2Y4sOk+zpt4zFx9Fx0iYiPmAYZaoan40FgIAo1
         RQ3II2v63fcXXUS1FB7EnKVd2CShFx5XulP3MgeH1375vMMNI1twyyDz8Mn3uOhxkYAg
         KImRfKJRMLkirmal+E+q2w85jO6Ljy5W4hH+kRaIgKyH76YiADab4uaCdiXsWsJ6na5D
         kYWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751564179; x=1752168979;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5E/SAxbdiV3TRF5Yfo8PH+PsmR3gvFEsRHLctVVyuPU=;
        b=LfByzfaCbJ8oKgsPsr81zVmJcecdn8xuOXXl8oXryGfvBbILpcfsK5kxLqxGWUKQlK
         dHYARZsq7HLaiJR2YTJydyeooOsCcjql0xWAmWcg0ojDElm6YTQvH7k0Bg8xZOp89KUs
         3B2ch+2hriTnX3Ah57XkMBhWFSuw3r9SSh8LD5Sr1t90DYJZSdWyA3n/uCsCa/w4ay+i
         Q6TVG7469B+9sptE/rdxDBXyjFGbHuMbDcPLjVFA45TxdFYR1ueXZ3iSVaZw4WwI4e/0
         iRRbmMAD6EFO5wnw40GwugkEbRY3NqYXnaduMc0qnaq9AbkPMsLyBSWB46j6zhEutujj
         FY5A==
X-Forwarded-Encrypted: i=1; AJvYcCUtN70P6LgZFefTdG0nvZ2A6paT22LGmLkQJHFbYfiSknkFbrXbEld+5iJbBpGaog/yZws=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy3VXHKfKkbiUXZOxtu638nt/aQhLhAMls7uqbQsucjBax8KNuE
	844GNUEhgw4kVMUhIahOqCc2fCiB6cvNkZPH5JxDXVi9yMAn29clOfVWRmgwXhv2Il0=
X-Gm-Gg: ASbGnctd7I/GuINr8nndEz2Mab6plScT/kha3cbVR6R+PffYJnf2eygCvfjdpJ6T6/a
	I4fa2O1wvU2Ffu7AQFH88CPL3wBq/hZVL4E/HSQWl27sntKtz1FrP5IF5dAiXi9CjSJ9f1bqWSX
	L8eVft+VwyJbi3UBs0/dFvG/7giA3eOPLmdwkq+Nqi6mgJQ+1Csmk1HbXys37p/PTg2FW0zjmwa
	QcDM9JrfTtHbnCKxgl4ab84toF3xoL9+SsRHeIfDmnL91Fu2Vy8fVSfDYTHc+bgtaCIx0nEZBnh
	nHYMd2/NxxiUoGbkSx8kM0B7cFz1HXwZ7CeNVpx98eoxGD6azFoWCTFnAkUeSP/f9auh8tL8V8v
	LYNculzdl4flOUq2yFGWrlJGSc1VEE0EtLJ7F
X-Google-Smtp-Source: AGHT+IGYkuYIeLocc6dsLio4WRAhQTPLG5g0dI2lw9ZYqsX2Hf52uwkNyyuJTdB+GW55XoGAazaZvQ==
X-Received: by 2002:a05:600c:4e8b:b0:443:48:66d2 with SMTP id 5b1f17b1804b1-454a3704fc7mr101594355e9.16.1751564179105;
        Thu, 03 Jul 2025 10:36:19 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-454a997e367sm32057155e9.15.2025.07.03.10.36.17
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 03 Jul 2025 10:36:18 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: Zhao Liu <zhao1.liu@intel.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Cameron Esfahani <dirty@apple.com>,
	Roman Bolshakov <rbolshakov@ddn.com>,
	Phil Dennis-Jordan <phil@philjordan.eu>,
	Mads Ynddal <mads@ynddal.dk>,
	Fabiano Rosas <farosas@suse.de>,
	Laurent Vivier <lvivier@redhat.com>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Anthony PERARD <anthony@xenproject.org>,
	Paul Durrant <paul@xen.org>,
	"Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
	Warner Losh <imp@bsdimp.com>,
	Kyle Evans <kevans@freebsd.org>,
	Peter Xu <peterx@redhat.com>,
	David Hildenbrand <david@redhat.com>,
	Reinoud Zandijk <reinoud@netbsd.org>,
	Sunil Muthuswamy <sunilmut@microsoft.com>,
	kvm@vger.kernel.org,
	xen-devel@lists.xenproject.org
Subject: [PATCH v6 38/39] accel: Extract AccelClass definition to 'accel/accel-ops.h'
Date: Thu,  3 Jul 2025 19:32:44 +0200
Message-ID: <20250703173248.44995-39-philmd@linaro.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250703173248.44995-1-philmd@linaro.org>
References: <20250703173248.44995-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Only accelerator implementations (and the common accelator
code) need to know about AccelClass internals. Move the
definition out but forward declare AccelState and AccelClass.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 MAINTAINERS                 |  2 +-
 include/accel/accel-ops.h   | 50 +++++++++++++++++++++++++++++++++++++
 include/qemu/accel.h        | 40 ++---------------------------
 include/system/hvf_int.h    |  3 ++-
 include/system/kvm_int.h    |  1 +
 accel/accel-common.c        |  1 +
 accel/accel-system.c        |  1 +
 accel/hvf/hvf-all.c         |  1 +
 accel/kvm/kvm-all.c         |  1 +
 accel/qtest/qtest.c         |  1 +
 accel/tcg/tcg-accel-ops.c   |  1 +
 accel/tcg/tcg-all.c         |  1 +
 accel/xen/xen-all.c         |  1 +
 bsd-user/main.c             |  1 +
 gdbstub/system.c            |  1 +
 linux-user/main.c           |  1 +
 system/memory.c             |  1 +
 target/i386/nvmm/nvmm-all.c |  1 +
 target/i386/whpx/whpx-all.c |  1 +
 19 files changed, 70 insertions(+), 40 deletions(-)
 create mode 100644 include/accel/accel-ops.h

diff --git a/MAINTAINERS b/MAINTAINERS
index 37d02b2313c..e3e08d4607f 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -501,7 +501,7 @@ F: include/exec/target_long.h
 F: include/qemu/accel.h
 F: include/system/accel-*.h
 F: include/system/cpus.h
-F: include/accel/accel-cpu*.h
+F: include/accel/accel-*.h
 F: accel/accel-*.?
 F: accel/dummy-cpus.?
 F: accel/Makefile.objs
diff --git a/include/accel/accel-ops.h b/include/accel/accel-ops.h
new file mode 100644
index 00000000000..35e7d4c3b26
--- /dev/null
+++ b/include/accel/accel-ops.h
@@ -0,0 +1,50 @@
+/*
+ * Accelerator handlers
+ *
+ * SPDX-License-Identifier: GPL-2.0-or-later
+ */
+
+#ifndef ACCEL_OPS_H
+#define ACCEL_OPS_H
+
+#include "exec/hwaddr.h"
+#include "qemu/accel.h"
+#include "qom/object.h"
+
+struct AccelState {
+    Object parent_obj;
+};
+
+struct AccelClass {
+    ObjectClass parent_class;
+
+    const char *name;
+    /* Cached by accel_init_ops_interfaces() when created */
+    AccelOpsClass *ops;
+
+    int (*init_machine)(AccelState *as, MachineState *ms);
+    bool (*cpu_common_realize)(CPUState *cpu, Error **errp);
+    void (*cpu_common_unrealize)(CPUState *cpu);
+
+    /* system related hooks */
+    void (*setup_post)(AccelState *as);
+    bool (*has_memory)(AccelState *accel, AddressSpace *as,
+                       hwaddr start_addr, hwaddr size);
+    bool (*cpus_are_resettable)(AccelState *as);
+
+    /* gdbstub related hooks */
+    bool (*supports_guest_debug)(AccelState *as);
+    int (*gdbstub_supported_sstep_flags)(AccelState *as);
+
+    bool *allowed;
+    /*
+     * Array of global properties that would be applied when specific
+     * accelerator is chosen. It works like MachineClass.compat_props
+     * but it's for accelerators not machines. Accelerator-provided
+     * global properties may be overridden by machine-type
+     * compat_props or user-provided global properties.
+     */
+    GPtrArray *compat_props;
+};
+
+#endif /* ACCEL_OPS_H */
diff --git a/include/qemu/accel.h b/include/qemu/accel.h
index 3c6350d6d63..71293a3e2a9 100644
--- a/include/qemu/accel.h
+++ b/include/qemu/accel.h
@@ -26,44 +26,8 @@
 #include "qom/object.h"
 #include "exec/hwaddr.h"
 
-struct AccelState {
-    /*< private >*/
-    Object parent_obj;
-};
-
-typedef struct AccelClass {
-    /*< private >*/
-    ObjectClass parent_class;
-    /*< public >*/
-
-    const char *name;
-    /* Cached by accel_init_ops_interfaces() when created */
-    AccelOpsClass *ops;
-
-    int (*init_machine)(AccelState *as, MachineState *ms);
-    bool (*cpu_common_realize)(CPUState *cpu, Error **errp);
-    void (*cpu_common_unrealize)(CPUState *cpu);
-
-    /* system related hooks */
-    void (*setup_post)(AccelState *as);
-    bool (*has_memory)(AccelState *accel, AddressSpace *as,
-                       hwaddr start_addr, hwaddr size);
-    bool (*cpus_are_resettable)(AccelState *as);
-
-    /* gdbstub related hooks */
-    bool (*supports_guest_debug)(AccelState *as);
-    int (*gdbstub_supported_sstep_flags)(AccelState *as);
-
-    bool *allowed;
-    /*
-     * Array of global properties that would be applied when specific
-     * accelerator is chosen. It works like MachineClass.compat_props
-     * but it's for accelerators not machines. Accelerator-provided
-     * global properties may be overridden by machine-type
-     * compat_props or user-provided global properties.
-     */
-    GPtrArray *compat_props;
-} AccelClass;
+typedef struct AccelState AccelState;
+typedef struct AccelClass AccelClass;
 
 #define TYPE_ACCEL "accel"
 
diff --git a/include/system/hvf_int.h b/include/system/hvf_int.h
index ecc49a309cf..8a443af3454 100644
--- a/include/system/hvf_int.h
+++ b/include/system/hvf_int.h
@@ -14,6 +14,7 @@
 #include "qemu/queue.h"
 #include "exec/vaddr.h"
 #include "qom/object.h"
+#include "accel/accel-ops.h"
 
 #ifdef __aarch64__
 #include <Hypervisor/Hypervisor.h>
@@ -45,7 +46,7 @@ typedef struct hvf_vcpu_caps {
 } hvf_vcpu_caps;
 
 struct HVFState {
-    AccelState parent;
+    AccelState parent_obj;
 
     hvf_slot slots[32];
     int num_slots;
diff --git a/include/system/kvm_int.h b/include/system/kvm_int.h
index 756a3c0a250..9247493b029 100644
--- a/include/system/kvm_int.h
+++ b/include/system/kvm_int.h
@@ -14,6 +14,7 @@
 #include "qemu/accel.h"
 #include "qemu/queue.h"
 #include "system/kvm.h"
+#include "accel/accel-ops.h"
 #include "hw/boards.h"
 #include "hw/i386/topology.h"
 #include "io/channel-socket.h"
diff --git a/accel/accel-common.c b/accel/accel-common.c
index b490612447b..de2504e435e 100644
--- a/accel/accel-common.c
+++ b/accel/accel-common.c
@@ -10,6 +10,7 @@
 #include "qemu/osdep.h"
 #include "qemu/accel.h"
 #include "qemu/target-info.h"
+#include "accel/accel-ops.h"
 #include "accel/accel-cpu-ops.h"
 #include "accel/accel-cpu.h"
 #include "accel-internal.h"
diff --git a/accel/accel-system.c b/accel/accel-system.c
index 451567e1a50..bce03c9ddeb 100644
--- a/accel/accel-system.c
+++ b/accel/accel-system.c
@@ -26,6 +26,7 @@
 #include "qemu/osdep.h"
 #include "qemu/accel.h"
 #include "hw/boards.h"
+#include "accel/accel-ops.h"
 #include "accel/accel-cpu-ops.h"
 #include "system/cpus.h"
 #include "qemu/error-report.h"
diff --git a/accel/hvf/hvf-all.c b/accel/hvf/hvf-all.c
index 4fae4c79805..11514533a84 100644
--- a/accel/hvf/hvf-all.c
+++ b/accel/hvf/hvf-all.c
@@ -10,6 +10,7 @@
 
 #include "qemu/osdep.h"
 #include "qemu/error-report.h"
+#include "accel/accel-ops.h"
 #include "system/address-spaces.h"
 #include "system/memory.h"
 #include "system/hvf.h"
diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index 9d1dc56d7e8..683116f68ff 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -32,6 +32,7 @@
 #include "system/runstate.h"
 #include "system/cpus.h"
 #include "system/accel-blocker.h"
+#include "accel/accel-ops.h"
 #include "qemu/bswap.h"
 #include "exec/tswap.h"
 #include "system/memory.h"
diff --git a/accel/qtest/qtest.c b/accel/qtest/qtest.c
index a7fc8bee6dd..1d4337d698e 100644
--- a/accel/qtest/qtest.c
+++ b/accel/qtest/qtest.c
@@ -18,6 +18,7 @@
 #include "qemu/option.h"
 #include "qemu/config-file.h"
 #include "qemu/accel.h"
+#include "accel/accel-ops.h"
 #include "accel/accel-cpu-ops.h"
 #include "system/qtest.h"
 #include "system/cpus.h"
diff --git a/accel/tcg/tcg-accel-ops.c b/accel/tcg/tcg-accel-ops.c
index 8f071d2cfeb..20802e24d46 100644
--- a/accel/tcg/tcg-accel-ops.c
+++ b/accel/tcg/tcg-accel-ops.c
@@ -26,6 +26,7 @@
  */
 
 #include "qemu/osdep.h"
+#include "accel/accel-ops.h"
 #include "accel/accel-cpu-ops.h"
 #include "system/tcg.h"
 #include "system/replay.h"
diff --git a/accel/tcg/tcg-all.c b/accel/tcg/tcg-all.c
index 93972bc0919..829a7293b80 100644
--- a/accel/tcg/tcg-all.c
+++ b/accel/tcg/tcg-all.c
@@ -39,6 +39,7 @@
 #ifndef CONFIG_USER_ONLY
 #include "hw/boards.h"
 #endif
+#include "accel/accel-ops.h"
 #include "accel/tcg/cpu-ops.h"
 #include "internal-common.h"
 
diff --git a/accel/xen/xen-all.c b/accel/xen/xen-all.c
index 55a60bb42c2..97377d67d1c 100644
--- a/accel/xen/xen-all.c
+++ b/accel/xen/xen-all.c
@@ -19,6 +19,7 @@
 #include "chardev/char.h"
 #include "qemu/accel.h"
 #include "accel/dummy-cpus.h"
+#include "accel/accel-ops.h"
 #include "accel/accel-cpu-ops.h"
 #include "system/cpus.h"
 #include "system/xen.h"
diff --git a/bsd-user/main.c b/bsd-user/main.c
index d0cc8e0088f..7e5d4bbce09 100644
--- a/bsd-user/main.c
+++ b/bsd-user/main.c
@@ -38,6 +38,7 @@
 #include "qemu/plugin.h"
 #include "user/guest-base.h"
 #include "user/page-protection.h"
+#include "accel/accel-ops.h"
 #include "tcg/startup.h"
 #include "qemu/timer.h"
 #include "qemu/envlist.h"
diff --git a/gdbstub/system.c b/gdbstub/system.c
index 1c48915b6a5..11870a1585f 100644
--- a/gdbstub/system.c
+++ b/gdbstub/system.c
@@ -20,6 +20,7 @@
 #include "gdbstub/commands.h"
 #include "exec/hwaddr.h"
 #include "exec/tb-flush.h"
+#include "accel/accel-ops.h"
 #include "accel/accel-cpu-ops.h"
 #include "system/cpus.h"
 #include "system/runstate.h"
diff --git a/linux-user/main.c b/linux-user/main.c
index a9142ee7268..254cf2526a8 100644
--- a/linux-user/main.c
+++ b/linux-user/main.c
@@ -42,6 +42,7 @@
 #include "user/page-protection.h"
 #include "exec/gdbstub.h"
 #include "gdbstub/user.h"
+#include "accel/accel-ops.h"
 #include "tcg/startup.h"
 #include "qemu/timer.h"
 #include "qemu/envlist.h"
diff --git a/system/memory.c b/system/memory.c
index b072a6bef83..13e833851a6 100644
--- a/system/memory.c
+++ b/system/memory.c
@@ -29,6 +29,7 @@
 #include "system/runstate.h"
 #include "system/tcg.h"
 #include "qemu/accel.h"
+#include "accel/accel-ops.h"
 #include "hw/boards.h"
 #include "migration/vmstate.h"
 #include "system/address-spaces.h"
diff --git a/target/i386/nvmm/nvmm-all.c b/target/i386/nvmm/nvmm-all.c
index b4a4d50e860..aab12d77326 100644
--- a/target/i386/nvmm/nvmm-all.c
+++ b/target/i386/nvmm/nvmm-all.c
@@ -12,6 +12,7 @@
 #include "system/address-spaces.h"
 #include "system/ioport.h"
 #include "qemu/accel.h"
+#include "accel/accel-ops.h"
 #include "system/nvmm.h"
 #include "system/cpus.h"
 #include "system/runstate.h"
diff --git a/target/i386/whpx/whpx-all.c b/target/i386/whpx/whpx-all.c
index 721c4782b9c..2a90cde6d50 100644
--- a/target/i386/whpx/whpx-all.c
+++ b/target/i386/whpx/whpx-all.c
@@ -14,6 +14,7 @@
 #include "system/ioport.h"
 #include "gdbstub/helpers.h"
 #include "qemu/accel.h"
+#include "accel/accel-ops.h"
 #include "system/whpx.h"
 #include "system/cpus.h"
 #include "system/runstate.h"
-- 
2.49.0


