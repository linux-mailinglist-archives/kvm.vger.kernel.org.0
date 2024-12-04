Return-Path: <kvm+bounces-33080-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CD4969E449E
	for <lists+kvm@lfdr.de>; Wed,  4 Dec 2024 20:30:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 94FDE1678DE
	for <lists+kvm@lfdr.de>; Wed,  4 Dec 2024 19:30:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 06EA3239197;
	Wed,  4 Dec 2024 19:30:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LBffAB1d"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13B962391B3
	for <kvm@vger.kernel.org>; Wed,  4 Dec 2024 19:30:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733340651; cv=none; b=sXjKlrWj9fKfMI3LpkjBvaXOuqwZyXCX9QGxi/BGresqTfVxjyd7X0g5nYXvns0OJDYMdfhSi9tdWMG2kw2HwKdZfNyI2Of5M4RGYW1wuZn9lJ4qRTrGc34vyTb3PSDQ4bS1LArxp83vpEtTjvVfl+D/kqrfSYhibqFYLwZE0v4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733340651; c=relaxed/simple;
	bh=+kG2ZX4h4KNGQ3n0K526VRWXhwqPpyhkssMZrUxDBdA=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=T43i6Aa6ImLxeayaLCusKK+SbXo11kFPGGkW6LVvKEn3kSFsQXItJkXhw+oxiJaODaJIQl1hmOXkKauAOf9dnoDlzf/9ZLlD+EmeuC2aPi/bGZTpEfnPtEBuYY15XAzSAC8TildSOUj88+VXxmxM/+6mZAqqDXig33N5QVRFnG0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=LBffAB1d; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1733340648;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tDRFw7U6hCer6QgswzgZpUCLYHSLAVZ4RAvpNMHlOEQ=;
	b=LBffAB1d8HT9tdVJW9VGwTwhsdpQJAL3nRpK13DCq6iBSjYB95yqhM6QQYxVNeTpTnWfiy
	2jhgdXDpuEUVb4pU09shJhWcgwBYzdzgcTJjrh0jrXwPbQB5vLcXpK1FYN7R1Dpeq8uPVd
	L7H7w1j5gFK6cC4GllEE3SWoqv8YoU0=
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com
 [209.85.166.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-543-dVwpYgpfPu6AD_GftCXE0w-1; Wed, 04 Dec 2024 14:30:46 -0500
X-MC-Unique: dVwpYgpfPu6AD_GftCXE0w-1
X-Mimecast-MFC-AGG-ID: dVwpYgpfPu6AD_GftCXE0w
Received: by mail-io1-f70.google.com with SMTP id ca18e2360f4ac-843e2e46265so878139f.0
        for <kvm@vger.kernel.org>; Wed, 04 Dec 2024 11:30:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733340646; x=1733945446;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tDRFw7U6hCer6QgswzgZpUCLYHSLAVZ4RAvpNMHlOEQ=;
        b=Q1LinHSoV0v/hjjI818+0JpPH7zVY7AtJ8Onv2EmimLYRBCVBZYmCXjlqnQ84PQ9fN
         gYejS8qqWOHzmyF5B36qaVMno19v4jWU1OqpfJ7pPu2oH29ONT6WxaUQTkL5RfHU/IoY
         BxPHa/J6UGPU2Kv+rM5LYn/GJl5b3GknetjTb6psOjAM8B+mn2DQt22YCZc6/EPlM6IX
         Div7PcHeAh/sTKQfTry3CgJcGs4+UA80F/6dDdcax3g6IFpcQV1bCLe3amMyoobQMSep
         +EV0F055Pxca/INq7NEj3RIuelMkivZDq9BsBD+W3E+XSBOFLS/4lTLDYw0grFVj8Rad
         T/dA==
X-Forwarded-Encrypted: i=1; AJvYcCWv2hLwoLQLtkkyW1s+etwwv1VqBXl6KW3XCG8/KJEsVIjROH8MoxEsBzn8l3eZI/CGmH4=@vger.kernel.org
X-Gm-Message-State: AOJu0YwO74gNY4GV8Om0ZF2HL7bQon1xJfpCc7u8acVhi0c2AYXO8Vpy
	Msolboif0CPtNHXnDBQmAsuYL+jxVr8KK9lB1AbvnVUnQUCVycc/TtgTtwm5zKT7uf/xehKEl1j
	/IxbFvRYql8VSRlOHTRFsVU4dXFIp8i7kfCoe/u5Y4ahSQLxU+A==
X-Gm-Gg: ASbGncvv+GNbgb+tzbCrnqCMyW0am2Dg/uDQmhG8QfvHxsa7f8AqA4IDGn8o+d7V7lH
	aXi1kHhHxBf0T5uZikkp+eNfm6dDhR4RnS0qjZ55oWE8PpJEIqDhtno+XEDLqTM9s7BO3eRVbgI
	7Mq9IRlsKyXXQAesQnNZhO7jl04IXKwelXA0uwqjJPZupgTAyy2NI3U3FavD3UQRq/8pu+n9Ymj
	qcusmRLAVh1M2ZtTMuL2P+P8WmJWLDoxpVQWOwTr/jv33unhbOTbQ==
X-Received: by 2002:a05:6e02:1a2d:b0:3a7:c5bd:a5f4 with SMTP id e9e14a558f8ab-3a7f99be195mr27373595ab.0.1733340646147;
        Wed, 04 Dec 2024 11:30:46 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGsK/2HPm3JBTPe5wDquntL8fLLs1nDF6MnU2P7XijNN0MTrZAVrQdqBOGx/aDp9B/vvT7kOA==
X-Received: by 2002:a05:6e02:1a2d:b0:3a7:c5bd:a5f4 with SMTP id e9e14a558f8ab-3a7f99be195mr27373455ab.0.1733340645632;
        Wed, 04 Dec 2024 11:30:45 -0800 (PST)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4e230daa182sm3229710173.19.2024.12.04.11.30.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Dec 2024 11:30:45 -0800 (PST)
Date: Wed, 4 Dec 2024 12:30:40 -0700
From: Alex Williamson <alex.williamson@redhat.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Heiner Kallweit <hkallweit1@gmail.com>, "Rafael J. Wysocki"
 <rafael@kernel.org>, Kirti Wankhede <kwankhede@nvidia.com>,
 kvm@vger.kernel.org
Subject: Re: [PATCH 2/3] vfio/mdev: inline needed class_compat functionality
Message-ID: <20241204123040.7e3483a4.alex.williamson@redhat.com>
In-Reply-To: <2024120410-promoter-blandness-efa1@gregkh>
References: <147a2a3e-8227-4f1b-9ab4-d0b4f261d2a6@gmail.com>
	<0a14a4df-fbb5-4613-837f-f8025dc73380@gmail.com>
	<2024120430-boneless-wafer-bf0c@gregkh>
	<fb0fc57d-955f-404e-a222-e3864cce2b14@gmail.com>
	<2024120410-promoter-blandness-efa1@gregkh>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 4 Dec 2024 19:16:03 +0100
Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

> On Wed, Dec 04, 2024 at 06:01:36PM +0100, Heiner Kallweit wrote:
> > On 04.12.2024 10:32, Greg Kroah-Hartman wrote:  
> > > On Tue, Dec 03, 2024 at 09:11:47PM +0100, Heiner Kallweit wrote:  
> > >> vfio/mdev is the last user of class_compat, and it doesn't use it for
> > >> the intended purpose. See kdoc of class_compat_register():
> > >> Compatibility class are meant as a temporary user-space compatibility
> > >> workaround when converting a family of class devices to a bus devices.  
> > > 
> > > True, so waht is mdev doing here?
> > >   
> > >> In addition it uses only a part of the class_compat functionality.
> > >> So inline the needed functionality, and afterwards all class_compat
> > >> code can be removed.
> > >>
> > >> No functional change intended. Compile-tested only.
> > >>
> > >> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
> > >> ---
> > >>  drivers/vfio/mdev/mdev_core.c | 12 ++++++------
> > >>  1 file changed, 6 insertions(+), 6 deletions(-)
> > >>
> > >> diff --git a/drivers/vfio/mdev/mdev_core.c b/drivers/vfio/mdev/mdev_core.c
> > >> index ed4737de4..a22c49804 100644
> > >> --- a/drivers/vfio/mdev/mdev_core.c
> > >> +++ b/drivers/vfio/mdev/mdev_core.c
> > >> @@ -18,7 +18,7 @@
> > >>  #define DRIVER_AUTHOR		"NVIDIA Corporation"
> > >>  #define DRIVER_DESC		"Mediated device Core Driver"
> > >>  
> > >> -static struct class_compat *mdev_bus_compat_class;
> > >> +static struct kobject *mdev_bus_kobj;  
> > > 
> > > 
> > >   
> > >>  
> > >>  static LIST_HEAD(mdev_list);
> > >>  static DEFINE_MUTEX(mdev_list_lock);
> > >> @@ -76,7 +76,7 @@ int mdev_register_parent(struct mdev_parent *parent, struct device *dev,
> > >>  	if (ret)
> > >>  		return ret;
> > >>  
> > >> -	ret = class_compat_create_link(mdev_bus_compat_class, dev, NULL);
> > >> +	ret = sysfs_create_link(mdev_bus_kobj, &dev->kobj, dev_name(dev));  
> > > 
> > > This feels really wrong, why create a link to a random kobject?  Who is
> > > using this kobject link?
> > >   
> > >>  	if (ret)
> > >>  		dev_warn(dev, "Failed to create compatibility class link\n");
> > >>  
> > >> @@ -98,7 +98,7 @@ void mdev_unregister_parent(struct mdev_parent *parent)
> > >>  	dev_info(parent->dev, "MDEV: Unregistering\n");
> > >>  
> > >>  	down_write(&parent->unreg_sem);
> > >> -	class_compat_remove_link(mdev_bus_compat_class, parent->dev, NULL);
> > >> +	sysfs_remove_link(mdev_bus_kobj, dev_name(parent->dev));
> > >>  	device_for_each_child(parent->dev, NULL, mdev_device_remove_cb);
> > >>  	parent_remove_sysfs_files(parent);
> > >>  	up_write(&parent->unreg_sem);
> > >> @@ -251,8 +251,8 @@ static int __init mdev_init(void)
> > >>  	if (ret)
> > >>  		return ret;
> > >>  
> > >> -	mdev_bus_compat_class = class_compat_register("mdev_bus");
> > >> -	if (!mdev_bus_compat_class) {
> > >> +	mdev_bus_kobj = class_pseudo_register("mdev_bus");  
> > > 
> > > But this isn't a class, so let's not fake it please.  Let's fix this
> > > properly, odds are all of this code can just be removed entirely, right?
> > >   
> > 
> > After I removed class_compat from i2c core, I asked Alex basically the
> > same thing: whether class_compat support can be removed from vfio/mdev too.
> > 
> > His reply:
> > I'm afraid we have active userspace tools dependent on
> > /sys/class/mdev_bus currently, libvirt for one.  We link mdev parent
> > devices here and I believe it's the only way for userspace to find
> > those parent devices registered for creating mdev devices.  If there's a
> > desire to remove class_compat, we might need to add some mdev
> > infrastructure to register the class ourselves to maintain the parent
> > links.
> > 
> > 
> > It's my understanding that /sys/class/mdev_bus has nothing in common
> > with an actual class, it's just a container for devices which at least
> > partially belong to other classes. And there's user space tools depending
> > on this structure.  
> 
> That's odd, when this was added, why was it added this way?  The
> class_compat stuff is for when classes move around, yet this was always
> done in this way?
> 
> And what tools use this symlink today that can't be updated?

It's been this way for 8 years, so it's hard to remember exact
motivation for using this mechanism, whether we just didn't look hard
enough at the class_compat or it didn't pass by the right set of eyes.
Yes, it's always been this way for the mdev_bus class.

The intention here is much like other classes, that we have a node in
sysfs where we can find devices that provide a common feature, in this
case providing support for creating and managing vfio mediated devices
(mdevs).  The perhaps unique part of this use case is that these devices
aren't strictly mdev providers, they might also belong to another class
and the mdev aspect of their behavior might be dynamically added after
the device itself is added.

I've done some testing with this series and it does indeed seem to
maintain compatibility with existing userspace tools, mdevctl and
libvirt.  We can update these tools, but then we get into the breaking
userspace and deprecation period questions, where we may further delay
removal of class_compat.  Also if we were to re-implement this, is there
a better mechanism than proposed here within the class hierarchy, or
would you recommend a non-class approach?  Thanks,

Alex


