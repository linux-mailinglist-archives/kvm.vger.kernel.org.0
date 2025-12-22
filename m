Return-Path: <kvm+bounces-66515-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id D81E6CD6DF0
	for <lists+kvm@lfdr.de>; Mon, 22 Dec 2025 19:06:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 082FF302107B
	for <lists+kvm@lfdr.de>; Mon, 22 Dec 2025 18:06:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F82F3321DC;
	Mon, 22 Dec 2025 18:06:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="avw/BcKo"
X-Original-To: kvm@vger.kernel.org
Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0C333277AF
	for <kvm@vger.kernel.org>; Mon, 22 Dec 2025 18:06:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766426801; cv=none; b=UWQ1arpLY3mLOO3Ydb49/+QH2XbUD5qjix4oBABI+5tzOWe70HvLKvXfydzls3HoJ1tvDcOimuM2jBof7rFBGdhAi+Cl9UeUJ5ynW7IHazjX4eNxbk1jODdmb2A9wsM3oaAcdRH9cgaXONlRcFEStVxAAPBl6nuXltiUT+fE7bM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766426801; c=relaxed/simple;
	bh=CQsSsbliIcyPp1VRQTPFQdTLRH4YhJiBswXOEthVJ08=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=g7n4jrEE0jGqrG1ihep6ayrIOpBraVYjAZ3bLXhu9WacH5alZCMjDw0HniPk78OrxhqGeyiHCvTjFZy0qjcP4ms5jjLMLoOMjXLG3RRytJv/AlMK/41hsbD8wTrX5jrwDRGKTVxsJPTEBiD9E23su0GulVTxtyxPNYaVVTbhrQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=avw/BcKo; arc=none smtp.client-ip=91.218.175.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Mon, 22 Dec 2025 12:06:08 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1766426783;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=MD+k29yEgQqQtWq7yJ0+IwowUibiEOtC9WU2KKaDscU=;
	b=avw/BcKo42R+Ay4EEthtfmeZ5W8JefBuR0FojzfVz4LpGT247fjXQLe7L3LrLKsODAQ3Ao
	AvutCZfCqhp/OCF0ebVQ24Zc+1yluTlQy3ouO+TFGicMFff+odeWFMgp1+ngK91lfcm6Po
	WojIATe0n94SDnECoCuCJIYPrl9g6FE=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Fuad Tabba <tabba@google.com>
Cc: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, maz@kernel.org, 
	oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	will@kernel.org, pbonzini@redhat.com, shuah@kernel.org, anup@brainfault.org
Subject: Re: [PATCH v2 2/5] KVM: arm64: selftests: Fix incorrect rounding in
 page_align()
Message-ID: <20251222-f8d98d81659c01f79e16da2f@orel>
References: <20251215165155.3451819-1-tabba@google.com>
 <20251215165155.3451819-3-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251215165155.3451819-3-tabba@google.com>
X-Migadu-Flow: FLOW_OUT

On Mon, Dec 15, 2025 at 04:51:52PM +0000, Fuad Tabba wrote:
> The implementation of `page_align()` in `processor.c` calculates
> alignment incorrectly for values that are already aligned. Specifically,
> `(v + vm->page_size) & ~(vm->page_size - 1)` aligns to the *next* page
> boundary even if `v` is already page-aligned, potentially wasting a page
> of memory.
> 
> Fix the calculation to use standard alignment logic: `(v + vm->page_size
> - 1) & ~(vm->page_size - 1)`.
> 
> Fixes: 7a6629ef746d ("kvm: selftests: add virt mem support for aarch64")
> Signed-off-by: Fuad Tabba <tabba@google.com>
> ---
>  tools/testing/selftests/kvm/lib/arm64/processor.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/kvm/lib/arm64/processor.c b/tools/testing/selftests/kvm/lib/arm64/processor.c
> index 5b379da8cb90..607a4e462984 100644
> --- a/tools/testing/selftests/kvm/lib/arm64/processor.c
> +++ b/tools/testing/selftests/kvm/lib/arm64/processor.c
> @@ -23,7 +23,7 @@ static vm_vaddr_t exception_handlers;
>  
>  static uint64_t page_align(struct kvm_vm *vm, uint64_t v)
>  {
> -	return (v + vm->page_size) & ~(vm->page_size - 1);
> +	return (v + vm->page_size - 1) & ~(vm->page_size - 1);
>  }
>  
>  static uint64_t pgd_index(struct kvm_vm *vm, vm_vaddr_t gva)
> -- 
> 2.52.0.239.gd5f0c6e74e-goog
> 
>

Thanks for finding and fixing this. I'll get my paper bag out later.

Reviewed-by: Andrew Jones <andrew.jones@linux.dev>

