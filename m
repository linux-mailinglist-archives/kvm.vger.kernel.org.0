Return-Path: <kvm+bounces-36455-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 1AE26A1AD7A
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2025 00:46:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 13320188E11D
	for <lists+kvm@lfdr.de>; Thu, 23 Jan 2025 23:46:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2105B1D5AB5;
	Thu, 23 Jan 2025 23:45:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="AM+mBYg6"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 614731D5145
	for <kvm@vger.kernel.org>; Thu, 23 Jan 2025 23:45:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737675957; cv=none; b=VgHH9TgyyzLcmGWELrX4F58/whUJmU8lTVn6gfcBGSUoQrwQ8to35uX1tyeQQ/dJHACQ4Gd+RB/tGArn/63OH10GlE/1p9SkD/EheXj7l9pWyBosTzKuNv26J86a7OnLwpctcOLSHpRsOF7awbnx5Te3P6VYJv1Ww4CXH44Y4JE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737675957; c=relaxed/simple;
	bh=+n1etEkqGg0BVPRatlhX1kHquhkRghxAJddT9q32VWo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OEHi6sS+bSMOoYBQ+9A3Ds873OnVfYX7AcZ5N1sM5qakA+lXsnGrlqPTz94PDVyOPMjS1swiCliTEtpD5ATLMoymrlT5yMD/kebmDKb5skCPyiFjm1S6ygx383NiAbutybf5grKCrvPXTVRzpKJg3dujggLicyq7lJf5rHDMe0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=AM+mBYg6; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-436341f575fso16147025e9.1
        for <kvm@vger.kernel.org>; Thu, 23 Jan 2025 15:45:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1737675953; x=1738280753; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MvtCakZyrGCXwv1NUluQigNUDDDoRJgD07DKcxozaAI=;
        b=AM+mBYg6hekCtX9q0+NIw/4DXnXxU7izXPM+mKFLP4KLA91n7hwrxKQ4bCP42kucKd
         0pR8tAv7uIWmQyFIA4jUz/NmyM1/lKOr5Xr2rrblmpYUKMiWZUVVrf/IkYAHjG1PdBdf
         XpRv1R7QLGxmEUMquYRZNs4xB7I03xkREc3iv4APmleSSyCRYQLiMk+Nw/OFg/oxX1WO
         U3WdcHjhRSYIgXcrWricDQSdKD+GovGYZcFZOsiRmul+szJrEEdnLpkQ0OUxx5UeGAL9
         uwSO29bwcsM4RB/8TySSTJBpdcdOyBxoQyhVaMUum3e3tY4my5oxLBlMj6qIeexpndC9
         yfzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737675953; x=1738280753;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MvtCakZyrGCXwv1NUluQigNUDDDoRJgD07DKcxozaAI=;
        b=dwstlcsKPqteNn56XSrGFQrBslmje1IiLq0qM6NLMFKqinDPaq7qdDDwiV8hJwTgfj
         MEuK1Ivdq+U82io96t9Db9YYkbLDvmzGqm3HDHGJ44n4qVIbBjDmtUe/C3MOuUFZuntV
         Xx68+LoBCEVC331sHLQbMWSPVkRGlOsMV83o22iplbrKoaYSH2gNX44Pl1AGJEFR4Vz7
         f7pYyOayh2Fxw8szsy7Jt/7tt9RWIJRm2km4O3mlYZAAYwycNEJ7hx+DDlHpDJ0cARxE
         RV+yXCeHZ8Iwj4iGuGdqZybvvjsVlRE/6Fl5kki0tOyzww7sI6IEhEQl2A3W7pgV2wHa
         t+qQ==
X-Forwarded-Encrypted: i=1; AJvYcCVn0SlE/9Xm7JUdrORaQO8DDC1Xuz/tqrmrylY4ZMPSiZoIqER3C1hWORpWtAfnMv4k8Es=@vger.kernel.org
X-Gm-Message-State: AOJu0YzXyBnmMNEcslB6ul2/80r3+zvflDBvABJvS9BLICG3vnKIDomY
	gQTiD8IPqwKzmuULUh0HHYK1yVebd68RuSsjbJHR5acZXKwaEzhnoPtDbrWlNKw=
X-Gm-Gg: ASbGncszhECa/K06NBmLRuCWGu/BfWasf3cCNHoJac/xnXH3ROH3ncT5RprqT3kYzbv
	nL20HliLc4zxPZ18SOwxhZdefJ6b2qIi4dwWHZX4NYmBQFUWR0SHGwbHqYdCxJLs30VtBq7DigM
	APEIJ0U7dmPnd8L2tNF9+ho9IO1QDmexIpo/xhhk/7Wl35SoFDUZ7bEilAb0t3JTopbIYApP8lQ
	Q0vQqX5wXfTB7fppye4Gc9lCIl8dXnor/LA2H6Clzaah9RCd8t+Dp76mdMesCQkjqH0bE4AFj/8
	TtSZI31H6NE8V1mvyiyI7+GOYvKzh3KBx07m9HVl6fmJYSGSFGTj0hA=
X-Google-Smtp-Source: AGHT+IESHbhLNhi6WI+MIsv7kwcNIGaQJ9dXLlWxoyCR3XibduHPGVHiP0CzOiY9OItw0/7PMnFvyA==
X-Received: by 2002:a05:600c:1987:b0:434:f753:6012 with SMTP id 5b1f17b1804b1-438913f2f4emr282730315e9.17.1737675953608;
        Thu, 23 Jan 2025 15:45:53 -0800 (PST)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-438bd43cdbbsm7488805e9.0.2025.01.23.15.45.51
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 23 Jan 2025 15:45:52 -0800 (PST)
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
Subject: [PATCH 17/20] cpus: Have cpu_class_init_props() per user / system emulation
Date: Fri, 24 Jan 2025 00:44:11 +0100
Message-ID: <20250123234415.59850-18-philmd@linaro.org>
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

Rather than maintaining a mix of system / user code for CPU
class properties, move system properties to cpu-system.c
and user ones to the new cpu-user.c unit.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 cpu-target.c         | 58 --------------------------------------------
 hw/core/cpu-system.c | 40 ++++++++++++++++++++++++++++++
 hw/core/cpu-user.c   | 27 +++++++++++++++++++++
 hw/core/meson.build  |  5 +++-
 4 files changed, 71 insertions(+), 59 deletions(-)
 create mode 100644 hw/core/cpu-user.c

diff --git a/cpu-target.c b/cpu-target.c
index c05ef1ff096..dff8c0747f9 100644
--- a/cpu-target.c
+++ b/cpu-target.c
@@ -19,15 +19,12 @@
 
 #include "qemu/osdep.h"
 #include "qapi/error.h"
-#include "hw/qdev-core.h"
-#include "hw/qdev-properties.h"
 #include "qemu/error-report.h"
 #include "qemu/qemu-print.h"
 #include "migration/vmstate.h"
 #ifndef CONFIG_USER_ONLY
 #include "hw/core/sysemu-cpu-ops.h"
 #include "exec/address-spaces.h"
-#include "exec/memory.h"
 #endif
 #include "system/accel-ops.h"
 #include "system/cpus.h"
@@ -179,61 +176,6 @@ void cpu_exec_unrealizefn(CPUState *cpu)
     accel_cpu_common_unrealize(cpu);
 }
 
-/*
- * This can't go in hw/core/cpu.c because that file is compiled only
- * once for both user-mode and system builds.
- */
-static const Property cpu_common_props[] = {
-#ifdef CONFIG_USER_ONLY
-    /*
-     * Create a property for the user-only object, so users can
-     * adjust prctl(PR_SET_UNALIGN) from the command-line.
-     * Has no effect if the target does not support the feature.
-     */
-    DEFINE_PROP_BOOL("prctl-unalign-sigbus", CPUState,
-                     prctl_unalign_sigbus, false),
-#else
-    /*
-     * Create a memory property for system CPU object, so users can
-     * wire up its memory.  The default if no link is set up is to use
-     * the system address space.
-     */
-    DEFINE_PROP_LINK("memory", CPUState, memory, TYPE_MEMORY_REGION,
-                     MemoryRegion *),
-#endif
-};
-
-#ifndef CONFIG_USER_ONLY
-static bool cpu_get_start_powered_off(Object *obj, Error **errp)
-{
-    CPUState *cpu = CPU(obj);
-    return cpu->start_powered_off;
-}
-
-static void cpu_set_start_powered_off(Object *obj, bool value, Error **errp)
-{
-    CPUState *cpu = CPU(obj);
-    cpu->start_powered_off = value;
-}
-#endif
-
-void cpu_class_init_props(DeviceClass *dc)
-{
-#ifndef CONFIG_USER_ONLY
-    ObjectClass *oc = OBJECT_CLASS(dc);
-
-    /*
-     * We can't use DEFINE_PROP_BOOL in the Property array for this
-     * property, because we want this to be settable after realize.
-     */
-    object_class_property_add_bool(oc, "start-powered-off",
-                                   cpu_get_start_powered_off,
-                                   cpu_set_start_powered_off);
-#endif
-
-    device_class_set_props(dc, cpu_common_props);
-}
-
 void cpu_exec_initfn(CPUState *cpu)
 {
 #ifndef CONFIG_USER_ONLY
diff --git a/hw/core/cpu-system.c b/hw/core/cpu-system.c
index 6aae28a349a..c63c984a803 100644
--- a/hw/core/cpu-system.c
+++ b/hw/core/cpu-system.c
@@ -20,7 +20,10 @@
 
 #include "qemu/osdep.h"
 #include "qapi/error.h"
+#include "exec/memory.h"
 #include "exec/tswap.h"
+#include "hw/qdev-core.h"
+#include "hw/qdev-properties.h"
 #include "hw/core/sysemu-cpu-ops.h"
 
 bool cpu_paging_enabled(const CPUState *cpu)
@@ -142,3 +145,40 @@ GuestPanicInformation *cpu_get_crash_info(CPUState *cpu)
     }
     return res;
 }
+
+static const Property cpu_system_props[] = {
+    /*
+     * Create a memory property for system CPU object, so users can
+     * wire up its memory.  The default if no link is set up is to use
+     * the system address space.
+     */
+    DEFINE_PROP_LINK("memory", CPUState, memory, TYPE_MEMORY_REGION,
+                     MemoryRegion *),
+};
+
+static bool cpu_get_start_powered_off(Object *obj, Error **errp)
+{
+    CPUState *cpu = CPU(obj);
+    return cpu->start_powered_off;
+}
+
+static void cpu_set_start_powered_off(Object *obj, bool value, Error **errp)
+{
+    CPUState *cpu = CPU(obj);
+    cpu->start_powered_off = value;
+}
+
+void cpu_class_init_props(DeviceClass *dc)
+{
+    ObjectClass *oc = OBJECT_CLASS(dc);
+
+    /*
+     * We can't use DEFINE_PROP_BOOL in the Property array for this
+     * property, because we want this to be settable after realize.
+     */
+    object_class_property_add_bool(oc, "start-powered-off",
+                                   cpu_get_start_powered_off,
+                                   cpu_set_start_powered_off);
+
+    device_class_set_props(dc, cpu_system_props);
+}
diff --git a/hw/core/cpu-user.c b/hw/core/cpu-user.c
new file mode 100644
index 00000000000..e5ccf6bf13a
--- /dev/null
+++ b/hw/core/cpu-user.c
@@ -0,0 +1,27 @@
+/*
+ * QEMU CPU model (user specific)
+ *
+ * Copyright (c) Linaro, Ltd.
+ *
+ * SPDX-License-Identifier: GPL-2.0-or-later
+ */
+
+#include "qemu/osdep.h"
+#include "hw/qdev-core.h"
+#include "hw/qdev-properties.h"
+#include "hw/core/cpu.h"
+
+static const Property cpu_user_props[] = {
+    /*
+     * Create a property for the user-only object, so users can
+     * adjust prctl(PR_SET_UNALIGN) from the command-line.
+     * Has no effect if the target does not support the feature.
+     */
+    DEFINE_PROP_BOOL("prctl-unalign-sigbus", CPUState,
+                     prctl_unalign_sigbus, false),
+};
+
+void cpu_class_init_props(DeviceClass *dc)
+{
+    device_class_set_props(dc, cpu_user_props);
+}
diff --git a/hw/core/meson.build b/hw/core/meson.build
index 65a1698ed1f..b5a545a0edd 100644
--- a/hw/core/meson.build
+++ b/hw/core/meson.build
@@ -46,4 +46,7 @@ system_ss.add(files(
   'vm-change-state-handler.c',
   'clock-vmstate.c',
 ))
-user_ss.add(files('qdev-user.c'))
+user_ss.add(files(
+  'cpu-user.c',
+  'qdev-user.c',
+))
-- 
2.47.1


