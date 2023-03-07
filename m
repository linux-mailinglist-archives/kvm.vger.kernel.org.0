Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB4F16AF924
	for <lists+kvm@lfdr.de>; Tue,  7 Mar 2023 23:45:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231217AbjCGWpY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Mar 2023 17:45:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230206AbjCGWpG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Mar 2023 17:45:06 -0500
Received: from out-59.mta1.migadu.com (out-59.mta1.migadu.com [95.215.58.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1FBD2057C
        for <kvm@vger.kernel.org>; Tue,  7 Mar 2023 14:44:52 -0800 (PST)
Date:   Tue, 7 Mar 2023 22:44:45 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1678229090;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=o0yOct0fTg2a0fiGhYTaldY+nw5yPHcKNkg12RI4tFQ=;
        b=ZWI2USo4H1YR2f/969TskNeavITQaMXA4yWJfpxbZlqMfEoL4kvHh2QkdMgm7ib2uqmgrv
        vuCK7xDlKyoqUYNJgypnD0uO/MGVxT/xGwVTugDJhG61MtDkyieDNHWUe/3fI+4JBbfKuJ
        dduc2MJ6QjHiORwKcTdkRuwv083/F74=
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
        Ricardo Koller <ricarkol@google.com>,
        Raghavendra Rao Ananta <rananta@google.com>
Subject: Re: [PATCH v3 2/6] KVM: arm64: Save ID registers' sanitized value
 per guest
Message-ID: <ZAe+XettpauZe84X@linux.dev>
References: <20230228062246.1222387-1-jingzhangos@google.com>
 <20230228062246.1222387-3-jingzhangos@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230228062246.1222387-3-jingzhangos@google.com>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Jing,

On Tue, Feb 28, 2023 at 06:22:42AM +0000, Jing Zhang wrote:
> From: Reiji Watanabe <reijiw@google.com>
> 
> Introduce id_regs[] in kvm_arch as a storage of guest's ID registers,
> and save ID registers' sanitized value in the array at KVM_CREATE_VM.
> Use the saved ones when ID registers are read by the guest or
> userspace (via KVM_GET_ONE_REG).
> 
> No functional change intended.
> 
> Signed-off-by: Reiji Watanabe <reijiw@google.com>
> Co-developed-by: Jing Zhang <jingzhangos@google.com>
> Signed-off-by: Jing Zhang <jingzhangos@google.com>
> ---
>  arch/arm64/include/asm/kvm_host.h | 12 +++++++++
>  arch/arm64/kvm/arm.c              |  1 +
>  arch/arm64/kvm/id_regs.c          | 44 ++++++++++++++++++++++++-------
>  arch/arm64/kvm/sys_regs.c         |  2 +-
>  arch/arm64/kvm/sys_regs.h         |  1 +
>  5 files changed, 50 insertions(+), 10 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index a1892a8f6032..5c1cec4efa37 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -245,6 +245,16 @@ struct kvm_arch {
>  	 * the associated pKVM instance in the hypervisor.
>  	 */
>  	struct kvm_protected_vm pkvm;
> +
> +	/*
> +	 * Save ID registers for the guest in id_regs[].
> +	 * (Op0, Op1, CRn, CRm, Op2) of the ID registers to be saved in it
> +	 * is (3, 0, 0, crm, op2), where 1<=crm<8, 0<=op2<8.
> +	 */
> +#define KVM_ARM_ID_REG_NUM	56
> +#define IDREG_IDX(id)		(((sys_reg_CRm(id) - 1) << 3) | sys_reg_Op2(id))
> +#define IDREG(kvm, id)		kvm->arch.id_regs[IDREG_IDX(id)]

I feel like the IDREG(...) macro just obfuscates what is otherwise a
simple array access.

> +static u64 read_id_reg(const struct kvm_vcpu *vcpu, struct sys_reg_desc const *r)
> +{
> +	if (sysreg_visible_as_raz(vcpu, r))
> +		return 0;
> +
> +	return kvm_arm_read_id_reg_with_encoding(vcpu, reg_to_encoding(r));

nit: you could probably drop the '_with_encoding' suffix, as I don't
believe there are any other flavors of accessors.

> +}
> +
>  /* cpufeature ID register access trap handlers */
>  
>  static bool access_id_reg(struct kvm_vcpu *vcpu,
> @@ -504,3 +505,28 @@ int kvm_arm_walk_id_regs(struct kvm_vcpu *vcpu, u64 __user *uind)
>  	}
>  	return total;
>  }
> +
> +/*
> + * Set the guest's ID registers that are defined in id_reg_descs[]
> + * with ID_SANITISED() to the host's sanitized value.
> + */
> +void kvm_arm_set_default_id_regs(struct kvm *kvm)
> +{
> +	int i;
> +	u32 id;
> +	u64 val;
> +
> +	for (i = 0; i < ARRAY_SIZE(id_reg_descs); i++) {
> +		id = reg_to_encoding(&id_reg_descs[i]);
> +		if (WARN_ON_ONCE(!is_id_reg(id)))
> +			/* Shouldn't happen */
> +			continue;

Could you instead wire in a check to kvm_sys_reg_table_init() or do
something similar to it? Benefit of going that route is we outright
refuse to run KVM with such an egregious bug.

> +
> +		if (id_reg_descs[i].visibility == raz_visibility)
> +			/* Hidden or reserved ID register */
> +			continue;

This sort of check works only for registers known to be RAZ at compile
time, but not for others that depend on runtime configuration. Is it
possible to reset the ID register values on the first call to
KVM_ARM_VCPU_INIT?

The set of configured features is available at that point so you can
actually handle things like SVE and 32-bit ID registers correctly.

-- 
Thanks,
Oliver
