Return-Path: <kvm+bounces-62282-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0438EC3F515
	for <lists+kvm@lfdr.de>; Fri, 07 Nov 2025 11:07:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7C8E23B2839
	for <lists+kvm@lfdr.de>; Fri,  7 Nov 2025 10:06:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 059632F549C;
	Fri,  7 Nov 2025 10:06:29 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D354B1E51EE
	for <kvm@vger.kernel.org>; Fri,  7 Nov 2025 10:06:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762509988; cv=none; b=eKNWZsV2HzBVfxvEpuLpXR2oNl7b6s44FcBc+yR+UvM6yEn9IW3vMy/GrKJ7d/9IIBwE2Tha86dvuPqmMiDD6lXOt2TOVLGAjAEHMXUlNvjhTlfvrIZBhII6id0P8fdSSUlZtbutClM/pX7priobcYgQflhnAl0hY+kTg0YaDN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762509988; c=relaxed/simple;
	bh=e1JOdRzLeuWX3PVxN52agD5YetnAyZ0LklkuKw8GlZM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GjPJJGGcdF1cJIoNwm96rTEdFhrLzXN7K1L9VlQBR1bc8DvVJmzzIzxqQJb2un7A6/qIyTT1rLvTqD+Nz2ofoHbW+IaEa8NSpuQyfeuOYFa1L3Z5RPwvwusfMOIyeujxNcBzqlBbEaJI7bndxc+1j0X2wONKasAEqo0u1aML9yY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7C75E14BF;
	Fri,  7 Nov 2025 02:06:18 -0800 (PST)
Received: from [10.1.197.1] (ewhatever.cambridge.arm.com [10.1.197.1])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 496A53F66E;
	Fri,  7 Nov 2025 02:06:25 -0800 (PST)
Message-ID: <264b9f2d-5fca-4fda-a0ce-1b0223906560@arm.com>
Date: Fri, 7 Nov 2025 10:06:23 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/3] KVM: arm64: Fix handling of ID_PFR1_EL1.GIC
To: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
 linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>, Oliver Upton <oliver.upton@linux.dev>,
 Zenghui Yu <yuzenghui@huawei.com>, Peter Maydell <peter.maydell@linaro.org>
References: <20251030122707.2033690-1-maz@kernel.org>
Content-Language: en-US
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <20251030122707.2033690-1-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Marc

On 30/10/2025 12:27, Marc Zyngier wrote:
> Peter reported[0] that restoring a GICv2 VM fails badly, and correctly
> points out that ID_PFR1_EL1.GIC isn't writable, while its 64bit
> equivalent is. I broke that in 6.12.
> 
> The other thing is that fixing the ID regs at runtime isn't great.
> specially when we could adjust them at the point where the GIC gets
> created.
> 
> This small series aims at fixing these issues. I've only tagged the
> first one as a stable candidate. 

But, all 3 patches have the same Fixes tag, was that intentional ?

Otherwise looks good.

Suzuki


With these fixes, I can happily



> save/restore a GICv2 VM (both 32 and 64bit) on my trusty Synquacer.
> 
> * From v1 [1]:
> 
>    - Make all 32bit ID regs writable
> 
>    - Use official accessors to manipulate ID regs
> 
>    - Rebased on 6.18-rc3
> 
> [0] https://lore.kernel.org/r/CAFEAcA8TpQduexT=8rdRYC=yxm_073COjzgWJAvc26_T+-F5vA@mail.gmail.com
> [3] https://lore.kernel.org/r/20251013083207.518998-1-maz@kernel.org
> 
> Marc Zyngier (3):
>    KVM: arm64: Make all 32bit ID registers fully writable
>    KVM: arm64: Set ID_{AA64PFR0,PFR1}_EL1.GIC when GICv3 is configured
>    KVM: arm64: Limit clearing of ID_{AA64PFR0,PFR1}_EL1.GIC to userspace
>      irqchip
> 
>   arch/arm64/kvm/sys_regs.c       | 71 ++++++++++++++++++---------------
>   arch/arm64/kvm/vgic/vgic-init.c | 14 ++++++-
>   2 files changed, 50 insertions(+), 35 deletions(-)
> 


