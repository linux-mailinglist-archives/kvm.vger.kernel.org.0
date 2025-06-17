Return-Path: <kvm+bounces-49713-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E71F5ADD002
	for <lists+kvm@lfdr.de>; Tue, 17 Jun 2025 16:35:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 85B00163581
	for <lists+kvm@lfdr.de>; Tue, 17 Jun 2025 14:30:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B44A52EF668;
	Tue, 17 Jun 2025 14:30:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QDe3FgWK"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C26842EF664;
	Tue, 17 Jun 2025 14:30:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750170618; cv=none; b=CQY6n1YPYARtAGB2q9QQ2BLFMZldH3n9YjLDKtHTQgosdZMInxBpF2KO7SxKGyP0P2sfKK3VG/AyX1O5Nxm23FnljWyG4g2SJKAyd6MAdQvxyI7bQSDofwHc93nRHjhEiP2dcxP82Y4j2H86kz6MWwlJW6H/MBOfXKqxhP5JolY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750170618; c=relaxed/simple;
	bh=fr2XMAsOts3e2z91VRBihiSkUtLYOX60usFN8g0EWAQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=S2+RdkCtpMA6XlGtruNHEVsWhzfbYMtTVstXkLHtbIFNmfL1q+QuHynAz3JviQw7yMz4gWkJqhavOB/vfQ6Re92STD3+o/i9iyOTRnFtXj70aJy+6ggPjizYnbGTA9LgD8vqPUSOsWTSIbph/y14LEZajEyvpn9qDHNEOMtJAVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QDe3FgWK; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9838C4CEE7;
	Tue, 17 Jun 2025 14:30:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750170618;
	bh=fr2XMAsOts3e2z91VRBihiSkUtLYOX60usFN8g0EWAQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=QDe3FgWKdRYt+BIzMKBQF3t5wcdsgovRo8kcvLAZPRvtxyXl1IvJ1uNlEJh8U4szk
	 WfnBWWcVDZzqXI61sDtZK990vZVY38xyHXdM8ZsdmGlYrWlwx9hSAd5jzQh+JAMcXz
	 4UEuHs04KEVpn53uSj9FF9SyIfJ2TnYQ0oGXkwZw7S2c7eR/8u3FrqK1UJ/EVyn7J2
	 FFrE/9UrKWA1xYiEFfIF+1CF254i3hvfP53fi2s9JlXyyKs/yG9t+uET8HDMiY7EM9
	 lWYelt+tdc7MIPGZhMbltC42Afg6OnmSi0RmZVMPObkuYfe1NmfQf1XhBBxdk4SbUw
	 0Rrk2MzTfwCJA==
Date: Tue, 17 Jun 2025 19:55:01 +0530
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
Subject: Re: [PATCH v3 12/62] KVM: SVM: Inhibit AVIC if ID is too big instead
 of rejecting vCPU creation
Message-ID: <bmx43lru6mwdyun3ktcmoeezqw6baih7vgtykolsrmu5q2x7vu@xp5jrbbqwzej>
References: <20250611224604.313496-2-seanjc@google.com>
 <20250611224604.313496-14-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250611224604.313496-14-seanjc@google.com>

On Wed, Jun 11, 2025 at 03:45:15PM -0700, Sean Christopherson wrote:
> Inhibit AVIC with a new "ID too big" flag if userspace creates a vCPU with
> an ID that is too big, but otherwise allow vCPU creation to succeed.
> Rejecting KVM_CREATE_VCPU with EINVAL violates KVM's ABI as KVM advertises
> that the max vCPU ID is 4095, but disallows creating vCPUs with IDs bigger
> than 254 (AVIC) or 511 (x2AVIC).
> 
> Alternatively, KVM could advertise an accurate value depending on which
> AVIC mode is in use, but that wouldn't really solve the underlying problem,
> e.g. would be a breaking change if KVM were to ever try and enable AVIC or
> x2AVIC by default.
> 
> Cc: Maxim Levitsky <mlevitsk@redhat.com>
> Tested-by: Sairaj Kodilkar <sarunkod@amd.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/include/asm/kvm_host.h |  9 ++++++++-
>  arch/x86/kvm/svm/avic.c         | 14 ++++++++++++--
>  arch/x86/kvm/svm/svm.h          |  3 ++-
>  3 files changed, 22 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 2a6ef1398da7..a9b709db7c59 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1314,6 +1314,12 @@ enum kvm_apicv_inhibit {
>  	 */
>  	APICV_INHIBIT_REASON_LOGICAL_ID_ALIASED,
>  
> +	/*
> +	 * AVIC is disabled because the vCPU's APIC ID is beyond the max
> +	 * supported by AVIC/x2AVIC, i.e. the vCPU is unaddressable.
> +	 */
> +	APICV_INHIBIT_REASON_PHYSICAL_ID_TOO_BIG,
> +
>  	NR_APICV_INHIBIT_REASONS,
>  };
>  
> @@ -1332,7 +1338,8 @@ enum kvm_apicv_inhibit {
>  	__APICV_INHIBIT_REASON(IRQWIN),			\
>  	__APICV_INHIBIT_REASON(PIT_REINJ),		\
>  	__APICV_INHIBIT_REASON(SEV),			\
> -	__APICV_INHIBIT_REASON(LOGICAL_ID_ALIASED)
> +	__APICV_INHIBIT_REASON(LOGICAL_ID_ALIASED),	\
> +	__APICV_INHIBIT_REASON(PHYSICAL_ID_TOO_BIG)
>  
>  struct kvm_arch {
>  	unsigned long n_used_mmu_pages;
> diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
> index ab228872a19b..f0a74b102c57 100644
> --- a/arch/x86/kvm/svm/avic.c
> +++ b/arch/x86/kvm/svm/avic.c
> @@ -277,9 +277,19 @@ static int avic_init_backing_page(struct kvm_vcpu *vcpu)
>  	int id = vcpu->vcpu_id;
>  	struct vcpu_svm *svm = to_svm(vcpu);
>  
> +	/*
> +	 * Inhibit AVIC if the vCPU ID is bigger than what is supported by AVIC
> +	 * hardware.  Immediately clear apicv_active, i.e. don't wait until the
> +	 * KVM_REQ_APICV_UPDATE request is processed on the first KVM_RUN, as
> +	 * avic_vcpu_load() expects to be called if and only if the vCPU has
> +	 * fully initialized AVIC.
> +	 */
>  	if ((!x2avic_enabled && id > AVIC_MAX_PHYSICAL_ID) ||
> -	    (id > X2AVIC_MAX_PHYSICAL_ID))
> -		return -EINVAL;
> +	    (id > X2AVIC_MAX_PHYSICAL_ID)) {
> +		kvm_set_apicv_inhibit(vcpu->kvm, APICV_INHIBIT_REASON_PHYSICAL_ID_TOO_BIG);
> +		vcpu->arch.apic->apicv_active = false;

This bothers me a bit. kvm_create_lapic() does this:
          if (enable_apicv) {
                  apic->apicv_active = true;
                  kvm_make_request(KVM_REQ_APICV_UPDATE, vcpu);
	  }

But, setting apic->apicv_active to false here means KVM_REQ_APICV_UPDATE 
is going to be a no-op.

This does not look to be a big deal given that kvm_create_lapic() itself 
is called just a bit before svm_vcpu_create() (which calls the above 
function through avic_init_vcpu()) in kvm_arch_vcpu_create(), so there 
isn't that much done before apicv_active is toggled.

But, this made me wonder if introducing a kvm_x86_op to check and 
enable/disable apic->apicv_active in kvm_create_lapic() might be cleaner 
overall. Maybe even have it be the initialization point for APICv: 
apicv_init(), so we can invoke avic_init_vcpu() right away?


- Naveen


