Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF756204F89
	for <lists+kvm@lfdr.de>; Tue, 23 Jun 2020 12:51:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732332AbgFWKvU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Jun 2020 06:51:20 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:28563 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1732272AbgFWKvR (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 23 Jun 2020 06:51:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592909471;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:  content-type:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mEg6XCfvV1v0FmAHgV2+JqjiKRpvGSEMh4QdEwoiO4c=;
        b=aOg6KDe6H4Pdqn6S6EFBOZDk12rSnvPHZgrBgKvwj7wYeCuf/c3b2OqEz+gFJD5D6hB2ih
        5zYKB+OlPYq90joBCfOc7DtfL9M+G6f74lG5FCp+23dDQ4DVm9C24U2tCxfgjTo6wopCvL
        a5NvR8w2yvQzentyIOxHXPMBaIseY4Q=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-271-2VVK0cWaPLa3mJ99zbd8Ow-1; Tue, 23 Jun 2020 06:51:09 -0400
X-MC-Unique: 2VVK0cWaPLa3mJ99zbd8Ow-1
Received: by mail-wm1-f72.google.com with SMTP id s134so3584246wme.6
        for <kvm@vger.kernel.org>; Tue, 23 Jun 2020 03:51:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mEg6XCfvV1v0FmAHgV2+JqjiKRpvGSEMh4QdEwoiO4c=;
        b=O/HdEq7bDHpRoATDGaqoqUbZC9z+9Z5rJUiBVAeP+RzGZpwm25tds5QglN6leiRQd0
         P4nbNIIrAaPNNW7myDEzid1Ub95xfUq2rEewV7B3sAAsGUXfN/EXxPOl/KCWcLXbnxu/
         e69m9uQd3WZWn6DJllw+kZjkTD7htEGWhiWjjGqjrC+xjem81qPvO4unGESlQHOEf/T3
         BYeLzlAUDfRj5CGspbJY8YbCttJuqBZ4NAoyUd/78pLPBOc7KgGmMOkYvJyyqXzO+arr
         krxcgIfBFWhJF0m8RGGKl/EX+pOfB7VppfvnqPuCn34PspsMobMVxy4NYSiJSozRc9CA
         mwhg==
X-Gm-Message-State: AOAM530jn/tIM6iUMKh4WtFbOPUHdhl6aPj5XWius6/QU4wMfuGlIa+s
        XrJBH58hePRLvhXnxaAltf4pLqAHCWhKXPbY/Lcoyk0ZZ4a9LtXxn8wvE4vLK3zKLT3eU0q9gCU
        5fzJgvTdTMx6a
X-Received: by 2002:a5d:6b8c:: with SMTP id n12mr9892330wrx.352.1592909467732;
        Tue, 23 Jun 2020 03:51:07 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwcmHTTh+C1XCkLV+VCjFhBVTDQGAMSeDwIB85ASZGE0EG/YP8vHYPSJXmB30UHTzhwOGQ7ag==
X-Received: by 2002:a5d:6b8c:: with SMTP id n12mr9892271wrx.352.1592909467017;
        Tue, 23 Jun 2020 03:51:07 -0700 (PDT)
Received: from localhost.localdomain (1.red-83-51-162.dynamicip.rima-tde.net. [83.51.162.1])
        by smtp.gmail.com with ESMTPSA id o29sm14395523wra.5.2020.06.23.03.51.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Jun 2020 03:51:06 -0700 (PDT)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Aurelien Jarno <aurelien@aurel32.net>,
        David Hildenbrand <david@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        Richard Henderson <rth@twiddle.net>, qemu-s390x@nongnu.org,
        David Gibson <david@gibson.dropbear.id.au>,
        Peter Maydell <peter.maydell@linaro.org>,
        Eduardo Habkost <ehabkost@redhat.com>, kvm@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>, qemu-arm@nongnu.org,
        Cornelia Huck <cohuck@redhat.com>, qemu-ppc@nongnu.org,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
Subject: [PATCH 2/7] accel/kvm: Simplify kvm_check_extension()
Date:   Tue, 23 Jun 2020 12:50:47 +0200
Message-Id: <20200623105052.1700-3-philmd@redhat.com>
X-Mailer: git-send-email 2.21.3
In-Reply-To: <20200623105052.1700-1-philmd@redhat.com>
References: <20200623105052.1700-1-philmd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In previous commit we let kvm_check_extension() use the
global kvm_state. Since the KVMState* argument is now
unused, drop it.

Convert callers with this Coccinelle script:

  @@
  expression kvm_state, extension;
  @@
  -   kvm_check_extension(kvm_state, extension)
  +   kvm_check_extension(extension)

Unused variables manually removed:
- CPUState* in hyperv_enabled()
- KVMState* in kvm_arm_get_max_vm_ipa_size()

Inspired-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
---
 include/sysemu/kvm.h         |  2 +-
 accel/kvm/kvm-all.c          | 64 ++++++++++++++++++------------------
 hw/hyperv/hyperv.c           |  2 +-
 hw/i386/kvm/clock.c          |  2 +-
 hw/i386/kvm/i8254.c          |  4 +--
 hw/i386/kvm/ioapic.c         |  2 +-
 hw/intc/arm_gic_kvm.c        |  2 +-
 hw/intc/openpic_kvm.c        |  2 +-
 hw/intc/xics_kvm.c           |  2 +-
 hw/s390x/s390-stattrib-kvm.c |  2 +-
 target/arm/kvm.c             | 13 ++++----
 target/arm/kvm32.c           |  2 +-
 target/arm/kvm64.c           | 15 ++++-----
 target/i386/kvm.c            | 61 ++++++++++++++++------------------
 target/mips/kvm.c            |  4 +--
 target/ppc/kvm.c             | 34 +++++++++----------
 target/s390x/cpu_models.c    |  3 +-
 target/s390x/kvm.c           | 30 ++++++++---------
 18 files changed, 119 insertions(+), 127 deletions(-)

diff --git a/include/sysemu/kvm.h b/include/sysemu/kvm.h
index b4174d941c..3662641c99 100644
--- a/include/sysemu/kvm.h
+++ b/include/sysemu/kvm.h
@@ -436,7 +436,7 @@ void kvm_arch_update_guest_debug(CPUState *cpu, struct kvm_guest_debug *dbg);
 
 bool kvm_arch_stop_on_emulation_error(CPUState *cpu);
 
-int kvm_check_extension(KVMState *s, unsigned int extension);
+int kvm_check_extension(unsigned int extension);
 
 int kvm_vm_check_extension(KVMState *s, unsigned int extension);
 
diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index 934a7d6b24..b6b39b0e92 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -909,7 +909,7 @@ static MemoryListener kvm_coalesced_pio_listener = {
     .coalesced_io_del = kvm_coalesce_pio_del,
 };
 
-int kvm_check_extension(KVMState *s, unsigned int extension)
+int kvm_check_extension(unsigned int extension)
 {
     int ret;
 
@@ -928,7 +928,7 @@ int kvm_vm_check_extension(KVMState *s, unsigned int extension)
     ret = kvm_vm_ioctl(s, KVM_CHECK_EXTENSION, extension);
     if (ret < 0) {
         /* VM wide version not implemented, use global one instead */
-        ret = kvm_check_extension(s, extension);
+        ret = kvm_check_extension(extension);
     }
 
     return ret;
@@ -1091,7 +1091,7 @@ static const KVMCapabilityInfo *
 kvm_check_extension_list(KVMState *s, const KVMCapabilityInfo *list)
 {
     while (list->name) {
-        if (!kvm_check_extension(s, list->value)) {
+        if (!kvm_check_extension(list->value)) {
             return list;
         }
         list++;
@@ -1394,7 +1394,7 @@ void kvm_init_irq_routing(KVMState *s)
 {
     int gsi_count, i;
 
-    gsi_count = kvm_check_extension(s, KVM_CAP_IRQ_ROUTING) - 1;
+    gsi_count = kvm_check_extension(KVM_CAP_IRQ_ROUTING) - 1;
     if (gsi_count > 0) {
         /* Round up so we can search ints using ffs */
         s->used_gsi_bitmap = bitmap_new(gsi_count);
@@ -1798,7 +1798,7 @@ int kvm_irqchip_add_hv_sint_route(KVMState *s, uint32_t vcpu, uint32_t sint)
     if (!kvm_gsi_routing_enabled()) {
         return -ENOSYS;
     }
-    if (!kvm_check_extension(s, KVM_CAP_HYPERV_SYNIC)) {
+    if (!kvm_check_extension(KVM_CAP_HYPERV_SYNIC)) {
         return -ENOSYS;
     }
     virq = kvm_irqchip_get_virq(s);
@@ -1907,9 +1907,9 @@ static void kvm_irqchip_create(KVMState *s)
     int ret;
 
     assert(s->kernel_irqchip_split != ON_OFF_AUTO_AUTO);
-    if (kvm_check_extension(s, KVM_CAP_IRQCHIP)) {
+    if (kvm_check_extension(KVM_CAP_IRQCHIP)) {
         ;
-    } else if (kvm_check_extension(s, KVM_CAP_S390_IRQCHIP)) {
+    } else if (kvm_check_extension(KVM_CAP_S390_IRQCHIP)) {
         ret = kvm_vm_enable_cap(s, KVM_CAP_S390_IRQCHIP, 0);
         if (ret < 0) {
             fprintf(stderr, "Enable kernel irqchip failed: %s\n", strerror(-ret));
@@ -1959,13 +1959,13 @@ static int kvm_recommended_vcpus(KVMState *s)
 
 static int kvm_max_vcpus(KVMState *s)
 {
-    int ret = kvm_check_extension(s, KVM_CAP_MAX_VCPUS);
+    int ret = kvm_check_extension(KVM_CAP_MAX_VCPUS);
     return (ret) ? ret : kvm_recommended_vcpus(s);
 }
 
 static int kvm_max_vcpu_id(KVMState *s)
 {
-    int ret = kvm_check_extension(s, KVM_CAP_MAX_VCPU_ID);
+    int ret = kvm_check_extension(KVM_CAP_MAX_VCPU_ID);
     return (ret) ? ret : kvm_max_vcpus(s);
 }
 
@@ -2035,15 +2035,15 @@ static int kvm_init(MachineState *ms)
         goto err;
     }
 
-    kvm_immediate_exit = kvm_check_extension(s, KVM_CAP_IMMEDIATE_EXIT);
-    s->nr_slots = kvm_check_extension(s, KVM_CAP_NR_MEMSLOTS);
+    kvm_immediate_exit = kvm_check_extension(KVM_CAP_IMMEDIATE_EXIT);
+    s->nr_slots = kvm_check_extension(KVM_CAP_NR_MEMSLOTS);
 
     /* If unspecified, use the default value */
     if (!s->nr_slots) {
         s->nr_slots = 32;
     }
 
-    s->nr_as = kvm_check_extension(s, KVM_CAP_MULTI_ADDRESS_SPACE);
+    s->nr_as = kvm_check_extension(KVM_CAP_MULTI_ADDRESS_SPACE);
     if (s->nr_as <= 1) {
         s->nr_as = 1;
     }
@@ -2116,12 +2116,12 @@ static int kvm_init(MachineState *ms)
         goto err;
     }
 
-    s->coalesced_mmio = kvm_check_extension(s, KVM_CAP_COALESCED_MMIO);
+    s->coalesced_mmio = kvm_check_extension(KVM_CAP_COALESCED_MMIO);
     s->coalesced_pio = s->coalesced_mmio &&
-                       kvm_check_extension(s, KVM_CAP_COALESCED_PIO);
+                       kvm_check_extension(KVM_CAP_COALESCED_PIO);
 
     s->manual_dirty_log_protect =
-        kvm_check_extension(s, KVM_CAP_MANUAL_DIRTY_LOG_PROTECT2);
+        kvm_check_extension(KVM_CAP_MANUAL_DIRTY_LOG_PROTECT2);
     if (s->manual_dirty_log_protect) {
         ret = kvm_vm_enable_cap(s, KVM_CAP_MANUAL_DIRTY_LOG_PROTECT2, 0, 1);
         if (ret) {
@@ -2132,46 +2132,46 @@ static int kvm_init(MachineState *ms)
     }
 
 #ifdef KVM_CAP_VCPU_EVENTS
-    s->vcpu_events = kvm_check_extension(s, KVM_CAP_VCPU_EVENTS);
+    s->vcpu_events = kvm_check_extension(KVM_CAP_VCPU_EVENTS);
 #endif
 
     s->robust_singlestep =
-        kvm_check_extension(s, KVM_CAP_X86_ROBUST_SINGLESTEP);
+        kvm_check_extension(KVM_CAP_X86_ROBUST_SINGLESTEP);
 
 #ifdef KVM_CAP_DEBUGREGS
-    s->debugregs = kvm_check_extension(s, KVM_CAP_DEBUGREGS);
+    s->debugregs = kvm_check_extension(KVM_CAP_DEBUGREGS);
 #endif
 
-    s->max_nested_state_len = kvm_check_extension(s, KVM_CAP_NESTED_STATE);
+    s->max_nested_state_len = kvm_check_extension(KVM_CAP_NESTED_STATE);
 
 #ifdef KVM_CAP_IRQ_ROUTING
-    kvm_direct_msi_allowed = (kvm_check_extension(s, KVM_CAP_SIGNAL_MSI) > 0);
+    kvm_direct_msi_allowed = (kvm_check_extension(KVM_CAP_SIGNAL_MSI) > 0);
 #endif
 
-    s->intx_set_mask = kvm_check_extension(s, KVM_CAP_PCI_2_3);
+    s->intx_set_mask = kvm_check_extension(KVM_CAP_PCI_2_3);
 
     s->irq_set_ioctl = KVM_IRQ_LINE;
-    if (kvm_check_extension(s, KVM_CAP_IRQ_INJECT_STATUS)) {
+    if (kvm_check_extension(KVM_CAP_IRQ_INJECT_STATUS)) {
         s->irq_set_ioctl = KVM_IRQ_LINE_STATUS;
     }
 
     kvm_readonly_mem_allowed =
-        (kvm_check_extension(s, KVM_CAP_READONLY_MEM) > 0);
+        (kvm_check_extension(KVM_CAP_READONLY_MEM) > 0);
 
     kvm_eventfds_allowed =
-        (kvm_check_extension(s, KVM_CAP_IOEVENTFD) > 0);
+        (kvm_check_extension(KVM_CAP_IOEVENTFD) > 0);
 
     kvm_irqfds_allowed =
-        (kvm_check_extension(s, KVM_CAP_IRQFD) > 0);
+        (kvm_check_extension(KVM_CAP_IRQFD) > 0);
 
     kvm_resamplefds_allowed =
-        (kvm_check_extension(s, KVM_CAP_IRQFD_RESAMPLE) > 0);
+        (kvm_check_extension(KVM_CAP_IRQFD_RESAMPLE) > 0);
 
     kvm_vm_attributes_allowed =
-        (kvm_check_extension(s, KVM_CAP_VM_ATTRIBUTES) > 0);
+        (kvm_check_extension(KVM_CAP_VM_ATTRIBUTES) > 0);
 
     kvm_ioeventfd_any_length_allowed =
-        (kvm_check_extension(s, KVM_CAP_IOEVENTFD_ANY_LENGTH) > 0);
+        (kvm_check_extension(KVM_CAP_IOEVENTFD_ANY_LENGTH) > 0);
 
     kvm_state = s;
 
@@ -2264,7 +2264,7 @@ static int kvm_handle_internal_error(CPUState *cpu, struct kvm_run *run)
     fprintf(stderr, "KVM internal error. Suberror: %d\n",
             run->internal.suberror);
 
-    if (kvm_check_extension(kvm_state, KVM_CAP_INTERNAL_ERROR_DATA)) {
+    if (kvm_check_extension(KVM_CAP_INTERNAL_ERROR_DATA)) {
         int i;
 
         for (i = 0; i < run->internal.ndata; ++i) {
@@ -2733,7 +2733,7 @@ int kvm_has_many_ioeventfds(void)
 int kvm_has_gsi_routing(void)
 {
 #ifdef KVM_CAP_IRQ_ROUTING
-    return kvm_check_extension(kvm_state, KVM_CAP_IRQ_ROUTING);
+    return kvm_check_extension(KVM_CAP_IRQ_ROUTING);
 #else
     return false;
 #endif
@@ -2746,7 +2746,7 @@ int kvm_has_intx_set_mask(void)
 
 bool kvm_arm_supports_user_irq(void)
 {
-    return kvm_check_extension(kvm_state, KVM_CAP_ARM_USER_IRQ);
+    return kvm_check_extension(KVM_CAP_ARM_USER_IRQ);
 }
 
 #ifdef KVM_CAP_SET_GUEST_DEBUG
@@ -3019,7 +3019,7 @@ int kvm_create_device(KVMState *s, uint64_t type, bool test)
     create_dev.fd = -1;
     create_dev.flags = test ? KVM_CREATE_DEVICE_TEST : 0;
 
-    if (!kvm_check_extension(s, KVM_CAP_DEVICE_CTRL)) {
+    if (!kvm_check_extension(KVM_CAP_DEVICE_CTRL)) {
         return -ENOTSUP;
     }
 
diff --git a/hw/hyperv/hyperv.c b/hw/hyperv/hyperv.c
index 844d00776d..92720efc3d 100644
--- a/hw/hyperv/hyperv.c
+++ b/hw/hyperv/hyperv.c
@@ -605,7 +605,7 @@ static bool process_event_flags_userspace;
 int hyperv_set_event_flag_handler(uint32_t conn_id, EventNotifier *notifier)
 {
     if (!process_event_flags_userspace &&
-        !kvm_check_extension(kvm_state, KVM_CAP_HYPERV_EVENTFD)) {
+        !kvm_check_extension(KVM_CAP_HYPERV_EVENTFD)) {
         process_event_flags_userspace = true;
 
         warn_report("Hyper-V event signaling is not supported by this kernel; "
diff --git a/hw/i386/kvm/clock.c b/hw/i386/kvm/clock.c
index 64283358f9..c0bfc69349 100644
--- a/hw/i386/kvm/clock.c
+++ b/hw/i386/kvm/clock.c
@@ -166,7 +166,7 @@ static void kvmclock_vm_state_change(void *opaque, int running,
 {
     KVMClockState *s = opaque;
     CPUState *cpu;
-    int cap_clock_ctrl = kvm_check_extension(kvm_state, KVM_CAP_KVMCLOCK_CTRL);
+    int cap_clock_ctrl = kvm_check_extension(KVM_CAP_KVMCLOCK_CTRL);
     int ret;
 
     if (running) {
diff --git a/hw/i386/kvm/i8254.c b/hw/i386/kvm/i8254.c
index 876f5aa6fa..90532df071 100644
--- a/hw/i386/kvm/i8254.c
+++ b/hw/i386/kvm/i8254.c
@@ -264,7 +264,7 @@ static void kvm_pit_realizefn(DeviceState *dev, Error **errp)
     };
     int ret;
 
-    if (kvm_check_extension(kvm_state, KVM_CAP_PIT2)) {
+    if (kvm_check_extension(KVM_CAP_PIT2)) {
         ret = kvm_vm_ioctl(kvm_state, KVM_CREATE_PIT2, &config);
     } else {
         ret = kvm_vm_ioctl(kvm_state, KVM_CREATE_PIT);
@@ -278,7 +278,7 @@ static void kvm_pit_realizefn(DeviceState *dev, Error **errp)
     case LOST_TICK_POLICY_DELAY:
         break; /* enabled by default */
     case LOST_TICK_POLICY_DISCARD:
-        if (kvm_check_extension(kvm_state, KVM_CAP_REINJECT_CONTROL)) {
+        if (kvm_check_extension(KVM_CAP_REINJECT_CONTROL)) {
             struct kvm_reinject_control control = { .pit_reinject = 0 };
 
             ret = kvm_vm_ioctl(kvm_state, KVM_REINJECT_CONTROL, &control);
diff --git a/hw/i386/kvm/ioapic.c b/hw/i386/kvm/ioapic.c
index 4ba8e47251..718ed8ec6f 100644
--- a/hw/i386/kvm/ioapic.c
+++ b/hw/i386/kvm/ioapic.c
@@ -25,7 +25,7 @@ void kvm_pc_setup_irq_routing(bool pci_enabled)
     KVMState *s = kvm_state;
     int i;
 
-    if (kvm_check_extension(s, KVM_CAP_IRQ_ROUTING)) {
+    if (kvm_check_extension(KVM_CAP_IRQ_ROUTING)) {
         for (i = 0; i < 8; ++i) {
             if (i == 2) {
                 continue;
diff --git a/hw/intc/arm_gic_kvm.c b/hw/intc/arm_gic_kvm.c
index d7df423a7a..b98437b265 100644
--- a/hw/intc/arm_gic_kvm.c
+++ b/hw/intc/arm_gic_kvm.c
@@ -551,7 +551,7 @@ static void kvm_arm_gic_realize(DeviceState *dev, Error **errp)
                               KVM_DEV_ARM_VGIC_CTRL_INIT, NULL, true,
                               &error_abort);
         }
-    } else if (kvm_check_extension(kvm_state, KVM_CAP_DEVICE_CTRL)) {
+    } else if (kvm_check_extension(KVM_CAP_DEVICE_CTRL)) {
         error_setg_errno(errp, -ret, "error creating in-kernel VGIC");
         error_append_hint(errp,
                           "Perhaps the host CPU does not support GICv2?\n");
diff --git a/hw/intc/openpic_kvm.c b/hw/intc/openpic_kvm.c
index e4bf47d885..b02e914f5f 100644
--- a/hw/intc/openpic_kvm.c
+++ b/hw/intc/openpic_kvm.c
@@ -203,7 +203,7 @@ static void kvm_openpic_realize(DeviceState *dev, Error **errp)
     struct kvm_create_device cd = {0};
     int ret, i;
 
-    if (!kvm_check_extension(s, KVM_CAP_DEVICE_CTRL)) {
+    if (!kvm_check_extension(KVM_CAP_DEVICE_CTRL)) {
         error_setg(errp, "Kernel is lacking Device Control API");
         return;
     }
diff --git a/hw/intc/xics_kvm.c b/hw/intc/xics_kvm.c
index 8d6156578f..054648d16b 100644
--- a/hw/intc/xics_kvm.c
+++ b/hw/intc/xics_kvm.c
@@ -365,7 +365,7 @@ int xics_kvm_connect(SpaprInterruptController *intc, uint32_t nr_servers,
         return 0;
     }
 
-    if (!kvm_enabled() || !kvm_check_extension(kvm_state, KVM_CAP_IRQ_XICS)) {
+    if (!kvm_enabled() || !kvm_check_extension(KVM_CAP_IRQ_XICS)) {
         error_setg(errp,
                    "KVM and IRQ_XICS capability must be present for in-kernel XICS");
         return -1;
diff --git a/hw/s390x/s390-stattrib-kvm.c b/hw/s390x/s390-stattrib-kvm.c
index f89d8d9d16..77f536f15a 100644
--- a/hw/s390x/s390-stattrib-kvm.c
+++ b/hw/s390x/s390-stattrib-kvm.c
@@ -22,7 +22,7 @@
 Object *kvm_s390_stattrib_create(void)
 {
     if (kvm_enabled() &&
-                kvm_check_extension(kvm_state, KVM_CAP_S390_CMMA_MIGRATION)) {
+                kvm_check_extension(KVM_CAP_S390_CMMA_MIGRATION)) {
         return object_new(TYPE_KVM_S390_STATTRIB);
     }
     return NULL;
diff --git a/target/arm/kvm.c b/target/arm/kvm.c
index 7c672c78b8..dcdd01916b 100644
--- a/target/arm/kvm.c
+++ b/target/arm/kvm.c
@@ -60,7 +60,7 @@ int kvm_arm_vcpu_finalize(CPUState *cs, int feature)
 
 void kvm_arm_init_serror_injection(CPUState *cs)
 {
-    cap_has_inject_serror_esr = kvm_check_extension(cs->kvm_state,
+    cap_has_inject_serror_esr = kvm_check_extension(
                                     KVM_CAP_ARM_INJECT_SERROR_ESR);
 }
 
@@ -210,15 +210,14 @@ void kvm_arm_add_vcpu_properties(Object *obj)
 
 bool kvm_arm_pmu_supported(void)
 {
-    return kvm_check_extension(kvm_state, KVM_CAP_ARM_PMU_V3);
+    return kvm_check_extension(KVM_CAP_ARM_PMU_V3);
 }
 
 int kvm_arm_get_max_vm_ipa_size(MachineState *ms)
 {
-    KVMState *s = KVM_STATE(ms->accelerator);
     int ret;
 
-    ret = kvm_check_extension(s, KVM_CAP_ARM_VM_IPA_SIZE);
+    ret = kvm_check_extension(KVM_CAP_ARM_VM_IPA_SIZE);
     return ret > 0 ? ret : 40;
 }
 
@@ -236,10 +235,10 @@ int kvm_arch_init(MachineState *ms, KVMState *s)
      */
     kvm_halt_in_kernel_allowed = true;
 
-    cap_has_mp_state = kvm_check_extension(s, KVM_CAP_MP_STATE);
+    cap_has_mp_state = kvm_check_extension(KVM_CAP_MP_STATE);
 
     if (ms->smp.cpus > 256 &&
-        !kvm_check_extension(s, KVM_CAP_ARM_IRQ_LINE_LAYOUT_2)) {
+        !kvm_check_extension(KVM_CAP_ARM_IRQ_LINE_LAYOUT_2)) {
         error_report("Using more than 256 vcpus requires a host kernel "
                      "with KVM_CAP_ARM_IRQ_LINE_LAYOUT_2");
         ret = -EINVAL;
@@ -870,7 +869,7 @@ int kvm_arch_irqchip_create(KVMState *s)
     /* If we can create the VGIC using the newer device control API, we
      * let the device do this when it initializes itself, otherwise we
      * fall back to the old API */
-    return kvm_check_extension(s, KVM_CAP_DEVICE_CTRL);
+    return kvm_check_extension(KVM_CAP_DEVICE_CTRL);
 }
 
 int kvm_arm_vgic_probe(void)
diff --git a/target/arm/kvm32.c b/target/arm/kvm32.c
index 7b3a19e9ae..eff0176c8f 100644
--- a/target/arm/kvm32.c
+++ b/target/arm/kvm32.c
@@ -221,7 +221,7 @@ int kvm_arch_init_vcpu(CPUState *cs)
     if (cpu->start_powered_off) {
         cpu->kvm_init_features[0] |= 1 << KVM_ARM_VCPU_POWER_OFF;
     }
-    if (kvm_check_extension(cs->kvm_state, KVM_CAP_ARM_PSCI_0_2)) {
+    if (kvm_check_extension(KVM_CAP_ARM_PSCI_0_2)) {
         cpu->psci_version = 2;
         cpu->kvm_init_features[0] |= 1 << KVM_ARM_VCPU_PSCI_0_2;
     }
diff --git a/target/arm/kvm64.c b/target/arm/kvm64.c
index 3dc494aaa7..49ef8ef15f 100644
--- a/target/arm/kvm64.c
+++ b/target/arm/kvm64.c
@@ -84,14 +84,13 @@ GArray *hw_breakpoints, *hw_watchpoints;
  */
 static void kvm_arm_init_debug(CPUState *cs)
 {
-    have_guest_debug = kvm_check_extension(cs->kvm_state,
-                                           KVM_CAP_SET_GUEST_DEBUG);
+    have_guest_debug = kvm_check_extension(KVM_CAP_SET_GUEST_DEBUG);
 
-    max_hw_wps = kvm_check_extension(cs->kvm_state, KVM_CAP_GUEST_DEBUG_HW_WPS);
+    max_hw_wps = kvm_check_extension(KVM_CAP_GUEST_DEBUG_HW_WPS);
     hw_watchpoints = g_array_sized_new(true, true,
                                        sizeof(HWWatchpoint), max_hw_wps);
 
-    max_hw_bps = kvm_check_extension(cs->kvm_state, KVM_CAP_GUEST_DEBUG_HW_BPS);
+    max_hw_bps = kvm_check_extension(KVM_CAP_GUEST_DEBUG_HW_BPS);
     hw_breakpoints = g_array_sized_new(true, true,
                                        sizeof(HWBreakpoint), max_hw_bps);
     return;
@@ -654,12 +653,12 @@ bool kvm_arm_get_host_cpu_features(ARMHostCPUFeatures *ahcf)
 
 bool kvm_arm_aarch32_supported(void)
 {
-    return kvm_check_extension(kvm_state, KVM_CAP_ARM_EL1_32BIT);
+    return kvm_check_extension(KVM_CAP_ARM_EL1_32BIT);
 }
 
 bool kvm_arm_sve_supported(void)
 {
-    return kvm_check_extension(kvm_state, KVM_CAP_ARM_SVE);
+    return kvm_check_extension(KVM_CAP_ARM_SVE);
 }
 
 QEMU_BUILD_BUG_ON(KVM_ARM64_SVE_VQ_MIN != 1);
@@ -778,14 +777,14 @@ int kvm_arch_init_vcpu(CPUState *cs)
     if (cpu->start_powered_off) {
         cpu->kvm_init_features[0] |= 1 << KVM_ARM_VCPU_POWER_OFF;
     }
-    if (kvm_check_extension(cs->kvm_state, KVM_CAP_ARM_PSCI_0_2)) {
+    if (kvm_check_extension(KVM_CAP_ARM_PSCI_0_2)) {
         cpu->psci_version = 2;
         cpu->kvm_init_features[0] |= 1 << KVM_ARM_VCPU_PSCI_0_2;
     }
     if (!arm_feature(&cpu->env, ARM_FEATURE_AARCH64)) {
         cpu->kvm_init_features[0] |= 1 << KVM_ARM_VCPU_EL1_32BIT;
     }
-    if (!kvm_check_extension(cs->kvm_state, KVM_CAP_ARM_PMU_V3)) {
+    if (!kvm_check_extension(KVM_CAP_ARM_PMU_V3)) {
         cpu->has_pmu = false;
     }
     if (cpu->has_pmu) {
diff --git a/target/i386/kvm.c b/target/i386/kvm.c
index b3c13cb898..03df6ac3b4 100644
--- a/target/i386/kvm.c
+++ b/target/i386/kvm.c
@@ -133,12 +133,12 @@ int kvm_has_pit_state2(void)
 
 bool kvm_has_smm(void)
 {
-    return kvm_check_extension(kvm_state, KVM_CAP_X86_SMM);
+    return kvm_check_extension(KVM_CAP_X86_SMM);
 }
 
 bool kvm_has_adjust_clock_stable(void)
 {
-    int ret = kvm_check_extension(kvm_state, KVM_CAP_ADJUST_CLOCK);
+    int ret = kvm_check_extension(KVM_CAP_ADJUST_CLOCK);
 
     return (ret == KVM_CLOCK_TSC_STABLE);
 }
@@ -294,7 +294,7 @@ static int get_para_features(KVMState *s)
     int i, features = 0;
 
     for (i = 0; i < ARRAY_SIZE(para_features); i++) {
-        if (kvm_check_extension(s, para_features[i].cap)) {
+        if (kvm_check_extension(para_features[i].cap)) {
             features |= (1 << para_features[i].feature);
         }
     }
@@ -386,7 +386,7 @@ uint32_t kvm_arch_get_supported_cpuid(KVMState *s, uint32_t function,
          * and the irqchip is in the kernel.
          */
         if (kvm_irqchip_in_kernel() &&
-                kvm_check_extension(s, KVM_CAP_TSC_DEADLINE_TIMER)) {
+                kvm_check_extension(KVM_CAP_TSC_DEADLINE_TIMER)) {
             ret |= CPUID_EXT_TSC_DEADLINE_TIMER;
         }
 
@@ -398,8 +398,7 @@ uint32_t kvm_arch_get_supported_cpuid(KVMState *s, uint32_t function,
         }
 
         if (enable_cpu_pm) {
-            int disable_exits = kvm_check_extension(s,
-                                                    KVM_CAP_X86_DISABLE_EXITS);
+            int disable_exits = kvm_check_extension(KVM_CAP_X86_DISABLE_EXITS);
 
             if (disable_exits & KVM_X86_DISABLE_EXITS_MWAIT) {
                 ret |= CPUID_EXT_MONITOR;
@@ -542,7 +541,7 @@ static int kvm_get_mce_cap_supported(KVMState *s, uint64_t *mce_cap,
 {
     int r;
 
-    r = kvm_check_extension(s, KVM_CAP_MCE);
+    r = kvm_check_extension(KVM_CAP_MCE);
     if (r > 0) {
         *max_banks = r;
         return kvm_ioctl(s, KVM_X86_GET_MCE_CAP_SUPPORTED, mce_cap);
@@ -734,8 +733,7 @@ unsigned long kvm_arch_vcpu_id(CPUState *cs)
 
 static bool hyperv_enabled(X86CPU *cpu)
 {
-    CPUState *cs = CPU(cpu);
-    return kvm_check_extension(cs->kvm_state, KVM_CAP_HYPERV) > 0 &&
+    return kvm_check_extension(KVM_CAP_HYPERV) > 0 &&
         ((cpu->hyperv_spinlock_attempts != HYPERV_SPINLOCK_NEVER_RETRY) ||
          cpu->hyperv_features || cpu->hyperv_passthrough);
 }
@@ -750,14 +748,14 @@ static int kvm_arch_set_tsc_khz(CPUState *cs)
         return 0;
     }
 
-    r = kvm_check_extension(cs->kvm_state, KVM_CAP_TSC_CONTROL) ?
+    r = kvm_check_extension(KVM_CAP_TSC_CONTROL) ?
         kvm_vcpu_ioctl(cs, KVM_SET_TSC_KHZ, env->tsc_khz) :
         -ENOTSUP;
     if (r < 0) {
         /* When KVM_SET_TSC_KHZ fails, it's an error only if the current
          * TSC frequency doesn't match the one we want.
          */
-        int cur_freq = kvm_check_extension(cs->kvm_state, KVM_CAP_GET_TSC_KHZ) ?
+        int cur_freq = kvm_check_extension(KVM_CAP_GET_TSC_KHZ) ?
                        kvm_vcpu_ioctl(cs, KVM_GET_TSC_KHZ) :
                        -ENOTSUP;
         if (cur_freq <= 0 || cur_freq != env->tsc_khz) {
@@ -978,7 +976,7 @@ static struct kvm_cpuid2 *get_supported_hv_cpuid_legacy(CPUState *cs)
     entry_recomm->function = HV_CPUID_ENLIGHTMENT_INFO;
     entry_recomm->ebx = cpu->hyperv_spinlock_attempts;
 
-    if (kvm_check_extension(cs->kvm_state, KVM_CAP_HYPERV) > 0) {
+    if (kvm_check_extension(KVM_CAP_HYPERV) > 0) {
         entry_feat->eax |= HV_HYPERCALL_AVAILABLE;
         entry_feat->eax |= HV_APIC_ACCESS_AVAILABLE;
         entry_feat->edx |= HV_CPU_DYNAMIC_PARTITIONING_AVAILABLE;
@@ -986,7 +984,7 @@ static struct kvm_cpuid2 *get_supported_hv_cpuid_legacy(CPUState *cs)
         entry_recomm->eax |= HV_APIC_ACCESS_RECOMMENDED;
     }
 
-    if (kvm_check_extension(cs->kvm_state, KVM_CAP_HYPERV_TIME) > 0) {
+    if (kvm_check_extension(KVM_CAP_HYPERV_TIME) > 0) {
         entry_feat->eax |= HV_TIME_REF_COUNT_AVAILABLE;
         entry_feat->eax |= HV_REFERENCE_TSC_AVAILABLE;
     }
@@ -1020,7 +1018,7 @@ static struct kvm_cpuid2 *get_supported_hv_cpuid_legacy(CPUState *cs)
         unsigned int cap = cpu->hyperv_synic_kvm_only ?
             KVM_CAP_HYPERV_SYNIC : KVM_CAP_HYPERV_SYNIC2;
 
-        if (kvm_check_extension(cs->kvm_state, cap) > 0) {
+        if (kvm_check_extension(cap) > 0) {
             entry_feat->eax |= HV_SYNIC_AVAILABLE;
         }
     }
@@ -1029,19 +1027,16 @@ static struct kvm_cpuid2 *get_supported_hv_cpuid_legacy(CPUState *cs)
         entry_feat->eax |= HV_SYNTIMERS_AVAILABLE;
     }
 
-    if (kvm_check_extension(cs->kvm_state,
-                            KVM_CAP_HYPERV_TLBFLUSH) > 0) {
+    if (kvm_check_extension(KVM_CAP_HYPERV_TLBFLUSH) > 0) {
         entry_recomm->eax |= HV_REMOTE_TLB_FLUSH_RECOMMENDED;
         entry_recomm->eax |= HV_EX_PROCESSOR_MASKS_RECOMMENDED;
     }
 
-    if (kvm_check_extension(cs->kvm_state,
-                            KVM_CAP_HYPERV_ENLIGHTENED_VMCS) > 0) {
+    if (kvm_check_extension(KVM_CAP_HYPERV_ENLIGHTENED_VMCS) > 0) {
         entry_recomm->eax |= HV_ENLIGHTENED_VMCS_RECOMMENDED;
     }
 
-    if (kvm_check_extension(cs->kvm_state,
-                            KVM_CAP_HYPERV_SEND_IPI) > 0) {
+    if (kvm_check_extension(KVM_CAP_HYPERV_SEND_IPI) > 0) {
         entry_recomm->eax |= HV_CLUSTER_IPI_RECOMMENDED;
         entry_recomm->eax |= HV_EX_PROCESSOR_MASKS_RECOMMENDED;
     }
@@ -1185,7 +1180,7 @@ static int hyperv_handle_properties(CPUState *cs,
         }
     }
 
-    if (kvm_check_extension(cs->kvm_state, KVM_CAP_HYPERV_CPUID) > 0) {
+    if (kvm_check_extension(KVM_CAP_HYPERV_CPUID) > 0) {
         cpuid = get_supported_hv_cpuid(cs);
     } else {
         cpuid = get_supported_hv_cpuid_legacy(cs);
@@ -1466,7 +1461,7 @@ int kvm_arch_init_vcpu(CPUState *cs)
      * so that vcpu's TSC frequency can be migrated later via this field.
      */
     if (!env->tsc_khz) {
-        r = kvm_check_extension(cs->kvm_state, KVM_CAP_GET_TSC_KHZ) ?
+        r = kvm_check_extension(KVM_CAP_GET_TSC_KHZ) ?
             kvm_vcpu_ioctl(cs, KVM_GET_TSC_KHZ) :
             -ENOTSUP;
         if (r > 0) {
@@ -1707,7 +1702,7 @@ int kvm_arch_init_vcpu(CPUState *cs)
     if (((env->cpuid_version >> 8)&0xF) >= 6
         && (env->features[FEAT_1_EDX] & (CPUID_MCE | CPUID_MCA)) ==
            (CPUID_MCE | CPUID_MCA)
-        && kvm_check_extension(cs->kvm_state, KVM_CAP_MCE) > 0) {
+        && kvm_check_extension(KVM_CAP_MCE) > 0) {
         uint64_t mcg_cap, unsupported_caps;
         int banks;
         int ret;
@@ -1900,7 +1895,7 @@ static int kvm_get_supported_feature_msrs(KVMState *s)
         return 0;
     }
 
-    if (!kvm_check_extension(s, KVM_CAP_GET_MSR_FEATURES)) {
+    if (!kvm_check_extension(KVM_CAP_GET_MSR_FEATURES)) {
         return 0;
     }
 
@@ -2096,13 +2091,13 @@ int kvm_arch_init(MachineState *ms, KVMState *s)
     int ret;
     struct utsname utsname;
 
-    has_xsave = kvm_check_extension(s, KVM_CAP_XSAVE);
-    has_xcrs = kvm_check_extension(s, KVM_CAP_XCRS);
-    has_pit_state2 = kvm_check_extension(s, KVM_CAP_PIT_STATE2);
+    has_xsave = kvm_check_extension(KVM_CAP_XSAVE);
+    has_xcrs = kvm_check_extension(KVM_CAP_XCRS);
+    has_pit_state2 = kvm_check_extension(KVM_CAP_PIT_STATE2);
 
-    hv_vpindex_settable = kvm_check_extension(s, KVM_CAP_HYPERV_VP_INDEX);
+    hv_vpindex_settable = kvm_check_extension(KVM_CAP_HYPERV_VP_INDEX);
 
-    has_exception_payload = kvm_check_extension(s, KVM_CAP_EXCEPTION_PAYLOAD);
+    has_exception_payload = kvm_check_extension(KVM_CAP_EXCEPTION_PAYLOAD);
     if (has_exception_payload) {
         ret = kvm_vm_enable_cap(s, KVM_CAP_EXCEPTION_PAYLOAD, 0, true);
         if (ret < 0) {
@@ -2133,7 +2128,7 @@ int kvm_arch_init(MachineState *ms, KVMState *s)
      * that case we need to stick with the default, i.e. a 256K maximum BIOS
      * size.
      */
-    if (kvm_check_extension(s, KVM_CAP_SET_IDENTITY_MAP_ADDR)) {
+    if (kvm_check_extension(KVM_CAP_SET_IDENTITY_MAP_ADDR)) {
         /* Allows up to 16M BIOSes. */
         identity_base = 0xfeffc000;
 
@@ -2165,7 +2160,7 @@ int kvm_arch_init(MachineState *ms, KVMState *s)
         }
     }
 
-    if (kvm_check_extension(s, KVM_CAP_X86_SMM) &&
+    if (kvm_check_extension(KVM_CAP_X86_SMM) &&
         object_dynamic_cast(OBJECT(ms), TYPE_X86_MACHINE) &&
         x86_machine_is_smm_enabled(X86_MACHINE(ms))) {
         smram_machine_done.notify = register_smram_listener;
@@ -2173,7 +2168,7 @@ int kvm_arch_init(MachineState *ms, KVMState *s)
     }
 
     if (enable_cpu_pm) {
-        int disable_exits = kvm_check_extension(s, KVM_CAP_X86_DISABLE_EXITS);
+        int disable_exits = kvm_check_extension(KVM_CAP_X86_DISABLE_EXITS);
         int ret;
 
 /* Work around for kernel header with a typo. TODO: fix header and drop. */
@@ -4490,7 +4485,7 @@ bool kvm_arch_stop_on_emulation_error(CPUState *cs)
 
 void kvm_arch_init_irq_routing(KVMState *s)
 {
-    if (!kvm_check_extension(s, KVM_CAP_IRQ_ROUTING)) {
+    if (!kvm_check_extension(KVM_CAP_IRQ_ROUTING)) {
         /* If kernel can't do irq routing, interrupt source
          * override 0->2 cannot be set up as required by HPET.
          * So we have to disable it.
diff --git a/target/mips/kvm.c b/target/mips/kvm.c
index 96cfa10cf2..0adfa70210 100644
--- a/target/mips/kvm.c
+++ b/target/mips/kvm.c
@@ -50,8 +50,8 @@ int kvm_arch_init(MachineState *ms, KVMState *s)
     /* MIPS has 128 signals */
     kvm_set_sigmask_len(s, 16);
 
-    kvm_mips_fpu_cap = kvm_check_extension(s, KVM_CAP_MIPS_FPU);
-    kvm_mips_msa_cap = kvm_check_extension(s, KVM_CAP_MIPS_MSA);
+    kvm_mips_fpu_cap = kvm_check_extension(KVM_CAP_MIPS_FPU);
+    kvm_mips_msa_cap = kvm_check_extension(KVM_CAP_MIPS_MSA);
 
     DPRINTF("%s\n", __func__);
     return 0;
diff --git a/target/ppc/kvm.c b/target/ppc/kvm.c
index 2692f76130..ace44d9fc7 100644
--- a/target/ppc/kvm.c
+++ b/target/ppc/kvm.c
@@ -110,24 +110,24 @@ static int kvmppc_get_dec_bits(void);
 
 int kvm_arch_init(MachineState *ms, KVMState *s)
 {
-    cap_interrupt_unset = kvm_check_extension(s, KVM_CAP_PPC_UNSET_IRQ);
-    cap_segstate = kvm_check_extension(s, KVM_CAP_PPC_SEGSTATE);
-    cap_booke_sregs = kvm_check_extension(s, KVM_CAP_PPC_BOOKE_SREGS);
+    cap_interrupt_unset = kvm_check_extension(KVM_CAP_PPC_UNSET_IRQ);
+    cap_segstate = kvm_check_extension(KVM_CAP_PPC_SEGSTATE);
+    cap_booke_sregs = kvm_check_extension(KVM_CAP_PPC_BOOKE_SREGS);
     cap_ppc_smt_possible = kvm_vm_check_extension(s, KVM_CAP_PPC_SMT_POSSIBLE);
-    cap_spapr_tce = kvm_check_extension(s, KVM_CAP_SPAPR_TCE);
-    cap_spapr_tce_64 = kvm_check_extension(s, KVM_CAP_SPAPR_TCE_64);
-    cap_spapr_multitce = kvm_check_extension(s, KVM_CAP_SPAPR_MULTITCE);
+    cap_spapr_tce = kvm_check_extension(KVM_CAP_SPAPR_TCE);
+    cap_spapr_tce_64 = kvm_check_extension(KVM_CAP_SPAPR_TCE_64);
+    cap_spapr_multitce = kvm_check_extension(KVM_CAP_SPAPR_MULTITCE);
     cap_spapr_vfio = kvm_vm_check_extension(s, KVM_CAP_SPAPR_TCE_VFIO);
-    cap_one_reg = kvm_check_extension(s, KVM_CAP_ONE_REG);
-    cap_hior = kvm_check_extension(s, KVM_CAP_PPC_HIOR);
-    cap_epr = kvm_check_extension(s, KVM_CAP_PPC_EPR);
-    cap_ppc_watchdog = kvm_check_extension(s, KVM_CAP_PPC_BOOKE_WATCHDOG);
+    cap_one_reg = kvm_check_extension(KVM_CAP_ONE_REG);
+    cap_hior = kvm_check_extension(KVM_CAP_PPC_HIOR);
+    cap_epr = kvm_check_extension(KVM_CAP_PPC_EPR);
+    cap_ppc_watchdog = kvm_check_extension(KVM_CAP_PPC_BOOKE_WATCHDOG);
     /*
      * Note: we don't set cap_papr here, because this capability is
      * only activated after this by kvmppc_set_papr()
      */
     cap_htab_fd = kvm_vm_check_extension(s, KVM_CAP_PPC_HTAB_FD);
-    cap_fixup_hcalls = kvm_check_extension(s, KVM_CAP_PPC_FIXUP_HCALL);
+    cap_fixup_hcalls = kvm_check_extension(KVM_CAP_PPC_FIXUP_HCALL);
     cap_ppc_smt = kvm_vm_check_extension(s, KVM_CAP_PPC_SMT);
     cap_htm = kvm_vm_check_extension(s, KVM_CAP_PPC_HTM);
     cap_mmu_radix = kvm_vm_check_extension(s, KVM_CAP_PPC_MMU_RADIX);
@@ -147,7 +147,7 @@ int kvm_arch_init(MachineState *ms, KVMState *s)
      */
     cap_ppc_pvr_compat = false;
 
-    if (!kvm_check_extension(s, KVM_CAP_PPC_IRQ_LEVEL)) {
+    if (!kvm_check_extension(KVM_CAP_PPC_IRQ_LEVEL)) {
         error_report("KVM: Host kernel doesn't have level irq capability");
         exit(1);
     }
@@ -205,7 +205,7 @@ static int kvm_booke206_tlb_init(PowerPCCPU *cpu)
     int ret, i;
 
     if (!kvm_enabled() ||
-        !kvm_check_extension(cs->kvm_state, KVM_CAP_SW_TLB)) {
+        !kvm_check_extension(KVM_CAP_SW_TLB)) {
         return 0;
     }
 
@@ -246,7 +246,7 @@ static void kvm_get_smmu_info(struct kvm_ppc_smmu_info *info, Error **errp)
 
     assert(kvm_state != NULL);
 
-    if (!kvm_check_extension(kvm_state, KVM_CAP_PPC_GET_SMMU_INFO)) {
+    if (!kvm_check_extension(KVM_CAP_PPC_GET_SMMU_INFO)) {
         error_setg(errp, "KVM doesn't expose the MMU features it supports");
         error_append_hint(errp, "Consider switching to a newer KVM\n");
         return;
@@ -268,7 +268,7 @@ struct ppc_radix_page_info *kvm_get_radix_page_info(void)
     struct kvm_ppc_rmmu_info rmmu_info;
     int i;
 
-    if (!kvm_check_extension(s, KVM_CAP_PPC_MMU_RADIX)) {
+    if (!kvm_check_extension(KVM_CAP_PPC_MMU_RADIX)) {
         return NULL;
     }
     if (kvm_vm_ioctl(s, KVM_PPC_GET_RMMU_INFO, &rmmu_info)) {
@@ -2611,7 +2611,7 @@ int kvmppc_define_rtas_kernel_token(uint32_t token, const char *function)
         .token = token,
     };
 
-    if (!kvm_check_extension(kvm_state, KVM_CAP_PPC_RTAS)) {
+    if (!kvm_check_extension(KVM_CAP_PPC_RTAS)) {
         return -ENOENT;
     }
 
@@ -2828,7 +2828,7 @@ int kvm_handle_nmi(PowerPCCPU *cpu, struct kvm_run *run)
 
 int kvmppc_enable_hwrng(void)
 {
-    if (!kvm_enabled() || !kvm_check_extension(kvm_state, KVM_CAP_PPC_HWRNG)) {
+    if (!kvm_enabled() || !kvm_check_extension(KVM_CAP_PPC_HWRNG)) {
         return -1;
     }
 
diff --git a/target/s390x/cpu_models.c b/target/s390x/cpu_models.c
index 2fa609bffe..4b6185bb44 100644
--- a/target/s390x/cpu_models.c
+++ b/target/s390x/cpu_models.c
@@ -222,8 +222,7 @@ bool s390_has_feat(S390Feat feat)
 #ifdef CONFIG_KVM
         if (kvm_enabled()) {
             if (feat == S390_FEAT_VECTOR) {
-                return kvm_check_extension(kvm_state,
-                                           KVM_CAP_S390_VECTOR_REGISTERS);
+                return kvm_check_extension(KVM_CAP_S390_VECTOR_REGISTERS);
             }
             if (feat == S390_FEAT_RUNTIME_INSTRUMENTATION) {
                 return kvm_s390_get_ri();
diff --git a/target/s390x/kvm.c b/target/s390x/kvm.c
index f2f75d2a57..710f353fb0 100644
--- a/target/s390x/kvm.c
+++ b/target/s390x/kvm.c
@@ -342,21 +342,21 @@ int kvm_arch_init(MachineState *ms, KVMState *s)
     object_class_foreach(ccw_machine_class_foreach, TYPE_S390_CCW_MACHINE,
                          false, NULL);
 
-    if (!kvm_check_extension(kvm_state, KVM_CAP_DEVICE_CTRL)) {
+    if (!kvm_check_extension(KVM_CAP_DEVICE_CTRL)) {
         error_report("KVM is missing capability KVM_CAP_DEVICE_CTRL - "
                      "please use kernel 3.15 or newer");
         return -1;
     }
 
-    cap_sync_regs = kvm_check_extension(s, KVM_CAP_SYNC_REGS);
-    cap_async_pf = kvm_check_extension(s, KVM_CAP_ASYNC_PF);
-    cap_mem_op = kvm_check_extension(s, KVM_CAP_S390_MEM_OP);
-    cap_s390_irq = kvm_check_extension(s, KVM_CAP_S390_INJECT_IRQ);
-    cap_vcpu_resets = kvm_check_extension(s, KVM_CAP_S390_VCPU_RESETS);
-    cap_protected = kvm_check_extension(s, KVM_CAP_S390_PROTECTED);
+    cap_sync_regs = kvm_check_extension(KVM_CAP_SYNC_REGS);
+    cap_async_pf = kvm_check_extension(KVM_CAP_ASYNC_PF);
+    cap_mem_op = kvm_check_extension(KVM_CAP_S390_MEM_OP);
+    cap_s390_irq = kvm_check_extension(KVM_CAP_S390_INJECT_IRQ);
+    cap_vcpu_resets = kvm_check_extension(KVM_CAP_S390_VCPU_RESETS);
+    cap_protected = kvm_check_extension(KVM_CAP_S390_PROTECTED);
 
-    if (!kvm_check_extension(s, KVM_CAP_S390_GMAP)
-        || !kvm_check_extension(s, KVM_CAP_S390_COW)) {
+    if (!kvm_check_extension(KVM_CAP_S390_GMAP)
+        || !kvm_check_extension(KVM_CAP_S390_COW)) {
         phys_mem_set_alloc(legacy_s390_alloc);
     }
 
@@ -381,7 +381,7 @@ int kvm_arch_init(MachineState *ms, KVMState *s)
      * newer machine types if KVM_CAP_S390_AIS_MIGRATION is available.
      */
     if (cpu_model_allowed() && kvm_kernel_irqchip_allowed() &&
-        kvm_check_extension(s, KVM_CAP_S390_AIS_MIGRATION)) {
+        kvm_check_extension(KVM_CAP_S390_AIS_MIGRATION)) {
         kvm_vm_enable_cap(s, KVM_CAP_S390_AIS, 0);
     }
 
@@ -1996,7 +1996,7 @@ void kvm_arch_init_irq_routing(KVMState *s)
      * are handled in-kernel, it is not true for s390 (yet); therefore, we
      * have to override the common code kvm_halt_in_kernel_allowed setting.
      */
-    if (kvm_check_extension(s, KVM_CAP_IRQ_ROUTING)) {
+    if (kvm_check_extension(KVM_CAP_IRQ_ROUTING)) {
         kvm_gsi_routing_allowed = true;
         kvm_halt_in_kernel_allowed = false;
     }
@@ -2015,7 +2015,7 @@ int kvm_s390_assign_subch_ioeventfd(EventNotifier *notifier, uint32_t sch,
     };
     trace_kvm_assign_subch_ioeventfd(kick.fd, kick.addr, assign,
                                      kick.datamatch);
-    if (!kvm_check_extension(kvm_state, KVM_CAP_IOEVENTFD)) {
+    if (!kvm_check_extension(KVM_CAP_IOEVENTFD)) {
         return -ENOSYS;
     }
     if (!assign) {
@@ -2082,7 +2082,7 @@ void kvm_s390_vcpu_interrupt_pre_save(S390CPU *cpu)
     CPUState *cs = CPU(cpu);
     int32_t bytes;
 
-    if (!kvm_check_extension(kvm_state, KVM_CAP_S390_IRQ_STATE)) {
+    if (!kvm_check_extension(KVM_CAP_S390_IRQ_STATE)) {
         return;
     }
 
@@ -2109,7 +2109,7 @@ int kvm_s390_vcpu_interrupt_post_load(S390CPU *cpu)
         return 0;
     }
 
-    if (!kvm_check_extension(kvm_state, KVM_CAP_S390_IRQ_STATE)) {
+    if (!kvm_check_extension(KVM_CAP_S390_IRQ_STATE)) {
         return -ENOSYS;
     }
 
@@ -2421,7 +2421,7 @@ void kvm_s390_get_host_cpu_model(S390CPUModel *model, Error **errp)
     }
 
     /* bpb needs kernel support for migration, VSIE and reset */
-    if (!kvm_check_extension(kvm_state, KVM_CAP_S390_BPB)) {
+    if (!kvm_check_extension(KVM_CAP_S390_BPB)) {
         clear_bit(S390_FEAT_BPB, model->features);
     }
 
-- 
2.21.3

