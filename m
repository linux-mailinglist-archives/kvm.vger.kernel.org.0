Return-Path: <kvm+bounces-61406-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id EC11AC1C2F7
	for <lists+kvm@lfdr.de>; Wed, 29 Oct 2025 17:43:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 26A115094C3
	for <lists+kvm@lfdr.de>; Wed, 29 Oct 2025 16:21:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1CAD0330312;
	Wed, 29 Oct 2025 16:21:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="hBPH8QFx"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qk1-f178.google.com (mail-qk1-f178.google.com [209.85.222.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 799071B87C0
	for <kvm@vger.kernel.org>; Wed, 29 Oct 2025 16:21:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761754876; cv=none; b=BCPLmbc/NUwYhzl6eeXFnMh/EVpIhqAlQA9oyeh9cLZb5YcJTch8ZflfkXcE0ItXM44PV5L1KKrWl/tlAccMgUyzIGFpjI22CJUkqOAHxll12g12IVl54peO7cJbE2yourJE9UPZlJZe9CyHv5dXVb16sr/FgvuK5TjWl8hrTUM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761754876; c=relaxed/simple;
	bh=tutHpDERpk2grTdSQkF8arln6wjfSewQh6BuPKWPSpA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kelqyHHmAzaONugQDn++YjL6X1/zYHwMMvIRNEFbi2uYL1pFL7cm7wZPDhi7zCWfm8D3gFQalXzYKa+GpUN3KIP1cKNZK72MpPFZ5rQzW7NtCF2xGHLBudb0AAgkv0VCuJix3x7m2Wn48IbS2awVOsH08w2KPkZhu9qaaEMQeL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=hBPH8QFx; arc=none smtp.client-ip=209.85.222.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Received: by mail-qk1-f178.google.com with SMTP id af79cd13be357-89ef0cec908so629317885a.1
        for <kvm@vger.kernel.org>; Wed, 29 Oct 2025 09:21:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1761754873; x=1762359673; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=3aZqVH3f6Ms1xWvoULJF1KIgdQvKJ2oeCT0jMy+sgwI=;
        b=hBPH8QFxDaOuHB3ajgnQ0BdO5WWZImIllkLNypfWT7qiMZjdhaD0RluiGTrAZcF5nE
         6VN4QEu+cjXP+huJGxnZ0QF78ftK4Phhi1JxDjiggKmAhJoaWx+NR6F2eElH1KwqrC9Y
         Q4Dx/kTmq6VbFYKdnI+4n2fENFfWLLh+71uY+ro/Ghut8pblOScCRG5AEyuoxD138+IE
         MfNsJz3m91YtTCyAft1S8Y47PjGxHBS8xjEaOOzsYfcz7jJBbWBHjTePyY3lNmaI2d2o
         eSsaxWUuVgyXrsj75w0n4LS6bBH6TiNUK4lPr8rbIIEMW01rk33OsI0mVBhn3pvdMxsl
         es7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761754873; x=1762359673;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3aZqVH3f6Ms1xWvoULJF1KIgdQvKJ2oeCT0jMy+sgwI=;
        b=eC2D9oDl9wkQnEE384W4C31tmCGe45VtNo84fJKne53lpQc840lWlVBlr/S8wV8SmP
         N0uIEAA5dtSQzo/fovMrtvma8M9271hNLpE6ORnmBOOk59cXK1tQtOpM2Qtvw6z725X5
         9b7wByPKvOcvRPSuBF5lE0E91UGyygab1xcZVHkO9P5bFww1katN+EH4pDvYIQXC8Opp
         fmgJ7hOD/2xzQHLWxD+3UlojNm3Dx6YC9q2m2etX42tg2YgPUfDNW4DxLY9d6wtqGd5D
         EqhXtjFEzH/xB6LQxa+2xZTcXENi+jgImrzbHg4WNppnzpPkXWjXN2G8vEvZ8AiOWqkv
         0oYA==
X-Forwarded-Encrypted: i=1; AJvYcCUxYhaAg7C++VGj+hDTpPULI9U3MY3x+8peFqhwBrx8SN15on5B4m631O4fAIN09KdFZNE=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz9uMzV8V7ddMoM9b/qx+MFQyIoczx7QFq7tGDlzhY2jHf15H2s
	fux+M6vCXzkzVWxgkxvPSlefjW4VxkS5cFxdbAoyJd2fqareqm8OK2Pb1CNGksgO+Is=
X-Gm-Gg: ASbGncuVMe3leQkCfRAjklIkLZPRLT69t1xGIVJSw1PwwPyc3AX5eyLfP8wyoA1EEgU
	C+oDTfkHCE3jOTlhFWHf1Ry4I+j4+fKloVb0Obl1dOFSdR5/9zQBemD6bheuQVJtaS6SGsOTyeT
	IQllVOgrtBeXJ16cVsjWbfgN1elGL/mkaZXQuq3WQ8u8QxDAGLvoVcuUQJLzEngOEInHz2ECrMl
	42BiuaR3WZv6OAFJ/9rmAb0ZSEGFueuV3oItfVwPbPlz0xYGCzb8fd8jVgsORSPY66h24DSb2oS
	qEIjYFq95nUKlyNiyvKUabyx3kh7Y/5lb0Zy5Ubh2V9FE9AIIu8FqZJhUl5DHcCfNHvfN0Rulmu
	CZ8vxwWdQIV91HJ9xJ5qsp0d6//fl2ZN/Kh63mPqJsm8j9fIaQ3yp0jMiqexBeU/DLYPmPsyNlG
	Knh026Z1Gd36Dcim/xN3aGXkMX2W8cF1ABlBpH7kW6AVzIew==
X-Google-Smtp-Source: AGHT+IHAqxsruoFSNH8r92pXByJZXpbC02cmDf8hvWhdyEsqMsjleZyGXnYBqpX9aTWrKNVK1bjXog==
X-Received: by 2002:a05:620a:2909:b0:827:1bda:ca68 with SMTP id af79cd13be357-8a8e628734dmr448036185a.46.1761754873236;
        Wed, 29 Oct 2025 09:21:13 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-47-55-120-4.dhcp-dynamic.fibreop.ns.bellaliant.net. [47.55.120.4])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-89f25b89e39sm1089184285a.44.2025.10.29.09.21.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Oct 2025 09:21:11 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1vE8v8-00000004zxA-1YYS;
	Wed, 29 Oct 2025 13:21:10 -0300
Date: Wed, 29 Oct 2025 13:21:10 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Jacob Pan <jacob.pan@linux.microsoft.com>
Cc: Vipin Sharma <vipinsh@google.com>, bhelgaas@google.com,
	alex.williamson@redhat.com, pasha.tatashin@soleen.com,
	dmatlack@google.com, graf@amazon.com, pratyush@kernel.org,
	gregkh@linuxfoundation.org, chrisl@kernel.org, rppt@kernel.org,
	skhawaja@google.com, parav@nvidia.com, saeedm@nvidia.com,
	kevin.tian@intel.com, jrhilke@google.com, david@redhat.com,
	jgowans@amazon.com, dwmw2@infradead.org, epetron@amazon.de,
	junaids@google.com, linux-kernel@vger.kernel.org,
	linux-pci@vger.kernel.org, kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Subject: Re: [RFC PATCH 06/21] vfio/pci: Accept live update preservation
 request for VFIO cdev
Message-ID: <20251029162110.GQ760669@ziepe.ca>
References: <20251018000713.677779-1-vipinsh@google.com>
 <20251018000713.677779-7-vipinsh@google.com>
 <20251027134430.00007e46@linux.microsoft.com>
 <20251028132855.GJ760669@ziepe.ca>
 <20251028103945.0000716e@linux.microsoft.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251028103945.0000716e@linux.microsoft.com>

On Tue, Oct 28, 2025 at 10:39:45AM -0700, Jacob Pan wrote:

> My current approach is that I have a special noiommu driver that handles
> the special iommu_domain. It seems much cleaner though some extra code
> overhead. I have a working prototype that has:

Oh interesting, maybe that is OK and reasonable.. My first worry is
that we don't well support iommu driver hot unplug, but if it is very
carefully controlled I think we can make it safe. iommufd selftests is
already doing this and I've been trying to make sure it stays safe
without races or memory leaks..

Binding is going to also need some fiddling because we don't want to
mess with the fwspec on a real struct device..

But maybe we can have some kind of direct 'bind iommu driver to struct
device' call?

> The following user test can pass:
> 1. __iommufd = open("/dev/iommu", O_RDWR);
> 2. devfd = open a noiommu cdev
> 3. ioas_id = ioas_alloc(__iommufd)
> 4. iommufd_bind(__iommufd, devfd)
> 5. successfully do an ioas map, e.g.
> ioctl(iommufd, IOMMU_IOAS_MAP, &map) 
> This will call pfn_reader_user_pin() but the noiommu driver does
> nothing for mapping.

Make sense.

So you can't have a paging iommu_domain that doesn't have a map
function - that just won't work for iommufd. What you should do is use
the iommu pt stuff and have the noiommu driver implement its paging
domain using the amdv1 format.

That will give you map/unmap/iova_to_phys and then iommufd will
immediately full work.

Look at how that series handles the selftest, the simple selftest
iommu_domain is very close to what you need. It is pretty small code
wise.

> > After writing the generic pt self test it occured to me we now have
> > enough infrastructure for iommufd to internally create its own
> > iommu_domain with a AMDv1 page table for the noiommu devices. It would
> > then be so easy to feed that through the existing machinery and have
> > all the pinning/etc work.
>
> Could you elaborate a little more? noiommu devices don't have page
> tables. Are you saying iommufd can create its own iommu_domain w/o a
> vendor iommu driver? Let me catch up with your v7 :)

That was my suggestion, but it seems you tried that and decided it was
too hard with groups/etc. OK.

Adding a dummy iommu driver solves that and you still get to the same
place where there is a paging iommu domain that implements an actual
page table with map/unmap/iova_to_phys. From this perspective iommufd
will be entirely happy and will do all the required pinning and
unpinning.

> > Then only an ioctl to read back the physical addresses from this
> > special domain would be needed
>
> Yes, that was part of your original suggestion to avoid /proc pagemap.
> I have not added that yet. Do you think this warrant a new ioctl or
> just return it in

I think a new ioctl is probably the right idea..

Jason

