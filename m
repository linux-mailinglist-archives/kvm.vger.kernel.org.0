Return-Path: <kvm+bounces-28994-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 463309A091F
	for <lists+kvm@lfdr.de>; Wed, 16 Oct 2024 14:14:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DFF071F22EFE
	for <lists+kvm@lfdr.de>; Wed, 16 Oct 2024 12:14:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D342F20821B;
	Wed, 16 Oct 2024 12:14:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NdIdiS69"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lj1-f175.google.com (mail-lj1-f175.google.com [209.85.208.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74E102076DA;
	Wed, 16 Oct 2024 12:14:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729080887; cv=none; b=Jg/CSt+Zr9MUXnaGxBs3pPY/r4I+KWXTXl5H4XcJsJ1NJ6b/OtVagQCpybsjBzSD5X65BCI7/wCsDblSwZUuIoQan/Bkpf8doVyCTSe5dfV5OsHb0g2JiXTuyLFzU3hYeDhAghJjXFiMtc2SapJr/TzQv7kdlZjeJ6XKWKUCg6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729080887; c=relaxed/simple;
	bh=2/Suc9WTfhdUXwiTzxc/IflbPBFAA6X/l6N4Gk2D62g=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pFEK74nww3AcY2AtuH12GYeqcV51hLbl/OXDGCVSS2m3Qz7efT1Et20o4lAeTx/4hKjAcMifk/p9vt2f4AmXChirdU2uFlwFizA8DlIeEe77DUYnXWAxGKpHSBBIe8MAh2Nc4nZGVkzbsUYS1jAxfyfbmuqIq7xXpx+soTD0j5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NdIdiS69; arc=none smtp.client-ip=209.85.208.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lj1-f175.google.com with SMTP id 38308e7fff4ca-2fb5111747cso35124871fa.2;
        Wed, 16 Oct 2024 05:14:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729080884; x=1729685684; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=l0eI5lAUbdT2xgG8Sg5gfm2pTZ0+zaLZVdb9X/94txA=;
        b=NdIdiS69KcBs2gR2T+FD8BZ4KQ6rj2VTySweFm80aO0pfyyvjz4eIjjW4CGNnPr9Rj
         gAUADkpHWQnlpRYTIftDzl2FQrQ7W8K6ELfinJZ4uhCqHTYgLOFdV9Ga5X8YnuaO9TDv
         YXOpoB1CovDeDV5iu3qLG4whMX/wBCt4epeRKCiixBHIxh5e5rbbNy+Z5EaULtsX4Uw+
         WmcEP393Px2yYdDCML1sHqZ7yrA8kM+vfd0ZsBXT69WW6qhoiPPDBeZfymDLCedkPfiz
         PlDnkduo9Vi/Ymmk42EXWsgjGsOPoE/VsvcDRfckDEekNacgzh6GDQPvpjSueExxoLdz
         q07g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729080884; x=1729685684;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=l0eI5lAUbdT2xgG8Sg5gfm2pTZ0+zaLZVdb9X/94txA=;
        b=Ged/FrJdmiG25jVUGfRvhMi6uV61Fft2I09L08pw/QxdR5+9OGyGDnrEYMkjmMTbeL
         jZftwTq/ysR8mJ22M0Ik2ouD3HhfK4hec4m/l4rpSnVHHloPT+jQ4CsLtgzTtFJua7Ow
         7kP4S67difREyG+XTw515rbUWhuJELusBES1oy6j3epe1sa+iQlUI8hZn2nakueSlz4X
         HcAbpAov2yYYmsRcOuxQAi2ymZLazQJ+75qSJSObbdpWjpbJYhJlAqcqEzLCFW5mN2pY
         263db6j1w+EurmlvCbeMaO/RIB8jNi025UeE2BSdrJtaVVwddlMLX9ISXu1d4HTKmLOi
         O5oA==
X-Forwarded-Encrypted: i=1; AJvYcCUHChxVumws4hDI1pXn9PxO0nuaGp4N8xf28SKRu3CxKT1HFEA2hCuBmW7PFaaYYfEZqloQhu2Yx7EobtwUmsY=@vger.kernel.org, AJvYcCUZwFp12pewxLqUpf4VRdTBbLqbudV43EUpC76Wmw9BsHPjQzNAOp7QByTjVq7CaTuawpRmRT5llAvu2mjq@vger.kernel.org, AJvYcCXAJpkD6B9Ye+XBeCyidb+1vSHBr8Cie4SOsQL293m2cq075C7Lh8SiNTbA1CPNG/Twy2eG@vger.kernel.org
X-Gm-Message-State: AOJu0YwNZrykROUuBXjyu2XSf4Ila77t5CCCPaSFwEe4/W8Oad51Q3fR
	RGt+SaLXTWiu5MHUNWHO8c/Inrg5I13zcYkxCvw08HtQ5AafvqiH
X-Google-Smtp-Source: AGHT+IFISaLoEL1v0HSzO0EUOZSFeeQBuVf/qhinkQvpqUzk15fW+vJulRLe5xE0klVquRlwEnymMA==
X-Received: by 2002:a05:651c:1990:b0:2fb:4f0c:e3d8 with SMTP id 38308e7fff4ca-2fb4f0cea31mr54327131fa.27.1729080883239;
        Wed, 16 Oct 2024 05:14:43 -0700 (PDT)
Received: from pc636 (host-95-203-1-67.mobileonline.telia.com. [95.203.1.67])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-2fb5d194034sm3994531fa.78.2024.10.16.05.14.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Oct 2024 05:14:42 -0700 (PDT)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@pc636>
Date: Wed, 16 Oct 2024 14:14:40 +0200
To: Julia Lawall <Julia.Lawall@inria.fr>,
	Michael Ellerman <mpe@ellerman.id.au>
Cc: Michael Ellerman <mpe@ellerman.id.au>, kernel-janitors@vger.kernel.org,
	vbabka@suse.cz, paulmck@kernel.org,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Naveen N Rao <naveen@kernel.org>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 13/17] KVM: PPC: replace call_rcu by kfree_rcu for simple
 kmem_cache_free callback
Message-ID: <Zw-uMDwxBvl0R0mL@pc636>
References: <20241013201704.49576-1-Julia.Lawall@inria.fr>
 <20241013201704.49576-14-Julia.Lawall@inria.fr>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241013201704.49576-14-Julia.Lawall@inria.fr>

On Sun, Oct 13, 2024 at 10:17:00PM +0200, Julia Lawall wrote:
> Since SLOB was removed and since
> commit 6c6c47b063b5 ("mm, slab: call kvfree_rcu_barrier() from kmem_cache_destroy()"),
> it is not necessary to use call_rcu when the callback only performs
> kmem_cache_free. Use kfree_rcu() directly.
> 
> The changes were made using Coccinelle.
> 
> Signed-off-by: Julia Lawall <Julia.Lawall@inria.fr>
> 
> ---
>  arch/powerpc/kvm/book3s_mmu_hpte.c |    8 +-------
>  1 file changed, 1 insertion(+), 7 deletions(-)
> 
> diff --git a/arch/powerpc/kvm/book3s_mmu_hpte.c b/arch/powerpc/kvm/book3s_mmu_hpte.c
> index ce79ac33e8d3..d904e13e069b 100644
> --- a/arch/powerpc/kvm/book3s_mmu_hpte.c
> +++ b/arch/powerpc/kvm/book3s_mmu_hpte.c
> @@ -92,12 +92,6 @@ void kvmppc_mmu_hpte_cache_map(struct kvm_vcpu *vcpu, struct hpte_cache *pte)
>  	spin_unlock(&vcpu3s->mmu_lock);
>  }
>  
> -static void free_pte_rcu(struct rcu_head *head)
> -{
> -	struct hpte_cache *pte = container_of(head, struct hpte_cache, rcu_head);
> -	kmem_cache_free(hpte_cache, pte);
> -}
> -
>  static void invalidate_pte(struct kvm_vcpu *vcpu, struct hpte_cache *pte)
>  {
>  	struct kvmppc_vcpu_book3s *vcpu3s = to_book3s(vcpu);
> @@ -126,7 +120,7 @@ static void invalidate_pte(struct kvm_vcpu *vcpu, struct hpte_cache *pte)
>  
>  	spin_unlock(&vcpu3s->mmu_lock);
>  
> -	call_rcu(&pte->rcu_head, free_pte_rcu);
> +	kfree_rcu(pte, rcu_head);
>  }
>  
>  static void kvmppc_mmu_pte_flush_all(struct kvm_vcpu *vcpu)
> 
> 
Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>

--
Uladzislau Rezki

