Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F6143A6A98
	for <lists+kvm@lfdr.de>; Mon, 14 Jun 2021 17:37:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233814AbhFNPjs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Jun 2021 11:39:48 -0400
Received: from foss.arm.com ([217.140.110.172]:39166 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233757AbhFNPjq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Jun 2021 11:39:46 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DFD381FB;
        Mon, 14 Jun 2021 08:37:43 -0700 (PDT)
Received: from [192.168.0.110] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E58DC3F70D;
        Mon, 14 Jun 2021 08:37:42 -0700 (PDT)
Subject: Re: [PATCH kvmtool 2/4] arm/fdt.c: Warn if MMIO device doesn't
 provide a node generator
To:     Andre Przywara <andre.przywara@arm.com>
Cc:     will@kernel.org, julien.thierry.kdev@gmail.com,
        kvm@vger.kernel.org, sami.mujawar@arm.com,
        lorenzo.pieralisi@arm.com, maz@kernel.org
References: <20210609183812.29596-1-alexandru.elisei@arm.com>
 <20210609183812.29596-3-alexandru.elisei@arm.com>
 <20210610171345.79919d7b@slackpad.fritz.box>
 <59cefe95-17ef-2ac3-8545-14ec38c0fbe4@arm.com>
 <20210614150757.7bde1f2e@slackpad.fritz.box>
From:   Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <a780e77f-f4fa-0ac6-eec2-c127567eae83@arm.com>
Date:   Mon, 14 Jun 2021 16:38:31 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210614150757.7bde1f2e@slackpad.fritz.box>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Andre,

On 6/14/21 3:07 PM, Andre Przywara wrote:
> On Thu, 10 Jun 2021 17:38:02 +0100
> Alexandru Elisei <alexandru.elisei@arm.com> wrote:
>
> Hi Alex,
>
>> On 6/10/21 5:13 PM, Andre Przywara wrote:
>>> On Wed,  9 Jun 2021 19:38:10 +0100
>>> Alexandru Elisei <alexandru.elisei@arm.com> wrote:
>>>  
>>>> Print a more helpful warning when a MMIO device hasn't set a function to
>>>> generate an FDT instead of causing a segmentation fault by dereferencing a
>>>> NULL pointer.  
>>> Not calling generate_mmio_fdt_nodes() if it's NULL is certainly a good
>>> idea, but how did you trigger it?  
>> I was able to trigger it when I was hacking a custom MMIO device emulation to test
>> some behaviour in KVM.
>>
>>> Because I am wondering whether every MMIO device needs to have an DT
>>> generator? And if that's not the case, a warning might be already too
>>> much.  
>> I don't know how the guest will be able to discover the device if it's not in the
>> DT, that's why I put the warning.
>> If there are devices which can be discovered by
>> the guest when they are missing from the DT, then I'll drop the warning.
> Well, not discovered, probably, but the guest (or parts of the guest,
> think EFI firmware) could have hard-coded knowledge about what to
> expect. That's what we did for the RTC and initially for the CFI flash.
> I agree it's not the best way to do (and we fixed both of those
> devices), but it's also nothing a *user* could do much about, so having a
> pr_debug() there seems more appropriate to me.

I think you're right, pr_debug() makes more sense here.

Thanks,

Alex

>
> Cheers,
> Andre
>
>>> So either just drop a print at all or use pr_info()/pr_debug()?
>>>
>>> Cheers,
>>> Andre
>>>  
>>>> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
>>>> ---
>>>>  arm/fdt.c | 7 ++++++-
>>>>  1 file changed, 6 insertions(+), 1 deletion(-)
>>>>
>>>> diff --git a/arm/fdt.c b/arm/fdt.c
>>>> index 02091e9e0bee..06287a13e395 100644
>>>> --- a/arm/fdt.c
>>>> +++ b/arm/fdt.c
>>>> @@ -171,7 +171,12 @@ static int setup_fdt(struct kvm *kvm)
>>>>  	dev_hdr = device__first_dev(DEVICE_BUS_MMIO);
>>>>  	while (dev_hdr) {
>>>>  		generate_mmio_fdt_nodes = dev_hdr->data;
>>>> -		generate_mmio_fdt_nodes(fdt, dev_hdr, generate_irq_prop);
>>>> +		if (generate_mmio_fdt_nodes) {
>>>> +			generate_mmio_fdt_nodes(fdt, dev_hdr, generate_irq_prop);
>>>> +		} else {
>>>> +			pr_warning("Missing FDT node generator for MMIO device %d",
>>>> +				   dev_hdr->dev_num);
>>>> +		}
>>>>  		dev_hdr = device__next_dev(dev_hdr);
>>>>  	}
>>>>    
