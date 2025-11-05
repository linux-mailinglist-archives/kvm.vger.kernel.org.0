Return-Path: <kvm+bounces-62126-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 03DCBC37FEE
	for <lists+kvm@lfdr.de>; Wed, 05 Nov 2025 22:26:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 8E48B4EBB48
	for <lists+kvm@lfdr.de>; Wed,  5 Nov 2025 21:23:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C31292DE6F9;
	Wed,  5 Nov 2025 21:19:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="MSyNrDLD"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E37B2DBF4B
	for <kvm@vger.kernel.org>; Wed,  5 Nov 2025 21:19:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762377567; cv=none; b=HGEUERBPWL0S0Xt886g9q62U720jNUvcrnkk0641p3g6RSH2Q64EawI2Qp32hR7slzMWnkUF5WqyZM9JAsHDiQVQkW/G5jDkhQfyHKO8WPSW6XRnCCJdjpO08PpZP+umfbU5eJTCkygOR/pWewVCGsKd/YkUm+Y7slDBr7ZCasY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762377567; c=relaxed/simple;
	bh=qCj0HkjcLlvzURF6w77QHtU0WP9/ZsapXnXVQY35VDE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uZg9VhkZpIf7pYgfwlVbOzYSTmXQ+no43AEnhwwYWi/BH/7Uhy1KIDLMXYYndjoJuVK6ZYcMgDXBdorjAKvjL+1SBf8+m0/f2Dk9S/K91+oJ/oatqq0dXs06rz9TtQfUwoHZoUa44fh8bTAoXARxiw1TZKftmhPJ8OluhL25MTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=MSyNrDLD; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2959197b68eso11055ad.1
        for <kvm@vger.kernel.org>; Wed, 05 Nov 2025 13:19:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762377565; x=1762982365; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=wsPKARLgoDbiEbqdjmx1yQIPjPrrWc4YFZC2utX6iXU=;
        b=MSyNrDLDOzz5fvFQWFa8k4op61UU9jUNtn2NmFE0/5qxxkI1PDwmqcVfwXQ9RyAlEw
         x/ZTGRNd9oBLWyuApaCS46A8feSLwLPNPjt6SGrCzwJbOB29y0oQA9nwXxFXGetmXDzk
         cYRFwtkPKaYl+OOJqOM0LanNN2Cu6kwVk4x85eoWViTekWKbhd2SAYcYnqPjV4wLu3hV
         SsdJ046YlAeEAdiVPkxs9nmzn19gH7sBhM11SnK4ejybsNOjdSKciNID3wdEaNYLvKJE
         HObxa0DgbuhMu7iWs+H1/Nv63HgYmLn5BjqdxcV8HkQdLxekw+Ax4iSS2sySgx45dirt
         BEqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762377565; x=1762982365;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wsPKARLgoDbiEbqdjmx1yQIPjPrrWc4YFZC2utX6iXU=;
        b=UMTLhPWDsLq++Z97+dSbtlzjByjVcQESUlezFscPWYajdEwxu2o7DpRpmY5bxjeKoz
         /98/au9IBKCwyzLJfBQlM9+P7epnd+cXjM77SZ8EKT1DErIH8fJBq0/oefIyrGSuymFK
         1WmZR+XjjVi536nfkN3JGGUUZZP+nfAbhisOzShoe797zwhvcwyY7CktKRqLSxFR6IVK
         Sa4UsshI25wA7klYVLnileXSGFF2t/9R6O6ytX70SVYxIiG5UzoM43gh/bHaLDHy7qc+
         1kxjgfKwgquMu3MF2ht1irB7qO5M4iUfEmcTK8kSkwwvjPOBCdEwddS8K8EMCj7WXQfK
         1NnA==
X-Forwarded-Encrypted: i=1; AJvYcCXJ3UdTCCJi7c1CMARLibtyXXGtH4iPTJNDF7dfkuUN6RDCwsOsFz3mdzIMM06Z4b/P7L8=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx91NbjroaorWYzNdvvjP62nqtyDlxMUjUht1FTKf/iSB/mIZgz
	HpEs1ipHL7fleya08ZTV/QV5Y5L/lGBHvFEAdtlCYNXfCZ6Qilqq9JA5j7KBEjFKKA==
X-Gm-Gg: ASbGncvEEM72HORnUKDhrz7oZ0nzbJR0kFm+DWwPUfiSgPwPiOePFOny+cTSecXCgbn
	4yD9sWEZ/MsFdeZcl6gcFJ8IBx0+4gc7g2uFmGh0c76LWsSeTMfdFxq4mXL+NCzr3bwMzGX8rFn
	/PrZ7lMcZiITEUhHg4IkjmzIGaW4Wfxpo8ov4TpulIMB8JnQ7MJRelvzjKe5hdgo3xXUdtqb78V
	QE0677CIyOPZ5IrpHrpKP9bv3Ljb9fisPDX8Ix4KthslS3E73tFQgV0eSUVFd61Vn/DOPihX+cf
	wVP6WqQu2+4VFp6k7WUF3BZsKq7SbBi+QMk/d6x5GtSaRivaWBPJ6Rmq4qZsrwig0zmrkfXmPBJ
	MhAB2VwT+Sh1OiXYzLor8gBNzGUniCYsjYnwYzu+MerZPps+cWt38XHwONHH3s+j/ZYbrM0GHbu
	9uTz6bgYEGgROS0PUTnOpS21hdJuaHWVyGTc66fQ==
X-Google-Smtp-Source: AGHT+IEIIO35cH2PrBkhqYMd/E+xZSf3lgI2yKX1DyfVtbO2pYBYeKyrnA3lBD1BQHg2AJrJT8JqeQ==
X-Received: by 2002:a17:902:d505:b0:266:b8a2:f5d8 with SMTP id d9443c01a7336-29655c7a119mr1205695ad.14.1762377564053;
        Wed, 05 Nov 2025 13:19:24 -0800 (PST)
Received: from google.com (164.210.142.34.bc.googleusercontent.com. [34.142.210.164])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7af82bf14d6sm365224b3a.66.2025.11.05.13.19.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Nov 2025 13:19:23 -0800 (PST)
Date: Wed, 5 Nov 2025 21:19:13 +0000
From: Pranjal Shrivastava <praan@google.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Alex Williamson <alex@shazbot.org>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	David Airlie <airlied@gmail.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Ankit Agrawal <ankita@nvidia.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Brett Creeley <brett.creeley@amd.com>,
	dri-devel@lists.freedesktop.org, Eric Auger <eric.auger@redhat.com>,
	Eric Farman <farman@linux.ibm.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>, intel-gfx@lists.freedesktop.org,
	Jani Nikula <jani.nikula@linux.intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org,
	Kirti Wankhede <kwankhede@nvidia.com>, linux-s390@vger.kernel.org,
	Longfang Liu <liulongfang@huawei.com>,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	Nikhil Agarwal <nikhil.agarwal@amd.com>,
	Nipun Gupta <nipun.gupta@amd.com>,
	Peter Oberparleiter <oberpar@linux.ibm.com>,
	Halil Pasic <pasic@linux.ibm.com>, qat-linux@intel.com,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Simona Vetter <simona@ffwll.ch>,
	Shameer Kolothum <skolothumtho@nvidia.com>,
	Mostafa Saleh <smostafa@google.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Tvrtko Ursulin <tursulin@ursulin.net>,
	virtualization@lists.linux.dev,
	Vineeth Vijayan <vneethv@linux.ibm.com>,
	Yishai Hadas <yishaih@nvidia.com>,
	Zhenyu Wang <zhenyuw.linux@gmail.com>,
	Zhi Wang <zhi.wang.linux@gmail.com>, patches@lists.linux.dev
Subject: Re: [PATCH 14/22] vfio: Require drivers to implement get_region_info
Message-ID: <aQu_Uc_ZmBJUgw0_@google.com>
References: <0-v1-679a6fa27d31+209-vfio_get_region_info_op_jgg@nvidia.com>
 <14-v1-679a6fa27d31+209-vfio_get_region_info_op_jgg@nvidia.com>
 <aQhcOYVbY-LqOjW5@google.com>
 <20251105134829.333243dd.alex@shazbot.org>
 <20251105205600.GX1537560@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251105205600.GX1537560@nvidia.com>

On Wed, Nov 05, 2025 at 04:56:00PM -0400, Jason Gunthorpe wrote:
> On Wed, Nov 05, 2025 at 01:48:29PM -0700, Alex Williamson wrote:
> > On Mon, 3 Nov 2025 07:39:37 +0000
> > Pranjal Shrivastava <praan@google.com> wrote:
> > 
> > > On Thu, Oct 23, 2025 at 08:09:28PM -0300, Jason Gunthorpe wrote:
> > > > Remove the fallback through the ioctl callback, no drivers use this now.
> > > > 
> > > > Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> > > > ---
> > > >  drivers/vfio/vfio_main.c | 8 ++++----
> > > >  1 file changed, 4 insertions(+), 4 deletions(-)
> > > > 
> > > > diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
> > > > index a390163ce706c4..f056e82ba35075 100644
> > > > --- a/drivers/vfio/vfio_main.c
> > > > +++ b/drivers/vfio/vfio_main.c
> > > > @@ -1297,13 +1297,13 @@ static long vfio_device_fops_unl_ioctl(struct file *filep,
> > > >  		break;
> > > >  
> > > >  	case VFIO_DEVICE_GET_REGION_INFO:
> > > > -		if (!device->ops->get_region_info)
> > > > -			goto ioctl_fallback;
> > > > -		ret = device->ops->get_region_info(device, uptr);
> > > > +		if (unlikely(!device->ops->get_region_info))
> > > > +			ret = -EINVAL;  
> > 
> > Nit, typically I would have expected a success oriented flow, ie.
> > 
> > 		if (likely(device->ops->get_region_info))
> > 			ret = device->ops->get_region_info(device, uptr);
> > 		else
> > 			ret = -EINVAL;
> > 
> > But it goes away in the next patch, so *shrug*.
> 
> Yeah, still I can edit it..
> 
> > > Nit: Let's also add a warn/err log here highliting that the device
> > > doesn't populate the get_region_info op?
> > 
> > Are devices required to implement regions?  If so, it'd be more
> > appropriate to fail the device registration in __vfio_register_dev()
> > for the missing op than wait for an ioctl.  However, here in the device
> > agnostic layer of vfio, I think the answer leans more towards no, we
> > could theoretically have a device with no regions.  We also want to be
> > careful not to introduce a WARN_ON that's user trigger'able.  Thanks,
> 
> Yeah, I had the same thought, so lets leave this. If we do want a warn
> it should be in registration.
> 
> A device without regions does not seem useful, but also it doesn't
> malfunction if someone does want to do that.
> 

I agree with the both of you.. I just thought if we should remind the
user with a log that the dev doesn't expose a region. But I guess we
don't need to worry about that.

> Thanks,
> Jason

Thanks,
Praan

