Return-Path: <kvm+bounces-68345-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id EBDCBD378D4
	for <lists+kvm@lfdr.de>; Fri, 16 Jan 2026 18:19:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 85A3530A9094
	for <lists+kvm@lfdr.de>; Fri, 16 Jan 2026 17:14:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B574E2DF12F;
	Fri, 16 Jan 2026 17:14:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Ym1ebSHF"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C8DF18E1F
	for <kvm@vger.kernel.org>; Fri, 16 Jan 2026 17:14:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768583686; cv=none; b=V7OZlj3EPdtybYQYxW2dNWoLzW1Nkq4OfUPVr3VyTzb74ntniaLEkNzDQDEnijhErMcnqhAdAe1t6l4URkhFMuG9+1ct1Zb2QCF0DWwdCg/O07/sqo8Iwm5aAyeBqQl9/q8q855HYdBYapxd4e6jWW5sfGFP0gOhx9AeH88i5aQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768583686; c=relaxed/simple;
	bh=HcsgQ8ddYvGnAaJjNR8u67lt5UzdJilH0JEzFChaOw4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=KO0HuhBr3/yGNvgNDqQn4LU7ZJ3Gkv4BhFJC0GjyWeooSZY6h3qmcmQw/9AkQKFtK0xKvTPXMZ4ySGIJLUZAQFTHAyJNf0HidmNXLx/9XMJpC0DRLgRkCWWEPcZO0K2/22VFBBH4mzrtisPWTHGCb1x3SA6ooTMKp9kJTVencF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Ym1ebSHF; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-34c704d5d15so3788999a91.1
        for <kvm@vger.kernel.org>; Fri, 16 Jan 2026 09:14:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768583685; x=1769188485; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=fkk10MiugYsvJrQTqX5exO07szvTrlf4fKKTid3Yj4c=;
        b=Ym1ebSHF9KYm8qqvoSbNIrw0axtVQuruWtid3vlbLYKHfmH0o6SZhThdRqYnEfgAZf
         37dVQrwXcSWW/ZVWPtEiVA9s1daY9d9D1jDw+EJULiv2OYKvI5BNTfe09L55oRLEBa3k
         b298RZAialcoFIOAgT7y/cXdkV2yLpVf2ytE3uClNhBxzN1pwkiFuyk/XwKJzhx6wX6+
         4UmEGMqvgyxrFP/4O1GAuNvEULKKEbtwjNSaPEVJxdTX1mZtXdMW3y4c/wBP0ADWbm29
         corlseP0xkQMv/BuO29fmt7+MC+/8uNjNVifhbxokL7NbNS1uXYjvVvv6DpQCMihipFV
         m9bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768583685; x=1769188485;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fkk10MiugYsvJrQTqX5exO07szvTrlf4fKKTid3Yj4c=;
        b=RdX848zvnfyV2B1PNTvIzCMcMRCegFw58KzKtYKZ4AiKwBT/FfHqGUuBlca09Q6VIT
         EdglQgcX2zUrJ+NznlHhR7cG5kvOyj8yT8N4oMGVtnHKv0ZgSKgomKLULtdGNoot9YxL
         UEetFKKYYMwMZVIUiMyRlto0i7ps45c47CU12VRptPrIVW750utuzH7EEWklPmVSfdp1
         9XGwcoZxjqVZHS0bNkeJzbAHsMOnZu7KmU8mwM4x+1KGoqb0IbETWKolw5VmhgYjZ1zg
         lfPhjNOi2cNaoRbrhNXNrijSH9qb99Md80mWufT1FmfIOZ535NFQUnN3zmn57JOmgb7K
         HzWA==
X-Forwarded-Encrypted: i=1; AJvYcCUanqFJ4auoqF9l/M0L4eVUtm0OfXJ/go0eoqQFGoRV8zPXe69scSo0kTCg45yEMoLUBEI=@vger.kernel.org
X-Gm-Message-State: AOJu0YxEJZH0yPqoDf4GOevvjprWfQNyexxJIB0uNA1dwsi0oB/5Tf7T
	7QqYF7JBMZRcuWuCtDt48BCb7TBk+9pa0PDm87TGBHkpzFsk/NFVa5Zwozz/kngdzrxd+n3GrOc
	4qs8xZA==
X-Received: from pjxd20.prod.google.com ([2002:a17:90a:c254:b0:34a:4a21:bc22])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4f86:b0:339:d03e:2a11
 with SMTP id 98e67ed59e1d1-35272efccc2mr3274066a91.14.1768583684779; Fri, 16
 Jan 2026 09:14:44 -0800 (PST)
Date: Fri, 16 Jan 2026 09:14:43 -0800
In-Reply-To: <435b8d81-b4de-4933-b0ae-357dea311488@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <CAEvNRgFOER_j61-3u2dEoYdFMPNKaVGEL_=o2WVHfBi8nN+T0A@mail.gmail.com>
 <aV2eIalRLSEGozY0@google.com> <CAEvNRgHSm0k2hthxLPg8oXO_Y9juA9cxOBp2YdFFYOnDkxpv5g@mail.gmail.com>
 <aWbkcRshLiL4NWZg@yzhao56-desk.sh.intel.com> <aWbwVG8aZupbHBh4@google.com>
 <aWdgfXNdBuzpVE2Z@yzhao56-desk.sh.intel.com> <aWe1tKpFw-As6VKg@google.com>
 <f4240495-120b-4124-b91a-b365e45bf50a@intel.com> <aWgyhmTJphGQqO0Y@google.com>
 <435b8d81-b4de-4933-b0ae-357dea311488@intel.com>
Message-ID: <aWpyA0_r_yVewnfx@google.com>
Subject: Re: [PATCH v3 00/24] KVM: TDX huge page support for private memory
From: Sean Christopherson <seanjc@google.com>
To: Dave Hansen <dave.hansen@intel.com>
Cc: Yan Zhao <yan.y.zhao@intel.com>, Ackerley Tng <ackerleytng@google.com>, 
	Vishal Annapurve <vannapurve@google.com>, pbonzini@redhat.com, linux-kernel@vger.kernel.org, 
	kvm@vger.kernel.org, x86@kernel.org, rick.p.edgecombe@intel.com, 
	kas@kernel.org, tabba@google.com, michael.roth@amd.com, david@kernel.org, 
	sagis@google.com, vbabka@suse.cz, thomas.lendacky@amd.com, 
	nik.borisov@suse.com, pgonda@google.com, fan.du@intel.com, jun.miao@intel.com, 
	francescolavra.fl@gmail.com, jgross@suse.com, ira.weiny@intel.com, 
	isaku.yamahata@intel.com, xiaoyao.li@intel.com, kai.huang@intel.com, 
	binbin.wu@linux.intel.com, chao.p.peng@intel.com, chao.gao@intel.com
Content-Type: text/plain; charset="us-ascii"

On Fri, Jan 16, 2026, Dave Hansen wrote:
> On 1/14/26 16:19, Sean Christopherson wrote:
> >> 'struct page' gives us two things: One is the type safety, but I'm
> >> pretty flexible on how that's implemented as long as it's not a raw u64
> >> getting passed around everywhere.
> > I don't necessarily disagree on the type safety front, but for the specific code
> > in question, any type safety is a facade.  Everything leading up to the TDX code
> > is dealing with raw PFNs and/or PTEs.  Then the TDX code assumes that the PFN
> > being mapped into the guest is backed by a struct page, and that the folio size
> > is consistent with @level, without _any_ checks whatsover.  This is providing
> > the exact opposite of safety.
> > 
> >   static int tdx_mem_page_aug(struct kvm *kvm, gfn_t gfn,
> > 			    enum pg_level level, kvm_pfn_t pfn)
> >   {
> > 	int tdx_level = pg_level_to_tdx_sept_level(level);
> > 	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
> > 	struct page *page = pfn_to_page(pfn);    <==================
> 
> I of course agree that this is fundamentally unsafe, it's just not
> necessarily bad code.
> 
> I hope we both agree that this could be made _more_ safe by, for
> instance, making sure the page is in a zone, pfn_valid(), and a few more
> things.
>
> In a perfect world, these conversions would happen at a well-defined
> layer (KVM=>TDX) and in relatively few places. That layer transition is
> where the sanity checks happen. It's super useful to have:
> 
> struct page *kvm_pfn_to_tdx_private_page(kvm_pfn_t pfn)
> {
> 	struct page *page = pfn_to_page(pfn);
> #ifdef DEBUG
> 	WARN_ON_ONCE(pfn_valid(pfn));
> 	// page must be from a "file"???
> 	WARN_ON_ONCE(!page_mapping(page));
> 	WARN_ON_ONCE(...);
> #endif
> 	return page;
> }
> 
> *EVEN* if the pfn_to_page() itself is unsafe, and even if the WARN()s
> are compiled out, this explicitly lays out the assumptions and it means
> someone reading TDX code has an easier idea comprehending it.

I object to the existence of those assumptions.  Why the blazes does TDX care
how KVM and guest_memfd manages memory?  If you want to assert that the pfn is
compatible with TDX, then by all means.  But I am NOT accepting any more KVM code
that assumes TDX memory is backed by refcounted struct page.  If I had been paying
more attention when the initial TDX series landed, I would have NAK'd that too.

tdh_mem_page_aug() is just an absurdly slow way of writing a PTE.  It doesn't
_need_ the pfn to be backed a struct page, at all.  IMO, what you're asking for
is akin to adding a pile of unnecessary assumptions to e.g. __set_spte() and
__kvm_tdp_mmu_write_spte().  No thanks.

> It's also not a crime to do the *same* checking on kvm_pfn_t and not
> have a type transition. I just like the idea of changing the type so
> that the transition line is clear and the concept is carried (forced,
> even) through the layers of helpers.

