Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4926E153837
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2020 19:34:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727192AbgBESez (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Feb 2020 13:34:55 -0500
Received: from foss.arm.com ([217.140.110.172]:50984 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726822AbgBESez (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Feb 2020 13:34:55 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 65A031FB;
        Wed,  5 Feb 2020 10:34:54 -0800 (PST)
Received: from donnerap.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5C6FA3F52E;
        Wed,  5 Feb 2020 10:34:53 -0800 (PST)
Date:   Wed, 5 Feb 2020 18:34:50 +0000
From:   Andre Przywara <andre.przywara@arm.com>
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     kvm@vger.kernel.org, will@kernel.org,
        julien.thierry.kdev@gmail.com, sami.mujawar@arm.com,
        lorenzo.pieralisi@arm.com, maz@kernel.org
Subject: Re: [PATCH v2 kvmtool 23/30] vfio: Reserve ioports when configuring
 the BAR
Message-ID: <20200205183450.70160ed2@donnerap.cambridge.arm.com>
In-Reply-To: <20200123134805.1993-24-alexandru.elisei@arm.com>
References: <20200123134805.1993-1-alexandru.elisei@arm.com>
        <20200123134805.1993-24-alexandru.elisei@arm.com>
Organization: ARM
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; aarch64-unknown-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 23 Jan 2020 13:47:58 +0000
Alexandru Elisei <alexandru.elisei@arm.com> wrote:

Hi,

> Let's be consistent and reserve ioports when we are configuring the BAR,
> not when we map it, just like we do with mmio regions.
> 
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>

Reviewed-by: Andre Przywara <andre.przywara@arm.com>

Thanks,
Andre

> ---
>  vfio/core.c | 9 +++------
>  vfio/pci.c  | 4 +++-
>  2 files changed, 6 insertions(+), 7 deletions(-)
> 
> diff --git a/vfio/core.c b/vfio/core.c
> index 73fdac8be675..6b9b58ea8d2f 100644
> --- a/vfio/core.c
> +++ b/vfio/core.c
> @@ -202,14 +202,11 @@ static int vfio_setup_trap_region(struct kvm *kvm, struct vfio_device *vdev,
>  				  struct vfio_region *region)
>  {
>  	if (region->is_ioport) {
> -		int port = pci_get_io_port_block(region->info.size);
> -
> -		port = ioport__register(kvm, port, &vfio_ioport_ops,
> -					region->info.size, region);
> +		int port = ioport__register(kvm, region->port_base,
> +					   &vfio_ioport_ops, region->info.size,
> +					   region);
>  		if (port < 0)
>  			return port;
> -
> -		region->port_base = port;
>  		return 0;
>  	}
>  
> diff --git a/vfio/pci.c b/vfio/pci.c
> index f86a7d9b7032..abde16dc8693 100644
> --- a/vfio/pci.c
> +++ b/vfio/pci.c
> @@ -885,7 +885,9 @@ static int vfio_pci_configure_bar(struct kvm *kvm, struct vfio_device *vdev,
>  		}
>  	}
>  
> -	if (!region->is_ioport) {
> +	if (region->is_ioport) {
> +		region->port_base = pci_get_io_port_block(region->info.size);
> +	} else {
>  		/* Grab some MMIO space in the guest */
>  		map_size = ALIGN(region->info.size, PAGE_SIZE);
>  		region->guest_phys_addr = pci_get_mmio_block(map_size);

