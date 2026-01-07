Return-Path: <kvm+bounces-67240-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 5A6B8CFF073
	for <lists+kvm@lfdr.de>; Wed, 07 Jan 2026 18:12:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 45066357012E
	for <lists+kvm@lfdr.de>; Wed,  7 Jan 2026 16:59:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D55D134E765;
	Wed,  7 Jan 2026 16:11:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="IP1gbG4h"
X-Original-To: kvm@vger.kernel.org
Received: from sinmsgout01.his.huawei.com (sinmsgout01.his.huawei.com [119.8.177.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B96D734C13B
	for <kvm@vger.kernel.org>; Wed,  7 Jan 2026 16:11:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=119.8.177.36
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767802309; cv=none; b=XEnYgfT/DkscUwLs3sgbP7esqfPSKxrA5r/9iGVPpbSAlXKcdvzmqApc5Xykssga0JoWp/bvZehK8zIKalSF4G4iEGCi3ryFZ7Dr4P4HoQy+WRrnZ+fpYY4+CzM07exd7qqn1bQquy7KD31MOanWCe6CqESD179n5fkIqfQ0DsE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767802309; c=relaxed/simple;
	bh=H7p093PbuyPCd0xz2rejhyv9A6nf+asOEhJYRLH2U3Y=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NtPv8Xw6ri971AkmB39lmeHXNbTH0Umm7l4LIkwiEFMTDXqYlpo1TUkGRGr7ynXG7IKjjzAQ3YDZ6r5ZzjwPhFt2HiSO/qNNaybiyjqyk3qzdju+PK1EzsV6ssNNvyNHwgh5tqiRJsoEk+FhynMFs8XBigxny7DwT+3IdhkdKnw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=IP1gbG4h; arc=none smtp.client-ip=119.8.177.36
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=RVt95oRL/KXDNdcI2dZusgPIXzVemppS5pbly2uJxJk=;
	b=IP1gbG4hSTj5/TzwaMlFRmEdxgdGiSknNJlNRL9Ja8zq8sGcwkkVseHCh8exT4TIKCYc5S+3r
	1sFL/+Ord8DzS7YNiuLawd4I9oqm0YjOF1XtPQsduiAcV9eSH8NeDFytbRSz/sRX/moPc5W2d/M
	TKX25nqHbOv84kdVtGA0onk=
Received: from frasgout.his.huawei.com (unknown [172.18.146.32])
	by sinmsgout01.his.huawei.com (SkyGuard) with ESMTPS id 4dmXz94T0vz1P7H7;
	Thu,  8 Jan 2026 00:09:09 +0800 (CST)
Received: from mail.maildlp.com (unknown [172.18.224.150])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4dmY1p2KWpzHnGdq;
	Thu,  8 Jan 2026 00:11:26 +0800 (CST)
Received: from dubpeml100005.china.huawei.com (unknown [7.214.146.113])
	by mail.maildlp.com (Postfix) with ESMTPS id BAE7C40565;
	Thu,  8 Jan 2026 00:11:32 +0800 (CST)
Received: from localhost (10.203.177.15) by dubpeml100005.china.huawei.com
 (7.214.146.113) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Wed, 7 Jan
 2026 16:11:31 +0000
Date: Wed, 7 Jan 2026 16:11:30 +0000
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
Subject: Re: [PATCH v2 27/36] KVM: arm64: gic-v5: Mandate architected PPI
 for PMU emulation on GICv5
Message-ID: <20260107161130.00006440@huawei.com>
In-Reply-To: <20251219155222.1383109-28-sascha.bischoff@arm.com>
References: <20251219155222.1383109-1-sascha.bischoff@arm.com>
	<20251219155222.1383109-28-sascha.bischoff@arm.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: lhrpeml500011.china.huawei.com (7.191.174.215) To
 dubpeml100005.china.huawei.com (7.214.146.113)

On Fri, 19 Dec 2025 15:52:45 +0000
Sascha Bischoff <Sascha.Bischoff@arm.com> wrote:

> Make it mandatory to use the architected PPI when running a GICv5
> guest. Attempts to set anything other than the architected PPI (23)
> are rejected.
> 
> Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
> ---
>  arch/arm64/kvm/pmu-emul.c | 14 ++++++++++++--
>  include/kvm/arm_pmu.h     |  5 ++++-
>  2 files changed, 16 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
> index afc838ea2503e..2d3b50dec6c5d 100644
> --- a/arch/arm64/kvm/pmu-emul.c
> +++ b/arch/arm64/kvm/pmu-emul.c
> @@ -962,8 +962,13 @@ static int kvm_arm_pmu_v3_init(struct kvm_vcpu *vcpu)
>  		if (!vgic_initialized(vcpu->kvm))
>  			return -ENODEV;
>  
> -		if (!kvm_arm_pmu_irq_initialized(vcpu))
> -			return -ENXIO;
> +		if (!kvm_arm_pmu_irq_initialized(vcpu)) {
> +			/* Use the architected irq number for GICv5. */
> +			if (vcpu->kvm->arch.vgic.vgic_model == KVM_DEV_TYPE_ARM_VGIC_V5)
> +				vcpu->arch.pmu.irq_num = KVM_ARMV8_PMU_GICV5_IRQ;
> +			else
> +				return -ENXIO;
Might as well flip logic and exit quickly on error.

			if (vcpu->kvm->arch.vgic.vgic_model != KVM_DEV_TYPE_ARM_VGIC_V5)
As before it might be nice to make the helper for this visible.

				return -ENXIO;

			vcpu->arch.pmu.irq_num = KVM_ARMV8_PMU_GICV5_IRQl;
		}
> +		}


