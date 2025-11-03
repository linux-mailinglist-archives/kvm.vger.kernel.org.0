Return-Path: <kvm+bounces-61793-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 71DE9C2A590
	for <lists+kvm@lfdr.de>; Mon, 03 Nov 2025 08:34:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 9A65F4E9721
	for <lists+kvm@lfdr.de>; Mon,  3 Nov 2025 07:32:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 67DB32BE658;
	Mon,  3 Nov 2025 07:32:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="zSookYoF"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB98C239E9E
	for <kvm@vger.kernel.org>; Mon,  3 Nov 2025 07:32:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762155125; cv=none; b=uDGgsPfvsDkOHZqZHRnlUYBAYlzwhyFn3QGvb9eoM+eJQQbGSj+ionDcKnRmT6dmNC1jaIZAZQ8jJWzo0QT6RCKA4cI6jPG9yhen9EB4SS2oHoOLbkn/qGISV+usCzR+wm2PmMDyLkEPgGvgAIe6s/iI8Iz67AAfaPDs62veaH4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762155125; c=relaxed/simple;
	bh=I7HDUIQg/KdqyDmPQ+qrxG240GLYIT2LqIXpnIqKcNE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Jnl5muDQhNqJjkQZjNg/ErNh1wdtQjVp77I5LUIZKw+QiXOTvCVse+tluUGg/Qq5hWwyyNKovRRiVuQE07DveSzPz0XdX2h4KN/K81PZfoKFIf3qaq1wkA3ONsi/kwSR70GbCuCkdwSVf74Cmr3CFnbPHUgQ2ZerJwLZ5BTqylw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=zSookYoF; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-295c64cb951so87975ad.0
        for <kvm@vger.kernel.org>; Sun, 02 Nov 2025 23:32:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762155122; x=1762759922; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=dADjXQcJVAcOBFwaI/JeQVroSWZH3kzmeM+gasunsjY=;
        b=zSookYoFfRjRsve0TquPbNlYHAKP8u8FjlXo1epzJ6/MiQOm3xl17tPdtSpUkKMd8d
         wwt2uP+wqJVBOc4WxSuC4VPnKPS+96pFg219qfLnd5GeGFo6HmHghY55eRmYR8Csw6AD
         G429iGUTkh0fMW1GPkmq9CDj00OZl2DSRdi0avBZqa75Y6Z7pe7bk6IIkFHNg2IlzxGg
         +YErQEbQZj4EIcQ2pji1k9FVSyZ10O0tDol1UhmvHbtx1KkbJRaPo7PILN3lL6lwqTUb
         JFqxwMAB7kcpqlAQLM0HEiTJ1FdYKnsxHXJseW+lSy5tLB2Z6Hu21xaHBP+YT+hSB2UC
         mhew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762155122; x=1762759922;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dADjXQcJVAcOBFwaI/JeQVroSWZH3kzmeM+gasunsjY=;
        b=jI+fQoqzFIwQEhCRWDBAP9kvsyzFHt2ThYnu+H39iSe1effdmMD7aSirMxPK8ai3m6
         2DoHY9LfnscxA5blZuiyhdGqtcefOsdwTnq59KY7uw/ETo4YBIj5m/HEzEZBfGZaOBje
         IsdC9zhUCpTdaaX4FHWVhTjIdifo1T5DuKsEtxouGdAbO0eLe9koa3RxwaJSId6+Y5lF
         G+DfDGuvQj8ybNNWTCWmVrBOR4TV/+HH+YZXCoiz5DQB0IRVCHBFJfcEroT4mzfhy9IW
         ZiDBigEVZCekP9woikn7+htqgGsUSTA/El+QTT7ZWqq1h/pcaSa/0HWAR8w2ItFoNqEb
         boJg==
X-Forwarded-Encrypted: i=1; AJvYcCVST3LxTDvJGzU4airv0X15zezMfuVBm3DbLVD+qfd0VFiW99EO3LX8mBQ3AyJuJIORlec=@vger.kernel.org
X-Gm-Message-State: AOJu0YyVuCVcxQeqI4j11jw2FrAGHYJJmM74I9wa/2REg3sX1stSdqZa
	qOab7pgIDhVU2Wcl2qfhzouIHA1kFxG0i7XgHyKJ6MjFr+IAvpx5R9SoQqe1Rs/jeg==
X-Gm-Gg: ASbGncsAPnrK3wkYtKUOtpEu2gm2dK0h/X0K3/P3kcKSgfWME2zANXspSbMl5+AT/MV
	23MTsoIZxwbuj5q2treY5IW0HN6pu/sQZ05xBxycIKAVJhhBX4S4jnYR7zEtQ6VWmqSpYC7EhBc
	PAAZ+ZUdmeiKmK7DtxRuPGfsaWF9bqZbC/g6AGeIqaCNiPzG1o8iyA8TXpG57FIAEgjx2BJAHit
	O6dUNncUr7B4mU73V++ZW04WOAhUfn/cat/6AmwXgRheR86EtE1UtAtqd3pFZo3Sz3gHwRSLrit
	zlvvGvFGvdc8be4Wcz+zXdcwIhFGoXG6ACQy9gSzQEd0t4n/rsQTk/0d+b7Q7UWTYo+0IwJFGlp
	lJXh3x0Eo3JsWEcoDRq1NAAT5qrLhjFKD99G5xhGzgbVB+xsCzG6IVvjGUSdV/SLga6wBnyg+gC
	i2XMMKq1JjIONsdGmlYPnyhPPSMEjG60ALm+htBg==
X-Google-Smtp-Source: AGHT+IHfrP3JzShs73f4Ou9j74BKdOau8otZ+u7WUYTtBZ6PInXsEFYOD9H0FiQHWOz2YtGspU3bog==
X-Received: by 2002:a17:902:ec8e:b0:274:1a09:9553 with SMTP id d9443c01a7336-29554bb5d5cmr6804875ad.6.1762155121865;
        Sun, 02 Nov 2025 23:32:01 -0800 (PST)
Received: from google.com (164.210.142.34.bc.googleusercontent.com. [34.142.210.164])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-295512dedabsm82398675ad.5.2025.11.02.23.31.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 02 Nov 2025 23:32:01 -0800 (PST)
Date: Mon, 3 Nov 2025 07:31:51 +0000
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
Subject: Re: [PATCH 11/22] vfio/cdx: Provide a get_region_info op
Message-ID: <aQhaZ2HvTTtanNdu@google.com>
References: <0-v1-679a6fa27d31+209-vfio_get_region_info_op_jgg@nvidia.com>
 <11-v1-679a6fa27d31+209-vfio_get_region_info_op_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <11-v1-679a6fa27d31+209-vfio_get_region_info_op_jgg@nvidia.com>

On Thu, Oct 23, 2025 at 08:09:25PM -0300, Jason Gunthorpe wrote:
> Change the signature of vfio_cdx_ioctl_get_region_info() and hook it to
> the op.
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/vfio/cdx/main.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 

Reviewed-by: Pranjal Shrivastava <praan@google.com>

Thanks,
Praan

