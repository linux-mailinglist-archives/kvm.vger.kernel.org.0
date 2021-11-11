Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C366144D83B
	for <lists+kvm@lfdr.de>; Thu, 11 Nov 2021 15:27:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233454AbhKKOa0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Nov 2021 09:30:26 -0500
Received: from foss.arm.com ([217.140.110.172]:40982 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232823AbhKKOaZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Nov 2021 09:30:25 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 70B74ED1;
        Thu, 11 Nov 2021 06:27:36 -0800 (PST)
Received: from monolith.localdoman (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 7DF2D3F70D;
        Thu, 11 Nov 2021 06:27:34 -0800 (PST)
Date:   Thu, 11 Nov 2021 14:29:23 +0000
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     Sathyam Panda <panda.sathyam9@gmail.com>
Cc:     will@kernel.org, julien.thierry.kdev@gmail.com,
        kvm@vger.kernel.org, andre.przywara@arm.com,
        jean-philippe@linaro.org, vivek.gautam@arm.com,
        sathyam.panda@arm.com
Subject: Re: [PATCH kvmtool RESENT] arm/pci: update interrupt-map only for
 legacy interrupts
Message-ID: <YY0ow3d6iaUsgU7t@monolith.localdoman>
References: <20211111120231.5468-1-sathyam.panda@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211111120231.5468-1-sathyam.panda@arm.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Sathyam,

On Thu, Nov 11, 2021 at 12:02:31PM +0000, Sathyam Panda wrote:
> The interrupt pin cell in "interrupt-map" property
> is defined only for legacy interrupts with a valid
> range in [1-4] corrspoding to INTA#..INTD#. And the
> PCI endpoint devices that support advance interrupt
> mechanism like MSI or MSI-X should not have an entry
> with value 0 in "interrupt-map". This patch takes
> care of this problem by avoiding redundant entries.
> 
> Signed-off-by: Sathyam Panda <sathyam.panda@arm.com>
> Reviewed-by: Vivek Kumar Gautam <vivek.gautam@arm.com>
> ---
>  arm/pci.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/arm/pci.c b/arm/pci.c
> index 2251f62..e44e453 100644
> --- a/arm/pci.c
> +++ b/arm/pci.c
> @@ -80,6 +80,16 @@ void pci__generate_fdt_nodes(void *fdt)
>  		u8 irq = pci_hdr->irq_line;
>  		u32 irq_flags = pci_hdr->irq_type;
>  
> +		/*
> +		 * Avoid adding entries in "interrupt-map" for devices that
> +		 * will be using advance interrupt mechanisms like MSI or
> +		 * MSI-X instead of legacy interrupt pins INTA#..INTD#
> +		 */
> +		if (pin == 0) {
> +			dev_hdr = device__next_dev(dev_hdr);
> +			continue;
> +		}

I found this in "Open Firmware Recommended Practive: Interrupt Mapping" [1]
(referenced by Documentation/devicetree/bindings/pci/pci.txt in the Linux source
tree), in the PCI bus examples section (page 8):

"The PCI binding defines an "interrupts" property to consist of one cell, which
encodes wheth- er the PCI device’s interrupt is connected to the PCI connector’s
INTA#...INTD# pins, with values 1...4, respectively (assuming that the device is
on a plug-in PCI card)".

The patch makes sense to me, if the interrupt pin is not present a the device,
don't describe it in the DTB:

Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>

[1] https://www.devicetree.org/open-firmware/practice/imap/imap0_9d.pdf

Thanks,
Alex

> +
>  		*entry = (struct of_interrupt_map_entry) {
>  			.pci_irq_mask = {
>  				.pci_addr = {
> -- 
> 2.25.1
> 
