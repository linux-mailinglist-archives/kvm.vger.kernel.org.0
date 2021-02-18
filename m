Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A345C31E9F4
	for <lists+kvm@lfdr.de>; Thu, 18 Feb 2021 13:47:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233082AbhBRMga (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Feb 2021 07:36:30 -0500
Received: from foss.arm.com ([217.140.110.172]:50414 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232244AbhBRMND (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 Feb 2021 07:13:03 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id F1C961042;
        Thu, 18 Feb 2021 03:17:43 -0800 (PST)
Received: from [192.168.0.110] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0029F3F73D;
        Thu, 18 Feb 2021 03:17:42 -0800 (PST)
Subject: Re: [PATCH kvmtool 06/21] hw/i8042: Refactor trap handler
To:     Andre Przywara <andre.przywara@arm.com>
Cc:     Will Deacon <will@kernel.org>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org, Marc Zyngier <maz@kernel.org>
References: <20201210142908.169597-1-andre.przywara@arm.com>
 <20201210142908.169597-7-andre.przywara@arm.com>
 <288df0e8-997c-7691-2dda-017876dba3f4@arm.com>
 <20210218103425.26a27000@slackpad.fritz.box>
From:   Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <5d2d7233-46f6-3056-e2b2-813a3fc56d88@arm.com>
Date:   Thu, 18 Feb 2021 11:17:58 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210218103425.26a27000@slackpad.fritz.box>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Andre,

On 2/18/21 10:34 AM, Andre Przywara wrote:
> On Thu, 11 Feb 2021 17:23:13 +0000
> Alexandru Elisei <alexandru.elisei@arm.com> wrote:
>
>> Hi Andre,
>>
>> On 12/10/20 2:28 PM, Andre Przywara wrote:
>>> With the planned retirement of the special ioport emulation code, we
>>> need to provide an emulation function compatible with the MMIO
>>> prototype.
>>>
>>> Adjust the trap handler to use that new function, and provide shims to
>>> implement the old ioport interface, for now.
>>>
>>> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
>>> ---
>>>  hw/i8042.c | 68 +++++++++++++++++++++++++++---------------------------
>>>  1 file changed, 34 insertions(+), 34 deletions(-)
>>>
>>> diff --git a/hw/i8042.c b/hw/i8042.c
>>> index 36ee183f..eb1f9d28 100644
>>> --- a/hw/i8042.c
>>> +++ b/hw/i8042.c
>>> @@ -292,52 +292,52 @@ static void kbd_reset(void)
>>>  	};
>>>  }
>>>  
>>> -/*
>>> - * Called when the OS has written to one of the keyboard's ports (0x60 or 0x64)
>>> - */
>>> -static bool kbd_in(struct ioport *ioport, struct kvm_cpu *vcpu, u16 port, void *data, int size)
>>> +static void kbd_io(struct kvm_cpu *vcpu, u64 addr, u8 *data, u32 len,
>>> +		   u8 is_write, void *ptr)
>>>  {
>>> -	switch (port) {
>>> -	case I8042_COMMAND_REG: {
>>> -		u8 value = kbd_read_status();
>>> -		ioport__write8(data, value);
>>> +	u8 value;
>>> +
>>> +	if (is_write)
>>> +		value = ioport__read8(data);
>>> +
>>> +	switch (addr) {
>>> +	case I8042_COMMAND_REG:
>>> +		if (is_write)
>>> +			kbd_write_command(vcpu->kvm, value);
>>> +		else
>>> +			value = kbd_read_status();
>>>  		break;
>>> -	}
>>> -	case I8042_DATA_REG: {
>>> -		u8 value = kbd_read_data();
>>> -		ioport__write8(data, value);
>>> +	case I8042_DATA_REG:
>>> +		if (is_write)
>>> +			kbd_write_data(value);
>>> +		else
>>> +			value = kbd_read_data();
>>>  		break;
>>> -	}
>>> -	case I8042_PORT_B_REG: {
>>> -		ioport__write8(data, 0x20);
>>> +	case I8042_PORT_B_REG:
>>> +		if (!is_write)
>>> +			value = 0x20;
>>>  		break;
>>> -	}
>>>  	default:
>>> -		return false;
>>> +		return;  
>> Any particular reason for removing the false return value? I don't see it
>> mentioned in the commit message. Otherwise this is identical to the two functions
>> it replaces.
> Because the MMIO handler prototype is void, in contrast to the PIO one.
> Since on returning "false" we only seem to panic kvmtool, this is of
> quite limited use, I'd say.

Actually, in ioport.c::kvm__emulate_io(), if kvm->cfg.ioport_debug is true, it
will print an error and then panic in kvm_cpu__start(); otherwise the error is
silently ignored. serial.c is another device where an unknown register returns
false. In rtc.c, the unknown register is ignored. cfi_flash.c prints debugging
information. So I guess kvmtool implements all possible methods of handling an
unknown register *at the same time*, so it's up to you how you want to handle it.

>>>  	}
>>>  
>>> +	if (!is_write)
>>> +		ioport__write8(data, value);
>>> +}
>>> +
>>> +/*
>>> + * Called when the OS has written to one of the keyboard's ports (0x60 or 0x64)
>>> + */
>>> +static bool kbd_in(struct ioport *ioport, struct kvm_cpu *vcpu, u16 port, void *data, int size)
>>> +{
>>> +	kbd_io(vcpu, port, data, size, false, NULL);  
>> is_write is an u8, not a bool.
> Right, will fix this.
>
>> I never could wrap my head around the ioport convention of "in" (read) and "out"
>> (write). To be honest, changing is_write changed to an enum so it's crystal clear
>> what is happening would help with that a lot, but I guess that's a separate patch.
> "in" and "out" are the x86 assembly mnemonics, but it's indeed
> confusing, because the device side has a different view (CPU "in" means
> pushing data "out" of the device). I usually look at the code to see
> what it's actually meant to do.
> So yeah, I feel like a lot of those device emulations could use
> some update. but that's indeed something for another day.

Agreed.

Thanks,

Alex

>
> Cheers,
> Andre
>
>>> +
>>>  	return true;
>>>  }
>>>  
>>>  static bool kbd_out(struct ioport *ioport, struct kvm_cpu *vcpu, u16 port, void *data, int size)
>>>  {
>>> -	switch (port) {
>>> -	case I8042_COMMAND_REG: {
>>> -		u8 value = ioport__read8(data);
>>> -		kbd_write_command(vcpu->kvm, value);
>>> -		break;
>>> -	}
>>> -	case I8042_DATA_REG: {
>>> -		u8 value = ioport__read8(data);
>>> -		kbd_write_data(value);
>>> -		break;
>>> -	}
>>> -	case I8042_PORT_B_REG: {
>>> -		break;
>>> -	}
>>> -	default:
>>> -		return false;
>>> -	}
>>> +	kbd_io(vcpu, port, data, size, true, NULL);
>>>  
>>>  	return true;
>>>  }  
