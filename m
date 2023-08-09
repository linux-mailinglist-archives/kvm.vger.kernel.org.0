Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8359277609E
	for <lists+kvm@lfdr.de>; Wed,  9 Aug 2023 15:28:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232992AbjHIN22 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Aug 2023 09:28:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232937AbjHIN2R (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Aug 2023 09:28:17 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96BFE10CC
        for <kvm@vger.kernel.org>; Wed,  9 Aug 2023 06:27:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1691587655;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OwCX0lUEuIP9ATmkSZdYEZDYGtv8hnFdu00DnuutpMg=;
        b=L0xp4lC2nYqdrFYfP2vvIKKAXCIuB8BbhmI8+6TO/WIEjt9ap59CPXVJcdHvFeXaE4vf/C
        6fXXvu3qTDdaBEjsYFoAmdPW0w6lFcOviCdM+tXZPVjzw+7i3sSRF8RrCo4nF54ebu1Zww
        KmfAZ6+ZVqzywxGbFrvme++HydIyvL4=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-595-M2X-HppSPt2qJKb6UXuLFg-1; Wed, 09 Aug 2023 09:27:33 -0400
X-MC-Unique: M2X-HppSPt2qJKb6UXuLFg-1
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-768197bad1bso599571285a.3
        for <kvm@vger.kernel.org>; Wed, 09 Aug 2023 06:27:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691587653; x=1692192453;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OwCX0lUEuIP9ATmkSZdYEZDYGtv8hnFdu00DnuutpMg=;
        b=ANhZBuHKkGXUU16pmeThvH6UFaWXxJuge4idKEa1lEjxUgnPlCtv5gJ50DVpImz6qJ
         9Pw4NrB2R0ATbFOJvGM5AyqfQRdJORNJwi0OHlG2WJnRlZVtBB42YUNNj9/maKyC5rvO
         7v/Bf0UjN351Pf/vZzhAeyxYh/FIW1WdGcVTyz2WZeOHv7TPj4ecDVEj54rLxgyGW1+3
         EkVz/MdPO75i92kd6SJXjY/uynsnwzSMWaSG/6I7XS9sfg8AYQND0wJApxNXJ5ypN1l/
         cpmULpuUAq6hUIVLNsFQc3fATsg5VoWawcHUzHUjMEs1bSbkhYzcbHmzTzP5qwXatBez
         n5VQ==
X-Gm-Message-State: AOJu0YxPsbeVj5KjEwH/mf94M8ksPsK3ftnNKeZucyFfBFtvWzRdKhg6
        ROBbkroaYcJL048x23xBDg4qV4RwaLnfeLYyU5F2BqR0RQQtlk4184fa2S8yJK+v88CWWrCXgqK
        kZj5GhXzuN7Kq
X-Received: by 2002:a05:620a:21ce:b0:76c:e764:5085 with SMTP id h14-20020a05620a21ce00b0076ce7645085mr2800512qka.54.1691587653331;
        Wed, 09 Aug 2023 06:27:33 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF+SQ9WfFzAqfpUvqvscz2ikVYbRM8AneWn/3KMenV7omEUI3H0Cpp8LKkpnDpiC2tMdfLF2A==
X-Received: by 2002:a05:620a:21ce:b0:76c:e764:5085 with SMTP id h14-20020a05620a21ce00b0076ce7645085mr2800479qka.54.1691587652968;
        Wed, 09 Aug 2023 06:27:32 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id d17-20020a05620a159100b00767d05117fesm3980198qkk.36.2023.08.09.06.27.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Aug 2023 06:27:32 -0700 (PDT)
Message-ID: <18eae581-500b-9c9e-2cce-e2f5fb007071@redhat.com>
Date:   Wed, 9 Aug 2023 15:27:27 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH v3 14/27] KVM: arm64: nv: Add trap forwarding
 infrastructure
Content-Language: en-US
To:     Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc:     Catalin Marinas <catalin.marinas@arm.com>,
        Mark Brown <broonie@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Will Deacon <will@kernel.org>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Andre Przywara <andre.przywara@arm.com>,
        Chase Conklin <chase.conklin@arm.com>,
        Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
        Darren Hart <darren@os.amperecomputing.com>,
        Miguel Luis <miguel.luis@oracle.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Zenghui Yu <yuzenghui@huawei.com>
References: <20230808114711.2013842-1-maz@kernel.org>
 <20230808114711.2013842-15-maz@kernel.org>
From:   Eric Auger <eric.auger@redhat.com>
In-Reply-To: <20230808114711.2013842-15-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On 8/8/23 13:46, Marc Zyngier wrote:
> A significant part of what a NV hypervisor needs to do is to decide
> whether a trap from a L2+ guest has to be forwarded to a L1 guest
> or handled locally. This is done by checking for the trap bits that
> the guest hypervisor has set and acting accordingly, as described by
> the architecture.
>
> A previous approach was to sprinkle a bunch of checks in all the
> system register accessors, but this is pretty error prone and doesn't
> help getting an overview of what is happening.
>
> Instead, implement a set of global tables that describe a trap bit,
> combinations of trap bits, behaviours on trap, and what bits must
> be evaluated on a system register trap.
>
> Although this is painful to describe, this allows to specify each
> and every control bit in a static manner. To make it efficient,
> the table is inserted in an xarray that is global to the system,
> and checked each time we trap a system register while running
> a L2 guest.
>
> Add the basic infrastructure for now, while additional patches will
> implement configuration registers.
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/include/asm/kvm_host.h   |   1 +
>  arch/arm64/include/asm/kvm_nested.h |   2 +
>  arch/arm64/kvm/emulate-nested.c     | 262 ++++++++++++++++++++++++++++
>  arch/arm64/kvm/sys_regs.c           |   6 +
>  arch/arm64/kvm/trace_arm.h          |  26 +++
>  5 files changed, 297 insertions(+)
>
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 721680da1011..cb1c5c54cedd 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -988,6 +988,7 @@ int kvm_handle_cp10_id(struct kvm_vcpu *vcpu);
>  void kvm_reset_sys_regs(struct kvm_vcpu *vcpu);
>  
>  int __init kvm_sys_reg_table_init(void);
> +int __init populate_nv_trap_config(void);
>  
>  bool lock_all_vcpus(struct kvm *kvm);
>  void unlock_all_vcpus(struct kvm *kvm);
> diff --git a/arch/arm64/include/asm/kvm_nested.h b/arch/arm64/include/asm/kvm_nested.h
> index 8fb67f032fd1..fa23cc9c2adc 100644
> --- a/arch/arm64/include/asm/kvm_nested.h
> +++ b/arch/arm64/include/asm/kvm_nested.h
> @@ -11,6 +11,8 @@ static inline bool vcpu_has_nv(const struct kvm_vcpu *vcpu)
>  		test_bit(KVM_ARM_VCPU_HAS_EL2, vcpu->arch.features));
>  }
>  
> +extern bool __check_nv_sr_forward(struct kvm_vcpu *vcpu);
> +
>  struct sys_reg_params;
>  struct sys_reg_desc;
>  
> diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nested.c
> index b96662029fb1..1b1148770d45 100644
> --- a/arch/arm64/kvm/emulate-nested.c
> +++ b/arch/arm64/kvm/emulate-nested.c
> @@ -14,6 +14,268 @@
>  
>  #include "trace.h"
>  
> +enum trap_behaviour {
> +	BEHAVE_HANDLE_LOCALLY	= 0,
> +	BEHAVE_FORWARD_READ	= BIT(0),
> +	BEHAVE_FORWARD_WRITE	= BIT(1),
> +	BEHAVE_FORWARD_ANY	= BEHAVE_FORWARD_READ | BEHAVE_FORWARD_WRITE,
> +};
> +
> +struct trap_bits {
> +	const enum vcpu_sysreg		index;
> +	const enum trap_behaviour	behaviour;
> +	const u64			value;
> +	const u64			mask;
> +};
> +
> +enum trap_group {
nit: Maybe add a comment saying that it relates to *coarse* trapping as
opposed to the other enum which is named fgt_group_id. cgt_group_id may
have been better but well ;-)

> +	/* Indicates no coarse trap control */
> +	__RESERVED__,
> +
> +	/*
> +	 * The first batch of IDs denote coarse trapping that are used
> +	 * on their own instead of being part of a combination of
> +	 * trap controls.
> +	 */
> +
> +	/*
> +	 * Anything after this point is a combination of trap controls,
coarse trap controls
> +	 * which all must be evaluated to decide what to do.
> +	 */
> +	__MULTIPLE_CONTROL_BITS__,
> +
> +	/*
> +	 * Anything after this point requires a callback evaluating a
> +	 * complex trap condition. Hopefully we'll never need this...
> +	 */
> +	__COMPLEX_CONDITIONS__,
> +
> +	/* Must be last */
> +	__NR_TRAP_GROUP_IDS__
> +};
> +
> +static const struct trap_bits coarse_trap_bits[] = {
> +};
> +
> +#define MCB(id, ...)					\
> +	[id - __MULTIPLE_CONTROL_BITS__]	=	\
> +		(const enum trap_group []){		\
> +			__VA_ARGS__, __RESERVED__	\
> +		}
> +
> +static const enum trap_group *coarse_control_combo[] = {
> +};
> +
> +typedef enum trap_behaviour (*complex_condition_check)(struct kvm_vcpu *);
> +
> +#define CCC(id, fn)				\
> +	[id - __COMPLEX_CONDITIONS__] = fn
> +
> +static const complex_condition_check ccc[] = {
> +};
> +
> +/*
> + * Bit assignment for the trap controls. We use a 64bit word with the
> + * following layout for each trapped sysreg:
> + *
> + * [9:0]	enum trap_group (10 bits)
> + * [13:10]	enum fgt_group_id (4 bits)
> + * [19:14]	bit number in the FGT register (6 bits)
> + * [20]		trap polarity (1 bit)
> + * [62:21]	Unused (42 bits)
> + * [63]		RES0 - Must be zero, as lost on insertion in the xarray
what do you mean by "as lost"
> + */
> +#define TC_CGT_BITS	10
> +#define TC_FGT_BITS	4
> +
> +union trap_config {
> +	u64	val;
> +	struct {
> +		unsigned long	cgt:TC_CGT_BITS; /* Coarse trap id */
> +		unsigned long	fgt:TC_FGT_BITS; /* Fing Grained Trap id */
Fine & align capital letter in Trap for both comments
> +		unsigned long	bit:6;		 /* Bit number */
> +		unsigned long	pol:1;		 /* Polarity */
> +		unsigned long	unk:42;		 /* Unknown */
s//Unknown/Unused?
> +		unsigned long	mbz:1;		 /* Must Be Zero */
> +	};
> +};
> +
> +struct encoding_to_trap_config {
> +	const u32			encoding;
> +	const u32			end;
> +	const union trap_config		tc;
> +};
> +
> +#define SR_RANGE_TRAP(sr_start, sr_end, trap_id)			\
> +	{								\
> +		.encoding	= sr_start,				\
> +		.end		= sr_end,				\
> +		.tc		= {					\
> +			.cgt		= trap_id,			\
> +		},							\
> +	}
> +
> +#define SR_TRAP(sr, trap_id)		SR_RANGE_TRAP(sr, sr, trap_id)
> +
> +/*
> + * Map encoding to trap bits for exception reported with EC=0x18.
> + * These must only be evaluated when running a nested hypervisor, but
> + * that the current context is not a hypervisor context. When the
> + * trapped access matches one of the trap controls, the exception is
> + * re-injected in the nested hypervisor.
I must confess I was confused by the "forwarding" terminology versus
"re-injection into the nested hyp" 

cf.

"decide whether a trap from a L2+ guest has to be forwarded to a L1 guest
or handled locally"

"re-injection into the nested hyp" sounds clearer to me.

> + */
> +static const struct encoding_to_trap_config encoding_to_cgt[] __initconst = {
> +};
> +
> +static DEFINE_XARRAY(sr_forward_xa);
> +
> +static union trap_config get_trap_config(u32 sysreg)
> +{
> +	return (union trap_config) {
> +		.val = xa_to_value(xa_load(&sr_forward_xa, sysreg)),
> +	};
> +}
> +
> +int __init populate_nv_trap_config(void)
> +{
> +	int ret = 0;
> +
> +	BUILD_BUG_ON(sizeof(union trap_config) != sizeof(void *));
> +	BUILD_BUG_ON(__NR_TRAP_GROUP_IDS__ > BIT(TC_CGT_BITS));
> +
> +	for (int i = 0; i < ARRAY_SIZE(encoding_to_cgt); i++) {
> +		const struct encoding_to_trap_config *cgt = &encoding_to_cgt[i];
> +		void *prev;
> +
> +		prev = xa_store_range(&sr_forward_xa, cgt->encoding, cgt->end,
> +				      xa_mk_value(cgt->tc.val), GFP_KERNEL);
> +
> +		if (prev) {
> +			kvm_err("Duplicate CGT for (%d, %d, %d, %d, %d)\n",
> +				sys_reg_Op0(cgt->encoding),
> +				sys_reg_Op1(cgt->encoding),
> +				sys_reg_CRn(cgt->encoding),
> +				sys_reg_CRm(cgt->encoding),
> +				sys_reg_Op2(cgt->encoding));
> +			ret = -EINVAL;
> +		}
> +	}
> +
> +	kvm_info("nv: %ld coarse grained trap handlers\n",
> +		 ARRAY_SIZE(encoding_to_cgt));
> +
> +	for (int id = __MULTIPLE_CONTROL_BITS__;
> +	     id < (__COMPLEX_CONDITIONS__ - 1);
> +	     id++) {
> +		const enum trap_group *cgids;
> +
> +		cgids = coarse_control_combo[id - __MULTIPLE_CONTROL_BITS__];
> +
> +		for (int i = 0; cgids[i] != __RESERVED__; i++) {
> +			if (cgids[i] >= __MULTIPLE_CONTROL_BITS__) {
> +				kvm_err("Recursive MCB %d/%d\n", id, cgids[i]);
> +				ret = -EINVAL;
> +			}
> +		}
> +	}
> +
> +	if (ret)
> +		xa_destroy(&sr_forward_xa);
> +
> +	return ret;
> +}
> +
> +static enum trap_behaviour get_behaviour(struct kvm_vcpu *vcpu,
> +					 const struct trap_bits *tb)
> +{
> +	enum trap_behaviour b = BEHAVE_HANDLE_LOCALLY;
> +	u64 val;
> +
> +	val = __vcpu_sys_reg(vcpu, tb->index);
> +	if ((val & tb->mask) == tb->value)
> +		b |= tb->behaviour;
> +
> +	return b;
> +}
> +
> +static enum trap_behaviour __do_compute_trap_behaviour(struct kvm_vcpu *vcpu,
> +						       const enum trap_group id,
> +						       enum trap_behaviour b)
> +{
> +	switch (id) {
> +		const enum trap_group *cgids;
> +
> +	case __RESERVED__ ... __MULTIPLE_CONTROL_BITS__ - 1:
> +		if (likely(id != __RESERVED__))
> +			b |= get_behaviour(vcpu, &coarse_trap_bits[id]);
> +		break;
> +	case __MULTIPLE_CONTROL_BITS__ ... __COMPLEX_CONDITIONS__ - 1:
> +		/* Yes, this is recursive. Don't do anything stupid. */
> +		cgids = coarse_control_combo[id - __MULTIPLE_CONTROL_BITS__];
> +		for (int i = 0; cgids[i] != __RESERVED__; i++)
> +			b |= __do_compute_trap_behaviour(vcpu, cgids[i], b);
> +		break;
> +	default:
> +		if (ARRAY_SIZE(ccc))
> +			b |= ccc[id -  __COMPLEX_CONDITIONS__](vcpu);
> +		break;
> +	}
> +
> +	return b;
> +}
> +
> +static enum trap_behaviour compute_trap_behaviour(struct kvm_vcpu *vcpu,
> +						  const union trap_config tc)
> +{
> +	enum trap_behaviour b = BEHAVE_HANDLE_LOCALLY;
> +
> +	return __do_compute_trap_behaviour(vcpu, tc.cgt, b);
> +}
> +
> +bool __check_nv_sr_forward(struct kvm_vcpu *vcpu)
> +{
> +	union trap_config tc;
> +	enum trap_behaviour b;
> +	bool is_read;
> +	u32 sysreg;
> +	u64 esr;
> +
> +	if (!vcpu_has_nv(vcpu) || is_hyp_ctxt(vcpu))
> +		return false;
> +
> +	esr = kvm_vcpu_get_esr(vcpu);
> +	sysreg = esr_sys64_to_sysreg(esr);
> +	is_read = (esr & ESR_ELx_SYS64_ISS_DIR_MASK) == ESR_ELx_SYS64_ISS_DIR_READ;
> +
> +	tc = get_trap_config(sysreg);
> +
> +	/*
> +	 * A value of 0 for the whole entry means that we know nothing
> +	 * for this sysreg, and that it cannot be forwareded. In this
forwarded
> +	 * situation, let's cut it short.
> +	 *
> +	 * Note that ultimately, we could also make use of the xarray
> +	 * to store the index of the sysreg in the local descriptor
> +	 * array, avoiding another search... Hint, hint...
> +	 */
> +	if (!tc.val)
> +		return false;
> +
> +	b = compute_trap_behaviour(vcpu, tc);
> +
> +	if (((b & BEHAVE_FORWARD_READ) && is_read) ||
> +	    ((b & BEHAVE_FORWARD_WRITE) && !is_read))
> +		goto inject;
> +
> +	return false;
> +
> +inject:
> +	trace_kvm_forward_sysreg_trap(vcpu, sysreg, is_read);
> +
> +	kvm_inject_nested_sync(vcpu, kvm_vcpu_get_esr(vcpu));
> +	return true;
> +}
> +
>  static u64 kvm_check_illegal_exception_return(struct kvm_vcpu *vcpu, u64 spsr)
>  {
>  	u64 mode = spsr & PSR_MODE_MASK;
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index f5baaa508926..dfd72b3a625f 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -3177,6 +3177,9 @@ int kvm_handle_sys_reg(struct kvm_vcpu *vcpu)
>  
>  	trace_kvm_handle_sys_reg(esr);
>  
> +	if (__check_nv_sr_forward(vcpu))
> +		return 1;
> +
>  	params = esr_sys64_to_params(esr);
>  	params.regval = vcpu_get_reg(vcpu, Rt);
>  
> @@ -3594,5 +3597,8 @@ int __init kvm_sys_reg_table_init(void)
>  	if (!first_idreg)
>  		return -EINVAL;
>  
> +	if (kvm_get_mode() == KVM_MODE_NV)
> +		populate_nv_trap_config();
> +
>  	return 0;
>  }
> diff --git a/arch/arm64/kvm/trace_arm.h b/arch/arm64/kvm/trace_arm.h
> index 6ce5c025218d..8ad53104934d 100644
> --- a/arch/arm64/kvm/trace_arm.h
> +++ b/arch/arm64/kvm/trace_arm.h
> @@ -364,6 +364,32 @@ TRACE_EVENT(kvm_inject_nested_exception,
>  		  __entry->hcr_el2)
>  );
>  
> +TRACE_EVENT(kvm_forward_sysreg_trap,
> +	    TP_PROTO(struct kvm_vcpu *vcpu, u32 sysreg, bool is_read),
> +	    TP_ARGS(vcpu, sysreg, is_read),
> +
> +	    TP_STRUCT__entry(
> +		__field(u64,	pc)
> +		__field(u32,	sysreg)
> +		__field(bool,	is_read)
> +	    ),
> +
> +	    TP_fast_assign(
> +		__entry->pc = *vcpu_pc(vcpu);
> +		__entry->sysreg = sysreg;
> +		__entry->is_read = is_read;
> +	    ),
> +
> +	    TP_printk("%llx %c (%d,%d,%d,%d,%d)",
> +		      __entry->pc,
> +		      __entry->is_read ? 'R' : 'W',
> +		      sys_reg_Op0(__entry->sysreg),
> +		      sys_reg_Op1(__entry->sysreg),
> +		      sys_reg_CRn(__entry->sysreg),
> +		      sys_reg_CRm(__entry->sysreg),
> +		      sys_reg_Op2(__entry->sysreg))
> +);
> +
>  #endif /* _TRACE_ARM_ARM64_KVM_H */
>  
>  #undef TRACE_INCLUDE_PATH
Thanks

Eric

