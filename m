Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 452793829F6
	for <lists+kvm@lfdr.de>; Mon, 17 May 2021 12:38:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236273AbhEQKjX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 May 2021 06:39:23 -0400
Received: from foss.arm.com ([217.140.110.172]:47876 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233962AbhEQKjW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 May 2021 06:39:22 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 522B2106F;
        Mon, 17 May 2021 03:38:06 -0700 (PDT)
Received: from [192.168.0.110] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 908943F719;
        Mon, 17 May 2021 03:38:05 -0700 (PDT)
Subject: Re: [PATCH kvm-unit-tests v3 4/8] arm/arm64: mmu: Stop mapping an
 assumed IO region
To:     Andrew Jones <drjones@redhat.com>
Cc:     kvm@vger.kernel.org, nikos.nikoleris@arm.com,
        andre.przywara@arm.com, eric.auger@redhat.com
References: <20210429164130.405198-1-drjones@redhat.com>
 <20210429164130.405198-5-drjones@redhat.com>
 <94288c5b-8894-5f8b-2477-6e45e087c4b5@arm.com>
 <0ca20ae5-d797-1c9f-9414-1d162d86f1b5@arm.com>
 <20210513171844.n3h3c7l5srhuriyy@gator>
 <20210513174313.j7ff6j5jhzvocnuh@gator>
From:   Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <b3d12a27-efda-86e0-b86c-c23e1371f473@arm.com>
Date:   Mon, 17 May 2021 11:38:46 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210513174313.j7ff6j5jhzvocnuh@gator>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Drew,

On 5/13/21 6:43 PM, Andrew Jones wrote:
> On Thu, May 13, 2021 at 07:18:44PM +0200, Andrew Jones wrote:
>> [..]
>> Thanks Alex,
>>
>> I think a better fix is this untested one below, though. If you can test
>> it out and confirm it also resolves the issue, then I'll add this patch
>> to the series.
>>
>> Thanks,
>> drew
>>
>>
>> diff --git a/arm/micro-bench.c b/arm/micro-bench.c
>> index 95c418c10eb4..deafd5695c33 100644
>> --- a/arm/micro-bench.c
>> +++ b/arm/micro-bench.c
>> @@ -273,16 +273,22 @@ static void hvc_exec(void)
>>         asm volatile("mov w0, #0x4b000000; hvc #0" ::: "w0");
>>  }
>>  
>> -static void mmio_read_user_exec(void)
>> +/*
>> + * FIXME: Read device-id in virtio mmio here in order to
>> + * force an exit to userspace. This address needs to be
>> + * updated in the future if any relevant changes in QEMU
>> + * test-dev are made.
>> + */
>> +static void *userspace_emulated_addr;
>> +
>> +static bool mmio_read_user_prep(void)
>>  {
>> -       /*
>> -        * FIXME: Read device-id in virtio mmio here in order to
>> -        * force an exit to userspace. This address needs to be
>> -        * updated in the future if any relevant changes in QEMU
>> -        * test-dev are made.
>> -        */
>> -       void *userspace_emulated_addr = (void*)0x0a000008;
>> +       userspace_emulated_addr = (void*)ioremap(0x0a000008, 8);
>> +       return true;
>> +}
>>  
>> +static void mmio_read_user_exec(void)
>> +{
>>         readl(userspace_emulated_addr);
>>  }
>>  
>> @@ -309,14 +315,14 @@ struct exit_test {
>>  };
>>  
>>  static struct exit_test tests[] = {
>> -       {"hvc",                 NULL,           hvc_exec,               NULL,           65536,          true},
>> -       {"mmio_read_user",      NULL,           mmio_read_user_exec,    NULL,           65536,          true},
>> -       {"mmio_read_vgic",      NULL,           mmio_read_vgic_exec,    NULL,           65536,          true},
>> -       {"eoi",                 NULL,           eoi_exec,               NULL,           65536,          true},
>> -       {"ipi",                 ipi_prep,       ipi_exec,               NULL,           65536,          true},
>> -       {"ipi_hw",              ipi_hw_prep,    ipi_exec,               NULL,           65536,          true},
>> -       {"lpi",                 lpi_prep,       lpi_exec,               NULL,           65536,          true},
>> -       {"timer_10ms",          timer_prep,     timer_exec,             timer_post,     256,            true},
>> +       {"hvc",                 NULL,                   hvc_exec,               NULL,           65536,          true},
>> +       {"mmio_read_user",      mmio_read_user_prep,    mmio_read_user_exec,    NULL,           65536,          true},
>> +       {"mmio_read_vgic",      NULL,                   mmio_read_vgic_exec,    NULL,           65536,          true},
>> +       {"eoi",                 NULL,                   eoi_exec,               NULL,           65536,          true},
>> +       {"ipi",                 ipi_prep,               ipi_exec,               NULL,           65536,          true},
>> +       {"ipi_hw",              ipi_hw_prep,            ipi_exec,               NULL,           65536,          true},
>> +       {"lpi",                 lpi_prep,               lpi_exec,               NULL,           65536,          true},
>> +       {"timer_10ms",          timer_prep,             timer_exec,             timer_post,     256,            true},
>>  };
>>  
>>  struct ns_time {
>>
> I still haven't tested it (beyond compiling), but I've tweaked this a bit.
> You can see it here
>
> https://gitlab.com/rhdrjones/kvm-unit-tests/-/commit/71938030d160e021db3388037d0d407df17e8e5e
>
> The whole v4 of this series is here
>
> https://gitlab.com/rhdrjones/kvm-unit-tests/-/commits/efiprep

Had a look at the patch, looks good; in my suggestion I wrongly thought that readl
reads a long (64 bits), not an uint32_t value:

Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>

I also ran some tests on the v4 series from your repo.

Qemu TCG on x86 machine:
    - arm compiled with arm-linux-gnu-gcc and arm-none-eabi-gcc
    - arm64, 4k and 64k pages.

Odroid-c4:
    - arm, both compilers, under kvmtool
    - arm64, 4k, 16k and 64k pages under qemu KVM and kvmtool

Rockpro64:
    - arm, both compilers, under kvmtool
    - arm64, 4k and 64k pages, under qemu KVM and kvmtool.

The ITS migration tests I had to run manually on the rockpro64 (Odroid has a
gicv2) because it looks like the run script wasn't detecting the prompt to start
migration. I'm guessing something on my side, because I had issues with the
migration tests before. Nonetheless, those tests ran just fine manually under qemu
and kvmtool, so everything looks correct to me:

Tested-by: Alexandru Elisei <alexandru.elisei@arm.com>

Thanks,

Alex

