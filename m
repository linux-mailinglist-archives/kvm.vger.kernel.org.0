Return-Path: <kvm+bounces-49433-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E933EAD9014
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 16:50:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 63DD4188B7D3
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 14:51:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A973D1917D6;
	Fri, 13 Jun 2025 14:50:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KeCYzdXg"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B202C2E406;
	Fri, 13 Jun 2025 14:50:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749826233; cv=none; b=P4uvlzKfP8FnPaSIeutcaRjjtuGn21jcwaHFwmXm9T16Br7uONwk+ogEIRtlTf1jA1gHCKA8Z9VB51wmmhrmnTtHI6YxSSfjuiCXqBnlnf6SGPQWPUW9QMJuvGwh5t8w7dufcjH6wX5kzVKL201OTNcxE8hcNVOcDu54nsP9NIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749826233; c=relaxed/simple;
	bh=JD0gFeCUEl8TiGFgMAnaGs74gyKTlAHzY+Py5LzUKjQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=h5GZyW7nf27AfcGClIUN/B/R3CMW4aM5sJ+rcdVMSXYEYmRipKqwzlhQGqLm+UzXzJTpJRncNHbmMELBPikebVhdHaukbjbwYt7vQgMuo7W5HFCdPTRjwdGm38dqmPhNYv8+xD56a4kBHin32vASAPveecBRZLYb0xotoTVcYd8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KeCYzdXg; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA233C4CEF0;
	Fri, 13 Jun 2025 14:50:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749826233;
	bh=JD0gFeCUEl8TiGFgMAnaGs74gyKTlAHzY+Py5LzUKjQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=KeCYzdXgP26k1gwX5o9SSDgvrzbb28BxL4FBy5Z4db5fOz7SxhW8ES0V22rPFTmyO
	 fSAXyriI+USEQEoC0k+wqQiaK6dJzrOB77hzLfKvPFHhEIm3cEtZMGaY5vSFDunuDQ
	 3NEPfnlxEnKJSZ+HlKYH9R+NHwu62A/HjqeDgng+Ba89V9/pIVh/09PeWjucgBZMPF
	 6cZ2aPNCh8wF0+f0PGr8Rg4oyQC1iSLdy1aziraNRm96SCGy7MEUbTeO8PHocUzJyy
	 VHkahhYaBVPeD0Ic92roBA4VoMvLQOh6g0MYgQ1ZO1/FeI4o/GZTGyOI4fpYp7qz7G
	 lSsiuKFi8u6Jg==
Date: Fri, 13 Jun 2025 20:14:47 +0530
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
Subject: Re: [PATCH v3 11/62] KVM: SVM: Drop vcpu_svm's pointless
 avic_backing_page field
Message-ID: <h4ofo2jby6glf7v6u3p2tbx6ism6s2sxtwx2pclavxnyckec7u@2ysnvrtga7a3>
References: <20250611224604.313496-2-seanjc@google.com>
 <20250611224604.313496-13-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250611224604.313496-13-seanjc@google.com>

On Wed, Jun 11, 2025 at 03:45:14PM -0700, Sean Christopherson wrote:
> Drop vcpu_svm's avic_backing_page pointer and instead grab the physical
> address of KVM's vAPIC page directly from the source.  Getting a physical
> address from a kernel virtual address is not an expensive operation, and
> getting the physical address from a struct page is *more* expensive for
> CONFIG_SPARSEMEM=y kernels.  Regardless, none of the paths that consume
> the address are hot paths, i.e. shaving cycles is not a priority.
> 
> Eliminating the "cache" means KVM doesn't have to worry about the cache
> being invalid, which will simplify a future fix when dealing with vCPU IDs
> that are too big.
> 
> WARN if KVM attempts to allocate a vCPU's AVIC backing page without an
> in-kernel local APIC.  avic_init_vcpu() bails early if the APIC is not
> in-kernel, and KVM disallows enabling an in-kernel APIC after vCPUs have
> been created, i.e. it should be impossible to reach
> avic_init_backing_page() without the vAPIC being allocated.
> 
> Tested-by: Sairaj Kodilkar <sarunkod@amd.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/svm/avic.c | 6 ++----
>  arch/x86/kvm/svm/svm.h  | 1 -
>  2 files changed, 2 insertions(+), 5 deletions(-)

Reviewed-by: Naveen N Rao (AMD) <naveen@kernel.org>

- Naveen


