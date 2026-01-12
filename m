Return-Path: <kvm+bounces-67784-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 725ADD141FE
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 17:44:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 23FB43015165
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 16:42:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 408A634D383;
	Mon, 12 Jan 2026 16:42:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="BbiUjK5U"
X-Original-To: kvm@vger.kernel.org
Received: from sinmsgout03.his.huawei.com (sinmsgout03.his.huawei.com [119.8.177.38])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55A4D366557
	for <kvm@vger.kernel.org>; Mon, 12 Jan 2026 16:42:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=119.8.177.38
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768236153; cv=none; b=f1pjNiYopFCSOD6CjvP+VaQviKU73R6vLYRYZIGSQBzvRxZ0IWQLcwWFfB3klRSFS0KJX/zNv4RIhvAdP1E6dNGY84eXNPi1VdXrXvk8W0p8EzyA93dcA7vATiE0l8jTxyBqTMbBbd6zzXeTOzqMqrVnLiMwJd+QeFcwB+7y5fQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768236153; c=relaxed/simple;
	bh=GCV/3QBtc+eIdYfvw5hxOGvLLmtdFxdHoXyuuvKPKYM=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ri7OGcWaZIl9wsT4qmTbjRqqNsuvwtKz1eY5hJy1wQeECyatm9Z12P6hk8JT2FFD9VCmzx3Z7hCq4tglARBcu7/H68hjV15afg+Bj7p3QZu4SjS9CUAmvaf1cECm8R8s0k7FXGjUGtcobPe9OdZLTnyqHWD1YNaGL/lL26Fx+sI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=BbiUjK5U; arc=none smtp.client-ip=119.8.177.38
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=eZmC8E9x0lsORQcKBHO7BPce7Bp4VCsTTDrVTj1p9/k=;
	b=BbiUjK5UomxqSiXsKG9eFzkpXanoKP+1SBcbtDaePrflU8sK/g28VzaBCBsf8TdrXeuVEpFVt
	bXLPjve1C4smFydsDNsbelt8NqQaGS/jbc3M5UeJV2867Fny+cCBph7iHOgWfPERst3eyCOdvJX
	Ro/y+PTtKpmuNgmNFB/6bKw=
Received: from frasgout.his.huawei.com (unknown [172.18.146.33])
	by sinmsgout03.his.huawei.com (SkyGuard) with ESMTPS id 4dqdQc4Bw1zMksc;
	Tue, 13 Jan 2026 00:40:08 +0800 (CST)
Received: from mail.maildlp.com (unknown [172.18.224.83])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4dqdSx2mVMzJ46F7;
	Tue, 13 Jan 2026 00:42:09 +0800 (CST)
Received: from dubpeml100005.china.huawei.com (unknown [7.214.146.113])
	by mail.maildlp.com (Postfix) with ESMTPS id 050C340086;
	Tue, 13 Jan 2026 00:42:21 +0800 (CST)
Received: from localhost (10.203.177.15) by dubpeml100005.china.huawei.com
 (7.214.146.113) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Mon, 12 Jan
 2026 16:42:20 +0000
Date: Mon, 12 Jan 2026 16:42:19 +0000
From: Jonathan Cameron <jonathan.cameron@huawei.com>
To: Sascha Bischoff <Sascha.Bischoff@arm.com>
CC: "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, nd
	<nd@arm.com>, "maz@kernel.org" <maz@kernel.org>, "oliver.upton@linux.dev"
	<oliver.upton@linux.dev>, Joey Gouly <Joey.Gouly@arm.com>, Suzuki Poulose
	<Suzuki.Poulose@arm.com>, "yuzenghui@huawei.com" <yuzenghui@huawei.com>,
	"peter.maydell@linaro.org" <peter.maydell@linaro.org>,
	"lpieralisi@kernel.org" <lpieralisi@kernel.org>, Timothy Hayes
	<Timothy.Hayes@arm.com>
Subject: Re: [PATCH v3 36/36] KVM: arm64: gic-v5: Communicate
 userspace-driveable PPIs via a UAPI
Message-ID: <20260112164219.00001d70@huawei.com>
In-Reply-To: <20260109170400.1585048-37-sascha.bischoff@arm.com>
References: <20260109170400.1585048-1-sascha.bischoff@arm.com>
	<20260109170400.1585048-37-sascha.bischoff@arm.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: lhrpeml100010.china.huawei.com (7.191.174.197) To
 dubpeml100005.china.huawei.com (7.214.146.113)

On Fri, 9 Jan 2026 17:04:50 +0000
Sascha Bischoff <Sascha.Bischoff@arm.com> wrote:

> GICv5 systems will likely not support the full set of PPIs. The
> presence of any virtual PPI is tied to the presence of the physical
> PPI. Therefore, the available PPIs will be limited by the physical
> host. Userspace cannot drive any PPIs that are not implemented.
> 
> Moreover, it is not desirable to expose all PPIs to the guest in the
> first place, even if they are supported in hardware. Some devices,
> such as the arch timer, are implemented in KVM, and hence those PPIs
> shouldn't be driven by userspace, either.
> 
> Provided a new UAPI:
>   KVM_DEV_ARM_VGIC_GRP_CTRL => KVM_DEV_ARM_VGIC_USERPSPACE_PPIs
> 
> This allows userspace to query which PPIs it is able to drive via
> KVM_IRQ_LINE.
> 
> Additionally, introduce a check in kvm_vm_ioctl_irq_line() to reject
> any PPIs not in the userspace mask.
> 
> Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
> 
> FOLD: Limit KVM_IRQ_LINE PPIs

Looks like you did a squash rather than a fixup merge and failed to drop this.

Otherwise, just one trivial thing below.

Thanks,

Jonathan

> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 1cfd1e53b060e..e15c97395f50f 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -1437,6 +1437,14 @@ int kvm_vm_ioctl_irq_line(struct kvm *kvm, struct kvm_irq_level *irq_level,
>  			if (irq_num >= VGIC_V5_NR_PRIVATE_IRQS)
>  				return -EINVAL;
>  
> +			/*
> +			 * Only allow PPIs that are explicitly exposed to
> +			 * usespace to be driven via KVM_IRQ_LINE
> +			 */
> +			u64 mask = kvm->arch.vgic.gicv5_vm.userspace_ppis[irq_num / 64];

Inline declarations are still normally limited to when we need to have
them, e.g for cleanup.h stuff.  So declare mask at top of appropriate
scope.

> +			if (!(mask & BIT_ULL(irq_num % 64)))
> +				return -EINVAL;
> +
>  			/* Build a GICv5-style IntID here */
>  			irq_num |= FIELD_PREP(GICV5_HWIRQ_TYPE, GICV5_HWIRQ_TYPE_PPI);
>  		} else if (irq_num < VGIC_NR_SGIS ||



