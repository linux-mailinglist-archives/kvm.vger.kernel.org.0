Return-Path: <kvm+bounces-49726-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 68AD1ADD3A4
	for <lists+kvm@lfdr.de>; Tue, 17 Jun 2025 18:00:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 10A803BCE3B
	for <lists+kvm@lfdr.de>; Tue, 17 Jun 2025 15:53:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A1692F2C55;
	Tue, 17 Jun 2025 15:50:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="g8ybcfpx"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EE592F2C41;
	Tue, 17 Jun 2025 15:50:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750175419; cv=none; b=fVNBghu7mfJqh+kLjyKVUb5KLhIdZ5rl8j/rS5eT4EEf/hUYRvmbx5l/XYCOiEBok6+yGTEPLzczsOpx3rkCSdQN44JKq96OIHzF65hXfGWInoa8B1ERhdBZ0uzTpxlcdB9E2enBdIac8rvSvmiwCzyJgD6NO6FgbHtLkELzTlU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750175419; c=relaxed/simple;
	bh=LNC2w8LSdPeWSFo7aYqjVJu6bohSIps4pbr6GI4K0BA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BMub4BeFW7RTCF/MG/FI76+WPR0OR7kB8tCKaFQRfYxgysqufziL/r+XXMNNoLP5hyfzZwzYs2hlT/6RKFwByLClXn2yRx1YUTaf28J9pA5RupmDjXwyTOZ7Ju0uEge/YG0u6AYZaoIw/nzJMKT1h2kR81DygTY4Hm6pZt1YJq0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=g8ybcfpx; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B85CC4CEE3;
	Tue, 17 Jun 2025 15:50:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750175419;
	bh=LNC2w8LSdPeWSFo7aYqjVJu6bohSIps4pbr6GI4K0BA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=g8ybcfpxWV2OtWW99thzTjWTfLwKsYYyaqcTvP7aHzalyqXMXPorjLvVi6xHimaHF
	 eJsTaSqfWINmIeb2EWU2+/1+1jmxVvUKxnQVRhZUALS1HDkfjHe1OCSVKeKD6cMpT1
	 jD8uwP4U1MtAJpojwUNjP8SJAr9bp+FteCTVASwSS77HmIqjK1cEtysYmef1wfU7Um
	 EURHWiaOCN3HV7rbcHdsJDcgHHmGnmyc9SHUZ/5P92AhI2AZ2xt4gPLhtJUX1WHsCu
	 TGiAuinoczfD8wisKatLD5XmFhJtiY/HaD0eXCqDoVmrX4+TYH5y5xXYeQNZ+BGEeO
	 3mSt/BnDa6lwA==
Date: Tue, 17 Jun 2025 21:12:58 +0530
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
Subject: Re: [PATCH v3 38/62] KVM: SVM: Take and hold ir_list_lock across
 IRTE updates in IOMMU
Message-ID: <qhvns5twcxwzrz2fhp7njmyqb5x5icgiz4iszwvwmeoxhw7ycv@3we3xqqaqeib>
References: <20250611224604.313496-2-seanjc@google.com>
 <20250611224604.313496-40-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250611224604.313496-40-seanjc@google.com>

On Wed, Jun 11, 2025 at 03:45:41PM -0700, Sean Christopherson wrote:
> Now that svm_ir_list_add() isn't overloaded with all manner of weird
> things, fold it into avic_pi_update_irte(), and more importantly take
> ir_list_lock across the irq_set_vcpu_affinity() calls to ensure the info
> that's shoved into the IRTE is fresh.  While preemption (and IRQs) is
> disabled on the task performing the IRTE update, thanks to irqfds.lock,
> that task doesn't hold the vCPU's mutex, i.e. preemption being disabled
> is irrelevant.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/svm/avic.c | 55 +++++++++++++++++------------------------
>  1 file changed, 22 insertions(+), 33 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
> index f1e9f0dd43e8..4747fb09aca4 100644
> --- a/arch/x86/kvm/svm/avic.c
> +++ b/arch/x86/kvm/svm/avic.c
> @@ -769,32 +769,6 @@ static void svm_ir_list_del(struct kvm_kernel_irqfd *irqfd)
>  	spin_unlock_irqrestore(&to_svm(vcpu)->ir_list_lock, flags);
>  }
>  
> -static void svm_ir_list_add(struct vcpu_svm *svm,
> -			    struct kvm_kernel_irqfd *irqfd,
> -			    struct amd_iommu_pi_data *pi)
> -{
> -	unsigned long flags;
> -	u64 entry;
> -
> -	irqfd->irq_bypass_data = pi->ir_data;
> -
> -	spin_lock_irqsave(&svm->ir_list_lock, flags);
> -
> -	/*
> -	 * Update the target pCPU for IOMMU doorbells if the vCPU is running.
> -	 * If the vCPU is NOT running, i.e. is blocking or scheduled out, KVM
> -	 * will update the pCPU info when the vCPU awkened and/or scheduled in.
> -	 * See also avic_vcpu_load().
> -	 */
> -	entry = svm->avic_physical_id_entry;
> -	if (entry & AVIC_PHYSICAL_ID_ENTRY_IS_RUNNING_MASK)
> -		amd_iommu_update_ga(entry & AVIC_PHYSICAL_ID_ENTRY_HOST_PHYSICAL_ID_MASK,
> -				    true, pi->ir_data);
> -
> -	list_add(&irqfd->vcpu_list, &svm->ir_list);
> -	spin_unlock_irqrestore(&svm->ir_list_lock, flags);
> -}
> -

There are a few comments in avic_vcpu_load() and avic_vcpu_put() which 
still refer to svm_ir_list_add(). Would be good to update those.

- Naveen


