Return-Path: <kvm+bounces-61808-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1500BC2AFDC
	for <lists+kvm@lfdr.de>; Mon, 03 Nov 2025 11:19:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 61F8A3B589A
	for <lists+kvm@lfdr.de>; Mon,  3 Nov 2025 10:17:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4701C2FD665;
	Mon,  3 Nov 2025 10:17:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="aLnG6tPA"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50DDE2FD1C2
	for <kvm@vger.kernel.org>; Mon,  3 Nov 2025 10:17:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762165031; cv=none; b=Si3UGqCjHEmGdns0wRYxOKJqHz4VS16IY0rvy3xGXbN7D103ueRmmpjWzAVgqqs+UlOLqqJ57dgOz6yFu06BUmn+Dloquvb/sdoe+9kJl7XLUSj2YFuldJBlIi2Knjydp/6EHiFf7FflGuLm7TRwVowCy9uDBOqkZvw+f56B5h0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762165031; c=relaxed/simple;
	bh=FFZiNUWIFKtxHxItZumM7duOWwpaz/Ziw593xKPC374=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=djRvGGaay3/D4+19ipte/aOtOmU4NClmEqVyyrlnCYIt7VK6vCvZaa1VvwkMchhg1xaDQEGVWO2coI3IASq4MV/sxY9cvz+uafyjIfnqk+3Z+7guJf3Vp36Ib1EkdT0mp7gbADzrOjLzDNJy91gyKWoJCJyrDgO1bV3Hg4S4chc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=aLnG6tPA; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-27d67abd215so417805ad.0
        for <kvm@vger.kernel.org>; Mon, 03 Nov 2025 02:17:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762165027; x=1762769827; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=+B58KtJn/bs233pgZmMdorp656WS5EnyOqIx/RHoAag=;
        b=aLnG6tPA2Lz8JDQ2FACTcqMz+WdTuZgG+U7ki9e1FgPajzlTfXpzy8ku0upyXh3Wz7
         k33jhLkl9tziC5r6T/veZTaKShmn455/bLDckA99pHLfQ736dqIjKrYjGlPnos7+GaI1
         LqPgXhntry+FhO0z28o5nPcGHSp8wE5HmAMMfMfWK+1flaOErwz8yjuih+zf10noPGr2
         HMoC23pppsa+tkq1IxYPjqfrp56N0h4YOqNdQgDPaq51vtfpaKu8YHQpUj3Mm3piXqxJ
         JSD5AHzN6qQJ8NyBAmSD56wR/oSfCvsOJh3cwC/HZgZyQl2vPsUHwGg7+zY1jN8L1DQh
         UrZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762165027; x=1762769827;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+B58KtJn/bs233pgZmMdorp656WS5EnyOqIx/RHoAag=;
        b=oRY3/39MPsBFA0RFtQ9TPyzlF/4Gerb3MqHnNe2aCk92ipKgGl7QSA+9b0lZ7xWB9m
         VbYPRLvlq0veMCYY3g4oauyaE8pW2LF2AFZx7X0/jwnMs1LXCjCjvd0WOmpZEV3uNRpH
         MNc9xQNM9b+WUNr5i5FdGQV9qRjJRMUL7bQvLN+KyYo+IisJa/Qmw38GLgfeTWF95egk
         AZztCJ8h6SDSRrszKqqGaFkeWj4h05CM2ZmQjKwogkqRxSQnn3DxydVvpPxQX3ZgHWK3
         nYVrms8nUh01f4Nlz8Ysn+gWO5Fre2J68SwFLRwwf+lz4LXKGDsmj2RANzL8wxRbJ0wg
         D+Uw==
X-Forwarded-Encrypted: i=1; AJvYcCUZ7YTpQbarYGeHVADWvdjoqA5SPgQou+nCQ/lruxt0CwyYWXZuu+1i/yE97s1i9lEvrUA=@vger.kernel.org
X-Gm-Message-State: AOJu0YwRKpOzRkuAxTrIEoJiiQKvXTA04k8pFSrs59iLwjB4zKzCwgZa
	yb7Y0QmqIMbqLaYzHsSxPSyWcBsrcVkJNVSEPFbYU4OyzfN56+hQBrMB86urURhdgA==
X-Gm-Gg: ASbGnct6zWE58KoCGC3H8OlI7Pu0+UZOpfgrI30+1HFwxQpVpmjIv23cH8x2f674hCo
	Bhh5GWx/YWbGXhtkT0S8lPuOLn/KhNHLsks4rIDIFA7NbV/JkCYce5C77Q/Hg54cUvl9Y7q/JT0
	5nHxwb923Dv9iaM7bM8xRQyDD4wYVgL5Nj8L2VRugTjZy+wBQ/3rLBGxz2PkYa1Hf5jOlj6CrGR
	piym8WUw5UsMmRq+r3koct+dvGRKg9NjvbEl6uGQoPOouvmR91TJCpa91zFqkCrJTTQWP0633lM
	VnBhtBalIz2zyw13sEcjsEM34afsP4mqkscX+l2VmtuaqYFLyv4I0N+GIuxnTW066lSKpKuz4Ny
	DChcSWoFxKZIWnX85Ir69+GgxFdoDfyqcwY38dZHL28e/ltKVxaGZiCkdBgSVQotpjrY/sZmHBw
	5AE2AS2bSSexCF60pibM9AbE7vYaknLgvx6FzrUg==
X-Google-Smtp-Source: AGHT+IHxzXLAyCFx7IPmcOnpFb2vp8Rgf1l3Kna0V2OUhXGSl0YxnYi8nj1MD1lWW9qX+m9LVNsxvQ==
X-Received: by 2002:a17:902:e88c:b0:290:d4dd:b042 with SMTP id d9443c01a7336-29554bc5206mr7508255ad.16.1762165026873;
        Mon, 03 Nov 2025 02:17:06 -0800 (PST)
Received: from google.com (164.210.142.34.bc.googleusercontent.com. [34.142.210.164])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7aa4f4c28easm4658013b3a.31.2025.11.03.02.16.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Nov 2025 02:17:06 -0800 (PST)
Date: Mon, 3 Nov 2025 10:16:56 +0000
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
Subject: Re: [PATCH 15/22] vfio: Add get_region_info_caps op
Message-ID: <aQiBGEgQ3vCpCvXM@google.com>
References: <0-v1-679a6fa27d31+209-vfio_get_region_info_op_jgg@nvidia.com>
 <15-v1-679a6fa27d31+209-vfio_get_region_info_op_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <15-v1-679a6fa27d31+209-vfio_get_region_info_op_jgg@nvidia.com>

On Thu, Oct 23, 2025 at 08:09:29PM -0300, Jason Gunthorpe wrote:
> This op does the copy to/from user for the info and can return back
> a cap chain through a vfio_info_cap * result.
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/vfio/vfio_main.c | 54 +++++++++++++++++++++++++++++++++++++---
>  include/linux/vfio.h     |  4 +++
>  2 files changed, 54 insertions(+), 4 deletions(-)

The newly added vfio_get_region_info seems to pull-in common boilerplate
code (like copy_from_user, arg size validation) into the core code,
removing redundancy across all other vfio drivers. LGTM.

Reviewed-by: Pranjal Shrivastava <praan@google.com>

Thanks,
Praan

