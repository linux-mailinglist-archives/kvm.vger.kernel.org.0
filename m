Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D70102DBF96
	for <lists+kvm@lfdr.de>; Wed, 16 Dec 2020 12:41:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725790AbgLPLl3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Dec 2020 06:41:29 -0500
Received: from foss.arm.com ([217.140.110.172]:47762 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725550AbgLPLl2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Dec 2020 06:41:28 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7591131B;
        Wed, 16 Dec 2020 03:40:42 -0800 (PST)
Received: from [192.168.0.110] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id BBFBD3F66B;
        Wed, 16 Dec 2020 03:40:41 -0800 (PST)
Subject: Re: [kvm-unit-tests PATCH 08/10] arm/arm64: gic: Split check_acked()
 into two functions
To:     Auger Eric <eric.auger@redhat.com>, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, drjones@redhat.com
Cc:     andre.przywara@arm.com
References: <20201125155113.192079-1-alexandru.elisei@arm.com>
 <20201125155113.192079-9-alexandru.elisei@arm.com>
 <0eb98cb0-835c-e257-484e-8210f1279f2c@redhat.com>
 <2b8d774e-9398-e24b-6989-8643f5dd2492@arm.com>
 <b5ccedb2-5f8d-50d5-8caf-776013613d90@redhat.com>
From:   Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <a01f61cf-d174-87b7-4db1-32b62a2c3e8a@arm.com>
Date:   Wed, 16 Dec 2020 11:40:37 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <b5ccedb2-5f8d-50d5-8caf-776013613d90@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Eric,

On 12/15/20 1:58 PM, Auger Eric wrote:
> Hi Alexandru,
>
> On 12/10/20 3:45 PM, Alexandru Elisei wrote:
>> Hi Eric,
>>
>> On 12/3/20 1:39 PM, Auger Eric wrote:
>>> [..]
>>>  
>>>  static void check_spurious(void)
>>> @@ -300,7 +318,8 @@ static void ipi_test_self(void)
>>>  	cpumask_clear(&mask);
>>>  	cpumask_set_cpu(smp_processor_id(), &mask);
>>>  	gic->ipi.send_self();
>>> -	check_acked("IPI: self", &mask);
>>> +	wait_for_interrupts(&mask);
>>> +	report(check_acked(&mask), "Interrupts received");
>>>  	report_prefix_pop();
>>>  }
>>>  
>>> @@ -315,7 +334,8 @@ static void ipi_test_smp(void)
>>>  	for (i = smp_processor_id() & 1; i < nr_cpus; i += 2)
>>>  		cpumask_clear_cpu(i, &mask);
>>>  	gic_ipi_send_mask(IPI_IRQ, &mask);
>>> -	check_acked("IPI: directed", &mask);
>>> +	wait_for_interrupts(&mask);
>>> +	report(check_acked(&mask), "Interrupts received");
>>> both ipi_test_smp and ipi_test_self are called from the same test so
>>> better to use different error messages like it was done originally.
>> I used the same error message because the tests have a different prefix
>> ("target-list" versus "broadcast"). Do you think there are cases where that's not
>> enough?
> I think in "ipi" test,
> ipi_test -> ipi_send -> ipi_test_self, ipi_test_smp

I'm afraid I don't understand what you are trying to say. This is the log for the
gicv3-ipi test:

$ cat logs/gicv3-ipi.log
timeout -k 1s --foreground 90s /usr/bin/qemu-system-aarch64 -nodefaults -machine
virt,gic-version=host,accel=kvm -cpu host -device virtio-serial-device -device
virtconsole,chardev=ctd -chardev testdev,id=ctd -device pci-testdev -display none
-serial stdio -kernel arm/gic.flat -smp 6 -machine gic-version=3 -append ipi #
-initrd /tmp/tmp.trk6aAcaZx
WARNING: early print support may not work. Found uart at 0x9000000, but early base
is 0x3f8.
PASS: gicv3: ipi: self: Interrupts received
PASS: gicv3: ipi: target-list: Interrupts received
PASS: gicv3: ipi: broadcast: Interrupts received
SUMMARY: 3 tests

The warning is because I forgot to reconfigure the tests with --vmm=qemu.

Would you mind pointing out what you think is ambiguous?

Thanks,

Alex

