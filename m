Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A4A91BF6CB
	for <lists+kvm@lfdr.de>; Thu, 30 Apr 2020 13:25:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726844AbgD3LZI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Apr 2020 07:25:08 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:3784 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726413AbgD3LZH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Apr 2020 07:25:07 -0400
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id B6CDFD5C09F13723E425;
        Thu, 30 Apr 2020 19:25:03 +0800 (CST)
Received: from [127.0.0.1] (10.173.222.27) by DGGEMS404-HUB.china.huawei.com
 (10.3.19.204) with Microsoft SMTP Server id 14.3.487.0; Thu, 30 Apr 2020
 19:24:55 +0800
Subject: Re: [PATCH] KVM: arm64: vgic-v4: Initialize GICv4.1 even in the
 absence of a virtual ITS
To:     Marc Zyngier <maz@kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <kvm@vger.kernel.org>,
        <kvmarm@lists.cs.columbia.edu>
CC:     James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Eric Auger <eric.auger@redhat.com>
References: <20200425094426.162962-1-maz@kernel.org>
From:   Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <5b23b938-f71f-5523-6d7e-027bcca98dd4@huawei.com>
Date:   Thu, 30 Apr 2020 19:24:53 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <20200425094426.162962-1-maz@kernel.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.173.222.27]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On 2020/4/25 17:44, Marc Zyngier wrote:
> KVM now expects to be able to use HW-accelerated delivery of vSGIs
> as soon as the guest has enabled thm. Unfortunately, we only
them
> initialize the GICv4 context if we have a virtual ITS exposed to
> the guest.
> 
> Fix it by always initializing the GICv4.1 context if it is
> available on the host.
> 
> Fixes: 2291ff2f2a56 ("KVM: arm64: GICv4.1: Plumb SGI implementation selection in the distributor")
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>   virt/kvm/arm/vgic/vgic-init.c    | 9 ++++++++-
>   virt/kvm/arm/vgic/vgic-mmio-v3.c | 3 ++-
>   2 files changed, 10 insertions(+), 2 deletions(-)
> 
> diff --git a/virt/kvm/arm/vgic/vgic-init.c b/virt/kvm/arm/vgic/vgic-init.c
> index a963b9d766b73..8e6f350c3bcd1 100644
> --- a/virt/kvm/arm/vgic/vgic-init.c
> +++ b/virt/kvm/arm/vgic/vgic-init.c
> @@ -294,8 +294,15 @@ int vgic_init(struct kvm *kvm)
>   		}
>   	}
>   
> -	if (vgic_has_its(kvm)) {
> +	if (vgic_has_its(kvm))
>   		vgic_lpi_translation_cache_init(kvm);
> +
> +	/*
> +	 * If we have GICv4.1 enabled, unconditionnaly request enable the
> +	 * v4 support so that we get HW-accelerated vSGIs. Otherwise, only
> +	 * enable it if we present a virtual ITS to the guest.
> +	 */
> +	if (vgic_supports_direct_msis(kvm)) {
>   		ret = vgic_v4_init(kvm);
>   		if (ret)
>   			goto out;
> diff --git a/virt/kvm/arm/vgic/vgic-mmio-v3.c b/virt/kvm/arm/vgic/vgic-mmio-v3.c
> index e72dcc4542475..26b11dcd45524 100644
> --- a/virt/kvm/arm/vgic/vgic-mmio-v3.c
> +++ b/virt/kvm/arm/vgic/vgic-mmio-v3.c
> @@ -50,7 +50,8 @@ bool vgic_has_its(struct kvm *kvm)
>   
>   bool vgic_supports_direct_msis(struct kvm *kvm)
>   {
> -	return kvm_vgic_global_state.has_gicv4 && vgic_has_its(kvm);
> +	return (kvm_vgic_global_state.has_gicv4_1 ||
> +		(kvm_vgic_global_state.has_gicv4 && vgic_has_its(kvm)));
>   }

Not related to this patch, but I think that the function name can be
improved a bit after this change. It now indicates whether the vGIC
supports direct MSIs injection *or* direct SGIs injection, not just
MSIs. And if vgic_has_its() is false, we don't even support MSIs.

The fix itself looks correct to me,

Reviewed-by: Zenghui Yu <yuzenghui@huawei.com>


Thanks.

