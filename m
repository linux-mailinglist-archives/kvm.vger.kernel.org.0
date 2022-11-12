Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2C7A626ABD
	for <lists+kvm@lfdr.de>; Sat, 12 Nov 2022 18:12:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234825AbiKLRMD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 12 Nov 2022 12:12:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230257AbiKLRMB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 12 Nov 2022 12:12:01 -0500
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67DDB15FE8
        for <kvm@vger.kernel.org>; Sat, 12 Nov 2022 09:12:00 -0800 (PST)
Received: by mail-pg1-x535.google.com with SMTP id v3so6799565pgh.4
        for <kvm@vger.kernel.org>; Sat, 12 Nov 2022 09:12:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=huOfRfTKX8VpR+zLQmX1u05LOoSZKsTiMBH9KVLbC90=;
        b=YOPdyFPHiHdfei20a0O7mxQJEQ1ngcz2Ak7zBVLQQL6m6BCgnGfpFH9NTCV5g3TkKb
         lhJ/Oix0aRGD4D0zw7tU9n/WWfjvoDT4CIJZ+st0hZCA2bVYqhniDRjY/c+Tn/lktx8w
         P6E46/GhBxnYcFdIVsWV2BjvcAxD1Oz93Mm61R/l2EajnTBEtD7fsBnJDZJMWNMEvcOI
         ngtnFreoV3caaRvProwwSKldBKPGjk3MUgTrZ8Hz0ukRGsosJ+LxNxVhajZk7nssB7kp
         ok1uvAeLWgYsUVYt/TemRAbnH/NofOgyy+GWdIo4doZcp15qloZblfU/KSw65we3g32K
         tfCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=huOfRfTKX8VpR+zLQmX1u05LOoSZKsTiMBH9KVLbC90=;
        b=llh3qhy9bvTgG16zEEFAfub4SWVkoRk+MUW9Gh6lrpdNcvM0PeO5+8y6LRLnl1onPV
         XYz1KliPEAmjlGL7KnBEgbyeyNeOTp/SjT1WN/NuJr/mxO1Y7FgnjQ8eNB+4bDbQjx6v
         eGz5Kf4mEq593u5znHb6GgNE9UCtDYxahlVrtACmn7iCPiVClqBCMNTze1kN3PeIqSTw
         KZnajjUPTNJ+Zjp2xJZguJgMVlwqHOQJyZUHfgX1RJlMmSE4L09fjeTum4F6Iu0J4dyx
         OXc/ALSINyIMrrMkkmRZEHmb6kRIf9uL2JxXceKEahZ5jBaYDr464jKa/ZNxjNyh1bFc
         uhkw==
X-Gm-Message-State: ANoB5pmxsWRi2p1yQ2Ln+vYZuFSSW65pdCLGdk6NgE30nBTerql4KTEd
        1Wph9n9YzmSeiF9xJS55/KhBNOuC+FSES7qKRfeAeA==
X-Google-Smtp-Source: AA0mqf5DICL/2gA2W9iIaKXpvPpequGwdfWsmg3dq8MWyHwh/KLJ/3GKXQMeXrpPRy8098xWMqdkZMYeGaya8U+kDxg=
X-Received: by 2002:a63:4711:0:b0:474:4380:cca6 with SMTP id
 u17-20020a634711000000b004744380cca6mr5941504pga.229.1668273119742; Sat, 12
 Nov 2022 09:11:59 -0800 (PST)
MIME-Version: 1.0
References: <20221107085435.2581641-1-maz@kernel.org> <20221107085435.2581641-3-maz@kernel.org>
 <CAAeT=FwNKZhc=a4Jggw-ENL=9G26QTU7OsRbHd2+F+=ZTPt24w@mail.gmail.com> <87edu8uz1o.wl-maz@kernel.org>
In-Reply-To: <87edu8uz1o.wl-maz@kernel.org>
From:   Reiji Watanabe <reijiw@google.com>
Date:   Sat, 12 Nov 2022 09:11:42 -0800
Message-ID: <CAAeT=Fwp-Xx49XmbVm55x-4+GRVuGbT6kqhAcfXTpWTqfvEu+Q@mail.gmail.com>
Subject: Re: [PATCH v3 02/14] KVM: arm64: PMU: Align chained counter
 implementation with architecture pseudocode
To:     Marc Zyngier <maz@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Ricardo Koller <ricarkol@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

> > > +#define PERF_ATTR_CFG1_COUNTER_64BIT   BIT(0)
> >
> > Although this isn't the new code (but just a name change),
> > wouldn't it be nicer to have armv8pmu_event_is_64bit()
> > (in arch/arm64/kernel/perf_event.c) use the macro as well ?
>
> We tried that in the past, and the amount of churn wasn't really worth
> it. I'm happy to revisit this in the future, but probably as a
> separate patch.

I see... Thank you for the clarification.  As this isn't new,
I agree with that (not addressing it in this series).

> > > @@ -340,11 +245,8 @@ void kvm_pmu_enable_counter_mask(struct kvm_vcpu *vcpu, u64 val)
> > >
> > >                 pmc = &pmu->pmc[i];
> > >
> > > -               /* A change in the enable state may affect the chain state */
> > > -               kvm_pmu_update_pmc_chained(vcpu, i);
> > >                 kvm_pmu_create_perf_event(vcpu, i);
> > >
> > > -               /* At this point, pmc must be the canonical */
> > >                 if (pmc->perf_event) {
> > >                         perf_event_enable(pmc->perf_event);
> > >                         if (pmc->perf_event->state != PERF_EVENT_STATE_ACTIVE)
> > > @@ -375,11 +277,8 @@ void kvm_pmu_disable_counter_mask(struct kvm_vcpu *vcpu, u64 val)
> > >
> > >                 pmc = &pmu->pmc[i];
> > >
> > > -               /* A change in the enable state may affect the chain state */
> > > -               kvm_pmu_update_pmc_chained(vcpu, i);
> > >                 kvm_pmu_create_perf_event(vcpu, i);
> >
> > Do we still need to call kvm_pmu_update_pmc_chained() here even
> > with this patch ? (I would think the reason why the function was
> > called here was because the chain state change could affect the
> > backed perf event attribute before).
> > I have the same comment for kvm_pmu_enable_counter_mask().
>
> Do you mean kvm_pmu_create_perf_event() instead? I think we can drop
> the one on disable. But the one on enable is required, as we need to
> be able to start counting an event even if the guest hasn't programmed
> the event number (unlikely, but allowed by the architecture). It can
> be made conditional though.

I'm so sorry for the confusion...
Yes, kvm_pmu_create_perf_event() is what I meant.
Thank you for the explanation for the one enabled case.
Now, I understand.

>
> I have the following fix queued:

Looks good!

Thank you,
Reiji

>
> diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
> index 26293f842b0f..b7a5f75d008d 100644
> --- a/arch/arm64/kvm/pmu-emul.c
> +++ b/arch/arm64/kvm/pmu-emul.c
> @@ -277,9 +277,9 @@ void kvm_pmu_enable_counter_mask(struct kvm_vcpu *vcpu, u64 val)
>
>                 pmc = &pmu->pmc[i];
>
> -               kvm_pmu_create_perf_event(vcpu, i);
> -
> -               if (pmc->perf_event) {
> +               if (!pmc->perf_event) {
> +                       kvm_pmu_create_perf_event(vcpu, i);
> +               } else {
>                         perf_event_enable(pmc->perf_event);
>                         if (pmc->perf_event->state != PERF_EVENT_STATE_ACTIVE)
>                                 kvm_debug("fail to enable perf event\n");
> @@ -309,8 +309,6 @@ void kvm_pmu_disable_counter_mask(struct kvm_vcpu *vcpu, u64 val)
>
>                 pmc = &pmu->pmc[i];
>
> -               kvm_pmu_create_perf_event(vcpu, i);
> -
>                 if (pmc->perf_event)
>                         perf_event_disable(pmc->perf_event);
>         }
