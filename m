Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21D9E7ACFDC
	for <lists+kvm@lfdr.de>; Mon, 25 Sep 2023 08:10:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230155AbjIYGKP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Sep 2023 02:10:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229511AbjIYGKO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Sep 2023 02:10:14 -0400
Received: from mail-qk1-x735.google.com (mail-qk1-x735.google.com [IPv6:2607:f8b0:4864:20::735])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4C2DC5
        for <kvm@vger.kernel.org>; Sun, 24 Sep 2023 23:10:07 -0700 (PDT)
Received: by mail-qk1-x735.google.com with SMTP id af79cd13be357-774141bb415so266348685a.3
        for <kvm@vger.kernel.org>; Sun, 24 Sep 2023 23:10:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1695622207; x=1696227007; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sFXfFbI5axEsbE00iYo3s4RazYa6oj7H1AdVZ62iHbM=;
        b=JZyLJ9zM1JdqF5eob6vw3aSSqCiH8c6BAO9xeIu8iE4dhg3ZudaCXgCeMTGzoF8Rph
         /SbAm/Mj6k+0jHJ6W49NOY/xkL84oNCu1zqTSabfw0DeHoVxRIkQtFdQZN7Y3c8x7/m2
         0gyfjws6ySHejxJnkl2sFS6t80sFMv3tSDqUwBp39sqja2XqA3r8+CAfIq/ZhS82b/84
         jbUaFP2qxWDuXHkghlkbsm4f7TXU52Y+nvhDLT3p4qLxdQnTefwXKhNY2bgnSunG/vba
         68c5jG10gyJA40en23PYerb0Vbp2PYSR2ugtM+fAgbaasuPYrRMCh0yoJ8KZsXptspEv
         SCGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695622207; x=1696227007;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sFXfFbI5axEsbE00iYo3s4RazYa6oj7H1AdVZ62iHbM=;
        b=gvx9qWJ4CPygDogfzPhn34uGOvqI/x78Gvx8iDGsl9LM37dY1NeLIxENn6VLXxUTiQ
         w99bRWE8uqBOBhyE8eDdOL7gTgmFFlJyK1afABnXtRXRlThnlpeYVsDzUZVh9bMk95qn
         UZ0SJZuoiAh4RPUAneIfr7yJN/G7+WuJ+/BKMKWeb7R1ug3YhCalccMXUvqEhD0bcevg
         fHD74BUUGfpbeVK8xnmlwGJXz3cac7F8uoCZqtc+Iwm1t0RJvQ9rREnAXlAUSjALjNrn
         4/4t58CuT5z2Yaz//KYeh7K/c5Am0lMvSObaakRouBgj1YAZCwKzSZHaXcTkPi0KjjS3
         jxaQ==
X-Gm-Message-State: AOJu0YyOhXOoT0hb2aHBLzYruTuFvZeUm3MaRC0WpanZdXQJtEF4r2BV
        KJNM2IlSkevsGdQi4Jak5y/bRrtOcEgxJScOvSovuHBOsYYjz0QuhGI=
X-Google-Smtp-Source: AGHT+IHNImLfiweNlcpNIDAQxyN4oj+ionjf4iy4ZTphebvtO45HK0c5a1GtJpB93uZ8zEBGrroRz829FaHRg8HqUUs=
X-Received: by 2002:a0c:a998:0:b0:62d:eda3:4335 with SMTP id
 a24-20020a0ca998000000b0062deda34335mr5082105qvb.29.1695622206779; Sun, 24
 Sep 2023 23:10:06 -0700 (PDT)
MIME-Version: 1.0
References: <20230901185646.2823254-1-jmattson@google.com> <ZQ3hD+zBCkZxZclS@google.com>
 <CALMp9eRQKUy7+AXWepsuJ=KguVMTTcgimeEjd3zMnEP-3LEDKg@mail.gmail.com>
 <ZQ3pQfu6Zw3MMvKx@google.com> <CAL715WKguAT_K_eUTxk8XEQ5rQ=e5WhEFdwOx8VpkpTHJWgRFw@mail.gmail.com>
 <ZQ36bxFOZM0s5+uk@google.com> <CAL715WL8KN1fceDhKxCfeGjbctx=vz2pAbw607pFYP6bw9N0_w@mail.gmail.com>
 <ZQ4BvCsFjLmnSxhd@google.com> <CAL715WLuqxN5JvcrZ7vcFpmTwuAi_EqKERtvj9BLoT9QVM0Ekw@mail.gmail.com>
 <ZQ4ch3GqM7WH34qv@google.com>
In-Reply-To: <ZQ4ch3GqM7WH34qv@google.com>
From:   Mingwei Zhang <mizhang@google.com>
Date:   Sun, 24 Sep 2023 23:09:30 -0700
Message-ID: <CAL715WLB-3iRrCOxuVNa=NJvGkVaY7K=+i3J7RnxAta81jef0Q@mail.gmail.com>
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

Hi Sean,

On Fri, Sep 22, 2023 at 4:00=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
>
> On Fri, Sep 22, 2023, Mingwei Zhang wrote:
> > So yes, they could be put together and they could be put separately.
> > But I don't see why they _cannot_ be together or cause confusion.
>
> Because they don't need to be put together.  Roman's patch kinda sorta ov=
erlaps
> with the prev_counter mess, but Jim's fixes are entirely orthogonal.
>
> If one person initially posted such a series with everything together I p=
robably
> wouldn't care *too* much, but combining patches and/or series that aren't=
 tightly
> coupled or dependent in some way usually does more harm than good.  E.g. =
if a
> maintainer has complaints against only one or two patches in series of un=
related
> patches, then grabbing the "good" patches is unnecessarily difficult.  It=
's not
> truly hard on the maintainer's end, but little bits of avoidable friction=
 in the
> process adds up across hundreds and thousands of patches.
>
> FWIW, my plan is to apply Roman's patch pretty much as-is, grab v2 from J=
im, and
> post my cleanups as a separate series on top (maybe two series, really ha=
ven't
> thought about it yet).  The only reason I have them all in a single branc=
h is
> because there are code conflicts and I know I will apply the patches from=
 Roman
> and Jim first, i.e. I didn't want to develop on a base that I knew would =
become
> stale.
>
> > So, I would like to put them together in the same context with a cover =
letter
> > fully describing the details.
>
> I certainly won't object to a thorough bug report/analysis, but I'd prefe=
r that
> Jim's series be posted separately (though I don't care if it's you or Jim=
 that
> posts it).

Thanks for agreeing to put things together. In fact, everything
together means all relevant fix patches for the same bug need to be
together. But I will put my patch explicitly as _optional_ mentioned
in the cover letter.

If the series causes inconvenience, please accept my apology. For the
sense of responsibility, I think I could just use this opportunity to
send my updated version with your comment fixed. I will also use this
chance to update your fix to Jim's patches.

One last thing, breaking the kvm-unit-test/pmu still surprises me.
Please test it again when you have a chance. Maybe adding more fixes
on top. With the series sent, I will hand it over to you.

Thanks.
-Mingwei

-Mingwei
