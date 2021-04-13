Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6BCC35D7B7
	for <lists+kvm@lfdr.de>; Tue, 13 Apr 2021 08:06:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344339AbhDMGG2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Apr 2021 02:06:28 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:15671 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343930AbhDMGGZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Apr 2021 02:06:25 -0400
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4FKFQP1sdyznWcp;
        Tue, 13 Apr 2021 14:03:09 +0800 (CST)
Received: from [10.174.187.224] (10.174.187.224) by
 DGGEMS410-HUB.china.huawei.com (10.3.19.210) with Microsoft SMTP Server id
 14.3.498.0; Tue, 13 Apr 2021 14:05:58 +0800
Subject: Re: [PATCH] KVM: arm/arm64: Fix KVM_VGIC_V3_ADDR_TYPE_REDIST read
To:     Eric Auger <eric.auger@redhat.com>, <eric.auger.pro@gmail.com>,
        <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
        <kvmarm@lists.cs.columbia.edu>, <maz@kernel.org>,
        <alexandru.elisei@arm.com>, <suzuki.poulose@arm.com>,
        <james.morse@arm.com>
References: <20210412150034.29185-1-eric.auger@redhat.com>
CC:     <drjones@redhat.com>, <gshan@redhat.com>
From:   Keqian Zhu <zhukeqian1@huawei.com>
Message-ID: <d458c821-75a3-a22a-67b0-19b6201cd6ca@huawei.com>
Date:   Tue, 13 Apr 2021 14:05:47 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <20210412150034.29185-1-eric.auger@redhat.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.187.224]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 2021/4/12 23:00, Eric Auger wrote:
> When reading the base address of the a REDIST region
> through KVM_VGIC_V3_ADDR_TYPE_REDIST we expect the
> redistributor region list to be populated with a single
> element.
> 
> However list_first_entry() expects the list to be non empty.
Indeed, list_first_entry() always return a non-null ptr. If the list
is empty, it will mistake the list head as the first element.

> Instead we should use list_first_entry_or_null which effectively
> returns NULL if the list is empty.
> 
> Fixes: dbd9733ab674 ("KVM: arm/arm64: Replace the single rdist region by a list")
> Cc: <Stable@vger.kernel.org> # v4.18+
> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> Reported-by: Gavin Shan <gshan@redhat.com>
> ---
>  arch/arm64/kvm/vgic/vgic-kvm-device.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/kvm/vgic/vgic-kvm-device.c b/arch/arm64/kvm/vgic/vgic-kvm-device.c
> index 44419679f91a..5eaede3e3b5a 100644
> --- a/arch/arm64/kvm/vgic/vgic-kvm-device.c
> +++ b/arch/arm64/kvm/vgic/vgic-kvm-device.c
> @@ -87,8 +87,8 @@ int kvm_vgic_addr(struct kvm *kvm, unsigned long type, u64 *addr, bool write)
>  			r = vgic_v3_set_redist_base(kvm, 0, *addr, 0);
>  			goto out;
>  		}
> -		rdreg = list_first_entry(&vgic->rd_regions,
> -					 struct vgic_redist_region, list);
> +		rdreg = list_first_entry_or_null(&vgic->rd_regions,
> +						 struct vgic_redist_region, list);
>  		if (!rdreg)
>  			addr_ptr = &undef_value;
>  		else
> 
