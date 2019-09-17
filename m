Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CEDD7B48E6
	for <lists+kvm@lfdr.de>; Tue, 17 Sep 2019 10:12:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388047AbfIQIMq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Sep 2019 04:12:46 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:35340 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728802AbfIQIMq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Sep 2019 04:12:46 -0400
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 0C3B6269A6DB47ECD602;
        Tue, 17 Sep 2019 16:12:43 +0800 (CST)
Received: from [127.0.0.1] (10.184.12.158) by DGGEMS414-HUB.china.huawei.com
 (10.3.19.214) with Microsoft SMTP Server id 14.3.439.0; Tue, 17 Sep 2019
 16:12:36 +0800
Subject: Re: [PATCH] KVM: arm64: vgic-v4: Move the GICv4 residency flow to be
 driven by vcpu_load/put
To:     Marc Zyngier <maz@kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <kvmarm@lists.cs.columbia.edu>, <kvm@vger.kernel.org>
CC:     Andre Przywara <Andre.Przywara@arm.com>
References: <20190903155747.219802-1-maz@kernel.org>
From:   Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <5ab75fec-6014-e3b4-92a3-63d5015814c1@huawei.com>
Date:   Tue, 17 Sep 2019 16:10:39 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:64.0) Gecko/20100101
 Thunderbird/64.0
MIME-Version: 1.0
In-Reply-To: <20190903155747.219802-1-maz@kernel.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.184.12.158]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

I've run this patch on my box and got the following messages:

---8<

[ 2258.490030] BUG: sleeping function called from invalid context at 
kernel/irq/manage.c:138
[ 2258.490034] in_atomic(): 1, irqs_disabled(): 0, pid: 59278, name: CPU 
0/KVM
[ 2258.490039] CPU: 32 PID: 59278 Comm: CPU 0/KVM Kdump: loaded Tainted: 
G        W         5.3.0+ #26
[ 2258.490041] Hardware name: Huawei TaiShan 2280 /BC11SPCD, BIOS 1.58 
10/29/2018
[ 2258.490043] Call trace:
[ 2258.490056]  dump_backtrace+0x0/0x188
[ 2258.490060]  show_stack+0x24/0x30
[ 2258.490066]  dump_stack+0xb0/0xf4
[ 2258.490072]  ___might_sleep+0x10c/0x130
[ 2258.490074]  __might_sleep+0x58/0x90
[ 2258.490078]  synchronize_irq+0x58/0xd8
[ 2258.490079]  disable_irq+0x2c/0x38
[ 2258.490083]  vgic_v4_load+0x9c/0xc0
[ 2258.490084]  vgic_v3_load+0x94/0x170
[ 2258.490088]  kvm_vgic_load+0x3c/0x60
[ 2258.490092]  kvm_arch_vcpu_load+0xd4/0x1d0
[ 2258.490095]  vcpu_load+0x50/0x70
[ 2258.490097]  kvm_arch_vcpu_ioctl_run+0x94/0x978
[ 2258.490098]  kvm_vcpu_ioctl+0x3d8/0xa28
[ 2258.490104]  do_vfs_ioctl+0xc4/0x8e8
[ 2258.490106]  ksys_ioctl+0x8c/0xa0
[ 2258.490108]  __arm64_sys_ioctl+0x28/0x58
[ 2258.490112]  el0_svc_common.constprop.0+0x7c/0x188
[ 2258.490114]  el0_svc_handler+0x34/0xb8
[ 2258.490117]  el0_svc+0x8/0xc
[ 2259.497070] BUG: sleeping function called from invalid context at 
kernel/irq/manage.c:138
[ 2259.497077] in_atomic(): 1, irqs_disabled(): 0, pid: 59278, name: CPU 
0/KVM
[ 2259.497082] CPU: 33 PID: 59278 Comm: CPU 0/KVM Kdump: loaded Tainted: 
G        W         5.3.0+ #26
[ 2259.497083] Hardware name: Huawei TaiShan 2280 /BC11SPCD, BIOS 1.58 
10/29/2018
[ 2259.497086] Call trace:
[ 2259.497098]  dump_backtrace+0x0/0x188
[ 2259.497101]  show_stack+0x24/0x30
[ 2259.497109]  dump_stack+0xb0/0xf4
[ 2259.497115]  ___might_sleep+0x10c/0x130
[ 2259.497117]  __might_sleep+0x58/0x90
[ 2259.497120]  synchronize_irq+0x58/0xd8
[ 2259.497122]  disable_irq+0x2c/0x38
[ 2259.497126]  vgic_v4_load+0x9c/0xc0
[ 2259.497127]  vgic_v3_load+0x94/0x170
[ 2259.497130]  kvm_vgic_load+0x3c/0x60
[ 2259.497134]  kvm_arch_vcpu_load+0xd4/0x1d0
[ 2259.497137]  kvm_sched_in+0x30/0x40
[ 2259.497139]  finish_task_switch+0x134/0x258
[ 2259.497142]  __schedule+0x33c/0x780
[ 2259.497144]  schedule+0x48/0xd8
[ 2259.497147]  kvm_vcpu_block+0xb8/0x390
[ 2259.497148]  kvm_handle_wfx+0xa0/0x230
[ 2259.497150]  handle_exit+0x14c/0x1c8
[ 2259.497152]  kvm_arch_vcpu_ioctl_run+0x354/0x978
[ 2259.497154]  kvm_vcpu_ioctl+0x3d8/0xa28
[ 2259.497161]  do_vfs_ioctl+0xc4/0x8e8
[ 2259.497163]  ksys_ioctl+0x8c/0xa0
[ 2259.497165]  __arm64_sys_ioctl+0x28/0x58
[ 2259.497168]  el0_svc_common.constprop.0+0x7c/0x188
[ 2259.497171]  el0_svc_handler+0x34/0xb8
[ 2259.497175]  el0_svc+0x8/0xc


The logic of disabling the doorbell interrupt in vgic_v4_load() might
need a fix?


Thanks,
zenghui

On 2019/9/3 23:57, Marc Zyngier wrote:
> When the VHE code was reworked, a lot of the vgic stuff was moved around,
> but the GICv4 residency code did stay untouched, meaning that we come
> in and out of residency on each flush/sync, which is obviously suboptimal.
> 
> To address this, let's move things around a bit:
> 
> - Residency entry (flush) moves to vcpu_load
> - Residency exit (sync) moves to vcpu_put
> - On blocking (entry to WFI), we "put"
> - On unblocking (exit from WFI, we "load"
> 
> Because these can nest (load/block/put/load/unblock/put, for example),
> we now have per-VPE tracking of the residency state.
> 
> Additionally, vgic_v4_put gains a "need doorbell" parameter, which only
> gets set to true when blocking because of a WFI. This allows a finer
> control of the doorbell, which now also gets disabled as soon as
> it gets signaled.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>   drivers/irqchip/irq-gic-v4.c       |  7 +++-
>   include/kvm/arm_vgic.h             |  4 +--
>   include/linux/irqchip/arm-gic-v4.h |  2 ++
>   virt/kvm/arm/arm.c                 | 12 ++++---
>   virt/kvm/arm/vgic/vgic-v3.c        |  4 +++
>   virt/kvm/arm/vgic/vgic-v4.c        | 55 ++++++++++++++----------------
>   virt/kvm/arm/vgic/vgic.c           |  4 ---
>   virt/kvm/arm/vgic/vgic.h           |  2 --
>   8 files changed, 48 insertions(+), 42 deletions(-)
> 
> diff --git a/drivers/irqchip/irq-gic-v4.c b/drivers/irqchip/irq-gic-v4.c
> index 563e87ed0766..45969927cc81 100644
> --- a/drivers/irqchip/irq-gic-v4.c
> +++ b/drivers/irqchip/irq-gic-v4.c
> @@ -141,12 +141,17 @@ static int its_send_vpe_cmd(struct its_vpe *vpe, struct its_cmd_info *info)
>   int its_schedule_vpe(struct its_vpe *vpe, bool on)
>   {
>   	struct its_cmd_info info;
> +	int ret;
>   
>   	WARN_ON(preemptible());
>   
>   	info.cmd_type = on ? SCHEDULE_VPE : DESCHEDULE_VPE;
>   
> -	return its_send_vpe_cmd(vpe, &info);
> +	ret = its_send_vpe_cmd(vpe, &info);
> +	if (!ret)
> +		vpe->resident = on;
> +
> +	return ret;
>   }
>   
>   int its_invall_vpe(struct its_vpe *vpe)
> diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
> index af4f09c02bf1..4dc58d7a0010 100644
> --- a/include/kvm/arm_vgic.h
> +++ b/include/kvm/arm_vgic.h
> @@ -396,7 +396,7 @@ int kvm_vgic_v4_set_forwarding(struct kvm *kvm, int irq,
>   int kvm_vgic_v4_unset_forwarding(struct kvm *kvm, int irq,
>   				 struct kvm_kernel_irq_routing_entry *irq_entry);
>   
> -void kvm_vgic_v4_enable_doorbell(struct kvm_vcpu *vcpu);
> -void kvm_vgic_v4_disable_doorbell(struct kvm_vcpu *vcpu);
> +int vgic_v4_load(struct kvm_vcpu *vcpu);
> +int vgic_v4_put(struct kvm_vcpu *vcpu, bool need_db);
>   
>   #endif /* __KVM_ARM_VGIC_H */
> diff --git a/include/linux/irqchip/arm-gic-v4.h b/include/linux/irqchip/arm-gic-v4.h
> index e6b155713b47..ab1396afe08a 100644
> --- a/include/linux/irqchip/arm-gic-v4.h
> +++ b/include/linux/irqchip/arm-gic-v4.h
> @@ -35,6 +35,8 @@ struct its_vpe {
>   	/* Doorbell interrupt */
>   	int			irq;
>   	irq_hw_number_t		vpe_db_lpi;
> +	/* VPE resident */
> +	bool			resident;
>   	/* VPE proxy mapping */
>   	int			vpe_proxy_event;
>   	/*
> diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
> index 35a069815baf..4e69268621b6 100644
> --- a/virt/kvm/arm/arm.c
> +++ b/virt/kvm/arm/arm.c
> @@ -321,20 +321,24 @@ void kvm_arch_vcpu_blocking(struct kvm_vcpu *vcpu)
>   	/*
>   	 * If we're about to block (most likely because we've just hit a
>   	 * WFI), we need to sync back the state of the GIC CPU interface
> -	 * so that we have the lastest PMR and group enables. This ensures
> +	 * so that we have the latest PMR and group enables. This ensures
>   	 * that kvm_arch_vcpu_runnable has up-to-date data to decide
>   	 * whether we have pending interrupts.
> +	 *
> +	 * For the same reason, we want to tell GICv4 that we need
> +	 * doorbells to be signalled, should an interrupt become pending.
>   	 */
>   	preempt_disable();
>   	kvm_vgic_vmcr_sync(vcpu);
> +	vgic_v4_put(vcpu, true);
>   	preempt_enable();
> -
> -	kvm_vgic_v4_enable_doorbell(vcpu);
>   }
>   
>   void kvm_arch_vcpu_unblocking(struct kvm_vcpu *vcpu)
>   {
> -	kvm_vgic_v4_disable_doorbell(vcpu);
> +	preempt_disable();
> +	vgic_v4_load(vcpu);
> +	preempt_enable();
>   }
>   
>   int kvm_arch_vcpu_init(struct kvm_vcpu *vcpu)
> diff --git a/virt/kvm/arm/vgic/vgic-v3.c b/virt/kvm/arm/vgic/vgic-v3.c
> index 8d69f007dd0c..48307a9eb1d8 100644
> --- a/virt/kvm/arm/vgic/vgic-v3.c
> +++ b/virt/kvm/arm/vgic/vgic-v3.c
> @@ -664,6 +664,8 @@ void vgic_v3_load(struct kvm_vcpu *vcpu)
>   
>   	if (has_vhe())
>   		__vgic_v3_activate_traps(vcpu);
> +
> +	WARN_ON(vgic_v4_load(vcpu));
>   }
>   
>   void vgic_v3_vmcr_sync(struct kvm_vcpu *vcpu)
> @@ -676,6 +678,8 @@ void vgic_v3_vmcr_sync(struct kvm_vcpu *vcpu)
>   
>   void vgic_v3_put(struct kvm_vcpu *vcpu)
>   {
> +	WARN_ON(vgic_v4_put(vcpu, false));
> +
>   	vgic_v3_vmcr_sync(vcpu);
>   
>   	kvm_call_hyp(__vgic_v3_save_aprs, vcpu);
> diff --git a/virt/kvm/arm/vgic/vgic-v4.c b/virt/kvm/arm/vgic/vgic-v4.c
> index 477af6aebb97..3a8a28854b13 100644
> --- a/virt/kvm/arm/vgic/vgic-v4.c
> +++ b/virt/kvm/arm/vgic/vgic-v4.c
> @@ -85,6 +85,10 @@ static irqreturn_t vgic_v4_doorbell_handler(int irq, void *info)
>   {
>   	struct kvm_vcpu *vcpu = info;
>   
> +	/* We got the message, no need to fire again */
> +	if (!irqd_irq_disabled(&irq_to_desc(irq)->irq_data))
> +		disable_irq_nosync(irq);
> +
>   	vcpu->arch.vgic_cpu.vgic_v3.its_vpe.pending_last = true;
>   	kvm_make_request(KVM_REQ_IRQ_PENDING, vcpu);
>   	kvm_vcpu_kick(vcpu);
> @@ -192,20 +196,30 @@ void vgic_v4_teardown(struct kvm *kvm)
>   	its_vm->vpes = NULL;
>   }
>   
> -int vgic_v4_sync_hwstate(struct kvm_vcpu *vcpu)
> +int vgic_v4_put(struct kvm_vcpu *vcpu, bool need_db)
>   {
> -	if (!vgic_supports_direct_msis(vcpu->kvm))
> +	struct its_vpe *vpe = &vcpu->arch.vgic_cpu.vgic_v3.its_vpe;
> +	struct irq_desc *desc = irq_to_desc(vpe->irq);
> +
> +	if (!vgic_supports_direct_msis(vcpu->kvm) || !vpe->resident)
>   		return 0;
>   
> -	return its_schedule_vpe(&vcpu->arch.vgic_cpu.vgic_v3.its_vpe, false);
> +	/*
> +	 * If blocking, a doorbell is required. Undo the nested
> +	 * disable_irq() calls...
> +	 */
> +	while (need_db && irqd_irq_disabled(&desc->irq_data))
> +		enable_irq(vpe->irq);
> +
> +	return its_schedule_vpe(vpe, false);
>   }
>   
> -int vgic_v4_flush_hwstate(struct kvm_vcpu *vcpu)
> +int vgic_v4_load(struct kvm_vcpu *vcpu)
>   {
> -	int irq = vcpu->arch.vgic_cpu.vgic_v3.its_vpe.irq;
> +	struct its_vpe *vpe = &vcpu->arch.vgic_cpu.vgic_v3.its_vpe;
>   	int err;
>   
> -	if (!vgic_supports_direct_msis(vcpu->kvm))
> +	if (!vgic_supports_direct_msis(vcpu->kvm) || vpe->resident)
>   		return 0;
>   
>   	/*
> @@ -214,11 +228,14 @@ int vgic_v4_flush_hwstate(struct kvm_vcpu *vcpu)
>   	 * doc in drivers/irqchip/irq-gic-v4.c to understand how this
>   	 * turns into a VMOVP command at the ITS level.
>   	 */
> -	err = irq_set_affinity(irq, cpumask_of(smp_processor_id()));
> +	err = irq_set_affinity(vpe->irq, cpumask_of(smp_processor_id()));
>   	if (err)
>   		return err;
>   
> -	err = its_schedule_vpe(&vcpu->arch.vgic_cpu.vgic_v3.its_vpe, true);
> +	/* Disabled the doorbell, as we're about to enter the guest */
> +	disable_irq(vpe->irq);
> +
> +	err = its_schedule_vpe(vpe, true);
>   	if (err)
>   		return err;
>   
> @@ -226,9 +243,7 @@ int vgic_v4_flush_hwstate(struct kvm_vcpu *vcpu)
>   	 * Now that the VPE is resident, let's get rid of a potential
>   	 * doorbell interrupt that would still be pending.
>   	 */
> -	err = irq_set_irqchip_state(irq, IRQCHIP_STATE_PENDING, false);
> -
> -	return err;
> +	return irq_set_irqchip_state(vpe->irq, IRQCHIP_STATE_PENDING, false);
>   }
>   
>   static struct vgic_its *vgic_get_its(struct kvm *kvm,
> @@ -335,21 +350,3 @@ int kvm_vgic_v4_unset_forwarding(struct kvm *kvm, int virq,
>   	mutex_unlock(&its->its_lock);
>   	return ret;
>   }
> -
> -void kvm_vgic_v4_enable_doorbell(struct kvm_vcpu *vcpu)
> -{
> -	if (vgic_supports_direct_msis(vcpu->kvm)) {
> -		int irq = vcpu->arch.vgic_cpu.vgic_v3.its_vpe.irq;
> -		if (irq)
> -			enable_irq(irq);
> -	}
> -}
> -
> -void kvm_vgic_v4_disable_doorbell(struct kvm_vcpu *vcpu)
> -{
> -	if (vgic_supports_direct_msis(vcpu->kvm)) {
> -		int irq = vcpu->arch.vgic_cpu.vgic_v3.its_vpe.irq;
> -		if (irq)
> -			disable_irq(irq);
> -	}
> -}
> diff --git a/virt/kvm/arm/vgic/vgic.c b/virt/kvm/arm/vgic/vgic.c
> index 45a870cb63f5..99b02ca730a8 100644
> --- a/virt/kvm/arm/vgic/vgic.c
> +++ b/virt/kvm/arm/vgic/vgic.c
> @@ -857,8 +857,6 @@ void kvm_vgic_sync_hwstate(struct kvm_vcpu *vcpu)
>   {
>   	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
>   
> -	WARN_ON(vgic_v4_sync_hwstate(vcpu));
> -
>   	/* An empty ap_list_head implies used_lrs == 0 */
>   	if (list_empty(&vcpu->arch.vgic_cpu.ap_list_head))
>   		return;
> @@ -882,8 +880,6 @@ static inline void vgic_restore_state(struct kvm_vcpu *vcpu)
>   /* Flush our emulation state into the GIC hardware before entering the guest. */
>   void kvm_vgic_flush_hwstate(struct kvm_vcpu *vcpu)
>   {
> -	WARN_ON(vgic_v4_flush_hwstate(vcpu));
> -
>   	/*
>   	 * If there are no virtual interrupts active or pending for this
>   	 * VCPU, then there is no work to do and we can bail out without
> diff --git a/virt/kvm/arm/vgic/vgic.h b/virt/kvm/arm/vgic/vgic.h
> index 83066a81b16a..c7fefd6b1c80 100644
> --- a/virt/kvm/arm/vgic/vgic.h
> +++ b/virt/kvm/arm/vgic/vgic.h
> @@ -316,7 +316,5 @@ void vgic_its_invalidate_cache(struct kvm *kvm);
>   bool vgic_supports_direct_msis(struct kvm *kvm);
>   int vgic_v4_init(struct kvm *kvm);
>   void vgic_v4_teardown(struct kvm *kvm);
> -int vgic_v4_sync_hwstate(struct kvm_vcpu *vcpu);
> -int vgic_v4_flush_hwstate(struct kvm_vcpu *vcpu);
>   
>   #endif
> 

