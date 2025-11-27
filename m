Return-Path: <kvm+bounces-64827-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id ECCF8C8CEE8
	for <lists+kvm@lfdr.de>; Thu, 27 Nov 2025 07:37:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A410B3AE237
	for <lists+kvm@lfdr.de>; Thu, 27 Nov 2025 06:37:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3842C2D0C6C;
	Thu, 27 Nov 2025 06:37:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="secg8Oj4"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 557311C84D7;
	Thu, 27 Nov 2025 06:37:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764225436; cv=none; b=imT/Dys9TLFkHIe3glLktdc+uMfmkgcYSd31QIDnHYNpRXLkc0BXUlEX8Hb8D1cXJxzTmajTnhbVbiNulJH5a4g367xAwcPx4UXyDJPI9Ge2WGdYwipx79syBAY5zOBitnrjNop76ocxR4rIC9gkKItiwxHma1lYNeBRSHGY2iQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764225436; c=relaxed/simple;
	bh=sxm/pZRxFK+AZN/1aSkLmnFO7vK7xwxEtuumkKqVWs4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tRMqslOlbeo5UyfdSfIDVNyj15y4sQtd/gwQxvHm5tsf62m9rEEY3M9ABHvMCo5Olt+hz0NZbRNLDxG3vXt79q0y2GjXFrz3+13oME6oSVViXAL1Zo2JaOZ+kIAXzq412WLboa+t8NAgftOJT52I/Zvb/8RIA8qK0tFU9yyt9Vk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=secg8Oj4; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAEB2C4CEF8;
	Thu, 27 Nov 2025 06:37:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764225434;
	bh=sxm/pZRxFK+AZN/1aSkLmnFO7vK7xwxEtuumkKqVWs4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=secg8Oj4iwk0hBvUbPFzz+j+hhH6cmpWPfG/YpGNTbMPOY3RnYZ5N4OjH7wwZS0Co
	 qCvrNf0E9cD1di0gSesJU3RyjrhKOYZsd+otKZvo+lyVA5MUzLWzlDCuyXuyIDU+Um
	 +XLT8oepfwvxr9eZ40IOFdemjnuEN/by4VV2XT+c1R1sQHrI4zgP+UHtbAiy+/RwiI
	 TOeJdje3X5DO1cAwEc26uND4nbttPkuEo/u4p9KYUyMa0r8uCpua2rDGf9CM7BduHI
	 FkETw4oXtXVDPhGx2crT5UJtTaqNYbmGsQs6eTReE4JJEEaWSSQQTIo6Gv2+lYbQCJ
	 aTKPQFA/phqgA==
Date: Wed, 26 Nov 2025 22:37:13 -0800
From: Oliver Upton <oupton@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>, Ben Horgan <ben.horgan@arm.com>
Subject: Re: [PATCH v2 2/5] KVM: arm64: Force trap of GMID_EL1 when the guest
 doesn't have MTE
Message-ID: <aSfxmQptJlCHhb0M@kernel.org>
References: <20251126155951.1146317-1-maz@kernel.org>
 <20251126155951.1146317-3-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251126155951.1146317-3-maz@kernel.org>

On Wed, Nov 26, 2025 at 03:59:48PM +0000, Marc Zyngier wrote:
> If our host has MTE, but the guest doesn't, make sure we set HCR_EL2.TID5
> to force GMID_EL1 being trapped.
> 
> Reviewed-by: Joey Gouly <joey.gouly@arm.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/sys_regs.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 9e4c46fbfd802..2ca6862e935b5 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -5561,6 +5561,8 @@ static void vcpu_set_hcr(struct kvm_vcpu *vcpu)
>  
>  	if (kvm_has_mte(vcpu->kvm))
>  		vcpu->arch.hcr_el2 |= HCR_ATA;
> +	else if (id_aa64pfr1_mte(read_sanitised_ftr_reg(SYS_ID_AA64PFR1_EL1)))

This helper is ugly!

> +		vcpu->arch.hcr_el2 |= HCR_TID5;

How about setting the trap unconditionally when !kvm_has_mte()? Even in
the case of asymmetry we'd want GMID_EL1 to trap.

Thanks,
Oliver

