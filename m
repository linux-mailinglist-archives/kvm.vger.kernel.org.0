Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BC515B5A67
	for <lists+kvm@lfdr.de>; Mon, 12 Sep 2022 14:46:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229765AbiILMqw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Sep 2022 08:46:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229543AbiILMqv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Sep 2022 08:46:51 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7E3B813EAA
        for <kvm@vger.kernel.org>; Mon, 12 Sep 2022 05:46:49 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 61C78113E;
        Mon, 12 Sep 2022 05:46:55 -0700 (PDT)
Received: from [10.57.78.77] (unknown [10.57.78.77])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D50793F73B;
        Mon, 12 Sep 2022 05:46:47 -0700 (PDT)
Message-ID: <1aaf62b7-1429-6206-bfab-f4cea61ffffd@arm.com>
Date:   Mon, 12 Sep 2022 14:46:41 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH kvmtool] pci: Disable writes to Status register
Content-Language: en-US
To:     Jean-Philippe Brucker <jean-philippe@linaro.org>, will@kernel.org
Cc:     andre.przywara@arm.com, alexandru.elisei@arm.com,
        kvm@vger.kernel.org
References: <20220908144208.231272-1-jean-philippe@linaro.org>
From:   Pierre Gondois <pierre.gondois@arm.com>
In-Reply-To: <20220908144208.231272-1-jean-philippe@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-9.1 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Thanks for the fix Jean-Philippe:
Tested-by: Pierre Gondois <pierre.gondois@arm.com>

On 9/8/22 16:42, Jean-Philippe Brucker wrote:
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
>    are writable.
> 
> Also remove the old hack that filtered accesses. It was wrong and not
> properly explained in the git history, but whatever it was guarding
> against should be prevented by these new checks.
> 
> Reported-by: Pierre Gondois <pierre.gondois@arm.com>
> Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
> ---
> Note that the issue described here only shows up during ACPI boot for
> me, because edac_init() happens after PCI enumeration. With DT boot,
> edac_pci_clear_parity_errors() runs earlier and doesn't find any device.
> ---
>   pci.c | 41 ++++++++++++++++++++++++++++++++---------
>   1 file changed, 32 insertions(+), 9 deletions(-)
> 
> diff --git a/pci.c b/pci.c
> index a769ae27..84dc7d1d 100644
> --- a/pci.c
> +++ b/pci.c
> @@ -350,6 +350,24 @@ static void pci_config_bar_wr(struct kvm *kvm,
>   	pci_activate_bar_regions(kvm, old_addr, bar_size);
>   }
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
>   void pci__config_wr(struct kvm *kvm, union pci_config_address addr, void *data, int size)
>   {
>   	void *base;
> @@ -357,7 +375,7 @@ void pci__config_wr(struct kvm *kvm, union pci_config_address addr, void *data,
>   	u16 offset;
>   	struct pci_device_header *pci_hdr;
>   	u8 dev_num = addr.device_number;
> -	u32 value = 0;
> +	u32 value = 0, mask = 0;
>   
>   	if (!pci_device_exists(addr.bus_number, dev_num, 0))
>   		return;
> @@ -368,12 +386,12 @@ void pci__config_wr(struct kvm *kvm, union pci_config_address addr, void *data,
>   	if (pci_hdr->cfg_ops.write)
>   		pci_hdr->cfg_ops.write(kvm, pci_hdr, offset, data, size);
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
> +	}
>   
>   	if (offset == PCI_COMMAND) {
>   		memcpy(&value, data, size);
> @@ -419,8 +437,13 @@ static void pci_config_mmio_access(struct kvm_cpu *vcpu, u64 addr, u8 *data,
>   	cfg_addr.w		= (u32)addr;
>   	cfg_addr.enable_bit	= 1;
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
>   
>   	if (is_write)
>   		pci__config_wr(kvm, cfg_addr, data, len);
