Return-Path: <kvm+bounces-23335-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 37585948C1F
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2024 11:24:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 696AA1C23051
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2024 09:24:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E303D1BDA96;
	Tue,  6 Aug 2024 09:23:59 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3586F161900
	for <kvm@vger.kernel.org>; Tue,  6 Aug 2024 09:23:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722936239; cv=none; b=ARIkM4pJ+svclQuRGlX0emE3ImmPQCIwvV/KrrpAqGPp3btIPGECyrrkRx7hLnTpTpnBJslfjY05ns17Tj4/xmNfazulu6A0amaoVWG8LytmBFmPLI4LdcySyt0dofczIo9MlzSfLDArf3iukpGLIgrqDj79Purfg2/8hu0s+xw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722936239; c=relaxed/simple;
	bh=zsDFLloGSiIW6aScJ2fJ7R0B6ARsNB5xRfftH8XEHwg=;
	h=Subject:To:CC:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=qUhEwz6PYl/AxgirKzVFMKanADgW8PBVYRg9Xpunxk2+psOZs7Zsuu8U7TeQi9OAsSmkyDqdgdVg4692bcghZnjw98pRVabK1VN3NO/7QD8SvRowm2YBCVxFsD+7HBHMy2waWKoDdKGNKTkaEmFCDUXjL/I+m0ubdlHaq11wIK0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.105])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4WdSWp1W4dzpSt1;
	Tue,  6 Aug 2024 17:22:46 +0800 (CST)
Received: from kwepemm600007.china.huawei.com (unknown [7.193.23.208])
	by mail.maildlp.com (Postfix) with ESMTPS id AE7121400D8;
	Tue,  6 Aug 2024 17:23:54 +0800 (CST)
Received: from [10.174.178.219] (10.174.178.219) by
 kwepemm600007.china.huawei.com (7.193.23.208) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 6 Aug 2024 17:23:53 +0800
Subject: Re: [PATCH v3 05/19] KVM: arm64: vgic-debug: Use an xarray mark for
 debug iterator
To: Oliver Upton <oliver.upton@linux.dev>
CC: <kvmarm@lists.linux.dev>, Marc Zyngier <maz@kernel.org>, James Morse
	<james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, Eric Auger
	<eric.auger@redhat.com>, <kvm@vger.kernel.org>
References: <20240422200158.2606761-1-oliver.upton@linux.dev>
 <20240422200158.2606761-6-oliver.upton@linux.dev>
From: Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <d034a9b8-34ae-923e-8e68-09d2de3cf079@huawei.com>
Date: Tue, 6 Aug 2024 17:23:52 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20240422200158.2606761-6-oliver.upton@linux.dev>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 kwepemm600007.china.huawei.com (7.193.23.208)

Hi Oliver,

On 2024/4/23 4:01, Oliver Upton wrote:
> The vgic debug iterator is the final user of vgic_copy_lpi_list(), but
> is a bit more complicated to transition to something else. Use a mark
> in the LPI xarray to record the indices 'known' to the debug iterator.
> Protect against the LPIs from being freed by associating an additional
> reference with the xarray mark.
> 
> Rework iter_next() to let the xarray walk 'drive' the iteration after
> visiting all of the SGIs, PPIs, and SPIs.
> 
> Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
> ---
>  arch/arm64/kvm/vgic/vgic-debug.c | 82 +++++++++++++++++++++++---------
>  arch/arm64/kvm/vgic/vgic-its.c   |  4 +-
>  arch/arm64/kvm/vgic/vgic.h       |  1 +
>  include/kvm/arm_vgic.h           |  2 +
>  4 files changed, 64 insertions(+), 25 deletions(-)
> 
> diff --git a/arch/arm64/kvm/vgic/vgic-debug.c b/arch/arm64/kvm/vgic/vgic-debug.c
> index 389025ce7749..bcbc8c986b1d 100644
> --- a/arch/arm64/kvm/vgic/vgic-debug.c
> +++ b/arch/arm64/kvm/vgic/vgic-debug.c
> @@ -28,27 +28,65 @@ struct vgic_state_iter {
>  	int nr_lpis;
>  	int dist_id;
>  	int vcpu_id;
> -	int intid;
> +	unsigned long intid;
>  	int lpi_idx;
> -	u32 *lpi_array;
>  };
>  
> -static void iter_next(struct vgic_state_iter *iter)
> +static void iter_next(struct kvm *kvm, struct vgic_state_iter *iter)
>  {
> +	struct vgic_dist *dist = &kvm->arch.vgic;
> +
>  	if (iter->dist_id == 0) {
>  		iter->dist_id++;
>  		return;
>  	}
>  
> +	/*
> +	 * Let the xarray drive the iterator after the last SPI, as the iterator
> +	 * has exhausted the sequentially-allocated INTID space.
> +	 */
> +	if (iter->intid >= (iter->nr_spis + VGIC_NR_PRIVATE_IRQS - 1)) {
> +		if (iter->lpi_idx < iter->nr_lpis)
> +			xa_find_after(&dist->lpi_xa, &iter->intid,
> +				      VGIC_LPI_MAX_INTID,
> +				      LPI_XA_MARK_DEBUG_ITER);
> +		iter->lpi_idx++;
> +		return;
> +	}

What's the purpose of moving the LPI handling up here?

> +
>  	iter->intid++;
>  	if (iter->intid == VGIC_NR_PRIVATE_IRQS &&
>  	    ++iter->vcpu_id < iter->nr_cpus)
>  		iter->intid = 0;

In case the guest *doesn't* have any LPI, we previously relied on the
iterator setting

	'intid = nr_spis + VGIC_NR_PRIVATE_IRQS' && 'lpi_idx = 1'

to exit the iterator. But it was broken with this refactor -- the intid
remains at 'nr_spis + VGIC_NR_PRIVATE_IRQS - 1', and vgic_debug_show()
endlessly prints the last SPI's state.

The following diff seems work for me.

diff --git a/arch/arm64/kvm/vgic/vgic-debug.c 
b/arch/arm64/kvm/vgic/vgic-debug.c
index 6faa1d16c9ce..f56f74c8cf54 100644
--- a/arch/arm64/kvm/vgic/vgic-debug.c
+++ b/arch/arm64/kvm/vgic/vgic-debug.c
@@ -41,11 +41,16 @@ static void iter_next(struct kvm *kvm, struct 
vgic_state_iter *iter)
  		return;
  	}

+	iter->intid++;
+	if (iter->intid == VGIC_NR_PRIVATE_IRQS &&
+	    ++iter->vcpu_id < iter->nr_cpus)
+		iter->intid = 0;
+
  	/*
  	 * Let the xarray drive the iterator after the last SPI, as the iterator
  	 * has exhausted the sequentially-allocated INTID space.
  	 */
-	if (iter->intid >= (iter->nr_spis + VGIC_NR_PRIVATE_IRQS - 1)) {
+	if (iter->intid >= (iter->nr_spis + VGIC_NR_PRIVATE_IRQS)) {
  		if (iter->lpi_idx < iter->nr_lpis)
  			xa_find_after(&dist->lpi_xa, &iter->intid,
  				      VGIC_LPI_MAX_INTID,
@@ -53,11 +58,6 @@ static void iter_next(struct kvm *kvm, struct 
vgic_state_iter *iter)
  		iter->lpi_idx++;
  		return;
  	}
-
-	iter->intid++;
-	if (iter->intid == VGIC_NR_PRIVATE_IRQS &&
-	    ++iter->vcpu_id < iter->nr_cpus)
-		iter->intid = 0;
  }

  static int iter_mark_lpis(struct kvm *kvm)

