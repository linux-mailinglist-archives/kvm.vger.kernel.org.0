Return-Path: <kvm+bounces-68388-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 3E1FCD3864F
	for <lists+kvm@lfdr.de>; Fri, 16 Jan 2026 20:59:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id AE1EB300268A
	for <lists+kvm@lfdr.de>; Fri, 16 Jan 2026 19:59:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5BCD93A1E67;
	Fri, 16 Jan 2026 19:59:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="wMnVInOM"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60D1A345736
	for <kvm@vger.kernel.org>; Fri, 16 Jan 2026 19:59:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768593561; cv=none; b=mll1JKmP6xv6DqHmRK71epKJLE2ew10c2SlGvAnSx5pLCtleaijmnp88xrAgYWiEZ2p5RqJatM9GppJseUqepoD1NY9ZJyGrMz5wjtV3sItfKLkwDSmFaeevBp6nRbM+sHt8uAOJjBeI0DxZjNRm/KIAnJEjpXAYvoFDGXpfgGc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768593561; c=relaxed/simple;
	bh=sm9bqjRyyBx1tfK/mmWy/rukH0wRuwoGD1nMV2WjmCE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=q/dlbm/U5IA6JVGDN7akr6W8sbUWiIzGyvOka3F2/pVyKaaAkk4S1DhSiWhyAYXNKs0BD/jsO8Ak1TfB/MLSHGnc71K+0zFO3NFEG19N29Uo0WKkxBh4i1YFDFu4oJsxpNLakSpjbzHQ8cx/3/rmgPt7IHWK3b82VQme5X9WcDw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=wMnVInOM; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-c56848e6f53so1365842a12.0
        for <kvm@vger.kernel.org>; Fri, 16 Jan 2026 11:59:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768593560; x=1769198360; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=CmVsGRS74zmdjEMM07LPVm6eWi6uP63Jcf4CCC+8B3s=;
        b=wMnVInOMzuKu66V/7Gl6NWjMzI7mV9TFmmb/BVtCDr2GDa2InJTlGxGlVPbhIj96SZ
         Tl5/7Z0ksW7h7gjGyXDH0umToCi4DYy1wl5kztv1fZCzhGO35Z67gZiCGbuh+Jd3q2qO
         l7RvFy448uW7qkVqjkz0aBV9DnJ84Zt+W2z8y16JnEBQlkZlTnHK7rlZ/HlHO8MsJsos
         AawRFpy3WephlnIND/kO6aD4ue0aLp5/a419YZosCV24cQMPts9f3r6DHpp2KQ7L06HN
         vLbSwya+BEY84RVwxslx4zehAejxR3PXOLrUHKIaW5odX40sFU+KqnzAog6GT4JUw85v
         Ienw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768593560; x=1769198360;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CmVsGRS74zmdjEMM07LPVm6eWi6uP63Jcf4CCC+8B3s=;
        b=JxNN0sga6+5ycwOqs3QWnCOFaKFK1UAix/05WXUC49JIdO+fJylHaK0LtiN7ojCb+U
         FGaJJaJ80DCACkA0pbiZMFz6Re9AoESLTjK7oeRloGBTwsCwjIc2TjIQv/8T7Gqr+iG/
         a3sPBNo64Qrx/zHkZgVegcEZbdOk9yzvaThS1YY5iz90K6bIRmuOdjpu5P3rTMbjBUzJ
         ZJH1pk6iJ+MNIdSGfb/ftX6D3NeZxtiWFRIgZnBvaD9XcIC9n7EDqJRXZfJxki5wK8t3
         owQ/7k7SChHd+5wJkzFMGuB+2fWmL8r2YiwSq0gJ5BMRTgkdDwlSlK4kSZl3cHFOWmvZ
         O6Tw==
X-Forwarded-Encrypted: i=1; AJvYcCXJhnHxuKOWvKeG1tMuFM/Errby4Ss1tBKdm+GF4tB8bhN24Vqa4QtxdF7tPkFPRJo6TpY=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz5guoyDwKItQctPH7JUbbRqouFbowRJiZNZWlqYmr4/u6T3ThX
	rhJAd6lXxGBSEliCjV7TwBJ90iOgvMBq676m4lMiPISSUlyoUuv/I8QVopKLhlSkbrvPOgrcLMM
	NZWfYyg==
X-Received: from plko12.prod.google.com ([2002:a17:902:6b0c:b0:29e:fb92:99f6])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:2c0c:b0:2a0:9970:13fd
 with SMTP id d9443c01a7336-2a7176cda67mr43766535ad.43.1768593559703; Fri, 16
 Jan 2026 11:59:19 -0800 (PST)
Date: Fri, 16 Jan 2026 11:59:17 -0800
In-Reply-To: <1b236a64-d511-49a2-9962-55f4b1eb08e3@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <CAEvNRgHSm0k2hthxLPg8oXO_Y9juA9cxOBp2YdFFYOnDkxpv5g@mail.gmail.com>
 <aWbkcRshLiL4NWZg@yzhao56-desk.sh.intel.com> <aWbwVG8aZupbHBh4@google.com>
 <aWdgfXNdBuzpVE2Z@yzhao56-desk.sh.intel.com> <aWe1tKpFw-As6VKg@google.com>
 <f4240495-120b-4124-b91a-b365e45bf50a@intel.com> <aWgyhmTJphGQqO0Y@google.com>
 <435b8d81-b4de-4933-b0ae-357dea311488@intel.com> <aWpyA0_r_yVewnfx@google.com>
 <1b236a64-d511-49a2-9962-55f4b1eb08e3@intel.com>
Message-ID: <aWqYlXg4CS6vxS-o@google.com>
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
> On 1/16/26 09:14, Sean Christopherson wrote:
> > If you want to assert that the pfn is compatible with TDX, then by
> > all means.  But I am NOT accepting any more KVM code that assumes
> > TDX memory is backed by refcounted struct page.  If I had been
> > paying more attention when the initial TDX series landed, I would
> > have NAK'd that too.
> I'm kinda surprised by that. The only memory we support handing into TDs
> for private memory is refcounted struct page. I can imagine us being
> able to do this with DAX pages in the near future, but those have
> 'struct page' too, and I think they're refcounted pretty normally now as
> well.
> 
> The TDX module initialization is pretty tied to NUMA nodes, too. If it's
> in a NUMA node, the TDX module is told about it and it also universally
> gets a 'struct page'.
> 
> Is there some kind of memory that I'm missing? What else *is* there? :)

I don't want to special case TDX on the backend of KVM's MMU.  There's already
waaaay too much code and complexity in KVM that exists purely for S-EPT.  Baking
in assumptions on how _exactly_ KVM is managing guest memory goes too far.

The reason I'm so hostile towards struct page is that, as evidenced by this series
and a ton of historical KVM code, assuming that memory is backed by struct page is
a _very_ slippery slope towards code that is extremely nasty to unwind later on.

E.g. see all of the effort that ended up going into commit ce7b5695397b ("KVM: TDX:
Drop superfluous page pinning in S-EPT management").  And in this series, the
constraints that will be placed on guest_memfd if TDX assumes hugepages will always
be covered in a single folio.  Untangling KVM's historical (non-TDX) messes around
struct page took us something like two years.

And so to avoid introducing similar messes in the future, I don't want KVM's MMU
to make _any_ references to struct page when it comes to mapping memory into the
guest unless it's absolutely necessary, e.g. to put a reference when KVM _knows_
it acquired a refcounted page via gup() (and ideally we'd kill even that, e.g.
by telling gup() not to bump the refcount in the first place).

> > tdh_mem_page_aug() is just an absurdly slow way of writing a PTE.  It doesn't
> > _need_ the pfn to be backed a struct page, at all.  IMO, what you're asking for
> > is akin to adding a pile of unnecessary assumptions to e.g. __set_spte() and
> > __kvm_tdp_mmu_write_spte().  No thanks.
> 
> Which part is absurdly slow?

The SEAMCALL itself.  I'm saying that TDH_MEM_PAGE_AUG is really just the S-EPT
version of "make this PTE PRESENT", and that piling on sanity checks that aren't
fundamental to TDX shouldn't be done when KVM is writing PTEs.

In other words, something like this is totally fine:

	KVM_MMU_WARN_ON(!tdx_is_convertible_pfn(pfn));

but this is not:

	WARN_ON_ONCE(!page_mapping(pfn_to_page(pfn)));

