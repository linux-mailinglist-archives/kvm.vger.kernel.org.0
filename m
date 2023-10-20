Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95CD77D1436
	for <lists+kvm@lfdr.de>; Fri, 20 Oct 2023 18:39:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377837AbjJTQjS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Oct 2023 12:39:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229776AbjJTQjR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Oct 2023 12:39:17 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24922D57
        for <kvm@vger.kernel.org>; Fri, 20 Oct 2023 09:39:12 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id a640c23a62f3a-9ba081173a3so170701666b.1
        for <kvm@vger.kernel.org>; Fri, 20 Oct 2023 09:39:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1697819950; x=1698424750; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yOZrNX/+z7aB8oqqC+6GO7cwysfniQeher82irVu/7U=;
        b=M1DaoUAkwd2SpQcnDqi/WyLSS0ML9kPBrftlNt2lvZcf2dgTnL+siCBLo1Mlft+XYQ
         gSc3DGBwRmTbqiovhubaSP1/aj6jfLju919El4Z0k/KE8qkf/QRbvGkcxX0pP7L0ZbR6
         0Xv8vc8gII0Bxty2ZjQiocw+eunjbFBWS3U8NSATuHv17lbRTl+3mjo3CSikicMptyNC
         3nHw6xnNF7BcgXo/WB6DFyWgoxCbBC+W23kinvQgtnTJz9fB1CGjrxzHUkcFUNXYrRTw
         z7ykXgAmu8NCR08HdHracseoVo5D0vOqnkb9+/B20exg3EcPyIjezxARdLCDNYNRdHAl
         /QvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697819950; x=1698424750;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yOZrNX/+z7aB8oqqC+6GO7cwysfniQeher82irVu/7U=;
        b=WD6bR8FtzQ9+ozmIcUq/SXcv2Me5ypY6Y2oSE7PZwa9B4dyEviFpQFJhIDfXL53GU0
         RVaNX1aK6+Zjsmf0+JaxJnhSzdgyN/GIPeLXMNMjZBjFCMnomH9xsSs9mZgsclZ9nQ7b
         uNU9aF1N1y3r24zCZvEwlAO35gFKTYsryn8dMrSXzRFwNaBaCo2jAQMoWfLzCdgFyfsl
         TseEkKxBDp/Vss5JiAAkKgj983a0p+9ujCkbR4/jAZRdXAQmPFw0m4vNwNl1D+1lPumk
         eVQyeyXwFSlRh0q/cTnKo40033xYHy4j+GzA/B5zI4VEu5L40oNhbJ/fdd153OxDa459
         0rKA==
X-Gm-Message-State: AOJu0YxC8xCZnXPHF9MKnyzY3PNVs3n7mM3znMcHfuOm9X1/P9RgFRiu
        lgByq52JIgigW8Dqh08Nks0ylA==
X-Google-Smtp-Source: AGHT+IGsgNGfCT5XpM2lTQY8HMLu12TWjzLu8IMAwyY25dXL0k0/QS5mYRTmqOEG0tkPfFgRkGRxOw==
X-Received: by 2002:a17:907:7b9f:b0:9ae:5f51:2e4a with SMTP id ne31-20020a1709077b9f00b009ae5f512e4amr2165318ejc.36.1697819950597;
        Fri, 20 Oct 2023 09:39:10 -0700 (PDT)
Received: from m1x-phil.lan (tbo33-h01-176-171-212-97.dsl.sta.abo.bbox.fr. [176.171.212.97])
        by smtp.gmail.com with ESMTPSA id do6-20020a170906c10600b009ad7fc17b2asm1806575ejc.224.2023.10.20.09.39.08
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 20 Oct 2023 09:39:10 -0700 (PDT)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To:     qemu-devel@nongnu.org
Cc:     Thomas Huth <thuth@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Alistair Francis <alistair.francis@wdc.com>,
        qemu-arm@nongnu.org, qemu-riscv@nongnu.org,
        "Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
        qemu-ppc@nongnu.org, Eduardo Habkost <eduardo@habkost.net>,
        "Michael S. Tsirkin" <mst@redhat.com>, qemu-s390x@nongnu.org,
        Peter Maydell <peter.maydell@linaro.org>,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        Zhao Liu <zhao1.liu@intel.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Sergio Lopez <slp@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org
Subject: [PATCH 19/19] cpus: Replace first_cpu by qemu_get_cpu(0, TYPE_X86_CPU)
Date:   Fri, 20 Oct 2023 18:36:41 +0200
Message-ID: <20231020163643.86105-20-philmd@linaro.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20231020163643.86105-1-philmd@linaro.org>
References: <20231020163643.86105-1-philmd@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Mechanical change using the following coccinelle script:

  @@ @@
  -   first_cpu
  +   qemu_get_cpu(0, TYPE_X86_CPU)

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 hw/i386/kvm/clock.c                 | 4 ++--
 hw/i386/kvmvapic.c                  | 3 ++-
 hw/i386/microvm.c                   | 2 +-
 hw/i386/pc.c                        | 7 ++++---
 hw/i386/pc_piix.c                   | 3 ++-
 hw/i386/x86.c                       | 2 +-
 hw/isa/lpc_ich9.c                   | 2 +-
 target/i386/arch_dump.c             | 6 +++---
 target/i386/kvm/kvm.c               | 6 +++---
 target/i386/tcg/sysemu/fpu_helper.c | 4 ++--
 10 files changed, 21 insertions(+), 18 deletions(-)

diff --git a/hw/i386/kvm/clock.c b/hw/i386/kvm/clock.c
index f25977d3f6..00067adde3 100644
--- a/hw/i386/kvm/clock.c
+++ b/hw/i386/kvm/clock.c
@@ -65,7 +65,7 @@ struct pvclock_vcpu_time_info {
 
 static uint64_t kvmclock_current_nsec(KVMClockState *s)
 {
-    CPUState *cpu = first_cpu;
+    CPUState *cpu = qemu_get_cpu(0, TYPE_X86_CPU);
     CPUX86State *env = cpu_env(cpu);
     hwaddr kvmclock_struct_pa;
     uint64_t migration_tsc = env->tsc;
@@ -330,7 +330,7 @@ static const TypeInfo kvmclock_info = {
 /* Note: Must be called after VCPU initialization. */
 void kvmclock_create(bool create_always)
 {
-    X86CPU *cpu = X86_CPU(first_cpu);
+    X86CPU *cpu = X86_CPU(qemu_get_cpu(0, TYPE_X86_CPU));
 
     assert(kvm_enabled());
     if (!kvm_has_adjust_clock()) {
diff --git a/hw/i386/kvmvapic.c b/hw/i386/kvmvapic.c
index 43f8a8f679..e10c2bfc5a 100644
--- a/hw/i386/kvmvapic.c
+++ b/hw/i386/kvmvapic.c
@@ -760,7 +760,8 @@ static void kvmvapic_vm_state_change(void *opaque, bool running,
 
     if (s->state == VAPIC_ACTIVE) {
         if (ms->smp.cpus == 1) {
-            run_on_cpu(first_cpu, do_vapic_enable, RUN_ON_CPU_HOST_PTR(s));
+            run_on_cpu(qemu_get_cpu(0, TYPE_X86_CPU), do_vapic_enable,
+                       RUN_ON_CPU_HOST_PTR(s));
         } else {
             zero = g_malloc0(s->rom_state.vapic_size);
             cpu_physical_memory_write(s->vapic_paddr, zero,
diff --git a/hw/i386/microvm.c b/hw/i386/microvm.c
index b9c93039e2..d043f71992 100644
--- a/hw/i386/microvm.c
+++ b/hw/i386/microvm.c
@@ -229,7 +229,7 @@ static void microvm_devices_init(MicrovmMachineState *mms)
 
     if (x86_machine_is_acpi_enabled(x86ms) && mms->pcie == ON_OFF_AUTO_ON) {
         /* use topmost 25% of the address space available */
-        hwaddr phys_size = (hwaddr)1 << X86_CPU(first_cpu)->phys_bits;
+        hwaddr phys_size = (hwaddr)1 << X86_CPU(qemu_get_cpu(0, TYPE_X86_CPU))->phys_bits;
         if (phys_size > 0x1000000ll) {
             mms->gpex.mmio64.size = phys_size / 4;
             mms->gpex.mmio64.base = phys_size - mms->gpex.mmio64.size;
diff --git a/hw/i386/pc.c b/hw/i386/pc.c
index bb3854d1d0..7f10078096 100644
--- a/hw/i386/pc.c
+++ b/hw/i386/pc.c
@@ -813,7 +813,7 @@ static uint64_t pc_get_cxl_range_end(PCMachineState *pcms)
 
 static hwaddr pc_max_used_gpa(PCMachineState *pcms, uint64_t pci_hole64_size)
 {
-    X86CPU *cpu = X86_CPU(first_cpu);
+    X86CPU *cpu = X86_CPU(qemu_get_cpu(0, TYPE_X86_CPU));
     PCMachineClass *pcmc = PC_MACHINE_GET_CLASS(pcms);
     MachineState *ms = MACHINE(pcms);
 
@@ -898,7 +898,7 @@ void pc_memory_init(PCMachineState *pcms,
     X86MachineState *x86ms = X86_MACHINE(pcms);
     hwaddr maxphysaddr, maxusedaddr;
     hwaddr cxl_base, cxl_resv_end = 0;
-    X86CPU *cpu = X86_CPU(first_cpu);
+    X86CPU *cpu = X86_CPU(qemu_get_cpu(0, TYPE_X86_CPU));
 
     assert(machine->ram_size == x86ms->below_4g_mem_size +
                                 x86ms->above_4g_mem_size);
@@ -1182,7 +1182,8 @@ static void pc_superio_init(ISABus *isa_bus, bool create_fdctrl,
     }
     port92 = isa_create_simple(isa_bus, TYPE_PORT92);
 
-    a20_line = qemu_allocate_irqs(handle_a20_line_change, first_cpu, 2);
+    a20_line = qemu_allocate_irqs(handle_a20_line_change,
+                                  qemu_get_cpu(0, TYPE_X86_CPU), 2);
     i8042_setup_a20_line(i8042, a20_line[0]);
     qdev_connect_gpio_out_named(DEVICE(port92),
                                 PORT92_A20_LINE, 0, a20_line[1]);
diff --git a/hw/i386/pc_piix.c b/hw/i386/pc_piix.c
index e36a3262b2..1e0c2bb2e3 100644
--- a/hw/i386/pc_piix.c
+++ b/hw/i386/pc_piix.c
@@ -363,7 +363,8 @@ static void pc_init1(MachineState *machine,
     if (pcmc->pci_enabled && x86_machine_is_acpi_enabled(X86_MACHINE(pcms))) {
         PCIDevice *piix4_pm;
 
-        smi_irq = qemu_allocate_irq(pc_acpi_smi_interrupt, first_cpu, 0);
+        smi_irq = qemu_allocate_irq(pc_acpi_smi_interrupt,
+                                    qemu_get_cpu(0, TYPE_X86_CPU), 0);
         piix4_pm = pci_new(piix3_devfn + 3, TYPE_PIIX4_PM);
         qdev_prop_set_uint32(DEVICE(piix4_pm), "smb_io_base", 0xb100);
         qdev_prop_set_bit(DEVICE(piix4_pm), "smm-enabled",
diff --git a/hw/i386/x86.c b/hw/i386/x86.c
index b3d054889b..ef7949ac42 100644
--- a/hw/i386/x86.c
+++ b/hw/i386/x86.c
@@ -538,7 +538,7 @@ uint64_t cpu_get_tsc(CPUX86State *env)
 /* IRQ handling */
 static void pic_irq_request(void *opaque, int irq, int level)
 {
-    CPUState *cs = first_cpu;
+    CPUState *cs = qemu_get_cpu(0, TYPE_X86_CPU);
     X86CPU *cpu = X86_CPU(cs);
 
     trace_x86_pic_interrupt(irq, level);
diff --git a/hw/isa/lpc_ich9.c b/hw/isa/lpc_ich9.c
index 3f59980aa0..0b9c37e0bf 100644
--- a/hw/isa/lpc_ich9.c
+++ b/hw/isa/lpc_ich9.c
@@ -327,7 +327,7 @@ static PCIINTxRoute ich9_route_intx_pin_to_irq(void *opaque, int pirq_pin)
 
 void ich9_generate_smi(void)
 {
-    cpu_interrupt(first_cpu, CPU_INTERRUPT_SMI);
+    cpu_interrupt(qemu_get_cpu(0, TYPE_X86_CPU), CPU_INTERRUPT_SMI);
 }
 
 /* Returns -1 on error, IRQ number on success */
diff --git a/target/i386/arch_dump.c b/target/i386/arch_dump.c
index c290910a04..c167f893db 100644
--- a/target/i386/arch_dump.c
+++ b/target/i386/arch_dump.c
@@ -185,7 +185,7 @@ int x86_cpu_write_elf64_note(WriteCoreDumpFunction f, CPUState *cs,
     X86CPU *cpu = X86_CPU(cs);
     int ret;
 #ifdef TARGET_X86_64
-    X86CPU *first_x86_cpu = X86_CPU(first_cpu);
+    X86CPU *first_x86_cpu = X86_CPU(qemu_get_cpu(0, TYPE_X86_CPU));
     bool lma = !!(first_x86_cpu->env.hflags & HF_LMA_MASK);
 
     if (lma) {
@@ -401,8 +401,8 @@ int cpu_get_dump_info(ArchDumpInfo *info,
     GuestPhysBlock *block;
 
 #ifdef TARGET_X86_64
-    X86CPU *first_x86_cpu = X86_CPU(first_cpu);
-    lma = first_cpu && (first_x86_cpu->env.hflags & HF_LMA_MASK);
+    X86CPU *first_x86_cpu = X86_CPU(qemu_get_cpu(0, TYPE_X86_CPU));
+    lma = qemu_get_cpu(0, TYPE_X86_CPU) && (first_x86_cpu->env.hflags & HF_LMA_MASK);
 #endif
 
     if (lma) {
diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index ab72bcdfad..c38e68275e 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -3464,7 +3464,7 @@ static int kvm_put_msrs(X86CPU *cpu, int level)
          * Hyper-V partition-wide MSRs: to avoid clearing them on cpu hot-add,
          * only sync them to KVM on the first cpu
          */
-        if (current_cpu == first_cpu) {
+        if (current_cpu == qemu_get_cpu(0, TYPE_X86_CPU)) {
             if (has_msr_hv_hypercall) {
                 kvm_msr_entry_add(cpu, HV_X64_MSR_GUEST_OS_ID,
                                   env->msr_hv_guest_os_id);
@@ -5601,10 +5601,10 @@ uint64_t kvm_swizzle_msi_ext_dest_id(uint64_t address)
     CPUX86State *env;
     uint64_t ext_id;
 
-    if (!first_cpu) {
+    if (!qemu_get_cpu(0, TYPE_X86_CPU)) {
         return address;
     }
-    env = &X86_CPU(first_cpu)->env;
+    env = &X86_CPU(qemu_get_cpu(0, TYPE_X86_CPU))->env;
     if (!(env->features[FEAT_KVM] & (1 << KVM_FEATURE_MSI_EXT_DEST_ID))) {
         return address;
     }
diff --git a/target/i386/tcg/sysemu/fpu_helper.c b/target/i386/tcg/sysemu/fpu_helper.c
index 93506cdd94..942d04037c 100644
--- a/target/i386/tcg/sysemu/fpu_helper.c
+++ b/target/i386/tcg/sysemu/fpu_helper.c
@@ -41,13 +41,13 @@ void fpu_check_raise_ferr_irq(CPUX86State *env)
 
 void cpu_clear_ignne(void)
 {
-    CPUX86State *env = &X86_CPU(first_cpu)->env;
+    CPUX86State *env = &X86_CPU(qemu_get_cpu(0, TYPE_X86_CPU))->env;
     env->hflags2 &= ~HF2_IGNNE_MASK;
 }
 
 void cpu_set_ignne(void)
 {
-    CPUX86State *env = &X86_CPU(first_cpu)->env;
+    CPUX86State *env = &X86_CPU(qemu_get_cpu(0, TYPE_X86_CPU))->env;
 
     assert(qemu_mutex_iothread_locked());
 
-- 
2.41.0

