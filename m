Return-Path: <kvm+bounces-68052-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 728A5D1FC69
	for <lists+kvm@lfdr.de>; Wed, 14 Jan 2026 16:34:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 0426B3127998
	for <lists+kvm@lfdr.de>; Wed, 14 Jan 2026 15:26:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 00E2F39900C;
	Wed, 14 Jan 2026 15:26:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="tcbOKFjv"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A858935580A
	for <kvm@vger.kernel.org>; Wed, 14 Jan 2026 15:26:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768404408; cv=none; b=Orcbf/ymh8/SRBUhLERIZhSd1Am2hUMpxhI3VvBysG3FuEVM8AcjvfW/RTYZ2oaJuS6LSiO9kZe3a3AuC8E1R3DBlXmLEGe5knskGUE7FJxmBAfkxxpgoNjaOAFk/VskEasyZCP2UDoxmsLz1ppmzJFVVUwrdHdGBQZp18zoqAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768404408; c=relaxed/simple;
	bh=Zk8AHOW1nqmj3XG8wr25aGXt2bVTCcnr8RrPSxAXtBU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=k3NpBNx4dnzEOX+PSmlUc5uJyOMV9Lfgo9w9W49W32G5/maYrbBji6S2q7d6eYjGrGtz+OeVRAP1L+kJYIQnI+fGwuwyCCKZASSIKbBf4aQprGBq4ag/EqZQ6de96yX471i51YGE1VoLFbqWVLfzlju21OGRvQ08BsyRa8bfPW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=tcbOKFjv; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-34c5d203988so5884311a91.3
        for <kvm@vger.kernel.org>; Wed, 14 Jan 2026 07:26:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768404406; x=1769009206; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=rWuW7yj9AOg3u7mU/oofVEyA+XCgVgGqbUPGQJHQPmA=;
        b=tcbOKFjvirIl75vTyAllcfzA3Tlwyip3b3I6OZZHFeuH5FhOw1GcunGeQMV8Hf67Ho
         NwyEBRzlRxIlJZdEmsj57AogaWKrjUq7oAiGjWbtE1+C5Pg06T95H/ZVeVbMm/kpljY+
         8SfP/a/PCozFl5k6I/90XxVtzSMwY4PnjVXxHnIAd0QrUgAKuC5wvIj8z+9jZJU6sibY
         FYOnREaIuCnTUN7YSbBktq2fOMuRnjMwoCPbyJ9QRmpKlnB88+eHy93myhuxW31Jc6jR
         uSvYbBnQCnOLdEtwnZ7/UvgkwZLmsWlVJLcQl2hj8u0oRJpVRKKMAwiQfu9wD5Segnd6
         BzeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768404406; x=1769009206;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rWuW7yj9AOg3u7mU/oofVEyA+XCgVgGqbUPGQJHQPmA=;
        b=j6d6RagbYYH+Hs9p/uNultHeFNAfvRVTqtr1qpfZkHMk78KsK60GzVuA3fw7Wp1YDg
         CUE+LfQWA6fxPMziMif3jgbEJuwRA1PJvOM2JHaaXMQ1YZRNFwcM2hAwf/MbSQuW/8rJ
         K5q555f6V4Lj9DlGK1hFCVcmRUh5g2yowAPCnYCNwSJrqIEzIyJKfgAHQAWx/7BPsIDv
         zPm0soNLWcUZWcuEoWBS62eOCslGeqgSJ8mFOjKoId721J0bDQizI9KreUzHbojjGBcv
         BKagALZKBJLP/JnpZoTdIpzrjStoPA1nYV1Gv4EjytbB/+YFroGeLtWkZQv4b5FcdfUz
         pGbA==
X-Forwarded-Encrypted: i=1; AJvYcCVXquIWNcb/t5m8eAopOevCUbzIH2RQ8hYByKmdhS8cEh1kPTD0iftTZUFQMROYKfPug2U=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzvm24WSTyqbDbjZairCSZpFOaffJzAah8WiTCp9xDjuO8Ha8sM
	+zrY1jZY8FrdKsoQEMSg0dHA5qTolUXoVL8PKH3Bo9BWFdDLyyK5N2FvTXE0k2h+NfXjtLrMM93
	tkA0MJQ==
X-Received: from pjbem21.prod.google.com ([2002:a17:90b:155:b0:34a:c87f:a95a])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3808:b0:339:d1f0:c740
 with SMTP id 98e67ed59e1d1-3510b090bf8mr2376655a91.1.1768404405960; Wed, 14
 Jan 2026 07:26:45 -0800 (PST)
Date: Wed, 14 Jan 2026 07:26:44 -0800
In-Reply-To: <aWdgfXNdBuzpVE2Z@yzhao56-desk.sh.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260106101646.24809-1-yan.y.zhao@intel.com> <CAGtprH-eEUzHDUB0CK2V162HHqvE8kT3bAacb6d3xDYJPwBiYA@mail.gmail.com>
 <CAEvNRgGG+xYhsz62foOrTeAxUCYxpCKCJnNgTAMYMV=w2eq+6Q@mail.gmail.com>
 <aV2A39fXgzuM4Toa@google.com> <CAEvNRgFOER_j61-3u2dEoYdFMPNKaVGEL_=o2WVHfBi8nN+T0A@mail.gmail.com>
 <aV2eIalRLSEGozY0@google.com> <CAEvNRgHSm0k2hthxLPg8oXO_Y9juA9cxOBp2YdFFYOnDkxpv5g@mail.gmail.com>
 <aWbkcRshLiL4NWZg@yzhao56-desk.sh.intel.com> <aWbwVG8aZupbHBh4@google.com> <aWdgfXNdBuzpVE2Z@yzhao56-desk.sh.intel.com>
Message-ID: <aWe1tKpFw-As6VKg@google.com>
Subject: Re: [PATCH v3 00/24] KVM: TDX huge page support for private memory
From: Sean Christopherson <seanjc@google.com>
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: Ackerley Tng <ackerleytng@google.com>, Vishal Annapurve <vannapurve@google.com>, pbonzini@redhat.com, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org, 
	rick.p.edgecombe@intel.com, dave.hansen@intel.com, kas@kernel.org, 
	tabba@google.com, michael.roth@amd.com, david@kernel.org, sagis@google.com, 
	vbabka@suse.cz, thomas.lendacky@amd.com, nik.borisov@suse.com, 
	pgonda@google.com, fan.du@intel.com, jun.miao@intel.com, 
	francescolavra.fl@gmail.com, jgross@suse.com, ira.weiny@intel.com, 
	isaku.yamahata@intel.com, xiaoyao.li@intel.com, kai.huang@intel.com, 
	binbin.wu@linux.intel.com, chao.p.peng@intel.com, chao.gao@intel.com
Content-Type: text/plain; charset="us-ascii"

On Wed, Jan 14, 2026, Yan Zhao wrote:
> On Tue, Jan 13, 2026 at 05:24:36PM -0800, Sean Christopherson wrote:
> > On Wed, Jan 14, 2026, Yan Zhao wrote:
> > > For non-gmem cases, KVM uses the mapping size in the primary MMU as the max
> > > mapping size in the secondary MMU, while the primary MMU does not create a
> > > mapping larger than the backend folio size.
> > 
> > Super strictly speaking, this might not hold true for VM_PFNMAP memory.  E.g. a
> > driver _could_ split a folio (no idea why it would) but map the entire thing into
> > userspace, and then userspace could have off that memory to KVM.
> > 
> > So I wouldn't say _KVM's_ rule isn't so much "mapping size <= folio size", it's
> > that "KVM mapping size <= primary MMU mapping size", at least for x86.  Arm's
> > VM_PFNMAP code sketches me out a bit, but on the other hand, a driver mapping
> > discontiguous pages into a single VM_PFNMAP VMA would be even more sketch.
> > 
> > But yes, ignoring VM_PFNMAP, AFAIK the primary MMU and thus KVM doesn't map larger
> > than the folio size.
> 
> Oh. I forgot about the VM_PFNMAP case, which allows to provide folios as the
> backend. Indeed, a driver can create a huge mapping in primary MMU for the
> VM_PFNMAP range with multiple discontiguous pages, if it wants.
> 
> But this occurs before KVM creates the mapping. Per my understanding, pages
> under VM_PFNMAP are pinned,

Nope.  Only the driver that owns the VMAs knows what sits behind the PFN and the
lifecycle rules for that memory.

That last point is *very* important.  Even if the PFNs shoved into VM_PFNMAP VMAs
have an associated "struct page", that doesn't mean the "struct page" is refcounted,
i.e. can be pinned.  That detail was the heart of "KVM: Stop grabbing references to
PFNMAP'd pages" overhaul[*].

To _safely_ map VM_PFNMAP into a secondary MMU, i.e. without relying on (priveleged)
userspace to "do the right thing", the secondary MMU needs to be tied into
mmu_notifiers, so that modifications to the mappings in the primary MMU are
reflected into the secondary MMU.

[*] https://lore.kernel.org/all/20240726235234.228822-1-seanjc@google.com

> so it looks like there're no splits after they are mapped into the primary MMU.
> 
> So, out of curiosity, do you know why linux kernel needs to unmap mappings from
> both primary and secondary MMUs, and check folio refcount before performing
> folio splitting?

Because it's a straightforward rule for the primary MMU.  Similar to guest_memfd,
if something is going through the effort of splitting a folio, then odds are very,
very good that the new folios can't be safely mapped as a contiguous hugepage.
Limiting mapping sizes to folios makes the rules/behavior straightfoward for core
MM to implement, and for drivers/users to understand.

Again like guest_memfd, there needs to be _some_ way for a driver/filesystem to
communicate the maximum mapping size; folios are the "currency" for doing so.

And then for edge cases that want to map a split folio as a hugepage (if any such
edge cases exist), thus take on the responsibility of managing the lifecycle of
the mappings, VM_PFNMAP and vmf_insert_pfn() provide the necessary functionality.
 
> > > When splitting the backend folio, the Linux kernel unmaps the folio from both
> > > the primary MMU and the KVM-managed secondary MMU (through the MMU notifier).
> > > 
> > > On the non-KVM side, though IOMMU stage-2 mappings are allowed to be larger
> > > than folio sizes, splitting folios while they are still mapped in the IOMMU
> > > stage-2 page table is not permitted due to the extra folio refcount held by the
> > > IOMMU.
> > > 
> > > For gmem cases, KVM also does not create mappings larger than the folio size
> > > allocated from gmem. This is why the TDX huge page series relies on gmem's
> > > ability to allocate huge folios.
> > > 
> > > We really need to be careful if we hope to break this long-established rule.
> > 
> > +100 to being careful, but at the same time I don't think we should get _too_
> > fixated on the guest_memfd folio size.  E.g. similar to VM_PFNMAP, where there
> > might not be a folio, if guest_memfd stopped using folios, then the entire
> > discussion becomes moot.
> > 
> > And as above, the long-standing rule isn't about the implementation details so
> > much as it is about KVM's behavior.  If the simplest solution to support huge
> > guest_memfd pages is to decouple the max order from the folio, then so be it.
> > 
> > That said, I'd very much like to get a sense of the alternatives, because at the
> > end of the day, guest_memfd needs to track the max mapping sizes _somewhere_,
> > and naively, tying that to the folio seems like an easy solution.
> Thanks for the explanation.
> 
> Alternatively, how do you feel about the approach of splitting S-EPT first
> before splitting folios?
> If guest_memfd always splits 1GB folios to 2MB first and only splits the
> converted range to 4KB, splitting S-EPT before splitting folios should not
> introduce too much overhead. Then, we can defer the folio size problem until
> guest_memfd stops using folios.
> 
> If the decision is to stop relying on folios for unmapping now, do you think
> the following changes are reasonable for the TDX huge page series?
> 
> - Add WARN_ON_ONCE() to assert that pages are in a single folio in
>   tdh_mem_page_aug().
> - Do not assert that pages are in a single folio in
>   tdh_phymem_page_wbinvd_hkid(). (or just assert of pfn_valid() for each page?)
>   Could you please give me guidance on
>   https://lore.kernel.org/kvm/aWb16XJuSVuyRu7l@yzhao56-desk.sh.intel.com.
> - Add S-EPT splitting in kvm_gmem_error_folio() and fail on splitting error.

Ok, with the disclaimer that I hadn't actually looked at the patches in this
series before now...

TDX absolutely should not be doing _anything_ with folios.  I am *very* strongly
opposed to TDX assuming that memory is backed by refcounted "struct page", and
thus can use folios to glean the maximum mapping size.

guest_memfd is _the_ owner of that information.  guest_memfd needs to explicitly
_tell_ the rest of KVM what the maximum mapping size is; arch code should not
infer that size from a folio.

And that code+behavior already exists in the form of kvm_gmem_mapping_order() and
its users, _and_ is plumbed all the way into tdx_mem_page_aug() as @level.  IIUC,
the _only_ reason tdx_mem_page_aug() retrieves the page+folio is because
tdx_clflush_page() ultimately requires a "struct page".  That is absolutely
ridiculous and not acceptable.  CLFLUSH takes a virtual address, there is *zero*
reason tdh_mem_page_aug() needs to require/assume a struct page.

Dave may feel differently, but I am not going to budge on this.  I am not going
to bake in assumptions throughout KVM about memory being backed by page+folio.
We _just_ cleaned up that mess in the aformentioned "Stop grabbing references to
PFNMAP'd pages" series, I am NOT reintroducing such assumptions.

NAK to any KVM TDX code that pulls a page or folio out of a guest_memfd pfn.

