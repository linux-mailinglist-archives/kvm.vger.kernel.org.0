Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 280134240E2
	for <lists+kvm@lfdr.de>; Wed,  6 Oct 2021 17:09:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238996AbhJFPLE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Oct 2021 11:11:04 -0400
Received: from foss.arm.com ([217.140.110.172]:35328 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238124AbhJFPLE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Oct 2021 11:11:04 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9BB3C6D;
        Wed,  6 Oct 2021 08:09:11 -0700 (PDT)
Received: from donnerap.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id CF0363F66F;
        Wed,  6 Oct 2021 08:09:10 -0700 (PDT)
Date:   Wed, 6 Oct 2021 16:08:59 +0100
From:   Andre Przywara <andre.przywara@foss.arm.com>
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     will@kernel.org, julien.thierry.kdev@gmail.com,
        kvm@vger.kernel.org, jean-philippe@linaro.org
Subject: Re: [PATCH v1 kvmtool 1/7] arm/gicv2m: Set errno when
 gicv2_update_routing() fails
Message-ID: <20211006160859.03390d9d@donnerap.cambridge.arm.com>
In-Reply-To: <20210913154413.14322-2-alexandru.elisei@arm.com>
References: <20210913154413.14322-1-alexandru.elisei@arm.com>
        <20210913154413.14322-2-alexandru.elisei@arm.com>
Organization: ARM
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; aarch64-unknown-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 13 Sep 2021 16:44:07 +0100
Alexandru Elisei <alexandru.elisei@arm.com> wrote:

> In case of an error when updating the routing table entries,
> irq__update_msix_route() uses perror to print an error message.
> gicv2m_update_routing() doesn't set errno, and instead returns the value
> that errno should have had, which can lead to failure messages like this:
> 
> KVM_SET_GSI_ROUTING: Success
> 
> Set errno in gicv2m_update_routing() to avoid such messages in the future.

Fair enough, the usage of errno in the error reporting path is not really
consistent in kvmtool, but as we also keep the return value, that's
alright:

> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>

Reviewed-by: Andre Przywara <andre.przywara@arm.com>

Cheers,
Andre

> ---
>  arm/gicv2m.c | 10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/arm/gicv2m.c b/arm/gicv2m.c
> index d7e6398..b47ada8 100644
> --- a/arm/gicv2m.c
> +++ b/arm/gicv2m.c
> @@ -42,16 +42,18 @@ static int gicv2m_update_routing(struct kvm *kvm,
>  {
>  	int spi;
>  
> -	if (entry->type != KVM_IRQ_ROUTING_MSI)
> -		return -EINVAL;
> +	if (entry->type != KVM_IRQ_ROUTING_MSI) {
> +		errno = EINVAL;
> +		return -errno;
> +	}
>  
>  	if (!entry->u.msi.address_hi && !entry->u.msi.address_lo)
>  		return 0;
>  
>  	spi = entry->u.msi.data & GICV2M_SPI_MASK;
>  	if (spi < v2m.first_spi || spi >= v2m.first_spi + v2m.num_spis) {
> -		pr_err("invalid SPI number %d", spi);
> -		return -EINVAL;
> +		errno = EINVAL;
> +		return -errno;
>  	}
>  
>  	v2m.spis[spi - v2m.first_spi] = entry->gsi;

