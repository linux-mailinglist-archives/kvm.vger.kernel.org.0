Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B5CE6FE65C
	for <lists+kvm@lfdr.de>; Wed, 10 May 2023 23:39:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235583AbjEJVjY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 May 2023 17:39:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230016AbjEJVjW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 May 2023 17:39:22 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21C163A80
        for <kvm@vger.kernel.org>; Wed, 10 May 2023 14:39:21 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id d2e1a72fcca58-64885aeed30so632990b3a.1
        for <kvm@vger.kernel.org>; Wed, 10 May 2023 14:39:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1683754760; x=1686346760;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pvMo88ZxTu4JSemHWRpCdEPpg2ynZCnKfs0n5ONEGjQ=;
        b=CeJmhLiVeMl/SalaT3UbgWDd6VZbKL0myvmAHYqsphIPwK8cGR848wCnLDAuc7yd1I
         zELWkkT3aTqEiAbKdsf2hUs2GkeJ5MiWLGlN7rfO7jK+hivnkfmWMO8Ru5GlsM6lceBE
         yO+HEbccZlJDHHuIKD8xBhM0otHLjuZ67zmdfokxtRJYJROWpRI+2/9vi3RZDuK4uZmI
         zSwmnX/xQDN/QXBlGizERLvYFs4nZgznpyz4aAHbuxFw+Kw4pUjqkzZDmWVoUZFsx+Ul
         mFwv1sCMTb345np8OlMSroX5+ovzXWZzMYE7RVmfr6ZfnFfQfI789o8jit9LcGvg/eAD
         66eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683754760; x=1686346760;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=pvMo88ZxTu4JSemHWRpCdEPpg2ynZCnKfs0n5ONEGjQ=;
        b=BAK7MVnVaec6i4bEhoYa5xI/HlVqXRolG3yW0zwjk1QQOBAlE03YrfPf30IUuPwCYK
         QvGSghRx3+I81Wcxnk0BzE0L/tatDEBqYgNxgQwWmXg9MzTMBx+KxuAE8JXtCZ1URii9
         q9A5y/XZOt1OZ3xQPu6a3PJNqRLbOYOZtVt1G80tCVTvVYpXTnUr3D5jU+Z+j7NyGg0r
         VD0PUIuj1PZ4fR6b4qJJn4d4fFBzyT9OVwDa58QaSHohbQYKky6YaQjtnJaluyKoLl84
         afopDQZDSuotNQfmZwqY/macAbi7jKOD5F3wS5P1zYX3SYyu3IWyCunxjIMQ6WRdNgg6
         EcRA==
X-Gm-Message-State: AC+VfDy1yM5ZjHPhLXZmM4TDEktYguqIy8ohDvP8gKZB3KfU/php8eyH
        4ZiC2COmk7ocK1rXoKKfpSy53czDqyU=
X-Google-Smtp-Source: ACHHUZ5vj9DFK0NhJYCWC3eWM91MVLeZUtPl8EkfA8521q2N+H8FD8crn4+g5/DykvygR1tXhlUlPIZU59U=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:7c9:b0:643:78c0:ec65 with SMTP id
 n9-20020a056a0007c900b0064378c0ec65mr4990145pfu.5.1683754760622; Wed, 10 May
 2023 14:39:20 -0700 (PDT)
Date:   Wed, 10 May 2023 14:39:18 -0700
In-Reply-To: <CAGtprH_+bF4VZg2ps6CM8vjJVvShsvSGAvaLfTedts4cKqhSUw@mail.gmail.com>
Mime-Version: 1.0
References: <ZD1oevE8iHsi66T2@google.com> <658018f9-581c-7786-795a-85227c712be0@redhat.com>
 <ZD12htq6dWg0tg2e@google.com> <1ed06a62-05a1-ebe6-7ac4-5b35ba272d13@redhat.com>
 <ZD2bBB00eKP6F8kz@google.com> <9efef45f-e9f4-18d1-0120-f0fc0961761c@redhat.com>
 <ZD86E23gyzF6Q7AF@google.com> <5869f50f-0858-ab0c-9049-4345abcf5641@redhat.com>
 <ZEM5Zq8oo+xnApW9@google.com> <CAGtprH_+bF4VZg2ps6CM8vjJVvShsvSGAvaLfTedts4cKqhSUw@mail.gmail.com>
Message-ID: <ZFwPBqGeW+d9xMEs@google.com>
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
> On Fri, Apr 21, 2023 at 6:33=E2=80=AFPM Sean Christopherson <seanjc@googl=
e.com> wrote:
> >
> > ...
> > cold.  I poked around a bit to see how we could avoid reinventing all o=
f that
> > infrastructure for fd-only memory, and the best idea I could come up wi=
th is
> > basically a rehash of Kirill's very original "KVM protected memory" RFC=
[3], i.e.
> > allow "mapping" fd-only memory, but ensure that memory is never actuall=
y present
> > from hardware's perspective.
> >
>=20
> I am most likely missing a lot of context here and possibly venturing
> into an infeasible/already shot down direction here.

Both :-)

> But I would still like to get this discussed here before we move on.
>=20
> I am wondering if it would make sense to implement
> restricted_mem/guest_mem file to expose both private and shared memory
> regions, inline with Kirill's original proposal now that the file
> implementation is controlled by KVM.
>=20
> Thinking from userspace perspective:
> 1) Userspace creates guest mem files and is able to mmap them but all
> accesses to these files result into faults as no memory is allowed to
> be mapped into userspace VMM pagetables.

Never mapping anything into the userspace page table is infeasible.  Techni=
cally
it's doable, but it'd effectively require all of the work of an fd-based ap=
proach
(and probably significantly more), _and_ it'd require touching core mm code=
.

VMAs don't provide hva=3D>pfn information, they're the kernel's way of impl=
ementing
the abstraction provided to userspace by mmap(), mprotect() etc.  Among man=
y other
things, a VMA describes properties of what is mapped, e.g. hugetblfs versus
anonymous, where memory is mapped (virtual address), how memory is mapped, =
e.g.
RWX protections, etc.  But a VMA doesn't track the physical address, that i=
nfo
is all managed through the userspace page tables.

To make it possible to allow userspace to mmap() but not access memory (wit=
hout
redoing how the kernel fundamentally manages virtual=3D>physical mappings),=
 the
simplest approach is to install PTEs into userspace page tables, but never =
mark
them Present in hardware, i.e. prevent actually accessing the backing memor=
y.
This is is exactly what Kirill's series in link [3] below implemented.

Issues that led to us abandoning the "map with special !Present PTEs" appro=
ach:

 - Using page tables, i.e. hardware defined structures, to track gfn=3D>pfn=
 mappings
   is inefficient and inflexible compared to software defined structures, e=
specially
   for the expected use cases for CoCo guests.

 - The kernel wouldn't _easily_ be able to enforce a 1:1 page:guest associa=
tion,
   let alone a 1:1 pfn:gfn mapping.
=20
 - Does not work for memory that isn't backed by 'struct page', e.g. if dev=
ices
   gain support for exposing encrypted memory regions to guests.

 - Poking into the VMAs to convert memory would be likely be less performan=
t due
   to using infrastructure that is much "heavier", e.g. would require takin=
g
   mmap_lock for write.

In short, shoehorning this into mmap() requires fighting how the kernel wor=
ks at
pretty much every step, and in the end, adding e.g. fbind() is a lot easier=
.

> 2) Userspace registers mmaped HVA ranges with KVM with additional
> KVM_MEM_PRIVATE flag
> 3) Userspace converts memory attributes and this memory conversion
> allows userspace to access shared ranges of the file because those are
> allowed to be faulted in from guest_mem. Shared to private conversion
> unmaps the file ranges from userspace VMM pagetables.
> 4) Granularity of userspace pagetable mappings for shared ranges will
> have to be dictated by KVM guest_mem file implementation.
>=20
> Caveat here is that once private pages are mapped into userspace view.
>=20
> Benefits here:
> 1) Userspace view remains consistent while still being able to use HVA ra=
nges
> 2) It would be possible to use HVA based APIs from userspace to do
> things like binding.
> 3) Double allocation wouldn't be a concern since hva ranges and gpa
> ranges possibly map to the same HPA ranges.

#3 isn't entirely correct.  If a different process (call it "B") maps share=
d memory,
and then the guest converts that memory from shared to private, the backing=
 pages
for the previously shared mapping will still be mapped by process B unless =
userspace
also ensures process B also unmaps on conversion.

#3 is also a limiter.  E.g. if a guest is primarly backed by 1GiB pages, ke=
eping
the 1GiB mapping is desirable if the guest converts a few KiB of memory to =
shared,
and possibly even if the guest converts a few MiB of memory.

> > Code is available here if folks want to take a look before any kind of =
formal
> > posting:
> >
> >         https://github.com/sean-jc/linux.git x86/kvm_gmem_solo
> >
> > [1] https://lore.kernel.org/all/ff5c5b97-acdf-9745-ebe5-c6609dd6322e@go=
ogle.com
> > [2] https://lore.kernel.org/all/20230418-anfallen-irdisch-6993a61be10b@=
brauner
> > [3] https://lore.kernel.org/linux-mm/20200522125214.31348-1-kirill.shut=
emov@linux.intel.com
