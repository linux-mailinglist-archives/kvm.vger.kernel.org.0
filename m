Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14C307ADF9F
	for <lists+kvm@lfdr.de>; Mon, 25 Sep 2023 21:35:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233296AbjIYTfO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Sep 2023 15:35:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232165AbjIYTfN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Sep 2023 15:35:13 -0400
Received: from mail-qt1-x829.google.com (mail-qt1-x829.google.com [IPv6:2607:f8b0:4864:20::829])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A83B610A
        for <kvm@vger.kernel.org>; Mon, 25 Sep 2023 12:35:05 -0700 (PDT)
Received: by mail-qt1-x829.google.com with SMTP id d75a77b69052e-4181f8d82b9so8820701cf.0
        for <kvm@vger.kernel.org>; Mon, 25 Sep 2023 12:35:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1695670505; x=1696275305; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Mnh3O7m7W6nR87RF4zMqQvhpvq8Z7yUQbT+7w28c04o=;
        b=b3zQmM8gxDtRP6zeMLQgOeMZ3eSkwU/ORZUdOaEfVtAmv67h5O/8JCM7xs2L/W80mI
         On8jIRKXR3uuSaCEDC9cxcvysQ/+bl6nL3AJXkICWQ+N6B55xUVS502grqznMvAaOg1n
         LuNAxA5HAa339YXhcCtlCwvz15h/O/Hr9r+3AEYC4wHD8ZRQ18duHZ5no8dnSvhySjiF
         Q0Q5FcQ+fXvnVmqEWu9kFCklqN3Vs4mLg/jNceC5HLNmWS6ghRSRJ3bFk9qofNFw1zyx
         wZi07NT7mAZESczb12h5PA13hDNat65PC5U0NVxrIEMP3XTd2JcLajUEKcdyzYyOdZMX
         xwNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695670505; x=1696275305;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Mnh3O7m7W6nR87RF4zMqQvhpvq8Z7yUQbT+7w28c04o=;
        b=C7MLdJB1jNgSA1tGqS4OH1ihCw7vW7EcRc9plfHKDOZ87g3xqzXaGIR0eC0vrLm+bE
         nKzncouT0cWFx5PigWO4ZQlXQbj4lTDTXpfOlXWsEWUdAVB6buZ3TPT09MD+PIu5Dk3k
         ojgHmNXA4CNGM+kAO3yj2R/Xj+euss/qIKSXFaJdQmt9JpltOPxmBcMfDNDDQPoByDtY
         50reg0k4A4iss3tztSc9n53Hdb11ehW5YOwVUOq0Cxhhanws+zh7rr1JcmsKPbY1psGR
         2hOblMDUwBvfUiYmYJZbr2IhP8Plza5EsKXEsfUhYvsGzt96cZtyRsgvdnMKfgnSiZeL
         rpKg==
X-Gm-Message-State: AOJu0YxB3Gk2sqH9b9m0dhslVF1nMwOCfr1xgO8lwKsUNRQv4MInerux
        dEtfXHjPQD4rLDP338xr7M9mPeiqj2dDwqlEZPClGw==
X-Google-Smtp-Source: AGHT+IHdN5SBGMHA0vFraankTBd+lcn3bhRYs72NLxucA4dDw3khM1sIZr29W6/HnxBbR/6FLJoeNrCH83R5x9/noTg=
X-Received: by 2002:a05:6214:33c7:b0:658:3af3:3d9a with SMTP id
 mw7-20020a05621433c700b006583af33d9amr7933187qvb.1.1695670504618; Mon, 25 Sep
 2023 12:35:04 -0700 (PDT)
MIME-Version: 1.0
References: <20230925173448.3518223-1-mizhang@google.com> <20230925173448.3518223-3-mizhang@google.com>
 <ZRHIyUEUeXnw7hii@google.com>
In-Reply-To: <ZRHIyUEUeXnw7hii@google.com>
From:   Mingwei Zhang <mizhang@google.com>
Date:   Mon, 25 Sep 2023 12:34:28 -0700
Message-ID: <CAL715WJ2AQ8G1cps_xquqcerDJ5H2Vq=DGZhdSff5ft=2uxY4w@mail.gmail.com>
Subject: Re: [PATCH 2/2] KVM: x86: Mask LVTPC when handling a PMI
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jim Mattson <jmattson@google.com>,
        Dapeng Mi <dapeng1.mi@linux.intel.com>,
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

On Mon, Sep 25, 2023 at 10:52=E2=80=AFAM Sean Christopherson <seanjc@google=
.com> wrote:
>
> On Mon, Sep 25, 2023, Mingwei Zhang wrote:
> > From: Jim Mattson <jmattson@google.com>
> >
> > Per the SDM, "When the local APIC handles a performance-monitoring
> > counters interrupt, it automatically sets the mask flag in the LVT
> > performance counter register."
> >
> > Add this behavior to KVM's local APIC emulation, to reduce the
> > incidence of "dazed and confused" spurious NMI warnings in Linux
> > guests (at least, those that use a PMI handler with "late_ack").
> >
> > Fixes: 23930f9521c9 ("KVM: x86: Enable NMI Watchdog via in-kernel PIT s=
ource")
>
> This Fixes is wrong.  Prior to commit f5132b01386b ("KVM: Expose a versio=
n 2
> architectural PMU to a guests"), KVM didn't ever deliver interrupts via t=
he LVTPC
> entry.  E.g. prior to that commit, the only reference to APIC_LVTPC is in
> kvm_lapic_reg_write:
>
>   arch/x86/kvm $ git grep APIC_LVTPC f5132b01386b^
>   f5132b01386b^:lapic.c:  case APIC_LVTPC:
>
> Commit 23930f9521c9 definitely set the PMU support up to fail, but the bu=
g would
> never have existed if kvm_deliver_pmi() had been written as:
>
> void kvm_deliver_pmi(struct kvm_vcpu *vcpu)
> {
>         struct kvm_lapic *apic =3D vcpu->arch.apic;
>
>         if (apic && kvm_apic_local_deliver(apic, APIC_LVTPC))
>                 kvm_lapic_set_reg(apic, APIC_LVTPC,
>                                   kvm_lapic_get_reg(apic, LVTPC) | APIC_L=
VT_MASKED);
> }
>
> And this needs an explicit Cc: to stable because KVM opts out of AUTOSEL.
>
> So
>
>   Fixes: f5132b01386b ("KVM: Expose a version 2 architectural PMU to a gu=
ests")
>   Cc: stable@vger.kernel.org
>
> > Signed-off-by: Jim Mattson <jmattson@google.com>
> > Tested-by: Mingwei Zhang <mizhang@google.com>
>
> When posting patches on behalf of others, you need to provide your SoB.
>
> > ---
> >  arch/x86/kvm/lapic.c | 8 ++++++--
> >  1 file changed, 6 insertions(+), 2 deletions(-)
> >
> > diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> > index 113ca9661ab2..1f3d56a1f45f 100644
> > --- a/arch/x86/kvm/lapic.c
> > +++ b/arch/x86/kvm/lapic.c
> > @@ -2729,13 +2729,17 @@ int kvm_apic_local_deliver(struct kvm_lapic *ap=
ic, int lvt_type)
> >  {
> >       u32 reg =3D kvm_lapic_get_reg(apic, lvt_type);
> >       int vector, mode, trig_mode;
> > +     int r;
> >
> >       if (kvm_apic_hw_enabled(apic) && !(reg & APIC_LVT_MASKED)) {
> >               vector =3D reg & APIC_VECTOR_MASK;
> >               mode =3D reg & APIC_MODE_MASK;
> >               trig_mode =3D reg & APIC_LVT_LEVEL_TRIGGER;
> > -             return __apic_accept_irq(apic, mode, vector, 1, trig_mode=
,
> > -                                     NULL);
> > +
> > +             r =3D __apic_accept_irq(apic, mode, vector, 1, trig_mode,=
 NULL);
> > +             if (r && lvt_type =3D=3D APIC_LVTPC)
> > +                     kvm_lapic_set_reg(apic, lvt_type, reg | APIC_LVT_=
MASKED);
>
> Belated feedback, I think I'd prefer to write this as
>
>                         kvm_lapic_set_reg(apic, APIC_LVTPC, reg | APIC_LV=
T_MASKED);
>
> so that this code will show up when searching for APIC_LVTPC.
>
> > +             return r;
> >       }
> >       return 0;
> >  }
> > --
> > 2.42.0.515.g380fc7ccd1-goog
> >
Signed-off-by: Mingwei Zhang <mizhang@google.com>
