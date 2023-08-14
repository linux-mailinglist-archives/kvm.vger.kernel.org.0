Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6574977BF75
	for <lists+kvm@lfdr.de>; Mon, 14 Aug 2023 20:02:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230468AbjHNSCT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Aug 2023 14:02:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229889AbjHNSBt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Aug 2023 14:01:49 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80DAEB5
        for <kvm@vger.kernel.org>; Mon, 14 Aug 2023 11:01:48 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-589a45c1b0fso64647207b3.1
        for <kvm@vger.kernel.org>; Mon, 14 Aug 2023 11:01:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692036107; x=1692640907;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Ks8fjorpwlw47D5SVnaZT4qZ6mVfWeJEmAjC93p1Ixs=;
        b=FvKGf9czOUB6BDQKW/gCE9YyqJ/eq85/hIbwQJIBXMtxaLBEbI7BSjqCJ+PKyE7FtK
         2csOj3+GnZ2QC17VrpcTOVCPQA94q9TLo6nIXmLPwof1DF66dVSD+FFkA61ToPT64eQ4
         +8hhz7JuXUwGNl8INCK5ZzX24dupZ17rzqfTZAhb7bJB+Un4A0aBqHHz3rfxB0FNe000
         mjWEgot8mBdfhNBGILR73jVmTmFBGqNJxx4D8t6K6WrraLFsS3fg3gRoKtGVIC7qUI6+
         tO/30bVR7bCIn2xjkN0IN44XWDVHcnxqvCPQFQ/pqBHNTYQZILHaiHONOl1Cb2/OFg3E
         Og5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692036107; x=1692640907;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Ks8fjorpwlw47D5SVnaZT4qZ6mVfWeJEmAjC93p1Ixs=;
        b=PnB241bJFbDUkAgup7nmEOB0pl6Pnymaag3qeyKMhZyhd8LHuEV5/ZCcLsWTSpU3KD
         o0TYTLW2pbYoL6M9DgGQC6nE0A4kopdRqcFB5MpyYHIri31Mr7R+kx6L4BfHKMn3x4Cc
         v1HdqS9/pK4VH/56exI2LxiKfsBhFtsAs+DGNoRAXMwGT/aqrNhIqUD3VwMBZdMQe3Lb
         JyRuoROf84n1RRXVvSMhvMh2SkBjCZrlByWwqbdaBX5kNxIc4b7kT0Dfu7u+ujTjHSZj
         B41+X21u7V9O2vjZECj07Nth0HOEivdkHGquJOqhDCYQqgVgN83v4wjgUnAdrHwl3xyY
         h+OA==
X-Gm-Message-State: AOJu0YzrJmL4J6nYHfytGkD57LCsJrVyW4qUUathhnuWivf7faRwnltH
        FpQ4l51jDbUns/3SwmamflzK0H8UEPQ=
X-Google-Smtp-Source: AGHT+IFbnsThc/L0Z6nrWqe7jCeBxTizKrdW2LLJWBH+gkQA+8C2e25gV+CD6CEGu04bQpwDWK+m2BEqqI8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:d803:0:b0:d07:9d79:881c with SMTP id
 p3-20020a25d803000000b00d079d79881cmr132435ybg.11.1692036107781; Mon, 14 Aug
 2023 11:01:47 -0700 (PDT)
Date:   Mon, 14 Aug 2023 11:01:46 -0700
In-Reply-To: <CAF7b7mqfkLYtWBJ=u0MK7hhARHrahQXHza9VnaughyNz5_tNug@mail.gmail.com>
Mime-Version: 1.0
References: <20230602161921.208564-1-amoorthy@google.com> <20230602161921.208564-4-amoorthy@google.com>
 <ZIn6VQSebTRN1jtX@google.com> <CAF7b7mqfkLYtWBJ=u0MK7hhARHrahQXHza9VnaughyNz5_tNug@mail.gmail.com>
Message-ID: <ZNpsCngiSjISMG5j@google.com>
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

On Fri, Aug 11, 2023, Anish Moorthy wrote:
> On Wed, Jun 14, 2023 at 10:35=E2=80=AFAM Sean Christopherson <seanjc@goog=
le.com> wrote:
> >
> > > diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> > > +inline void kvm_populate_efault_info(struct kvm_vcpu *vcpu,
> >
> > Tagging a globally visible, non-static function as "inline" is odd, to =
say the
> > least.
>=20
> I think my eyes glaze over whenever I read the words "translation
> unit" (my brain certainly does) so I'll have to take your word for it.
> IIRC last time I tried to mark this function "static" the compiler
> yelled at me, so removing the "inline" it is.

What is/was the error?  It's probably worth digging into; "static inline" s=
hould
work just fine, so there might be something funky elsewhere that you're pap=
ering
over.

> > I got a bit (ok, way more than a bit) lost in all of the (A) (B) (C) ma=
dness.  I
> > think this what you intended for each case?
> >
> >   (A) if there are any existing paths in KVM_RUN which cause a vCPU
> >       to (1) populate the kvm_run struct then (2) fail a vCPU guest mem=
ory
> >       access but ignore the failure and then (3) complete the exit to
> >       userspace set up in (1), then the contents of the kvm_run struct =
written
> >       in (1) will be corrupted.
> >
> >   (B) if KVM_RUN fails a guest memory access for which the EFAULT is an=
notated
> >       but does not return the EFAULT to userspace, then later returns a=
n *un*annotated
> >       EFAULT to userspace, then userspace will receive incorrect inform=
ation.
> >
> >   (C) an annotated EFAULT which is ignored/suppressed followed by one w=
hich is
> >       propagated to userspace. Here the exit-reason-unset check will pr=
event the
> >       second annotation from being written, so userspace sees an annota=
tion with
> >       bad contents, If we believe that case (A) is a weird sequence of =
events
> >       that shouldn't be happening in the first place, then case (C) see=
ms more
> >       important to ensure correctness in. But I don't know anything abo=
ut how often
> >       (A) happens in KVM, which is why I want others' opinions.
>=20
> Yeah, I got lost in the weeds: you've gotten the important points though
>=20
> > (A) does sadly happen.  I wouldn't call it a "pattern" though, it's an =
unfortunate
> > side effect of deficiencies in KVM's uAPI.
> >
> > (B) is the trickiest to defend against in the kernel, but as I mentione=
d in earlier
> > versions of this series, userspace needs to guard against a vCPU gettin=
g stuck in
> > an infinite fault anyways, so I'm not _that_ concerned with figuring ou=
t a way to
> > address this in the kernel.  KVM's documentation should strongly encour=
age userspace
> > to take action if KVM repeatedly exits with the same info over and over=
, but beyond
> > that I think anything else is nice to have, not mandatory.
> >
> > (C) should simply not be possible.  (A) is very much a "this shouldn't =
happen,
> > but it does" case.  KVM provides no meaningful guarantees if (A) does h=
appen, so
> > yes, prioritizing correctness for (C) is far more important.
> >
> > That said, prioritizing (C) doesn't mean we can't also do our best to p=
lay nice
> > with (A).  None of the existing exits use anywhere near the exit info u=
nion's 256
> > bytes, i.e. there is tons of space to play with.  So rather than put me=
mory_fault
> > in with all the others, what if we split the union in two, and place me=
mory_fault
> > in the high half (doesn't have to literally be half, but you get the id=
ea).  It'd
> > kinda be similar to x86's contributory vs. benign faults; exits that ca=
n't be
> > "nested" or "speculative" go in the low half, and things like memory_fa=
ult go in
> > the high half.
> >
> > That way, if (A) does occur, the original information will be preserved=
 when KVM
> > fills memory_fault.  And my suggestion to WARN-and-continue limits the =
problematic
> > scenarios to just fields in the second union, i.e. just memory_fault fo=
r now.
> > At the very least, not clobbering would likely make it easier for us to=
 debug when
> > things go sideways.
> >
> > And rather than use kvm_run.exit_reason as the canary, we should carve =
out a
> > kernel-only, i.e. non-ABI, field from the union.  That would allow sett=
ing the
> > canary in common KVM code, which can't be done for kvm_run.exit_reason =
because
> > some architectures, e.g. s390 (and x86 IIRC), consume the exit_reason e=
arly on
> > in KVM_RUN.
>=20
> I think this is a good idea :D I was going to suggest something
> similar a while back, but I thought it would be off the table- whoops.
>=20
> My one concern is that if/when other features eventually also use the
> "speculative" portion, then they're going to run into the same issues
> as we're trying to avoid here.

I think it's worth the risk.  We could mitigate potential future problems t=
o some
degree by maintaining the last N "speculative" user exits since KVM_RUN, e.=
g. with
a ring buffer, but (a) that's more than a bit crazy and (b) I don't think t=
he
extra data would be actionable for userspace unless userspace somehow had a=
 priori
knowledge of the "failing" sequence.

> But fixing *that* (probably by propagating these exits through return
> values/the call stack) would be a really big refactor, and C doesn't real=
ly
> have the type system for it in the first place :(

Yeah, lack of a clean and easy way to return a tuple makes it all but impos=
sible
to handle this without resorting to evil shenanigans.
