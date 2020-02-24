Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED88916A78D
	for <lists+kvm@lfdr.de>; Mon, 24 Feb 2020 14:47:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727440AbgBXNrr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Feb 2020 08:47:47 -0500
Received: from foss.arm.com ([217.140.110.172]:37318 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725535AbgBXNrr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Feb 2020 08:47:47 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A301731B;
        Mon, 24 Feb 2020 05:47:46 -0800 (PST)
Received: from [10.1.196.63] (e123195-lin.cambridge.arm.com [10.1.196.63])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 46C853F534;
        Mon, 24 Feb 2020 05:47:45 -0800 (PST)
Subject: Re: kvm-unit-tests : Kconfigs and extra kernel args for full coverage
To:     Andrew Jones <drjones@redhat.com>
Cc:     Naresh Kamboju <naresh.kamboju@linaro.org>,
        kvm list <kvm@vger.kernel.org>, lkft-triage@lists.linaro.org,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>, yzt356@gmail.com,
        jmattson@google.com, Paolo Bonzini <pbonzini@redhat.com>,
        namit@vmware.com, sean.j.christopherson@intel.com,
        Basil Eljuse <Basil.Eljuse@arm.com>
References: <CA+G9fYvx=WzyJqS4fUFLq8qXT8nbFQoFfXZoeL9kP-hvv549EA@mail.gmail.com>
 <c82f4386-702f-a2e9-a4d7-d5ebb1f335d1@arm.com>
 <20200224133818.gtxtrmzo4y4guk4z@kamzik.brq.redhat.com>
From:   Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <adf05c0d-6a19-da06-5e41-da63b0d0d8d8@arm.com>
Date:   Mon, 24 Feb 2020 13:47:44 +0000
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20200224133818.gtxtrmzo4y4guk4z@kamzik.brq.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On 2/24/20 1:38 PM, Andrew Jones wrote:
> On Mon, Feb 24, 2020 at 01:21:23PM +0000, Alexandru Elisei wrote:
>> Hi Naresh,
>>
>> On 2/24/20 12:53 PM, Naresh Kamboju wrote:
>>> [Sorry for the spam]
>>>
>>> Greeting from Linaro !
>>> We are running kvm-unit-tests on our CI Continuous Integration and
>>> testing on x86_64 and arm64 Juno-r2.
>>> Linux stable branches and Linux mainline and Linux next.
>>>
>>> Few tests getting fail and skipped, we are interested in increasing the
>>> test coverage by adding required kernel config fragments,
>>> kernel command line arguments and user space tools.
>>>
>>> Your help is much appreciated.
>>>
>>> Here is the details of the LKFT kvm unit test logs,
>>>
>>> [..]
>> I am going to comment on the arm64 tests. As far as I am aware, you don't need any
>> kernel configs to run the tests.
>>
>> From looking at the java log [1], I can point out a few things:
>>
>> - The gicv3 tests are failing because Juno has a gicv2 and the kernel refuses to
>> create a virtual gicv3. It's normal.
> Yup
>
>> - I am not familiar with the PMU test, so I cannot help you with that.
> Where is the output from running the PMU test? I didn't see it in the link
> below.

It's toward the end, it just says that 2 tests failed:

|TESTNAME=pmu TIMEOUT=90s ACCEL= ./arm/run arm/pmu.flat -smp 1|
|[31mFAIL[0m pmu (3 tests, 2 unexpected failures)|
>
>> - Without the logs, it's hard for me to say why the micro-bench test is failing.
>> Can you post the logs for that particular run? They are located in
>> /path/to/kvm-unit-tests/logs/micro-bench.log. My guess is that it has to do with
>> the fact that you are using taskset to keep the tests on one CPU. Micro-bench will
>> use 2 VCPUs to send 2^28 IPIs which will run on the same physical CPU, and sending
>> and receiving them will be serialized which will incur a *lot* of overhead. I
>> tried the same test without taskset, and it worked. With taskset -c 0, it timed
>> out like in your log.
> We've also had "failures" of the micro-bench test when run under avocado
> reported. The problem was/is the assert_msg() on line 107 is firing. We
> could probably increase the number of tries or change the assert to a
> warning. Of course micro-bench isn't a "test" anyway so it can't "fail".
> Well, not unless one goes through the trouble of preparing expected times
> for each measurement for a given host and then compares new results to
> those expectations. Then it could fail when the results are too large
> (some threshold must be defined too).

That happens to me too on occasions when running under kvmtool. When it does I
just rerun the test and it passes almost always. But I think that's not the case
here, since the test times out:

|TESTNAME=micro-bench TIMEOUT=90s ACCEL=kvm ./arm/run arm/micro-bench.flat -smp 2|
|[31mFAIL[0m micro-bench (timeout; duration=90s)|

I tried it and I got the same message, and the in the log:

$ cat logs/micro-bench.log
timeout -k 1s --foreground 90s /usr/bin/qemu-system-aarch64 -nodefaults -machine
virt,gic-version=host,accel=kvm -cpu host -device virtio-serial-device -device
virtconsole,chardev=ctd -chardev testdev,id=ctd -device pci-testdev -display none
-serial stdio -kernel arm/micro-bench.flat -smp 2 # -initrd /tmp/tmp.XXOYQIrjIM
Timer Frequency 40000000 Hz (Output in microseconds)

name                                    total ns                         avg
ns            
--------------------------------------------------------------------------------------------
hvc                                  87727475.0                        
1338.0             
mmio_read_user                      348083225.0                        
5311.0             
mmio_read_vgic                      125456300.0                        
1914.0             
eoi                                    820875.0                          
12.0             
qemu-system-aarch64: terminating on signal 15 from pid 23273 (timeout)

Thanks,
Alex
