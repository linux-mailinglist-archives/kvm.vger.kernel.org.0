Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DF5370FF49
	for <lists+kvm@lfdr.de>; Wed, 24 May 2023 22:33:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234761AbjEXUdv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 May 2023 16:33:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232021AbjEXUdu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 May 2023 16:33:50 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5997C12B
        for <kvm@vger.kernel.org>; Wed, 24 May 2023 13:33:48 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id 41be03b00d2f7-518d6f87a47so406949a12.3
        for <kvm@vger.kernel.org>; Wed, 24 May 2023 13:33:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1684960428; x=1687552428;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ccOI4mZo9XfuiFQ9V2PeqZJhByctKZGbBlZxcPOJ16o=;
        b=J5mE/dXhDYvUVrKyzwcgeygz3QEleyiIzQplgmVTnGrfT1kd64BHSjrsjRuDHCLFgQ
         oxIhXd0uodkyon9bwjunJ5d4kwWoGNChHzSHAAr9PtIM2o9awxNYDzYF9UTJy9mSUIWP
         4ywbkgPPLXd0lyLDnitUw2BqHg8L3x/S2lUwD4O7i+SwSqdP+SyIdJDKiR1iTS95SDQr
         l1gQKTtXC2syTVeUzkdmajeSwic8xEoRZRkCPaVo33gw+2VXZACbWbaPkvAG8MwmwW0l
         SE7l1Ko3DyFNWEDuBW8VPD7W0wgnJlHPYmw/rBMTEbwCwJAYGxQOJtgJqwnJp6fb7QIQ
         vv+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684960428; x=1687552428;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=ccOI4mZo9XfuiFQ9V2PeqZJhByctKZGbBlZxcPOJ16o=;
        b=Z87MZ1kmpe+9LmM0fNhVgZ4p+ijAcp2RDxGyei09vcmlJgI3iQPhaPn2a33Z6KwMRJ
         CnP97Hf+SM392gSn5ZoI1PQ5qaQC772+Hp06RRvhB8dTR2SCO2HM1ylnvFBTQW90o8vt
         YBHZpVwi6t/PuI/jt3Ol8bXnD2PitOdnLZAxJgAyJ/kErNdL/EwCya6/z+m6hJ0VZQbx
         be3Ng329Ld/lUII19rSia052s3acPTkhHRxVWVIgjS1II78dvFPDliYahP2lG6spXoRv
         LVh8ZCDxPnxoK5+DbEfEWsAt5MUrCururY3b1eYbcYSAUCRIpio7/o+Z0r5wF2qdbh2j
         tupg==
X-Gm-Message-State: AC+VfDxKtH6o6QdmrLEte2itv9XUu9zbW9vorvP+bocx2bKXhMf1CZdz
        l0QSy43m63L9uwH7UQ/otCv0B2AHras=
X-Google-Smtp-Source: ACHHUZ7ogoj9VRxjE2Dsg67VcrHv1bhJs8NbvDJMng3eAz0jKeU0eiETQcE+mZmZat3UDRuw+SZbSDJmSzw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:5fce:0:b0:521:62ef:9b38 with SMTP id
 t197-20020a635fce000000b0052162ef9b38mr4451847pgb.3.1684960427855; Wed, 24
 May 2023 13:33:47 -0700 (PDT)
Date:   Wed, 24 May 2023 13:33:46 -0700
In-Reply-To: <7e84bfb4-b052-4c31-a319-1ea2dd52ae54@gmail.com>
Mime-Version: 1.0
References: <20230322093117.48335-1-likexu@tencent.com> <CABgObfYfiUDf4zY=izcg_32yGCbUxxVc+JAkHGHwiQ0VmGdOgA@mail.gmail.com>
 <871434fe-ae80-bec6-9920-a6411f5842c0@gmail.com> <fce5c1ad-24a3-febf-127e-e97238492143@redhat.com>
 <7e84bfb4-b052-4c31-a319-1ea2dd52ae54@gmail.com>
Message-ID: <ZG50qnYquf77OOoT@google.com>
Subject: Re: [PATCH v2] KVM: x86/pmu: Fix emulation on Intel counters' bit width
From:   Sean Christopherson <seanjc@google.com>
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 28, 2023, Like Xu wrote:
> On 28/3/2023 5:20 pm, Paolo Bonzini wrote:
> > On 3/28/23 11:16, Like Xu wrote:
> > >=20
> > >=20
> > > If IA32_PERF_CAPABILITIES.FW_WRITE[bit 13] =3D1, each IA32_PMCi is ac=
companied by a
> > > corresponding alias address starting at 4C1H for IA32_A_PMC0.
> > >=20
> > > The bit width of the performance monitoring counters is specified in
> > > CPUID.0AH:EAX[23:16].
> > > If IA32_A_PMCi is present, the 64-bit input value (EDX:EAX) of WRMSR
> > > to IA32_A_PMCi will cause
> > > IA32_PMCi to be updated by:
> > >=20
> > > =EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BDCOUNTERWIDTH =3D
> > > =EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=
=BD CPUID.0AH:EAX[23:16] bit width of the performance monitoring counter
> > > =EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BDIA32_PMCi[COUNTERWIDTH-1=
:32] :=3D EDX[COUNTERWIDTH-33:0]);
> > > =EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BDIA32_PMCi[31:0] :=3D EAX=
[31:0];
> > > =EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BDEDX[63:COUNTERWIDTH] are=
 reserved
> > >=20
> > > ---
> > >=20
> > > Some might argue that this is all talking about GP counters, not
> > > fixed counters. In fact, the full-width write hw behaviour is
> > > presumed to do the same thing for all counters.
> > But the above behavior, and the #GP, is only true for IA32_A_PMCi (the
> > full-witdh MSR).=EF=BF=BD Did I understand correctly that the behavior =
for fixed
> > counters is changed without introducing an alias MSR?
> >=20
> > Paolo
> >=20
>=20
> If true, why introducing those alias MSRs ?

My guess is there is/was software in the field that wrote -1 to the GP coun=
ters,
i.e. would have been broken by the new #GP behavior.

> My archaeological findings are:
>=20
> a platform w/o full-witdh like Westmere (has 3-fixed counters already) is
> declared to have a counter width (R:48, W:32) and its successor Sandy Bri=
dge
> has (R:48 , W: 32/48).
>=20
> Thus I think the behaviour of the fixed counter has changed from there, a=
nd
> the alias GP MSRs were introduced to keep the support on 32-bit writes on=
 #GP
> counters (via original address).

FWIW, I see the #GP behavior for fixed counters on Haswell, so this does se=
em to
be the case.  That said, I would like to get confirmation from Intel that t=
his is
architectural and/or working as intended.

Like, can you follow up with Intel to get clarification/confirmation?  And =
ideally
an SDM update...
