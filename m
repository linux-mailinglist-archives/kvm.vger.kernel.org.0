Return-Path: <kvm+bounces-24671-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id F3FEF95913A
	for <lists+kvm@lfdr.de>; Wed, 21 Aug 2024 01:33:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A22A51F2489C
	for <lists+kvm@lfdr.de>; Tue, 20 Aug 2024 23:33:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 20E671C824D;
	Tue, 20 Aug 2024 23:33:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="N0XgiVxF"
X-Original-To: kvm@vger.kernel.org
Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EBFB14A4F0
	for <kvm@vger.kernel.org>; Tue, 20 Aug 2024 23:33:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724196831; cv=none; b=aFOoQNtTUB76xhEpz1w9DjtLMUZUi6OhRtqb4mFI0vYGwdN+iWS5eZKeyhm7Xu8L8evgz86RBG0KEFWcYmVCkDjKD6O3EDM2P6y2wZlFpT3NJdySUTp8YjLmaVBWag4zUDAySdcf+2WL7MXgHWpaILZIFB9Ar2XpRUtCTzPFOdk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724196831; c=relaxed/simple;
	bh=BKHJHbHa19Ih2gq/65r1haup2z8NnQNS+f8PkCCH9Og=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SGHy1QrFkU9lDKYcPw+qm3kzt9pkkJfY4h5VXMUDeylzra4r3Kus4soBPt8Tp0MM4kv+fKuguHbzdJi7mLYcbB0blhhmKpizg0o/+vlYeagCMdS0qRHoR3ubC0x+zPl7pzJJ7t0HbnZUMyTlpq9F0famxWM3g0X6qKY5oNRdfUU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=N0XgiVxF; arc=none smtp.client-ip=95.215.58.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Tue, 20 Aug 2024 16:33:40 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1724196826;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=pwtQbLYsFWwvfXXtgan0g6RHZJGMppl5MqjZKi/sPao=;
	b=N0XgiVxFcOhGDMyiWiGS98Cz/VCq3n0Z+pgSMRTwv2GH/Q5e0cPDpWKiH/BqXVumxvQX3+
	b2/5+regFQBHfgrqfBPukxC15aciH5i8T7nLdfSssAGHQniZo9mFIrGU16Q+l47nQOX95S
	+SMn5Awjl/Ifua6k6MCz29aiO2QYpkA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org, James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Alexander Potapenko <glider@google.com>
Subject: Re: [PATCH 04/12] KVM: arm64: Force GICv3 traps activa when no
 irqchip is configured on VHE
Message-ID: <ZsUn1E6Gytu40iOW@linux.dev>
References: <20240820100349.3544850-1-maz@kernel.org>
 <20240820100349.3544850-5-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240820100349.3544850-5-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

s/activa/active/

On Tue, Aug 20, 2024 at 11:03:41AM +0100, Marc Zyngier wrote:
> On a VHE system, no GICv3 traps get configured when no irqchip is
> present. This is not quite matching the "no GICv3" semantics that
> we want to present.
> 
> Force such traps to be configured in this case.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/vgic/vgic.c | 14 ++++++++++----
>  1 file changed, 10 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
> index 974849ea7101..2caa64415ff3 100644
> --- a/arch/arm64/kvm/vgic/vgic.c
> +++ b/arch/arm64/kvm/vgic/vgic.c
> @@ -917,10 +917,13 @@ void kvm_vgic_flush_hwstate(struct kvm_vcpu *vcpu)
>  
>  void kvm_vgic_load(struct kvm_vcpu *vcpu)
>  {
> -	if (unlikely(!vgic_initialized(vcpu->kvm)))
> +	if (unlikely(!irqchip_in_kernel(vcpu->kvm) || !vgic_initialized(vcpu->kvm))) {

Doesn't !vgic_initialized(vcpu->kvm) also cover the case of no irqchip
in kernel?

-- 
Thanks,
Oliver

