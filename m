Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 39F2617E2C4
	for <lists+kvm@lfdr.de>; Mon,  9 Mar 2020 15:54:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726784AbgCIOyJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Mar 2020 10:54:09 -0400
Received: from foss.arm.com ([217.140.110.172]:53420 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726439AbgCIOyJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Mar 2020 10:54:09 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0280230E;
        Mon,  9 Mar 2020 07:54:09 -0700 (PDT)
Received: from [10.1.196.63] (e123195-lin.cambridge.arm.com [10.1.196.63])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0EA523F6CF;
        Mon,  9 Mar 2020 07:54:07 -0700 (PDT)
Subject: Re: [PATCH v2 kvmtool 26/30] pci: Toggle BAR I/O and memory space
 emulation
To:     Andre Przywara <andre.przywara@arm.com>
Cc:     kvm@vger.kernel.org, will@kernel.org,
        julien.thierry.kdev@gmail.com, sami.mujawar@arm.com,
        lorenzo.pieralisi@arm.com, maz@kernel.org
References: <20200123134805.1993-1-alexandru.elisei@arm.com>
 <20200123134805.1993-27-alexandru.elisei@arm.com>
 <20200206182137.48894a54@donnerap.cambridge.arm.com>
 <2d14a067-7d7c-d7b4-90f3-72f5778a2fec@arm.com>
 <20200207113619.26c11a24@donnerap.cambridge.arm.com>
From:   Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <d4528925-7fa8-115b-3197-9a7c524f447d@arm.com>
Date:   Mon, 9 Mar 2020 14:54:06 +0000
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20200207113619.26c11a24@donnerap.cambridge.arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On 2/7/20 11:36 AM, Andre Przywara wrote:
> On Fri, 7 Feb 2020 11:08:19 +0000
> Alexandru Elisei <alexandru.elisei@arm.com> wrote:
>
> Hi,
>
>> On 2/6/20 6:21 PM, Andre Przywara wrote:
>>> On Thu, 23 Jan 2020 13:48:01 +0000
>>> Alexandru Elisei <alexandru.elisei@arm.com> wrote:
>>>
>>> Hi,
>>>  
>>>> During configuration of the BAR addresses, a Linux guest disables and
>>>> enables access to I/O and memory space. When access is disabled, we don't
>>>> stop emulating the memory regions described by the BARs. Now that we have
>>>> callbacks for activating and deactivating emulation for a BAR region,
>>>> let's use that to stop emulation when access is disabled, and
>>>> re-activate it when access is re-enabled.
>>>>
>>>> The vesa emulation hasn't been designed with toggling on and off in
>>>> mind, so refuse writes to the PCI command register that disable memory
>>>> or IO access.
>>>>
>>>> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
>>>> ---
>>>>  hw/vesa.c | 16 ++++++++++++++++
>>>>  pci.c     | 42 ++++++++++++++++++++++++++++++++++++++++++
>>>>  2 files changed, 58 insertions(+)
>>>>
>>>> diff --git a/hw/vesa.c b/hw/vesa.c
>>>> index 74ebebbefa6b..3044a86078fb 100644
>>>> --- a/hw/vesa.c
>>>> +++ b/hw/vesa.c
>>>> @@ -81,6 +81,18 @@ static int vesa__bar_deactivate(struct kvm *kvm,
>>>>  	return -EINVAL;
>>>>  }
>>>>  
>>>> +static void vesa__pci_cfg_write(struct kvm *kvm, struct pci_device_header *pci_hdr,
>>>> +				u8 offset, void *data, int sz)
>>>> +{
>>>> +	u32 value;  
>>> I guess the same comment as on the other patch applies: using u64 looks safer to me. Also you should clear it, to avoid nasty surprises in case of a short write (1 or 2 bytes only).  
>> I was under the impression that the maximum size for a write to the PCI CAM or
>> ECAM space is 32 bits. This is certainly what I've seen when running Linux, and
>> the assumption in the PCI emulation code which has been working since 2010. I'm
>> trying to dig out more information about this.
>>
>> If it's not, then we have a bigger problem because the PCI emulation code doesn't
>> support it, and to account for it we would need to add a certain amount of logic
>> to the code to deal with it: what if a write hits the command register and another
>> adjacent register? what if a write hits two BARs? A BAR and a regular register
>> before/after it? Part of a BAR and two registers before/after? You can see where
>> this is going.
>>
>> Until we find exactly where in a PCI spec says that 64 bit writes to the
>> configuration space are allowed, I would rather avoid all this complexity and
>> assume that the guest is sane and will only write 32 bit values.
> I don't think it's allowed, but that's not the point here:
> If a (malicious?) guest does a 64-bit write, it will overwrite kvmtool's stack. We should not allow that. We don't need to behave correctly, but the guest should not be able to affect the host (VMM). All it should take is to have "u64 value = 0;" to fix that.

Did a lot of digging about this. From PCI Local Bus 3.0, section 3.8:

"The bandwidth requirements for I/O and *configuration* transactions cannot
justify the added complexity, and, therefore, only memory transactions support
64-bit data transfers" (emphasis added).

So 64-bit data transfers are *not* allowed for configuration space accesses.

From PCI Express Base Specification Revision 1.1, section 7.2.2:

"Because Root Complex implementations are not required to support the generation
of Configuration Requests from memory space accesses that cross DW boundaries, or
that use locked semantics, software should take care not to cause the generation
of such requests when using the memory-mapped configuration access mechanism
unless it is known that the Root Complex implementation being used will support
the translation"

So the PCI Express spec clearly states that only particular implementations
support 64-bit accesses to the configuration space; not generic implementations.

I'll modify the PCI emulation layer to forbid accesses wider than 32-bit.

Thanks,
Alex
