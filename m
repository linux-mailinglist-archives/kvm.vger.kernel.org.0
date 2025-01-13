Return-Path: <kvm+bounces-35329-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8AB7CA0C46B
	for <lists+kvm@lfdr.de>; Mon, 13 Jan 2025 23:10:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8DA3F167F67
	for <lists+kvm@lfdr.de>; Mon, 13 Jan 2025 22:10:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4294C1F12EC;
	Mon, 13 Jan 2025 22:10:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FDWuBBsn"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 304511F8EF9
	for <kvm@vger.kernel.org>; Mon, 13 Jan 2025 22:10:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736806214; cv=none; b=GQeHYcyf2tPlg2mZ1zRzGDNY7SNnJTjHBz7ScLMo7E31Iixh3dRHGhqBnSWZhq7ROeDJd9LjZiTVKaThBanlQgaU80cP3IVzCC4/OmVK2fYo46HOZZONZMuHSdBM9IeynY6x7xzTZTQe3cbywGRvQzmCPI9em0Ec22HIoG/pxbw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736806214; c=relaxed/simple;
	bh=NxrIDSVfQYLRZe+g4uJWkHrxqIn8fN/iT1Cblsia8Ig=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=t1x/IYl4fRYZKB0aKD3WnROPyeEz60stIvPa3y90dzQdF79hvT54qXfhAMsP9u9/GomfvlVFH2e59nV7fiUBriPhx1Tw2kszVBf7zxRwBQba84xBlQI4CIVzRbU/Dcfnm/xeY/s/UOowGp2Z1pmagcvW4WDlsMDrB3QSY9dWFwU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FDWuBBsn; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1736806211;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=18QZ8Pd8nNMsgts1fXiqNIPnausrE0wjYEFVhROt/3c=;
	b=FDWuBBsnvJDSNtyDypSF+rUvGXCJ+hEd0o1xLycjODXaNgc8pdIDPAZl0fJiLP8ZcB1eS+
	8dJ7N/TP7Ce34PT9VOowlsEocjzIMBLqYNXdFzXoTgoYQeSSY8yR1PNYxzcK4AHG6iOjrk
	cMm1kWWizwvIakRSwcEinFcZZkZgYmI=
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com
 [209.85.166.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-577-_K4THr8-OKONe3yu2owQrA-1; Mon, 13 Jan 2025 17:10:09 -0500
X-MC-Unique: _K4THr8-OKONe3yu2owQrA-1
X-Mimecast-MFC-AGG-ID: _K4THr8-OKONe3yu2owQrA
Received: by mail-io1-f70.google.com with SMTP id ca18e2360f4ac-849e7868f6eso35567839f.0
        for <kvm@vger.kernel.org>; Mon, 13 Jan 2025 14:10:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736806209; x=1737411009;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=18QZ8Pd8nNMsgts1fXiqNIPnausrE0wjYEFVhROt/3c=;
        b=EO3Kez7gD/YysAoGZLTGUfF+xccxrMUBWUDAmh3RUEkR3D9xB88wlLkIqGXm4cNIA0
         wR8jwSGykLkBP41YxmhHGcllQ653HY4t2REojtnAqRtBGkr5htesb/jOQg/tvxGfrLVH
         s1gb5pslQPEnKajG2JCqDxTQ/6hnwFVERq6laXC3HNpudoLz6uO5rZVuW5MXLuv/ycHF
         XaQwyZMQ2zcGv0O/l7ZZl1HTp2C1wnkFG+Ge3KUJhINg9kWaM7iEcAklwAauWmnqWBXk
         e5Wbo/86gyHdUu4ILz6hjSPTxuCWYsKSkN40DIwiRHz7NkQdlRgBb9HnjyMI6ZUkHBPj
         yPgQ==
X-Forwarded-Encrypted: i=1; AJvYcCUdL14drq0QODVtbv7wyT5ok5SF/fydR86d6hk8nSZtKLdOVubT2maueC4MkbFt2EkHtlM=@vger.kernel.org
X-Gm-Message-State: AOJu0YzsXV3ppZGv79hm7nNmtFULE/cHYdibq7SvcYjfbJ8sYcfQBd1K
	EiO5imn3pnDhgYXM7TsASmukcUmjWiTvcpFY63+99fjpOeNVWZKMGSUSen7iIRCH1O+MsOdFcFs
	6moA93sRYk1xPbWjnbqQQwPqADHkywKNXE24aLVbXoboZ6XCG6g==
X-Gm-Gg: ASbGncv1l9fl8BOBI1XBvL5S7EkellpEj4kcG8+SD5UrEID60+NBP82hn9DBrn2sZtS
	r5PyBuljEcxiW/x31EXQbhUwDt/1Q3TyhlzXhhYjIgASIi01opC9pWs8iZUhnRfq/t/Fa4s/+UI
	CrHwEZFgwhraFpn3OawRPBcN7lZ6F9BThvbB/dny4X8GMqea9AAxkyiE3IXmrp1McwLdTpskAmI
	pJHeYHFf6jpJlSOmLFSIBiJMVDNaHXfZ2ZibXUjPehb6+mVtBsGm7I0T0gO
X-Received: by 2002:a92:c548:0:b0:3cd:edf1:7c79 with SMTP id e9e14a558f8ab-3ce3a8d24a7mr41271155ab.4.1736806209073;
        Mon, 13 Jan 2025 14:10:09 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHeeXJpM9VWyQlIwUSlOqsOzts6XqYxdbKr9aBdY+YuAv4wW/G1y7DQoUw9m1zyiytE3xHtRQ==
X-Received: by 2002:a92:c548:0:b0:3cd:edf1:7c79 with SMTP id e9e14a558f8ab-3ce3a8d24a7mr41271105ab.4.1736806208756;
        Mon, 13 Jan 2025 14:10:08 -0800 (PST)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4ea1b4eabf5sm3021994173.0.2025.01.13.14.10.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jan 2025 14:10:08 -0800 (PST)
Date: Mon, 13 Jan 2025 17:09:55 -0500
From: Alex Williamson <alex.williamson@redhat.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Heiner Kallweit <hkallweit1@gmail.com>, "Rafael J. Wysocki"
 <rafael@kernel.org>, Kirti Wankhede <kwankhede@nvidia.com>,
 kvm@vger.kernel.org
Subject: Re: [PATCH 2/3] vfio/mdev: inline needed class_compat functionality
Message-ID: <20250113170955.29fbea65.alex.williamson@redhat.com>
In-Reply-To: <2025011041-fervor-enlarged-9d52@gregkh>
References: <147a2a3e-8227-4f1b-9ab4-d0b4f261d2a6@gmail.com>
	<0a14a4df-fbb5-4613-837f-f8025dc73380@gmail.com>
	<2025011041-fervor-enlarged-9d52@gregkh>
Organization: Red Hat
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 10 Jan 2025 15:35:30 +0100
Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

> On Tue, Dec 03, 2024 at 09:11:47PM +0100, Heiner Kallweit wrote:
> > vfio/mdev is the last user of class_compat, and it doesn't use it for
> > the intended purpose. See kdoc of class_compat_register():
> > Compatibility class are meant as a temporary user-space compatibility
> > workaround when converting a family of class devices to a bus devices.
> > 
> > In addition it uses only a part of the class_compat functionality.
> > So inline the needed functionality, and afterwards all class_compat
> > code can be removed.
> > 
> > No functional change intended. Compile-tested only.  
> 
> Did this ever get tested?

I wasn't sure where we stand between this and

https://lore.kernel.org/all/db49131d-fd79-4f23-93f2-0ab541a345fa@gmail.com/

I've tested them both separately.

Tested-by: Alex Williamson <alex.williamson@redhat.com>
Acked-by: Alex Williamson <alex.williamson@redhat.com>
 
> > Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
> > ---
> >  drivers/vfio/mdev/mdev_core.c | 12 ++++++------
> >  1 file changed, 6 insertions(+), 6 deletions(-)
> > 
> > diff --git a/drivers/vfio/mdev/mdev_core.c b/drivers/vfio/mdev/mdev_core.c
> > index ed4737de4..a22c49804 100644
> > --- a/drivers/vfio/mdev/mdev_core.c
> > +++ b/drivers/vfio/mdev/mdev_core.c
> > @@ -18,7 +18,7 @@
> >  #define DRIVER_AUTHOR		"NVIDIA Corporation"
> >  #define DRIVER_DESC		"Mediated device Core Driver"
> >  
> > -static struct class_compat *mdev_bus_compat_class;
> > +static struct kobject *mdev_bus_kobj;  
> 
> If you want to resubmit this, after testing, you need some BIG comments
> here as to what you are doing and why, and that no one else should EVER
> do this again so they don't cut/paste from this code to create the same
> mess.

WFM.  Thanks,

Alex


