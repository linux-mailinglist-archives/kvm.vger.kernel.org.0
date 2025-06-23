Return-Path: <kvm+bounces-50355-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 985CCAE4603
	for <lists+kvm@lfdr.de>; Mon, 23 Jun 2025 16:09:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 75EE5188F9D4
	for <lists+kvm@lfdr.de>; Mon, 23 Jun 2025 14:09:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DC98D219A72;
	Mon, 23 Jun 2025 14:09:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dHdsPhym"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE2F078F5E;
	Mon, 23 Jun 2025 14:09:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750687745; cv=none; b=KfhX2yV/R2RffX0OOKbs/BXbyVpm24m5FBn3FdYEPyCitlBbvNSA9mXE2EVpxU9exY6HS0ijMlFtR5r4jUnEAv5kwdhAuxiocsFaPA+HdzbtOgpyiA3JTULtAcGaRDkm3tOg5Nf//87V/uhrkksmso+ozzKQn6BeeeXsa9ozon4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750687745; c=relaxed/simple;
	bh=sIqaqHwoR/cVtxIhgcxx2ZVcUkiubyrehXo3GcWtKOc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=a54f/YTdWB2sid64AGzDYpyRwNPl84i52Rq2NKJK7iDDe/Gv6t7/kAPZuA87AT7Fqvx4lfjmjqx4sO5hvaY1wcZPJ4rr+fvs7qIZT8lj23T3G8MvokgeX9vsS7237mYuufnLW/l4sPfKldD4aEBRmKvJ0RggPquky1j+J2QKfK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dHdsPhym; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D9D1C4CEEA;
	Mon, 23 Jun 2025 14:08:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750687744;
	bh=sIqaqHwoR/cVtxIhgcxx2ZVcUkiubyrehXo3GcWtKOc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=dHdsPhymHpCpP1L1rpiiuVh9anWKDbUGp+dOsOPmO4OQHE+kU+Zi18fE4bLaexYrK
	 gUoN90qEMebw6mZqVEPlvabq2eThh8jpVLRCedMrM9eSnmX3GOFuVtEOseL+YdN3wn
	 X8qzapUuQcmNdjX6GIaf4OcqNHI+q8NPq1HMYd9eexsJ6bIMOSDISjUzkr6ThA2YxS
	 ISPmeyDa0Yn46UlCpcxQuo8fPxQ1748dOTKvenwn7VFifTenNUleH0JxjjCZ6KgFWh
	 1JCXZsmFMs7pcYZDFQqjcAOKf3JPAOwPWPTW1qjaoHn3i8f4SdJWqCkjKdFaxTYuQu
	 SKrtpjjYZZkKA==
Date: Mon, 23 Jun 2025 19:35:32 +0530
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
Subject: Re: [PATCH v3 18/62] KVM: SVM: Disable (x2)AVIC IPI virtualization
 if CPU has erratum #1235
Message-ID: <jskiyda3defofthrtniugcdbcoftx4o5yvgt47koswq64qf7d7@2pzrr5v5yssy>
References: <20250611224604.313496-2-seanjc@google.com>
 <20250611224604.313496-20-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250611224604.313496-20-seanjc@google.com>

On Wed, Jun 11, 2025 at 03:45:21PM -0700, Sean Christopherson wrote:
> From: Maxim Levitsky <mlevitsk@redhat.com>
> 
> Disable IPI virtualization on AMD Family 17h CPUs (Zen2 and Zen1), as
> hardware doesn't reliably detect changes to the 'IsRunning' bit during ICR
> write emulation, and might fail to VM-Exit on the sending vCPU, if
> IsRunning was recently cleared.
> 
> The absence of the VM-Exit leads to KVM not waking (or triggering nested
> VM-Exit) of the target vCPU(s) of the IPI, which can lead to hung vCPUs,
  ^^^^^^^^^^^
  VM-Exit of)

> unbounded delays in L2 execution, etc.
> 
> To workaround the erratum, simply disable IPI virtualization, which
> prevents KVM from setting IsRunning and thus eliminates the race where
> hardware sees a stale IsRunning=1.  As a result, all ICR writes (except
> when "Self" shorthand is used) will VM-Exit and therefore be correctly
> emulated by KVM.
> 
> Disabling IPI virtualization does carry a performance penalty, but
> benchmarkng shows that enabling AVIC without IPI virtualization is still
> much better than not using AVIC at all, because AVIC still accelerates
> posted interrupts and the receiving end of the IPIs.
> 
> Note, when virtualizaing Self-IPIs, the CPU skips reading the physical ID
	     ^^^^^^^^^^^^^
	     virtualizing

> table and updates the vIRR directly (because the vCPU is by definition
> actively running), i.e. Self-IPI isn't susceptible to the erratum *and*
> is still accelerated by hardware.
> 
> Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> [sean: rebase, massage changelog, disallow user override]
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/svm/avic.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
> index 48c737e1200a..bf8b59556373 100644
> --- a/arch/x86/kvm/svm/avic.c
> +++ b/arch/x86/kvm/svm/avic.c
> @@ -1187,6 +1187,14 @@ bool avic_hardware_setup(void)
>  	if (x2avic_enabled)
>  		pr_info("x2AVIC enabled\n");
>  
> +	/*
> +	 * Disable IPI virtualization for AMD Family 17h CPUs (Zen1 and Zen2)
> +	 * due to erratum 1235, which results in missed GA log events and thus
							^^^^^^^^^^^^^
Not sure I understand the reference to GA log events here -- those are 
only for device interrupts and not IPIs.

> +	 * missed wake events for blocking vCPUs due to the CPU failing to see
> +	 * a software update to clear IsRunning.
> +	 */
> +	enable_ipiv = enable_ipiv && boot_cpu_data.x86 != 0x17;
> +

Apart from the above, this LGTM.
Acked-by: Naveen N Rao (AMD) <naveen@kernel.org>


- Naveen


