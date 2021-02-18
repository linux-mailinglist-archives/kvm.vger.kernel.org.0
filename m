Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 256C631EE3A
	for <lists+kvm@lfdr.de>; Thu, 18 Feb 2021 19:27:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231258AbhBRS0j convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Thu, 18 Feb 2021 13:26:39 -0500
Received: from foss.arm.com ([217.140.110.172]:53004 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233212AbhBRQPl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 Feb 2021 11:15:41 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 04EB8ED1;
        Thu, 18 Feb 2021 08:14:51 -0800 (PST)
Received: from slackpad.fritz.box (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6E2793F73D;
        Thu, 18 Feb 2021 08:14:48 -0800 (PST)
Date:   Thu, 18 Feb 2021 16:13:49 +0000
From:   Andre Przywara <andre.przywara@arm.com>
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     Will Deacon <will@kernel.org>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org, Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH kvmtool 17/21] virtio: Switch trap handling to use MMIO
 handler
Message-ID: <20210218161349.632897c9@slackpad.fritz.box>
In-Reply-To: <0c6e033e-4bc4-bc81-173f-c7c195ded78a@arm.com>
References: <20201210142908.169597-1-andre.przywara@arm.com>
        <20201210142908.169597-18-andre.przywara@arm.com>
        <0c6e033e-4bc4-bc81-173f-c7c195ded78a@arm.com>
Organization: Arm Ltd.
X-Mailer: Claws Mail 3.17.1 (GTK+ 2.24.31; x86_64-slackware-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 16 Feb 2021 17:03:04 +0000
Alexandru Elisei <alexandru.elisei@arm.com> wrote:

> Hi Andre,
> 
> Nitpick below, otherwise looks good.
> 
> On 12/10/20 2:29 PM, Andre Przywara wrote:
> > With the planned retirement of the special ioport emulation code, we
> > need to provide an emulation function compatible with the MMIO prototype.
> >
> > Adjust the existing MMIO callback routine to automatically determine
> > the region this trap came through, and call the existing I/O handlers.
> > Register the ioport region using the new registration function.
> >
> > Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> > ---
> >  virtio/pci.c | 42 ++++++++++--------------------------------
> >  1 file changed, 10 insertions(+), 32 deletions(-)
> >
> > diff --git a/virtio/pci.c b/virtio/pci.c
> > index 6eea6c68..49d3f4d5 100644
> > --- a/virtio/pci.c
> > +++ b/virtio/pci.c
> > @@ -178,15 +178,6 @@ static bool virtio_pci__data_in(struct kvm_cpu *vcpu, struct virtio_device *vdev
> >  	return ret;
> >  }
> >  
> > -static bool virtio_pci__io_in(struct ioport *ioport, struct kvm_cpu *vcpu, u16 port, void *data, int size)
> > -{
> > -	struct virtio_device *vdev = ioport->priv;
> > -	struct virtio_pci *vpci = vdev->virtio;
> > -	unsigned long offset = port - virtio_pci__port_addr(vpci);
> > -
> > -	return virtio_pci__data_in(vcpu, vdev, offset, data, size);
> > -}
> > -
> >  static void update_msix_map(struct virtio_pci *vpci,
> >  			    struct msix_table *msix_entry, u32 vecnum)
> >  {
> > @@ -334,20 +325,6 @@ static bool virtio_pci__data_out(struct kvm_cpu *vcpu, struct virtio_device *vde
> >  	return ret;
> >  }
> >  
> > -static bool virtio_pci__io_out(struct ioport *ioport, struct kvm_cpu *vcpu, u16 port, void *data, int size)
> > -{
> > -	struct virtio_device *vdev = ioport->priv;
> > -	struct virtio_pci *vpci = vdev->virtio;
> > -	unsigned long offset = port - virtio_pci__port_addr(vpci);
> > -
> > -	return virtio_pci__data_out(vcpu, vdev, offset, data, size);
> > -}
> > -
> > -static struct ioport_operations virtio_pci__io_ops = {
> > -	.io_in	= virtio_pci__io_in,
> > -	.io_out	= virtio_pci__io_out,
> > -};
> > -
> >  static void virtio_pci__msix_mmio_callback(struct kvm_cpu *vcpu,
> >  					   u64 addr, u8 *data, u32 len,
> >  					   u8 is_write, void *ptr)
> > @@ -455,12 +432,15 @@ static void virtio_pci__io_mmio_callback(struct kvm_cpu *vcpu,
> >  {
> >  	struct virtio_device *vdev = ptr;
> >  	struct virtio_pci *vpci = vdev->virtio;
> > -	u32 mmio_addr = virtio_pci__mmio_addr(vpci);
> > +	u32 base_addr = virtio_pci__mmio_addr(vpci);
> > +
> > +	if (addr < base_addr || addr >= base_addr + PCI_IO_SIZE)
> > +		base_addr = virtio_pci__port_addr(vpci);  
> 
> There are only two BARs that use this callback, the ioport BAR (BAR0) and the
> memory BAR (BAR1) (MSIX uses a different emulation callback). The condition above
> says that if addr is not inside the region described by the memory BAR, then it's
> an ioport BAR. How about checking explicitly that it is inside the ioport region
> like this (compile tested only), which looks a bit more intuitive for me:

Fair enough.

Cheers,
Andre

> 
> diff --git a/virtio/pci.c b/virtio/pci.c
> index 49d3f4d524b2..4024bcd709cd 100644
> --- a/virtio/pci.c
> +++ b/virtio/pci.c
> @@ -432,10 +432,15 @@ static void virtio_pci__io_mmio_callback(struct kvm_cpu *vcpu,
>  {
>         struct virtio_device *vdev = ptr;
>         struct virtio_pci *vpci = vdev->virtio;
> -       u32 base_addr = virtio_pci__mmio_addr(vpci);
> +       u32 mmio_addr = virtio_pci__mmio_addr(vpci);
> +       u32 ioport_addr = virtio_pci__port_addr(vpci);
> +       u32 base_addr;
>  
> -       if (addr < base_addr || addr >= base_addr + PCI_IO_SIZE)
> -               base_addr = virtio_pci__port_addr(vpci);
> +       if (addr >= ioport_addr &&
> +           addr < ioport_addr + pci__bar_size(&vpci->pci_hdr, 0))
> +               base_addr = ioport_addr;
> +       else
> +               base_addr = mmio_addr;
>  
>         if (!is_write)
>                 virtio_pci__data_in(vcpu, vdev, addr - base_addr, data, len);
> 
> Thanks,
> 
> Alex
> 
> >  
> >  	if (!is_write)
> > -		virtio_pci__data_in(vcpu, vdev, addr - mmio_addr, data, len);
> > +		virtio_pci__data_in(vcpu, vdev, addr - base_addr, data, len);
> >  	else
> > -		virtio_pci__data_out(vcpu, vdev, addr - mmio_addr, data, len);
> > +		virtio_pci__data_out(vcpu, vdev, addr - base_addr, data, len);
> >  }
> >  
> >  static int virtio_pci__bar_activate(struct kvm *kvm,
> > @@ -478,10 +458,8 @@ static int virtio_pci__bar_activate(struct kvm *kvm,
> >  
> >  	switch (bar_num) {
> >  	case 0:
> > -		r = ioport__register(kvm, bar_addr, &virtio_pci__io_ops,
> > -				     bar_size, vdev);
> > -		if (r > 0)
> > -			r = 0;
> > +		r = kvm__register_pio(kvm, bar_addr, bar_size,
> > +				      virtio_pci__io_mmio_callback, vdev);
> >  		break;
> >  	case 1:
> >  		r =  kvm__register_mmio(kvm, bar_addr, bar_size, false,
> > @@ -510,7 +488,7 @@ static int virtio_pci__bar_deactivate(struct kvm *kvm,
> >  
> >  	switch (bar_num) {
> >  	case 0:
> > -		r = ioport__unregister(kvm, bar_addr);
> > +		r = kvm__deregister_pio(kvm, bar_addr);
> >  		break;
> >  	case 1:
> >  	case 2:
> > @@ -625,7 +603,7 @@ int virtio_pci__exit(struct kvm *kvm, struct virtio_device *vdev)
> >  	virtio_pci__reset(kvm, vdev);
> >  	kvm__deregister_mmio(kvm, virtio_pci__mmio_addr(vpci));
> >  	kvm__deregister_mmio(kvm, virtio_pci__msix_io_addr(vpci));
> > -	ioport__unregister(kvm, virtio_pci__port_addr(vpci));
> > +	kvm__deregister_pio(kvm, virtio_pci__port_addr(vpci));
> >  
> >  	return 0;
> >  }  

