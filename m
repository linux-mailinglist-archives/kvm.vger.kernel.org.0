Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B5E2C177B70
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2020 17:03:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729235AbgCCQCz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Mar 2020 11:02:55 -0500
Received: from foss.arm.com ([217.140.110.172]:49142 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728714AbgCCQCy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Mar 2020 11:02:54 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3655B2F;
        Tue,  3 Mar 2020 08:02:54 -0800 (PST)
Received: from [10.1.196.63] (e123195-lin.cambridge.arm.com [10.1.196.63])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D0DB03F6C4;
        Tue,  3 Mar 2020 08:02:52 -0800 (PST)
Subject: Re: kvm-unit-tests : Kconfigs and extra kernel args for full coverage
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     Andrew Jones <drjones@redhat.com>, kvm list <kvm@vger.kernel.org>,
        lkft-triage@lists.linaro.org,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>, yzt356@gmail.com,
        jmattson@google.com, Paolo Bonzini <pbonzini@redhat.com>,
        namit@vmware.com, sean.j.christopherson@intel.com,
        Basil Eljuse <Basil.Eljuse@arm.com>
References: <CA+G9fYvx=WzyJqS4fUFLq8qXT8nbFQoFfXZoeL9kP-hvv549EA@mail.gmail.com>
 <c82f4386-702f-a2e9-a4d7-d5ebb1f335d1@arm.com>
 <20200224133818.gtxtrmzo4y4guk4z@kamzik.brq.redhat.com>
 <adf05c0d-6a19-da06-5e41-da63b0d0d8d8@arm.com>
 <20200224145936.mzpwveaoijjmb5ql@kamzik.brq.redhat.com>
 <CA+G9fYvt2LyqU5G2j_EFKzgPXzt8sDYYm8NxP+zD6Do07REsYw@mail.gmail.com>
 <7b9209be-f880-a791-a2b9-c7e98bf05ecd@arm.com>
 <CA+G9fYvjoeLV5B951yFb8fc7r+WAejz+0kHcFYTNzW6+HfouXw@mail.gmail.com>
 <CA+G9fYuEfrhW_7vLCdK4nKBhDv6aQkK_knUY7mbgeDcuaETLyQ@mail.gmail.com>
From:   Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <a1f51266-d735-402a-6273-8ae84d415881@arm.com>
Date:   Tue, 3 Mar 2020 16:02:51 +0000
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <CA+G9fYuEfrhW_7vLCdK4nKBhDv6aQkK_knUY7mbgeDcuaETLyQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On 2/25/20 8:20 AM, Naresh Kamboju wrote:
> Hi Alexandru,
>
> On Mon, 24 Feb 2020 at 23:14, Naresh Kamboju <naresh.kamboju@linaro.org> wrote:
>>> I think this is because you are running it on one physical CPU (it's exactly the
>>> same message I am getting when I use taskset to run the tests). Can you try and
>>> run it without taskset and see if it solves your issue?
> We have a new problem when running [1] without taskset on Juno-r2.
> None of the test got pass [2] when running without taskset on Juno-r2.
>
I think I have an explanation for why all the tests fail. qemu creates a vcpu to
match the host cpu in kvm_arm_create_scratch_host_vcpu and it sets the target to
whatever the result of the KVM_ARM_PREFERRED_TARGET ioctl is. If it's run on the
little core, the target will be KVM_ARM_TARGET_CORTEX_A53. If it's run on the big
core, the target will be KVM_ARM_TARGET_GENERIC_V8. I tried it a few times, and
for me it has always been the big core.

The vcpu is created from a different thread by doing a KVM_ARM_VCPU_INIT ioctl and
KVM makes sure that the vcpu target matches the target corresponding to the
physical CPU the thread is running on. What is happening is that the vcpu thread
is run on a little core, so the target as far as KVM is concerned should be
KVM_ARM_TARGET_CORTEX_A53, but qemu (correctly) set it to
KVM_ARM_TARGET_GENERIC_V8. The ioctl return -EINVAL (-22) and qemu dies.

To get around this, I ran the tests either only on the big cores or on the little
cores.

I also managed to reliably trigger the PMU failures that you are seeing. They only
happen when kvm-unit-tests is run on the little cores (ran them 10 times in a
loop). When run on  the big cores, everything is fine (also ran them 10 times in a
loop). Log output when it fails:

# taskset -c 0,3,4,5 arm/run arm/pmu.flat
/usr/bin/qemu-system-aarch64 -nodefaults -machine virt,gic-version=host,accel=kvm
-cpu host -device virtio-serial-device -device virtconsole,chardev=ctd -chardev
testdev,id=ctd -device pci-testdev -display none -serial stdio -kernel
arm/pmu.flat # -initrd /tmp/tmp.s4ld4DX4uK
INFO: PMU version: 3
INFO: pmu: PMU implementer/ID code/counters: 0x41("A")/0x3/6
PASS: pmu: Control register
Read 0 then 0.
FAIL: pmu: Monotonically increasing cycle count
instrs : cycles0 cycles1 ...
   4:    0
cycles not incrementing!
FAIL: pmu: Cycle/instruction ratio
SUMMARY: 3 tests, 2 unexpected failures

I'm looking into it.

Thanks,
Alex
