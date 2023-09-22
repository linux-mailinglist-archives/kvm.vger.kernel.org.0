Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8AD47ABBEE
	for <lists+kvm@lfdr.de>; Sat, 23 Sep 2023 00:43:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230117AbjIVWno (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Sep 2023 18:43:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230081AbjIVWnm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Sep 2023 18:43:42 -0400
Received: from mail-oa1-x2d.google.com (mail-oa1-x2d.google.com [IPv6:2001:4860:4864:20::2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82CA31A4
        for <kvm@vger.kernel.org>; Fri, 22 Sep 2023 15:43:36 -0700 (PDT)
Received: by mail-oa1-x2d.google.com with SMTP id 586e51a60fabf-1a1fa977667so1526244fac.1
        for <kvm@vger.kernel.org>; Fri, 22 Sep 2023 15:43:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1695422616; x=1696027416; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ItDTe0VTr4QShyonFGcZbu3ivfRshK9y5fYB4B6+Sto=;
        b=0CPBHLf/M75LSP2bxYpzOTk9R3Ph3RJjPbH0JYhb173TX6feTqsr9UrVleFg76HEfp
         A/VEtpF/6z5Q3KSl5cPkJXKKAgjLrv0kMj6SFIlGkw/Hx6cF2jYI3MkFaTDkBr4sc+7N
         c0GerBtBGQd7NFMCBkZ5RkWsQBro1KT63CZMkIyft0ks2YdLt6dc2t4PAr9dcDZu9qkW
         F2ULJePY/LELfWc+CAzvFp7ovTNHTTjvjHRULwCiTODT1Hv2mq0UkVx8a9AqOyJeISex
         1DK/ajjULctWciCOKMdVgEioi2z0RIDMxHWuxoVJM3xrTv8O4LmpNlu+aXein0p4QTR7
         A4nA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695422616; x=1696027416;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ItDTe0VTr4QShyonFGcZbu3ivfRshK9y5fYB4B6+Sto=;
        b=CQqS/AtXqWKUfX78KkNxYfw7PQyPpvyCEaDTRv6BIIsYw4rAQeT4JgZRuozAg+VjWz
         lJ2pHI9Zad4oUXMPQ8YsGHhhjfrIwSYyuGuQd3cnLxa7WTvsUWiEGq6j+rPreanm+a4Y
         YYi5WxQE8km6xA5oDv2GTr66dR7rHjyTR/MpqwOgiAJPBMCij7fWdLxzuoDssBq8J+D4
         EzWNozGf60fdbLKWXhJew6rSBbSU2d8+twT38/8m+tLEzkfi/EzP7oQofxHEAmlw0ROX
         djbi7TOwmRbNFoAcA1rfAJ8POTr15ocMoSRHBdZVVs4BNMx0K41IH1jjqTDWMtQijXYl
         wbbA==
X-Gm-Message-State: AOJu0YxZvqqReuIgqWAF/qnn1XdSSQ1QH4gZTxCkUULScMLYG9I45fe/
        4hEQ/PwFukTEQA0KOu0954q+Beh0IQ4ASFLedjwUVg==
X-Google-Smtp-Source: AGHT+IEDFhDsgminRXVBxMPT7hg9kQGPgziheEh14X116eSnl54rbLah3W4F704SgfPyuRFcEzLqkLLCH9h/3QgLp+M=
X-Received: by 2002:a05:6870:1685:b0:1bf:4a66:d54f with SMTP id
 j5-20020a056870168500b001bf4a66d54fmr934790oae.56.1695422615648; Fri, 22 Sep
 2023 15:43:35 -0700 (PDT)
MIME-Version: 1.0
References: <20230901185646.2823254-1-jmattson@google.com> <ZQ3hD+zBCkZxZclS@google.com>
 <CALMp9eRQKUy7+AXWepsuJ=KguVMTTcgimeEjd3zMnEP-3LEDKg@mail.gmail.com>
 <ZQ3pQfu6Zw3MMvKx@google.com> <CAL715WKguAT_K_eUTxk8XEQ5rQ=e5WhEFdwOx8VpkpTHJWgRFw@mail.gmail.com>
 <ZQ36bxFOZM0s5+uk@google.com> <CAL715WL8KN1fceDhKxCfeGjbctx=vz2pAbw607pFYP6bw9N0_w@mail.gmail.com>
 <ZQ4BvCsFjLmnSxhd@google.com>
In-Reply-To: <ZQ4BvCsFjLmnSxhd@google.com>
From:   Mingwei Zhang <mizhang@google.com>
Date:   Fri, 22 Sep 2023 15:42:59 -0700
Message-ID: <CAL715WLuqxN5JvcrZ7vcFpmTwuAi_EqKERtvj9BLoT9QVM0Ekw@mail.gmail.com>
Subject: Re: [PATCH 1/2] KVM: x86: Synthesize at most one PMI per VM-exit
To:     Sean Christopherson <seanjc@google.com>
Cc:     Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Like Xu <likexu@tencent.com>, Roman Kagan <rkagan@amazon.de>,
        Kan Liang <kan.liang@intel.com>,
        Dapeng1 Mi <dapeng1.mi@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 22, 2023 at 2:06=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
>
> On Fri, Sep 22, 2023, Mingwei Zhang wrote:
> > On Fri, Sep 22, 2023 at 1:34=E2=80=AFPM Sean Christopherson <seanjc@goo=
gle.com> wrote:
> > >
> > > On Fri, Sep 22, 2023, Mingwei Zhang wrote:
> > > > Agree. Both patches are fixing the general potential buggy situatio=
n
> > > > of multiple PMI injection on one vm entry: one software level defen=
se
> > > > (forcing the usage of KVM_REQ_PMI) and one hardware level defense
> > > > (preventing PMI injection using mask).
> > > >
> > > > Although neither patch in this series is fixing the root cause of t=
his
> > > > specific double PMI injection bug, I don't see a reason why we cann=
ot
> > > > add a "fixes" tag to them, since we may fix it and create it again.
> > > >
> > > > I am currently working on it and testing my patch. Please give me s=
ome
> > > > time, I think I could try sending out one version today. Once that =
is
> > > > done, I will combine mine with the existing patch and send it out a=
s a
> > > > series.
> > >
> > > Me confused, what patch?  And what does this patch have to do with Ji=
m's series?
> > > Unless I've missed something, Jim's patches are good to go with my ni=
ts addressed.
> >
> > Let me step back.
> >
> > We have the following problem when we run perf inside guest:
> >
> > [ 1437.487320] Uhhuh. NMI received for unknown reason 20 on CPU 3.
> > [ 1437.487330] Dazed and confused, but trying to continue
> >
> > This means there are more NMIs that guest PMI could understand. So
> > there are potentially two approaches to solve the problem: 1) fix the
> > PMI injection issue: only one can be injected; 2) fix the code that
> > causes the (incorrect) multiple PMI injection.
>
> No, because the LVTPC masking fix isn't optional, the current KVM behavio=
r is a
> clear violation of the SDM.  And I'm struggling to think of a sane way to=
 fix the
> IRQ work bug, e.g. KVM would have to busy on the work finishing before re=
suming
> the guest, which is rather crazy.
>
> I'm not saying there isn't more work to be done, nor am I saying that we =
shouldn't
> further harden KVM against double-injection.  I'm just truly confused as =
to what
> that has to do with Jim's fixes.
>
hmm, I will take the "two approaches" back. You are right on that.
"two directions" is what I mean.

Oh, I think I did not elaborate the full context to you maybe. That
might cause confusion and sorry about that.

The context of Jim's patches is to fix the multiple PMI injections
when using perf, starting from
https://lore.kernel.org/all/ZJ7y9DuedQyBb9eU@u40bc5e070a0153.ant.amazon.com=
/

So, regarding the fix, there are multiple layers and they may or may
not be logically connected closely, but we are solving the same
problem. In fact, I was asking Jim to help me with this specific issue
:)

So yes, they could be put together and they could be put separately.
But I don't see why they _cannot_ be together or cause confusion. So,
I would like to put them together in the same context with a cover
letter fully describing the details.

FYI for reviewers: to reproduce the spurious PMI issue in the guest
VM, you need to let KVM emulate some instructions during the runtime,
so the function kvm_pmu_incr_counter() will be triggered more. One
option is to add a kernel cmdline like "idle=3Dnomwait" to your guest
kernel. Regarding the workload in guest vm, please run the perf
command specified in
https://lore.kernel.org/all/ZKCD30QrE5g9XGIh@google.com/

Thanks.
-Mingwei



-Mingwei
