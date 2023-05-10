Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5988C6FE7E3
	for <lists+kvm@lfdr.de>; Thu, 11 May 2023 01:04:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236792AbjEJXEA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 May 2023 19:04:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230467AbjEJXD7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 May 2023 19:03:59 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEB4A7AB0
        for <kvm@vger.kernel.org>; Wed, 10 May 2023 16:03:26 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id 4fb4d7f45d1cf-50bc4b88998so13967388a12.3
        for <kvm@vger.kernel.org>; Wed, 10 May 2023 16:03:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1683759805; x=1686351805;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1R4G4N9xNRse1S8Qy+Upxa7B2Fk7s5Bd8H1DsXqUpgw=;
        b=Us3qewPs7FH0/9W5JtJ6Kc+Ny8oizpy0w1yqNC9NtnBqieR4BooJyWYdJuZSVZwzOi
         aL3Hr2XiQ9JlpVNz+ZQv67KbXosCmCJ2aNmLEi4+F7rRKNJhFnK34x6osrzkg73R0lbR
         e3YAAS9c2kCME6hc2ZY+09KeWVWXyi/xB6sMkjaoculZn63ChhHu2dB3XsOvZn6YZkmo
         xvG/rsPacDlpdM1VHePpDcPH1X2F/ATqnz6UrAKKE43rNSiIVy4RPtB5RfZHKPcJC6OW
         pWbShUSwkMN+9TTabPsmilevPoLJxN4REG0CQlkxSEs9eMAO0lrjqetZ7Y8y9UZ1nOhI
         DVjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683759805; x=1686351805;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1R4G4N9xNRse1S8Qy+Upxa7B2Fk7s5Bd8H1DsXqUpgw=;
        b=VJI0QYO3YRFx1itITeAvLJ03gOvZbfmEKY902QEKa94cbSRQkVBtqQAE19PM+f6RH+
         5jEJxAdGhj0fKoUqUxbVN7bZEH/lY2vG3A5jb4cy0pHvzVzAmIpODPMss0k03oUpIMFK
         FiGI9VSYytQbOfFOYVxI1weU6gqAL1e6Nk57uW/y+7sR+ugtsGIrc9mclZnZkCeeYS0Y
         lUxT85Zfp6/H3xmwY8/3qZYTEp9aQtYIRB4zLYJV9g2Ryt+086YCguzErcIBQVRBXCfl
         wRaiZbfPnsI6MUmmsvKV2J90wBssQyVuFC4i2arroMHaCTt1jrGtuOh74fPG6hPCedJy
         +okQ==
X-Gm-Message-State: AC+VfDynJa/nRWDh8YsKBE8B9RacTnjvj0PvClOz6/21ImqS1y3Sc6ak
        ZJs0mvG+FIQpS69iu8PBjLizf5Uyv2PwkitkJU78Kg==
X-Google-Smtp-Source: ACHHUZ4v5M4IuwVasytIBzHFiuO2mXW3bXcaw1h9dErieYg9F2g83Pin19NJjFwbluHfeDQMhpE31ioFQgqUa76b610=
X-Received: by 2002:a05:6402:605:b0:50d:91c8:9e10 with SMTP id
 n5-20020a056402060500b0050d91c89e10mr12970238edv.10.1683759805082; Wed, 10
 May 2023 16:03:25 -0700 (PDT)
MIME-Version: 1.0
References: <ZD1oevE8iHsi66T2@google.com> <658018f9-581c-7786-795a-85227c712be0@redhat.com>
 <ZD12htq6dWg0tg2e@google.com> <1ed06a62-05a1-ebe6-7ac4-5b35ba272d13@redhat.com>
 <ZD2bBB00eKP6F8kz@google.com> <9efef45f-e9f4-18d1-0120-f0fc0961761c@redhat.com>
 <ZD86E23gyzF6Q7AF@google.com> <5869f50f-0858-ab0c-9049-4345abcf5641@redhat.com>
 <ZEM5Zq8oo+xnApW9@google.com> <CAGtprH_+bF4VZg2ps6CM8vjJVvShsvSGAvaLfTedts4cKqhSUw@mail.gmail.com>
 <ZFwPBqGeW+d9xMEs@google.com>
In-Reply-To: <ZFwPBqGeW+d9xMEs@google.com>
From:   Vishal Annapurve <vannapurve@google.com>
Date:   Wed, 10 May 2023 16:03:13 -0700
Message-ID: <CAGtprH8jUAM015h4eEhbdAv6Oq2UNbX3P5Z-VCVbcrHtnATJwQ@mail.gmail.com>
Subject: Re: Rename restrictedmem => guardedmem? (was: Re: [PATCH v10 0/9]
 KVM: mm: fd-based approach for supporting KVM)
To:     Sean Christopherson <seanjc@google.com>
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
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 10, 2023 at 2:39=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
>
> On Wed, May 10, 2023, Vishal Annapurve wrote:
> > On Fri, Apr 21, 2023 at 6:33=E2=80=AFPM Sean Christopherson <seanjc@goo=
gle.com> wrote:
> > >
> > > ...
> > > cold.  I poked around a bit to see how we could avoid reinventing all=
 of that
> > > infrastructure for fd-only memory, and the best idea I could come up =
with is
> > > basically a rehash of Kirill's very original "KVM protected memory" R=
FC[3], i.e.
> > > allow "mapping" fd-only memory, but ensure that memory is never actua=
lly present
> > > from hardware's perspective.
> > >
> >
> > I am most likely missing a lot of context here and possibly venturing
> > into an infeasible/already shot down direction here.
>
> Both :-)
>
> > But I would still like to get this discussed here before we move on.
> >
> > I am wondering if it would make sense to implement
> > restricted_mem/guest_mem file to expose both private and shared memory
> > regions, inline with Kirill's original proposal now that the file
> > implementation is controlled by KVM.
> >
> > Thinking from userspace perspective:
> > 1) Userspace creates guest mem files and is able to mmap them but all
> > accesses to these files result into faults as no memory is allowed to
> > be mapped into userspace VMM pagetables.
>
> Never mapping anything into the userspace page table is infeasible.  Tech=
nically
> it's doable, but it'd effectively require all of the work of an fd-based =
approach
> (and probably significantly more), _and_ it'd require touching core mm co=
de.
>
> VMAs don't provide hva=3D>pfn information, they're the kernel's way of im=
plementing
> the abstraction provided to userspace by mmap(), mprotect() etc.  Among m=
any other
> things, a VMA describes properties of what is mapped, e.g. hugetblfs vers=
us
> anonymous, where memory is mapped (virtual address), how memory is mapped=
, e.g.
> RWX protections, etc.  But a VMA doesn't track the physical address, that=
 info
> is all managed through the userspace page tables.
>
> To make it possible to allow userspace to mmap() but not access memory (w=
ithout
> redoing how the kernel fundamentally manages virtual=3D>physical mappings=
), the
> simplest approach is to install PTEs into userspace page tables, but neve=
r mark
> them Present in hardware, i.e. prevent actually accessing the backing mem=
ory.
> This is is exactly what Kirill's series in link [3] below implemented.
>

Maybe it's simpler to do when mmaped regions are backed with files.

I see that shmem has fault handlers for accesses to VMA regions
associated with the files, In theory a file implementation can always
choose to not allocate physical pages for such faults (similar to
F_SEAL_FAULT_AUTOALLOCATE that was discussed earlier).

> Issues that led to us abandoning the "map with special !Present PTEs" app=
roach:
>
>  - Using page tables, i.e. hardware defined structures, to track gfn=3D>p=
fn mappings
>    is inefficient and inflexible compared to software defined structures,=
 especially
>    for the expected use cases for CoCo guests.
>
>  - The kernel wouldn't _easily_ be able to enforce a 1:1 page:guest assoc=
iation,
>    let alone a 1:1 pfn:gfn mapping.

Maybe KVM can ensure that each page of the guest_mem file is
associated with a single memslot. HVAs when they are registered can be
associated with offsets into guest_mem files.

>
>  - Does not work for memory that isn't backed by 'struct page', e.g. if d=
evices
>    gain support for exposing encrypted memory regions to guests.
>
>  - Poking into the VMAs to convert memory would be likely be less perform=
ant due
>    to using infrastructure that is much "heavier", e.g. would require tak=
ing
>    mmap_lock for write.

Converting memory doesn't necessarily need to poke holes into VMA, but
rather just unmap pagetables just like what would happen when mmapped
files are punched to free the backing file offsets.

>
> In short, shoehorning this into mmap() requires fighting how the kernel w=
orks at
> pretty much every step, and in the end, adding e.g. fbind() is a lot easi=
er.
>
> > 2) Userspace registers mmaped HVA ranges with KVM with additional
> > KVM_MEM_PRIVATE flag
> > 3) Userspace converts memory attributes and this memory conversion
> > allows userspace to access shared ranges of the file because those are
> > allowed to be faulted in from guest_mem. Shared to private conversion
> > unmaps the file ranges from userspace VMM pagetables.
> > 4) Granularity of userspace pagetable mappings for shared ranges will
> > have to be dictated by KVM guest_mem file implementation.
> >
> > Caveat here is that once private pages are mapped into userspace view.
> >
> > Benefits here:
> > 1) Userspace view remains consistent while still being able to use HVA =
ranges
> > 2) It would be possible to use HVA based APIs from userspace to do
> > things like binding.
> > 3) Double allocation wouldn't be a concern since hva ranges and gpa
> > ranges possibly map to the same HPA ranges.
>
> #3 isn't entirely correct.  If a different process (call it "B") maps sha=
red memory,
> and then the guest converts that memory from shared to private, the backi=
ng pages
> for the previously shared mapping will still be mapped by process B unles=
s userspace
> also ensures process B also unmaps on conversion.
>

This should be ideally handled by something like: unmap_mapping_range()

> #3 is also a limiter.  E.g. if a guest is primarly backed by 1GiB pages, =
keeping
> the 1GiB mapping is desirable if the guest converts a few KiB of memory t=
o shared,
> and possibly even if the guest converts a few MiB of memory.

This caveat maybe can be lived with as shared ranges most likely will
not be backed by 1G pages anyways, possibly causing IO performance to
get hit. This possibly needs more discussion about conversion
granularity used by guests.

>
> > > Code is available here if folks want to take a look before any kind o=
f formal
> > > posting:
> > >
> > >         https://github.com/sean-jc/linux.git x86/kvm_gmem_solo
> > >
> > > [1] https://lore.kernel.org/all/ff5c5b97-acdf-9745-ebe5-c6609dd6322e@=
google.com
> > > [2] https://lore.kernel.org/all/20230418-anfallen-irdisch-6993a61be10=
b@brauner
> > > [3] https://lore.kernel.org/linux-mm/20200522125214.31348-1-kirill.sh=
utemov@linux.intel.com
