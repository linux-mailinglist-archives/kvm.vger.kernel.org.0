Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 793EA331459
	for <lists+kvm@lfdr.de>; Mon,  8 Mar 2021 18:16:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229580AbhCHRPy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Mar 2021 12:15:54 -0500
Received: from foss.arm.com ([217.140.110.172]:41054 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230111AbhCHRPx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Mar 2021 12:15:53 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C3D7BD6E;
        Mon,  8 Mar 2021 09:15:52 -0800 (PST)
Received: from [192.168.0.110] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id BFE243F71B;
        Mon,  8 Mar 2021 09:15:51 -0800 (PST)
Subject: Re: [PATCH kvmtool v2 06/22] hw/i8042: Refactor trap handler
To:     Andre Przywara <andre.przywara@arm.com>,
        Will Deacon <will@kernel.org>,
        Julien Thierry <julien.thierry.kdev@gmail.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        Marc Zyngier <maz@kernel.org>,
        Sami Mujawar <sami.mujawar@arm.com>
References: <20210225005915.26423-1-andre.przywara@arm.com>
 <20210225005915.26423-7-andre.przywara@arm.com>
From:   Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <e31b55d5-d61a-968f-9387-d0c3bbd09e2e@arm.com>
Date:   Mon, 8 Mar 2021 17:16:16 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210225005915.26423-7-andre.przywara@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Andre,

On 2/25/21 12:58 AM, Andre Przywara wrote:
> With the planned retirement of the special ioport emulation code, we
> need to provide an emulation function compatible with the MMIO
> prototype.
>
> Adjust the trap handler to use that new function, and provide shims to
> implement the old ioport interface, for now.
>
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> ---
>  hw/i8042.c | 68 +++++++++++++++++++++++++++---------------------------
>  1 file changed, 34 insertions(+), 34 deletions(-)
>
> diff --git a/hw/i8042.c b/hw/i8042.c
> index 7d1f9772..ab866662 100644
> --- a/hw/i8042.c
> +++ b/hw/i8042.c
> @@ -292,52 +292,52 @@ static void kbd_reset(void)
>  	};
>  }
>  
> -/*
> - * Called when the OS has written to one of the keyboard's ports (0x60 or 0x64)
> - */
> -static bool kbd_in(struct ioport *ioport, struct kvm_cpu *vcpu, u16 port, void *data, int size)
> +static void kbd_io(struct kvm_cpu *vcpu, u64 addr, u8 *data, u32 len,
> +		   u8 is_write, void *ptr)
>  {
> -	switch (port) {
> -	case I8042_COMMAND_REG: {
> -		u8 value = kbd_read_status();
> -		ioport__write8(data, value);
> +	u8 value;
> +
> +	if (is_write)
> +		value = ioport__read8(data);
> +
> +	switch (addr) {
> +	case I8042_COMMAND_REG:
> +		if (is_write)
> +			kbd_write_command(vcpu->kvm, value);
> +		else
> +			value = kbd_read_status();
>  		break;
> -	}
> -	case I8042_DATA_REG: {
> -		u8 value = kbd_read_data();
> -		ioport__write8(data, value);
> +	case I8042_DATA_REG:
> +		if (is_write)
> +			kbd_write_data(value);
> +		else
> +			value = kbd_read_data();
>  		break;
> -	}
> -	case I8042_PORT_B_REG: {
> -		ioport__write8(data, 0x20);
> +	case I8042_PORT_B_REG:
> +		if (!is_write)
> +			value = 0x20;
>  		break;
> -	}
>  	default:
> -		return false;
> +		return;
>  	}
>  
> +	if (!is_write)
> +		ioport__write8(data, value);
> +}
> +
> +/*
> + * Called when the OS has written to one of the keyboard's ports (0x60 or 0x64)
> + */
> +static bool kbd_in(struct ioport *ioport, struct kvm_cpu *vcpu, u16 port, void *data, int size)
> +{
> +	kbd_io(vcpu, port, data, size, 0, NULL);
> +
>  	return true;
>  }
>  
>  static bool kbd_out(struct ioport *ioport, struct kvm_cpu *vcpu, u16 port, void *data, int size)
>  {
> -	switch (port) {
> -	case I8042_COMMAND_REG: {
> -		u8 value = ioport__read8(data);
> -		kbd_write_command(vcpu->kvm, value);
> -		break;
> -	}
> -	case I8042_DATA_REG: {
> -		u8 value = ioport__read8(data);
> -		kbd_write_data(value);
> -		break;
> -	}
> -	case I8042_PORT_B_REG: {
> -		break;
> -	}
> -	default:
> -		return false;
> -	}
> +	kbd_io(vcpu, port, data, size, 1, NULL);

I think I made a mistake when I suggested that is_write should 0 or 1. I followed
the emulation path in kvmtool and it turns out that is_write is supposed to
represent the field with the same name from the anonymous struct mmio from struct
kvm_run (more precisely, the struct defined at line 4980 from
Documentation/virt/kvm/api.rst, Linux tag v5.11). I think the is_write field is
declared in kvm_run as an u8 for compatibility with an userspace which might not
know about the bool type. is_write is also treated as a bool in the MMIO exit path
by KVM (see arch/arm64/kvm/mmio.c::io_mem_abort()).

kvmtool assigns is_write a boolean value everywhere except in this file, would you
mind changing it back to a bool? Sorry for suggesting the wrong thing.

I checked that the code remains functionally identical, with the above change:

Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>

Thanks,

Alex

>  
>  	return true;
>  }
