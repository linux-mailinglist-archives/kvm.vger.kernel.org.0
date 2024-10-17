Return-Path: <kvm+bounces-29062-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6FD149A22E9
	for <lists+kvm@lfdr.de>; Thu, 17 Oct 2024 15:01:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 38854282C30
	for <lists+kvm@lfdr.de>; Thu, 17 Oct 2024 13:01:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE6F91DDA15;
	Thu, 17 Oct 2024 13:01:05 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5FAA41E535;
	Thu, 17 Oct 2024 13:01:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729170065; cv=none; b=RtL1OjfjBnEwl3oU5I9dbMaXTLGbqzg1lkP93Owrs9+JTg4DfV5/IfHbrjWfxB5MF5DyaedmEBTeF3yIQqD6rHGNXZpxWCSY6o38Q3DD2rcxL3pnWaoW4CIRIwQeZz8EfMa5+k70N7hHWIKoMrfpJoMNxs1A2N3qEuu3iqvZD9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729170065; c=relaxed/simple;
	bh=6mQCc5n8ciq65YegNIO/eQiZWDVvzdfuSQNbE3WVN6s=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VsxBxSt8xEsEM0QltfjIVAIJI9PQpo74e+KBypt+eeo/ahxiYOvC8E7hyg/t/j7FdWSaKpFLT4+zpwQN5392zkjOuhVFkF0uWm3remqhXtC/AZUfizEPFACOj865LAZCZtq5QjkuyYqBNlR8qjh185QRE4K/sKa233DUUrVpwvk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6172CFEC;
	Thu, 17 Oct 2024 06:01:31 -0700 (PDT)
Received: from [10.57.22.188] (unknown [10.57.22.188])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 76E303F71E;
	Thu, 17 Oct 2024 06:00:58 -0700 (PDT)
Message-ID: <c44aeac6-4fe1-4199-962d-5fbbc5a591de@arm.com>
Date: Thu, 17 Oct 2024 14:00:57 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 18/43] arm64: RME: Handle realm enter/exit
Content-Language: en-GB
To: Steven Price <steven.price@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu <yuzenghui@huawei.com>,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 Joey Gouly <joey.gouly@arm.com>, Alexandru Elisei
 <alexandru.elisei@arm.com>, Christoffer Dall <christoffer.dall@arm.com>,
 Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Gavin Shan <gshan@redhat.com>, Shanker Donthineni <sdonthineni@nvidia.com>,
 Alper Gun <alpergun@google.com>, "Aneesh Kumar K . V"
 <aneesh.kumar@kernel.org>
References: <20241004152804.72508-1-steven.price@arm.com>
 <20241004152804.72508-19-steven.price@arm.com>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <20241004152804.72508-19-steven.price@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 04/10/2024 16:27, Steven Price wrote:
> Entering a realm is done using a SMC call to the RMM. On exit the
> exit-codes need to be handled slightly differently to the normal KVM
> path so define our own functions for realm enter/exit and hook them
> in if the guest is a realm guest.
> 
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
> Changes since v4:
>   * Rename handle_rme_exit() to handle_rec_exit()
>   * Move the loop to copy registers into the REC enter structure from the
>     to rec_exit_handlers callbacks to kvm_rec_enter(). This fixes a bug
>     where the handler exits to user space and user space wants to modify
>     the GPRS.
>   * Some code rearrangement in rec_exit_ripas_change().
> Changes since v2:
>   * realm_set_ipa_state() now provides an output parameter for the
>     top_iap that was changed. Use this to signal the VMM with the correct
>     range that has been transitioned.
>   * Adapt to previous patch changes.
> ---
>   arch/arm64/include/asm/kvm_rme.h |   3 +
>   arch/arm64/kvm/Makefile          |   2 +-
>   arch/arm64/kvm/arm.c             |  19 +++-
>   arch/arm64/kvm/rme-exit.c        | 179 +++++++++++++++++++++++++++++++
>   arch/arm64/kvm/rme.c             |  19 ++++
>   5 files changed, 216 insertions(+), 6 deletions(-)
>   create mode 100644 arch/arm64/kvm/rme-exit.c
> 
> diff --git a/arch/arm64/include/asm/kvm_rme.h b/arch/arm64/include/asm/kvm_rme.h
> index c064bfb080ad..889fe120283a 100644
> --- a/arch/arm64/include/asm/kvm_rme.h
> +++ b/arch/arm64/include/asm/kvm_rme.h
> @@ -96,6 +96,9 @@ void kvm_realm_destroy_rtts(struct kvm *kvm, u32 ia_bits);
>   int kvm_create_rec(struct kvm_vcpu *vcpu);
>   void kvm_destroy_rec(struct kvm_vcpu *vcpu);
>   
> +int kvm_rec_enter(struct kvm_vcpu *vcpu);
> +int handle_rec_exit(struct kvm_vcpu *vcpu, int rec_run_status);
> +
>   void kvm_realm_unmap_range(struct kvm *kvm,
>   			   unsigned long ipa,
>   			   u64 size,
> diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
> index ce8a10d3161d..0170e902fb63 100644
> --- a/arch/arm64/kvm/Makefile
> +++ b/arch/arm64/kvm/Makefile
> @@ -24,7 +24,7 @@ kvm-y += arm.o mmu.o mmio.o psci.o hypercalls.o pvtime.o \
>   	 vgic/vgic-mmio.o vgic/vgic-mmio-v2.o \
>   	 vgic/vgic-mmio-v3.o vgic/vgic-kvm-device.o \
>   	 vgic/vgic-its.o vgic/vgic-debug.o \
> -	 rme.o
> +	 rme.o rme-exit.o
>   
>   kvm-$(CONFIG_HW_PERF_EVENTS)  += pmu-emul.o pmu.o
>   kvm-$(CONFIG_ARM64_PTR_AUTH)  += pauth.o
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index ecce40a35cd0..273c08bb4a05 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -1278,7 +1278,10 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
>   		trace_kvm_entry(*vcpu_pc(vcpu));
>   		guest_timing_enter_irqoff();
>   
> -		ret = kvm_arm_vcpu_enter_exit(vcpu);
> +		if (vcpu_is_rec(vcpu))
> +			ret = kvm_rec_enter(vcpu);
> +		else
> +			ret = kvm_arm_vcpu_enter_exit(vcpu);
>   
>   		vcpu->mode = OUTSIDE_GUEST_MODE;
>   		vcpu->stat.exits++;
> @@ -1332,10 +1335,13 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
>   
>   		local_irq_enable();
>   
> -		trace_kvm_exit(ret, kvm_vcpu_trap_get_class(vcpu), *vcpu_pc(vcpu));
> -
>   		/* Exit types that need handling before we can be preempted */
> -		handle_exit_early(vcpu, ret);
> +		if (!vcpu_is_rec(vcpu)) {
> +			trace_kvm_exit(ret, kvm_vcpu_trap_get_class(vcpu),
> +				       *vcpu_pc(vcpu));
> +
> +			handle_exit_early(vcpu, ret);
> +		}
>   
>   		preempt_enable();
>   
> @@ -1358,7 +1364,10 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
>   			ret = ARM_EXCEPTION_IL;
>   		}
>   
> -		ret = handle_exit(vcpu, ret);
> +		if (vcpu_is_rec(vcpu))
> +			ret = handle_rec_exit(vcpu, ret);
> +		else
> +			ret = handle_exit(vcpu, ret);
>   	}
>   
>   	/* Tell userspace about in-kernel device output levels */
> diff --git a/arch/arm64/kvm/rme-exit.c b/arch/arm64/kvm/rme-exit.c
> new file mode 100644
> index 000000000000..e96ea308212c
> --- /dev/null
> +++ b/arch/arm64/kvm/rme-exit.c
> @@ -0,0 +1,179 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * Copyright (C) 2023 ARM Ltd.
> + */
> +
> +#include <linux/kvm_host.h>
> +#include <kvm/arm_hypercalls.h>
> +#include <kvm/arm_psci.h>
> +
> +#include <asm/rmi_smc.h>
> +#include <asm/kvm_emulate.h>
> +#include <asm/kvm_rme.h>
> +#include <asm/kvm_mmu.h>
> +
> +typedef int (*exit_handler_fn)(struct kvm_vcpu *vcpu);
> +
> +static int rec_exit_reason_notimpl(struct kvm_vcpu *vcpu)
> +{
> +	struct realm_rec *rec = &vcpu->arch.rec;
> +
> +	pr_err("[vcpu %d] Unhandled exit reason from realm (ESR: %#llx)\n",
> +	       vcpu->vcpu_id, rec->run->exit.esr);
> +	return -ENXIO;
> +}
> +
> +static int rec_exit_sync_dabt(struct kvm_vcpu *vcpu)
> +{
> +	return kvm_handle_guest_abort(vcpu);
> +}
> +
> +static int rec_exit_sync_iabt(struct kvm_vcpu *vcpu)
> +{
> +	struct realm_rec *rec = &vcpu->arch.rec;
> +
> +	pr_err("[vcpu %d] Unhandled instruction abort (ESR: %#llx).\n",
> +	       vcpu->vcpu_id, rec->run->exit.esr);
> +	return -ENXIO;
> +}
> +
> +static int rec_exit_sys_reg(struct kvm_vcpu *vcpu)
> +{
> +	struct realm_rec *rec = &vcpu->arch.rec;
> +	unsigned long esr = kvm_vcpu_get_esr(vcpu);
> +	int rt = kvm_vcpu_sys_get_rt(vcpu);
> +	bool is_write = !(esr & 1);
> +	int ret;
> +
> +	if (is_write)
> +		vcpu_set_reg(vcpu, rt, rec->run->exit.gprs[0]);
> +
> +	ret = kvm_handle_sys_reg(vcpu);
> +
> +	if (ret >= 0 && !is_write)
> +		rec->run->enter.gprs[0] = vcpu_get_reg(vcpu, rt);
> +
> +	return ret;
> +}
> +
> +static exit_handler_fn rec_exit_handlers[] = {
> +	[0 ... ESR_ELx_EC_MAX]	= rec_exit_reason_notimpl,
> +	[ESR_ELx_EC_SYS64]	= rec_exit_sys_reg,
> +	[ESR_ELx_EC_DABT_LOW]	= rec_exit_sync_dabt,
> +	[ESR_ELx_EC_IABT_LOW]	= rec_exit_sync_iabt
> +};
> +
> +static int rec_exit_psci(struct kvm_vcpu *vcpu)
> +{
> +	struct realm_rec *rec = &vcpu->arch.rec;
> +	int i;
> +
> +	for (i = 0; i < REC_RUN_GPRS; i++)
> +		vcpu_set_reg(vcpu, i, rec->run->exit.gprs[i]);
> +
> +	return kvm_smccc_call_handler(vcpu);
> +}
> +
> +static int rec_exit_ripas_change(struct kvm_vcpu *vcpu)
> +{
> +	struct kvm *kvm = vcpu->kvm;
> +	struct realm *realm = &kvm->arch.realm;
> +	struct realm_rec *rec = &vcpu->arch.rec;
> +	unsigned long base = rec->run->exit.ripas_base;
> +	unsigned long top = rec->run->exit.ripas_top;
> +	unsigned long ripas = rec->run->exit.ripas_value;
> +	unsigned long top_ipa;
> +	int ret;
> +
> +	if (!realm_is_addr_protected(realm, base) ||
> +	    !realm_is_addr_protected(realm, top - 1)) {
> +		kvm_err("Invalid RIPAS_CHANGE for %#lx - %#lx, ripas: %#lx\n",
> +			base, top, ripas);
> +		return -EINVAL;
> +	}
> +
> +	kvm_mmu_topup_memory_cache(&vcpu->arch.mmu_page_cache,
> +				   kvm_mmu_cache_min_pages(vcpu->arch.hw_mmu));

I think we also need to filter the request for RIPAS_RAM, by consulting 
if the "range" is backed by a memslot or not. If they are not, we should
reject the request with a response flag set in run.enter.flags.

As for EMPTY requests, if the guest wants to explicitly mark any range
as EMPTY, it doesn't matter, as long as it is within the protected IPA.
(even though they may be EMPTY in the first place).

> +	write_lock(&kvm->mmu_lock);
> +	ret = realm_set_ipa_state(vcpu, base, top, ripas, &top_ipa);
> +	write_unlock(&kvm->mmu_lock);
> +
> +	WARN(ret && ret != -ENOMEM,
> +	     "Unable to satisfy RIPAS_CHANGE for %#lx - %#lx, ripas: %#lx\n",
> +	     base, top, ripas);
> +
> +	/* Exit to VMM to complete the change */
> +	kvm_prepare_memory_fault_exit(vcpu, base, top_ipa - base, false, false,
> +				      ripas == RMI_RAM);

Again this may only be need if the range is backed by a memslot ?
Otherwise the VMM has nothing to do.

> +
> +	return 0;
> +}
> +
> +static void update_arch_timer_irq_lines(struct kvm_vcpu *vcpu)
> +{
> +	struct realm_rec *rec = &vcpu->arch.rec;
> +
> +	__vcpu_sys_reg(vcpu, CNTV_CTL_EL0) = rec->run->exit.cntv_ctl;
> +	__vcpu_sys_reg(vcpu, CNTV_CVAL_EL0) = rec->run->exit.cntv_cval;
> +	__vcpu_sys_reg(vcpu, CNTP_CTL_EL0) = rec->run->exit.cntp_ctl;
> +	__vcpu_sys_reg(vcpu, CNTP_CVAL_EL0) = rec->run->exit.cntp_cval;
> +
> +	kvm_realm_timers_update(vcpu);
> +}
> +
> +/*
> + * Return > 0 to return to guest, < 0 on error, 0 (and set exit_reason) on
> + * proper exit to userspace.
> + */
> +int handle_rec_exit(struct kvm_vcpu *vcpu, int rec_run_ret)
> +{
> +	struct realm_rec *rec = &vcpu->arch.rec;
> +	u8 esr_ec = ESR_ELx_EC(rec->run->exit.esr);
> +	unsigned long status, index;
> +
> +	status = RMI_RETURN_STATUS(rec_run_ret);
> +	index = RMI_RETURN_INDEX(rec_run_ret);
> +
> +	/*
> +	 * If a PSCI_SYSTEM_OFF request raced with a vcpu executing, we might
> +	 * see the following status code and index indicating an attempt to run
> +	 * a REC when the RD state is SYSTEM_OFF.  In this case, we just need to
> +	 * return to user space which can deal with the system event or will try
> +	 * to run the KVM VCPU again, at which point we will no longer attempt
> +	 * to enter the Realm because we will have a sleep request pending on
> +	 * the VCPU as a result of KVM's PSCI handling.
> +	 */
> +	if (status == RMI_ERROR_REALM && index == 1) {
> +		vcpu->run->exit_reason = KVM_EXIT_UNKNOWN;
> +		return 0;
> +	}
> +
> +	if (rec_run_ret)
> +		return -ENXIO;
> +
> +	vcpu->arch.fault.esr_el2 = rec->run->exit.esr;
> +	vcpu->arch.fault.far_el2 = rec->run->exit.far;
> +	vcpu->arch.fault.hpfar_el2 = rec->run->exit.hpfar;
> +
> +	update_arch_timer_irq_lines(vcpu);
> +
> +	/* Reset the emulation flags for the next run of the REC */
> +	rec->run->enter.flags = 0;
> +
> +	switch (rec->run->exit.exit_reason) {
> +	case RMI_EXIT_SYNC:
> +		return rec_exit_handlers[esr_ec](vcpu);
> +	case RMI_EXIT_IRQ:
> +	case RMI_EXIT_FIQ:
> +		return 1;
> +	case RMI_EXIT_PSCI:
> +		return rec_exit_psci(vcpu);
> +	case RMI_EXIT_RIPAS_CHANGE:
> +		return rec_exit_ripas_change(vcpu);
> +	}
> +
> +	kvm_pr_unimpl("Unsupported exit reason: %u\n",
> +		      rec->run->exit.exit_reason);
> +	vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
> +	return 0;
> +}
> diff --git a/arch/arm64/kvm/rme.c b/arch/arm64/kvm/rme.c
> index 1fa9991d708b..4c0751231810 100644
> --- a/arch/arm64/kvm/rme.c
> +++ b/arch/arm64/kvm/rme.c
> @@ -899,6 +899,25 @@ void kvm_destroy_realm(struct kvm *kvm)
>   	kvm_free_stage2_pgd(&kvm->arch.mmu);
>   }
>   
> +int kvm_rec_enter(struct kvm_vcpu *vcpu)
> +{
> +	struct realm_rec *rec = &vcpu->arch.rec;
> +
> +	switch (rec->run->exit.exit_reason) {
> +	case RMI_EXIT_HOST_CALL:
> +	case RMI_EXIT_PSCI:
> +		for (int i = 0; i < REC_RUN_GPRS; i++)
> +			rec->run->enter.gprs[i] = vcpu_get_reg(vcpu, i);
> +		break;
> +	}

As mentioned in the patch following (MMIO emulation support), we may be
able to do this unconditionally for all REC entries, to cover ourselves
from missing out other cases. The RMM is in charge of taking the
appropriate action anyways to copy the results back.

Suzuki

> +
> +	if (kvm_realm_state(vcpu->kvm) != REALM_STATE_ACTIVE)
> +		return -EINVAL;
> +
> +	return rmi_rec_enter(virt_to_phys(rec->rec_page),
> +			     virt_to_phys(rec->run));
> +}
> +
>   static void free_rec_aux(struct page **aux_pages,
>   			 unsigned int num_aux)
>   {


