Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5DE576757F
	for <lists+kvm@lfdr.de>; Fri, 28 Jul 2023 20:33:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230010AbjG1Sdw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Jul 2023 14:33:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237054AbjG1Sdk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Jul 2023 14:33:40 -0400
Received: from out-118.mta0.migadu.com (out-118.mta0.migadu.com [91.218.175.118])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94DE02109
        for <kvm@vger.kernel.org>; Fri, 28 Jul 2023 11:33:38 -0700 (PDT)
Date:   Fri, 28 Jul 2023 18:33:31 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1690569216;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Jrx5aHEojE/xaYVofIxjbxwFqRcq5TCTvqXzSOvaD+w=;
        b=MKWugsJjBcoOzco0vnyQq9bssNxNpUL2c+be5QVp7ccwiOnu3J2jqvCdjHgQ0HdEGPjCsk
        Ie+VNEHwbgg6Z09yY/mGpjlE29T3JgRUv84p3+JzaIrvya43IdA3jYQx4RpexRAmnm0coN
        vo6pV5SZF74el/A+QGSYb68n3UNqAiQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Eric Auger <eric.auger@redhat.com>,
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
        Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH v2 14/26] KVM: arm64: nv: Add trap forwarding
 infrastructure
Message-ID: <ZMQJ+7VPbGVnz0kP@linux.dev>
References: <20230728082952.959212-1-maz@kernel.org>
 <20230728082952.959212-15-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230728082952.959212-15-maz@kernel.org>
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

On Fri, Jul 28, 2023 at 09:29:40AM +0100, Marc Zyngier wrote:

[...]

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
> + */
> +union trap_config {
> +	u64	val;
> +	struct {
> +		unsigned long	cgt:10;	/* Coarse trap id */
> +		unsigned long	fgt:4;	/* Fing Grained Trap id */
> +		unsigned long	bit:6;	/* Bit number */
> +		unsigned long	pol:1;	/* Polarity */
> +		unsigned long	unk:42;	/* Unknown */
> +		unsigned long	mbz:1;	/* Must Be Zero */
> +	};
> +};

Correct me if I'm wrong, but I don't think the compiler is going to
whine if any of these bitfields are initialized with a larger value than
can be represented... Do you think some BUILD_BUG_ON() is in order to
ensure that trap_group fits in ::cgt?

	BUILD_BUG_ON(__NR_TRAP_IDS__ >= BIT(10));

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

Should we be checking for NULL here? AFAICT, the use of sentinel values
in the trap_group enum would effectively guarantee each trap_config has
a nonzero value.

> +}
> +
> +void __init populate_nv_trap_config(void)
> +{
> +	for (int i = 0; i < ARRAY_SIZE(encoding_to_cgt); i++) {
> +		const struct encoding_to_trap_config *cgt = &encoding_to_cgt[i];
> +		void *prev;
> +
> +		prev = xa_store_range(&sr_forward_xa, cgt->encoding, cgt->end,
> +				      xa_mk_value(cgt->tc.val), GFP_KERNEL);
> +		WARN_ON(prev);

Returning the error here and failing the overall KVM initialization
seems to be the safest option. The WARN is still handy, though.

> +	}
> +
> +	kvm_info("nv: %ld coarse grained trap handlers\n",
> +		 ARRAY_SIZE(encoding_to_cgt));
> +
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

Would it make sense to WARN here if one of the child trap ids was in the
recursive range?

-- 
Thanks,
Oliver
