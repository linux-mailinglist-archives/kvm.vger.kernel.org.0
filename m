Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 652AE154AF7
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2020 19:21:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727815AbgBFSVo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Feb 2020 13:21:44 -0500
Received: from foss.arm.com ([217.140.110.172]:33216 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727788AbgBFSVo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Feb 2020 13:21:44 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E2ECB1FB;
        Thu,  6 Feb 2020 10:21:43 -0800 (PST)
Received: from donnerap.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D8F853F68E;
        Thu,  6 Feb 2020 10:21:42 -0800 (PST)
Date:   Thu, 6 Feb 2020 18:21:37 +0000
From:   Andre Przywara <andre.przywara@arm.com>
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     kvm@vger.kernel.org, will@kernel.org,
        julien.thierry.kdev@gmail.com, sami.mujawar@arm.com,
        lorenzo.pieralisi@arm.com, maz@kernel.org
Subject: Re: [PATCH v2 kvmtool 26/30] pci: Toggle BAR I/O and memory space
 emulation
Message-ID: <20200206182137.48894a54@donnerap.cambridge.arm.com>
In-Reply-To: <20200123134805.1993-27-alexandru.elisei@arm.com>
References: <20200123134805.1993-1-alexandru.elisei@arm.com>
        <20200123134805.1993-27-alexandru.elisei@arm.com>
Organization: ARM
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; aarch64-unknown-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 23 Jan 2020 13:48:01 +0000
Alexandru Elisei <alexandru.elisei@arm.com> wrote:

Hi,

> During configuration of the BAR addresses, a Linux guest disables and
> enables access to I/O and memory space. When access is disabled, we don't
> stop emulating the memory regions described by the BARs. Now that we have
> callbacks for activating and deactivating emulation for a BAR region,
> let's use that to stop emulation when access is disabled, and
> re-activate it when access is re-enabled.
> 
> The vesa emulation hasn't been designed with toggling on and off in
> mind, so refuse writes to the PCI command register that disable memory
> or IO access.
> 
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> ---
>  hw/vesa.c | 16 ++++++++++++++++
>  pci.c     | 42 ++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 58 insertions(+)
> 
> diff --git a/hw/vesa.c b/hw/vesa.c
> index 74ebebbefa6b..3044a86078fb 100644
> --- a/hw/vesa.c
> +++ b/hw/vesa.c
> @@ -81,6 +81,18 @@ static int vesa__bar_deactivate(struct kvm *kvm,
>  	return -EINVAL;
>  }
>  
> +static void vesa__pci_cfg_write(struct kvm *kvm, struct pci_device_header *pci_hdr,
> +				u8 offset, void *data, int sz)
> +{
> +	u32 value;

I guess the same comment as on the other patch applies: using u64 looks safer to me. Also you should clear it, to avoid nasty surprises in case of a short write (1 or 2 bytes only).

The rest looks alright.

Cheers,
Andre

> +
> +	if (offset == PCI_COMMAND) {
> +		memcpy(&value, data, sz);
> +		value |= (PCI_COMMAND_IO | PCI_COMMAND_MEMORY);
> +		memcpy(data, &value, sz);
> +	}
> +}
> +
>  struct framebuffer *vesa__init(struct kvm *kvm)
>  {
>  	struct vesa_dev *vdev;
> @@ -114,6 +126,10 @@ struct framebuffer *vesa__init(struct kvm *kvm)
>  		.bar_size[1]		= VESA_MEM_SIZE,
>  	};
>  
> +	vdev->pci_hdr.cfg_ops = (struct pci_config_operations) {
> +		.write	= vesa__pci_cfg_write,
> +	};
> +
>  	vdev->fb = (struct framebuffer) {
>  		.width			= VESA_WIDTH,
>  		.height			= VESA_HEIGHT,
> diff --git a/pci.c b/pci.c
> index 5412f2defa2e..98331a1fc205 100644
> --- a/pci.c
> +++ b/pci.c
> @@ -157,6 +157,42 @@ static struct ioport_operations pci_config_data_ops = {
>  	.io_out	= pci_config_data_out,
>  };
>  
> +static void pci_config_command_wr(struct kvm *kvm,
> +				  struct pci_device_header *pci_hdr,
> +				  u16 new_command)
> +{
> +	int i;
> +	bool toggle_io, toggle_mem;
> +
> +	toggle_io = (pci_hdr->command ^ new_command) & PCI_COMMAND_IO;
> +	toggle_mem = (pci_hdr->command ^ new_command) & PCI_COMMAND_MEMORY;
> +
> +	for (i = 0; i < 6; i++) {
> +		if (!pci_bar_is_implemented(pci_hdr, i))
> +			continue;
> +
> +		if (toggle_io && pci__bar_is_io(pci_hdr, i)) {
> +			if (__pci__io_space_enabled(new_command))
> +				pci_hdr->bar_activate_fn(kvm, pci_hdr, i,
> +							 pci_hdr->data);
> +			else
> +				pci_hdr->bar_deactivate_fn(kvm, pci_hdr, i,
> +							   pci_hdr->data);
> +		}
> +
> +		if (toggle_mem && pci__bar_is_memory(pci_hdr, i)) {
> +			if (__pci__memory_space_enabled(new_command))
> +				pci_hdr->bar_activate_fn(kvm, pci_hdr, i,
> +							 pci_hdr->data);
> +			else
> +				pci_hdr->bar_deactivate_fn(kvm, pci_hdr, i,
> +							   pci_hdr->data);
> +		}
> +	}
> +
> +	pci_hdr->command = new_command;
> +}
> +
>  void pci__config_wr(struct kvm *kvm, union pci_config_address addr, void *data, int size)
>  {
>  	void *base;
> @@ -182,6 +218,12 @@ void pci__config_wr(struct kvm *kvm, union pci_config_address addr, void *data,
>  	if (*(u32 *)(base + offset) == 0)
>  		return;
>  
> +	if (offset == PCI_COMMAND) {
> +		memcpy(&value, data, size);
> +		pci_config_command_wr(kvm, pci_hdr, (u16)value);
> +		return;
> +	}
> +
>  	bar = (offset - PCI_BAR_OFFSET(0)) / sizeof(u32);
>  
>  	/*

