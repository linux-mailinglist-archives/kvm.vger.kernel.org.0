Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFB516AE5D0
	for <lists+kvm@lfdr.de>; Tue,  7 Mar 2023 17:04:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231708AbjCGQD7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Mar 2023 11:03:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231239AbjCGQDj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Mar 2023 11:03:39 -0500
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF3DF9387A
        for <kvm@vger.kernel.org>; Tue,  7 Mar 2023 08:01:26 -0800 (PST)
Received: by mail-pg1-x54a.google.com with SMTP id 198-20020a6307cf000000b00503e9b0493bso3050333pgh.20
        for <kvm@vger.kernel.org>; Tue, 07 Mar 2023 08:01:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678204885;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=boRSrkFxSI01l01wcdgK/bH+XA8owR64pjb/afVEWio=;
        b=k5nw9fvsirqwmOBkzkGYvpee1e68Ds9epHg5RclP4+SXXDsjsIeDVpxBFTA80oO/TL
         QyUN9tUumg5Cp2OAe9B09nsoaU/0lsvAKi497Ua2XmQcRdIHsm9OS7jdbaZZFw1glKW8
         JntrvFwAnvJi8S4hT7FipX6P9OLQOc0nMJzu0VaQ/oF4Mhd1QNqbFM3CI4nrnPFC31L5
         5UIhv0bjB+gJA7zjlAitsvRss9ymgB4tJ95/45n/zGh5mBxXhag3Kk0Re5RkgtFh160i
         Jt+zw5BFG2x7o6zhfsjKQAiQKIFhvFq/qYeDhzQ1Tw08KR3/a9sZ5qU8nqW9RuFDEdYe
         E+zQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678204885;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=boRSrkFxSI01l01wcdgK/bH+XA8owR64pjb/afVEWio=;
        b=JY2lo3ESTC/HhWOJNpv9VfS+IgpBHqwy/GLz7A4xQcfeU7F5kb45lXeT0Kj2FD9vfF
         jBeawXVDtS3kTLaCCcqO23SioAHmqHc1OVGEkIY0PI2x76Fc5PdT2EjnCnWZRpLSQiYY
         hia9MGFfiKNzAXc3AME12SP/4j8GpVGtBvM6E6bjduZGfRWOpvxbynKqng76hi5WrQH2
         BFN0b6YCkpnwlW9znyoyi7pe0Yxeea8kKi2SZC6k+3SKOFlEUKmWHxc+6i5CGsd2Inrv
         1a63kuqkQePscXk5F+eINZjkKp5LEkD/5rH7jRtwr52yQ4jMgKJX8jOJPwq2yNASd1Ni
         TMDw==
X-Gm-Message-State: AO0yUKXkiiLvL8DULorubZQDHAmINqRYZQrZiTkU5flIcU7+axbOCjnG
        YwiJNrifP7ZpibHKtD07DFpq+qhJ6Ek=
X-Google-Smtp-Source: AK7set8wGtwD+iNwocYSdzlMivEBn1Zhec2CqapukHojhGMWjSkygOtGKyga2b0hrhuy+RClLW9aHpm1b+s=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:ab0f:b0:19a:64f6:e147 with SMTP id
 ik15-20020a170902ab0f00b0019a64f6e147mr6135115plb.2.1678204885262; Tue, 07
 Mar 2023 08:01:25 -0800 (PST)
Date:   Tue, 7 Mar 2023 08:01:24 -0800
In-Reply-To: <CAAAPnDFuEhhv+3orZ0EGMq4kAm3_p335kRAMOf=ZcLi_pcnPKQ@mail.gmail.com>
Mime-Version: 1.0
References: <20230307141400.1486314-1-aaronlewis@google.com>
 <20230307141400.1486314-2-aaronlewis@google.com> <1c7a20c4-742c-9c42-970e-19626323e367@gmail.com>
 <CAAAPnDFuEhhv+3orZ0EGMq4kAm3_p335kRAMOf=ZcLi_pcnPKQ@mail.gmail.com>
Message-ID: <ZAdfX+S323JVWNZC@google.com>
Subject: Re: [PATCH v3 1/5] KVM: x86/pmu: Prevent the PMU from counting
 disallowed events
From:   Sean Christopherson <seanjc@google.com>
To:     Aaron Lewis <aaronlewis@google.com>
Cc:     Like Xu <like.xu.linux@gmail.com>, pbonzini@redhat.com,
        jmattson@google.com, kvm@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 07, 2023, Aaron Lewis wrote:
> On Tue, Mar 7, 2023 at 7:19=E2=80=AFAM Like Xu <like.xu.linux@gmail.com> =
wrote:
> > > ---
> > >   arch/x86/kvm/pmu.c | 13 ++++++++-----
> > >   1 file changed, 8 insertions(+), 5 deletions(-)
> > >
> > > diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
> > > index 612e6c70ce2e..9914a9027c60 100644
> > > --- a/arch/x86/kvm/pmu.c
> > > +++ b/arch/x86/kvm/pmu.c
> > > @@ -400,6 +400,12 @@ static bool check_pmu_event_filter(struct kvm_pm=
c *pmc)
> > >       return is_fixed_event_allowed(filter, pmc->idx);
> > >   }
> > >
> > > +static bool event_is_allowed(struct kvm_pmc *pmc)
> >
> > Nit, an inline event_is_allowed() here might be better.
>=20
> I purposely didn't inline this because Sean generally discourages its
> use and has commented in several reviews to not use 'inline' and
> instead leave it up to the compiler to decide, unless using
> __always_inline.

Ya.

> I think the sentiment is either use the strong hint or don't use it at al=
l.
> This seems like an example of where the compiler can decide, and a strong
> hint isn't needed.

Not quite.  __always_inline is not a hint, it's a command.  The kernel *req=
uires*
functions tagged with __always_inline to be (surprise!) always inlined, eve=
n when
building with features that cause the compiler to generate non-inlined func=
tions
for even the most trivial helpers, e.g. KASAN can cause a literal nop funct=
ion to
be non-inlined.  __alway_inlined is used to ensure like no-instrumentation =
regions
and __init sections are preserved when invoking common helpers.
