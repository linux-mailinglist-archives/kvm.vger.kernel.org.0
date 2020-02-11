Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE77D158BD7
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2020 10:26:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727761AbgBKJ0Y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Feb 2020 04:26:24 -0500
Received: from foss.arm.com ([217.140.110.172]:43206 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727121AbgBKJ0Y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Feb 2020 04:26:24 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9686A31B;
        Tue, 11 Feb 2020 01:26:23 -0800 (PST)
Received: from [10.1.196.63] (e123195-lin.cambridge.arm.com [10.1.196.63])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id DA8EC3F68E;
        Tue, 11 Feb 2020 01:26:22 -0800 (PST)
Subject: Re: [kvm-unit-tests PATCH 2/3] arm64: timer: Use the proper RDist
 register name in GICv3
To:     Zenghui Yu <yuzenghui@huawei.com>, drjones@redhat.com,
        kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc:     wanghaibin.wang@huawei.com
References: <20200211083901.1478-1-yuzenghui@huawei.com>
 <20200211083901.1478-3-yuzenghui@huawei.com>
From:   Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <50dcce90-b2b6-e375-b8af-9c1c53d43a4a@arm.com>
Date:   Tue, 11 Feb 2020 09:26:16 +0000
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20200211083901.1478-3-yuzenghui@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On 2/11/20 8:39 AM, Zenghui Yu wrote:
> We're actually going to read GICR_ISACTIVER0 and GICR_ISPENDR0 (in
> SGI_base frame of the redistribitor) to get the active/pending state
> of the timer interrupt.  Fix this typo.
>
> And since they have the same value, there's no functional change.
>
> Signed-off-by: Zenghui Yu <yuzenghui@huawei.com>
> ---
>  arm/timer.c          | 4 ++--
>  lib/arm/asm/gic-v3.h | 4 ++++
>  2 files changed, 6 insertions(+), 2 deletions(-)
>
> diff --git a/arm/timer.c b/arm/timer.c
> index 94543f2..10a88f3 100644
> --- a/arm/timer.c
> +++ b/arm/timer.c
> @@ -351,8 +351,8 @@ static void test_init(void)
>  		gic_icenabler = gicv2_dist_base() + GICD_ICENABLER;
>  		break;
>  	case 3:
> -		gic_isactiver = gicv3_sgi_base() + GICD_ISACTIVER;
> -		gic_ispendr = gicv3_sgi_base() + GICD_ISPENDR;
> +		gic_isactiver = gicv3_sgi_base() + GICR_ISACTIVER0;
> +		gic_ispendr = gicv3_sgi_base() + GICR_ISPENDR0;
>  		gic_isenabler = gicv3_sgi_base() + GICR_ISENABLER0;
>  		gic_icenabler = gicv3_sgi_base() + GICR_ICENABLER0;
>  		break;
> diff --git a/lib/arm/asm/gic-v3.h b/lib/arm/asm/gic-v3.h
> index 0dc838b..e2736a1 100644
> --- a/lib/arm/asm/gic-v3.h
> +++ b/lib/arm/asm/gic-v3.h
> @@ -32,6 +32,10 @@
>  #define GICR_IGROUPR0			GICD_IGROUPR
>  #define GICR_ISENABLER0			GICD_ISENABLER
>  #define GICR_ICENABLER0			GICD_ICENABLER
> +#define GICR_ISPENDR0			GICD_ISPENDR
> +#define GICR_ICPENDR0			GICD_ICPENDR
> +#define GICR_ISACTIVER0			GICD_ISACTIVER
> +#define GICR_ICACTIVER0			GICD_ICACTIVER
>  #define GICR_IPRIORITYR0		GICD_IPRIORITYR
>  
>  #define ICC_SGI1R_AFFINITY_1_SHIFT	16

Looks like an improvement to me:

Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>

