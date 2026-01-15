Return-Path: <kvm+bounces-68195-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id BEDB8D25BDE
	for <lists+kvm@lfdr.de>; Thu, 15 Jan 2026 17:28:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id E6881302BAA5
	for <lists+kvm@lfdr.de>; Thu, 15 Jan 2026 16:26:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D36373B9614;
	Thu, 15 Jan 2026 16:26:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="1pUkNHI4"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75A1D3B9618
	for <kvm@vger.kernel.org>; Thu, 15 Jan 2026 16:26:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768494389; cv=none; b=TyopzvG0c3JUAkuh+Qrtvn1E5lAWqRHCO8UoD5IStfMEpT0aoc8EIriNW8fXf9G1ZTpMwxy6WhyqMp2mfo9TPJVbh1q+RQF/47MvenFShKSAcFzsr19wGnyN/d6HxYtukPO6pH18ii+J3cEeNNwK3fLrcaVNQt9U1A7R9ssoAEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768494389; c=relaxed/simple;
	bh=O9Ec/dFOzt00Qe0E/Y4PV0oguKJYyQ+GkPJ3I10uCF0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=oXKz5BNmIuXoyaGhn0pf18c4ikeNkSC5fw0tdQCr/wuHepotAnynF0kcczvfuCXtrpoHe/iaCGhEa1BQALG3PPNdMCXDHBFnabkOOp67bgbA4tqtIO8XR/HWQ6bLUg5E7hTBlH9QlTk+m4CYZToDcGP24kS2DJaBPSiqyHTRUTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=1pUkNHI4; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-34ab8693a2cso1822635a91.0
        for <kvm@vger.kernel.org>; Thu, 15 Jan 2026 08:26:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768494383; x=1769099183; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Cqob1pqf/0CpEhvrUSjLUn32N0WxHoPxiFVd1xN70ko=;
        b=1pUkNHI4EXfjH8G5Ha5E+hpouQfs1homgMGBOEFxyh8p0kiUSqKTBTNKAuiDhYpOy2
         x5Y0Hcgamrv0PHIQEZ35lTa03M9b23StvcoHIKc06dJ6f4id03Wj7qej0qPFqQoBjAzY
         sdnXUDSjEkYGMRToOAP1sq+Bysdx6kZ5roAiWHoJDY/VFyAlkUCQQus/1Fx7bYIIXii/
         djjc7M0cCwky258xkzb9gnmGHP1THC3xCQJPNYXTrh59eb/guirmRxUw2ibVYCTfyOD7
         DI0AqFjQxR1hXP2yOZjVUkz+QWTDV6Z1QSBmAjdzWlHmjhvX3xL5t+znSLAOmFfPpyTG
         DGTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768494383; x=1769099183;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Cqob1pqf/0CpEhvrUSjLUn32N0WxHoPxiFVd1xN70ko=;
        b=Prtn+udNFnCjsYb0RpaI9Gy3pkXyWzVxHcWTsfWTfRcUj2CEuU+buUmLFdfQCRcmsz
         624d+0mkQAgyU8gyUZddbN5md41q+b/HM7qI2cFCMO3NGVbO/TxDVFg2UEkGXAwufDkv
         GUng30m//p2iW/gQdGMogus2M5Kcex4mCv4KpmUZZAoRuz61T9XAP5N1ACa9/MYyD0rH
         aiWNJ+NwMrbldYVhFn+RqeCBHgmNsZba12dVKgppDiQP8ppjrlPPAazdf0KOp94vh+9T
         s0kk1nSMsUtKuC0EgniDkyJdeC3JKHDy0nzHbJkdY97C4kyqnLIx/tK1iLWmOsVLh9he
         BrAA==
X-Forwarded-Encrypted: i=1; AJvYcCVC9CaNwLSxy0/OQ41y229mt9lJbE34uQknQdZHNjErpx8UTZ7aEwnUfdNfWPZHkkE2E3M=@vger.kernel.org
X-Gm-Message-State: AOJu0YwVpeKsh7Jh4LBIpucVBLAsnhAAVD5lHn0LKdHRmEI1zHYTDmE5
	/mewA8yb9hNPTRi/dkEZe1X7YiHc/UsTsPiJ53U+l7W4WE0ZKdnmnXTu38vD6MpUOF7zkH57lMt
	Mby1fCQ==
X-Received: from pjbft24.prod.google.com ([2002:a17:90b:f98:b0:347:76e2:5ff6])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3943:b0:336:9dcf:ed14
 with SMTP id 98e67ed59e1d1-3510911d394mr7062210a91.23.1768494382813; Thu, 15
 Jan 2026 08:26:22 -0800 (PST)
Date: Thu, 15 Jan 2026 08:26:21 -0800
In-Reply-To: <aWhFwzlqqrnBLLiK@yzhao56-desk.sh.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <CAEvNRgGG+xYhsz62foOrTeAxUCYxpCKCJnNgTAMYMV=w2eq+6Q@mail.gmail.com>
 <aV2A39fXgzuM4Toa@google.com> <CAEvNRgFOER_j61-3u2dEoYdFMPNKaVGEL_=o2WVHfBi8nN+T0A@mail.gmail.com>
 <aV2eIalRLSEGozY0@google.com> <CAEvNRgHSm0k2hthxLPg8oXO_Y9juA9cxOBp2YdFFYOnDkxpv5g@mail.gmail.com>
 <aWbkcRshLiL4NWZg@yzhao56-desk.sh.intel.com> <aWbwVG8aZupbHBh4@google.com>
 <aWdgfXNdBuzpVE2Z@yzhao56-desk.sh.intel.com> <aWe1tKpFw-As6VKg@google.com> <aWhFwzlqqrnBLLiK@yzhao56-desk.sh.intel.com>
Message-ID: <aWkVLViKBgiVGgaI@google.com>
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

On Thu, Jan 15, 2026, Yan Zhao wrote:
> On Wed, Jan 14, 2026 at 07:26:44AM -0800, Sean Christopherson wrote:
> > Ok, with the disclaimer that I hadn't actually looked at the patches in this
> > series before now...
> > 
> > TDX absolutely should not be doing _anything_ with folios.  I am *very* strongly
> > opposed to TDX assuming that memory is backed by refcounted "struct page", and
> > thus can use folios to glean the maximum mapping size.
> > 
> > guest_memfd is _the_ owner of that information.  guest_memfd needs to explicitly
> > _tell_ the rest of KVM what the maximum mapping size is; arch code should not
> > infer that size from a folio.
> > 
> > And that code+behavior already exists in the form of kvm_gmem_mapping_order() and
> > its users, _and_ is plumbed all the way into tdx_mem_page_aug() as @level.  IIUC,
> > the _only_ reason tdx_mem_page_aug() retrieves the page+folio is because
> > tdx_clflush_page() ultimately requires a "struct page".  That is absolutely
> > ridiculous and not acceptable.  CLFLUSH takes a virtual address, there is *zero*
> > reason tdh_mem_page_aug() needs to require/assume a struct page.
> Not really.
> 
> Per my understanding, tdx_mem_page_aug() requires "struct page" (and checks
> folios for huge pages) because the SEAMCALL wrapper APIs are not currently built
> into KVM. Since they may have callers other than KVM, some sanity checking in
> case the caller does something incorrect seems necessary (e.g., in case the
> caller provides an out-of-range struct page or a page with !pfn_valid() PFN).

As a mentioned in my reply to Dave, I don't object to reasonable sanity checks.

> This is similar to "VM_WARN_ON_ONCE_FOLIO(!folio_test_large(folio), folio)" in
> __folio_split().

No, it's not.  __folio_split() is verifying that the input for the exact one thing
it's doing, splitting a huge folio, matches what the function is being asked to do.

TDX requiring guest_memfd to back everything with struct page, and to only use
single, huge folios to map hugepages into the guest is making completely unnecessary
about guest_memfd and KVM MMU implementation details.

> With tdx_mem_page_aug() ensuring pages validity and contiguity,

It absolutely does not.

 - If guest_memfd unmaps the direct map[*], CLFLUSH will fault and panic the
   kernel.
 - If the PFN isn't backed by struct page, tdx_mem_page_aug() will hit a NULL
   pointer deref.
 - If the PFN is back by struct page, but the page is managed by something other
   than guest_memfd or core MM, all bets are off.

[*] https://lore.kernel.org/all/20260114134510.1835-1-kalyazin@amazon.com

> invoking local static function tdx_clflush_page() page-per-page looks good to
> me.  Alternatively, we could convert tdx_clflush_page() to
> tdx_clflush_cache_range(), which receives VA.
> 
> However, I'm not sure if my understanding is correct now, especially since it
> seems like everyone thinks the SEAMCALL wrapper APIs should trust the caller,
> assuming they are KVM-specific.

It's all kernel code.  Implying that KVM is somehow untrusted is absurd.

