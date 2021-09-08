Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC92F403D74
	for <lists+kvm@lfdr.de>; Wed,  8 Sep 2021 18:17:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347311AbhIHQS0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Sep 2021 12:18:26 -0400
Received: from foss.arm.com ([217.140.110.172]:48506 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230091AbhIHQSN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Sep 2021 12:18:13 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 242D31FB;
        Wed,  8 Sep 2021 09:17:05 -0700 (PDT)
Received: from [192.168.0.110] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C644E3F766;
        Wed,  8 Sep 2021 09:17:03 -0700 (PDT)
Subject: Re: [PATCH] vfio/pci: Add support for PCIe extended capabilities
To:     Vivek Kumar Gautam <vivek.gautam@arm.com>, will@kernel.org,
        julien.thierry.kdev@gmail.com, kvm@vger.kernel.org
Cc:     andre.przywara@arm.com, lorenzo.pieralisi@arm.com,
        jean-philippe@linaro.org, eric.auger@redhat.com
References: <20210810062514.18980-1-vivek.gautam@arm.com>
 <af1ae6fe-176b-8016-3815-faa9651b0aba@arm.com>
 <51cc78f5-6841-5e83-3b28-bef7fbf68937@arm.com>
 <ae4bdd18-29c8-5871-5242-95d5c5d8a6a6@arm.com>
 <867e8db7-c173-5ad2-dca4-69085c89d956@arm.com>
From:   Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <d3fefd2e-f2e3-e484-839f-a5d93d4021d9@arm.com>
Date:   Wed, 8 Sep 2021 17:18:19 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <867e8db7-c173-5ad2-dca4-69085c89d956@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Vivek,

On 9/8/21 10:32 AM, Vivek Kumar Gautam wrote:
> Hi Alex,
>
>
> On 9/3/21 8:45 PM, Alexandru Elisei wrote:
>> Hi Vivek,
>>
>> On 9/2/21 11:48 AM, Vivek Kumar Gautam wrote:
>>> Hi Alex,
>>>
>>>
>>> On 9/2/21 3:29 PM, Alexandru Elisei wrote:
>>>> Hi Vivek,
>>>>
>>>> On 8/10/21 7:25 AM, Vivek Gautam wrote:
>>>>> Add support to parse extended configuration space for vfio based
>>>>> assigned PCIe devices and add extended capabilities for the device
>>>>> in the guest. This allows the guest to see and work on extended
>>>>> capabilities, for example to toggle PRI extended cap to enable and
>>>>> disable Shared virtual addressing (SVA) support.
>>>>> PCIe extended capability header that is the first DWORD of all
>>>>> extended caps is shown below -
>>>>>
>>>>>      31               20  19   16  15                 0
>>>>>      ____________________|_______|_____________________
>>>>>     |    Next cap off    |  1h   |     Cap ID          |
>>>>>     |____________________|_______|_____________________|
>>>>>
>>>>> Out of the two upper bytes of extended cap header, the
>>>>> lower nibble is actually cap version - 0x1.
>>>>> 'next cap offset' if present at bits [31:20], should be
>>>>> right shifted by 4 bits to calculate the position of next
>>>>> capability.
>>>>> This change supports parsing and adding ATS, PRI and PASID caps.
>>>>>
>>>>> Signed-off-by: Vivek Gautam <vivek.gautam@arm.com>
>>>>> ---
>>>>>    include/kvm/pci.h |   6 +++
>>>>>    vfio/pci.c        | 104 ++++++++++++++++++++++++++++++++++++++++++----
>>>>>    2 files changed, 103 insertions(+), 7 deletions(-)
>> [..]
>>>>> @@ -725,7 +815,7 @@ static int vfio_pci_parse_caps(struct vfio_device *vdev)
>>>>>      static int vfio_pci_parse_cfg_space(struct vfio_device *vdev)
>>>>>    {
>>>>> -    ssize_t sz = PCI_DEV_CFG_SIZE_LEGACY;
>>>>> +    ssize_t sz = PCI_DEV_CFG_SIZE;
>>>>>        struct vfio_region_info *info;
>>>>>        struct vfio_pci_device *pdev = &vdev->pci;
>>>>>    @@ -831,10 +921,10 @@ static int vfio_pci_fixup_cfg_space(struct vfio_device
>>>>> *vdev)
>>>>>        /* Install our fake Configuration Space */
>>>>>        info = &vdev->regions[VFIO_PCI_CONFIG_REGION_INDEX].info;
>>>>>        /*
>>>>> -     * We don't touch the extended configuration space, let's be cautious
>>>>> -     * and not overwrite it all with zeros, or bad things might happen.
>>>>> +     * Update the extended configuration space as well since we
>>>>> +     * are now populating the extended capabilities.
>>>>>         */
>>>>> -    hdr_sz = PCI_DEV_CFG_SIZE_LEGACY;
>>>>> +    hdr_sz = PCI_DEV_CFG_SIZE;
>>>>
>>>> In one of the earlier versions of the PCI Express patches I was doing the same
>>>> thing here - overwriting the entire PCI Express configuration space for a
>>>> device.
>>>> However, that made one of the devices I was using for testing stop working when
>>>> assigned to a VM.
>>>>
>>>> I'll go through my testing notes and test it again, the cause of the failure
>>>> might
>>>> have been something else entirely which was fixed since then.
>>>
>>> Sure. Let me know your findings.
>>
>> I think I found the card that doesn't work when overwriting the extended device
>> configuration space. I tried device assignment with a Realtek 8168 Gigabit
>> Ethernet card on a Seattle machine, and the host freezes when I try to start a VM.
>> Even after reset, the machine doesn't boot anymore and it gets stuck during the
>> boot process at this message:
>>
>> NewPackageList status: EFI_SUCCESS
>> BDS.SignalConnectDriversEvent(feeb6d60)
>> BDS.ConnectRootBridgeHandles(feeb6db0)
>>
>> It doesn't go away no matter how many times I reset the machine, to get it booting
>> again I have to pull the plug and plug it again. I tried assigning the device to a
>> VM several times, and this happened every time. The card doesn't have the caps
>> that you added, this is caused entirely by the config space write (tried it with
>> only the config space change).
>>
>> It could be a problem kvmtool, with Linux or with the machine, but this is the
>> only machine where device assignment works and I would like to keep it working
>> with this NIC.
>
> Sorry for the delay in responding. I took sometime off work.
> Sure, we will try to keep your machine working :)
>
>>
>> One solution I see is to add a field to vfio_pci_device (something like has_pcie),
>> and based on that, vfio_pci_fixup_cfg_space() could overwrite only the first 256
>> bytes or the entire device configuration space.
>
> Does the card support PCI extended caps (as seen from the PCI spec v5.0
> section-7.5)?
> If no, then I guess the check that I am planning to add - to check if the device
> supports extended Caps - can help here. Since we would add extended caps based
> on the mentioned check, it seems only valid to have that check before
> overwriting the configuration space.

The card is has PCIE support:

# lspci -v
[..]
01:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL8111/8168/8411 PCI
Express Gigabit Ethernet Controller (rev 06)
    Subsystem: TP-LINK Technologies Co., Ltd. TG-3468 Gigabit PCI Express Network
Adapter
    Flags: bus master, fast devsel, latency 0, IRQ 255
    I/O ports at 1000 [size=256]
    Memory at 40000000 (64-bit, non-prefetchable) [size=4K]
    Memory at 100000000 (64-bit, prefetchable) [size=16K]
    Capabilities: [40] Power Management version 3
    Capabilities: [50] MSI: Enable- Count=1/1 Maskable- 64bit+
    Capabilities: [70] Express Endpoint, MSI 01
    Capabilities: [b0] MSI-X: Enable- Count=4 Masked-
    Capabilities: [d0] Vital Product Data
    Capabilities: [100] Advanced Error Reporting
    Capabilities: [140] Virtual Channel
    Capabilities: [160] Device Serial Number d7-40-00-00-68-4c-e0-00

>
>>
>> It's also not clear to me what you are trying to achieve with this patch. Is there
>> a particular device that you want to get working? Or an entire class of devices
>> which have those features? If it's the former, you could have the size of the
>> config space write depend on the vendor + device id. If it's the latter, we could
>> key the size of the config space write based on the presence of those particular
>> PCIE caps and try and fix other devices if they break.
>
> Absolutely, we can check for the presence of PCI extended capabilities and based
> on that write the configuration space. If the device has issue with only a
> specific extended capability we can try to fix that by keying the DevID-VendorID
> pair? What do you think?

My preference would be to overwrite the extended configuration space only for
those devices that have at least of the PCIE capabilities that this patch adds. If
a device doesn't have neither of ATS, PRI or PASID, then kvmtool should not touch
the extended configuration space, similar to how it behaves today.

Thanks,

Alex

>
>>
>> Will, Andre, do you see other solutions? Do you have a preference?
>
> Will, Andre, please let me know as well if you have any preferences.
>
> Best regards
> Vivek
>
>>
>> Thanks,
>>
>> Alex
>>
>>>
>>> Best regards
>>> Vivek
>>>
>>>>
>>>> Thanks,
>>>>
>>>> Alex
>>>>
>>>>>        if (pwrite(vdev->fd, &pdev->hdr, hdr_sz, info->offset) != hdr_sz) {
>>>>>            vfio_dev_err(vdev, "failed to write %zd bytes to Config Space",
>>>>>                     hdr_sz);
