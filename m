Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80C051B8AEA
	for <lists+kvm@lfdr.de>; Sun, 26 Apr 2020 03:55:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726102AbgDZBzj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 25 Apr 2020 21:55:39 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:3292 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726087AbgDZBzj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 25 Apr 2020 21:55:39 -0400
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id A8599EA61FAA5363363F;
        Sun, 26 Apr 2020 09:55:36 +0800 (CST)
Received: from [10.173.228.124] (10.173.228.124) by smtp.huawei.com
 (10.3.19.207) with Microsoft SMTP Server (TLS) id 14.3.487.0; Sun, 26 Apr
 2020 09:55:29 +0800
Subject: Re: [PATCH v1 00/15] Add support for Nitro Enclaves
To:     "Paraschiv, Andra-Irina" <andraprs@amazon.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        <linux-kernel@vger.kernel.org>
CC:     Anthony Liguori <aliguori@amazon.com>,
        Benjamin Herrenschmidt <benh@amazon.com>,
        Colm MacCarthaigh <colmmacc@amazon.com>,
        Bjoern Doebel <doebel@amazon.de>,
        David Woodhouse <dwmw@amazon.co.uk>,
        Frank van der Linden <fllinden@amazon.com>,
        Alexander Graf <graf@amazon.de>,
        Martin Pohlack <mpohlack@amazon.de>,
        Matt Wilson <msw@amazon.com>, Balbir Singh <sblbir@amazon.com>,
        Stewart Smith <trawets@amazon.com>,
        Uwe Dannowski <uwed@amazon.de>, <kvm@vger.kernel.org>,
        <ne-devel-upstream@amazon.com>,
        "Gonglei (Arei)" <arei.gonglei@huawei.com>
References: <20200421184150.68011-1-andraprs@amazon.com>
 <18406322-dc58-9b59-3f94-88e6b638fe65@redhat.com>
 <ff65b1ed-a980-9ddc-ebae-996869e87308@amazon.com>
 <2aa9c865-61c1-fc73-c85d-6627738d2d24@huawei.com>
 <7ac3f702-9c5f-5021-ebe3-42f1c93afbdf@amazon.com>
 <f701e084-7d2d-35dd-31ec-adc7d2a9e893@amazon.com>
From:   "Longpeng (Mike, Cloud Infrastructure Service Product Dept.)" 
        <longpeng2@huawei.com>
Message-ID: <77af0b1c-9884-5a75-02bd-1cc63c57971c@huawei.com>
Date:   Sun, 26 Apr 2020 09:55:28 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <f701e084-7d2d-35dd-31ec-adc7d2a9e893@amazon.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.173.228.124]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2020/4/24 17:54, Paraschiv, Andra-Irina wrote:
> 
> 
> On 24/04/2020 11:19, Paraschiv, Andra-Irina wrote:
>>
>>
>> On 24/04/2020 06:04, Longpeng (Mike, Cloud Infrastructure Service Product
>> Dept.) wrote:
>>> On 2020/4/23 21:19, Paraschiv, Andra-Irina wrote:
>>>>
>>>> On 22/04/2020 00:46, Paolo Bonzini wrote:
>>>>> On 21/04/20 20:41, Andra Paraschiv wrote:
>>>>>> An enclave communicates with the primary VM via a local communication
>>>>>> channel,
>>>>>> using virtio-vsock [2]. An enclave does not have a disk or a network device
>>>>>> attached.
>>>>> Is it possible to have a sample of this in the samples/ directory?
>>>> I can add in v2 a sample file including the basic flow of how to use the ioctl
>>>> interface to create / terminate an enclave.
>>>>
>>>> Then we can update / build on top it based on the ongoing discussions on the
>>>> patch series and the received feedback.
>>>>
>>>>> I am interested especially in:
>>>>>
>>>>> - the initial CPU state: CPL0 vs. CPL3, initial program counter, etc.
>>>>>
>>>>> - the communication channel; does the enclave see the usual local APIC
>>>>> and IOAPIC interfaces in order to get interrupts from virtio-vsock, and
>>>>> where is the virtio-vsock device (virtio-mmio I suppose) placed in memory?
>>>>>
>>>>> - what the enclave is allowed to do: can it change privilege levels,
>>>>> what happens if the enclave performs an access to nonexistent memory, etc.
>>>>>
>>>>> - whether there are special hypercall interfaces for the enclave
>>>> An enclave is a VM, running on the same host as the primary VM, that launched
>>>> the enclave. They are siblings.
>>>>
>>>> Here we need to think of two components:
>>>>
>>>> 1. An enclave abstraction process - a process running in the primary VM guest,
>>>> that uses the provided ioctl interface of the Nitro Enclaves kernel driver to
>>>> spawn an enclave VM (that's 2 below).
>>>>
>>>> How does all gets to an enclave VM running on the host?
>>>>
>>>> There is a Nitro Enclaves emulated PCI device exposed to the primary VM. The
>>>> driver for this new PCI device is included in the current patch series.
>>>>
>>> Hi Paraschiv,
>>>
>>> The new PCI device is emulated in QEMU ? If so, is there any plan to send the
>>> QEMU code ?
>>
>> Hi,
>>
>> Nope, not that I know of so far.
> 
> And just to be a bit more clear, the reply above takes into consideration that
> it's not emulated in QEMU.
> 

Thanks.

Guys in this thread are much more interested in the design of enclave VM and the
new device, but there's no any document about this device yet, so I think the
emulate code is a good alternative. However, Alex said the device specific will
be published later, so I'll wait for it.

> 
> Thanks,
> Andra
> 
>>
>>>
>>>> The ioctl logic is mapped to PCI device commands e.g. the NE_ENCLAVE_START
>>>> ioctl
>>>> maps to an enclave start PCI command or the KVM_SET_USER_MEMORY_REGION maps to
>>>> an add memory PCI command. The PCI device commands are then translated into
>>>> actions taken on the hypervisor side; that's the Nitro hypervisor running on
>>>> the
>>>> host where the primary VM is running.
>>>>
>>>> 2. The enclave itself - a VM running on the same host as the primary VM that
>>>> spawned it.
>>>>
>>>> The enclave VM has no persistent storage or network interface attached, it uses
>>>> its own memory and CPUs + its virtio-vsock emulated device for communication
>>>> with the primary VM.
>>>>
>>>> The memory and CPUs are carved out of the primary VM, they are dedicated for
>>>> the
>>>> enclave. The Nitro hypervisor running on the host ensures memory and CPU
>>>> isolation between the primary VM and the enclave VM.
>>>>
>>>>
>>>> These two components need to reflect the same state e.g. when the enclave
>>>> abstraction process (1) is terminated, the enclave VM (2) is terminated as
>>>> well.
>>>>
>>>> With regard to the communication channel, the primary VM has its own emulated
>>>> virtio-vsock PCI device. The enclave VM has its own emulated virtio-vsock
>>>> device
>>>> as well. This channel is used, for example, to fetch data in the enclave and
>>>> then process it. An application that sets up the vsock socket and connects or
>>>> listens, depending on the use case, is then developed to use this channel; this
>>>> happens on both ends - primary VM and enclave VM.
>>>>
>>>> Let me know if further clarifications are needed.
>>>>
>>>>>> The proposed solution is following the KVM model and uses the KVM API to
>>>>>> be able
>>>>>> to create and set resources for enclaves. An additional ioctl command,
>>>>>> besides
>>>>>> the ones provided by KVM, is used to start an enclave and setup the
>>>>>> addressing
>>>>>> for the communication channel and an enclave unique id.
>>>>> Reusing some KVM ioctls is definitely a good idea, but I wouldn't really
>>>>> say it's the KVM API since the VCPU file descriptor is basically non
>>>>> functional (without KVM_RUN and mmap it's not really the KVM API).
>>>> It uses part of the KVM API or a set of KVM ioctls to model the way a VM is
>>>> created / terminated. That's true, KVM_RUN and mmap-ing the vcpu fd are not
>>>> included.
>>>>
>>>> Thanks for the feedback regarding the reuse of KVM ioctls.
>>>>
>>>> Andra
>>>>
>>>>
>>>>
>>>>
>>>> Amazon Development Center (Romania) S.R.L. registered office: 27A Sf. Lazar
>>>> Street, UBC5, floor 2, Iasi, Iasi County, 700045, Romania. Registered in
>>>> Romania. Registration number J22/2621/2005.
>>
> 
> 
> 
> 
> Amazon Development Center (Romania) S.R.L. registered office: 27A Sf. Lazar
> Street, UBC5, floor 2, Iasi, Iasi County, 700045, Romania. Registered in
> Romania. Registration number J22/2621/2005.
---
Regards,
Longpeng(Mike)
