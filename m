Return-Path: <kvm+bounces-35485-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id ACE1DA11646
	for <lists+kvm@lfdr.de>; Wed, 15 Jan 2025 01:55:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id F21D9188AF70
	for <lists+kvm@lfdr.de>; Wed, 15 Jan 2025 00:55:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 60CCF35945;
	Wed, 15 Jan 2025 00:55:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="GVLvLw5Y"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qv1-f43.google.com (mail-qv1-f43.google.com [209.85.219.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A48973594F
	for <kvm@vger.kernel.org>; Wed, 15 Jan 2025 00:55:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736902508; cv=none; b=g2ILfmROE+Hb3ZrpNKcIetRwBWrNaP0aSi8UkrWog8QNJLSMdQaffmoxRR490QxV1KK/kHWx1fPrHeOD+zKInSF1QF85eeOJxHUAlOwSUjdqg0yXXOhzJAfT4QHKHHohkBzLXJlbegR2vQ8A8qoi5KVe3PGq9CktbcCBV3uvi4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736902508; c=relaxed/simple;
	bh=vrlH48UNEPf1VIaFGLNIiQJdDc7yHCcQpcsSEsGsgDs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nY6yxRR+9jnNaWlBdWuZvSwaVfGjioD3i/1Nlwu5ygY6s+vCgv4vIjTr5TltNRF4RNLzNzziUU3KdVmeJhpxKabBchYEqWBm7mlcrhu6QqyH7M53RNJMo3vkLpqAvjw5/E3GK0emjopdxOdrsFdFmEefLvGwpZOTd0+CKXeVffs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=GVLvLw5Y; arc=none smtp.client-ip=209.85.219.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Received: by mail-qv1-f43.google.com with SMTP id 6a1803df08f44-6dd43b08674so58542866d6.3
        for <kvm@vger.kernel.org>; Tue, 14 Jan 2025 16:55:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1736902504; x=1737507304; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=10EzHPSG2bUCygPfgif9/cuh6edjmOAn/OyamE628Pg=;
        b=GVLvLw5YlsdhlZ04H70q/3H8oh+J4k84snVM4I5T4LmBirDy5oO2cfcWrKy+DERQYd
         kvfnJy4EFEu1cunbV49Oz54uX7lLcmnQ+JJJzjyy1SJM3xC01WKmUU+mRdlrv0CkDHAo
         kDxz1XuuHviJr/Rr9yRs+mwrRmrpGvdyWwbenKfF2SpM2LhUppwoCYclodp0T6+0PUHD
         2EiiW1828z59mUlN5PWNv+w9REqEeLkGl2JvU0lYVEAOTQIW5ePg94Bqaq3gs7COPPLS
         VvqAJ6zSydyeh9JszLk3gKa9FEYdQhH8HhqGCGKGxj2aFa65MX9IyNTraOt5K8MsJ2+v
         7bqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736902504; x=1737507304;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=10EzHPSG2bUCygPfgif9/cuh6edjmOAn/OyamE628Pg=;
        b=VGETRGkkt0fUNNAqRSBMxTh7DPSnxPMHP9dtViqsbHqVX/NIVvkQHpQmMtDA5FW0lw
         Y/PmbHxZtJzyfEx1cAvAxFMN9FaxVaDw3EsVGmQ1mXijP9HrgLWw7kcsNrNPn2uw6hB5
         uLLMFTJPne7uJx7xuny9BiDG1SK7/R44DAVDgmhKQ695zyoYKbMIai30IP/1xytP0SXW
         TWTmU3A+U1frsorLjfbuopP+cgj1UcFtUzieDbDj/p/Xizn4S0DeeJyzLMyhQ136GEaW
         MdgQFW1TiKFlMyJkMOQt8q3IgU1bmz+7wxW4ifqR7BwDt+TWCD7CB8XxpXHyAThXy/n9
         UrPg==
X-Forwarded-Encrypted: i=1; AJvYcCUqVNAMxPw4B4IFpEMXCuLTKFr1Y0YMLqK//CMQHfVRd2H+z0EuAHu/nkyxBxsVp3HblT0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz7OgXHkCUQX4qsZNnWwBx+tqKYM7KsGKlTed71llsCtZ8bJ5jl
	+YOR0A+13bCWpDtHsYnW/oliNPYwA0Kyuv0/Sx9wWYy8+0Dc8LBAk8E+1Dh0qEA=
X-Gm-Gg: ASbGncuKXDgv0WopYa+1Jq0xyX8gR4m219zIdfwY2YL1rFULT3nWGRc2N2/EIZ2oB9A
	p8Sp/d5egFHEItX5mVENuxVqVbe8CNaXrK4gAyk+cKPVPuOND0ND3hxrJtZIiEJmDs8TgFUWiWT
	Nb28aE39ewAvRAgzFiJEF0E8gLhoV7BJPZMvEL1RUX+eYj3jztfpSqU8GA+tcky2FIjv1vh4Vd6
	uRcjUmPx9Z84zygrLOClvjd7t9ABXSX+GF/zUJ22ptDCGwAoIw6ZPrQ7HgAi7+Y5uk8kIEbRwmB
	wVaWPWwXJYh2o56NI3LJDNXwfd46kw==
X-Google-Smtp-Source: AGHT+IGLjfKxJ87rrVPmCkPy9xlvuSl1hb5LjUEXsPjyZRxMzyEbB2OUkapE5LIwVE830rdPyRwJMA==
X-Received: by 2002:a05:6214:3289:b0:6d4:1d4a:70e9 with SMTP id 6a1803df08f44-6df9b1f3028mr464639926d6.19.1736902504504;
        Tue, 14 Jan 2025 16:55:04 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-68-128-5.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.128.5])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6dfad85ffe6sm58924276d6.16.2025.01.14.16.55.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jan 2025 16:55:03 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1tXrgV-00000002jAI-18zj;
	Tue, 14 Jan 2025 20:55:03 -0400
Date: Tue, 14 Jan 2025 20:55:03 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Yi Liu <yi.l.liu@intel.com>
Cc: alex.williamson@redhat.com, kevin.tian@intel.com, eric.auger@redhat.com,
	nicolinc@nvidia.com, kvm@vger.kernel.org,
	chao.p.peng@linux.intel.com, zhenzhong.duan@intel.com,
	willy@infradead.org, zhangfei.gao@linaro.org, vasant.hegde@amd.com
Subject: Re: [PATCH v6 0/5] vfio-pci support pasid attach/detach
Message-ID: <20250115005503.GP26854@ziepe.ca>
References: <20241219133534.16422-1-yi.l.liu@intel.com>
 <20250114140047.GK26854@ziepe.ca>
 <3428d2b7-8f91-43ed-8c8a-08358850cc66@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3428d2b7-8f91-43ed-8c8a-08358850cc66@intel.com>

On Wed, Jan 15, 2025 at 08:22:59AM +0800, Yi Liu wrote:
> On 2025/1/14 22:00, Jason Gunthorpe wrote:
> > On Thu, Dec 19, 2024 at 05:35:29AM -0800, Yi Liu wrote:
> > > This adds the pasid attach/detach uAPIs for userspace to attach/detach
> > > a PASID of a device to/from a given ioas/hwpt. Only vfio-pci driver is
> > > enabled in this series. After this series, PASID-capable devices bound
> > > with vfio-pci can report PASID capability to userspace and VM to enable
> > > PASID usages like Shared Virtual Addressing (SVA).
> > 
> > It looks like all the dependencies are merged now, so we should be
> > able to consider merging this and the matching iommufd series for the
> > next cycle. Something like week of Feb 10 if things are OK with the
> > series?
> 
> Hi Jason,
> 
> I think the major undone dependency is the iommufd pasid series. We might
> need to wait for it before merging this. :)

I aim to take them together, we should try to avoid adding unused code
to the kernel, I'd look to Alex to Ack this and we'd taken them all at
once.

Jason

