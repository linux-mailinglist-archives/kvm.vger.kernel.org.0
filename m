Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E535786950
	for <lists+kvm@lfdr.de>; Thu, 24 Aug 2023 10:04:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231515AbjHXIE2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Aug 2023 04:04:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240439AbjHXIEV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Aug 2023 04:04:21 -0400
Received: from mail-lj1-x22f.google.com (mail-lj1-x22f.google.com [IPv6:2a00:1450:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B9B6199A
        for <kvm@vger.kernel.org>; Thu, 24 Aug 2023 01:03:36 -0700 (PDT)
Received: by mail-lj1-x22f.google.com with SMTP id 38308e7fff4ca-2b9b50be31aso98958861fa.3
        for <kvm@vger.kernel.org>; Thu, 24 Aug 2023 01:03:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1692864202; x=1693469002;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FwL3iE/sigInGebDo7+XC2zrCJyIJXwWg9T7XgYdvUo=;
        b=gxvA/c6f/mD+SfAn3i79Fac49CIYCfuEAc0NJXFLYFB579Htuh0raSgmo5mwINjJKP
         6mZXPbJVoLaq/tx8bw95ips+dNfMElarUiEFePbfy6xKS2dz4ss1ZXXCCdNYMwI1jeLf
         17LTOViCbmKzZvWJJEazhuc9QUFLtiG02+szQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692864202; x=1693469002;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FwL3iE/sigInGebDo7+XC2zrCJyIJXwWg9T7XgYdvUo=;
        b=ZyHcVZSelEvk+665hqx6R+eOs6xpADCeIQ7q2RUdHId0yRCsqdDG7DZh9DPR7j1xiM
         ecX2LFO3Dcp2qHfRxxoTirQtAd2EWK5V5dFph1nCe0GiwIy0cPxPTTFh2fy1z23T5n9k
         SDKhWfQFBs+zL7udDP9L5xfYHzQHelJ3a/taC52r3YCsTXHqahS7brC7Xk7C5OS5iReS
         a2AYdqLVR8y0bsiveMQeo3cTroQLZKgAqjenq4KCPHFgwVYK50EqrYJ1LmPyeT8sXkB3
         MSp9MImyVXmKd1jASETtRFElZP09D39qxS285kWY4sWNKoS6TC4kSge3mVxY8DkLf9/q
         wW6A==
X-Gm-Message-State: AOJu0YypPdM54DNFaOG9gJps1AapF9Z446JtmjIpnGNXzn5/L2UYAZUH
        BG3F9MNd91eR+FHRJOVNDIVe+0DUxppd12xlll7VqQ==
X-Google-Smtp-Source: AGHT+IEJrvoCh3YeHUxATo9a8VY8kdH7uwNLYGWpcGp3BdwVjU+SPGgyEkpIPGghrgwO/hJ/muX8oz01uFd1YWIRnOA=
X-Received: by 2002:a2e:8e97:0:b0:2bb:aaab:b42f with SMTP id
 z23-20020a2e8e97000000b002bbaaabb42fmr10476719ljk.49.1692864202467; Thu, 24
 Aug 2023 01:03:22 -0700 (PDT)
MIME-Version: 1.0
References: <20230704075054.3344915-1-stevensd@google.com> <20230704075054.3344915-5-stevensd@google.com>
 <20230706015449.GB3894444@ls.amr.corp.intel.com>
In-Reply-To: <20230706015449.GB3894444@ls.amr.corp.intel.com>
From:   David Stevens <stevensd@chromium.org>
Date:   Thu, 24 Aug 2023 17:03:11 +0900
Message-ID: <CAD=HUj43RG6M5_TEKBjv+Aioj8rZXKZFN_R8dinjhcpnN219hg@mail.gmail.com>
Subject: Re: [PATCH v7 4/8] KVM: x86/mmu: Migrate to __kvm_follow_pfn
To:     Isaku Yamahata <isaku.yamahata@gmail.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Marc Zyngier <maz@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Peter Xu <peterx@redhat.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 6, 2023 at 10:54=E2=80=AFAM Isaku Yamahata <isaku.yamahata@gmai=
l.com> wrote:
>
> On Tue, Jul 04, 2023 at 04:50:49PM +0900,
> David Stevens <stevensd@chromium.org> wrote:
>
> > From: David Stevens <stevensd@chromium.org>
> >
> > Migrate from __gfn_to_pfn_memslot to __kvm_follow_pfn.
> >
> > Signed-off-by: David Stevens <stevensd@chromium.org>
> > ---
> >  arch/x86/kvm/mmu/mmu.c | 35 +++++++++++++++++++++++++----------
> >  1 file changed, 25 insertions(+), 10 deletions(-)
> >
> > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > index ec169f5c7dce..e44ab512c3a1 100644
> > --- a/arch/x86/kvm/mmu/mmu.c
> > +++ b/arch/x86/kvm/mmu/mmu.c
> > @@ -4296,7 +4296,12 @@ void kvm_arch_async_page_ready(struct kvm_vcpu *=
vcpu, struct kvm_async_pf *work)
> >  static int __kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fa=
ult *fault)
> >  {
> >       struct kvm_memory_slot *slot =3D fault->slot;
> > -     bool async;
> > +     struct kvm_follow_pfn foll =3D {
> > +             .slot =3D slot,
> > +             .gfn =3D fault->gfn,
> > +             .flags =3D FOLL_GET | (fault->write ? FOLL_WRITE : 0),
> > +             .allow_write_mapping =3D true,
> > +     };
> >
> >       /*
> >        * Retry the page fault if the gfn hit a memslot that is being de=
leted
> > @@ -4325,12 +4330,14 @@ static int __kvm_faultin_pfn(struct kvm_vcpu *v=
cpu, struct kvm_page_fault *fault
> >                       return RET_PF_EMULATE;
> >       }
> >
> > -     async =3D false;
> > -     fault->pfn =3D __gfn_to_pfn_memslot(slot, fault->gfn, false, fals=
e, &async,
> > -                                       fault->write, &fault->map_writa=
ble,
> > -                                       &fault->hva);
> > -     if (!async)
> > -             return RET_PF_CONTINUE; /* *pfn has correct page already =
*/
> > +     foll.flags |=3D FOLL_NOWAIT;
> > +     fault->pfn =3D __kvm_follow_pfn(&foll);
> > +
> > +     if (!is_error_noslot_pfn(fault->pfn))
>
> We have pfn in struct kvm_follow_pfn as output. Can we make __kvm_follow_=
pfn()
> return int instead of kvm_pfn_t?  KVM_PFN_* seems widely used, though.

Switching __kvm_follow_pfn to return an int isn't difficult, but doing
is cleanly would require reworking the kvm_pfn_t/KVM_PFN_ERR_* api,
which as you said is quite widely used. That's a bit larger scope than
I want to do in this patch series.

-David
