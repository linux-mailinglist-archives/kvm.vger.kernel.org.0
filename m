Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 017BF33C24A
	for <lists+kvm@lfdr.de>; Mon, 15 Mar 2021 17:39:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232640AbhCOQi6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Mar 2021 12:38:58 -0400
Received: from foss.arm.com ([217.140.110.172]:54506 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234581AbhCOQil (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Mar 2021 12:38:41 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 44B201FB;
        Mon, 15 Mar 2021 09:38:41 -0700 (PDT)
Received: from [192.168.0.110] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 831E93F718;
        Mon, 15 Mar 2021 09:38:40 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH] configure: arm/arm64: Add --earlycon
 option to set UART type and address
To:     Andre Przywara <andre.przywara@arm.com>
Cc:     drjones@redhat.com, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, pbonzini@redhat.com
References: <20210219163718.109101-1-alexandru.elisei@arm.com>
 <20210303141846.0bcc0d2c@slackpad.fritz.box>
From:   Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <2b6a2ee0-d8de-e408-ad9b-116c4e574174@arm.com>
Date:   Mon, 15 Mar 2021 16:38:37 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210303141846.0bcc0d2c@slackpad.fritz.box>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Andre,

On 3/3/21 2:18 PM, Andre Przywara wrote:
> On Fri, 19 Feb 2021 16:37:18 +0000
> Alexandru Elisei <alexandru.elisei@arm.com> wrote:
>
>> Currently, the UART early address is set indirectly with the --vmm option
>> and there are only two possible values: if the VMM is qemu (the default),
>> then the UART address is set to 0x09000000; if the VMM is kvmtool, then the
>> UART address is set to 0x3f8.
>>
>> There several efforts under way to change the kvmtool UART address, and
>> kvm-unit-tests so far hasn't had mechanism to let the user set a specific
>> address, which means that the early UART won't be available.
>>
>> This situation will only become worse as kvm-unit-tests gains support to
>> run as an EFI app, as each platform will have their own UART type and
>> address.
>>
>> To address both issues, a new configure option is added, --earlycon. The
>> syntax and semantics are identical to the kernel parameter with the same
>> name.
> Nice one! I like that reusing of an existing scheme.
>
>> Specifying this option will overwrite the UART address set by --vmm.
>>
>> At the moment, the UART type and register width parameters are ignored
>> since both qemu's and kvmtool's UART emulation use the same offset for the
>> TX register and no other registers are used by kvm-unit-tests, but the
>> parameters will become relevant once EFI support is added.
>>
>> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
>> ---
>> The kvmtool patches I was referring to are the patches to unify ioport and
>> MMIO emulation [1] and to allow the user to specify a custom memory layout
>> for the VM [2] (these patches are very old, but I plan to revive them after
>> the ioport and MMIO unification series are merged).
>>
>> [1] https://lore.kernel.org/kvm/20201210142908.169597-1-andre.przywara@arm.com/T/#t
>> [2] https://lore.kernel.org/kvm/1569245722-23375-1-git-send-email-alexandru.elisei@arm.com/
>>
>>  configure | 35 +++++++++++++++++++++++++++++++++++
>>  1 file changed, 35 insertions(+)
>>
>> diff --git a/configure b/configure
>> index cdcd34e94030..d94b92255088 100755
>> --- a/configure
>> +++ b/configure
>> @@ -26,6 +26,7 @@ errata_force=0
>>  erratatxt="$srcdir/errata.txt"
>>  host_key_document=
>>  page_size=
>> +earlycon=
>>  
>>  usage() {
>>      cat <<-EOF
>> @@ -54,6 +55,17 @@ usage() {
>>  	    --page-size=PAGE_SIZE
>>  	                           Specify the page size (translation granule) (4k, 16k or
>>  	                           64k, default is 64k, arm64 only)
>> +	    --earlycon=EARLYCON
>> +	                           Specify the UART name, type and address (optional, arm and
>> +	                           arm64 only). The specified address will overwrite the UART
>> +	                           address set by the --vmm option. EARLYCON can be on of (case
>> +	                           sensitive):
>> +	               uart[8250],mmio,ADDR
>> +	                           Specify an 8250 compatible UART at address ADDR. Supported
>> +	                           register stride is 8 bit only.
>> +	               pl011,mmio,ADDR
>> +	                           Specify a PL011 compatible UART at address ADDR. Supported
>> +	                           register stride is 8 bit only.
> I think the PL011 only ever specified 32-bit register accesses? I just

You are correct, according to Arm Base System Architecture 1.0 (DEN0094A), page 43:

"The registers that are described in this specification are a subset of the Arm
PL011 r1p5 UART. [..] The Generic UART is specified as a set of 32-bit registers.
[..] The Generic UART is little-endian."

> see that we actually do a writeb() for puts, that is not guaranteed to
> work on a hardware PL011, AFAIK. I guess QEMU just doesn't care ...

Table 19, page 43 of DEN0094A, says that permitted accesses sizes for the UARTDR
register are 8, 16 and 32 bits. I think using writeb() at address 0 of the UART
memory region to write a character is correct.

> Looks like we should fix this, maybe we get mmio32 for uart8250 for
> free, then.
>
> The kernel specifies "pl011,mmio32,ADDR" or "pl011,ADDR", so I think we
> should keep it compatible. "mmio[32]" is pretty much redundant on the
> PL011 (no port I/O), I think it's just for consistency with the 8250.
> Can you tweak the routine below to make this optional, and also accept
> mmio32?

Definitely, my intention was to make it as close as possible to what Linux does. I
made a mistake when I allowed this value, I will change it in the next version.

Thanks,

Alex

>
> Cheers,
> Andre
>
>>  EOF
>>      exit 1
>>  }
>> @@ -112,6 +124,9 @@ while [[ "$1" = -* ]]; do
>>  	--page-size)
>>  	    page_size="$arg"
>>  	    ;;
>> +	--earlycon)
>> +	    earlycon="$arg"
>> +	    ;;
>>  	--help)
>>  	    usage
>>  	    ;;
>> @@ -170,6 +185,26 @@ elif [ "$arch" = "arm" ] || [ "$arch" = "arm64" ]; then
>>          echo '--vmm must be one of "qemu" or "kvmtool"!'
>>          usage
>>      fi
>> +
>> +    if [ "$earlycon" ]; then
>> +        name=$(echo $earlycon|cut -d',' -f1)
>> +        if [ "$name" != "uart" ] && [ "$name" != "uart8250" ] &&
>> +                [ "$name" != "pl011" ]; then
>> +            echo "unknown earlycon name: $name"
>> +            usage
>> +        fi
>> +        type=$(echo $earlycon|cut -d',' -f2)
>> +        if [ "$type" != "mmio" ]; then
>> +            echo "unknown earlycon type: $type"
>> +            usage
>> +        fi
>> +        addr=$(echo $earlycon|cut -d',' -f3)
>> +        if [ -z "$addr" ]; then
>> +            echo "missing earlycon address"
>> +            usage
>> +        fi
>> +        arm_uart_early_addr=$addr
>> +    fi
>>  elif [ "$arch" = "ppc64" ]; then
>>      testdir=powerpc
>>      firmware="$testdir/boot_rom.bin"
