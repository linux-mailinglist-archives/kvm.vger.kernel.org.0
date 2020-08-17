Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45255245A88
	for <lists+kvm@lfdr.de>; Mon, 17 Aug 2020 03:46:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726590AbgHQBqc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 16 Aug 2020 21:46:32 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:9741 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726375AbgHQBqa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 16 Aug 2020 21:46:30 -0400
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id C2D54D38E42019B5E021;
        Mon, 17 Aug 2020 09:46:24 +0800 (CST)
Received: from [127.0.0.1] (10.174.187.42) by DGGEMS404-HUB.china.huawei.com
 (10.3.19.204) with Microsoft SMTP Server id 14.3.487.0; Mon, 17 Aug 2020
 09:46:18 +0800
Subject: Re: [kvm-unit-tests PATCH v3 00/10] arm/arm64: Add IPI/LPI/vtimer
 latency test
To:     Marc Zyngier <maz@kernel.org>
CC:     <drjones@redhat.com>, <kvm@vger.kernel.org>,
        <kvmarm@lists.cs.columbia.edu>, <eric.auger@redhat.com>,
        <wanghaibin.wang@huawei.com>, <yuzenghui@huawei.com>
References: <20200731074244.20432-1-wangjingyi11@huawei.com>
 <957a4657-7e17-b173-ea4d-10c29ab9e3cd@huawei.com>
 <0bd81d1da9040fce660af46763507ac2@kernel.org>
 <54de9edf-3cca-f968-1ea8-027556b5f5ff@huawei.com>
 <b175763e4f4f08ecdae46e6e87b0bc81@kernel.org>
From:   Jingyi Wang <wangjingyi11@huawei.com>
Message-ID: <d9aa5414-490e-179f-d789-3c929ffe0727@huawei.com>
Date:   Mon, 17 Aug 2020 09:46:17 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <b175763e4f4f08ecdae46e6e87b0bc81@kernel.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.187.42]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/11/2020 3:49 PM, Marc Zyngier wrote:
> On 2020-08-11 02:48, Jingyi Wang wrote:
>> Hi Marc,
>>
>> On 8/5/2020 8:13 PM, Marc Zyngier wrote:
>>> On 2020-08-05 12:54, Jingyi Wang wrote:
>>>> Hi all,
>>>>
>>>> Currently, kvm-unit-tests only support GICv3 vLPI injection. May I ask
>>>> is there any plan or suggestion on constructing irq bypass mechanism
>>>> to test vLPI direct injection in kvm-unit-tests?
>>>
>>> I'm not sure what you are asking for here. VLPIs are only delivered
>>> from a HW device, and the offloading mechanism isn't visible from
>>> userspace (you either have an enabled GICv4 implementation, or
>>> you don't).
>>>
>>> There are ways to *trigger* device MSIs from userspace and inject
>>> them in a guest, but that's only a debug feature, which shouldn't
>>> be enabled on a production system.
>>>
>>>          M.
>>
>> Sorry for the late reply.
>>
>> As I mentioned before, we want to add vLPI direct injection test
>> in KUT, meanwhile measure the latency of hardware vLPI injection.
>>
>> Sure, vLPI is triggered by hardware. Since kernel supports sending
>> ITS INT command in guest to trigger vLPI, I wonder if it is possible
> 
> So can the host.
> 
>> to add an extra interface to make a vLPI hardware-offload(just as
>> kvm_vgic_v4_set_forwarding() does). If so, vgic_its_trigger_msi()
>> can inject vLPI directly instead of using LR.
> 
> The interface exists, it is in debugfs. But it mandates that the
> device exists. And no, I am not willing to add an extra KVM userspace
> API for this.
> 
> The whole concept of injecting an INT to measure the performance
> of GICv4 is slightly bonkers, actually. Most of the cost is paid
> on the injection path (queuing a pair of command, waiting until
> the ITS wakes up and generate the signal...).
> 
> What you really want to measure is the time from generation of
> the LPI by a device until the guest acknowledges the interrupt
> to the device itself. and this can only be implemented in the
> device.
> 
>          M.

OK understood. I just thought measuring the latency of the path
kvm->guest can be useful.

Thanks,
Jingyi

