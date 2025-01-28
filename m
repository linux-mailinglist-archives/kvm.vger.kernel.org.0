Return-Path: <kvm+bounces-36785-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 00822A20D58
	for <lists+kvm@lfdr.de>; Tue, 28 Jan 2025 16:44:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 91D2B1881FA9
	for <lists+kvm@lfdr.de>; Tue, 28 Jan 2025 15:44:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C32C1D5CC6;
	Tue, 28 Jan 2025 15:44:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kXra+tjb"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60EA1199EAF;
	Tue, 28 Jan 2025 15:44:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738079069; cv=none; b=R3puQPoN945J38DIOV6HmdtVpzoxVuAmvhkVxo/H32G8KTcSB0JitIlEwyDm6kXgy3psm/5VqpJrrcr+6skq7j3GYUiqwEhNN6Fesr2JxoJjUBpxNLubnZQ6d4IEM0Yme4utpZSP0iLScYScpsw2O3V5bQ9ERdoGp/E1s6VB5dc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738079069; c=relaxed/simple;
	bh=ElL8ovpzFbgzDeR1L56kKfYZbexMGAr0x6jmeZlmB2A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Zq5GNjbLmtJJ7iphG+utKn0QBfbeJdvu9trWu2Kj1f54A8hv4Wtk1Oam9AWesKNVnfsWa0HgUnsTQcZ4IpvCcDwHIdqBHkLW8X6aV6ySoDAHmt91QdZwDogl6G9xxzniFCkPic2w4dTeCiCsBUzbEQKTznO9Ie+AkpFIQ2w4nhs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kXra+tjb; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71564C4CED3;
	Tue, 28 Jan 2025 15:44:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738079068;
	bh=ElL8ovpzFbgzDeR1L56kKfYZbexMGAr0x6jmeZlmB2A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=kXra+tjb3OboSkzHi8wfjbT1q4jSMJAbWdnDVtr4+lR3T2ajKWrwcvMQ+dCP7+/xM
	 u2HCo1BsXScOYgtxqukOmyRuvlshpCNGmYiQSD8hVQ2mKegbo9XDAuLQKtRyBvzc48
	 p5iiajXwuzDwtjiKlQh61MWcVsXLW8a1N7lSCxvHsSwsX+95A4VNvSUxxbGhR5QBCj
	 9jRjPOOF9G5x2vyn7ctnh8XMzxhMeLIboxQoliylcKSKNVgZvT7XUhQru5M7YZl6RV
	 i3/qWlRY4QRPghepJaUYZ0ASoEQsqb/ZdRe2OshFi8KDgzoXmPmWTMRrOYlfiedR10
	 gzBMupEwKIr0w==
Date: Tue, 28 Jan 2025 08:44:26 -0700
From: Keith Busch <kbusch@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: x86/mmu: Ensure NX huge page recovery thread is
 alive before waking
Message-ID: <Z5j7Wq1E6DqUYu8D@kbusch-mbp>
References: <20250124234623.3609069-1-seanjc@google.com>
 <Z5RkcB_wf5Y74BUM@kbusch-mbp>
 <Z5e4w7IlEEk2cpH-@google.com>
 <Z5fO5bac8ohqUH1D@kbusch-mbp>
 <a0d9ad95-ea69-45dc-a07f-b6dc43e9731e@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a0d9ad95-ea69-45dc-a07f-b6dc43e9731e@redhat.com>

On Tue, Jan 28, 2025 at 04:41:41PM +0100, Paolo Bonzini wrote:
> I'm queuing the patch with the store before vhost_task_start, and
> acquire/release instead of just READ_ONCE/WRITE_ONCE.

Thanks, looks good to me:

Reviewed-by: Keith Busch <kbusch@kernel.org>
 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 74c20dbb92da..6d5708146384 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -7127,7 +7127,8 @@ static void kvm_wake_nx_recovery_thread(struct kvm *kvm)
>  	 * may not be valid even though the VM is globally visible.  Do nothing,
>  	 * as such a VM can't have any possible NX huge pages.
>  	 */
> -	struct vhost_task *nx_thread = READ_ONCE(kvm->arch.nx_huge_page_recovery_thread);
> +	struct vhost_task *nx_thread =
> +		smp_load_acquire(&kvm->arch.nx_huge_page_recovery_thread);
>  	if (nx_thread)
>  		vhost_task_wake(nx_thread);
> @@ -7474,10 +7475,10 @@ static void kvm_mmu_start_lpage_recovery(struct once *once)
>  	if (!nx_thread)
>  		return;
> -	vhost_task_start(nx_thread);
> +	/* Make the task visible only once it is fully created. */
> +	smp_store_release(&kvm->arch.nx_huge_page_recovery_thread, nx_thread);
> -	/* Make the task visible only once it is fully started. */
> -	WRITE_ONCE(kvm->arch.nx_huge_page_recovery_thread, nx_thread);
> +	vhost_task_start(nx_thread);
>  }
>  int kvm_mmu_post_init_vm(struct kvm *kvm)
> 

