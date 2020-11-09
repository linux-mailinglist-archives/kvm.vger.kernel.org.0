Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 086562ABF8E
	for <lists+kvm@lfdr.de>; Mon,  9 Nov 2020 16:18:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731626AbgKIPSU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Nov 2020 10:18:20 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:24934 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729776AbgKIPST (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 9 Nov 2020 10:18:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604935097;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=w5enKsZSNWbgWd9sqRj4xxK6HKbx1Pcury6gxzpl2VM=;
        b=Hw5/cdlNaz6X3pipgVMyX3SCd1YLq3Ibi9D3362pwpWCTppK7mb52xqwdAD2gtC8ZnPzMb
        LI2DBPp6ZtHRdvxbYLkX6Clr4kz1LoPKosIyxKyWWOSLMticl9VS79oRCDrc2V8CNT1IFv
        bEa3Otp4IYE8qRJ2tboZEZM1nXtj6tI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-326-xfMPrt9PP7uOHDkprBj0xg-1; Mon, 09 Nov 2020 10:18:15 -0500
X-MC-Unique: xfMPrt9PP7uOHDkprBj0xg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 84ADA876E3D;
        Mon,  9 Nov 2020 15:18:14 +0000 (UTC)
Received: from [10.36.114.125] (ovpn-114-125.ams2.redhat.com [10.36.114.125])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 6F50C60BF1;
        Mon,  9 Nov 2020 15:18:09 +0000 (UTC)
Subject: Re: [RFC, v0 1/3] vfio/platform: add support for msi
To:     Vikas Gupta <vikas.gupta@broadcom.com>,
        Alex Williamson <alex.williamson@redhat.com>
Cc:     Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Vikram Prakash <vikram.prakash@broadcom.com>
References: <20201105060257.35269-1-vikas.gupta@broadcom.com>
 <20201105060257.35269-2-vikas.gupta@broadcom.com>
 <20201105000806.1df16656@x1.home>
 <CAHLZf_vyn1RKEsQWcd7=M1462F2hurSvE37aW3b+1QvFAnBTPQ@mail.gmail.com>
 <20201105201208.5366d71e@x1.home>
 <CAHLZf_uan_nbewxRgTtbkAAk1rGAggq_3Z4EgtRqsPryt58eOw@mail.gmail.com>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <eec028cb-6c80-4560-e138-2b567f821a5c@redhat.com>
Date:   Mon, 9 Nov 2020 16:18:07 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <CAHLZf_uan_nbewxRgTtbkAAk1rGAggq_3Z4EgtRqsPryt58eOw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Vikas,

On 11/9/20 7:41 AM, Vikas Gupta wrote:
> Hi Alex,
> 
> On Fri, Nov 6, 2020 at 8:42 AM Alex Williamson
> <alex.williamson@redhat.com> wrote:
>>
>> On Fri, 6 Nov 2020 08:24:26 +0530
>> Vikas Gupta <vikas.gupta@broadcom.com> wrote:
>>
>>> Hi Alex,
>>>
>>> On Thu, Nov 5, 2020 at 12:38 PM Alex Williamson
>>> <alex.williamson@redhat.com> wrote:
>>>>
>>>> On Thu,  5 Nov 2020 11:32:55 +0530
>>>> Vikas Gupta <vikas.gupta@broadcom.com> wrote:
>>>>
>>>>> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
>>>>> index 2f313a238a8f..aab051e8338d 100644
>>>>> --- a/include/uapi/linux/vfio.h
>>>>> +++ b/include/uapi/linux/vfio.h
>>>>> @@ -203,6 +203,7 @@ struct vfio_device_info {
>>>>>  #define VFIO_DEVICE_FLAGS_AP (1 << 5)        /* vfio-ap device */
>>>>>  #define VFIO_DEVICE_FLAGS_FSL_MC (1 << 6)    /* vfio-fsl-mc device */
>>>>>  #define VFIO_DEVICE_FLAGS_CAPS       (1 << 7)        /* Info supports caps */
>>>>> +#define VFIO_DEVICE_FLAGS_MSI        (1 << 8)        /* Device supports msi */
>>>>>       __u32   num_regions;    /* Max region index + 1 */
>>>>>       __u32   num_irqs;       /* Max IRQ index + 1 */
>>>>>       __u32   cap_offset;     /* Offset within info struct of first cap */
>>>>
>>>> This doesn't make any sense to me, MSIs are just edge triggered
>>>> interrupts to userspace, so why isn't this fully described via
>>>> VFIO_DEVICE_GET_IRQ_INFO?  If we do need something new to describe it,
>>>> this seems incomplete, which indexes are MSI (IRQ_INFO can describe
>>>> that)?  We also already support MSI with vfio-pci, so a global flag for
>>>> the device advertising this still seems wrong.  Thanks,
>>>>
>>>> Alex
>>>>
>>> Since VFIO platform uses indexes for IRQ numbers so I think MSI(s)
>>> cannot be described using indexes.
>>
>> That would be news for vfio-pci which has been describing MSIs with
>> sub-indexes within indexes since vfio started.
>>
>>> In the patch set there is no difference between MSI and normal
>>> interrupt for VFIO_DEVICE_GET_IRQ_INFO.
>>
>> Then what exactly is a global device flag indicating?  Does it indicate
>> all IRQs are MSI?
> 
> No, it's not indicating that all are MSI.
> The rationale behind adding the flag to tell user-space that platform
> device supports MSI as well. As you mentioned recently added
> capabilities can help on this, I`ll go through that.
> 
>>
>>> The patch set adds MSI(s), say as an extension, to the normal
>>> interrupts and handled accordingly.
>>
>> So we have both "normal" IRQs and MSIs?  How does the user know which
>> indexes are which?
> 
> With this patch set, I think this is missing and user space cannot
> know that particular index is MSI interrupt.
> For platform devices there is no such mechanism, like index and
> sub-indexes to differentiate between legacy, MSI or MSIX as it’s there
> in PCI.
Wht can't you use the count field (as per vfio_pci_get_irq_count())?
> I believe for a particular IRQ index if the flag
> VFIO_IRQ_INFO_NORESIZE is used then user space can know which IRQ
> index has MSI(s). Does it make sense?
I don't think it is the same semantics.

Thanks

Eric
> Suggestions on this would be helpful.
> 
> Thanks,
> Vikas
>>
>>> Do you see this is a violation? If
>>
>> Seems pretty unclear and dubious use of a global device flag.
>>
>>> yes, then we`ll think of other possible ways to support MSI for the
>>> platform devices.
>>> Macro VFIO_DEVICE_FLAGS_MSI can be changed to any other name if it
>>> collides with an already supported vfio-pci or if not necessary, we
>>> can remove this flag.
>>
>> If nothing else you're using a global flag to describe a platform
>> device specific augmentation.  We've recently added capabilities on the
>> device info return that would be more appropriate for this, but
>> fundamentally I don't understand why the irq info isn't sufficient.
>> Thanks,
>>
>> Alex
>>

