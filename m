Return-Path: <kvm+bounces-64822-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 52EE2C8CE1A
	for <lists+kvm@lfdr.de>; Thu, 27 Nov 2025 06:53:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 19F5A3AC6E1
	for <lists+kvm@lfdr.de>; Thu, 27 Nov 2025 05:52:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CAC9627D786;
	Thu, 27 Nov 2025 05:52:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="LR7efaNF"
X-Original-To: kvm@vger.kernel.org
Received: from out30-110.freemail.mail.aliyun.com (out30-110.freemail.mail.aliyun.com [115.124.30.110])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8B90258EFB
	for <kvm@vger.kernel.org>; Thu, 27 Nov 2025 05:52:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.110
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764222774; cv=none; b=L/SpZ+KYbaVlhXuUkOmzPfiPzRV3vP0lqXTtn0HNJqzOMkZM9DkDkB3zWsN3MBGSmag+V3m0dhADEW3R/NhmfOqvkFygRSKf39qwCyni6cXXMuk+g4Dce1tAkWOEjTcgieyw0tZmlB82p0FJ8TDSYglGSleXq5f/w4cOpEJAHBU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764222774; c=relaxed/simple;
	bh=ISAFkZ0HmitTgmmDConEYXzcz7D+u6fWEkB3O+gmCY0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Xi8v/1ZmbUDZynyq/176z6ZGUHRdkvgzwra7YN17pw0T4LGY+6lRjZErAKpkpJR8lHhsouXvNtQ8iEyC9IGte0s6ofbqWx/Rly3tDrl1NbdPIAglJ68LoPtFEKoCSY9EMR5QyOBJuwdR4EHRqa+yOIM0mN6QYdJe3z2mimWQYeA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=LR7efaNF; arc=none smtp.client-ip=115.124.30.110
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1764222763; h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type;
	bh=8n0RK31A+ec3zN8vE8zvo+3qlTZfSr6qORtM7xzltbs=;
	b=LR7efaNFKEj7V1DnO7ng3pgwK3eEPCIqo7LKHWozi2Rl8rMKlVPWQqWe3a6fApnru2YwJ9gYNG+6oso1n2EY/lVlFFsd9oulilpzjM10238qbecQs6UgGTDnZdnmQwJQNSEUVuR90KxbMH04EBJROHJBaVIr6FsS7aROx+pGTCY=
Received: from localhost(mailfrom:yaoyuan@linux.alibaba.com fp:SMTPD_---0WtW0l1z_1764222762 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 27 Nov 2025 13:52:43 +0800
Date: Thu, 27 Nov 2025 13:52:42 +0800
From: Yao Yuan <yaoyuan@linux.alibaba.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Oliver Upton <oupton@kernel.org>, 
	Zenghui Yu <yuzenghui@huawei.com>, Ben Horgan <ben.horgan@arm.com>
Subject: Re: [PATCH v2 2/5] KVM: arm64: Force trap of GMID_EL1 when the guest
 doesn't have MTE
Message-ID: <itxexyotztmtvuvcbs4wjcdod3tfpufqe5t2gmz6vyky3vtihs@a3atxxjadgfq>
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

Hi Marc,

On Wed, Nov 26, 2025 at 03:59:48PM +0800, Marc Zyngier wrote:
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
> +		vcpu->arch.hcr_el2 |= HCR_TID5;

Reviewed-by: Yuan Yao <yaoyuan@linux.alibaba.com>

>
>  	/*
>  	 * In the absence of FGT, we cannot independently trap TLBI
> --
> 2.47.3
>

