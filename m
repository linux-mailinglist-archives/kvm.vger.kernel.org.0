Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1ED3F39BD8A
	for <lists+kvm@lfdr.de>; Fri,  4 Jun 2021 18:46:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230468AbhFDQrs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Jun 2021 12:47:48 -0400
Received: from foss.arm.com ([217.140.110.172]:43104 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229864AbhFDQrs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Jun 2021 12:47:48 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5A5D51063;
        Fri,  4 Jun 2021 09:46:01 -0700 (PDT)
Received: from [192.168.0.110] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 7A59D3F73D;
        Fri,  4 Jun 2021 09:46:00 -0700 (PDT)
Subject: Re: [PATCH v3 kvmtool 32/32] arm/arm64: Add PCI Express 1.1 support
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     =?UTF-8?Q?Andr=c3=a9_Przywara?= <andre.przywara@arm.com>,
        kvm@vger.kernel.org
Cc:     will@kernel.org, julien.thierry.kdev@gmail.com,
        sami.mujawar@arm.com, lorenzo.pieralisi@arm.com
References: <20200326152438.6218-1-alexandru.elisei@arm.com>
 <20200326152438.6218-33-alexandru.elisei@arm.com>
 <2b963524-3153-fc95-7bf2-b60852ea2f22@arm.com>
 <f1e6746f-6196-a687-f3c5-78a08df31205@arm.com>
 <d1e018e7-f443-2710-a00d-e570652d569a@arm.com>
 <4f8dfda1-4a64-e2fb-4e93-3979e037599d@arm.com>
 <87575228-33b0-96cf-13d6-3499ce107020@arm.com>
 <51a2c089-28fd-2371-14ae-1f3dd024aa5a@arm.com>
Message-ID: <41a1ad1e-49d2-ed3a-e2c5-1caf89a3a258@arm.com>
Date:   Fri, 4 Jun 2021 17:46:50 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <51a2c089-28fd-2371-14ae-1f3dd024aa5a@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Andre,

On 5/13/20 3:42 PM, Alexandru Elisei wrote:
> Hi,
>
> On 5/13/20 9:17 AM, André Przywara wrote:
>> On 12/05/2020 16:44, Alexandru Elisei wrote:
>>
>> Hi,
>>
>>> On 5/12/20 3:17 PM, André Przywara wrote:
>>>> On 06/05/2020 14:51, Alexandru Elisei wrote:
>>>>
>>>> Hi,
>>>>
>>>>> On 4/6/20 3:06 PM, André Przywara wrote:
>>>>> [..]
>>>>>> Actually, looking closer: why do we need this in the first place? I
>>>>>> removed this and struct pm_cap, and it still compiles.
>>>>>> So can we lose those two structures at all? And move the discussion and
>>>>>> implementation (for VirtIO 1.0?) to a later series?
>>>>> I've answered both points in v2 of the series [1].
>>>>>
>>>>> [1] https://www.spinics.net/lists/kvm/msg209601.html:
>>>> From there:
>>>>>> But more importantly: Do we actually need those definitions? We
>>>>>> don't seem to use them, do we?
>>>>>> And the u8 __pad[PCI_DEV_CFG_SIZE] below should provide the extended
>>>>>> storage space a guest would expect?
>>>>> Yes, we don't use them for the reasons I explained in the commit
>>>>> message. I would rather keep them, because they are required by the
>>>>> PCIE spec.
>>>> I don't get the point of adding code / data structures that we don't
>>>> need, especially if it has issues. I understand it's mandatory as per
>>>> the spec, but just adding a struct here doesn't fix this or makes this
>>>> better.
>>> Sure, I can remove the unused structs, especially if they have issues. But I don't
>>> see what issues they have, would you mind expanding on that?
>> The best code is the one not written. ;-)
> Truer words were never spoken.
>
> That settles it then, I'll remove the unused structs.

Coming back to this. Without the PCIE capability, Linux will incorrectly set the
size of the PCI configuration space for a device to the legacy PCI size (256 bytes
instead of 4096). This is done in drivers/pci/probe.c::pci_setup_device, where
dev->cfg_size = pci_cfg_size(dev). And pci_cfg_size() is:

int pci_cfg_space_size(struct pci_dev *dev)
{
    int pos;
    u32 status;
    u16 class;

#ifdef CONFIG_PCI_IOV
    /*
     * Per the SR-IOV specification (rev 1.1, sec 3.5), VFs are required to
     * implement a PCIe capability and therefore must implement extended
     * config space.  We can skip the NO_EXTCFG test below and the
     * reachability/aliasing test in pci_cfg_space_size_ext() by virtue of
     * the fact that the SR-IOV capability on the PF resides in extended
     * config space and must be accessible and non-aliased to have enabled
     * support for this VF.  This is a micro performance optimization for
     * systems supporting many VFs.
     */
    if (dev->is_virtfn)
        return PCI_CFG_SPACE_EXP_SIZE;
#endif

    if (dev->bus->bus_flags & PCI_BUS_FLAGS_NO_EXTCFG)
        return PCI_CFG_SPACE_SIZE;

    class = dev->class >> 8;
    if (class == PCI_CLASS_BRIDGE_HOST)
        return pci_cfg_space_size_ext(dev);

    if (pci_is_pcie(dev))
        return pci_cfg_space_size_ext(dev);

    pos = pci_find_capability(dev, PCI_CAP_ID_PCIX);
    if (!pos)
        return PCI_CFG_SPACE_SIZE;

    pci_read_config_dword(dev, pos + PCI_X_STATUS, &status);
    if (status & (PCI_X_STATUS_266MHZ | PCI_X_STATUS_533MHZ))
        return pci_cfg_space_size_ext(dev);

    return PCI_CFG_SPACE_SIZE;
}

And pci_is_pcie(dev) returns true if the device has a valid PCIE capability.

Why do we care? The RTL8168 driver checks if the NIC is PCIE capable, and if not
it prints the error message below and falls back to another (proprietary?) method
of device configuration (in
drivers/net/ethernet/realtek/r8169_main.c::rtl_csi_access_enable):

[    1.490530] r8169 0000:00:00.0 enp0s0: No native access to PCI extended config
space, falling back to CSI
[    1.500201] r8169 0000:00:00.0 enp0s0: Link is Down

I'll keep the PCIE cap and drop the power management cap.

Thanks,

Alex

