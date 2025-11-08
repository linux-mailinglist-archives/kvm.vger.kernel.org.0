Return-Path: <kvm+bounces-62379-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 88B16C4239B
	for <lists+kvm@lfdr.de>; Sat, 08 Nov 2025 02:11:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0EF02188C2F6
	for <lists+kvm@lfdr.de>; Sat,  8 Nov 2025 01:12:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 037162BE029;
	Sat,  8 Nov 2025 01:11:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="jFT+GXF0"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qk1-f172.google.com (mail-qk1-f172.google.com [209.85.222.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E2A634D38B
	for <kvm@vger.kernel.org>; Sat,  8 Nov 2025 01:11:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762564307; cv=none; b=VuYb2hEm1z7ZsY6NPTGAS7zHrNbCzY56ToennOjVgzirzlnWl7r9yxM2tBGuxR5EhsDc+p2uGBbpDjGYfY5ofT9duQjBnjfUoVqDITGcTK/VaozEsmU2gYq1o68bbX4HniLq3E2F+DNjzJTo6v2kZj+0grxW0ZjFjj7P7xFoDvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762564307; c=relaxed/simple;
	bh=fzToj5dDPDmAgKJ79e6bVD2SIFNhDcqaLH7py0Vyc8g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RVg1gxiyfea5OHY/dTx8d6RmPZoT77q7MEE0iugfnWs5KjN/PR/hZxOdoMvO/QFih6mGLqYnLAax+UfRTZ4XPlgq2GUIlCge29gYxNQJWzrsIsAmVfA9/bzGjhj/xz+TiCRULtOpUWcn8o7tyOTYrzWqJZIEM7y1HWPVnDfvCCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=jFT+GXF0; arc=none smtp.client-ip=209.85.222.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Received: by mail-qk1-f172.google.com with SMTP id af79cd13be357-8906eb94264so139917485a.0
        for <kvm@vger.kernel.org>; Fri, 07 Nov 2025 17:11:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1762564304; x=1763169104; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Cf4zf8TV/EOP/YsPQoWXgFR8ZzXqCqkCmbhECODLpcg=;
        b=jFT+GXF0CpdtJrydLYTd4j+TkbbofbBb0L3gHvvgKP1z3bWdaUNh7b3WZovYGfAQGA
         bO9daBysl285+ZAKw4xkCWzdHMdUGTmTaV/NFpcc/0RAC3u4wM6b269/E+reffQaBpvj
         D94vFN7ukwinB40M8/XNqX7tmcjMA6/X/CU6MEi8A6qLZxUsVRmf71r5gYvNIgjIoYpm
         Z5JYm1q0aEIvWRNNLySAVb7h13oHYL7we3+Fr6oe3KUFYqRTixlla6Rp4qDkoKuAu9nI
         Fpj1VCwIIMm778IBgKW3n3nBRzTfmADe9KOxafKX4k7FJia5UiTBqryCVD2KDtDpw4/o
         ifJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762564304; x=1763169104;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Cf4zf8TV/EOP/YsPQoWXgFR8ZzXqCqkCmbhECODLpcg=;
        b=gTiARmIc9rTjns5D7tHa/TmSs1ZUgkXCjbWS3Is6yp9dAWqsNQl7ds1P9dFm6/H6P2
         fs/7hKHRKAnDnvDxS6NrQXQpEppLe9TkIezqkfICH2WcvyxQO1KkTFU9EbZpgVwh78P+
         HEQHGxvMvZMPtO8wKQG681/I+ZSj8V0JYPpO7sNumc1DBdWoXAIaitdGvn0YLGdxFq82
         QdX0pHTOoWc/V+wfX33Tvd2T44Ktj4DxlGnxCulnYbBTE2GCSGAuFb3x3f/uP/WrOJLL
         3RCklQHIZm4k9F0j11o50cztt+IViCfjrT9OeNMgVPysmzst4Z3VB5g0+bH/aBUvcfZW
         eT8A==
X-Forwarded-Encrypted: i=1; AJvYcCW/YbDkWnMkcN4s3LFfWRDB5IVMv0RVdaeqLb1Rc3c5feZsdnN0XgA0vxUpoRge+sdIcmk=@vger.kernel.org
X-Gm-Message-State: AOJu0YxwhOZNDMnaNu1fHlO/ZHMoUYJT7LkmA+SZRV+j3/+aoxi2A1/G
	FYv0+EqoZfqBEMETRaVQdQbz6anhSVjRfGSww2oFuBxaXnzixoAIm5tdvm7BVdHAALk=
X-Gm-Gg: ASbGncvFd0+S38XDoSvg996TNPOyADcdaGFAFeHKBDiKsqUUdWfe02sgZhgfH7XcnBE
	oOGC6rZYtkt+N4t9DnO9H04l6ssE3GrhPNlu4gyyA34LjcaRiblDKeR8TiJXSHCTurPtdoGmIpc
	x+vV14Oqe29hyN+QWgWH0fDSKHQB4V3bRUV4tvRBbkVnfi3AmDutO2DuMFMib2tFuGsnS6VwQZm
	KD7BNgsjzJGOXBLcJe2vieXQ8ws5npRCToIw/DB9PcFhZCtpg5DFT8YPSWcCR4OJmvsYFp7xrle
	qxlvRqcyueSdVCVLJ1aoDZaA2bFyZzPwImOSGpyIQcGYuGdFiB0pVfLSukgOOq94Lp8ZD/99+72
	pHNrHqZRqsFKqODKvPZS+fWcEIAj58sRxwY4cDdQQNCuXQ75pG1fdnESR1WSOjt2ya2Xq22iox4
	buiaSOIdQk43S2AVOYitjMe8+BN8NEA3XfPYFXK3kxOUqoWoRwwr2PkWjT
X-Google-Smtp-Source: AGHT+IHgQm4crSoFbOP6aPyQmLcW59espnioyKWZw+sam6UcNVlWlMqDlHJNn7lZhEfcTWvrH5yFgA==
X-Received: by 2002:a05:620a:209b:b0:8b2:2719:ed33 with SMTP id af79cd13be357-8b257f3c71amr135197285a.46.1762564304210;
        Fri, 07 Nov 2025 17:11:44 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-47-55-120-4.dhcp-dynamic.fibreop.ns.bellaliant.net. [47.55.120.4])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8b2355e615bsm530534085a.19.2025.11.07.17.11.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Nov 2025 17:11:43 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1vHXUV-00000008NdU-17Dq;
	Fri, 07 Nov 2025 21:11:43 -0400
Date: Fri, 7 Nov 2025 21:11:43 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: "Tian, Kevin" <kevin.tian@intel.com>
Cc: "Winiarski, Michal" <michal.winiarski@intel.com>,
	Alex Williamson <alex@shazbot.org>,
	"De Marchi, Lucas" <lucas.demarchi@intel.com>,
	Thomas =?utf-8?Q?Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	"Vivi, Rodrigo" <rodrigo.vivi@intel.com>,
	Yishai Hadas <yishaih@nvidia.com>,
	Shameer Kolothum <skolothumtho@nvidia.com>,
	"intel-xe@lists.freedesktop.org" <intel-xe@lists.freedesktop.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"Brost, Matthew" <matthew.brost@intel.com>,
	"Wajdeczko, Michal" <Michal.Wajdeczko@intel.com>,
	"dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
	Jani Nikula <jani.nikula@linux.intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Tvrtko Ursulin <tursulin@ursulin.net>,
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
	"Laguna, Lukasz" <lukasz.laguna@intel.com>,
	Christoph Hellwig <hch@infradead.org>,
	"Cabiddu, Giovanni" <giovanni.cabiddu@intel.com>,
	Brett Creeley <brett.creeley@amd.com>
Subject: Re: [PATCH v4 28/28] vfio/xe: Add device specific vfio_pci driver
 variant for Intel graphics
Message-ID: <20251108011143.GE1859178@ziepe.ca>
References: <20251105151027.540712-1-michal.winiarski@intel.com>
 <20251105151027.540712-29-michal.winiarski@intel.com>
 <BN9PR11MB52766F70E2D8FD19C154CE958CC2A@BN9PR11MB5276.namprd11.prod.outlook.com>
 <7dtl5qum4mfgjosj2mkfqu5u5tu7p2roi2et3env4lhrccmiqi@asemffaeeflr>
 <BN9PR11MB52768763573DF22AB978C8228CC3A@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20251108004754.GD1859178@ziepe.ca>
 <BN9PR11MB52768BF0A4E6FA1B234E33108CC0A@BN9PR11MB5276.namprd11.prod.outlook.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB52768BF0A4E6FA1B234E33108CC0A@BN9PR11MB5276.namprd11.prod.outlook.com>

On Sat, Nov 08, 2025 at 01:05:55AM +0000, Tian, Kevin wrote:
> > From: Jason Gunthorpe <jgg@ziepe.ca>
> > Sent: Saturday, November 8, 2025 8:48 AM
> > 
> > On Fri, Nov 07, 2025 at 03:10:33AM +0000, Tian, Kevin wrote:
> > > > To me, it looks like something generic, that will have impact on any
> > > > device specific driver variant.
> > > > What am I missing?
> > > >
> > > > I wonder if drivers that don't implement the deferred reset trick were
> > > > ever executed with lockdep enabled.
> > > >
> > >
> > > @Jason, @Yishai, @Shameer, @Giovanni, @Brett:
> > >
> > > Sounds it's a right thing to pull back the deferred reset trick into
> > > every driver. anything overlooked?
> > 
> > It does seem like we should probably do something in the core code to
> > help this and remove the duplication.
> 
> from backport p.o.v. it might be easier to first fix each driver 
> independently then remove the duplication in upstream? 

If it hasn't bothered anyone yet I wouldn't stress about backporting..

Maybe those drivers do work for some unknown reason?

Plus it is *really* hard to actually hit this deadlock..

Jason

