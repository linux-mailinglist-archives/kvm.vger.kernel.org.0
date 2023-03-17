Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F50B6BF1F6
	for <lists+kvm@lfdr.de>; Fri, 17 Mar 2023 20:54:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229601AbjCQTyD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Mar 2023 15:54:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229516AbjCQTyC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Mar 2023 15:54:02 -0400
Received: from mail-ua1-x92f.google.com (mail-ua1-x92f.google.com [IPv6:2607:f8b0:4864:20::92f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A63E13FB84
        for <kvm@vger.kernel.org>; Fri, 17 Mar 2023 12:53:41 -0700 (PDT)
Received: by mail-ua1-x92f.google.com with SMTP id g23so4090967uak.7
        for <kvm@vger.kernel.org>; Fri, 17 Mar 2023 12:53:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679082820;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=c75j1XnsYdf+cmNatU3jyf9cEv226es2tGse5jsbB64=;
        b=SdREXCBVG6hQgEu1Ge/cv/gqnJSELpuGQ0zuIP6tMFbnbDgg7AzlIhLCpXYjratNW7
         YNzxgg49MN325317BD4vbp0etqYpyTbIGijJeWuXkH33FaybMy71jTivfamZ6g05Xsy6
         lTUtL+wuvqjJIjHDimyigck0He9l+ZN4UuXQdk/1KSclol8N0dXgEA9CLIws5QSN410k
         3162JIkMqDGS3w0l3aQPqxYDidcepsEcIvWRie2cuLS+ShscWUoysa37+IG/6p7GjNrG
         AgPrtu1rEMbrpksk9YDyo/44F3S8/1V1iXlBbYs1KR9bKTW0W17+ZeIFmf63hK5h3+1o
         vwHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679082820;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=c75j1XnsYdf+cmNatU3jyf9cEv226es2tGse5jsbB64=;
        b=K4F0J3obPaPSb8gmFhJkbtKy+VohDqjcW3DgWg0Typ4lZuzZlmKZBTmgq3B9c7RUli
         IRoomxiJF7fo/FK49SxRrKi7CZkElDVCkKF4Tij8jYBd3+gxgCcGR6B2+D4XtWvvaFan
         xc5ZZUvkUEwWV2mRhiVWVRDUp4P9Va9MRCo8jXGxOnJb0z7LikvZrFvgvqh2X7nw9zDu
         xu65ewWa1PvlP1M+3vOhLXLB4IrZOxWXXrDbwbL0LfsR3kK6yNUL8cy+RKdSy8maJRt1
         nZ9NSLDIE1LbNS5qdIt3Cci8cI8wO6wq3yHfREm96IOOibyu4fTipe73xX/JnzTig/aJ
         gKlA==
X-Gm-Message-State: AO0yUKVgm97xarXBu2++ifVqC/1Ot+qYC8IQpBSuXPhby7NXupR5S9pv
        4ezRqSruKxZKKOR0UUEX0gMxeTkHLe0zHl6zQsa+skzFLEYBoFzH3xN6bg==
X-Google-Smtp-Source: AK7set98lOnL8GVsd7oqZGcpKk5si2Uwm+R55RG8VPalV6rBbmKglYyotak+Jgflg8C07XaV/C4sWj2+rhevGYaReng=
X-Received: by 2002:a05:6122:1819:b0:431:bc30:7182 with SMTP id
 ay25-20020a056122181900b00431bc307182mr939694vkb.9.1679082820242; Fri, 17 Mar
 2023 12:53:40 -0700 (PDT)
MIME-Version: 1.0
References: <20230315021738.1151386-1-amoorthy@google.com> <ZBSmz0JAgTrsF608@linux.dev>
 <ZBStyKk6H73/0z2r@google.com> <CALzav=dBJyr373jnBF_-uLJfZMwHOsKSVSR2u4xr83etjp6Daw@mail.gmail.com>
 <ZBS3UbrWFZJzLzOq@linux.dev> <CALzav=fuZRrrMWHR+tRJ7R9hUDHyzhdBJ_Ak2V622TjRpFLoLw@mail.gmail.com>
In-Reply-To: <CALzav=fuZRrrMWHR+tRJ7R9hUDHyzhdBJ_Ak2V622TjRpFLoLw@mail.gmail.com>
From:   Anish Moorthy <amoorthy@google.com>
Date:   Fri, 17 Mar 2023 12:53:04 -0700
Message-ID: <CAF7b7mpwJ55vhmVfy0-_Nosgd+GZfno_HT1QQHg-952kvXW_5Q@mail.gmail.com>
Subject: Re: [WIP Patch v2 00/14] Avoiding slow get-user-pages via memory
 fault exit
To:     Sean Christopherson <seanjc@google.com>
Cc:     Oliver Upton <oliver.upton@linux.dev>, jthoughton@google.com,
        kvm@vger.kernel.org, maz@kernel.org,
        Isaku Yamahata <isaku.yamahata@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Mar 17, 2023 at 12:00=E2=80=AFPM David Matlack <dmatlack@google.com=
> wrote:
>
> On Fri, Mar 17, 2023 at 11:54=E2=80=AFAM Oliver Upton <oliver.upton@linux=
.dev> wrote:
> >
> > David,
> >
> > On Fri, Mar 17, 2023 at 11:46:58AM -0700, David Matlack wrote:
> > > On Fri, Mar 17, 2023 at 11:13=E2=80=AFAM Sean Christopherson <seanjc@=
google.com> wrote:
> > > >
> > > > On Fri, Mar 17, 2023, Oliver Upton wrote:
> > > > > On Wed, Mar 15, 2023 at 02:17:24AM +0000, Anish Moorthy wrote:
> > > > > > Hi Sean, here's what I'm planing to send up as v2 of the scalab=
le
> > > > > > userfaultfd series.
> > > > >
> > > > > I don't see a ton of value in sending a targeted posting of a ser=
ies to the
> > > > > list.
> > >
> > > But isn't it already generating value as you were able to weigh in an=
d
> > > provide feedback on technical aspects that you would not have been
> > > otherwise able to if Anish had just messaged Sean?
> >
> > No, I only happened upon this series looking at lore. My problem is tha=
t
> > none of the affected maintainers or reviewers were cc'ed on the series.
> >
> > > > > IOW, just CC all of the appropriate reviewers+maintainers. I prom=
ise,
> > > > > we won't bite.
> > >
> > > I disagree. While I think it's fine to reach out to someone off-list
> > > to discuss a specific question, if you're going to message all
> > > reviewers and maintainers, you should also CC the mailing list. That
> > > allows more people to follow along and weigh in if necessary.
> >
> > I think there may be a slight disconnect here :) I'm in no way encourag=
ing
> > off-list discussion and instead asking that mail on the list arrives in
> > the right folks' inboxes.
> >
> > Posting an RFC on the list was absolutely the right thing to do.
>
> Doh. I misunderstood what you meant. We are in violent agreement!

Noted. Also, thanks Oliver and Isaku for paying attention to the
series despite it being obscure.

On Fri, Mar 17, 2023 at 11:13=E2=80=AFAM Sean Christopherson <seanjc@google=
.com> wrote:
>
> On Fri, Mar 17, 2023, Oliver Upton wrote:
> > > Still unsure if needs conversion
> > > --------------------------------
> > > * __kvm_read_guest_atomic
> > >   The EFAULT might be propagated though FNAME(sync_page)?
> > > * kvm_write_guest_offset_cached (virt/kvm/kvm_main.c:3226)
> > > * __kvm_write_guest_page
> > >   Called from kvm_write_guest_offset_cached: if that needs change, th=
is does too
> >
> > The low-level accessors are common across architectures and can be call=
ed from
> > other contexts besides a vCPU. Is it possible for the caller to catch -=
EFAULT
> > and convert that into an exit?
>
> Ya, as things stand today, the conversions _must_ be performed at the cal=
ler, as
> there are (sadly) far too many flows where KVM squashes the error.  E.g. =
almost
> all of x86's paravirt code just suppresses user memory faults :-(
>
> Anish, when we discussed this off-list, what I meant by limiting the inti=
al support
> to existing -EFAULT cases was limiting support to existing cases where KV=
M directly
> returns -EFAULT to userspace, not to all existing cases where -EFAULT is =
ever
> returned _within KVM_ while handling KVM_RUN.  My apologies if I didn't m=
ake that clear.

Don't worry, we eventually got there off-list :)

This brings us back to my original set of questions. As has already
been pointed out, I'll have to revisit my "Confident that needs
conversion" changes and tweak them so that the vCPU exit is populated
only for the call sites where the -EFAULT makes it to userspace. I
still want feedback on if I've mis-identified any of the functions in
my "EFAULT does not propagate to userspace" list and whether there are
functions/callers in the "Still unsure if needs conversion" which do
have return paths to KVM_RUN.
