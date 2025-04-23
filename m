Return-Path: <kvm+bounces-43997-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 3727BA996D6
	for <lists+kvm@lfdr.de>; Wed, 23 Apr 2025 19:39:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9225F1B826AD
	for <lists+kvm@lfdr.de>; Wed, 23 Apr 2025 17:39:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6A09928CF60;
	Wed, 23 Apr 2025 17:39:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="XV88OjQX"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qk1-f173.google.com (mail-qk1-f173.google.com [209.85.222.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3E8E289373
	for <kvm@vger.kernel.org>; Wed, 23 Apr 2025 17:38:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745429939; cv=none; b=UOESsQn4jUJMqqnBKxK69t/JWNflR/jOAiEXfSVtsN1MmbMXBzRF7NzLCBwhEi/9nZuAC+IFqXfAwsmMX6HfAEHUosw5tgxdAVjGZVYr0NastRCTJNN7I+eJ0wG3L8y7aBODu1TJnsPltIJlX7alTvsNkIGV3LogF9V0IAk5sHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745429939; c=relaxed/simple;
	bh=jyCSrAMbJeJJMtfyLp932NW76okHOgg35e8+PFG3Bes=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=M0SFy4PEU6bKQ9aC0aknSRjkK//VmOWC3XKbkzB++Zat8PF7ruPeg/RRWi3XOmexhjz+UYA9rqOVxnPnV3iO0TnwoOaglUnNPpk8d7Mjiny3toCHip/YjorH7OK1+BNlVANxfi6nRKTp11gaJJNvMiCVP1xoyM4b4pIXvp4IYus=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=XV88OjQX; arc=none smtp.client-ip=209.85.222.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Received: by mail-qk1-f173.google.com with SMTP id af79cd13be357-7c5e1b40f68so9191785a.1
        for <kvm@vger.kernel.org>; Wed, 23 Apr 2025 10:38:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1745429935; x=1746034735; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=5ZKbLbO/VBglO/Va9GZRrTXMgQWmFJOWwhYhgpmasyg=;
        b=XV88OjQXLvia7kK4o00ZKUcesjYunq5WroYYymOJIGPMGmbS/9i7/qihmuV7uOasU4
         OXl8PETx5N3fBmnwdHey/3OYAFXqGUH3OPC9lDRQ3t7t5ywtpMDnAQfl5fXiXDw0kz0Y
         CY7vXgT33OAcwYME65ecscD4qSwBEzKjCIcCmKALFBpmrDUzivrqYevJro0byOJABFZm
         U27EyPyD2OYa9Q5WnrYhRvJ6IlClmvfZsSYDVXfiY18SHL3rcq5umqVuzT5sD0yp3yd5
         P0OLu9NB/5EVomSa/v3aTFE9KbMXn5dTG7PuVElsFKFgm+UzdsRy6Q7MuGfp0offCZkj
         bQ7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745429935; x=1746034735;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5ZKbLbO/VBglO/Va9GZRrTXMgQWmFJOWwhYhgpmasyg=;
        b=kRHYwOIzT+rqb3jZWgcVf13aQnc2QlCIBWdaE1Paf1gz8WYvkRlkmLbOnc5LKyiDu4
         WKEn2gq7NCuwSYIwh/XDpc9FVYZRdewqh5guQcahHXLYjlhasySAgu0lxa+xvBRMqa7M
         /f+tV0x/P2SYudbz2EaF2ZulVJsO62DD67a6HK1BqEeFHjXcKgl4A381Zfq9OIaTZuph
         UmTEsV4BgBD+j0SK4/aBh//HFzi7FkYxe2ixRyUwkV98PMPwI/W0Qu+U/E1JazOMdvzr
         lZzELwTg+Z+OihW0PB8EdHZ2dxMzpZEJ3VGZva5oyY0r3PQyP/E6GKPpfj68C0TvIKHb
         AFCA==
X-Forwarded-Encrypted: i=1; AJvYcCX4WQSZwLD/XS+mqxFKQScx8wC/V6o7YbRF6l4IoHW+U60zmkoCHB/Y8Z1Ne0pnJXDZEdQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YwMytt/6BRYjhGeY5+oEnNUE2MO4WcIqQTmd0iYvZSQVPpwU+ok
	Bpv436b8x3MP7/2IMx2zGXUgfiwuKVSVG5dj71rWZHHoP6IFNsWz8OyITuj84Pw=
X-Gm-Gg: ASbGncsJWUHGiyded9+ai4RzDJu9aEMO5GMYBSGJ+Ao5CKyylETPOzZJ10rC438Uuh+
	IcjvJ/0uUI8Wh7sT0dI246pU1AJmkuuDWUxmC3PYh5GsO9nkuoK74PccrQLqek7ofM+FvyQtCwH
	RhnaCsQcJGzOn552Ox6u+s4KvrqHLhrwjuM7or9s2M86uaDUcJgnsGW2nLzX+6LB4RlBlROv0Ki
	TR22Jt7VJ6Y/wlWq/6btHzu3ME/q/gWMp3fc81mQEIScZC1b5jo3qdBCLQnh1Aa4Fc252Q0Lnt8
	mV1crgDoYOQXjvuWLWRtU5YbOYORFlZ4JalfZwJJfJT5ZLKqppWDeHXLbwbvGAg053ssnzAJzgv
	TvdgcW88s+BrluFGPS30=
X-Google-Smtp-Source: AGHT+IGgN3qsfS6onNY8+gQMZCTHD3MSF9+S5w+6n1/7VM1d4IchwJLfZsPm7/0ZCJyeB599ZskZwg==
X-Received: by 2002:a05:620a:1917:b0:7c5:ae20:e832 with SMTP id af79cd13be357-7c927f6ff15mr2997015185a.11.1745429935582;
        Wed, 23 Apr 2025 10:38:55 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-167-219-86.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.167.219.86])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7c925a8c9f2sm708523885a.29.2025.04.23.10.38.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Apr 2025 10:38:55 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1u7e3i-00000007Le6-2jjE;
	Wed, 23 Apr 2025 14:38:54 -0300
Date: Wed, 23 Apr 2025 14:38:54 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Leon Romanovsky <leon@kernel.org>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
	Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>,
	Leon Romanovsky <leonro@nvidia.com>, Jake Edge <jake@lwn.net>,
	Jonathan Corbet <corbet@lwn.net>, Zhu Yanjun <zyjzyj2000@gmail.com>,
	Robin Murphy <robin.murphy@arm.com>, Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>, Sagi Grimberg <sagi@grimberg.me>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Logan Gunthorpe <logang@deltatee.com>,
	Yishai Hadas <yishaih@nvidia.com>,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	=?utf-8?B?SsOpcsO0bWU=?= Glisse <jglisse@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org, linux-rdma@vger.kernel.org,
	iommu@lists.linux.dev, linux-nvme@lists.infradead.org,
	linux-pci@vger.kernel.org, kvm@vger.kernel.org, linux-mm@kvack.org,
	Niklas Schnelle <schnelle@linux.ibm.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Luis Chamberlain <mcgrof@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Dan Williams <dan.j.williams@intel.com>,
	Kanchan Joshi <joshi.k@samsung.com>,
	Chaitanya Kulkarni <kch@nvidia.com>
Subject: Re: [PATCH v9 14/24] RDMA/umem: Separate implicit ODP initialization
 from explicit ODP
Message-ID: <20250423173854.GP1213339@ziepe.ca>
References: <cover.1745394536.git.leon@kernel.org>
 <c79721bb70988f60fa23fdfb6785e13f6ef806c5.1745394536.git.leon@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c79721bb70988f60fa23fdfb6785e13f6ef806c5.1745394536.git.leon@kernel.org>

On Wed, Apr 23, 2025 at 11:13:05AM +0300, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
> 
> Create separate functions for the implicit ODP initialization
> which is different from the explicit ODP initialization.
> 
> Tested-by: Jens Axboe <axboe@kernel.dk>
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> ---
>  drivers/infiniband/core/umem_odp.c | 91 +++++++++++++++---------------
>  1 file changed, 46 insertions(+), 45 deletions(-)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason

