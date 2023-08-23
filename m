Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52245785F9E
	for <lists+kvm@lfdr.de>; Wed, 23 Aug 2023 20:29:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238143AbjHWS3C (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Aug 2023 14:29:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238154AbjHWS27 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Aug 2023 14:28:59 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57866E7F
        for <kvm@vger.kernel.org>; Wed, 23 Aug 2023 11:28:55 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id a640c23a62f3a-99bcfe28909so748134766b.3
        for <kvm@vger.kernel.org>; Wed, 23 Aug 2023 11:28:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692815334; x=1693420134;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=D1i56BJxrtFkay0cZ6IFmWxVW0ev3tPI6w5w2txm7Do=;
        b=tY59VRdaWi1DBU5yE67ABWm0o7nBL9MaDrpmh6mNIpiomLMKYM9r5+wGag8dCdpGui
         NaOu1KuepfxDYEnB5dPlu6HN3tZoqfi4h5AZqSoJMkAg0oJDWfVE8EHuzN27hE3O0KBP
         JacU7TySMZ9zMI707ZZsNDN3xijkW23FU/k8wMptNZ3fySwsLdyTXz9Lxwn1rCU56ZCE
         C/Rs2MpZPWH9uHcMD3MIE59ybie080aQKP2f9kpdsw97pgl7vV5p2yZBjbOIXCsUeFLe
         cYN8QqkTzAvw/3ZN3fCU0RffyJWB4XNowo4aojHT/BDBDqMCUc9dr5tWJQZvMBpdddNz
         e2UQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692815334; x=1693420134;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=D1i56BJxrtFkay0cZ6IFmWxVW0ev3tPI6w5w2txm7Do=;
        b=Xx640HM6+j0u2Xyjmf73yWHM5qdIOrz7HrBtfraJqGibocmsaw6K0ZRZ0oPMB9FLyd
         hqs8ScEPk7AwyYpfSkRu/D3kS54wBBUIHqH1+ttCpvme2EVpE1N8WV6Xmwnnn8TxqbHv
         Y2//Ujo5CqZXmvrVxA8FRgKLL7TWA1HQxRFaOgT051ghbXT9/Jrc0kZBZW8PgLj/wy55
         JyXAbDiu9aW1fokfFscJyv6N4G4aGn4YBNH2m20oGKVAN2LOFS9GvIo5EtCChDPxIaW+
         cQx/bF+rc/OrmCjEA4GblT43XRdpnq5ijDtEQge1x96V2THl1e+weJRZhutIn19anjXe
         6mMg==
X-Gm-Message-State: AOJu0YxLJeFMGf/W0inq6lnfIRhXd8G6CxvSqa66+aMEnRwUps0eFmV2
        D/aFPB3u4Mv7lQFCeEVXGCsXf35HneHPcP+sBcEsDg==
X-Google-Smtp-Source: AGHT+IHlQp9aiZ8Ka0ZJpgClwBB6XmkiaNX9y3bj9ftkzDoc7wSBGvtA2RV/u4qhbokdUveFaacH9H1ARr99SdESQ+M=
X-Received: by 2002:a17:907:7714:b0:99b:6e54:bd6e with SMTP id
 kw20-20020a170907771400b0099b6e54bd6emr9614282ejc.56.1692815333628; Wed, 23
 Aug 2023 11:28:53 -0700 (PDT)
MIME-Version: 1.0
References: <20230504120042.785651-1-rkagan@amazon.de> <ZH6DJ8aFq/LM6Bk9@google.com>
 <CALMp9eS3F08cwUJbKjTRAEL0KyZ=MC==YSH+DW-qsFkNfMpqEQ@mail.gmail.com>
 <ZJ4dmrQSduY8aWap@google.com> <ZJ65CiW0eEL2mGg8@u40bc5e070a0153.ant.amazon.com>
 <ZJ7mjdZ8h/RSilFX@google.com> <ZJ7y9DuedQyBb9eU@u40bc5e070a0153.ant.amazon.com>
 <ZJ74gELkj4DgAk4S@google.com> <ZJ9IaskpbIK9q4rt@google.com> <bdc2be50-c8c4-ff06-196f-d9b67e61a6b5@gmail.com>
In-Reply-To: <bdc2be50-c8c4-ff06-196f-d9b67e61a6b5@gmail.com>
From:   Mingwei Zhang <mizhang@google.com>
Date:   Wed, 23 Aug 2023 11:28:17 -0700
Message-ID: <CAL715WJiUYpxRRqs3FNiLiS8b6=4Pm5K0u==S6t5NYi0p=vutw@mail.gmail.com>
Subject: Re: [PATCH] KVM: x86: vPMU: truncate counter value to allowed width
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Roman Kagan <rkagan@amazon.de>,
        Jim Mattson <jmattson@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Eric Hankland <ehankland@google.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 22, 2023 at 2:30=E2=80=AFAM Like Xu <like.xu.linux@gmail.com> w=
rote:
>
> On 1/7/2023 5:26 am, Sean Christopherson wrote:
> > Ugh, yeah, de0f619564f4 created a bit of a mess.  The underlying issue =
that it
> > was solving is that perf_event_read_value() and friends might sleep (ya=
y mutex),
> > and so can't be called from KVM's fastpath (IRQs disabled).
> Updating pmu counters for emulated instructions cause troubles.
>
> >
> > However, detecting overflow requires reading perf_event_read_value() to=
 gather
> > the accumulated count from the hardware event in order to add it to the=
 emulated
> > count from software.  E.g. if pmc->counter is X and the perf event coun=
ter is Y,
> > KVM needs to factor in Y because X+Y+1 might overflow even if X+1 does =
not.
> >
> > Trying to snapshot the previous counter value is a bit of a mess.  It c=
ould probably
> > made to work, but it's hard to reason about what the snapshot actually =
contains
> > and when it should be cleared, especially when factoring in the wrappin=
g logic.
> >
> > Rather than snapshot the previous counter, I think it makes sense to:
> >
> >    1) Track the number of emulated counter events
>
> If events are counted separately, the challenge here is to correctly time
> the emulation of counter overflows, which can occur on both sides of the
> counter values out of sync.
>
> >    2) Accumulate and reset the counts from perf_event and emulated_coun=
ter into
> >       pmc->counter when pausing the PMC
> >    3) Pause and reprogram the PMC on writes (instead of the current app=
roach of
> >       blindly updating the sample period)
>
> Updating the sample period is the only interface for KVM to configure hw
> behaviour on hw-ctr. I note that perf_event_set_count() will be proposed,
> and I'm pessimistic about this change.
>
> >    4) Pause the counter when stopping the perf_event to ensure pmc->cou=
nter is
> >       fresh (instead of manually updating pmc->counter)
> >
> > IMO, that yields more intuitive logic, and makes it easier to reason ab=
out
> > correctness since the behavior is easily define: pmc->counter holds the=
 counts
> > that have been gathered and processed, perf_event and emulated_counter =
hold
> > outstanding counts on top.  E.g. on a WRMSR to the counter, both the em=
ulated
> > counter and the hardware counter are reset, because whatever counts exi=
sted
> > previously are irrelevant.
>
> If we take the hardware view, a counter, emulated or not, just increments
> and overflows at the threshold. The missing logic here is when the counte=
r
> is truncated when writing high bit-width values, and how to deal with the
> value of pmc->prev_counter was before pmc->counter was truncated.
>
> >
> > Pausing the counter_might_  make WRMSR slower, but we need to get this =
all
> > functionally correct before worrying too much about performance.
>
> Performance, security and correctness should all be considered at the beg=
inning.
>

+1 on the performance part.

I did several rounds of performance testing, pausing the counter is
fast, but restarting the counter is *super* slow. The extra overhead
might just make vPMU useless especially when the guest workload takes
full CPU/memory resources in a VM (like SPEC2017 does).

> >
> > Diff below for what I'm thinking (needs to be split into multiple patch=
es).  It's
> > *very*  lightly tested.
>
> It saddens me that no one has come up with an actual low-level counter-te=
st for
> this issue.
>
> >
> > I'm about to disappear for a week, I'll pick this back up when I get re=
turn.  In
> > the meantime, any testing and/or input would be much appreciated!
>
> How about accepting Roman's original fix and then exercising the rewritin=
g genius ?

+1

I think the best option would be to just apply the fix in a short term
and put the refactoring of the emulated counter in the next series.
