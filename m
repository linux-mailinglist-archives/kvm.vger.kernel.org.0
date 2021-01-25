Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF454303215
	for <lists+kvm@lfdr.de>; Tue, 26 Jan 2021 03:48:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729723AbhAYOtY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Jan 2021 09:49:24 -0500
Received: from szxga08-in.huawei.com ([45.249.212.255]:2797 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729627AbhAYOsX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Jan 2021 09:48:23 -0500
Received: from dggeme717-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4DPXj04mpVz13lyL;
        Mon, 25 Jan 2021 22:45:24 +0800 (CST)
Received: from [10.174.187.161] (10.174.187.161) by
 dggeme717-chm.china.huawei.com (10.1.199.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2106.2; Mon, 25 Jan 2021 22:47:19 +0800
Subject: Re: [PATCH v3 00/17] KVM: x86/pmu: Add support to enable Guest PEBS
 via DS
To:     Like Xu <like.xu@linux.intel.com>, kvm <kvm@vger.kernel.org>,
        Wei Wang <wei.w.wang@intel.com>
References: <EEC2A80E7137D84ABF791B01D40FA9A601EC200E@DGGEMM506-MBX.china.huawei.com>
 <584b4e9a-37e7-1f2a-0a67-42034329a9dc@linux.intel.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Xiexiangyou <xiexiangyou@huawei.com>
From:   "Liuxiangdong (Aven, Cloud Infrastructure Service Product Dept.)" 
        <liuxiangdong5@huawei.com>
Reply-To: "Fangyi (Eric)" <eric.fangyi@huawei.com>
Message-ID: <600ED9F7.1060503@huawei.com>
Date:   Mon, 25 Jan 2021 22:47:19 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:38.0) Gecko/20100101
 Thunderbird/38.1.0
MIME-Version: 1.0
In-Reply-To: <584b4e9a-37e7-1f2a-0a67-42034329a9dc@linux.intel.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.187.161]
X-ClientProxiedBy: dggeme715-chm.china.huawei.com (10.1.199.111) To
 dggeme717-chm.china.huawei.com (10.1.199.113)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Thanks for replying,

On 2021/1/25 10:41, Like Xu wrote:
> + kvm@vger.kernel.org
>
> Hi Liuxiangdong,
>
> On 2021/1/22 18:02, Liuxiangdong (Aven, Cloud Infrastructure Service 
> Product Dept.) wrote:
>> Hi Like,
>>
>> Some questions about 
>> https://lore.kernel.org/kvm/20210104131542.495413-1-like.xu@linux.intel.com/ 
>> <https://lore.kernel.org/kvm/20210104131542.495413-1-like.xu@linux.intel.com/> 
>>
>
> Thanks for trying the PEBS feature in the guest,
> and I assume you have correctly applied the QEMU patches for guest PEBS.
>
Is there any other patch that needs to be apply? I use qemu 5.2.0. 
(download from github on January 14th)

>> 1)Test in IceLake
>
> In the [PATCH v3 10/17] KVM: x86/pmu: Expose CPUIDs feature bits PDCM, 
> DS, DTES64, we only support Ice Lake with the following x86_model(s):
>
> #define INTEL_FAM6_ICELAKE_X        0x6A
> #define INTEL_FAM6_ICELAKE_D        0x6C
>
> you can check the eax output of "cpuid -l 1 -1 -r",
> for example "0x000606a4" meets this requirement.
It's INTEL_FAM6_ICELAKE_X
cpuid -l 1 -1 -r

CPU:
    0x00000001 0x00: eax=0x000606a6 ebx=0xb4800800 ecx=0x7ffefbf7 
edx=0xbfebfbff

>>
>> HOST:
>>
>> CPU family:                      6
>>
>> Model:                           106
>>
>> Model name:                      Intel(R) Xeon(R) Platinum 8378A CPU 
>> $@ $@
>>
>> microcode: sig=0x606a6, pf=0x1, revision=0xd000122
>
> As long as you get the latest BIOS from the provider,
> you may check 'cat /proc/cpuinfo | grep code | uniq' with the latest one.
OK. I'll do it later.
>
>>
>> Guest:  linux kernel 5.11.0-rc2
>
> I assume it's the "upstream tag v5.11-rc2" which is fine.
Yes.
>
>>
>> We can find pebs/intel_pt flag in guest cpuinfo, but there still 
>> exists error when we use perf
>
> Just a note, intel_pt and pebs are two features and we can write
> pebs records to intel_pt buffer with extra hardware support.
> (by default, pebs records are written to the pebs buffer)
>
> You may check the output of "dmesg | grep PEBS" in the guest
> to see if the guest PEBS cpuinfo is exposed and use "perf record
> –e cycles:pp" to see if PEBS feature actually  works in the guest.

I apply only pebs patch set to linux kernel 5.11.0-rc2, test perf in 
guest and dump stack when return -EOPNOTSUPP

(1)
# perf record -e instructions:pp
Error:
instructions:pp: PMU Hardware doesn't support 
sampling/overflow-interrupts. Try 'perf stat'

[  117.793266] Call Trace:
[  117.793270]  dump_stack+0x57/0x6a
[  117.793275]  intel_pmu_setup_lbr_filter+0x137/0x190
[  117.793280]  intel_pmu_hw_config+0x18b/0x320
[  117.793288]  hsw_hw_config+0xe/0xa0
[  117.793290]  x86_pmu_event_init+0x8e/0x210
[  117.793293]  perf_try_init_event+0x40/0x130
[  117.793297]  perf_event_alloc.part.22+0x611/0xde0
[  117.793299]  ? alloc_fd+0xba/0x180
[  117.793302]  __do_sys_perf_event_open+0x1bd/0xd90
[  117.793305]  do_syscall_64+0x33/0x40
[  117.793308]  entry_SYSCALL_64_after_hwframe+0x44/0xa9

Do we need lbr when we use pebs?

I tried to apply lbr patch 
set(https://lore.kernel.org/kvm/911adb63-ba05-ea93-c038-1c09cff15eda@intel.com/) 
to kernel and qemu, but there is still other problem.
Error:
The sys_perf_event_open() syscall returned with 22 (Invalid argument) 
for event
...

(2)
# perf record -e instructions:ppp
Error:
instructions:ppp: PMU Hardware doesn't support 
sampling/overflow-interrupts. Try 'perf stat'

[  115.188498] Call Trace:
[  115.188503]  dump_stack+0x57/0x6a
[  115.188509]  x86_pmu_hw_config+0x1eb/0x220
[  115.188515]  intel_pmu_hw_config+0x13/0x320
[  115.188519]  hsw_hw_config+0xe/0xa0
[  115.188521]  x86_pmu_event_init+0x8e/0x210
[  115.188524]  perf_try_init_event+0x40/0x130
[  115.188528]  perf_event_alloc.part.22+0x611/0xde0
[  115.188530]  ? alloc_fd+0xba/0x180
[  115.188534]  __do_sys_perf_event_open+0x1bd/0xd90
[  115.188538]  do_syscall_64+0x33/0x40
[  115.188541]  entry_SYSCALL_64_after_hwframe+0x44/0xa9

This is beacuse x86_pmu.intel_cap.pebs_format is always 0 in 
x86_pmu_max_precise().

We rdmsr MSR_IA32_PERF_CAPABILITIES(0x00000345)  from HOST, it's f4c5.
 From guest, it's 2000

>>
>> # perf record –e cycles:pp
>>
>> Error:
>>
>> cycles:pp: PMU Hardware doesn’t support sampling/overflow-interrupts. 
>> Try ‘perf stat’
>>
>> Could you give some advice?
>
> If you have more specific comments or any concerns, just let me know.
>
>>
>> 2)Test in Skylake
>>
>> HOST:
>>
>> CPU family:                      6
>>
>> Model:                           85
>>
>> Model name:                      Intel(R) Xeon(R) Gold 6146 CPU @
>>
>>                                    3.20GHz
>>
>> microcode        : 0x2000064
>>
>> Guest: linux 4.18
>>
>> we cannot find intel_pt flag in guest cpuinfo because 
>> cpu_has_vmx_intel_pt() return false.
>
> You may check vmx_pebs_supported().
It's true.
>
>>
>> SECONDARY_EXEC_PT_USE_GPA/VM_EXIT_CLEAR_IA32_RTIT_CTL/VM_ENTRY_LOAD_IA32_RTIT_CTL 
>> are both disable.
>>
>> Is it because microcode is not supported?
>>
>> And, isthere a new macrocode which can support these bits? How can we 
>> get this?
>
> Currently, this patch set doesn't support guest PEBS on the Skylake
> platforms, and if we choose to support it, we will let you know.
>
And now, we want to use pebs in skylake. If we develop based on pebs 
patch set, do you have any suggestions?
I think microcode requirements need to be satisfied.  Can we use 
https://github.com/intel/Intel-Linux-Processor-Microcode-Data-Files ?

> ---
> thx,likexu
>
>>
>> Thanks,
>>
>> Liuxiangdong
>>
>
Thanks. Liuxiangdong

