Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BAEC79C404
	for <lists+kvm@lfdr.de>; Tue, 12 Sep 2023 05:20:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235678AbjILDUG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Sep 2023 23:20:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242034AbjILDPJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Sep 2023 23:15:09 -0400
Received: from mail-yw1-x112d.google.com (mail-yw1-x112d.google.com [IPv6:2607:f8b0:4864:20::112d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1636F2BB5
        for <kvm@vger.kernel.org>; Mon, 11 Sep 2023 16:51:48 -0700 (PDT)
Received: by mail-yw1-x112d.google.com with SMTP id 00721157ae682-5922380064bso49961337b3.2
        for <kvm@vger.kernel.org>; Mon, 11 Sep 2023 16:51:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1694476237; x=1695081037; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=w16s33Ihl9Edec8v32eClrQeM6o/EkNqBq369IDiij0=;
        b=VgMK03MK1SeycexMEnx6iFI7qphMIECDgu+PDevsWwHo8/Ovoj1/n6xOy6hussybaX
         cSF7LkoAdnbyU804SsIenYbzjPcAmR3jwWaUJs7UVFOwVDsSwxnYSHLWeMLNTcpgJYhq
         7gM4NwITbZCl91GW4rv6DdHweJyHZT2ukRqq9ar5lTKK/V9hsoJfh4HjIzYN07GGbXoU
         TF2HEjczawtCM2NjIZNyPJhd/33KFHwmsG0mIacKRFCQwuzYk/rOb27fogrXRG+9yx58
         B42dfxjvsutgYEWLQydolCGs5ad33WqN8ImsHYY9DZ80rmvbJGKA2UaeQmRITqEPV3KL
         aRTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694476237; x=1695081037;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=w16s33Ihl9Edec8v32eClrQeM6o/EkNqBq369IDiij0=;
        b=wOBmK3xWZPZHrUN0tu+k+ms2DMpM5vYPQV8tPcmxYe+pkp8GaHB9rvEoaUNLRzRslg
         6eMpmwdedhOJq9j1lpruyk241Qddm/Y0P1Q8zMlDOqWgIs0zEga3KTD2S+fzJy1Mb1Tn
         JRWQneXLnTb1A3/Da7LmVMMI1IJoQ1Oo/P8AcKTKPNFFTq5pf2MsgpCHor9tVh4XXR2x
         nej2EDtnOPF+PgzuUQDcubElcL0hju/0a/DnbIlOKDSLCcNLeDZNE0sGQbl/UPKutSQ8
         XmfBOVMMm8UMCm+fSXCB7H3rtGz7+H5h2kWv40rFNk0BQcEaJeC6vvScOpaWiJ8rLiwS
         5O0g==
X-Gm-Message-State: AOJu0Yzy9KpV/BvG1q/GE2EhJ5XN6RSnks6DmO8BNYz4zVjK8DGglaok
        eyn/jTpE7NNu0GVTVmi1dMcj0edEB6SOSC+9ID5rXTTpkn4iqdsMdiI=
X-Google-Smtp-Source: AGHT+IF3VFWmU2t6fGzRh4Vg2raGEn2I0dv7mwjtityQsXhfiZidYslEoRgJugqphqPksCLP/EWvAYBzQKe8PdqA+eI=
X-Received: by 2002:a05:620a:2483:b0:76f:24d2:e232 with SMTP id
 i3-20020a05620a248300b0076f24d2e232mr10582843qkn.47.1694475802678; Mon, 11
 Sep 2023 16:43:22 -0700 (PDT)
MIME-Version: 1.0
References: <20230911061147.409152-1-mizhang@google.com> <ZP8r2CDsv3JkGYzX@google.com>
 <CAL715WKyS4sTH3yEOX2OyV+fxMLMOAV6tX-A7fvEAKEUGj8uxw@mail.gmail.com> <ZP9X7YvstWhS/pWn@google.com>
In-Reply-To: <ZP9X7YvstWhS/pWn@google.com>
From:   Mingwei Zhang <mizhang@google.com>
Date:   Mon, 11 Sep 2023 16:42:46 -0700
Message-ID: <CAL715WJwb8RhqdvOaurUxY5=ftixw7LHZWBT9PrOGRAzF5veqA@mail.gmail.com>
Subject: Re: [PATCH] KVM: vPMU: Use atomic bit operations for global_status
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Dapeng Mi <dapeng1.mi@intel.com>,
        Jim Mattson <jmattson@google.com>, Like Xu <likexu@tencent.com>
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

On Mon, Sep 11, 2023 at 11:09=E2=80=AFAM Sean Christopherson <seanjc@google=
.com> wrote:
>
> On Mon, Sep 11, 2023, Mingwei Zhang wrote:
> > On Mon, Sep 11, 2023 at 8:01=E2=80=AFAM Sean Christopherson <seanjc@goo=
gle.com> wrote:
> > >
> > > On Mon, Sep 11, 2023, Mingwei Zhang wrote:
> > > > Use atomic bit operations for pmu->global_status because it may suf=
fer from
> > > > race conditions between emulated overflow in KVM vPMU and PEBS over=
flow in
> > > > host PMI handler.
> > >
> > > Only if the host PMI occurs on a different pCPU, and if that can happ=
en don't we
> > > have a much larger problem?
> >
> > Why on different pCPU?  For vPMU, I think there is always contention
> > between the vCPU thread and the host PMI handler running on the same
> > pCPU, no?
>
> A non-atomic instruction can't be interrupted by an NMI, or any other eve=
nt, so
> I don't see how switching to atomic operations fixes anything unless the =
NMI comes
> in on a different pCPU.

You are right. I realize that. The race condition has to happen
concurrently from two different pCPUs. This happens to
pmu->reprogram_nmi but not pmu->global_status. The critical stuff we
care about should be re-entrancy issues for __kvm_perf_overflow() and
some state maintenance issues like avoiding duplicate NMI injection.

That concludes that we don't need this change.

Thanks
-Mingwei
