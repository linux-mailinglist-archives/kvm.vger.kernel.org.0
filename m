Return-Path: <kvm+bounces-68421-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 82F46D38AEE
	for <lists+kvm@lfdr.de>; Sat, 17 Jan 2026 01:54:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 08BAE309145A
	for <lists+kvm@lfdr.de>; Sat, 17 Jan 2026 00:54:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4992D1C5D7D;
	Sat, 17 Jan 2026 00:54:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="zQOC+prF"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FFD07640E
	for <kvm@vger.kernel.org>; Sat, 17 Jan 2026 00:53:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768611240; cv=none; b=bhauMeeDnIo1N/zywJJyGhC4kEsKLIahZ5Fdg1nFWiAiZJf1Y1Va5Y7AF7FjXoJ+QUYV5kYnGNR7b2vYbsz7d+d8whgn2mRKDxCo+eo9+rFrzDSA/tVCYEjQMLqVVm2MDLHSiyoSiJWGqx21JBKo2hsotSMOAPcl7u9E+z+ItgQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768611240; c=relaxed/simple;
	bh=KtQbBtkkDfMz+T6TV6Z43Sh0FYs4DtN2nG5zD6O9acc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=OjlHCsL41BwG+ANBPcOlLAJUJka5FES9Z8gMCcP7S61fwPLqTw2YmAAi3nllb6u294HBPN46eCE98nyKgH5RfVAkPi1Z0QR+uWKCmi8EMVBmtW5THacoKMDAC/zvQk6SJB/G1Ga6cT7+b7DZopsMa2Qa1LmAmcepbrGQ1LZIHZs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=zQOC+prF; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-34c21341f56so4848054a91.2
        for <kvm@vger.kernel.org>; Fri, 16 Jan 2026 16:53:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768611238; x=1769216038; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hbXKaJ28UXi7TW5JydnHYQgt5Nu+JSM6PpzNbxX5B/o=;
        b=zQOC+prFNnyg1PioXEVvWkXg3pwmkSB9ctK0uOkEry+lWw0kbSQUTSH8JT/SWTsE6y
         dkv6ZeKzXUoCQAQccs6v7XIRHOe847H35RNfP2MwxHFCwYIM/aCBitxoWFPhncJsXWqk
         K8kzqqRuaWjKCQ4c2j6d3ngQaJaeCOZj1CWElfmLtYpkZQtPEy69bZ4HiW0z2DBHN40F
         jZUlXqi5REobVYhd5HeyGR+TOFs5b3RSNdS0dMJ9FFM+mdUTMVld/MQjIX+Cn9GInogf
         OWNLr5cRybOjCiiufnuh5t53zN177xVtiXOSeHjEOOXxezH4CGC9bkajFnf/77JOCvd2
         02NA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768611238; x=1769216038;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=hbXKaJ28UXi7TW5JydnHYQgt5Nu+JSM6PpzNbxX5B/o=;
        b=MhksgdeZTFKvitelxov0bq1itFAmM3RF79GLuGDnoUIXiEbfN7KLOK4y7pQEg5RT7B
         Cj0HYlebOeS8qSsp21jyVAWFXjjftCaRjLnVksdWVlDTit5J9qijR4fbiTXbW+UxaxSC
         KbgotPYzyn88r2hUzDP1mAL1AZlu7Z0TolX0EaqcGjdsnV4Lt6lUOmJETK94MidSMc6A
         pGF0yV/pH7bWvl273+jNYEtHCNQyzDuPQz46+a/MgADtJLhd4NDc1jDIXXrk61AzXDGC
         85ue+AMEXfDuENJGaSRXLXpkDNyax0rvN/rAaTYpIXB2ZAsGIAV8WfsfbuYyl7q7Q8qZ
         K3iA==
X-Forwarded-Encrypted: i=1; AJvYcCXVuaP5T8qqXWgkkdb5JDc4bCzcXmo9MeWWRv/m9O7sflJeqh9N+mTrhuGt8sKSQoYyoqQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YwHwKJsSorXMKZwaxCBUW5BPwfKLg+i43QrV/LLGo7PDDcKXv5F
	q8piIBUv7n1/KHv0V+ZaT9Kts5o44Pm7rsXBnvap8YFP4X/e7rk9rNeFBW+9x4uwPTqfYImxxY+
	GR9aMhA==
X-Received: from pjsi5.prod.google.com ([2002:a17:90a:65c5:b0:34f:6b95:ea39])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:d647:b0:34c:2db6:57d5
 with SMTP id 98e67ed59e1d1-35272d76fafmr3909741a91.0.1768611238388; Fri, 16
 Jan 2026 16:53:58 -0800 (PST)
Date: Fri, 16 Jan 2026 16:53:57 -0800
In-Reply-To: <20251121005125.417831-12-rick.p.edgecombe@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251121005125.417831-1-rick.p.edgecombe@intel.com> <20251121005125.417831-12-rick.p.edgecombe@intel.com>
Message-ID: <aWrdpZCCDDAffZRM@google.com>
Subject: Re: [PATCH v4 11/16] KVM: TDX: Add x86 ops for external spt cache
From: Sean Christopherson <seanjc@google.com>
To: Rick Edgecombe <rick.p.edgecombe@intel.com>
Cc: bp@alien8.de, chao.gao@intel.com, dave.hansen@intel.com, 
	isaku.yamahata@intel.com, kai.huang@intel.com, kas@kernel.org, 
	kvm@vger.kernel.org, linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org, 
	mingo@redhat.com, pbonzini@redhat.com, tglx@linutronix.de, 
	vannapurve@google.com, x86@kernel.org, yan.y.zhao@intel.com, 
	xiaoyao.li@intel.com, binbin.wu@intel.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 20, 2025, Rick Edgecombe wrote:
> Move mmu_external_spt_cache behind x86 ops.
>=20
> In the mirror/external MMU concept, the KVM MMU manages a non-active EPT
> tree for private memory (the mirror). The actual active EPT tree the
> private memory is protected inside the TDX module. Whenever the mirror EP=
T
> is changed, it needs to call out into one of a set of x86 opts that
> implement various update operation with TDX specific SEAMCALLs and other
> tricks. These implementations operate on the TDX S-EPT (the external).
>=20
> In reality these external operations are designed narrowly with respect t=
o
> TDX particulars. On the surface, what TDX specific things are happening t=
o
> fulfill these update operations are mostly hidden from the MMU, but there
> is one particular area of interest where some details leak through.
>=20
> The S-EPT needs pages to use for the S-EPT page tables. These page tables
> need to be allocated before taking the mmu lock, like all the rest. So th=
e
> KVM MMU pre-allocates pages for TDX to use for the S-EPT in the same plac=
e
> where it pre-allocates the other page tables. It=E2=80=99s not too bad an=
d fits
> nicely with the others.
>=20
> However, Dynamic PAMT will need even more pages for the same operations.
> Further, these pages will need to be handed to the arch/x86 side which us=
ed
> them for DPAMT updates, which is hard for the existing KVM based cache.
> The details living in core MMU code start to add up.
>=20
> So in preparation to make it more complicated, move the external page
> table cache into TDX code by putting it behind some x86 ops. Have one for
> topping up and one for allocation. Don=E2=80=99t go so far to try to hide=
 the
> existence of external page tables completely from the generic MMU, as the=
y
> are currently stored in their mirror struct kvm_mmu_page and it=E2=80=99s=
 quite
> handy.
>=20
> To plumb the memory cache operations through tdx.c, export some of
> the functions temporarily. This will be removed in future changes.
>=20
> Acked-by: Kiryl Shutsemau <kas@kernel.org>
> Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
> ---

NAK.  I kinda sorta get why you did this?  But the pages KVM uses for page =
tables
are KVM's, not to be mixed with PAMT pages.

Eww.  Definitely a hard "no".  In tdp_mmu_alloc_sp_for_split(), the allocat=
ion
comes from KVM:

	if (mirror) {
		sp->external_spt =3D (void *)get_zeroed_page(GFP_KERNEL_ACCOUNT);
		if (!sp->external_spt) {
			free_page((unsigned long)sp->spt);
			kmem_cache_free(mmu_page_header_cache, sp);
			return NULL;
		}
	}

But then in kvm_tdp_mmu_map(), via kvm_mmu_alloc_external_spt(), the alloca=
tion
comes from get_tdx_prealloc_page()

  static void *tdx_alloc_external_fault_cache(struct kvm_vcpu *vcpu)
  {
	struct page *page =3D get_tdx_prealloc_page(&to_tdx(vcpu)->prealloc);

	if (WARN_ON_ONCE(!page))
		return (void *)__get_free_page(GFP_ATOMIC | __GFP_ACCOUNT);

	return page_address(page);
  }

But then regardles of where the page came from, KVM frees it.  Seriously.

  static void tdp_mmu_free_sp(struct kvm_mmu_page *sp)
  {
	free_page((unsigned long)sp->external_spt);  <=3D=3D=3D=3D=3D
	free_page((unsigned long)sp->spt);
	kmem_cache_free(mmu_page_header_cache, sp);
  }

Oh, and the hugepage series also fumbles its topup (why there's yet another
topup API, I have no idea).

  static int tdx_topup_vm_split_cache(struct kvm *kvm, enum pg_level level)
  {
	struct kvm_tdx *kvm_tdx =3D to_kvm_tdx(kvm);
	struct tdx_prealloc *prealloc =3D &kvm_tdx->prealloc_split_cache;
	int cnt =3D tdx_min_split_cache_sz(kvm, level);

	while (READ_ONCE(prealloc->cnt) < cnt) {
		struct page *page =3D alloc_page(GFP_KERNEL);  <=3D=3D=3D=3D GFP_KERNEL_A=
CCOUNT

		if (!page)
			return -ENOMEM;

		spin_lock(&kvm_tdx->prealloc_split_cache_lock);
		list_add(&page->lru, &prealloc->page_list);
		prealloc->cnt++;
		spin_unlock(&kvm_tdx->prealloc_split_cache_lock);
	}

	return 0;
  }

