Return-Path: <kvm+bounces-62012-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id B75DCC32C77
	for <lists+kvm@lfdr.de>; Tue, 04 Nov 2025 20:27:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id C20A34E65F0
	for <lists+kvm@lfdr.de>; Tue,  4 Nov 2025 19:27:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C6C5B2D9498;
	Tue,  4 Nov 2025 19:27:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="Ah8Miwb9"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qv1-f50.google.com (mail-qv1-f50.google.com [209.85.219.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8537A21ABC9
	for <kvm@vger.kernel.org>; Tue,  4 Nov 2025 19:27:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762284438; cv=none; b=C0GnRzpf3M+8AagxndhxUDsSC4veU7oqpJq9AuJ6awx+s7+S3ZnlmV+Xex7rqTPMRiB3OKaTS9ed7rkt/DOZK/R9q1O+qRicbKboh1ZHxbbYyfkUfxlzreJfoSCOptqzMJGsnXiynhFfSnL25MQxDKV663/EUpkniPZHmklCwuU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762284438; c=relaxed/simple;
	bh=ERQVrbBCQIPe4MLibTpmxNghzimhnud2fzegQLVewpk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=i1VVU3eiqO7UR+WR71SbPv6Id2Ll7g6aBhRCTDjp6vd1boykgMVo042/H5Kq0VJMykdNcmr8LT9V76ouBu0+SFJr2tYKmJ5RAyEbWWd3nSQpWp7kGEwqFMV8lohJ8TU5ZgUrwoNBDGJ5HoOpTSiINMI/xXeTjtvcd0x8dfcwZbg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=Ah8Miwb9; arc=none smtp.client-ip=209.85.219.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Received: by mail-qv1-f50.google.com with SMTP id 6a1803df08f44-880570bdef8so25885006d6.3
        for <kvm@vger.kernel.org>; Tue, 04 Nov 2025 11:27:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1762284435; x=1762889235; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=mUs2AdnuvvFczrN0XtEi+7TYEAruGEb9Cu+wb9VP03U=;
        b=Ah8Miwb98PBPZa9TlsLGk1Gm0gaRsYQf+f7ILGvO4khgzWXNJ0AqzV/ArrgDGClKsV
         w8hZs5RgVEmD3roEXkRcFDqA5fkdjRuPXCLuH1eCAc0Hel1AZj+Umtx6A6SW4k8Mxas9
         2D2ykWkHMZ+H6mwRE2OwRu45cBa+2cWPY3J6xNHWZADVH4S8/GIpccCeXM5DO92RUL/B
         f6AJvii6GKfe4749vw8PA2ZZBy5EtJWCk/xIMdKgHV6zZ0iroMJI82HY6edG/DUKSnVy
         ngopOSW21aQLJt5X9MNi3sqJGvHRA2qmjCaSay2wP6UxDugkAfh6vDlsib3gI/CyQQDb
         sbfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762284435; x=1762889235;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mUs2AdnuvvFczrN0XtEi+7TYEAruGEb9Cu+wb9VP03U=;
        b=cXVlvtkBFZQmKeqYkI3CbBY+Hv1q+0e8hnnF5/Ds9aKvSvzQUhFU34rK3r1lMs420N
         fMvsRmV+w5ncMyEcbns3m6JqeKPPXXeCo7swRSWDIoHp3SL4IiOUagmgQ5jQccGRa5dP
         bGDj+uA+4WvUtieX5ENOgSJjT41/BSIGIivCN9kpkokH5Pz94W6NlDRZbUCaDKWf5sQN
         xYzev0TelvoUNg11rsbbEl9j4D6TgO7pu+0Rn1mtCMQk6MrwgXUiXQLn2jvKEc2xdQFT
         sFRhMmDdhXoxEDyJ0t7Y8EKHOZ0BsZGj0Op9et3r2678ePN9zjauLzEFRQUX4DbNGrLx
         AoKw==
X-Forwarded-Encrypted: i=1; AJvYcCUQ49LYGWxW5tjD1WrHFSc0aUF1i2it6MLuLE1zuYe61iZeJS7K+isoweTXfyjnfL/D0T0=@vger.kernel.org
X-Gm-Message-State: AOJu0YyQOlRXHD/beBwfq7WEduiilOvDoot2aCydxSUrrBDUdnKEfJpD
	JrYAjR9nBgz6iugnak0wU09xOW2rq5HH51uP/CYVPS5HP3BdWFLgo+VtlWt9C2I+0Ps=
X-Gm-Gg: ASbGnctK5Ubx2nGY/OBTxHI250HoowyD8LQdcc3utadqgcPgLfd4QyXx/PLR6ohHpzI
	UiQu5DPNw45SdTgT+P2T2klbUw0D8b0RtMx+Z69ZuoFCcppg2bEXHO/X8Khhvo9yUUXkXwsmxCb
	b1kk6fEVpm+zldZzoWcSxwzaaE8GOrG4DkTowJhn3aI3lVeZJezQMF25qIIpHcZc5GLRB+n1orW
	6D7YsL250PHl87D13zZczQgQH+nQPx6WHVua8crnSotrI/oOzNWOqUDvMxSCeStCYclTYcEQlfs
	+/qRCw+X/cea4mH3m44fGmlAGm947uLOHDxmnZ6QlFsQ2JpwQMaozJyKJJWQZp65FPDeeIzLsBD
	2jmskmMF+wFqk+XM/tH3BOyJIevYUbfqQCmtHjsbsz58OtOrSoSLTH8Wag9kupFrO71EjsnyfMB
	7u7BuFrD+NVPQ4HF1bvLtPy1LO1fX+0H2FGcwuwdiEwyT8/eSWnxsiopS8
X-Google-Smtp-Source: AGHT+IG0dhBeAR5RX27f2wfJWdOR7juDgLSbyDVJXq4BJqtIZIC/EimxFvt08yglge630ermzohXtg==
X-Received: by 2002:a05:622a:2d3:b0:4ed:18d5:2140 with SMTP id d75a77b69052e-4ed7262c198mr10018791cf.66.1762284435447;
        Tue, 04 Nov 2025 11:27:15 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-47-55-120-4.dhcp-dynamic.fibreop.ns.bellaliant.net. [47.55.120.4])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4ed5faf6038sm22412071cf.11.2025.11.04.11.27.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Nov 2025 11:27:14 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1vGMgU-000000073Cx-1Hyp;
	Tue, 04 Nov 2025 15:27:14 -0400
Date: Tue, 4 Nov 2025 15:27:14 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Lucas De Marchi <lucas.demarchi@intel.com>
Cc: =?utf-8?Q?Micha=C5=82?= Winiarski <michal.winiarski@intel.com>,
	Alex Williamson <alex@shazbot.org>,
	Thomas =?utf-8?Q?Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Yishai Hadas <yishaih@nvidia.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Shameer Kolothum <skolothumtho@nvidia.com>,
	intel-xe@lists.freedesktop.org, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org, Matthew Brost <matthew.brost@intel.com>,
	Michal Wajdeczko <michal.wajdeczko@intel.com>,
	dri-devel@lists.freedesktop.org,
	Jani Nikula <jani.nikula@linux.intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Tvrtko Ursulin <tursulin@ursulin.net>,
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
	Lukasz Laguna <lukasz.laguna@intel.com>,
	Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v3 27/28] drm/intel/pciids: Add match with VFIO override
Message-ID: <20251104192714.GK1204670@ziepe.ca>
References: <20251030203135.337696-1-michal.winiarski@intel.com>
 <20251030203135.337696-28-michal.winiarski@intel.com>
 <cj3ohepcobrqmam5upr5nc6jbvb6wuhkv4akw2lm5g3rms7foo@4snkr5sui32w>
 <xewec63623hktutmcnmrvuuq4wsmd5nvih5ptm7ovdlcjcgii2@lruzhh5raltm>
 <3y2rsj2r27htdisspmulaoufy74w3rs7eramz4fezwcs6j5xuh@jzjrjasasryz>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3y2rsj2r27htdisspmulaoufy74w3rs7eramz4fezwcs6j5xuh@jzjrjasasryz>

On Tue, Nov 04, 2025 at 11:41:53AM -0600, Lucas De Marchi wrote:

> > > > +#define INTEL_VGA_VFIO_DEVICE(_id, _info) { \
> > > > +	PCI_DEVICE(PCI_VENDOR_ID_INTEL, (_id)), \
> > > > +	.class = PCI_BASE_CLASS_DISPLAY << 16, .class_mask = 0xff << 16, \
> > > > +	.driver_data = (kernel_ulong_t)(_info), \
> > > > +	.override_only = PCI_ID_F_VFIO_DRIVER_OVERRIDE, \
> > > 
> > > why do we need this and can't use PCI_DRIVER_OVERRIDE_DEVICE_VFIO()
> > > directly? Note that there are GPUs that wouldn't match the display class
> > > above.
> > > 
> > > 	edb660ad79ff ("drm/intel/pciids: Add match on vendor/id only")
> > > 	5e0de2dfbc1b ("drm/xe/cri: Add CRI platform definition")
> > > 
> > > Lucas De Marchi
> > > 
> > 
> > I'll define it on xe-vfio-pci side and use
> 
> but no matter where it's defined, why do you need it to match on the
> class? The vid/devid should be sufficient.

+1

Jason

