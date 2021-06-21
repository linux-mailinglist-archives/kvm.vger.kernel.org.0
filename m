Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E5FC3AEAB2
	for <lists+kvm@lfdr.de>; Mon, 21 Jun 2021 16:03:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230137AbhFUOGB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Jun 2021 10:06:01 -0400
Received: from foss.arm.com ([217.140.110.172]:35134 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229790AbhFUOF7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Jun 2021 10:05:59 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7EFC7D6E;
        Mon, 21 Jun 2021 07:03:44 -0700 (PDT)
Received: from slackpad.fritz.box (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 40AC53F694;
        Mon, 21 Jun 2021 07:03:43 -0700 (PDT)
Date:   Mon, 21 Jun 2021 15:03:26 +0100
From:   Andre Przywara <andre.przywara@arm.com>
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     will@kernel.org, julien.thierry.kdev@gmail.com,
        kvm@vger.kernel.org, sami.mujawar@arm.com,
        lorenzo.pieralisi@arm.com, maz@kernel.org, pierre.gondois@arm.com
Subject: Re: [PATCH v2 kvmtool 2/4] arm/fdt.c: Don't generate the node if
 generator function is NULL
Message-ID: <20210621150326.5dc3d0a2@slackpad.fritz.box>
In-Reply-To: <20210621092128.11313-3-alexandru.elisei@arm.com>
References: <20210621092128.11313-1-alexandru.elisei@arm.com>
        <20210621092128.11313-3-alexandru.elisei@arm.com>
Organization: Arm Ltd.
X-Mailer: Claws Mail 3.17.1 (GTK+ 2.24.31; x86_64-slackware-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 21 Jun 2021 10:21:26 +0100
Alexandru Elisei <alexandru.elisei@arm.com> wrote:

> Print a more helpful debugging message when a MMIO device hasn't set a
> function to generate an FDT node instead of causing a segmentation fault by
> dereferencing a NULL pointer.
> 
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>

Thanks for the change.
One nit below, but anyway:

Reviewed-by: Andre Przywara <andre.przywara@arm.com>

> ---
>  arm/fdt.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/arm/fdt.c b/arm/fdt.c
> index 02091e9e0bee..7032985e99a3 100644
> --- a/arm/fdt.c
> +++ b/arm/fdt.c
> @@ -171,7 +171,12 @@ static int setup_fdt(struct kvm *kvm)
>  	dev_hdr = device__first_dev(DEVICE_BUS_MMIO);
>  	while (dev_hdr) {
>  		generate_mmio_fdt_nodes = dev_hdr->data;
> -		generate_mmio_fdt_nodes(fdt, dev_hdr, generate_irq_prop);
> +		if (generate_mmio_fdt_nodes) {
> +			generate_mmio_fdt_nodes(fdt, dev_hdr, generate_irq_prop);
> +		} else {
> +			pr_debug("Missing FDT node generator for MMIO device %d",
> +				 dev_hdr->dev_num);
> +		}

I think coding style says you don't need the brackets here.

Cheers,
Andre

>  		dev_hdr = device__next_dev(dev_hdr);
>  	}
>  

