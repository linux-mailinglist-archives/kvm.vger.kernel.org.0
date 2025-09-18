Return-Path: <kvm+bounces-57990-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 544EDB83CBD
	for <lists+kvm@lfdr.de>; Thu, 18 Sep 2025 11:29:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4CC3B188DF11
	for <lists+kvm@lfdr.de>; Thu, 18 Sep 2025 09:29:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 845B33019A7;
	Thu, 18 Sep 2025 09:29:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="lBXYlN5M"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1892B3002D4
	for <kvm@vger.kernel.org>; Thu, 18 Sep 2025 09:29:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758187757; cv=none; b=o6KqxJdCU8SViC9YX1B2L7MI7yJHEtGfWq9MjZhP6Q3XB6htkvndr8LdxN6utQvsrm7kWLOaf546KN0d7FTjkxDOQiBVsEBH71WMg+jMq4zY6t/LhRFqDheYRSHIH8fbyeEi9pmwgGDmMIjNalbP+1jATddophBLBHtce1wUklc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758187757; c=relaxed/simple;
	bh=lbPL2i1Afubcw+Qs5zLSUx0wWtcDGsQ1FaY6PcJdGfE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=joijt7DRBAT1M8fTOA036cml839ObW4fd2LEfvZpR5sPEmdUfEYd//D/UVcmmnb5ho3EoIiNFalP5rXZ6KAqLOQd2qsR4zqrFHpu9XWGlBIzwcYClMBhY8Zz8B1g+HWIITzbKQABH02IO6GBcaNlopkovGKpd0nZ/d3UBTrslsk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=lBXYlN5M; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-32eaa47c7c8so731173a91.3
        for <kvm@vger.kernel.org>; Thu, 18 Sep 2025 02:29:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758187755; x=1758792555; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=xQDo9EaQ2w3t78/otIEPi+dSfFPSjpELcLYcaQVq7QY=;
        b=lBXYlN5MG+q3dWJM0VkQiBPi5cQe3+28kH+ay7MViy+cjh3HyXgENW1GP2v9Q3rwgO
         sumv7tV6tlSMQ+D4OWWkrrBN1p39Eolhq0ektHh39dIRbY0VCnfj9/NCC1n1Bk8Tz5WX
         hcKEKN7Zp1yhoSIDtJHxHway6/GhZ6VEEgCv+ehiC19ea5T1Yfman6A9icFkFV+ZInT6
         oVZ3ym+w1gCKuWyvy8nlfHzrL9hQkb1PYYq/VlBxBQOOj0xVUZjbp1rVulumW+viu9OP
         yDhdYfDEXqyS6E4Tdgi4EchK5TBoxO+RMWt7zbOtD9kl0k66bCY1XQdpfyyQVHZdJEah
         X80g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758187755; x=1758792555;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xQDo9EaQ2w3t78/otIEPi+dSfFPSjpELcLYcaQVq7QY=;
        b=DTPkbfhhWxuI5u2pygCXkbf7e2ajaYlaA0J13/bL8tb6zZfcAmwrriHRrfKmceJs4j
         rbzQ1j3MfJIbqGNJ7b7h8PSQG+XxUevqPaBD0AoMB8WmpgNl10FtXE0sUUTPwF2IlrU5
         cPaUdlzXRJIDeln7iy6QrQiZzCORd15IHOZlqy4SIqU+PH5dN/r0TFxXNnIkx6iQOTnV
         fNr+D4RQOkhk9FupQMqgkArZqKWCuPCaKNTVjFtbgWmcVw7SoAcvNpsXVkaLURIEuqqB
         +ZqDImwFAvRDG3g2IDrYUvpqv8AtKigJm/t6zszVIRklC7bVeUDXlkvqG/sR42mtoc2j
         si0A==
X-Gm-Message-State: AOJu0Yz4yhc3bnPLQf1hhd+tcRsZJbo5Iifv4dAkL1mgPsrc7v65psTA
	KuW589EWaSUP09ixRR0rf60Awq7UXZRKgIag5iVc56/MftmarZ5+d3gcK48VpkrMR0v4fdic+BQ
	R9VP1glKo6bT/vvaWcfxxn2STeQ==
X-Google-Smtp-Source: AGHT+IFUQkgkuqmfWUG7HDKnuWEBjj0flQA10iJkOzbHKdrj3MYRDVrEP3z7SCj5p8m6zzJiYkILKbi/G2n6kH7QHg==
X-Received: from pjbsi16.prod.google.com ([2002:a17:90b:5290:b0:32e:8ff7:495])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:1b12:b0:330:6d5e:f17e with SMTP id 98e67ed59e1d1-3306d5ef3f6mr1962826a91.24.1758187755343;
 Thu, 18 Sep 2025 02:29:15 -0700 (PDT)
Date: Thu, 18 Sep 2025 09:29:14 +0000
In-Reply-To: <diqzcy7op5wg.fsf@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250613005400.3694904-1-michael.roth@amd.com>
 <20250613005400.3694904-2-michael.roth@amd.com> <diqztt1vf198.fsf@google.com>
 <20250916233335.wv2lf4fiejlw53o2@amd.com> <diqzo6r8p90a.fsf@google.com> <diqzcy7op5wg.fsf@google.com>
Message-ID: <diqza52sp0r9.fsf@google.com>
Subject: Re: [PATCH RFC v1 1/5] KVM: guest_memfd: Remove preparation tracking
From: Ackerley Tng <ackerleytng@google.com>
To: Michael Roth <michael.roth@amd.com>
Cc: kvm@vger.kernel.org, linux-coco@lists.linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, david@redhat.com, tabba@google.com, 
	vannapurve@google.com, ira.weiny@intel.com, thomas.lendacky@amd.com, 
	pbonzini@redhat.com, seanjc@google.com, vbabka@suse.cz, joro@8bytes.org, 
	pratikrajesh.sampat@amd.com, liam.merwick@oracle.com, yan.y.zhao@intel.com, 
	aik@amd.com
Content-Type: text/plain; charset="UTF-8"

Ackerley Tng <ackerleytng@google.com> writes:

> Ackerley Tng <ackerleytng@google.com> writes:
>
>> Michael Roth <michael.roth@amd.com> writes:
>>
>>> On Mon, Aug 25, 2025 at 04:08:19PM -0700, Ackerley Tng wrote:
>>>> Michael Roth <michael.roth@amd.com> writes:
>>>> 
>>>> 
>>>> [...snip...]
>>>> 
>>>> > @@ -435,13 +430,7 @@ static inline void kvm_gmem_mark_prepared(struct folio *folio)
>>>> >  static int kvm_gmem_prepare_folio(struct kvm *kvm, struct kvm_memory_slot *slot,
>>>> >  				  gfn_t gfn, struct folio *folio)
>>>> >  {
>>>> > -	unsigned long nr_pages, i;
>>>> >  	pgoff_t index;
>>>> > -	int r;
>>>> > -
>>>> > -	nr_pages = folio_nr_pages(folio);
>>>> > -	for (i = 0; i < nr_pages; i++)
>>>> > -		clear_highpage(folio_page(folio, i));
>>>> >  
>>>> >  	/*
>>>> >  	 * Preparing huge folios should always be safe, since it should
>>>> > @@ -459,11 +448,8 @@ static int kvm_gmem_prepare_folio(struct kvm *kvm, struct kvm_memory_slot *slot,
>>>> 
>>>> While working on HugeTLB support for guest_memfd, I added a test that
>>>> tries to map a non-huge-page-aligned gmem.pgoff to a huge-page aligned
>>>> gfn.
>>>> 
>>>> I understand that config would destroy the performance advantages of
>>>> huge pages, but I think the test is necessary since Yan brought up the
>>>> use case here [1].
>>>> 
>>>> The conclusion in that thread, I believe, was to allow binding of
>>>> unaligned GFNs to offsets, but disallow large pages in that case. The
>>>> next series for guest_memfd HugeTLB support will include a fix similar
>>>> to this [2].
>>>> 
>>>> While testing, I hit this WARN_ON with a non-huge-page-aligned
>>>> gmem.pgoff.
>>>> 
>>>> >  	WARN_ON(!IS_ALIGNED(slot->gmem.pgoff, 1 << folio_order(folio)));
>>>> 
>>>> Do you all think this WARN_ON can be removed?
>>>
>>> I think so.. I actually ended up dropping this WARN_ON() for a similar
>>> reason:
>>>
>>
>> Thanks for confirming!
>>
>
> Dropping this WARN_ON() actually further highlights the importance of
> separating preparedness from folio flags (and the folio).
>
> With huge pages being supported in guest_memfd, it's possible for just
> part of a folio to be mapped into the stage 2 page tables. One example
> of this is if userspace were to request populating just 2M in a 1G
> page. If preparedness were recorded in folio flags, then the entire 1G
> would be considered prepared even though only 2M of that page was
> prepared (updated in RMP tables).
>
> So I do support making the uptodate flag only mean zeroed, and taking
> preparedness out of the picture.
>
> With this change, kvm_gmem_prepare_folio() and
> __kvm_gmem_prepare_folio() seems to be a misnomer, since conceptually
> we're not preparing a folio, we can't assume that we're always preparing
> a whole folio once huge pages are in the picture.
>
> What do you all think of taking this even further? Instead of keeping
> kvm_gmem_prepare_folio() within guest_memfd, what if we
>
> 1. Focus on preparing pfn ranges (retaining kvm_arch_gmem_prepare() is
>    good) and not folios
>    
> 2. More clearly and directly associate preparing pfns with mapping
>    (rather than with getting a folio to be mapped) into stage 2 page
>    tables
>

Thought about this a little more and maybe this is not quite accurate
either. On a conversion, for SNP, does the memory actually need to be
unmapped from the NPTs, or would it be possible to just flip the C bit?

If conversion only involves flipping the C bit and updating RMP tables,
then perhaps preparation and invalidation shouldn't be associated with
mapping, but directly with conversions, or setting page private/shared
state.


> What I have in mind for (2) is to update kvm_tdp_mmu_map() to do an
> arch-specific call, when fault->is_private, to call
> kvm_arch_gmem_prepare() just before mapping the pfns and when the
> mapping level is known.
>
> The cleanup counterpart would then be to call kvm_arch_gmem_invalidate()
> somewhere in tdp_mmu_zap_leafs().
>
> kvm_arch_gmem_prepare() and kvm_arch_gmem_invalidate() would then drop
> out of guest_memfd and be moved back into the core of KVM.
>
> Technically these two functions don't even need to have gmem in the name
> since any memory can be prepared in the SNP sense, though for the
> foreseeable future gmem is the only memory supported for private memory
> in CoCo VMs.
>
> Also, to push this along a little, I feel that this series does a few
> things. What do you all think of re-focusing this series (or a part of
> this series) as "Separating SNP preparation from guest_memfd" or
> "Separating arch-specific preparation from guest_memfd"?
>
>>> 
>>> [...snip...]
>>> 

