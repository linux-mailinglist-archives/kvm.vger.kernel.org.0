Return-Path: <kvm+bounces-53791-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 0F8D3B16F34
	for <lists+kvm@lfdr.de>; Thu, 31 Jul 2025 12:08:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4DFA27B1324
	for <lists+kvm@lfdr.de>; Thu, 31 Jul 2025 10:06:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 25E5029827E;
	Thu, 31 Jul 2025 10:08:09 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7DA8E20C461
	for <kvm@vger.kernel.org>; Thu, 31 Jul 2025 10:08:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753956488; cv=none; b=uw+wnb0u6Ep0ntdeHGmkg0B9yH9URon0hqpQC4w2Bsa7eDKkY4J6ILgu7KDVuKD4DiycnKiQFOPjBQ3OnNnPS18m2FYeXhPfd27qOAM0JGQadEc0mOx1uTl6UGW6BU+gUbIQ7i0bucXzuyTtrBvqwjmvFebGgcoq3WCQ1pS5bxM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753956488; c=relaxed/simple;
	bh=Y/BSnGaupmoJsvGT14lFvNu/TBOFcf4iyJsUPFheY84=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tu/OWTpoU3IptLDJsqC+kf3QhX+j+aTUXnAo96pfLW6Nx1LaINhvAHM5xIYiwAcWExAUJHYAr3GYfzHiLM6eZJAj/3MQsE8kBAClIOHaj/G/bfKeONvPZJGk9k9qAUdwwdtWVIAZy/mjZY/47E79miZ2Q1m0ldB6S7dKHG1nmsw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BBFE71D13;
	Thu, 31 Jul 2025 03:07:52 -0700 (PDT)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 77DC03F673;
	Thu, 31 Jul 2025 03:07:59 -0700 (PDT)
Date: Thu, 31 Jul 2025 11:07:54 +0100
From: Joey Gouly <joey.gouly@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH] KVM: arm64: nv: Properly check ESR_EL2.VNCR on taking a
 VNCR_EL2 related fault
Message-ID: <20250731100754.GA1470634@e124191.cambridge.arm.com>
References: <20250730101828.1168707-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250730101828.1168707-1-maz@kernel.org>

On Wed, Jul 30, 2025 at 11:18:28AM +0100, Marc Zyngier wrote:
> Instead of checking for the ESR_EL2.VNCR bit being set (the only case
> we should be here), we are actually testing random bits in ESR_EL2.DFSC.
> 
> 13 obviously being a lucky number, it matches both permission and
> translation fault status codes, which explains why we never saw it
> failing. This was found by inspection, while reviewing a vaguely
> related patch.
> 
> Whilst we're at it, turn the BUG_ON() into a WARN_ON_ONCE(), as
> exploding here is just silly.
> 
> Fixes: 069a05e535496 ("KVM: arm64: nv: Handle VNCR_EL2-triggered faults")
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Good spot!

Reviewed-by: Joey Gouly <joey.gouly@arm.com>

> ---
>  arch/arm64/kvm/nested.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
> index c6a4e8f384ac6..046dcfc8bf76b 100644
> --- a/arch/arm64/kvm/nested.c
> +++ b/arch/arm64/kvm/nested.c
> @@ -1287,7 +1287,7 @@ int kvm_handle_vncr_abort(struct kvm_vcpu *vcpu)
>  	struct vncr_tlb *vt = vcpu->arch.vncr_tlb;
>  	u64 esr = kvm_vcpu_get_esr(vcpu);
>  
> -	BUG_ON(!(esr & ESR_ELx_VNCR_SHIFT));
> +	WARN_ON_ONCE(!(esr & ESR_ELx_VNCR));
>  
>  	if (esr_fsc_is_permission_fault(esr)) {
>  		inject_vncr_perm(vcpu);
> -- 
> 2.39.2
> 

