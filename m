Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66A922EC13E
	for <lists+kvm@lfdr.de>; Wed,  6 Jan 2021 17:34:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727436AbhAFQdK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Jan 2021 11:33:10 -0500
Received: from foss.arm.com ([217.140.110.172]:43832 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727406AbhAFQdK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Jan 2021 11:33:10 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 66309106F;
        Wed,  6 Jan 2021 08:32:24 -0800 (PST)
Received: from [192.168.0.110] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E07033F719;
        Wed,  6 Jan 2021 08:32:22 -0800 (PST)
Subject: Re: [PATCH 1/9] KVM: arm64: vgic-v3: Fix some error codes when
 setting RDIST base
To:     Eric Auger <eric.auger@redhat.com>, eric.auger.pro@gmail.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, maz@kernel.org, drjones@redhat.com
Cc:     james.morse@arm.com, julien.thierry.kdev@gmail.com,
        suzuki.poulose@arm.com, shuah@kernel.org, pbonzini@redhat.com
References: <20201212185010.26579-1-eric.auger@redhat.com>
 <20201212185010.26579-2-eric.auger@redhat.com>
From:   Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <fa73780d-b72b-6810-460e-5ed1057df093@arm.com>
Date:   Wed, 6 Jan 2021 16:32:23 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20201212185010.26579-2-eric.auger@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Eric,

On 12/12/20 6:50 PM, Eric Auger wrote:
> KVM_DEV_ARM_VGIC_GRP_ADDR group doc says we should return
> -EEXIST in case the base address of the redist is already set.
> We currently return -EINVAL.
>
> However we need to return -EINVAL in case a legacy REDIST address
> is attempted to be set while REDIST_REGIONS were set. This case
> is discriminated by looking at the count field.
>
> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> ---
>  arch/arm64/kvm/vgic/vgic-mmio-v3.c | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
>
> diff --git a/arch/arm64/kvm/vgic/vgic-mmio-v3.c b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
> index 15a6c98ee92f..8e8a862def76 100644
> --- a/arch/arm64/kvm/vgic/vgic-mmio-v3.c
> +++ b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
> @@ -792,8 +792,13 @@ static int vgic_v3_insert_redist_region(struct kvm *kvm, uint32_t index,
>  	int ret;
>  
>  	/* single rdist region already set ?*/
> -	if (!count && !list_empty(rd_regions))
> -		return -EINVAL;
> +	if (!count && !list_empty(rd_regions)) {
> +		rdreg = list_last_entry(rd_regions,
> +				       struct vgic_redist_region, list);
> +		if (rdreg->count)
> +			return -EINVAL; /* Mixing REDIST and REDIST_REGION API */
> +		return -EEXIST;
> +	}

A few instructions below:

    if (list_empty(rd_regions)) {
        [..]
    } else {
        rdreg = list_last_entry(rd_regions,
                    struct vgic_redist_region, list);
        [..]

        /* Cannot add an explicitly sized regions after legacy region */
        if (!rdreg->count)
            return -EINVAL;
    }

Isn't this testing for the same thing, but using the opposite condition? Or am I
misunderstanding the code (quite likely)?

Looks to me like KVM_DEV_ARM_VGIC_GRP_ADDR(KVM_VGIC_V3_ADDR_TYPE_REDIST{,_REGION})
used to return -EEXIST (from vgic_check_ioaddr()) before commit ccc27bf5be7b7
("KVM: arm/arm64: Helper to register a new redistributor region") which added the
vgic_v3_insert_redist_region() function, so bringing back the -EEXIST return code
looks the right thing to me.

Thanks,
Alex
>  
>  	/* cross the end of memory ? */
>  	if (base + size < base)
