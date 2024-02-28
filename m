Return-Path: <kvm+bounces-10225-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2A69E86AC5C
	for <lists+kvm@lfdr.de>; Wed, 28 Feb 2024 11:48:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1C5F21C2214E
	for <lists+kvm@lfdr.de>; Wed, 28 Feb 2024 10:48:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0D03613B29F;
	Wed, 28 Feb 2024 10:48:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Dhw6xsfW"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com [209.85.167.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9028F137C24
	for <kvm@vger.kernel.org>; Wed, 28 Feb 2024 10:48:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709117294; cv=none; b=gT6r4iebt6pze681jx80BrohzF50krhrUD/7gQkABaNqPZkSW5eXMa5M+AB8o+IweJ6OCJRtuwTPIf/PTUOhPBWY/f2taTJ+GuPpRGKZo8MprsNp88VYzP7rhmoB1WqYjYojSItWVCCoyW3BPaZHCffUtP3DBZkEt5rILY1pZN8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709117294; c=relaxed/simple;
	bh=bIvwPx5I/0CAZu6imCUxeHBF8u5xuCD6MWr2XnPSMEI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Si+gfmbqhlhtxhVMZTTOEsTq0WPniS3BoIBGXs5iypqFSvg6XhJL8wuRKZLNyKyGf2iyXVyfb6/Ricj5tro5LBDT2njdHnofZv141H664uptyXvbOjFGdrB7PwwB1EzFBg1XqpfAFuFSIbbxoGtp0sTtCpzsyY861xpShd7k/YU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Dhw6xsfW; arc=none smtp.client-ip=209.85.167.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-lf1-f49.google.com with SMTP id 2adb3069b0e04-512f6f263a6so3408584e87.2
        for <kvm@vger.kernel.org>; Wed, 28 Feb 2024 02:48:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1709117291; x=1709722091; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=yd5yZnBCJWOehzR8Dz9CIlcYtWtgp41lO7eq7h9zZG4=;
        b=Dhw6xsfW6u/7oF2axOvMS/GMpssGwYyA68yDoiMSlLDRd8tmQnQ9cjxxD1zK2VeZKq
         YyqyGiHg0Lo42Uy0hbnhFJn6KOgltZPNZ9tH2M0KHdw+6sjCVwgII/sSgOvhiTCJZ7ue
         12yqASRSbY9Lppuegus2ykUKjUy+ojjjLVtNPzALi41FOkcpMMQVGLezNIL9sFHsXoaf
         AaYYmSRlYE5ajwGqZ8nQCJD6Q901jfN/az7Iv6ilcOnFjJ9SohNRzL2lqPjBp3pjGCqK
         hAoNcXEKqr0oL9tkfgvyMNMiXa789E3zR3GEn3c9kdQFt0tfQPrPN0s5YBr7kqO4GPCL
         GKlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709117291; x=1709722091;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yd5yZnBCJWOehzR8Dz9CIlcYtWtgp41lO7eq7h9zZG4=;
        b=P2dZUKlc9EX/04Qkn3K9lMjSTpTHT2q2aePsKbWVY91fINjITUrhDjC7rYjpupDrft
         6X9KA1kJvfzlaIpETW8NuYLa1DT+p9mNS9DWc3SkKkqhe+NHSJBu5YL3FitS1JD57Np4
         96ixHrtLZqkD7NtDdK/8fHSMCB3ExWnpweCHxvfZO3E7OuH4GK4QiJPlslXclujvEIQ5
         7PV0REOhV/dvEefY1t9kVZlzXKhaaK4KsN/568FFoM4Q/03lbvfkHL0KdqhszSLaV6bb
         +iC4YI7Egk6Gyzf3A0CMrR928AccnwxGYOlbFBu5mOHhTxaQnEa5A/afI7y4MHrH2hjy
         axvw==
X-Forwarded-Encrypted: i=1; AJvYcCX9ZcQlk4DDassQCjyAgsHYOB30M0Z3SdqLMhp8cn9zrRlblZr88FBddq+0InST0PN06rLwIGm5CAJUK1Y8FbDDCLDy
X-Gm-Message-State: AOJu0Yx+fW0O08MWB1d1+2PGAYp1Lc7CdVNQSt38FJnp1YhWhviXhq9a
	OASu2vuVUckFMa7Vwd3568Q9hBzMyVjZPaBs6ivdFUW5SDXF9CDM3XHu17n0aw==
X-Google-Smtp-Source: AGHT+IGoxuPozYt3D8BINxx33cesSkYKSOCaHEVHz4LSd6TJAMaSCsPyZuksu5xQE/r8xD99uCOcCQ==
X-Received: by 2002:ac2:5fc1:0:b0:512:b075:4a25 with SMTP id q1-20020ac25fc1000000b00512b0754a25mr7438780lfg.41.1709117290522;
        Wed, 28 Feb 2024 02:48:10 -0800 (PST)
Received: from google.com (64.227.90.34.bc.googleusercontent.com. [34.90.227.64])
        by smtp.gmail.com with ESMTPSA id hs39-20020a1709073ea700b00a43815bf5edsm1688444ejc.133.2024.02.28.02.48.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Feb 2024 02:48:09 -0800 (PST)
Date: Wed, 28 Feb 2024 10:48:03 +0000
From: Quentin Perret <qperret@google.com>
To: David Hildenbrand <david@redhat.com>
Cc: Matthew Wilcox <willy@infradead.org>, Fuad Tabba <tabba@google.com>,
	kvm@vger.kernel.org, kvmarm@lists.linux.dev, pbonzini@redhat.com,
	chenhuacai@kernel.org, mpe@ellerman.id.au, anup@brainfault.org,
	paul.walmsley@sifive.com, palmer@dabbelt.com, aou@eecs.berkeley.edu,
	seanjc@google.com, viro@zeniv.linux.org.uk, brauner@kernel.org,
	akpm@linux-foundation.org, xiaoyao.li@intel.com, yilun.xu@intel.com,
	chao.p.peng@linux.intel.com, jarkko@kernel.org, amoorthy@google.com,
	dmatlack@google.com, yu.c.zhang@linux.intel.com,
	isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz,
	vannapurve@google.com, ackerleytng@google.com,
	mail@maciej.szmigiero.name, michael.roth@amd.com,
	wei.w.wang@intel.com, liam.merwick@oracle.com,
	isaku.yamahata@gmail.com, kirill.shutemov@linux.intel.com,
	suzuki.poulose@arm.com, steven.price@arm.com,
	quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com,
	quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com,
	quic_pderrin@quicinc.com, quic_pheragu@quicinc.com,
	catalin.marinas@arm.com, james.morse@arm.com, yuzenghui@huawei.com,
	oliver.upton@linux.dev, maz@kernel.org, will@kernel.org,
	keirf@google.com, linux-mm@kvack.org
Subject: Re: folio_mmapped
Message-ID: <Zd8PY504BOwMR4jO@google.com>
References: <20240222161047.402609-1-tabba@google.com>
 <20240222141602976-0800.eberman@hu-eberman-lv.qualcomm.com>
 <ZdfoR3nCEP3HTtm1@casper.infradead.org>
 <40a8fb34-868f-4e19-9f98-7516948fc740@redhat.com>
 <20240226105258596-0800.eberman@hu-eberman-lv.qualcomm.com>
 <925f8f5d-c356-4c20-a6a5-dd7efde5ee86@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <925f8f5d-c356-4c20-a6a5-dd7efde5ee86@redhat.com>

On Tuesday 27 Feb 2024 at 15:59:37 (+0100), David Hildenbrand wrote:
> > 
> > Ah, this was something I hadn't thought about. I think both Fuad and I
> > need to update our series to check the refcount rather than mapcount
> > (kvm_is_gmem_mapped for Fuad, gunyah_folio_lend_safe for me).
> 
> An alternative might be !folio_mapped() && !folio_maybe_dma_pinned(). But
> checking for any unexpected references might be better (there are still some
> GUP users that don't use FOLL_PIN).

As a non-mm person I'm not sure to understand to consequences of holding
a GUP pin to a page that is not covered by any VMA. The absence of VMAs
imply that userspace cannot access the page right? Presumably the kernel
can't be coerced into accessing that page either? Is that correct?

> At least concurrent migration/swapout (that temporarily unmaps a folio and
> can give you folio_mapped() "false negatives", which both take a temporary
> folio reference and hold the page lock) should not be a concern because
> guest_memfd doesn't support that yet.
> 
> > 
> > > 
> > > Now, regarding the original question (disallow mapping the page), I see the
> > > following approaches:
> > > 
> > > 1) SIGBUS during page fault. There are other cases that can trigger
> > >     SIGBUS during page faults: hugetlb when we are out of free hugetlb
> > >     pages, userfaultfd with UFFD_FEATURE_SIGBUS.
> > > 
> > > -> Simple and should get the job done.
> > > 
> > > 2) folio_mmapped() + preventing new mmaps covering that folio
> > > 
> > > -> More complicated, requires an rmap walk on every conversion.
> > > 
> > > 3) Disallow any mmaps of the file while any page is private
> > > 
> > > -> Likely not what you want.
> > > 
> > > 
> > > Why was 1) abandoned? I looks a lot easier and harder to mess up. Why are
> > > you trying to avoid page faults? What's the use case?
> > > 
> > 
> > We were chatting whether we could do better than the SIGBUS approach.
> > SIGBUS/FAULT usually crashes userspace, so I was brainstorming ways to
> > return errors early. One difference between hugetlb and this usecase is
> > that running out of free hugetlb pages isn't something we could detect
> 
> With hugetlb reservation one can try detecting it at mmap() time. But as
> reservations are not NUMA aware, it's not reliable.
> 
> > at mmap time. In guest_memfd usecase, we should be able to detect when
> > SIGBUS becomes possible due to memory being lent to guest.
> > 
> > I can't think of a reason why userspace would want/be able to resume
> > operation after trying to access a page that it shouldn't be allowed, so
> > SIGBUS is functional. The advantage of trying to avoid SIGBUS was
> > better/easier reporting to userspace.
> 
> To me, it sounds conceptually easier and less error-prone to
> 
> 1) Converting a page to private only if there are no unexpected
>    references (no mappings, GUP pins, ...)
> 2) Disallowing mapping private pages and failing the page fault.
> 3) Handling that small race window only (page lock?)
> 
> Instead of
> 
> 1) Converting a page to private only if there are no unexpected
>    references (no mappings, GUP pins, ...) and no VMAs covering it where
>    we could fault it in later
> 2) Disallowing mmap when the range would contain any private page
> 3) Handling races between mmap and page conversion

The one thing that makes the second option cleaner from a userspace
perspective (IMO) is that the conversion to private is happening lazily
during guest faults. So whether or not an mmapped page can indeed be
accessed from userspace will be entirely undeterministic as it depends
on the guest faulting pattern which userspace is entirely unaware of.
Elliot's suggestion would prevent spurious crashes caused by that
somewhat odd behaviour, though arguably sane userspace software
shouldn't be doing that to start with.

To add a layer of paint to the shed, the usage of SIGBUS for
something that is really a permission access problem doesn't feel
appropriate. Allocating memory via guestmem and donating that to a
protected guest is a way for userspace to voluntarily relinquish access
permissions to the memory it allocated. So a userspace process violating
that could, IMO, reasonably expect a SEGV instead of SIGBUS. By the
point that signal would be sent, the page would have been accounted
against that userspace process, so not sure the paging examples that
were discussed earlier are exactly comparable. To illustrate that
differently, given that pKVM and Gunyah use MMU-based protection, there
is nothing architecturally that prevents a guest from sharing a page
back with Linux as RO. Note that we don't currently support this, so I
don't want to conflate this use case, but that hopefully makes it a
little more obvious that this is a "there is a page, but you don't
currently have the permission to access it" problem rather than "sorry
but we ran out of pages" problem.

Thanks,
Quentin

