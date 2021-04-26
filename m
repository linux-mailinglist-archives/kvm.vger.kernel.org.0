Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19DE636B561
	for <lists+kvm@lfdr.de>; Mon, 26 Apr 2021 17:04:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233919AbhDZPEo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Apr 2021 11:04:44 -0400
Received: from foss.arm.com ([217.140.110.172]:35472 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233752AbhDZPEi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Apr 2021 11:04:38 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3CD8A1FB;
        Mon, 26 Apr 2021 08:03:57 -0700 (PDT)
Received: from slackpad.fritz.box (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 760543F73B;
        Mon, 26 Apr 2021 08:03:56 -0700 (PDT)
Date:   Mon, 26 Apr 2021 16:03:26 +0100
From:   Andre Przywara <andre.przywara@arm.com>
To:     Andrew Jones <drjones@redhat.com>
Cc:     kvm@vger.kernel.org, alexandru.elisei@arm.com,
        nikos.nikoleris@arm.com, eric.auger@redhat.com
Subject: Re: [PATCH kvm-unit-tests v2 3/8] pci-testdev: ioremap regions
Message-ID: <20210426160326.65daca85@slackpad.fritz.box>
In-Reply-To: <20210420190002.383444-4-drjones@redhat.com>
References: <20210420190002.383444-1-drjones@redhat.com>
        <20210420190002.383444-4-drjones@redhat.com>
Organization: Arm Ltd.
X-Mailer: Claws Mail 3.17.1 (GTK+ 2.24.31; x86_64-slackware-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 20 Apr 2021 20:59:57 +0200
Andrew Jones <drjones@redhat.com> wrote:

Hi,

> Don't assume the physical addresses used with PCI have already been
> identity mapped.
> 
> Reviewed-by: Nikos Nikoleris <nikos.nikoleris@arm.com>
> Signed-off-by: Andrew Jones <drjones@redhat.com>
> ---
>  lib/pci-host-generic.c | 5 ++---
>  lib/pci-host-generic.h | 4 ++--
>  lib/pci-testdev.c      | 4 ++++
>  3 files changed, 8 insertions(+), 5 deletions(-)
> 
> diff --git a/lib/pci-host-generic.c b/lib/pci-host-generic.c
> index 818150dc0a66..de93b8feac39 100644
> --- a/lib/pci-host-generic.c
> +++ b/lib/pci-host-generic.c
> @@ -122,7 +122,7 @@ static struct pci_host_bridge *pci_dt_probe(void)
>  		      sizeof(host->addr_space[0]) * nr_addr_spaces);
>  	assert(host != NULL);
>  
> -	host->start		= base.addr;
> +	host->start		= ioremap(base.addr, base.size);
>  	host->size		= base.size;
>  	host->bus		= bus;
>  	host->bus_max		= bus_max;
> @@ -279,8 +279,7 @@ phys_addr_t pci_host_bridge_get_paddr(u64 pci_addr)
>  
>  static void __iomem *pci_get_dev_conf(struct pci_host_bridge *host, int devfn)
>  {
> -	return (void __iomem *)(unsigned long)
> -		host->start + (devfn << PCI_ECAM_DEVFN_SHIFT);
> +	return (void __iomem *)host->start + (devfn << PCI_ECAM_DEVFN_SHIFT);

But host->start's type is now exactly "void __iomem *", so why the cast?
And are we OK with doing pointer arithmetic on a void pointer?

>  }
>  
>  u8 pci_config_readb(pcidevaddr_t dev, u8 off)
> diff --git a/lib/pci-host-generic.h b/lib/pci-host-generic.h
> index fd30e7c74ed8..0ffe6380ec8f 100644
> --- a/lib/pci-host-generic.h
> +++ b/lib/pci-host-generic.h
> @@ -18,8 +18,8 @@ struct pci_addr_space {
>  };
>  
>  struct pci_host_bridge {
> -	phys_addr_t		start;
> -	phys_addr_t		size;
> +	void __iomem		*start;
> +	size_t			size;
>  	int			bus;
>  	int			bus_max;
>  	int			nr_addr_spaces;
> diff --git a/lib/pci-testdev.c b/lib/pci-testdev.c
> index 039bb44781c1..4f2e5663b2d6 100644
> --- a/lib/pci-testdev.c
> +++ b/lib/pci-testdev.c
> @@ -185,7 +185,11 @@ int pci_testdev(void)
>  	mem = ioremap(addr, PAGE_SIZE);
>  
>  	addr = pci_bar_get_addr(&pci_dev, 1);
> +#if defined(__i386__) || defined(__x86_64__)
>  	io = (void *)(unsigned long)addr;
> +#else
> +	io = ioremap(addr, PAGE_SIZE);
> +#endif

I am bit puzzled: For anything but x86 ioremap() is implemented like the
first statement, so why do we differentiate here? Shouldn't either one
of the statements be fine, for all architectures?

Cheers,
Andre

>  
>  	nr_tests += pci_testdev_all(mem, &pci_testdev_mem_ops);
>  	nr_tests += pci_testdev_all(io, &pci_testdev_io_ops);

