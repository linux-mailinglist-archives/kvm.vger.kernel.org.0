Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 17D4410CE07
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2019 18:43:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726681AbfK1RnT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Nov 2019 12:43:19 -0500
Received: from foss.arm.com ([217.140.110.172]:39068 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726446AbfK1RnT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Nov 2019 12:43:19 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 008281FB;
        Thu, 28 Nov 2019 09:43:19 -0800 (PST)
Received: from donnerap.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1AAD83F6C4;
        Thu, 28 Nov 2019 09:43:18 -0800 (PST)
Date:   Thu, 28 Nov 2019 17:43:15 +0000
From:   Andre Przywara <andre.przywara@arm.com>
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     kvm@vger.kernel.org, will@kernel.org,
        julien.thierry.kdev@gmail.com, sami.mujawar@arm.com,
        lorenzo.pieralisi@arm.com
Subject: Re: [PATCH kvmtool 05/16] arm: pci.c: Advertise only PCI bus 0 in
 the DT
Message-ID: <20191128174315.26208e51@donnerap.cambridge.arm.com>
In-Reply-To: <20191125103033.22694-6-alexandru.elisei@arm.com>
References: <20191125103033.22694-1-alexandru.elisei@arm.com>
        <20191125103033.22694-6-alexandru.elisei@arm.com>
Organization: ARM
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; aarch64-unknown-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 25 Nov 2019 10:30:22 +0000
Alexandru Elisei <alexandru.elisei@arm.com> wrote:

> The "bus-range" property encodes the first and last bus number. kvmtool
> uses bus 0 for PCI and bus 1 for MMIO. 

Mmmh, but this DT setting is about (guest visible) PCI busses, not kvmtool busses, isn't it?
So for the PCI devices we *emulate* that's probably correct, since we don't have any PCI bridge functionality among them, but wouldn't forwarding a PCI device with a bridge require more than one bus? And the guest OS' enumeration code would try to create a new bus, but fails, because there is only one?

So I agree that the [0, 1] looks somewhat arbitrary, but shouldn't we set it to [0, 255] instead, to not limit things?
I think this setting should correspond to the PCIe config space size we provide, which should be: 4096 bytes * 8 fns * 32 devs * nr_busses (for PCIe).

At least that's my understanding of these things, please correct me if I am wrong.

Cheers,
Andre.

> Advertise only the PCI bus in
> the PCI DT node by setting "bus-range" to <0, 0>.
> 
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> ---
>  arm/pci.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arm/pci.c b/arm/pci.c
> index 557cfa98938d..ed325fa4a811 100644
> --- a/arm/pci.c
> +++ b/arm/pci.c
> @@ -30,7 +30,7 @@ void pci__generate_fdt_nodes(void *fdt)
>  	struct of_interrupt_map_entry irq_map[OF_PCI_IRQ_MAP_MAX];
>  	unsigned nentries = 0;
>  	/* Bus range */
> -	u32 bus_range[] = { cpu_to_fdt32(0), cpu_to_fdt32(1), };
> +	u32 bus_range[] = { cpu_to_fdt32(0), cpu_to_fdt32(0), };
>  	/* Configuration Space */
>  	u64 cfg_reg_prop[] = { cpu_to_fdt64(KVM_PCI_CFG_AREA),
>  			       cpu_to_fdt64(ARM_PCI_CFG_SIZE), };

