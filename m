Return-Path: <kvm+bounces-61788-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 689FCC2A42A
	for <lists+kvm@lfdr.de>; Mon, 03 Nov 2025 08:15:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AD3F8188CC80
	for <lists+kvm@lfdr.de>; Mon,  3 Nov 2025 07:15:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 025A829A300;
	Mon,  3 Nov 2025 07:14:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="3l0LwOAQ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEE3F29993A
	for <kvm@vger.kernel.org>; Mon,  3 Nov 2025 07:14:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762154092; cv=none; b=GEc1Wn5P2sOqVCNpmkPrUAQ1hk78UXt8M+CeZY+u/geTk8YPqET4CBwQl3AXo7qsPBdW5czOZ9FMWVtLeL5GVFvUcaQchLfYWKShOBKTkgBkwBIoanGgehlC1tJcjY+XVzL+oJ40LVXvEZKQj+xD+7DJDjeSH2vpuTn5JVfxgiY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762154092; c=relaxed/simple;
	bh=M46toCVjS5FqeK8M2CG3xD/T7DNTY+jrsL9mMEekFOE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Nv36gwYlvTY0qoHgNm0lycewfBo+OaSkKsdO13DstNn9meROyIhGdeKucb7A8ODeR29jq2aKMYHYle9xk2uDed7enmw6yclGOvz2GGJN/6Kyexfo/hg4rqXzUmIF2fU30Le4p5kHiztZLjP4+rv8A7xujpiTN4aOIqBy4lNRB7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=3l0LwOAQ; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-27d67abd215so381355ad.0
        for <kvm@vger.kernel.org>; Sun, 02 Nov 2025 23:14:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762154090; x=1762758890; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=krxDO85tsubF5J6uxcbfpS+xA/eKw7o0+Vmbt9d1Ois=;
        b=3l0LwOAQyUnzNrd5Vzgo5Uey8TOYpqL56YEDPcntnKW6zOEv30BW7kUlAPg1U80xGa
         WQ/5tbrA1P7jBLezIx2eO1+Ilr9LbEIauHSWlTbNwbyvjDONd/NIkuEZbzHo0y1YItOb
         k1rygZj8tHYr07dR/n8x6NdY63FwHiMR8I97uXdHZjOirlV3K5Ywh3YSGZ4C8xLnPXes
         6e6YY5oYcXLYaajC3B5DcEtPKllYQgL4aYZJAKFd1fijWXPtpKtqePJnWErplu7zp3Zd
         BU/eCa58K7Zzpj6/O70vZwSa4GHHDqaR3YLdzxTHSsX1lC1AZYkNZ7O6LqDRofani0JX
         47nA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762154090; x=1762758890;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=krxDO85tsubF5J6uxcbfpS+xA/eKw7o0+Vmbt9d1Ois=;
        b=rSIRw4Kssqn7HqQNpomUasFHu8fA3Evko9jDRpYpm7bBQDrrPNkiT8YNnPsrIBABQ4
         ilv3tE+syFhREqC6/mUXbCnW5k/LhitI2WIN29QePLF82uoCgV9+tiXonO3ZMKQth+cB
         nYoMZ8zF1RHK9GL4sfF3+hOvtXQXjrT+9ZkR4wyfM9gIEUdCbN2FsPRPvMqBANciTc8Q
         P4t9MNR4od1bzeSYQ+12uc9rNmxXQ0hFRKl9FsjK0XT+oe6InG6jIBrEOWi4bmKNmqGt
         SA6kPPcFATE7Eye24CoFWsdbS4zWvlIVbRxVDAsxwOFINcSA7n1BRdEwoSXA440PW/hq
         noXA==
X-Forwarded-Encrypted: i=1; AJvYcCUEiHWc3EuXBD2xuvSYN6GJ4L3lVdQ7Idb3z16pN8QbeMoaJS88r2vqUjNZ791L4IH6js4=@vger.kernel.org
X-Gm-Message-State: AOJu0YytJv+x0uWkfWzeDo60KOIOWRNKl41//+pMvTf5B3VsIOvnmea5
	qeBg6ij4fJyv96ezlibUspyHoPDCEZXzLjZMvQvdGM2Y++IBcNHKNl1OMQZ+cLbPgw==
X-Gm-Gg: ASbGnctePapgNwSnhKzEeAuUCy1FIxD1YF+IXHfs42+OGhWik3x+23tGt+zLgkIzupR
	yiK9itPDe7dDDXX+tyWOYPysKkc7NzF8wkn1o+WdvD0WcqhpHMJlJsZGDHz7wegLgT0L0v7euum
	bxBTnENW0SlTTB7RaVsVoeTAlJVvFEJJNX0DBleFYa69xcyu96A4+b4c1pHhzO3t0i6kCafRexN
	L5GlKH+y6pmbtcZVIEVNsRXsxHFL80yC141ieblGQ2NhfrcJ2EhjfrwOm/mQeWhUArGJc3vmINq
	MITUCC05Q7qeg5u97yk7uu+OWQhJ30m1B/1hB3RaM1CDj+pEajEYAdC3tvSf73W2hwLHJOGAwF9
	X7jxUmwxc150IJO3n+Qu51M1YPGAasZdiKRpPCsw6KdFKuiH/dTlQJEZT134vL4M3cBc9AELc1g
	ReuBwnVLj77NmRuMaQh1v74oZ5eZx5ztSdWPuHDg==
X-Google-Smtp-Source: AGHT+IE97CemVwDodrlEsACTbu3ii+CcSlX4Mt/UH1nASQkOOWezhknbfsTfFcSLebBhaZ2a41/idw==
X-Received: by 2002:a17:903:184:b0:25b:fba3:afb5 with SMTP id d9443c01a7336-295565ad1aemr5343685ad.11.1762154089465;
        Sun, 02 Nov 2025 23:14:49 -0800 (PST)
Received: from google.com (164.210.142.34.bc.googleusercontent.com. [34.142.210.164])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2952696eae8sm107020535ad.61.2025.11.02.23.14.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 02 Nov 2025 23:14:48 -0800 (PST)
Date: Mon, 3 Nov 2025 07:14:38 +0000
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
Subject: Re: [PATCH 09/22] vfio/platform: Provide a get_region_info op
Message-ID: <aQhWXmluuFaU3XPL@google.com>
References: <0-v1-679a6fa27d31+209-vfio_get_region_info_op_jgg@nvidia.com>
 <9-v1-679a6fa27d31+209-vfio_get_region_info_op_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9-v1-679a6fa27d31+209-vfio_get_region_info_op_jgg@nvidia.com>

On Thu, Oct 23, 2025 at 08:09:23PM -0300, Jason Gunthorpe wrote:
> Move it out of vfio_platform_ioctl() and re-indent it. Add it to all
> platform drivers.
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/vfio/platform/vfio_amba.c             |  1 +
>  drivers/vfio/platform/vfio_platform.c         |  1 +
>  drivers/vfio/platform/vfio_platform_common.c  | 50 +++++++++++--------
>  drivers/vfio/platform/vfio_platform_private.h |  2 +
>  4 files changed, 32 insertions(+), 22 deletions(-)
> 

Moving the GET_REGION_INFO logic to vfio_platform_common.c and exporting
it for both the vfio-amba and vfio-platform drivers to use in the new op
looks correct. LGTM

Reviewed-by: Pranjal Shrivastava <praan@google.com>

Thanks,
Praan

