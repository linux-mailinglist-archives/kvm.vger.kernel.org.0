Return-Path: <kvm+bounces-51439-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id CDC1EAF713A
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 12:59:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 0A92E7B3C40
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 10:58:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DE5032E3AE2;
	Thu,  3 Jul 2025 10:58:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="jfqH5Dfo"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9ED02DE70E
	for <kvm@vger.kernel.org>; Thu,  3 Jul 2025 10:58:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751540338; cv=none; b=NPakOlwOc8jbenFQlGM49OaWfgv0FXKGfCE/4+CEZD2ptIvOK5Sre7UrgM//YUzDii9WEVUxsz5EFaJQFsXWxBRa5rudDqDSgEffbRYm1T+ENqfqkh25Si9U8LRDF5lo7MpVL9GwJf46GOImMWAzr17YspA/ISpZk+DNCmOEf0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751540338; c=relaxed/simple;
	bh=BDzU7aXB1YD2Fv5sZXvrPj+rsAolQ+R7QX9uKjCKTaI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BSUh/FHdlLHx3iy5Esi+ydxecvuSRykZ9J7gdgm0a0ZnlhczMyoUsGRVrKud+SL3aF+YmM28Nhhq5km7SO9l+KOMx1l04B5/5cLUv7plVwJSEbY2fjBvhdWMdBK2pQJymx1fMMtGiSXNSIG0TLYxJ6L2SmywoGPPul5q1JGDLgA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=jfqH5Dfo; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-4537fdec39fso18659225e9.0
        for <kvm@vger.kernel.org>; Thu, 03 Jul 2025 03:58:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1751540334; x=1752145134; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=coUKaKf6dZIxfVeFUFnOi2/CaQ9UIB137B6rtgj9MwA=;
        b=jfqH5Dfo26aMpodlfJVS0MvN6gKHOml71vMpTzJhfdYGtpGnz2ZbNyFrxdmzmgqz0l
         qG8NyWzzfQC3NvkYaLWeeDw5AjYptY2hoWWUd9iM/pUIOPPB6OR1HqD0VE7wUIWgsp9M
         pdu3uZ4puLaAYyigYtuds/l3HmJsS8LqDDzyyJloNC1bZqKIV4cFtHhq1y60QfAMxP8N
         fL48cSL0blNf41SW5JNuYFLc5uDHR1pSFc1xxwWzKxR43105b/jtZ034Im0MeREOjUYP
         C1d6e5UvJlrsng9aZZBPr0d2ndiq/lwCUGg/vSWorLH+7Ajs+cYiwPsLXDvwDBA9VZn5
         nbzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751540334; x=1752145134;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=coUKaKf6dZIxfVeFUFnOi2/CaQ9UIB137B6rtgj9MwA=;
        b=gBkdNDqiu9Nqon1wWeiTAn29HvEvd/SSoEEy+umeFKkpHPXCrZDfkfHFo99OVTGuWI
         GmSJdo1gUaaSe12AGnQtGpMnIvf14fjGCG4ewgwXGOq2eV5lmCd2PxykxC0x2XC1Ek4U
         dIeyTzK/XKqYCDVwoXqCwfX7OquKp7qmR6IKmVU6lth1hCEaqBti0zOG78GKZLBx98v8
         gguL690gVHQ5Eoajc5nbUZm/kb355AZWFnWuou4D/ryRd4z6VmE+NtdSwQLdhbgU2rxe
         SnzlKA12pEtA/Q+I9EtfUQon9rw0zlY0mWB0Vs7u+H1seA5AaNKS9X6BPjXhAtdHWn/B
         2Ypg==
X-Forwarded-Encrypted: i=1; AJvYcCV6jidzTLFzd3YBI/MwjXTbYZfhA6dMkDYfHj516gLHbKBAEE4EBNtGNzz8Ij9F5ETidiI=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywn17+mSO2xe0XsBwGs5XN0/86r63jzp0CCTKQkMX3dL8OYIfNA
	4w2iaqMhEqXm3wpT9UYVXKxA7oRxk3aMFLUoSVYtZqrM90K6n5yvyHpmtYoAAdEqUW0=
X-Gm-Gg: ASbGncv1kFDEgKj8JLcY/nudc0XJi14+BQ+vhbt0ZdwslA6B1Z6WU4KAYVMmIp/03b+
	tas/2TQ1w4u0kKgqYexI282gPQYoD83LcXCypl41Gorn/jNLMpQ6DJFAVysPB+WN+Q9xwKD5CKX
	bRESyKpjzES2xNo1Qa7dKHX07QGBjScHr1bo628/fRE+g34SWsq+UC5J6CV8t9Q+BZYvCvZ4Fsf
	S6pgt0bYeJeGCB0bTMLA9LJyA7HV08Y444k0EsuVQWGXwrkKTIEN2bRurVvyUasJE4OH8cSWSa+
	jlawsXkYr5M4IJ66Bca3mG+zorQ+ke2MbEmtRUI/Pb8HnulVyyv48R7T6OScJYV870OCVe+HCHQ
	gKT4iEdB87cE=
X-Google-Smtp-Source: AGHT+IFoAHmqAcsEqFViiwlToVOAvAPm8vzQ+vVW180SFtethjVrbQPcvt2pZvH71MhFhbJz0+QPYw==
X-Received: by 2002:adf:b648:0:b0:3a5:3b93:be4b with SMTP id ffacd0b85a97d-3b32ca3ea49mr1857645f8f.25.1751540333736;
        Thu, 03 Jul 2025 03:58:53 -0700 (PDT)
Received: from localhost.localdomain ([83.247.137.20])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-454a98ebe2asm24225595e9.0.2025.07.03.03.58.52
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 03 Jul 2025 03:58:53 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>,
	kvm@vger.kernel.org,
	Richard Henderson <richard.henderson@linaro.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Cameron Esfahani <dirty@apple.com>,
	Roman Bolshakov <rbolshakov@ddn.com>,
	Phil Dennis-Jordan <phil@philjordan.eu>,
	Mads Ynddal <mads@ynddal.dk>
Subject: [PATCH v5 36/69] accel/hvf: Move generic method declarations to hvf-all.c
Date: Thu,  3 Jul 2025 12:55:02 +0200
Message-ID: <20250703105540.67664-37-philmd@linaro.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250703105540.67664-1-philmd@linaro.org>
References: <20250703105540.67664-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

hvf-all.c aims to contain the generic accel methods (TYPE_ACCEL),
while hvf-accel-ops.c the per-vcpu methods (TYPE_ACCEL_OPS).

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
---
 accel/hvf/hvf-accel-ops.c | 278 +-------------------------------------
 accel/hvf/hvf-all.c       | 272 +++++++++++++++++++++++++++++++++++++
 2 files changed, 277 insertions(+), 273 deletions(-)

diff --git a/accel/hvf/hvf-accel-ops.c b/accel/hvf/hvf-accel-ops.c
index be044b9ceaa..319c30f703c 100644
--- a/accel/hvf/hvf-accel-ops.c
+++ b/accel/hvf/hvf-accel-ops.c
@@ -48,19 +48,16 @@
  */
 
 #include "qemu/osdep.h"
-#include "qemu/error-report.h"
+#include "qemu/guest-random.h"
 #include "qemu/main-loop.h"
 #include "qemu/queue.h"
-#include "system/address-spaces.h"
 #include "gdbstub/enums.h"
-#include "hw/boards.h"
+#include "exec/cpu-common.h"
 #include "system/accel-ops.h"
 #include "system/cpus.h"
 #include "system/hvf.h"
 #include "system/hvf_int.h"
-#include "system/runstate.h"
-#include "qemu/guest-random.h"
-#include "trace.h"
+#include "hw/core/cpu.h"
 
 HVFState *hvf_state;
 
@@ -80,132 +77,6 @@ hvf_slot *hvf_find_overlap_slot(uint64_t start, uint64_t size)
     return NULL;
 }
 
-struct mac_slot {
-    int present;
-    uint64_t size;
-    uint64_t gpa_start;
-    uint64_t gva;
-};
-
-struct mac_slot mac_slots[32];
-
-static int do_hvf_set_memory(hvf_slot *slot, hv_memory_flags_t flags)
-{
-    struct mac_slot *macslot;
-    hv_return_t ret;
-
-    macslot = &mac_slots[slot->slot_id];
-
-    if (macslot->present) {
-        if (macslot->size != slot->size) {
-            macslot->present = 0;
-            trace_hvf_vm_unmap(macslot->gpa_start, macslot->size);
-            ret = hv_vm_unmap(macslot->gpa_start, macslot->size);
-            assert_hvf_ok(ret);
-        }
-    }
-
-    if (!slot->size) {
-        return 0;
-    }
-
-    macslot->present = 1;
-    macslot->gpa_start = slot->start;
-    macslot->size = slot->size;
-    trace_hvf_vm_map(slot->start, slot->size, slot->mem, flags,
-                     flags & HV_MEMORY_READ ?  'R' : '-',
-                     flags & HV_MEMORY_WRITE ? 'W' : '-',
-                     flags & HV_MEMORY_EXEC ?  'E' : '-');
-    ret = hv_vm_map(slot->mem, slot->start, slot->size, flags);
-    assert_hvf_ok(ret);
-    return 0;
-}
-
-static void hvf_set_phys_mem(MemoryRegionSection *section, bool add)
-{
-    hvf_slot *mem;
-    MemoryRegion *area = section->mr;
-    bool writable = !area->readonly && !area->rom_device;
-    hv_memory_flags_t flags;
-    uint64_t page_size = qemu_real_host_page_size();
-
-    if (!memory_region_is_ram(area)) {
-        if (writable) {
-            return;
-        } else if (!memory_region_is_romd(area)) {
-            /*
-             * If the memory device is not in romd_mode, then we actually want
-             * to remove the hvf memory slot so all accesses will trap.
-             */
-             add = false;
-        }
-    }
-
-    if (!QEMU_IS_ALIGNED(int128_get64(section->size), page_size) ||
-        !QEMU_IS_ALIGNED(section->offset_within_address_space, page_size)) {
-        /* Not page aligned, so we can not map as RAM */
-        add = false;
-    }
-
-    mem = hvf_find_overlap_slot(
-            section->offset_within_address_space,
-            int128_get64(section->size));
-
-    if (mem && add) {
-        if (mem->size == int128_get64(section->size) &&
-            mem->start == section->offset_within_address_space &&
-            mem->mem == (memory_region_get_ram_ptr(area) +
-            section->offset_within_region)) {
-            return; /* Same region was attempted to register, go away. */
-        }
-    }
-
-    /* Region needs to be reset. set the size to 0 and remap it. */
-    if (mem) {
-        mem->size = 0;
-        if (do_hvf_set_memory(mem, 0)) {
-            error_report("Failed to reset overlapping slot");
-            abort();
-        }
-    }
-
-    if (!add) {
-        return;
-    }
-
-    if (area->readonly ||
-        (!memory_region_is_ram(area) && memory_region_is_romd(area))) {
-        flags = HV_MEMORY_READ | HV_MEMORY_EXEC;
-    } else {
-        flags = HV_MEMORY_READ | HV_MEMORY_WRITE | HV_MEMORY_EXEC;
-    }
-
-    /* Now make a new slot. */
-    int x;
-
-    for (x = 0; x < hvf_state->num_slots; ++x) {
-        mem = &hvf_state->slots[x];
-        if (!mem->size) {
-            break;
-        }
-    }
-
-    if (x == hvf_state->num_slots) {
-        error_report("No free slots");
-        abort();
-    }
-
-    mem->size = int128_get64(section->size);
-    mem->mem = memory_region_get_ram_ptr(area) + section->offset_within_region;
-    mem->start = section->offset_within_address_space;
-    mem->region = area;
-
-    if (do_hvf_set_memory(mem, flags)) {
-        error_report("Error registering new memory slot");
-        abort();
-    }
-}
-
 static void do_hvf_cpu_synchronize_state(CPUState *cpu, run_on_cpu_data arg)
 {
     if (!cpu->accel->dirty) {
@@ -243,157 +114,16 @@ static void hvf_cpu_synchronize_pre_loadvm(CPUState *cpu)
     run_on_cpu(cpu, do_hvf_cpu_synchronize_set_dirty, RUN_ON_CPU_NULL);
 }
 
-static void hvf_set_dirty_tracking(MemoryRegionSection *section, bool on)
-{
-    hvf_slot *slot;
-
-    slot = hvf_find_overlap_slot(
-            section->offset_within_address_space,
-            int128_get64(section->size));
-
-    /* protect region against writes; begin tracking it */
-    if (on) {
-        slot->flags |= HVF_SLOT_LOG;
-        hv_vm_protect((uintptr_t)slot->start, (size_t)slot->size,
-                      HV_MEMORY_READ | HV_MEMORY_EXEC);
-    /* stop tracking region*/
-    } else {
-        slot->flags &= ~HVF_SLOT_LOG;
-        hv_vm_protect((uintptr_t)slot->start, (size_t)slot->size,
-                      HV_MEMORY_READ | HV_MEMORY_WRITE | HV_MEMORY_EXEC);
-    }
-}
-
-static void hvf_log_start(MemoryListener *listener,
-                          MemoryRegionSection *section, int old, int new)
-{
-    if (old != 0) {
-        return;
-    }
-
-    hvf_set_dirty_tracking(section, 1);
-}
-
-static void hvf_log_stop(MemoryListener *listener,
-                         MemoryRegionSection *section, int old, int new)
-{
-    if (new != 0) {
-        return;
-    }
-
-    hvf_set_dirty_tracking(section, 0);
-}
-
-static void hvf_log_sync(MemoryListener *listener,
-                         MemoryRegionSection *section)
-{
-    /*
-     * sync of dirty pages is handled elsewhere; just make sure we keep
-     * tracking the region.
-     */
-    hvf_set_dirty_tracking(section, 1);
-}
-
-static void hvf_region_add(MemoryListener *listener,
-                           MemoryRegionSection *section)
-{
-    hvf_set_phys_mem(section, true);
-}
-
-static void hvf_region_del(MemoryListener *listener,
-                           MemoryRegionSection *section)
-{
-    hvf_set_phys_mem(section, false);
-}
-
-static MemoryListener hvf_memory_listener = {
-    .name = "hvf",
-    .priority = MEMORY_LISTENER_PRIORITY_ACCEL,
-    .region_add = hvf_region_add,
-    .region_del = hvf_region_del,
-    .log_start = hvf_log_start,
-    .log_stop = hvf_log_stop,
-    .log_sync = hvf_log_sync,
-};
-
 static void dummy_signal(int sig)
 {
 }
 
-bool hvf_allowed;
-
-static int hvf_accel_init(AccelState *as, MachineState *ms)
-{
-    int x;
-    hv_return_t ret;
-    HVFState *s = HVF_STATE(as);
-    int pa_range = 36;
-    MachineClass *mc = MACHINE_GET_CLASS(ms);
-
-    if (mc->hvf_get_physical_address_range) {
-        pa_range = mc->hvf_get_physical_address_range(ms);
-        if (pa_range < 0) {
-            return -EINVAL;
-        }
-    }
-
-    ret = hvf_arch_vm_create(ms, (uint32_t)pa_range);
-    if (ret == HV_DENIED) {
-        error_report("Could not access HVF. Is the executable signed"
-                     " with com.apple.security.hypervisor entitlement?");
-        exit(1);
-    }
-    assert_hvf_ok(ret);
-
-    s->num_slots = ARRAY_SIZE(s->slots);
-    for (x = 0; x < s->num_slots; ++x) {
-        s->slots[x].size = 0;
-        s->slots[x].slot_id = x;
-    }
-
-    QTAILQ_INIT(&s->hvf_sw_breakpoints);
-
-    hvf_state = s;
-    memory_listener_register(&hvf_memory_listener, &address_space_memory);
-
-    return hvf_arch_init();
-}
-
-static inline int hvf_gdbstub_sstep_flags(AccelState *as)
-{
-    return SSTEP_ENABLE | SSTEP_NOIRQ;
-}
-
 static void do_hvf_get_vcpu_exec_time(CPUState *cpu, run_on_cpu_data arg)
 {
     int r = hv_vcpu_get_exec_time(cpu->accel->fd, arg.host_ptr);
     assert_hvf_ok(r);
 }
 
-static void hvf_accel_class_init(ObjectClass *oc, const void *data)
-{
-    AccelClass *ac = ACCEL_CLASS(oc);
-    ac->name = "HVF";
-    ac->init_machine = hvf_accel_init;
-    ac->allowed = &hvf_allowed;
-    ac->supports_guest_debug = hvf_arch_supports_guest_debug;
-    ac->gdbstub_supported_sstep_flags = hvf_gdbstub_sstep_flags;
-}
-
-static const TypeInfo hvf_accel_type = {
-    .name = TYPE_HVF_ACCEL,
-    .parent = TYPE_ACCEL,
-    .instance_size = sizeof(HVFState),
-    .class_init = hvf_accel_class_init,
-};
-
-static void hvf_type_init(void)
-{
-    type_register_static(&hvf_accel_type);
-}
-
-type_init(hvf_type_init);
-
 static void hvf_vcpu_destroy(CPUState *cpu)
 {
     hv_return_t ret = hv_vcpu_destroy(cpu->accel->fd);
@@ -662,8 +392,10 @@ static const TypeInfo hvf_accel_ops_type = {
     .class_init = hvf_accel_ops_class_init,
     .abstract = true,
 };
+
 static void hvf_accel_ops_register_types(void)
 {
     type_register_static(&hvf_accel_ops_type);
 }
+
 type_init(hvf_accel_ops_register_types);
diff --git a/accel/hvf/hvf-all.c b/accel/hvf/hvf-all.c
index 481d7dece57..f498e32a23f 100644
--- a/accel/hvf/hvf-all.c
+++ b/accel/hvf/hvf-all.c
@@ -10,8 +10,24 @@
 
 #include "qemu/osdep.h"
 #include "qemu/error-report.h"
+#include "system/address-spaces.h"
+#include "system/memory.h"
 #include "system/hvf.h"
 #include "system/hvf_int.h"
+#include "hw/core/cpu.h"
+#include "hw/boards.h"
+#include "trace.h"
+
+bool hvf_allowed;
+
+struct mac_slot {
+    int present;
+    uint64_t size;
+    uint64_t gpa_start;
+    uint64_t gva;
+};
+
+struct mac_slot mac_slots[32];
 
 const char *hvf_return_string(hv_return_t ret)
 {
@@ -40,3 +56,259 @@ void assert_hvf_ok_impl(hv_return_t ret, const char *file, unsigned int line,
 
     abort();
 }
+
+static int do_hvf_set_memory(hvf_slot *slot, hv_memory_flags_t flags)
+{
+    struct mac_slot *macslot;
+    hv_return_t ret;
+
+    macslot = &mac_slots[slot->slot_id];
+
+    if (macslot->present) {
+        if (macslot->size != slot->size) {
+            macslot->present = 0;
+            trace_hvf_vm_unmap(macslot->gpa_start, macslot->size);
+            ret = hv_vm_unmap(macslot->gpa_start, macslot->size);
+            assert_hvf_ok(ret);
+        }
+    }
+
+    if (!slot->size) {
+        return 0;
+    }
+
+    macslot->present = 1;
+    macslot->gpa_start = slot->start;
+    macslot->size = slot->size;
+    trace_hvf_vm_map(slot->start, slot->size, slot->mem, flags,
+                     flags & HV_MEMORY_READ ?  'R' : '-',
+                     flags & HV_MEMORY_WRITE ? 'W' : '-',
+                     flags & HV_MEMORY_EXEC ?  'E' : '-');
+    ret = hv_vm_map(slot->mem, slot->start, slot->size, flags);
+    assert_hvf_ok(ret);
+    return 0;
+}
+
+static void hvf_set_phys_mem(MemoryRegionSection *section, bool add)
+{
+    hvf_slot *mem;
+    MemoryRegion *area = section->mr;
+    bool writable = !area->readonly && !area->rom_device;
+    hv_memory_flags_t flags;
+    uint64_t page_size = qemu_real_host_page_size();
+
+    if (!memory_region_is_ram(area)) {
+        if (writable) {
+            return;
+        } else if (!memory_region_is_romd(area)) {
+            /*
+             * If the memory device is not in romd_mode, then we actually want
+             * to remove the hvf memory slot so all accesses will trap.
+             */
+             add = false;
+        }
+    }
+
+    if (!QEMU_IS_ALIGNED(int128_get64(section->size), page_size) ||
+        !QEMU_IS_ALIGNED(section->offset_within_address_space, page_size)) {
+        /* Not page aligned, so we can not map as RAM */
+        add = false;
+    }
+
+    mem = hvf_find_overlap_slot(
+            section->offset_within_address_space,
+            int128_get64(section->size));
+
+    if (mem && add) {
+        if (mem->size == int128_get64(section->size) &&
+            mem->start == section->offset_within_address_space &&
+            mem->mem == (memory_region_get_ram_ptr(area) +
+            section->offset_within_region)) {
+            return; /* Same region was attempted to register, go away. */
+        }
+    }
+
+    /* Region needs to be reset. set the size to 0 and remap it. */
+    if (mem) {
+        mem->size = 0;
+        if (do_hvf_set_memory(mem, 0)) {
+            error_report("Failed to reset overlapping slot");
+            abort();
+        }
+    }
+
+    if (!add) {
+        return;
+    }
+
+    if (area->readonly ||
+        (!memory_region_is_ram(area) && memory_region_is_romd(area))) {
+        flags = HV_MEMORY_READ | HV_MEMORY_EXEC;
+    } else {
+        flags = HV_MEMORY_READ | HV_MEMORY_WRITE | HV_MEMORY_EXEC;
+    }
+
+    /* Now make a new slot. */
+    int x;
+
+    for (x = 0; x < hvf_state->num_slots; ++x) {
+        mem = &hvf_state->slots[x];
+        if (!mem->size) {
+            break;
+        }
+    }
+
+    if (x == hvf_state->num_slots) {
+        error_report("No free slots");
+        abort();
+    }
+
+    mem->size = int128_get64(section->size);
+    mem->mem = memory_region_get_ram_ptr(area) + section->offset_within_region;
+    mem->start = section->offset_within_address_space;
+    mem->region = area;
+
+    if (do_hvf_set_memory(mem, flags)) {
+        error_report("Error registering new memory slot");
+        abort();
+    }
+}
+
+static void hvf_set_dirty_tracking(MemoryRegionSection *section, bool on)
+{
+    hvf_slot *slot;
+
+    slot = hvf_find_overlap_slot(
+            section->offset_within_address_space,
+            int128_get64(section->size));
+
+    /* protect region against writes; begin tracking it */
+    if (on) {
+        slot->flags |= HVF_SLOT_LOG;
+        hv_vm_protect((uintptr_t)slot->start, (size_t)slot->size,
+                      HV_MEMORY_READ | HV_MEMORY_EXEC);
+    /* stop tracking region*/
+    } else {
+        slot->flags &= ~HVF_SLOT_LOG;
+        hv_vm_protect((uintptr_t)slot->start, (size_t)slot->size,
+                      HV_MEMORY_READ | HV_MEMORY_WRITE | HV_MEMORY_EXEC);
+    }
+}
+
+static void hvf_log_start(MemoryListener *listener,
+                          MemoryRegionSection *section, int old, int new)
+{
+    if (old != 0) {
+        return;
+    }
+
+    hvf_set_dirty_tracking(section, 1);
+}
+
+static void hvf_log_stop(MemoryListener *listener,
+                         MemoryRegionSection *section, int old, int new)
+{
+    if (new != 0) {
+        return;
+    }
+
+    hvf_set_dirty_tracking(section, 0);
+}
+
+static void hvf_log_sync(MemoryListener *listener,
+                         MemoryRegionSection *section)
+{
+    /*
+     * sync of dirty pages is handled elsewhere; just make sure we keep
+     * tracking the region.
+     */
+    hvf_set_dirty_tracking(section, 1);
+}
+
+static void hvf_region_add(MemoryListener *listener,
+                           MemoryRegionSection *section)
+{
+    hvf_set_phys_mem(section, true);
+}
+
+static void hvf_region_del(MemoryListener *listener,
+                           MemoryRegionSection *section)
+{
+    hvf_set_phys_mem(section, false);
+}
+
+static MemoryListener hvf_memory_listener = {
+    .name = "hvf",
+    .priority = MEMORY_LISTENER_PRIORITY_ACCEL,
+    .region_add = hvf_region_add,
+    .region_del = hvf_region_del,
+    .log_start = hvf_log_start,
+    .log_stop = hvf_log_stop,
+    .log_sync = hvf_log_sync,
+};
+
+static int hvf_accel_init(AccelState *as, MachineState *ms)
+{
+    int x;
+    hv_return_t ret;
+    HVFState *s = HVF_STATE(as);
+    int pa_range = 36;
+    MachineClass *mc = MACHINE_GET_CLASS(ms);
+
+    if (mc->hvf_get_physical_address_range) {
+        pa_range = mc->hvf_get_physical_address_range(ms);
+        if (pa_range < 0) {
+            return -EINVAL;
+        }
+    }
+
+    ret = hvf_arch_vm_create(ms, (uint32_t)pa_range);
+    if (ret == HV_DENIED) {
+        error_report("Could not access HVF. Is the executable signed"
+                     " with com.apple.security.hypervisor entitlement?");
+        exit(1);
+    }
+    assert_hvf_ok(ret);
+
+    s->num_slots = ARRAY_SIZE(s->slots);
+    for (x = 0; x < s->num_slots; ++x) {
+        s->slots[x].size = 0;
+        s->slots[x].slot_id = x;
+    }
+
+    QTAILQ_INIT(&s->hvf_sw_breakpoints);
+
+    hvf_state = s;
+    memory_listener_register(&hvf_memory_listener, &address_space_memory);
+
+    return hvf_arch_init();
+}
+
+static inline int hvf_gdbstub_sstep_flags(AccelState *as)
+{
+    return SSTEP_ENABLE | SSTEP_NOIRQ;
+}
+
+static void hvf_accel_class_init(ObjectClass *oc, const void *data)
+{
+    AccelClass *ac = ACCEL_CLASS(oc);
+    ac->name = "HVF";
+    ac->init_machine = hvf_accel_init;
+    ac->allowed = &hvf_allowed;
+    ac->supports_guest_debug = hvf_arch_supports_guest_debug;
+    ac->gdbstub_supported_sstep_flags = hvf_gdbstub_sstep_flags;
+}
+
+static const TypeInfo hvf_accel_type = {
+    .name = TYPE_HVF_ACCEL,
+    .parent = TYPE_ACCEL,
+    .instance_size = sizeof(HVFState),
+    .class_init = hvf_accel_class_init,
+};
+
+static void hvf_type_init(void)
+{
+    type_register_static(&hvf_accel_type);
+}
+
+type_init(hvf_type_init);
-- 
2.49.0


