Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C16E16FFB31
	for <lists+kvm@lfdr.de>; Thu, 11 May 2023 22:22:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239018AbjEKUWh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 May 2023 16:22:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231446AbjEKUWg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 May 2023 16:22:36 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32793270D
        for <kvm@vger.kernel.org>; Thu, 11 May 2023 13:22:34 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-b9a7e3fc659so20207541276.1
        for <kvm@vger.kernel.org>; Thu, 11 May 2023 13:22:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1683836553; x=1686428553;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Pc3KTqUCSKzWsEHzUQVAXEAq3C5U5xaJDzEQ7e6JFi4=;
        b=M2/PeIN97s00eeSmiyRLGD3PvefqBVctLWv3nW5t4O6pOr++sFB6okzpEdh+jpfo/S
         jemOIrVU7Z7IMbsUdZ7dXTnK+8YnKESUBsfmeDIo4B6gIGKl4mp9YbGYzF05b2MHc++R
         zkcce/ZyYYpNkKUtCt72zSN1YjgO9e+EWHySXPu/XQ/kyZm/voKg5eCBBSAsHahuDaJH
         jLL9LhVQJCo8AHn4S8PdTTdejXbygVl0i7ZxwB1wak1aR4nGilvXs1ASnRk30XHqvR7O
         efEpYYxjaBUGWBULkP6gDuE9gTITT4yxhSlSPSOY1ZVFJN0bRyOk9oCkyt57Bvs8tkus
         XFtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683836553; x=1686428553;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Pc3KTqUCSKzWsEHzUQVAXEAq3C5U5xaJDzEQ7e6JFi4=;
        b=eB7xJStXxBis2HIzTkCPWecJpC+k9tvDVV1dl95d50K/AMbLUfJ8Ak6ktKzGoxqt/y
         WTkkKvfFa0Wwgtsi+sv5XcQfPpGTX7gPjxuI/bekmdwRhZA92PxYynbHtsQDIVDocL5p
         DqhfL9c9xJh49jBjTREyr1BpjIohuFI65Q+1zYY0rhS+ftNf/Q8VilFGPsfBMFtBbdAz
         tuLTJ+NQZG8WdCGBjer8wKVra2tA+r7+uSaPGdmw9E91Pa7ui5007/yyRaejUTWr9rYT
         +5TJ4b3+y0EcMBj7fC5YY9CUh4NKWdM5GLNzL9I2Aj1eFOe/giHRChfTfiqXS5L9i1GG
         xe3Q==
X-Gm-Message-State: AC+VfDwS26lmqvL0QrCxkU+h+jIZxKXkPbLEWU8G3SpAAN66esqIFP8z
        jF+mhJTvZQ6Bi7TQ/8ozAQqyEDlXFxI=
X-Google-Smtp-Source: ACHHUZ7Axk7QKjEI2Ze7kTlQKJK2/j1UAuv4jea1yq8A1ku9q05Red0Z9Gik8pF5gmrO0M4cdRMEeCOKKjQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:5e55:0:b0:ba6:c897:53d9 with SMTP id
 s82-20020a255e55000000b00ba6c89753d9mr1141409ybb.10.1683836553436; Thu, 11
 May 2023 13:22:33 -0700 (PDT)
Date:   Thu, 11 May 2023 13:22:31 -0700
In-Reply-To: <CAGtprH8jUAM015h4eEhbdAv6Oq2UNbX3P5Z-VCVbcrHtnATJwQ@mail.gmail.com>
Mime-Version: 1.0
References: <ZD12htq6dWg0tg2e@google.com> <1ed06a62-05a1-ebe6-7ac4-5b35ba272d13@redhat.com>
 <ZD2bBB00eKP6F8kz@google.com> <9efef45f-e9f4-18d1-0120-f0fc0961761c@redhat.com>
 <ZD86E23gyzF6Q7AF@google.com> <5869f50f-0858-ab0c-9049-4345abcf5641@redhat.com>
 <ZEM5Zq8oo+xnApW9@google.com> <CAGtprH_+bF4VZg2ps6CM8vjJVvShsvSGAvaLfTedts4cKqhSUw@mail.gmail.com>
 <ZFwPBqGeW+d9xMEs@google.com> <CAGtprH8jUAM015h4eEhbdAv6Oq2UNbX3P5Z-VCVbcrHtnATJwQ@mail.gmail.com>
Message-ID: <ZF1Oh5qrgcNNZ7Jc@google.com>
Subject: Re: Rename restrictedmem => guardedmem? (was: Re: [PATCH v10 0/9]
 KVM: mm: fd-based approach for supporting KVM)
From:   Sean Christopherson <seanjc@google.com>
To:     Vishal Annapurve <vannapurve@google.com>
Cc:     David Hildenbrand <david@redhat.com>,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        "Maciej S . Szmigiero" <mail@maciej.szmigiero.name>,
        Vlastimil Babka <vbabka@suse.cz>,
        Yu Zhang <yu.c.zhang@linux.intel.com>,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
        dhildenb@redhat.com, Quentin Perret <qperret@google.com>,
        tabba@google.com, Michael Roth <michael.roth@amd.com>,
        wei.w.wang@intel.com, Mike Rapoport <rppt@kernel.org>,
        Liam Merwick <liam.merwick@oracle.com>,
        Isaku Yamahata <isaku.yamahata@gmail.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Ackerley Tng <ackerleytng@google.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Hugh Dickins <hughd@google.com>,
        Christian Brauner <brauner@kernel.org>
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

On Wed, May 10, 2023, Vishal Annapurve wrote:
> On Wed, May 10, 2023 at 2:39=E2=80=AFPM Sean Christopherson <seanjc@googl=
e.com> wrote:
> > > But I would still like to get this discussed here before we move on.
> > >
> > > I am wondering if it would make sense to implement
> > > restricted_mem/guest_mem file to expose both private and shared memor=
y
> > > regions, inline with Kirill's original proposal now that the file
> > > implementation is controlled by KVM.
> > >
> > > Thinking from userspace perspective:
> > > 1) Userspace creates guest mem files and is able to mmap them but all
> > > accesses to these files result into faults as no memory is allowed to
> > > be mapped into userspace VMM pagetables.
> >
> > Never mapping anything into the userspace page table is infeasible.  Te=
chnically
> > it's doable, but it'd effectively require all of the work of an fd-base=
d approach
> > (and probably significantly more), _and_ it'd require touching core mm =
code.
> >
> > VMAs don't provide hva=3D>pfn information, they're the kernel's way of =
implementing
> > the abstraction provided to userspace by mmap(), mprotect() etc.  Among=
 many other
> > things, a VMA describes properties of what is mapped, e.g. hugetblfs ve=
rsus
> > anonymous, where memory is mapped (virtual address), how memory is mapp=
ed, e.g.
> > RWX protections, etc.  But a VMA doesn't track the physical address, th=
at info
> > is all managed through the userspace page tables.
> >
> > To make it possible to allow userspace to mmap() but not access memory =
(without
> > redoing how the kernel fundamentally manages virtual=3D>physical mappin=
gs), the
> > simplest approach is to install PTEs into userspace page tables, but ne=
ver mark
> > them Present in hardware, i.e. prevent actually accessing the backing m=
emory.
> > This is is exactly what Kirill's series in link [3] below implemented.
> >
>=20
> Maybe it's simpler to do when mmaped regions are backed with files.
>=20
> I see that shmem has fault handlers for accesses to VMA regions
> associated with the files, In theory a file implementation can always
> choose to not allocate physical pages for such faults (similar to
> F_SEAL_FAULT_AUTOALLOCATE that was discussed earlier).

Ah, you're effectively suggesting a hybrid model where the file is the sing=
le
source of truth for what's private versus shared, ad KVM gets pfns through
direct communication with the backing store via the file descriptor, but us=
erspace
can still control things via mmap() and friends.

If you're not suggesting a backdoor, i.e. KVM still gets private pfns via h=
vas,
then we're back at Kirill's series, because otherwise there's no easy way f=
or KVM
to retrieve the pfn.

A form of this was also discussed, though I don't know how much of the disc=
ussion
happened on-list.
=20
KVM actually does something like this for s390's Ultravisor (UV), which is =
quite
a bit like TDX (UV is a trusted intermediary) except that it handles faults=
 much,
much more gracefully.  Specifically, when the untrusted host attempts to ac=
cess a
secure page, a fault occurs and the kernel responds by telling UV to export=
 the
page.  The fault is gracefully handled even even for kernel accesses
(see do_secure_storage_access()).  The kernel does BUG() if the export fail=
s when
handling fault from kernel context, but my understanding is that export can=
 fail
if and only if there's a fatal error elsewhere, i.e. the UV essentialy _ens=
ures_
success, and goes straight to BUG()/panic() if something goes wrong.

On the guest side, accesses to exported (swapped) secure pages generate int=
ercepts
and KVM faults in the page.  To do so, KVM freezes the page/folio refcount,=
 tells
the UV to import the page, and then unfreezes the page/folio.  But very cru=
cially,
when _anything_ in the untrusted host attempts to access the secure page, t=
he
above fault handling for untrusted host accesses kicks in.  In other words,=
 the
guest can cause thrash, but can't bring down the host.

TDX on the other hand silently poisons memory, i.e. doesn't even generate a
synchronous fault.  Thus the kernel needs to be 100% perfect on preventing =
_any_
accesses to private memory from the host, and doing that is non-trivial and
invasive.

SNP does synchronously fault, but the automatically converting in the #PF h=
andler
got NAK'd[*] for good reasons, e.g. SNP doesn't guarantee conversion succes=
s as the
guest can trigger concurrent RMP modifications.  So the end result ends up =
being
the same as TDX, host accesses need to be completely prevented.

Again, this is all doable, but costly.  And IMO, provides very little value=
.

Allowing things like mbind() is nice-to-have at best, as implementing fbind=
()
isn't straightforward and arguably valuable to have irrespective of this
discussion, e.g. to allow userspace to say "use this policy regardless of w=
hat
process maps the file".

Using a common memory pool (same physical page is used for both shared and =
private)
is a similar story.  There are plenty of existing controls to limit userspa=
ce/guest
memory usage and to deal with OOM scenarios, so barring egregious host acco=
unting
and/or limiting bugs, which would affect _all_ VM types, the worst case sce=
nario
is that a VM is terminated because host userspace is buggy.  On the slip si=
de, using
a common pool brings complexity into the kernel, as backing stores would ne=
ed to
be taught to deny access to a subset of pages in their mappings, and in mul=
tiple
paths, e.g. faults, read()/write() and similar, page migration, swap, etc.

[*] https://lore.kernel.org/linux-mm/8a244d34-2b10-4cf8-894a-1bf12b59cf92@w=
ww.fastmail.com

> > Issues that led to us abandoning the "map with special !Present PTEs" a=
pproach:
> >
> >  - Using page tables, i.e. hardware defined structures, to track gfn=3D=
>pfn mappings
> >    is inefficient and inflexible compared to software defined structure=
s, especially
> >    for the expected use cases for CoCo guests.
> >
> >  - The kernel wouldn't _easily_ be able to enforce a 1:1 page:guest ass=
ociation,
> >    let alone a 1:1 pfn:gfn mapping.
>=20
> Maybe KVM can ensure that each page of the guest_mem file is
> associated with a single memslot.

This is a hard NAK.  Guest physical address space is guaranteed to have hol=
es
and/or be discontiguous, for the PCI hole at the top of lower memory.  Allo=
wing
only a single binding would prevent userspace from backing all (or large ch=
unks)
of guest memory with a single file.

> HVAs when they are registered can be associated with offsets into guest_m=
em files.

Enforcing 1:1 assocations is doable if KVM inserts a shim/interposer, e.g. =
essentially
implements the exclusivity bits of restrictedmem.  But that's adding even m=
ore
complexity.

> >  - Does not work for memory that isn't backed by 'struct page', e.g. if=
 devices
> >    gain support for exposing encrypted memory regions to guests.
> >
> >  - Poking into the VMAs to convert memory would be likely be less perfo=
rmant due
> >    to using infrastructure that is much "heavier", e.g. would require t=
aking
> >    mmap_lock for write.
>=20
> Converting memory doesn't necessarily need to poke holes into VMA, but
> rather just unmap pagetables just like what would happen when mmapped
> files are punched to free the backing file offsets.

Sorry, bad choice of word on my part.  I didn't intend to imply poking hole=
s, in
this case I used "poking" to mean "modifying".  munmap(), mprotected(), etc=
 all
require modifying VMAs, which means taking mmap_lock for write.

> > In short, shoehorning this into mmap() requires fighting how the kernel=
 works at
> > pretty much every step, and in the end, adding e.g. fbind() is a lot ea=
sier.
> >
> > > 2) Userspace registers mmaped HVA ranges with KVM with additional
> > > KVM_MEM_PRIVATE flag
> > > 3) Userspace converts memory attributes and this memory conversion
> > > allows userspace to access shared ranges of the file because those ar=
e
> > > allowed to be faulted in from guest_mem. Shared to private conversion
> > > unmaps the file ranges from userspace VMM pagetables.
> > > 4) Granularity of userspace pagetable mappings for shared ranges will
> > > have to be dictated by KVM guest_mem file implementation.
> > >
> > > Caveat here is that once private pages are mapped into userspace view=
.
> > >
> > > Benefits here:
> > > 1) Userspace view remains consistent while still being able to use HV=
A ranges
> > > 2) It would be possible to use HVA based APIs from userspace to do
> > > things like binding.
> > > 3) Double allocation wouldn't be a concern since hva ranges and gpa
> > > ranges possibly map to the same HPA ranges.
> >
> > #3 isn't entirely correct.  If a different process (call it "B") maps s=
hared memory,
> > and then the guest converts that memory from shared to private, the bac=
king pages
> > for the previously shared mapping will still be mapped by process B unl=
ess userspace
> > also ensures process B also unmaps on conversion.
> >
>=20
> This should be ideally handled by something like: unmap_mapping_range()

That'd work for the hybrid model (fd backdoor with pseudo mmap() support), =
but
not for a generic VMA-based implementation.  If the file isn't the single s=
ource
of truth, then forcing all mappings to go away simply can't work.
=20
> > #3 is also a limiter.  E.g. if a guest is primarly backed by 1GiB pages=
, keeping
> > the 1GiB mapping is desirable if the guest converts a few KiB of memory=
 to shared,
> > and possibly even if the guest converts a few MiB of memory.
>=20
> This caveat maybe can be lived with as shared ranges most likely will
> not be backed by 1G pages anyways, possibly causing IO performance to
> get hit. This possibly needs more discussion about conversion
> granularity used by guests.

Yes, it's not the end of the world.  My point is that separating shared and=
 private
memory provides more flexibility.  Maybe that flexibility never ends up bei=
ng
super important, but at the same time we shouldn't willingly paint ourselve=
s into
a corner.
