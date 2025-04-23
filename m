Return-Path: <kvm+bounces-44024-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id BEBC6A99C18
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 01:33:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E940F7A9408
	for <lists+kvm@lfdr.de>; Wed, 23 Apr 2025 23:32:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4B3EC1F2B8E;
	Wed, 23 Apr 2025 23:33:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="oxpQR22A"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDEC022A7E9
	for <kvm@vger.kernel.org>; Wed, 23 Apr 2025 23:33:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745451219; cv=none; b=Ew/xyDXQwhK11A/rp0ZQtoJdLV9o/aVer1/ZM/EFFJ8sz87hpoHj4gzOwmbqG2KMVHpYo52uu7+EjoMDY/T6R0Az0+tsybK5eO8PqelPllpfnGbwiHh58rosmkbpayOl3zCvTTF04F96c9fPbzWrAUQHCJsI9Iw3fQWR/3FLTyQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745451219; c=relaxed/simple;
	bh=El3tntKet6XFP5tu5jRccRiIHcbcsNXplDjGS1RgqqY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PHg28Z0gQdRgUfsZj78uaevs7a+SQ3SrmMRmDUD9VLH3X0zMuTjzu0oXX3l9ErUFJ0edlcH+WAEs8K5mSwUBZicTMNBHre26m4qudb8tF/8BVSIazgmq/muj749+4HXeCepGVK67a+9PzmlY7l1K/YGnF0FnveFFLv2os1Azyu8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=oxpQR22A; arc=none smtp.client-ip=209.85.160.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-477282401b3so4518321cf.1
        for <kvm@vger.kernel.org>; Wed, 23 Apr 2025 16:33:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1745451216; x=1746056016; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=L7oRP2YqJwVB6GeEu4BqvXzZqclhisHpp0fN6LY14JQ=;
        b=oxpQR22AuCBUupk33WzKrsqOuEfDjGF5EniClxzPYJi+H/2OHhj3xqGjwCfB3IjXj1
         IS44abUFubw81ik89SK+dFDMZisPitToRy3EjPnxuoq9OkV+yz2s0Dd26VYZBM4RiMKf
         LNZPMNSpZe8jxWLp38ZCMDDKtCWhhAEaNccFys3J39EgF9Oa5YZ6+Oi0PJ9u2qeAGeb+
         x42QOq7flqmXeNRLssg9BL3MbzD8TDfAQ3F1ZEg2N3dERLvQfW0Wo9v5YoPExvUsoEdC
         IJPMcscXB538yc3/hVCCR4MgBTNPsBOr+AloLAvkeppeSsp27pJkz8n/J7Twj4P35Hbl
         gDmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745451216; x=1746056016;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=L7oRP2YqJwVB6GeEu4BqvXzZqclhisHpp0fN6LY14JQ=;
        b=O83Y/9jR/lRQ3JnXbe30vWji2ShwBgK56Ft7TrZ4yjRZh0p+TvMX/qRJE0Li8qClHQ
         CzRFkwRnRBtiPq4EGwT7RDrSWnP+0tZtVzFlI/1kW/D+KKVMqUED1lm1mQG5WwaUezcG
         iw4xYu/QWLY28CIzpUswxJlwiKDJONfs5Q9OE1gHHiglI6aylWIscWB+2gR52FUWsTrO
         bOOIkrZjgbQMz7kES/WoP+P42dVzwAAaCMDj2R3MmQqn690Mx6LQ/+0VnV/GD/8x1qXZ
         MRw+0jAAKY+xFYZoULvI4H5GymBzYRVRVqMNpyfbwIZtVoSa3zokhQr1ENJoY4n71ONe
         oHwA==
X-Forwarded-Encrypted: i=1; AJvYcCUxx8chcjCIJLq95x8/oMRx/jxcqOWGCrfx6FcyV/tDWo80f3XOKCMNcqqNWADVWdgz5Yk=@vger.kernel.org
X-Gm-Message-State: AOJu0YzpL8YGJ+78DFGsI0p9RJGBR9qQJOdQvN9EKTsT3RclJ99JWYLh
	t6eoUMHOE58Rwo0DIB+zCCttO0VCS1DQEMuGfDAV/3Sy3+jr0IgjWm6Z+NVbAY4=
X-Gm-Gg: ASbGnctrVmW+LbaYBWFQ9OQawlvGOrm8dQHklRaYXJKIjdDNhwAPzFqKMgOHU3nZ/eZ
	prRS9sg6bRmS44tXa/BOrgN//PQiug52yS32drKydb6Wkiheu+UL59PcK5YsNU6KzGnhlP02a1k
	qfYa422KalZvF7nYS6us4VoBAvHMruKCid+bLyj66A6M5CfKogPnnSGaIMT/f8pB+fUkUmlPyI5
	r7wD3xdTZpL+BcuQFEKZyiunKK+rh1+zLuW0vcTA03W/meu4b8e4qrm4jjOJ5vUkNkqLeSsdjNO
	E6Qt9VKWdeCadko5tB+vbea6FHKh7nhgqoWB8gZvZguuhsabAEVpY4PWWs4snelbdMoAKDTm4Ya
	vze3kEbtBtD7Q0H6Dso0=
X-Google-Smtp-Source: AGHT+IHp4LWhqR/rJc6pqFU95w2BqdqjYtJ4SAe1Mvc/v+Ufccgyj7hWc7Mm96oBr3hzP4lBlnfnCQ==
X-Received: by 2002:a05:622a:388:b0:476:b783:c94d with SMTP id d75a77b69052e-47eb4fbb928mr6490361cf.35.1745451216599;
        Wed, 23 Apr 2025 16:33:36 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-167-219-86.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.167.219.86])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-47ea1ba154asm2538601cf.67.2025.04.23.16.33.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Apr 2025 16:33:35 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1u7jax-00000007PKl-19Zx;
	Wed, 23 Apr 2025 20:33:35 -0300
Date: Wed, 23 Apr 2025 20:33:35 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Mika =?utf-8?B?UGVudHRpbMOk?= <mpenttil@redhat.com>
Cc: Leon Romanovsky <leon@kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
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
Subject: Re: [PATCH v9 10/24] mm/hmm: let users to tag specific PFN with DMA
 mapped bit
Message-ID: <20250423233335.GW1213339@ziepe.ca>
References: <cover.1745394536.git.leon@kernel.org>
 <0a7c1e06269eee12ff8912fe0da4b7692081fcde.1745394536.git.leon@kernel.org>
 <7185c055-fc9e-4510-a9bf-6245673f2f92@redhat.com>
 <20250423181706.GT1213339@ziepe.ca>
 <36891b0e-d5fa-4cf8-a181-599a20af1da3@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <36891b0e-d5fa-4cf8-a181-599a20af1da3@redhat.com>

On Wed, Apr 23, 2025 at 09:37:24PM +0300, Mika Penttilä wrote:
> 
> On 4/23/25 21:17, Jason Gunthorpe wrote:
> > On Wed, Apr 23, 2025 at 08:54:05PM +0300, Mika Penttilä wrote:
> >>> @@ -36,6 +38,13 @@ enum hmm_pfn_flags {
> >>>  	HMM_PFN_VALID = 1UL << (BITS_PER_LONG - 1),
> >>>  	HMM_PFN_WRITE = 1UL << (BITS_PER_LONG - 2),
> >>>  	HMM_PFN_ERROR = 1UL << (BITS_PER_LONG - 3),
> >>> +
> >>> +	/*
> >>> +	 * Sticky flags, carried from input to output,
> >>> +	 * don't forget to update HMM_PFN_INOUT_FLAGS
> >>> +	 */
> >>> +	HMM_PFN_DMA_MAPPED = 1UL << (BITS_PER_LONG - 7),
> >>> +
> >> How is this playing together with the mapped order usage?
> > Order shift starts at bit 8, DMA_MAPPED is at bit 7
> 
> hmm bits are the high bits, and order is 5 bits starting from
> (BITS_PER_LONG - 8)

I see, so yes order occupies 5 bits [-4,-5,-6,-7,-8] and the
DMA_MAPPED overlaps, it should be 9 not 7 because of the backwardness.

Probably testing didn't hit this because the usual 2M order of 9 only
sets bits -4 and -8 .. The way the order works it doesn't clear the
0 bits, which I wonder if is a little bug..

Jason

