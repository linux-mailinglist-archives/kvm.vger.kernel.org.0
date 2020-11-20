Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CC3D2BAB28
	for <lists+kvm@lfdr.de>; Fri, 20 Nov 2020 14:33:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727980AbgKTNdI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Nov 2020 08:33:08 -0500
Received: from foss.arm.com ([217.140.110.172]:49406 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727083AbgKTNdI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Nov 2020 08:33:08 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8990C11D4;
        Fri, 20 Nov 2020 05:33:07 -0800 (PST)
Received: from [192.168.0.110] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id EC8423F718;
        Fri, 20 Nov 2020 05:33:06 -0800 (PST)
Subject: Re: [kvm-unit-tests] its-migration segmentation fault
To:     Andrew Jones <drjones@redhat.com>
Cc:     kvm@vger.kernel.org,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        Auger Eric <eric.auger@redhat.com>
References: <d18ab1d5-4eff-43e1-4a5b-5373b67e4286@arm.com>
 <20201120123414.bolwl6pym4iy3m6x@kamzik.brq.redhat.com>
From:   Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <1dd15f28-2201-7061-7227-52f0eea9715f@arm.com>
Date:   Fri, 20 Nov 2020 13:34:26 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.3
MIME-Version: 1.0
In-Reply-To: <20201120123414.bolwl6pym4iy3m6x@kamzik.brq.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On 11/20/20 12:34 PM, Andrew Jones wrote:
> On Fri, Nov 20, 2020 at 12:02:10PM +0000, Alexandru Elisei wrote:
>> When running all the tests with taskset -c 0-3 ./run_tests.sh on a rockpro64 (on
>> the Cortex-a53 cores) the its-migration test hangs.[..]
> Is your ncat segfaulting? It looks like it from this output. Have you
> tried running your ncat with a UNIX socket independently of this test?
>
> Is this the first time you've tried this test in this environment, or
> is this a regression for you?

Looks like it's a regression in nmap. I downgraded to nmap 7.80 and the test
passes, thank you for the help!

>
>> If I run the test manually:
>>
>> $ taskset -c 0-3 ./arm-run arm/gic.flat -smp 4 -machine gic-version=3 -append
>> 'its-migration'
> This won't work because we need run_tests.sh to setup the run_migration()
> call. The only ways to run migration tests separately are
>
>  $ ./run_tests.sh its-migration
>
> and
>
>  $ tests/its-migration
>
> For the second one you need to do 'make standalone' first.
>
>
>> /usr/bin/qemu-system-aarch64 -nodefaults -machine virt,gic-version=host,accel=kvm
>> -cpu host -device virtio-serial-device -device virtconsole,chardev=ctd -chardev
>> testdev,id=ctd -device pci-testdev -display none -serial stdio -kernel
>> arm/gic.flat -smp 4 -machine gic-version=3 -append its-migration # -initrd
>> /tmp/tmp.OtsTj3QD4J
>> ITS: MAPD devid=2 size = 0x8 itt=0x403a0000 valid=1
>> ITS: MAPD devid=7 size = 0x8 itt=0x403b0000 valid=1
>> MAPC col_id=3 target_addr = 0x30000 valid=1
>> MAPC col_id=2 target_addr = 0x20000 valid=1
>> INVALL col_id=2
>> INVALL col_id=3
>> MAPTI dev_id=2 event_id=20 -> phys_id=8195, col_id=3
>> MAPTI dev_id=7 event_id=255 -> phys_id=8196, col_id=2
>> Now migrate the VM, then press a key to continue...
>>
>> And the test hangs here after I press a key.
> The test doesn't get your input because of the '</dev/null' in run_qemu(),
> which ./arm-run calls. So it's not hanging it's just waiting forever on
> the key press.

I see, thanks for the explanation!

Thanks,
Alex
