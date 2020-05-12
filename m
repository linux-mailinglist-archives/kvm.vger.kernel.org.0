Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1C731CF981
	for <lists+kvm@lfdr.de>; Tue, 12 May 2020 17:43:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728181AbgELPnm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 May 2020 11:43:42 -0400
Received: from foss.arm.com ([217.140.110.172]:57456 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726388AbgELPnm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 May 2020 11:43:42 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C77B81FB;
        Tue, 12 May 2020 08:43:41 -0700 (PDT)
Received: from [192.168.0.110] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 020993F305;
        Tue, 12 May 2020 08:43:40 -0700 (PDT)
Subject: Re: [PATCH v3 kvmtool 32/32] arm/arm64: Add PCI Express 1.1 support
To:     =?UTF-8?Q?Andr=c3=a9_Przywara?= <andre.przywara@arm.com>,
        kvm@vger.kernel.org
Cc:     will@kernel.org, julien.thierry.kdev@gmail.com,
        sami.mujawar@arm.com, lorenzo.pieralisi@arm.com
References: <20200326152438.6218-1-alexandru.elisei@arm.com>
 <20200326152438.6218-33-alexandru.elisei@arm.com>
 <2b963524-3153-fc95-7bf2-b60852ea2f22@arm.com>
 <f1e6746f-6196-a687-f3c5-78a08df31205@arm.com>
 <d1e018e7-f443-2710-a00d-e570652d569a@arm.com>
From:   Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <4f8dfda1-4a64-e2fb-4e93-3979e037599d@arm.com>
Date:   Tue, 12 May 2020 16:44:14 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <d1e018e7-f443-2710-a00d-e570652d569a@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On 5/12/20 3:17 PM, André Przywara wrote:
> On 06/05/2020 14:51, Alexandru Elisei wrote:
>
> Hi,
>
>> On 4/6/20 3:06 PM, André Przywara wrote:
>>> On 26/03/2020 15:24, Alexandru Elisei wrote:
>>>
>>>>  
>>>>  union pci_config_address {
>>>>  	struct {
>>>> @@ -58,6 +91,8 @@ union pci_config_address {
>>>>  	};
>>>>  	u32 w;
>>>>  };
>>>> +#endif
>>>> +#define PCI_DEV_CFG_MASK	(PCI_DEV_CFG_SIZE - 1)
>>>>  
>>>>  struct msix_table {
>>>>  	struct msi_msg msg;
>>>> @@ -100,6 +135,33 @@ struct pci_cap_hdr {
>>>>  	u8	next;
>>>>  };
>>>>  
>>>> +struct pcie_cap {
>>> I guess this is meant to map to the PCI Express Capability Structure as
>>> described in the PCIe spec?
>>> We would need to add the "packed" attribute then. But actually I am not
>>> a fan of using C language constructs to model specified register
>>> arrangements, the kernel tries to avoid this as well.
>> I'm not sure what you are suggesting. Should we rewrite the entire PCI emulation
>> code in kvmtool then?
> At least not add more of that problematic code, especially if we don't

I don't see why how the code is problematic. Did I miss it in a previous comment?

> need it. Maybe there is a better solution for the operations we will
> need (byte array?), that's hard to say without seeing the code.
>
>>> Actually, looking closer: why do we need this in the first place? I
>>> removed this and struct pm_cap, and it still compiles.
>>> So can we lose those two structures at all? And move the discussion and
>>> implementation (for VirtIO 1.0?) to a later series?
>> I've answered both points in v2 of the series [1].
>>
>> [1] https://www.spinics.net/lists/kvm/msg209601.html:
> From there:
>>> But more importantly: Do we actually need those definitions? We
>>> don't seem to use them, do we?
>>> And the u8 __pad[PCI_DEV_CFG_SIZE] below should provide the extended
>>> storage space a guest would expect?
>> Yes, we don't use them for the reasons I explained in the commit
>> message. I would rather keep them, because they are required by the
>> PCIE spec.
> I don't get the point of adding code / data structures that we don't
> need, especially if it has issues. I understand it's mandatory as per
> the spec, but just adding a struct here doesn't fix this or makes this
> better.

Sure, I can remove the unused structs, especially if they have issues. But I don't
see what issues they have, would you mind expanding on that?

Thanks,
Alex
