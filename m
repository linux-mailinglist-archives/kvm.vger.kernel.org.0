Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8464F31CBFF
	for <lists+kvm@lfdr.de>; Tue, 16 Feb 2021 15:34:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230209AbhBPOc0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Feb 2021 09:32:26 -0500
Received: from foss.arm.com ([217.140.110.172]:36204 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229864AbhBPOcY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Feb 2021 09:32:24 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 118DC31B;
        Tue, 16 Feb 2021 06:31:37 -0800 (PST)
Received: from [192.168.0.110] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 16BAC3F694;
        Tue, 16 Feb 2021 06:31:35 -0800 (PST)
Subject: Re: [PATCH kvmtool 14/21] hw/serial: Switch to new trap handlers
To:     Andre Przywara <andre.przywara@arm.com>,
        Will Deacon <will@kernel.org>,
        Julien Thierry <julien.thierry.kdev@gmail.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org, Marc Zyngier <maz@kernel.org>
References: <20201210142908.169597-1-andre.przywara@arm.com>
 <20201210142908.169597-15-andre.przywara@arm.com>
From:   Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <a38de466-4bf7-193f-fbbe-872df93d5474@arm.com>
Date:   Tue, 16 Feb 2021 14:31:45 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20201210142908.169597-15-andre.przywara@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Andre,

Looks correct to me:

Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>

Thanks,

Alex

On 12/10/20 2:29 PM, Andre Przywara wrote:
> Now that the serial device has a trap handler adhering to the MMIO fault
> handler prototype, let's switch over to the joint registration routine.
>
> This allows us to get rid of the ioport shim routines.
>
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> ---
>  hw/serial.c | 36 +++---------------------------------
>  1 file changed, 3 insertions(+), 33 deletions(-)
>
> diff --git a/hw/serial.c b/hw/serial.c
> index 2907089c..d840eebc 100644
> --- a/hw/serial.c
> +++ b/hw/serial.c
> @@ -397,31 +397,6 @@ static void serial8250_mmio(struct kvm_cpu *vcpu, u64 addr, u8 *data, u32 len,
>  	}
>  }
>  
> -static bool serial8250_ioport_out(struct ioport *ioport, struct kvm_cpu *vcpu,
> -				  u16 port, void *data, int size)
> -{
> -	struct serial8250_device *dev = ioport->priv;
> -	u8 value = ioport__read8(data);
> -
> -	serial8250_mmio(vcpu, port, &value, 1, true, dev);
> -
> -	return true;
> -}
> -
> -static bool serial8250_ioport_in(struct ioport *ioport, struct kvm_cpu *vcpu,
> -				 u16 port, void *data, int size)
> -{
> -	struct serial8250_device *dev = ioport->priv;
> -	u8 value = 0;
> -
> -
> -	serial8250_mmio(vcpu, port, &value, 1, false, dev);
> -
> -	ioport__write8(data, value);
> -
> -	return true;
> -}
> -
>  #ifdef CONFIG_HAS_LIBFDT
>  
>  char *fdt_stdout_path = NULL;
> @@ -459,11 +434,6 @@ void serial8250_generate_fdt_node(void *fdt, struct device_header *dev_hdr,
>  }
>  #endif
>  
> -static struct ioport_operations serial8250_ops = {
> -	.io_in			= serial8250_ioport_in,
> -	.io_out			= serial8250_ioport_out,
> -};
> -
>  static int serial8250__device_init(struct kvm *kvm,
>  				   struct serial8250_device *dev)
>  {
> @@ -474,7 +444,7 @@ static int serial8250__device_init(struct kvm *kvm,
>  		return r;
>  
>  	ioport__map_irq(&dev->irq);
> -	r = ioport__register(kvm, dev->iobase, &serial8250_ops, 8, dev);
> +	r = kvm__register_pio(kvm, dev->iobase, 8, serial8250_mmio, dev);
>  
>  	return r;
>  }
> @@ -497,7 +467,7 @@ cleanup:
>  	for (j = 0; j <= i; j++) {
>  		struct serial8250_device *dev = &devices[j];
>  
> -		ioport__unregister(kvm, dev->iobase);
> +		kvm__deregister_pio(kvm, dev->iobase);
>  		device__unregister(&dev->dev_hdr);
>  	}
>  
> @@ -513,7 +483,7 @@ int serial8250__exit(struct kvm *kvm)
>  	for (i = 0; i < ARRAY_SIZE(devices); i++) {
>  		struct serial8250_device *dev = &devices[i];
>  
> -		r = ioport__unregister(kvm, dev->iobase);
> +		r = kvm__deregister_pio(kvm, dev->iobase);
>  		if (r < 0)
>  			return r;
>  		device__unregister(&dev->dev_hdr);
