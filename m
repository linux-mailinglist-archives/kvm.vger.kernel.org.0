Return-Path: <kvm+bounces-41737-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7C225A6C6C0
	for <lists+kvm@lfdr.de>; Sat, 22 Mar 2025 01:41:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E95263B9ED1
	for <lists+kvm@lfdr.de>; Sat, 22 Mar 2025 00:41:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EE1FB171A1;
	Sat, 22 Mar 2025 00:41:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="R7B8UWhJ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 756DC523A
	for <kvm@vger.kernel.org>; Sat, 22 Mar 2025 00:41:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742604094; cv=none; b=HXR9AQ3oVu5pG5zWZxxm/3cFDg1nHMnKKx9TChhjfWXg35RnPQM9Zi4caautZXmSrzwzmedIlHWOh11I0i5aBSLF//cJYC7bav+JkrD0ZTufPsoTlXJGzwrt9s5SuZpdy/76q/tJ8na423mYxv6JIHJUS2kq9PF08rxtjzcRLJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742604094; c=relaxed/simple;
	bh=hqoJRCdWhjuEg7TGBkaWxPiFOMvAutcwW1byYHxtnno=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Q5RqYTR1XXEixaxXElr+AUr0CfLMMX52Q+BoLDMffG2G9KM4k80754pchmnPbUTUXR1q0caVwOnOPXgy+rU/mx2VgLrv1traA5lnqEq56t39ds63SwvTxu4N+lgX53H1fCaIeysSJpZuJOSsHEH1Lf1FDHPyFDTk8f4nyP2hEDs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=R7B8UWhJ; arc=none smtp.client-ip=209.85.160.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-476977848c4so26020931cf.1
        for <kvm@vger.kernel.org>; Fri, 21 Mar 2025 17:41:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1742604091; x=1743208891; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=7w18pLCxgYQdbgr4L7Ilx5M+dDme30Hw40dLx2kJ/Cs=;
        b=R7B8UWhJvzY42pvGEXzc6g/CCpxVufGWlUhFok38uou2OkWlLPGuDJtZw2zv0X4g2t
         8J5H7J4iv1COZfvtScYcLqv9UYzmPga9O/PMs2PLCjtHMbt/F0sr/E5TOwdCISHFdnc8
         exaOwDFrFSeER/EDk/U5R5I4ss8/9qVJpHWvlC5zpAs/igjUOeO+/BxSk93pH1UXx+SP
         LgqpLAQwbAZ0onbxeHG4Mp3udUsn+AaBi8XeRFKkfmStyPwJPUKi1tgDkHRXr9OXgZbx
         VNuHyNVmP70zXrP/aA9tz91BGWewef+tcco1OglHPjxMOipK+QxDWUYAtcqogWNoxQ8a
         yiYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742604091; x=1743208891;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7w18pLCxgYQdbgr4L7Ilx5M+dDme30Hw40dLx2kJ/Cs=;
        b=sASW7Flv+ZiBeRE2jiHZV6HcWxFrY+amsSSAba55onYwdT3XppjFVVMU+dj5V4MeG6
         oTDdaE0psLvP1sohR4rufkeGpGD9MfXCSgZgRkxrOdSGfQ3mkAuAFB1NAKy4D1I5ELuE
         1hmVPWtyMTk2HOZd+r7jTCjSmw3eTLPiEVg0EQ6bvBPZ9hkfyoDWPN+1IcQyxK1ObVfC
         U2btlOpl3QHHL8dDYNwGUYgHKBcJXAHWvvC9u7+F9jxBLEnuFqJ5gqJqWy7WieK9bzgZ
         htJaLsfbnsdza7FQ0jn9Qb+oLrGsmaDhUKNKKKVaohWRlgma9+aH+LoUrExQZQqI5C/M
         gsjA==
X-Forwarded-Encrypted: i=1; AJvYcCVFabpUDQXc1niN2yfTEhpAGxFUVeASwGN9DaJXn3BkUvmulR2r/c/qr3oPhU/QqtS9apc=@vger.kernel.org
X-Gm-Message-State: AOJu0YzeMLn5WkZBPfdr6CluisTZMp2zmlBXlXBNSjIQQsPrvf0S0Krz
	QheORUttv+wPY8Ay0+Idi0IApppm8Qy7nW0i/S+9oWhkbALTPTjndgXHXdKZYYI=
X-Gm-Gg: ASbGncuql9bwr04dY9E+I24h3Q8KNpS78EQ8+57m/suwU4jgp20tLs7Jc49maCzWV7s
	Y0sk+KMUQs4DgS+f7AgaM4Co09dzm6vgOX8E5ZmInQcaDqXf3TIotGXd4CdcZcsdv8NBV0XNpXQ
	7WBI0JMI1qPVMRAlNBfGTjFw3ElxXgmsd3cXxbP28mMf4lADPaRQmywnK0IPVMztvdDX8tDMlU+
	VJMVBRLk16+EE4lMt/R1VRdk6xuso4uygq5o8JrPE+yWxRVhXwi4xCzvne2nJjDHxV8Bp5/FKXL
	xmidEuZRUVqCzt61FIprI2vZDS1JkV0VXQmg+/RfhQccDmu0nXNnb7vLQKUO+KYtHGJmWOWdVMx
	8NsLS/YtS/0X0XsVnW24bWVY=
X-Google-Smtp-Source: AGHT+IF3UkobCdIF7lNWuu9KRAhdJDE5q4DcYOtKKTS+FcoMl1AlUzXXVqHHTKDK0VlDF9Mdifo+AQ==
X-Received: by 2002:a05:622a:480c:b0:476:b7e2:385c with SMTP id d75a77b69052e-4771dd5d0e6mr84261721cf.2.1742604091376;
        Fri, 21 Mar 2025 17:41:31 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-167-219-86.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.167.219.86])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4771d0ad87esm18121731cf.0.2025.03.21.17.41.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Mar 2025 17:41:30 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1tvmva-00000001CZm-0pDT;
	Fri, 21 Mar 2025 21:41:30 -0300
Date: Fri, 21 Mar 2025 21:41:30 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Leon Romanovsky <leon@kernel.org>, Robin Murphy <robin.murphy@arm.com>,
	Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
	Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
	Sagi Grimberg <sagi@grimberg.me>, Keith Busch <kbusch@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Logan Gunthorpe <logang@deltatee.com>,
	Yishai Hadas <yishaih@nvidia.com>,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	=?utf-8?B?SsOpcsO0bWU=?= Glisse <jglisse@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
	linux-rdma@vger.kernel.org, iommu@lists.linux.dev,
	linux-nvme@lists.infradead.org, linux-pci@vger.kernel.org,
	kvm@vger.kernel.org, linux-mm@kvack.org,
	Randy Dunlap <rdunlap@infradead.org>
Subject: Re: [PATCH v7 00/17] Provide a new two step DMA mapping API
Message-ID: <20250322004130.GS126678@ziepe.ca>
References: <cover.1738765879.git.leonro@nvidia.com>
 <20250220124827.GR53094@unreal>
 <CGME20250228195423eucas1p221736d964e9aeb1b055d3ee93a4d2648@eucas1p2.samsung.com>
 <1166a5f5-23cc-4cce-ba40-5e10ad2606de@arm.com>
 <d408b1c7-eabf-4a1e-861c-b2ddf8bf9f0e@samsung.com>
 <20250312193249.GI1322339@unreal>
 <adb63b87-d8f2-4ae6-90c4-125bde41dc29@samsung.com>
 <20250319175840.GG10600@ziepe.ca>
 <1034b694-2b25-4649-a004-19e601061b90@samsung.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1034b694-2b25-4649-a004-19e601061b90@samsung.com>

On Fri, Mar 21, 2025 at 12:52:30AM +0100, Marek Szyprowski wrote:
> > Christoph's vision was to make a performance DMA API path that could
> > be used to implement any scatterlist-like data structure very
> > efficiently without having to teach the DMA API about all sorts of
> > scatterlist-like things.
> 
> Thanks for explaining one more motivation behind this patchset!

Sure, no problem.

To close the loop on the bigger picture here..

When you put the parts together:

 1) dma_map_sg is the only API that is both performant and fully
    functional

 2) scatterlist is a horrible leaky design and badly misued all over
    the place. When Logan added SG_DMA_BUS_ADDRESS it became quite
    clear that any significant changes to scatterlist are infeasible,
    or at least we'd break a huge number of untestable legacy drivers
    in the process.

 3) We really want to do full featured performance DMA *without* a
    struct page. This requires changing scatterlist, inventing a new
    scatterlist v2 and DMA map for it, or this idea here of a flexible
    lower level DMA API entry point.

    Matthew has been talking about struct-pageless for a long time now
    from the block/mm direction using folio & memdesc and this is
    meeting his work from the other end of the stack by starting to
    build a way to do DMA on future struct pageless things. This is 
    going to be huge multi-year project but small parts like this need
    to be solved and agreed to make progress.

 4) In the immediate moment we still have problems in VFIO, RDMA, and
    DRM managing P2P transfers because dma_map_resource/page() don't
    properly work, and we don't have struct pages to use
    dma_map_sg(). Hacks around the DMA API have been in the kernel for
    a long time now, we want to see a properly architected solution.

Jason

