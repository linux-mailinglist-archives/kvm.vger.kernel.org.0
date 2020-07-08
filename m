Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47753218751
	for <lists+kvm@lfdr.de>; Wed,  8 Jul 2020 14:30:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729012AbgGHMaD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Jul 2020 08:30:03 -0400
Received: from foss.arm.com ([217.140.110.172]:37120 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728941AbgGHMaC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Jul 2020 08:30:02 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 38B841FB;
        Wed,  8 Jul 2020 05:30:02 -0700 (PDT)
Received: from [192.168.0.14] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 344EE3F68F;
        Wed,  8 Jul 2020 05:29:59 -0700 (PDT)
Subject: Re: [PATCH RFC 0/4] Changes to Support *Virtual* CPU Hotplug for
 ARM64
To:     Salil Mehta <salil.mehta@huawei.com>
Cc:     "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "maz@kernel.org" <maz@kernel.org>,
        "will@kernel.org" <will@kernel.org>,
        "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
        "christoffer.dall@arm.com" <christoffer.dall@arm.com>,
        "andre.przywara@arm.com" <andre.przywara@arm.com>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "lorenzo.pieralisi@arm.com" <lorenzo.pieralisi@arm.com>,
        "sudeep.holla@arm.com" <sudeep.holla@arm.com>,
        "qemu-arm@nongnu.org" <qemu-arm@nongnu.org>,
        "peter.maydell@linaro.org" <peter.maydell@linaro.org>,
        "richard.henderson@linaro.org" <richard.henderson@linaro.org>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "mst@redhat.com" <mst@redhat.com>,
        "drjones@redhat.com" <drjones@redhat.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "gshan@redhat.com" <gshan@redhat.com>,
        "david@redhat.com" <david@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linuxarm <linuxarm@huawei.com>,
        "mehta.salil.lnk@gmail.com" <mehta.salil.lnk@gmail.com>
References: <20200625133757.22332-1-salil.mehta@huawei.com>
 <8efc4efe284641eda3ffeb2301fcca43@huawei.com>
From:   James Morse <james.morse@arm.com>
Message-ID: <cbaa6d68-6143-e010-5f3c-ec62f879ad95@arm.com>
Date:   Wed, 8 Jul 2020 13:29:43 +0100
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <8efc4efe284641eda3ffeb2301fcca43@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Salil,

On 07/07/2020 10:52, Salil Mehta wrote:
>> From: Salil Mehta


Disambiguation: by cpu-hotplug here, you don't mean
CONFIG_HOTPLUG_CPU backed by PSCI, which is commonly what we mean in the arm world. You
mean: package hot-add. A bunch of CPUs (and maybe more) that weren't present at boot have
turned up.


>> Changes to support virtual cpu hotplug in QEMU[1] have been introduced to the
>> community as RFC. These are under review.
>>
>> To support virtual cpu hotplug guest kernel must:

Surely number 1 is: know its a virtual machine, and that whatever needs doing/describing
on a real machine, doesn't need doing or describing here...

We add support for virtual machines after support for the physical machine. Is anyone
building hardware that supports this?

We can assume some will exist during the lifetime of a stable-kernel. The stable-kernel
will claim to support this, but in reality it will crash and burn in exciting ways.

(e.g. parts of the interrupt controller in the hot-added package would need configuring.
We'd either lock up during boot when we try, but its not there ... or not do it when the
package is added because we assumed this was a VM)


I don't think linux can support this for virtual machines until it works for real machines
too. We don't have a reliable way of determining we are running in a VM.

This at least needs the ACPI spec updating to describe what work the OS has to do when a
package comes online, and what it can't touch until then.
I don't think this work would happen without someone building such a system.


>> 1. Identify disabled/present vcpus and set/unset the present mask of the vcpu
>>    during initialization and hotplug event. It must also set the possible mask
>>    (which includes disabled vcpus) during init of guest kernel.
>> 2. Provide architecture specific ACPI hooks, for example to map/unmap the
>>    logical cpuid to hwids/MPIDR. Linux kernel already has generic ACPI cpu
>>    hotplug framework support.

>> Changes introduced in this patch-set also ensures that initialization of the
>> cpus when virtual cpu hotplug is not supported remains un-affected.

But on a platform with physical cpu hotplug, really-bad-things will happen.


There is no description here of what problem you are trying to solve. I don't believe 'cpu
hotlpug' is an end in itself.

~

Aha, its in the qemu cover letter:
| This allows scaling the guest VM compute capacity on-demand which would be
| useful for the following example scenarios,
| 1. Vertical Pod Autoscaling[3][4] in the cloud: Part of the orchestration
|   framework which could adjust resource requests (CPU and Mem requests) for
|   the containers in a pod, based on usage.
|2. Pay-as-you-grow Business Model: Infrastructure provider could allocate and
|   restrict the total number of compute resources available to the guest VM
|   according to the SLA(Service Level Agreement). VM owner could request for
|   more compute to be hot-plugged for some cost.

Controlling CPU time makes perfect sense. But doesn't cgroup already do exactly this?

If a VM is restricted to 1xCPU of cpu-time, it can online as many vcpu as it likes, its
not going to get more than 1xCPU of cpu-time.


I understand that this is how kubernetes reconfigures a VM on x86, but I'm fairly sure x86
had physical cpu hotplug before, so the firmware/OS responsibilities were well understood.


I think this series creates a support nightmare for the future.


This has come up before:
https://lore.kernel.org/kvmarm/82879258-46a7-a6e9-ee54-fc3692c1cdc3@arm.com/


Thanks,

James


>> Repository:
>> (*) Kernel changes are at,
>>      https://github.com/salil-mehta/linux.git virt-cpuhp-arm64/rfc-v1
>> (*) QEMU changes for vcpu hotplug could be cloned from below site,
>>      https://github.com/salil-mehta/qemu.git virt-cpuhp-armv8/rfc-v1
>>
>>
>> THINGS TO DO:
>> 1. Handling of per-cpu variables especially the first-chunk allocations
>>    (which are NUMA aware) when the vcpu is hotplugged needs further attention
>>    and review.
>> 2. NUMA related stuff has not been fully tested both in QEMU and kernel.
>> 3. Comprehensive Testing including when cpu hotplug is not supported.
>> 4. Docs
>>
>> DISCLAIMER:
>> This is not a complete work but an effort to present the arm vcpu hotplug
>> implementation to the community. This RFC is being used as a way to verify
>> the idea mentioned above and to support changes presented for QEMU[1] to
>> support vcpu hotplug. As of now this is *not* a production level code and might
>> have bugs. Only a basic testing has been done on HiSilicon Kunpeng920 ARM64
>> based SoC for Servers to verify the proof-of-concept that has been found working!
>>
>> Best regards
>> Salil.
>>
>> REFERENCES:
>> [1] https://www.mail-archive.com/qemu-devel@nongnu.org/msg712010.html
>> [2] https://lkml.org/lkml/2019/6/28/1157
>> [3] https://lists.cs.columbia.edu/pipermail/kvmarm/2018-July/032316.html
>>
>> Organization of Patches:
>> [Patch 1-3]
>> (*) Changes required during guest boot time to support vcpu hotplug
>> (*) Max cpu overflow checks
>> (*) Changes required to pre-setup cpu-operations even for disabled cpus
>> [Patch 4]
>> (*) Arch changes required by guest kernel ACPI CPU Hotplug framework.
>>
>>
>> Salil Mehta (4):
>>   arm64: kernel: Handle disabled[(+)present] cpus in MADT/GICC during
>>     init
>>   arm64: kernel: Bound the total(present+disabled) cpus with nr_cpu_ids
>>   arm64: kernel: Init cpu operations for all possible vcpus
>>   arm64: kernel: Arch specific ACPI hooks(like logical cpuid<->hwid
>>     etc.)
>>
>>  arch/arm64/kernel/smp.c | 153 ++++++++++++++++++++++++++++++++--------
>>  1 file changed, 123 insertions(+), 30 deletions(-)
>>
>> --
>> 2.17.1
>>
> 

