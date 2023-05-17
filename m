Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6CB170637B
	for <lists+kvm@lfdr.de>; Wed, 17 May 2023 11:01:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231290AbjEQJB0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 May 2023 05:01:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229508AbjEQJBJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 May 2023 05:01:09 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9A5855B3
        for <kvm@vger.kernel.org>; Wed, 17 May 2023 01:59:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1684313990;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HIVGKr92to8Dmk2bxhmzlEfc+g/1vVinSymgfq9Os5w=;
        b=RlWMIj9KQv1RAuj8BL2u2IQBigUxg7AEbwRMQ46/OCcWXEz0Kkg0NbHOe8QoE0FABZV5vD
        eEwdKd/LGLp7INWS51Akt8y6bSWEjDQSFEKu7Zyiath6sAr4g1RxckKAKy4gDgtfm6fXrA
        wOuApvZnuBu5hJ8KsL2pouUeV+RW1vQ=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-638-k0t70JWHOkGCKK1jM1KrAQ-1; Wed, 17 May 2023 04:59:48 -0400
X-MC-Unique: k0t70JWHOkGCKK1jM1KrAQ-1
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-3f348182ffcso3650265e9.3
        for <kvm@vger.kernel.org>; Wed, 17 May 2023 01:59:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684313988; x=1686905988;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HIVGKr92to8Dmk2bxhmzlEfc+g/1vVinSymgfq9Os5w=;
        b=BbPu4cSq2mj33leozgU/fuxcoyN3VUpj5Q0wO30r8JsNMHhc+w9kEUeTeduFnrii1A
         HOsYBU0mURfpgH/TnEQnIhv53xMDTzblqI/ZsLi6kzQY+lXFNF6Vlog1c7Ftmr16O4TO
         laqFsBumccpMTiIl1K3UjlL+h72r/CiLuCPe0vzTSGxgM1ffKMxZQK8VmsScZha9il6v
         56mrOE0R58g2vQPAA3rP9kz62bBS16/zbFVmSERFk5PyWhnG7YsSyMW5Lm1F7Lqs95Gp
         ASzCb4hcfxyzyRrkYaSWW+hgl9gqpNWRrGlvjyLyunj9Wm7p7PTzPFfHDdp8+cKnLLVN
         R5iQ==
X-Gm-Message-State: AC+VfDxZd405v4YSdqBhZ4QDAWBiSdchLdFw/IINlBawZjb1a1HFvyhF
        uCcO8ywWaD0R5WfVaxgEVvbadrvmzrPCQDx866HfmwbBDJE+p6rmqR7ykji2uzWM1oyCqHBrZfh
        3QBgnsZGqpISb
X-Received: by 2002:a7b:c5d2:0:b0:3f3:2b37:dd34 with SMTP id n18-20020a7bc5d2000000b003f32b37dd34mr26929669wmk.9.1684313987886;
        Wed, 17 May 2023 01:59:47 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ7zHvTt2KB86FL8HelVnj5IrobJnjcl3UexrHbo6YuaT13OfR4AW0fEjEpq69UXVUCvfNcDXw==
X-Received: by 2002:a7b:c5d2:0:b0:3f3:2b37:dd34 with SMTP id n18-20020a7bc5d2000000b003f32b37dd34mr26929653wmk.9.1684313987561;
        Wed, 17 May 2023 01:59:47 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id f6-20020a1cc906000000b003f435652aaesm1557077wmb.11.2023.05.17.01.59.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 May 2023 01:59:46 -0700 (PDT)
Message-ID: <d0b77823-c04c-4ee0-cb55-2cc20a48903b@redhat.com>
Date:   Wed, 17 May 2023 10:59:45 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH v10 00/59] KVM: arm64: ARMv8.3/8.4 Nested Virtualization
 support
Content-Language: en-US
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Andre Przywara <andre.przywara@arm.com>,
        Chase Conklin <chase.conklin@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
        Darren Hart <darren@os.amperecomputing.com>,
        Jintack Lim <jintack@cs.columbia.edu>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Miguel Luis <miguel.luis@oracle.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Zenghui Yu <yuzenghui@huawei.com>
References: <20230515173103.1017669-1-maz@kernel.org>
 <16d9fda4-3ead-7d5e-9f54-ef29fbd932ac@redhat.com>
 <87zg64nhqh.wl-maz@kernel.org>
From:   Eric Auger <eauger@redhat.com>
In-Reply-To: <87zg64nhqh.wl-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On 5/16/23 22:28, Marc Zyngier wrote:
> On Tue, 16 May 2023 17:53:14 +0100,
> Eric Auger <eauger@redhat.com> wrote:
>>
>> Hi Marc,
>>
>> On 5/15/23 19:30, Marc Zyngier wrote:
>>> This is the 4th drop of NV support on arm64 for this year.
>>>
>>> For the previous episodes, see [1].
>>>
>>> What's changed:
>>>
>>> - New framework to track system register traps that are reinjected in
>>>   guest EL2. It is expected to replace the discrete handling we have
>>>   enjoyed so far, which didn't scale at all. This has already fixed a
>>>   number of bugs that were hidden (a bunch of traps were never
>>>   forwarded...). Still a work in progress, but this is going in the
>>>   right direction.
>>>
>>> - Allow the L1 hypervisor to have a S2 that has an input larger than
>>>   the L0 IPA space. This fixes a number of subtle issues, depending on
>>>   how the initial guest was created.
>>>
>>> - Consequently, the patch series has gone longer again. Boo. But
>>>   hopefully some of it is easier to review...
>>>
>>> [1] https://lore.kernel.org/r/20230405154008.3552854-1-maz@kernel.org
>>
>> I have started testing this and when booting my fedora guest I get
>>
>> [  151.796544] kvm [7617]: Unsupported guest sys_reg access at:
>> 23f425fd0 [80000209]
>> [  151.796544]  { Op0( 3), Op1( 3), CRn(14), CRm( 3), Op2( 1), func_write },
>>
>> as soon as the host has kvm-arm.mode=nested
>>
>> This seems to be triggered very early by EDK2
>> (ArmPkg/Drivers/TimerDxe/TimerDxe.c).
>>
>> If I am not wrong this CNTV_CTL_EL0. Do you have any idea?
> 
> So here's my current analysis:
> 
> I assume you are running EDK2 as the L1 guest in a nested
> configuration. I also assume that you are not running on an Apple
> CPU. If these assumptions are correct, then EDK2 runs at vEL2, and is
> in nVHE mode.
> 
> Finally, I'm going to assume that your implementation has FEAT_ECV and
> FEAT_NV2, because I can't see how it could fail otherwise.
all the above is correct.
> 
> In these precise conditions, KVM sets the CNTHCTL_EL2.EL1TVT bit so
> that we can trap the EL0 virtual timer and faithfully emulate it (it
> is otherwise written to memory, which isn't very helpful).

indeed
> 
> As it turns out, we don't handle these traps. I didn't spot it because
> my test machines are all Apple boxes that don't have a nVHE mode, so
> nothing on the nVHE path is getting *ANY* coverage. Hint: having
> access to such a machine would help (shipping address on request!).
> Otherwise, I'll eventually kill the nVHE support altogether.
> 
> I have written the following patch, which compiles, but that I cannot
> test with my current setup. Could you please give it a go?

with the patch below, my guest boots nicely. You did it great on the 1st
shot!!! So this fixes my issue. I will continue testing the v10.

Thank you again!

Eric


> 
> Thanks again,
> 
> 	M.
> 
> From feb03b57de0bcb83254a2d6a3ce320f5e39434b6 Mon Sep 17 00:00:00 2001
> From: Marc Zyngier <maz@kernel.org>
> Date: Tue, 16 May 2023 21:06:20 +0100
> Subject: [PATCH] KVM: arm64: Handle virtual timer traps when
>  CNTHCTL_EL2.EL1TVT is set
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/include/asm/sysreg.h |  1 +
>  arch/arm64/kvm/sys_regs.c       | 28 ++++++++++++++++++++++++++++
>  2 files changed, 29 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
> index 72ff6df5d75b..77a61179ea37 100644
> --- a/arch/arm64/include/asm/sysreg.h
> +++ b/arch/arm64/include/asm/sysreg.h
> @@ -436,6 +436,7 @@
>  #define SYS_CNTP_CTL_EL0		sys_reg(3, 3, 14, 2, 1)
>  #define SYS_CNTP_CVAL_EL0		sys_reg(3, 3, 14, 2, 2)
>  
> +#define SYS_CNTV_TVAL_EL0		sys_reg(3, 3, 14, 3, 0)
>  #define SYS_CNTV_CTL_EL0		sys_reg(3, 3, 14, 3, 1)
>  #define SYS_CNTV_CVAL_EL0		sys_reg(3, 3, 14, 3, 2)
>  
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 27a29dcbfcd2..9aa9c4e4b4d6 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -1328,6 +1328,14 @@ static bool access_arch_timer(struct kvm_vcpu *vcpu,
>  		treg = TIMER_REG_TVAL;
>  		break;
>  
> +	case SYS_CNTV_TVAL_EL0:
> +		if (is_hyp_ctxt(vcpu) && vcpu_el2_e2h_is_set(vcpu))
> +			tmr = TIMER_HVTIMER;
> +		else
> +			tmr = TIMER_VTIMER;
> +		treg = TIMER_REG_TVAL;
> +		break;
> +
>  	case SYS_AARCH32_CNTP_TVAL:
>  	case SYS_CNTP_TVAL_EL02:
>  		tmr = TIMER_PTIMER;
> @@ -1357,6 +1365,14 @@ static bool access_arch_timer(struct kvm_vcpu *vcpu,
>  		treg = TIMER_REG_CTL;
>  		break;
>  
> +	case SYS_CNTV_CTL_EL0:
> +		if (is_hyp_ctxt(vcpu) && vcpu_el2_e2h_is_set(vcpu))
> +			tmr = TIMER_HVTIMER;
> +		else
> +			tmr = TIMER_VTIMER;
> +		treg = TIMER_REG_CTL;
> +		break;
> +
>  	case SYS_AARCH32_CNTP_CTL:
>  	case SYS_CNTP_CTL_EL02:
>  		tmr = TIMER_PTIMER;
> @@ -1386,6 +1402,14 @@ static bool access_arch_timer(struct kvm_vcpu *vcpu,
>  		treg = TIMER_REG_CVAL;
>  		break;
>  
> +	case SYS_CNTV_CVAL_EL0:
> +		if (is_hyp_ctxt(vcpu) && vcpu_el2_e2h_is_set(vcpu))
> +			tmr = TIMER_HVTIMER;
> +		else
> +			tmr = TIMER_VTIMER;
> +		treg = TIMER_REG_CVAL;
> +		break;
> +
>  	case SYS_AARCH32_CNTP_CVAL:
>  	case SYS_CNTP_CVAL_EL02:
>  		tmr = TIMER_PTIMER;
> @@ -2510,6 +2534,10 @@ static const struct sys_reg_desc sys_reg_descs[] = {
>  	{ SYS_DESC(SYS_CNTP_CTL_EL0), access_arch_timer },
>  	{ SYS_DESC(SYS_CNTP_CVAL_EL0), access_arch_timer },
>  
> +	{ SYS_DESC(SYS_CNTV_TVAL_EL0), access_arch_timer },
> +	{ SYS_DESC(SYS_CNTV_CTL_EL0), access_arch_timer },
> +	{ SYS_DESC(SYS_CNTV_CVAL_EL0), access_arch_timer },
> +
>  	/* PMEVCNTRn_EL0 */
>  	PMU_PMEVCNTR_EL0(0),
>  	PMU_PMEVCNTR_EL0(1),

