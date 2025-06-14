Return-Path: <kvm+bounces-49549-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DC6BBAD98FD
	for <lists+kvm@lfdr.de>; Sat, 14 Jun 2025 02:11:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 188713BF08B
	for <lists+kvm@lfdr.de>; Sat, 14 Jun 2025 00:11:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1DB7F42A97;
	Sat, 14 Jun 2025 00:10:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="iL4gr6Z6"
X-Original-To: kvm@vger.kernel.org
Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FAC64A24
	for <kvm@vger.kernel.org>; Sat, 14 Jun 2025 00:10:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749859807; cv=none; b=jTvPLzMfH+0kFJNg/KUPyg9NAsGcVVUOte7Pd9AJBvCAqK0gaXeiB8FxnRdgvao5ZmZpEZTS/0N4apGf+1AYRP5tIAVu5QvbPqvHReu9cKxpI6aRiPvpaebYrDqxI0fQMt1/A6sG5AUw19J0qTYyoHjO6Cx1qa71FUk8fWsRbp4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749859807; c=relaxed/simple;
	bh=7lSStw4IyBObwGIg2QyFJG+tkhOCRsvLVl4qYXr6szc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cjdhiK9KdaQQj2mu49uyzeNDYX49TP2xBqfHRsXpFX2cMOEhbMTd27mZDBk0BXsb9GKi2L3/YfREskUSteTa3QAhlJIXzM8Zt93rlhlkfgADIOJtSwjrvTYzt4lAXarIzTqLYEe2BOdDH5/T2bcC2tjl2LXqOur89EK7RCibEdY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=iL4gr6Z6; arc=none smtp.client-ip=95.215.58.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Message-ID: <ffd04c9b-030d-4eaa-bbf6-d1f416565c35@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1749859791;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LbpWLSH9rDDdqtA+Sb9xpkQ5UT+CvuC/hhHqruiikz4=;
	b=iL4gr6Z6lF+iNm3fi26JoZLJFoc51ULHyABpXVyoijOfZz5KZi5RvdedlJOiSyWyBNto0k
	cZ5LhikgZo3Yh66mubHMhwvPMZ9vf+ma1BrWnpHakAcBojLoUOJ/FeXDOSyvtql2QXdnic
	whKaXzo2UigzOFa+B20N92/yuKviUes=
Date: Fri, 13 Jun 2025 17:09:41 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH v2 05/12] RISC-V: KVM: Don't flush TLB when PTE is
 unchanged
To: Anup Patel <apatel@ventanamicro.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>,
 Paul Walmsley <paul.walmsley@sifive.com>, Alexandre Ghiti <alex@ghiti.fr>,
 Andrew Jones <ajones@ventanamicro.com>, Anup Patel <anup@brainfault.org>,
 kvm@vger.kernel.org, kvm-riscv@lists.infradead.org,
 linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org
References: <20250613065743.737102-1-apatel@ventanamicro.com>
 <20250613065743.737102-6-apatel@ventanamicro.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Atish Patra <atish.patra@linux.dev>
In-Reply-To: <20250613065743.737102-6-apatel@ventanamicro.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT


On 6/12/25 11:57 PM, Anup Patel wrote:
> The gstage_set_pte() and gstage_op_pte() should flush TLB only when
> a leaf PTE changes so that unnecessary TLB flushes can be avoided.
>
> Signed-off-by: Anup Patel <apatel@ventanamicro.com>
> ---
>   arch/riscv/kvm/mmu.c | 14 +++++++++-----
>   1 file changed, 9 insertions(+), 5 deletions(-)
>
> diff --git a/arch/riscv/kvm/mmu.c b/arch/riscv/kvm/mmu.c
> index 1087ea74567b..29f1bd853a66 100644
> --- a/arch/riscv/kvm/mmu.c
> +++ b/arch/riscv/kvm/mmu.c
> @@ -167,9 +167,11 @@ static int gstage_set_pte(struct kvm *kvm, u32 level,
>   		ptep = &next_ptep[gstage_pte_index(addr, current_level)];
>   	}
>   
> -	set_pte(ptep, *new_pte);
> -	if (gstage_pte_leaf(ptep))
> -		gstage_remote_tlb_flush(kvm, current_level, addr);
> +	if (pte_val(*ptep) != pte_val(*new_pte)) {
> +		set_pte(ptep, *new_pte);
> +		if (gstage_pte_leaf(ptep))
> +			gstage_remote_tlb_flush(kvm, current_level, addr);
> +	}
>   
>   	return 0;
>   }
> @@ -229,7 +231,7 @@ static void gstage_op_pte(struct kvm *kvm, gpa_t addr,
>   			  pte_t *ptep, u32 ptep_level, enum gstage_op op)
>   {
>   	int i, ret;
> -	pte_t *next_ptep;
> +	pte_t old_pte, *next_ptep;
>   	u32 next_ptep_level;
>   	unsigned long next_page_size, page_size;
>   
> @@ -258,11 +260,13 @@ static void gstage_op_pte(struct kvm *kvm, gpa_t addr,
>   		if (op == GSTAGE_OP_CLEAR)
>   			put_page(virt_to_page(next_ptep));
>   	} else {
> +		old_pte = *ptep;
>   		if (op == GSTAGE_OP_CLEAR)
>   			set_pte(ptep, __pte(0));
>   		else if (op == GSTAGE_OP_WP)
>   			set_pte(ptep, __pte(pte_val(ptep_get(ptep)) & ~_PAGE_WRITE));
> -		gstage_remote_tlb_flush(kvm, ptep_level, addr);
> +		if (pte_val(*ptep) != pte_val(old_pte))
> +			gstage_remote_tlb_flush(kvm, ptep_level, addr);
>   	}
>   }
>   

Reviewed-by: Atish Patra <atishp@rivosinc.com>

