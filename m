Return-Path: <kvm+bounces-64018-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 2ABE2C76C4A
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 01:25:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id A927135504B
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 00:24:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 679B625DAEA;
	Fri, 21 Nov 2025 00:23:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="X0nsss1q"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qv1-f54.google.com (mail-qv1-f54.google.com [209.85.219.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10D5A2459C6
	for <kvm@vger.kernel.org>; Fri, 21 Nov 2025 00:23:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763684629; cv=none; b=aUr1z7t8Y+iZanPOYuJtxiiAco6KUajpU6L79X+6vkqaTGBLXWbAmy83F5y+e9FdHlzGOy9Cx7etp3FXZ8kc9A2jF+yzfTX5WroorqJ9epwhP98KzWS8t1PDn06/RQBqMy5KmhthCMP9vi5SogXc/d1da13u2YqkFkoeyql46RI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763684629; c=relaxed/simple;
	bh=rSFCVYBQGHYIVw4AaRKYw6Ay38HyAtjHDSJOWPLks+s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ANSMFktBmjJjzVahrG5RhY4gLyrzNSdG2G+MGp55ScBaplrnzDexbnglq8prCliJFzN7rnMPAPM8tAfrFVo1qbasy+JZHvd6Zf9TiTPFGXUoVRg7TaxREB0hplkF2+wlyUfIyV4EytfO2+LuZSffHUbggiHi23rNonEIxQYi//E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=X0nsss1q; arc=none smtp.client-ip=209.85.219.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Received: by mail-qv1-f54.google.com with SMTP id 6a1803df08f44-88242fc32c9so17085786d6.1
        for <kvm@vger.kernel.org>; Thu, 20 Nov 2025 16:23:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1763684626; x=1764289426; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=HeoQ6A9zQA47pPVQ4WN0R1Mr0WB5BGBDvzJz+/SIjn4=;
        b=X0nsss1q1dQAqvVQCjfcM7UUewWlBvLurLKTQOkoLVBJ11Zbv8ClxmGVsU1Bo6EF5b
         qB1Gi2Yhtkul9cgel4Ab+PKL3kmhaxR19s/esS9Nary6n06TyegRG022N0a1RmQ8sFQJ
         Ar/lOjV0WQuho9a2OOlwX2VRTf+i183+ahDzvYQdBGOKzztulAsjTqiXgnQP438u63kz
         84HsJu/Oi7pdM7HSBpBL0ajrrzV4LFaclFsAjGqTlANxGvWpGEGC8h7B/dZ7yx5ZuK5v
         9BQIRbH7CWDiUe1Y5XDQZyyKT8tkkQWxTuthpFeNHPLVryv7gw6vE+thgY7MLcr+xgTz
         DZSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763684626; x=1764289426;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HeoQ6A9zQA47pPVQ4WN0R1Mr0WB5BGBDvzJz+/SIjn4=;
        b=eteiQ2qSKCs6/o/VmR7b1TZJ/r+JslTHe1S3PvxGZjmP/wR9H7YVeWlndrMCBHwStX
         iwntBpTaeyiL0vYUuQEfP8VJx/mpl+vii8kqZV6mXAgTsSF8QFij4D2uKDr8OmKHIn2h
         7Hj1i53K2j2Lkhz5X5hqCmjVrF8ggk4BYjg9+K+odrwchOjURWl4Biw8Dj0m0nHxS+Tf
         zDJXO4Ih06ELR4/IXNIXXOmlhVw5Rq48XpW8MWXN8oszq4SN1OjyBR+YgR2jw0UefXnB
         sXbVlGsxEO4/2AmQVoXNm0YZ2qejuk2J5h+EBZ3dN26TbxB0wideqGqr/03gzoTrpI+A
         tdKw==
X-Forwarded-Encrypted: i=1; AJvYcCW7MQ7eU5kI31XQYbXqyy/uoT7gpAsbFTUlxrdMrsNDw8se63I6E3j3W+ZEIOeJjlyyMd0=@vger.kernel.org
X-Gm-Message-State: AOJu0YxYu3IM9ojAsbDDcA5pCnF3LZR8/6IQyrq5uYJou73NZP8u7IvZ
	iYClUnz6kYdnlRSSVQw8zdtpa+qUna8swyRltWqEG2/8dRhvd0SBWMqPd0MioxNcoI42HBT/vEC
	P8ujG
X-Gm-Gg: ASbGncu+3zcAnMEKeeUfWUw35V8G3JQvEBVanDwCCDnJcEw/S2R0dhLpBBvkLdQ+5EH
	d7QGIS8Olik8JgAD8J0qabAz9jvsWhwL+XWKb313lWlAnZ3ND7FcBGC8nuDLNUZrV54x2jKzgxh
	EmjkNBnFLT0VQf5ap2viYrYhA+pbLQa4C3SzCVVSUIyFKMCOF42vAIGRikN6d5e928Ocox5nFAn
	MkSb4apof17MA2eoomKkNqVpJmNcfandxdcCkddYmQVnpuG7OhI5uNVpq+ooXEyYVr2hYsUWDVz
	D4oDegQbSBp47J5eBWh8d+6Q83yscrJQMaNtYNOwWOcGfsILzekmIgEj+Ok71PLiueO0WAqctkB
	FXCkatuigVsqt53JvwFbFm1kYh0B+8u7+fnOkuoV9ygv8QpTji5hpEJvlg+KnUhm1YuIPvp3wZq
	+x3dqep5j+crvkVpgjDl9jLd+2pCmcl/PLBYNaC0wH+AmIIHHvhSn/hNUZ
X-Google-Smtp-Source: AGHT+IF9fpUZC0KSEi60qYSTXqU5TN/0kv3Br6v+7st2smYcT5XQOEwOWy/F2amvDq4QuChbOli5Vg==
X-Received: by 2002:ad4:5d42:0:b0:880:2c08:88e with SMTP id 6a1803df08f44-8847c5206f8mr8425876d6.45.1763684625945;
        Thu, 20 Nov 2025 16:23:45 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-47-55-120-4.dhcp-dynamic.fibreop.ns.bellaliant.net. [47.55.120.4])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8846e472ae1sm27645766d6.22.2025.11.20.16.23.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Nov 2025 16:23:45 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1vMEwC-000000016i7-2ZE0;
	Thu, 20 Nov 2025 20:23:44 -0400
Date: Thu, 20 Nov 2025 20:23:44 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Alex Williamson <alex@shazbot.org>
Cc: Leon Romanovsky <leon@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
	Logan Gunthorpe <logang@deltatee.com>, Jens Axboe <axboe@kernel.dk>,
	Robin Murphy <robin.murphy@arm.com>, Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>,
	Kees Cook <kees@kernel.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Ankit Agrawal <ankita@nvidia.com>,
	Yishai Hadas <yishaih@nvidia.com>,
	Shameer Kolothum <skolothumtho@nvidia.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Krishnakant Jaju <kjaju@nvidia.com>, Matt Ochs <mochs@nvidia.com>,
	linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org, iommu@lists.linux.dev,
	linux-mm@kvack.org, linux-doc@vger.kernel.org,
	linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linaro-mm-sig@lists.linaro.org, kvm@vger.kernel.org,
	linux-hardening@vger.kernel.org,
	Vivek Kasireddy <vivek.kasireddy@intel.com>
Subject: Re: [PATCH v9 10/11] vfio/pci: Add dma-buf export support for MMIO
 regions
Message-ID: <20251121002344.GC233636@ziepe.ca>
References: <20251120-dmabuf-vfio-v9-0-d7f71607f371@nvidia.com>
 <20251120-dmabuf-vfio-v9-10-d7f71607f371@nvidia.com>
 <20251120170413.050ccbb5.alex@shazbot.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251120170413.050ccbb5.alex@shazbot.org>

On Thu, Nov 20, 2025 at 05:04:13PM -0700, Alex Williamson wrote:

> @@ -2501,7 +2501,7 @@ static int vfio_pci_dev_set_hot_reset(struct vfio_device_set *dev_set,
>  err_undo:
>         list_for_each_entry_from_reverse(vdev, &dev_set->device_list,
>                                          vdev.dev_set_list) {
> -               if (__vfio_pci_memory_enabled(vdev))
> +               if (vdev->vdev.open_count && __vfio_pci_memory_enabled(vdev))
>                         vfio_pci_dma_buf_move(vdev, false);
>                 up_write(&vdev->memory_lock);
>         }
> 
> Any other suggestions?  This should be the only reset path with this
> nuance of affecting non-opened devices.  Thanks,

Seems reasonable, but should it be in __vfio_pci_memory_enabled() just
to be robust?

Jason

