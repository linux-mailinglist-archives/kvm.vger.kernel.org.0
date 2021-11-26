Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4444245EE5F
	for <lists+kvm@lfdr.de>; Fri, 26 Nov 2021 13:58:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377582AbhKZNBv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Nov 2021 08:01:51 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:30424 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236936AbhKZM7v (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 26 Nov 2021 07:59:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637931398;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=PBR/JoAE9YRQbNyaEYhmaAUlpZ7nooARgOBN0g29slU=;
        b=JgJah1w702VqL9UmAkz7QtURTrmaP0X6YEJbi7RFst7mmZTYB2Au9z0nTsJdv0GkGbZhyL
        q1uiQm8rqnRch2Ab/IR3qkiAUwLCcbRPAQXN1DufPB3YhgcWoPckkEh4w+5e156KO6IWS2
        yngkR0jLqST9YQPT3B5Z7OcLCEkEZYo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-515-dyww8ts1NmiwH5wU-cnopw-1; Fri, 26 Nov 2021 07:56:35 -0500
X-MC-Unique: dyww8ts1NmiwH5wU-cnopw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7F3CA100C609;
        Fri, 26 Nov 2021 12:56:33 +0000 (UTC)
Received: from localhost (unknown [10.39.193.82])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 3D6F96C350;
        Fri, 26 Nov 2021 12:56:28 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
        kvm@vger.kernel.org, Kirti Wankhede <kwankhede@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
        Yishai Hadas <yishaih@nvidia.com>
Subject: Re: [PATCH RFC] vfio: Documentation for the migration region
In-Reply-To: <20211125161447.GN4670@nvidia.com>
Organization: Red Hat GmbH
References: <0-v1-0ec87874bede+123-vfio_mig_doc_jgg@nvidia.com>
 <87zgpvj6lp.fsf@redhat.com> <20211123165352.GA4670@nvidia.com>
 <87fsrljxwq.fsf@redhat.com> <20211124184020.GM4670@nvidia.com>
 <87a6hsju8v.fsf@redhat.com> <20211125161447.GN4670@nvidia.com>
User-Agent: Notmuch/0.33.1 (https://notmuchmail.org)
Date:   Fri, 26 Nov 2021 13:56:26 +0100
Message-ID: <87pmqnhy85.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Nov 25 2021, Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Thu, Nov 25, 2021 at 01:27:12PM +0100, Cornelia Huck wrote:
>> On Wed, Nov 24 2021, Jason Gunthorpe <jgg@nvidia.com> wrote:
>> 
>> > On Wed, Nov 24, 2021 at 05:55:49PM +0100, Cornelia Huck wrote:
>> 
>> >> What I meant to say: If we give userspace the flexibility to operate
>> >> this, we also must give different device types some flexibility. While
>> >> subchannels will follow the general flow, they'll probably condense/omit
>> >> some steps, as I/O is quite different to PCI there.
>> >
>> > I would say no - migration is general, no device type should get to
>> > violate this spec.  Did you have something specific in mind? There is
>> > very little PCI specific here already
>> 
>> I'm not really thinking about violating the spec, but more omitting
>> things that do not really apply to the hardware. For example, it is
>> really easy to shut up a subchannel, we don't really need to wait until
>> nothing happens anymore, and it doesn't even have MMIO. 
>
> I've never really looked closely at the s390 mdev drivers..
>
> What does something like AP even do anyhow? The ioctl handler doesn't
> do anything, there is no mmap hook, how does the VFIO userspace
> interact with this thing?

For AP, the magic is in the hardware/firmware; the vfio parts are needed
to configure what is exposed to a given guest, not for operation. Once
it is up, the hardware will handle any instructions directly, the
hypervisor will not see them. (Unfortunately, none of the details have
public documentation.) I have no idea how this would play with migration.

>
>> > In general, userspace can issue a VFIO_DEVICE_RESET ioctl and recover the
>> > device back to device_state RUNNING. When a migration driver executes this
>> > ioctl it should discard the data window and set migration_state to RUNNING as
>> > part of resetting the device to a clean state. This must happen even if the
>> > migration_state has errored. A freshly opened device FD should always be in
>> > the RUNNING state.
>> 
>> Can the state immediately change from RUNNING to ERROR again?
>
> Immediately? State change can only happen in response to the ioctl or
> the reset.
>
> ""The migration_state cannot change asynchronously, upon writing the
> migration_state the driver will either keep the current state and return
> failure, return failure and go to ERROR, or succeed and go to the new state.""

ok

>
>> > However, a device may not compromise system integrity if it is subjected to a
>> > MMIO. It can not trigger an error TLP, it can not trigger a Machine Check, and
>> > it can not compromise device isolation.
>> 
>> "Machine Check" may be confusing to readers coming from s390; there, the
>> device does not trigger the machine check, but the channel subsystem
>> does, and we cannot prevent it. Maybe we can word it more as an example,
>> so readers get an idea what the limits in this state are?
>
> Lets say x86 machine check then which is a kernel-fatal event.

ok

>
>> Although I would like to see some more feedback from others, I think
>> this is already a huge step in the right direction.
>
> Thanks, I made all your other changes
>
> Will send a v2 next week

Thanks, sounds good.

