Return-Path: <kvm+bounces-66954-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id C8DAACEF05D
	for <lists+kvm@lfdr.de>; Fri, 02 Jan 2026 18:04:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 3B736300A9F4
	for <lists+kvm@lfdr.de>; Fri,  2 Jan 2026 17:04:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D96B22836B1;
	Fri,  2 Jan 2026 17:04:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="gcjMVEgM"
X-Original-To: kvm@vger.kernel.org
Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77C5D262FD0
	for <kvm@vger.kernel.org>; Fri,  2 Jan 2026 17:04:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767373453; cv=none; b=Jg17JqcC3LGszblAPxJiCF12XLtbNYvgcOFGNKH4JWidKP9zUCJTogSLyl1F5ECWfF3JcabVJbzcSh14m2cKIJjKwZIPzCTKzEhJezYtE5BWlpykcB/fayTDzjT/DX/zTu+2Dq5QlhbEgvNL7MDI52Mxs2voBJxKBeat6zdu1H8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767373453; c=relaxed/simple;
	bh=AA0GiriPvxHu5l9dMiPGzsMaKRoZR7YB+y0m1FP73+M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eN5s0wZ1lHViSLhdp7D7Qr2x3hObzBjgKvQYAnFppnK32oeKK+bozfGBuEKz1qT/cyJhYvz3ysSVXb3KrhjVk9o9KBac9PCxHHBoIbUOez5xpzQuzs0AkyDeqDZM0nB3SKtseNopB3J6KrxKlye5BreNS/P7bsPAAAAqRslWBtc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=gcjMVEgM; arc=none smtp.client-ip=95.215.58.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Fri, 2 Jan 2026 17:03:49 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1767373448;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=kMbovm/gG/7jubGENqfjP/9rxqSn/HJfGYv99VNhtHo=;
	b=gcjMVEgM+r9x0LCC9CNLWmc8hkGGczkEUcOS+ZUDjiXsI5+UDN+fVo4JgvC0Tz39SlTk4g
	ELNQYbp1SMiKD6mZDD6hUF/Hhz55lFxsvuTSq/b7fV9ZYQJLtryImwzf0g3U06LT2LmP7D
	6arYDRy1xXoqqsfCF4lTg1hx123J1j8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oupton@kernel.org>, Tianrui Zhao <zhaotianrui@loongson.cn>, 
	Bibo Mao <maobibo@loongson.cn>, Huacai Chen <chenhuacai@kernel.org>, 
	Anup Patel <anup@brainfault.org>, Paul Walmsley <pjw@kernel.org>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, loongarch@lists.linux.dev, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 12/21] KVM: selftests: Add a stage-2 MMU instance to
 kvm_vm
Message-ID: <3kuuj6toya5xlv74yrl4wg74b52wsvfqv3gigdbsdaqs7eibt5@th3b5x3dik7y>
References: <20251230230150.4150236-1-seanjc@google.com>
 <20251230230150.4150236-13-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251230230150.4150236-13-seanjc@google.com>
X-Migadu-Flow: FLOW_OUT

On Tue, Dec 30, 2025 at 03:01:41PM -0800, Sean Christopherson wrote:
> Add a stage-2 MMU instance so that architectures that support nested
> virtualization (more specifically, nested stage-2 page tables) can create
> and track stage-2 page tables for running L2 guests.  Plumb the structure
> into common code to avoid cyclical dependencies, and to provide some line
> of sight to having common APIs for creating stage-2 mappings.
> 
> As a bonus, putting the member in common code justifies using stage2_mmu
> instead of tdp_mmu for x86.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Yosry Ahmed <yosry.ahmed@linux.dev>

> ---
>  tools/testing/selftests/kvm/include/kvm_util.h | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
> index c1497515fa6a..371d55e0366e 100644
> --- a/tools/testing/selftests/kvm/include/kvm_util.h
> +++ b/tools/testing/selftests/kvm/include/kvm_util.h
> @@ -116,7 +116,12 @@ struct kvm_vm {
>  	uint32_t dirty_ring_size;
>  	uint64_t gpa_tag_mask;
>  
> +	/*
> +	 * "mmu" is the guest's stage-1, with a short name because the vast
> +	 * majority of tests only care about the stage-1 MMU.
> +	 */
>  	struct kvm_mmu mmu;
> +	struct kvm_mmu stage2_mmu;
>  
>  	struct kvm_vm_arch arch;
>  
> -- 
> 2.52.0.351.gbe84eed79e-goog
> 

