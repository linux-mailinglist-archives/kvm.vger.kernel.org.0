Return-Path: <kvm+bounces-50380-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3D495AE496F
	for <lists+kvm@lfdr.de>; Mon, 23 Jun 2025 17:59:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C928E1753D7
	for <lists+kvm@lfdr.de>; Mon, 23 Jun 2025 15:59:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E30A42980CD;
	Mon, 23 Jun 2025 15:58:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="a/hdkmmf"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E826B253B67;
	Mon, 23 Jun 2025 15:58:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750694320; cv=none; b=nToXZ0xxR8zhHDGMgvqaat42T5qeiXG0ISIsh5IutRQXdVfGDK+fygtTzTV3lP0gqmMIBnw64n4vFUvyLwLMzI7jE4nRj9jULwhXmYUNzwI1P1m1ZlhNWdw9FaOBCB3IrVSNIHl89osKI8lB7v9lAGmfUXNqqYagGRacQpmZKHo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750694320; c=relaxed/simple;
	bh=MBmtOH9m6zr81wji+yIuMSpqTbR3C3+WuqdmMBu0WVU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=d57bslakNdTIszY6dHd518I7wUToFRn81gU/Vr8cPa8BO9DR2bou+EL/GfnhYJOpDgzm+D6GGST4RSRT3i+eg8Ib0iReGyNaEXKXzeR2uTK1mwErrPd6z+ujJuHa6AO9C3q2SRqP6iI3smDNzpLh/goCovPEiAvfiPXPncFNgbE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=a/hdkmmf; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81277C4CEEA;
	Mon, 23 Jun 2025 15:58:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750694317;
	bh=MBmtOH9m6zr81wji+yIuMSpqTbR3C3+WuqdmMBu0WVU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=a/hdkmmf37JuuBRRIQqHxENDG6LmCaTmsJp2DHu7KCr0mZRs4pMvtzIzwaJWRy3Xa
	 4fYQWPNVfpITMNEkZLGMafBo6GVgCwxjW8sW0YsiqKG/unwlNXMPR4GpPrZy6AwCzZ
	 vvAWz50fwIGN7BHS5wK8ouR+ISNxq8yd16oS8fYckmhD5hAvz0hvTy7muPjfc4kxbg
	 QyicczYhD/4fzwCShSSpTX4eWkVEvInZKE5MBwmC2xDCqWQUWSqTN5dHU18wYrSTHG
	 QLZyUBoHa9ZkMEWNMJZV0ebpOq8Q6Z89vV3uYkr98l4tGodaCeAaa0iiLEfybrQRRd
	 1nRuvP660Ry6w==
Date: Mon, 23 Jun 2025 21:24:37 +0530
From: Naveen N Rao <naveen@kernel.org>
To: Sean Christopherson <seanjc@google.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Paolo Bonzini <pbonzini@redhat.com>, Joerg Roedel <joro@8bytes.org>, 
	David Woodhouse <dwmw2@infradead.org>, Lu Baolu <baolu.lu@linux.intel.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, kvm@vger.kernel.org, 
	iommu@lists.linux.dev, linux-kernel@vger.kernel.org, Sairaj Kodilkar <sarunkod@amd.com>, 
	Vasant Hegde <vasant.hegde@amd.com>, Maxim Levitsky <mlevitsk@redhat.com>, 
	Joao Martins <joao.m.martins@oracle.com>, Francesco Lavra <francescolavra.fl@gmail.com>, 
	David Matlack <dmatlack@google.com>
Subject: Re: [PATCH v3 20/62] KVM: SVM: Add a comment to explain why
 avic_vcpu_blocking() ignores IRQ blocking
Message-ID: <pxtvegopzsyhn7lelksclxiiee7tumppu76553rax7octqpy7i@giclgo667htf>
References: <20250611224604.313496-2-seanjc@google.com>
 <20250611224604.313496-22-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250611224604.313496-22-seanjc@google.com>

On Wed, Jun 11, 2025 at 03:45:23PM -0700, Sean Christopherson wrote:
> Add a comment to explain why KVM clears IsRunning when putting a vCPU,
> even though leaving IsRunning=1 would be ok from a functional perspective.
> Per Maxim's experiments, a misbehaving VM could spam the AVIC doorbell so
> fast as to induce a 50%+ loss in performance.
> 
> Link: https://lore.kernel.org/all/8d7e0d0391df4efc7cb28557297eb2ec9904f1e5.camel@redhat.com
> Cc: Maxim Levitsky <mlevitsk@redhat.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/svm/avic.c | 31 ++++++++++++++++++-------------
>  1 file changed, 18 insertions(+), 13 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
> index bf8b59556373..3cf929ac117f 100644
> --- a/arch/x86/kvm/svm/avic.c
> +++ b/arch/x86/kvm/svm/avic.c
> @@ -1121,19 +1121,24 @@ void avic_vcpu_blocking(struct kvm_vcpu *vcpu)
>  	if (!kvm_vcpu_apicv_active(vcpu))
>  		return;
>  
> -       /*
> -        * Unload the AVIC when the vCPU is about to block, _before_
> -        * the vCPU actually blocks.
> -        *
> -        * Any IRQs that arrive before IsRunning=0 will not cause an
> -        * incomplete IPI vmexit on the source, therefore vIRR will also
> -        * be checked by kvm_vcpu_check_block() before blocking.  The
> -        * memory barrier implicit in set_current_state orders writing
> -        * IsRunning=0 before reading the vIRR.  The processor needs a
> -        * matching memory barrier on interrupt delivery between writing
> -        * IRR and reading IsRunning; the lack of this barrier might be
> -        * the cause of errata #1235).
> -        */
> +	/*
> +	 * Unload the AVIC when the vCPU is about to block, _before_ the vCPU
> +	 * actually blocks.
> +	 *
> +	 * Note, any IRQs that arrive before IsRunning=0 will not cause an
> +	 * incomplete IPI vmexit on the source; kvm_vcpu_check_block() handles
> +	 * this by checking vIRR one last time before blocking.  The memory
> +	 * barrier implicit in set_current_state orders writing IsRunning=0
> +	 * before reading the vIRR.  The processor needs a matching memory
> +	 * barrier on interrupt delivery between writing IRR and reading
> +	 * IsRunning; the lack of this barrier might be the cause of errata #1235).
> +	 *
> +	 * Clear IsRunning=0 even if guest IRQs are disabled, i.e. even if KVM
> +	 * doesn't need to detect events for scheduling purposes.  The doorbell

Nit: just IsRunning (you can drop the =0 part).

Trying to understand the significance of IRQs being disabled here. Is 
that a path KVM tries to optimize? Theoretically, it looks like we want 
to clear IsRunning regardless of whether the vCPU is blocked so as to 
prevent the guest from spamming the host with AVIC doorbells -- compared 
to always keeping IsRunning set so as to speed up VM entry/exit.

> +	 * used to signal running vCPUs cannot be blocked, i.e. will perturb the
> +	 * CPU and cause noisy neighbor problems if the VM is sending interrupts
> +	 * to the vCPU while it's scheduled out.
> +	 */
>  	avic_vcpu_put(vcpu);
>  }

Otherwise, this LGTM.
Acked-by: Naveen N Rao (AMD) <naveen@kernel.org>


Thanks,
Naveen


