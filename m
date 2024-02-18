Return-Path: <kvm+bounces-8984-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 04A858595C3
	for <lists+kvm@lfdr.de>; Sun, 18 Feb 2024 09:47:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B523C28199E
	for <lists+kvm@lfdr.de>; Sun, 18 Feb 2024 08:47:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C77FF11196;
	Sun, 18 Feb 2024 08:47:10 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2F5A149E17;
	Sun, 18 Feb 2024 08:47:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.190
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708246030; cv=none; b=iWmfsuN8JvvJmX96GKYoxwjx4Y8r5f8Y6YMzoMDA2yBWR4FWqeLQIkcjYQc+CkJJqHVaixia8ZotEkribZWzGSOKYLpjLnISLjbq7U4sZLVCeKyyeG6LpLdrQMUxvtFOT3XSdr7A4UQ2DUfxtKLZk6OwMS+SvFrDGkLAeu3Y3Oc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708246030; c=relaxed/simple;
	bh=r57VIygo4McbMJy7ObYDVyZ9K85AZDXtGaqReM398zI=;
	h=Subject:To:CC:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=KNLmmNM+IVYL4We/SG9ry1fHNDdzbBAo1G/yHxbTdGU2FNDYc00yRCEc6bozH+5qYqAaqWUfEXqa1BlESzjXj3YC/9xiMlvhpLrJdrnYbW4hjV39It0A0vT5Z+uKlpzAYrwZBHAZw/94k1rqdNLuh+7ig4MCQ8MyEJcA+tFeU7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.190
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.17])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4TczlS4hMQz1xnjr;
	Sun, 18 Feb 2024 16:45:40 +0800 (CST)
Received: from kwepemm600007.china.huawei.com (unknown [7.193.23.208])
	by mail.maildlp.com (Postfix) with ESMTPS id E67E51A0172;
	Sun, 18 Feb 2024 16:46:59 +0800 (CST)
Received: from [10.174.185.179] (10.174.185.179) by
 kwepemm600007.china.huawei.com (7.193.23.208) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Sun, 18 Feb 2024 16:46:58 +0800
Subject: Re: [PATCH v3 04/10] KVM: arm64: vgic-its: Walk the LPI xarray in
 vgic_copy_lpi_list()
To: Oliver Upton <oliver.upton@linux.dev>
CC: <kvmarm@lists.linux.dev>, <kvm@vger.kernel.org>, Marc Zyngier
	<maz@kernel.org>, James Morse <james.morse@arm.com>, Suzuki K Poulose
	<suzuki.poulose@arm.com>, <linux-kernel@vger.kernel.org>
References: <20240216184153.2714504-1-oliver.upton@linux.dev>
 <20240216184153.2714504-5-oliver.upton@linux.dev>
From: Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <beca07ad-833e-ca68-2fe7-a30a2cb9faef@huawei.com>
Date: Sun, 18 Feb 2024 16:46:53 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20240216184153.2714504-5-oliver.upton@linux.dev>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 kwepemm600007.china.huawei.com (7.193.23.208)

On 2024/2/17 2:41, Oliver Upton wrote:
> Start iterating the LPI xarray in anticipation of removing the LPI
> linked-list.
> 
> Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
> ---
>  arch/arm64/kvm/vgic/vgic-its.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
> index fb2d3c356984..9ce2edfadd11 100644
> --- a/arch/arm64/kvm/vgic/vgic-its.c
> +++ b/arch/arm64/kvm/vgic/vgic-its.c
> @@ -335,6 +335,7 @@ static int update_lpi_config(struct kvm *kvm, struct vgic_irq *irq,
>  int vgic_copy_lpi_list(struct kvm *kvm, struct kvm_vcpu *vcpu, u32 **intid_ptr)
>  {
>  	struct vgic_dist *dist = &kvm->arch.vgic;
> +	XA_STATE(xas, &dist->lpi_xa, GIC_LPI_OFFSET);
>  	struct vgic_irq *irq;
>  	unsigned long flags;
>  	u32 *intids;
> @@ -353,7 +354,9 @@ int vgic_copy_lpi_list(struct kvm *kvm, struct kvm_vcpu *vcpu, u32 **intid_ptr)
>  		return -ENOMEM;
>  
>  	raw_spin_lock_irqsave(&dist->lpi_list_lock, flags);
> -	list_for_each_entry(irq, &dist->lpi_list_head, lpi_list) {
> +	rcu_read_lock();
> +
> +	xas_for_each(&xas, irq, INTERRUPT_ID_BITS_ITS) {

We should use '1 << INTERRUPT_ID_BITS_ITS - 1' to represent the maximum
LPI interrupt ID.

>  		if (i == irq_count)
>  			break;
>  		/* We don't need to "get" the IRQ, as we hold the list lock. */
> @@ -361,6 +364,8 @@ int vgic_copy_lpi_list(struct kvm *kvm, struct kvm_vcpu *vcpu, u32 **intid_ptr)
>  			continue;
>  		intids[i++] = irq->intid;
>  	}
> +
> +	rcu_read_unlock();
>  	raw_spin_unlock_irqrestore(&dist->lpi_list_lock, flags);
>  
>  	*intid_ptr = intids;

Thanks,
Zenghui

