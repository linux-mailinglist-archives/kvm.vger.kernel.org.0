Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0653731CE99
	for <lists+kvm@lfdr.de>; Tue, 16 Feb 2021 18:04:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230310AbhBPRDo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Feb 2021 12:03:44 -0500
Received: from foss.arm.com ([217.140.110.172]:39226 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229784AbhBPRDl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Feb 2021 12:03:41 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A539C101E;
        Tue, 16 Feb 2021 09:02:55 -0800 (PST)
Received: from [192.168.0.110] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A99363F73B;
        Tue, 16 Feb 2021 09:02:54 -0800 (PST)
Subject: Re: [PATCH kvmtool 17/21] virtio: Switch trap handling to use MMIO
 handler
To:     Andre Przywara <andre.przywara@arm.com>,
        Will Deacon <will@kernel.org>,
        Julien Thierry <julien.thierry.kdev@gmail.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org, Marc Zyngier <maz@kernel.org>
References: <20201210142908.169597-1-andre.przywara@arm.com>
 <20201210142908.169597-18-andre.przywara@arm.com>
From:   Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <0c6e033e-4bc4-bc81-173f-c7c195ded78a@arm.com>
Date:   Tue, 16 Feb 2021 17:03:04 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20201210142908.169597-18-andre.przywara@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Andre,

Nitpick below, otherwise looks good.

On 12/10/20 2:29 PM, Andre Przywara wrote:
> With the planned retirement of the special ioport emulation code, we
> need to provide an emulation function compatible with the MMIO prototype.
>
> Adjust the existing MMIO callback routine to automatically determine
> the region this trap came through, and call the existing I/O handlers.
> Register the ioport region using the new registration function.
>
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> ---
>  virtio/pci.c | 42 ++++++++++--------------------------------
>  1 file changed, 10 insertions(+), 32 deletions(-)
>
> diff --git a/virtio/pci.c b/virtio/pci.c
> index 6eea6c68..49d3f4d5 100644
> --- a/virtio/pci.c
> +++ b/virtio/pci.c
> @@ -178,15 +178,6 @@ static bool virtio_pci__data_in(struct kvm_cpu *vcpu, struct virtio_device *vdev
>  	return ret;
>  }
>  
> -static bool virtio_pci__io_in(struct ioport *ioport, struct kvm_cpu *vcpu, u16 port, void *data, int size)
> -{
> -	struct virtio_device *vdev = ioport->priv;
> -	struct virtio_pci *vpci = vdev->virtio;
> -	unsigned long offset = port - virtio_pci__port_addr(vpci);
> -
> -	return virtio_pci__data_in(vcpu, vdev, offset, data, size);
> -}
> -
>  static void update_msix_map(struct virtio_pci *vpci,
>  			    struct msix_table *msix_entry, u32 vecnum)
>  {
> @@ -334,20 +325,6 @@ static bool virtio_pci__data_out(struct kvm_cpu *vcpu, struct virtio_device *vde
>  	return ret;
>  }
>  
> -static bool virtio_pci__io_out(struct ioport *ioport, struct kvm_cpu *vcpu, u16 port, void *data, int size)
> -{
> -	struct virtio_device *vdev = ioport->priv;
> -	struct virtio_pci *vpci = vdev->virtio;
> -	unsigned long offset = port - virtio_pci__port_addr(vpci);
> -
> -	return virtio_pci__data_out(vcpu, vdev, offset, data, size);
> -}
> -
> -static struct ioport_operations virtio_pci__io_ops = {
> -	.io_in	= virtio_pci__io_in,
> -	.io_out	= virtio_pci__io_out,
> -};
> -
>  static void virtio_pci__msix_mmio_callback(struct kvm_cpu *vcpu,
>  					   u64 addr, u8 *data, u32 len,
>  					   u8 is_write, void *ptr)
> @@ -455,12 +432,15 @@ static void virtio_pci__io_mmio_callback(struct kvm_cpu *vcpu,
>  {
>  	struct virtio_device *vdev = ptr;
>  	struct virtio_pci *vpci = vdev->virtio;
> -	u32 mmio_addr = virtio_pci__mmio_addr(vpci);
> +	u32 base_addr = virtio_pci__mmio_addr(vpci);
> +
> +	if (addr < base_addr || addr >= base_addr + PCI_IO_SIZE)
> +		base_addr = virtio_pci__port_addr(vpci);

There are only two BARs that use this callback, the ioport BAR (BAR0) and the
memory BAR (BAR1) (MSIX uses a different emulation callback). The condition above
says that if addr is not inside the region described by the memory BAR, then it's
an ioport BAR. How about checking explicitly that it is inside the ioport region
like this (compile tested only), which looks a bit more intuitive for me:

diff --git a/virtio/pci.c b/virtio/pci.c
index 49d3f4d524b2..4024bcd709cd 100644
--- a/virtio/pci.c
+++ b/virtio/pci.c
@@ -432,10 +432,15 @@ static void virtio_pci__io_mmio_callback(struct kvm_cpu *vcpu,
 {
        struct virtio_device *vdev = ptr;
        struct virtio_pci *vpci = vdev->virtio;
-       u32 base_addr = virtio_pci__mmio_addr(vpci);
+       u32 mmio_addr = virtio_pci__mmio_addr(vpci);
+       u32 ioport_addr = virtio_pci__port_addr(vpci);
+       u32 base_addr;
 
-       if (addr < base_addr || addr >= base_addr + PCI_IO_SIZE)
-               base_addr = virtio_pci__port_addr(vpci);
+       if (addr >= ioport_addr &&
+           addr < ioport_addr + pci__bar_size(&vpci->pci_hdr, 0))
+               base_addr = ioport_addr;
+       else
+               base_addr = mmio_addr;
 
        if (!is_write)
                virtio_pci__data_in(vcpu, vdev, addr - base_addr, data, len);

Thanks,

Alex

>  
>  	if (!is_write)
> -		virtio_pci__data_in(vcpu, vdev, addr - mmio_addr, data, len);
> +		virtio_pci__data_in(vcpu, vdev, addr - base_addr, data, len);
>  	else
> -		virtio_pci__data_out(vcpu, vdev, addr - mmio_addr, data, len);
> +		virtio_pci__data_out(vcpu, vdev, addr - base_addr, data, len);
>  }
>  
>  static int virtio_pci__bar_activate(struct kvm *kvm,
> @@ -478,10 +458,8 @@ static int virtio_pci__bar_activate(struct kvm *kvm,
>  
>  	switch (bar_num) {
>  	case 0:
> -		r = ioport__register(kvm, bar_addr, &virtio_pci__io_ops,
> -				     bar_size, vdev);
> -		if (r > 0)
> -			r = 0;
> +		r = kvm__register_pio(kvm, bar_addr, bar_size,
> +				      virtio_pci__io_mmio_callback, vdev);
>  		break;
>  	case 1:
>  		r =  kvm__register_mmio(kvm, bar_addr, bar_size, false,
> @@ -510,7 +488,7 @@ static int virtio_pci__bar_deactivate(struct kvm *kvm,
>  
>  	switch (bar_num) {
>  	case 0:
> -		r = ioport__unregister(kvm, bar_addr);
> +		r = kvm__deregister_pio(kvm, bar_addr);
>  		break;
>  	case 1:
>  	case 2:
> @@ -625,7 +603,7 @@ int virtio_pci__exit(struct kvm *kvm, struct virtio_device *vdev)
>  	virtio_pci__reset(kvm, vdev);
>  	kvm__deregister_mmio(kvm, virtio_pci__mmio_addr(vpci));
>  	kvm__deregister_mmio(kvm, virtio_pci__msix_io_addr(vpci));
> -	ioport__unregister(kvm, virtio_pci__port_addr(vpci));
> +	kvm__deregister_pio(kvm, virtio_pci__port_addr(vpci));
>  
>  	return 0;
>  }
