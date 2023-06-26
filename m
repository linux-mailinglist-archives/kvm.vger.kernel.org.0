Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6FE473EBFD
	for <lists+kvm@lfdr.de>; Mon, 26 Jun 2023 22:44:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230231AbjFZUnV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Jun 2023 16:43:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230070AbjFZUnU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Jun 2023 16:43:20 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45C4E1BC0
        for <kvm@vger.kernel.org>; Mon, 26 Jun 2023 13:42:42 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id 98e67ed59e1d1-262d8993033so802823a91.0
        for <kvm@vger.kernel.org>; Mon, 26 Jun 2023 13:42:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1687812154; x=1690404154;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=roNwuphAhOKRAuXeRi7d1wmxywx48d/MTesOiCetVbg=;
        b=003hPm8k6NkDyLnmn8q7pqzAPTuLiKwFD/H+x8IJOvsA5No1rQQZVs76OoCgWM/lGV
         e40lpmvDP9S8v47UiCO+j01tJUQkYF7qIQpJoVvfHsTPiiR2i5d+EZcXZtJPGjs+38na
         OnibD67CD8VswKAE8fu6Vdb9w+eu7plm1dW0UKCgEJxKj80sndBMZHaPimQs/4AosyJ7
         cwggDPnwnQR8So6SZh/LJIFgCuGaZFp5JnRKcDFbtx4biUxBjB9x9owq4GqhjKfM9Ljx
         dsqdV9Ea+S2vfwzd3/WUb/+VeS/6XpDrYWvKsD1jDgXK1qFyL/lvHMhEgQZYqcY+nI5A
         UuRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687812154; x=1690404154;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=roNwuphAhOKRAuXeRi7d1wmxywx48d/MTesOiCetVbg=;
        b=Jnyys9u8YmJIy7lDZSaG7FGLq0ccqdbnhTZYqymJw4geEUnHQwa+NgUfpLob2iZT95
         6d6ZqLOz2w8tGo3khWZRzGI5KiagbKkGIo/rc5ar0o2KgSyDezFqNJdZVpfbgKeAPIKr
         770AdxK32BXTSfzip3DPH3TXT3HlJsT4hNBCItbcKKkhfHLxLBY3i7fzpWa6sbxV/Pq3
         WLxHy8GIyxqAwBQYo6iqH6vLnYDL9SkV8dAnPJcDU6+jNGgSpi4sT/d4ozvisyYGuDrV
         nvSVM020dclC5Tt7jqhphnvYQCo5/zpV2HOE0LVnic2qGD+4k0zmZAqAO0xqudGHTXQ0
         WJbQ==
X-Gm-Message-State: AC+VfDxkNW97wiNoe74UJOW6MixUJ+DOci93o76eAVJqzdvg88zKvoA0
        uGXRaJ4Dq7z3vAZUGOs6P1Qqp9Y5iBw=
X-Google-Smtp-Source: ACHHUZ5VFQ8ouxtbrP37Y8tQO/Qx83nWyjN/Y6ZCv2huHQVZaO2HLCH9aT4mxg5cjHlnkWSZQ5HKldWJm+g=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90b:400e:b0:262:ffa8:f49d with SMTP id
 ie14-20020a17090b400e00b00262ffa8f49dmr394485pjb.9.1687812154391; Mon, 26 Jun
 2023 13:42:34 -0700 (PDT)
Date:   Mon, 26 Jun 2023 13:42:32 -0700
In-Reply-To: <CALMp9eRvUky-jcrkJ75N5-kvWWxVMNaf95XpyGTa_k49n48g9A@mail.gmail.com>
Mime-Version: 1.0
References: <20230605004334.1930091-1-mizhang@google.com> <CALMp9eSQgcKd=SN4q2QRYbveKoayKzuYEQPM0Xu+FgQ_Mja8-g@mail.gmail.com>
 <CAL715WJowYL=W40SWmtPoz1F9WVBFDG7TQwbsV2Bwf9-cS77=Q@mail.gmail.com>
 <ZH4ofuj0qvKNO9Bz@google.com> <CAL715WKtsC=93Nqr7QJZxspWzF04_CLqN3FUxUaqTHWFRUrwBA@mail.gmail.com>
 <ZH+8GafaNLYPvTJI@google.com> <CAL715WJ1rHS9ORR2ttyAw+idqbaLnOhLveUhW8f4tB9o+ZsuiQ@mail.gmail.com>
 <ZH/PKMmWWgJQdcJQ@google.com> <CAL715W+KSgNMk+kTt3=B-CgxTkToH6xmvHWvVmm3V+hir-jE=g@mail.gmail.com>
 <CALMp9eRvUky-jcrkJ75N5-kvWWxVMNaf95XpyGTa_k49n48g9A@mail.gmail.com>
Message-ID: <ZJn4OFrQfTYpoIYE@google.com>
Subject: Re: [PATCH] KVM: x86/mmu: Remove KVM MMU write lock when accessing indirect_shadow_pages
From:   Sean Christopherson <seanjc@google.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     Mingwei Zhang <mizhang@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 26, 2023, Jim Mattson wrote:
> On Thu, Jun 15, 2023 at 4:58=E2=80=AFPM Mingwei Zhang <mizhang@google.com=
> wrote:
> >
> > On Tue, Jun 6, 2023 at 5:28=E2=80=AFPM Sean Christopherson <seanjc@goog=
le.com> wrote:
> > >
> > > On Tue, Jun 06, 2023, Mingwei Zhang wrote:
> > > > > > Hmm. I agree with both points above, but below, the change seem=
s too
> > > > > > heavyweight. smp_wb() is a mfence(), i.e., serializing all
> > > > > > loads/stores before the instruction. Doing that for every shado=
w page
> > > > > > creation and destruction seems a lot.
> > > > >
> > > > > No, the smp_*b() variants are just compiler barriers on x86.
> > > >
> > > > hmm, it is a "lock addl" now for smp_mb(). Check this: 450cbdd0125c
> > > > ("locking/x86: Use LOCK ADD for smp_mb() instead of MFENCE")
> > > >
> > > > So this means smp_mb() is not a free lunch and we need to be a litt=
le
> > > > bit careful.
> > >
> > > Oh, those sneaky macros.  x86 #defines __smp_mb(), not the outer help=
er.  I'll
> > > take a closer look before posting to see if there's a way to avoid th=
e runtime
> > > barrier.
> >
> > Checked again, I think using smp_wmb() and smp_rmb() should be fine as
> > those are just compiler barriers. We don't need a full barrier here.
>=20
> That seems adequate.

Strictly speaking, no, because neither FNAME(fetch) nor kvm_mmu_pte_write()=
 are
pure readers or writers.  FNAME(fetch) reads guest memory (guest PTEs) and =
writes
indirect_shadow_pages.   kvm_mmu_pte_write() writes guest memory (guest PTE=
s) and
reads indirect_shadow_pages (it later writes indirect_shadow_pages too, but=
 that
write isn't relevant to the ordering we care about here).
