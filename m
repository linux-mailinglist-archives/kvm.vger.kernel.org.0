Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 316C179751D
	for <lists+kvm@lfdr.de>; Thu,  7 Sep 2023 17:47:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234279AbjIGPqt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Sep 2023 11:46:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343691AbjIGPaw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Sep 2023 11:30:52 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 42C6810FD
        for <kvm@vger.kernel.org>; Thu,  7 Sep 2023 08:30:25 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4AE831576;
        Thu,  7 Sep 2023 08:30:00 -0700 (PDT)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id F2D603F67D;
        Thu,  7 Sep 2023 08:29:20 -0700 (PDT)
Date:   Thu, 7 Sep 2023 16:29:18 +0100
From:   Joey Gouly <joey.gouly@arm.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
        kvm@vger.kernel.org, James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Xu Zhao <zhaoxu.35@bytedance.com>
Subject: Re: [PATCH 2/5] KVM: arm64: Build MPIDR to vcpu index cache at
 runtime
Message-ID: <20230907152918.GB69899@e124191.cambridge.arm.com>
References: <20230907100931.1186690-1-maz@kernel.org>
 <20230907100931.1186690-3-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230907100931.1186690-3-maz@kernel.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 07, 2023 at 11:09:28AM +0100, Marc Zyngier wrote:
> The MPIDR_EL1 register contains a unique value that identifies
> the CPU. The only problem with it is that it is stupidly large
> (32 bits, once the useless stuff is removed).
> 
> Trying to obtain a vcpu from an MPIDR value is a fairly common,
> yet costly operation: we iterate over all the vcpus until we
> find the correct one. While this is cheap for small VMs, it is
> pretty expensive on large ones, specially if you are trying to
> get to the one that's at the end of the list...
> 
> In order to help with this, it is important to realise that
> the MPIDR values are actually structured, and that implementations
> tend to use a small number of significant bits in the 32bit space.
> 
> We can use this fact to our advantage by computing a small hash
> table that uses the "compression" of the significant MPIDR bits
> as an index, giving us the vcpu index as a result.
> 
> Given that the MPIDR values can be supplied by userspace, and
> that an evil VMM could decide to make *all* bits significant,
> resulting in a 4G-entry table, we only use this method if the
> resulting table fits in a single page. Otherwise, we fallback
> to the good old iterative method.
> 
> Nothing uses that table just yet, but keep your eyes peeled.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/include/asm/kvm_host.h | 28 ++++++++++++++++
>  arch/arm64/kvm/arm.c              | 54 +++++++++++++++++++++++++++++++
>  2 files changed, 82 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index af06ccb7ee34..361aaf66ac32 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -202,6 +202,31 @@ struct kvm_protected_vm {
>  	struct kvm_hyp_memcache teardown_mc;
>  };
>  
> +struct kvm_mpidr_data {
> +	u64			mpidr_mask;
> +	DECLARE_FLEX_ARRAY(u16, cmpidr_to_idx);
> +};
> +
> +static inline u16 kvm_mpidr_index(struct kvm_mpidr_data *data, u64 mpidr)
> +{
> +	unsigned long mask = data->mpidr_mask;
> +	u64 aff = mpidr & MPIDR_HWID_BITMASK;
> +	int nbits, bit, bit_idx = 0;
> +	u16 vcpu_idx = 0;
> +
> +	/*
> +	 * If this looks like RISC-V's BEXT or x86's PEXT
> +	 * instructions, it isn't by accident.
> +	 */
> +	nbits = fls(mask);
> +	for_each_set_bit(bit, &mask, nbits) {
> +		vcpu_idx |= (aff & BIT(bit)) >> (bit - bit_idx);
> +		bit_idx++;
> +	}
> +
> +	return vcpu_idx;
> +}
> +
>  struct kvm_arch {
>  	struct kvm_s2_mmu mmu;
>  
> @@ -248,6 +273,9 @@ struct kvm_arch {
>  	/* VM-wide vCPU feature set */
>  	DECLARE_BITMAP(vcpu_features, KVM_VCPU_MAX_FEATURES);
>  
> +	/* MPIDR to vcpu index mapping, optional */
> +	struct kvm_mpidr_data *mpidr_data;
> +
>  	/*
>  	 * VM-wide PMU filter, implemented as a bitmap and big enough for
>  	 * up to 2^10 events (ARMv8.0) or 2^16 events (ARMv8.1+).
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 4866b3f7b4ea..30ce394c09d4 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -205,6 +205,7 @@ void kvm_arch_destroy_vm(struct kvm *kvm)
>  	if (is_protected_kvm_enabled())
>  		pkvm_destroy_hyp_vm(kvm);
>  
> +	kfree(kvm->arch.mpidr_data);
>  	kvm_destroy_vcpus(kvm);
>  
>  	kvm_unshare_hyp(kvm, kvm + 1);
> @@ -578,6 +579,57 @@ static int kvm_vcpu_initialized(struct kvm_vcpu *vcpu)
>  	return vcpu_get_flag(vcpu, VCPU_INITIALIZED);
>  }
>  
> +static void kvm_init_mpidr_data(struct kvm *kvm)
> +{
> +	struct kvm_mpidr_data *data = NULL;
> +	unsigned long c, mask, nr_entries;
> +	u64 aff_set = 0, aff_clr = ~0UL;
> +	struct kvm_vcpu *vcpu;
> +
> +	mutex_lock(&kvm->arch.config_lock);
> +
> +	if (kvm->arch.mpidr_data || atomic_read(&kvm->online_vcpus) == 1)
> +		goto out;
> +
> +	kvm_for_each_vcpu(c, vcpu, kvm) {
> +		u64 aff = kvm_vcpu_get_mpidr_aff(vcpu);
> +		aff_set |= aff;
> +		aff_clr &= aff;
> +	}
> +
> +	/*
> +	 * A significant bit can be either 0 or 1, and will only appear in
> +	 * aff_set. Use aff_clr to weed out the useless stuff.
> +	 */
> +	mask = aff_set ^ aff_clr;
> +	nr_entries = BIT_ULL(hweight_long(mask));
> +
> +	/*
> +	 * Don't let userspace fool us. If we need more than a single page
> +	 * to describe the compressed MPIDR array, just fall back to the
> +	 * iterative method. Single vcpu VMs do not need this either.
> +	 */
> +	if (struct_size(data, cmpidr_to_idx, nr_entries) <= PAGE_SIZE)
> +		data = kzalloc(struct_size(data, cmpidr_to_idx, nr_entries),
> +			       GFP_KERNEL_ACCOUNT);
> +
> +	if (!data)
> +		goto out;

Probably not a big deal, but if the data doesn't fit, every vCPU will run this
function up until this point (if the data fits or there's only 1 vCPU we bail
out earlier)

> +
> +	data->mpidr_mask = mask;
> +
> +	kvm_for_each_vcpu(c, vcpu, kvm) {
> +		u64 aff = kvm_vcpu_get_mpidr_aff(vcpu);
> +		u16 vcpu_idx = kvm_mpidr_index(data, aff);
> +
> +		data->cmpidr_to_idx[vcpu_idx] = c;
> +	}
> +
> +	kvm->arch.mpidr_data = data;
> +out:
> +	mutex_unlock(&kvm->arch.config_lock);
> +}
> +
>  /*
>   * Handle both the initialisation that is being done when the vcpu is
>   * run for the first time, as well as the updates that must be
> @@ -601,6 +653,8 @@ int kvm_arch_vcpu_run_pid_change(struct kvm_vcpu *vcpu)
>  	if (likely(vcpu_has_run_once(vcpu)))
>  		return 0;
>  
> +	kvm_init_mpidr_data(kvm);
> +
>  	kvm_arm_vcpu_init_debug(vcpu);
>  
>  	if (likely(irqchip_in_kernel(kvm))) {

Reviewed-by: Joey Gouly <joey.gouly@arm.com>
