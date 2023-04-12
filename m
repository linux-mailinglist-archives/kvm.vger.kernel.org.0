Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E10016DF924
	for <lists+kvm@lfdr.de>; Wed, 12 Apr 2023 16:56:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230163AbjDLO4j (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Apr 2023 10:56:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230281AbjDLO4f (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Apr 2023 10:56:35 -0400
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73CE77DA0
        for <kvm@vger.kernel.org>; Wed, 12 Apr 2023 07:56:11 -0700 (PDT)
Received: from mail-yb1-f198.google.com (mail-yb1-f198.google.com [209.85.219.198])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 3C45C3F429
        for <kvm@vger.kernel.org>; Wed, 12 Apr 2023 14:56:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1681311370;
        bh=OxpzX6kzOmYSsKE6qMLSC1R+x0dOP8fBolvejWA6sqA=;
        h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
         To:Cc:Content-Type;
        b=mDcdiTqot7FrCYU2Wl2VINayp+tkEYTHc1FxeB9hDYvLpfRK7IL/0klAdrBPoHbQw
         XsafG9JkTb/812ppF6NqoU6lNJI+xkotON6flvbyhhdzwif2bLDMiWY5ZuzRrdTlT7
         W8mBHt7xdMPS1RufG3yvYDPiFeSwhrxMJWj120Xh4jlHmxZPV3ueIzfVOwwIAxmt0a
         LEm0fl+bCMpsgr4NuMpcINah22AQc7W0dvX+18TTR35mUhUK8LH/+tzHmQ5DyjRhxq
         sL2D2+9uajpW7VenuLFKxKtq2tkNsgWF3U6DA5RFsO+Rj/5/8EdsFyQ/DHzbZDTz0F
         3/gPO0lMC562g==
Received: by mail-yb1-f198.google.com with SMTP id 186-20020a2510c3000000b00b880000325bso28883029ybq.3
        for <kvm@vger.kernel.org>; Wed, 12 Apr 2023 07:56:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681311369; x=1683903369;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OxpzX6kzOmYSsKE6qMLSC1R+x0dOP8fBolvejWA6sqA=;
        b=OMWhmgd9fbkydksfilMjYk4idNPHQJlDZpifaJAwwcLwT+qbXQ3Dly/ZP1pvIKA92l
         0af7IxRccEO0Vbf6WD18ODu6b5S0lFAgmagsdkiOiynvu44DCAuFKdA0tfJ0X45/K8mV
         jh27bCzT+X6JMOdLyxf5mec4WQbJC73d0l5QCeZ1ykgKqWY/wwkalNP0MWH51H7ZXZZ1
         nIl4/bXg0Bo0jepVt94wKFnuhIdQSmM8JD9ZL097EvijMBEcuZ+E4zhA6wOHo8faD7eV
         qWXr7tIiORg6pQ1ce/OfFbochfbBUPmy/rA87PgNNuflMdV5nwJtFk3Q0jkdbA1r8Vvi
         /BWg==
X-Gm-Message-State: AAQBX9cD9siCsDYR7R99l9eKVrC7lhZxwndVvAdboJGk3xBx9kQPADMu
        RoRWVw47UyCv1RrTL96Ga2vN8JPzBS+PnVJxqjSL/HCBq/ptxuSgY6gtxNEUyMvwbejuDKkiUqu
        AtZiMgqg9TaS0y+rGaz9soJF/FKbPCfGXR5IxMf6anBAbEg==
X-Received: by 2002:a25:76c6:0:b0:b8b:ee74:c9d4 with SMTP id r189-20020a2576c6000000b00b8bee74c9d4mr12272194ybc.12.1681311369262;
        Wed, 12 Apr 2023 07:56:09 -0700 (PDT)
X-Google-Smtp-Source: AKy350ayKQid4DrFAszxepNHukT7rDUmpRKfL4/yXe/Auq2u5OoAJAKLAvIupIl1TNxT0UPAazi0OdRaFIcQIia5ivY=
X-Received: by 2002:a25:76c6:0:b0:b8b:ee74:c9d4 with SMTP id
 r189-20020a2576c6000000b00b8bee74c9d4mr12272184ybc.12.1681311369029; Wed, 12
 Apr 2023 07:56:09 -0700 (PDT)
MIME-Version: 1.0
References: <20230404122652.275005-1-aleksandr.mikhalitsyn@canonical.com>
 <20230404122652.275005-3-aleksandr.mikhalitsyn@canonical.com> <20230411224337.000015ce.zhi.wang.linux@gmail.com>
In-Reply-To: <20230411224337.000015ce.zhi.wang.linux@gmail.com>
From:   Aleksandr Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
Date:   Wed, 12 Apr 2023 16:55:58 +0200
Message-ID: <CAEivzxd6GFMcW-k_dNKy83bHgPfa7iMivE=kdV-88Vkp28H2WA@mail.gmail.com>
Subject: Re: [PATCH 2/2] KVM: SVM: add some info prints to SEV init
To:     Zhi Wang <zhi.wang.linux@gmail.com>
Cc:     pbonzini@redhat.com, Sean Christopherson <seanjc@google.com>,
        =?UTF-8?Q?St=C3=A9phane_Graber?= <stgraber@ubuntu.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 11, 2023 at 9:43=E2=80=AFPM Zhi Wang <zhi.wang.linux@gmail.com>=
 wrote:
>
> On Tue,  4 Apr 2023 14:26:52 +0200
> Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com> wrote:
>
> > Let's add a few pr_info's to sev_hardware_setup to make SEV/SEV-ES
> > enabling a little bit handier for users. Right now it's too hard
> > to guess why SEV/SEV-ES are failing to enable.
> >
> > There are a few reasons.
> > SEV:
> > - npt is disabled (module parameter)
>      ^NPT
> > - CPU lacks some features (sev, decodeassists)
> > - Maximum SEV ASID is 0
> >
> > SEV-ES:
> > - mmio_caching is disabled (module parameter)
> > - CPU lacks sev_es feature
> > - Minimum SEV ASID value is 1 (can be adjusted in BIOS/UEFI)
> >
> > Cc: Sean Christopherson <seanjc@google.com>
> > Cc: Paolo Bonzini <pbonzini@redhat.com>
> > Cc: St=C3=A9phane Graber <stgraber@ubuntu.com>
> > Cc: kvm@vger.kernel.org
> > Cc: linux-kernel@vger.kernel.org
> > Signed-off-by: Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.c=
om>
> > ---
> >  arch/x86/kvm/svm/sev.c | 27 +++++++++++++++++++++------
> >  1 file changed, 21 insertions(+), 6 deletions(-)
> >
> > diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> > index a42536a0681a..14cbb8f14c6b 100644
> > --- a/arch/x86/kvm/svm/sev.c
> > +++ b/arch/x86/kvm/svm/sev.c
> > @@ -2168,17 +2168,24 @@ void __init sev_hardware_setup(void)
> >       bool sev_es_supported =3D false;
> >       bool sev_supported =3D false;
> >
> > -     if (!sev_enabled || !npt_enabled)
> > +     if (!sev_enabled)
> >               goto out;
> >
> > +     if (!npt_enabled) {
> > +             pr_info("Failed to enable AMD SEV as it requires Nested P=
aging to be enabled\n");
> > +             goto out;
>
> Shouldn't we use pr_err() for error message?

I'm not sure. Because technically that's not an error, that is an
information message about current configuration.


>
> > +     }
> > +
> >       /*
> >        * SEV must obviously be supported in hardware.  Sanity check tha=
t the
> >        * CPU supports decode assists, which is mandatory for SEV guests=
 to
> >        * support instruction emulation.
> >        */
> >       if (!boot_cpu_has(X86_FEATURE_SEV) ||
> > -         WARN_ON_ONCE(!boot_cpu_has(X86_FEATURE_DECODEASSISTS)))
> > +         WARN_ON_ONCE(!boot_cpu_has(X86_FEATURE_DECODEASSISTS))) {
> > +             pr_info("Failed to enable AMD SEV as it requires decodeas=
sists and sev CPU features\n");
> >               goto out;
> > +     }
> >
> >       /* Retrieve SEV CPUID information */
> >       cpuid(0x8000001f, &eax, &ebx, &ecx, &edx);
> > @@ -2188,8 +2195,10 @@ void __init sev_hardware_setup(void)
> >
> >       /* Maximum number of encrypted guests supported simultaneously */
> >       max_sev_asid =3D ecx;
> > -     if (!max_sev_asid)
> > +     if (!max_sev_asid) {
> > +             pr_info("Failed to enable SEV as the maximum SEV ASID val=
ue is 0.\n");
> >               goto out;
> > +     }
> >
> >       /* Minimum ASID value that should be used for SEV guest */
> >       min_sev_asid =3D edx;
> > @@ -2234,16 +2243,22 @@ void __init sev_hardware_setup(void)
> >        * instead relies on #NPF(RSVD) being reflected into the guest as=
 #VC
> >        * (the guest can then do a #VMGEXIT to request MMIO emulation).
> >        */
> > -     if (!enable_mmio_caching)
> > +     if (!enable_mmio_caching) {
> > +             pr_info("Failed to enable SEV-ES as it requires MMIO cach=
ing to be enabled\n");
> >               goto out;
> > +     }
> >
> >       /* Does the CPU support SEV-ES? */
> > -     if (!boot_cpu_has(X86_FEATURE_SEV_ES))
> > +     if (!boot_cpu_has(X86_FEATURE_SEV_ES)) {
> > +             pr_info("Failed to enable SEV-ES as it requires sev_es CP=
U feature\n");
> >               goto out;
> > +     }
> >
> >       /* Has the system been allocated ASIDs for SEV-ES? */
> > -     if (min_sev_asid =3D=3D 1)
> > +     if (min_sev_asid =3D=3D 1) {
> > +             pr_info("Failed to enable SEV-ES as the minimum SEV ASID =
value is 1.\n");
> >               goto out;
> > +     }
> >
> >       sev_es_asid_count =3D min_sev_asid - 1;
> >       if (misc_cg_set_capacity(MISC_CG_RES_SEV_ES, sev_es_asid_count))
>
> As this patch is making sev_hardware_setup()more informative, it would be
> better to print both ASID range and count (instead of only ASID count in
> the current code). I was suspecting there seems a bug of ASID range alloc=
ation
> in the current code, but I don't have the HW to test yet...
