Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BEB2F7D3902
	for <lists+kvm@lfdr.de>; Mon, 23 Oct 2023 16:10:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229476AbjJWOKc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Oct 2023 10:10:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbjJWOK3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Oct 2023 10:10:29 -0400
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF1E4DF
        for <kvm@vger.kernel.org>; Mon, 23 Oct 2023 07:10:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1698070225; x=1729606225;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=iM0osDfJQlHcURPap0S7S9PxkzGbUqhS2HdMRF5Q6RY=;
  b=XHF58qgSM6L6LkMPgapIAnCctzt8jC3N7I6z+W8p9+Ip026wHSoDL9e+
   fyL9bn8oZj2kFrjZiX0LkGPnMMbTJIO+jfMQvj4pVzAzDsvBIij/qmrDJ
   I7nr3B5W6/6svPiK2n8KfTiTVwaxERp/03AYadxw4iJsYHktsPDhNs4mN
   vz9aG0eFXV5Cs2DJbTj8i/5nzMaNML2i2h5pLrxZsYDxQHzksZM2jqSIw
   Vwqhx3J+qRODMiceav/XCZIDU2Ym5IsQ/fAX6i2W9PNSCKy4oGJEDhOLt
   Zpin6+/RyBPO1ZTnuBPdnupZu+Uqc4n0+EakYvVdLasQyvzIuT6v+0Ckb
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10872"; a="5471509"
X-IronPort-AV: E=Sophos;i="6.03,244,1694761200"; 
   d="scan'208";a="5471509"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Oct 2023 07:10:24 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10872"; a="758152040"
X-IronPort-AV: E=Sophos;i="6.03,244,1694761200"; 
   d="scan'208";a="758152040"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.36])
  by orsmga002.jf.intel.com with ESMTP; 23 Oct 2023 07:10:12 -0700
Date:   Mon, 23 Oct 2023 22:21:51 +0800
From:   Zhao Liu <zhao1.liu@intel.com>
To:     Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?= <philmd@linaro.org>
Cc:     qemu-devel@nongnu.org, Thomas Huth <thuth@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Alistair Francis <alistair.francis@wdc.com>,
        qemu-arm@nongnu.org, qemu-riscv@nongnu.org,
        "Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
        qemu-ppc@nongnu.org, Eduardo Habkost <eduardo@habkost.net>,
        "Michael S. Tsirkin" <mst@redhat.com>, qemu-s390x@nongnu.org,
        Peter Maydell <peter.maydell@linaro.org>,
        Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>,
        Andrey Smirnov <andrew.smirnov@gmail.com>,
        Radoslaw Biernacki <rad@semihalf.com>,
        Leif Lindholm <quic_llindhol@quicinc.com>,
        Marcin Juszkiewicz <marcin.juszkiewicz@linaro.org>,
        Shannon Zhao <shannon.zhaosl@gmail.com>,
        Igor Mammedov <imammedo@redhat.com>,
        Ani Sinha <anisinha@redhat.com>,
        Alistair Francis <alistair@alistair23.me>,
        David Woodhouse <dwmw2@infradead.org>,
        Paul Durrant <paul@xen.org>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Bin Meng <bin.meng@windriver.com>,
        Weiwei Li <liweiwei@iscas.ac.cn>,
        Daniel Henrique Barboza <dbarboza@ventanamicro.com>,
        Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
        Song Gao <gaosong@loongson.cn>,
        Thomas Huth <huth@tuxfamily.org>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Ilya Leoshkevich <iii@linux.ibm.com>,
        Yanan Wang <wangyanan55@huawei.com>,
        "Dr. David Alan Gilbert" <dave@treblig.org>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Aurelien Jarno <aurelien@aurel32.net>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        Zhao Liu <zhao1.liu@intel.com>, kvm@vger.kernel.org
Subject: Re: [RFC PATCH 01/19] cpus: Add argument to qemu_get_cpu() to filter
 CPUs by QOM type
Message-ID: <ZTaBfzLDL1+Aayur@intel.com>
References: <20231020163643.86105-1-philmd@linaro.org>
 <20231020163643.86105-2-philmd@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20231020163643.86105-2-philmd@linaro.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Philippe,

On Fri, Oct 20, 2023 at 06:36:23PM +0200, Philippe Mathieu-Daudé wrote:
> Date: Fri, 20 Oct 2023 18:36:23 +0200
> From: Philippe Mathieu-Daudé <philmd@linaro.org>
> Subject: [RFC PATCH 01/19] cpus: Add argument to qemu_get_cpu() to filter
>  CPUs by QOM type
> X-Mailer: git-send-email 2.41.0
> 
> Heterogeneous machines have different type of CPU.
> qemu_get_cpu() returning unfiltered CPUs doesn't make
> sense anymore. Add a 'type' argument to filter CPU by
> QOM type.
> 
> Type in "hw/core/cpu.h" and implementation in cpu-common.c
> modified manually, then convert all call sites by passing
> a NULL argument using the following coccinelle script:
> 
>   @@
>   expression index;
>   @@
>   -   qemu_get_cpu(index)
>   +   qemu_get_cpu(index, NULL)
> 
> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
> ---
> RFC: Is this hot path code? What is the cost of this QOM cast check?
> ---
>  include/hw/core/cpu.h               |  3 ++-
>  cpu-common.c                        |  5 ++++-
>  hw/arm/boot.c                       |  2 +-
>  hw/arm/fsl-imx7.c                   |  2 +-
>  hw/arm/pxa2xx_gpio.c                |  2 +-
>  hw/arm/sbsa-ref.c                   |  4 ++--
>  hw/arm/vexpress.c                   |  2 +-
>  hw/arm/virt-acpi-build.c            |  2 +-
>  hw/arm/virt.c                       |  8 ++++----
>  hw/arm/xlnx-versal-virt.c           |  2 +-
>  hw/core/generic-loader.c            |  2 +-
>  hw/cpu/a15mpcore.c                  |  4 ++--
>  hw/cpu/a9mpcore.c                   |  2 +-
>  hw/hyperv/hyperv.c                  |  2 +-
>  hw/i386/kvm/xen_evtchn.c            |  8 ++++----
>  hw/intc/arm_gicv3_common.c          |  2 +-
>  hw/intc/arm_gicv3_cpuif.c           |  2 +-
>  hw/intc/arm_gicv3_kvm.c             |  2 +-
>  hw/intc/riscv_aclint.c              |  2 +-
>  hw/intc/sifive_plic.c               |  4 ++--
>  hw/loongarch/virt.c                 | 10 +++++-----
>  hw/m68k/mcf5206.c                   |  2 +-
>  hw/ppc/e500.c                       |  2 +-
>  hw/ppc/ppce500_spin.c               |  2 +-
>  hw/riscv/boot.c                     |  2 +-
>  hw/riscv/opentitan.c                |  4 ++--
>  hw/s390x/ipl.c                      |  2 +-
>  hw/s390x/s390-virtio-ccw.c          |  2 +-
>  monitor/hmp-cmds-target.c           |  4 ++--
>  stats/stats-hmp-cmds.c              |  2 +-
>  system/cpus.c                       |  2 +-
>  target/i386/kvm/xen-emu.c           | 15 ++++++++-------
>  target/i386/monitor.c               |  2 +-
>  target/mips/cpu.c                   |  2 +-
>  target/mips/tcg/sysemu/cp0_helper.c |  2 +-
>  target/s390x/cpu_models.c           | 10 +++++-----
>  36 files changed, 66 insertions(+), 61 deletions(-)
> 
> diff --git a/include/hw/core/cpu.h b/include/hw/core/cpu.h
> index 12205b7882..2a6008dd96 100644
> --- a/include/hw/core/cpu.h
> +++ b/include/hw/core/cpu.h
> @@ -903,12 +903,13 @@ static inline bool cpu_in_exclusive_context(const CPUState *cpu)
>  /**
>   * qemu_get_cpu:
>   * @index: The CPUState@cpu_index value of the CPU to obtain.

The meaning of index needs to be clearly defined here, I understand that
on a heterogeneous machine, CPUs of different ISAs will be numbered from
0 respectively, i.e. CPU0 of type0 is numbered 0, CPU1 of type0 is
numbered 1, and CPU 2 of type1 is also numbered 0, CPU3 of tyoe1 is also
numbered 1, thus we need another "type" to differentiate between CPU0
and CPU2, and CPU1 and CPU3...Is my understanding correct?

If so, the change to the qemu_get_cpu() interface actually implies a
change in the meaning of "index"; in the context of the old
qemu_get_cpu(index), "index" looked to refer to the system wide index,
while in the context of the new qemu_get_cpu(index, type), "index"
becomes the sub index of a certain cluster range.

If future heterogeneous machines still use different clusters to
organize different ISA cores, can we consider introducing the
cluster_index/qemu_get_cluster_cpu(cluster_index, type)? This seems to
avoid the confusion caused by the different meanings of index in
symmetric and heterogeneous machines.

Regards,
Zhao

> + * @type: The QOM type to filter for, including its derivatives.
>   *
>   * Gets a CPU matching @index.
>   *
>   * Returns: The CPU or %NULL if there is no matching CPU.
>   */
> -CPUState *qemu_get_cpu(int index);
> +CPUState *qemu_get_cpu(int index, const char *type);
>  
>  /**
>   * cpu_exists:
> diff --git a/cpu-common.c b/cpu-common.c
> index c81fd72d16..e0d7f7e7e7 100644
> --- a/cpu-common.c
> +++ b/cpu-common.c
> @@ -107,11 +107,14 @@ void cpu_list_remove(CPUState *cpu)
>      cpu_list_generation_id++;
>  }
>  
> -CPUState *qemu_get_cpu(int index)
> +CPUState *qemu_get_cpu(int index, const char *type)
>  {
>      CPUState *cpu;
>  
>      CPU_FOREACH(cpu) {
> +        if (type && !object_dynamic_cast(OBJECT(cpu), type)) {
> +            continue;
> +        }
>          if (cpu->cpu_index == index) {
>              return cpu;
>          }
> diff --git a/hw/arm/boot.c b/hw/arm/boot.c
> index 24fa169060..e260168cf5 100644
> --- a/hw/arm/boot.c
> +++ b/hw/arm/boot.c
> @@ -438,7 +438,7 @@ static void fdt_add_psci_node(void *fdt)
>      uint32_t cpu_off_fn;
>      uint32_t cpu_on_fn;
>      uint32_t migrate_fn;
> -    ARMCPU *armcpu = ARM_CPU(qemu_get_cpu(0));
> +    ARMCPU *armcpu = ARM_CPU(qemu_get_cpu(0, NULL));
>      const char *psci_method;
>      int64_t psci_conduit;
>      int rc;
> diff --git a/hw/arm/fsl-imx7.c b/hw/arm/fsl-imx7.c
> index 474cfdc87c..1c1585f3e1 100644
> --- a/hw/arm/fsl-imx7.c
> +++ b/hw/arm/fsl-imx7.c
> @@ -212,7 +212,7 @@ static void fsl_imx7_realize(DeviceState *dev, Error **errp)
>  
>      for (i = 0; i < smp_cpus; i++) {
>          SysBusDevice *sbd = SYS_BUS_DEVICE(&s->a7mpcore);
> -        DeviceState  *d   = DEVICE(qemu_get_cpu(i));
> +        DeviceState  *d   = DEVICE(qemu_get_cpu(i, NULL));
>  
>          irq = qdev_get_gpio_in(d, ARM_CPU_IRQ);
>          sysbus_connect_irq(sbd, i, irq);
> diff --git a/hw/arm/pxa2xx_gpio.c b/hw/arm/pxa2xx_gpio.c
> index e7c3d99224..0a698171ab 100644
> --- a/hw/arm/pxa2xx_gpio.c
> +++ b/hw/arm/pxa2xx_gpio.c
> @@ -303,7 +303,7 @@ static void pxa2xx_gpio_realize(DeviceState *dev, Error **errp)
>  {
>      PXA2xxGPIOInfo *s = PXA2XX_GPIO(dev);
>  
> -    s->cpu = ARM_CPU(qemu_get_cpu(s->ncpu));
> +    s->cpu = ARM_CPU(qemu_get_cpu(s->ncpu, NULL));
>  
>      qdev_init_gpio_in(dev, pxa2xx_gpio_set, s->lines);
>      qdev_init_gpio_out(dev, s->handler, s->lines);
> diff --git a/hw/arm/sbsa-ref.c b/hw/arm/sbsa-ref.c
> index 3c7dfcd6dc..3571d5038f 100644
> --- a/hw/arm/sbsa-ref.c
> +++ b/hw/arm/sbsa-ref.c
> @@ -275,7 +275,7 @@ static void create_fdt(SBSAMachineState *sms)
>  
>      for (cpu = sms->smp_cpus - 1; cpu >= 0; cpu--) {
>          char *nodename = g_strdup_printf("/cpus/cpu@%d", cpu);
> -        ARMCPU *armcpu = ARM_CPU(qemu_get_cpu(cpu));
> +        ARMCPU *armcpu = ARM_CPU(qemu_get_cpu(cpu, NULL));
>          CPUState *cs = CPU(armcpu);
>          uint64_t mpidr = sbsa_ref_cpu_mp_affinity(sms, cpu);
>  
> @@ -478,7 +478,7 @@ static void create_gic(SBSAMachineState *sms, MemoryRegion *mem)
>       * and the GIC's IRQ/FIQ/VIRQ/VFIQ interrupt outputs to the CPU's inputs.
>       */
>      for (i = 0; i < smp_cpus; i++) {
> -        DeviceState *cpudev = DEVICE(qemu_get_cpu(i));
> +        DeviceState *cpudev = DEVICE(qemu_get_cpu(i, NULL));
>          int ppibase = NUM_IRQS + i * GIC_INTERNAL + GIC_NR_SGIS;
>          int irq;
>          /*
> diff --git a/hw/arm/vexpress.c b/hw/arm/vexpress.c
> index 8ff37f52ca..0590332fe5 100644
> --- a/hw/arm/vexpress.c
> +++ b/hw/arm/vexpress.c
> @@ -257,7 +257,7 @@ static void init_cpus(MachineState *ms, const char *cpu_type,
>  
>      /* Connect the CPUs to the GIC */
>      for (n = 0; n < smp_cpus; n++) {
> -        DeviceState *cpudev = DEVICE(qemu_get_cpu(n));
> +        DeviceState *cpudev = DEVICE(qemu_get_cpu(n, NULL));
>  
>          sysbus_connect_irq(busdev, n, qdev_get_gpio_in(cpudev, ARM_CPU_IRQ));
>          sysbus_connect_irq(busdev, n + smp_cpus,
> diff --git a/hw/arm/virt-acpi-build.c b/hw/arm/virt-acpi-build.c
> index 6b674231c2..fd6c239c31 100644
> --- a/hw/arm/virt-acpi-build.c
> +++ b/hw/arm/virt-acpi-build.c
> @@ -727,7 +727,7 @@ build_madt(GArray *table_data, BIOSLinker *linker, VirtMachineState *vms)
>      build_append_int_noprefix(table_data, 0, 3);   /* Reserved */
>  
>      for (i = 0; i < MACHINE(vms)->smp.cpus; i++) {
> -        ARMCPU *armcpu = ARM_CPU(qemu_get_cpu(i));
> +        ARMCPU *armcpu = ARM_CPU(qemu_get_cpu(i, NULL));
>          uint64_t physical_base_address = 0, gich = 0, gicv = 0;
>          uint32_t vgic_interrupt = vms->virt ? PPI(ARCH_GIC_MAINT_IRQ) : 0;
>          uint32_t pmu_interrupt = arm_feature(&armcpu->env, ARM_FEATURE_PMU) ?
> diff --git a/hw/arm/virt.c b/hw/arm/virt.c
> index 15e74249f9..a8f9d88519 100644
> --- a/hw/arm/virt.c
> +++ b/hw/arm/virt.c
> @@ -355,7 +355,7 @@ static void fdt_add_timer_nodes(const VirtMachineState *vms)
>  
>      qemu_fdt_add_subnode(ms->fdt, "/timer");
>  
> -    armcpu = ARM_CPU(qemu_get_cpu(0));
> +    armcpu = ARM_CPU(qemu_get_cpu(0, NULL));
>      if (arm_feature(&armcpu->env, ARM_FEATURE_V8)) {
>          const char compat[] = "arm,armv8-timer\0arm,armv7-timer";
>          qemu_fdt_setprop(ms->fdt, "/timer", "compatible",
> @@ -394,7 +394,7 @@ static void fdt_add_cpu_nodes(const VirtMachineState *vms)
>       * at least one of them has Aff3 populated, we set #address-cells to 2.
>       */
>      for (cpu = 0; cpu < smp_cpus; cpu++) {
> -        ARMCPU *armcpu = ARM_CPU(qemu_get_cpu(cpu));
> +        ARMCPU *armcpu = ARM_CPU(qemu_get_cpu(cpu, NULL));
>  
>          if (armcpu->mp_affinity & ARM_AFF3_MASK) {
>              addr_cells = 2;
> @@ -408,7 +408,7 @@ static void fdt_add_cpu_nodes(const VirtMachineState *vms)
>  
>      for (cpu = smp_cpus - 1; cpu >= 0; cpu--) {
>          char *nodename = g_strdup_printf("/cpus/cpu@%d", cpu);
> -        ARMCPU *armcpu = ARM_CPU(qemu_get_cpu(cpu));
> +        ARMCPU *armcpu = ARM_CPU(qemu_get_cpu(cpu, NULL));
>          CPUState *cs = CPU(armcpu);
>  
>          qemu_fdt_add_subnode(ms->fdt, nodename);
> @@ -799,7 +799,7 @@ static void create_gic(VirtMachineState *vms, MemoryRegion *mem)
>       * and the GIC's IRQ/FIQ/VIRQ/VFIQ interrupt outputs to the CPU's inputs.
>       */
>      for (i = 0; i < smp_cpus; i++) {
> -        DeviceState *cpudev = DEVICE(qemu_get_cpu(i));
> +        DeviceState *cpudev = DEVICE(qemu_get_cpu(i, NULL));
>          int ppibase = NUM_IRQS + i * GIC_INTERNAL + GIC_NR_SGIS;
>          /* Mapping from the output timer irq lines from the CPU to the
>           * GIC PPI inputs we use for the virt board.
> diff --git a/hw/arm/xlnx-versal-virt.c b/hw/arm/xlnx-versal-virt.c
> index 88c561ff63..419ee3b882 100644
> --- a/hw/arm/xlnx-versal-virt.c
> +++ b/hw/arm/xlnx-versal-virt.c
> @@ -103,7 +103,7 @@ static void fdt_add_cpu_nodes(VersalVirt *s, uint32_t psci_conduit)
>  
>      for (i = XLNX_VERSAL_NR_ACPUS - 1; i >= 0; i--) {
>          char *name = g_strdup_printf("/cpus/cpu@%d", i);
> -        ARMCPU *armcpu = ARM_CPU(qemu_get_cpu(i));
> +        ARMCPU *armcpu = ARM_CPU(qemu_get_cpu(i, NULL));
>  
>          qemu_fdt_add_subnode(s->fdt, name);
>          qemu_fdt_setprop_cell(s->fdt, name, "reg", armcpu->mp_affinity);
> diff --git a/hw/core/generic-loader.c b/hw/core/generic-loader.c
> index d4b5c501d8..98830ebd5b 100644
> --- a/hw/core/generic-loader.c
> +++ b/hw/core/generic-loader.c
> @@ -124,7 +124,7 @@ static void generic_loader_realize(DeviceState *dev, Error **errp)
>      qemu_register_reset(generic_loader_reset, dev);
>  
>      if (s->cpu_num != CPU_NONE) {
> -        s->cpu = qemu_get_cpu(s->cpu_num);
> +        s->cpu = qemu_get_cpu(s->cpu_num, NULL);
>          if (!s->cpu) {
>              error_setg(errp, "Specified boot CPU#%d is nonexistent",
>                         s->cpu_num);
> diff --git a/hw/cpu/a15mpcore.c b/hw/cpu/a15mpcore.c
> index bfd8aa5644..8c9098d5d3 100644
> --- a/hw/cpu/a15mpcore.c
> +++ b/hw/cpu/a15mpcore.c
> @@ -65,7 +65,7 @@ static void a15mp_priv_realize(DeviceState *dev, Error **errp)
>          /* Make the GIC's TZ support match the CPUs. We assume that
>           * either all the CPUs have TZ, or none do.
>           */
> -        cpuobj = OBJECT(qemu_get_cpu(0));
> +        cpuobj = OBJECT(qemu_get_cpu(0, NULL));
>          has_el3 = object_property_find(cpuobj, "has_el3") &&
>              object_property_get_bool(cpuobj, "has_el3", &error_abort);
>          qdev_prop_set_bit(gicdev, "has-security-extensions", has_el3);
> @@ -90,7 +90,7 @@ static void a15mp_priv_realize(DeviceState *dev, Error **errp)
>       * appropriate GIC PPI inputs
>       */
>      for (i = 0; i < s->num_cpu; i++) {
> -        DeviceState *cpudev = DEVICE(qemu_get_cpu(i));
> +        DeviceState *cpudev = DEVICE(qemu_get_cpu(i, NULL));
>          int ppibase = s->num_irq - 32 + i * 32;
>          int irq;
>          /* Mapping from the output timer irq lines from the CPU to the
> diff --git a/hw/cpu/a9mpcore.c b/hw/cpu/a9mpcore.c
> index d03f57e579..62b7fb3836 100644
> --- a/hw/cpu/a9mpcore.c
> +++ b/hw/cpu/a9mpcore.c
> @@ -56,7 +56,7 @@ static void a9mp_priv_realize(DeviceState *dev, Error **errp)
>      CPUState *cpu0;
>      Object *cpuobj;
>  
> -    cpu0 = qemu_get_cpu(0);
> +    cpu0 = qemu_get_cpu(0, NULL);
>      cpuobj = OBJECT(cpu0);
>      if (strcmp(object_get_typename(cpuobj), ARM_CPU_TYPE_NAME("cortex-a9"))) {
>          /* We might allow Cortex-A5 once we model it */
> diff --git a/hw/hyperv/hyperv.c b/hw/hyperv/hyperv.c
> index 57b402b956..a43f29ad8d 100644
> --- a/hw/hyperv/hyperv.c
> +++ b/hw/hyperv/hyperv.c
> @@ -226,7 +226,7 @@ struct HvSintRoute {
>  
>  static CPUState *hyperv_find_vcpu(uint32_t vp_index)
>  {
> -    CPUState *cs = qemu_get_cpu(vp_index);
> +    CPUState *cs = qemu_get_cpu(vp_index, NULL);
>      assert(hyperv_vp_index(cs) == vp_index);
>      return cs;
>  }
> diff --git a/hw/i386/kvm/xen_evtchn.c b/hw/i386/kvm/xen_evtchn.c
> index a731738411..de3650ba3b 100644
> --- a/hw/i386/kvm/xen_evtchn.c
> +++ b/hw/i386/kvm/xen_evtchn.c
> @@ -542,7 +542,7 @@ static void deassign_kernel_port(evtchn_port_t port)
>  static int assign_kernel_port(uint16_t type, evtchn_port_t port,
>                                uint32_t vcpu_id)
>  {
> -    CPUState *cpu = qemu_get_cpu(vcpu_id);
> +    CPUState *cpu = qemu_get_cpu(vcpu_id, NULL);
>      struct kvm_xen_hvm_attr ha;
>  
>      if (!cpu) {
> @@ -589,7 +589,7 @@ static bool valid_port(evtchn_port_t port)
>  
>  static bool valid_vcpu(uint32_t vcpu)
>  {
> -    return !!qemu_get_cpu(vcpu);
> +    return !!qemu_get_cpu(vcpu, NULL);
>  }
>  
>  static void unbind_backend_ports(XenEvtchnState *s)
> @@ -917,7 +917,7 @@ static int set_port_pending(XenEvtchnState *s, evtchn_port_t port)
>  
>      if (s->evtchn_in_kernel) {
>          XenEvtchnPort *p = &s->port_table[port];
> -        CPUState *cpu = qemu_get_cpu(p->vcpu);
> +        CPUState *cpu = qemu_get_cpu(p->vcpu, NULL);
>          struct kvm_irq_routing_xen_evtchn evt;
>  
>          if (!cpu) {
> @@ -1779,7 +1779,7 @@ int xen_evtchn_translate_pirq_msi(struct kvm_irq_routing_entry *route,
>          return -EINVAL;
>      }
>  
> -    cpu = qemu_get_cpu(s->port_table[port].vcpu);
> +    cpu = qemu_get_cpu(s->port_table[port].vcpu, NULL);
>      if (!cpu) {
>          return -EINVAL;
>      }
> diff --git a/hw/intc/arm_gicv3_common.c b/hw/intc/arm_gicv3_common.c
> index 2ebf880ead..cdf21dfc11 100644
> --- a/hw/intc/arm_gicv3_common.c
> +++ b/hw/intc/arm_gicv3_common.c
> @@ -392,7 +392,7 @@ static void arm_gicv3_common_realize(DeviceState *dev, Error **errp)
>      s->cpu = g_new0(GICv3CPUState, s->num_cpu);
>  
>      for (i = 0; i < s->num_cpu; i++) {
> -        CPUState *cpu = qemu_get_cpu(i);
> +        CPUState *cpu = qemu_get_cpu(i, NULL);
>          uint64_t cpu_affid;
>  
>          s->cpu[i].cpu = cpu;
> diff --git a/hw/intc/arm_gicv3_cpuif.c b/hw/intc/arm_gicv3_cpuif.c
> index d07b13eb27..f765b3d4b5 100644
> --- a/hw/intc/arm_gicv3_cpuif.c
> +++ b/hw/intc/arm_gicv3_cpuif.c
> @@ -2795,7 +2795,7 @@ void gicv3_init_cpuif(GICv3State *s)
>      int i;
>  
>      for (i = 0; i < s->num_cpu; i++) {
> -        ARMCPU *cpu = ARM_CPU(qemu_get_cpu(i));
> +        ARMCPU *cpu = ARM_CPU(qemu_get_cpu(i, NULL));
>          GICv3CPUState *cs = &s->cpu[i];
>  
>          /*
> diff --git a/hw/intc/arm_gicv3_kvm.c b/hw/intc/arm_gicv3_kvm.c
> index 72ad916d3d..d1ff9886aa 100644
> --- a/hw/intc/arm_gicv3_kvm.c
> +++ b/hw/intc/arm_gicv3_kvm.c
> @@ -808,7 +808,7 @@ static void kvm_arm_gicv3_realize(DeviceState *dev, Error **errp)
>      gicv3_init_irqs_and_mmio(s, kvm_arm_gicv3_set_irq, NULL);
>  
>      for (i = 0; i < s->num_cpu; i++) {
> -        ARMCPU *cpu = ARM_CPU(qemu_get_cpu(i));
> +        ARMCPU *cpu = ARM_CPU(qemu_get_cpu(i, NULL));
>  
>          define_arm_cp_regs(cpu, gicv3_cpuif_reginfo);
>      }
> diff --git a/hw/intc/riscv_aclint.c b/hw/intc/riscv_aclint.c
> index ab1a0b4b3a..a97c0449ec 100644
> --- a/hw/intc/riscv_aclint.c
> +++ b/hw/intc/riscv_aclint.c
> @@ -483,7 +483,7 @@ static void riscv_aclint_swi_realize(DeviceState *dev, Error **errp)
>  
>      /* Claim software interrupt bits */
>      for (i = 0; i < swi->num_harts; i++) {
> -        RISCVCPU *cpu = RISCV_CPU(qemu_get_cpu(swi->hartid_base + i));
> +        RISCVCPU *cpu = RISCV_CPU(qemu_get_cpu(swi->hartid_base + i, NULL));
>          /* We don't claim mip.SSIP because it is writable by software */
>          if (riscv_cpu_claim_interrupts(cpu, swi->sswi ? 0 : MIP_MSIP) < 0) {
>              error_report("MSIP already claimed");
> diff --git a/hw/intc/sifive_plic.c b/hw/intc/sifive_plic.c
> index 5522ede2cf..a32e7f1924 100644
> --- a/hw/intc/sifive_plic.c
> +++ b/hw/intc/sifive_plic.c
> @@ -392,7 +392,7 @@ static void sifive_plic_realize(DeviceState *dev, Error **errp)
>       * hardware controlled when a PLIC is attached.
>       */
>      for (i = 0; i < s->num_harts; i++) {
> -        RISCVCPU *cpu = RISCV_CPU(qemu_get_cpu(s->hartid_base + i));
> +        RISCVCPU *cpu = RISCV_CPU(qemu_get_cpu(s->hartid_base + i, NULL));
>          if (riscv_cpu_claim_interrupts(cpu, MIP_SEIP) < 0) {
>              error_setg(errp, "SEIP already claimed");
>              return;
> @@ -499,7 +499,7 @@ DeviceState *sifive_plic_create(hwaddr addr, char *hart_config,
>  
>      for (i = 0; i < plic->num_addrs; i++) {
>          int cpu_num = plic->addr_config[i].hartid;
> -        CPUState *cpu = qemu_get_cpu(cpu_num);
> +        CPUState *cpu = qemu_get_cpu(cpu_num, NULL);
>  
>          if (plic->addr_config[i].mode == PLICMode_M) {
>              qdev_connect_gpio_out(dev, cpu_num - hartid_base + num_harts,
> diff --git a/hw/loongarch/virt.c b/hw/loongarch/virt.c
> index 2952fe452e..e888aea892 100644
> --- a/hw/loongarch/virt.c
> +++ b/hw/loongarch/virt.c
> @@ -170,7 +170,7 @@ static void fdt_add_cpu_nodes(const LoongArchMachineState *lams)
>      /* cpu nodes */
>      for (num = smp_cpus - 1; num >= 0; num--) {
>          char *nodename = g_strdup_printf("/cpus/cpu@%d", num);
> -        LoongArchCPU *cpu = LOONGARCH_CPU(qemu_get_cpu(num));
> +        LoongArchCPU *cpu = LOONGARCH_CPU(qemu_get_cpu(num, NULL));
>          CPUState *cs = CPU(cpu);
>  
>          qemu_fdt_add_subnode(ms->fdt, nodename);
> @@ -560,7 +560,7 @@ static void loongarch_irq_init(LoongArchMachineState *lams)
>       * +--------+ +---------+ +---------+
>       */
>      for (cpu = 0; cpu < ms->smp.cpus; cpu++) {
> -        cpu_state = qemu_get_cpu(cpu);
> +        cpu_state = qemu_get_cpu(cpu, NULL);
>          cpudev = DEVICE(cpu_state);
>          lacpu = LOONGARCH_CPU(cpu_state);
>          env = &(lacpu->env);
> @@ -594,7 +594,7 @@ static void loongarch_irq_init(LoongArchMachineState *lams)
>       * cpu_pin[9:2] <= intc_pin[7:0]
>       */
>      for (cpu = 0; cpu < MIN(ms->smp.cpus, EXTIOI_CPUS); cpu++) {
> -        cpudev = DEVICE(qemu_get_cpu(cpu));
> +        cpudev = DEVICE(qemu_get_cpu(cpu, NULL));
>          for (pin = 0; pin < LS3A_INTC_IP; pin++) {
>              qdev_connect_gpio_out(extioi, (cpu * 8 + pin),
>                                    qdev_get_gpio_in(cpudev, pin + 2));
> @@ -726,7 +726,7 @@ static void loongarch_direct_kernel_boot(LoongArchMachineState *lams,
>      kernel_addr = load_kernel_info(loaderparams);
>      if (!machine->firmware) {
>          for (i = 0; i < machine->smp.cpus; i++) {
> -            lacpu = LOONGARCH_CPU(qemu_get_cpu(i));
> +            lacpu = LOONGARCH_CPU(qemu_get_cpu(i, NULL));
>              lacpu->env.load_elf = true;
>              lacpu->env.elf_address = kernel_addr;
>          }
> @@ -859,7 +859,7 @@ static void loongarch_init(MachineState *machine)
>      fdt_add_flash_node(lams);
>      /* register reset function */
>      for (i = 0; i < machine->smp.cpus; i++) {
> -        lacpu = LOONGARCH_CPU(qemu_get_cpu(i));
> +        lacpu = LOONGARCH_CPU(qemu_get_cpu(i, NULL));
>          qemu_register_reset(reset_load_elf, lacpu);
>      }
>      /* Initialize the IO interrupt subsystem */
> diff --git a/hw/m68k/mcf5206.c b/hw/m68k/mcf5206.c
> index 2ab1b4f059..a0851f58a9 100644
> --- a/hw/m68k/mcf5206.c
> +++ b/hw/m68k/mcf5206.c
> @@ -601,7 +601,7 @@ static void mcf5206_mbar_realize(DeviceState *dev, Error **errp)
>      s->timer[1] = m5206_timer_init(s->pic[10]);
>      s->uart[0] = mcf_uart_init(s->pic[12], serial_hd(0));
>      s->uart[1] = mcf_uart_init(s->pic[13], serial_hd(1));
> -    s->cpu = M68K_CPU(qemu_get_cpu(0));
> +    s->cpu = M68K_CPU(qemu_get_cpu(0, NULL));
>  }
>  
>  static void mcf5206_mbar_class_init(ObjectClass *oc, void *data)
> diff --git a/hw/ppc/e500.c b/hw/ppc/e500.c
> index e04114fb3c..380bbe1fe6 100644
> --- a/hw/ppc/e500.c
> +++ b/hw/ppc/e500.c
> @@ -495,7 +495,7 @@ static int ppce500_load_device_tree(PPCE500MachineState *pms,
>          char *cpu_name;
>          uint64_t cpu_release_addr = pmc->spin_base + (i * 0x20);
>  
> -        cpu = qemu_get_cpu(i);
> +        cpu = qemu_get_cpu(i, NULL);
>          if (cpu == NULL) {
>              continue;
>          }
> diff --git a/hw/ppc/ppce500_spin.c b/hw/ppc/ppce500_spin.c
> index bbce63e8a4..3b113fbbdb 100644
> --- a/hw/ppc/ppce500_spin.c
> +++ b/hw/ppc/ppce500_spin.c
> @@ -125,7 +125,7 @@ static void spin_write(void *opaque, hwaddr addr, uint64_t value,
>      SpinInfo *curspin = &s->spin[env_idx];
>      uint8_t *curspin_p = (uint8_t*)curspin;
>  
> -    cpu = qemu_get_cpu(env_idx);
> +    cpu = qemu_get_cpu(env_idx, NULL);
>      if (cpu == NULL) {
>          /* Unknown CPU */
>          return;
> diff --git a/hw/riscv/boot.c b/hw/riscv/boot.c
> index 52bf8e67de..ea733b3df1 100644
> --- a/hw/riscv/boot.c
> +++ b/hw/riscv/boot.c
> @@ -49,7 +49,7 @@ char *riscv_plic_hart_config_string(int hart_count)
>      int i;
>  
>      for (i = 0; i < hart_count; i++) {
> -        CPUState *cs = qemu_get_cpu(i);
> +        CPUState *cs = qemu_get_cpu(i, NULL);
>          CPURISCVState *env = &RISCV_CPU(cs)->env;
>  
>          if (kvm_enabled()) {
> diff --git a/hw/riscv/opentitan.c b/hw/riscv/opentitan.c
> index 436503f1ba..e98361de19 100644
> --- a/hw/riscv/opentitan.c
> +++ b/hw/riscv/opentitan.c
> @@ -190,7 +190,7 @@ static void lowrisc_ibex_soc_realize(DeviceState *dev_soc, Error **errp)
>      sysbus_mmio_map(SYS_BUS_DEVICE(&s->plic), 0, memmap[IBEX_DEV_PLIC].base);
>  
>      for (i = 0; i < ms->smp.cpus; i++) {
> -        CPUState *cpu = qemu_get_cpu(i);
> +        CPUState *cpu = qemu_get_cpu(i, NULL);
>  
>          qdev_connect_gpio_out(DEVICE(&s->plic), ms->smp.cpus + i,
>                                qdev_get_gpio_in(DEVICE(cpu), IRQ_M_EXT));
> @@ -223,7 +223,7 @@ static void lowrisc_ibex_soc_realize(DeviceState *dev_soc, Error **errp)
>                         0, qdev_get_gpio_in(DEVICE(&s->plic),
>                         IBEX_TIMER_TIMEREXPIRED0_0));
>      qdev_connect_gpio_out(DEVICE(&s->timer), 0,
> -                          qdev_get_gpio_in(DEVICE(qemu_get_cpu(0)),
> +                          qdev_get_gpio_in(DEVICE(qemu_get_cpu(0, NULL)),
>                                             IRQ_M_TIMER));
>  
>      /* SPI-Hosts */
> diff --git a/hw/s390x/ipl.c b/hw/s390x/ipl.c
> index 515dcf51b5..14cd0a1f7b 100644
> --- a/hw/s390x/ipl.c
> +++ b/hw/s390x/ipl.c
> @@ -671,7 +671,7 @@ void s390_ipl_get_reset_request(CPUState **cs, enum s390_reset *reset_type)
>  {
>      S390IPLState *ipl = get_ipl_device();
>  
> -    *cs = qemu_get_cpu(ipl->reset_cpu_index);
> +    *cs = qemu_get_cpu(ipl->reset_cpu_index, NULL);
>      if (!*cs) {
>          /* use any CPU */
>          *cs = first_cpu;
> diff --git a/hw/s390x/s390-virtio-ccw.c b/hw/s390x/s390-virtio-ccw.c
> index 2d75f2131f..7628b746a8 100644
> --- a/hw/s390x/s390-virtio-ccw.c
> +++ b/hw/s390x/s390-virtio-ccw.c
> @@ -583,7 +583,7 @@ static HotplugHandler *s390_get_hotplug_handler(MachineState *machine,
>  
>  static void s390_nmi(NMIState *n, int cpu_index, Error **errp)
>  {
> -    CPUState *cs = qemu_get_cpu(cpu_index);
> +    CPUState *cs = qemu_get_cpu(cpu_index, NULL);
>  
>      s390_cpu_restart(S390_CPU(cs));
>  }
> diff --git a/monitor/hmp-cmds-target.c b/monitor/hmp-cmds-target.c
> index d9fbcac08d..e501b997f8 100644
> --- a/monitor/hmp-cmds-target.c
> +++ b/monitor/hmp-cmds-target.c
> @@ -36,7 +36,7 @@ int monitor_set_cpu(Monitor *mon, int cpu_index)
>  {
>      CPUState *cpu;
>  
> -    cpu = qemu_get_cpu(cpu_index);
> +    cpu = qemu_get_cpu(cpu_index, NULL);
>      if (cpu == NULL) {
>          return -1;
>      }
> @@ -103,7 +103,7 @@ void hmp_info_registers(Monitor *mon, const QDict *qdict)
>              cpu_dump_state(cs, NULL, CPU_DUMP_FPU);
>          }
>      } else {
> -        cs = vcpu >= 0 ? qemu_get_cpu(vcpu) : mon_get_cpu(mon);
> +        cs = vcpu >= 0 ? qemu_get_cpu(vcpu, NULL) : mon_get_cpu(mon);
>  
>          if (!cs) {
>              if (vcpu >= 0) {
> diff --git a/stats/stats-hmp-cmds.c b/stats/stats-hmp-cmds.c
> index 1f91bf8bd5..0e58336c7f 100644
> --- a/stats/stats-hmp-cmds.c
> +++ b/stats/stats-hmp-cmds.c
> @@ -147,7 +147,7 @@ static StatsFilter *stats_filter(StatsTarget target, const char *names,
>      case STATS_TARGET_VCPU:
>      {
>          strList *vcpu_list = NULL;
> -        CPUState *cpu = qemu_get_cpu(cpu_index);
> +        CPUState *cpu = qemu_get_cpu(cpu_index, NULL);
>          char *canonical_path = object_get_canonical_path(OBJECT(cpu));
>  
>          QAPI_LIST_PREPEND(vcpu_list, canonical_path);
> diff --git a/system/cpus.c b/system/cpus.c
> index 0848e0dbdb..3e7c80e91b 100644
> --- a/system/cpus.c
> +++ b/system/cpus.c
> @@ -751,7 +751,7 @@ void qmp_memsave(int64_t addr, int64_t size, const char *filename,
>          cpu_index = 0;
>      }
>  
> -    cpu = qemu_get_cpu(cpu_index);
> +    cpu = qemu_get_cpu(cpu_index, NULL);
>      if (cpu == NULL) {
>          error_setg(errp, QERR_INVALID_PARAMETER_VALUE, "cpu-index",
>                     "a CPU number");
> diff --git a/target/i386/kvm/xen-emu.c b/target/i386/kvm/xen-emu.c
> index 76348f9d5d..f289af906c 100644
> --- a/target/i386/kvm/xen-emu.c
> +++ b/target/i386/kvm/xen-emu.c
> @@ -384,7 +384,7 @@ static void do_set_vcpu_info_gpa(CPUState *cs, run_on_cpu_data data)
>  
>  void *kvm_xen_get_vcpu_info_hva(uint32_t vcpu_id)
>  {
> -    CPUState *cs = qemu_get_cpu(vcpu_id);
> +    CPUState *cs = qemu_get_cpu(vcpu_id, NULL);
>      if (!cs) {
>          return NULL;
>      }
> @@ -418,7 +418,7 @@ void kvm_xen_maybe_deassert_callback(CPUState *cs)
>  
>  void kvm_xen_set_callback_asserted(void)
>  {
> -    CPUState *cs = qemu_get_cpu(0);
> +    CPUState *cs = qemu_get_cpu(0, NULL);
>  
>      if (cs) {
>          X86_CPU(cs)->env.xen_callback_asserted = true;
> @@ -427,7 +427,7 @@ void kvm_xen_set_callback_asserted(void)
>  
>  void kvm_xen_inject_vcpu_callback_vector(uint32_t vcpu_id, int type)
>  {
> -    CPUState *cs = qemu_get_cpu(vcpu_id);
> +    CPUState *cs = qemu_get_cpu(vcpu_id, NULL);
>      uint8_t vector;
>  
>      if (!cs) {
> @@ -491,7 +491,7 @@ static void do_set_vcpu_timer_virq(CPUState *cs, run_on_cpu_data data)
>  
>  int kvm_xen_set_vcpu_virq(uint32_t vcpu_id, uint16_t virq, uint16_t port)
>  {
> -    CPUState *cs = qemu_get_cpu(vcpu_id);
> +    CPUState *cs = qemu_get_cpu(vcpu_id, NULL);
>  
>      if (!cs) {
>          return -ENOENT;
> @@ -588,7 +588,7 @@ static int xen_set_shared_info(uint64_t gfn)
>      trace_kvm_xen_set_shared_info(gfn);
>  
>      for (i = 0; i < XEN_LEGACY_MAX_VCPUS; i++) {
> -        CPUState *cpu = qemu_get_cpu(i);
> +        CPUState *cpu = qemu_get_cpu(i, NULL);
>          if (cpu) {
>              async_run_on_cpu(cpu, do_set_vcpu_info_default_gpa,
>                               RUN_ON_CPU_HOST_ULONG(gpa));
> @@ -834,7 +834,7 @@ static int kvm_xen_hcall_evtchn_upcall_vector(struct kvm_xen_exit *exit,
>          return -EINVAL;
>      }
>  
> -    target_cs = qemu_get_cpu(up.vcpu);
> +    target_cs = qemu_get_cpu(up.vcpu, NULL);
>      if (!target_cs) {
>          return -EINVAL;
>      }
> @@ -1160,7 +1160,8 @@ static bool kvm_xen_hcall_vcpu_op(struct kvm_xen_exit *exit, X86CPU *cpu,
>                                    int cmd, int vcpu_id, uint64_t arg)
>  {
>      CPUState *cs = CPU(cpu);
> -    CPUState *dest = cs->cpu_index == vcpu_id ? cs : qemu_get_cpu(vcpu_id);
> +    CPUState *dest = cs->cpu_index == vcpu_id ? cs : qemu_get_cpu(vcpu_id,
> +                                                                  NULL);
>      int err;
>  
>      if (!dest) {
> diff --git a/target/i386/monitor.c b/target/i386/monitor.c
> index 6512846327..aca7be61dd 100644
> --- a/target/i386/monitor.c
> +++ b/target/i386/monitor.c
> @@ -592,7 +592,7 @@ void hmp_mce(Monitor *mon, const QDict *qdict)
>      if (qdict_get_try_bool(qdict, "broadcast", false)) {
>          flags |= MCE_INJECT_BROADCAST;
>      }
> -    cs = qemu_get_cpu(cpu_index);
> +    cs = qemu_get_cpu(cpu_index, NULL);
>      if (cs != NULL) {
>          cpu = X86_CPU(cs);
>          cpu_x86_inject_mce(mon, cpu, bank, status, mcg_status, addr, misc,
> diff --git a/target/mips/cpu.c b/target/mips/cpu.c
> index 83ee54f766..17e9e06a15 100644
> --- a/target/mips/cpu.c
> +++ b/target/mips/cpu.c
> @@ -117,7 +117,7 @@ static void mips_cpu_dump_state(CPUState *cs, FILE *f, int flags)
>  
>  void cpu_set_exception_base(int vp_index, target_ulong address)
>  {
> -    MIPSCPU *vp = MIPS_CPU(qemu_get_cpu(vp_index));
> +    MIPSCPU *vp = MIPS_CPU(qemu_get_cpu(vp_index, NULL));
>      vp->env.exception_base = address;
>  }
>  
> diff --git a/target/mips/tcg/sysemu/cp0_helper.c b/target/mips/tcg/sysemu/cp0_helper.c
> index 5da1124589..fcaba37c40 100644
> --- a/target/mips/tcg/sysemu/cp0_helper.c
> +++ b/target/mips/tcg/sysemu/cp0_helper.c
> @@ -126,7 +126,7 @@ static CPUMIPSState *mips_cpu_map_tc(CPUMIPSState *env, int *tc)
>      cs = env_cpu(env);
>      vpe_idx = tc_idx / cs->nr_threads;
>      *tc = tc_idx % cs->nr_threads;
> -    other_cs = qemu_get_cpu(vpe_idx);
> +    other_cs = qemu_get_cpu(vpe_idx, NULL);
>      if (other_cs == NULL) {
>          return env;
>      }
> diff --git a/target/s390x/cpu_models.c b/target/s390x/cpu_models.c
> index b1e77b3a2b..4a44ee56a9 100644
> --- a/target/s390x/cpu_models.c
> +++ b/target/s390x/cpu_models.c
> @@ -150,7 +150,7 @@ uint32_t s390_get_hmfai(void)
>      static S390CPU *cpu;
>  
>      if (!cpu) {
> -        cpu = S390_CPU(qemu_get_cpu(0));
> +        cpu = S390_CPU(qemu_get_cpu(0, NULL));
>      }
>  
>      if (!cpu || !cpu->model) {
> @@ -164,7 +164,7 @@ uint8_t s390_get_mha_pow(void)
>      static S390CPU *cpu;
>  
>      if (!cpu) {
> -        cpu = S390_CPU(qemu_get_cpu(0));
> +        cpu = S390_CPU(qemu_get_cpu(0, NULL));
>      }
>  
>      if (!cpu || !cpu->model) {
> @@ -179,7 +179,7 @@ uint32_t s390_get_ibc_val(void)
>      static S390CPU *cpu;
>  
>      if (!cpu) {
> -        cpu = S390_CPU(qemu_get_cpu(0));
> +        cpu = S390_CPU(qemu_get_cpu(0, NULL));
>      }
>  
>      if (!cpu || !cpu->model) {
> @@ -199,7 +199,7 @@ void s390_get_feat_block(S390FeatType type, uint8_t *data)
>      static S390CPU *cpu;
>  
>      if (!cpu) {
> -        cpu = S390_CPU(qemu_get_cpu(0));
> +        cpu = S390_CPU(qemu_get_cpu(0, NULL));
>      }
>  
>      if (!cpu || !cpu->model) {
> @@ -213,7 +213,7 @@ bool s390_has_feat(S390Feat feat)
>      static S390CPU *cpu;
>  
>      if (!cpu) {
> -        cpu = S390_CPU(qemu_get_cpu(0));
> +        cpu = S390_CPU(qemu_get_cpu(0, NULL));
>      }
>  
>      if (!cpu || !cpu->model) {
> -- 
> 2.41.0
> 
