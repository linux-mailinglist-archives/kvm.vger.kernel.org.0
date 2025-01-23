Return-Path: <kvm+bounces-36458-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 937F4A1AD7F
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2025 00:46:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 53082188D1C5
	for <lists+kvm@lfdr.de>; Thu, 23 Jan 2025 23:46:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B3A641DF993;
	Thu, 23 Jan 2025 23:46:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="ko55gOyb"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2E5F1D9A5F
	for <kvm@vger.kernel.org>; Thu, 23 Jan 2025 23:46:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737675968; cv=none; b=gl4Ygv7/9qTBnCwcFNZujSR/C9q/tiyyS9WCRAZ7brWhlGw3VqTcHLhoUE6DQFK2uzIqUVnWNrkgRGpCVcPLJCJOaP0Sjuz5Dz52NdJYlbrr/e4IgRyZhGbnMJFchBxP1cYmOAQ9lYbCovkksw2XnAeCdy+Gxo119ZQOmHLCX4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737675968; c=relaxed/simple;
	bh=163gI4MEUEuRQkHPP8Zd+fD9ueA96D9Tl16HJ/CL2mo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=I3yyfP59eQ01jHGapWZDAAnvoRYd5zsTpBv1rlhp9K2igROyYzJEzvXOk76TiH2yCx21sGGU6O1l7pQszKFmOfBl47IJRF8eVFbpwsd+rm9pWTEvPi7DbeeBCC1X568wKj/FEzQjfppQlxOaqjNbxWcVs/tg17VXYZxHycar0R8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=ko55gOyb; arc=none smtp.client-ip=209.85.221.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-38be3bfb045so1815050f8f.0
        for <kvm@vger.kernel.org>; Thu, 23 Jan 2025 15:46:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1737675965; x=1738280765; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sQ+5PubFZrrCYmUor7z2ohXZLQOj0+FDz6CQ50FZwrM=;
        b=ko55gOybU7Od3+XR9nJgxlgPcELlf7mfj0n6/QO+JJPh9UG8L0eEov7CTPUEQEACJt
         8KIhoTgYqHilsE/KF9q5NrrvaFvB6MZWCwgs2Ra36fvn7EIcnYLv8CaBH6u7Hg2JE0Vn
         HO9CdsHaJAmZebKmqf/cEi0udJcBCZySIYoXPrjHcnoz42ajimMI8yiK2MpcVLixfHl7
         0WvG9KAd7sDPKwtgPzVEgx4Z8AcKEbYmOb43LA0U0hGL86RRsoKxqAErn2kMU4m6oMNx
         nYS2qhOR1BXrS1mHCSQrEmSedOgY+DRNIz12zljE9CuB1owObOLPNOEbkKWO3GQbt0cx
         FNDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737675965; x=1738280765;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sQ+5PubFZrrCYmUor7z2ohXZLQOj0+FDz6CQ50FZwrM=;
        b=eI6ugs0gFRZvLPTB7r6gnVGFYfPzZj+5wG5S6dQNp1n58bAkTmwi6eHKHz7mL7s07h
         RMx/rofqtTKbXJdFtc42gBsBPtxupuH/G7oWxx6pQfHcCkkUKph17bS1c78q6hfWhVyt
         GuAgsbXceXYkamMo+JSNyrgHnq7hJvzANMtd9cjyCMfZNMbMTmgO811i07I/29VEfvWp
         +3FRwrY2qyenIN4vzaXDWAsSDGTQB2+Ue5vCtfPpEoU0rhzvki6f7VhVQm43rFIHAZgh
         MpqZfwNIf/J/OEirignsRXAZL5veUj48T6oTGY8hX7X5gmifBSzv8PivepD/pO/CRdRu
         sC5Q==
X-Forwarded-Encrypted: i=1; AJvYcCUGs2cl4OzNFjVChn+dUuoKk7Zwrs0pCVRWNC6RCwWXz35jeUYzrRW2djyNg+kQmxLJD94=@vger.kernel.org
X-Gm-Message-State: AOJu0YzsZJN8981ZdU7sIBTYbcRvLi6F6xWyJo6Z8DTT/zn/up0DzkhB
	A2oFEd7G1W9rPfrVuHktp5J/mRkDDqF/wtbEyR1+pXIejSwbGn9dgebrBQuGFjM=
X-Gm-Gg: ASbGncsitNQ4rY9DwG1pf/UIzyK5GS30iid6m58JhDnRnA0ra52CowgWud6Knz8q0kE
	04zVtUuxi9OQhxFv8/eJYPbb23Ah4zqOEnIYnDqjL0lBfNM3yg/BMGY5e0U5dltHtdHEAbWIxzY
	RL+wODXkImIaimMc3QZbNfA3zYWWTSMxjtY0/iEFf6PcTbxviBdkOkS0jCu2vXxxqBwXoKLFuis
	BzsIWGuiwLJGBMFDvmXhi3G9+hawWDzyFo5qtxSof/vK137qU9LkvZrGRepY4xej7jVUgpZLM4A
	iv432doj/vWz97icl3ogbGfMXGmFHRfL1GdVrFvUhEZ+wn7lY4ZpCLE=
X-Google-Smtp-Source: AGHT+IGsiKZVvuhBn67VKbvp7ZCKdJegwhgfqv/IiEk5xyysRNRbKSY3tyJ6LqHq9Om3O3Zv9Xfmsw==
X-Received: by 2002:adf:f250:0:b0:38a:5dc4:6dcd with SMTP id ffacd0b85a97d-38c22279dafmr4343550f8f.22.1737675965020;
        Thu, 23 Jan 2025 15:46:05 -0800 (PST)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38c2a1c403asm989733f8f.93.2025.01.23.15.46.03
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 23 Jan 2025 15:46:03 -0800 (PST)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	qemu-arm@nongnu.org,
	Igor Mammedov <imammedo@redhat.com>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	kvm@vger.kernel.org,
	qemu-ppc@nongnu.org,
	qemu-riscv@nongnu.org,
	David Hildenbrand <david@redhat.com>,
	qemu-s390x@nongnu.org,
	xen-devel@lists.xenproject.org,
	Richard Henderson <richard.henderson@linaro.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [PATCH 19/20] cpus: Register VMState per user / system emulation
Date: Fri, 24 Jan 2025 00:44:13 +0100
Message-ID: <20250123234415.59850-20-philmd@linaro.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250123234415.59850-1-philmd@linaro.org>
References: <20250123234415.59850-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Simplify cpu-target.c by extracting mixed vmstate code
into the cpu_vmstate_register() / cpu_vmstate_unregister()
helpers, implemented in cpu-user.c and cpu-system.c.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
XXX: tlb_flush() temporary declared manually.

Only 2 more CONFIG_USER_ONLY to go.
---
 include/hw/core/cpu.h |   2 +
 cpu-target.c          | 122 +----------------------------------------
 hw/core/cpu-system.c  | 123 ++++++++++++++++++++++++++++++++++++++++++
 hw/core/cpu-user.c    |  12 +++++
 4 files changed, 139 insertions(+), 120 deletions(-)

diff --git a/include/hw/core/cpu.h b/include/hw/core/cpu.h
index fb397cdfc53..aadbd2e1122 100644
--- a/include/hw/core/cpu.h
+++ b/include/hw/core/cpu.h
@@ -1163,6 +1163,8 @@ G_NORETURN void cpu_abort(CPUState *cpu, const char *fmt, ...)
 /* $(top_srcdir)/cpu.c */
 void cpu_class_init_props(DeviceClass *dc);
 void cpu_exec_initfn(CPUState *cpu);
+void cpu_vmstate_register(CPUState *cpu);
+void cpu_vmstate_unregister(CPUState *cpu);
 bool cpu_exec_realizefn(CPUState *cpu, Error **errp);
 void cpu_exec_unrealizefn(CPUState *cpu);
 void cpu_exec_reset_hold(CPUState *cpu);
diff --git a/cpu-target.c b/cpu-target.c
index 3d33d20b8c8..bfcd48f9ae2 100644
--- a/cpu-target.c
+++ b/cpu-target.c
@@ -21,115 +21,16 @@
 #include "qapi/error.h"
 #include "qemu/error-report.h"
 #include "qemu/qemu-print.h"
-#include "migration/vmstate.h"
-#ifndef CONFIG_USER_ONLY
-#include "hw/core/sysemu-cpu-ops.h"
-#endif
 #include "system/accel-ops.h"
 #include "system/cpus.h"
-#include "system/tcg.h"
 #include "exec/replay-core.h"
 #include "exec/cpu-common.h"
-#include "exec/exec-all.h"
-#include "exec/tb-flush.h"
 #include "exec/log.h"
 #include "accel/accel-cpu-target.h"
 #include "trace/trace-root.h"
 #include "qemu/accel.h"
 #include "hw/core/cpu.h"
 
-#ifndef CONFIG_USER_ONLY
-static int cpu_common_post_load(void *opaque, int version_id)
-{
-#ifdef CONFIG_TCG
-    if (tcg_enabled()) {
-        CPUState *cpu = opaque;
-
-        /*
-         * 0x01 was CPU_INTERRUPT_EXIT. This line can be removed when the
-         * version_id is increased.
-         */
-        cpu->interrupt_request &= ~0x01;
-
-        tlb_flush(cpu);
-
-        /*
-         * loadvm has just updated the content of RAM, bypassing the
-         * usual mechanisms that ensure we flush TBs for writes to
-         * memory we've translated code from. So we must flush all TBs,
-         * which will now be stale.
-         */
-        tb_flush(cpu);
-    }
-#endif
-
-    return 0;
-}
-
-static int cpu_common_pre_load(void *opaque)
-{
-    CPUState *cpu = opaque;
-
-    cpu->exception_index = -1;
-
-    return 0;
-}
-
-static bool cpu_common_exception_index_needed(void *opaque)
-{
-    CPUState *cpu = opaque;
-
-    return tcg_enabled() && cpu->exception_index != -1;
-}
-
-static const VMStateDescription vmstate_cpu_common_exception_index = {
-    .name = "cpu_common/exception_index",
-    .version_id = 1,
-    .minimum_version_id = 1,
-    .needed = cpu_common_exception_index_needed,
-    .fields = (const VMStateField[]) {
-        VMSTATE_INT32(exception_index, CPUState),
-        VMSTATE_END_OF_LIST()
-    }
-};
-
-static bool cpu_common_crash_occurred_needed(void *opaque)
-{
-    CPUState *cpu = opaque;
-
-    return cpu->crash_occurred;
-}
-
-static const VMStateDescription vmstate_cpu_common_crash_occurred = {
-    .name = "cpu_common/crash_occurred",
-    .version_id = 1,
-    .minimum_version_id = 1,
-    .needed = cpu_common_crash_occurred_needed,
-    .fields = (const VMStateField[]) {
-        VMSTATE_BOOL(crash_occurred, CPUState),
-        VMSTATE_END_OF_LIST()
-    }
-};
-
-const VMStateDescription vmstate_cpu_common = {
-    .name = "cpu_common",
-    .version_id = 1,
-    .minimum_version_id = 1,
-    .pre_load = cpu_common_pre_load,
-    .post_load = cpu_common_post_load,
-    .fields = (const VMStateField[]) {
-        VMSTATE_UINT32(halted, CPUState),
-        VMSTATE_UINT32(interrupt_request, CPUState),
-        VMSTATE_END_OF_LIST()
-    },
-    .subsections = (const VMStateDescription * const []) {
-        &vmstate_cpu_common_exception_index,
-        &vmstate_cpu_common_crash_occurred,
-        NULL
-    }
-};
-#endif
-
 bool cpu_exec_realizefn(CPUState *cpu, Error **errp)
 {
     if (!accel_cpu_common_realize(cpu, errp)) {
@@ -139,33 +40,14 @@ bool cpu_exec_realizefn(CPUState *cpu, Error **errp)
     /* Wait until cpu initialization complete before exposing cpu. */
     cpu_list_add(cpu);
 
-#ifdef CONFIG_USER_ONLY
-    assert(qdev_get_vmsd(DEVICE(cpu)) == NULL ||
-           qdev_get_vmsd(DEVICE(cpu))->unmigratable);
-#else
-    if (qdev_get_vmsd(DEVICE(cpu)) == NULL) {
-        vmstate_register(NULL, cpu->cpu_index, &vmstate_cpu_common, cpu);
-    }
-    if (cpu->cc->sysemu_ops->legacy_vmsd != NULL) {
-        vmstate_register(NULL, cpu->cpu_index, cpu->cc->sysemu_ops->legacy_vmsd, cpu);
-    }
-#endif /* CONFIG_USER_ONLY */
+    cpu_vmstate_register(cpu);
 
     return true;
 }
 
 void cpu_exec_unrealizefn(CPUState *cpu)
 {
-#ifndef CONFIG_USER_ONLY
-    CPUClass *cc = CPU_GET_CLASS(cpu);
-
-    if (cc->sysemu_ops->legacy_vmsd != NULL) {
-        vmstate_unregister(NULL, cc->sysemu_ops->legacy_vmsd, cpu);
-    }
-    if (qdev_get_vmsd(DEVICE(cpu)) == NULL) {
-        vmstate_unregister(NULL, &vmstate_cpu_common, cpu);
-    }
-#endif
+    cpu_vmstate_unregister(cpu);
 
     cpu_list_remove(cpu);
     /*
diff --git a/hw/core/cpu-system.c b/hw/core/cpu-system.c
index 0520c362db4..3e1f60f23df 100644
--- a/hw/core/cpu-system.c
+++ b/hw/core/cpu-system.c
@@ -22,10 +22,21 @@
 #include "qapi/error.h"
 #include "exec/address-spaces.h"
 #include "exec/memory.h"
+#include "exec/tb-flush.h"
 #include "exec/tswap.h"
 #include "hw/qdev-core.h"
 #include "hw/qdev-properties.h"
 #include "hw/core/sysemu-cpu-ops.h"
+#include "migration/vmstate.h"
+#include "system/tcg.h"
+
+/*
+ * XXX this series plan is to be applied on top on my exec/cputlb rework series,
+ * then tlb_flush() won't be declared target-specific in exec-all.h.
+ * Meanwhile, declare locally.
+ * XXX
+ */
+void tlb_flush(CPUState *cs);
 
 bool cpu_paging_enabled(const CPUState *cpu)
 {
@@ -189,3 +200,115 @@ void cpu_exec_initfn(CPUState *cpu)
     cpu->memory = get_system_memory();
     object_ref(OBJECT(cpu->memory));
 }
+
+static int cpu_common_post_load(void *opaque, int version_id)
+{
+#ifdef CONFIG_TCG
+    if (tcg_enabled()) {
+        CPUState *cpu = opaque;
+
+        /*
+         * 0x01 was CPU_INTERRUPT_EXIT. This line can be removed when the
+         * version_id is increased.
+         */
+        cpu->interrupt_request &= ~0x01;
+
+        tlb_flush(cpu);
+
+        /*
+         * loadvm has just updated the content of RAM, bypassing the
+         * usual mechanisms that ensure we flush TBs for writes to
+         * memory we've translated code from. So we must flush all TBs,
+         * which will now be stale.
+         */
+        tb_flush(cpu);
+    }
+#endif
+
+    return 0;
+}
+
+static int cpu_common_pre_load(void *opaque)
+{
+    CPUState *cpu = opaque;
+
+    cpu->exception_index = -1;
+
+    return 0;
+}
+
+static bool cpu_common_exception_index_needed(void *opaque)
+{
+    CPUState *cpu = opaque;
+
+    return tcg_enabled() && cpu->exception_index != -1;
+}
+
+static const VMStateDescription vmstate_cpu_common_exception_index = {
+    .name = "cpu_common/exception_index",
+    .version_id = 1,
+    .minimum_version_id = 1,
+    .needed = cpu_common_exception_index_needed,
+    .fields = (const VMStateField[]) {
+        VMSTATE_INT32(exception_index, CPUState),
+        VMSTATE_END_OF_LIST()
+    }
+};
+
+static bool cpu_common_crash_occurred_needed(void *opaque)
+{
+    CPUState *cpu = opaque;
+
+    return cpu->crash_occurred;
+}
+
+static const VMStateDescription vmstate_cpu_common_crash_occurred = {
+    .name = "cpu_common/crash_occurred",
+    .version_id = 1,
+    .minimum_version_id = 1,
+    .needed = cpu_common_crash_occurred_needed,
+    .fields = (const VMStateField[]) {
+        VMSTATE_BOOL(crash_occurred, CPUState),
+        VMSTATE_END_OF_LIST()
+    }
+};
+
+const VMStateDescription vmstate_cpu_common = {
+    .name = "cpu_common",
+    .version_id = 1,
+    .minimum_version_id = 1,
+    .pre_load = cpu_common_pre_load,
+    .post_load = cpu_common_post_load,
+    .fields = (const VMStateField[]) {
+        VMSTATE_UINT32(halted, CPUState),
+        VMSTATE_UINT32(interrupt_request, CPUState),
+        VMSTATE_END_OF_LIST()
+    },
+    .subsections = (const VMStateDescription * const []) {
+        &vmstate_cpu_common_exception_index,
+        &vmstate_cpu_common_crash_occurred,
+        NULL
+    }
+};
+
+void cpu_vmstate_register(CPUState *cpu)
+{
+    if (qdev_get_vmsd(DEVICE(cpu)) == NULL) {
+        vmstate_register(NULL, cpu->cpu_index, &vmstate_cpu_common, cpu);
+    }
+    if (cpu->cc->sysemu_ops->legacy_vmsd != NULL) {
+        vmstate_register(NULL, cpu->cpu_index, cpu->cc->sysemu_ops->legacy_vmsd, cpu);
+    }
+}
+
+void cpu_vmstate_unregister(CPUState *cpu)
+{
+    CPUClass *cc = CPU_GET_CLASS(cpu);
+
+    if (cc->sysemu_ops->legacy_vmsd != NULL) {
+        vmstate_unregister(NULL, cc->sysemu_ops->legacy_vmsd, cpu);
+    }
+    if (qdev_get_vmsd(DEVICE(cpu)) == NULL) {
+        vmstate_unregister(NULL, &vmstate_cpu_common, cpu);
+    }
+}
diff --git a/hw/core/cpu-user.c b/hw/core/cpu-user.c
index cdd8de2fefa..1892acdee0f 100644
--- a/hw/core/cpu-user.c
+++ b/hw/core/cpu-user.c
@@ -10,6 +10,7 @@
 #include "hw/qdev-core.h"
 #include "hw/qdev-properties.h"
 #include "hw/core/cpu.h"
+#include "migration/vmstate.h"
 
 static const Property cpu_user_props[] = {
     /*
@@ -30,3 +31,14 @@ void cpu_exec_initfn(CPUState *cpu)
 {
     /* nothing to do */
 }
+
+void cpu_vmstate_register(CPUState *cpu)
+{
+    assert(qdev_get_vmsd(DEVICE(cpu)) == NULL ||
+           qdev_get_vmsd(DEVICE(cpu))->unmigratable);
+}
+
+void cpu_vmstate_unregister(CPUState *cpu)
+{
+    /* nothing to do */
+}
-- 
2.47.1


