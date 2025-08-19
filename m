Return-Path: <kvm+bounces-54973-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 3E64FB2BED8
	for <lists+kvm@lfdr.de>; Tue, 19 Aug 2025 12:25:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5E0F21B607C4
	for <lists+kvm@lfdr.de>; Tue, 19 Aug 2025 10:25:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B5FC231579D;
	Tue, 19 Aug 2025 10:25:20 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8F733311592
	for <kvm@vger.kernel.org>; Tue, 19 Aug 2025 10:25:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755599120; cv=none; b=H8ExSV/+LLBVwCDfwNURdUzTLlmGwCuC8Kq4Ze8/A/f94/ygVqWjRK8y+DQMjfePlo0XWHxCFzApjg1d8GlVbJxnhH6rIFkIjhP6oncifFt/AhdTq1k3DR6kuVugh9M2vTBpOXYFL79QB4SomMB5YRtE2oEgvuEHau86yj1A2M8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755599120; c=relaxed/simple;
	bh=mPIHHNKtAx3hLVCW0P5StnhWD+LRvarGR1wp+gxgprA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OPaLV6S8sERkULmSbW6I0by6hT13yvDNUPrQTGn8XQTIThE60XjaV0cvL/BA1NkS3QFel+NxP7MMzMVLHsFISVG3RCsmHziAxwVqBSgyit+fMF6WFwCH8hR2ho+UcKVECeaSrcRw/QsVFHmjpAemyBXeo3wB53NSiEnG3oZcJzs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B0CF81BD0;
	Tue, 19 Aug 2025 03:25:08 -0700 (PDT)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2C0B33F63F;
	Tue, 19 Aug 2025 03:25:15 -0700 (PDT)
Date: Tue, 19 Aug 2025 11:24:34 +0100
From: Joey Gouly <joey.gouly@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org, Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>, Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Cornelia Huck <cohuck@redhat.com>
Subject: Re: [PATCH v3 3/6] KVM: arm64: Ignore HCR_EL2.FIEN set by L1 guest's
 EL2
Message-ID: <20250819102434.GA3736290@e124191.cambridge.arm.com>
References: <20250817202158.395078-1-maz@kernel.org>
 <20250817202158.395078-4-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250817202158.395078-4-maz@kernel.org>

On Sun, Aug 17, 2025 at 09:21:55PM +0100, Marc Zyngier wrote:
> An EL2 guest can set HCR_EL2.FIEN, which gives access to the RASv1p1
> fault injection mechanism. This would allow an EL1 guest to inject
> error records into the system, which does sound like a terrible idea.
> 
> Prevent this situation by added FIEN to the list of bits we silently
> exclude from being inserted into the host configuration.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Reviewed-by: Joey Gouly <joey.gouly@arm.com>

> ---
>  arch/arm64/kvm/hyp/vhe/switch.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
> index e482181c66322..0998ad4a25524 100644
> --- a/arch/arm64/kvm/hyp/vhe/switch.c
> +++ b/arch/arm64/kvm/hyp/vhe/switch.c
> @@ -43,8 +43,11 @@ DEFINE_PER_CPU(unsigned long, kvm_hyp_vector);
>   *
>   * - API/APK: they are already accounted for by vcpu_load(), and can
>   *   only take effect across a load/put cycle (such as ERET)
> + *
> + * - FIEN: no way we let a guest have access to the RAS "Common Fault
> + *   Injection" thing, whatever that does
>   */
> -#define NV_HCR_GUEST_EXCLUDE	(HCR_TGE | HCR_API | HCR_APK)
> +#define NV_HCR_GUEST_EXCLUDE	(HCR_TGE | HCR_API | HCR_APK | HCR_FIEN)
>  
>  static u64 __compute_hcr(struct kvm_vcpu *vcpu)
>  {
> -- 
> 2.39.2
> 

