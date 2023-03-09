Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95B4D6B3041
	for <lists+kvm@lfdr.de>; Thu,  9 Mar 2023 23:15:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230236AbjCIWPN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Mar 2023 17:15:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229835AbjCIWPK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Mar 2023 17:15:10 -0500
Received: from mail-oa1-x2f.google.com (mail-oa1-x2f.google.com [IPv6:2001:4860:4864:20::2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBF26F82A6
        for <kvm@vger.kernel.org>; Thu,  9 Mar 2023 14:15:09 -0800 (PST)
Received: by mail-oa1-x2f.google.com with SMTP id 586e51a60fabf-17638494edbso3870926fac.10
        for <kvm@vger.kernel.org>; Thu, 09 Mar 2023 14:15:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678400109;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=E3PQRMfxQpWw1EQQGErwxaTj11IIxbXvdV9zBZ1y4E8=;
        b=Y9RgqY/R49EUCbBlDxx4d3nanzjLIn3mMjcmuVW56VS1awQnqsRW+zJP5wohesNJch
         zg1I7QVEFGP6FlohW41/rXg+b2cqCqxW6BLcDDqbions+nu/IonS5GIGWuNYbKlP6sDn
         oVGM/BN6Ky7XOdJqN7qcl4WRWFaF2rNx+y8u4LFkVEZgP6KG5MuemD7Fq3jcVwU4/x4o
         L362NHXei92hxGxrvgWRqVPrz/7Z6PdwujtF/h61LOOfYglO5eZ/jds+x4zP6cSm65Ad
         j0P5ccYOf4x/JJvz+FgB/NknLjbaQ9B4plsCKGR1KiZQQ/JKJaXsWE2h40V4WldgmCEy
         4sBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678400109;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=E3PQRMfxQpWw1EQQGErwxaTj11IIxbXvdV9zBZ1y4E8=;
        b=jcBSU247gPnkLoxsvgXAFnavBEtPDhu+PQyQDCJkUAYUsbSB6dFmLe0dt1O0dJwyHI
         db3o3JMlowyELr45wLTgNqopABx5VjcMycbzNtYWw1cmf2MVaso9idwuhWEkht5LT9qD
         qlQl2fFjbj09Pn6pwTF8CaPXUtlQN0ZHkFVR12kaZceD/ETGzbcqNHmzo+kdlMb7tBMf
         6NmCBseAMFYUYdloxaFKfeulF+mg96vhoGTP0NVQ21rVUJHeTYFuJWHc05d6OhlGL/ZI
         xUb5xrxe4wMgi5IkwRzvxoVphFLEMnsUpkmW8bW58Ylv+Mq/gVqQQMPH978HO6RP8zBI
         mh/w==
X-Gm-Message-State: AO0yUKVRacMp3KD8pJ8zVJT5mgnT4OBFxFDbPcIdlNVReBIFxIhlTv13
        BdqALHTEnjaRTEla5og+EBljGXA3JVyv3SX8nVAt2Q==
X-Google-Smtp-Source: AK7set/32BBIrvEDt0fltBRnip4rqPQdBgJQQDjXpdLAI3JvJVq6nj0esM2VH3efuTnhloEU4dl5EHGiLl6+aSSX9Ec=
X-Received: by 2002:a05:6870:a2c2:b0:176:4a71:6fdc with SMTP id
 w2-20020a056870a2c200b001764a716fdcmr8314733oak.9.1678400109081; Thu, 09 Mar
 2023 14:15:09 -0800 (PST)
MIME-Version: 1.0
References: <20230215010717.3612794-1-rananta@google.com> <20230215010717.3612794-7-rananta@google.com>
 <CAAeT=FyrgUjQWhL75n7z43msubHHghhy3Tj2JjsYop14f3kFhg@mail.gmail.com>
In-Reply-To: <CAAeT=FyrgUjQWhL75n7z43msubHHghhy3Tj2JjsYop14f3kFhg@mail.gmail.com>
From:   Raghavendra Rao Ananta <rananta@google.com>
Date:   Thu, 9 Mar 2023 14:14:58 -0800
Message-ID: <CAJHc60z87hz7tVfHyiO6wcYXDKLMNZzRE2V8jWB-5rekR1xkAg@mail.gmail.com>
Subject: Re: [REPOST PATCH 06/16] tools: arm64: perf_event: Define Cycle
 counter enable/overflow bits
To:     Reiji Watanabe <reijiw@google.com>
Cc:     Oliver Upton <oupton@google.com>, Marc Zyngier <maz@kernel.org>,
        Ricardo Koller <ricarkol@google.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jing Zhang <jingzhangos@google.com>,
        Colton Lewis <coltonlewis@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
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

Hi Reiji,

On Thu, Mar 2, 2023 at 4:47=E2=80=AFPM Reiji Watanabe <reijiw@google.com> w=
rote:
>
> Hi Raghu,
>
> On Tue, Feb 14, 2023 at 5:07=E2=80=AFPM Raghavendra Rao Ananta
> <rananta@google.com> wrote:
> >
> > Add the definitions of ARMV8_PMU_CNTOVS_C (Cycle counter overflow
> > bit) for overflow status registers and ARMV8_PMU_CNTENSET_C (Cycle
> > counter enable bit) for PMCNTENSET_EL0 register.
> >
> > Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> > ---
> >  tools/arch/arm64/include/asm/perf_event.h | 7 +++++++
> >  1 file changed, 7 insertions(+)
> >
> > diff --git a/tools/arch/arm64/include/asm/perf_event.h b/tools/arch/arm=
64/include/asm/perf_event.h
> > index 97e49a4d4969f..8ce23aabf6fe6 100644
> > --- a/tools/arch/arm64/include/asm/perf_event.h
> > +++ b/tools/arch/arm64/include/asm/perf_event.h
> > @@ -222,9 +222,11 @@
> >  /*
> >   * PMOVSR: counters overflow flag status reg
> >   */
> > +#define ARMV8_PMU_CNTOVS_C      (1 << 31) /* Cycle counter overflow bi=
t */
>
> Nit: This macro doesn't seem to be used in any of the patches.
> Do we need this ?
>
Ah, I think originally I intended to use this instead of defining my
own ARMV8_PMU_CYCLE_COUNTER_IDX to align with other pmc idx-es. But I
think the latter is better. I'll remove ARMV8_PMU_CNTOVS_C.

Thank you.
Raghavendra

> Thank you,
> Reiji
>
>
> >  #define        ARMV8_PMU_OVSR_MASK             0xffffffff      /* Mask=
 for writable bits */
> >  #define        ARMV8_PMU_OVERFLOWED_MASK       ARMV8_PMU_OVSR_MASK
> >
> > +
> >  /*
> >   * PMXEVTYPER: Event selection reg
> >   */
> > @@ -247,6 +249,11 @@
> >  #define ARMV8_PMU_USERENR_CR   (1 << 2) /* Cycle counter can be read a=
t EL0 */
> >  #define ARMV8_PMU_USERENR_ER   (1 << 3) /* Event counter can be read a=
t EL0 */
> >
> > +/*
> > + * PMCNTENSET: Count Enable set reg
> > + */
> > +#define ARMV8_PMU_CNTENSET_C    (1 << 31) /* Cycle counter enable bit =
*/
> > +
> >  /* PMMIR_EL1.SLOTS mask */
> >  #define ARMV8_PMU_SLOTS_MASK   0xff
> >
> > --
> > 2.39.1.581.gbfd45094c4-goog
> >
