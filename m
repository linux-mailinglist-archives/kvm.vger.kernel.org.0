Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D88DA78D95B
	for <lists+kvm@lfdr.de>; Wed, 30 Aug 2023 20:33:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231596AbjH3Sc6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Aug 2023 14:32:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343633AbjH3QWS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Aug 2023 12:22:18 -0400
Received: from mail-vk1-xa2b.google.com (mail-vk1-xa2b.google.com [IPv6:2607:f8b0:4864:20::a2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C732AD2
        for <kvm@vger.kernel.org>; Wed, 30 Aug 2023 09:22:14 -0700 (PDT)
Received: by mail-vk1-xa2b.google.com with SMTP id 71dfb90a1353d-48d165bd108so2000842e0c.0
        for <kvm@vger.kernel.org>; Wed, 30 Aug 2023 09:22:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1693412534; x=1694017334; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Dw2WvEWP5AHwQBMLMZzuxkvXEX6YYa50Q22jJHrU9hQ=;
        b=d/KuGhUyj5Y9PfKzc4LBx81Q73Ar6ZGJFNhc9PFvdrc6gDykcyRfQhfNN6Wk/aEVn1
         4lr47dorFVc0rSpUpS2VdzfZP6A5w4ls0ZiNzGw6oL9GVC1Dhhz6Nk9EgOfVOmFo4a4g
         AzdJRYy81MLfrmUzkbIrPUSdCoOq2bOaoccsLmgaW0HUd+P1jl+rQltBslEUsxmaQBwu
         4Zp5o8GJFr9bDQ2MahKFxsw9PrFHyAhp5gMZAViBCB3EQ0bqOa3vlUMHKef5dBQ4LryX
         uWAfhJmseVNKkgFXIbKAvk+qOfDdhDnMH3d59J74gpS4eMRSTSIh2lsWfHI44QRj3Ah6
         vrLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693412534; x=1694017334;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Dw2WvEWP5AHwQBMLMZzuxkvXEX6YYa50Q22jJHrU9hQ=;
        b=KzkQSzVkZH4i5ntj3hX4/sZ5vYrFbhHkcc6H5mrNCo/JfnyJCvUlg7G6CVVgnVZ2Ik
         spaY+iyZKGjMEa0ePmevF3b7I7AOyqjhhYv0uPHsnvcJR0cqhIIAPEypg5lwHmsWMR/0
         uk23x9haUNw43BiwNtfkeMoKybtnRza/T8eWhaJ1M7t+DkKLYvhFepqxMTfQ50sGjKCY
         k4CWoh1EK0fxIp1yHK266XDf3nJzPB3KhqqYWSQRgf9yVbpCoGu3Ksv0EZSXJv6N4j8b
         pdpSadS1kV6sCZEkY3nAB8RnozOZbr+puYZ5tRZOh3UPHcij70LlG4y1VleFVcWLj3ZG
         jqHA==
X-Gm-Message-State: AOJu0YzY76tU2p876pQhAsGPa/D/cn/yUsSOFvepL//3BTSpuC+8U6TF
        ge5z8mj13SCO1PWuZQYuufAKZFMP4uClatrqxRpyyoVA0byTKzNS+7A=
X-Google-Smtp-Source: AGHT+IFJYolaWrvL9Vm6pW/8woBwDRooYKKzo58w/okNFmpZ5IkaXab/sUrziXE2fCbBT5QIHQa5WDlTvBocGpsAIZw=
X-Received: by 2002:a1f:4842:0:b0:48d:d3b:7dd9 with SMTP id
 v63-20020a1f4842000000b0048d0d3b7dd9mr2165847vka.3.1693412533698; Wed, 30 Aug
 2023 09:22:13 -0700 (PDT)
MIME-Version: 1.0
References: <20230602161921.208564-1-amoorthy@google.com> <20230602161921.208564-10-amoorthy@google.com>
 <ZIovIBVLIM69E5Bo@google.com> <CAF7b7mqKJTCENsb+5MZT+D=DwcSva-jMANjtYszMTm-ACvkiKA@mail.gmail.com>
 <CAF7b7mrabLtnq+0Gtsg9FA+Gfr12FqbmfxwJZuQcBNDz1+3yLw@mail.gmail.com>
 <ZK11Sxobf53RsAmH@google.com> <CAF7b7mp1Bspeqc9n==gE5NgPwxfYLtu9G3=+OTwAcipeYRkPKg@mail.gmail.com>
 <ZO50Nvl5QaQMmNqX@google.com>
In-Reply-To: <ZO50Nvl5QaQMmNqX@google.com>
From:   Anish Moorthy <amoorthy@google.com>
Date:   Wed, 30 Aug 2023 09:21:37 -0700
Message-ID: <CAF7b7mr1EHF3EAU9PAFV16N0y52N2Ek8vPEcr60NQL7jd85PLg@mail.gmail.com>
Subject: Re: [PATCH v4 09/16] KVM: Introduce KVM_CAP_NOWAIT_ON_FAULT without implementation
To:     Sean Christopherson <seanjc@google.com>,
        "stevensd@chromium.org" <stevensd@chromium.org>
Cc:     oliver.upton@linux.dev, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev, pbonzini@redhat.com, maz@kernel.org,
        robert.hoo.linux@gmail.com, jthoughton@google.com,
        bgardon@google.com, dmatlack@google.com, ricarkol@google.com,
        axelrasmussen@google.com, peterx@redhat.com, nadav.amit@gmail.com,
        isaku.yamahata@gmail.com
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

On Tue, Aug 29, 2023 at 3:42=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
>
> On Thu, Aug 24, 2023, Anish Moorthy wrote:
> > On Tue, Jul 11, 2023 at 8:29=E2=80=AFAM Sean Christopherson <seanjc@goo=
gle.com> wrote:
> > >
> > > Well, that description is wrong for other reasons.  As mentioned in m=
y reply
> > > (got snipped), the behavior is not tied to sleeping or waiting on I/O=
.
> > >
> > > >  Moving the nowait check out of __kvm_faultin_pfn()/user_mem_abort(=
)
> > > > and into __gfn_to_pfn_memslot() means that, obviously, other caller=
s
> > > > will start to see behavior changes. Some of that is probably actual=
ly
> > > > necessary for that documentation to be accurate (since any usages o=
f
> > > > __gfn_to_pfn_memslot() under KVM_RUN should respect the memslot fla=
g),
> > > > but I think there are consumers of __gfn_to_pfn_memslot() from outs=
ide
> > > > KVM_RUN.
> > >
> > > Yeah, replace "in response to page faults" with something along the l=
ines of "if
> > > an access in guest context ..."
> >
> > Alright, how about
> >
> > + KVM_MEM_NO_USERFAULT_ON_GUEST_ACCESS
> > + The presence of this capability indicates that userspace may pass the
> > + KVM_MEM_NO_USERFAULT_ON_GUEST_ACCESS flag to
> > + KVM_SET_USER_MEMORY_REGION. Said flag will cause KVM_RUN to fail (-EF=
AULT)
> > + in response to guest-context memory accesses which would require KVM
> > + to page fault on the userspace mapping.
> >
> > Although, as Wang mentioned, USERFAULT seems to suggest something
> > related to userfaultfd which is a liiiiitle too specific. Perhaps we
> > should use USERSPACE_FAULT (*cries*) instead?
>
> Heh, it's not strictly on guest accesses though.

Is the inaccuracy just because of the KVM_DEV_ARM_VGIC_GRP_CTRL
disclaimer, or something else? I thought that "guest-context accesses"
would capture the flag affecting memory accesses that KVM emulates for
the guest as well, in addition to the "normal" EPT-violation -> page
fault path. But if that's still not totally accurate then you should
probably just spell this out for me.

> At this point, I'm tempted to come up with some completely arbitrary name=
 for the
> feature and give up on trying to describe its effects in the name itself.

You know, Oliver may have made an inspired suggestion a while back...

On Mon, Mar 20, 2023 at 3:22=E2=80=AFPM Oliver Upton <oliver.upton@linux.de=
v> wrote:
>
> I couldn't care less about what the user-facing portion of this thing is
> called, TBH. We could just refer to it as KVM_MEM_BIT_2 /s

> > On Wed, Jun 14, 2023 at 2:20=E2=80=AFPM Sean Christopherson <seanjc@goo=
gle.com> wrote:
>
> We'll need a way to way for KVM to opt-out for kvm_vcpu_map(), at which p=
oint it
> makes sense to opt-out for kvm_vm_ioctl_mte_copy_tags() as well.

Uh oh, I sense another parameter to __gfn_to_pfn_memslot(). Although I
did see that David Stevens has been proposing cleanups to that code
[1]. Is proper practice here to take a dependency on his series, do we
just resolve the conflicts when the series are merged, or something
else?

[1] https://lore.kernel.org/kvm/20230824080408.2933205-1-stevensd@google.co=
m/

> > 3. I don't think I've caught parts of the who-calls tree that are in
> > drivers/. The one part I know about is the gfn_to_pfn() call in
> > is_2MB_gtt_possible() (drivers/gpu/drm/i915/gvt/gtt.c), and I'm not
> > sure what to do about it. Again, doesn't look like a guest-context
> > access.
>
> On x86, that _was_ the only one.  You're welcome ;-)
>
> https://lore.kernel.org/all/20230729013535.1070024-9-seanjc@google.com

Much obliged :D
