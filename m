Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 425446A12DF
	for <lists+kvm@lfdr.de>; Thu, 23 Feb 2023 23:41:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229557AbjBWWlR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Feb 2023 17:41:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229463AbjBWWlQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Feb 2023 17:41:16 -0500
Received: from mail-io1-xd4a.google.com (mail-io1-xd4a.google.com [IPv6:2607:f8b0:4864:20::d4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6043154A3A
        for <kvm@vger.kernel.org>; Thu, 23 Feb 2023 14:41:15 -0800 (PST)
Received: by mail-io1-xd4a.google.com with SMTP id z9-20020a6b0a09000000b0074c9d317fc7so2670875ioi.17
        for <kvm@vger.kernel.org>; Thu, 23 Feb 2023 14:41:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=njxIFRU6oa+bMFJp4SuHumf2vOky2GO0uHGNatkMWic=;
        b=gzX0he6fpyBfnaDeQpfldthAsDjjo1Wpv2jFwTY5MDXv4xgye4uUhlrSIBepktdx4z
         74tPQc4yxz5NuE2Ud9YV8oyeylL419uuvjNcGkGrVLbpylqDGLHZyzQ7BJeOMKjiV5Vy
         /OFyB0bXj9vS6toOvy0wtcK13pbSEdiNVc5ezmHcR/fBIY+YMOostsfdNwdZNZ3DmZFD
         jILkuoUVClxm15bcf4WZw1WYUjuvpIzfA23W3W5TnWmt8QubAU39fsD3zpSI9kC21z0P
         KdrirIsUjek+COyg7fQ0cYHrnQIci9TRK6eEaPr0Yo6hGmu3sVx50XDg+5DBS8v6ue2H
         jTtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=njxIFRU6oa+bMFJp4SuHumf2vOky2GO0uHGNatkMWic=;
        b=rZJ+gz6B6zmaa9Y7e4OaQHsZRXAmCc+siZVrAk9nWOasnHLgD9+2Xaj760N/hAXOXe
         lxCrkphbmQ2Kdem3nIyFYAdnouIzhCd8pisNLgf1pekungTf1/m/6DpNG//Dx2+GQ9bd
         RLv+hUafLNDHO8N3l5mQrN6sSGkBFRcUdadked6pCQQg6Rf3yFm13alEI4IYBz5d5rKz
         9HwN39sZ5MHPBNyer9P8wNGYhH2j7KN/bkalm8+kWUJSGhpr5burNogKt98fHSaWwssy
         wbI2XcevJpanICyZL9iuu3qgqghMgHLmdErzAMYOd+/TxtdCWDu9pHmicRNIOEUvYWgx
         /Ruw==
X-Gm-Message-State: AO0yUKWqkeXkuqxB/shURITikOq0D8NbjL/nRYX1uniO9DPqSgoMUW8/
        RF5x/0e6/qOpUnBl4vTmTHI6tOJzvK3NLYBSgA==
X-Google-Smtp-Source: AK7set8eU6LXXGNsXhypWuPasNfU+Jy+y/Y6+I7CCNgTvs1mrAWB6o6YN6KK+svTCaLeqtyLcQ/Gja8X8X4Clja/KQ==
X-Received: from coltonlewis-kvm.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:14ce])
 (user=coltonlewis job=sendgmr) by 2002:a02:84e7:0:b0:3c5:d3e:9c82 with SMTP
 id f94-20020a0284e7000000b003c50d3e9c82mr4336134jai.5.1677192074809; Thu, 23
 Feb 2023 14:41:14 -0800 (PST)
Date:   Thu, 23 Feb 2023 22:41:13 +0000
In-Reply-To: <20230216142123.2638675-9-maz@kernel.org> (message from Marc
 Zyngier on Thu, 16 Feb 2023 14:21:15 +0000)
Mime-Version: 1.0
Message-ID: <gsntwn4880om.fsf@coltonlewis-kvm.c.googlers.com>
Subject: Re: [PATCH 08/16] KVM: arm64: timers: Allow userspace to set the
 counter offsets
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

> Once this new API is used, there is no going back, and the counters
> cannot be written to to set the offsets implicitly (the writes
> are instead ignored).

Why do this? I can't see a reason for disabling the other API the first
time this one is used.

> In keeping with the architecture, the offsets are expressed as
> a delta that is substracted from the physical counter value.
                   ^
nit: subtracted

> +/*
> + * Counter/Timer offset structure. Describe the virtual/physical offsets.
> + * To be used with KVM_ARM_SET_CNT_OFFSETS.
> + */
> +struct kvm_arm_counter_offsets {
> +	__u64 virtual_offset;
> +	__u64 physical_offset;
> +
> +#define KVM_COUNTER_SET_VOFFSET_FLAG	(1UL << 0)
> +#define KVM_COUNTER_SET_POFFSET_FLAG	(1UL << 1)
> +
> +	__u64 flags;
> +	__u64 reserved;
> +};
> +

It looks weird to have the #defines in the middle of the struct like
that. I think it would be easier to read with the #defines before the
struct.

> @@ -852,9 +852,11 @@ void kvm_timer_vcpu_init(struct kvm_vcpu *vcpu)
>   	ptimer->vcpu = vcpu;
>   	ptimer->offset.vm_offset = &vcpu->kvm->arch.offsets.poffset;

> -	/* Synchronize cntvoff across all vtimers of a VM. */
> -	timer_set_offset(vtimer, kvm_phys_timer_read());
> -	timer_set_offset(ptimer, 0);
> +	/* Synchronize offsets across timers of a VM if not already provided */
> +	if (!test_bit(KVM_ARCH_FLAG_COUNTER_OFFSETS, &vcpu->kvm->arch.flags)) {
> +		timer_set_offset(vtimer, kvm_phys_timer_read());
> +		timer_set_offset(ptimer, 0);
> +	}

>   	hrtimer_init(&timer->bg_timer, CLOCK_MONOTONIC, HRTIMER_MODE_ABS_HARD);
>   	timer->bg_timer.function = kvm_bg_timer_expire;

The code says "assign the offsets if the KVM_ARCH_FLAG_COUNTER_OFFSETS
flag is not on". The flag name is confusing and made it hard for me to
understand the intent. I think the intent is to only assign the offsets
if the user has not called the API to provide some offsets (that would
have been assigned in the API call along with flipping the flag
on). With that in mind, I would prefer the flag name reference the
user. KVM_ARCH_FLAG_USER_OFFSETS
