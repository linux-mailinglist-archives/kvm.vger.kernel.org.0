Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9A0731A411
	for <lists+kvm@lfdr.de>; Fri, 12 Feb 2021 18:53:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231649AbhBLRvG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Feb 2021 12:51:06 -0500
Received: from foss.arm.com ([217.140.110.172]:40672 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229451AbhBLRu5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Feb 2021 12:50:57 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DACB21063;
        Fri, 12 Feb 2021 09:50:12 -0800 (PST)
Received: from [192.168.0.110] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id DFDAE3F73B;
        Fri, 12 Feb 2021 09:50:11 -0800 (PST)
Subject: Re: [PATCH kvmtool 12/21] hw/vesa: Switch trap handling to use MMIO
 handler
To:     Andre Przywara <andre.przywara@arm.com>,
        Will Deacon <will@kernel.org>,
        Julien Thierry <julien.thierry.kdev@gmail.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org, Marc Zyngier <maz@kernel.org>
References: <20201210142908.169597-1-andre.przywara@arm.com>
 <20201210142908.169597-13-andre.przywara@arm.com>
From:   Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <ca9d5ae8-9f16-ef7e-0a8b-2d389f56c3bc@arm.com>
Date:   Fri, 12 Feb 2021 17:50:28 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20201210142908.169597-13-andre.przywara@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Andre,

On 12/10/20 2:28 PM, Andre Przywara wrote:
> To be able to use the VESA device with the new generic I/O trap handler,
> we need to use the different MMIO handler callback routine.
>
> Replace the existing dummy in and out handlers with a joint dummy
> MMIO handler, and register this using the new registration function.
>
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> ---
>  hw/vesa.c | 19 +++++--------------
>  1 file changed, 5 insertions(+), 14 deletions(-)
>
> diff --git a/hw/vesa.c b/hw/vesa.c
> index 8659a002..7f82cdb4 100644
> --- a/hw/vesa.c
> +++ b/hw/vesa.c
> @@ -43,21 +43,11 @@ static struct framebuffer vesafb = {
>  	.mem_size	= VESA_MEM_SIZE,
>  };
>  
> -static bool vesa_pci_io_in(struct ioport *ioport, struct kvm_cpu *vcpu, u16 port, void *data, int size)
> +static void vesa_pci_io(struct kvm_cpu *vcpu, u64 addr, u8 *data, u32 len,
> +		        u8 is_write, void *ptr)
>  {
> -	return true;
>  }
>  
> -static bool vesa_pci_io_out(struct ioport *ioport, struct kvm_cpu *vcpu, u16 port, void *data, int size)
> -{
> -	return true;
> -}
> -
> -static struct ioport_operations vesa_io_ops = {
> -	.io_in			= vesa_pci_io_in,
> -	.io_out			= vesa_pci_io_out,
> -};
> -
>  static int vesa__bar_activate(struct kvm *kvm, struct pci_device_header *pci_hdr,
>  			      int bar_num, void *data)
>  {
> @@ -82,7 +72,8 @@ struct framebuffer *vesa__init(struct kvm *kvm)
>  	BUILD_BUG_ON(VESA_MEM_SIZE < VESA_BPP/8 * VESA_WIDTH * VESA_HEIGHT);
>  
>  	vesa_base_addr = pci_get_io_port_block(PCI_IO_SIZE);
> -	r = ioport__register(kvm, vesa_base_addr, &vesa_io_ops, PCI_IO_SIZE, NULL);
> +	r = kvm__register_pio(kvm, vesa_base_addr, PCI_IO_SIZE, vesa_pci_io,
> +			      NULL);
>  	if (r < 0)
>  		goto out_error;
>  
> @@ -116,7 +107,7 @@ unmap_dev:
>  unregister_device:
>  	device__unregister(&vesa_device);
>  unregister_ioport:
> -	ioport__unregister(kvm, vesa_base_addr);
> +	kvm__deregister_pio(kvm, vesa_base_addr);
>  out_error:
>  	return ERR_PTR(r);
>  }

Looks good:

Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>

Thanks,

Alex

