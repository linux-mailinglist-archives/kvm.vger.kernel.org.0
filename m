Return-Path: <kvm+bounces-7871-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 573A6847C8F
	for <lists+kvm@lfdr.de>; Fri,  2 Feb 2024 23:55:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C151E1F22B11
	for <lists+kvm@lfdr.de>; Fri,  2 Feb 2024 22:55:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5052812C7EA;
	Fri,  2 Feb 2024 22:55:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Y1k3j84f"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EDD1126F21
	for <kvm@vger.kernel.org>; Fri,  2 Feb 2024 22:54:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706914500; cv=none; b=apML9Y4lzyzKun4HWqNwXFHJA/+1ZsNOdEl8W3VaTop9h7Vm20TY1Nn1UGhM5pAgMT820HTVNPVlWRsiW1ftjKBM8HmMNrXmtxdd8MaieUyWsIjTnXk9w1aH6WM4IdiSc2VDaNzU81EIiI9bR0736+6It1OGTgTqpY1eB7/PBhk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706914500; c=relaxed/simple;
	bh=xLLdVjR78iCftIzXlIU+GT2WV5TXzmzQM7wql3RHWCw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=GlWSIemXYza5LcQrEsLiq6px6CRqjfdoXv+0B7voSErv/9ROBrwayG+/Xxkd0Q2BrDMyQC3kf7ckQreJwe8r7fxPwpy5cBIXlhjYvAPB5S6GEG+M6almP7d1yDwtQthZRIDf3b0DgY7qUebVQhINC0uoyJ01QmMFRA6+XZVt1gw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Y1k3j84f; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-dc6b26783b4so3260200276.0
        for <kvm@vger.kernel.org>; Fri, 02 Feb 2024 14:54:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1706914497; x=1707519297; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=yST2IhC4x7xwue5FLDSVPscgeSgsqzoau2hWHl8C2YI=;
        b=Y1k3j84fCd633LqyR0hVxmIdmrKm6oZGatKJ3KeIOCfhS/I0SKtsGPx/ZEUdu7N37k
         xIXcx654xNekPT8N14ASSbiM0a7BM7XJpaUN8brqbDwAGPJl4YSxgXaBEqB3U32aMTzj
         l8jn8BIsnzxQG0Ir6cB0GgtdDNrZ1+wvi9eXAyqYJHfxc3PZbK+1AVRc/xMFtt6DOGa3
         GQ3+cOYOMQDhfRrY9yzEe9clvycBacHjisoQeNNrSZEZmM9PDpk4mwGFQxFBWW6MfRX0
         dfWY1QqNqLl1dl7/7GykG5Ga6Y7B/ScfU5dXBowt0l7IMfc3H2M0GqkYcn20lXwtvf5z
         cS6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706914497; x=1707519297;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yST2IhC4x7xwue5FLDSVPscgeSgsqzoau2hWHl8C2YI=;
        b=VVY89tLTmwG6Lb/QCq9PsxpkapWw5qRlf2DvyA1/0rf3JrR9Nv4O3aIFpoWOFGDm0u
         B/m8cCKIpAiMaEZBNEqK6kuhJ6YFjUxe4EK552p4dxsNb4IakMENpd6XmL6ACXFHqz/n
         BaoKRMxFqRTQKBBDinjnrZMz78Vog9caFvxsho1Za00bDdwdY7yASMkVWI6W2R1L170o
         pYaai5A6QTUZ2sM0bYRtTkMn3Crbymej4CehLKKho7FUDdM2bxDnmNrfOAzBaJJLViF2
         WmhZ7nWNrGWFBv1ZJM3ar2+c170hMvw9zhUxlF/VDXrvPnw8/rjy3niKqQXrmNUbV9vK
         UhxQ==
X-Gm-Message-State: AOJu0YyNs1r5zbrhqpFOvrLouuUS0XeZCWTNPfLrpHeKevBoRwdWS4st
	2xsLn5ZFneeFdXDAmdSZ09nkQ8qqheSmy+ACgylvUdUwUaaITB36q635O7KO6VUwfy3tjjNlawY
	9Cg==
X-Google-Smtp-Source: AGHT+IHpo//SwtMaQHEuaxSujjkaLfTq03FTpTzav293FCFg3laEeYePeMZVtQBRLJICB1llqkhzIf5zGgs=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:993:b0:dc2:25fd:eff1 with SMTP id
 bv19-20020a056902099300b00dc225fdeff1mr234713ybb.4.1706914497040; Fri, 02 Feb
 2024 14:54:57 -0800 (PST)
Date: Fri, 2 Feb 2024 14:54:55 -0800
In-Reply-To: <20240116041457.wver7acnwthjaflr@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231230172351.574091-1-michael.roth@amd.com> <20231230172351.574091-19-michael.roth@amd.com>
 <ZZ67oJwzAsSvui5U@google.com> <20240116041457.wver7acnwthjaflr@amd.com>
Message-ID: <Zb1yv67h6gkYqqv9@google.com>
Subject: Re: [PATCH v11 18/35] KVM: SEV: Add KVM_SEV_SNP_LAUNCH_UPDATE command
From: Sean Christopherson <seanjc@google.com>
To: Michael Roth <michael.roth@amd.com>
Cc: kvm@vger.kernel.org, linux-coco@lists.linux.dev, linux-mm@kvack.org, 
	linux-crypto@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org, 
	tglx@linutronix.de, mingo@redhat.com, jroedel@suse.de, 
	thomas.lendacky@amd.com, hpa@zytor.com, ardb@kernel.org, pbonzini@redhat.com, 
	vkuznets@redhat.com, jmattson@google.com, luto@kernel.org, 
	dave.hansen@linux.intel.com, slp@redhat.com, pgonda@google.com, 
	peterz@infradead.org, srinivas.pandruvada@linux.intel.com, 
	rientjes@google.com, dovmurik@linux.ibm.com, tobin@ibm.com, bp@alien8.de, 
	vbabka@suse.cz, kirill@shutemov.name, ak@linux.intel.com, tony.luck@intel.com, 
	sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com, 
	jarkko@kernel.org, ashish.kalra@amd.com, nikunj.dadhania@amd.com, 
	pankaj.gupta@amd.com, liam.merwick@oracle.com, zhi.a.wang@intel.com, 
	Brijesh Singh <brijesh.singh@amd.com>
Content-Type: text/plain; charset="us-ascii"

On Mon, Jan 15, 2024, Michael Roth wrote:
> On Wed, Jan 10, 2024 at 07:45:36AM -0800, Sean Christopherson wrote:
> > On Sat, Dec 30, 2023, Michael Roth wrote:
> > > diff --git a/Documentation/virt/kvm/x86/amd-memory-encryption.rst b/Documentation/virt/kvm/x86/amd-memory-encryption.rst
> > > index b1beb2fe8766..d4325b26724c 100644
> > > --- a/Documentation/virt/kvm/x86/amd-memory-encryption.rst
> > > +++ b/Documentation/virt/kvm/x86/amd-memory-encryption.rst
> > > @@ -485,6 +485,34 @@ Returns: 0 on success, -negative on error
> > >  
> > >  See the SEV-SNP specification for further detail on the launch input.
> > >  
> > > +20. KVM_SNP_LAUNCH_UPDATE
> > > +-------------------------
> > > +
> > > +The KVM_SNP_LAUNCH_UPDATE is used for encrypting a memory region. It also
> > > +calculates a measurement of the memory contents. The measurement is a signature
> > > +of the memory contents that can be sent to the guest owner as an attestation
> > > +that the memory was encrypted correctly by the firmware.
> > > +
> > > +Parameters (in): struct  kvm_snp_launch_update
> > > +
> > > +Returns: 0 on success, -negative on error
> > > +
> > > +::
> > > +
> > > +        struct kvm_sev_snp_launch_update {
> > > +                __u64 start_gfn;        /* Guest page number to start from. */
> > > +                __u64 uaddr;            /* userspace address need to be encrypted */
> > 
> > Huh?  Why is KVM taking a userspace address?  IIUC, the address unconditionally
> > gets translated into a gfn, so why not pass a gfn?
> > 
> > And speaking of gfns, AFAICT start_gfn is never used.
> 
> I think having both the uaddr and start_gfn parameters makes sense. I
> think it's only awkward because how I'm using the memslot to translate
> the uaddr to a GFN in the current implementation,

Yes.

> > Oof, reading more of the code, this *requires* an effective in-place copy-and-convert
> > of guest memory.
> 
> Yes, I'm having some trouble locating the various threads, but initially
> there were some discussions about having a userspace API that allows for
> UPM/gmem pages to be pre-populated before they are in-place encrypted, but
> we'd all eventually decided that having KVM handle this internally was
> the simplest approach.
> 
> So that's how it's done here, KVM_SNP_LAUNCH_UPDATE copies the pages into
> gmem, then passes those pages on to firmware for encryption. Then the
> VMM is expected to mark the GFN range as private via
> KVM_SET_MEMORY_ATTRIBUTES, since the VMM understands what constitutes
> initial private/encrypted payload. I should document that better in
> KVM_SNP_LAUNCH_UPDATE docs however.

That's fine.  As above, my complaints are that the unencrypted source *must* be
covered by a memslot.  That's beyond ugly.

> > What's "the IMI"?  Initial Measurement Image?  I assume this is essentially just
> > a flag that communicates whether or not the page should be measured?
> 
> This is actually for loading a measured migration agent into the target
> system so that it can handle receiving the encrypted guest data from the
> source. There's still a good deal of planning around how live migration
> will be handled however so if you think it's premature to expose this
> via KVM I can remove the related fields.

Yes, please.  Though FWIW, I honestly hope KVM_SEV_SNP_LAUNCH_UPDATE goes away
and we end up with a common uAPI for populating guest memory:

https://lore.kernel.org/all/Zbrj5WKVgMsUFDtb@google.com

> > > +                __u8 page_type;         /* page type */
> > > +                __u8 vmpl3_perms;       /* VMPL3 permission mask */
> > > +                __u8 vmpl2_perms;       /* VMPL2 permission mask */
> > > +                __u8 vmpl1_perms;       /* VMPL1 permission mask */
> > 
> > Why?  KVM doesn't support VMPLs.
> 
> It does actually get used by the SVSM.

> I can remove these but then we'd need some capability bit or something to
> know when they are available if they get re-introduced.

_If_.  We don't merge dead code, and we _definitely_ don't merge dead code that
creates ABI.

> > > +		kvaddr = pfn_to_kaddr(pfns[i]);
> > > +		if (!virt_addr_valid(kvaddr)) {
> > 
> > I really, really don't like that this assume guest_memfd is backed by struct page.
> 
> There are similar enforcements in the SEV/SEV-ES code. There was some
> initial discussion about relaxing this for SNP so we could support
> things like /dev/mem-mapped guest memory, but then guest_memfd came
> along and made that to be an unlikely use-case in the near-term given
> that it relies on alloc_pages() currently and explicitly guards against
> mmap()'ing pages in userspace.
> 
> I think it makes to keep the current tightened restrictions in-place
> until such a use-case comes along, since otherwise we are relaxing a
> bunch of currently-useful sanity checks that span all throughout the code
> to support some nebulous potential use-case that might never come along.
> I think it makes more sense to cross that bridge when we get there.

I disagree.  You say "sanity checks", while I see a bunch of arbitrary assumptions
that don't need to exist.  Yes, today guest_memfd always uses struct page memory,
but that should have _zero_ impact on SNP.  Arbitrary assumptions often cause a
lot of confusion for future readers, e.g. a few years from now, if the above code
still exists, someone might wonder what is so special about struct page memory,
and then waste a bunch of time trying to figure out that there's no technical
reason SNP "requires" struct page memory.

This is partly why I was pushing for guest_memfd to handle some of this; the
gmem code _knows_ what backing type it's using, it _knows_ if the direct map is
valid, etc.

> > > +			pr_err("Invalid HVA 0x%llx for GFN 0x%llx\n", (uint64_t)kvaddr, gfn);
> > > +			ret = -EINVAL;
> > > +			goto e_release;
> > > +		}
> > > +
> > > +		ret = kvm_read_guest_page(kvm, gfn, kvaddr, 0, PAGE_SIZE);
> > 
> > Good gravy.  If I'm reading this correctly, KVM:
> > 
> >   1. Translates an HVA into a GFN.
> >   2. Gets the PFN for that GFN from guest_memfd
> >   3. Verifies the PFN is not assigned to the guest
> >   4. Copies memory from the shared memslot page to the guest_memfd page
> >   5. Converts the page to private and asks the PSP to encrypt it
> > 
> > (a) As above, why is #1 a thing?
> 
> Yah, it's probably best to avoid this, as proposed above.
> 
> > (b) Why are KVM's memory attributes never consulted?
> 
> It doesn't really matter if the attributes are set before or after
> KVM_SNP_LAUNCH_UPDATE, only that by the time the guest actually launches
> they pages get set to private so they get faulted in from gmem. We could
> document our expectations and enforce them here if that's preferable
> however. Maybe requiring KVM_SET_MEMORY_ATTRIBUTES(private) in advance
> would make it easier to enforce that userspace does the right thing.
> I'll see how that looks if there are no objections.

Userspace owns whether a page is PRIVATE or SHARED, full stop.  If KVM can't
honor that, then we need to come up with better uAPI.

> > (c) What prevents TOCTOU issues with respect to the RMP?
> 
> Time-of-use will be when the guest faults the gmem page in with C-bit
> set. If it is not in the expected Guest-owned/pre-validated state that
> SEV_CMD_SNP_LAUNCH_UPDATE expected/set, then the guest will get an RMP
> fault or #VC exception for unvalidated page access. It will also fail
> attestation. Not sure if that covers the scenarios you had in mind.

I don't think this covers what I was asking, but I suspect my concern will go
away once the new APIs come along, so let's table this for now.

> 
> > (d) Why is *KVM* copying memory into guest_memfd?
> 
> As mentioned above, there were various discussions of ways of allowing
> userspace to pwrite() to the guest_memfd in advance of
> "sealing"/"binding" it and then encrypting it in place. I think this was
> one of the related threads:
> 
>   https://lore.kernel.org/linux-mm/YkyKywkQYbr9U0CA@google.com/
> 
> My read at the time was that the requirements between pKVM/TDX/SNP were all
> so unique that we'd spin forever trying to come up with a userspace ABI
> that worked for everyone. At the time you'd suggested for pKVM to handle
> their specific requirements internally in pKVM to avoid unecessary churn on
> TDX/SNP side, and I took the same approach with SNP in implementing it
> internally in SNP's KVM interfaces since it seemed unlikely there would
> be much common ground with how TDX handles it via KVM_TDX_INIT_MEM_REGION.

Yeah, the whole "intra-memslot copy" thing threw me.

> > (e) What guarantees the direct map is valid for guest_memfd?
> 
> Are you suggesting this may change in the near-term?

I asking because, when I asked, I was unaware that the plan was to shatter the
direct to address the 2MiB vs. 4KiB erratum (as opposed to unmapping guest_memfd
pfns).

> > > +		if (ret) {
> > > +			pr_err("SEV-SNP launch update failed, ret: 0x%x, fw_error: 0x%x\n",
> > > +			       ret, *error);
> > > +			snp_page_reclaim(pfns[i]);
> > > +
> > > +			/*
> > > +			 * When invalid CPUID function entries are detected, the firmware
> > > +			 * corrects these entries for debugging purpose and leaves the
> > > +			 * page unencrypted so it can be provided users for debugging
> > > +			 * and error-reporting.
> > > +			 *
> > > +			 * Copy the corrected CPUID page back to shared memory so
> > > +			 * userpsace can retrieve this information.
> > 
> > Why?  IIUC, this is basically backdooring reads/writes into guest_memfd to avoid
> > having to add proper mmap() support.
> 
> The CPUID page is private/encrypted, so it needs to be a gmem page.
> SNP firmware is doing the backdooring when it writes the unencrypted,
> expected contents into the page during failure. What's wrong with copying
> the contents back into the source page so userspace can be use of it?
> If we implement the above-mentioned changes then the source page is just
> a userspace buffer that isn't necessarily associated with a memslot, so
> it becomes even more straightforward.
> 
> Would that be acceptable?

Yes, I am specifically complaining about writing guest memory on failure, which is
all kinds of weird.

> > > +	kvfree(pfns);
> > 
> > Saving PFNs from guest_memfd, which is fully owned by KVM, is so unnecessarily
> > complex.  Add a guest_memfd API (or three) to do this safely, e.g. to lock the
> > pages, do (and track) the RMP conversion, etc...
> 
> Is adding 3 gmem APIs and tracking RMP states inside gmem really less
> complex than what's going on here?

I think we covered this in PUCK?  Holler if you still have questions here.

