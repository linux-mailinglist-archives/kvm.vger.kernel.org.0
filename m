Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54E607AB9F5
	for <lists+kvm@lfdr.de>; Fri, 22 Sep 2023 21:21:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233253AbjIVTVt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Sep 2023 15:21:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231226AbjIVTVr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Sep 2023 15:21:47 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34B35A3
        for <kvm@vger.kernel.org>; Fri, 22 Sep 2023 12:21:41 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-59c29d6887cso38927437b3.0
        for <kvm@vger.kernel.org>; Fri, 22 Sep 2023 12:21:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1695410500; x=1696015300; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=R48U7uSCoZCqnr9B0catLMfflr6AkPCT1nbo0cLu9p8=;
        b=Ru9MtWQlovxKG0p09RxzzsJoS7mdPSSXAB/FSNvP+0Yui8b+InpV2U8hq8CsvsQBVo
         G+JrBst8K3+5P3SdFQAMfOFhERksqE2w/lTpVYT/G3bwk2E6Lo5G06xEtq7I3OWbl0Xh
         ktraUR+fCUdohpVoNeL1xLjFgDHRuXYWu9X5QigZtXFgkqHnYxWPPj+3ttLU+me1o0FM
         Yn3nTTaEmWJMkjmRcnkFRjxQ9T7ZNYV0v9Dv34Mmfm46vzJbBMkBaZFslmO1Tg54zBJP
         KYQ0ODYwo2xchrz7XgSA4gAuze0x60e4Fng11YBKlXLWao/KMUktBhxV7+lFgVDQZn7j
         605w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695410500; x=1696015300;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=R48U7uSCoZCqnr9B0catLMfflr6AkPCT1nbo0cLu9p8=;
        b=RYvrYCtYG3SbGePozv64bt7w681GYytSqDANmvYQhVT34iTo41aOnJNBOEfOPH0utl
         U5aIzrHYmbFnn8Gc38Ov5Z031EE5qE2xnVU3phBV0WqvNuRr0reKpFLIKpjiihFolQcg
         TS1ix6tikXB9vI+N+Tu+KCYjDFADwJojVP/zN/mDa9LabOCWVjuxaePLBUAn6Dj+XErT
         OLy3Qjjj9Q1b7KoL0SdNUEBp16hPgGbhG7iIMlD6NFy2j8MJ61d9CkhGLvEVRATJfocE
         wmEgLOt1SUMi6ABkJdX8DLRruoWYKnqfdwbb16oJmk0dB5KlOYMZj3qDBZpoZ7EQn1wt
         lgIg==
X-Gm-Message-State: AOJu0Ywhx7XdY5FqVJB14GqpX5XtgOPc76p4NasJdR+B4zfWkgVVUGIf
        LozIaVBGYbxf1ZQaIMfWMf+RWgExsuk=
X-Google-Smtp-Source: AGHT+IGYDFFPWEvQFK94Dgn073DcI/r82vtXpTeUpcsvW3w1Ebrytj1CTwJd1oIfa4mSE4woAyV9a31TDMc=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:50c7:0:b0:d7e:7a8a:2159 with SMTP id
 e190-20020a2550c7000000b00d7e7a8a2159mr2158ybb.5.1695410500460; Fri, 22 Sep
 2023 12:21:40 -0700 (PDT)
Date:   Fri, 22 Sep 2023 12:21:37 -0700
In-Reply-To: <CALMp9eRQKUy7+AXWepsuJ=KguVMTTcgimeEjd3zMnEP-3LEDKg@mail.gmail.com>
Mime-Version: 1.0
References: <20230901185646.2823254-1-jmattson@google.com> <ZQ3hD+zBCkZxZclS@google.com>
 <CALMp9eRQKUy7+AXWepsuJ=KguVMTTcgimeEjd3zMnEP-3LEDKg@mail.gmail.com>
Message-ID: <ZQ3pQfu6Zw3MMvKx@google.com>
Subject: Re: [PATCH 1/2] KVM: x86: Synthesize at most one PMI per VM-exit
From:   Sean Christopherson <seanjc@google.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Like Xu <likexu@tencent.com>,
        Mingwei Zhang <mizhang@google.com>,
        Roman Kagan <rkagan@amazon.de>,
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

On Fri, Sep 22, 2023, Jim Mattson wrote:
> On Fri, Sep 22, 2023 at 11:46=E2=80=AFAM Sean Christopherson <seanjc@goog=
le.com> wrote:
> >
> > On Fri, Sep 01, 2023, Jim Mattson wrote:
> > > When the irq_work callback, kvm_pmi_trigger_fn(), is invoked during a
> > > VM-exit that also invokes __kvm_perf_overflow() as a result of
> > > instruction emulation, kvm_pmu_deliver_pmi() will be called twice
> > > before the next VM-entry.
> > >
> > > That shouldn't be a problem. The local APIC is supposed to
> > > automatically set the mask flag in LVTPC when it handles a PMI, so th=
e
> > > second PMI should be inhibited. However, KVM's local APIC emulation
> > > fails to set the mask flag in LVTPC when it handles a PMI, so two PMI=
s
> > > are delivered via the local APIC. In the common case, where LVTPC is
> > > configured to deliver an NMI, the first NMI is vectored through the
> > > guest IDT, and the second one is held pending. When the NMI handler
> > > returns, the second NMI is vectored through the IDT. For Linux guests=
,
> > > this results in the "dazed and confused" spurious NMI message.
> > >
> > > Though the obvious fix is to set the mask flag in LVTPC when handling
> > > a PMI, KVM's logic around synthesizing a PMI is unnecessarily
> > > convoluted.
> >
> > To address Like's question about whether not this is necessary, I think=
 we should
> > rephrase this to explicitly state this is a bug irrespective of the who=
le LVTPC
> > masking thing.
> >
> > And I think it makes sense to swap the order of the two patches.  The L=
VTPC masking
> > fix is a clearcut architectural violation.  This is a bit more of a gre=
y area,
> > though still blatantly buggy.
>=20
> The reason I ordered the patches as I did is that when this patch
> comes first, it actually fixes the problem that was introduced in
> commit 9cd803d496e7 ("KVM: x86: Update vPMCs when retiring
> instructions"). If this patch comes second, it's less clear that it
> fixes a bug, since the other patch renders this one essentially moot.

Yeah, but as Like pointed out, the way the changelog is worded just raises =
the
question of why this change is necessary.

I think we should tag them both for stable.  They're both bug fixes, regard=
less
of the ordering.
