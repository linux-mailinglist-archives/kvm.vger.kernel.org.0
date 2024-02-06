Return-Path: <kvm+bounces-8166-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8370684C0C3
	for <lists+kvm@lfdr.de>; Wed,  7 Feb 2024 00:19:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BF4171C247E6
	for <lists+kvm@lfdr.de>; Tue,  6 Feb 2024 23:19:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 079071CD28;
	Tue,  6 Feb 2024 23:19:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XPNLdvn5"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7765C1CD1F
	for <kvm@vger.kernel.org>; Tue,  6 Feb 2024 23:19:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707261582; cv=none; b=B9FKlnz/GFu40//F6p6VtG2x8pQcfCz7tvSQyuziHwJPh/w8DJIaGOY2VMawkUDbouSAquSSHhek4W8AzOZBImMbxL/YxlixMdRbs76tM5N9DXQ7EUyus/bcX5AnKzY1WKVsxXo2/EbL4/Q2XSqxVxfltLkePEzhQ/7gim+mHlc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707261582; c=relaxed/simple;
	bh=mSp1+JYDb7NdH17RZ+qMLPdVmrJ42e3fPvlEjXiGpZc=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ou+DBM4KhntyAnBArlOydmJ4tSzTLstlIrX+j64SZvK4ORCcHG9tw6QGqtnsVgA7qW6bcjw9NUZD9WZ/UF3gKIKevoXZ6QFjucnrGYyQ7wWWRPReL44sudFHaRV84W/nn/+qeDk85yFogyxmXovsaCNpPDK6GJ51ZFMdtnhBEJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XPNLdvn5; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1707261579;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/9lQWrs1kWLDUb9rNRJMZocZRASv82NRrn4c/SQZik0=;
	b=XPNLdvn5V6bTVv/AXIx/40HLOU3SbTPJ8u609S6aAjQFMJ4I+PVOmI75YZRMH/X0Ne5/xU
	lkEe57jZ+0cWUv9vlW/EhTMuGTurTeZpmFPwHXFsuQMzDSg6CTxnVPBNXO3C1wbGp0sLVg
	kaeK+n2JdexH1DNU/4eXgiWGw/St1PE=
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com
 [209.85.166.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-679-RMdcnKqpNmy4tNv5JoMQ0g-1; Tue, 06 Feb 2024 18:19:37 -0500
X-MC-Unique: RMdcnKqpNmy4tNv5JoMQ0g-1
Received: by mail-io1-f72.google.com with SMTP id ca18e2360f4ac-7bfd755ae39so4013439f.1
        for <kvm@vger.kernel.org>; Tue, 06 Feb 2024 15:19:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707261577; x=1707866377;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/9lQWrs1kWLDUb9rNRJMZocZRASv82NRrn4c/SQZik0=;
        b=Ci9re7WrRdM2rWeOCgCXI9q4X4DOXGc/jeKnaCiGjNJgzCFsi07wS34NTV3rjzgdQ8
         N/PkY4avrU3MUKxWc4iK0CfkChwaeREqFFUAUEEUIuQ+HdT64vepMv+AJV463I5y+B/J
         8MvQ6r+2n6mnz8cNu6haC0V14hdVBZjlUH2MXI1RI85F1jfeZ+Oanu1EpW/FFiz89ANz
         BPptXXOLA1X054vjVmL3OoJpx79jI1LiSUnHKd9VSKMjY/j2ky54/5Ihs/ikFp1pBUOu
         AtEHKxkNINbcJZxtjH3PpQsBYErHDjI3oLJV6fl6SBv4896FiPn3nraIKHrKnBnfADXH
         jyVw==
X-Forwarded-Encrypted: i=1; AJvYcCXK1sZ4kXsfdPu8g7wPpxRH1x/emtaeWP2fLKo3DuhreS1qWDPrMZItEwoAkL3kczlSRyIjwsDE9jQd1WPBmQ4mVnkc
X-Gm-Message-State: AOJu0Yz4aj6hohiNBDTN2PwShgjHMcj1737/2Kj5X9n1uluLB9IgHp0B
	rmLQ5yTXNfHW8Gu7vSj0WoQ+KGU713ePFItg63HSRV6+qsIrCAzIgbpalLh+c21p2p6HYskaQ2D
	cmzFkAi6PuuQXMtYxKW0SqzlfZpRVwFZVr9/B2N3Gfcxyy5l7Tg==
X-Received: by 2002:a6b:d90c:0:b0:7c3:eda4:ea11 with SMTP id r12-20020a6bd90c000000b007c3eda4ea11mr3842360ioc.16.1707261576998;
        Tue, 06 Feb 2024 15:19:36 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEXK/MFQbXmN+Uf8XVzJe4tvZZl/EZvTIdNvNxAoxSmujnNBpZGeCU0PDhYylr2/KYfzAQzoA==
X-Received: by 2002:a6b:d90c:0:b0:7c3:eda4:ea11 with SMTP id r12-20020a6bd90c000000b007c3eda4ea11mr3842343ioc.16.1707261576688;
        Tue, 06 Feb 2024 15:19:36 -0800 (PST)
X-Forwarded-Encrypted: i=0; AJvYcCVxQNy7WM81D1KyTsj5b6dysZmQ7irl+mHz/wXIJCehZJzT0rzy+38bzv2vK3ShDIBzaGnFianyWRV+Hdsia6yEsRrKo2XUlAzSu2R7lPibY72NFRgkL6J1H4gguFl0tSVtOPFdoSDj6gOxqFGFXrShMogteJqdI2GP0UhDD2LGRyM9B5Wc+7HDrTXKN44RMTBUNTuq7aMfFxLTXCzPdV4FZ1UgM7UOCYN7m5m0EnQ23l/aEj0OzE8fhqLrcF+Mya/rFzyaRajzcLY69xrxYnzGhpt+N80pc4GtLcrRAz51m/QHUQtyk020l/znzMSPys9qDlGZ3Q==
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id s24-20020a6bdc18000000b007c3f616986csm369762ioc.40.2024.02.06.15.19.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Feb 2024 15:19:36 -0800 (PST)
Date: Tue, 6 Feb 2024 16:19:34 -0700
From: Alex Williamson <alex.williamson@redhat.com>
To: Reinette Chatre <reinette.chatre@intel.com>
Cc: <jgg@nvidia.com>, <yishaih@nvidia.com>,
 <shameerali.kolothum.thodi@huawei.com>, <kevin.tian@intel.com>,
 <kvm@vger.kernel.org>, <dave.jiang@intel.com>, <ashok.raj@intel.com>,
 <linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>
Subject: Re: [PATCH 15/17] vfio/pci: Let enable and disable of interrupt
 types use same signature
Message-ID: <20240206161934.684237d3.alex.williamson@redhat.com>
In-Reply-To: <ce617344-ab6e-49f3-adbd-47be9fb87bf9@intel.com>
References: <cover.1706849424.git.reinette.chatre@intel.com>
	<bf87e46c249941ebbfacb20ee9ff92e8efd2a595.1706849424.git.reinette.chatre@intel.com>
	<20240205153542.0883e2ff.alex.williamson@redhat.com>
	<5784cc9b-697a-40fa-99b0-b75530f51214@intel.com>
	<20240206150341.798bb9fe.alex.williamson@redhat.com>
	<ce617344-ab6e-49f3-adbd-47be9fb87bf9@intel.com>
X-Mailer: Claws Mail 4.2.0 (GTK 3.24.38; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 6 Feb 2024 14:22:04 -0800
Reinette Chatre <reinette.chatre@intel.com> wrote:

> Hi Alex,
> 
> On 2/6/2024 2:03 PM, Alex Williamson wrote:
> > On Tue, 6 Feb 2024 13:46:37 -0800
> > Reinette Chatre <reinette.chatre@intel.com> wrote:
> >   
> >> Hi Alex,
> >>
> >> On 2/5/2024 2:35 PM, Alex Williamson wrote:  
> >>> On Thu,  1 Feb 2024 20:57:09 -0800
> >>> Reinette Chatre <reinette.chatre@intel.com> wrote:    
> >>
> >> ..
> >>  
> >>>> @@ -715,13 +724,13 @@ static int vfio_pci_set_intx_trigger(struct vfio_pci_core_device *vdev,
> >>>>  		if (is_intx(vdev))
> >>>>  			return vfio_irq_set_block(vdev, start, count, fds, index);
> >>>>  
> >>>> -		ret = vfio_intx_enable(vdev);
> >>>> +		ret = vfio_intx_enable(vdev, start, count, index);    
> >>>
> >>> Please trace what happens when a user calls SET_IRQS to setup a trigger
> >>> eventfd with start = 0, count = 1, followed by any other combination of
> >>> start and count values once is_intx() is true.  vfio_intx_enable()
> >>> cannot be the only place we bounds check the user, all of the INTx
> >>> callbacks should be an error or nop if vector != 0.  Thanks,
> >>>     
> >>
> >> Thank you very much for catching this. I plan to add the vector
> >> check to the device_name() and request_interrupt() callbacks. I do
> >> not think it is necessary to add the vector check to disable() since
> >> it does not operate on a range and from what I can tell it depends on
> >> a successful enable() that already contains the vector check. Similar,
> >> free_interrupt() requires a successful request_interrupt() (that will
> >> have vector check in next version).
> >> send_eventfd() requires a valid interrupt context that is only
> >> possible if enable() or request_interrupt() succeeded.  
> > 
> > Sounds reasonable.
> >   
> >> If user space creates an eventfd with start = 0 and count = 1
> >> and then attempts to trigger the eventfd using another combination then
> >> the changes in this series will result in a nop while the current
> >> implementation will result in -EINVAL. Is this acceptable?  
> > 
> > I think by nop, you mean the ioctl returns success.  Was the call a
> > success?  Thanks,  
> 
> Yes, I mean the ioctl returns success without taking any
> action (nop).
> 
> It is not obvious to me how to interpret "success" because from what I
> understand current INTx and MSI/MSI-x are behaving differently when
> considering this flow. If I understand correctly, INTx will return
> an error if user space attempts to trigger an eventfd that has not
> been set up while MSI and MSI-x will return 0.
> 
> I can restore existing INTx behavior by adding more logic and a return
> code to the send_eventfd() callback so that the different interrupt types
> can maintain their existing behavior.

Ah yes, I see the dilemma now.  INTx always checked start/count were
valid but MSI/X plowed through regardless, and with this series we've
standardized the loop around the MSI/X flow.

Tricky, but probably doesn't really matter.  Unless we break someone.

I can ignore that INTx can be masked and signaling a masked vector
doesn't do anything, but signaling an unconfigured vector feels like an
error condition and trying to create verbiage in the uAPI header to
weasel out of that error and unconditionally return success makes me
cringe.

What if we did this:

        uint8_t *bools = data;
	...
        for (i = start; i < start + count; i++) {
                if ((flags & VFIO_IRQ_SET_DATA_NONE) ||
                    ((flags & VFIO_IRQ_SET_DATA_BOOL) && bools[i - start])) {
                        ctx = vfio_irq_ctx_get(vdev, i);
                        if (!ctx || !ctx->trigger)
                                return -EINVAL;
                        intr_ops[index].send_eventfd(vdev, ctx);
                }
        }

And we note the behavior change for MSI/X in the commit log and if
someone shouts that we broke them, we can make that an -errno or
continue based on is_intx().  Sound ok?  Thanks,

Alex


