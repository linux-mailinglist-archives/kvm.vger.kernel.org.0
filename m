Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A7917ABAA3
	for <lists+kvm@lfdr.de>; Fri, 22 Sep 2023 22:49:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229687AbjIVUtr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Sep 2023 16:49:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229693AbjIVUtq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Sep 2023 16:49:46 -0400
Received: from mail-qv1-xf2a.google.com (mail-qv1-xf2a.google.com [IPv6:2607:f8b0:4864:20::f2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DED3ACA
        for <kvm@vger.kernel.org>; Fri, 22 Sep 2023 13:49:39 -0700 (PDT)
Received: by mail-qv1-xf2a.google.com with SMTP id 6a1803df08f44-65643a83758so14390396d6.0
        for <kvm@vger.kernel.org>; Fri, 22 Sep 2023 13:49:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1695415779; x=1696020579; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CGbfWRo0+UyXLnbYvlBLAFnU8cAtRtOyYuxm6aQG+5s=;
        b=R+S78Y0WtNSqpDDyhtlsU1ZpzCkT55P3ZwQLk8qeAbHb3ZlTapWf4kWJSAmEAGUjtA
         1nNV0GEUE1Nv1OY0Brum9svC8wteRp+JbKOExdvxFICciP7JcMAOIAiyyMySWjXz1lBX
         dCkNSBKkaqnmzDdRkTnOD9FUy4e7dKzRf2BIvz5Atw7bPPEksp2F6BcyDeplLqaRlaT+
         d6iQyj5L3hi8HZJpyh9Kz3yPXjJzwtdKgaOaPWCE6Me/b5hujsPEslmQQ3h8zX+6nn8S
         XOk0Lvq+qPZ5QR/I9jYIbXP9Rrv2yvYk8g8C91IyLHwpMes9BVg8tLTCurZf3nSx7fa/
         o5wA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695415779; x=1696020579;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CGbfWRo0+UyXLnbYvlBLAFnU8cAtRtOyYuxm6aQG+5s=;
        b=mi77U4DmyYXB8ReE4+/ZpH4KpttlTWvulWRWaNhQU+GpgeqHQNutqm71KWePSp7pVR
         nEtJRXj2YQIveNU2jzR7YnC6J+XO4vol1AxDjvJh3u2snpR/HaaaqsF+/SCwMkxP6Nvr
         jc1rhatvFl0rxfkYj+BDTU1tsAnf4kBuZl7C2S9v6J7DU1naONseR6pwHywNDZYI5UUV
         Hk4IDfQQX07gPyzZ+9XatHwSifwDTrsuavjPQ8OQpay4meivG1AlsIGJFQTIjQp7Tdq+
         T9AKxbV2KHWLKFWs5LG5tjWgHaAMkEYHFGRWz6gOft12/OH0dSa+jIvd9P7of3x4CTyQ
         SsaA==
X-Gm-Message-State: AOJu0YwW5q8RC7sOgM5FRqFePt1S/KSw3S5Ec0jCo8t5D0xXDSa6g4HC
        pg2UtmJmJdPJWqvVdNUb2lvB2prnfV4++9WGr6J3cw==
X-Google-Smtp-Source: AGHT+IFIKAWuRhxP/RKj+Zy5+I6G/opfckXywAUSCGTVBb9RmF/EIuYUjI6ZEDFtG2aBS8VE6tow5CEk/TOroRCoM84=
X-Received: by 2002:a0c:e50b:0:b0:647:2628:5ba4 with SMTP id
 l11-20020a0ce50b000000b0064726285ba4mr377598qvm.34.1695415778730; Fri, 22 Sep
 2023 13:49:38 -0700 (PDT)
MIME-Version: 1.0
References: <20230901185646.2823254-1-jmattson@google.com> <ZQ3hD+zBCkZxZclS@google.com>
 <CALMp9eRQKUy7+AXWepsuJ=KguVMTTcgimeEjd3zMnEP-3LEDKg@mail.gmail.com>
 <ZQ3pQfu6Zw3MMvKx@google.com> <CAL715WKguAT_K_eUTxk8XEQ5rQ=e5WhEFdwOx8VpkpTHJWgRFw@mail.gmail.com>
 <ZQ36bxFOZM0s5+uk@google.com>
In-Reply-To: <ZQ36bxFOZM0s5+uk@google.com>
From:   Mingwei Zhang <mizhang@google.com>
Date:   Fri, 22 Sep 2023 13:49:02 -0700
Message-ID: <CAL715WL8KN1fceDhKxCfeGjbctx=vz2pAbw607pFYP6bw9N0_w@mail.gmail.com>
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

On Fri, Sep 22, 2023 at 1:34=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
>
> On Fri, Sep 22, 2023, Mingwei Zhang wrote:
> > On Fri, Sep 22, 2023 at 12:21=E2=80=AFPM Sean Christopherson <seanjc@go=
ogle.com> wrote:
> > >
> > > On Fri, Sep 22, 2023, Jim Mattson wrote:
> > > > On Fri, Sep 22, 2023 at 11:46=E2=80=AFAM Sean Christopherson <seanj=
c@google.com> wrote:
> > > > >
> > > > > On Fri, Sep 01, 2023, Jim Mattson wrote:
> > > > > > When the irq_work callback, kvm_pmi_trigger_fn(), is invoked du=
ring a
> > > > > > VM-exit that also invokes __kvm_perf_overflow() as a result of
> > > > > > instruction emulation, kvm_pmu_deliver_pmi() will be called twi=
ce
> > > > > > before the next VM-entry.
> > > > > >
> > > > > > That shouldn't be a problem. The local APIC is supposed to
> > > > > > automatically set the mask flag in LVTPC when it handles a PMI,=
 so the
> > > > > > second PMI should be inhibited. However, KVM's local APIC emula=
tion
> > > > > > fails to set the mask flag in LVTPC when it handles a PMI, so t=
wo PMIs
> > > > > > are delivered via the local APIC. In the common case, where LVT=
PC is
> > > > > > configured to deliver an NMI, the first NMI is vectored through=
 the
> > > > > > guest IDT, and the second one is held pending. When the NMI han=
dler
> > > > > > returns, the second NMI is vectored through the IDT. For Linux =
guests,
> > > > > > this results in the "dazed and confused" spurious NMI message.
> > > > > >
> > > > > > Though the obvious fix is to set the mask flag in LVTPC when ha=
ndling
> > > > > > a PMI, KVM's logic around synthesizing a PMI is unnecessarily
> > > > > > convoluted.
> > > > >
> > > > > To address Like's question about whether not this is necessary, I=
 think we should
> > > > > rephrase this to explicitly state this is a bug irrespective of t=
he whole LVTPC
> > > > > masking thing.
> > > > >
> > > > > And I think it makes sense to swap the order of the two patches. =
 The LVTPC masking
> > > > > fix is a clearcut architectural violation.  This is a bit more of=
 a grey area,
> > > > > though still blatantly buggy.
> > > >
> > > > The reason I ordered the patches as I did is that when this patch
> > > > comes first, it actually fixes the problem that was introduced in
> > > > commit 9cd803d496e7 ("KVM: x86: Update vPMCs when retiring
> > > > instructions"). If this patch comes second, it's less clear that it
> > > > fixes a bug, since the other patch renders this one essentially moo=
t.
> > >
> > > Yeah, but as Like pointed out, the way the changelog is worded just r=
aises the
> > > question of why this change is necessary.
> > >
> > > I think we should tag them both for stable.  They're both bug fixes, =
regardless
> > > of the ordering.
> >
> > Agree. Both patches are fixing the general potential buggy situation
> > of multiple PMI injection on one vm entry: one software level defense
> > (forcing the usage of KVM_REQ_PMI) and one hardware level defense
> > (preventing PMI injection using mask).
> >
> > Although neither patch in this series is fixing the root cause of this
> > specific double PMI injection bug, I don't see a reason why we cannot
> > add a "fixes" tag to them, since we may fix it and create it again.
> >
> > I am currently working on it and testing my patch. Please give me some
> > time, I think I could try sending out one version today. Once that is
> > done, I will combine mine with the existing patch and send it out as a
> > series.
>
> Me confused, what patch?  And what does this patch have to do with Jim's =
series?
> Unless I've missed something, Jim's patches are good to go with my nits a=
ddressed.

Let me step back.

We have the following problem when we run perf inside guest:

[ 1437.487320] Uhhuh. NMI received for unknown reason 20 on CPU 3.
[ 1437.487330] Dazed and confused, but trying to continue

This means there are more NMIs that guest PMI could understand. So
there are potentially two approaches to solve the problem: 1) fix the
PMI injection issue: only one can be injected; 2) fix the code that
causes the (incorrect) multiple PMI injection.

I am working on the 2nd one. So, the property of the 2nd one is:
without patches in 1) (Jim's patches), we could still avoid the above
warning messages.

Thanks.
-Mingwei
