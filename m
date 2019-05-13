Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6EA3C1B3BB
	for <lists+kvm@lfdr.de>; Mon, 13 May 2019 12:15:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728351AbfEMKPN convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Mon, 13 May 2019 06:15:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57242 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727272AbfEMKPN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 May 2019 06:15:13 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 78CDF3082B4D;
        Mon, 13 May 2019 10:15:12 +0000 (UTC)
Received: from gondolin (dhcp-192-222.str.redhat.com [10.33.192.222])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BD17560BEC;
        Mon, 13 May 2019 10:15:04 +0000 (UTC)
Date:   Mon, 13 May 2019 12:15:02 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Pierre Morel <pmorel@linux.ibm.com>
Cc:     Halil Pasic <pasic@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Sebastian Ott <sebott@linux.ibm.com>,
        virtualization@lists.linux-foundation.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Christoph Hellwig <hch@infradead.org>,
        Thomas Huth <thuth@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Viktor Mihajlovski <mihajlov@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Farhan Ali <alifm@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>
Subject: Re: [PATCH 08/10] virtio/s390: add indirection to indicators access
Message-ID: <20190513121502.34d3dc62.cohuck@redhat.com>
In-Reply-To: <89074bc5-78ee-a2e3-0546-791a465f83bd@linux.ibm.com>
References: <20190426183245.37939-1-pasic@linux.ibm.com>
        <20190426183245.37939-9-pasic@linux.ibm.com>
        <716d47ca-016f-e8f4-6d78-7746a7d9f6ba@linux.ibm.com>
        <a4bf1976-8037-63bb-2cf6-c389edbd2e89@linux.ibm.com>
        <20190509202600.4fd6aebe.pasic@linux.ibm.com>
        <c1e03cf0-3773-de00-10ae-d092ffe7ccc5@linux.ibm.com>
        <20190510135421.5363f14a.pasic@linux.ibm.com>
        <89074bc5-78ee-a2e3-0546-791a465f83bd@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.45]); Mon, 13 May 2019 10:15:12 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 10 May 2019 17:36:05 +0200
Pierre Morel <pmorel@linux.ibm.com> wrote:

> On 10/05/2019 13:54, Halil Pasic wrote:
> > On Fri, 10 May 2019 09:43:08 +0200
> > Pierre Morel <pmorel@linux.ibm.com> wrote:
> >   
> >> On 09/05/2019 20:26, Halil Pasic wrote:  
> >>> On Thu, 9 May 2019 14:01:01 +0200
> >>> Pierre Morel <pmorel@linux.ibm.com> wrote:
> >>>  
> >>>> On 08/05/2019 16:31, Pierre Morel wrote:  
> >>>>> On 26/04/2019 20:32, Halil Pasic wrote:  
> >>>>>> This will come in handy soon when we pull out the indicators from
> >>>>>> virtio_ccw_device to a memory area that is shared with the hypervisor
> >>>>>> (in particular for protected virtualization guests).
> >>>>>>
> >>>>>> Signed-off-by: Halil Pasic <pasic@linux.ibm.com>
> >>>>>> ---
> >>>>>>     drivers/s390/virtio/virtio_ccw.c | 40
> >>>>>> +++++++++++++++++++++++++---------------
> >>>>>>     1 file changed, 25 insertions(+), 15 deletions(-)
> >>>>>>
> >>>>>> diff --git a/drivers/s390/virtio/virtio_ccw.c
> >>>>>> b/drivers/s390/virtio/virtio_ccw.c
> >>>>>> index bb7a92316fc8..1f3e7d56924f 100644
> >>>>>> --- a/drivers/s390/virtio/virtio_ccw.c
> >>>>>> +++ b/drivers/s390/virtio/virtio_ccw.c
> >>>>>> @@ -68,6 +68,16 @@ struct virtio_ccw_device {
> >>>>>>         void *airq_info;
> >>>>>>     };
> >>>>>> +static inline unsigned long *indicators(struct virtio_ccw_device *vcdev)
> >>>>>> +{
> >>>>>> +    return &vcdev->indicators;
> >>>>>> +}
> >>>>>> +
> >>>>>> +static inline unsigned long *indicators2(struct virtio_ccw_device
> >>>>>> *vcdev)
> >>>>>> +{
> >>>>>> +    return &vcdev->indicators2;
> >>>>>> +}
> >>>>>> +
> >>>>>>     struct vq_info_block_legacy {
> >>>>>>         __u64 queue;
> >>>>>>         __u32 align;
> >>>>>> @@ -337,17 +347,17 @@ static void virtio_ccw_drop_indicator(struct
> >>>>>> virtio_ccw_device *vcdev,
> >>>>>>             ccw->cda = (__u32)(unsigned long) thinint_area;
> >>>>>>         } else {
> >>>>>>             /* payload is the address of the indicators */
> >>>>>> -        indicatorp = kmalloc(sizeof(&vcdev->indicators),
> >>>>>> +        indicatorp = kmalloc(sizeof(indicators(vcdev)),
> >>>>>>                          GFP_DMA | GFP_KERNEL);
> >>>>>>             if (!indicatorp)
> >>>>>>                 return;
> >>>>>>             *indicatorp = 0;
> >>>>>>             ccw->cmd_code = CCW_CMD_SET_IND;
> >>>>>> -        ccw->count = sizeof(&vcdev->indicators);
> >>>>>> +        ccw->count = sizeof(indicators(vcdev));  
> >>>>>
> >>>>> This looks strange to me. Was already weird before.
> >>>>> Lucky we are indicators are long...
> >>>>> may be just sizeof(long)  
> >>>>  
> >>>
> >>> I'm not sure I understand where are you coming from...
> >>>
> >>> With CCW_CMD_SET_IND we tell the hypervisor the guest physical address
> >>> at which the so called classic indicators. There is a comment that
> >>> makes this obvious. The argument of the sizeof was and remained a
> >>> pointer type. AFAIU this is what bothers you.  
> >>>>
> >>>> AFAIK the size of the indicators (AIV/AIS) is not restricted by the
> >>>> architecture.  
> >>>
> >>> The size of vcdev->indicators is restricted or defined by the virtio
> >>> specification. Please have a look at '4.3.2.6.1 Setting Up Classic Queue
> >>> Indicators' here:
> >>> https://docs.oasis-open.org/virtio/virtio/v1.1/cs01/virtio-v1.1-cs01.html#x1-1630002
> >>>
> >>> Since with Linux on s390 only 64 bit is supported, both the sizes are in
> >>> line with the specification. Using u64 would semantically match the spec
> >>> better, modulo pre virtio 1.0 which ain't specified. I did not want to
> >>> do changes that are not necessary for what I'm trying to accomplish. If
> >>> we want we can change these to u64 with a patch on top.  
> >>
> >> I mean you are changing these line already, so why not doing it right
> >> while at it?
> >>  
> > 
> > This patch is about adding the indirection so we can move the member
> > painlessly. Mixing in different stuff would be a bad practice.
> > 
> > BTW I just explained that it ain't wrong, so I really do not understand
> > what do you mean by  'why not doing it right'. Can you please explain?
> >   
> 
> I did not wanted to discuss a long time on this and gave my R-B, so 
> meaning that I am OK with this patch.
> 
> But if you ask, yes I can, it seems quite obvious.
> When you build a CCW you give the pointer to CCW->cda and you give the 
> size of the transfer in CCW->count.
> 
> Here the count is initialized with the sizeof of the pointer used to 
> initialize CCW->cda with.

But the cda points to the pointer address, so the size of the pointer
is actually the correct value here, isn't it?

> Lukily we work on a 64 bits machine with 64 bits pointers and the size 
> of the pointed object is 64 bits wide so... the resulting count is right.
> But it is not the correct way to do it.

I think it is, but this interface really is confusing.

> That is all. Not a big concern, you do not need to change it, as you 
> said it can be done in another patch.
> 
> > Did you agree with the rest of my comment? I mean there was more to it.
> >   
> 
> I understood from your comments that the indicators in Linux are 64bits 
> wide so all OK.
> 
> Regards
> Pierre
> 
> 
> 
> 
> 
> 

