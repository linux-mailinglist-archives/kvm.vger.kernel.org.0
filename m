Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BB4F6D4E18
	for <lists+kvm@lfdr.de>; Mon,  3 Apr 2023 18:38:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232557AbjDCQiT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Apr 2023 12:38:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232284AbjDCQiQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Apr 2023 12:38:16 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7AF026B1
        for <kvm@vger.kernel.org>; Mon,  3 Apr 2023 09:37:53 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id m6-20020a05600c3b0600b003ee6e324b19so18512601wms.1
        for <kvm@vger.kernel.org>; Mon, 03 Apr 2023 09:37:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1680539872;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=NovDWHlqyKDZ5akhigRWdHUvfhntYGANAshU5Dbe72M=;
        b=bW9+X88L6vecrQZDBliYgXg7g9wDPu9mKFZkn3OwcShhdeM943m2ZuLqXWethK4BYY
         nCHRo1/drV92AFYMccGXk7r5MjP64jtcRzfJNTEkfa5TV0fMVHDgTnCYkXK6osIakztT
         PO0l9ttx7k92f6BWNI7CwNG3dkhVI0RaHeJbltQAedOalnUajbtenQn8YHb7Wqghw6yU
         VAyYx8zXksjDP+Z46n9h8XStJ/Dh+0fPU/fvQA+W87PcR05xKqX7eJJqfFq/SVpKRr7z
         eLvolpbBTNMmBRG/lLjfoGY1CRlUPeSgZrapzXQIxJhUZDq75oqlr6jgSf7hrLEvmrlV
         yj3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680539872;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NovDWHlqyKDZ5akhigRWdHUvfhntYGANAshU5Dbe72M=;
        b=xauAEy+oc+3b6fffWEQ7+sFybVbk6EZoI/hyo7WOhruwQqM1wzvzDzUTdh0s1vP1dz
         ouplOwMkJB2Dl/AlUqRNBoTNDQkzyIazrJDCB3s4TsMGnaUiMEnP4Zl/gQF7xO6hLbEI
         xnAZ6LBTPx9nTQpVYlx6+PEmgmtjfsunD0ON95Zkc6Jk+qv7YU6UNDCMj04t5Ibvrnqc
         fbBB39GoFhd0zyERXCWSRzR0ir7c+V1BNrqrVXO5+dZK45HRXErhQ4xN5OyCysAla8+V
         71LsjmGG0APbmcGIGGsL41fHLIa4/aLdfoK6w7NBQrAaJYNmV0O5CFZEX9w7AUNFVkTd
         gw5A==
X-Gm-Message-State: AAQBX9frrFpambxS1XWsNwfweaXmZTBQo2m5i42C8vEF+mU3fYM8+04s
        vPoHg5Xrw6XxDUmKHeLpgLGjDg==
X-Google-Smtp-Source: AKy350bbP/6C2emmjSzfMLFcPZ+VLoA7bvy1TWvqV89WDwJGgv9Jz3yxv0zMXBIcUnNbRSFQUkPX+w==
X-Received: by 2002:a05:600c:2158:b0:3ef:5e17:1ed9 with SMTP id v24-20020a05600c215800b003ef5e171ed9mr53285wml.31.1680539872026;
        Mon, 03 Apr 2023 09:37:52 -0700 (PDT)
Received: from localhost (2001-1ae9-1c2-4c00-20f-c6b4-1e57-7965.ip6.tmcz.cz. [2001:1ae9:1c2:4c00:20f:c6b4:1e57:7965])
        by smtp.gmail.com with ESMTPSA id az22-20020a05600c601600b003f0472ffc7csm10319848wmb.11.2023.04.03.09.37.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Apr 2023 09:37:51 -0700 (PDT)
Date:   Mon, 3 Apr 2023 18:37:50 +0200
From:   Andrew Jones <ajones@ventanamicro.com>
To:     Anup Patel <apatel@ventanamicro.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 7/8] RISC-V: KVM: Virtualize per-HART AIA CSRs
Message-ID: <boauaf7zkv6bai4jqw7gjp5yexmwgecinen2ss7s2r2qxfn7xv@4jbglkwtrafk>
References: <20230403093310.2271142-1-apatel@ventanamicro.com>
 <20230403093310.2271142-8-apatel@ventanamicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230403093310.2271142-8-apatel@ventanamicro.com>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Apr 03, 2023 at 03:03:09PM +0530, Anup Patel wrote:
> The AIA specification introduce per-HART AIA CSRs which primarily
> support:
> * 64 local interrupts on both RV64 and RV32
> * priority for each of the 64 local interrupts
> * interrupt filtering for local interrupts
> 
> This patch virtualize above mentioned AIA CSRs and also extend
> ONE_REG interface to allow user-space save/restore Guest/VM
> view of these CSRs.
> 
> Signed-off-by: Anup Patel <apatel@ventanamicro.com>
> ---
>  arch/riscv/include/asm/kvm_aia.h  |  88 +++++----
>  arch/riscv/include/asm/kvm_host.h |   7 +-
>  arch/riscv/include/uapi/asm/kvm.h |   7 +
>  arch/riscv/kvm/aia.c              | 317 ++++++++++++++++++++++++++++++
>  arch/riscv/kvm/vcpu.c             |  53 +++--
>  5 files changed, 415 insertions(+), 57 deletions(-)
> 
> diff --git a/arch/riscv/include/asm/kvm_aia.h b/arch/riscv/include/asm/kvm_aia.h
> index 258a835d4c32..1de0717112e5 100644
> --- a/arch/riscv/include/asm/kvm_aia.h
> +++ b/arch/riscv/include/asm/kvm_aia.h

nit: Generating the diff with --patience makes this a bit easier to read,
and/or several of the stub functions could have been directly put in
arch/riscv/kvm/aia.c in the skeleton patch to avoid so many changes in
this one.

> @@ -12,6 +12,7 @@
>  
>  #include <linux/jump_label.h>
>  #include <linux/kvm_types.h>
> +#include <asm/csr.h>
>  
>  struct kvm_aia {
>  	/* In-kernel irqchip created */
> @@ -21,7 +22,22 @@ struct kvm_aia {
>  	bool		initialized;
>  };
>  
> +struct kvm_vcpu_aia_csr {
> +	unsigned long vsiselect;
> +	unsigned long hviprio1;
> +	unsigned long hviprio2;
> +	unsigned long vsieh;
> +	unsigned long hviph;
> +	unsigned long hviprio1h;
> +	unsigned long hviprio2h;
> +};
> +
>  struct kvm_vcpu_aia {
> +	/* CPU AIA CSR context of Guest VCPU */
> +	struct kvm_vcpu_aia_csr guest_csr;
> +
> +	/* CPU AIA CSR context upon Guest VCPU reset */
> +	struct kvm_vcpu_aia_csr guest_reset_csr;
>  };
>  
>  #define kvm_riscv_aia_initialized(k)	((k)->arch.aia.initialized)
> @@ -32,48 +48,50 @@ DECLARE_STATIC_KEY_FALSE(kvm_riscv_aia_available);
>  #define kvm_riscv_aia_available() \
>  	static_branch_unlikely(&kvm_riscv_aia_available)
>  
> -static inline void kvm_riscv_vcpu_aia_flush_interrupts(struct kvm_vcpu *vcpu)
> -{
> -}
> -
> -static inline void kvm_riscv_vcpu_aia_sync_interrupts(struct kvm_vcpu *vcpu)
> -{
> -}
> -
> -static inline bool kvm_riscv_vcpu_aia_has_interrupts(struct kvm_vcpu *vcpu,
> -						     u64 mask)
> -{
> -	return false;
> -}
> -
> -static inline void kvm_riscv_vcpu_aia_update_hvip(struct kvm_vcpu *vcpu)
> -{
> -}
> -
> -static inline void kvm_riscv_vcpu_aia_load(struct kvm_vcpu *vcpu, int cpu)
> -{
> -}
> -
> -static inline void kvm_riscv_vcpu_aia_put(struct kvm_vcpu *vcpu)
> +#define KVM_RISCV_AIA_IMSIC_TOPEI	(ISELECT_MASK + 1)
> +static inline int kvm_riscv_vcpu_aia_imsic_rmw(struct kvm_vcpu *vcpu,
> +					       unsigned long isel,
> +					       unsigned long *val,
> +					       unsigned long new_val,
> +					       unsigned long wr_mask)
>  {
> +	return 0;
>  }
>  
> -static inline int kvm_riscv_vcpu_aia_get_csr(struct kvm_vcpu *vcpu,
> -					     unsigned long reg_num,
> -					     unsigned long *out_val)
> +#ifdef CONFIG_32BIT
> +void kvm_riscv_vcpu_aia_flush_interrupts(struct kvm_vcpu *vcpu);
> +void kvm_riscv_vcpu_aia_sync_interrupts(struct kvm_vcpu *vcpu);
> +#else
> +static inline void kvm_riscv_vcpu_aia_flush_interrupts(struct kvm_vcpu *vcpu)
>  {
> -	*out_val = 0;
> -	return 0;
>  }
> -
> -static inline int kvm_riscv_vcpu_aia_set_csr(struct kvm_vcpu *vcpu,
> -					     unsigned long reg_num,
> -					     unsigned long val)
> +static inline void kvm_riscv_vcpu_aia_sync_interrupts(struct kvm_vcpu *vcpu)
>  {
> -	return 0;
>  }
> -
> -#define KVM_RISCV_VCPU_AIA_CSR_FUNCS
> +#endif
> +bool kvm_riscv_vcpu_aia_has_interrupts(struct kvm_vcpu *vcpu, u64 mask);
> +
> +void kvm_riscv_vcpu_aia_update_hvip(struct kvm_vcpu *vcpu);
> +void kvm_riscv_vcpu_aia_load(struct kvm_vcpu *vcpu, int cpu);
> +void kvm_riscv_vcpu_aia_put(struct kvm_vcpu *vcpu);
> +int kvm_riscv_vcpu_aia_get_csr(struct kvm_vcpu *vcpu,
> +			       unsigned long reg_num,
> +			       unsigned long *out_val);
> +int kvm_riscv_vcpu_aia_set_csr(struct kvm_vcpu *vcpu,
> +			       unsigned long reg_num,
> +			       unsigned long val);
> +
> +int kvm_riscv_vcpu_aia_rmw_topei(struct kvm_vcpu *vcpu,
> +				 unsigned int csr_num,
> +				 unsigned long *val,
> +				 unsigned long new_val,
> +				 unsigned long wr_mask);
> +int kvm_riscv_vcpu_aia_rmw_ireg(struct kvm_vcpu *vcpu, unsigned int csr_num,
> +				unsigned long *val, unsigned long new_val,
> +				unsigned long wr_mask);
> +#define KVM_RISCV_VCPU_AIA_CSR_FUNCS \
> +{ .base = CSR_SIREG,      .count = 1, .func = kvm_riscv_vcpu_aia_rmw_ireg }, \
> +{ .base = CSR_STOPEI,     .count = 1, .func = kvm_riscv_vcpu_aia_rmw_topei },
>  
>  static inline int kvm_riscv_vcpu_aia_update(struct kvm_vcpu *vcpu)
>  {
> diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm/kvm_host.h
> index 3157cf748df1..ee0acccb1d3b 100644
> --- a/arch/riscv/include/asm/kvm_host.h
> +++ b/arch/riscv/include/asm/kvm_host.h
> @@ -204,8 +204,9 @@ struct kvm_vcpu_arch {
>  	 * in irqs_pending. Our approach is modeled around multiple producer
>  	 * and single consumer problem where the consumer is the VCPU itself.
>  	 */
> -	unsigned long irqs_pending;
> -	unsigned long irqs_pending_mask;
> +#define KVM_RISCV_VCPU_NR_IRQS	64
> +	DECLARE_BITMAP(irqs_pending, KVM_RISCV_VCPU_NR_IRQS);
> +	DECLARE_BITMAP(irqs_pending_mask, KVM_RISCV_VCPU_NR_IRQS);

I'd prefer this ulong to bitmap change, and all its repercussions, be done
in a separate patch.

>  
>  	/* VCPU Timer */
>  	struct kvm_vcpu_timer timer;
> @@ -334,7 +335,7 @@ int kvm_riscv_vcpu_set_interrupt(struct kvm_vcpu *vcpu, unsigned int irq);
>  int kvm_riscv_vcpu_unset_interrupt(struct kvm_vcpu *vcpu, unsigned int irq);
>  void kvm_riscv_vcpu_flush_interrupts(struct kvm_vcpu *vcpu);
>  void kvm_riscv_vcpu_sync_interrupts(struct kvm_vcpu *vcpu);
> -bool kvm_riscv_vcpu_has_interrupts(struct kvm_vcpu *vcpu, unsigned long mask);
> +bool kvm_riscv_vcpu_has_interrupts(struct kvm_vcpu *vcpu, u64 mask);
>  void kvm_riscv_vcpu_power_off(struct kvm_vcpu *vcpu);
>  void kvm_riscv_vcpu_power_on(struct kvm_vcpu *vcpu);
>  
> diff --git a/arch/riscv/include/uapi/asm/kvm.h b/arch/riscv/include/uapi/asm/kvm.h
> index cbc3e74fa670..c517e70ddcd6 100644
> --- a/arch/riscv/include/uapi/asm/kvm.h
> +++ b/arch/riscv/include/uapi/asm/kvm.h
> @@ -81,6 +81,13 @@ struct kvm_riscv_csr {
>  
>  /* AIA CSR registers for KVM_GET_ONE_REG and KVM_SET_ONE_REG */
>  struct kvm_riscv_aia_csr {
> +	unsigned long siselect;
> +	unsigned long siprio1;
> +	unsigned long siprio2;
> +	unsigned long sieh;
> +	unsigned long siph;
> +	unsigned long siprio1h;
> +	unsigned long siprio2h;
>  };
>  
>  /* TIMER registers for KVM_GET_ONE_REG and KVM_SET_ONE_REG */
> diff --git a/arch/riscv/kvm/aia.c b/arch/riscv/kvm/aia.c
> index 7a633331cd3e..d530912f28bc 100644
> --- a/arch/riscv/kvm/aia.c
> +++ b/arch/riscv/kvm/aia.c
> @@ -26,6 +26,323 @@ static void aia_set_hvictl(bool ext_irq_pending)
>  	csr_write(CSR_HVICTL, hvictl);
>  }
>  
> +#ifdef CONFIG_32BIT
> +void kvm_riscv_vcpu_aia_flush_interrupts(struct kvm_vcpu *vcpu)
> +{
> +	struct kvm_vcpu_aia_csr *csr = &vcpu->arch.aia_context.guest_csr;
> +	unsigned long mask, val;
> +
> +	if (!kvm_riscv_aia_available())
> +		return;
> +
> +	if (READ_ONCE(vcpu->arch.irqs_pending_mask[1])) {
> +		mask = xchg_acquire(&vcpu->arch.irqs_pending_mask[1], 0);
> +		val = READ_ONCE(vcpu->arch.irqs_pending[1]) & mask;
> +
> +		csr->hviph &= ~mask;
> +		csr->hviph |= val;
> +	}
> +}
> +
> +void kvm_riscv_vcpu_aia_sync_interrupts(struct kvm_vcpu *vcpu)
> +{
> +	struct kvm_vcpu_aia_csr *csr = &vcpu->arch.aia_context.guest_csr;
> +
> +	if (kvm_riscv_aia_available())
> +		csr->vsieh = csr_read(CSR_VSIEH);
> +}
> +#endif
> +
> +bool kvm_riscv_vcpu_aia_has_interrupts(struct kvm_vcpu *vcpu, u64 mask)
> +{
> +	unsigned long seip;
> +
> +	if (!kvm_riscv_aia_available())
> +		return false;
> +
> +#ifdef CONFIG_32BIT
> +	if (READ_ONCE(vcpu->arch.irqs_pending[1]) &
> +	    (vcpu->arch.aia_context.guest_csr.vsieh & (unsigned long)(mask >> 32)))

upper_32_bits()

> +		return true;
> +#endif
> +
> +	seip = vcpu->arch.guest_csr.vsie;
> +	seip &= (unsigned long)mask;
> +	seip &= BIT(IRQ_S_EXT);

Please add a blank line above the if-statement.

> +	if (!kvm_riscv_aia_initialized(vcpu->kvm) || !seip)

Shouldn't we check kvm_riscv_aia_initialized() at the top of this
function?

> +		return false;
> +
> +	return false;

return true

But if we move kvm_riscv_aia_initialized() up, then we instead can do

 return !!seip;

> +}
> +
> +void kvm_riscv_vcpu_aia_update_hvip(struct kvm_vcpu *vcpu)
> +{
> +	struct kvm_vcpu_csr *csr = &vcpu->arch.guest_csr;
> +
> +	if (!kvm_riscv_aia_available())
> +		return;
> +
> +#ifdef CONFIG_32BIT
> +	csr_write(CSR_HVIPH, vcpu->arch.aia_context.guest_csr.hviph);
> +#endif
> +	aia_set_hvictl((csr->hvip & BIT(IRQ_VS_EXT)) ? true : false);

The compiler will manage the conversion of csr->hvip & BIT(IRQ_VS_EXT)
to a 1 or 0 since it's getting passed in as a boolean parameter.

> +}
> +
> +void kvm_riscv_vcpu_aia_load(struct kvm_vcpu *vcpu, int cpu)
> +{
> +	struct kvm_vcpu_aia_csr *csr = &vcpu->arch.aia_context.guest_csr;
> +
> +	if (!kvm_riscv_aia_available())
> +		return;
> +
> +	csr_write(CSR_VSISELECT, csr->vsiselect);
> +	csr_write(CSR_HVIPRIO1, csr->hviprio1);
> +	csr_write(CSR_HVIPRIO2, csr->hviprio2);
> +#ifdef CONFIG_32BIT
> +	csr_write(CSR_VSIEH, csr->vsieh);
> +	csr_write(CSR_HVIPH, csr->hviph);
> +	csr_write(CSR_HVIPRIO1H, csr->hviprio1h);
> +	csr_write(CSR_HVIPRIO2H, csr->hviprio2h);
> +#endif
> +}
> +
> +void kvm_riscv_vcpu_aia_put(struct kvm_vcpu *vcpu)
> +{
> +	struct kvm_vcpu_aia_csr *csr = &vcpu->arch.aia_context.guest_csr;
> +
> +	if (!kvm_riscv_aia_available())
> +		return;
> +
> +	csr->vsiselect = csr_read(CSR_VSISELECT);
> +	csr->hviprio1 = csr_read(CSR_HVIPRIO1);
> +	csr->hviprio2 = csr_read(CSR_HVIPRIO2);
> +#ifdef CONFIG_32BIT
> +	csr->vsieh = csr_read(CSR_VSIEH);
> +	csr->hviph = csr_read(CSR_HVIPH);
> +	csr->hviprio1h = csr_read(CSR_HVIPRIO1H);
> +	csr->hviprio2h = csr_read(CSR_HVIPRIO2H);
> +#endif
> +}
> +
> +int kvm_riscv_vcpu_aia_get_csr(struct kvm_vcpu *vcpu,
> +			       unsigned long reg_num,
> +			       unsigned long *out_val)
> +{
> +	struct kvm_vcpu_aia_csr *csr = &vcpu->arch.aia_context.guest_csr;
> +
> +	if (reg_num >= sizeof(struct kvm_riscv_aia_csr) / sizeof(unsigned long))
> +		return -EINVAL;
> +
> +	*out_val = 0;
> +	if (kvm_riscv_aia_available())
> +		*out_val = ((unsigned long *)csr)[reg_num];
> +
> +	return 0;
> +}
> +
> +int kvm_riscv_vcpu_aia_set_csr(struct kvm_vcpu *vcpu,
> +			       unsigned long reg_num,
> +			       unsigned long val)
> +{
> +	struct kvm_vcpu_aia_csr *csr = &vcpu->arch.aia_context.guest_csr;
> +
> +	if (reg_num >= sizeof(struct kvm_riscv_aia_csr) / sizeof(unsigned long))
> +		return -EINVAL;
> +
> +	if (kvm_riscv_aia_available()) {
> +		((unsigned long *)csr)[reg_num] = val;
> +
> +#ifdef CONFIG_32BIT
> +		if (reg_num == KVM_REG_RISCV_CSR_AIA_REG(siph))
> +			WRITE_ONCE(vcpu->arch.irqs_pending_mask[1], 0);
> +#endif
> +	}
> +
> +	return 0;
> +}
> +
> +int kvm_riscv_vcpu_aia_rmw_topei(struct kvm_vcpu *vcpu,
> +				 unsigned int csr_num,
> +				 unsigned long *val,
> +				 unsigned long new_val,
> +				 unsigned long wr_mask)
> +{
> +	/* If AIA not available then redirect trap */
> +	if (!kvm_riscv_aia_available())
> +		return KVM_INSN_ILLEGAL_TRAP;
> +
> +	/* If AIA not initialized then forward to user space */
> +	if (!kvm_riscv_aia_initialized(vcpu->kvm))
> +		return KVM_INSN_EXIT_TO_USER_SPACE;
> +
> +	return kvm_riscv_vcpu_aia_imsic_rmw(vcpu, KVM_RISCV_AIA_IMSIC_TOPEI,
> +					    val, new_val, wr_mask);
> +}
> +
> +/*
> + * External IRQ priority always read-only zero. This means default
> + * priority order  is always preferred for external IRQs unless
> + * HVICTL.IID == 9 and HVICTL.IPRIO != 0
> + */
> +static int aia_irq2bitpos[] = {
> +0,     8,   -1,   -1,   16,   24,   -1,   -1, /* 0 - 7 */
> +32,   -1,   -1,   -1,   -1,   40,   48,   56, /* 8 - 15 */
> +64,   72,   80,   88,   96,  104,  112,  120, /* 16 - 23 */
> +-1,   -1,   -1,   -1,   -1,   -1,   -1,   -1, /* 24 - 31 */
> +-1,   -1,   -1,   -1,   -1,   -1,   -1,   -1, /* 32 - 39 */
> +-1,   -1,   -1,   -1,   -1,   -1,   -1,   -1, /* 40 - 47 */
> +-1,   -1,   -1,   -1,   -1,   -1,   -1,   -1, /* 48 - 55 */
> +-1,   -1,   -1,   -1,   -1,   -1,   -1,   -1, /* 56 - 63 */
> +};
> +
> +static u8 aia_get_iprio8(struct kvm_vcpu *vcpu, unsigned int irq)
> +{
> +	unsigned long hviprio;
> +	int bitpos = aia_irq2bitpos[irq];
> +
> +	if (bitpos < 0)
> +		return 0;
> +
> +	switch (bitpos / BITS_PER_LONG) {
> +	case 0:
> +		hviprio = csr_read(CSR_HVIPRIO1);
> +		break;
> +	case 1:
> +#ifndef CONFIG_32BIT
> +		hviprio = csr_read(CSR_HVIPRIO2);
> +		break;
> +#else
> +		hviprio = csr_read(CSR_HVIPRIO1H);
> +		break;
> +	case 2:
> +		hviprio = csr_read(CSR_HVIPRIO2);
> +		break;
> +	case 3:
> +		hviprio = csr_read(CSR_HVIPRIO2H);
> +		break;
> +#endif
> +	default:
> +		return 0;
> +	};
         ^ unnecessary ;
> +
> +	return (hviprio >> (bitpos % BITS_PER_LONG)) & TOPI_IPRIO_MASK;
> +}
> +
> +static void aia_set_iprio8(struct kvm_vcpu *vcpu, unsigned int irq, u8 prio)
> +{
> +	unsigned long hviprio;
> +	int bitpos = aia_irq2bitpos[irq];
> +
> +	if (bitpos < 0)
> +		return;
> +
> +	switch (bitpos / BITS_PER_LONG) {
> +	case 0:
> +		hviprio = csr_read(CSR_HVIPRIO1);
> +		break;
> +	case 1:
> +#ifndef CONFIG_32BIT
> +		hviprio = csr_read(CSR_HVIPRIO2);
> +		break;
> +#else
> +		hviprio = csr_read(CSR_HVIPRIO1H);
> +		break;
> +	case 2:
> +		hviprio = csr_read(CSR_HVIPRIO2);
> +		break;
> +	case 3:
> +		hviprio = csr_read(CSR_HVIPRIO2H);
> +		break;
> +#endif
> +	default:
> +		return;
> +	};
         ^ unnecessary ;

The csr read switch could be put in a helper and shared between the get
and set functions.

> +
> +	hviprio &= ~((unsigned long)TOPI_IPRIO_MASK <<

I don't think the (unsigned long) cast is necessary, as I believe
TOPI_IPRIO_MASK is already an unsigned long.

> +		     (bitpos % BITS_PER_LONG));
> +	hviprio |= (unsigned long)prio << (bitpos % BITS_PER_LONG);
> +
> +	switch (bitpos / BITS_PER_LONG) {
> +	case 0:
> +		csr_write(CSR_HVIPRIO1, hviprio);
> +		break;
> +	case 1:
> +#ifndef CONFIG_32BIT
> +		csr_write(CSR_HVIPRIO2, hviprio);
> +		break;
> +#else
> +		csr_write(CSR_HVIPRIO1H, hviprio);
> +		break;
> +	case 2:
> +		csr_write(CSR_HVIPRIO2, hviprio);
> +		break;
> +	case 3:
> +		csr_write(CSR_HVIPRIO2H, hviprio);
> +		break;
> +#endif
> +	default:
> +		return;
> +	};
         ^ unnecessary ;

> +}
> +
> +static int aia_rmw_iprio(struct kvm_vcpu *vcpu, unsigned int isel,
> +			 unsigned long *val, unsigned long new_val,
> +			 unsigned long wr_mask)
> +{
> +	int i, firq, nirqs;

nit: I guessed 'f' is for 'first', but 'first_irq' would make that more
clear from the start.

> +	unsigned long old_val;
> +
> +#ifndef CONFIG_32BIT
> +	if (isel & 0x1)
> +		return KVM_INSN_ILLEGAL_TRAP;
> +#endif
> +
> +	nirqs = 4 * (BITS_PER_LONG / 32);
> +	firq = ((isel - ISELECT_IPRIO0) / (BITS_PER_LONG / 32)) * (nirqs);

This is just firq = 4 * (isel - ISELECT_IPRIO0);

> +
> +	old_val = 0;
> +	for (i = 0; i < nirqs; i++)
> +		old_val |= (unsigned long)aia_get_iprio8(vcpu, firq + i) <<
> +			   (TOPI_IPRIO_BITS * i);

nit: normally would indent to under the (

> +
> +	if (val)
> +		*val = old_val;
> +
> +	if (wr_mask) {
> +		new_val = (old_val & ~wr_mask) | (new_val & wr_mask);
> +		for (i = 0; i < nirqs; i++)
> +			aia_set_iprio8(vcpu, firq + i,
> +			(new_val >> (TOPI_IPRIO_BITS * i)) & TOPI_IPRIO_MASK);

nit: normally would indent to under the (

> +	}
> +
> +	return KVM_INSN_CONTINUE_NEXT_SEPC;
> +}
> +
> +#define IMSIC_FIRST	0x70
> +#define IMSIC_LAST	0xff
> +int kvm_riscv_vcpu_aia_rmw_ireg(struct kvm_vcpu *vcpu, unsigned int csr_num,
> +				unsigned long *val, unsigned long new_val,
> +				unsigned long wr_mask)
> +{
> +	unsigned int isel;
> +
> +	/* If AIA not available then redirect trap */
> +	if (!kvm_riscv_aia_available())
> +		return KVM_INSN_ILLEGAL_TRAP;
> +
> +	/* First try to emulate in kernel space */
> +	isel = csr_read(CSR_VSISELECT) & ISELECT_MASK;
> +	if (isel >= ISELECT_IPRIO0 && isel <= ISELECT_IPRIO15)
> +		return aia_rmw_iprio(vcpu, isel, val, new_val, wr_mask);
> +	else if (isel >= IMSIC_FIRST && isel <= IMSIC_LAST &&
> +		 kvm_riscv_aia_initialized(vcpu->kvm))
> +		return kvm_riscv_vcpu_aia_imsic_rmw(vcpu, isel, val, new_val,
> +						    wr_mask);
> +
> +	/* We can't handle it here so redirect to user space */
> +	return KVM_INSN_EXIT_TO_USER_SPACE;
> +}
> +
>  void kvm_riscv_aia_enable(void)
>  {
>  	if (!kvm_riscv_aia_available())
> diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
> index 15507cd3a595..30acf3ebdc3d 100644
> --- a/arch/riscv/kvm/vcpu.c
> +++ b/arch/riscv/kvm/vcpu.c
> @@ -141,8 +141,8 @@ static void kvm_riscv_reset_vcpu(struct kvm_vcpu *vcpu)
>  
>  	kvm_riscv_vcpu_aia_reset(vcpu);
>  
> -	WRITE_ONCE(vcpu->arch.irqs_pending, 0);
> -	WRITE_ONCE(vcpu->arch.irqs_pending_mask, 0);
> +	bitmap_zero(vcpu->arch.irqs_pending, KVM_RISCV_VCPU_NR_IRQS);
> +	bitmap_zero(vcpu->arch.irqs_pending_mask, KVM_RISCV_VCPU_NR_IRQS);
>  
>  	kvm_riscv_vcpu_pmu_reset(vcpu);
>  
> @@ -474,6 +474,7 @@ static int kvm_riscv_vcpu_general_get_csr(struct kvm_vcpu *vcpu,
>  	if (reg_num == KVM_REG_RISCV_CSR_REG(sip)) {
>  		kvm_riscv_vcpu_flush_interrupts(vcpu);
>  		*out_val = (csr->hvip >> VSIP_TO_HVIP_SHIFT) & VSIP_VALID_MASK;
> +		*out_val |= csr->hvip & ~IRQ_LOCAL_MASK;
>  	} else
>  		*out_val = ((unsigned long *)csr)[reg_num];
>  
> @@ -497,7 +498,7 @@ static inline int kvm_riscv_vcpu_general_set_csr(struct kvm_vcpu *vcpu,
>  	((unsigned long *)csr)[reg_num] = reg_val;
>  
>  	if (reg_num == KVM_REG_RISCV_CSR_REG(sip))
> -		WRITE_ONCE(vcpu->arch.irqs_pending_mask, 0);
> +		WRITE_ONCE(vcpu->arch.irqs_pending_mask[0], 0);
>  
>  	return 0;
>  }
> @@ -799,9 +800,9 @@ void kvm_riscv_vcpu_flush_interrupts(struct kvm_vcpu *vcpu)
>  	struct kvm_vcpu_csr *csr = &vcpu->arch.guest_csr;
>  	unsigned long mask, val;
>  
> -	if (READ_ONCE(vcpu->arch.irqs_pending_mask)) {
> -		mask = xchg_acquire(&vcpu->arch.irqs_pending_mask, 0);
> -		val = READ_ONCE(vcpu->arch.irqs_pending) & mask;
> +	if (READ_ONCE(vcpu->arch.irqs_pending_mask[0])) {
> +		mask = xchg_acquire(&vcpu->arch.irqs_pending_mask[0], 0);
> +		val = READ_ONCE(vcpu->arch.irqs_pending[0]) & mask;
>  
>  		csr->hvip &= ~mask;
>  		csr->hvip |= val;
> @@ -825,12 +826,12 @@ void kvm_riscv_vcpu_sync_interrupts(struct kvm_vcpu *vcpu)
>  	if ((csr->hvip ^ hvip) & (1UL << IRQ_VS_SOFT)) {
>  		if (hvip & (1UL << IRQ_VS_SOFT)) {
>  			if (!test_and_set_bit(IRQ_VS_SOFT,
> -					      &v->irqs_pending_mask))
> -				set_bit(IRQ_VS_SOFT, &v->irqs_pending);
> +					      v->irqs_pending_mask))
> +				set_bit(IRQ_VS_SOFT, v->irqs_pending);
>  		} else {
>  			if (!test_and_set_bit(IRQ_VS_SOFT,
> -					      &v->irqs_pending_mask))
> -				clear_bit(IRQ_VS_SOFT, &v->irqs_pending);
> +					      v->irqs_pending_mask))
> +				clear_bit(IRQ_VS_SOFT, v->irqs_pending);
>  		}
>  	}
>  
> @@ -843,14 +844,20 @@ void kvm_riscv_vcpu_sync_interrupts(struct kvm_vcpu *vcpu)
>  
>  int kvm_riscv_vcpu_set_interrupt(struct kvm_vcpu *vcpu, unsigned int irq)
>  {
> -	if (irq != IRQ_VS_SOFT &&
> +	/*
> +	 * We only allow VS-mode software, timer, and external
> +	 * interrupts when irq is one of the local interrupts
> +	 * defined by RISC-V privilege specification.
> +	 */
> +	if (irq < IRQ_LOCAL_MAX &&
> +	    irq != IRQ_VS_SOFT &&
>  	    irq != IRQ_VS_TIMER &&
>  	    irq != IRQ_VS_EXT)
>  		return -EINVAL;
>  
> -	set_bit(irq, &vcpu->arch.irqs_pending);
> +	set_bit(irq, vcpu->arch.irqs_pending);
>  	smp_mb__before_atomic();
> -	set_bit(irq, &vcpu->arch.irqs_pending_mask);
> +	set_bit(irq, vcpu->arch.irqs_pending_mask);
>  
>  	kvm_vcpu_kick(vcpu);
>  
> @@ -859,25 +866,33 @@ int kvm_riscv_vcpu_set_interrupt(struct kvm_vcpu *vcpu, unsigned int irq)
>  
>  int kvm_riscv_vcpu_unset_interrupt(struct kvm_vcpu *vcpu, unsigned int irq)
>  {
> -	if (irq != IRQ_VS_SOFT &&
> +	/*
> +	 * We only allow VS-mode software, timer, and external
> +	 * interrupts when irq is one of the local interrupts
> +	 * defined by RISC-V privilege specification.
> +	 */
> +	if (irq < IRQ_LOCAL_MAX &&
> +	    irq != IRQ_VS_SOFT &&
>  	    irq != IRQ_VS_TIMER &&
>  	    irq != IRQ_VS_EXT)
>  		return -EINVAL;
>  
> -	clear_bit(irq, &vcpu->arch.irqs_pending);
> +	clear_bit(irq, vcpu->arch.irqs_pending);
>  	smp_mb__before_atomic();
> -	set_bit(irq, &vcpu->arch.irqs_pending_mask);
> +	set_bit(irq, vcpu->arch.irqs_pending_mask);
>  
>  	return 0;
>  }
>  
> -bool kvm_riscv_vcpu_has_interrupts(struct kvm_vcpu *vcpu, unsigned long mask)
> +bool kvm_riscv_vcpu_has_interrupts(struct kvm_vcpu *vcpu, u64 mask)
>  {
>  	unsigned long ie;
>  
>  	ie = ((vcpu->arch.guest_csr.vsie & VSIP_VALID_MASK)
> -		<< VSIP_TO_HVIP_SHIFT) & mask;
> -	if (READ_ONCE(vcpu->arch.irqs_pending) & ie)
> +		<< VSIP_TO_HVIP_SHIFT) & (unsigned long)mask;
> +	ie |= vcpu->arch.guest_csr.vsie & ~IRQ_LOCAL_MASK &
> +		(unsigned long)mask;
> +	if (READ_ONCE(vcpu->arch.irqs_pending[0]) & ie)
>  		return true;
>  
>  	/* Check AIA high interrupts */
> -- 
> 2.34.1
>

Thanks,
drew
