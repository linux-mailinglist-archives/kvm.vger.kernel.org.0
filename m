Return-Path: <kvm+bounces-68101-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 71D66D21D69
	for <lists+kvm@lfdr.de>; Thu, 15 Jan 2026 01:19:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 6A50D302CF43
	for <lists+kvm@lfdr.de>; Thu, 15 Jan 2026 00:19:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 580968287E;
	Thu, 15 Jan 2026 00:19:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="MwAaTfOD"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52CEC1397
	for <kvm@vger.kernel.org>; Thu, 15 Jan 2026 00:19:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768436362; cv=none; b=sbFZHEtQ/6yNuAWd9OmZVjLP0oVTiCK3dTwdvM09i6VQkPgNam7BE4k9vwZrNlzMNyMh5IOmY0JHdbIGNjAYmGe9qEY1JoCWigBJ9plNl3wm1QGnvcfD3vtddrFCPCJgzTBN4YSObXulCy7GHUGE5y5ZUqTo3GoPc3MlYjR9ItA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768436362; c=relaxed/simple;
	bh=9OJ7Bv6EmPT04u7hksmUAJ9D2DTfAs/+5EMvZVUoIQQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=EN38BSHmYvi/FbTLOlEwhS8PEOL5CESLDDSzSYDWveHElpS4bRZq7mfpPykv2LyP5uy0wuOhdkQ9D8LVWDHm+7CS/LY+G8NtgqSNeau9WZ3wdpx57oroHtULJPYPrzBBRouerL+hscw1PB+p7TeS9jzh0WO9CtibRMBzkTXrOi0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=MwAaTfOD; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2a090819ed1so2290415ad.2
        for <kvm@vger.kernel.org>; Wed, 14 Jan 2026 16:19:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768436361; x=1769041161; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=XXs7JrUDbBtoVcfFWKUiB6HLb56edwyCJBhI/Mr8b0I=;
        b=MwAaTfODNJ9vr+kuwK879daP5Gb6tbPftLn1uLZL9rC2sZKckFKlVra7FwHLm+UbV0
         yjN08AWSyz23Z078oZID7BoUiXQa0BWmzAL/OCWa2THoglmaKS46413MCA6Cibysm+rB
         nCCaOlB55V/VkYvJJzWZ7XRIKizdMINIm4ilR1ylYAK5wOISHP0nHwHkuAEarHXTyWFo
         Wp5AA59d1E/dk1fpiLGGHCBx3p0Dw2JAkQ3JNlaJIpMTGoU8uF8uXrKG6RIbco+hYqQ3
         Rgh51RBTnVlLVCTlgNckwgmU7RPnig+mVe0rSnE5zLDOyEvW9/PPjabNYzXHZKe0qd3p
         SEWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768436361; x=1769041161;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XXs7JrUDbBtoVcfFWKUiB6HLb56edwyCJBhI/Mr8b0I=;
        b=uyR5IyhkK7dr5KFYmpeLH6092flHEuEHwnRGyWlNXZkFtUd3ynz1a5kJb/u/qj0Hc9
         GiHnfWEuYr42W2p+7WwbdIZ1C7ILOPmWSjGgf6wbRaHpv27FBbMtIVION3R1PKY0J9Mz
         JthudVUY8YRwjAfDMh5kXA5Ya51Kwr0GFhO8k6TyIxD2BcxcmQAs1P+Gy5QpuYIM19ws
         EWwrmO2p2sN944ai6vfwc9ZRa4lZrMTYOH6L+cF8igdxaishxsmpddB2hyH7PW5SSuhs
         hoqaS9NKlFWdhddTso4NUTqX2i9F5A0dWSbUVeMrWTV4EprsRXdo4bq9PbMzi5K3+iC+
         rS4g==
X-Forwarded-Encrypted: i=1; AJvYcCX84aJ/WfxCG2r8hGONxoVqbViOVqKkVnnMCiZxlaTPH2wFCn+gxKiY9MG6LYvztZRH/sY=@vger.kernel.org
X-Gm-Message-State: AOJu0YzgyDAQOObo90d8+w4UAeWx2fukCvhgYdOUyfKY3BlH5tW+YkHu
	RZqMIaoSI7Vwd+Tzhi3823JnVGZaXhBlDG3HLo8mI2dIeAwNuE2Oh5pNiSrZgq2W39kab2kH1Fx
	QubTmtA==
X-Received: from pjbpv8.prod.google.com ([2002:a17:90b:3c88:b0:34c:d9a0:3bf6])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:11cc:b0:2a0:be5d:d53d
 with SMTP id d9443c01a7336-2a599ea7c5dmr43733585ad.53.1768436360589; Wed, 14
 Jan 2026 16:19:20 -0800 (PST)
Date: Wed, 14 Jan 2026 16:19:18 -0800
In-Reply-To: <f4240495-120b-4124-b91a-b365e45bf50a@intel.com>
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
 <aWdgfXNdBuzpVE2Z@yzhao56-desk.sh.intel.com> <aWe1tKpFw-As6VKg@google.com> <f4240495-120b-4124-b91a-b365e45bf50a@intel.com>
Message-ID: <aWgyhmTJphGQqO0Y@google.com>
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

On Wed, Jan 14, 2026, Dave Hansen wrote:
> On 1/14/26 07:26, Sean Christopherson wrote:
> ...
> > Dave may feel differently, but I am not going to budge on this.  I am not going
> > to bake in assumptions throughout KVM about memory being backed by page+folio.
> > We _just_ cleaned up that mess in the aformentioned "Stop grabbing references to
> > PFNMAP'd pages" series, I am NOT reintroducing such assumptions.
> > 
> > NAK to any KVM TDX code that pulls a page or folio out of a guest_memfd pfn.
> 
> 'struct page' gives us two things: One is the type safety, but I'm
> pretty flexible on how that's implemented as long as it's not a raw u64
> getting passed around everywhere.

I don't necessarily disagree on the type safety front, but for the specific code
in question, any type safety is a facade.  Everything leading up to the TDX code
is dealing with raw PFNs and/or PTEs.  Then the TDX code assumes that the PFN
being mapped into the guest is backed by a struct page, and that the folio size
is consistent with @level, without _any_ checks whatsover.  This is providing
the exact opposite of safety.

  static int tdx_mem_page_aug(struct kvm *kvm, gfn_t gfn,
			    enum pg_level level, kvm_pfn_t pfn)
  {
	int tdx_level = pg_level_to_tdx_sept_level(level);
	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
	struct page *page = pfn_to_page(pfn);    <==================
	struct folio *folio = page_folio(page);
	gpa_t gpa = gfn_to_gpa(gfn);
	u64 entry, level_state;
	u64 err;

	err = tdh_mem_page_aug(&kvm_tdx->td, gpa, tdx_level, folio,
			       folio_page_idx(folio, page), &entry, &level_state);

	...
  }

I've no objection if e.g. tdh_mem_page_aug() wants to sanity check that a PFN
is backed by a struct page with a valid refcount, it's code like that above that
I don't want.

> The second thing is a (near) guarantee that the backing memory is RAM.
> Not only RAM, but RAM that the TDX module knows about and has a PAMT and
> TDMR and all that TDX jazz.

I'm not at all opposed to backing guest_memfd with "struct page", quite the
opposite.  What I don't want is to bake assumptions into KVM code that doesn't
_require_ struct page, because that has cause KVM immense pain in the past.

And I'm strongly opposed to KVM special-casing TDX or anything else, precisely
 because we struggled through all that pain so that KVM would work better with
memory that isn't backed by "struct page", or more specifically, memory that has
an associated "struct page", but isn't managed by core MM, e.g. isn't refcounted.

> We've also done things like stopping memory hotplug because you can't
> amend TDX page metadata at runtime. So we prevent new 'struct pages'
> from coming into existence. So 'struct page' is a quite useful choke
> point for TDX.
> 
> I'd love to hear more about how guest_memfd is going to tie all the
> pieces together and give the same straightforward guarantees without
> leaning on the core mm the same way we do now.

I don't think guest_memfd needs to be different, and that's not what I'm advocating.
What I don't want is to make KVM TDX's handling of memory different from the rest
of KVM and KVM's MMU(s).

