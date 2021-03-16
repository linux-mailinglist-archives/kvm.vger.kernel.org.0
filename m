Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC88A33D7CE
	for <lists+kvm@lfdr.de>; Tue, 16 Mar 2021 16:40:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234013AbhCPPkO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Mar 2021 11:40:14 -0400
Received: from foss.arm.com ([217.140.110.172]:47070 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231326AbhCPPkF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Mar 2021 11:40:05 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DFFABD6E;
        Tue, 16 Mar 2021 08:40:04 -0700 (PDT)
Received: from [192.168.0.110] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D30E23F792;
        Tue, 16 Mar 2021 08:40:03 -0700 (PDT)
Subject: Re: [PATCH kvmtool v3 13/22] hw/serial: Refactor trap handler
To:     Andre Przywara <andre.przywara@arm.com>,
        Will Deacon <will@kernel.org>,
        Julien Thierry <julien.thierry.kdev@gmail.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        Marc Zyngier <maz@kernel.org>,
        Sami Mujawar <sami.mujawar@arm.com>
References: <20210315153350.19988-1-andre.przywara@arm.com>
 <20210315153350.19988-14-andre.przywara@arm.com>
From:   Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <08350e12-76c7-2d3f-fd05-67356d21479b@arm.com>
Date:   Tue, 16 Mar 2021 15:40:17 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210315153350.19988-14-andre.przywara@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Andre,

On 3/15/21 3:33 PM, Andre Przywara wrote:

> With the planned retirement of the special ioport emulation code, we
> need to provide an emulation function compatible with the MMIO prototype.
>
> Adjust the trap handler to use that new function, and provide shims to
> implement the old ioport interface, for now.

The diff looks nice and tidy. I checked that the changes are functionally
identical, also did a quick kvm-unit-tests run and booted an arm64 kernel:

Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>

Thanks,

Alex

>
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> ---
>  hw/serial.c | 50 +++++++++++++++++++++++++++++++++++++-------------
>  1 file changed, 37 insertions(+), 13 deletions(-)
>
> diff --git a/hw/serial.c b/hw/serial.c
> index b0465d99..3f797452 100644
> --- a/hw/serial.c
> +++ b/hw/serial.c
> @@ -242,18 +242,14 @@ void serial8250__inject_sysrq(struct kvm *kvm, char sysrq)
>  	sysrq_pending = sysrq;
>  }
>  
> -static bool serial8250_out(struct ioport *ioport, struct kvm_cpu *vcpu, u16 port,
> -			   void *data, int size)
> +static bool serial8250_out(struct serial8250_device *dev, struct kvm_cpu *vcpu,
> +			   u16 offset, void *data)
>  {
> -	struct serial8250_device *dev = ioport->priv;
> -	u16 offset;
>  	bool ret = true;
>  	char *addr = data;
>  
>  	mutex_lock(&dev->mutex);
>  
> -	offset = port - dev->iobase;
> -
>  	switch (offset) {
>  	case UART_TX:
>  		if (dev->lcr & UART_LCR_DLAB) {
> @@ -336,16 +332,13 @@ static void serial8250_rx(struct serial8250_device *dev, void *data)
>  	}
>  }
>  
> -static bool serial8250_in(struct ioport *ioport, struct kvm_cpu *vcpu, u16 port, void *data, int size)
> +static bool serial8250_in(struct serial8250_device *dev, struct kvm_cpu *vcpu,
> +			  u16 offset, void *data)
>  {
> -	struct serial8250_device *dev = ioport->priv;
> -	u16 offset;
>  	bool ret = true;
>  
>  	mutex_lock(&dev->mutex);
>  
> -	offset = port - dev->iobase;
> -
>  	switch (offset) {
>  	case UART_RX:
>  		if (dev->lcr & UART_LCR_DLAB)
> @@ -389,6 +382,37 @@ static bool serial8250_in(struct ioport *ioport, struct kvm_cpu *vcpu, u16 port,
>  	return ret;
>  }
>  
> +static void serial8250_mmio(struct kvm_cpu *vcpu, u64 addr, u8 *data, u32 len,
> +			    u8 is_write, void *ptr)
> +{
> +	struct serial8250_device *dev = ptr;
> +
> +	if (is_write)
> +		serial8250_out(dev, vcpu, addr - dev->iobase, data);
> +	else
> +		serial8250_in(dev, vcpu, addr - dev->iobase, data);
> +}
> +
> +static bool serial8250_ioport_out(struct ioport *ioport, struct kvm_cpu *vcpu,
> +				  u16 port, void *data, int size)
> +{
> +	struct serial8250_device *dev = ioport->priv;
> +
> +	serial8250_mmio(vcpu, port, data, 1, true, dev);
> +
> +	return true;
> +}
> +
> +static bool serial8250_ioport_in(struct ioport *ioport, struct kvm_cpu *vcpu,
> +				 u16 port, void *data, int size)
> +{
> +	struct serial8250_device *dev = ioport->priv;
> +
> +	serial8250_mmio(vcpu, port, data, 1, false, dev);
> +
> +	return true;
> +}
> +
>  #ifdef CONFIG_HAS_LIBFDT
>  
>  char *fdt_stdout_path = NULL;
> @@ -427,8 +451,8 @@ void serial8250_generate_fdt_node(void *fdt, struct device_header *dev_hdr,
>  #endif
>  
>  static struct ioport_operations serial8250_ops = {
> -	.io_in			= serial8250_in,
> -	.io_out			= serial8250_out,
> +	.io_in			= serial8250_ioport_in,
> +	.io_out			= serial8250_ioport_out,
>  };
>  
>  static int serial8250__device_init(struct kvm *kvm,
