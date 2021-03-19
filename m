Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 259D3341B99
	for <lists+kvm@lfdr.de>; Fri, 19 Mar 2021 12:38:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229805AbhCSLh2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Mar 2021 07:37:28 -0400
Received: from foss.arm.com ([217.140.110.172]:47514 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229807AbhCSLh1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Mar 2021 07:37:27 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9F95FED1;
        Fri, 19 Mar 2021 04:37:26 -0700 (PDT)
Received: from [192.168.0.110] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 06C203F70D;
        Fri, 19 Mar 2021 04:37:25 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH v2] configure: arm/arm64: Add --earlycon
 option to set UART type and address
To:     Andrew Jones <drjones@redhat.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        pbonzini@redhat.com
References: <20210318162022.84482-1-alexandru.elisei@arm.com>
 <20210318164157.xervbl23zvqmqdli@kamzik.brq.redhat.com>
From:   Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <d8403f28-c47c-d8eb-4131-c13a1fdd9a73@arm.com>
Date:   Fri, 19 Mar 2021 11:37:51 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210318164157.xervbl23zvqmqdli@kamzik.brq.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Drew,

Thanks for having another look!

On 3/18/21 4:41 PM, Andrew Jones wrote:
> On Thu, Mar 18, 2021 at 04:20:22PM +0000, Alexandru Elisei wrote:
>> Currently, the UART early address is set indirectly with the --vmm option
>> and there are only two possible values: if the VMM is qemu (the default),
>> then the UART address is set to 0x09000000; if the VMM is kvmtool, then the
>> UART address is set to 0x3f8.
>>
>> The upstream kvmtool commit 45b4968e0de1 ("hw/serial: ARM/arm64: Use MMIO
>> at higher addresses") changed the UART address to 0x1000000, and
>> kvm-unit-tests so far hasn't had mechanism to let the user set a specific
>> address, which means that for recent versions of kvmtool the early UART
>> won't be available.
>>
>> This situation will only become worse as kvm-unit-tests gains support to
>> run as an EFI app, as each platform will have their own UART type and
>> address.
>>
>> To address both issues, a new configure option is added, --earlycon. The
>> syntax and semantics are identical to the kernel parameter with the same
>> name. For example, for kvmtool, --earlycon=uart,mmio,0x1000000 will set the
>> correct UART address. Specifying this option will overwrite the UART
>> address set by --vmm.
>>
>> At the moment, the UART type and register width parameters are ignored
>> since both qemu's and kvmtool's UART emulation use the same offset for the
>> TX register and no other registers are used by kvm-unit-tests, but the
>> parameters will become relevant once EFI support is added.
>>
>> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
>> ---
>> Besides working with current versions of kvmtool, this will also make early
>> console work if the user specifies a custom memory layout [1] (patches are
>> old, but I plan to pick them up at some point in the future).
>>
>> Changes in v2:
>> * kvmtool patches were merged, so I reworked the commit message to point to
>>   the corresponding kvmtool commit.
>> * Restricted pl011 register size to 32 bits, as per Arm Base System
>>   Architecture 1.0 (DEN0094A), and to match Linux.
>> * Reworked the way the fields are extracted to make it more precise
>>   (without the -s argument, the entire string is echo'ed when no delimiter
>>   is found).
> You can also drop 'cut' and just do something like
>
> IFS=, read -r name type_addr addr <<<"$earlycon"

That looks much nicer and concise, and I prefer it to my approach.

However, I believe it requires a certain version of bash to work. On bash 5.1.4
and 4.3.48 (copyright says it's from 2013), it works as expected. On bash 3.2.57
(version used by MacOS), the result of the command is that the variable name
contains the string with the comma replaced by space, and the other variables are
empty. Using cut works with this version. According to the copyright notice, bash
3.2.57 is from 2007, so extremely old.

Did some googling for the query "bash split string" and according to this stack
overflow question [1] (second reply), using IFS works for bash >= 4.2. Don't know
how accurate it is.

I guess the question here is how compatible we want to be with regard to the bash
version. I am not familiar with bash programming, so I will defer to your decision.

[1]
https://stackoverflow.com/questions/918886/how-do-i-split-a-string-on-a-delimiter-in-bash

>
>> * The changes are not trivial, so I dropped Drew's Reviewed-by.
>>
>> [1] https://lore.kernel.org/kvm/1569245722-23375-1-git-send-email-alexandru.elisei@arm.com/
>>
>>  configure | 61 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
>>  1 file changed, 61 insertions(+)
>>
>> diff --git a/configure b/configure
>> index cdcd34e94030..137b165db18f 100755
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
>> @@ -54,6 +55,18 @@ usage() {
>>  	    --page-size=PAGE_SIZE
>>  	                           Specify the page size (translation granule) (4k, 16k or
>>  	                           64k, default is 64k, arm64 only)
>> +	    --earlycon=EARLYCON
>> +	                           Specify the UART name, type and address (optional, arm and
>> +	                           arm64 only). The specified address will overwrite the UART
>> +	                           address set by the --vmm option. EARLYCON can be on of (case
> 'on of' typo still here

Sorry, I missed that in your previous comment.

>
>> +	                           sensitive):
>> +	               uart[8250],mmio,ADDR
>> +	                           Specify an 8250 compatible UART at address ADDR. Supported
>> +	                           register stride is 8 bit only.
>> +	               pl011,ADDR
>> +	               pl011,mmio32,ADDR
>> +	                           Specify a PL011 compatible UART at address ADDR. Supported
>> +	                           register stride is 32 bit only.
>>  EOF
>>      exit 1
>>  }
>> @@ -112,6 +125,9 @@ while [[ "$1" = -* ]]; do
>>  	--page-size)
>>  	    page_size="$arg"
>>  	    ;;
>> +	--earlycon)
>> +	    earlycon="$arg"
>> +	    ;;
>>  	--help)
>>  	    usage
>>  	    ;;
>> @@ -170,6 +186,51 @@ elif [ "$arch" = "arm" ] || [ "$arch" = "arm64" ]; then
>>          echo '--vmm must be one of "qemu" or "kvmtool"!'
>>          usage
>>      fi
>> +
>> +    if [ "$earlycon" ]; then
>> +        # Append delimiter and use cut -s to prevent cut from ignoring the field
>> +        # argument if no delimiter is specified by the user.
>> +        earlycon="$earlycon,"
>> +        name=$(echo $earlycon|cut -sd',' -f1)
>> +        if [ "$name" != "uart" ] && [ "$name" != "uart8250" ] &&
>> +                [ "$name" != "pl011" ]; then
>> +            echo "unknown earlycon name: $name"
>> +            usage
>> +        fi
>> +
>> +        if [ "$name" = "pl011" ]; then
>> +            type_addr=$(echo $earlycon|cut -sd',' -f2)
>> +            if [ -z "$type_addr" ]; then
>> +                echo "missing earlycon address"
>> +                usage
>> +            fi
>> +            addr=$(echo $earlycon|cut -sd',' -f3)
>> +            if [ -z "$addr" ]; then
> Don't you need
>
>   if [ "$type_addr" = "mmio32" ]; then
>      echo "missing earlycon address"
>      usage
>   fi
>
> here to avoid accepting
>
>   pl011,mmio32
>
> and then assigning mmio32 to the address?

That's a good idea.

>
> And/or should we do a quick sanity check on the address?
> Something like
>
>   [[ $addr =~ ^0?x?[0-9a-f]+$ ]]

Another great suggestion. The pattern above doesn't take into account character
case and the fact that 0xa is a valid number, but a is not. Best I could come up
with is:

[[ $addr =~ ^0(x|X)[0-9a-fA-F]+$ ]] || [[ $addr =~ ^[0-9]+$ ]]

What do you think?

Thanks,

Alex

>
>
>> +                addr=$type_addr
>> +            else
>> +                if [ "$type_addr" != "mmio32" ]; then
>> +                    echo "unknown $name earlycon type: $type_addr"
>> +                    usage
>> +                fi
>> +            fi
>> +        else
>> +            type=$(echo $earlycon|cut -sd',' -f2)
>> +            if [ -z "$type" ]; then
>> +                echo "missing $name earlycon type"
>> +                usage
>> +            fi
>> +            if [ "$type" != "mmio" ]; then
>> +                echo "unknown $name earlycon type: $type"
>> +                usage
>> +            fi
>> +            addr=$(echo $earlycon|cut -sd',' -f3)
>> +            if [ -z "$addr" ]; then
>> +                echo "missing earlycon address"
>> +                usage
>> +            fi
>> +        fi
>> +        arm_uart_early_addr=$addr
>> +    fi
>>  elif [ "$arch" = "ppc64" ]; then
>>      testdir=powerpc
>>      firmware="$testdir/boot_rom.bin"
>> -- 
>> 2.30.2
>>
> Thanks,
> drew
>
