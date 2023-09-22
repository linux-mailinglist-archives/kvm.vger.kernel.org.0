Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFAD17ABADB
	for <lists+kvm@lfdr.de>; Fri, 22 Sep 2023 23:06:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229821AbjIVVGQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Sep 2023 17:06:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229800AbjIVVGP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Sep 2023 17:06:15 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24F2BAC
        for <kvm@vger.kernel.org>; Fri, 22 Sep 2023 14:06:06 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-d8486b5e780so3771017276.0
        for <kvm@vger.kernel.org>; Fri, 22 Sep 2023 14:06:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1695416765; x=1696021565; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1zXYcDXGcYsJ3QPsWifTFwSLqnVRcb5JJ8vcVIWXvts=;
        b=bOtpf4E3ghRaqlNtJWPGy8GpuNwjbFnGyTNnJjTOnc9iKazp6mNecW2jY4q/QgTCvC
         wP2KT6ZpbNlxM1Ib8T6IE9J9eLaWVrF6GJjuW98k/fFLHhFHK3U0oaWJNLApd+JlQ1lj
         UOwDVa6LBAL8dW+kF2cxRLdiT0kQyd8YHyT/puOEGXF8TeP+/6OCQOUSpbT9ISr1/Lcg
         2QHoEwH4S67W1MCqSUCHXoS9YmInJ8OpQ67VQSVR/sOCsSB2i8rQZxd4sXjOE3kHZcfN
         NixmSFpctIH17blePz0XmTbs/6vaYxhiubG7OGGYah3TKNbwkouU1RsSQ9waWS/FoXSU
         V/cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695416765; x=1696021565;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=1zXYcDXGcYsJ3QPsWifTFwSLqnVRcb5JJ8vcVIWXvts=;
        b=eh3A76Y/2zPcQVMDB8V0bxpKM+VJU20mTmQmcWI1DY6Lh1dEckhjSZ2sx2Md8RRHVx
         V7oZJvsC6Qnnfaar22mgp8D7YkssAcZczz/gF0q/+kDPB5XgSAOK0kXr3a5zLQGseCt7
         qGBFkoVZ3V5Jr8EDi64Q1d9837Lid9eGb8m9N/8peZulf7FAkmsptVYGsEsqHYPbJloG
         n6I4rKXOS3o+G5HwGakETYMrxfO/AJQSAPIKFNYLS6eVh+TY2L72J9gSyHLLeMz98HG0
         GU7uZUtsk+3HESi/Cgomk8kdTALbHguXpU0fiK01P6o6cj7QytNzhZ0NAvByddZeg+W/
         849Q==
X-Gm-Message-State: AOJu0Ywy/5PyYy3plKFBXVudC80n3/1BevgV7Ck/nAIgBomPOo8cts7U
        yePubXVmSLdB4R/stT1sxgiIQmSIZVE=
X-Google-Smtp-Source: AGHT+IH5AnMjHoqEfoPtSneNLc3UwUPsmouF8vmMfXMFATQ6atPMJpT0g8nry2TZjuvAo0h335C8TSnRzVg=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1689:b0:d7b:9902:fb3d with SMTP id
 bx9-20020a056902168900b00d7b9902fb3dmr5114ybb.0.1695416765393; Fri, 22 Sep
 2023 14:06:05 -0700 (PDT)
Date:   Fri, 22 Sep 2023 14:06:04 -0700
In-Reply-To: <CAL715WL8KN1fceDhKxCfeGjbctx=vz2pAbw607pFYP6bw9N0_w@mail.gmail.com>
Mime-Version: 1.0
References: <20230901185646.2823254-1-jmattson@google.com> <ZQ3hD+zBCkZxZclS@google.com>
 <CALMp9eRQKUy7+AXWepsuJ=KguVMTTcgimeEjd3zMnEP-3LEDKg@mail.gmail.com>
 <ZQ3pQfu6Zw3MMvKx@google.com> <CAL715WKguAT_K_eUTxk8XEQ5rQ=e5WhEFdwOx8VpkpTHJWgRFw@mail.gmail.com>
 <ZQ36bxFOZM0s5+uk@google.com> <CAL715WL8KN1fceDhKxCfeGjbctx=vz2pAbw607pFYP6bw9N0_w@mail.gmail.com>
Message-ID: <ZQ4BvCsFjLmnSxhd@google.com>
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
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 22, 2023, Mingwei Zhang wrote:
> On Fri, Sep 22, 2023 at 1:34=E2=80=AFPM Sean Christopherson <seanjc@googl=
e.com> wrote:
> >
> > On Fri, Sep 22, 2023, Mingwei Zhang wrote:
> > > Agree. Both patches are fixing the general potential buggy situation
> > > of multiple PMI injection on one vm entry: one software level defense
> > > (forcing the usage of KVM_REQ_PMI) and one hardware level defense
> > > (preventing PMI injection using mask).
> > >
> > > Although neither patch in this series is fixing the root cause of thi=
s
> > > specific double PMI injection bug, I don't see a reason why we cannot
> > > add a "fixes" tag to them, since we may fix it and create it again.
> > >
> > > I am currently working on it and testing my patch. Please give me som=
e
> > > time, I think I could try sending out one version today. Once that is
> > > done, I will combine mine with the existing patch and send it out as =
a
> > > series.
> >
> > Me confused, what patch?  And what does this patch have to do with Jim'=
s series?
> > Unless I've missed something, Jim's patches are good to go with my nits=
 addressed.
>=20
> Let me step back.
>=20
> We have the following problem when we run perf inside guest:
>=20
> [ 1437.487320] Uhhuh. NMI received for unknown reason 20 on CPU 3.
> [ 1437.487330] Dazed and confused, but trying to continue
>=20
> This means there are more NMIs that guest PMI could understand. So
> there are potentially two approaches to solve the problem: 1) fix the
> PMI injection issue: only one can be injected; 2) fix the code that
> causes the (incorrect) multiple PMI injection.

No, because the LVTPC masking fix isn't optional, the current KVM behavior =
is a
clear violation of the SDM.  And I'm struggling to think of a sane way to f=
ix the
IRQ work bug, e.g. KVM would have to busy on the work finishing before resu=
ming
the guest, which is rather crazy.

I'm not saying there isn't more work to be done, nor am I saying that we sh=
ouldn't
further harden KVM against double-injection.  I'm just truly confused as to=
 what
that has to do with Jim's fixes.

> I am working on the 2nd one. So, the property of the 2nd one is:
> without patches in 1) (Jim's patches), we could still avoid the above
> warning messages.
