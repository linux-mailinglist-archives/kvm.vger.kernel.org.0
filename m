Return-Path: <kvm+bounces-24315-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id CC6DC9538AA
	for <lists+kvm@lfdr.de>; Thu, 15 Aug 2024 18:59:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 074121C237EC
	for <lists+kvm@lfdr.de>; Thu, 15 Aug 2024 16:59:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C5B421BB6AD;
	Thu, 15 Aug 2024 16:59:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DvHNT8Ks"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6073F21105
	for <kvm@vger.kernel.org>; Thu, 15 Aug 2024 16:59:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723741154; cv=none; b=D/Qd3U8ICMI1Wei5NS2HJHl+lz9HPMvmt5Rb90eCnNfig2J9eomvmGhNVcfPvTtgWf/OHBg79Jx7Gd0FXlvKGhpHy+SY4lh9oGJB0zUVtMHsd8OiddfXAM8D5U7uGiFyhAS7jUN+TBeydX8Fg/GOvjonh5H3YpDNlI10B9/LZMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723741154; c=relaxed/simple;
	bh=3hIwpWIXEHc6rIHNNwobnugw6L7v+QjdIrBr1viVgI8=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MVjfq+GMw44O7kdbh4LN/ppZrDyhKkVGaY8/jWjxsOficNyz97V6i6RCmvKk1e6jbOdaU7V1Vo3qbdBw7BpmQAWNH9EHMg2hVLXUDNno9mId5HlvyFGJs2QlfVxqjFt4ok2J6Er/3PfWicfAGUiuDokDN94Yl6GqJ7MkzsoWC7A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DvHNT8Ks; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1723741150;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZlcSz4KYwAPgWcAKkWXUG1nSmDKdddlqy88W5LmzqbQ=;
	b=DvHNT8Ks9er0yzKFAFBZwcINolhnMs610dS63wH8jMV51W3CTZa8LY8GBbjOPWJRSSFvab
	5jwcrulIeU4z1Klc31juwIUPKJA7hrJMlkvogHLm3lOv7iBZA7z5ckg4z54Yt+10fBRlB9
	7hMPlIBXoIG+YS86XDmPNviCQnTEDdY=
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com
 [209.85.166.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-384-T8pkV5CEMQiLbz4vE9XOJg-1; Thu, 15 Aug 2024 12:59:08 -0400
X-MC-Unique: T8pkV5CEMQiLbz4vE9XOJg-1
Received: by mail-il1-f199.google.com with SMTP id e9e14a558f8ab-39d27488930so327425ab.3
        for <kvm@vger.kernel.org>; Thu, 15 Aug 2024 09:59:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723741148; x=1724345948;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ZlcSz4KYwAPgWcAKkWXUG1nSmDKdddlqy88W5LmzqbQ=;
        b=JUMJ3229Eu1Sce1HOqHXLTYMqsoGzOsMJiFyw8KuKhodMR3iV1djw+TOhDwr2QI7No
         pbDp5XWQOSrZ+H/DXlCMYzxEl8OK0gFiY0kJC90KWputVIduwFIHADCJNXN0yJQf6Rek
         0tTGQSjXl7Xzt7+mAkLyiud9MPUHYs63tvPNkUjpaXXC8ZODl20sbWF89QB/ibae/E1x
         18MYSjCPTbvxGgiuNQjTLAvnyg6I9V580HNDDb4dhv5F8c2vUTeMU+P6Ti7vgFmPuNfF
         1/hjXI2R/tjJEQhqrSG1sAHGop0/i0+4JtQPcRui9mp/nn2ukKIiIfE5Wuv9oU6tXoKk
         5SBA==
X-Forwarded-Encrypted: i=1; AJvYcCVxr5wzWHfn+BYJSESyCSFbw2y0sbGn/CqBES2GZiHPDvXr/GW+xlUkYC75z+nJNFcm9zsUd3BU74Lbjr6TsRzMKc7t
X-Gm-Message-State: AOJu0YweepOHClNsw7u34kUaciEaMg0C/RRhm7t/xzurxkwCBSE+JJgl
	fpzmhGOvlwvU3NveuNNLTgSLDmUaUgckNzvnus8TVg84dKbC75Ns7ahoWMxGjwy+D9NMWVzt8gc
	rwB/+pjQkDzjEMXdH7rg1y1oYUD655hZB+uhGe5YBtsrGTTpreg==
X-Received: by 2002:a05:6e02:1aaa:b0:39a:ea4c:8c26 with SMTP id e9e14a558f8ab-39d26cdf8fbmr6083185ab.1.1723741148120;
        Thu, 15 Aug 2024 09:59:08 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGnffchl9WybcknzKF++o1mrFSsyjdEylnwuSiMZ5up4JHfQDmnQXUAj1Uo1c5erjQFGND9Ig==
X-Received: by 2002:a05:6e02:1aaa:b0:39a:ea4c:8c26 with SMTP id e9e14a558f8ab-39d26cdf8fbmr6082925ab.1.1723741147721;
        Thu, 15 Aug 2024 09:59:07 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-39d1ec19de3sm6807035ab.45.2024.08.15.09.59.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Aug 2024 09:59:07 -0700 (PDT)
Date: Thu, 15 Aug 2024 10:59:05 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org, quic_bqiang@quicinc.com,
 kvalo@kernel.org, prestwoj@gmail.com, linux-wireless@vger.kernel.org,
 ath11k@lists.infradead.org, dwmw2@infradead.org, iommu@lists.linux.dev,
 kernel@quicinc.com, johannes@sipsolutions.net, jtornosm@redhat.com
Subject: Re: [PATCH RFC/RFT] vfio/pci-quirks: Quirk for ath wireless
Message-ID: <20240815105905.19d69576.alex.williamson@redhat.com>
In-Reply-To: <20240813233724.GS1985367@ziepe.ca>
References: <adcb785e-4dc7-4c4a-b341-d53b72e13467@gmail.com>
	<20240812170045.1584000-1-alex.williamson@redhat.com>
	<20240813164341.GL1985367@ziepe.ca>
	<20240813150320.73df43d7.alex.williamson@redhat.com>
	<20240813233724.GS1985367@ziepe.ca>
Organization: Red Hat
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 13 Aug 2024 20:37:24 -0300
Jason Gunthorpe <jgg@ziepe.ca> wrote:

> On Tue, Aug 13, 2024 at 03:03:20PM -0600, Alex Williamson wrote:
> 
> > How does the guest know to write a remappable vector format?  How does
> > the guest know the host interrupt architecture?  For example why would
> > an aarch64 guest program an MSI vector of 0xfee... if the host is x86?  
> 
> All excellent questions.
> 
> Emulating real interrupt controllers in the VM is probably impossible
> in every scenario. But certainly x86 emulating x86 and ARM emulating
> ARM would be usefully achievable.
> 
> hyperv did a neat thing where their remapping driver seems to make VMM
> traps and looks kind of like the VMM gives it the platform specific
> addr/data pair.
> 
> It is a big ugly problem for sure, and we definately have painted
> ourselves into a corner where the OS has no idea if IMS techniques
> work properly or it is broken. :( :(
> 
> But I think there may not be a terribly impossible path where at least
> the guest could be offered a, say, virtio-irq in addition to the
> existing platform controllers that would process IMS for it.
> 
> > The idea of guest owning the physical MSI address space sounds great,
> > but is it practical?    
> 
> In many cases yes, it is, but more importantly it is the only sane way
> to support these IMS like techniques broadly since IMS is by
> definition not generally trappable.
> 
> > Is it something that would be accomplished while
> > this device is still relevant?  
> 
> I don't know, I fear not. But it keeps coming up. Too many things
> don't work right with the trapping approach, including this.
> 
> > The Windows driver is just programming the MSI capability to use 16
> > vectors.  We configure those vectors on the host at the time the
> > capability is written.  Whereas the Linux driver is only using a single
> > vector and therefore writing the same MSI address and data at the
> > locations noted in the trace, the Windows driver is writing different
> > data values at different locations to make use of those vectors.  This
> > note is simply describing that we can't directly write the physical
> > data value into the device, we need to determine which vector offset
> > the guest is using and provide the same offset from the host data
> > register value.  
> 
> I see, it seems to be assuming also that these extra interrupt sources
> are generating the same MSI message as the main MSI, not something
> else. That is more a SW quirk of Windows, I expect. I don't think
> Linux would do that..
> 
> This is probably the only way to approach this, trap and emulate the
> places in the device that program additional interrupt sources and do
> a full MSI-like flow to set them up in the kernel.

Your last sentence here seems to agree with this approach, but
everything else suggests disapproval, so I don't know where you're
going here.

I have no specs for this device, nor any involvement from the device
vendor, so the idea of creating a vfio-pci variant driver to setup an
irq_domain and augment a device specific SET_IRQs ioctls not only sounds
tremendously more complicated (host and VMM), it's simply not possible
with the knowledge we have at hand.  Making this device work in a VM is
dead in the water if that's the bar to achieve.

I observe that the device configures MSI vectors and then writes that
same vector address/data elsewhere into the device.  Whether the device
can trigger those vectors based only on the MSI capability programming
and a secondary source piggybacks on those vectors or if this is just a
hack by Qualcomm to use an MSI capability to acquire some vectors which
are exclusively used by the secondary hardware, I have no idea.  Who
can even say if this is just a cost saving measure that a PCI config
space is slapped into a platform device and there's simply no hw/fw
support to push the vector data into the hardware and the driver
bridges the gap.

The solution here is arguably fragile, we're relying on having a
sufficiently unique MSI address that we can recognize writes with that
value in order to both replace it with the host value and mark the
location of the data register.  If someone with some hardware insight
wants to come along and provide a reference for static locations of
these writes, I'd certainly welcome it.  My sample size is one, which
is why this is posted as an RFT.

I do not believe that introducing a vfio device feature that disables
virtualization of the MSI address/data _only_ at the vfio interface
(not to a QEMU VM) provides some implicit support of this device
behavior.  These values are already available to a privileged user in
the host and the same is available for an MSI-X use case by directly
reading the MSI-X vector table.  The only point of the vfio device
feature is that we need a vehicle to expose the MSI phsyical
address/data values through he vfio channel, without additional host
privileges.  The virtualized values are essentially unused by QEMU, so
why not give QEMU a way to turn off the virtualization to expose the
host values.  Thanks,

Alex


