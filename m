Return-Path: <kvm+bounces-60804-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 50E0ABFA773
	for <lists+kvm@lfdr.de>; Wed, 22 Oct 2025 09:09:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 4A2BA4F6CE0
	for <lists+kvm@lfdr.de>; Wed, 22 Oct 2025 07:08:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D00DD2ECE96;
	Wed, 22 Oct 2025 07:08:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="sgn4JcuB"
X-Original-To: kvm@vger.kernel.org
Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24E3533F3
	for <kvm@vger.kernel.org>; Wed, 22 Oct 2025 07:08:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761116926; cv=none; b=sF3v81r4Khkg+6hLTGw5xlp0tFE7dHaA5GxIEBIgdv62tSTukab5DRrBRkKsWHSS5+PINwvZq6OsuRetMwmTgZc79e/QCx1Q3NbhYsPCLoZRLkxTZL6zctA5zfP9aOTgBnlpvSE4crbrsV0yd8DHAKlYsFP9Pj750cSytI3CGAg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761116926; c=relaxed/simple;
	bh=KyxkuKB4uG3+7R4X/Oipar1IhPzTuV6lz/ScJcpFF+k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=M+cCParHnKe63IJYgDq+0lxLmQc6NY7Zc8KrF9JfJORJSNic3gRjXgWKcZwzN+qJjVnpvBpui4RKj+vRNd9osl6LvhEudoLKKwCmaMZEL/YjY8rx4ltOCHmw2a9PgxuU0m/HweDC58nNHOSpTAjiBt/0e/l9EiVAZvLXVkY+HB4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=sgn4JcuB; arc=none smtp.client-ip=95.215.58.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Wed, 22 Oct 2025 00:08:25 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1761116910;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=mU1PzAZ1BNV26YpxLxNOHYihlxsG75VaTbtBXC0551E=;
	b=sgn4JcuBKRbZ9ae67O0U5ghHOKcyKfbwWuz5hcPwtARVGDEHH6RES+XCYIzpKBwCm7E/7p
	j65wKvesFRXwarjIcFP4aDZbysyOi0biVw/hQEExKmEnHfFd5t+vAdAsqxqp5aQSnHdUH2
	fdGmS+qMSB/aT3Xu8ACduhCLI8Gybks=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Peter Maydell <peter.maydell@linaro.org>
Subject: Re: [PATCH 3/3] KVM: arm64: Limit clearing of
 ID_{AA64PFR0,PFR1}_EL1.GIC to userspace irqchip
Message-ID: <aPiCmpn-Qhysv6Dn@linux.dev>
References: <20251013083207.518998-1-maz@kernel.org>
 <20251013083207.518998-4-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251013083207.518998-4-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Mon, Oct 13, 2025 at 09:32:07AM +0100, Marc Zyngier wrote:
> Now that the idreg's GIC field is in sync with the irqchip, limit
> the runtime clearing of these fields to the pathological case where
> we do not have an in-kernel GIC.
> 
> Fixes: 5cb57a1aff755 ("KVM: arm64: Zero ID_AA64PFR0_EL1.GIC when no GICv3 is presented to the guest")
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/sys_regs.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 73dcefe51a3e7..25cfd0f9541f5 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -5494,9 +5494,7 @@ int kvm_finalize_sys_regs(struct kvm_vcpu *vcpu)
>  
>  	guard(mutex)(&kvm->arch.config_lock);
>  
> -	if (!(static_branch_unlikely(&kvm_vgic_global_state.gicv3_cpuif) &&
> -	      irqchip_in_kernel(kvm) &&
> -	      kvm->arch.vgic.vgic_model == KVM_DEV_TYPE_ARM_VGIC_V3)) {
> +	if (!irqchip_in_kernel(kvm)) {
>  		kvm->arch.id_regs[IDREG_IDX(SYS_ID_AA64PFR0_EL1)] &= ~ID_AA64PFR0_EL1_GIC_MASK;
>  		kvm->arch.id_regs[IDREG_IDX(SYS_ID_PFR1_EL1)] &= ~ID_PFR1_EL1_GIC_MASK;

Pre-existing, but converting this to the accessors would be a good idea.

Thanks,
Oliver

