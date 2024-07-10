Return-Path: <kvm+bounces-21267-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D0C7A92CA6A
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2024 08:11:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F3B931C22190
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2024 06:11:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A82005B1F8;
	Wed, 10 Jul 2024 06:10:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="a6UoVETN"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C6334F8A0
	for <kvm@vger.kernel.org>; Wed, 10 Jul 2024 06:10:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720591851; cv=none; b=bH5F2Gv1V+nkoLDCqotKaykHxK++iTx/MF5oKnEfWM+d80wCTtKrqm5L/m2HywpiKzn5GSGyFMOWkd4tr19PSqNnTKA55PK4wPIk/qRO1fQWfK3r3LLide71HyTS0Xz5D7avTgWaI3qM8B5g4IfierC7sf9uuQCO+8LuZZPJ048=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720591851; c=relaxed/simple;
	bh=1OteSeEEKH0xI0Oh+CNKtD7aOdOLUK4Wax0gEtG/3rY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=te9ZRXR9K3fDu73Ue6atIrQ/hsn7V0B9h/Mw4AlW1nvzDS6md9pexLMI/9aTaxUQzH3rGj+YNQI1eRM6+x0IcKRW6FEqTVhbHU0JXtcA9wEWn06/AN7aIcDfNcRMPPSioDnOjfI5ihD5Y4RYWIupSr/c69cwrE+OokO4ybiGgLU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=a6UoVETN; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1720591849;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=X4MsH1lA4eWc8gvy+b6nRd+irAYUf4vc/vQAj43j3S8=;
	b=a6UoVETNm4UdP9f1bofzRfEIMzTtjdjwhxjeOL0uxvE7Tlg2Ful7nu161PFOUEeMo9BThn
	lY976bpXO0nh8rgT9P4j7Fr0OcNSKC5ZctmuUqB6z5bAwDB1qO8V8j//tdavZ4MktUycSB
	SWfFJahqmOX2ALdw4oty9W/SFBnOZXc=
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com
 [209.85.167.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-647-N7XOWK4FM6qtZ6S_iGFKyw-1; Wed, 10 Jul 2024 02:10:47 -0400
X-MC-Unique: N7XOWK4FM6qtZ6S_iGFKyw-1
Received: by mail-lf1-f71.google.com with SMTP id 2adb3069b0e04-52ea1a947aeso5957965e87.1
        for <kvm@vger.kernel.org>; Tue, 09 Jul 2024 23:10:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720591846; x=1721196646;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=X4MsH1lA4eWc8gvy+b6nRd+irAYUf4vc/vQAj43j3S8=;
        b=Hvr0WLMt5d9mnd5+x6F0kTFdU0mtxl7o4Z6pckSNx4Z+J2B7BNo6+oH3LrFi8rL2+e
         MoAWXcqx2pgY+qaYpcVLgquiFLORa6KBuWzzjcr3vzley4pJYJsIiKDGLMexrwey4Xqc
         I9tkxenGQCjhkbpSnBdIV1J5bqcwk32CGVFZaBOPwxrdXEWvzs+wVzjcLxkkeqUTuuFl
         p+jmStDjo9O41ySjrBEI00a1Z14wsiUjlHB5yArFKbgKwbxycD6bY/fyuEZBAlq50OU6
         UwkBi4aDdTqcU9ZwEQbdlowVuWjBB3L2ZOst3iURqsAtHiPX7ZtEBzkcTp6yyPmmm16/
         o18w==
X-Forwarded-Encrypted: i=1; AJvYcCUbvTqaE7l/V2ciIk506IJsbWXPe2x9YeVEIIj90hEk9BJHguqHSWzAwY8VYZZbQq/OwWA+7gOpmJ7SU7npPDuLQDb6
X-Gm-Message-State: AOJu0YwBCLmTi8V4xzSS97i8DAVGXQU0RizHWr1VbbCeZl2FFMJrGP1C
	quvKbiR3jzhMAW13hs3cqyNnOQ1TPb5C4PQDJGg2sJuqYggxpd4cT2FY6GxIb9/MWLS1I/LBU94
	LRn9Xr2wIKIpfrPUB+VD5+zLtwwkknHv1hzHUlHK3EmDOV3PM4w==
X-Received: by 2002:ac2:42d8:0:b0:52b:b327:9c1c with SMTP id 2adb3069b0e04-52eb99d59e8mr2530511e87.62.1720591845789;
        Tue, 09 Jul 2024 23:10:45 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGPbauTJ9QFnUJHiEZRXf8cKpY/Ph2hFs+oVaX3YRKAndRpINbHSQxy+Oi4OwHlpwQjmGnGuw==
X-Received: by 2002:ac2:42d8:0:b0:52b:b327:9c1c with SMTP id 2adb3069b0e04-52eb99d59e8mr2530479e87.62.1720591845031;
        Tue, 09 Jul 2024 23:10:45 -0700 (PDT)
Received: from redhat.com ([2a02:14f:174:f6ae:a6e3:8cbc:2cbd:b8ff])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4266b03feecsm101417875e9.10.2024.07.09.23.10.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Jul 2024 23:10:43 -0700 (PDT)
Date: Wed, 10 Jul 2024 02:10:37 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Jason Wang <jasowang@redhat.com>
Cc: Cindy Lu <lulu@redhat.com>, Parav Pandit <parav@nvidia.com>,
	Dragos Tatulea <dtatulea@nvidia.com>,
	"sgarzare@redhat.com" <sgarzare@redhat.com>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"virtualization@lists.linux-foundation.org" <virtualization@lists.linux-foundation.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	Leonardo Milleri <lmilleri@redhat.com>
Subject: Re: [PATCH v3 0/2] vdpa: support set mac address from vdpa tool
Message-ID: <20240710020852-mutt-send-email-mst@kernel.org>
References: <20240708064820.88955-1-lulu@redhat.com>
 <PH0PR12MB5481AE2FD52AEE1C10411F3DDCDB2@PH0PR12MB5481.namprd12.prod.outlook.com>
 <CACLfguXk4qiw4efRGK4Gw8OZQ_PKw6j+GVQJCVtbyJ+hxOoE0Q@mail.gmail.com>
 <20240709084109-mutt-send-email-mst@kernel.org>
 <CACGkMEtdFgbgrjNDoYfW1B+4BwG8=i9CP5ePiULm2n3837n29w@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACGkMEtdFgbgrjNDoYfW1B+4BwG8=i9CP5ePiULm2n3837n29w@mail.gmail.com>

On Wed, Jul 10, 2024 at 11:05:48AM +0800, Jason Wang wrote:
> On Tue, Jul 9, 2024 at 8:42 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> >
> > On Tue, Jul 09, 2024 at 02:19:19PM +0800, Cindy Lu wrote:
> > > On Tue, 9 Jul 2024 at 11:59, Parav Pandit <parav@nvidia.com> wrote:
> > > >
> > > > Hi Cindy,
> > > >
> > > > > From: Cindy Lu <lulu@redhat.com>
> > > > > Sent: Monday, July 8, 2024 12:17 PM
> > > > >
> > > > > Add support for setting the MAC address using the VDPA tool.
> > > > > This feature will allow setting the MAC address using the VDPA tool.
> > > > > For example, in vdpa_sim_net, the implementation sets the MAC address to
> > > > > the config space. However, for other drivers, they can implement their own
> > > > > function, not limited to the config space.
> > > > >
> > > > > Changelog v2
> > > > >  - Changed the function name to prevent misunderstanding
> > > > >  - Added check for blk device
> > > > >  - Addressed the comments
> > > > > Changelog v3
> > > > >  - Split the function of the net device from vdpa_nl_cmd_dev_attr_set_doit
> > > > >  - Add a lock for the network device's dev_set_attr operation
> > > > >  - Address the comments
> > > > >
> > > > > Cindy Lu (2):
> > > > >   vdpa: support set mac address from vdpa tool
> > > > >   vdpa_sim_net: Add the support of set mac address
> > > > >
> > > > >  drivers/vdpa/vdpa.c                  | 81 ++++++++++++++++++++++++++++
> > > > >  drivers/vdpa/vdpa_sim/vdpa_sim_net.c | 19 ++++++-
> > > > >  include/linux/vdpa.h                 |  9 ++++
> > > > >  include/uapi/linux/vdpa.h            |  1 +
> > > > >  4 files changed, 109 insertions(+), 1 deletion(-)
> > > > >
> > > > > --
> > > > > 2.45.0
> > > >
> > > > Mlx5 device already allows setting the mac and mtu during the vdpa device creation time.
> > > > Once the vdpa device is created, it binds to vdpa bus and other driver vhost_vdpa etc bind to it.
> > > > So there was no good reason in the past to support explicit config after device add complicate the flow for synchronizing this.
> > > >
> > > > The user who wants a device with new attributes, as well destroy and recreate the vdpa device with new desired attributes.
> > > >
> > > > vdpa_sim_net can also be extended for similar way when adding the vdpa device.
> > > >
> > > > Have you considered using the existing tool and kernel in place since 2021?
> > > > Such as commit d8ca2fa5be1.
> > > >
> > > > An example of it is,
> > > > $ vdpa dev add name bar mgmtdev vdpasim_net mac 00:11:22:33:44:55 mtu 9000
> > > >
> > > Hi Parav
> > > Really thanks for your comments. The reason for adding this function
> > > is to support Kubevirt.
> > > the problem we meet is that kubevirt chooses one random vdpa device
> > > from the pool and we don't know which one it going to pick. That means
> > > we can't get to know the Mac address before it is created. So we plan
> > > to have this function to change the mac address after it is created
> > > Thanks
> > > cindy
> >
> > Well you will need to change kubevirt to teach it to set
> > mac address, right?
> 
> That's the plan. Adding Leonardo.
> 
> Thanks

So given you are going to change kubevirt, can we
change it to create devices as needed with the
existing API?

> >
> > --
> > MST
> >


