Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 355757ADD95
	for <lists+kvm@lfdr.de>; Mon, 25 Sep 2023 19:06:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232592AbjIYRGw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Sep 2023 13:06:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230292AbjIYRGv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Sep 2023 13:06:51 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAECE95
        for <kvm@vger.kernel.org>; Mon, 25 Sep 2023 10:06:44 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-d81486a0382so10820016276.0
        for <kvm@vger.kernel.org>; Mon, 25 Sep 2023 10:06:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1695661604; x=1696266404; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=cNtjze0gX8Y/0E7U9UY0etBu59zzt6jnmb4RdRh2IwY=;
        b=LSdj3DUURZiN05s6z9NCttwGd3uf0VaDc1UcyLAzAuWDMKCGLTx2O/nUlx3X9QCR50
         ovSy4U5H8Hb9DAlfLqOMwd3Q3Cx14DyiMGLAoovTDj9Of7n9jrdCjrIU5QhIir3dL5OR
         CY9gQGRx6/KQqftM0bM9XGyzj8YpdBV+bzbwHO38q5d19iLkUvhLjIbBabBtf3zCzIjm
         bxNMtioMTeEiVsQXVUySdkKGfR/FSD/dk77TsghC52LEjHG6wadrhAx+fI+hbxtw3lZh
         iVAlLzSuNpzT5knZwYSgyzMIOjcR0BRHTAA2S1HN7g/OGjnvl2xj0yJbpN4vzcrcdTfk
         /jng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695661604; x=1696266404;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=cNtjze0gX8Y/0E7U9UY0etBu59zzt6jnmb4RdRh2IwY=;
        b=kQtx9FpVY1D6/aLdgDOytEmuLCG2vzzTPD5ls6CLqJSF61mstoT1D3hyuC/fUdxSSO
         UE2QgFE5K5gXW3PjMGKp0XiNLgen2DLXC8NbjWAgDV1Hz5mhodn/0Zsd/JjxD1GnuoIx
         r3jHv4a713IZnOnaoHfPrTWMAq31i/P+K0tbFdJpW9mpokBNDocId+DbQ0RhAP7TbGko
         DRvnLmnscojts9y/onsou2VTp6SnuFv/6S+cCwsLwKGRm5OcuNe0mkbT9UQuiHJ9YcR9
         pUzyOCcV2VzFK8KK9fLSbFFOp02GqoZF0wmsfTdgQmLYza+cClNACM+oXVHxIM+biM+7
         Kkrg==
X-Gm-Message-State: AOJu0YwpOdk1avXAy/ONY6CYc4p2i6UxzFD1G3m7rtnrPrqoAjpIh8SS
        y5CpZbB6RkgysIE4xoD3D5R6DCJzapc=
X-Google-Smtp-Source: AGHT+IGCqTaWPsbSXukc0DM41GdSfo8XFoAs4WxuMCM3MiZSBSHUaZfAcjvO9Mk/vSVzkBkQuqpVPYfyTFQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:ec0c:0:b0:d7e:b82a:ef68 with SMTP id
 j12-20020a25ec0c000000b00d7eb82aef68mr72940ybh.3.1695661603914; Mon, 25 Sep
 2023 10:06:43 -0700 (PDT)
Date:   Mon, 25 Sep 2023 10:06:42 -0700
In-Reply-To: <CAL715WKjYP0tq1Ls5G0v2Myfhp6SAhqsZhfLZUbSue3mJv2byA@mail.gmail.com>
Mime-Version: 1.0
References: <CALMp9eRQKUy7+AXWepsuJ=KguVMTTcgimeEjd3zMnEP-3LEDKg@mail.gmail.com>
 <ZQ3pQfu6Zw3MMvKx@google.com> <CAL715WKguAT_K_eUTxk8XEQ5rQ=e5WhEFdwOx8VpkpTHJWgRFw@mail.gmail.com>
 <ZQ36bxFOZM0s5+uk@google.com> <CAL715WL8KN1fceDhKxCfeGjbctx=vz2pAbw607pFYP6bw9N0_w@mail.gmail.com>
 <ZQ4BvCsFjLmnSxhd@google.com> <CAL715WLuqxN5JvcrZ7vcFpmTwuAi_EqKERtvj9BLoT9QVM0Ekw@mail.gmail.com>
 <ZQ4ch3GqM7WH34qv@google.com> <CAL715WLB-3iRrCOxuVNa=NJvGkVaY7K=+i3J7RnxAta81jef0Q@mail.gmail.com>
 <CAL715WKjYP0tq1Ls5G0v2Myfhp6SAhqsZhfLZUbSue3mJv2byA@mail.gmail.com>
Message-ID: <ZRG+Ioc9ndCTHOlh@google.com>
Subject: Re: [PATCH 1/2] KVM: x86: Synthesize at most one PMI per VM-exit
From:   Sean Christopherson <seanjc@google.com>
To:     Mingwei Zhang <mizhang@google.com>
Cc:     Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Like Xu <likexu@tencent.com>, Roman Kagan <rkagan@amazon.de>,
        Kan Liang <kan.liang@intel.com>,
        Dapeng1 Mi <dapeng1.mi@intel.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 25, 2023, Mingwei Zhang wrote:
> On Sun, Sep 24, 2023 at 11:09=E2=80=AFPM Mingwei Zhang <mizhang@google.co=
m> wrote:
> >
> > Hi Sean,
> >
> > On Fri, Sep 22, 2023 at 4:00=E2=80=AFPM Sean Christopherson <seanjc@goo=
gle.com> wrote:
> > >
> > > On Fri, Sep 22, 2023, Mingwei Zhang wrote:
> > > > So yes, they could be put together and they could be put separately=
.
> > > > But I don't see why they _cannot_ be together or cause confusion.
> > >
> > > Because they don't need to be put together.  Roman's patch kinda sort=
a overlaps
> > > with the prev_counter mess, but Jim's fixes are entirely orthogonal.
> > >
> > > If one person initially posted such a series with everything together=
 I probably
> > > wouldn't care *too* much, but combining patches and/or series that ar=
en't tightly
> > > coupled or dependent in some way usually does more harm than good.  E=
.g. if a
> > > maintainer has complaints against only one or two patches in series o=
f unrelated
> > > patches, then grabbing the "good" patches is unnecessarily difficult.=
  It's not
> > > truly hard on the maintainer's end, but little bits of avoidable fric=
tion in the
> > > process adds up across hundreds and thousands of patches.
> > >
> > > FWIW, my plan is to apply Roman's patch pretty much as-is, grab v2 fr=
om Jim, and
> > > post my cleanups as a separate series on top (maybe two series, reall=
y haven't
> > > thought about it yet).  The only reason I have them all in a single b=
ranch is
> > > because there are code conflicts and I know I will apply the patches =
from Roman
> > > and Jim first, i.e. I didn't want to develop on a base that I knew wo=
uld become
> > > stale.
> > >
> > > > So, I would like to put them together in the same context with a co=
ver letter
> > > > fully describing the details.
> > >
> > > I certainly won't object to a thorough bug report/analysis, but I'd p=
refer that
> > > Jim's series be posted separately (though I don't care if it's you or=
 Jim that
> > > posts it).
> >
> > Thanks for agreeing to put things together. In fact, everything
> > together means all relevant fix patches for the same bug need to be
> > together. But I will put my patch explicitly as _optional_ mentioned
> > in the cover letter.

No, please do not post your version of the emulated_counter patch.  I am mo=
re
than happy to give you primary author credit (though I need your SoB), all =
I care
about is minimizing the amount of effort and overhead on my end.  At this p=
oint,
posting your version at this time will only generate more noise and make my=
 job
harder.  To tie everything together in the cover letter, just include lore =
links
to the relevant pseudo-patches.

Assuming you are taking over Jim's series, please post v2 asap.  I want to =
get
the critical fixes applied sooner than later.

> > If the series causes inconvenience, please accept my apology. For the
> > sense of responsibility, I think I could just use this opportunity to
> > send my updated version with your comment fixed. I will also use this
> > chance to update your fix to Jim's patches.
> >
> > One last thing, breaking the kvm-unit-test/pmu still surprises me.
> > Please test it again when you have a chance. Maybe adding more fixes
> > on top. With the series sent, I will hand it over to you.
> >
>=20
> Never, this is a test failure that we already solved internally.
> Applying the following fix to kvm-unit-tests/pmu remove the failures:
>=20
> diff --git a/x86/pmu.c b/x86/pmu.c
> index 0def2869..667e6233 100644
> --- a/x86/pmu.c
> +++ b/x86/pmu.c
> @@ -68,6 +68,7 @@ volatile uint64_t irq_received;
>  static void cnt_overflow(isr_regs_t *regs)
>  {
>         irq_received++;
> +       apic_write(APIC_LVTPC, apic_read(APIC_LVTPC) & ~APIC_LVT_MASKED);
>         apic_write(APIC_EOI, 0);
>  }
>=20
> Since KVM vPMU adds a mask when injecting the PMI, it is the
> responsibility of the guest PMI handler to remove the mask and allow
> subsequent PMIs delivered.
>=20
> We should upstream the above fix some time.

Please post the above asap.  And give pmu_pebs.c's cnt_overflow() the same
treatment when you do.  Or just give my your SoB and I'll write the changel=
og.
