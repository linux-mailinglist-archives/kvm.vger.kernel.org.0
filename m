Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8993027D244
	for <lists+kvm@lfdr.de>; Tue, 29 Sep 2020 17:14:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731504AbgI2POC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Sep 2020 11:14:02 -0400
Received: from foss.arm.com ([217.140.110.172]:46968 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725710AbgI2POC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Sep 2020 11:14:02 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 26BF41063;
        Tue, 29 Sep 2020 08:14:01 -0700 (PDT)
Received: from e121166-lin.cambridge.arm.com (e121166-lin.cambridge.arm.com [10.1.196.255])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C878F3F6CF;
        Tue, 29 Sep 2020 08:13:59 -0700 (PDT)
Date:   Tue, 29 Sep 2020 16:13:54 +0100
From:   Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org, kernel-team@android.com,
        Christoffer Dall <Christoffer.Dall@arm.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: Re: [PATCH 22/23] KVM: arm64: Add a rVIC/rVID in-kernel
 implementation
Message-ID: <20200929151354.GA4877@e121166-lin.cambridge.arm.com>
References: <20200903152610.1078827-1-maz@kernel.org>
 <20200903152610.1078827-23-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200903152610.1078827-23-maz@kernel.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 03, 2020 at 04:26:09PM +0100, Marc Zyngier wrote:

[...]

> +static void __rvic_sync_hcr(struct kvm_vcpu *vcpu, struct rvic *rvic,
> +			    bool was_signaling)
> +{
> +	struct kvm_vcpu *target = kvm_rvic_to_vcpu(rvic);
> +	bool signal = __rvic_can_signal(rvic);
> +
> +	/* We're hitting our own rVIC: update HCR_VI locally */
> +	if (vcpu == target) {
> +		if (signal)
> +			*vcpu_hcr(vcpu) |= HCR_VI;
> +		else
> +			*vcpu_hcr(vcpu) &= ~HCR_VI;
> +
> +		return;
> +	}
> +
> +	/*
> +	 * Remote rVIC case:
> +	 *
> +	 * We kick even if the interrupt disappears, as ISR_EL1.I must
> +	 * always reflect the state of the rVIC. This forces a reload
> +	 * of the vcpu state, making it consistent.

Forgive me the question but this is unclear to me. IIUC here we do _not_
want to change the target_vcpu.hcr and we force a kick to make sure it
syncs the hcr (so the rvic) state on its own upon exit. Is that correct ?

Furthermore, I think it would be extremely useful to elaborate (ie
rework the comment) further on ISR_EL1.I and how it is linked to this
code path - I think it is key to understanding it.

Thanks,
Lorenzo

> +	 *
> +	 * This avoids modifying the target's own copy of HCR_EL2, as
> +	 * we are in a cross-vcpu call, and changing it from under its
> +	 * feet is dodgy.
> +	 */
> +	if (was_signaling != signal)
> +		__rvic_kick_vcpu(target);
> +}
> +
> +static void rvic_version(struct kvm_vcpu *vcpu)
> +{
> +	/* ALP0.3 is the name of the game */
> +	smccc_set_retval(vcpu, RVIC_STATUS_SUCCESS, RVIC_VERSION(0, 3), 0, 0);
> +}
> +
> +static void rvic_info(struct kvm_vcpu *vcpu)
> +{
> +	struct rvic *rvic = kvm_vcpu_to_rvic(vcpu);
> +	unsigned long what = smccc_get_arg1(vcpu);
> +	unsigned long a0, a1;
> +
> +	switch (what) {
> +	case RVIC_INFO_KEY_NR_TRUSTED_INTERRUPTS:
> +		a0 = RVIx_STATUS_PACK(RVIC_STATUS_SUCCESS, 0);
> +		a1 = rvic->nr_trusted;
> +		break;
> +	case RVIC_INFO_KEY_NR_UNTRUSTED_INTERRUPTS:
> +		a0 = RVIx_STATUS_PACK(RVIC_STATUS_SUCCESS, 0);
> +		a1 = rvic_nr_untrusted(rvic);
> +		break;
> +	default:
> +		a0 = RVIx_STATUS_PACK(RVIC_STATUS_ERROR_PARAMETER, 0);
> +		a1 = 0;
> +		break;
> +	}
> +
> +	smccc_set_retval(vcpu, a0, a1, 0, 0);
> +}
> +
> +static void rvic_enable(struct kvm_vcpu *vcpu)
> +{
> +	struct rvic *rvic = kvm_vcpu_to_rvic(vcpu);
> +	unsigned long flags;
> +	bool was_signaling;
> +
> +	spin_lock_irqsave(&rvic->lock, flags);
> +
> +	was_signaling = __rvic_can_signal(rvic);
> +	__rvic_enable(rvic);
> +	__rvic_sync_hcr(vcpu, rvic, was_signaling);
> +
> +	spin_unlock_irqrestore(&rvic->lock, flags);
> +
> +	smccc_set_retval(vcpu, RVIx_STATUS_PACK(RVIC_STATUS_SUCCESS, 0),
> +			 0, 0, 0);
> +}
> +
> +static void rvic_disable(struct kvm_vcpu *vcpu)
> +{
> +	struct rvic *rvic = kvm_vcpu_to_rvic(vcpu);
> +	unsigned long flags;
> +	bool was_signaling;
> +
> +	spin_lock_irqsave(&rvic->lock, flags);
> +
> +	was_signaling = __rvic_can_signal(rvic);
> +	__rvic_disable(rvic);
> +	__rvic_sync_hcr(vcpu, rvic, was_signaling);
> +
> +	spin_unlock_irqrestore(&rvic->lock, flags);
> +
> +	smccc_set_retval(vcpu, RVIx_STATUS_PACK(RVIC_STATUS_SUCCESS, 0),
> +			 0, 0, 0);
> +}
> +
> +typedef void (*rvic_action_fn_t)(struct rvic *, unsigned int);
> +
> +static int validate_rvic_call(struct kvm_vcpu *vcpu, struct rvic **rvicp,
> +			      unsigned int *intidp)
> +{
> +	unsigned long mpidr = smccc_get_arg1(vcpu);
> +	unsigned int intid = smccc_get_arg2(vcpu);
> +	struct kvm_vcpu *target;
> +	struct rvic *rvic;
> +
> +	/* FIXME: The spec distinguishes between invalid MPIDR and invalid CPU */
> +
> +	target = kvm_mpidr_to_vcpu(vcpu->kvm, mpidr);
> +	if (!target) {
> +		smccc_set_retval(vcpu, RVIx_STATUS_PACK(RVIC_STATUS_INVALID_CPU, 0),
> +				 0, 0, 0);
> +		return -1;
> +	}
> +
> +	rvic = kvm_vcpu_to_rvic(target);
> +	if (intid >= rvic->nr_total) {
> +		smccc_set_retval(vcpu, RVIx_STATUS_PACK(RVIC_STATUS_ERROR_PARAMETER, 1),
> +				 0, 0, 0);
> +		return -1;
> +	}
> +
> +	*rvicp = rvic;
> +	*intidp = intid;
> +
> +	return 0;
> +}
> +
> +static void __rvic_action(struct kvm_vcpu *vcpu, rvic_action_fn_t action,
> +			  bool check_enabled)
> +{
> +	struct rvic *rvic;
> +	unsigned long a0;
> +	unsigned long flags;
> +	int intid;
> +
> +	if (validate_rvic_call(vcpu, &rvic, &intid))
> +		return;
> +
> +	spin_lock_irqsave(&rvic->lock, flags);
> +
> +	if (unlikely(check_enabled && !__rvic_is_enabled(rvic))) {
> +		a0 = RVIx_STATUS_PACK(RVIC_STATUS_DISABLED, 0);
> +	} else {
> +		bool was_signaling = __rvic_can_signal(rvic);
> +		action(rvic, intid);
> +		__rvic_sync_hcr(vcpu, rvic, was_signaling);
> +		a0 = RVIx_STATUS_PACK(RVIC_STATUS_SUCCESS, 0);
> +	}
> +
> +	spin_unlock_irqrestore(&rvic->lock, flags);
> +
> +	smccc_set_retval(vcpu, a0, 0, 0, 0);
> +}
> +
> +static void rvic_set_masked(struct kvm_vcpu *vcpu)
> +{
> +	__rvic_action(vcpu, __rvic_set_masked, false);
> +}
> +
> +static void rvic_clear_masked(struct kvm_vcpu *vcpu)
> +{
> +	__rvic_action(vcpu, __rvic_clear_masked, false);
> +}
> +
> +static void rvic_clear_pending(struct kvm_vcpu *vcpu)
> +{
> +	__rvic_action(vcpu, __rvic_clear_pending, false);
> +}
> +
> +static void rvic_signal(struct kvm_vcpu *vcpu)
> +{
> +	__rvic_action(vcpu, __rvic_set_pending, true);
> +}
> +
> +static void rvic_is_pending(struct kvm_vcpu *vcpu)
> +{
> +	unsigned long flags;
> +	struct rvic *rvic;
> +	int intid;
> +	bool res;
> +
> +	if (validate_rvic_call(vcpu, &rvic, &intid))
> +		return;
> +
> +	spin_lock_irqsave(&rvic->lock, flags);
> +
> +	res = __rvic_is_pending(rvic, intid);
> +
> +	spin_unlock_irqrestore(&rvic->lock, flags);
> +
> +	smccc_set_retval(vcpu, RVIx_STATUS_PACK(RVIC_STATUS_SUCCESS, 0),
> +			 res, 0, 0);
> +}
> +
> +/*
> + * Ack and Resample are the only "interesting" operations that are
> + * strictly per-CPU.
> + */
> +static void rvic_acknowledge(struct kvm_vcpu *vcpu)
> +{
> +	unsigned long a0, a1;
> +	unsigned long flags;
> +	unsigned int intid;
> +	struct rvic *rvic;
> +
> +	rvic = kvm_vcpu_to_rvic(vcpu);
> +
> +	spin_lock_irqsave(&rvic->lock, flags);
> +
> +	if (unlikely(!__rvic_is_enabled(rvic))) {
> +		a0 = RVIx_STATUS_PACK(RVIC_STATUS_DISABLED, 0);
> +		a1 = 0;
> +	} else {
> +		intid = __rvic_ack(rvic);
> +		__rvic_sync_hcr(vcpu, rvic, true);
> +		if (unlikely(intid >= rvic->nr_total)) {
> +			a0 = RVIx_STATUS_PACK(RVIC_STATUS_NO_INTERRUPTS, 0);
> +			a1 = 0;
> +		} else {
> +			a0 = RVIx_STATUS_PACK(RVIC_STATUS_SUCCESS, 0);
> +			a1 = intid;
> +		}
> +	}
> +
> +	spin_unlock_irqrestore(&rvic->lock, flags);
> +
> +	smccc_set_retval(vcpu, a0, a1, 0, 0);
> +}
> +
> +static void rvic_resample(struct kvm_vcpu *vcpu)
> +{
> +	unsigned int intid = smccc_get_arg1(vcpu);
> +	unsigned long flags;
> +	unsigned long a0;
> +	struct rvic *rvic;
> +
> +	rvic = kvm_vcpu_to_rvic(vcpu);
> +
> +	spin_lock_irqsave(&rvic->lock, flags);
> +
> +	if (unlikely(intid >= rvic->nr_trusted)) {
> +		a0 = RVIx_STATUS_PACK(RVIC_STATUS_ERROR_PARAMETER, 0);
> +	} else {
> +		__rvic_resample(rvic, intid);
> +
> +		/*
> +		 * Don't bother finding out if we were signalling, we
> +		 * will update HCR_EL2 anyway as we are guaranteed not
> +		 * to be in a cross-call.
> +		 */
> +		__rvic_sync_hcr(vcpu, rvic, true);
> +		a0 = RVIx_STATUS_PACK(RVIC_STATUS_SUCCESS, 0);
> +	}
> +
> +	spin_unlock_irqrestore(&rvic->lock, flags);
> +
> +	smccc_set_retval(vcpu, a0, 0, 0, 0);
> +}
> +
> +int kvm_rvic_handle_hcall(struct kvm_vcpu *vcpu)
> +{
> +	pr_debug("RVIC: HC %08x", (unsigned int)smccc_get_function(vcpu));
> +	switch (smccc_get_function(vcpu)) {
> +	case SMC64_RVIC_VERSION:
> +		rvic_version(vcpu);
> +		break;
> +	case SMC64_RVIC_INFO:
> +		rvic_info(vcpu);
> +		break;
> +	case SMC64_RVIC_ENABLE:
> +		rvic_enable(vcpu);
> +		break;
> +	case SMC64_RVIC_DISABLE:
> +		rvic_disable(vcpu);
> +		break;
> +	case SMC64_RVIC_SET_MASKED:
> +		rvic_set_masked(vcpu);
> +		break;
> +	case SMC64_RVIC_CLEAR_MASKED:
> +		rvic_clear_masked(vcpu);
> +		break;
> +	case SMC64_RVIC_IS_PENDING:
> +		rvic_is_pending(vcpu);
> +		break;
> +	case SMC64_RVIC_SIGNAL:
> +		rvic_signal(vcpu);
> +		break;
> +	case SMC64_RVIC_CLEAR_PENDING:
> +		rvic_clear_pending(vcpu);
> +		break;
> +	case SMC64_RVIC_ACKNOWLEDGE:
> +		rvic_acknowledge(vcpu);
> +		break;
> +	case SMC64_RVIC_RESAMPLE:
> +		rvic_resample(vcpu);
> +		break;
> +	default:
> +		smccc_set_retval(vcpu, SMCCC_RET_NOT_SUPPORTED, 0, 0, 0);
> +		break;
> +	}
> +
> +	return 1;
> +}
> +
> +static void rvid_version(struct kvm_vcpu *vcpu)
> +{
> +	/* ALP0.3 is the name of the game */
> +	smccc_set_retval(vcpu, RVID_STATUS_SUCCESS, RVID_VERSION(0, 3), 0, 0);
> +}
> +
> +static void rvid_map(struct kvm_vcpu *vcpu)
> +{
> +	unsigned long input = smccc_get_arg1(vcpu);
> +	unsigned long mpidr = smccc_get_arg2(vcpu);
> +	unsigned int intid = smccc_get_arg3(vcpu);
> +	unsigned long flags;
> +	struct rvic_vm_data *data;
> +	struct kvm_vcpu *target;
> +
> +	data = vcpu->kvm->arch.irqchip_data;
> +
> +	if (input > rvic_nr_untrusted(data)) {
> +		smccc_set_retval(vcpu, RVIx_STATUS_PACK(RVID_STATUS_ERROR_PARAMETER, 0),
> +				 0, 0, 0);
> +		return;
> +	}
> +
> +	/* FIXME: different error from RVIC. Why? */
> +	target = kvm_mpidr_to_vcpu(vcpu->kvm, mpidr);
> +	if (!target) {
> +		smccc_set_retval(vcpu, RVIx_STATUS_PACK(RVID_STATUS_ERROR_PARAMETER, 1),
> +				 0, 0, 0);
> +		return;
> +	}
> +
> +	if (intid < data->nr_trusted || intid >= data->nr_total) {
> +		smccc_set_retval(vcpu, RVIx_STATUS_PACK(RVID_STATUS_ERROR_PARAMETER, 2),
> +				 0, 0, 0);
> +		return;
> +	}
> +
> +	spin_lock_irqsave(&data->lock, flags);
> +	data->rvid_map[input].target_vcpu	= target->vcpu_id;
> +	data->rvid_map[input].intid		= intid;
> +	spin_unlock_irqrestore(&data->lock, flags);
> +
> +	smccc_set_retval(vcpu, 0, 0, 0, 0);
> +}
> +
> +static void rvid_unmap(struct kvm_vcpu *vcpu)
> +{
> +	unsigned long input = smccc_get_arg1(vcpu);
> +	unsigned long flags;
> +	struct rvic_vm_data *data;
> +
> +	data = vcpu->kvm->arch.irqchip_data;
> +
> +	if (input > rvic_nr_untrusted(data)) {
> +		smccc_set_retval(vcpu, RVIx_STATUS_PACK(RVID_STATUS_ERROR_PARAMETER, 0),
> +				 0, 0, 0);
> +		return;
> +	}
> +
> +	spin_lock_irqsave(&data->lock, flags);
> +	data->rvid_map[input].target_vcpu	= 0;
> +	data->rvid_map[input].intid		= 0;
> +	spin_unlock_irqrestore(&data->lock, flags);
> +
> +	smccc_set_retval(vcpu, 0, 0, 0, 0);
> +}
> +
> +int kvm_rvid_handle_hcall(struct kvm_vcpu *vcpu)
> +{
> +	pr_debug("RVID: HC %08x", (unsigned int)smccc_get_function(vcpu));
> +	switch (smccc_get_function(vcpu)) {
> +	case SMC64_RVID_VERSION:
> +		rvid_version(vcpu);
> +		break;
> +	case SMC64_RVID_MAP:
> +		rvid_map(vcpu);
> +		break;
> +	case SMC64_RVID_UNMAP:
> +		rvid_unmap(vcpu);
> +		break;
> +	default:
> +		smccc_set_retval(vcpu, SMCCC_RET_NOT_SUPPORTED, 0, 0, 0);
> +		break;
> +	}
> +
> +	return 1;
> +}
> +
> +/*
> + * KVM internal interface to the rVIC
> + */
> +
> +/* This *must* be called from the vcpu thread */
> +static void rvic_flush_signaling_state(struct kvm_vcpu *vcpu)
> +{
> +	struct rvic *rvic = kvm_vcpu_to_rvic(vcpu);
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&rvic->lock, flags);
> +
> +	__rvic_sync_hcr(vcpu, rvic, true);
> +
> +	spin_unlock_irqrestore(&rvic->lock, flags);
> +}
> +
> +/* This can be called from any context */
> +static void rvic_vcpu_inject_irq(struct kvm_vcpu *vcpu, unsigned int intid,
> +				 bool level)
> +{
> +	struct rvic *rvic = kvm_vcpu_to_rvic(vcpu);
> +	unsigned long flags;
> +	bool prev;
> +
> +	spin_lock_irqsave(&rvic->lock, flags);
> +
> +	if (WARN_ON(intid >= rvic->nr_total))
> +		goto out;
> +
> +	/*
> +	 * Although really ugly, this should be safe as we hold the
> +	 * rvic lock, and the only path that uses this information is
> +	 * resample, which takes this lock too.
> +	 */
> +	if (!rvic->irqs[intid].get_line_level)
> +		rvic->irqs[intid].line_level = level;
> +
> +	if (level) {
> +		prev = __rvic_can_signal(rvic);
> +		__rvic_set_pending(rvic, intid);
> +		if (prev != __rvic_can_signal(rvic))
> +			__rvic_kick_vcpu(vcpu);
> +	}
> +out:
> +	spin_unlock_irqrestore(&rvic->lock, flags);
> +}
> +
> +static int rvic_inject_irq(struct kvm *kvm, unsigned int cpu,
> +			   unsigned int intid, bool level, void *owner)
> +{
> +	struct kvm_vcpu *vcpu = kvm_get_vcpu(kvm, cpu);
> +	struct rvic *rvic;
> +
> +	if (unlikely(!vcpu))
> +		return -EINVAL;
> +
> +	rvic = kvm_vcpu_to_rvic(vcpu);
> +	if (unlikely(intid >= rvic->nr_total))
> +		return -EINVAL;
> +
> +	/* Ignore interrupt owner for now */
> +	rvic_vcpu_inject_irq(vcpu, intid, level);
> +	return 0;
> +}
> +
> +static int rvic_inject_userspace_irq(struct kvm *kvm, unsigned int type,
> +				     unsigned int cpu,
> +				     unsigned int intid, bool level)
> +{
> +	struct rvic_vm_data *data = kvm->arch.irqchip_data;
> +	unsigned long flags;
> +	u16 output;
> +
> +	switch (type) {
> +	case KVM_ARM_IRQ_TYPE_SPI:
> +		/*
> +		 * Userspace can only inject interrupts that are
> +		 * translated by the rvid, so the cpu parameter is
> +		 * irrelevant and we override it when resolving the
> +		 * translation.
> +		 */
> +		if (intid >= rvic_nr_untrusted(data))
> +			return -EINVAL;
> +
> +		spin_lock_irqsave(&data->lock, flags);
> +		output = data->rvid_map[intid].intid;
> +		cpu = data->rvid_map[intid].target_vcpu;
> +		spin_unlock_irqrestore(&data->lock, flags);
> +
> +		/* Silently ignore unmapped interrupts */
> +		if (output < data->nr_trusted)
> +			return 0;
> +
> +		return rvic_inject_irq(kvm, cpu, output, level, NULL);
> +	default:
> +		return -EINVAL;
> +	}
> +}
> +
> +static int rvic_vcpu_init(struct kvm_vcpu *vcpu)
> +{
> +	struct rvic_vm_data *data = vcpu->kvm->arch.irqchip_data;
> +	struct rvic *rvic = kvm_vcpu_to_rvic(vcpu);
> +	int i;
> +
> +	/* irqchip not ready yet, we will come back later */
> +	if (!data)
> +		return 0;
> +
> +	if (WARN_ON(rvic->irqs))
> +		return -EINVAL;
> +
> +	spin_lock_init(&rvic->lock);
> +	INIT_LIST_HEAD(&rvic->delivery);
> +	rvic->nr_trusted	= data->nr_trusted;
> +	rvic->nr_total		= data->nr_total;
> +	rvic->enabled		= false;
> +
> +	rvic->irqs = kcalloc(rvic->nr_total, sizeof(*rvic->irqs), GFP_ATOMIC);
> +	if (!rvic->irqs)
> +		return -ENOMEM;
> +
> +	for (i = 0; i < rvic->nr_total; i++) {
> +		struct rvic_irq *irq = &rvic->irqs[i];
> +
> +		spin_lock_init(&irq->lock);
> +		INIT_LIST_HEAD(&irq->delivery_entry);
> +		irq->get_line_level	= NULL;
> +		irq->intid		= i;
> +		irq->host_irq		= 0;
> +		irq->pending		= false;
> +		irq->masked		= true;
> +		irq->line_level		= false;
> +	}
> +
> +	return 0;
> +}
> +
> +static void rvic_destroy(struct kvm *kvm)
> +{
> +	struct kvm_vcpu *vcpu;
> +	int i;
> +
> +	mutex_lock(&kvm->lock);
> +
> +	kvm_for_each_vcpu(i, vcpu, kvm) {
> +		struct rvic *rvic = kvm_vcpu_to_rvic(vcpu);
> +
> +		INIT_LIST_HEAD(&rvic->delivery);
> +		kfree(rvic->irqs);
> +		rvic->irqs = NULL;
> +	}
> +
> +	mutex_unlock(&kvm->lock);
> +}
> +
> +static int rvic_pending_irq(struct kvm_vcpu *vcpu)
> +{
> +	struct rvic *rvic = kvm_vcpu_to_rvic(vcpu);
> +	unsigned long flags;
> +	bool res;
> +
> +	spin_lock_irqsave(&rvic->lock, flags);
> +	res = __rvic_can_signal(rvic);
> +	spin_unlock_irqrestore(&rvic->lock, flags);
> +
> +	return res;
> +}
> +
> +static int rvic_map_phys_irq(struct kvm_vcpu *vcpu, unsigned int host_irq,
> +			     u32 intid, bool (*get_line_level)(int))
> +{
> +	struct rvic *rvic = kvm_vcpu_to_rvic(vcpu);
> +	struct rvic_irq *irq = rvic_get_irq(rvic, intid);
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&irq->lock, flags);
> +	irq->host_irq = host_irq;
> +	irq->get_line_level = get_line_level;
> +	spin_unlock_irqrestore(&irq->lock, flags);
> +
> +	return 0;
> +}
> +
> +static int rvic_unmap_phys_irq(struct kvm_vcpu *vcpu, unsigned int intid)
> +{
> +	struct rvic *rvic = kvm_vcpu_to_rvic(vcpu);
> +	struct rvic_irq *irq = rvic_get_irq(rvic, intid);
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&irq->lock, flags);
> +	irq->host_irq = 0;
> +	irq->get_line_level = NULL;
> +	spin_unlock_irqrestore(&irq->lock, flags);
> +
> +	return 0;
> +}
> +
> +static int rvic_irqfd_set_irq(struct kvm_kernel_irq_routing_entry *e,
> +			      struct kvm *kvm, int irq_source_id,
> +			      int level, bool line_status)
> +{
> +	/* Abuse the userspace interface to perform the routing*/
> +	return rvic_inject_userspace_irq(kvm, KVM_ARM_IRQ_TYPE_SPI, 0,
> +					 e->irqchip.pin, level);
> +}
> +
> +static int rvic_set_msi(struct kvm_kernel_irq_routing_entry *e,
> +			struct kvm *kvm, int irq_source_id,
> +			int level, bool line_status)
> +{
> +	return -ENODEV;
> +}
> +
> +static int rvic_set_irq_inatomic(struct kvm_kernel_irq_routing_entry *e,
> +				 struct kvm *kvm, int irq_source_id,
> +				 int level, bool line_status)
> +{
> +	if (e->type != KVM_IRQ_ROUTING_IRQCHIP)
> +		return -EWOULDBLOCK;
> +
> +	return rvic_irqfd_set_irq(e, kvm, irq_source_id, level, line_status);
> +}
> +
> +static const struct kvm_irqchip_flow rvic_irqchip_flow = {
> +	.irqchip_destroy		= rvic_destroy,
> +	.irqchip_vcpu_init		= rvic_vcpu_init,
> +	/* Nothing to do on block/unblock */
> +	/* Nothing to do on load/put */
> +	.irqchip_vcpu_pending_irq	= rvic_pending_irq,
> +	.irqchip_vcpu_flush_hwstate	= rvic_flush_signaling_state,
> +	/* Nothing tp do on sync_hwstate */
> +	.irqchip_inject_irq		= rvic_inject_irq,
> +	.irqchip_inject_userspace_irq	= rvic_inject_userspace_irq,
> +	/* No reset_mapped_irq as we allow spurious interrupts */
> +	.irqchip_map_phys_irq		= rvic_map_phys_irq,
> +	.irqchip_unmap_phys_irq		= rvic_unmap_phys_irq,
> +	.irqchip_irqfd_set_irq		= rvic_irqfd_set_irq,
> +	.irqchip_set_msi		= rvic_set_msi,
> +	.irqchip_set_irq_inatomic	= rvic_set_irq_inatomic,
> +};
> +
> +static int rvic_setup_default_irq_routing(struct kvm *kvm)
> +{
> +	struct rvic_vm_data *data = kvm->arch.irqchip_data;
> +	unsigned int nr = rvic_nr_untrusted(data);
> +	struct kvm_irq_routing_entry *entries;
> +	int i, ret;
> +
> +	entries = kcalloc(nr, sizeof(*entries), GFP_KERNEL);
> +	if (!entries)
> +		return -ENOMEM;
> +
> +	for (i = 0; i < nr; i++) {
> +		entries[i].gsi = i;
> +		entries[i].type = KVM_IRQ_ROUTING_IRQCHIP;
> +		entries[i].u.irqchip.irqchip = 0;
> +		entries[i].u.irqchip.pin = i;
> +	}
> +	ret = kvm_set_irq_routing(kvm, entries, nr, 0);
> +	kfree(entries);
> +	return ret;
> +}
> +
> +/* Device management */
> +static int rvic_device_create(struct kvm_device *dev, u32 type)
> +{
> +	struct kvm *kvm = dev->kvm;
> +	struct kvm_vcpu *vcpu;
> +	int i, ret;
> +
> +	if (irqchip_in_kernel(kvm))
> +		return -EEXIST;
> +
> +	ret = -EBUSY;
> +	if (!lock_all_vcpus(kvm))
> +		return ret;
> +
> +	kvm_for_each_vcpu(i, vcpu, kvm) {
> +		if (vcpu->arch.has_run_once)
> +			goto out_unlock;
> +	}
> +
> +	ret = 0;
> +
> +	/*
> +	 * The good thing about not having any HW is that you don't
> +	 * get the limitations of the HW...
> +	 */
> +	kvm->arch.max_vcpus		= KVM_MAX_VCPUS;
> +	kvm->arch.irqchip_type		= IRQCHIP_RVIC;
> +	kvm->arch.irqchip_flow		= rvic_irqchip_flow;
> +	kvm->arch.irqchip_data		= NULL;
> +
> +out_unlock:
> +	unlock_all_vcpus(kvm);
> +	return ret;
> +}
> +
> +static void rvic_device_destroy(struct kvm_device *dev)
> +{
> +	kfree(dev->kvm->arch.irqchip_data);
> +	kfree(dev);
> +}
> +
> +static int rvic_set_attr(struct kvm_device *dev, struct kvm_device_attr *attr)
> +{
> +	struct rvic_vm_data *data;
> +	struct kvm_vcpu *vcpu;
> +	u32 __user *uaddr, val;
> +	u16 trusted, total;
> +	int i, ret = -ENXIO;
> +
> +	mutex_lock(&dev->kvm->lock);
> +
> +	switch (attr->group) {
> +	case KVM_DEV_ARM_RVIC_GRP_NR_IRQS:
> +		if (attr->attr)
> +			break;
> +
> +		if (dev->kvm->arch.irqchip_data) {
> +			ret = -EBUSY;
> +			break;
> +		}
> +
> +		uaddr = (u32 __user *)(uintptr_t)attr->addr;
> +		if (get_user(val, uaddr)) {
> +			ret = -EFAULT;
> +			break;
> +		}
> +
> +		trusted = FIELD_GET(KVM_DEV_ARM_RVIC_GRP_NR_TRUSTED_MASK, val);
> +		total   = FIELD_GET(KVM_DEV_ARM_RVIC_GRP_NR_TOTAL_MASK, val);
> +		if (total < trusted || trusted < 32 || total < 64 ||
> +		    trusted % 32 || total % 32 || total > 2048) {
> +			ret = -EINVAL;
> +			break;
> +		}
> +
> +		data = kzalloc(struct_size(data, rvid_map, (total - trusted)),
> +			       GFP_KERNEL);
> +		if (!data) {
> +			ret = -ENOMEM;
> +			break;
> +		}
> +
> +		data->nr_trusted = trusted;
> +		data->nr_total = total;
> +		spin_lock_init(&data->lock);
> +		/* Default to no mapping */
> +		for (i = 0; i < (total - trusted); i++) {
> +			/*
> +			 * an intid < nr_trusted is invalid as the
> +			 * result of a translation through the rvid,
> +			 * hence the input in unmapped.
> +			 */
> +			data->rvid_map[i].target_vcpu = 0;
> +			data->rvid_map[i].intid = 0;
> +		}
> +
> +		dev->kvm->arch.irqchip_data = data;
> +
> +		ret = 0;
> +		break;
> +
> +	case KVM_DEV_ARM_RVIC_GRP_INIT:
> +		if (attr->attr)
> +			break;
> +
> +		if (!dev->kvm->arch.irqchip_data)
> +			break;
> +
> +		ret = 0;
> +
> +		/* Init the rvic on any already created vcpu */
> +		kvm_for_each_vcpu(i, vcpu, dev->kvm) {
> +			ret = rvic_vcpu_init(vcpu);
> +			if (ret)
> +				break;
> +		}
> +
> +		if (!ret)
> +			ret = rvic_setup_default_irq_routing(dev->kvm);
> +		if (!ret)
> +			dev->kvm->arch.irqchip_finalized = true;
> +		break;
> +
> +	default:
> +		break;
> +	}
> +
> +	mutex_unlock(&dev->kvm->lock);
> +
> +	return ret;
> +}
> +
> +static int rvic_get_attr(struct kvm_device *dev, struct kvm_device_attr *attr)
> +{
> +	struct rvic_vm_data *data;
> +	u32 __user *uaddr, val;
> +	int ret = -ENXIO;
> +
> +	mutex_lock(&dev->kvm->lock);
> +
> +	switch (attr->group) {
> +	case KVM_DEV_ARM_RVIC_GRP_NR_IRQS:
> +		if (attr->attr)
> +			break;
> +
> +		data = dev->kvm->arch.irqchip_data;
> +		if (!data)
> +			break;
> +
> +		val  = FIELD_PREP(KVM_DEV_ARM_RVIC_GRP_NR_TRUSTED_MASK,
> +					 data->nr_trusted);
> +		val |= FIELD_PREP(KVM_DEV_ARM_RVIC_GRP_NR_TOTAL_MASK,
> +					 data->nr_total);
> +
> +		uaddr = (u32 __user *)(uintptr_t)attr->addr;
> +		ret = put_user(val, uaddr);
> +		break;
> +
> +	default:
> +		break;
> +	}
> +
> +	mutex_unlock(&dev->kvm->lock);
> +
> +	return ret;
> +}
> +
> +static int rvic_has_attr(struct kvm_device *dev, struct kvm_device_attr *attr)
> +{
> +	int ret = -ENXIO;
> +
> +	switch (attr->group) {
> +	case KVM_DEV_ARM_RVIC_GRP_NR_IRQS:
> +	case KVM_DEV_ARM_RVIC_GRP_INIT:
> +		if (attr->attr)
> +			break;
> +		ret = 0;
> +		break;
> +
> +	default:
> +		break;
> +	}
> +
> +	return ret;
> +}
> +
> +static const struct kvm_device_ops rvic_dev_ops = {
> +	.name		= "kvm-arm-rvic",
> +	.create		= rvic_device_create,
> +	.destroy	= rvic_device_destroy,
> +	.set_attr	= rvic_set_attr,
> +	.get_attr	= rvic_get_attr,
> +	.has_attr	= rvic_has_attr,
> +};
> +
> +int kvm_register_rvic_device(void)
> +{
> +	return kvm_register_device_ops(&rvic_dev_ops, KVM_DEV_TYPE_ARM_RVIC);
> +}
> diff --git a/include/kvm/arm_rvic.h b/include/kvm/arm_rvic.h
> new file mode 100644
> index 000000000000..9e67a83fa384
> --- /dev/null
> +++ b/include/kvm/arm_rvic.h
> @@ -0,0 +1,41 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * rVIC/rVID PV interrupt controller implementation for KVM/arm64.
> + *
> + * Copyright 2020 Google LLC.
> + * Author: Marc Zyngier <maz@kernel.org>
> + */
> +
> +#ifndef __KVM_ARM_RVIC_H__
> +#define __KVM_ARM_RVIC_H__
> +
> +#include <linux/list.h>
> +#include <linux/spinlock.h>
> +
> +struct kvm_vcpu;
> +
> +struct rvic_irq {
> +	spinlock_t		lock;
> +	struct list_head	delivery_entry;
> +	bool			(*get_line_level)(int intid);
> +	unsigned int		intid;
> +	unsigned int		host_irq;
> +	bool			pending;
> +	bool			masked;
> +	bool			line_level; /* If get_line_level == NULL */
> +};
> +
> +struct rvic {
> +	spinlock_t		lock;
> +	struct list_head	delivery;
> +	struct rvic_irq		*irqs;
> +	unsigned int		nr_trusted;
> +	unsigned int		nr_total;
> +	bool			enabled;
> +};
> +
> +int kvm_rvic_handle_hcall(struct kvm_vcpu *vcpu);
> +int kvm_rvid_handle_hcall(struct kvm_vcpu *vcpu);
> +int kvm_register_rvic_device(void);
> +
> +#endif
> diff --git a/include/linux/irqchip/irq-rvic.h b/include/linux/irqchip/irq-rvic.h
> index 4545c1e89741..b188773729fb 100644
> --- a/include/linux/irqchip/irq-rvic.h
> +++ b/include/linux/irqchip/irq-rvic.h
> @@ -57,6 +57,8 @@
>  #define SMC64_RVIC_ACKNOWLEDGE		SMC64_RVIC_FN(9)
>  #define SMC64_RVIC_RESAMPLE		SMC64_RVIC_FN(10)
>  
> +#define SMC64_RVIC_LAST			SMC64_RVIC_RESAMPLE
> +
>  #define RVIC_INFO_KEY_NR_TRUSTED_INTERRUPTS	0
>  #define RVIC_INFO_KEY_NR_UNTRUSTED_INTERRUPTS	1
>  
> @@ -82,6 +84,8 @@
>  #define SMC64_RVID_MAP			SMC64_RVID_FN(1)
>  #define SMC64_RVID_UNMAP		SMC64_RVID_FN(2)
>  
> +#define SMC64_RVID_LAST			SMC64_RVID_UNMAP
> +
>  #define RVID_VERSION(M, m)		RVIx_VERSION((M), (m))
>  
>  #define RVID_VERSION_MAJOR(v)		RVIx_VERSION_MAJOR((v))
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index f6d86033c4fa..6d245d2dc9e6 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -1264,6 +1264,8 @@ enum kvm_device_type {
>  #define KVM_DEV_TYPE_XIVE		KVM_DEV_TYPE_XIVE
>  	KVM_DEV_TYPE_ARM_PV_TIME,
>  #define KVM_DEV_TYPE_ARM_PV_TIME	KVM_DEV_TYPE_ARM_PV_TIME
> +	KVM_DEV_TYPE_ARM_RVIC,
> +#define KVM_DEV_TYPE_ARM_RVIC		KVM_DEV_TYPE_ARM_RVIC
>  	KVM_DEV_TYPE_MAX,
>  };
>  
> -- 
> 2.27.0
> 
