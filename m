Return-Path: <kvm+bounces-35693-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 295E6A14394
	for <lists+kvm@lfdr.de>; Thu, 16 Jan 2025 21:43:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8D7F6188B48F
	for <lists+kvm@lfdr.de>; Thu, 16 Jan 2025 20:43:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9D118241681;
	Thu, 16 Jan 2025 20:43:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Cm+594WJ"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0F3A22FAFC
	for <kvm@vger.kernel.org>; Thu, 16 Jan 2025 20:43:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737060208; cv=none; b=TQCmk8UMXheRj5QG6ReOlP66C+LS3GEko9MGZlWa59UXCyNdobWebnjmD0ELwFnXWIM+KriOEx/rsjTe+K6I6C9IiOZYaKxAoXys4J59U4gMGuWICs+FIjSN4HOfo3wGz9m5zC3CS1oGVOmRszBfLO4mdYlsJy8UtfTUtlZmcGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737060208; c=relaxed/simple;
	bh=ShOFB+QP0++gznzpcfLaYgU4N+GaVzhiiTWwaKtsxa8=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nWZzYAzCEUW8VJReJ9v/rp2EYzRMeQtG5ZPRvb4rULwI52VhpUd745BiLFd8hlukQZyopyJz3iB9W+ojdLX2q26qmwwD26jf8kaFY+uzGtKyoAdyoQS7MfZhxnH//jmoeT40/aJ7iBYbTnznrLrfBBfm861dbIX0eS6NyVZ9pfM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Cm+594WJ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1737060203;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mBGlIKz4vIjple3ZYPVyvO5Ps5hUBmWm1TRR7fUzGj8=;
	b=Cm+594WJQG8ZhfCPop5hkDZNQQUph7l6YAuKuPfKRqsA9f/WZwML3M/SJns1bpuO+8DoWk
	uXGKiUwaj40S9lfclW1zwhoY0eI2Z/OBDDjTiJLaV7+Tkh/RD67/JMW5D2HNE/A6rtWYh7
	g/i1YSoh1WuA0v6dE4aij8x6Fz2qwGE=
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com
 [209.85.166.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-106-j9a3KslfOr-BMtrj6GYSnQ-1; Thu, 16 Jan 2025 15:43:21 -0500
X-MC-Unique: j9a3KslfOr-BMtrj6GYSnQ-1
X-Mimecast-MFC-AGG-ID: j9a3KslfOr-BMtrj6GYSnQ
Received: by mail-io1-f72.google.com with SMTP id ca18e2360f4ac-844d68dbe60so17111639f.0
        for <kvm@vger.kernel.org>; Thu, 16 Jan 2025 12:43:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737060201; x=1737665001;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=mBGlIKz4vIjple3ZYPVyvO5Ps5hUBmWm1TRR7fUzGj8=;
        b=u7/Ec6FiOch/H6X8nuRyEE2UC7uf9k2SI0bBse2G32SOaH6O15J0Ywnjl5FfnxywVd
         boGyQA95ihpxLTagZeYNljMaAIixIU3j+hYAUUF/cjBJBOpVlHiZNhLrImy99AF/gy89
         Xhj/Q8voOhi5lkaRu7kLY+gMXyEyuFVqkMOZ/RPDi3OvtDc+8cPDJfUjWu9NLXu9QPyg
         UprJbFkQlFxp9LW0kunoyr2iDEkcV1nHMXNosklY0agKHjEL6kMTrBjzXQynn4Y6lH5W
         1bwbn4g7uuN8ZhKgpvRTwy4aLY7jpm1oUZ7t4CR3Q/WVOSsm+ntjYqsGuwqIBJ/SCumQ
         1EDw==
X-Forwarded-Encrypted: i=1; AJvYcCUVBh2l7ck0YbGV1Gxe+R4DiqpyakN8XayXbn3+K5lIpBZNB8hp3Pz1iXOo8uQx7sKlNnA=@vger.kernel.org
X-Gm-Message-State: AOJu0YxhgPG1eLsYQ0Gdvilr4ARqI45ZeUBvpt9RhGN6ZUP7xgjo91G2
	+nUyQSn8h+qajpstX50GcfOO1hDSj2A0baKax1/nP9X8ngp1GvY4wWv+Xm3OUl7Y8hHQGKHD+ax
	DLFDkMFuBKTogjr6NTY4btrKpcLlrLvlF+P0dpkGf8tFzfPEIdQ==
X-Gm-Gg: ASbGncsu5V3jFfChag/bRYn9T1743BfgcO+A2AHHOJBKyOw/vWRyDnKGUM4WekzClFw
	tWeScTh4R3Op0ovC23mZIqDWJJmwr7NhhPFDw2ccB9Yj4shXWFy5ES1i8R22Y0URznOMGCRrKgB
	1QqtCAsJA2x8Nq8PR1fz+TtgURpb/Ng02esAe2VbCOT6yFbiAl+okTdyDg88N0Uf3x3EXrtj6zv
	YD9Zq1ggcm9AXmF6xGgWHQ9L0y+j6FFkVbveDNUT5zluHZhZkWNu+LRJi4F
X-Received: by 2002:a05:6e02:1a4f:b0:3a7:e7bd:9f30 with SMTP id e9e14a558f8ab-3cf743abb1bmr158495ab.2.1737060200954;
        Thu, 16 Jan 2025 12:43:20 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGGXMXdA+gl3GxQiRXdE/tGRFbWNceG/xjkMAye0jVkrD+cLbaJ3aRBbq7ju/DCsxtpSamm3w==
X-Received: by 2002:a05:6e02:1a4f:b0:3a7:e7bd:9f30 with SMTP id e9e14a558f8ab-3cf743abb1bmr158405ab.2.1737060200683;
        Thu, 16 Jan 2025 12:43:20 -0800 (PST)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4ea753f64cbsm223114173.12.2025.01.16.12.43.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jan 2025 12:43:19 -0800 (PST)
Date: Thu, 16 Jan 2025 15:43:06 -0500
From: Alex Williamson <alex.williamson@redhat.com>
To: Yi Liu <yi.l.liu@intel.com>
Cc: kevin.tian@intel.com, jgg@nvidia.com, eric.auger@redhat.com,
 nicolinc@nvidia.com, kvm@vger.kernel.org, chao.p.peng@linux.intel.com,
 zhenzhong.duan@intel.com, willy@infradead.org, zhangfei.gao@linaro.org,
 vasant.hegde@amd.com
Subject: Re: [PATCH v6 3/5] vfio: VFIO_DEVICE_[AT|DE]TACH_IOMMUFD_PT support
 pasid
Message-ID: <20250116154306.57e6224e.alex.williamson@redhat.com>
In-Reply-To: <20241219133534.16422-4-yi.l.liu@intel.com>
References: <20241219133534.16422-1-yi.l.liu@intel.com>
	<20241219133534.16422-4-yi.l.liu@intel.com>
Organization: Red Hat
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 19 Dec 2024 05:35:32 -0800
Yi Liu <yi.l.liu@intel.com> wrote:

> This extends the VFIO_DEVICE_[AT|DE]TACH_IOMMUFD_PT ioctls to attach/detach
> a given pasid of a vfio device to/from an IOAS/HWPT.
> 
> Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> ---
>  drivers/vfio/device_cdev.c | 60 +++++++++++++++++++++++++++++++++-----
>  include/uapi/linux/vfio.h  | 29 +++++++++++-------
>  2 files changed, 71 insertions(+), 18 deletions(-)

Reviewed-by: Alex Williamson <alex.williamson@redhat.com>


