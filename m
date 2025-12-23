Return-Path: <kvm+bounces-66626-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 29BAFCDACEC
	for <lists+kvm@lfdr.de>; Wed, 24 Dec 2025 00:12:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 9CE65302628B
	for <lists+kvm@lfdr.de>; Tue, 23 Dec 2025 23:12:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D036230F529;
	Tue, 23 Dec 2025 23:12:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="V36QEEiB"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72E472DCBF4
	for <kvm@vger.kernel.org>; Tue, 23 Dec 2025 23:12:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766531533; cv=none; b=cnh/2CncnUiN9C0vHrVIGP9rdoJPyTisDq4jy7RzsDF9MQ1OIfWOnAzqnJBCx6IHO85l0rqcIsYqo66Wyfzgyq1eg6DqM24Hy2XIJ3oKHvGFQtcITxMNLloTwvd0vEg97h784rJzNvN98qV34e4Rjw+e98IYVA4Sy8arABWMrKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766531533; c=relaxed/simple;
	bh=wN65EApT/ayEKiqDm9SizlLSn1y2MGXxbsfB1NdKD1Q=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=r1HeHk0z93DTNbTc/7+3x6K34O4IKKDz5ejm8am8V4h23ZfWHxfAN1dyemb4lfBX3cUKJaweKmW5hSOaL9knmaYE3MODpCCRvKeVoczcvhLGQOFA6jkWmL2E29M3xTsa+PAYBqKZVs8mYxbeWaGuqkmf/wQ/NgWRExGirK8EjzM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=V36QEEiB; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-34c704d5d15so10618694a91.1
        for <kvm@vger.kernel.org>; Tue, 23 Dec 2025 15:12:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1766531531; x=1767136331; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=xEi01BqSTkmwBMdWxitsf6rmzRbefuQ2j6agJwBYotA=;
        b=V36QEEiBoY7tk/thGw2WCfo/70G7em9yT7CDPAa6yeYO0RUhti9o05Hdu4HOTYIxPJ
         fKCTCww4TrvzU5c4CTivy/MkjEZ/R+Y5LNlGlAjuYcTiKZYJdpwaPpx5BWaxpxE3zjg3
         kjrlavMMZLuybUIaPPkxTcHNrzufR4YBD3yZxgFDiJp2LDeTCcHckG4bujQWjZYnkRaj
         WjNp93jTejshXEOgeQXkV7rY2DUxm6vLWdevcFwu3wmMsBHWuFGxbW0SZCNo8F/lo2Zv
         2kZWLgznVQMSHvzen/rJDwPGKbwYKab8hPOjkj+v40Bv03G37a1td7gUBSGlsI42Kmtp
         p3+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766531531; x=1767136331;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xEi01BqSTkmwBMdWxitsf6rmzRbefuQ2j6agJwBYotA=;
        b=JmbXDWwzm+fhXS+8OKV/Y7SvhUO+1zn9kuCSeaBiKOYzpxgE/DPV5ct1Gj8X6wwoWc
         /0bzkXm33G3cC9uBLgjkAqgwOwT65gKk5t5OtJuMEMUygXT1Wkbxwu3iW8E6iuQTTq0q
         yVnf1RVxOih9x8JdI0VPYPXh4oNNhRVl6XXuh/xJxXja7NqCJcGsfpz95aCvnOjoiozw
         Xf6A9NUc3FWg58POMHIFkj3Hed03JndB1x7Iyg8RQVvIly2xHTswNKvbpT68/I1EegPb
         WsnAkpsAmTXdkPYKb8Imh6TyepNSHWx0PwRMJGk8IG6u+X0dq1jEJrnCXGCYCTfRY8UM
         aBqQ==
X-Forwarded-Encrypted: i=1; AJvYcCWn6QxBVUUQ+8wAgpf8vRz06xkyUVsmqXaizo46ky4cAzgnEwirTdxQQxL5D0FSClnkfBQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YwYdcX2jeWCYv3jrtanZV0lhRKIEpSyXBReps7fMC3jDJfj4dtK
	5cCmG4uNW93aPxSjFBXeDn/9f5Uvq5IotV4CntNpQdaKexeWGcNvgUSSqnDPN2KjFN6jroGiHhZ
	M2SnzDQ==
X-Google-Smtp-Source: AGHT+IFXcGtLUkuoP4M1YIbs/KeL/27Ptmb6aknnvIFt/3xOqhSdSzHhf/AZm5q9iF2IB/zLgoBWxm0Dtnw=
X-Received: from pfht19.prod.google.com ([2002:a62:ea13:0:b0:7f0:64eb:f9fe])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:7349:b0:366:19a5:b492
 with SMTP id adf61e73a8af0-376a75ef489mr13858452637.5.1766531530759; Tue, 23
 Dec 2025 15:12:10 -0800 (PST)
Date: Tue, 23 Dec 2025 15:12:09 -0800
In-Reply-To: <20251127013440.3324671-11-yosry.ahmed@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251127013440.3324671-1-yosry.ahmed@linux.dev> <20251127013440.3324671-11-yosry.ahmed@linux.dev>
Message-ID: <aUshyQad7LjdhYAY@google.com>
Subject: Re: [PATCH v3 10/16] KVM: selftests: Reuse virt mapping functions for
 nested EPTs
From: Sean Christopherson <seanjc@google.com>
To: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Thu, Nov 27, 2025, Yosry Ahmed wrote:
> __tdp_pg_map() bears a lot of resemblence to __virt_pg_map(). The
> main differences are:
> - It uses the EPT struct overlay instead of the PTE masks.
> - It always assumes 4-level EPTs.
> 
> To reuse __virt_pg_map(), initialize the PTE masks in nested MMU with
> EPT PTE masks. EPTs have no 'present' or 'user' bits, so use the
> 'readable' bit instead like shadow_{present/user}_mask, ignoring the
> fact that entries can be present and not readable if the CPU has
> VMX_EPT_EXECUTE_ONLY_BIT.  This is simple and sufficient for testing.

Ugh, no.  I am strongly against playing the same insane games KVM itself plays
with overloading protectin/access bits.  There's no reason for selftests to do
the same, e.g. selftests aren't shadowing guest PTEs and doing permission checks
in hot paths and so don't need to multiplex a bunch of things into an inscrutable
(but performant!) system.

> Add an executable bitmask and update __virt_pg_map() and friends to set
> the bit on newly created entries to match the EPT behavior. It's a nop
> for x86 page tables.
> 
> Another benefit of reusing the code is having separate handling for
> upper-level PTEs vs 4K PTEs, which avoids some quirks like setting the
> large bit on a 4K PTE in the EPTs.
> 
> No functional change intended.
> 
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
> ---
>  .../selftests/kvm/include/x86/processor.h     |   3 +
>  .../testing/selftests/kvm/lib/x86/processor.c |  12 +-
>  tools/testing/selftests/kvm/lib/x86/vmx.c     | 115 ++++--------------
>  3 files changed, 33 insertions(+), 97 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/include/x86/processor.h b/tools/testing/selftests/kvm/include/x86/processor.h
> index fb2b2e53d453..62e10b296719 100644
> --- a/tools/testing/selftests/kvm/include/x86/processor.h
> +++ b/tools/testing/selftests/kvm/include/x86/processor.h
> @@ -1447,6 +1447,7 @@ struct pte_masks {
>  	uint64_t dirty;
>  	uint64_t huge;
>  	uint64_t nx;
> +	uint64_t x;

To be consistent with e.g. writable, call this executable.

>  	uint64_t c;
>  	uint64_t s;
>  };
> @@ -1464,6 +1465,7 @@ struct kvm_mmu {
>  #define PTE_DIRTY_MASK(mmu) ((mmu)->pte_masks.dirty)
>  #define PTE_HUGE_MASK(mmu) ((mmu)->pte_masks.huge)
>  #define PTE_NX_MASK(mmu) ((mmu)->pte_masks.nx)
> +#define PTE_X_MASK(mmu) ((mmu)->pte_masks.x)
>  #define PTE_C_MASK(mmu) ((mmu)->pte_masks.c)
>  #define PTE_S_MASK(mmu) ((mmu)->pte_masks.s)
>  
> @@ -1474,6 +1476,7 @@ struct kvm_mmu {
>  #define pte_dirty(mmu, pte) (!!(*(pte) & PTE_DIRTY_MASK(mmu)))
>  #define pte_huge(mmu, pte) (!!(*(pte) & PTE_HUGE_MASK(mmu)))
>  #define pte_nx(mmu, pte) (!!(*(pte) & PTE_NX_MASK(mmu)))
> +#define pte_x(mmu, pte) (!!(*(pte) & PTE_X_MASK(mmu)))

And then here to not assume PRESENT == READABLE, just check if the MMU even has
a PRESENT bit.  We may still need changes, e.g. the page table builders actually
need to verify a PTE is _writable_, not just present, but that's largely an
orthogonal issue.

#define is_present_pte(mmu, pte)		\
	(PTE_PRESENT_MASK(mmu) ?		\
	 !!(*(pte) & PTE_PRESENT_MASK(mmu)) :	\
	 !!(*(pte) & (PTE_READABLE_MASK(mmu) | PTE_EXECUTABLE_MASK(mmu))))

And to properly capture the relationship between NX and EXECUTABLE:

#define is_executable_pte(mmu, pte)	\
	((*(pte) & (PTE_EXECUTABLE_MASK(mmu) | PTE_NX_MASK(mmu))) == PTE_EXECUTABLE_MASK(mmu))

#define is_nx_pte(mmu, pte)		(!is_executable_pte(mmu, pte))

>  #define pte_c(mmu, pte) (!!(*(pte) & PTE_C_MASK(mmu)))
>  #define pte_s(mmu, pte) (!!(*(pte) & PTE_S_MASK(mmu)))
>  
> diff --git a/tools/testing/selftests/kvm/lib/x86/processor.c b/tools/testing/selftests/kvm/lib/x86/processor.c
> index bff75ff05364..8b0e17f8ca37 100644
> --- a/tools/testing/selftests/kvm/lib/x86/processor.c
> +++ b/tools/testing/selftests/kvm/lib/x86/processor.c
> @@ -162,8 +162,7 @@ struct kvm_mmu *mmu_create(struct kvm_vm *vm, int pgtable_levels,
>  	struct kvm_mmu *mmu = calloc(1, sizeof(*mmu));
>  
>  	TEST_ASSERT(mmu, "-ENOMEM when allocating MMU");
> -	if (pte_masks)
> -		mmu->pte_masks = *pte_masks;
> +	mmu->pte_masks = *pte_masks;

Rather than pass NULL (and allow NULL here) in the previous patch, pass an
empty pte_masks.  That avoids churning the MMU initialization code, and allows
for a better TODO in the previous patch.

> +	/*
> +	 * EPTs do not have 'present' or 'user' bits, instead bit 0 is the
> +	 * 'readable' bit. In some cases, EPTs can be execute-only and an entry
> +	 * is present but not readable. However, for the purposes of testing we
> +	 * assume 'present' == 'user' == 'readable' for simplicity.
> +	 */
> +	pte_masks = (struct pte_masks){
> +		.present	=	BIT_ULL(0),
> +		.user		=	BIT_ULL(0),
> +		.writable	=	BIT_ULL(1),
> +		.x		=	BIT_ULL(2),
> +		.accessed	=	BIT_ULL(5),
> +		.dirty		=	BIT_ULL(6),
> +		.huge		=	BIT_ULL(7),
> +		.nx		=	0,
> +	};
> +
>  	/* EPTP_PWL_4 is always used */

Make this a TODO, e.g.

	/* TODO: Add support for 5-level paging. */

so that it's clear this is a shortcoming, not some fundamental property of
selftests.

