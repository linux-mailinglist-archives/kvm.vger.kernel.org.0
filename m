Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F221A35E120
	for <lists+kvm@lfdr.de>; Tue, 13 Apr 2021 16:15:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346421AbhDMOM2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Apr 2021 10:12:28 -0400
Received: from foss.arm.com ([217.140.110.172]:43012 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346418AbhDMOM0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Apr 2021 10:12:26 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DD84E106F;
        Tue, 13 Apr 2021 07:12:06 -0700 (PDT)
Received: from C02W217MHV2R.local (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0B9893F694;
        Tue, 13 Apr 2021 07:12:05 -0700 (PDT)
Subject: Re: [PATCH kvm-unit-tests 3/8] pci-testdev: ioremap regions
To:     Andrew Jones <drjones@redhat.com>, kvm@vger.kernel.org
Cc:     alexandru.elisei@arm.com, andre.przywara@arm.com,
        eric.auger@redhat.com
References: <20210407185918.371983-1-drjones@redhat.com>
 <20210407185918.371983-4-drjones@redhat.com>
From:   Nikos Nikoleris <nikos.nikoleris@arm.com>
Message-ID: <a1ae2fc8-918e-d574-2b3b-ba8a7bfd9944@arm.com>
Date:   Tue, 13 Apr 2021 15:12:04 +0100
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <20210407185918.371983-4-drjones@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 07/04/2021 19:59, Andrew Jones wrote:
> Don't assume the physical addresses used with PCI have already been
> identity mapped.
> 
> Signed-off-by: Andrew Jones <drjones@redhat.com>

This makes more sense now that I had a look at the next patch (4/8).

Reviewed-by: Nikos Nikoleris <nikos.nikoleris@arm.com>

> ---
>   lib/pci-host-generic.c | 5 ++---
>   lib/pci-host-generic.h | 4 ++--
>   lib/pci-testdev.c      | 4 ++++
>   3 files changed, 8 insertions(+), 5 deletions(-)
> 
> diff --git a/lib/pci-host-generic.c b/lib/pci-host-generic.c
> index 818150dc0a66..de93b8feac39 100644
> --- a/lib/pci-host-generic.c
> +++ b/lib/pci-host-generic.c
> @@ -122,7 +122,7 @@ static struct pci_host_bridge *pci_dt_probe(void)
>   		      sizeof(host->addr_space[0]) * nr_addr_spaces);
>   	assert(host != NULL);
>   
> -	host->start		= base.addr;
> +	host->start		= ioremap(base.addr, base.size);
>   	host->size		= base.size;
>   	host->bus		= bus;
>   	host->bus_max		= bus_max;
> @@ -279,8 +279,7 @@ phys_addr_t pci_host_bridge_get_paddr(u64 pci_addr)
>   
>   static void __iomem *pci_get_dev_conf(struct pci_host_bridge *host, int devfn)
>   {
> -	return (void __iomem *)(unsigned long)
> -		host->start + (devfn << PCI_ECAM_DEVFN_SHIFT);
> +	return (void __iomem *)host->start + (devfn << PCI_ECAM_DEVFN_SHIFT);
>   }
>   
>   u8 pci_config_readb(pcidevaddr_t dev, u8 off)
> diff --git a/lib/pci-host-generic.h b/lib/pci-host-generic.h
> index fd30e7c74ed8..0ffe6380ec8f 100644
> --- a/lib/pci-host-generic.h
> +++ b/lib/pci-host-generic.h
> @@ -18,8 +18,8 @@ struct pci_addr_space {
>   };
>   
>   struct pci_host_bridge {
> -	phys_addr_t		start;
> -	phys_addr_t		size;
> +	void __iomem		*start;
> +	size_t			size;
>   	int			bus;
>   	int			bus_max;
>   	int			nr_addr_spaces;
> diff --git a/lib/pci-testdev.c b/lib/pci-testdev.c
> index 039bb44781c1..4f2e5663b2d6 100644
> --- a/lib/pci-testdev.c
> +++ b/lib/pci-testdev.c
> @@ -185,7 +185,11 @@ int pci_testdev(void)
>   	mem = ioremap(addr, PAGE_SIZE);
>   
>   	addr = pci_bar_get_addr(&pci_dev, 1);
> +#if defined(__i386__) || defined(__x86_64__)
>   	io = (void *)(unsigned long)addr;
> +#else
> +	io = ioremap(addr, PAGE_SIZE);
> +#endif
>   
>   	nr_tests += pci_testdev_all(mem, &pci_testdev_mem_ops);
>   	nr_tests += pci_testdev_all(io, &pci_testdev_io_ops);
> 
