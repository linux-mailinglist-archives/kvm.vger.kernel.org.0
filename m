Return-Path: <kvm+bounces-24014-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B97C3950880
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2024 17:07:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 731A6282D89
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2024 15:07:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 460EB1A0734;
	Tue, 13 Aug 2024 15:06:56 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 82F651A072C
	for <kvm@vger.kernel.org>; Tue, 13 Aug 2024 15:06:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723561615; cv=none; b=Xsthhp5s8dh2VexeAmKTQ8ev4Fi8iGyxF4rnN0hpxH9CZ9JLPjPXnqWpMLBS9GuNkVj/hcuYtS+eIOGTCYcDvmzphqL/hjNVsxIkT8Q3i5Kd2gSy1GBqNLEq+xcXUm9av3jcj1Iw3gD0WlN/74tBhljY/eXN+0WE+0g34Rl4qRg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723561615; c=relaxed/simple;
	bh=QpibTT59eRhgnFQprM5zNZ8yyf3H4QvIDg3G6x2zri8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qQuYHoQuiqe7AEQ8J85knAvBN1uOJEcQ787hWXWeUDlsdQWpXZkXRkwU1l/PPLtglwLyw0Se2wunSS1zSzqy9N1j9kH3CxPs2fBgFPIlOTRji6T0JaQFPH7KJs24kFlK+VOraxz8fc2tsRkfuJiLTrnmpkRqfjm4T03r2EqrWq8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 194E812FC;
	Tue, 13 Aug 2024 08:07:20 -0700 (PDT)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C86793F6A8;
	Tue, 13 Aug 2024 08:06:52 -0700 (PDT)
Date: Tue, 13 Aug 2024 16:06:50 +0100
From: Joey Gouly <joey.gouly@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org, James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: [PATCH 05/10] arm64: Add encoding for PIRE0_EL2
Message-ID: <20240813150650.GB3321997@e124191.cambridge.arm.com>
References: <20240813144738.2048302-1-maz@kernel.org>
 <20240813144738.2048302-6-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240813144738.2048302-6-maz@kernel.org>

On Tue, Aug 13, 2024 at 03:47:33PM +0100, Marc Zyngier wrote:
> PIRE0_EL2 is the equivalent of PIRE0_EL1 for the EL2&0 translation
> regime, and it is sorely missing from the sysreg file.
> 
> Add the sucker.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/tools/sysreg | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
> index 7ceaa1e0b4bc..8e1aed548e93 100644
> --- a/arch/arm64/tools/sysreg
> +++ b/arch/arm64/tools/sysreg
> @@ -2853,6 +2853,10 @@ Sysreg	PIRE0_EL12	3	5	10	2	2
>  Fields	PIRx_ELx
>  EndSysreg
>  
> +Sysreg	PIRE0_EL2	3	4	10	2	2
> +Fields	PIRx_ELx
> +EndSysreg
> +
>  Sysreg	PIR_EL1		3	0	10	2	3
>  Fields	PIRx_ELx
>  EndSysreg

Reviewed-by: Joey Gouly <joey.gouly@arm.com>

