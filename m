Return-Path: <kvm+bounces-44775-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 1E28BAA0D8E
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 15:34:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A02C41A812D2
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 13:35:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F0D112C17AE;
	Tue, 29 Apr 2025 13:34:42 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1305D1D63F2
	for <kvm@vger.kernel.org>; Tue, 29 Apr 2025 13:34:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745933682; cv=none; b=Ria6nXvjy0ykqbiG6ELmOyNlwKEJ7uDZWTt5YiEC+0he+N0mdBXEeIp7LT4uy11Ze2UgzD6qOqy3AcpjCg2u9pkH9qmPWPpo7iQyPiHETZIN3bdDzS+9D6bJ6vf5fyIuDkGbHdWJXIBa1F971Pd2MSkbB+7ohasixq83hChYkZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745933682; c=relaxed/simple;
	bh=D6JBBbUQDZG/CPoNWeIlzaW5z9Ba5ZRvycIS7RbdHMI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=p5X4NtCqwLFOkuc2wTFB0CZ6y3sS9OXrQaK4j7m/LmaX0cAmGEqfYo2kBZhAgnbAwPpurH4+bscxWzkXVFm5Eh6B6BmvDFrZ3tPoXH1PfjIlZYZL27iMLuBpnROC4g9fU+HxqyWpecjqFWr5VqlZZyB3qBVkPkWVV19VMecVFgg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 82F3D1515;
	Tue, 29 Apr 2025 06:34:33 -0700 (PDT)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 7898F3F673;
	Tue, 29 Apr 2025 06:34:38 -0700 (PDT)
Date: Tue, 29 Apr 2025 14:34:32 +0100
From: Joey Gouly <joey.gouly@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Mark Rutland <mark.rutland@arm.com>, Fuad Tabba <tabba@google.com>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v3 01/42] arm64: sysreg: Add ID_AA64ISAR1_EL1.LS64
 encoding for FEAT_LS64WB
Message-ID: <20250429133432.GA1859293@e124191.cambridge.arm.com>
References: <20250426122836.3341523-1-maz@kernel.org>
 <20250426122836.3341523-2-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250426122836.3341523-2-maz@kernel.org>

On Sat, Apr 26, 2025 at 01:27:55PM +0100, Marc Zyngier wrote:
> The 2024 extensions are adding yet another variant of LS64
> (aptly named FEAT_LS64WB) supporting LS64 accesses to write-back
> memory, as well as 32 byte single-copy atomic accesses using pairs
> of FP registers.
> 
> Add the relevant encoding to ID_AA64ISAR1_EL1.LS64.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/tools/sysreg | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
> index bdf044c5d11b6..e5da8848b66b5 100644
> --- a/arch/arm64/tools/sysreg
> +++ b/arch/arm64/tools/sysreg
> @@ -1466,6 +1466,7 @@ UnsignedEnum	63:60	LS64
>  	0b0001	LS64
>  	0b0010	LS64_V
>  	0b0011	LS64_ACCDATA
> +	0b0100	LS64WB
>  EndEnum
>  UnsignedEnum	59:56	XS
>  	0b0000	NI

Reviewed-by: Joey Gouly <joey.gouly@arm.com>

