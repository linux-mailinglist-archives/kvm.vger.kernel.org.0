Return-Path: <kvm+bounces-46056-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 15442AB1005
	for <lists+kvm@lfdr.de>; Fri,  9 May 2025 12:11:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5F88B1C252B1
	for <lists+kvm@lfdr.de>; Fri,  9 May 2025 10:11:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D5EB128EA41;
	Fri,  9 May 2025 10:11:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="oeJVqoXz"
X-Original-To: kvm@vger.kernel.org
Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58C4728DF5F
	for <kvm@vger.kernel.org>; Fri,  9 May 2025 10:11:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746785490; cv=none; b=qvpAxTz/bX/tOZe8qPmpL1IYXA/6nBHALGhg7y5vkoQM0Eohgpl8zazAWo/y41ndeBgAMSiozJy2V6S8+Y8Op39b01ks2v5Fuuy3Su9KrD3ATfV/085ZvhAsmwIlVoPnQ+kFrZCi2H83nrwEPGuaRYYwxu/0G0QgD8+n0/kucvI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746785490; c=relaxed/simple;
	bh=Ar0OFSFbAZYi+/eYa8H5g+BNAP9J4sNaDYBUw0iwgo8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aNWZZJQL52/YMweuzq5+o8j0OeQtCr3sNcG9EL913OyAeJiodUpRkrxetfoEze6OxHkllXXeZlEunspY/yfFHcdpy8kzLKU2oD3zvfEalpU7Mnb9eneYwOhjR04AgyVOIzQf0+cN8bxyhY/DP8W+d0CYz1Po7cXs8++T+JTZDCs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=oeJVqoXz; arc=none smtp.client-ip=95.215.58.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Fri, 9 May 2025 03:11:16 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1746785486;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=gADP7rDY+Aim+5KEmwjyMEJOxyUwFF8/OBHyG20/FUA=;
	b=oeJVqoXzqvHiRN3YALK3a5w3UYfGRpQO+N4t0GHjMe0EjZ8C4TJwY+s8DH22NNVQbEqZ8D
	aFg0CxBak1q68+mfPJhXLlnm9PjE5BKbYIdKEt06F6WG2iv2sCE7rXB00plRCQgSBWwnat
	7I8cKYIOA5Tub8dbHiaHpQnAqV0baRA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Eric Auger <eric.auger@redhat.com>,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
Subject: Re: [PATCH v3 02/17] KVM: arm64: nv: Allocate VNCR page when required
Message-ID: <aB3UxDxwXhz5iY9J@linux.dev>
References: <20250423151508.2961768-1-maz@kernel.org>
 <20250423151508.2961768-3-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250423151508.2961768-3-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Wed, Apr 23, 2025 at 04:14:53PM +0100, Marc Zyngier wrote:
> If running a NV guest on an ARMv8.4-NV capable system, let's
> allocate an additional page that will be used by the hypervisor
> to fulfill system register accesses.
> 
> Reviewed-by: Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/nested.c | 9 +++++++++
>  arch/arm64/kvm/reset.c  | 1 +
>  2 files changed, 10 insertions(+)
> 
> diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
> index 4a3fc11f7ecf3..884b3e25795c4 100644
> --- a/arch/arm64/kvm/nested.c
> +++ b/arch/arm64/kvm/nested.c
> @@ -55,6 +55,12 @@ int kvm_vcpu_init_nested(struct kvm_vcpu *vcpu)
>  	    !cpus_have_final_cap(ARM64_HAS_HCR_NV1))
>  		return -EINVAL;
>  
> +	if (!vcpu->arch.ctxt.vncr_array)
> +		vcpu->arch.ctxt.vncr_array = (u64 *)__get_free_page(GFP_KERNEL | __GFP_ZERO);

Think you want GFP_KERNEL_ACCOUNT here.

Thanks,
Oliver

