Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BC7D787C7A
	for <lists+kvm@lfdr.de>; Fri, 25 Aug 2023 02:17:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231426AbjHYARF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Aug 2023 20:17:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232438AbjHYAQi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Aug 2023 20:16:38 -0400
Received: from mail-vk1-xa2c.google.com (mail-vk1-xa2c.google.com [IPv6:2607:f8b0:4864:20::a2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE4B61BC8
        for <kvm@vger.kernel.org>; Thu, 24 Aug 2023 17:16:36 -0700 (PDT)
Received: by mail-vk1-xa2c.google.com with SMTP id 71dfb90a1353d-48cfdfa7893so223356e0c.0
        for <kvm@vger.kernel.org>; Thu, 24 Aug 2023 17:16:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692922596; x=1693527396;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7t4jBs6ANdVOZ+fXA/YvUk9XjJk29rUWw8CEUgNsyuc=;
        b=C4Gh3k2Q2eM8M36CRLT7ye5PV63jFfM0Qod71NeCl+gHiPrnCkOhYxA0FaRRaBUDeL
         6pf5Q5GNd+KqY/dhT8pZ5ho3XFuGPAdZoluyt8pdJdCfEE1uurvT4umPi7diZMKjBaza
         1WO15Y7JhKnBO+tTDEiZgWBqB9FBqVwtzaEqfPXib2ZI3WvEwfCzSC7pepD0k0XuxblC
         fCI3CDCpY6qDT0QJPQt3TX02LDCP95DpgmVYs5zPKtKMssJfCXSLbS9WZl03YdykaiYB
         /yCBVj9CxWrZEjjjTkqE/FavGt9vjS/FpOX3NYMaLZ9JzQuQjXAymv8LAgqeSAVsIWlr
         UTeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692922596; x=1693527396;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7t4jBs6ANdVOZ+fXA/YvUk9XjJk29rUWw8CEUgNsyuc=;
        b=fCHkPV0Ryu/RqE8m/g+w1yyXXto7EpML1SuWWFaQJ3uKRQdv7Q25e+1WRinpU3Fb+A
         EIlHkE2vQfjO73N5vlsSiPVKr1YkvmxvIiyQVP+WMMBTNh4mE6uOR3o9nzN0jASew+xO
         t7kMrei/DPExCfYpR1Z3h63Ev7yD8wSFvJP7GkwN2XTAyROr2fN6mpzospXaXB0NmbVg
         Oh6Sc4Bvxp/WawkpU4D6ct8WWZR9XAoLTrJRTIewUvDqwfUM8X6CZPlMipNtFr1WYh8m
         BepcsOK/ChGf+UxdTRBBmLOkU5u1p177SrYRwRFl+B/U3FiUbNq7U6NqLd7s86KRmy0t
         hBkQ==
X-Gm-Message-State: AOJu0YxaGtFhqbsnT9iIbhMuqTSJ7nk2uLgnX9c3ILKOU2wMZXK3NMDx
        /BtgsXcqkpN5WXvxsEKvSUp3fZSAfWJjPwEV5GKuBw==
X-Google-Smtp-Source: AGHT+IGF5ck2Ld8HKUNY/AFh8ERxd5PNB/Sn3tz9UMkNMgVe5d1AIX+7bSyVWzQ317NBF2reSTtFoVUeF2PbqJctIGI=
X-Received: by 2002:a05:6122:552:b0:48d:149e:1a41 with SMTP id
 y18-20020a056122055200b0048d149e1a41mr18663014vko.8.1692922595910; Thu, 24
 Aug 2023 17:16:35 -0700 (PDT)
MIME-Version: 1.0
References: <20230602161921.208564-1-amoorthy@google.com> <20230602161921.208564-10-amoorthy@google.com>
 <ZIovIBVLIM69E5Bo@google.com> <CAF7b7mqKJTCENsb+5MZT+D=DwcSva-jMANjtYszMTm-ACvkiKA@mail.gmail.com>
 <CAF7b7mrabLtnq+0Gtsg9FA+Gfr12FqbmfxwJZuQcBNDz1+3yLw@mail.gmail.com> <ZK11Sxobf53RsAmH@google.com>
In-Reply-To: <ZK11Sxobf53RsAmH@google.com>
From:   Anish Moorthy <amoorthy@google.com>
Date:   Thu, 24 Aug 2023 17:15:59 -0700
Message-ID: <CAF7b7mp1Bspeqc9n==gE5NgPwxfYLtu9G3=+OTwAcipeYRkPKg@mail.gmail.com>
Subject: Re: [PATCH v4 09/16] KVM: Introduce KVM_CAP_NOWAIT_ON_FAULT without implementation
To:     Sean Christopherson <seanjc@google.com>
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

On Tue, Jul 11, 2023 at 8:29=E2=80=AFAM Sean Christopherson <seanjc@google.=
com> wrote:
>
> Well, that description is wrong for other reasons.  As mentioned in my re=
ply
> (got snipped), the behavior is not tied to sleeping or waiting on I/O.
>
> >  Moving the nowait check out of __kvm_faultin_pfn()/user_mem_abort()
> > and into __gfn_to_pfn_memslot() means that, obviously, other callers
> > will start to see behavior changes. Some of that is probably actually
> > necessary for that documentation to be accurate (since any usages of
> > __gfn_to_pfn_memslot() under KVM_RUN should respect the memslot flag),
> > but I think there are consumers of __gfn_to_pfn_memslot() from outside
> > KVM_RUN.
>
> Yeah, replace "in response to page faults" with something along the lines=
 of "if
> an access in guest context ..."

Alright, how about

+ KVM_MEM_NO_USERFAULT_ON_GUEST_ACCESS
+ The presence of this capability indicates that userspace may pass the
+ KVM_MEM_NO_USERFAULT_ON_GUEST_ACCESS flag to
+ KVM_SET_USER_MEMORY_REGION. Said flag will cause KVM_RUN to fail (-EFAULT=
)
+ in response to guest-context memory accesses which would require KVM
+ to page fault on the userspace mapping.

Although, as Wang mentioned, USERFAULT seems to suggest something
related to userfaultfd which is a liiiiitle too specific. Perhaps we
should use USERSPACE_FAULT (*cries*) instead?

On Wed, Jun 14, 2023 at 2:20=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
>
> However, do we actually need to force vendor code to query nowait?  At a =
glance,
> the only external (relative to kvm_main.c) users of __gfn_to_pfn_memslot(=
) are
> in flows that play nice with nowait or that don't support it at all.  So =
I *think*
> we can do this?

On Wed, Jun 14, 2023 at 2:23=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
>
> Gah, got turned around and forgot to account for @atomic.  So this?
>
>         if (!atomic && memslot_is_nowait_on_fault(slot)) {
>                 atomic =3D true;
>                 if (async) {
>                         *async =3D false;
>                         async =3D NULL;
>                 }
>         }
>
> > +
> >         return hva_to_pfn(addr, atomic, interruptible, async, write_fau=
lt,
> >                           writable);
> >  }

Took another look at this and I *think* it works too (I added my notes
at the end here so if anyone wants to double-check they can). But
there are a couple of quirks

1. The memslot flag can cause new __gfn_to_pfn_memslot() failures in
kvm_vcpu_map() (good thing!) but those failures result in an EINVAL
(bad!). It kinda looks like the current is_error_noslot_pfn() check in
that function should be returning EFAULT anyways though, any opinions?

2. kvm_vm_ioctl_mte_copy_tags() will see new failures. This function
has come up before (a) and it doesn't seem like an access in a guest
context. Is this something to just be documented away?

3. I don't think I've caught parts of the who-calls tree that are in
drivers/. The one part I know about is the gfn_to_pfn() call in
is_2MB_gtt_possible() (drivers/gpu/drm/i915/gvt/gtt.c), and I'm not
sure what to do about it. Again, doesn't look like a guest-context
access.

(a) https://lore.kernel.org/kvm/ZIoiLGotFsDDvRN3@google.com/T/#u

---------------------------------------------------
Notes: Tracing the usages of __gfn_to_pfn_memslot()
"shove" =3D "moving the nowait check inside of __gfn_to_pfn_memslot

* [x86] __gfn_to_pfn_memslot() has 5 callers
** DONE kvm_faultin_pfn() accounts for two calls, shove will cause
bail (as intended) after first
** DONE __gfn_to_pfn_prot(): No usages on x86
** DONE __gfn_to_pfn_memslot_atomic: already requires atomic access :)
** gfn_to_pfn_memslot() has two callers
*** DONE kvm_vcpu_gfn_to_pfn(): No callers
*** gfn_to_pfn() has two callers
**** TODO kvm_vcpu_map() When memslot flag trips will get
KVM_PFN_ERR_FAULT, error is handled
HOWEVER it will return -EINVAL which is kinda... not right
**** gfn_to_page() has two callers, but both operate on
APIC_DEFAULT_PHYS_BASE addr
** Ok so that's "done," as long as my LSP is reliable

* [arm64] __gfn_to_pfn_memslot() has 4 callers
** DONE user_mem_abort() has one, accounted for by the subsequent
is_error_noslot_pfn()
** DONE __gfn_to_pfn_memslot_atomic() fine as above
** TODO gfn_to_pfn_prot() One caller in kvm_vm_ioctl_mte_copy_tags()
There's a is_error_noslot_pfn() to catch the failure, but there's no vCPU
floating around to annotate a fault in!
** gfn_to_pfn_memslot() two callers
*** DONE kvm_vcpu_gfn_to_pfn() no callers
*** gfn_to_pfn() two callers
**** kvm_vcpu_map() as above
**** DONE gfn_to_page() no callers

* TODO Weird driver code reference I discovered only via ripgrep?
