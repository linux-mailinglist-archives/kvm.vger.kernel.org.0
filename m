Return-Path: <kvm+bounces-60307-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id E32B7BE86A9
	for <lists+kvm@lfdr.de>; Fri, 17 Oct 2025 13:39:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 4F1345668C3
	for <lists+kvm@lfdr.de>; Fri, 17 Oct 2025 11:38:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1AE8D34AAE2;
	Fri, 17 Oct 2025 11:34:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XZqO6N0i"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99B7D34AAE4
	for <kvm@vger.kernel.org>; Fri, 17 Oct 2025 11:34:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760700849; cv=none; b=DfnufKRSGsWSKTTEWJ3jz/njSklWMVsicVY5MthWLGG/UgfiKLX3ZvRoHUXG4hgqs361hDDRvZQOOB50FVQWKnb0zaHdU2Lla+HDo7wDCfM5tD2eH+vzdqmOCdzbweJdQk2XTOLajVGwj6tfh82ZbqFrW7ff4xRlTGtHoutQdWE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760700849; c=relaxed/simple;
	bh=FwoWQGewQnvfE3DgFl2sbo9F5FfNkmnnG6MdbtKa8/c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hIfZcOCoSWTNhpQh4ady02JO4vay2JY/tFJevbTJzGt/SfYEL43TrHyH6DhpLaJx/FWwcdPP7R10Rse841Vyu69DSEFyHnCJ8cClFrGtWCEvUtihsqOnPaWAwBlVssIudqTXQWVXcN0k+hrqNpmDkDjU0Uttn0Hn4b7xr84RuMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XZqO6N0i; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-46fc5e54cceso13674455e9.0
        for <kvm@vger.kernel.org>; Fri, 17 Oct 2025 04:34:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760700844; x=1761305644; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=S6vKc0hwwlCgha4p0dnyBbkmC+U2R4VT4bcnp+IbsaQ=;
        b=XZqO6N0iziceaL3hLDVH1JKvIb0fq6iH+Bd7gXLOeEobAkJ1we/kZc0Zp0UaQr4LZc
         AOwP7GP5L8RuXJSMMlB5EZGfgYNN4Dlo34+njUYNCU4ORiLTDFZbXDGvBh2ytYviVBbi
         RrksIlAMvjpwOD9vRz5oP7gL++lJbKRst7cVg3V1GCS1Iyre1tufN6hibie0cK4nzXmz
         rGaHpzoskS9BAjSTXPfPXot7E8mD27oNwwRW+Cb4j69HJYmisbQ7LkKT/JLABDCI+ZsZ
         /Bav8BYzTXm7e4D2snFbgsF3UbD9Ypwk5TVBol8KdLOs6U6s2bq+Yo/o5y8sbdDtON4P
         8Cug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760700844; x=1761305644;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=S6vKc0hwwlCgha4p0dnyBbkmC+U2R4VT4bcnp+IbsaQ=;
        b=guKWLi+1UfZE12fudonu1N8UgNUNu+2cv6fTJ7TIBrpf0LHAR/bJ6OEnN32h15aYry
         PqPI1yMMbfua6hXXxr+HT4dMSpAgXtPD4zvwS6egNCZ6zs2C0HhCh/c0vVNY+PE2+U4H
         QGPhw4B7SVIsicRVFMNknDeQ25eo4iC1CgbIGbmtpQA84wCCNM6Ndrchr3Ekg04dbfPG
         D4udqiOMCTGTRUl5w4AoBilY4STUQ8cO8cc3clKrUbi/YWvPE7LFDo5aEhem+y0rFS0x
         2OBEik/zYOnAh0nyoNCs/fWlCBbDeWtOapUkrdCUnC2NJ6B96DhC6sGLGd69xWG3MLdk
         mJVg==
X-Forwarded-Encrypted: i=1; AJvYcCWtZ0RxJ7CqRxUlA7oO6ocMPr05mq75BXQJ7EKXz8shy5IY/Bi4H3Kj1ejD6+oC704isD8=@vger.kernel.org
X-Gm-Message-State: AOJu0YzBtMXopL8Iws96buZUxkKowNjE4oA80ZFjskb9PuAYAJeS4ETt
	VdCz8ReHWGwMRaCkgvNoo8KysyMUKSg0PEcmxltpXu3OKPIP6yH3iUcx
X-Gm-Gg: ASbGncuLeYubnFRcYGMCobryQvhDiw6jOAQ3w0p5mnhpttNAxwNu0+JSd/uWaOWwpIk
	arFeEAt58Z84upNWJ6QdzHhyZas5YvA68qL1n/q3PvxlEjPClWNev65YMTa16B/XM++aoJVvUYQ
	muBIHDs2b5/ioHfaG4mj3q0Ua2B7UrLayd+vv2fadUMHcOIZqPn+WMWTuWL6WLFRHb4n5x99i/y
	Q7FJ6lqcQB42i6z7GbXtG78pl0pCBsgt7KV3emdWtVbENJHIM/6Z9EVNZgWe4TlayNB8vpwDUlM
	hBhr6eQuS3mUKbp6L2eKsgILT+vZni0aARVVwMAu85yeMsvG1KbkfAB3USfdv+vxCKyWhGze3ZV
	H5KxfGH3TB9wQasdeXoddI/iZIPstDOs3sCJvpmdZH5nwihjRpQbQpcB5VKot4739E6Ox0exIiM
	48CaeuUJxybShfLDb+4zRrJ69HbKuImU3P/w4bl/3rI98=
X-Google-Smtp-Source: AGHT+IGqAbveX4RPg/hEwQ7NGKwV+poU7tSRSzAmvVTRRBLpbtC5gXANcUNsHQ/As79zVpdgRNR6Bg==
X-Received: by 2002:a05:600c:1f93:b0:46f:b42e:e367 with SMTP id 5b1f17b1804b1-4711792a527mr23002855e9.41.1760700843581;
        Fri, 17 Oct 2025 04:34:03 -0700 (PDT)
Received: from archlinux (pd95edc07.dip0.t-ipconnect.de. [217.94.220.7])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4711444c8adsm80395435e9.13.2025.10.17.04.34.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Oct 2025 04:34:03 -0700 (PDT)
From: Bernhard Beschow <shentey@gmail.com>
To: qemu-devel@nongnu.org
Cc: Laurent Vivier <lvivier@redhat.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	John Snow <jsnow@redhat.com>,
	Fabiano Rosas <farosas@suse.de>,
	Laurent Vivier <laurent@vivier.eu>,
	kvm@vger.kernel.org,
	Zhao Liu <zhao1.liu@intel.com>,
	qemu-trivial@nongnu.org,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sunil Muthuswamy <sunilmut@microsoft.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Michael Tokarev <mjt@tls.msk.ru>,
	Richard Henderson <richard.henderson@linaro.org>,
	qemu-block@nongnu.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	Gerd Hoffmann <kraxel@redhat.com>,
	Bernhard Beschow <shentey@gmail.com>
Subject: [PATCH 6/8] hw/i386/apic: Prefer APICCommonState over DeviceState
Date: Fri, 17 Oct 2025 13:33:36 +0200
Message-ID: <20251017113338.7953-7-shentey@gmail.com>
X-Mailer: git-send-email 2.51.1.dirty
In-Reply-To: <20251017113338.7953-1-shentey@gmail.com>
References: <20251017113338.7953-1-shentey@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Makes the APIC API more type-safe by resolving quite a few APIC_COMMON
downcasts.

Like PICCommonState, the APICCommonState is now a public typedef while staying
an abstract datatype.

Signed-off-by: Bernhard Beschow <shentey@gmail.com>
---
 include/hw/i386/apic.h           | 33 +++++------
 include/hw/i386/apic_internal.h  |  7 +--
 target/i386/cpu.h                |  4 +-
 target/i386/kvm/kvm_i386.h       |  2 +-
 target/i386/whpx/whpx-internal.h |  2 +-
 hw/i386/kvm/apic.c               |  3 +-
 hw/i386/vapic.c                  |  2 +-
 hw/i386/x86-cpu.c                |  2 +-
 hw/intc/apic.c                   | 97 +++++++++++++-------------------
 hw/intc/apic_common.c            | 56 +++++++-----------
 target/i386/cpu-apic.c           |  4 +-
 target/i386/cpu.c                |  2 +-
 target/i386/kvm/kvm.c            |  2 +-
 target/i386/whpx/whpx-apic.c     |  3 +-
 14 files changed, 89 insertions(+), 130 deletions(-)

diff --git a/include/hw/i386/apic.h b/include/hw/i386/apic.h
index eb606d6076..871f142888 100644
--- a/include/hw/i386/apic.h
+++ b/include/hw/i386/apic.h
@@ -1,28 +1,29 @@
 #ifndef APIC_H
 #define APIC_H
 
+typedef struct APICCommonState APICCommonState;
 
 /* apic.c */
 void apic_set_max_apic_id(uint32_t max_apic_id);
-int apic_accept_pic_intr(DeviceState *s);
-void apic_deliver_pic_intr(DeviceState *s, int level);
-void apic_deliver_nmi(DeviceState *d);
-int apic_get_interrupt(DeviceState *s);
-int cpu_set_apic_base(DeviceState *s, uint64_t val);
-uint64_t cpu_get_apic_base(DeviceState *s);
-bool cpu_is_apic_enabled(DeviceState *s);
-void cpu_set_apic_tpr(DeviceState *s, uint8_t val);
-uint8_t cpu_get_apic_tpr(DeviceState *s);
-void apic_init_reset(DeviceState *s);
-void apic_sipi(DeviceState *s);
-void apic_poll_irq(DeviceState *d);
-void apic_designate_bsp(DeviceState *d, bool bsp);
-int apic_get_highest_priority_irr(DeviceState *dev);
+int apic_accept_pic_intr(APICCommonState *s);
+void apic_deliver_pic_intr(APICCommonState *s, int level);
+void apic_deliver_nmi(APICCommonState *s);
+int apic_get_interrupt(APICCommonState *s);
+int cpu_set_apic_base(APICCommonState *s, uint64_t val);
+uint64_t cpu_get_apic_base(APICCommonState *s);
+bool cpu_is_apic_enabled(APICCommonState *s);
+void cpu_set_apic_tpr(APICCommonState *s, uint8_t val);
+uint8_t cpu_get_apic_tpr(APICCommonState *s);
+void apic_init_reset(APICCommonState *s);
+void apic_sipi(APICCommonState *s);
+void apic_poll_irq(APICCommonState *s);
+void apic_designate_bsp(APICCommonState *s, bool bsp);
+int apic_get_highest_priority_irr(APICCommonState *s);
 int apic_msr_read(int index, uint64_t *val);
 int apic_msr_write(int index, uint64_t val);
-bool is_x2apic_mode(DeviceState *d);
+bool is_x2apic_mode(APICCommonState *s);
 
 /* pc.c */
-DeviceState *cpu_get_current_apic(void);
+APICCommonState *cpu_get_current_apic(void);
 
 #endif
diff --git a/include/hw/i386/apic_internal.h b/include/hw/i386/apic_internal.h
index 429278da61..4a62fdceb4 100644
--- a/include/hw/i386/apic_internal.h
+++ b/include/hw/i386/apic_internal.h
@@ -22,6 +22,7 @@
 #define QEMU_APIC_INTERNAL_H
 
 #include "cpu.h"
+#include "hw/i386/apic.h"
 #include "system/memory.h"
 #include "qemu/timer.h"
 #include "target/i386/cpu-qom.h"
@@ -125,8 +126,6 @@
 #define VAPIC_ENABLE_BIT                0
 #define VAPIC_ENABLE_MASK               (1 << VAPIC_ENABLE_BIT)
 
-typedef struct APICCommonState APICCommonState;
-
 #define TYPE_APIC_COMMON "apic-common"
 typedef struct APICCommonClass APICCommonClass;
 DECLARE_OBJ_CHECKERS(APICCommonState, APICCommonClass,
@@ -203,8 +202,8 @@ typedef struct VAPICState {
 extern bool apic_report_tpr_access;
 
 bool apic_next_timer(APICCommonState *s, int64_t current_time);
-void apic_enable_tpr_access_reporting(DeviceState *d, bool enable);
-void apic_enable_vapic(DeviceState *d, hwaddr paddr);
+void apic_enable_tpr_access_reporting(APICCommonState *s, bool enable);
+void apic_enable_vapic(APICCommonState *s, hwaddr paddr);
 
 void vapic_report_tpr_access(DeviceState *dev, CPUState *cpu, target_ulong ip,
                              TPRAccess access);
diff --git a/target/i386/cpu.h b/target/i386/cpu.h
index ce948861a7..67ff52a8b4 100644
--- a/target/i386/cpu.h
+++ b/target/i386/cpu.h
@@ -2349,7 +2349,7 @@ struct ArchCPU {
 
     /* in order to simplify APIC support, we leave this pointer to the
        user */
-    struct DeviceState *apic_state;
+    struct APICCommonState *apic_state;
     struct MemoryRegion *cpu_as_root, *cpu_as_mem, *smram;
     Notifier machine_done;
 
@@ -2830,7 +2830,7 @@ bool cpu_svm_has_intercept(CPUX86State *env, uint32_t type);
 
 /* apic.c */
 void cpu_report_tpr_access(CPUX86State *env, TPRAccess access);
-void apic_handle_tpr_access_report(DeviceState *d, target_ulong ip,
+void apic_handle_tpr_access_report(APICCommonState *s, target_ulong ip,
                                    TPRAccess access);
 
 /* Special values for X86CPUVersion: */
diff --git a/target/i386/kvm/kvm_i386.h b/target/i386/kvm/kvm_i386.h
index 5f83e8850a..5c908fdd6a 100644
--- a/target/i386/kvm/kvm_i386.h
+++ b/target/i386/kvm/kvm_i386.h
@@ -56,7 +56,7 @@ bool kvm_has_adjust_clock_stable(void);
 bool kvm_has_exception_payload(void);
 void kvm_synchronize_all_tsc(void);
 
-void kvm_get_apic_state(DeviceState *d, struct kvm_lapic_state *kapic);
+void kvm_get_apic_state(APICCommonState *s, struct kvm_lapic_state *kapic);
 void kvm_put_apicbase(X86CPU *cpu, uint64_t value);
 
 bool kvm_has_x2apic_api(void);
diff --git a/target/i386/whpx/whpx-internal.h b/target/i386/whpx/whpx-internal.h
index 6633e9c4ca..066e16bd8e 100644
--- a/target/i386/whpx/whpx-internal.h
+++ b/target/i386/whpx/whpx-internal.h
@@ -44,7 +44,7 @@ struct whpx_state {
 };
 
 extern struct whpx_state whpx_global;
-void whpx_apic_get(DeviceState *s);
+void whpx_apic_get(struct APICCommonState *s);
 
 #define WHV_E_UNKNOWN_CAPABILITY 0x80370300L
 
diff --git a/hw/i386/kvm/apic.c b/hw/i386/kvm/apic.c
index 1be9bfe36e..82355f0463 100644
--- a/hw/i386/kvm/apic.c
+++ b/hw/i386/kvm/apic.c
@@ -60,9 +60,8 @@ static void kvm_put_apic_state(APICCommonState *s, struct kvm_lapic_state *kapic
     kvm_apic_set_reg(kapic, 0x3e, s->divide_conf);
 }
 
-void kvm_get_apic_state(DeviceState *dev, struct kvm_lapic_state *kapic)
+void kvm_get_apic_state(APICCommonState *s, struct kvm_lapic_state *kapic)
 {
-    APICCommonState *s = APIC_COMMON(dev);
     int i, v;
 
     if (kvm_has_x2apic_api() && s->apicbase & MSR_IA32_APICBASE_EXTD) {
diff --git a/hw/i386/vapic.c b/hw/i386/vapic.c
index 0c1c92c479..f1089f0a7c 100644
--- a/hw/i386/vapic.c
+++ b/hw/i386/vapic.c
@@ -490,7 +490,7 @@ void vapic_report_tpr_access(DeviceState *dev, CPUState *cs, target_ulong ip,
 }
 
 typedef struct VAPICEnableTPRReporting {
-    DeviceState *apic;
+    APICCommonState *apic;
     bool enable;
 } VAPICEnableTPRReporting;
 
diff --git a/hw/i386/x86-cpu.c b/hw/i386/x86-cpu.c
index c876e6709e..1a86a853d5 100644
--- a/hw/i386/x86-cpu.c
+++ b/hw/i386/x86-cpu.c
@@ -86,7 +86,7 @@ int cpu_get_pic_interrupt(CPUX86State *env)
     return intno;
 }
 
-DeviceState *cpu_get_current_apic(void)
+APICCommonState *cpu_get_current_apic(void)
 {
     if (current_cpu) {
         X86CPU *cpu = X86_CPU(current_cpu);
diff --git a/hw/intc/apic.c b/hw/intc/apic.c
index c768033856..cb35c80c75 100644
--- a/hw/intc/apic.c
+++ b/hw/intc/apic.c
@@ -181,10 +181,8 @@ static void apic_local_deliver(APICCommonState *s, int vector)
     }
 }
 
-void apic_deliver_pic_intr(DeviceState *dev, int level)
+void apic_deliver_pic_intr(APICCommonState *s, int level)
 {
-    APICCommonState *s = APIC(dev);
-
     if (level) {
         apic_local_deliver(s, APIC_LVT_LINT0);
     } else {
@@ -301,10 +299,8 @@ static void apic_deliver_irq(uint32_t dest, uint8_t dest_mode,
     apic_bus_deliver(deliver_bitmask, delivery_mode, vector_num, trigger_mode);
 }
 
-bool is_x2apic_mode(DeviceState *dev)
+bool is_x2apic_mode(APICCommonState *s)
 {
-    APICCommonState *s = APIC(dev);
-
     return s->apicbase & MSR_IA32_APICBASE_EXTD;
 }
 
@@ -388,15 +384,12 @@ static void apic_set_tpr(APICCommonState *s, uint8_t val)
     }
 }
 
-int apic_get_highest_priority_irr(DeviceState *dev)
+int apic_get_highest_priority_irr(APICCommonState *s)
 {
-    APICCommonState *s;
-
-    if (!dev) {
+    if (!s) {
         /* no interrupts */
         return -1;
     }
-    s = APIC_COMMON(dev);
     return get_highest_priority_int(s->irr);
 }
 
@@ -458,22 +451,19 @@ static int apic_irq_pending(APICCommonState *s)
 static void apic_update_irq(APICCommonState *s)
 {
     CPUState *cpu;
-    DeviceState *dev = (DeviceState *)s;
 
     cpu = CPU(s->cpu);
     if (!qemu_cpu_is_self(cpu)) {
         cpu_interrupt(cpu, CPU_INTERRUPT_POLL);
     } else if (apic_irq_pending(s) > 0) {
         cpu_interrupt(cpu, CPU_INTERRUPT_HARD);
-    } else if (!apic_accept_pic_intr(dev) || !pic_get_output(isa_pic)) {
+    } else if (!apic_accept_pic_intr(s) || !pic_get_output(isa_pic)) {
         cpu_reset_interrupt(cpu, CPU_INTERRUPT_HARD);
     }
 }
 
-void apic_poll_irq(DeviceState *dev)
+void apic_poll_irq(APICCommonState *s)
 {
-    APICCommonState *s = APIC(dev);
-
     apic_sync_vapic(s, SYNC_FROM_VAPIC);
     apic_update_irq(s);
 }
@@ -516,7 +506,7 @@ static void apic_eoi(APICCommonState *s)
 
 static bool apic_match_dest(APICCommonState *apic, uint32_t dest)
 {
-    if (is_x2apic_mode(&apic->parent_obj)) {
+    if (is_x2apic_mode(apic)) {
         return apic->initial_apic_id == dest;
     } else {
         return apic->id == (uint8_t)dest;
@@ -550,7 +540,7 @@ static void apic_get_broadcast_bitmask(uint32_t *deliver_bitmask,
     for (i = 0; i < max_apics; i++) {
         apic_iter = local_apics[i];
         if (apic_iter) {
-            bool apic_in_x2apic = is_x2apic_mode(&apic_iter->parent_obj);
+            bool apic_in_x2apic = is_x2apic_mode(apic_iter);
 
             if (is_x2apic_broadcast && apic_in_x2apic) {
                 apic_set_bit(deliver_bitmask, i);
@@ -642,27 +632,24 @@ static void apic_startup(APICCommonState *s, int vector_num)
     cpu_interrupt(CPU(s->cpu), CPU_INTERRUPT_SIPI);
 }
 
-void apic_sipi(DeviceState *dev)
+void apic_sipi(APICCommonState *s)
 {
-    APICCommonState *s = APIC(dev);
-
     if (!s->wait_for_sipi)
         return;
     cpu_x86_load_seg_cache_sipi(s->cpu, s->sipi_vector);
     s->wait_for_sipi = 0;
 }
 
-static void apic_deliver(DeviceState *dev, uint32_t dest, uint8_t dest_mode,
+static void apic_deliver(APICCommonState *s, uint32_t dest, uint8_t dest_mode,
                          uint8_t delivery_mode, uint8_t vector_num,
                          uint8_t trigger_mode, uint8_t dest_shorthand)
 {
-    APICCommonState *s = APIC(dev);
     APICCommonState *apic_iter;
     uint32_t deliver_bitmask_size = max_apic_words * sizeof(uint32_t);
     g_autofree uint32_t *deliver_bitmask = g_new(uint32_t, max_apic_words);
     uint32_t current_apic_id;
 
-    if (is_x2apic_mode(dev)) {
+    if (is_x2apic_mode(s)) {
         current_apic_id = s->initial_apic_id;
     } else {
         current_apic_id = s->id;
@@ -709,18 +696,15 @@ static void apic_deliver(DeviceState *dev, uint32_t dest, uint8_t dest_mode,
 
 static bool apic_check_pic(APICCommonState *s)
 {
-    DeviceState *dev = (DeviceState *)s;
-
-    if (!apic_accept_pic_intr(dev) || !pic_get_output(isa_pic)) {
+    if (!apic_accept_pic_intr(s) || !pic_get_output(isa_pic)) {
         return false;
     }
-    apic_deliver_pic_intr(dev, 1);
+    apic_deliver_pic_intr(s, 1);
     return true;
 }
 
-int apic_get_interrupt(DeviceState *dev)
+int apic_get_interrupt(APICCommonState *s)
 {
-    APICCommonState *s = APIC(dev);
     int intno;
 
     /* if the APIC is installed or enabled, we let the 8259 handle the
@@ -752,9 +736,8 @@ int apic_get_interrupt(DeviceState *dev)
     return intno;
 }
 
-int apic_accept_pic_intr(DeviceState *dev)
+int apic_accept_pic_intr(APICCommonState *s)
 {
-    APICCommonState *s = APIC(dev);
     uint32_t lvt0;
 
     if (!s)
@@ -788,20 +771,18 @@ static void apic_timer(void *opaque)
 
 static int apic_register_read(int index, uint64_t *value)
 {
-    DeviceState *dev;
     APICCommonState *s;
     uint32_t val;
     int ret = 0;
 
-    dev = cpu_get_current_apic();
-    if (!dev) {
+    s = cpu_get_current_apic();
+    if (!s) {
         return -1;
     }
-    s = APIC(dev);
 
     switch(index) {
     case 0x02: /* id */
-        if (is_x2apic_mode(dev)) {
+        if (is_x2apic_mode(s)) {
             val = s->initial_apic_id;
         } else {
             val = s->id << 24;
@@ -828,14 +809,14 @@ static int apic_register_read(int index, uint64_t *value)
         val = 0;
         break;
     case 0x0d:
-        if (is_x2apic_mode(dev)) {
+        if (is_x2apic_mode(s)) {
             val = s->extended_log_dest;
         } else {
             val = s->log_dest << 24;
         }
         break;
     case 0x0e:
-        if (is_x2apic_mode(dev)) {
+        if (is_x2apic_mode(s)) {
             val = 0;
             ret = -1;
         } else {
@@ -902,14 +883,14 @@ static uint64_t apic_mem_read(void *opaque, hwaddr addr, unsigned size)
 
 int apic_msr_read(int index, uint64_t *val)
 {
-    DeviceState *dev;
+    APICCommonState *s;
 
-    dev = cpu_get_current_apic();
-    if (!dev) {
+    s = cpu_get_current_apic();
+    if (!s) {
         return -1;
     }
 
-    if (!is_x2apic_mode(dev)) {
+    if (!is_x2apic_mode(s)) {
         return -1;
     }
 
@@ -943,20 +924,18 @@ static void apic_send_msi(MSIMessage *msi)
 
 static int apic_register_write(int index, uint64_t val)
 {
-    DeviceState *dev;
     APICCommonState *s;
 
-    dev = cpu_get_current_apic();
-    if (!dev) {
+    s = cpu_get_current_apic();
+    if (!s) {
         return -1;
     }
-    s = APIC(dev);
 
     trace_apic_register_write(index, val);
 
     switch(index) {
     case 0x02:
-        if (is_x2apic_mode(dev)) {
+        if (is_x2apic_mode(s)) {
             return -1;
         }
 
@@ -979,14 +958,14 @@ static int apic_register_write(int index, uint64_t val)
         apic_eoi(s);
         break;
     case 0x0d:
-        if (is_x2apic_mode(dev)) {
+        if (is_x2apic_mode(s)) {
             return -1;
         }
 
         s->log_dest = val >> 24;
         break;
     case 0x0e:
-        if (is_x2apic_mode(dev)) {
+        if (is_x2apic_mode(s)) {
             return -1;
         }
 
@@ -1005,20 +984,20 @@ static int apic_register_write(int index, uint64_t val)
         uint32_t dest;
 
         s->icr[0] = val;
-        if (is_x2apic_mode(dev)) {
+        if (is_x2apic_mode(s)) {
             s->icr[1] = val >> 32;
             dest = s->icr[1];
         } else {
             dest = (s->icr[1] >> 24) & 0xff;
         }
 
-        apic_deliver(dev, dest, (s->icr[0] >> 11) & 1,
+        apic_deliver(s, dest, (s->icr[0] >> 11) & 1,
                      (s->icr[0] >> 8) & 7, (s->icr[0] & 0xff),
                      (s->icr[0] >> 15) & 1, (s->icr[0] >> 18) & 3);
         break;
     }
     case 0x31:
-        if (is_x2apic_mode(dev)) {
+        if (is_x2apic_mode(s)) {
             return -1;
         }
 
@@ -1053,7 +1032,7 @@ static int apic_register_write(int index, uint64_t val)
     case 0x3f: {
         int vector = val & 0xff;
 
-        if (!is_x2apic_mode(dev)) {
+        if (!is_x2apic_mode(s)) {
             return -1;
         }
 
@@ -1063,7 +1042,7 @@ static int apic_register_write(int index, uint64_t val)
          * - Trigger mode: 0 (Edge)
          * - Delivery mode: 0 (Fixed)
          */
-        apic_deliver(dev, 0, 0, APIC_DM_FIXED, vector, 0, 1);
+        apic_deliver(s, 0, 0, APIC_DM_FIXED, vector, 0, 1);
 
         break;
     }
@@ -1102,14 +1081,14 @@ static void apic_mem_write(void *opaque, hwaddr addr, uint64_t val,
 
 int apic_msr_write(int index, uint64_t val)
 {
-    DeviceState *dev;
+    APICCommonState *s;
 
-    dev = cpu_get_current_apic();
-    if (!dev) {
+    s = cpu_get_current_apic();
+    if (!s) {
         return -1;
     }
 
-    if (!is_x2apic_mode(dev)) {
+    if (!is_x2apic_mode(s)) {
         return -1;
     }
 
diff --git a/hw/intc/apic_common.c b/hw/intc/apic_common.c
index 394fe02013..ec9e978b0b 100644
--- a/hw/intc/apic_common.c
+++ b/hw/intc/apic_common.c
@@ -35,12 +35,11 @@
 
 bool apic_report_tpr_access;
 
-int cpu_set_apic_base(DeviceState *dev, uint64_t val)
+int cpu_set_apic_base(APICCommonState *s, uint64_t val)
 {
     trace_cpu_set_apic_base(val);
 
-    if (dev) {
-        APICCommonState *s = APIC_COMMON(dev);
+    if (s) {
         APICCommonClass *info = APIC_COMMON_GET_CLASS(s);
         /* Reset possibly modified xAPIC ID */
         s->id = s->initial_apic_id;
@@ -50,10 +49,9 @@ int cpu_set_apic_base(DeviceState *dev, uint64_t val)
     return 0;
 }
 
-uint64_t cpu_get_apic_base(DeviceState *dev)
+uint64_t cpu_get_apic_base(APICCommonState *s)
 {
-    if (dev) {
-        APICCommonState *s = APIC_COMMON(dev);
+    if (s) {
         trace_cpu_get_apic_base((uint64_t)s->apicbase);
         return s->apicbase;
     } else {
@@ -62,52 +60,43 @@ uint64_t cpu_get_apic_base(DeviceState *dev)
     }
 }
 
-bool cpu_is_apic_enabled(DeviceState *dev)
+bool cpu_is_apic_enabled(APICCommonState *s)
 {
-    APICCommonState *s;
-
-    if (!dev) {
+    if (!s) {
         return false;
     }
 
-    s = APIC_COMMON(dev);
-
     return s->apicbase & MSR_IA32_APICBASE_ENABLE;
 }
 
-void cpu_set_apic_tpr(DeviceState *dev, uint8_t val)
+void cpu_set_apic_tpr(APICCommonState *s, uint8_t val)
 {
-    APICCommonState *s;
     APICCommonClass *info;
 
-    if (!dev) {
+    if (!s) {
         return;
     }
 
-    s = APIC_COMMON(dev);
     info = APIC_COMMON_GET_CLASS(s);
 
     info->set_tpr(s, val);
 }
 
-uint8_t cpu_get_apic_tpr(DeviceState *dev)
+uint8_t cpu_get_apic_tpr(APICCommonState *s)
 {
-    APICCommonState *s;
     APICCommonClass *info;
 
-    if (!dev) {
+    if (!s) {
         return 0;
     }
 
-    s = APIC_COMMON(dev);
     info = APIC_COMMON_GET_CLASS(s);
 
     return info->get_tpr(s);
 }
 
-void apic_enable_tpr_access_reporting(DeviceState *dev, bool enable)
+void apic_enable_tpr_access_reporting(APICCommonState *s, bool enable)
 {
-    APICCommonState *s = APIC_COMMON(dev);
     APICCommonClass *info = APIC_COMMON_GET_CLASS(s);
 
     apic_report_tpr_access = enable;
@@ -116,26 +105,22 @@ void apic_enable_tpr_access_reporting(DeviceState *dev, bool enable)
     }
 }
 
-void apic_enable_vapic(DeviceState *dev, hwaddr paddr)
+void apic_enable_vapic(APICCommonState *s, hwaddr paddr)
 {
-    APICCommonState *s = APIC_COMMON(dev);
     APICCommonClass *info = APIC_COMMON_GET_CLASS(s);
 
     s->vapic_paddr = paddr;
     info->vapic_base_update(s);
 }
 
-void apic_handle_tpr_access_report(DeviceState *dev, target_ulong ip,
+void apic_handle_tpr_access_report(APICCommonState *s, target_ulong ip,
                                    TPRAccess access)
 {
-    APICCommonState *s = APIC_COMMON(dev);
-
     vapic_report_tpr_access(s->vapic, CPU(s->cpu), ip, access);
 }
 
-void apic_deliver_nmi(DeviceState *dev)
+void apic_deliver_nmi(APICCommonState *s)
 {
-    APICCommonState *s = APIC_COMMON(dev);
     APICCommonClass *info = APIC_COMMON_GET_CLASS(s);
 
     info->external_nmi(s);
@@ -193,16 +178,14 @@ uint32_t apic_get_current_count(APICCommonState *s)
     return val;
 }
 
-void apic_init_reset(DeviceState *dev)
+void apic_init_reset(APICCommonState *s)
 {
-    APICCommonState *s;
     APICCommonClass *info;
     int i;
 
-    if (!dev) {
+    if (!s) {
         return;
     }
-    s = APIC_COMMON(dev);
     s->tpr = 0;
     s->spurious_vec = 0xff;
     s->log_dest = 0;
@@ -233,13 +216,12 @@ void apic_init_reset(DeviceState *dev)
     }
 }
 
-void apic_designate_bsp(DeviceState *dev, bool bsp)
+void apic_designate_bsp(APICCommonState *s, bool bsp)
 {
-    if (dev == NULL) {
+    if (s == NULL) {
         return;
     }
 
-    APICCommonState *s = APIC_COMMON(dev);
     if (bsp) {
         s->apicbase |= MSR_IA32_APICBASE_BSP;
     } else {
@@ -262,7 +244,7 @@ static void apic_reset_common(DeviceState *dev)
     s->vapic_paddr = 0;
     info->vapic_base_update(s);
 
-    apic_init_reset(dev);
+    apic_init_reset(s);
 }
 
 static const VMStateDescription vmstate_apic_common;
diff --git a/target/i386/cpu-apic.c b/target/i386/cpu-apic.c
index 242a05fdbe..9b6c479865 100644
--- a/target/i386/cpu-apic.c
+++ b/target/i386/cpu-apic.c
@@ -48,7 +48,7 @@ void x86_cpu_apic_create(X86CPU *cpu, Error **errp)
         return;
     }
 
-    cpu->apic_state = DEVICE(object_new_with_class(OBJECT_CLASS(apic_class)));
+    cpu->apic_state = APIC_COMMON(object_new_with_class(OBJECT_CLASS(apic_class)));
     object_property_add_child(OBJECT(cpu), "lapic",
                               OBJECT(cpu->apic_state));
     object_unref(OBJECT(cpu->apic_state));
@@ -63,7 +63,7 @@ void x86_cpu_apic_create(X86CPU *cpu, Error **errp)
      * feature in case APIC ID >= 255, so we need to set apic->cpu
      * before setting APIC ID
      */
-    qdev_prop_set_uint32(cpu->apic_state, "id", cpu->apic_id);
+    qdev_prop_set_uint32(DEVICE(cpu->apic_state), "id", cpu->apic_id);
 }
 
 void x86_cpu_apic_realize(X86CPU *cpu, Error **errp)
diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index 455caff6b2..0a66e1fec9 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -8789,7 +8789,7 @@ void x86_cpu_after_reset(X86CPU *cpu)
     }
 
     if (cpu->apic_state) {
-        device_cold_reset(cpu->apic_state);
+        device_cold_reset(DEVICE(cpu->apic_state));
     }
 #endif
 }
diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index 309f043373..f7a6ef650a 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -5029,7 +5029,7 @@ static int kvm_get_mp_state(X86CPU *cpu)
 
 static int kvm_get_apic(X86CPU *cpu)
 {
-    DeviceState *apic = cpu->apic_state;
+    APICCommonState *apic = cpu->apic_state;
     struct kvm_lapic_state kapic;
     int ret;
 
diff --git a/target/i386/whpx/whpx-apic.c b/target/i386/whpx/whpx-apic.c
index e1ef6d4e6d..afcb25843b 100644
--- a/target/i386/whpx/whpx-apic.c
+++ b/target/i386/whpx/whpx-apic.c
@@ -151,9 +151,8 @@ static void whpx_apic_put(CPUState *cs, run_on_cpu_data data)
     }
 }
 
-void whpx_apic_get(DeviceState *dev)
+void whpx_apic_get(APICCommonState *s)
 {
-    APICCommonState *s = APIC_COMMON(dev);
     CPUState *cpu = CPU(s->cpu);
     struct whpx_lapic_state kapic;
 
-- 
2.51.1.dirty


