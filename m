Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42D2C321E54
	for <lists+kvm@lfdr.de>; Mon, 22 Feb 2021 18:42:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231558AbhBVRlU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Feb 2021 12:41:20 -0500
Received: from foss.arm.com ([217.140.110.172]:58846 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231536AbhBVRlS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Feb 2021 12:41:18 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 748AF1FB;
        Mon, 22 Feb 2021 09:40:31 -0800 (PST)
Received: from [192.168.0.110] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 75B003F73B;
        Mon, 22 Feb 2021 09:40:30 -0800 (PST)
Subject: Re: [PATCH kvmtool 13/21] hw/serial: Refactor trap handler
To:     Andre Przywara <andre.przywara@arm.com>
Cc:     Will Deacon <will@kernel.org>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org, Marc Zyngier <maz@kernel.org>
References: <20201210142908.169597-1-andre.przywara@arm.com>
 <20201210142908.169597-14-andre.przywara@arm.com>
 <5c91e8f2-7bdf-4c4a-1da3-08dac79fd9a4@arm.com>
 <20210218144153.776fb089@slackpad.fritz.box>
From:   Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <85c714de-edb8-666d-49be-90539e347e30@arm.com>
Date:   Mon, 22 Feb 2021 17:40:36 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210218144153.776fb089@slackpad.fritz.box>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Andre,

On 2/18/21 2:41 PM, Andre Przywara wrote:
> On Tue, 16 Feb 2021 14:22:05 +0000
> Alexandru Elisei <alexandru.elisei@arm.com> wrote:
>
>> Hi Andre,
>>
>> Patch looks good, nitpicks below.
>>
>> On 12/10/20 2:29 PM, Andre Przywara wrote:
>>> With the planned retirement of the special ioport emulation code, we
>>> need to provide an emulation function compatible with the MMIO prototype.
>>>
>>> Adjust the trap handler to use that new function, and provide shims to
>>> implement the old ioport interface, for now.
>>>
>>> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
>>> ---
>>>  hw/serial.c | 97 +++++++++++++++++++++++++++++++++++------------------
>>>  1 file changed, 65 insertions(+), 32 deletions(-)
>>>
>>> diff --git a/hw/serial.c b/hw/serial.c
>>> index b0465d99..2907089c 100644
>>> --- a/hw/serial.c
>>> +++ b/hw/serial.c
>>> @@ -242,36 +242,31 @@ void serial8250__inject_sysrq(struct kvm *kvm, char sysrq)
>>>  	sysrq_pending = sysrq;
>>>  }
>>>  
>>> -static bool serial8250_out(struct ioport *ioport, struct kvm_cpu *vcpu, u16 port,
>>> -			   void *data, int size)
>>> +static bool serial8250_out(struct serial8250_device *dev, struct kvm_cpu *vcpu,
>>> +			   u16 offset, u8 data)
>>>  {
>>> -	struct serial8250_device *dev = ioport->priv;
>>> -	u16 offset;
>>>  	bool ret = true;
>>> -	char *addr = data;
>>>  
>>>  	mutex_lock(&dev->mutex);
>>>  
>>> -	offset = port - dev->iobase;
>>> -
>>>  	switch (offset) {
>>>  	case UART_TX:
>>>  		if (dev->lcr & UART_LCR_DLAB) {
>>> -			dev->dll = ioport__read8(data);
>>> +			dev->dll = data;
>>>  			break;
>>>  		}
>>>  
>>>  		/* Loopback mode */
>>>  		if (dev->mcr & UART_MCR_LOOP) {
>>>  			if (dev->rxcnt < FIFO_LEN) {
>>> -				dev->rxbuf[dev->rxcnt++] = *addr;
>>> +				dev->rxbuf[dev->rxcnt++] = data;
>>>  				dev->lsr |= UART_LSR_DR;
>>>  			}
>>>  			break;
>>>  		}
>>>  
>>>  		if (dev->txcnt < FIFO_LEN) {
>>> -			dev->txbuf[dev->txcnt++] = *addr;
>>> +			dev->txbuf[dev->txcnt++] = data;
>>>  			dev->lsr &= ~UART_LSR_TEMT;
>>>  			if (dev->txcnt == FIFO_LEN / 2)
>>>  				dev->lsr &= ~UART_LSR_THRE;
>>> @@ -283,18 +278,18 @@ static bool serial8250_out(struct ioport *ioport, struct kvm_cpu *vcpu, u16 port
>>>  		break;
>>>  	case UART_IER:
>>>  		if (!(dev->lcr & UART_LCR_DLAB))
>>> -			dev->ier = ioport__read8(data) & 0x0f;
>>> +			dev->ier = data & 0x0f;
>>>  		else
>>> -			dev->dlm = ioport__read8(data);
>>> +			dev->dlm = data;
>>>  		break;
>>>  	case UART_FCR:
>>> -		dev->fcr = ioport__read8(data);
>>> +		dev->fcr = data;
>>>  		break;
>>>  	case UART_LCR:
>>> -		dev->lcr = ioport__read8(data);
>>> +		dev->lcr = data;
>>>  		break;
>>>  	case UART_MCR:
>>> -		dev->mcr = ioport__read8(data);
>>> +		dev->mcr = data;
>>>  		break;
>>>  	case UART_LSR:
>>>  		/* Factory test */
>>> @@ -303,7 +298,7 @@ static bool serial8250_out(struct ioport *ioport, struct kvm_cpu *vcpu, u16 port
>>>  		/* Not used */
>>>  		break;
>>>  	case UART_SCR:
>>> -		dev->scr = ioport__read8(data);
>>> +		dev->scr = data;
>>>  		break;
>>>  	default:
>>>  		ret = false;
>>> @@ -336,46 +331,43 @@ static void serial8250_rx(struct serial8250_device *dev, void *data)
>>>  	}
>>>  }
>>>  
>>> -static bool serial8250_in(struct ioport *ioport, struct kvm_cpu *vcpu, u16 port, void *data, int size)
>>> +static bool serial8250_in(struct serial8250_device *dev, struct kvm_cpu *vcpu,
>>> +			  u16 offset, u8 *data)
>>>  {
>>> -	struct serial8250_device *dev = ioport->priv;
>>> -	u16 offset;
>>>  	bool ret = true;
>>>  
>>>  	mutex_lock(&dev->mutex);
>>>  
>>> -	offset = port - dev->iobase;
>>> -
>>>  	switch (offset) {
>>>  	case UART_RX:
>>>  		if (dev->lcr & UART_LCR_DLAB)
>>> -			ioport__write8(data, dev->dll);
>>> +			*data = dev->dll;
>>>  		else
>>>  			serial8250_rx(dev, data);
>>>  		break;
>>>  	case UART_IER:
>>>  		if (dev->lcr & UART_LCR_DLAB)
>>> -			ioport__write8(data, dev->dlm);
>>> +			*data = dev->dlm;
>>>  		else
>>> -			ioport__write8(data, dev->ier);
>>> +			*data = dev->ier;
>>>  		break;
>>>  	case UART_IIR:
>>> -		ioport__write8(data, dev->iir | UART_IIR_TYPE_BITS);
>>> +		*data = dev->iir | UART_IIR_TYPE_BITS;
>>>  		break;
>>>  	case UART_LCR:
>>> -		ioport__write8(data, dev->lcr);
>>> +		*data = dev->lcr;
>>>  		break;
>>>  	case UART_MCR:
>>> -		ioport__write8(data, dev->mcr);
>>> +		*data = dev->mcr;
>>>  		break;
>>>  	case UART_LSR:
>>> -		ioport__write8(data, dev->lsr);
>>> +		*data = dev->lsr;
>>>  		break;
>>>  	case UART_MSR:
>>> -		ioport__write8(data, dev->msr);
>>> +		*data = dev->msr;
>>>  		break;
>>>  	case UART_SCR:
>>> -		ioport__write8(data, dev->scr);
>>> +		*data = dev->scr;
>>>  		break;
>>>  	default:
>>>  		ret = false;
>>> @@ -389,6 +381,47 @@ static bool serial8250_in(struct ioport *ioport, struct kvm_cpu *vcpu, u16 port,
>>>  	return ret;
>>>  }
>>>  
>>> +static void serial8250_mmio(struct kvm_cpu *vcpu, u64 addr, u8 *data, u32 len,
>>> +			    u8 is_write, void *ptr)
>>> +{
>>> +	struct serial8250_device *dev = ptr;
>>> +	u8 value = 0;
>>> +
>>> +	if (is_write) {
>>> +		 value = *data;  
>> Extra space before value.
>>
>>> +
>>> +		serial8250_out(dev, vcpu, addr - dev->iobase, value);
>>> +	} else {
>>> +		if (serial8250_in(dev, vcpu, addr - dev->iobase, &value))
>>> +			*data = value;
>>> +	}
>>> +}
>>> +
>>> +static bool serial8250_ioport_out(struct ioport *ioport, struct kvm_cpu *vcpu,
>>> +				  u16 port, void *data, int size)
>>> +{
>>> +	struct serial8250_device *dev = ioport->priv;
>>> +	u8 value = ioport__read8(data);
>>> +
>>> +	serial8250_mmio(vcpu, port, &value, 1, true, dev);
>>> +
>>> +	return true;
>>> +}
>>> +
>>> +static bool serial8250_ioport_in(struct ioport *ioport, struct kvm_cpu *vcpu,
>>> +				 u16 port, void *data, int size)
>>> +{
>>> +	struct serial8250_device *dev = ioport->priv;
>>> +	u8 value = 0;
>>> +
>>> +
>>> +	serial8250_mmio(vcpu, port, &value, 1, false, dev);
>>> +
>>> +	ioport__write8(data, value);  
>> This is correct, but confusing. You pass the address of a local variable as *data
>> to serial8250_mmio, serial8250_mmio conditionally updates the value at data (which
>> is &value from here), and then here we update the *data unconditionally. Why not
>> pass data directly to serial8250_mmio and skip the local variable? Am I missing
>> something?
> The idea is to keep the abstraction of ioport__write<x>. I agree this
> is somewhat pointless for a single byte write, since the purpose of
> those wrappers is to deal with endianness, but it seems nice to use
> that anyway, anywhere, in case we need to add something to the wrappers
> at some point.

What I was thinking was something like this:

@@ -385,25 +386,19 @@ static void serial8250_mmio(struct kvm_cpu *vcpu, u64 addr,
u8 *data, u32 len,
                            u8 is_write, void *ptr)
 {
        struct serial8250_device *dev = ptr;
-       u8 value = 0;
 
-       if (is_write) {
-                value = *data;
-
-               serial8250_out(dev, vcpu, addr - dev->iobase, value);
-       } else {
-               if (serial8250_in(dev, vcpu, addr - dev->iobase, &value))
-                       *data = value;
-       }
+       if (is_write)
+               serial8250_out(dev, vcpu, addr - dev->iobase, data);
+       else
+               serial8250_in(dev, vcpu, addr - dev->iobase, data);
 }
 
 static bool serial8250_ioport_out(struct ioport *ioport, struct kvm_cpu *vcpu,
                                  u16 port, void *data, int size)
 {
        struct serial8250_device *dev = ioport->priv;
-       u8 value = ioport__read8(data);
 
-       serial8250_mmio(vcpu, port, &value, 1, true, dev);
+       serial8250_mmio(vcpu, port, data, 1, true, dev);
 
        return true;
 }
@@ -412,12 +407,8 @@ static bool serial8250_ioport_in(struct ioport *ioport,
struct kvm_cpu *vcpu,
                                 u16 port, void *data, int size)
 {
        struct serial8250_device *dev = ioport->priv;
-       u8 value = 0;
-
-
-       serial8250_mmio(vcpu, port, &value, 1, false, dev);
 
-       ioport__write8(data, value);
+       serial8250_mmio(vcpu, port, data, 1, false, dev);
 
        return true;
 }

And the ioport_{read,write}8 function will used inside the serial8250_{out,in}
functions, like they were before this patch, which should also make the diff
smaller. Or is there something that I'm missing which makes this unfeasible?

Thanks,

Alex

> ioport__write8() is a static inline in a header file, so it shouldn't
> really hurt, the compiler is able to see through it. The generated code
> is almost the same, at least.
>
> Let me know what you think!
>
> Cheers,
> Andre
>
>>> +
>>> +	return true;
>>> +}
>>> +
>>>  #ifdef CONFIG_HAS_LIBFDT
>>>  
>>>  char *fdt_stdout_path = NULL;
>>> @@ -427,8 +460,8 @@ void serial8250_generate_fdt_node(void *fdt, struct device_header *dev_hdr,
>>>  #endif
>>>  
>>>  static struct ioport_operations serial8250_ops = {
>>> -	.io_in			= serial8250_in,
>>> -	.io_out			= serial8250_out,
>>> +	.io_in			= serial8250_ioport_in,
>>> +	.io_out			= serial8250_ioport_out,
>>>  };
>>>  
>>>  static int serial8250__device_init(struct kvm *kvm,  
