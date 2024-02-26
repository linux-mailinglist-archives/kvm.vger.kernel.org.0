Return-Path: <kvm+bounces-10008-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6CDC58683B6
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 23:28:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5D0181C23D32
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 22:28:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7BE441332AA;
	Mon, 26 Feb 2024 22:25:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="byhULuj0"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB5DA13328F
	for <kvm@vger.kernel.org>; Mon, 26 Feb 2024 22:25:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708986306; cv=none; b=BMqOfIYZe1wk9eNUk5vj989JJGaoKHFsk0dGbWy+KQVjMdyDVGDj0sJ2+7HeFRgE5Fg/DmHQuzMTl+t0fWCid6cIQxkFf2j1GGQ+9oNw493pMvqYfDyQQLpsF7j5sHQ3T6yTArwOLPo4xFF+EUmyWpebkg4XgC4HLUc/ELwdMz0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708986306; c=relaxed/simple;
	bh=LP0ZVgaA1YTfqo65yesfhXlhTo6vABN8oLil7ESND+o=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=t7VqGAtOT/MEZKPihI3kTpVnII/3qS16iVPONqHHipHdKzITKw/R15tX0XaOeLonExGma6i9RGTb6JtWS0lSbAS8M+G7zz0TOXn9IETtZZp6CbngifrQ7XU+JXuuRUmWBCc2jjHvKGGkJiKE0mXnoEjAa8TvySc3Qv0ngHGMEqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=byhULuj0; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1708986303;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yD9tbFkWs/Hu3mVa1QH2in7ctNLHY9fEwHrXwOBp36s=;
	b=byhULuj0Ka5DL6lqDlXZmYMZ79V5fcDIy2SPXlIpgu+thliJOk3oEDYvx99kCpuYNlBaZ0
	sDcHRwIXE54OOrZjeBN9le5UecBd2sD94+6Ct0M7CH7UptzcITvr2se/8zl57Kw3bcwstx
	6jDKJHiBf+IpwaZfgQYXsczALEXNMIU=
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com
 [209.85.166.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-433-r4TWu5DqPNyDfUQ42Hy1ZQ-1; Mon, 26 Feb 2024 17:25:01 -0500
X-MC-Unique: r4TWu5DqPNyDfUQ42Hy1ZQ-1
Received: by mail-il1-f200.google.com with SMTP id e9e14a558f8ab-3650bfcb2bfso31041795ab.1
        for <kvm@vger.kernel.org>; Mon, 26 Feb 2024 14:25:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708986301; x=1709591101;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yD9tbFkWs/Hu3mVa1QH2in7ctNLHY9fEwHrXwOBp36s=;
        b=h5sLQF8ppvY3N/g1aba8apLYspxQPi7CG0KtHS8Fl4kPOx3iBT9PKjHx43xhBRb+jz
         T/bqNUQCng4hyMIizR1WNrBkSbQEg5i/rH5HlOPHFV1fCC92iH0BUcdtOOe81J9muIEC
         I7axZf1iGxYOwpKoo5Tgnk4UDUtD+X3CDoRMlJRJF275CBt1WAArQalu2Vc7mcqXEEwX
         NITO0xqTShYxSc5M2piGlER17ocFjnPTwTeSeBQ1hukL5GDAnvdzudt9IrBPuvq2tN1W
         Z6ygdmmaPo+sRlnk1zjtlcQc8+rcWs/WKAEAEIGyASkBdexo97B6kZKi8WKu5oio43Fx
         SR+Q==
X-Forwarded-Encrypted: i=1; AJvYcCXXj6Mxi2WME77XX2imoOl/WLbtwuWkk6ADBUce/S4m/AvGjyW7Dv1RX3f2zVaSH1ylODRGNDCWqokWWTnUDfWrI6sS
X-Gm-Message-State: AOJu0Yz1hnXnmY80LwGmocklQuhMI+ZKKB+04XE5GPO/IynwbNxJRlfx
	+aF1H9lnl7DbvPPGwwUnX/a82HI04CqP12ZsmtySFdPwujeJPFq7eNZrtnkVQhkmuqE8yYUNw/P
	/OfUfr2aFRwayMBmQLIWZd7oj1FTHefPeFTslUhfOOoFR34G3Yg==
X-Received: by 2002:a92:c24a:0:b0:365:249c:690 with SMTP id k10-20020a92c24a000000b00365249c0690mr6424540ilo.9.1708986300862;
        Mon, 26 Feb 2024 14:25:00 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHSFjfJ3E7pFtjthpRny93fg61UqnyyQlQ/lezUDAjxZNp3tS/G+y3LmblJjXQIDTm332k3Uw==
X-Received: by 2002:a92:c24a:0:b0:365:249c:690 with SMTP id k10-20020a92c24a000000b00365249c0690mr6424527ilo.9.1708986300555;
        Mon, 26 Feb 2024 14:25:00 -0800 (PST)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id q6-20020a056638238600b004747a57b603sm1258086jat.58.2024.02.26.14.24.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Feb 2024 14:25:00 -0800 (PST)
Date: Mon, 26 Feb 2024 15:24:58 -0700
From: Alex Williamson <alex.williamson@redhat.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Xin Zeng <xin.zeng@intel.com>, herbert@gondor.apana.org.au,
 yishaih@nvidia.com, shameerali.kolothum.thodi@huawei.com,
 kevin.tian@intel.com, linux-crypto@vger.kernel.org, kvm@vger.kernel.org,
 qat-linux@intel.com, Yahui Cao <yahui.cao@intel.com>
Subject: Re: [PATCH v3 10/10] vfio/qat: Add vfio_pci driver for Intel QAT VF
 devices
Message-ID: <20240226152458.2b8a0f83.alex.williamson@redhat.com>
In-Reply-To: <20240226194952.GO13330@nvidia.com>
References: <20240221155008.960369-1-xin.zeng@intel.com>
	<20240221155008.960369-11-xin.zeng@intel.com>
	<20240226115556.3f494157.alex.williamson@redhat.com>
	<20240226191220.GM13330@nvidia.com>
	<20240226124107.4317b3c3.alex.williamson@redhat.com>
	<20240226194952.GO13330@nvidia.com>
X-Mailer: Claws Mail 4.2.0 (GTK 3.24.41; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 26 Feb 2024 15:49:52 -0400
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Mon, Feb 26, 2024 at 12:41:07PM -0700, Alex Williamson wrote:
> > On Mon, 26 Feb 2024 15:12:20 -0400
> > Jason Gunthorpe <jgg@nvidia.com> wrote:
> >   
> > > On Mon, Feb 26, 2024 at 11:55:56AM -0700, Alex Williamson wrote:  
> > > > This will be the first intel vfio-pci variant driver, I don't think we
> > > > need an intel sub-directory just yet.
> > > > 
> > > > Tangentially, I think an issue we're running into with
> > > > PCI_DRIVER_OVERRIDE_DEVICE_VFIO is that we require driver_override to
> > > > bind the device and therefore the id_table becomes little more than a
> > > > suggestion.  Our QE is already asking, for example, if they should use
> > > > mlx5-vfio-pci for all mlx5 compatible devices.    
> > > 
> > > They don't have to, but it works fine, there is no reason not to.  
> > 
> > But there's also no reason to.  None of the metadata exposed by the
> > driver suggests it should be a general purpose vfio-pci stand-in.  
> 
> I think the intent was to bind it to all the devices in its ID table
> automatically for VFIO use and it should always be OK to do that. Not
> doing so is a micro optimization.

Automatic in what sense?  We use PCI_DRIVER_OVERRIDE_DEVICE_VFIO to set
the id_table entry to override_only, so any binding requires the user
to specify a driver_override.  Nothing automatically performs that
driver_override except the recent support in libvirt for "managed"
devices.

Effectively override_only negates the id_table to little more than a
suggestion to userspace of how the driver should be used.

> Userspace binding it to other random things is a Bad Thing.

Yes, and GregKH has opinions about who gets to keep the pieces of the
broken system if a user uses dynamic ids or overrides to bind an
unsupported driver to a device.

> > > You are worried about someone wrongly loading a mlx5 driver on, say,
> > > an Intel device?  
> > 
> > That's sort of where we're headed if we consider it valid to bind a CX5
> > to mlx5-vfio-pci just because they have a host driver with a similar
> > name in common.   
> 
> I hope nobody is doing that, everyone should be using a tool that
> checks that ID table.. If we lack a usable tool for that then it that
> is the problemm.

These are the sort of questions I'm currently fielding and yes, we
don't really have any tools to make this automatic outside of the
recent libvirt support.

> > It's essentially a free for all.  I worry about test matrices, user
> > confusion, and being on guard for arbitrary devices at every turn in
> > variant drivers if our policy is that they should all work
> > equivalent to a basic vfio-pci-core implementation for anything.  
> 
> Today most of the drivers will just NOP themeslves if they can't find
> a compatible PF driver, the most likely bug in this path would be a
> NULL ptr deref or something in an untested path, or just total failure
> to bind.
> 
> We could insist that VF drivers are always able to find their PF or
> binding fails, that would narrow things considerably.

I think that conflicts with the guidance we've been giving for things
like virtio-vfio-pci and nvgrace-gpu-vfio-pci where a device matching
the id_table should at least get vfio-pci-core level functionality
because there is no "try the next best driver" protocol defined if
probing fails.  OTOH, I think it's fair to fail probing of a device
that does not match the id_table.

Therefore to me, a CX7 VF with matching VID:DID should always bind to
mlx5-vfio-pci regardless of the PF support for migration because that's
what the id_table matches and the device has functionality with a
vfio-pci-core driver.  However I don't see that mlx5-vfio-pci has any
obligation to bind to a CX5 device.

> > libvirt recently implemented support for managed="yes" with variant
> > drivers where it will find the best "vfio_pci" driver for a device
> > using an algorithm like Max suggested, but in practice it's not clear
> > how useful that will be considering devices likes CX7 require
> > configuration before binding to the variant driver.  libvirt has no
> > hooks to specify or perform configuration at that point.  
> 
> I don't think this is fully accurate (or at least not what was
> intended), the VFIO device can be configured any time up until the VM
> mlx5 driver reaches the device startup.
> 
> Is something preventing this? Did we accidentally cache the migratable
> flag in vfio or something??

I don't think so, I think this was just the policy we had decided
relative to profiling VFs when they're created rather than providing a
means to do it though a common vfio variant driver interface[1].

Nothing necessarily prevents libvirt from configuring devices after
binding to a vfio-pci variant driver, but per the noted thread the
upstream policy is to have the device configured prior to giving it to
vfio and any configuration mechanisms are specific to the device and
variant driver, therefore what more is libvirt to do?

> > The driverctl script also exists and could maybe consider the
> > "vfio-pci" driver name to be a fungible alias for the best matching
> > vfio_pci class driver, but I'm not sure if driverctl has a sufficient
> > following to make a difference.  
> 
> I was also thinking about this tool as an alternative instruction to
> using libvirt.
> 
> Maybe this would ecourage more people to use it if it implemented it?

driverctl is a very powerful and very unchecked tool.  It loads the gun
and points it at the user's foot and taunts them to pull the trigger.
I suspect use cases beyond vfio are largely theoretical, but it allows
specifying an arbitrary driver for almost any device.

OTOH, libvirt is more targeted and while it will work automatically for
a "managed" device specified via domain xml, it's also available as a
utility through virsh, ex:

 # virsh nodedev-detach pci_0000_01_10_0

Which should trigger the code to bind to vfio-pci or the best variant
driver.

So while there's a place for driverctl and I wouldn't mind driver
matching being added, I have trouble seeing enterprise distros really
getting behind it to recommend as best practice without a lot more
safety checks.

Relative to variant driver probe() re-checking the id_table, I know we
generally don't try to set policy in the kernel and this sort of
behavior has been around for a long, long time with new_id, but the
barrier to entry has been substantially lowered with things like
driverctl that I'd still entertain the idea.  Thanks,

Alex 

[1]https://lore.kernel.org/all/20231018163333.GZ3952@nvidia.com/


