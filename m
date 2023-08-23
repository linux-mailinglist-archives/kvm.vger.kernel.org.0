Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99B9878634A
	for <lists+kvm@lfdr.de>; Thu, 24 Aug 2023 00:21:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238590AbjHWWUh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Aug 2023 18:20:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238612AbjHWWUM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Aug 2023 18:20:12 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51D7AE76
        for <kvm@vger.kernel.org>; Wed, 23 Aug 2023 15:20:09 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-58419550c3aso83502857b3.0
        for <kvm@vger.kernel.org>; Wed, 23 Aug 2023 15:20:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692829208; x=1693434008;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pqMdodFSaIPazUq5gjHaUCHX1MNejLxMwWlhFBx2Z8w=;
        b=Jel5zrc1W5I2rUv8cHlOu9egMLSzCL154kGRJnOinrAfuzgrR7Rettas8RQLhEujtR
         9kQhkKOCDZ2O4xS7slgqZSF984Md5rC69hDrjEuDB/F17aUDJHmcxGnADzCzeKPXqAqY
         nbuEwbpBpCTXC+O8w0xMdFCcCbhAOtXCY/zebutUng8K9ZtAQZocxWfRXOeAL7f3HSoD
         eKrOFGBv4UghnVTJgdf4X88EPhF78QjrrMUmCAi/NtevFzM4ADTfUMsQxyFrY7LABmNM
         ztn7ZMoKyog+AEAOcYA5pGWyNktyf7aT1jndbeSoQYNisHEI971vv1ocnnZwwHT3JvGk
         ivvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692829208; x=1693434008;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=pqMdodFSaIPazUq5gjHaUCHX1MNejLxMwWlhFBx2Z8w=;
        b=Hw1qtK+e4KbaNhZZLj/MseXiq/PZtSv1665CuyyxnTEW68IjJ5kFo6l48xw90R/SQE
         aBqBg4uOVd6+15r+Zg2iakIAcaxuYEo0H3IMU64gJkrVj0AVLGj+803ax3IkjipyD9ET
         G9woi8aapeOw4Z2HEtHm1sc9k6qnSjKPTUj605iq/1lecgXteI70dFLEZl4VdowJwZDo
         jC0ySFN7+FSBWR2Ua0KTwE+mlF5jtJAczZiHjewIZldedinSp9b+SeeChIk08yMjq5Qh
         RHr3zjSknS2vVLf2K0LQKexf9deK6nROB/AdBfrV63grei+RmzbBj8fLK5exFdkuUsWT
         n53Q==
X-Gm-Message-State: AOJu0YySG84Lqznc9Sx6ili74+aWi+pvvTEylbzLre9/+BFeTo1ikmDm
        OawuxuabMQH9iMnqd/O84RXQ5jwpaiE=
X-Google-Smtp-Source: AGHT+IHb1Kwnzx98UJKQhCUXeG+zMY9sN+gJQOja69/O27Su+Q15xD2Zsqyl2Tl+OLLC0O7NYB5oInLu+l8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:588:0:b0:d73:bcb7:7282 with SMTP id
 130-20020a250588000000b00d73bcb77282mr185292ybf.8.1692829208599; Wed, 23 Aug
 2023 15:20:08 -0700 (PDT)
Date:   Wed, 23 Aug 2023 15:20:07 -0700
In-Reply-To: <CAF7b7mo3WDWQDoRX=bQUy-bnm7_3+UMaQX9DKeRxAZ+opQCZiw@mail.gmail.com>
Mime-Version: 1.0
References: <ZIn6VQSebTRN1jtX@google.com> <CAF7b7mqfkLYtWBJ=u0MK7hhARHrahQXHza9VnaughyNz5_tNug@mail.gmail.com>
 <ZNpsCngiSjISMG5j@google.com> <CAF7b7mo0gGGhv9dSFV70md1fNqMvPCfZ05VawPOB=xFkaax8AA@mail.gmail.com>
 <ZNrKNs8IjkUWOatn@google.com> <CAF7b7mp=bDBpaN+NHoSmL-+JUdShGfippRKdxr9LW0nNUhtpWA@mail.gmail.com>
 <ZNzyHqLKQu9bMT8M@google.com> <CAF7b7mpOAJ5MO0F4EPMvb9nsgmjBCASo-6=rMC3kUbFPAh4Vfg@mail.gmail.com>
 <ZN60KPh2uzSo8W4I@google.com> <CAF7b7mo3WDWQDoRX=bQUy-bnm7_3+UMaQX9DKeRxAZ+opQCZiw@mail.gmail.com>
Message-ID: <ZOaGF6pE5xk7C1It@google.com>
Subject: Re: [PATCH v4 03/16] KVM: Add KVM_CAP_MEMORY_FAULT_INFO
From:   Sean Christopherson <seanjc@google.com>
To:     Anish Moorthy <amoorthy@google.com>
Cc:     oliver.upton@linux.dev, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev, pbonzini@redhat.com, maz@kernel.org,
        robert.hoo.linux@gmail.com, jthoughton@google.com,
        bgardon@google.com, dmatlack@google.com, ricarkol@google.com,
        axelrasmussen@google.com, peterx@redhat.com, nadav.amit@gmail.com,
        isaku.yamahata@gmail.com
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

On Fri, Aug 18, 2023, Anish Moorthy wrote:
> On Thu, Aug 17, 2023 at 4:58=E2=80=AFPM Sean Christopherson <seanjc@googl=
e.com> wrote:
> >
> > On Wed, Aug 16, 2023, Anish Moorthy wrote:
> > > > but the names just need to be unique, e.g. the below compiles just =
fine.  So unless
> > > > someone has a better idea, using a separate union for exits that mi=
ght be clobbered
> > > > seems like the way to go.
> > >
> > > Agreed. By the way, what was the reason why you wanted to avoid the
> > > exit reason canary being ABI?
> >
> > Because it doesn't need to be exposed to usersepace, and it would be qu=
ite
> > unfortunate if we ever need/want to drop the canary, but can't because =
it's exposed
> > to userspace.
>=20
> > No need for a full 32-bit value, or even a separate field, we can use k=
vm_run.flags.
> > Ugh, but of course flags' usage is arch specific.  *sigh*
>=20
> Ah, I realise now you're thinking of separating the canary and
> whatever userspace reads to check for an annotated memory fault. I
> think that even if one variable in kvm_run did double-duty for now,
> we'd always be able to switch to using another as the canary without
> changing the ABI. But I'm on board with separating them anyways.
>=20
> > Regarding the canary, if we want to use it for WARN_ON_ONCE(), it can't=
 be
> > exposed to userspace.  Either that or we need to guard the WARN in some=
 way.
>=20
> It's guarded behind a kconfig atm, although if we decide to drop the
> userspace-visible canary then I'll drop that bit.

Yeah, burning a kconfig for this probably overkill.

> > > On Wed, Jun 14, 2023 at 10:35=E2=80=AFAM Sean Christopherson <seanjc@=
google.com> wrote:
> > > > +       __u32 speculative_exit_reason;
> > ...
> > We can either defines a flags2 (blech), or grab the upper byte of flags=
 for
> > arch agnostic flags (slightly less blech).
>=20
> Grabbing the upper byte seems reasonable: but do you anticipate KVM
> ever supporting more than eight of these speculative exits? Because if
> so then it seems like it'd be less trouble to use a separate u32 or
> u16 (or even u8, judging by the number of KVM exits). Not sure how
> much future-proofing is appropriate here :)

I don't anticipate anything beyond the memory fault case.  We essentially a=
lready
treat incomplete exits to userspace as KVM bugs.   MMIO is the only other c=
ase I
can think of where KVM doesn't complete an exit to usersapce, but that one =
is
essentially getting grandfathered in because of x86's flawed MMIO handling.
Userspace memory faults also get grandfathered in because of paravirt ABIs,=
 i.e.
KVM is effectively required to ignore some faults due to external forces.

In other words, the bar for adding "speculative" exit to userspace is very =
high.

> > > > +       union {
> > > > +               /* KVM_SPEC_EXIT_MEMORY_FAULT */
> >
> > Definitely just KVM_EXIT_MEMORY_FAULT, the vast, vast majority of exits=
 to
> > userspace will not be speculative in any way.
>=20
> Speaking of future-proofing, this was me trying to anticipate future
> uses of the speculative exit struct: I figured that some case might
> come along where KVM_RUN returns 0 *and* the contents of the speculative
> exit struct might be useful- it'd be weird to look for KVM_EXIT_*s in
> two different fields.

That can be handled with a comment about the new flag, e.g.

/*
 * Set if KVM filled the memory_fault field since the start of KVM_RUN.  No=
te,
 * memory_fault is guaranteed to be fresh if and only KVM_RUN returns -EFAU=
LT.
 * For all other return values, memory_fault may be stale and should be
 * considered informational only, e.g. can captured to aid debug, but shoul=
dn't
 * be relied on for correctness.
 */
#define 	KVM_RUN_MEMORY_FAULT_FILLED
