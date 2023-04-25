Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C35966EDD38
	for <lists+kvm@lfdr.de>; Tue, 25 Apr 2023 09:52:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233252AbjDYHwK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Apr 2023 03:52:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231189AbjDYHwJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Apr 2023 03:52:09 -0400
Received: from out-58.mta0.migadu.com (out-58.mta0.migadu.com [IPv6:2001:41d0:1004:224b::3a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22F36128
        for <kvm@vger.kernel.org>; Tue, 25 Apr 2023 00:52:06 -0700 (PDT)
Date:   Tue, 25 Apr 2023 07:51:59 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1682409124;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=350TgBQILY/jaNRX4gCbyRdsDrtoFKzlurfJ1IuUeII=;
        b=m3qg++2Tq8TSmJog+me6km0pxuTxJNGC9a5rVIWbEutjgvRF6HGPacMCkrrIVFT1de5V/G
        Fsi3KI3g5qzBVqxnO5VzJG481eoEqASTwYHRv/WeVpn7yfJakDyjgOTanmQNztiYMmEb7p
        OIpFuJ0TBhwM9lbNlNB453eboADI6+0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Jing Zhang <jingzhangos@google.com>
Cc:     KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.linux.dev>,
        ARMLinux <linux-arm-kernel@lists.infradead.org>,
        Marc Zyngier <maz@kernel.org>,
        Oliver Upton <oupton@google.com>,
        Will Deacon <will@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Fuad Tabba <tabba@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Raghavendra Rao Ananta <rananta@google.com>
Subject: Re: [PATCH v7 2/6] KVM: arm64: Save ID registers' sanitized value
 per guest
Message-ID: <ZEeGnwVxytVuZejC@linux.dev>
References: <20230424234704.2571444-1-jingzhangos@google.com>
 <20230424234704.2571444-3-jingzhangos@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230424234704.2571444-3-jingzhangos@google.com>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Jing,

On Mon, Apr 24, 2023 at 11:47:00PM +0000, Jing Zhang wrote:
> Introduce id_regs[] in kvm_arch as a storage of guest's ID registers,
> and save ID registers' sanitized value in the array at KVM_CREATE_VM.
> Use the saved ones when ID registers are read by the guest or
> userspace (via KVM_GET_ONE_REG).
> 
> No functional change intended.
> 
> Co-developed-by: Reiji Watanabe <reijiw@google.com>
> Signed-off-by: Reiji Watanabe <reijiw@google.com>
> Signed-off-by: Jing Zhang <jingzhangos@google.com>
> ---
>  arch/arm64/include/asm/kvm_host.h | 47 +++++++++++++++++++++++++++++
>  arch/arm64/kvm/arm.c              |  1 +
>  arch/arm64/kvm/id_regs.c          | 49 +++++++++++++++++++++++++------
>  arch/arm64/kvm/sys_regs.c         |  2 +-
>  arch/arm64/kvm/sys_regs.h         |  3 +-
>  5 files changed, 90 insertions(+), 12 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index bcd774d74f34..2b1fe90a1790 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -177,6 +177,20 @@ struct kvm_smccc_features {
>  	unsigned long vendor_hyp_bmap;
>  };
>  
> +/*
> + * Emualted CPU ID registers per VM

typo: emulated

> + * (Op0, Op1, CRn, CRm, Op2) of the ID registers to be saved in it
> + * is (3, 0, 0, crm, op2), where 1<=crm<8, 0<=op2<8.
> + *
> + * These emulated idregs are VM-wide, but accessed from the context of a vCPU.
> + * Access to id regs are guarded by kvm_arch.config_lock.
> + */
> +#define KVM_ARM_ID_REG_NUM	56
> +#define IDREG_IDX(id)		(((sys_reg_CRm(id) - 1) << 3) | sys_reg_Op2(id))
> +struct kvm_idregs {
> +	u64 regs[KVM_ARM_ID_REG_NUM];
> +};

What is the purpose of declaring the register array as a separate
structure? It has no meaning (nor use) outside of the context of a VM.

I'd prefer the 'regs' array be embedded directly in kvm_arch, and just
name it 'idregs'. You can move your macro definitions there as well to
immediately precede the field.

>  typedef unsigned int pkvm_handle_t;
>  
>  struct kvm_protected_vm {
> @@ -243,6 +257,9 @@ struct kvm_arch {
>  	/* Hypercall features firmware registers' descriptor */
>  	struct kvm_smccc_features smccc_feat;
>  
> +	/* Emulated CPU ID registers */
> +	struct kvm_idregs idregs;
> +
>  	/*
>  	 * For an untrusted host VM, 'pkvm.handle' is used to lookup
>  	 * the associated pKVM instance in the hypervisor.
> @@ -1008,6 +1025,8 @@ int kvm_arm_vcpu_arch_has_attr(struct kvm_vcpu *vcpu,
>  long kvm_vm_ioctl_mte_copy_tags(struct kvm *kvm,
>  				struct kvm_arm_copy_mte_tags *copy_tags);
>  
> +void kvm_arm_init_id_regs(struct kvm *kvm);
> +
>  /* Guest/host FPSIMD coordination helpers */
>  int kvm_arch_vcpu_run_map_fp(struct kvm_vcpu *vcpu);
>  void kvm_arch_vcpu_load_fp(struct kvm_vcpu *vcpu);
> @@ -1073,4 +1092,32 @@ static inline void kvm_hyp_reserve(void) { }
>  void kvm_arm_vcpu_power_off(struct kvm_vcpu *vcpu);
>  bool kvm_arm_vcpu_stopped(struct kvm_vcpu *vcpu);
>  
> +static inline u64 _idreg_read(struct kvm_arch *arch, u32 id)

<bikeshed>

Personally, I find passing 'kvm_arch' around to be a bit clunky. Almost
all functions in KVM take 'struct kvm' as an argument, even if it only
accesses the data in 'kvm_arch'.

So, I'd prefer if all these helpers took 'struct kvm *'.

</bikeshed>

> +{
> +	return arch->idregs.regs[IDREG_IDX(id)];
> +}
> +
> +static inline void _idreg_write(struct kvm_arch *arch, u32 id, u64 val)
> +{
> +	arch->idregs.regs[IDREG_IDX(id)] = val;
> +}
> +
> +static inline u64 idreg_read(struct kvm_arch *arch, u32 id)
> +{
> +	u64 val;
> +
> +	mutex_lock(&arch->config_lock);
> +	val = _idreg_read(arch, id);
> +	mutex_unlock(&arch->config_lock);

What exactly are we protecting against by taking the config_lock here?

While I do believe there is value in serializing writers to the shared
data, there isn't a need to serialize reads from the guest.

What about implementing the following:

 - Acquire the config_lock for handling writes. Only allow the value to
   change if !kvm_vm_has_ran_once(). Otherwise, permit identical writes
   (useful for hotplug, I imagine) or return EBUSY if userspace tried to
   change something after running the VM.

 - Acquire the config_lock for handling reads *from userspace*

 - Handle reads from the guest with a plain old load, avoiding the need
   to acquire any locks.

This has the benefit of avoiding lock contention for guest reads w/o
requiring the use of atomic loads/stores (i.e. {READ,WRITE}_ONCE()) to
protect said readers.

> +	return val;
> +}
> +
> +static inline void idreg_write(struct kvm_arch *arch, u32 id, u64 val)
> +{
> +	mutex_lock(&arch->config_lock);
> +	_idreg_write(arch, id, val);
> +	mutex_unlock(&arch->config_lock);
> +}
> +
>  #endif /* __ARM64_KVM_HOST_H__ */
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 4b2e16e696a8..e34744c36406 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -153,6 +153,7 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
>  
>  	set_default_spectre(kvm);
>  	kvm_arm_init_hypercalls(kvm);
> +	kvm_arm_init_id_regs(kvm);
>  
>  	/*
>  	 * Initialise the default PMUver before there is a chance to
> diff --git a/arch/arm64/kvm/id_regs.c b/arch/arm64/kvm/id_regs.c
> index 96b4c43a5100..d2fba2fde01c 100644
> --- a/arch/arm64/kvm/id_regs.c
> +++ b/arch/arm64/kvm/id_regs.c
> @@ -52,16 +52,9 @@ static u8 pmuver_to_perfmon(u8 pmuver)
>  	}
>  }
>  
> -/* Read a sanitised cpufeature ID register by sys_reg_desc */
> -static u64 read_id_reg(const struct kvm_vcpu *vcpu, struct sys_reg_desc const *r)
> +u64 kvm_arm_read_id_reg(const struct kvm_vcpu *vcpu, u32 id)
>  {
> -	u32 id = reg_to_encoding(r);
> -	u64 val;
> -
> -	if (sysreg_visible_as_raz(vcpu, r))
> -		return 0;
> -
> -	val = read_sanitised_ftr_reg(id);
> +	u64 val = idreg_read(&vcpu->kvm->arch, id);
>  
>  	switch (id) {
>  	case SYS_ID_AA64PFR0_EL1:
> @@ -126,6 +119,14 @@ static u64 read_id_reg(const struct kvm_vcpu *vcpu, struct sys_reg_desc const *r
>  	return val;
>  }
>  
> +static u64 read_id_reg(const struct kvm_vcpu *vcpu, struct sys_reg_desc const *r)
> +{
> +	if (sysreg_visible_as_raz(vcpu, r))
> +		return 0;
> +
> +	return kvm_arm_read_id_reg(vcpu, reg_to_encoding(r));
> +}
> +
>  /* cpufeature ID register access trap handlers */
>  
>  static bool access_id_reg(struct kvm_vcpu *vcpu,
> @@ -458,3 +459,33 @@ int emulate_id_reg(struct kvm_vcpu *vcpu, struct sys_reg_params *params)
>  
>  	return 1;
>  }
> +
> +/*
> + * Set the guest's ID registers that are defined in id_reg_descs[]
> + * with ID_SANITISED() to the host's sanitized value.
> + */
> +void kvm_arm_init_id_regs(struct kvm *kvm)
> +{
> +	int i;
> +	u32 id;
> +	u64 val;

nit: use reverse christmas/fir tree ordering for locals.

> +	for (i = 0; i < ARRAY_SIZE(id_reg_descs); i++) {
> +		id = reg_to_encoding(&id_reg_descs[i]);
> +		if (WARN_ON_ONCE(!is_id_reg(id)))
> +			/* Shouldn't happen */
> +			continue;

I'll make the suggestion once more.

Please do not implement these sort of sanity checks on static data
structures at the point userspace has gotten involved. Sanity checking
on id_reg_descs[] should happen at the time KVM is initialized. If
anything is wrong at that point we should return an error and outright
refuse to run KVM.

-- 
Thanks,
Oliver
