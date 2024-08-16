Return-Path: <kvm+bounces-24444-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BD30495524E
	for <lists+kvm@lfdr.de>; Fri, 16 Aug 2024 23:22:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 58956B2218A
	for <lists+kvm@lfdr.de>; Fri, 16 Aug 2024 21:22:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD3B31C463F;
	Fri, 16 Aug 2024 21:22:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="VlRxun+q"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9976A1C37B6
	for <kvm@vger.kernel.org>; Fri, 16 Aug 2024 21:22:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723843366; cv=none; b=KKLCIv+nGJ4TicRccUQ9AA+J3Xq7oPV7GAD6KR0+hyXd0KQZdVDZ2h7+1GtseRyfovRqBsIAPJQiokLrqCMgcUirpj8yZNvC8Vf6nM/eLj2gjUtN9gP18+2NBBuDVh9aMjyggM0gjV3rfpFA6hWOBz9c2YtUyZ50K3125LxxpvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723843366; c=relaxed/simple;
	bh=sWA1R4Z+hjjLgkZaegTM4CTQgixl0MSxWNpQ2OfSHSk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ZnIQEdFVyuuqyi5SQF70wercXMUEbISDpG/L3eeQsIjkPDCnUD+eWE99iiqDa6I4Vzu0odMZzzasX/g3JUsJkQdmwv1KdLg6Z8+OXyftVL/xBnafu/PcsoxscKahb7CI75bacdDs7Qjn0jrJaiJ76s9mNGMc0bTQmZV4HLQAQeo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=VlRxun+q; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-70d2ab42082so3043357b3a.0
        for <kvm@vger.kernel.org>; Fri, 16 Aug 2024 14:22:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1723843364; x=1724448164; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=o9uTxs0mkniTI3GS8tRBaRROslovtMgDYxgP4WPwRKU=;
        b=VlRxun+qGqxgfbLHBeOpk8qR7M1wdhcycfc0ZZzBYvM1RfTN7wysq91GQD4an+zZSo
         4O/TIogSH9vJC0t3uEg6kc9BdEPPQg649TKhSHk1FAkGKhsCg538pDx/2qg6+OZsGHWC
         CLg1EkF50TUBoa0VVUAIWOQea0S/GbIyHL79F3DTth7T5VyB+38SOpCyxXoVRrbqonrl
         stTcdn2VmSQOmeYmo1XtcILyy3njUcb1pfJ8SBEq8bWQB8NR1QHWi/0GwXMgSPBLW/7f
         hrWawsI6PaxNgP2euNchRs+gNObgt3Cv+KB74n7UfPj5/P4qTDZgnPF81I5n2KKN8BPZ
         Mzdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723843364; x=1724448164;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=o9uTxs0mkniTI3GS8tRBaRROslovtMgDYxgP4WPwRKU=;
        b=ELEzZWG0tQfEDuKSdYzVIvAx7uj4c5+4T6m0cPZa4+jNIyWaD70927CmlZIOFbbPN4
         POdFmXBOvFq64kzTEGsW4aCrGqJZaZYWVbIoacRUIE6hnwuH30OBggHFve2V0NOoOXTX
         ltzX14LLXHgoz32fwfVoVVb8Fcl35Ai5f28iUdMoXQUpkBjj1VnFVvRv/239dX01TkEg
         zh7U7UpJf1tnnwLJxfX5su4ATjoAoWlzFbzLP01DXHlEx1BD0AHU7hZBxNtj1fMRwkgA
         +wmLWeYGQ+Ry0yn5iiEDf3Ygjpkb2u2WNNrmGz2fOnFts47BbQJfFA/IBO3OHBEJ+kxz
         Msog==
X-Forwarded-Encrypted: i=1; AJvYcCUlmY3tkfLJ7VeKdQMyseutzn6LOIM3V/vaQgItM9r1RpAmj7073N0GPnhv11Dyinlq/9+m8riGSBlc3HBtRDLTltDm
X-Gm-Message-State: AOJu0Yy8EUS7pe8rm4U5piU+N/xgYvH9eXhVHBX/aW22b0IoHfdWf78D
	BrWXD7vc0CQGvKkG5OVIQ569zafkSGEXcDzs2N9oVijLTXUd4+wFvh/CQsbgqAIEdAZ/sww8rRp
	Dzw==
X-Google-Smtp-Source: AGHT+IHDYed5uLkrjadTM1HkBjUKX+hpJJsh/EyZ8evcAdTKPd0muQAu8d9inIi0f9HwyVQ2JOWLPGX7nk0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:91cb:b0:710:4e4c:a4ad with SMTP id
 d2e1a72fcca58-71276c8a229mr65569b3a.0.1723843363684; Fri, 16 Aug 2024
 14:22:43 -0700 (PDT)
Date: Fri, 16 Aug 2024 14:22:42 -0700
In-Reply-To: <20240809205158.1340255-4-amoorthy@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240809205158.1340255-1-amoorthy@google.com> <20240809205158.1340255-4-amoorthy@google.com>
Message-ID: <Zr_DIuWBRuaQIYmX@google.com>
Subject: Re: [PATCH v2 3/3] KVM: arm64: Perform memory fault exits when
 stage-2 handler EFAULTs
From: Sean Christopherson <seanjc@google.com>
To: Anish Moorthy <amoorthy@google.com>
Cc: oliver.upton@linux.dev, kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	jthoughton@google.com, rananta@google.com
Content-Type: text/plain; charset="us-ascii"

On Fri, Aug 09, 2024, Anish Moorthy wrote:
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 6981b1bc0946..c97199d1feac 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -1448,6 +1448,8 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>  
>  	if (fault_is_perm && !write_fault && !exec_fault) {
>  		kvm_err("Unexpected L2 read permission error\n");
> +		kvm_prepare_memory_fault_exit(vcpu, fault_ipa, 0,

In this case, KVM has the fault granule, can't we just use that instead of
reporting '0'?

> +					      write_fault, exec_fault, false);
>  		return -EFAULT;
>  	}
>  
> @@ -1473,6 +1475,8 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>  	if (unlikely(!vma)) {
>  		kvm_err("Failed to find VMA for hva 0x%lx\n", hva);
>  		mmap_read_unlock(current->mm);
> +		kvm_prepare_memory_fault_exit(vcpu, fault_ipa, 0,

Why can't KVM use the minimum possible page (granule?) size.  It's _always_ legal
for KVM to map at a smaller granularity than the primary MMU, thus it's always
accurate to report KVM's minimum size.

In fact, I would argue that it's inaccurate to report anything larger, because
there's no way for KVM to know if the badness extends to an entire hugepage.
E.g. even in the MTE case below, reporting the vma _page size_ is weird.  IIUC,
the problem exists with the entire vma, not some random (huge)page in the vma.

> +					      write_fault, exec_fault, false);
>  		return -EFAULT;
>  	}
>  
> @@ -1568,8 +1572,11 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>  		kvm_send_hwpoison_signal(hva, vma_shift);
>  		return 0;
>  	}
> -	if (is_error_noslot_pfn(pfn))
> +	if (is_error_noslot_pfn(pfn)) {
> +		kvm_prepare_memory_fault_exit(vcpu, fault_ipa, vma_pagesize,
> +					      write_fault, exec_fault, false);
>  		return -EFAULT;

Shouldn't this be:

	if (KVM_BUG_ON(is_error_noslot_pfn(pfn), vcpu->kvm))
		return -EIO;

Emulated MMIO is suppposed to be handled in kvm_handle_guest_abort():

	if (kvm_is_error_hva(hva) || (write_fault && !writable)) {o
		...

		/*
		 * The IPA is reported as [MAX:12], so we need to
		 * complement it with the bottom 12 bits from the
		 * faulting VA. This is always 12 bits, irrespective
		 * of the page size.
		 */
		ipa |= kvm_vcpu_get_hfar(vcpu) & GENMASK(11, 0);
		ret = io_mem_abort(vcpu, ipa);
		goto out_unlock;
	}

And the memslot itself is stable, e.g. it can't disappear, and it can't have its
flags toggled.  KVM specifically does all modifications to memslots on unreachable
structures so that a memslot cannot change once it has been retrieved from the
memslots tree. 
	/*
	 * Mark the current slot INVALID.  As with all memslot modifications,
	 * this must be done on an unreachable slot to avoid modifying the
	 * current slot in the active tree.
	 */
	kvm_copy_memslot(invalid_slot, old);
	invalid_slot->flags |= KVM_MEMSLOT_INVALID;
	kvm_replace_memslot(kvm, old, invalid_slot);

And if KVM were indeed re-retrieving the memslot from kvm->memslots, then the
appropriate behavior would be

	if (is_error_noslot_pfn(pfn))
		return -EAGAIN;

so that KVM retries the fault.  It's perfectly legal to delete a memslot at any
time, with the rather large caveat that if bad things happen to the guest, it's
userspace responsibility to deal with the fallout.

