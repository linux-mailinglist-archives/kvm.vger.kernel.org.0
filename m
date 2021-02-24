Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81AF8324161
	for <lists+kvm@lfdr.de>; Wed, 24 Feb 2021 17:06:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236115AbhBXPup convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Wed, 24 Feb 2021 10:50:45 -0500
Received: from foss.arm.com ([217.140.110.172]:35232 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234565AbhBXO4L (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Feb 2021 09:56:11 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 14F15101E;
        Wed, 24 Feb 2021 06:55:25 -0800 (PST)
Received: from slackpad.fritz.box (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D28A53F70D;
        Wed, 24 Feb 2021 06:55:23 -0800 (PST)
Date:   Wed, 24 Feb 2021 14:54:22 +0000
From:   Andre Przywara <andre.przywara@arm.com>
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     Will Deacon <will@kernel.org>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org, Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH kvmtool 13/21] hw/serial: Refactor trap handler
Message-ID: <20210224145422.6bfd0ff2@slackpad.fritz.box>
In-Reply-To: <85c714de-edb8-666d-49be-90539e347e30@arm.com>
References: <20201210142908.169597-1-andre.przywara@arm.com>
        <20201210142908.169597-14-andre.przywara@arm.com>
        <5c91e8f2-7bdf-4c4a-1da3-08dac79fd9a4@arm.com>
        <20210218144153.776fb089@slackpad.fritz.box>
        <85c714de-edb8-666d-49be-90539e347e30@arm.com>
Organization: Arm Ltd.
X-Mailer: Claws Mail 3.17.1 (GTK+ 2.24.31; x86_64-slackware-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 22 Feb 2021 17:40:36 +0000
Alexandru Elisei <alexandru.elisei@arm.com> wrote:

Hi Alex,

> On 2/18/21 2:41 PM, Andre Przywara wrote:
> > On Tue, 16 Feb 2021 14:22:05 +0000
> > Alexandru Elisei <alexandru.elisei@arm.com> wrote:
> >  
> >> Hi Andre,
> >>
> >> Patch looks good, nitpicks below.
> >>
> >> On 12/10/20 2:29 PM, Andre Przywara wrote:  
> >>> With the planned retirement of the special ioport emulation code, we
> >>> need to provide an emulation function compatible with the MMIO prototype.
> >>>
> >>> Adjust the trap handler to use that new function, and provide shims to
> >>> implement the old ioport interface, for now.
> >>>
> >>> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> >>> ---
> >>>  hw/serial.c | 97 +++++++++++++++++++++++++++++++++++------------------
> >>>  1 file changed, 65 insertions(+), 32 deletions(-)
> >>>
> >>> diff --git a/hw/serial.c b/hw/serial.c
> >>> index b0465d99..2907089c 100644
> >>> --- a/hw/serial.c
> >>> +++ b/hw/serial.c
> >>> @@ -242,36 +242,31 @@ void serial8250__inject_sysrq(struct kvm *kvm, char sysrq)
> >>>  	sysrq_pending = sysrq;
> >>>  }
> >>>  
> >>> -static bool serial8250_out(struct ioport *ioport, struct kvm_cpu *vcpu, u16 port,
> >>> -			   void *data, int size)
> >>> +static bool serial8250_out(struct serial8250_device *dev, struct kvm_cpu *vcpu,
> >>> +			   u16 offset, u8 data)
> >>>  {
> >>> -	struct serial8250_device *dev = ioport->priv;
> >>> -	u16 offset;
> >>>  	bool ret = true;
> >>> -	char *addr = data;
> >>>  
> >>>  	mutex_lock(&dev->mutex);
> >>>  
> >>> -	offset = port - dev->iobase;
> >>> -
> >>>  	switch (offset) {
> >>>  	case UART_TX:
> >>>  		if (dev->lcr & UART_LCR_DLAB) {
> >>> -			dev->dll = ioport__read8(data);
> >>> +			dev->dll = data;
> >>>  			break;
> >>>  		}
> >>>  
> >>>  		/* Loopback mode */
> >>>  		if (dev->mcr & UART_MCR_LOOP) {
> >>>  			if (dev->rxcnt < FIFO_LEN) {
> >>> -				dev->rxbuf[dev->rxcnt++] = *addr;
> >>> +				dev->rxbuf[dev->rxcnt++] = data;
> >>>  				dev->lsr |= UART_LSR_DR;
> >>>  			}
> >>>  			break;
> >>>  		}
> >>>  
> >>>  		if (dev->txcnt < FIFO_LEN) {
> >>> -			dev->txbuf[dev->txcnt++] = *addr;
> >>> +			dev->txbuf[dev->txcnt++] = data;
> >>>  			dev->lsr &= ~UART_LSR_TEMT;
> >>>  			if (dev->txcnt == FIFO_LEN / 2)
> >>>  				dev->lsr &= ~UART_LSR_THRE;
> >>> @@ -283,18 +278,18 @@ static bool serial8250_out(struct ioport *ioport, struct kvm_cpu *vcpu, u16 port
> >>>  		break;
> >>>  	case UART_IER:
> >>>  		if (!(dev->lcr & UART_LCR_DLAB))
> >>> -			dev->ier = ioport__read8(data) & 0x0f;
> >>> +			dev->ier = data & 0x0f;
> >>>  		else
> >>> -			dev->dlm = ioport__read8(data);
> >>> +			dev->dlm = data;
> >>>  		break;
> >>>  	case UART_FCR:
> >>> -		dev->fcr = ioport__read8(data);
> >>> +		dev->fcr = data;
> >>>  		break;
> >>>  	case UART_LCR:
> >>> -		dev->lcr = ioport__read8(data);
> >>> +		dev->lcr = data;
> >>>  		break;
> >>>  	case UART_MCR:
> >>> -		dev->mcr = ioport__read8(data);
> >>> +		dev->mcr = data;
> >>>  		break;
> >>>  	case UART_LSR:
> >>>  		/* Factory test */
> >>> @@ -303,7 +298,7 @@ static bool serial8250_out(struct ioport *ioport, struct kvm_cpu *vcpu, u16 port
> >>>  		/* Not used */
> >>>  		break;
> >>>  	case UART_SCR:
> >>> -		dev->scr = ioport__read8(data);
> >>> +		dev->scr = data;
> >>>  		break;
> >>>  	default:
> >>>  		ret = false;
> >>> @@ -336,46 +331,43 @@ static void serial8250_rx(struct serial8250_device *dev, void *data)
> >>>  	}
> >>>  }
> >>>  
> >>> -static bool serial8250_in(struct ioport *ioport, struct kvm_cpu *vcpu, u16 port, void *data, int size)
> >>> +static bool serial8250_in(struct serial8250_device *dev, struct kvm_cpu *vcpu,
> >>> +			  u16 offset, u8 *data)
> >>>  {
> >>> -	struct serial8250_device *dev = ioport->priv;
> >>> -	u16 offset;
> >>>  	bool ret = true;
> >>>  
> >>>  	mutex_lock(&dev->mutex);
> >>>  
> >>> -	offset = port - dev->iobase;
> >>> -
> >>>  	switch (offset) {
> >>>  	case UART_RX:
> >>>  		if (dev->lcr & UART_LCR_DLAB)
> >>> -			ioport__write8(data, dev->dll);
> >>> +			*data = dev->dll;
> >>>  		else
> >>>  			serial8250_rx(dev, data);
> >>>  		break;
> >>>  	case UART_IER:
> >>>  		if (dev->lcr & UART_LCR_DLAB)
> >>> -			ioport__write8(data, dev->dlm);
> >>> +			*data = dev->dlm;
> >>>  		else
> >>> -			ioport__write8(data, dev->ier);
> >>> +			*data = dev->ier;
> >>>  		break;
> >>>  	case UART_IIR:
> >>> -		ioport__write8(data, dev->iir | UART_IIR_TYPE_BITS);
> >>> +		*data = dev->iir | UART_IIR_TYPE_BITS;
> >>>  		break;
> >>>  	case UART_LCR:
> >>> -		ioport__write8(data, dev->lcr);
> >>> +		*data = dev->lcr;
> >>>  		break;
> >>>  	case UART_MCR:
> >>> -		ioport__write8(data, dev->mcr);
> >>> +		*data = dev->mcr;
> >>>  		break;
> >>>  	case UART_LSR:
> >>> -		ioport__write8(data, dev->lsr);
> >>> +		*data = dev->lsr;
> >>>  		break;
> >>>  	case UART_MSR:
> >>> -		ioport__write8(data, dev->msr);
> >>> +		*data = dev->msr;
> >>>  		break;
> >>>  	case UART_SCR:
> >>> -		ioport__write8(data, dev->scr);
> >>> +		*data = dev->scr;
> >>>  		break;
> >>>  	default:
> >>>  		ret = false;
> >>> @@ -389,6 +381,47 @@ static bool serial8250_in(struct ioport *ioport, struct kvm_cpu *vcpu, u16 port,
> >>>  	return ret;
> >>>  }
> >>>  
> >>> +static void serial8250_mmio(struct kvm_cpu *vcpu, u64 addr, u8 *data, u32 len,
> >>> +			    u8 is_write, void *ptr)
> >>> +{
> >>> +	struct serial8250_device *dev = ptr;
> >>> +	u8 value = 0;
> >>> +
> >>> +	if (is_write) {
> >>> +		 value = *data;    
> >> Extra space before value.
> >>  
> >>> +
> >>> +		serial8250_out(dev, vcpu, addr - dev->iobase, value);
> >>> +	} else {
> >>> +		if (serial8250_in(dev, vcpu, addr - dev->iobase, &value))
> >>> +			*data = value;
> >>> +	}
> >>> +}
> >>> +
> >>> +static bool serial8250_ioport_out(struct ioport *ioport, struct kvm_cpu *vcpu,
> >>> +				  u16 port, void *data, int size)
> >>> +{
> >>> +	struct serial8250_device *dev = ioport->priv;
> >>> +	u8 value = ioport__read8(data);
> >>> +
> >>> +	serial8250_mmio(vcpu, port, &value, 1, true, dev);
> >>> +
> >>> +	return true;
> >>> +}
> >>> +
> >>> +static bool serial8250_ioport_in(struct ioport *ioport, struct kvm_cpu *vcpu,
> >>> +				 u16 port, void *data, int size)
> >>> +{
> >>> +	struct serial8250_device *dev = ioport->priv;
> >>> +	u8 value = 0;
> >>> +
> >>> +
> >>> +	serial8250_mmio(vcpu, port, &value, 1, false, dev);
> >>> +
> >>> +	ioport__write8(data, value);    
> >> This is correct, but confusing. You pass the address of a local variable as *data
> >> to serial8250_mmio, serial8250_mmio conditionally updates the value at data (which
> >> is &value from here), and then here we update the *data unconditionally. Why not
> >> pass data directly to serial8250_mmio and skip the local variable? Am I missing
> >> something?  
> > The idea is to keep the abstraction of ioport__write<x>. I agree this
> > is somewhat pointless for a single byte write, since the purpose of
> > those wrappers is to deal with endianness, but it seems nice to use
> > that anyway, anywhere, in case we need to add something to the wrappers
> > at some point.  
> 
> What I was thinking was something like this:
> 
> @@ -385,25 +386,19 @@ static void serial8250_mmio(struct kvm_cpu *vcpu, u64 addr,
> u8 *data, u32 len,
>                             u8 is_write, void *ptr)
>  {
>         struct serial8250_device *dev = ptr;
> -       u8 value = 0;
>  
> -       if (is_write) {
> -                value = *data;
> -
> -               serial8250_out(dev, vcpu, addr - dev->iobase, value);
> -       } else {
> -               if (serial8250_in(dev, vcpu, addr - dev->iobase, &value))
> -                       *data = value;
> -       }
> +       if (is_write)
> +               serial8250_out(dev, vcpu, addr - dev->iobase, data);
> +       else
> +               serial8250_in(dev, vcpu, addr - dev->iobase, data);
>  }
>  
>  static bool serial8250_ioport_out(struct ioport *ioport, struct kvm_cpu *vcpu,
>                                   u16 port, void *data, int size)
>  {
>         struct serial8250_device *dev = ioport->priv;
> -       u8 value = ioport__read8(data);
>  
> -       serial8250_mmio(vcpu, port, &value, 1, true, dev);
> +       serial8250_mmio(vcpu, port, data, 1, true, dev);
>  
>         return true;
>  }
> @@ -412,12 +407,8 @@ static bool serial8250_ioport_in(struct ioport *ioport,
> struct kvm_cpu *vcpu,
>                                  u16 port, void *data, int size)
>  {
>         struct serial8250_device *dev = ioport->priv;
> -       u8 value = 0;
> -
> -
> -       serial8250_mmio(vcpu, port, &value, 1, false, dev);
>  
> -       ioport__write8(data, value);
> +       serial8250_mmio(vcpu, port, data, 1, false, dev);
>  
>         return true;
>  }
> 
> And the ioport_{read,write}8 function will used inside the serial8250_{out,in}
> functions, like they were before this patch, which should also make the diff
> smaller. Or is there something that I'm missing which makes this unfeasible?

Now I remember what the problem was:
The comment before the definition of ioport__read16() says the PowerPC
needs to byteswap specifically PCI port I/O, but apparently not MMIO.
So I moved the ioport wrappers out of the actual handlers, and in *this*
patch they are just in the PIO path, so make it fit for both kind of
traps.
Now with dropping the PIO specific path in the next patch we lose this
differentiation. This is not a real problem here, since all accesses
are 8 bit wide only, which doesn't do anything, really.

I think a proper fix for this problem would be to do the byteswapping
*once*, very early (write) or late (read) in the KVM_RUN
exit handling, or in the kvm__emulate_io() function. So that the
whole device emulation always works in native endianness, and can use
pointers at will. But this would obviously be another patch.

So in preparation for this I could drop all usage of
ioport__{read,write}8 from this file, and use pointers all the way.
That wouldn't change anything (since it's byte accesses only anyway),
but would already prepare for this move.

What do you think?

Cheers,
Andre

> > ioport__write8() is a static inline in a header file, so it shouldn't
> > really hurt, the compiler is able to see through it. The generated code
> > is almost the same, at least.
> >
> > Let me know what you think!
> >
> > Cheers,
> > Andre
> >  
> >>> +
> >>> +	return true;
> >>> +}
> >>> +
> >>>  #ifdef CONFIG_HAS_LIBFDT
> >>>  
> >>>  char *fdt_stdout_path = NULL;
> >>> @@ -427,8 +460,8 @@ void serial8250_generate_fdt_node(void *fdt, struct device_header *dev_hdr,
> >>>  #endif
> >>>  
> >>>  static struct ioport_operations serial8250_ops = {
> >>> -	.io_in			= serial8250_in,
> >>> -	.io_out			= serial8250_out,
> >>> +	.io_in			= serial8250_ioport_in,
> >>> +	.io_out			= serial8250_ioport_out,
> >>>  };
> >>>  
> >>>  static int serial8250__device_init(struct kvm *kvm,    

