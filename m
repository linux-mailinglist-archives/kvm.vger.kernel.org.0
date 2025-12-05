Return-Path: <kvm+bounces-65316-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id A1CFDCA6386
	for <lists+kvm@lfdr.de>; Fri, 05 Dec 2025 07:25:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id EA9803058B8E
	for <lists+kvm@lfdr.de>; Fri,  5 Dec 2025 06:25:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A43CC2F39DA;
	Fri,  5 Dec 2025 06:25:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="EANK0zxv"
X-Original-To: kvm@vger.kernel.org
Received: from out30-97.freemail.mail.aliyun.com (out30-97.freemail.mail.aliyun.com [115.124.30.97])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED0B12E0B5C
	for <kvm@vger.kernel.org>; Fri,  5 Dec 2025 06:25:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.97
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764915920; cv=none; b=ns0PA05zOk5JhEkg3q1DIwj/cEFY8Zsb3w77DALXyvEAnZEWtvegJnG5+WX8sVXCcf4c1cbAsqL6iDvZQ2M3+SWc1/qhq4PQIWWHP7+B32/QHMEXPOR/sRMFY5sviFS2qkWKoK2dsfSULXeB9iUOgQM1JbOKobkvdUYIpQymi1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764915920; c=relaxed/simple;
	bh=0FpdJeGy3Q0ZrF6Dc/ArhnOePdc5iqrV2NpUYVBM9Gk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GWR3P6LA1B7Qq0ekb+bB3fouZj0+j6M2BEiY0YJkm3QuAsq6NmP1vFXyXB1iXA7rkTpOA98Mu4GeKY4GjfoUSfdCjxD+724OewwOC8KSMzT+eOGTZeJdSVFcMhkotnUFOey3c4IDNBTsZGRpk/pq5DKe/s9ebrj4B1a0PJUeigo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=EANK0zxv; arc=none smtp.client-ip=115.124.30.97
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1764915908; h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type;
	bh=pOM8ESUhCgXHF3aPTqSUKOu9YbGu/eNZGcUrooc+AG8=;
	b=EANK0zxvKNJhZUt+SpGFFeSl/OGbDVUGnvQlM+fVpzM0O9H1zOQH+NF8DfaIemH9f3lMjHojCmMC77c49Zy7OoKlzUVK2D53U43aqM/8OCLtKL7s7NMudJFlAGlFy53NwoLHxP/Dqpwqvjyl/rh+6CNQoXMk00ydT50mQPUpfaw=
Received: from localhost(mailfrom:yaoyuan@linux.alibaba.com fp:SMTPD_---0Wu6x.ch_1764915907 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 05 Dec 2025 14:25:08 +0800
Date: Fri, 5 Dec 2025 14:25:07 +0800
From: Yao Yuan <yaoyuan@linux.alibaba.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Oliver Upton <oupton@kernel.org>, 
	Zenghui Yu <yuzenghui@huawei.com>, Ben Horgan <ben.horgan@arm.com>
Subject: Re: [PATCH v3 5/9] KVM: arm64: Handle CSSIDR2_EL1 and SMIDR_EL1 in a
 generic way
Message-ID: <csa7ttcducyjm5z7tdnw7kimry7obkhflo4zknenw267b3shlp@t37ltcp6flps>
References: <20251204094806.3846619-1-maz@kernel.org>
 <20251204094806.3846619-6-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251204094806.3846619-6-maz@kernel.org>

On Thu, Dec 04, 2025 at 09:48:02AM +0800, Marc Zyngier wrote:
> Now that we can handle ID registers using the FEAT_IDST infrastrcuture,
> get rid of the handling of CSSIDR2_EL1 and SMIDR_EL1.
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/sys_regs.c | 2 --
>  1 file changed, 2 deletions(-)
>
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index ec3fbe0b8d525..ae1e72df1ed45 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -3399,8 +3399,6 @@ static const struct sys_reg_desc sys_reg_descs[] = {
>  	{ SYS_DESC(SYS_CCSIDR_EL1), access_ccsidr },
>  	{ SYS_DESC(SYS_CLIDR_EL1), access_clidr, reset_clidr, CLIDR_EL1,
>  	  .set_user = set_clidr, .val = ~CLIDR_EL1_RES0 },
> -	{ SYS_DESC(SYS_CCSIDR2_EL1), undef_access },
> -	{ SYS_DESC(SYS_SMIDR_EL1), undef_access },
Hi Marc,

I checked the arm ARM to make sure these 2 belong to ID space.

Reviewed-by: Yuan Yao <yaoyuan@linux.alibaba.com>

>  	IMPLEMENTATION_ID(AIDR_EL1, GENMASK_ULL(63, 0)),
>  	{ SYS_DESC(SYS_CSSELR_EL1), access_csselr, reset_unknown, CSSELR_EL1 },
>  	ID_FILTERED(CTR_EL0, ctr_el0,
> --
> 2.47.3

