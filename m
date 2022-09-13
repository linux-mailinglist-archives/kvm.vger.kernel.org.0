Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBD775B6E9D
	for <lists+kvm@lfdr.de>; Tue, 13 Sep 2022 15:51:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231672AbiIMNvy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Sep 2022 09:51:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231820AbiIMNvw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Sep 2022 09:51:52 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A62BE4F1BD
        for <kvm@vger.kernel.org>; Tue, 13 Sep 2022 06:51:51 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C23021063;
        Tue, 13 Sep 2022 06:51:57 -0700 (PDT)
Received: from monolith.localdoman (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 635DD3F73B;
        Tue, 13 Sep 2022 06:51:50 -0700 (PDT)
Date:   Tue, 13 Sep 2022 14:52:44 +0100
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     Jean-Philippe Brucker <jean-philippe@linaro.org>
Cc:     will@kernel.org, andre.przywara@arm.com, kvm@vger.kernel.org,
        Pierre Gondois <pierre.gondois@arm.com>
Subject: Re: [PATCH kvmtool] pci: Disable writes to Status register
Message-ID: <YyCLLLVi6AzAzW0p@monolith.localdoman>
References: <20220908144208.231272-1-jean-philippe@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220908144208.231272-1-jean-philippe@linaro.org>
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On Thu, Sep 08, 2022 at 03:42:09PM +0100, Jean-Philippe Brucker wrote:
> Although the PCI Status register only contains read-only and
> write-1-to-clear bits, we currently keep anything written there, which
> can confuse a guest.
> 
> The problem was highlighted by recent Linux commit 6cd514e58f12 ("PCI:
> Clear PCI_STATUS when setting up device"), which unconditionally writes
> 0xffff to the Status register in order to clear pending errors. Then the
> EDAC driver sees the parity status bits set and attempts to clear them
> by writing 0xc100, which in turn clears the Capabilities List bit.
> Later on, when the virtio-pci driver starts probing, it assumes due to
> missing capabilities that the device is using the legacy transport, and
> fails to setup the device because of mismatched protocol.
> 
> Filter writes to the config space, keeping only those to writable
> fields. Tighten the access size check while we're at it, to prevent
> overflow. This is only a small step in the right direction, not a
> foolproof solution, because a guest could still write both Command and
> Status registers using a single 32-bit write. More work is needed for:
> * Supporting arbitrary sized writes.
> * Sanitizing accesses to capabilities, which are device-specific.
> * Fine-grained filtering of the Command register, where only some bits
>   are writable.

I'm confused here. Why not do value &= mask to keep only those bits that
writable?

> 
> Also remove the old hack that filtered accesses. It was wrong and not
> properly explained in the git history, but whatever it was guarding
> against should be prevented by these new checks.

If I remember correctly, that was guarding against the guest kernel poking
the ROM base address register for drivers that assumed that the ROM was
always there, I vaguely remember that was the case with GPUs. Pairs with
the similar check in the vfio callback, vfio_pci_cfg_write().

> 
> Reported-by: Pierre Gondois <pierre.gondois@arm.com>
> Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
> ---
> Note that the issue described here only shows up during ACPI boot for
> me, because edac_init() happens after PCI enumeration. With DT boot,
> edac_pci_clear_parity_errors() runs earlier and doesn't find any device.
> ---
>  pci.c | 41 ++++++++++++++++++++++++++++++++---------
>  1 file changed, 32 insertions(+), 9 deletions(-)
> 
> diff --git a/pci.c b/pci.c
> index a769ae27..84dc7d1d 100644
> --- a/pci.c
> +++ b/pci.c
> @@ -350,6 +350,24 @@ static void pci_config_bar_wr(struct kvm *kvm,
>  	pci_activate_bar_regions(kvm, old_addr, bar_size);
>  }
>  
> +/*
> + * Bits that are writable in the config space header.
> + * Write-1-to-clear Status bits are missing since we never set them.
> + */
> +static const u8 pci_config_writable[PCI_STD_HEADER_SIZEOF] = {
> +	[PCI_COMMAND] =
> +		PCI_COMMAND_IO |
> +		PCI_COMMAND_MEMORY |
> +		PCI_COMMAND_MASTER |
> +		PCI_COMMAND_PARITY,
> +	[PCI_COMMAND + 1] =
> +		(PCI_COMMAND_SERR |
> +		 PCI_COMMAND_INTX_DISABLE) >> 8,
> +	[PCI_INTERRUPT_LINE] = 0xff,
> +	[PCI_BASE_ADDRESS_0 ... PCI_BASE_ADDRESS_5 + 3] = 0xff,
> +	[PCI_CACHE_LINE_SIZE] = 0xff,
> +};
> +
>  void pci__config_wr(struct kvm *kvm, union pci_config_address addr, void *data, int size)
>  {
>  	void *base;
> @@ -357,7 +375,7 @@ void pci__config_wr(struct kvm *kvm, union pci_config_address addr, void *data,
>  	u16 offset;
>  	struct pci_device_header *pci_hdr;
>  	u8 dev_num = addr.device_number;
> -	u32 value = 0;
> +	u32 value = 0, mask = 0;
>  
>  	if (!pci_device_exists(addr.bus_number, dev_num, 0))
>  		return;
> @@ -368,12 +386,12 @@ void pci__config_wr(struct kvm *kvm, union pci_config_address addr, void *data,
>  	if (pci_hdr->cfg_ops.write)
>  		pci_hdr->cfg_ops.write(kvm, pci_hdr, offset, data, size);
>  
> -	/*
> -	 * legacy hack: ignore writes to uninitialized regions (e.g. ROM BAR).
> -	 * Not very nice but has been working so far.
> -	 */
> -	if (*(u32 *)(base + offset) == 0)
> -		return;
> +	/* We don't sanity-check capabilities for the moment */
> +	if (offset < PCI_STD_HEADER_SIZEOF) {
> +		memcpy(&mask, pci_config_writable + offset, size);
> +		if (!mask)
> +			return;

Shouldn't this be performed before the VFIO callbacks?  Also, the vfio
callbacks still do the writes to the VFIO in-kernel PCI header, but now
kvmtool would skip those writes entirely. Shouldn't kvmtool's view of the
configuration space be identical to that of VFIO?

> +	}
>  
>  	if (offset == PCI_COMMAND) {
>  		memcpy(&value, data, size);
> @@ -419,8 +437,13 @@ static void pci_config_mmio_access(struct kvm_cpu *vcpu, u64 addr, u8 *data,
>  	cfg_addr.w		= (u32)addr;
>  	cfg_addr.enable_bit	= 1;
>  
> -	if (len > 4)
> -		len = 4;
> +	/*
> +	 * "Root Complex implementations are not required to support the
> +	 * generation of Configuration Requests from accesses that cross DW
> +	 * [4 bytes] boundaries."
> +	 */
> +	if ((addr & 3) + len > 4)
> +		return;

Isn't that a change in behaviour? How about:

    len = 4 - (addr & 3);

Which should conform to the spec, but still allow writes like before.

Thanks,
Alex

>  
>  	if (is_write)
>  		pci__config_wr(kvm, cfg_addr, data, len);
> -- 
> 2.37.3
> 
