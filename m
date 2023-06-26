Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9AED073E535
	for <lists+kvm@lfdr.de>; Mon, 26 Jun 2023 18:35:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229990AbjFZQfX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Jun 2023 12:35:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231514AbjFZQfB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Jun 2023 12:35:01 -0400
Received: from out-9.mta0.migadu.com (out-9.mta0.migadu.com [91.218.175.9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 176FECF
        for <kvm@vger.kernel.org>; Mon, 26 Jun 2023 09:34:58 -0700 (PDT)
Date:   Mon, 26 Jun 2023 16:34:50 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1687797296;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=BaphbRu7L4C7SqsGphPReeAVmMfd4ld7jXFvqYy0b30=;
        b=bVkV1Jem7YJ4Ng8rnGrW/tRpQl6E2EJLWyml/T7kGX7rpZ9A8Va8t42q9E25e+Wwl8yzh1
        8auSyJlzC27hRiSOoRLO2oBsVQ5bnCyvbhzJlsXtNqm8U+ao53lTVPluAt3DIZTyLYZzqT
        C/natIyDXGMOS6gu5nFRZlyJcMYhAUo=
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
        Raghavendra Rao Ananta <rananta@google.com>,
        Suraj Jitindar Singh <surajjs@amazon.com>
Subject: Re: [PATCH v4 1/4] KVM: arm64: Enable writable for ID_AA64DFR0_EL1
Message-ID: <ZJm+Kj0C5YySp055@linux.dev>
References: <20230607194554.87359-1-jingzhangos@google.com>
 <20230607194554.87359-2-jingzhangos@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230607194554.87359-2-jingzhangos@google.com>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 07, 2023 at 07:45:51PM +0000, Jing Zhang wrote:
> Since number of context-aware breakpoints must be no more than number
> of supported breakpoints according to Arm ARM, return an error if
> userspace tries to set CTX_CMPS field to such value.
> 
> Signed-off-by: Jing Zhang <jingzhangos@google.com>
> ---
>  arch/arm64/kvm/sys_regs.c | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 50d4e25f42d3..a6299c796d03 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -1539,9 +1539,14 @@ static int set_id_aa64dfr0_el1(struct kvm_vcpu *vcpu,
>  			       const struct sys_reg_desc *rd,
>  			       u64 val)
>  {
> -	u8 pmuver, host_pmuver;
> +	u8 pmuver, host_pmuver, brps, ctx_cmps;
>  	bool valid_pmu;
>  
> +	brps = FIELD_GET(ID_AA64DFR0_EL1_BRPs_MASK, val);
> +	ctx_cmps = FIELD_GET(ID_AA64DFR0_EL1_CTX_CMPs_MASK, val);
> +	if (ctx_cmps > brps)
> +		return -EINVAL;
> +

I'm not fully convinced on the need to do this sort of cross-field
validation... I think it is probably more trouble than it is worth. If
userspace writes something illogical to the register, oh well. All we
should care about is that the advertised feature set is a subset of
what's supported by the host.

The series doesn't even do complete sanity checking, and instead works
on a few cherry-picked examples. AA64PFR0.EL{0-3} would also require
special handling depending on how pedantic you're feeling. AArch32
support at a higher exception level implies AArch32 support at all lower
exception levels.

But that isn't a suggestion to implement it, more of a suggestion to
just avoid the problem as a whole.

>  	host_pmuver = kvm_arm_pmu_get_pmuver_limit();
>  
>  	/*
> @@ -2061,7 +2066,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
>  	  .get_user = get_id_reg,
>  	  .set_user = set_id_aa64dfr0_el1,
>  	  .reset = read_sanitised_id_aa64dfr0_el1,
> -	  .val = ID_AA64DFR0_EL1_PMUVer_MASK, },
> +	  .val = GENMASK(63, 0), },

DebugVer requires special handling, as the minimum safe value is 0x6 for
the field. IIUC, as written we would permit userspace to write any value
less than the current register value.

I posted a patch to 'fix' this, but it isn't actually a bug in what's
upstream. Could you pick that patch up and discard the 'Fixes' tag on
it?

https://lore.kernel.org/kvmarm/20230623205232.2837077-1-oliver.upton@linux.dev/

>  	ID_SANITISED(ID_AA64DFR1_EL1),
>  	ID_UNALLOCATED(5,2),
>  	ID_UNALLOCATED(5,3),
> -- 
> 2.41.0.rc0.172.g3f132b7071-goog
> 
> 

-- 
Thanks,
Oliver
