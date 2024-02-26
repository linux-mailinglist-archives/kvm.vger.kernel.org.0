Return-Path: <kvm+bounces-9991-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B477E86813C
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 20:41:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E63B11C2903A
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 19:41:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8DBD5130ADB;
	Mon, 26 Feb 2024 19:41:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="g1AqjQym"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC1B312FF72
	for <kvm@vger.kernel.org>; Mon, 26 Feb 2024 19:41:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708976480; cv=none; b=lnN0KJaWuqIT2ypxIz3Y685KgrWW7IJ0XeK5EDiQT2gogpObvgOj2dv7JNlYHDLxtCl44RkN5I6RVkU4/nGLNecQsptdQYFDfuZZI/3LCm/tqKE9F0ARtbp/F/YC9xgqy/SUAmW8oIYdL1DcBOLs2tcwf5EByK25bvUV1fnrml0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708976480; c=relaxed/simple;
	bh=x628PMNIjEu+GPKy+4TVIAw2AOn9qlhn8qxd9uSv5uM=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ODOJnwYpXhj2EREjrrEZxGq5eTkMkRCbUrTh/UZoc6nLj1Q198j/cQZakDALAu6NXWr8QfSwGZGp7hHYronYAeQoXhlPMghCvAqmf2fEFADoGCrdt2UClk9+KdXainqPpbSdGXN2kdmOXgWL00FOh2tS3aYk/T7DOlW87PPbkH0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=g1AqjQym; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1708976477;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=badWDkj2YkXDjBt3ARyYRqGgukXsc8wuzH22/FWY+Zg=;
	b=g1AqjQymmo1ss8VKRIrFOtX5KJ8q3enpJ+1PWwIdESjAzqUoXzzdCxHIkRQzkJtabPHaMN
	BkcrHwYTykNB8ktgsuH9lWMmmLy7sVYeiaqeK6NKgxHZIVaxqHhmSmdM4r5J8cQpgg0WlX
	gmN47BDXIK+5Lqt42SeMRQSo8CXhGa4=
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com
 [209.85.166.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-367-2DWF5zdINzOTnzx1R4zfKQ-1; Mon, 26 Feb 2024 14:41:09 -0500
X-MC-Unique: 2DWF5zdINzOTnzx1R4zfKQ-1
Received: by mail-io1-f72.google.com with SMTP id ca18e2360f4ac-7c79b0aaa86so303045139f.2
        for <kvm@vger.kernel.org>; Mon, 26 Feb 2024 11:41:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708976469; x=1709581269;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=badWDkj2YkXDjBt3ARyYRqGgukXsc8wuzH22/FWY+Zg=;
        b=vGqueelGkQsxajfWJ6AorsAa7Tr7oFXgrxxDCbrnOz4ntEoaiB5/G7/+N2XdczRGTH
         kLlKoP3LDm8AlN7u9QnNzRJnSDs7/uy6aoaETRs/bUxA6fFp6JDGTFZ3koUeEpKULW7K
         YVQKjbHqFmJAZkEJQbA7N5yPZxxgzEl8hyWG1RLs5BlJBUsl+8Z4pgfxx2Xz8SeRIZVp
         tGgEZLnPPF45Dm8nmZJ+dXC4cn/OEDOpsthSU8dkYHeaQZiNH4NzxN7U5DjJFSFqVZ1p
         mIZ+x1IRbgkchkItIiD3TzEPUz1Nhcf3K+aq/vD7pK5FuTDwRrujFh+il4yFQUMXrjv8
         DuFQ==
X-Forwarded-Encrypted: i=1; AJvYcCVI/01pkechzXWREXg7ZZmLnJWqcAxLcgrZ6WLcLUwPuMhZ4hRK/qOVaAm3aSyw5P+Jo9TG0nu1JQqWelbSOfem3Igv
X-Gm-Message-State: AOJu0YyzCZqIFoQ1GJd1YofPo0TcPx8NGPRYRi4aU8kCQKiQmJvkSzj0
	jwHUZ4o16xDUAivYm0r/JlC4wVVxaM2YsgrEcps0DTK6NDcTZW4Si3p2hdqb1jp+dllVXQa/9xw
	3Aw+sashUa0pmwSU6cMTuSBXDUK5xFbywERCWGbDssECHxALAEg==
X-Received: by 2002:a6b:7002:0:b0:7c7:e215:d7a3 with SMTP id l2-20020a6b7002000000b007c7e215d7a3mr122861ioc.18.1708976469039;
        Mon, 26 Feb 2024 11:41:09 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHIK/Dy6sFQlbBs99kDqRsbW0lPK+LM/dnqKqgSgFP+8ik3ExkiF17wdCn80lyzWXN1TM8SDA==
X-Received: by 2002:a6b:7002:0:b0:7c7:e215:d7a3 with SMTP id l2-20020a6b7002000000b007c7e215d7a3mr122843ioc.18.1708976468794;
        Mon, 26 Feb 2024 11:41:08 -0800 (PST)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id r4-20020a056638044400b0047469899515sm1409393jap.154.2024.02.26.11.41.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Feb 2024 11:41:07 -0800 (PST)
Date: Mon, 26 Feb 2024 12:41:07 -0700
From: Alex Williamson <alex.williamson@redhat.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Xin Zeng <xin.zeng@intel.com>, herbert@gondor.apana.org.au,
 yishaih@nvidia.com, shameerali.kolothum.thodi@huawei.com,
 kevin.tian@intel.com, linux-crypto@vger.kernel.org, kvm@vger.kernel.org,
 qat-linux@intel.com, Yahui Cao <yahui.cao@intel.com>
Subject: Re: [PATCH v3 10/10] vfio/qat: Add vfio_pci driver for Intel QAT VF
 devices
Message-ID: <20240226124107.4317b3c3.alex.williamson@redhat.com>
In-Reply-To: <20240226191220.GM13330@nvidia.com>
References: <20240221155008.960369-1-xin.zeng@intel.com>
	<20240221155008.960369-11-xin.zeng@intel.com>
	<20240226115556.3f494157.alex.williamson@redhat.com>
	<20240226191220.GM13330@nvidia.com>
X-Mailer: Claws Mail 4.2.0 (GTK 3.24.41; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 26 Feb 2024 15:12:20 -0400
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Mon, Feb 26, 2024 at 11:55:56AM -0700, Alex Williamson wrote:
> > This will be the first intel vfio-pci variant driver, I don't think we
> > need an intel sub-directory just yet.
> > 
> > Tangentially, I think an issue we're running into with
> > PCI_DRIVER_OVERRIDE_DEVICE_VFIO is that we require driver_override to
> > bind the device and therefore the id_table becomes little more than a
> > suggestion.  Our QE is already asking, for example, if they should use
> > mlx5-vfio-pci for all mlx5 compatible devices.  
> 
> They don't have to, but it works fine, there is no reason not to.

But there's also no reason to.  None of the metadata exposed by the
driver suggests it should be a general purpose vfio-pci stand-in.

> I imagined that users would always bind the variant driver, it is why
> the drivers all have "disabled" fallbacks to just be normal vfio-pci.
> 
> > I wonder if all vfio-pci variant drivers that specify an id_table
> > shouldn't include in their probe function:
> > 
> > 	if (!pci_match_id(pdev, id)) {
> > 		pci_info(pdev, "Incompatible device, disallowing driver_override\n");
> > 		return -ENODEV;
> > 	}  
> 
> Certainly an interesting idea, doesn't that completely defeat driver
> binding and new_id though?

I guess we always send a compatible id, so it'd be more a matter of
exporting and testing id against pci_device_id_any, that would be the
footprint of just a driver_override match (or an extremely liberal
dynamic id).

> You are worried about someone wrongly loading a mlx5 driver on, say,
> an Intel device?

That's sort of where we're headed if we consider it valid to bind a CX5
to mlx5-vfio-pci just because they have a host driver with a similar
name in common.  It's essentially a free for all.  I worry about test
matrices, user confusion, and being on guard for arbitrary devices at
every turn in variant drivers if our policy is that they should all work
equivalent to a basic vfio-pci-core implementation for anything.

> > (And yes, I see the irony that vfio introduced driver_override and
> > we've created variant drivers that require driver_override and now we
> > want to prevent driver_overrides)  
> 
> Heh
>  
> > Jason, are you seeing any of this as well and do you have a better
> > suggestion how we might address the issue?  Thanks,  
> 
> I haven't heard of confusion here.. People who don't care just use
> vfio-pci like the internet tells them, people who do care seem to be
> very sophisticated right now..
> 
> Did the userspace tool Max sketched out to automatically parse the id
> tables ever get completed? That seems like the best solution, just
> automate it and remove the decision from the user.

libvirt recently implemented support for managed="yes" with variant
drivers where it will find the best "vfio_pci" driver for a device
using an algorithm like Max suggested, but in practice it's not clear
how useful that will be considering devices likes CX7 require
configuration before binding to the variant driver.  libvirt has no
hooks to specify or perform configuration at that point.

The driverctl script also exists and could maybe consider the
"vfio-pci" driver name to be a fungible alias for the best matching
vfio_pci class driver, but I'm not sure if driverctl has a sufficient
following to make a difference.  Thanks,

Alex


