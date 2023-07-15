Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62FA47545A5
	for <lists+kvm@lfdr.de>; Sat, 15 Jul 2023 02:36:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230146AbjGOAal (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Jul 2023 20:30:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230102AbjGOAak (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Jul 2023 20:30:40 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6752E3A9B
        for <kvm@vger.kernel.org>; Fri, 14 Jul 2023 17:30:39 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-cac213f9264so2067936276.3
        for <kvm@vger.kernel.org>; Fri, 14 Jul 2023 17:30:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1689381038; x=1691973038;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FHKwfmmmzPP47eD0/lc7LkRrZ2d2K2NzwRoC7JoUoLc=;
        b=a+FzRVPiZrW0fqmlFJABpuG8Y6bGxU0TqA8TqCxHRZGgObxX5SSgo0oB/FUgNQLgEV
         FnKY6jtRfmR6N1X2EdhsLXkGnsOs5ZX7WY1Np2nRkJAroDmflKvdxidI2RA22XtNjA7S
         ksvMF2+/gACQLm2dupXD7q6eHQmmgjM8GptqORnXW/68I+uw58SCs66dnsWzhIGYjvbQ
         IsviHBtVGyoohHaiivukhm9S1lT7rHdyuzDrUT1pxzIq/A0h3zTVBEFp4Nq3vjtaY6SN
         LSMvKFW154ElxAMDejVexeo7imsNyG9vqc4KbPWDP7Iw7AU5YCYD86+eG+Sr5oohd97d
         PbTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689381038; x=1691973038;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=FHKwfmmmzPP47eD0/lc7LkRrZ2d2K2NzwRoC7JoUoLc=;
        b=bZOU9E0NT8IUbBh6iwCytmXkvQjZ/yg6lZVJQw7zTbkbic9A0NJNV5IkT8517eXCxm
         iCSuOyvPkUSICy6MT5/cy156oqbftvfejO9xOhqhmYRLsNwpn4z5WXyvuxspHIRzd3Db
         R1o7zAyyl75x0TIlq0DR9MIKVZIcMFDGf4VIJz7hE6e2g53acHHaP4N2/9dKx8lS0C4s
         obRGMzeHZaUKnVcJbDhv1s9InFpvThL8SU0NfQmE7rrVCAewnsc0CWqKUpKpBM/2h6QH
         ucVxCwQWk5CVqj0Qux5kcZ8kCBM0CkJeGYB5I7lP6cXgFz6MF5O2B1yo0ljnA9GBuGMs
         jH3g==
X-Gm-Message-State: ABy/qLZ/X6l8B/tFGC4nVB77MJoy332fHtt2004XoA2TyEkJT8weTLF2
        8eQzc/a6+FOXgWcx6miW3VHNMqZoMoM=
X-Google-Smtp-Source: APBJJlH9VCWaKch8qFYSR3IiJohKql/mJpccdhRIVYnUmRBlU/7KMw9WMaI3a/IEBvC+TXTYx41QlaSaT0E=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:ab81:0:b0:c5f:85f5:a0e5 with SMTP id
 v1-20020a25ab81000000b00c5f85f5a0e5mr12471ybi.5.1689381038652; Fri, 14 Jul
 2023 17:30:38 -0700 (PDT)
Date:   Fri, 14 Jul 2023 17:30:37 -0700
In-Reply-To: <CAGtprH-VCqUgqK8gk40KaQZD8trXbWYk8KmA612Og1ep1Dko=Q@mail.gmail.com>
Mime-Version: 1.0
References: <ZFWli2/H5M8MZRiY@google.com> <diqzr0pb2zws.fsf@ackerleytng-ctop.c.googlers.com>
 <ZLGiEfJZTyl7M8mS@google.com> <CAGtprH-VCqUgqK8gk40KaQZD8trXbWYk8KmA612Og1ep1Dko=Q@mail.gmail.com>
Message-ID: <ZLHorQjmNe1Qe5Ne@google.com>
Subject: Re: Rename restrictedmem => guardedmem? (was: Re: [PATCH v10 0/9]
 KVM: mm: fd-based approach for supporting KVM)
From:   Sean Christopherson <seanjc@google.com>
To:     Vishal Annapurve <vannapurve@google.com>
Cc:     Ackerley Tng <ackerleytng@google.com>, david@redhat.com,
        chao.p.peng@linux.intel.com, pbonzini@redhat.com,
        vkuznets@redhat.com, jmattson@google.com, joro@8bytes.org,
        mail@maciej.szmigiero.name, vbabka@suse.cz,
        yu.c.zhang@linux.intel.com, kirill.shutemov@linux.intel.com,
        dhildenb@redhat.com, qperret@google.com, tabba@google.com,
        michael.roth@amd.com, wei.w.wang@intel.com, rppt@kernel.org,
        liam.merwick@oracle.com, isaku.yamahata@gmail.com,
        jarkko@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, hughd@google.com, brauner@kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 14, 2023, Vishal Annapurve wrote:
> On Fri, Jul 14, 2023 at 12:29=E2=80=AFPM Sean Christopherson <seanjc@goog=
le.com> wrote:
> > ...
> > And _if_ there is a VMM that instantiates memory before KVM_CREATE_VM, =
IMO making
> > the ioctl() /dev/kvm scoped would have no meaningful impact on adapting=
 userspace
> > to play nice with the required ordering.  If userspace can get at /dev/=
kvm, then
> > it can do KVM_CREATE_VM, because the only input to KVM_CREATE_VM is the=
 type, i.e.
> > the only dependencies for KVM_CREATE_VM should be known/resolved long b=
efore the
> > VMM knows it wants to use gmem.
>=20
> I am not sure about the benefits of tying gmem creation to any given
> kvm instance.

IMO, making gmem->kvm immutable is very nice to have, e.g. gmem->kvm will a=
lways be
valid and the refcounting rules are fairly straightforward. =20

> I think the most important requirement here is that a given gmem range is=
 always
> tied to a single VM=20

I'm not convinced that that requirement will always hold true (see below).

> This can be enforced when memslots are bound to the gmem files.

Yeah, but TBH, waiting until the guest faults in memory to detect an invali=
d memslot
is gross.  And looking more closely, taking filemap_invalidate_lock(), i.e.=
 taking
a semaphore for write, in the page fault path is a complete non-starter.  T=
he
"if (existing_slot =3D=3D slot)" check is likely a non-starter, because KVM=
 handles
FLAGS_ONLY memslot updates, e.g. toggling dirty logging, by duplicating and
replacing the memslot, not by updating the live memslot.

> I believe "Required ordering" is that gmem files are created first and
> then supplied while creating the memslots whose gpa ranges can
> generate private memory accesses.
> Is there any other ordering we want to enforce here?

I wasn't talking about enforcing arbitrary ordering, I was simply talking a=
bout
what userspace literally needs to be able to do KVM_CREATE_GUEST_MEMFD.

> > Practically, I think that gives us a clean, intuitive way to handle int=
ra-host
> > migration.  Rather than transfer ownership of the file, instantiate a n=
ew file
> > for the target VM, using the gmem inode from the source VM, i.e. create=
 a hard
> > link.  That'd probably require new uAPI, but I don't think that will be=
 hugely
> > problematic.  KVM would need to ensure the new VM's guest_memfd can't b=
e mapped
> > until KVM_CAP_VM_MOVE_ENC_CONTEXT_FROM (which would also need to verify=
 the
> > memslots/bindings are identical), but that should be easy enough to enf=
orce.
> >
> > That way, a VM, its memslots, and its SPTEs are tied to the file, while=
 allowing
> > the memory and the *contents* of memory to outlive the VM, i.e. be effe=
ctively
> > transfered to the new target VM.  And we'll maintain the invariant that=
 each
> > guest_memfd is bound 1:1 with a single VM.
> >
> > As above, that should also help us draw the line between mapping memory=
 into a
> > VM (file), and freeing/reclaiming the memory (inode).
> >
> > There will be extra complexity/overhead as we'll have to play nice with=
 the
> > possibility of multiple files per inode, e.g. to zap mappings across al=
l files
> > when punching a hole, but the extra complexity is quite small, e.g. we =
can use
> > address_space.private_list to keep track of the guest_memfd instances a=
ssociated
> > with the inode.
>=20
> Are we talking about a different usecase of sharing gmem fd across VMs
> other than intra-host migration?

Well, I am :-)  I don't want to build all of this on an assumption that we'=
ll
never ever want to share a guest_memfd across multiple VMs.  E.g. SEV (and =
SEV-ES?)
already have the migration helper concept, and I've heard more than a few r=
umblings
of TDX utilizing helper TDs.  IMO, it's not far fetched at all to think tha=
t there
will eventually be a need to let multiple VMs share a guest_memfd.

> If not, ideally only one of the files should be catering to the guest
> memory mappings at any given time. i.e. any inode should be ideally
> bound to (through the file) a single kvm instance,

Why?  Honest question, what does it buy us?

For TDX and SNP intra-host migration, it should be easy enough to ensure th=
e new
VM can't create mappings before migration, and that the old VM can't create=
 mappings
or run after migration.  I don't see that being any harder if the source an=
d
dest use different files.

FWIW, it might be easier to hold off on this discussion until I post the RF=
C
(which is going to happen on Monday at this point), as then we'll have actu=
al code
to discuss.

> as we we are planning to ensure that guest_memfd can't be mapped until
> KVM_CAP_VM_MOVE_ENC_CONTEXT_FROM is invoked on the target side.
