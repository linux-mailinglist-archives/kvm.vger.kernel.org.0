Return-Path: <kvm+bounces-34934-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 9FB03A08056
	for <lists+kvm@lfdr.de>; Thu,  9 Jan 2025 20:00:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6A15018884DB
	for <lists+kvm@lfdr.de>; Thu,  9 Jan 2025 19:00:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AC7C01B423A;
	Thu,  9 Jan 2025 19:00:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fgmIlYsh"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B8651ACEB2
	for <kvm@vger.kernel.org>; Thu,  9 Jan 2025 19:00:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736449204; cv=none; b=uJFcbuUm2dBWCvkOdBPKhtf9LmDBMb9euNCKrMzKx125wW0OmT9U7QLD97yzkLvC714Ct2D6akh+DvoIuBUGESkOrxaLQ7o3jeBr2cJXqlhMg9ZFEF4CamBlOG2+4NUjsrxq8EHpBw5kmMr3hH55mq688OWtzKJEIqdSQFrsgt4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736449204; c=relaxed/simple;
	bh=BBqs3szBxL4esre0332Pv3td2KRryfSW/KpLMasw1tc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=VPbNW05+H1W6tbUeZ81dEmkf5HK7gv8Spv0GEN5hbxrDV19hbsgRZKBO5593Dli7OkMQj6gQSWTQFo5yI97AIM9K74XRDJaoXtqtTTy9ocvcitCSEQhX8edw3VPAaWSryyZUPhGRp7Ixc9sQOMqNp5MVGcYPBS8Kvkgiu3d2D/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=fgmIlYsh; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2162259a5dcso32229735ad.3
        for <kvm@vger.kernel.org>; Thu, 09 Jan 2025 11:00:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1736449202; x=1737054002; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=haLW7l47J5rMTEJ8zSACBng3wk1nv637cJFnGsiAO+w=;
        b=fgmIlYsh/q6Gv55SG/prqOlprWQW9ZP6G/z/PgU6qS4B+mfOkZx6C37xxOI7ZrBe5C
         BzMwI65LDU6ru1Ot5Wru+GgpF1zMbSV3hKGyhshSpQ5k6h6iYQnI9br+VDaPsHODzbeD
         TnYtoToraETwg5HxtJVRge6G1EE3O0jFU8uBf2VU3Ji/dDIyLxIdIJ6Uxi78n/9fY9f1
         4HtC8lT3q607ppugTYols2v0U8Uzy82USUDgK6p1pNrYH/YsP6MLV/9FqK3DMtJQZsGf
         JNm3ah9BxKqJzzznRH7/W+3u2wjznCAea82ndFD7K/jd9+lr4/oGtRypmb1ixpspf9PZ
         03LQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736449202; x=1737054002;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=haLW7l47J5rMTEJ8zSACBng3wk1nv637cJFnGsiAO+w=;
        b=p1jxJ1nu1p7Gcvqmo0PnxLaTYcZSnLfgqjlf80hkZ0Iml5XaeydPvBioVPvwMkGrdX
         RxV1f2blmYJbD5erwnRQj6aTOwRfgTFaEboJCQsGy/G3a612hQNgJa1Gayqt1f7MuHJb
         aQZ5/A8Ak4f5GKjwt1ORJufV0v8dBmYXL/KmpWB1Ys3FrjnYS728WxwLhXJkoL7dxyDg
         RzGx7rvhGpk8x2M+CiVLrdWNnn92jQw27ntMxyThUPzsSlxuFL64Cb/+pDgH9R75zQdn
         NMXNsPEAeeh0vQOvPWy5MSo+imkCmQqbP+T5zVvr/CLfqhYVaHWjeJnPN0OScDDC0TEw
         8N0Q==
X-Forwarded-Encrypted: i=1; AJvYcCVPRkXh0aPeuUtO2t1DjN4Hmm3BhGCBA8MSBSXhX5Xm7FEGmJRrMN6eQJYkhe/a+pw1hi4=@vger.kernel.org
X-Gm-Message-State: AOJu0YxKm8FWkwQ7yv7TJ32VIQRNV9k2gTCAHQdXaj7Ae+YVSEU/V0by
	+LmZX950LFCFWsvo2evLdTMq+zwmww5s50aKRQXQFwa2KM/QCu86cH0cHtoiotCxOVUJqk2VjED
	62g==
X-Google-Smtp-Source: AGHT+IGGyRrFtOiXTLX0QGUwtIUWJLQiVZ+xflS3X78Pqi0jjnUrRHfKUFCx6IqJaMIjpIbZnthCmIRTyvc=
X-Received: from pgak9.prod.google.com ([2002:a63:3d09:0:b0:7fd:432d:551a])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:db06:b0:216:725c:a12c
 with SMTP id d9443c01a7336-21a83f46a4dmr117318665ad.9.1736449202497; Thu, 09
 Jan 2025 11:00:02 -0800 (PST)
Date: Thu, 9 Jan 2025 11:00:01 -0800
In-Reply-To: <20250109133817.314401-2-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250109133817.314401-1-pbonzini@redhat.com> <20250109133817.314401-2-pbonzini@redhat.com>
Message-ID: <Z4Acsese_-Kh1GPr@google.com>
Subject: Re: [PATCH 1/5] KVM: e500: retry if no memslot is found
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, oliver.upton@linux.dev, 
	Will Deacon <will@kernel.org>, Anup Patel <apatel@ventanamicro.com>, 
	Andrew Jones <ajones@ventanamicro.com>, linuxppc-dev@lists.ozlabs.org, 
	regressions@lists.linux.dev, stable@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Thu, Jan 09, 2025, Paolo Bonzini wrote:
> Avoid a NULL pointer dereference if the memslot table changes between the
> exit and the call to kvmppc_e500_shadow_map().
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/powerpc/kvm/e500_mmu_host.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/arch/powerpc/kvm/e500_mmu_host.c b/arch/powerpc/kvm/e500_mmu_host.c
> index e5a145b578a4..732335444d68 100644
> --- a/arch/powerpc/kvm/e500_mmu_host.c
> +++ b/arch/powerpc/kvm/e500_mmu_host.c
> @@ -349,6 +349,11 @@ static inline int kvmppc_e500_shadow_map(struct kvmppc_vcpu_e500 *vcpu_e500,
>  	 * pointer through from the first lookup.
>  	 */
>  	slot = gfn_to_memslot(vcpu_e500->vcpu.kvm, gfn);
> +	if (!slot) {
> +		ret = -EAGAIN;
> +		goto out;
> +	}

This is unnecessary, __gfn_to_hva_many() checks for a NULL @slot.

  static unsigned long __gfn_to_hva_many(const struct kvm_memory_slot *slot, gfn_t gfn,
				       gfn_t *nr_pages, bool write)
  {
	if (!slot || slot->flags & KVM_MEMSLOT_INVALID)
		return KVM_HVA_ERR_BAD;

	if (memslot_is_readonly(slot) && write)
		return KVM_HVA_ERR_RO_BAD;

	if (nr_pages)
		*nr_pages = slot->npages - (gfn - slot->base_gfn);

	return __gfn_to_hva_memslot(slot, gfn);
  }

  unsigned long gfn_to_hva_memslot(struct kvm_memory_slot *slot,
					gfn_t gfn)
  {
	return gfn_to_hva_many(slot, gfn, NULL);
  }

Not checking the return value and doing a VMA lookup on hva=-1 when tlbsel==1 is
gross, but it should be functionally safe.

Returning -EAGAIN is nicer (kvmppc_e500_shadow_map() will inevitably return -EINVAL),
but in practice it doesn't matter because all callers ultimately ignore the return
value.

Since there's a ratelimited printk that yells if there's no slot, it's probably
best to let sleeping dogs lie.

	if (likely(!pfnmap)) {
		tsize_pages = 1UL << (tsize + 10 - PAGE_SHIFT);
		pfn = __kvm_faultin_pfn(slot, gfn, FOLL_WRITE, NULL, &page);
		if (is_error_noslot_pfn(pfn)) {
			if (printk_ratelimit())
				pr_err("%s: real page not found for gfn %lx\n",
				       __func__, (long)gfn);
			return -EINVAL;
		}



> +
>  	hva = gfn_to_hva_memslot(slot, gfn);
>  
>  	if (tlbsel == 1) {
> -- 
> 2.47.1
> 

