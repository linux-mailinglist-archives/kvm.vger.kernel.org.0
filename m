Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 674A6401A54
	for <lists+kvm@lfdr.de>; Mon,  6 Sep 2021 13:05:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238573AbhIFLFz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Sep 2021 07:05:55 -0400
Received: from foss.arm.com ([217.140.110.172]:54940 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231511AbhIFLFy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Sep 2021 07:05:54 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D513B6D;
        Mon,  6 Sep 2021 04:04:49 -0700 (PDT)
Received: from [192.168.0.110] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 78E2E3F73D;
        Mon,  6 Sep 2021 04:04:47 -0700 (PDT)
Subject: Re: [kvm-unit-tests RFC PATCH 1/5] lib: arm: Print test exit status
 on exit if chr-testdev is not available
To:     Andrew Jones <drjones@redhat.com>
Cc:     thuth@redhat.com, pbonzini@redhat.com, lvivier@redhat.com,
        kvm-ppc@vger.kernel.org, david@redhat.com, frankja@linux.ibm.com,
        cohuck@redhat.com, imbrenda@linux.ibm.com,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, andre.przywara@arm.com,
        maz@kernel.org, vivek.gautam@arm.com
References: <20210702163122.96110-1-alexandru.elisei@arm.com>
 <20210702163122.96110-2-alexandru.elisei@arm.com>
 <20210712163647.oxntpjapur4z23sl@gator>
 <7814beab-547e-98d9-9aa0-3b7e5afd803b@arm.com>
 <20210906105827.wneqtlrsgbz3pxk5@gator.home>
From:   Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <8a851ff0-a112-19ff-8f4c-9f6bed0cb4d9@arm.com>
Date:   Mon, 6 Sep 2021 12:06:10 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210906105827.wneqtlrsgbz3pxk5@gator.home>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Drew,

On 9/6/21 11:58 AM, Andrew Jones wrote:
> On Mon, Sep 06, 2021 at 11:20:31AM +0100, Alexandru Elisei wrote:
>> Hi Drew,
>>
>> Sorry for taking so long to reply, been busy with other things.
>>
>> On 7/12/21 5:36 PM, Andrew Jones wrote:
>>> On Fri, Jul 02, 2021 at 05:31:18PM +0100, Alexandru Elisei wrote:
>>>> The arm64 tests can be run under kvmtool, which doesn't emulate a
>>>> chr-testdev device. In preparation for adding run script support for
>>>> kvmtool, print the test exit status so the scripts can pick it up and
>>>> correctly mark the test as pass or fail.
>>>>
>>>> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
>>>> ---
>>>>  lib/chr-testdev.h |  1 +
>>>>  lib/arm/io.c      | 10 +++++++++-
>>>>  lib/chr-testdev.c |  5 +++++
>>>>  3 files changed, 15 insertions(+), 1 deletion(-)
>>>>
>>>> diff --git a/lib/chr-testdev.h b/lib/chr-testdev.h
>>>> index ffd9a851aa9b..09b4b424670e 100644
>>>> --- a/lib/chr-testdev.h
>>>> +++ b/lib/chr-testdev.h
>>>> @@ -11,4 +11,5 @@
>>>>   */
>>>>  extern void chr_testdev_init(void);
>>>>  extern void chr_testdev_exit(int code);
>>>> +extern bool chr_testdev_available(void);
>>>>  #endif
>>>> diff --git a/lib/arm/io.c b/lib/arm/io.c
>>>> index 343e10822263..9e62b571a91b 100644
>>>> --- a/lib/arm/io.c
>>>> +++ b/lib/arm/io.c
>>>> @@ -125,7 +125,15 @@ extern void halt(int code);
>>>>  
>>>>  void exit(int code)
>>>>  {
>>>> -	chr_testdev_exit(code);
>>>> +	if (chr_testdev_available()) {
>>>> +		chr_testdev_exit(code);
>>> chr_testdev_exit() already has a 'if !vcon goto out' in it, so you can
>>> just call it unconditionally. No need for chr_testdev_available().
>> I'm not sure what you mean. There has to be a way to check if chr-testdev is
>> available, and if it's not present on the system, to print the EXIT: STATUS
>> message, and vcon is static in chr-testdev.c.
>>
>> Are you suggesting that we move the message to chr_testdev_exit(code)?
> I'm saying you can unconditionally call chr_testdev_exit(), because it
> only conditionally does anything, and on the same condition that you're
> adding (vcon != NULL). 
>
> $ /usr/bin/qemu-system-aarch64 -nodefaults -machine virt,accel=tcg -cpu cortex-a57 -device virtio-serial-device -device virtconsole,chardev=ctd -chardev testdev,id=ctd -device pci-testdev -display none -serial stdio -kernel arm/selftest.flat
> ABORT: selftest: no test specified
> SUMMARY: 0 tests
> $ echo $?
> 127
> $ /usr/bin/qemu-system-aarch64 -nodefaults -machine virt,accel=tcg -cpu cortex-a57 -display none -serial stdio -kernel arm/selftest.flat
> ABORT: selftest: no test specified
> SUMMARY: 0 tests
> $ echo $?
> 0
>
> See, no explosions when the device is removed. Just a lack of return code.

Yup, this makes sense, this is exactly what happens today with kvmtool.

>
> Also, since chr_testdev_exit() exits, any calls after it won't happen. So
> the exit print statement doesn't need to be in an else clause. That said,
> I think the print statement should come first in order to also put it in
> the qemu output logs. We might as well have consistent output between qemu
> and kvmtool.

Makes sense, I'll move the printf before chr_testdev_exit(). Thanks for the quick
reply!

Thanks,

Alex

>
> Thanks,
> drew
>
>
>> Thanks,
>>
>> Alex
>>
>>>> +	} else {
>>>> +		/*
>>>> +		 * Print the test return code in the format used by chr-testdev
>>>> +		 * so the runner script can parse it.
>>>> +		 */
>>>> +		printf("\nEXIT: STATUS=%d\n", ((code) << 1) | 1);
>>>> +	}
>>>>  	psci_system_off();
>>>>  	halt(code);
>>>>  	__builtin_unreachable();
>>>> diff --git a/lib/chr-testdev.c b/lib/chr-testdev.c
>>>> index b3c641a833fe..301e73a6c064 100644
>>>> --- a/lib/chr-testdev.c
>>>> +++ b/lib/chr-testdev.c
>>>> @@ -68,3 +68,8 @@ void chr_testdev_init(void)
>>>>  	in_vq = vqs[0];
>>>>  	out_vq = vqs[1];
>>>>  }
>>>> +
>>>> +bool chr_testdev_available(void)
>>>> +{
>>>> +	return vcon != NULL;
>>>> +}
>>>> -- 
>>>> 2.32.0
>>>>
>>> Thanks,
>>> drew 
>>>
