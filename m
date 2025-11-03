Return-Path: <kvm+bounces-61790-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 501CBC2A468
	for <lists+kvm@lfdr.de>; Mon, 03 Nov 2025 08:19:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EF2C13AEC31
	for <lists+kvm@lfdr.de>; Mon,  3 Nov 2025 07:18:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D3A6529ACC5;
	Mon,  3 Nov 2025 07:18:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="n5X2Smts"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC8BE2505A5
	for <kvm@vger.kernel.org>; Mon,  3 Nov 2025 07:18:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762154323; cv=none; b=YOwVZy3c2I3M+e4IV8kNv5RY56Ue5ZLULh4sxGsg2CuuG7wnpFXUmhPUePC0sOK2XaTB+aJA7coSpIjme90Ymtm0+lq3kxdsR/wwqhKkxBtRV/Kty2JUWSQhSKf0vN8HvO/TP+UW1L5uL8qN041adgv9sNY0AoV0zr0RrvxMO+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762154323; c=relaxed/simple;
	bh=Vm2BtOrr7/4guLkxjFZFHOZoayeqUbBXepUyeDwPM+g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DnopVCX2NwcfBlCWTM1NmfFc+J2SrCr9Yy1smDehwDQhqEKk8UOpOZSjlkEJ9KRGTaJDBz01pPBySpNUS1dNTCEwPFk4bgfrjAoXQSoD8dT6Gosdc03DSb14cH1J6bkI2ZvPTR6E7qJtIAL5whLXbrM2IjSxFp0ZQ9QaY13XlwY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=n5X2Smts; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-294f3105435so339105ad.1
        for <kvm@vger.kernel.org>; Sun, 02 Nov 2025 23:18:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762154321; x=1762759121; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Y22k5ngiq32o4MbKE/s0CLErP3q9IoFtmfwfCLBHatI=;
        b=n5X2SmtsT3C92S5w2AKKmQZO5DiAjkuCdpMd+Nh87ZsPG1CWUNv6sefJMAKMocelmE
         BztECs30WePiaiHvJqjxMx70QVB4M/C35E7KC6JNx+R0CcPhuOZlT40EAKk0I4qMBYqV
         3uea5zUH03lKRSnjWsAxHGF0UjW+MshMeMeQnJdEFTukjmhwZ7Rw3UuGlIsvx09Um7Ot
         VpxhlZWp4nMxPBVr4ie97UnuI/wgomP0P/bgDJGQws6wggZYDd3Iu3iCstm2EyxEQoxu
         rA/ECikzzGxZkz1NvA/xUWsB3bGwdXPzNCJw5Gcp9Dab1V3HbSFwV/ZMQcYuaTLyil99
         DXhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762154321; x=1762759121;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Y22k5ngiq32o4MbKE/s0CLErP3q9IoFtmfwfCLBHatI=;
        b=mNJMD/HgOySwO7l7DQ8D2m8csLgyavLNoD06CnJJ/5lvMeULbxMMq/8RmBpouT86pd
         11jUKiaP4xCU+GY7pm7yfOlDjzmU4Fr1AHRqTIMu96crhoxl5RtLSajqNkLyPdQn5dIj
         k+Ef7Ly5XksPA84jU3odjSajm6hBJ7mYH4CO9n7hIF+fdQ388qnBgc/SuVNEPgA7chCh
         Pbi1MSTIIMZV311G+nLzHbySr80DFQD/wIwgZCPE09CSIirF1KM90PH6xxX/NHXs9MIw
         bs/m15Mz1OOHYtplvBdEfZpZb0Yt3O77cjNznzk/EaOmEydx3JTHVRYSpjx4JDXYZpPy
         mK9g==
X-Forwarded-Encrypted: i=1; AJvYcCWvqtnnyp/FNhQBf+UiSAFINvZwS3qP/e6lsJ0V9UzeM8UpeRUp1QHF31g6bVBKVUHnWxA=@vger.kernel.org
X-Gm-Message-State: AOJu0YyzhV0O54oRn/7qgNkp2grErYPkgqyUIIovFoKI/v3FBZtibZ1P
	KZca50NFCrlj52ZvhKOFqB19EZ23akAmsUs22r73/C+BBIspKtvcyYRZu6Vznafj+g==
X-Gm-Gg: ASbGnctyijEtTH5JIkScqhwUdPrADc0BqsEUqxYY3jrEY8qTHjIzdO7te0PZfQ+mSDb
	opUUrswTH6GRgU4OHnoi+iq1mLqDkJotnhMDbo+zM7hmkFK0ep5BhroYDIw2y4Q0XgZ+L0FAYtE
	5MGbmBlvV0lUJaug8+eGnySNVS/5ywpXO2XMQt73ra95ut2nG1XiprL33mTGy/sNtw9T2uqF3iK
	Lk373ddgfPpaOO+mpv9j64mKhaiWeTNKYvEcQbxNSm1uV94nd1/lWWrxOmaj1g98TfNxYvHngyp
	MJxCuPgkD9gd3Y3IU8mA9xRQhQdbzcWR3vjGLBF0Zrdo7DULj+3F7pcdFrnkgcmQURBkeTNS34f
	qQDgkSIpSCVB4dDv0bPRCIA4KKmlKqmjJ2FI0VyFdhED7kLTek8qBnQ2RSTmzRCBAgr+YxU7uRq
	jDJGwP5iNzOlK9vAsztw7oBCglxSGug5foKBy4Og==
X-Google-Smtp-Source: AGHT+IHz7vQ0cm4SGWCD8qu7hNB41Aed4i8aC1NkscOeFOjchnLwW8gMwvqn5xaYYumt7DzVtDnmgQ==
X-Received: by 2002:a17:902:d2d0:b0:295:30bc:458e with SMTP id d9443c01a7336-29556477728mr5855785ad.3.1762154320729;
        Sun, 02 Nov 2025 23:18:40 -0800 (PST)
Received: from google.com (164.210.142.34.bc.googleusercontent.com. [34.142.210.164])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7a7db197340sm10108242b3a.44.2025.11.02.23.18.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 02 Nov 2025 23:18:40 -0800 (PST)
Date: Mon, 3 Nov 2025 07:18:31 +0000
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
Subject: Re: [PATCH 07/22] vfio/mdpy: Provide a get_region_info op
Message-ID: <aQhXR2M6riHmufl7@google.com>
References: <0-v1-679a6fa27d31+209-vfio_get_region_info_op_jgg@nvidia.com>
 <7-v1-679a6fa27d31+209-vfio_get_region_info_op_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7-v1-679a6fa27d31+209-vfio_get_region_info_op_jgg@nvidia.com>

On Thu, Oct 23, 2025 at 08:09:21PM -0300, Jason Gunthorpe wrote:
> Move it out of mdpy_ioctl() and re-indent it.
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  samples/vfio-mdev/mdpy.c | 53 ++++++++++++++++++++++------------------
>  1 file changed, 29 insertions(+), 24 deletions(-)
> 

Acked-by: Pranjal Shrivastava <praan@google.com>

- Praan


