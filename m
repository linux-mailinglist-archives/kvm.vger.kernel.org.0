Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C969010E9F3
	for <lists+kvm@lfdr.de>; Mon,  2 Dec 2019 13:15:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727398AbfLBMPH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Dec 2019 07:15:07 -0500
Received: from foss.arm.com ([217.140.110.172]:53668 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727354AbfLBMPH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Dec 2019 07:15:07 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A1E0430E;
        Mon,  2 Dec 2019 04:15:06 -0800 (PST)
Received: from e121166-lin.cambridge.arm.com (e121166-lin.cambridge.arm.com [10.1.196.255])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B60953F68E;
        Mon,  2 Dec 2019 04:15:05 -0800 (PST)
Date:   Mon, 2 Dec 2019 12:15:00 +0000
From:   Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     kvm@vger.kernel.org, will@kernel.org,
        julien.thierry.kdev@gmail.com, andre.przywara@arm.com,
        sami.mujawar@arm.com
Subject: Re: [PATCH kvmtool 09/16] arm/pci: Do not use first PCI IO space
 bytes for devices
Message-ID: <20191202121500.GA4770@e121166-lin.cambridge.arm.com>
References: <20191125103033.22694-1-alexandru.elisei@arm.com>
 <20191125103033.22694-10-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191125103033.22694-10-alexandru.elisei@arm.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 25, 2019 at 10:30:26AM +0000, Alexandru Elisei wrote:
> From: Julien Thierry <julien.thierry@arm.com>
> 
> Linux has this convention that the lower 0x1000 bytes of the IO space
> should not be used. (cf PCIBIOS_MIN_IO).
> 
> Just allocate those bytes to prevent future allocation assigning it to
> devices.

I do not understand what this means; if the kernel reassigns IO BARs
within the IO window kvmtool provides (through DT host controller
bindings - ranges property) this patch should not be needed.

Furthermore I don't think there should be any dependency in kvmtool
to the Linux PCIBIOS_MIN_IO offset (which happens to be 0x1000 but
kvmtool must not rely on that).

To sum it up: kvmtool should assign sensible IO ports default values
to BARs (even though that's *not* mandatory) and let the OS reassign
values according to the IO port windows provided through DT bindings
(ie ranges property).

It is likely there is something I am missing in this patch logic,
apologies for asking but I don't think this patch should be required.

Thanks,
Lorenzo

> Cc: julien.thierry.kdev@gmail.com
> Signed-off-by: Julien Thierry <julien.thierry@arm.com>
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> ---
>  arm/pci.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/arm/pci.c b/arm/pci.c
> index 1c0949a22408..4e6467357ce8 100644
> --- a/arm/pci.c
> +++ b/arm/pci.c
> @@ -37,6 +37,9 @@ void pci__arm_init(struct kvm *kvm)
>  
>  	/* Make PCI port allocation start at a properly aligned address */
>  	pci_get_io_port_block(align_pad);
> +
> +	/* Convention, don't allocate first 0x1000 bytes of PCI IO */
> +	pci_get_io_port_block(0x1000);
>  }
>  
>  void pci__generate_fdt_nodes(void *fdt)
> -- 
> 2.20.1
> 
