Return-Path: <kvm+bounces-34042-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C77AD9F63A1
	for <lists+kvm@lfdr.de>; Wed, 18 Dec 2024 11:45:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6E6A6189536A
	for <lists+kvm@lfdr.de>; Wed, 18 Dec 2024 10:45:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 302E319CC20;
	Wed, 18 Dec 2024 10:44:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ffwll.ch header.i=@ffwll.ch header.b="B5oQE4Y/"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA96C199FDD
	for <kvm@vger.kernel.org>; Wed, 18 Dec 2024 10:44:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734518685; cv=none; b=YcZo02GdZ/cOH0t3/syxEvbpi0Bew2tG2JLrGBUfIMfuMf51Vl3rElFn5/yTqP1YFY0pJz4BrhgmUyP6uEvp0UgWrjiVx1nh/G6VShp7lax2nHxZ8qcvShUXiH17KFaRs+uGTykB5Ve5IOIkfZyxGU4htg/tyHqIu91Z6PlwmKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734518685; c=relaxed/simple;
	bh=FgzAKdbWXLWHun90WMZSodB7l80udUFu2CLZktDUfm4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gU6lSdiOschfoUxPK/1e/TVjEGwwn7hAb7wbkfO57Bc7rOIoqo4phAcOYQTr4c7HmixIb3UUh1VpvJix+cftkxAwsKm93/cUwQjgs5bKKjsiRE2pFrmPSfMgdDKl6JpHyx+tKEXV+JGrwUkFrhmAEobV5iLy4JksNcPl4dIK0Vs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ffwll.ch; spf=none smtp.mailfrom=ffwll.ch; dkim=pass (1024-bit key) header.d=ffwll.ch header.i=@ffwll.ch header.b=B5oQE4Y/; arc=none smtp.client-ip=209.85.221.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ffwll.ch
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ffwll.ch
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-385d7f19f20so3199325f8f.1
        for <kvm@vger.kernel.org>; Wed, 18 Dec 2024 02:44:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google; t=1734518682; x=1735123482; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=NQPNbO4Jh28X15Px0+LkPPkbR4yLtap4Vaw9U0pvMDM=;
        b=B5oQE4Y/BQCIREbjvnSQay2KhiUuxk3xnjDOCdI+tNcq6XQL7O+EW8ZiphrPSvCqvt
         D1VM8l+O4o9YFSLKtaMYnUMmJzY9kQLeN/Ggc5k90jA50a1bGrdLDvzUDSd26lGkZKXE
         w1OrzDtWIbaI0eEz7A3cTFhPQ98wdZHgsN9rk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734518682; x=1735123482;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NQPNbO4Jh28X15Px0+LkPPkbR4yLtap4Vaw9U0pvMDM=;
        b=NP4GLlf/eY2y7/2c3k1Tm8z7ktuSWj7v1Bj22cBWNijWL+6h2gfNTDZ5NW5K3161gh
         UC4kqNimCw2FtbNoNJ+eg7vowqQzcDISu3OB3L6HxRIrQeDsmMyPxf114QOK1FOlTPGf
         CHZIBeUgjQxSgHuPuNgE4MDo+uY4eCvvauBVBlzc1+UdLnWglToSmkZSw5mnDrJEjDZ7
         5VjgpG5Uj6gXz3fksiAU5gfUX6PyTf68S0a0OW1AJW5H5OV0jggGVUf+OFWu5iYGuvUP
         4+7pdNneK3TxkXZbwuRMWHeYA84ihGqhaJ8CYe+UcFnbMLZfHjUv9PEsNlS0KvgkFWs9
         ikpQ==
X-Forwarded-Encrypted: i=1; AJvYcCVOCm1g0wOBNq6MMExOiokjpkQ5umA6OkRNx+nDMKNL/LvBxm+QRxX6guUcUbvaJjZgtFA=@vger.kernel.org
X-Gm-Message-State: AOJu0YyCp9M7e/+on3EHzMjuEYD5FypBtK91X4bkC4A5y51Mo7p4YUYT
	68IVT7qYRnzdUd4zmbDq+2uaruTpaj2HFYM610B7MjhaSKw6pP+PN9itPe+dUvw=
X-Gm-Gg: ASbGncsXRnZ2YNEZjGKhkLenSxjE3wouBsXoYJRhmKd+RNJUIGAkY/x9ugM5VC/eBpn
	953SG6/06tlukqoeDA2Sd68OKLtQcLWY0IXpsUcwsQydmlj5LnV4oSf1GtuMtQXFpboawzCb2yr
	W0ulPlXr4iWVJlMMrh4S1BHgQJ89+htWa06R4HgJY/QrczQ5KFz6GFM56Ne8eNLrLYxXlYdb+po
	5ZHTOK2g01yHK+2XiZGBo63zqOQGNES8J+iY/m8apHfCOOBmJbj7SB2jA5028scMDWr
X-Google-Smtp-Source: AGHT+IHcanVPmRLlzM2e6vfR41Z6Bf/R2ewaujydkQ7EOTyW5LtKeaoeAxoDwby+iMKdhpEeJt9o4w==
X-Received: by 2002:a5d:6da6:0:b0:382:6f3:a20f with SMTP id ffacd0b85a97d-388e4d2de58mr2369209f8f.11.1734518682020;
        Wed, 18 Dec 2024 02:44:42 -0800 (PST)
Received: from phenom.ffwll.local ([2a02:168:57f4:0:5485:d4b2:c087:b497])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-388c8046c05sm13901360f8f.73.2024.12.18.02.44.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Dec 2024 02:44:41 -0800 (PST)
Date: Wed, 18 Dec 2024 11:44:39 +0100
From: Simona Vetter <simona.vetter@ffwll.ch>
To: Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>
Cc: Keith Busch <kbusch@kernel.org>, Wei Lin Guay <wguay@fb.com>,
	alex.williamson@redhat.com, dri-devel@lists.freedesktop.org,
	kvm@vger.kernel.org, linux-rdma@vger.kernel.org, jgg@nvidia.com,
	vivek.kasireddy@intel.com, dagmoxnes@meta.com, nviljoen@meta.com,
	Wei Lin Guay <wguay@meta.com>, Oded Gabbay <ogabbay@kernel.org>,
	Daniel Vetter <daniel.vetter@ffwll.ch>,
	Leon Romanovsky <leon@kernel.org>, Maor Gottlieb <maorg@nvidia.com>
Subject: Re: [PATCH 0/4] cover-letter: Allow MMIO regions to be exported
 through dmabuf
Message-ID: <Z2Knl1omccV-8Oa7@phenom.ffwll.local>
References: <20241216095429.210792-1-wguay@fb.com>
 <89d9071b-0d3e-4fcd-963b-7aa234031a38@amd.com>
 <Z2BbPKvbxm7jvJL9@kbusch-mbp.dhcp.thefacebook.com>
 <0f207bf8-572a-4d32-bd24-602a0bf02d90@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <0f207bf8-572a-4d32-bd24-602a0bf02d90@amd.com>
X-Operating-System: Linux phenom 6.12.3-amd64 

On Tue, Dec 17, 2024 at 10:53:32AM +0100, Christian König wrote:
> Am 16.12.24 um 17:54 schrieb Keith Busch:
> > On Mon, Dec 16, 2024 at 11:21:39AM +0100, Christian König wrote:
> > > Am 16.12.24 um 10:54 schrieb Wei Lin Guay:
> > > > From: Wei Lin Guay <wguay@meta.com>
> > > > However, as a general mechanism, it can support many other scenarios with
> > > > VFIO. I imagine this dmabuf approach to be usable by iommufd as well for
> > > > generic and safe P2P mappings.
> > > > 
> > > > This series goes after the "Break up ioctl dispatch functions to one
> > > > function per ioctl" series.
> > > Yeah that sounds like it should work.
> > > 
> > > But where is the rest of the series, I only see the cover letter?
> > Should be here:
> > 
> >    https://lore.kernel.org/linux-rdma/20241216095429.210792-2-wguay@fb.com/T/#u
> 
> Please send that out once more with me on explicit CC.
> 
> Apart from that I have to reject the adding of dma_buf_try_get(), that is
> clearly not something we should do.

Yeah if we do try_get it would need to be at least on a specific dma_buf
type (so checking for dma_buf->ops), since in general this does not work
(unless we add the general code in dma_buf.c somehow to make it work).
Aside from any other design concerns.
-Sima
-- 
Simona Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch

