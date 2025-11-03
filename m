Return-Path: <kvm+bounces-61782-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 2E692C2A2A1
	for <lists+kvm@lfdr.de>; Mon, 03 Nov 2025 07:22:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 882184EBC6F
	for <lists+kvm@lfdr.de>; Mon,  3 Nov 2025 06:21:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A2D1292B54;
	Mon,  3 Nov 2025 06:21:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="KhI8mYEc"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53C33285CAE
	for <kvm@vger.kernel.org>; Mon,  3 Nov 2025 06:21:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762150909; cv=none; b=cT1baHbFh7V5wBFTVCeNkgmBup7R8sqAiXfvedyb/SpWIgARkJ10XwoSN0ZbL4Ye7ep3mIABcKbCRsxj0K2dqU6o2iPTQYsPOY/LXsGwN0w8XNOG2bbxZsAzLUkans6z+a9znr68c7prIDTpr7sr6ye0QJJDETCkCigNNM090+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762150909; c=relaxed/simple;
	bh=q6TURu0Txeo2OJvua8KGcsnP9mDJkJtsWp5sVhFajZo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SQs0O7am6I9IC4loenjuehcBOn9fOqR3dTphutdnVKPVp9t2TV1slkwO4NjVyM45IbQ+nAbvfu8l8qAvG7v1PsnIsD5c+SoUzZlWN3csk4TcEqVPbUzpRUo4nEqq4MnM5WFgmdV9yQXI9eTL+vzaauXJhVt31232rPzMImg04Rk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=KhI8mYEc; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-294f3105435so331675ad.1
        for <kvm@vger.kernel.org>; Sun, 02 Nov 2025 22:21:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762150907; x=1762755707; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=nWlZBJWMNR3o5R9SijDhT22MNLu42EpPET2zOzK998A=;
        b=KhI8mYEcsJ6TsfAorMN5CZWcaO3mMtm1GdlGy1IAK4tgpOQ7Yot/PtI/AOVagzbjO2
         CGEC2YM0pqZQjIkQD1/P86ao7gWHDIU1yDfmEzrHslNfARjUAEQTdT19qhiVbkZDbaw0
         sja4N/5aSJLeibnBGHZ5v3lnK15n8+GmTl4xOBHotrB7WwLmuYYVrSgnGX+jRX+cIg98
         QfCXWLidFvNwyyoKMnmYHlU1NVJ3h/RKHZdEzAnNYs5VM1e2gpa93kP3i4FcZPgfCqw8
         7RxL2+jqJTzpc8KJNTR31K5PCArJ+3vHP0Q4L+3cI7fEakSceMf43vWyvjgu/TErg0L4
         ljTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762150907; x=1762755707;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nWlZBJWMNR3o5R9SijDhT22MNLu42EpPET2zOzK998A=;
        b=nK6rXPqKBmcEueDSp8mDcy3Z/S3iOw9OpYWIj6e2dPgGBabl8muMS/tTx5WNH9Dm9G
         j41TVZVBPbQRWbjxXqvPQhqcWfIw6eBz7slUvHMFReBlhHZS2rmZQLAMxKQuXJzFhsGV
         h0m3T8s9aK13jUWOMR8n2abEIlzYrNqTYchl5YQJo5Q2T5w4+a6sVxfMIPB3j2oSCeqG
         euuK1tFBaBIbGQh6QePqBoE0ezNojgLUOzGFl+PVF6ExvFLRabITtZl+dPwo4EOcpwts
         kp5znu5L8O7HC0oSQFw9vz5Ez9yybao0z3JlyPDzPZrPryibF603IUGENwWV2beJ8fQZ
         qIaw==
X-Forwarded-Encrypted: i=1; AJvYcCUWm9SvZuOFdNtqE0kaFGF7tePGUbLdg6LRrVIi4LE4gn5nuw5FG+xxUx3hUfap+xjooMc=@vger.kernel.org
X-Gm-Message-State: AOJu0YzHBZrtpevXjxdF1nOAwDUdbSX2sJBm/VIPEWTOBaUP34Nr4lJV
	stcZyN+C/qDOuCwOuEqMjTGJLU/aCK5DMFzgDr4LtkB5REOMUDHi92p74tr/YgN+1A==
X-Gm-Gg: ASbGncsFX/DW+Qo0ea5hySR6nWeu2j1RT1uFmkwtUkjD/C3h0NDIDVn9GrdTNagJy+s
	0h5fhAu0CyQKSIbJtqBAsg0g9B87b6dJQoLSPbg7EARAuLbvwQZCa/STCl7rsl+oBQVYVhrB4C4
	mrcREFfmjzIoBRDGyCFL7Ck/j/+tYSWtoiOF7ajt4eDb9Ivg6XyhJqcP5rTjyjuOra1KPvNaqPw
	w7F4G94moSnxGX+g61/fKpMXoJvvrC7D36BEyjoBQzHC1/O18z7qIUYGaKFfsMc2oPn9qV0ordX
	Dom0Lh3AoaTm0peR7pR5Pl2ODUR1ELGiAGfLD0ujhhm953SUd3BCkqZgqAQd+XqR4FGTpPwmuR0
	H+Lxd3D0iIUdEy7Ol6RVIP67fPrxb5OFoHDjiARi4FcAX9fou48QmVtk8ZhW1fulXsV5S/xDIfq
	w5uKbW7L8P7XY+CId18G5mys3gJDgcYU19oIxTQQ==
X-Google-Smtp-Source: AGHT+IGruOwIqSOkw/c0UIqbUAnBCrsgVRvu/C4si6qjv3qWziT7RTJr58fgj5zqaOcpkLKvHmo5tQ==
X-Received: by 2002:a17:902:e891:b0:290:dd42:eb5f with SMTP id d9443c01a7336-29554be37d6mr5455555ad.12.1762150907195;
        Sun, 02 Nov 2025 22:21:47 -0800 (PST)
Received: from google.com (164.210.142.34.bc.googleusercontent.com. [34.142.210.164])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7a7db67cbdfsm9912363b3a.49.2025.11.02.22.21.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 02 Nov 2025 22:21:46 -0800 (PST)
Date: Mon, 3 Nov 2025 06:21:36 +0000
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
Subject: Re: [PATCH 03/22] vfio/virtio: Convert to the get_region_info op
Message-ID: <aQhJ8OZiVYe06hv_@google.com>
References: <0-v1-679a6fa27d31+209-vfio_get_region_info_op_jgg@nvidia.com>
 <3-v1-679a6fa27d31+209-vfio_get_region_info_op_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3-v1-679a6fa27d31+209-vfio_get_region_info_op_jgg@nvidia.com>

On Thu, Oct 23, 2025 at 08:09:17PM -0300, Jason Gunthorpe wrote:
> Remove virtiovf_vfio_pci_core_ioctl() and change the signature of
> virtiovf_pci_ioctl_get_region_info().
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/vfio/pci/virtio/common.h    |  4 +---
>  drivers/vfio/pci/virtio/legacy_io.c | 20 ++++----------------
>  drivers/vfio/pci/virtio/main.c      |  3 ++-
>  3 files changed, 7 insertions(+), 20 deletions(-)
> 
> diff --git a/drivers/vfio/pci/virtio/common.h b/drivers/vfio/pci/virtio/common.h
> index c7d7e27af386e9..a10f2d92cb6238 100644
> --- a/drivers/vfio/pci/virtio/common.h
> +++ b/drivers/vfio/pci/virtio/common.h
> @@ -109,10 +109,8 @@ void virtiovf_migration_reset_done(struct pci_dev *pdev);
>

Reviewed-by: Pranjal Shrivastava <praan@google.com>

Thanks,
Praan

