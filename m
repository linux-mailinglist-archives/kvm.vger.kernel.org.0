Return-Path: <kvm+bounces-21177-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9ADF492B9B7
	for <lists+kvm@lfdr.de>; Tue,  9 Jul 2024 14:42:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BE5191C21EB7
	for <lists+kvm@lfdr.de>; Tue,  9 Jul 2024 12:42:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B3E331598EE;
	Tue,  9 Jul 2024 12:42:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Gp6SrgNN"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25F2515AD83
	for <kvm@vger.kernel.org>; Tue,  9 Jul 2024 12:42:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720528926; cv=none; b=S2rjyD4btiSNS55U0UGz//cFytpKSiR7GvAYrm+6dsUG1E9jlOuR9CIzve0rLs1Io/sJX7lZsuwogXuAo135oDUEdosedqZuZqBRVQQ66Qo5lbJ7I8DLyTsYfvBS2MxE0nlL5blbGUQPHMKw9aLc4bV0TWczahq6bRQowle3zY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720528926; c=relaxed/simple;
	bh=WMRXeklNAFCXPxZX0QKDYEufIJKcpHVBpPvLr8GdPXs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=riJDcQ/bDhKMm98HV5wy+FXXr9Zsjlmg1zs5Ixhh05LTtE/46YQZEyfxnsLgql7IeH9pIgC6LZDNsJG5nPaCIu6USSI2cVzLcKbrUVgif1EJTF/hVXWnVWjDe8/FkC6mm9srves8k6Li9wX/cphN7/emsvbywzSsbZCi5vAOpqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Gp6SrgNN; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1720528924;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=dtU0JGN0EJmcocAYFfRCYWD9D/xkCDMAfPhd/SDuPwo=;
	b=Gp6SrgNNgqweNWynXuvwKbR7mn+f/JQrVRI/PEwz0WX9xsQXNV/LKyYCCNEnkty4kuG1hq
	BnmpwIhk9YJGgQ58GsTckFqaNuCZHez5YPS7/Q0PeZP6Y2LPM1frINSbGfscOu/NVNto4V
	0zRUQyTH0x5ftumkUuMcfI1i/gYYTx8=
Received: from mail-lj1-f200.google.com (mail-lj1-f200.google.com
 [209.85.208.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-549-j58x4qZSOMyUU3OmdSULBg-1; Tue, 09 Jul 2024 08:42:02 -0400
X-MC-Unique: j58x4qZSOMyUU3OmdSULBg-1
Received: by mail-lj1-f200.google.com with SMTP id 38308e7fff4ca-2ee90339092so60404941fa.1
        for <kvm@vger.kernel.org>; Tue, 09 Jul 2024 05:42:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720528921; x=1721133721;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dtU0JGN0EJmcocAYFfRCYWD9D/xkCDMAfPhd/SDuPwo=;
        b=kZBsAXwOR7NXVOnzlNBEHW2WJUxu1EWUCkBotmFF2KySWcMTVvN8vis3bDYg+Q9Qlj
         wdYuWocykxGxoQ4P7ErP/j0Gg73wyMK1gbvUyyRZwjCcNxZJXsr2lQbDQI+DTN36VQZM
         g6U1Tvw41ZFxpyZGTSGsVF3WCqdiQ84AxhvjWnDZSsE9tffkLwByd3dXTL7boJxZqS+3
         z7sq8wxf1U+qfaSWmZTwtlnszdECc9l3/io7nUBSAzMKvTgv671BVwW3ElYWXqUIMLNp
         KJFKP8ieH5vL2NxXGonqLBV4qtGYvdonhPNUMdPeEV4XtHD/X05TyypNzu+55/4hR1nM
         gv3A==
X-Forwarded-Encrypted: i=1; AJvYcCXriibyQurcOP29Qcn4SMwXxNuExgF5ZktQUSwoFSJiGA1phJCrjCOWsN2YeuM1iDk/Sr73EIGkoDRaR+5BzjJdIhXd
X-Gm-Message-State: AOJu0YwMrxgFIROCuAZtiLs6GsCv2gxSqs6IF3pa0TUF6YbO12Z9LeMU
	WegwPdPkbXd19woSVmyaObnTjwB2Gexnu/7QDaGfF07kVfGRAI8uP3UbgvBUYYBqien38ZL/RSs
	QimWrU9XPpvRUUhzrwSvvePR8MbHZdJmcf+TRzj+1gfVcbMr0jA==
X-Received: by 2002:a2e:8952:0:b0:2ec:5547:c59e with SMTP id 38308e7fff4ca-2eeb3198ac3mr15823981fa.50.1720528921181;
        Tue, 09 Jul 2024 05:42:01 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEJQ/3+1cvJIxlRdKB/u4MEHHTb/Kxc0reqE+YePLpyvQDvI/rkVgTUeLmn/vgIWjxO/a5kxQ==
X-Received: by 2002:a2e:8952:0:b0:2ec:5547:c59e with SMTP id 38308e7fff4ca-2eeb3198ac3mr15823541fa.50.1720528918592;
        Tue, 09 Jul 2024 05:41:58 -0700 (PDT)
Received: from redhat.com ([2.52.29.103])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-367cdfa06b6sm2454398f8f.86.2024.07.09.05.41.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Jul 2024 05:41:58 -0700 (PDT)
Date: Tue, 9 Jul 2024 08:41:53 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Cindy Lu <lulu@redhat.com>
Cc: Parav Pandit <parav@nvidia.com>, Dragos Tatulea <dtatulea@nvidia.com>,
	"jasowang@redhat.com" <jasowang@redhat.com>,
	"sgarzare@redhat.com" <sgarzare@redhat.com>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"virtualization@lists.linux-foundation.org" <virtualization@lists.linux-foundation.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH v3 0/2] vdpa: support set mac address from vdpa tool
Message-ID: <20240709084109-mutt-send-email-mst@kernel.org>
References: <20240708064820.88955-1-lulu@redhat.com>
 <PH0PR12MB5481AE2FD52AEE1C10411F3DDCDB2@PH0PR12MB5481.namprd12.prod.outlook.com>
 <CACLfguXk4qiw4efRGK4Gw8OZQ_PKw6j+GVQJCVtbyJ+hxOoE0Q@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACLfguXk4qiw4efRGK4Gw8OZQ_PKw6j+GVQJCVtbyJ+hxOoE0Q@mail.gmail.com>

On Tue, Jul 09, 2024 at 02:19:19PM +0800, Cindy Lu wrote:
> On Tue, 9 Jul 2024 at 11:59, Parav Pandit <parav@nvidia.com> wrote:
> >
> > Hi Cindy,
> >
> > > From: Cindy Lu <lulu@redhat.com>
> > > Sent: Monday, July 8, 2024 12:17 PM
> > >
> > > Add support for setting the MAC address using the VDPA tool.
> > > This feature will allow setting the MAC address using the VDPA tool.
> > > For example, in vdpa_sim_net, the implementation sets the MAC address to
> > > the config space. However, for other drivers, they can implement their own
> > > function, not limited to the config space.
> > >
> > > Changelog v2
> > >  - Changed the function name to prevent misunderstanding
> > >  - Added check for blk device
> > >  - Addressed the comments
> > > Changelog v3
> > >  - Split the function of the net device from vdpa_nl_cmd_dev_attr_set_doit
> > >  - Add a lock for the network device's dev_set_attr operation
> > >  - Address the comments
> > >
> > > Cindy Lu (2):
> > >   vdpa: support set mac address from vdpa tool
> > >   vdpa_sim_net: Add the support of set mac address
> > >
> > >  drivers/vdpa/vdpa.c                  | 81 ++++++++++++++++++++++++++++
> > >  drivers/vdpa/vdpa_sim/vdpa_sim_net.c | 19 ++++++-
> > >  include/linux/vdpa.h                 |  9 ++++
> > >  include/uapi/linux/vdpa.h            |  1 +
> > >  4 files changed, 109 insertions(+), 1 deletion(-)
> > >
> > > --
> > > 2.45.0
> >
> > Mlx5 device already allows setting the mac and mtu during the vdpa device creation time.
> > Once the vdpa device is created, it binds to vdpa bus and other driver vhost_vdpa etc bind to it.
> > So there was no good reason in the past to support explicit config after device add complicate the flow for synchronizing this.
> >
> > The user who wants a device with new attributes, as well destroy and recreate the vdpa device with new desired attributes.
> >
> > vdpa_sim_net can also be extended for similar way when adding the vdpa device.
> >
> > Have you considered using the existing tool and kernel in place since 2021?
> > Such as commit d8ca2fa5be1.
> >
> > An example of it is,
> > $ vdpa dev add name bar mgmtdev vdpasim_net mac 00:11:22:33:44:55 mtu 9000
> >
> Hi Parav
> Really thanks for your comments. The reason for adding this function
> is to support Kubevirt.
> the problem we meet is that kubevirt chooses one random vdpa device
> from the pool and we don't know which one it going to pick. That means
> we can't get to know the Mac address before it is created. So we plan
> to have this function to change the mac address after it is created
> Thanks
> cindy

Well you will need to change kubevirt to teach it to set
mac address, right?

-- 
MST


