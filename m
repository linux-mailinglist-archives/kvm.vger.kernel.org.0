Return-Path: <kvm+bounces-53173-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D4B2DB0E6AD
	for <lists+kvm@lfdr.de>; Wed, 23 Jul 2025 00:47:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D52A23A6A19
	for <lists+kvm@lfdr.de>; Tue, 22 Jul 2025 22:46:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6A2F4289808;
	Tue, 22 Jul 2025 22:46:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="PtSYDgQF"
X-Original-To: kvm@vger.kernel.org
Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06D0E18FC91
	for <kvm@vger.kernel.org>; Tue, 22 Jul 2025 22:46:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753224410; cv=none; b=cG8Yg+ggAIsQw9WUBP9oe9Z/m0Rb77/ziFouuNstAA235vf2yqnEfYFNjHYwUtUzTLPv897WkeDpV3M51eHoJOMmu+gWc/+kTWIevfQI3atOzahY73VN+Lnjc7brk2PNkwbgaDWosBQjamAs4V9Qa2kigsr6gm9vxMrl0S44TcY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753224410; c=relaxed/simple;
	bh=XIUphyS9R5agE3V0TfEDBVxFJk0XGM5U4nRvYeEZPqg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fi29/bFiKR31YH2VzKXB+tXGzjst37bUuhMpNnIyflQP4+y74mnpKSOJU/WMWqDtXIw29mN2/ATmTFzh7cw6FbIKhfCw3k4f7/Kfkjyt7KKvA7UggXhxiSjRv/6qCt1Gasa/m4eMPy12Q6msvlgOAJAYa83M8lrYvH7tQpDLtrA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=PtSYDgQF; arc=none smtp.client-ip=91.218.175.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Tue, 22 Jul 2025 15:46:29 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1753224395;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=poYuBLo+FyteJvotbUIRXGnKl0U6/ba9ipHaVlY2UUk=;
	b=PtSYDgQFY+/+9zqYqgARX+ymZRw3lpYC9Glbw49QLvz3LG4D9WkGmnMOXQG1/coRucFm4z
	NEJB45btLP54Mqum3AV4BNAef/AKdNP+37zPFzRu7Pz1JHBWUSHktsWuZ1iDymyinECMnF
	iYOUj29fbNw1VimnSv879a6LwYWQU8k=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
	Sebastian Ott <sebott@redhat.com>,
	Andre Przywara <andre.przywara@arm.com>,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	David Woodhouse <dwmw@amazon.co.uk>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [RFC PATCH 2/2] KVM: arm64: vgic-its: Unmap all vPEs on shutdown
Message-ID: <aIAUxarULx3vC2MO@linux.dev>
References: <20250623132714.965474-1-dwmw2@infradead.org>
 <20250623132714.965474-2-dwmw2@infradead.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250623132714.965474-2-dwmw2@infradead.org>
X-Migadu-Flow: FLOW_OUT

On Mon, Jun 23, 2025 at 02:27:14PM +0100, David Woodhouse wrote:
> From: David Woodhouse <dwmw@amazon.co.uk>
> 
> We observed systems going dark on kexec, due to corruption of the new
> kernel's text (and sometimes the initrd). This was eventually determined
> to be caused by the vLPI pending tables used by the GIC in the previous
> kernel, which were not being quiesced properly.
> 
> Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
> ---
>  arch/arm64/kvm/arm.c          |  5 +++++
>  arch/arm64/kvm/vgic/vgic-v3.c | 14 ++++++++++++++
>  include/kvm/arm_vgic.h        |  2 ++
>  3 files changed, 21 insertions(+)
> 
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 38a91bb5d4c7..2b76f506bc2d 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -2164,6 +2164,11 @@ void kvm_arch_disable_virtualization_cpu(void)
>  		cpu_hyp_uninit(NULL);
>  }
>  
> +void kvm_arch_shutdown(void)
> +{
> +	kvm_vgic_v3_shutdown();
> +}
> +
>  #ifdef CONFIG_CPU_PM
>  static int hyp_init_cpu_pm_notifier(struct notifier_block *self,
>  				    unsigned long cmd,
> diff --git a/arch/arm64/kvm/vgic/vgic-v3.c b/arch/arm64/kvm/vgic/vgic-v3.c
> index b9ad7c42c5b0..6591e8d84855 100644
> --- a/arch/arm64/kvm/vgic/vgic-v3.c
> +++ b/arch/arm64/kvm/vgic/vgic-v3.c
> @@ -382,6 +382,20 @@ static void map_all_vpes(struct kvm *kvm)
>  						dist->its_vm.vpes[i]->irq));
>  }
>  
> +void kvm_vgic_v3_shutdown(void)
> +{
> +	struct kvm *kvm;
> +
> +	if (!kvm_vgic_global_state.has_gicv4_1)
> +		return;
> +
> +	mutex_lock(&kvm_lock);
> +	list_for_each_entry(kvm, &vm_list, vm_list) {
> +		unmap_all_vpes(kvm);
> +	}
> +	mutex_unlock(&kvm_lock);
> +}
> +

This presumes the vCPUs have already been quiesced which I'm guessing
is the case for you. The vPEs need to be made nonresident from the
redistributors prior to unmapping from the ITS to avoid consuming
unknown vPE state (IHI0069H.b 8.6.2).

So we'd probably need to deschedule the vPE in
kvm_arch_disable_virtualization_cpu() along with some awareness of
'kvm_rebooting'.

Thanks,
Oliver

