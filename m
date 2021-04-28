Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E35136D9BF
	for <lists+kvm@lfdr.de>; Wed, 28 Apr 2021 16:43:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235147AbhD1Ooa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Apr 2021 10:44:30 -0400
Received: from foss.arm.com ([217.140.110.172]:44292 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229794AbhD1Ooa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Apr 2021 10:44:30 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7247EED1;
        Wed, 28 Apr 2021 07:43:44 -0700 (PDT)
Received: from [192.168.0.110] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id CF0D03F694;
        Wed, 28 Apr 2021 07:43:43 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH v2] configure: arm: Replace --vmm with
 --target
To:     Andrew Jones <drjones@redhat.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        pbonzini@redhat.com
References: <20210427163437.243839-1-alexandru.elisei@arm.com>
 <20210427171011.ymu7j5sen76c4xb3@gator.home>
From:   Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <c10442e1-f7e1-e777-c33e-d103276febf8@arm.com>
Date:   Wed, 28 Apr 2021 15:44:18 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <20210427171011.ymu7j5sen76c4xb3@gator.home>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Drew,

On 4/27/21 6:10 PM, Andrew Jones wrote:
> On Tue, Apr 27, 2021 at 05:34:37PM +0100, Alexandru Elisei wrote:
>> The --vmm configure option was added to distinguish between the two virtual
>> machine managers that kvm-unit-tests supports, qemu or kvmtool. There are
>> plans to make kvm-unit-tests work as an EFI app, which will require changes
>> to the way tests are compiled. Instead of adding a new configure option
>> specifically for EFI and have it coexist with --vmm, or overloading the
>> semantics of the existing --vmm option, let's replace --vmm with the more
>> generic name --target.
>>
>> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
>> ---
>> Changes in v2:
>>
>> * Removed the RFC tag and cover letter.
>> * Removed --vmm entirely.
>>
>>  configure | 19 ++++++++++---------
>>  1 file changed, 10 insertions(+), 9 deletions(-)
>>
>> diff --git a/configure b/configure
>> index 01a0b262a9f2..08c6afdf952c 100755
>> --- a/configure
>> +++ b/configure
>> @@ -21,7 +21,7 @@ pretty_print_stacks=yes
>>  environ_default=yes
>>  u32_long=
>>  wa_divide=
>> -vmm="qemu"
>> +target="qemu"
>>  errata_force=0
>>  erratatxt="$srcdir/errata.txt"
>>  host_key_document=
>> @@ -35,8 +35,8 @@ usage() {
>>  	Options include:
>>  	    --arch=ARCH            architecture to compile for ($arch)
>>  	    --processor=PROCESSOR  processor to compile for ($arch)
>> -	    --vmm=VMM              virtual machine monitor to compile for (qemu
>> -	                           or kvmtool, default is qemu) (arm/arm64 only)
>> +	    --target=TARGET        target platform that the tests will be running on (qemu or
>> +	                           kvmtool, default is qemu) (arm/arm64 only)
>>  	    --cross-prefix=PREFIX  cross compiler prefix
>>  	    --cc=CC		   c compiler to use ($cc)
>>  	    --ld=LD		   ld linker to use ($ld)
>> @@ -58,7 +58,7 @@ usage() {
>>  	    --earlycon=EARLYCON
>>  	                           Specify the UART name, type and address (optional, arm and
>>  	                           arm64 only). The specified address will overwrite the UART
>> -	                           address set by the --vmm option. EARLYCON can be one of
>> +	                           address set by the --target option. EARLYCON can be one of
>>  	                           (case sensitive):
>>  	               uart[8250],mmio,ADDR
>>  	                           Specify an 8250 compatible UART at address ADDR. Supported
>> @@ -88,8 +88,8 @@ while [[ "$1" = -* ]]; do
>>          --processor)
>>  	    processor="$arg"
>>  	    ;;
>> -	--vmm)
>> -	    vmm="$arg"
>> +	--target)
>> +	    target="$arg"
>>  	    ;;
>>  	--cross-prefix)
>>  	    cross_prefix="$arg"
>> @@ -177,13 +177,13 @@ if [ "$arch" = "i386" ] || [ "$arch" = "x86_64" ]; then
>>      testdir=x86
>>  elif [ "$arch" = "arm" ] || [ "$arch" = "arm64" ]; then
>>      testdir=arm
>> -    if [ "$vmm" = "qemu" ]; then
>> +    if [ "$target" = "qemu" ]; then
>>          arm_uart_early_addr=0x09000000
>> -    elif [ "$vmm" = "kvmtool" ]; then
>> +    elif [ "$target" = "kvmtool" ]; then
>>          arm_uart_early_addr=0x3f8
>>          errata_force=1
>>      else
>> -        echo '--vmm must be one of "qemu" or "kvmtool"!'
>> +        echo '--target must be one of "qemu" or "kvmtool"!'
>>          usage
>>      fi
>>  
>> @@ -317,6 +317,7 @@ U32_LONG_FMT=$u32_long
>>  WA_DIVIDE=$wa_divide
>>  GENPROTIMG=${GENPROTIMG-genprotimg}
>>  HOST_KEY_DOCUMENT=$host_key_document
>> +TARGET=$target
> We should only emit this TARGET=qemu to the config.mak when we're
> arm/arm64, since that's what the help text says. Also, because the help
> text says that the --target option is only for arm/arm64, then configure
> should error out if it's used with another architecture. The nice thing
> about this rename is that we can get that right this time. We didn't error
> out with --vmm, but we should have. Erroring out on an unsupported
> feature allows us to add support for it later without the users having
> to guess if it'll work or not.

You're right, I'll fix it for v3.

Thanks,

Alex
