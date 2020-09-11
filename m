Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 728F226646D
	for <lists+kvm@lfdr.de>; Fri, 11 Sep 2020 18:38:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726552AbgIKQiU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Sep 2020 12:38:20 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:57996 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726193AbgIKPMQ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 11 Sep 2020 11:12:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599837121;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aiWmHLDD0Ad0LUM9I3Re3J2jS/emquPxE/7QtuwNOPg=;
        b=gxXCtIupESgbz961KIg5tC4lEmLWzKToPJBqqrL5WIchgdrsdUGifvttRW07oWQtkxCInS
        rLNv/SsI/azVsJHj2mLVsZ+cGXkEW22ym9M2v4+SkyUAF6rFPdvA9mj758sYLqEx90AtZp
        Jm+d0g8OSvLNiLA0hOM2YRmH5+4zdE8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-200-4NT_19gWN0K2miAueSjn9w-1; Fri, 11 Sep 2020 09:53:13 -0400
X-MC-Unique: 4NT_19gWN0K2miAueSjn9w-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 62D58CD046;
        Fri, 11 Sep 2020 13:53:12 +0000 (UTC)
Received: from [10.36.112.212] (ovpn-112-212.ams2.redhat.com [10.36.112.212])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 1B1135DA2A;
        Fri, 11 Sep 2020 13:53:00 +0000 (UTC)
Subject: Re: MSI/MSIX for VFIO platform
To:     Alex Williamson <alex.williamson@redhat.com>,
        Vikas Gupta <vikas.gupta@broadcom.com>
Cc:     Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Vikram Prakash <vikram.prakash@broadcom.com>,
        Srinath Mannam <srinath.mannam@broadcom.com>
References: <c94c36305980f80674aa699e27b9895b@mail.gmail.com>
 <20200910105735.1e060b95@w520.home>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <f9b3c805-cd64-3402-ff73-339c35c4c27a@redhat.com>
Date:   Fri, 11 Sep 2020 15:52:59 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200910105735.1e060b95@w520.home>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Vikas,

On 9/10/20 6:57 PM, Alex Williamson wrote:
> On Thu, 10 Sep 2020 16:15:27 +0530
> Vikas Gupta <vikas.gupta@broadcom.com> wrote:
> 
>> Hi Alex/Cornelia,
>>
>> We are looking for MSI interrupts for platform devices in user-space
>> applications via event/poll mechanism using VFIO.
>>
>> Since there is no support for MSI/MSIX handling in VFIO-platform in kernel,
>> it may not possible to get this feature in user-space.
>>
>> Is there any other way we can get this feature in user-space OR can you
>> please suggest if any patch or feature is in progress for same in VFIO
>> platform?
>>
>> Any suggestions would be helpful.
> 
> Eric (Cc'd) is the maintainer of vfio-platform.
> 
> vfio-platform devices don't have IRQ indexes dedicated to MSI and MSI-X
> like vfio-pci devices do (technically these are PCI concepts, but I
> assume we're referring generically to message signaled interrupts), but
> that's simply due to the lack of standardization in platform devices.
> Logically these are simply collections of edge triggered interrupts,
> which the vfio device API supports generically, it's simply a matter
> that the vfio bus driver exposing a vfio-platform device create an IRQ
> index exposing these vectors.  Thanks,

I have not worked on MSI support and I am not aware of any work
happening in this area.

First I would recommend to look at IRQ related uapis exposed by VFIO:
VFIO_DEVICE_GET_IRQ_INFO
VFIO_DEVICE_SET_IRQS

and try to understand if they can be implemented for MSIs in a generic
way in the vfio_platform driver using platform-msi helpers.

For instance VFIO_DEVICE_GET_IRQ_INFO would need to return the number of
requested vectors. On init I guess we should allocate vectors using
platform_msi_domain_alloc_irqs/ devm_request_irq and in the handler
trigger the eventfd provided through VFIO_DEVICE_SET_IRQS.

On userspace where you have to trap the MSI setup to call the above
functions and setup irqfd injection. This would be device specific as
opposed to PCI. That's just rough ideas at the moment.

Thanks

Eric

> 
> Alex
> 

