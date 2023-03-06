Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42A6E6ABA54
	for <lists+kvm@lfdr.de>; Mon,  6 Mar 2023 10:50:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230135AbjCFJuC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Mar 2023 04:50:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229536AbjCFJuB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Mar 2023 04:50:01 -0500
Received: from devnull.tasossah.com (devnull.tasossah.com [IPv6:2001:41d0:1:e60e::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C5FBE054
        for <kvm@vger.kernel.org>; Mon,  6 Mar 2023 01:49:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=devnull.tasossah.com; s=vps; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:Subject:References:Cc:To:From:MIME-Version:Date:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=YfaxxHoYrWnes5guy9eV8QXJlAX4ovDPjtoMZNEsnXY=; b=pCgSTS+joL76fiizFi5JsoMMkg
        ihZ0S9AP3dfvrrHnKeuvXcbbGI89ZDQlCdTDIFbUuXbhjipEbBkhZyAfJkIDkGWf8Jxm2L0wGXCsw
        a4eStAk3STtaxB1WtxKdAAMAMCFflihddhEa6QKDcdgEAew+ZF9FgiKfUti0RPqlOpCs=;
Received: from [2a02:587:6a02:3a00::298]
        by devnull.tasossah.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <tasos@tasossah.com>)
        id 1pZ7TY-00DC2O-2d; Mon, 06 Mar 2023 11:49:48 +0200
Message-ID: <bd4c9ca5-845e-80ef-962a-bf4a87f0632c@tasossah.com>
Date:   Mon, 6 Mar 2023 11:49:37 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
From:   Tasos Sahanidis <tasos@tasossah.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Abhishek Sahu <abhsahu@nvidia.com>, kvm@vger.kernel.org
References: <a01fa87d-bd42-e108-606b-78759edcecf8@tasossah.com>
 <bcc9d355-b464-7eaf-238c-e95d2f65c93d@nvidia.com>
 <31c2caf4-57b2-be1a-cf15-146903f7b2a1@tasossah.com>
 <20230228114606.446e8db2.alex.williamson@redhat.com>
 <7c1980ec-d032-11c1-b09d-4db40611f268@tasossah.com>
 <20230301071049.0f8f88ae.alex.williamson@redhat.com>
 <4c079c5a-f8e2-ce4d-a811-dc574f135cff@tasossah.com>
 <20230302133655.2966f2e3.alex.williamson@redhat.com>
 <5682fc52-d2a3-8fd9-47e8-eb12d5f87c57@tasossah.com>
 <20230303094110.79d34dab.alex.williamson@redhat.com>
Content-Language: en-US
Subject: Re: Bug: Completion-Wait loop timed out with vfio
In-Reply-To: <20230303094110.79d34dab.alex.williamson@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2023-03-03 18:41, Alex Williamson wrote:>>> But it suddenly dawns on
me that you're assigning a Radeon HD 7790,
>>> which is one of the many AMD GPUs which is plagued by reset problems.
>>> I wonder if that's a factor there.  This particular GPU even has
>>> special handling in QEMU to try to manually reset the device, and which
>>> likely has never been tested since adding runtime power management
>>> support.  In fact, I'm surprised anyone is doing regular device
>>> assignment with an HD 7790 and considers it a normal, acceptable
>>> experience even with the QEMU workarounds.  
>>
>> I had no idea. I always assumed that because it worked out of the box
>> ever since I first tried passing it through, it wasn't affected by these
>> reset issues. I never had any trouble with it until now.
> 
> IIRC, so long as the VM is always booting and cleanly shutting down,
> then the QEMU quirk is sufficient, but if you need to kill QEMU the GPU
> might be in a bad state that requires a host reboot to recover.
> 

I tried SIGKILLing QEMU a few times and the card kept working.

>>> I certainly wouldn't feel comfortable proposing a quirk for the
>>> downstream port to disable D3hot for an issue only seen when assigning
>>> a device with such a nefarious background relative to device
>>> assignment.  It does however seem like there are sufficient options in
>>> place to work around the issue, either disabling power management at
>>> the vfio-pci driver, or specifically for the downstream port via sysfs.
>>> I don't really have any better suggestions given our limited ability to
>>> test and highly suspect target device.  Any other ideas, Abhishek?
>>> Thanks,
>>>
>>> Alex  
>>
>> This actually gave me an idea on how to check if it's the graphics card
>> that's at fault, or if it is QEMU's workarounds.
>>
>> I booted up the system as usual and let vfio-pci take over the device.
>> Both the device itself and the PCIe port were at D3hot. I manually
>> forced the PCIe port to switch to D0, with the GPU remaining at D3hot. I
>> then proceeded to start up the VM, and there were no errors in dmesg.
>>
>> If it's even possible, it sounds like QEMU might be doing something
>> before the PCIe port is (fully?) out of D3hot, and thus the card tries
>> to do something which makes the IOMMU unhappy.
>>
>> Is there something in either the rpm trace, or elsewhere that can help
>> me dig into this further?
> 
> That's interesting to find.  There are quirks in the kernel that don't
> disable D3hot, but just extend the suspend/resume time.  If you're
> slightly comfortable with coding and building the kernel, you could try
> something like below.  With the level of information we have, I'd feel
> more comfortable only proposing to extend the resume time for the 7790
> and not the downstream port, but I've put both in below to play with.
> 
> You can comment out one of the DECLARE... lines to disable each.  The 20
> value here is in ms and I have no idea what it should be.  There are a
> couple quirks that use this 20ms value and a bunch of Intel device IDs
> set an equivalent value to 120ms.  Experiment and see if you can find
> something that works reliably.  Thanks,
> 
> Alex
> 
> diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
> index 44cab813bf95..d9ae376d9524 100644
> --- a/drivers/pci/quirks.c
> +++ b/drivers/pci/quirks.c
> @@ -1956,6 +1956,15 @@ DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_AMD, 0x15e0, quirk_ryzen_xhci_d3hot);
>  DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_AMD, 0x15e1, quirk_ryzen_xhci_d3hot);
>  DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_AMD, 0x1639, quirk_ryzen_xhci_d3hot);
>  
> +static void quirk_d3hot_test_delay(struct pci_dev *dev)
> +{
> +	quirk_d3hot_delay(dev, 20);
> +}
> +/* Radeon HD 7790 */
> +DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_ATI, 0x665c, quirk_d3hot_test_delay);
> +/* Matisse PCIe GPP Bridge Downstream Ports */
> +DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_AMD, 0x57a3, quirk_d3hot_test_delay);
> +
>  #ifdef CONFIG_X86_IO_APIC
>  static int dmi_disable_ioapicreroute(const struct dmi_system_id *d)
>  {
> 

The quirk on the downstream port changed nothing, which is both good and
bad I guess. The quirk on the 7790, when set to 120ms actually stopped
the error messages, but only when the VM was stopping. When the VM was
starting, the messages remained the same, which is puzzling. The delay
applies when going from D3 to D0, which happens when the VM starts, not
when it stops... I tried it as high as 500ms and nothing else changed.

I looked at QEMU's source, and I'll try both disabling the reset
temporarily, to see if the errors go away, and also adding some delays
in there in different areas (as there are a few already).

--
Tasos
