Return-Path: <kvm+bounces-11056-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CBABF872626
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 19:03:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 458A7B23FDE
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 18:03:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2801217BCF;
	Tue,  5 Mar 2024 18:03:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="GtAwQhwS"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qv1-f52.google.com (mail-qv1-f52.google.com [209.85.219.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C471A18C1A
	for <kvm@vger.kernel.org>; Tue,  5 Mar 2024 18:02:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709661780; cv=none; b=Sa0augL5W6DNZMyIVhY1YA1FJ+MYWqrwc+AWEFD9zrM9RxUC+GmC/NwrIlkX191UAXqKAeKBiv7tmTnglrNIhvAXrA9taBwo/mlTJGoawRsaF+8iUyEeeup/dK1jisxQEgz7m/7KAW40tgN33d1L/rtFlM68N9OlY2wYKUWxbwo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709661780; c=relaxed/simple;
	bh=1Ygz/jFXjFE5S3QIqY1MdyAleIqkDTe8bwk1VT3gG80=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bROBh3jun2OxcE5mmCeLicPlFZYaWVl7r/yIdxSlN5NvjW0FP6bpaqoqwpWoF31EArBOXQd/C9dolcg1LV9R3OnKNFPwoXlUa7CX6S9Ownu6jEVb70sO7bBqK/VX6AXecqm83o00Sua+FU9ZjVDwQ54iBUAJJ2P/djSgvi0IAGM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=GtAwQhwS; arc=none smtp.client-ip=209.85.219.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Received: by mail-qv1-f52.google.com with SMTP id 6a1803df08f44-6901a6dca63so38329086d6.0
        for <kvm@vger.kernel.org>; Tue, 05 Mar 2024 10:02:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1709661776; x=1710266576; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=4deBuZmVeZksIG4kx/F0ukZwUGCDjZkGD+TjmZ4rLG4=;
        b=GtAwQhwSzB+3QiHyOSvmVPn1wXC5UIM10xgIEIAKMETZatp6Vp/RHfMGcW3EBh4B/F
         E/OhoyBVBYZgCmH3xIndSJCKbclQvGKQtj81jRAhwRVryaXBoib2LCcPfzDdVN0DPzjt
         jMtmq769oOtxo87amoop3xhM+yuSyyFtm7erZVGBPcJRm5WrzTUfJBpTrL2MQ4oKaVUY
         qjab27myxDD3r5B2NTPlUjmlishNg1L5vHvcRJuu+BfrDVI2or9ZuEvOkUH0JlrYTsnv
         cFn2Xe+6QtMNT8jxvJA2/TVwUy9a4zrtCKRfaRNpbLAGKHMH+u63M5WnKfz/LiVPKJmH
         mMoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709661776; x=1710266576;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4deBuZmVeZksIG4kx/F0ukZwUGCDjZkGD+TjmZ4rLG4=;
        b=Qel7eh/07eXslzzuyO/BTDc0eUwkKo+gpG/Bx7RGKfOUbcRnBAay8SZgg2wwyj0INe
         kb3PC+oRxZQsA5QgHK3NkCOmi7g02czq9FOVl1765Zhv5FhuoBsVc2MMtrJQ653Dl2HZ
         edrBDmvofKHSWUrpQHBIBV7zBhyIe3kO5+HQZS+DD+1rwhTWJZxLwU+n5VzHgRqgqJky
         niO6BGg31xsOv2iDDx2HPIxKJctnxT1hzZ4VHJTVkj/FsM0z4DLouN29OFN6Ypifw/j2
         TuN3m4Evc/15T7yK6tO+1LI95KtM2hIzgb4e/aeZmahyxSoMO4Uh4XuX1JoiDil02C52
         AgKQ==
X-Gm-Message-State: AOJu0YyIhksZlSDKMRE7193O8DOuyzkQ3bAjWU0ekzOfvJ316lH/cVuf
	wxaNI2nDc3mBWpBGQ81zMw9xUHj7FlSC53gmUXHrMr3JfvB9O7q+8kf+E9Ald09roMd1Bt1n4/z
	BYoU=
X-Google-Smtp-Source: AGHT+IE4UtkYTBnWmUpd4cHJhiWmin7dosv4PZILpNahbLmEa4KQ/A/aLmEZ8smWulCzyEgAXwOqUA==
X-Received: by 2002:a05:6214:a48:b0:690:89af:cfe5 with SMTP id ee8-20020a0562140a4800b0069089afcfe5mr2145509qvb.13.1709661776721;
        Tue, 05 Mar 2024 10:02:56 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-68-80-239.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.80.239])
        by smtp.gmail.com with ESMTPSA id lv8-20020a056214578800b0068f881d0d00sm6281209qvb.53.2024.03.05.10.02.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Mar 2024 10:02:56 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.95)
	(envelope-from <jgg@ziepe.ca>)
	id 1rhZ7v-00G5t6-En;
	Tue, 05 Mar 2024 14:02:55 -0400
Date: Tue, 5 Mar 2024 14:02:55 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Cc: kvm@vger.kernel.org, alex.williamson@redhat.com, yishaih@nvidia.com,
	kevin.tian@intel.com, linuxarm@huawei.com, liulongfang@huawei.com,
	bcreeley@amd.com
Subject: Re: [PATCH] hisi_acc_vfio_pci: Remove the deferred_reset logic
Message-ID: <20240305180255.GK9225@ziepe.ca>
References: <20240229091152.56664-1-shameerali.kolothum.thodi@huawei.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240229091152.56664-1-shameerali.kolothum.thodi@huawei.com>

On Thu, Feb 29, 2024 at 09:11:52AM +0000, Shameer Kolothum wrote:
> The deferred_reset logic was added to vfio migration drivers to prevent
> a circular locking dependency with respect to mm_lock and state mutex.
> This is mainly because of the copy_to/from_user() functions(which takes
> mm_lock) invoked under state mutex. But for HiSilicon driver, the only
> place where we now hold the state mutex for copy_to_user is during the
> PRE_COPY IOCTL. So for pre_copy, release the lock as soon as we have
> updated the data and perform copy_to_user without state mutex. By this,
> we can get rid of the deferred_reset logic.
> 
> Link: https://lore.kernel.org/kvm/20240220132459.GM13330@nvidia.com/
> Signed-off-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
> ---
>  .../vfio/pci/hisilicon/hisi_acc_vfio_pci.c    | 48 +++++--------------
>  .../vfio/pci/hisilicon/hisi_acc_vfio_pci.h    |  6 +--
>  2 files changed, 14 insertions(+), 40 deletions(-)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason

