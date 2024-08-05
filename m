Return-Path: <kvm+bounces-23272-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 47B629485C3
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2024 01:02:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E1CEAB21396
	for <lists+kvm@lfdr.de>; Mon,  5 Aug 2024 23:02:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D4BA116E881;
	Mon,  5 Aug 2024 23:02:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="YMAMJOMC"
X-Original-To: kvm@vger.kernel.org
Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 585AA16E870
	for <kvm@vger.kernel.org>; Mon,  5 Aug 2024 23:02:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722898949; cv=none; b=GeKUhvsnaCfmMM07Fw/DBuNQxu1HZ6nCsvYLGMPnnosurzcKh6HIQtZP/lqdpBvFyPr4+hcqvHfW6dbnSN+7PdCdUU7PZX2ofFQg4qdoowy/ceGGgKI1e5+yjJHVTgmKgi2nou8jMUUIKzwZHR4FhUwfpSqFYYaCveeUEGJIO9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722898949; c=relaxed/simple;
	bh=XOTcF+H6VTa6ldiD/H9ODV8RhKJIkpEl00U//Tf2m80=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZoYZ0TTudgMfrfegitLquZ4pv1dWg2yTA4D3kuaw76nHPawM31MlA3Li+VVEPMyEAOjlRmvtVfyiH3LufYW+XxhzHkWs8CgbiCkhuZS0WlfanAqUz6uW/ZDCYtGnJZ6kIgsZA3t2lONCyoHWcA9jlo0ftZgOZCdl0iVz77CsEAw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=YMAMJOMC; arc=none smtp.client-ip=95.215.58.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Mon, 5 Aug 2024 23:02:20 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1722898944;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=86R+9EHYqSACu5ogU8H4AsfRYmZMVJOta5A0hvGH9QY=;
	b=YMAMJOMCFJlF8+EMRXCor/gW4fTct/RUPtwX1HxJ2pluv4BFdp8dgh35OLc3jar6vw9JNn
	srL2qvIryXJLrRSNXshPwxLKtf3h/oFI4I1xO0qxfJ+BB09RySB/aRhS7WDSjNLQylo0tN
	p6VKQsMqgdZAEW/l5ndFbrSbtnXZ3E4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Anish Moorthy <amoorthy@google.com>
Cc: seanjc@google.com, kvm@vger.kernel.org, kvmarm@lists.linux.dev,
	jthoughton@google.com, rananta@google.com
Subject: Re: [PATCH 3/3] KVM: arm64: Do a KVM_EXIT_MEMORY_FAULT when stage-2
 fault handler EFAULTs
Message-ID: <ZrFZ_ANIIbFdzmIn@linux.dev>
References: <20240802224031.154064-1-amoorthy@google.com>
 <20240802224031.154064-4-amoorthy@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240802224031.154064-4-amoorthy@google.com>
X-Migadu-Flow: FLOW_OUT

On Fri, Aug 02, 2024 at 10:40:31PM +0000, Anish Moorthy wrote:
> Right now userspace just gets a bare EFAULT when the stage-2 fault
> handler fails to fault in the relevant page. Set up a memory fault exit
> when this happens, which at the very least eases debugging and might
> also let userspace decide on/take some specific action other than
> crashing the VM.

There are several other 'bare' EFAULTs remaining (unexpected fault
context, failed vma_lookup(), nested PTW), so the patch doesn't exactly
match the shortlog.

Is there a reason why those are unaddressed? In any case, it doesn't
hurt to be unambiguous in the shortlog if we're only focused on this single
error condition, e.g.

  KVM: arm64: Do a memory fault exit if __gfn_to_pfn_memslot() fails

> Signed-off-by: Anish Moorthy <amoorthy@google.com>
> ---
>  arch/arm64/kvm/mmu.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 6981b1bc0946..52b4f8e648fb 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -1568,8 +1568,11 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>  		kvm_send_hwpoison_signal(hva, vma_shift);
>  		return 0;
>  	}
> -	if (is_error_noslot_pfn(pfn))
> +	if (is_error_noslot_pfn(pfn)) {
> +		kvm_prepare_memory_fault_exit(vcpu, fault_ipa, vma_pagesize,
> +					      write_fault, exec_fault, false);
>  		return -EFAULT;
> +	}
>  
>  	if (kvm_is_device_pfn(pfn)) {
>  		/*
> -- 
> 2.46.0.rc2.264.g509ed76dc8-goog
> 

-- 
Thanks,
Oliver

