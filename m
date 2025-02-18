Return-Path: <kvm+bounces-38455-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D6696A3A21B
	for <lists+kvm@lfdr.de>; Tue, 18 Feb 2025 17:06:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E08B51884408
	for <lists+kvm@lfdr.de>; Tue, 18 Feb 2025 16:04:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2F14626E15C;
	Tue, 18 Feb 2025 16:04:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="U9YtFzZE"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C681194C86
	for <kvm@vger.kernel.org>; Tue, 18 Feb 2025 16:03:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739894641; cv=none; b=JaBpDPfONhV31Oe/1wF2GYdilmjnW+8GncsR+BZsW7cEtLpWMEvLyKXasBUMzdcP+7H/ByGi2HFY+iYOLrcJm9hCbktbsNHiPjTaQDKgAiY4Ryt2to8asLqFA+8pyF96k4EXtDhVmlvRxkXh9S4km3SlT+ff5iplAOCFe8Umxxo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739894641; c=relaxed/simple;
	bh=q895/9qgMhtBqu0Uzl9tkRoBti/jVnEblaswsLouDTk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Gi0N7X9PwiDYW82HfbwHbA9DU5JHuthpEI9Ws2GwJMoWkZt5pweGKvTATtbysqGCVpfOMpQAsbZjohobUQujCPlSRO/t3+PXm6eOoZDIVOb4cEpwynXj1TWRghp3uAa8+P/Arcn/ex7DB/GNif8gedptfSpPh/AFz+TuZPbHtPE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=U9YtFzZE; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-220c86b3ef3so123638205ad.1
        for <kvm@vger.kernel.org>; Tue, 18 Feb 2025 08:03:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1739894639; x=1740499439; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=bZDB6163brXmpWZDgT/6YzrIWqBj9L6ybAjsJnZ9ahg=;
        b=U9YtFzZEuLU/jcqKKSgYYRSnELHPQ1kk+vkXgzXhTaMLdrxUn73VCuVKwYzi3F5GWe
         jGuDLN98B4OFgddwplBYxJHAc8FY+cpsVIh9H43AdEjO1f5Fonjzp2WE2rlv2iGyI6yH
         Buy5OzJTbMwkcjqtM0BEjzcPFxSfU0EOsZRjd5EG4IXpfiWbBPI3dCxNPWur8RAyIpBK
         a166xLmFfzbf3CuZBWlr8Gwn2bXfOnR6quHgARi9b/6PeuCLjvN2TP9EL+nblRICypwZ
         tQeLT6LgX8qpBsyNDqtuEpd0vUjzLpZr6HeWldgIYcq8nnZansrz5YQfuInn1KC8eO5I
         48PA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739894639; x=1740499439;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bZDB6163brXmpWZDgT/6YzrIWqBj9L6ybAjsJnZ9ahg=;
        b=BGDnkzewOx7iKBKYnLfMnA9uN0yUyGxucFvO3uFCn0cZSW17e0JM7J5EUx/yIc4sfn
         jwoU8B/Cf8qKK1tv2Zhetv0PPtR8ysg0EB4Xb7hnXLGXdVf41C0iwcZvfd13BhmLwUw8
         LT6hszKsEowZ+Ff+REZyD8SfHPvxsBtIODPwKpZIt6d5LcKcIxKxQ7+pE3cBIdnWGtKf
         /yGWU4WTznrMBw27OENfGlCNWWXe841pi+aAS6nneLS6Q2w5dHEtXL2gUtDpmBgpq22n
         BuqT6vJ+HKA94bH8RploQk5mq/cT8X33k8CMeC5ReaAUsNP30wiwypSLnC9bJJF+FEzk
         o1ug==
X-Forwarded-Encrypted: i=1; AJvYcCVa4KQZpkLZbfXK3fW/H9+c41hh5DJ5G3vj76eIhk9+0JfLGu//XkIq3DUytDmCumMjSxc=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy8kVS1ro74UyGAJoPtjuV9l0dPUaSjSyb0+flVITlmKvfZpIvH
	5UbCuxyXYPbCJggmESrRqivWGAdf9+ID/naBz/QjzaFMO+5XTED1BXMJ9k23pveRsQU+sp/njle
	S6g==
X-Google-Smtp-Source: AGHT+IFNVuGgmnbQtTfdLkBHrvWh0s23OtsUX5+0HskCmpFlWqBybVXiHNX0UB/9IvEeeiAdLnbnMSNoI9o=
X-Received: from pfan14.prod.google.com ([2002:aa7:8a4e:0:b0:730:7648:7a74])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:4e06:b0:732:706c:c4ff
 with SMTP id d2e1a72fcca58-7329cf56e98mr240940b3a.7.1739894639222; Tue, 18
 Feb 2025 08:03:59 -0800 (PST)
Date: Tue, 18 Feb 2025 08:03:57 -0800
In-Reply-To: <20250217085731.19733-1-yan.y.zhao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250217085535.19614-1-yan.y.zhao@intel.com> <20250217085731.19733-1-yan.y.zhao@intel.com>
Message-ID: <Z7SvbSHe74HUXvz4@google.com>
Subject: Re: [PATCH 2/2] KVM: x86/mmu: Bail out kvm_tdp_map_page() when VM dead
From: Sean Christopherson <seanjc@google.com>
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: pbonzini@redhat.com, rick.p.edgecombe@intel.com, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Mon, Feb 17, 2025, Yan Zhao wrote:
> Bail out of the loop in kvm_tdp_map_page() when a VM is dead. Otherwise,
> kvm_tdp_map_page() may get stuck in the kernel loop when there's only one
> vCPU in the VM (or if the other vCPUs are not executing ioctls), even if
> fatal errors have occurred.
> 
> kvm_tdp_map_page() is called by the ioctl KVM_PRE_FAULT_MEMORY or the TDX
> ioctl KVM_TDX_INIT_MEM_REGION. It loops in the kernel whenever RET_PF_RETRY
> is returned. In the TDP MMU, kvm_tdp_mmu_map() always returns RET_PF_RETRY,
> regardless of the specific error code from tdp_mmu_set_spte_atomic(),
> tdp_mmu_link_sp(), or tdp_mmu_split_huge_page(). While this is acceptable
> in general cases where the only possible error code from these functions is
> -EBUSY, TDX introduces an additional error code, -EIO, due to SEAMCALL
> errors.
> 
> Since this -EIO error is also a fatal error, check for VM dead in the
> kvm_tdp_map_page() to avoid unnecessary retries until a signal is pending.
> 
> The error -EIO is uncommon and has not been observed in real workloads.
> Currently, it is only hypothetically triggered by bypassing the real
> SEAMCALL and faking an error in the SEAMCALL wrapper.
> 
> Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
> ---
>  arch/x86/kvm/mmu/mmu.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 08ed5092c15a..3a8d735939b5 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -4700,6 +4700,10 @@ int kvm_tdp_map_page(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code, u8 *level
>  	do {
>  		if (signal_pending(current))
>  			return -EINTR;
> +
> +		if (vcpu->kvm->vm_dead)

This needs to be READ_ONCE().  Along those lines, I think I'd prefer

		if (kvm_check_request(KVM_REQ_VM_DEAD, vcpu))
			return -EIO;

or

		if (kvm_check_request(KVM_REQ_VM_DEAD, vcpu)) 
			return -EIO;

so that if more terminal requests come long, we can bundle everything into a
single check via a selective version of kvm_request_pending().

