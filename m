Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BAA08992B8
	for <lists+kvm@lfdr.de>; Thu, 22 Aug 2019 13:58:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733260AbfHVL5X (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Aug 2019 07:57:23 -0400
Received: from foss.arm.com ([217.140.110.172]:44750 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731156AbfHVL5W (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Aug 2019 07:57:22 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id EABE1337;
        Thu, 22 Aug 2019 04:57:21 -0700 (PDT)
Received: from [10.1.196.217] (e121566-lin.cambridge.arm.com [10.1.196.217])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 07C2B3F718;
        Thu, 22 Aug 2019 04:57:20 -0700 (PDT)
Subject: Re: [PATCH 00/59] KVM: arm64: ARMv8.3 Nested Virtualization support
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     Marc Zyngier <Marc.Zyngier@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Cc:     Andre Przywara <Andre.Przywara@arm.com>,
        Dave P Martin <Dave.Martin@arm.com>
References: <20190621093843.220980-1-marc.zyngier@arm.com>
 <69cf1fe7-912c-1767-ff1b-dfcc7f549e44@arm.com>
 <0d9aa552-fa01-c482-41d7-587acf308259@arm.com>
Message-ID: <55184c0d-8a8f-ca67-894c-1e738aee262b@arm.com>
Date:   Thu, 22 Aug 2019 12:57:19 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <0d9aa552-fa01-c482-41d7-587acf308259@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/9/19 11:01 AM, Alexandru Elisei wrote:
> On 8/2/19 11:11 AM, Alexandru Elisei wrote:
>> Hi,
>>
>> On 6/21/19 10:37 AM, Marc Zyngier wrote:
>> When working on adding support for EL2 to kvm-unit-tests I was able to trigger
>> the following warning:
>>
>> # ./lkvm run -f psci.flat -m 128 -c 8 --console serial --irqchip gicv3 --nested
>>   # lkvm run --firmware psci.flat -m 128 -c 8 --name guest-151
>>   Info: Placing fdt at 0x80200000 - 0x80210000
>>   # Warning: The maximum recommended amount of VCPUs is 4
>> chr_testdev_init: chr-testdev: can't find a virtio-console
>> INFO: PSCI version 1.0
>> PASS: invalid-function
>> PASS: affinity-info-on
>> PASS: affinity-info-off
>> [   24.381266] WARNING: CPU: 3 PID: 160 at
>> arch/arm64/kvm/../../../virt/kvm/arm/arch_timer.c:170
>> kvm_timer_irq_can_fire+0xc/0x30
>> [   24.381366] Modules linked in:
>> [   24.381466] CPU: 3 PID: 160 Comm: kvm-vcpu-1 Not tainted
>> 5.2.0-rc5-00060-g7dbce63bd1c7 #145
>> [   24.381566] Hardware name: Foundation-v8A (DT)
>> [   24.381566] pstate: 40400009 (nZcv daif +PAN -UAO)
>> [   24.381666] pc : kvm_timer_irq_can_fire+0xc/0x30
>> [   24.381766] lr : timer_emulate+0x24/0x98
>> [   24.381766] sp : ffff000013d8b780
>> [   24.381866] x29: ffff000013d8b780 x28: ffff80087a639b80
>> [   24.381966] x27: ffff000010ba8648 x26: ffff000010b71b40
>> [   24.382066] x25: ffff80087a63a100 x24: 0000000000000000
>> [   24.382111] x23: 000080086ca54000 x22: ffff0000100ce260
>> [   24.382166] x21: ffff800875e7c918 x20: ffff800875e7a800
>> [   24.382275] x19: ffff800875e7ca08 x18: 0000000000000000
>> [   24.382366] x17: 0000000000000000 x16: 0000000000000000
>> [   24.382466] x15: 0000000000000000 x14: 0000000000002118
>> [   24.382566] x13: 0000000000002190 x12: 0000000000002280
>> [   24.382566] x11: 0000000000002208 x10: 0000000000000040
>> [   24.382666] x9 : ffff000012dc3b38 x8 : 0000000000000000
>> [   24.382766] x7 : 0000000000000000 x6 : ffff80087ac00248
>> [   24.382866] x5 : 000080086ca54000 x4 : 0000000000002118
>> [   24.382966] x3 : eeeeeeeeeeeeeeef x2 : ffff800875e7c918
>> [   24.383066] x1 : 0000000000000001 x0 : ffff800875e7ca08
>> [   24.383066] Call trace:
>> [   24.383166]  kvm_timer_irq_can_fire+0xc/0x30
>> [   24.383266]  kvm_timer_vcpu_load+0x9c/0x1a0
>> [   24.383366]  kvm_arch_vcpu_load+0xb0/0x1f0
>> [   24.383366]  kvm_sched_in+0x1c/0x28
>> [   24.383466]  finish_task_switch+0xd8/0x1d8
>> [   24.383566]  __schedule+0x248/0x4a0
>> [   24.383666]  preempt_schedule_irq+0x60/0x90
>> [   24.383666]  el1_irq+0xd0/0x180
>> [   24.383766]  kvm_handle_guest_abort+0x0/0x3a0
>> [   24.383866]  kvm_arch_vcpu_ioctl_run+0x41c/0x688
>> [   24.383866]  kvm_vcpu_ioctl+0x4c0/0x838
>> [   24.383966]  do_vfs_ioctl+0xb8/0x878
>> [   24.384077]  ksys_ioctl+0x84/0x90
>> [   24.384166]  __arm64_sys_ioctl+0x18/0x28
>> [   24.384166]  el0_svc_common.constprop.0+0xb0/0x168
>> [   24.384266]  el0_svc_handler+0x28/0x78
>> [   24.384366]  el0_svc+0x8/0xc
>> [   24.384366] ---[ end trace 37a32293e43ac12c ]---
>> [   24.384666] WARNING: CPU: 3 PID: 160 at
>> arch/arm64/kvm/../../../virt/kvm/arm/arch_timer.c:170
>> kvm_timer_irq_can_fire+0xc/0x30
>> [   24.384766] Modules linked in:
>> [   24.384866] CPU: 3 PID: 160 Comm: kvm-vcpu-1 Tainted: G        W
>> 5.2.0-rc5-00060-g7dbce63bd1c7 #145
>> [   24.384966] Hardware name: Foundation-v8A (DT)
>> [   24.384966] pstate: 40400009 (nZcv daif +PAN -UAO)
>> [   24.385066] pc : kvm_timer_irq_can_fire+0xc/0x30
>> [   24.385166] lr : timer_emulate+0x24/0x98
>> [   24.385166] sp : ffff000013d8b780
>> [   24.385266] x29: ffff000013d8b780 x28: ffff80087a639b80
>> [   24.385366] x27: ffff000010ba8648 x26: ffff000010b71b40
>> [   24.385466] x25: ffff80087a63a100 x24: 0000000000000000
>> [   24.385466] x23: 000080086ca54000 x22: ffff0000100ce260
>> [   24.385566] x21: ffff800875e7c918 x20: ffff800875e7a800
>> [   24.385666] x19: ffff800875e7ca80 x18: 0000000000000000
>> [   24.385766] x17: 0000000000000000 x16: 0000000000000000
>> [   24.385866] x15: 0000000000000000 x14: 0000000000002118
>> [   24.385966] x13: 0000000000002190 x12: 0000000000002280
>> [   24.385966] x11: 0000000000002208 x10: 0000000000000040
>> [   24.386066] x9 : ffff000012dc3b38 x8 : 0000000000000000
>> [   24.386166] x7 : 0000000000000000 x6 : ffff80087ac00248
>> [   24.386266] x5 : 000080086ca54000 x4 : 0000000000002118
>> [   24.386366] x3 : eeeeeeeeeeeeeeef x2 : ffff800875e7c918
>> [   24.386466] x1 : 0000000000000001 x0 : ffff800875e7ca80
>> [   24.386466] Call trace:
>> [   24.386566]  kvm_timer_irq_can_fire+0xc/0x30
>> [   24.386666]  kvm_timer_vcpu_load+0xa8/0x1a0
>> [   24.386666]  kvm_arch_vcpu_load+0xb0/0x1f0
>> [   24.386898]  kvm_sched_in+0x1c/0x28
>> [   24.386966]  finish_task_switch+0xd8/0x1d8
>> [   24.387166]  __schedule+0x248/0x4a0
>> [   24.387354]  preempt_schedule_irq+0x60/0x90
>> [   24.387366]  el1_irq+0xd0/0x180
>> [   24.387466]  kvm_handle_guest_abort+0x0/0x3a0
>> [   24.387566]  kvm_arch_vcpu_ioctl_run+0x41c/0x688
>> [   24.387566]  kvm_vcpu_ioctl+0x4c0/0x838
>> [   24.387666]  do_vfs_ioctl+0xb8/0x878
>> [   24.387766]  ksys_ioctl+0x84/0x90
>> [   24.387866]  __arm64_sys_ioctl+0x18/0x28
>> [   24.387866]  el0_svc_common.constprop.0+0xb0/0x168
>> [   24.387966]  el0_svc_handler+0x28/0x78
>> [   24.388066]  el0_svc+0x8/0xc
>> [   24.388066] ---[ end trace 37a32293e43ac12d ]---
>> PASS: cpu-on
>> SUMMARY: 4 te[   24.390266] WARNING: CPU: 3 PID: 160 at
>> arch/arm64/kvm/../../../virt/kvm/arm/arch_timer.c:170
>> kvm_timer_irq_can_fire+0xc/0x30
>> s[   24.390366] Modules linked in:
>> ts[   24.390366] CPU: 3 PID: 160 Comm: kvm-vcpu-1 Tainted: G        W
>> 5.2.0-rc5-00060-g7dbce63bd1c7 #145
>> [   24.390566] Hardware name: Foundation-v8A (DT)
>>
>> [   24.390795] pstate: 40400009 (nZcv daif +PAN -UAO)
>> [   24.390866] pc : kvm_timer_irq_can_fire+0xc/0x30
>> [   24.390966] lr : timer_emulate+0x24/0x98
>> [   24.391066] sp : ffff000013d8b780
>> [   24.391066] x29: ffff000013d8b780 x28: ffff80087a639b80
>> [   24.391166] x27: ffff000010ba8648 x26: ffff000010b71b40
>> [   24.391266] x25: ffff80087a63a100 x24: 0000000000000000
>> [   24.391366] x23: 000080086ca54000 x22: 0000000000000003
>> [   24.391466] x21: ffff800875e7c918 x20: ffff800875e7a800
>> [   24.391466] x19: ffff800875e7ca08 x18: 0000000000000000
>> [   24.391566] x17: 0000000000000000 x16: 0000000000000000
>> [   24.391666] x15: 0000000000000000 x14: 0000000000002118
>> [   24.391766] x13: 0000000000002190 x12: 0000000000002280
>> [   24.391866] x11: 0000000000002208 x10: 0000000000000040
>> [   24.391942] x9 : ffff000012dc3b38 x8 : 0000000000000000
>> [   24.391966] x7 : 0000000000000000 x6 : ffff80087ac00248
>> [   24.392066] x5 : 000080086ca54000 x4 : 0000000000002118
>> [   24.392166] x3 : eeeeeeeeeeeeeeef x2 : ffff800875e7c918
>> [   24.392269] x1 : 0000000000000001 x0 : ffff800875e7ca08
>> [   24.392366] Call trace:
>> [   24.392433]  kvm_timer_irq_can_fire+0xc/0x30
>> [   24.392466]  kvm_timer_vcpu_load+0x9c/0x1a0
>> [   24.392597]  kvm_arch_vcpu_load+0xb0/0x1f0
>> [   24.392666]  kvm_sched_in+0x1c/0x28
>> [   24.392766]  finish_task_switch+0xd8/0x1d8
>> [   24.392766]  __schedule+0x248/0x4a0
>> [   24.392866]  preempt_schedule_irq+0x60/0x90
>> [   24.392966]  el1_irq+0xd0/0x180
>> [   24.392966]  kvm_handle_guest_abort+0x0/0x3a0
>> [   24.393066]  kvm_arch_vcpu_ioctl_run+0x41c/0x688
>> [   24.393166]  kvm_vcpu_ioctl+0x4c0/0x838
>> [   24.393266]  do_vfs_ioctl+0xb8/0x878
>> [   24.393266]  ksys_ioctl+0x84/0x90
>> [   24.393366]  __arm64_sys_ioctl+0x18/0x28
>> [   24.393466]  el0_svc_common.constprop.0+0xb0/0x168
>> [   24.393566]  el0_svc_handler+0x28/0x78
>> [   24.393566]  el0_svc+0x8/0xc
>> [   24.393666] ---[ end trace 37a32293e43ac12e ]---
>> [   24.393866] WARNING: CPU: 3 PID: 160 at
>> arch/arm64/kvm/../../../virt/kvm/arm/arch_timer.c:170
>> kvm_timer_irq_can_fire+0xc/0x30
>> [   24.394066] Modules linked in:
>> [   24.394266] CPU: 3 PID: 160 Comm: kvm-vcpu-1 Tainted: G        W
>> 5.2.0-rc5-00060-g7dbce63bd1c7 #145
>> [   24.394366] Hardware name: Foundation-v8A (DT)
>> [   24.394466] pstate: 40400009 (nZcv daif +PAN -UAO)
>> [   24.394466] pc : kvm_timer_irq_can_fire+0xc/0x30
>> [   24.394566] lr : timer_emulate+0x24/0x98
>> [   24.394666] sp : ffff000013d8b780
>> [   24.394727] x29: ffff000013d8b780 x28: ffff80087a639b80
>> [   24.394766] x27: ffff000010ba8648 x26: ffff000010b71b40
>> [   24.394866] x25: ffff80087a63a100 x24: 0000000000000000
>> [   24.394966] x23: 000080086ca54000 x22: 0000000000000003
>> [   24.394966] x21: ffff800875e7c918 x20: ffff800875e7a800
>> [   24.395066] x19: ffff800875e7ca80 x18: 0000000000000000
>> [   24.395166] x17: 0000000000000000 x16: 0000000000000000
>> [   24.395266] x15: 0000000000000000 x14: 0000000000002118
>> [   24.395383] x13: 0000000000002190 x12: 0000000000002280
>> [   24.395466] x11: 0000000000002208 x10: 0000000000000040
>> [   24.395547] x9 : ffff000012dc3b38 x8 : 0000000000000000
>> [   24.395666] x7 : 0000000000000000 x6 : ffff80087ac00248
>> [   24.395866] x5 : 000080086ca54000 x4 : 0000000000002118
>> [   24.395966] x3 : eeeeeeeeeeeeeeef x2 : ffff800875e7c918
>> [   24.396066] x1 : 0000000000000001 x0 : ffff800875e7ca80
>> [   24.396066] Call trace:
>> [   24.396166]  kvm_timer_irq_can_fire+0xc/0x30
>> [   24.396266]  kvm_timer_vcpu_load+0xa8/0x1a0
>> [   24.396366]  kvm_arch_vcpu_load+0xb0/0x1f0
>> [   24.396366]  kvm_sched_in+0x1c/0x28
>> [   24.396466]  finish_task_switch+0xd8/0x1d8
>> [   24.396566]  __schedule+0x248/0x4a0
>> [   24.396666]  preempt_schedule_irq+0x60/0x90
>> [   24.396666]  el1_irq+0xd0/0x180
>> [   24.396766]  kvm_handle_guest_abort+0x0/0x3a0
>> [   24.396866]  kvm_arch_vcpu_ioctl_run+0x41c/0x688
>> [   24.396866]  kvm_vcpu_ioctl+0x4c0/0x838
>> [   24.397021]  do_vfs_ioctl+0xb8/0x878
>> [   24.397066]  ksys_ioctl+0x84/0x90
>> [   24.397166]  __arm64_sys_ioctl+0x18/0x28
>> [   24.397348]  el0_svc_common.constprop.0+0xb0/0x168
>> [   24.397366]  el0_svc_handler+0x28/0x78
>> [   24.397566]  el0_svc+0x8/0xc
>> [   24.397676] ---[ end trace 37a32293e43ac12f ]---
>>
>>   # KVM compatibility warning.
>>     virtio-9p device was not detected.
>>     While you have requested a virtio-9p device, the guest kernel did not
>> initialize it.
>>     Please make sure that the guest kernel was compiled with
>> CONFIG_NET_9P_VIRTIO=y enabled in .config.
>>
>>   # KVM compatibility warning.
>>     virtio-net device was not detected.
>>     While you have requested a virtio-net device, the guest kernel did not
>> initialize it.
>>     Please make sure that the guest kernel was compiled with CONFIG_VIRTIO_NET=y
>> enabled in .config.
>>
>> [..]
> Did some investigating and this was caused by a bug in kvm-unit-tests (the fix
> for it will be part of the EL2 patches for kvm-unit-tests). The guest was trying
> to fetch an instruction from address 0x200, which KVM interprets as a prefetch
> abort on an I/O address and ends up calling kvm_inject_pabt. The code from
> arch/arm64/kvm/inject_fault.c doesn't know anything about nested virtualization,
> and it sets the VCPU mode directly to PSR_MODE_EL1h. This makes_hyp_ctxt return
> false, and get_timer_map will return an incorrect mapping.
>
> On next kvm_timer_vcpu_put, the direct timers will be {p,v}timer, and
> h{p,v}timer->loaded will not be set to false. In the corresponding call to
> kvm_timer_vcpu_load, KVM will try to emulate the hptimer and hvtimer, which
> still have loaded = true. And this causes the warning I saw.

I tried to fix it with the following patch, inject_undef64 was similarly broken:

diff --git a/arch/arm64/kvm/inject_fault.c b/arch/arm64/kvm/inject_fault.c
index fac962b467bd..aee8a9ef36d5 100644
--- a/arch/arm64/kvm/inject_fault.c
+++ b/arch/arm64/kvm/inject_fault.c
@@ -53,15 +53,7 @@ static void inject_abt64(struct kvm_vcpu *vcpu, bool is_iabt,
unsigned long addr
 {
     unsigned long cpsr = *vcpu_cpsr(vcpu);
     bool is_aarch32 = vcpu_mode_is_32bit(vcpu);
-    u32 esr = 0;
-
-    vcpu_write_elr_el1(vcpu, *vcpu_pc(vcpu));
-    *vcpu_pc(vcpu) = get_except_vector(vcpu, except_type_sync);
-
-    *vcpu_cpsr(vcpu) = PSTATE_FAULT_BITS_64;
-    vcpu_write_spsr(vcpu, cpsr);
-
-    vcpu_write_sys_reg(vcpu, addr, FAR_EL1);
+    u32 esr = ESR_ELx_FSC_EXTABT;
 
     /*
      * Build an {i,d}abort, depending on the level and the
@@ -82,13 +74,12 @@ static void inject_abt64(struct kvm_vcpu *vcpu, bool
is_iabt, unsigned long addr
     if (!is_iabt)
         esr |= ESR_ELx_EC_DABT_LOW << ESR_ELx_EC_SHIFT;
 
-    vcpu_write_sys_reg(vcpu, esr | ESR_ELx_FSC_EXTABT, ESR_EL1);
-}
+    if (nested_virt_in_use(vcpu)) {
+        kvm_inject_nested_sync(vcpu, esr);
+        return;
+    }
 
-static void inject_undef64(struct kvm_vcpu *vcpu)
-{
-    unsigned long cpsr = *vcpu_cpsr(vcpu);
-    u32 esr = (ESR_ELx_EC_UNKNOWN << ESR_ELx_EC_SHIFT);
+    vcpu_write_sys_reg(vcpu, esr, ESR_EL1);
 
     vcpu_write_elr_el1(vcpu, *vcpu_pc(vcpu));
     *vcpu_pc(vcpu) = get_except_vector(vcpu, except_type_sync);
@@ -96,6 +87,14 @@ static void inject_undef64(struct kvm_vcpu *vcpu)
     *vcpu_cpsr(vcpu) = PSTATE_FAULT_BITS_64;
     vcpu_write_spsr(vcpu, cpsr);
 
+    vcpu_write_sys_reg(vcpu, addr, FAR_EL1);
+}
+
+static void inject_undef64(struct kvm_vcpu *vcpu)
+{
+    unsigned long cpsr = *vcpu_cpsr(vcpu);
+    u32 esr = ESR_ELx_EC_UNKNOWN << ESR_ELx_EC_SHIFT;
+
     /*
      * Build an unknown exception, depending on the instruction
      * set.
@@ -103,7 +102,18 @@ static void inject_undef64(struct kvm_vcpu *vcpu)
     if (kvm_vcpu_trap_il_is32bit(vcpu))
         esr |= ESR_ELx_IL;
 
+    if (nested_virt_in_use(vcpu)) {
+        kvm_inject_nested_sync(vcpu, esr);
+        return;
+    }
+
     vcpu_write_sys_reg(vcpu, esr, ESR_EL1);
+
+    vcpu_write_elr_el1(vcpu, *vcpu_pc(vcpu));
+    *vcpu_pc(vcpu) = get_except_vector(vcpu, except_type_sync);
+
+    *vcpu_cpsr(vcpu) = PSTATE_FAULT_BITS_64;
+    vcpu_write_spsr(vcpu, cpsr);
 }
 
 /**

