Return-Path: <kvm+bounces-20097-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DBF8E9109A8
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2024 17:22:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0BFD91C21C4F
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2024 15:22:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D0CD01AF6A3;
	Thu, 20 Jun 2024 15:22:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="EB3tMfAJ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BEC41AB91B
	for <kvm@vger.kernel.org>; Thu, 20 Jun 2024 15:22:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718896948; cv=none; b=jo+s0nNrfrIOoQVpU1bOsq4/fUY+GbTpcg0H1xSOFfpSXe5HRLIPm9fg2w3gQ+dEkEB1UhtjB+xeb50ncO6xneAvjpf9p1bEl6dYKpHGFVsA6RT8JwPUF4PTWZ2U365c13SaknVbSq32k32S6RcU06dKuZgIb7Shs9LljCiW5OQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718896948; c=relaxed/simple;
	bh=a/NUlqCvZJfUnZTc2CYLOBjgrGstoH2HmBX4yVV3hiU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aHiXw5Dqnt+mXqEMepHqDuWUbS5zHIEpweGYGjKYLmA33TDBjcw8a02Zz2PQXZ3vY2V7BLnNzsjbrpjHNZ1uDz6QSZ7sYDVqFRZVMGSfmxLLcD815zhVn0JdTX1iI8ZCyHY0eYJ0/E0d9f3xcoJBRfZnUuZOT28Yd+2ZBHf6/xk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=EB3tMfAJ; arc=none smtp.client-ip=209.85.208.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-57a1fe6392eso1296770a12.0
        for <kvm@vger.kernel.org>; Thu, 20 Jun 2024 08:22:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1718896944; x=1719501744; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LOX8Q5w9ilc+mTdUjLpvpvMTTAOVE9Tn6EBHwdgleNg=;
        b=EB3tMfAJLI2RApPVuTq/Tny/NnOv0UVowyy41N3SpFT/kqEruDSCyr18vUjTwP/Gi2
         Tc+jBDrji+iiZiT2FTMR2UdcBuucpw3G0bsgvaTBlxxmpYdSoWwqlDdcohDAtHWB737q
         CL3CbHlK0vMu7JeBqgF8rhzt/PFQBP4bx1RErhvwbaE6lYWx53YtIA/yZ4ARGd0aHg/L
         MUVvOi4HFKcmoBCPNzVdYNm8kXs+TOCz8Dmx1b4UX5X8VBFtF+62mqYWv15subGyH0Up
         VT7SiRKHq/qnfFJUtWSe3FUY7nare0mfDuAYreXKP5l1uc6eLKUo97YCWXf8OLKVbuL8
         GfvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718896944; x=1719501744;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LOX8Q5w9ilc+mTdUjLpvpvMTTAOVE9Tn6EBHwdgleNg=;
        b=K2icvIccyxz4lrCWroapImEaV8bpptcGB57A9HzVY8D2FwttgYhB7BTwO3Rfpry6XJ
         M8+f97xIf+y7xlj3lAyxhRY0vARs7IQn8KHvwnHKDAnOLk9xq2PSMgnjWbEh3ccjuKoN
         /JcrSG+Z8Ij0+XMjkod4H38QmNJdvG7YAtTWqhI2Xmoey6SecoQFG8CGBR6MaezHHt/P
         ZtyjqkJUh8XX4zb/hSGuXMXpVmVISVSJc6L87mL/PmyYM2uxIpjxbd+efueN3V6cn0ea
         SmN2N24Z1yXfy7P/Ji2mXiJU0xYSxfCVtskXJ4LJXAqySyNf7ZInpRxq+ZNKdin6D2oN
         CBLQ==
X-Forwarded-Encrypted: i=1; AJvYcCXx7YnYnBp5iqJATayHJrbHFFndRJ5JfleBItQJEK3bHxMhzcsQXHirNViiriPG5W5zrqHMDOCzfAqhkXwr5wMN0cxa
X-Gm-Message-State: AOJu0YytV6xwfwAwuRiN8yVxDXmanrOrWrLnt/GGbFul+qzm7uDxd8lz
	Uk/Lfjgg+iu03xWK9ei6Qf9tzg+URG/7+F4qe0558y/w/7vfY00toyc23O2j+OM=
X-Google-Smtp-Source: AGHT+IH8hZbaChjM3AJnO+aTrpsliFi4MfatJ5ruTS8TFIL6GBCuxi+m7UFhpS7uCY4WZIHcqJtRQw==
X-Received: by 2002:a17:906:d8a:b0:a6f:4c90:7951 with SMTP id a640c23a62f3a-a6fab60bcc3mr306422166b.8.1718896943901;
        Thu, 20 Jun 2024 08:22:23 -0700 (PDT)
Received: from draig.lan ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a6f56ecd5bfsm774823766b.113.2024.06.20.08.22.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Jun 2024 08:22:22 -0700 (PDT)
Received: from draig.lan (localhost [IPv6:::1])
	by draig.lan (Postfix) with ESMTP id 3A38F5F9F3;
	Thu, 20 Jun 2024 16:22:21 +0100 (BST)
From: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
To: qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>,
	kvm@vger.kernel.org,
	qemu-ppc@nongnu.org,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Jamie Iles <quic_jiles@quicinc.com>,
	David Hildenbrand <david@redhat.com>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>,
	Mark Burton <mburton@qti.qualcomm.com>,
	Daniel Henrique Barboza <danielhb413@gmail.com>,
	qemu-arm@nongnu.org,
	Laurent Vivier <lvivier@redhat.com>,
	Alexander Graf <agraf@csgraf.de>,
	Ilya Leoshkevich <iii@linux.ibm.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Marco Liebel <mliebel@qti.qualcomm.com>,
	Halil Pasic <pasic@linux.ibm.com>,
	Thomas Huth <thuth@redhat.com>,
	qemu-s390x@nongnu.org,
	Cameron Esfahani <dirty@apple.com>,
	Alexandre Iooss <erdnaxe@crans.org>,
	Nicholas Piggin <npiggin@gmail.com>,
	Roman Bolshakov <rbolshakov@ddn.com>,
	"Dr. David Alan Gilbert" <dave@treblig.org>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Mahmoud Mandour <ma.mandourr@gmail.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [PATCH v2 02/12] gdbstub: move enums into separate header
Date: Thu, 20 Jun 2024 16:22:10 +0100
Message-Id: <20240620152220.2192768-3-alex.bennee@linaro.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240620152220.2192768-1-alex.bennee@linaro.org>
References: <20240620152220.2192768-1-alex.bennee@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is an experiment to further reduce the amount we throw into the
exec headers. It might not be as useful as I initially thought because
just under half of the users also need gdbserver_start().

Message-Id: <20240612153508.1532940-3-alex.bennee@linaro.org>
Reviewed-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
---
 include/exec/gdbstub.h    |  9 ---------
 include/gdbstub/enums.h   | 21 +++++++++++++++++++++
 accel/hvf/hvf-accel-ops.c |  2 +-
 accel/kvm/kvm-all.c       |  2 +-
 accel/tcg/tcg-accel-ops.c |  2 +-
 gdbstub/user.c            |  1 +
 monitor/hmp-cmds.c        |  3 ++-
 system/vl.c               |  1 +
 target/arm/hvf/hvf.c      |  2 +-
 target/arm/hyp_gdbstub.c  |  2 +-
 target/arm/kvm.c          |  2 +-
 target/i386/kvm/kvm.c     |  2 +-
 target/ppc/kvm.c          |  2 +-
 target/s390x/kvm/kvm.c    |  2 +-
 14 files changed, 34 insertions(+), 19 deletions(-)
 create mode 100644 include/gdbstub/enums.h

diff --git a/include/exec/gdbstub.h b/include/exec/gdbstub.h
index 008a92198a..1bd2c4ec2a 100644
--- a/include/exec/gdbstub.h
+++ b/include/exec/gdbstub.h
@@ -1,15 +1,6 @@
 #ifndef GDBSTUB_H
 #define GDBSTUB_H
 
-#define DEFAULT_GDBSTUB_PORT "1234"
-
-/* GDB breakpoint/watchpoint types */
-#define GDB_BREAKPOINT_SW        0
-#define GDB_BREAKPOINT_HW        1
-#define GDB_WATCHPOINT_WRITE     2
-#define GDB_WATCHPOINT_READ      3
-#define GDB_WATCHPOINT_ACCESS    4
-
 typedef struct GDBFeature {
     const char *xmlname;
     const char *xml;
diff --git a/include/gdbstub/enums.h b/include/gdbstub/enums.h
new file mode 100644
index 0000000000..c4d54a1d08
--- /dev/null
+++ b/include/gdbstub/enums.h
@@ -0,0 +1,21 @@
+/*
+ * gdbstub enums
+ *
+ * Copyright (c) 2024 Linaro Ltd
+ *
+ * SPDX-License-Identifier: GPL-2.0-or-later
+ */
+
+#ifndef GDBSTUB_ENUMS_H
+#define GDBSTUB_ENUMS_H
+
+#define DEFAULT_GDBSTUB_PORT "1234"
+
+/* GDB breakpoint/watchpoint types */
+#define GDB_BREAKPOINT_SW        0
+#define GDB_BREAKPOINT_HW        1
+#define GDB_WATCHPOINT_WRITE     2
+#define GDB_WATCHPOINT_READ      3
+#define GDB_WATCHPOINT_ACCESS    4
+
+#endif /* GDBSTUB_ENUMS_H */
diff --git a/accel/hvf/hvf-accel-ops.c b/accel/hvf/hvf-accel-ops.c
index b2a37a2229..ac08cfb9f3 100644
--- a/accel/hvf/hvf-accel-ops.c
+++ b/accel/hvf/hvf-accel-ops.c
@@ -52,7 +52,7 @@
 #include "qemu/main-loop.h"
 #include "exec/address-spaces.h"
 #include "exec/exec-all.h"
-#include "exec/gdbstub.h"
+#include "gdbstub/enums.h"
 #include "sysemu/cpus.h"
 #include "sysemu/hvf.h"
 #include "sysemu/hvf_int.h"
diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index 854cb86b22..2b4ab89679 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -27,7 +27,7 @@
 #include "hw/pci/msi.h"
 #include "hw/pci/msix.h"
 #include "hw/s390x/adapter.h"
-#include "exec/gdbstub.h"
+#include "gdbstub/enums.h"
 #include "sysemu/kvm_int.h"
 #include "sysemu/runstate.h"
 #include "sysemu/cpus.h"
diff --git a/accel/tcg/tcg-accel-ops.c b/accel/tcg/tcg-accel-ops.c
index 1433e38f40..3c19e68a79 100644
--- a/accel/tcg/tcg-accel-ops.c
+++ b/accel/tcg/tcg-accel-ops.c
@@ -35,7 +35,7 @@
 #include "exec/exec-all.h"
 #include "exec/hwaddr.h"
 #include "exec/tb-flush.h"
-#include "exec/gdbstub.h"
+#include "gdbstub/enums.h"
 
 #include "hw/core/cpu.h"
 
diff --git a/gdbstub/user.c b/gdbstub/user.c
index edeb72efeb..e34b58b407 100644
--- a/gdbstub/user.c
+++ b/gdbstub/user.c
@@ -18,6 +18,7 @@
 #include "exec/gdbstub.h"
 #include "gdbstub/syscalls.h"
 #include "gdbstub/user.h"
+#include "gdbstub/enums.h"
 #include "hw/core/cpu.h"
 #include "trace.h"
 #include "internals.h"
diff --git a/monitor/hmp-cmds.c b/monitor/hmp-cmds.c
index 45ee3a9e1f..f601d06ab8 100644
--- a/monitor/hmp-cmds.c
+++ b/monitor/hmp-cmds.c
@@ -15,8 +15,9 @@
 
 #include "qemu/osdep.h"
 #include "exec/address-spaces.h"
-#include "exec/gdbstub.h"
 #include "exec/ioport.h"
+#include "exec/gdbstub.h"
+#include "gdbstub/enums.h"
 #include "monitor/hmp.h"
 #include "qemu/help_option.h"
 #include "monitor/monitor-internal.h"
diff --git a/system/vl.c b/system/vl.c
index a3eede5fa5..cfcb674425 100644
--- a/system/vl.c
+++ b/system/vl.c
@@ -68,6 +68,7 @@
 #include "sysemu/numa.h"
 #include "sysemu/hostmem.h"
 #include "exec/gdbstub.h"
+#include "gdbstub/enums.h"
 #include "qemu/timer.h"
 #include "chardev/char.h"
 #include "qemu/bitmap.h"
diff --git a/target/arm/hvf/hvf.c b/target/arm/hvf/hvf.c
index 45e2218be5..ef9bc42738 100644
--- a/target/arm/hvf/hvf.c
+++ b/target/arm/hvf/hvf.c
@@ -33,7 +33,7 @@
 #include "trace/trace-target_arm_hvf.h"
 #include "migration/vmstate.h"
 
-#include "exec/gdbstub.h"
+#include "gdbstub/enums.h"
 
 #define MDSCR_EL1_SS_SHIFT  0
 #define MDSCR_EL1_MDE_SHIFT 15
diff --git a/target/arm/hyp_gdbstub.c b/target/arm/hyp_gdbstub.c
index ebde2899cd..f120d55caa 100644
--- a/target/arm/hyp_gdbstub.c
+++ b/target/arm/hyp_gdbstub.c
@@ -12,7 +12,7 @@
 #include "qemu/osdep.h"
 #include "cpu.h"
 #include "internals.h"
-#include "exec/gdbstub.h"
+#include "gdbstub/enums.h"
 
 /* Maximum and current break/watch point counts */
 int max_hw_bps, max_hw_wps;
diff --git a/target/arm/kvm.c b/target/arm/kvm.c
index 7cf5cf31de..70f79eda33 100644
--- a/target/arm/kvm.c
+++ b/target/arm/kvm.c
@@ -31,7 +31,7 @@
 #include "hw/pci/pci.h"
 #include "exec/memattrs.h"
 #include "exec/address-spaces.h"
-#include "exec/gdbstub.h"
+#include "gdbstub/enums.h"
 #include "hw/boards.h"
 #include "hw/irq.h"
 #include "qapi/visitor.h"
diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index 7ad8072748..dd8b0f3313 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -38,7 +38,7 @@
 #include "hyperv.h"
 #include "hyperv-proto.h"
 
-#include "exec/gdbstub.h"
+#include "gdbstub/enums.h"
 #include "qemu/host-utils.h"
 #include "qemu/main-loop.h"
 #include "qemu/ratelimit.h"
diff --git a/target/ppc/kvm.c b/target/ppc/kvm.c
index 005f2239f3..2c3932200b 100644
--- a/target/ppc/kvm.c
+++ b/target/ppc/kvm.c
@@ -39,7 +39,7 @@
 #include "migration/qemu-file-types.h"
 #include "sysemu/watchdog.h"
 #include "trace.h"
-#include "exec/gdbstub.h"
+#include "gdbstub/enums.h"
 #include "exec/memattrs.h"
 #include "exec/ram_addr.h"
 #include "sysemu/hostmem.h"
diff --git a/target/s390x/kvm/kvm.c b/target/s390x/kvm/kvm.c
index 1b494ecc20..94181d9281 100644
--- a/target/s390x/kvm/kvm.c
+++ b/target/s390x/kvm/kvm.c
@@ -40,7 +40,7 @@
 #include "sysemu/hw_accel.h"
 #include "sysemu/runstate.h"
 #include "sysemu/device_tree.h"
-#include "exec/gdbstub.h"
+#include "gdbstub/enums.h"
 #include "exec/ram_addr.h"
 #include "trace.h"
 #include "hw/s390x/s390-pci-inst.h"
-- 
2.39.2


