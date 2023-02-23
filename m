Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87DE56A113A
	for <lists+kvm@lfdr.de>; Thu, 23 Feb 2023 21:29:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229733AbjBWU3D (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Feb 2023 15:29:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229454AbjBWU3B (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Feb 2023 15:29:01 -0500
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE2F413D6F
        for <kvm@vger.kernel.org>; Thu, 23 Feb 2023 12:29:00 -0800 (PST)
Received: by mail-pf1-x449.google.com with SMTP id i11-20020a056a00224b00b005d44149eb06so3328842pfu.10
        for <kvm@vger.kernel.org>; Thu, 23 Feb 2023 12:29:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=iMpgRmyVDog12gGF5u00S3GFVvfa3RjsGhYYuIghQuw=;
        b=Oj0JNHRfBF0003MFOrybvJRxKWvg4a//DfyLNclUK+7N5/s7VjeN2Ybz0ne96gQ+y/
         Kce+Q0ZXdzbS+HItx2LVYs6XbJeGYav5T0kxtg6oSGyyAnYLkgfUmKMvnWrz/RJr2iGt
         BiNuY4XQIP71ObixRoPGWBrf5q6zjI9OvmSI5XqGwGSoaN4Qo8PjJcVdjNQWqFmCbaNT
         fDylmTkY2OnILfYvuCp/0wvlS/vK3WqeY+Vs8jpgS0bDY+Fzi+bVe+j3RecifYahcIhh
         j4oJs7UNz2z7WtDg2Ub7n9qah3g+mR+nVEw9Z6a8GUszbe4QIdPOG3iK1M22brh9bkyW
         z3qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=iMpgRmyVDog12gGF5u00S3GFVvfa3RjsGhYYuIghQuw=;
        b=UkXOYNNmU2hQTqNnQkfnb9yz031A/qfcJZ5p8vqqb8kapFjYXp+5Rpqh8kZiQbD6Fa
         kH7SHVnjQl2EiaFgHqDpUVlO26WKFxRw1f9kUbI67/jrQZApgtMfeivNTX1sE3D66YP6
         YPK2I1zemtwHuTWb/gbxm+p9mzpWCvtxYl+7s+YbdyLBFv4eviqPsoNobhiJjH9UsdW2
         V2o1lpsZE0BRpAhQ0lFjHrqhCftjRh9hflEkD6f6rdWOHJxPRvB3fYATJFP2s4cY/FOp
         sYDlt1C3gyLQ5OcGDsWMHYgwlndN2lnUZMsZtHwruNoFGXTC60zbSd1pJMlLXHhkLWfH
         JGqQ==
X-Gm-Message-State: AO0yUKVS8cvITqwZvPHKA1cAqkj+0/sRcDngL3UuiCITuLKYbgxt9j3d
        8tsymxUNAOOwIthXeF6YqKQXP2X+im8=
X-Google-Smtp-Source: AK7set/XyWT2OAnpm11r3FBKVIDwL0kXrUZRkKccpnOexZiyXc1HvjHh6IvJEeYAirA5lDcDXm4Ck4IuD34=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:1955:b0:593:f5e4:8d87 with SMTP id
 s21-20020a056a00195500b00593f5e48d87mr2471665pfk.6.1677184140109; Thu, 23 Feb
 2023 12:29:00 -0800 (PST)
Date:   Thu, 23 Feb 2023 12:28:58 -0800
In-Reply-To: <CAOUHufYWktz4SNjL_o_2oZNcJLXserwCot-Prv4UEG9uzn57rg@mail.gmail.com>
Mime-Version: 1.0
References: <20230217041230.2417228-1-yuzhao@google.com> <20230217041230.2417228-6-yuzhao@google.com>
 <Y/elw7CTvVWt0Js6@google.com> <CAOUHufbAKpv95k6rVedstjD_7JzP0RrbOD652gyZh2vbAjGPOg@mail.gmail.com>
 <Y/e6Z+KIl6sYJoRg@google.com> <CAOUHufbwcqx21T=zmvYpnX_Mnd2A0KkPORbtxnJEwKuUKVSPzA@mail.gmail.com>
 <Y/fFWyYPu5Jf0de1@google.com> <CAOUHufYWktz4SNjL_o_2oZNcJLXserwCot-Prv4UEG9uzn57rg@mail.gmail.com>
Message-ID: <Y/fMimvChfhhbCid@google.com>
Subject: Re: [PATCH mm-unstable v1 5/5] mm: multi-gen LRU: use mmu_notifier_test_clear_young()
From:   Sean Christopherson <seanjc@google.com>
To:     Yu Zhao <yuzhao@google.com>
Cc:     Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Michael Larabel <michael@michaellarabel.com>,
        kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linuxppc-dev@lists.ozlabs.org, x86@kernel.org,
        linux-mm@google.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Feb 23, 2023, Yu Zhao wrote:
> On Thu, Feb 23, 2023 at 12:58=E2=80=AFPM Sean Christopherson <seanjc@goog=
le.com> wrote:
> >
> > On Thu, Feb 23, 2023, Yu Zhao wrote:
> > > On Thu, Feb 23, 2023 at 12:11=E2=80=AFPM Sean Christopherson <seanjc@=
google.com> wrote:
> > > >
> > > > On Thu, Feb 23, 2023, Yu Zhao wrote:
> > > > > > As alluded to in patch 1, unless batching the walks even if KVM=
 does _not_ support
> > > > > > a lockless walk is somehow _worse_ than using the existing mmu_=
notifier_clear_flush_young(),
> > > > > > I think batching the calls should be conditional only on LRU_GE=
N_SPTE_WALK.  Or
> > > > > > if we want to avoid batching when there are no mmu_notifier lis=
teners, probe
> > > > > > mmu_notifiers.  But don't call into KVM directly.
> > > > >
> > > > > I'm not sure I fully understand. Let's present the problem on the=
 MM
> > > > > side: assuming KVM supports lockless walks, batching can still be
> > > > > worse (very unlikely), because GFNs can exhibit no memory localit=
y at
> > > > > all. So this option allows userspace to disable batching.
> > > >
> > > > I'm asking the opposite.  Is there a scenario where batching+lock i=
s worse than
> > > > !batching+lock?  If not, then don't make batching depend on lockles=
s walks.
> > >
> > > Yes, absolutely. batching+lock means we take/release mmu_lock for
> > > every single PTE in the entire VA space -- each small batch contains
> > > 64 PTEs but the entire batch is the whole KVM.
> >
> > Who is "we"?
>=20
> Oops -- shouldn't have used "we".
>=20
> > I don't see anything in the kernel that triggers walking the whole
> > VMA, e.g. lru_gen_look_around() limits the walk to a single PMD.  I fee=
l like I'm
> > missing something...
>=20
> walk_mm() -> walk_pud_range() -> walk_pmd_range() -> walk_pte_range()
> -> test_spte_young() -> mmu_notifier_test_clear_young().
>=20
> MGLRU takes two passes: during the first pass, it sweeps entire VA
> space on each MM (per MM/KVM); during the second pass, it uses the rmap o=
n each
> folio (per folio).

Ah.  IIUC, userspace can use LRU_GEN_SPTE_WALK to control whether or not to=
 walk
secondary MMUs, and the kernel further restricts LRU_GEN_SPTE_WALK to secon=
dary
MMUs that implement a lockless walk.  And if the answer is "no", secondary =
MMUs
are simply not consulted.

If that's correct, then the proper way to handle this is by extending mmu_n=
otifier_ops
to query (a) if there's at least one register listeners that implements
test_clear_young() and (b) if all registered listeners that implement test_=
clear_young()
support lockless walks.  That avoids direct dependencies on KVM, and avoids=
 making
assumptions that may not always hold true, e.g. that KVM is the only mmu_no=
tifier
user that supports the young APIs.

P.S. all of this info absolutely belongs in documentation and/or changelogs=
.
