Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29CB76A12DD
	for <lists+kvm@lfdr.de>; Thu, 23 Feb 2023 23:40:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229540AbjBWWk3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Feb 2023 17:40:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbjBWWk2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Feb 2023 17:40:28 -0500
Received: from mail-io1-xd4a.google.com (mail-io1-xd4a.google.com [IPv6:2607:f8b0:4864:20::d4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D20354A06
        for <kvm@vger.kernel.org>; Thu, 23 Feb 2023 14:40:27 -0800 (PST)
Received: by mail-io1-xd4a.google.com with SMTP id t68-20020a6bc347000000b0074caed3a2d2so85309iof.12
        for <kvm@vger.kernel.org>; Thu, 23 Feb 2023 14:40:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=H7DW1E7YDz23DUtDKapMOgWWzaxvMLvR5mEfkeUQPGk=;
        b=Jhluh9+e5VRpjYu5+kcBiTA94nGVEILdRx7wwIvaiTJjLwaZFO2mOl/BrEnLr+dySN
         vUJMjDh79tOham1v5ryHa+M00dxh7b4tY1Xz/O+ncjzzyxKxLKyHJHua1HOXENJk7FaN
         +QXXyFuWQfJl7bafhkPoK/8Eom7tvtF05PwOTRpbnlIzgM6vJ1nqhtwoCcP2zhCXS47H
         Cc7EatoGy3sYeGUCierAqMzFWXu0KHeDUzFxyiIMcf6QwGK8aDBC9ZECLrDg9xsvVVQ/
         nKC9izGs4oVvgbaazrUnqT3uuX9GLMRs7vyWEQ8TID9KkhUIPVsjn/pTCAJYnB18IoNe
         8dPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=H7DW1E7YDz23DUtDKapMOgWWzaxvMLvR5mEfkeUQPGk=;
        b=E+Tv1puC5q9OrHDzu8Uncrhj43IKPhdyvf3/ki/hYNe8bM/+e8ax8eA1mTuO+GN4vb
         6L4G1uFURlWKUkk6dUJSsD99BkHWQXzMzomLtEFR5taOYP5UjzPIcyl0duoTESsmcs7i
         Qe5OGhJXRtuRvC3tGnY3YwRxyHeTaM+fdJ3R2ptMK+D/8OMA8mOhrx/SbL7Cwvw5trI3
         rUwtb44A5/1A1QeIuaRVI8HT7t/laJ+3lqVkqWQ4s/C+DOdokuC8NnL8quutxuh3dHih
         4rGGhQ/li21f0UuFR5Ox9hlVhofMOe8CtqSfJKQD7t+2X1RpSQh8NE1JRfBT7vvwVWrY
         4grw==
X-Gm-Message-State: AO0yUKXrOSH4IhdC4ReV1jcVXhXfeMD0iBhLg5MB5U0JElQsuA/7PChB
        AIig7x3DUGqhJwTnTAytcc/IiMegM8aNZ313wQ==
X-Google-Smtp-Source: AK7set9wg+5HcHPYkzP9dXHsc+T600jg65CBBFaIxpNQfWNqODZyyLry6GpHALNx1bvDDiS0OqkdfbWH0jUWpKBqUA==
X-Received: from coltonlewis-kvm.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:14ce])
 (user=coltonlewis job=sendgmr) by 2002:a05:6e02:ee1:b0:30e:e796:23c1 with
 SMTP id j1-20020a056e020ee100b0030ee79623c1mr3693592ilk.1.1677192026614; Thu,
 23 Feb 2023 14:40:26 -0800 (PST)
Date:   Thu, 23 Feb 2023 22:40:25 +0000
In-Reply-To: <20230216142123.2638675-8-maz@kernel.org> (message from Marc
 Zyngier on Thu, 16 Feb 2023 14:21:14 +0000)
Mime-Version: 1.0
Message-ID: <gsnty1oo80py.fsf@coltonlewis-kvm.c.googlers.com>
Subject: Re: [PATCH 07/16] KVM: arm64: timers: Allow physical offset without CNTPOFF_EL2
From:   Colton Lewis <coltonlewis@google.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, james.morse@arm.com,
        suzuki.poulose@arm.com, oliver.upton@linux.dev,
        yuzenghui@huawei.com, ricarkol@google.com, sveith@amazon.de,
        dwmw2@infradead.org
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


Marc Zyngier <maz@kernel.org> writes:

> +/* If _pred is true, set bit in _set, otherwise set it in _clr */
> +#define assign_clear_set_bit(_pred, _bit, _clr, _set)			\
> +	do {								\
> +		if (_pred)						\
> +			(_set) |= (_bit);				\
> +		else							\
> +			(_clr) |= (_bit);				\
> +	} while (0)
> +

I don't think the do-while wrapper is necessary. Is there any reason
besides style guide conformance?

> +	/*
> +	 * We have two possibility to deal with a physical offset:
> +	 *
> +	 * - Either we have CNTPOFF (yay!) or the offset is 0:
> +	 *   we let the guest freely access the HW
> +	 *
> +	 * - or neither of these condition apply:
> +	 *   we trap accesses to the HW, but still use it
> +	 *   after correcting the physical offset
> +	 */
> +	if (!has_cntpoff() && timer_get_offset(map->direct_ptimer))
> +		tpt = tpc = true;

If there are only two possibilites, then two different booleans makes
things more complicated than it has to be.

> +	assign_clear_set_bit(tpt, CNTHCTL_EL1PCEN << 10, set, clr);
> +	assign_clear_set_bit(tpc, CNTHCTL_EL1PCTEN << 10, set, clr);

Might be good to name the 10 something like VHE_SHIFT so people know why
it is applied.

> +
> +
> +	timer_set_traps(vcpu, &map);
>   }

>   bool kvm_timer_should_notify_user(struct kvm_vcpu *vcpu)
> @@ -1293,27 +1363,12 @@ int kvm_timer_enable(struct kvm_vcpu *vcpu)
>   }

>   /*
> - * On VHE system, we only need to configure the EL2 timer trap register  
> once,
> - * not for every world switch.
> - * The host kernel runs at EL2 with HCR_EL2.TGE == 1,
> - * and this makes those bits have no effect for the host kernel  
> execution.
> + * If we have CNTPOFF, permanently set ECV to enable it.
>    */
>   void kvm_timer_init_vhe(void)
>   {
> -	/* When HCR_EL2.E2H ==1, EL1PCEN and EL1PCTEN are shifted by 10 */
> -	u32 cnthctl_shift = 10;
> -	u64 val;
> -
> -	/*
> -	 * VHE systems allow the guest direct access to the EL1 physical
> -	 * timer/counter.
> -	 */
> -	val = read_sysreg(cnthctl_el2);
> -	val |= (CNTHCTL_EL1PCEN << cnthctl_shift);
> -	val |= (CNTHCTL_EL1PCTEN << cnthctl_shift);
>   	if (cpus_have_final_cap(ARM64_HAS_ECV_CNTPOFF))
> -		val |= CNTHCTL_ECV;
> -	write_sysreg(val, cnthctl_el2);
> +		sysreg_clear_set(cntkctl_el1, 0, CNTHCTL_ECV);
>   }

What is the reason for moving these register writes from initialization
to vcpu load time? This contradicts the comment that says this is only
needed once and not at every world switch. Seems like doing more work
for no reason.
