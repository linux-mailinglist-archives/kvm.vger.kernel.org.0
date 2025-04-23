Return-Path: <kvm+bounces-43995-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C617EA996C8
	for <lists+kvm@lfdr.de>; Wed, 23 Apr 2025 19:35:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 779D6921D18
	for <lists+kvm@lfdr.de>; Wed, 23 Apr 2025 17:34:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 13EE927F4ED;
	Wed, 23 Apr 2025 17:35:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="jKeC0wG0"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qk1-f175.google.com (mail-qk1-f175.google.com [209.85.222.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6303288C80
	for <kvm@vger.kernel.org>; Wed, 23 Apr 2025 17:34:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745429700; cv=none; b=E/pJ1/XergqWghVtgMQ9y/tuhjMbWJb0QS3r7WSA8EWH5T8v3Kow0W/kvvUlmYVJ2q7g0OamwFarC5GLT/OmoT74/3hNBp8I0HgcExA8S8z3bhEPJ2/mbRub26HoOU5zjC5EBYLSQGsbX6a9M5obhUmLvT8Ogs6WuPwLSsgjnGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745429700; c=relaxed/simple;
	bh=zB24IJl1jZzMHzgO4K1Iy0NHxHgoWs9FaxvjZYsQalw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=inTzuD33tbYeHep3+u0aE0lLsF6gPGGfjPTp5rbAl8BKBBSMbLhsT/RhW6/FanpdEgGyPNXUScJsFejLeVUe2VYZiHwZcKiM2BkIpHGDKPdUP7U4NkdibbvfO7qwtO0iY35+795VQlVdBvi/KUzaLU0QIsUhYWAusW37EXk9v3Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=jKeC0wG0; arc=none smtp.client-ip=209.85.222.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Received: by mail-qk1-f175.google.com with SMTP id af79cd13be357-7be49f6b331so8410985a.1
        for <kvm@vger.kernel.org>; Wed, 23 Apr 2025 10:34:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1745429696; x=1746034496; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=I+fayQ/PBTnrOfxtrw3IgFnI1QJK9xAjEiHuuXs7Kpg=;
        b=jKeC0wG0Rxs29aLtFTXrwvm6sCjBlI+WjPNCPmALgo/mjnmuyNi8RzQ8EoTi2n9ato
         G2uR8+wTHeXdzUwlwgxBh5NicR8ymrLhg0bWgtzToqLWFgmbk1yR2sBCKvTWpQ2XzEqK
         c+gqSngWmaHabqIMpagt+bie9Wb3ZUbIY0uf9WN8dkBe5oq6/jz0Omc/q/isRe5XxD6s
         wIyd2QIvWZ+V+k8HV/tY0iBuNr8JlAnZaGxdHRzWwWJdpEc7zUCULfC7NElEQ7ugzKS1
         ukaL0jDlfBwfBtKiA5JthSNqw13rTy4KL+WCFZHxth3Teiilhqthip7KWkPBUKtkiX7c
         Z7dA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745429696; x=1746034496;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=I+fayQ/PBTnrOfxtrw3IgFnI1QJK9xAjEiHuuXs7Kpg=;
        b=RHNsF2ub8S7weazSOQkX5FY+dVLcbjJYIHejNz5IM9enU0Le31GWTyffbM6ROUPrMQ
         CHrLtUdr99SSlAvYvoc+Lhcgyq4eM/Orx/lyfPel/wt5x/L/Olo4/ulonqvdwBdwYZhs
         lHGPNi0dixcWUxd0wQ66AmYgXivf3tpusywACvcPNywFOatk94AQtg8DV/BnTNq6t1nv
         cddOqXVyGsYLxDPwZ8LK0v/pNcdp8F3pDByTUC9gg6+WU2iOZwiWbqaWkvo1PvVYXzDh
         gXJlIM7mfwQiHoQuFLhOfgHF9qc+sK/skQWl5TfHNSKlQNOu/fwf6gMLPMnRLHK08Et5
         QRsw==
X-Forwarded-Encrypted: i=1; AJvYcCV2Xmkk/npGo+cotECRg7/Gy4BL7iD9WGMChHvTCFn2wJ3tAbQPf17cDR9dhfJ2HQNzYEc=@vger.kernel.org
X-Gm-Message-State: AOJu0YyNKem0n4vSjC7Ds+7cZ+lL+CA6fQYDy9J2vcfq+dWo7egizHrC
	1rsPMkF0o5HacYc8vAvFs9i7MsaoiJVZguHJe3JMwfNWouePCcysFRXIWQ4Uve8=
X-Gm-Gg: ASbGncsf9Yq1/y8qOOm64WHysJblgNvdgUCBJE/N0msR1AsS7aPDP5r1M4MhX8ArRD9
	Vgf+YcWT+GMZl2J9zddh0twtRvz2y7WcPcY0GFB3fZgGnHXIzV0lfp7GLqJjRvz/UUGcUUWNlbu
	ckgTm/qfvRPvrDeC2Hh4kd/agRFD/ZFGfdk3ksJGy1/4xmn63ZrzY709kpFb0qKeu8s1oyNYPgU
	dBoyp00j6Ht6fL88VIaSHB05IatM5IfGMJqOFNZxIFLN+Tsz+GhXdCgqVEh/zx+uwUevF9NZXJf
	4NRxfgmzwkO0aTWoBOS3/MrJKvp8zkQua5NhYIZikMIKe1SwJVk2eX0qFWpd1kMlSd0V73yHOIb
	FdTJ/0AY+hT6Dcoo7mZE=
X-Google-Smtp-Source: AGHT+IHrcKTZfJXCAhkO2WaOum0PT2hRMW3vGaRhpe2sCjwAXzgjbldqD9beTUKDcznlrIIPKNuBAw==
X-Received: by 2002:a05:620a:2953:b0:7c7:97ff:ca42 with SMTP id af79cd13be357-7c955e7c7d7mr65261285a.41.1745429696505;
        Wed, 23 Apr 2025 10:34:56 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-167-219-86.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.167.219.86])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7c925a8bf65sm707741185a.25.2025.04.23.10.34.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Apr 2025 10:34:56 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1u7dzr-00000007LbA-2PtY;
	Wed, 23 Apr 2025 14:34:55 -0300
Date: Wed, 23 Apr 2025 14:34:55 -0300
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
Subject: Re: [PATCH v9 12/24] RDMA/umem: Store ODP access mask information in
 PFN
Message-ID: <20250423173455.GN1213339@ziepe.ca>
References: <cover.1745394536.git.leon@kernel.org>
 <f81331e55cf95b941e6c57f940a2a204141bf2e1.1745394536.git.leon@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f81331e55cf95b941e6c57f940a2a204141bf2e1.1745394536.git.leon@kernel.org>

On Wed, Apr 23, 2025 at 11:13:03AM +0300, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
> 
> As a preparation to remove dma_list, store access mask in PFN pointer
> and not in dma_addr_t.
> 
> Tested-by: Jens Axboe <axboe@kernel.dk>
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> ---
>  drivers/infiniband/core/umem_odp.c   | 103 +++++++++++----------------
>  drivers/infiniband/hw/mlx5/mlx5_ib.h |   1 +
>  drivers/infiniband/hw/mlx5/odp.c     |  37 +++++-----
>  drivers/infiniband/sw/rxe/rxe_odp.c  |  14 ++--
>  include/rdma/ib_umem_odp.h           |  14 +---
>  5 files changed, 70 insertions(+), 99 deletions(-)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason

