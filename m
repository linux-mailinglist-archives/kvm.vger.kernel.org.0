Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D16C22ABF64
	for <lists+kvm@lfdr.de>; Mon,  9 Nov 2020 16:06:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731258AbgKIPGA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Nov 2020 10:06:00 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:30572 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730892AbgKIPFO (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 9 Nov 2020 10:05:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604934313;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hQQ4XbiqE85iPIRFWzo/hV4LN32LEkjf6ushyTGemPM=;
        b=cmoy4xwpKq5NWAr3TGqfxEVpLvu1cqImEF8FjrcOwGzidWptcSyPhH9LGuc/FPjYJ3N14+
        Ne3GSXzz11iAuwUSnsND1AC+dDvswWnM161FVTYxUQRxwE+AQh6BbA/1sXcc9b7SPrL1+l
        6ufUBlldUKeX3ug4cuMzhr+sOv2sUys=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-59-v8p-37KYNo-v1yHp0uLZIg-1; Mon, 09 Nov 2020 10:05:11 -0500
X-MC-Unique: v8p-37KYNo-v1yHp0uLZIg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 069F26D581;
        Mon,  9 Nov 2020 15:05:10 +0000 (UTC)
Received: from [10.36.114.125] (ovpn-114-125.ams2.redhat.com [10.36.114.125])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 9C53C1002C0E;
        Mon,  9 Nov 2020 15:05:04 +0000 (UTC)
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
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <add3a419-dc88-871b-6afa-7fe57aefc597@redhat.com>
Date:   Mon, 9 Nov 2020 16:05:02 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <CAHLZf_vyn1RKEsQWcd7=M1462F2hurSvE37aW3b+1QvFAnBTPQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Vikas,

On 11/6/20 3:54 AM, Vikas Gupta wrote:
> Hi Alex,
> 
> On Thu, Nov 5, 2020 at 12:38 PM Alex Williamson
> <alex.williamson@redhat.com> wrote:
>>
>> On Thu,  5 Nov 2020 11:32:55 +0530
>> Vikas Gupta <vikas.gupta@broadcom.com> wrote:
>>
>>> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
>>> index 2f313a238a8f..aab051e8338d 100644
>>> --- a/include/uapi/linux/vfio.h
>>> +++ b/include/uapi/linux/vfio.h
>>> @@ -203,6 +203,7 @@ struct vfio_device_info {
>>>  #define VFIO_DEVICE_FLAGS_AP (1 << 5)        /* vfio-ap device */
>>>  #define VFIO_DEVICE_FLAGS_FSL_MC (1 << 6)    /* vfio-fsl-mc device */
>>>  #define VFIO_DEVICE_FLAGS_CAPS       (1 << 7)        /* Info supports caps */
>>> +#define VFIO_DEVICE_FLAGS_MSI        (1 << 8)        /* Device supports msi */
>>>       __u32   num_regions;    /* Max region index + 1 */
>>>       __u32   num_irqs;       /* Max IRQ index + 1 */
>>>       __u32   cap_offset;     /* Offset within info struct of first cap */
>>
>> This doesn't make any sense to me, MSIs are just edge triggered
>> interrupts to userspace, so why isn't this fully described via
>> VFIO_DEVICE_GET_IRQ_INFO?  If we do need something new to describe it,
>> this seems incomplete, which indexes are MSI (IRQ_INFO can describe
>> that)?  We also already support MSI with vfio-pci, so a global flag for
>> the device advertising this still seems wrong.  Thanks,
>>
>> Alex
>>
> Since VFIO platform uses indexes for IRQ numbers so I think MSI(s)
> cannot be described using indexes.
> In the patch set there is no difference between MSI and normal
> interrupt for VFIO_DEVICE_GET_IRQ_INFO.
in vfio_platform_irq_init() we first iterate on normal interrupts using
get_irq(). Can't we add an MSI index at the end of this list with
vdev->irqs[i].count > 1 and set vdev->num_irqs accordingly?

Thanks

Eric
> The patch set adds MSI(s), say as an extension, to the normal
> interrupts and handled accordingly. Do you see this is a violation? If
> yes, then we`ll think of other possible ways to support MSI for the
> platform devices.
> Macro VFIO_DEVICE_FLAGS_MSI can be changed to any other name if it
> collides with an already supported vfio-pci or if not necessary, we
> can remove this flag.
> 
> Thanks,
> Vikas
> 

