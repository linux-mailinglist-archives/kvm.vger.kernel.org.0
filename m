Return-Path: <kvm+bounces-61809-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B2F44C2B051
	for <lists+kvm@lfdr.de>; Mon, 03 Nov 2025 11:22:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 80F043A97EA
	for <lists+kvm@lfdr.de>; Mon,  3 Nov 2025 10:21:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 04B172FD69C;
	Mon,  3 Nov 2025 10:21:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="sNuwm7xz"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D19EC2F9DB0
	for <kvm@vger.kernel.org>; Mon,  3 Nov 2025 10:21:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762165302; cv=none; b=EBxb1s8pkP4l5OZw7VLwmGZ5qqJcfHmQluG06XKG9Ve1iZZoCesEeJD6BAjxQBSgKxj+dxaEUSM4oyTCLZNjVAVkfMXgmLhaCbrBflcxT5DWpDhJcK2j7QVWpubmnwD8bJC80KBSLVHGa9mDc4Ri4o4XQ4cDD4EbVCBFISvV5qU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762165302; c=relaxed/simple;
	bh=/HKMzy5aaV8LtDdSBvQnNIuHvkwtMkRBm1mFEXs55wk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rpk6x2lPiBF3JEj7yj8utmnvbjOl9hhsbuDbJbzDm9QhL/76KZ81+U99vcRcIvZk2O0dqr+kteqQDeswOrJqKiY4mgB2aUiR3IJqk/muQHM3N+8acF4hzk47JI8y6W62dpmK5xVgPrRVtklOsOef85S5ivhco44Y/SjpGCCMxj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=sNuwm7xz; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-295c64cb951so122895ad.0
        for <kvm@vger.kernel.org>; Mon, 03 Nov 2025 02:21:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762165300; x=1762770100; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=zM2bsN+XnlGuvDGqw1tQvaweGHKrw1JAZACa3YqST0c=;
        b=sNuwm7xzNz9BLR8g0i2a59brtv119zUXWWp3H8jbpe4jCVYshPpPZv5ScrHhTA3Jr1
         XAdKZugGhct9NDwTxzTECaYg5ZcePD1E1jHsbGEdFV+fDSmoVg7CxhsMl9lCxcFqFm5f
         0i6/DFVx0n3GiFjJBU4xc+BeDrbJwMyXySozNTgBGhPJGeL1BgLcJO1DF1QbbtzrLQqR
         t9x0ZeAs+ETfQxnYJf2er3zw3cDVm4/+KGv/5K3xysXao6JY8A2auRjbGwSX1f1Jb4aE
         MowFe5AFaKUEJiHYfGpVkbb6sIJIj+S5DPv26psI09xE6ZWTsuv/XkzfTaCdE5OGVXxD
         2D0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762165300; x=1762770100;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zM2bsN+XnlGuvDGqw1tQvaweGHKrw1JAZACa3YqST0c=;
        b=D4yfZC2QWysJ11bIYtTGQc7FO1qds8vkQAkClcnhQqmBaiIyb8OZzN5DcDsdHMyrO0
         SNd+ci6FYkEUFYrtzFprX5YoSEyCga2QETlyBpDtFKrlBxSUf9bAPlXtoOBn6V7h/EPV
         rNYSEi719rtlQdGppR1WIeIuSWy1ZttwCSRY5GLm+0bFObm0Nu3k5Wj6PxKCrHt1e4Vr
         7GOIhg0n8/3MGRxif7oNxwLBVEO3zktrwFsLH/g9t/S/0p71Bqo7KHhhye0kayTn9K3K
         8MK/dMEuVMMyWuXz8tuNeL+LztK6dKL9hTAg3KYgNQjYR82gAymuBHqI3sG19UMCUf8U
         tr7w==
X-Forwarded-Encrypted: i=1; AJvYcCXQJpC/UeAtht8Zw6R35uKHb3T+bHFC2ICfzrTF5ymmFC5FTLB+Zx4DCknqXI89QtqYmdU=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxv0qU/jt8GcLJOqtlc4hoWGFDGJBgsAs9X3VfJzGL/frtbzs5i
	QxtnDvPnRCnKSRcCPImkO8oeg2amR6w47VmMyXypIuLZDoLqhQnjYLb6WpDJ3xBy/g==
X-Gm-Gg: ASbGncsp4i+g3xV3ejs0ca3lSC50X9ov4x++86mf+bJLp5e7Vm4RKuqugll/ixn7K1W
	PwBQqU6y54yAQ/Kc+HmvP97okpIOdn0zddGdOuJnMj1feEpHK/RNkfK/lLGm8btIn0oFqRfFnjj
	EKQzTKbNK9NmiUDD3ILOrdQzaSwy+xDPCtkQbsMLfuY1p5iZY4rBJnfd7Vg7RUsfyFVUOqu7vFL
	iz0oMTAB/mm3VTCNPlH5JfR6bFlRTR0zzGe0P0px60QKeT4glW/M1s0hTNYgbi5k12GY7ulMr5t
	CoYLjMdk6K1qQr/gDPZcmWchNFJfri+4EFeJdp9OCLBBqk5kXJf+cpG1C/iomFcf0+ox0Ae8Wwi
	Su/90TDoGL2ZUsAfWteQNYi+gy0CF4robLcCRCO2VJ8X2He/GXkBpz0VC9RT1k2VrxLn7YM03sC
	il3CUCSE70vaeY0tEjoIotPWlW92qEfmX8oCreLe8+smt6fFWp
X-Google-Smtp-Source: AGHT+IHDQYQU+xgcIcym40SdSIPVCJL4E/vz3sWG3WXd+xmfQ1K9iSuwfFgvjeHeyY3RCG42umC9MA==
X-Received: by 2002:a17:903:1a70:b0:295:28a4:f0f5 with SMTP id d9443c01a7336-29556476c7amr6429175ad.5.1762165299489;
        Mon, 03 Nov 2025 02:21:39 -0800 (PST)
Received: from google.com (164.210.142.34.bc.googleusercontent.com. [34.142.210.164])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3407f26e0a6sm6205722a91.5.2025.11.03.02.21.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Nov 2025 02:21:38 -0800 (PST)
Date: Mon, 3 Nov 2025 10:21:28 +0000
From: Pranjal Shrivastava <praan@google.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>,
	David Airlie <airlied@gmail.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Ankit Agrawal <ankita@nvidia.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Brett Creeley <brett.creeley@amd.com>,
	dri-devel@lists.freedesktop.org, Eric Auger <eric.auger@redhat.com>,
	Eric Farman <farman@linux.ibm.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>, intel-gfx@lists.freedesktop.org,
	Jani Nikula <jani.nikula@linux.intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org,
	Kirti Wankhede <kwankhede@nvidia.com>, linux-s390@vger.kernel.org,
	Longfang Liu <liulongfang@huawei.com>,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	Nikhil Agarwal <nikhil.agarwal@amd.com>,
	Nipun Gupta <nipun.gupta@amd.com>,
	Peter Oberparleiter <oberpar@linux.ibm.com>,
	Halil Pasic <pasic@linux.ibm.com>, qat-linux@intel.com,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Simona Vetter <simona@ffwll.ch>,
	Shameer Kolothum <skolothumtho@nvidia.com>,
	Mostafa Saleh <smostafa@google.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Tvrtko Ursulin <tursulin@ursulin.net>,
	virtualization@lists.linux.dev,
	Vineeth Vijayan <vneethv@linux.ibm.com>,
	Yishai Hadas <yishaih@nvidia.com>,
	Zhenyu Wang <zhenyuw.linux@gmail.com>,
	Zhi Wang <zhi.wang.linux@gmail.com>, patches@lists.linux.dev
Subject: Re: [PATCH 20/22] vfio/platform: Convert to get_region_info_caps
Message-ID: <aQiCKBl0ScO78Le9@google.com>
References: <0-v1-679a6fa27d31+209-vfio_get_region_info_op_jgg@nvidia.com>
 <20-v1-679a6fa27d31+209-vfio_get_region_info_op_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20-v1-679a6fa27d31+209-vfio_get_region_info_op_jgg@nvidia.com>

On Thu, Oct 23, 2025 at 08:09:34PM -0300, Jason Gunthorpe wrote:
> Remove the duplicate code and change info to a pointer. caps are not used.
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/vfio/platform/vfio_amba.c             |  2 +-
>  drivers/vfio/platform/vfio_platform.c         |  2 +-
>  drivers/vfio/platform/vfio_platform_common.c  | 24 ++++++-------------
>  drivers/vfio/platform/vfio_platform_private.h |  3 ++-
>  4 files changed, 11 insertions(+), 20 deletions(-)
>

Removes all the boilerplate (copy_from_user, copy_to_user, argsz
validation) and lets the VFIO core handle it.

Reviewed-by: Pranjal Shrivastava <praan@google.com>

Thanks!
Praan

