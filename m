Return-Path: <kvm+bounces-61780-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 78938C2A1E4
	for <lists+kvm@lfdr.de>; Mon, 03 Nov 2025 06:59:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 1E5D04EE35B
	for <lists+kvm@lfdr.de>; Mon,  3 Nov 2025 05:58:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 04A1C28D8DB;
	Mon,  3 Nov 2025 05:58:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="lSxpVBUC"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F3DA285CAE
	for <kvm@vger.kernel.org>; Mon,  3 Nov 2025 05:58:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762149488; cv=none; b=e6Ysj6OaOHMDP61jI4Rkco2GeIfbb+Yp0wjQIVLcOJ9kPzH7e16+YtuZqQ0FV4iDcU+YeKj8Qlw5b+g6oluVTUV/hUH/yz34AtQPxJIV0/WuabVWagwnj9qWKJ7I0m7oR0pBonXac0DR2HGUOYBoFBwYPdpgAEKN3EBp4f8Fkxc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762149488; c=relaxed/simple;
	bh=COnfabRE25CHEyik36bmtXTyjtL97X8u2YW/C0gU2+c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HxEmVRAQE3G49MgnkjGJJg7yUxhci0cBo3DtG7jzkEeWZ/Wh9wWV3Lbm8d90ARMOGP/OdcxNBbhe8+h1oh+CpLkwIT/RSu0t5X7Ljh3q1sJrZsb/UQ3dRp0x68Pg3CpUfR1GOaj7Xh6ZxN6/acjpk9FkiSmENkDbbeTynBRk1vs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=lSxpVBUC; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-294f3105435so328985ad.1
        for <kvm@vger.kernel.org>; Sun, 02 Nov 2025 21:58:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762149486; x=1762754286; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=jNN38kSQW+Z67K4qsM9EOBHtmYi+rj4bbcXqoaYoYec=;
        b=lSxpVBUCQ5psG5bCyY6pior0r5FZzvdbgyl0Dop2N15B5GXuZNirV1ebLJXJhhnJoJ
         4jHPJ1N/O0kCPWvqd2cxSmXQ6MGQMkfTGHtiwqk0C93ToyDndlPEfDozniE0xyzOgf6o
         z3f5eo9BlYvLzSHefq/vwAkkk0GPAVn7yErdOtxpK/olAMlYvA9w3kzwwyqUEiC374Tm
         SA5XXQk4v6niXORba3G+Fvyzg3kxGNp6Og+/L+bqsnj5+PGXvjmy5cSY7pE36Bhw8WAU
         0ayq54s2KNM4DdtOSWs6k/AYbGI9y1cy7yUombMl8bLpqCrXZypHZYYpyL5shMRCSBd7
         FlNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762149486; x=1762754286;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jNN38kSQW+Z67K4qsM9EOBHtmYi+rj4bbcXqoaYoYec=;
        b=rIeXGMz96SeKUUahKmlJkjFn5nVWp6vUSUzVw6kiyHwu1LtbPw82f4TTokMZa2HXuk
         mSHx+QbM4dtaXRE1DMs696w4LdmExRLKdbWdBEcIcL/EhtN1wZ6goos7elYuRpq+bA6B
         rNvV/NWjXl0HMTUk6ZmKibPJKuM1U54hscqEVdtSRsfVrgnuGe/z3pL5wOD+6kP2QDyq
         B52bfiLhqEPZhIW9GQ5oqiTl1o1sMJeZ7r6y/EZ7uX4wYEdT3DfDlQfno10Vyr23e8jq
         gUTo4Jm0jSK6rX/SgNtrf7lPYUPFj70I9kewmvUekMVXB6lCGjbGPFaSGoDgKV0QmxyR
         RHxQ==
X-Forwarded-Encrypted: i=1; AJvYcCW7uC3bg8J6nBHMyF74tGZ7+uOerQ233tnzZrCG7wSuV93BnAtzQTkLBcndiwZG8IfilsU=@vger.kernel.org
X-Gm-Message-State: AOJu0YwBhXJqoCvcROkV0/FyXmf+aJVc54zUA1zSndfWHdbjU/FgOSjR
	wQAmjFEbpFp/+dUH1rZCI4YEsENHg3RI0oaoR4UmN6xlfrg2dzGKLMP+3jM/B+sdIA==
X-Gm-Gg: ASbGncsRiLVRCO3PH742xF3PU1NbBifsY0tiLrY1dleClGj3ZUXXEWZQRmmc6JuCzzw
	I/Irw7O8VYGj4nlnW/OGO8+avxPx/KURKAzMSMKjEaohkSJ4JtsDuS45Vrd4JMz+97++2JnjHah
	rKEL63uSRumTqOOwPuxqelfUPn+alR0vSOQYMKzeUOXZtaxQHPPfQJ88n9otthGQrXfRiy0IBis
	po43W0NfqTyCRTOXmNezOvXL5Iiv+8SAdp0+0N7nmzEJcIfIINJispO3Z9da46YBgN+PO/jVpV+
	N9esx0nzGE4ngDnzrmuptNUeg416myDSFn7Zjc0xpP+SOwyFsZxYEJaZioJt2AlfsWFWXksoRzL
	V0kss9mRvIOaEmq1xTdEeJDGITcN3I2v1fGkLo4qJEq0fZLe1vWKutPp0SebKVodkgiMwCXFjMA
	7mvcDK2hubmfKVCfoQSbROzJ8g+DT7FIt8L3AijKkYqJOk3ro3
X-Google-Smtp-Source: AGHT+IHe2S0n2gwZ091UPBX6ERfL1n+n8BtlVw9vlL1yBRvzccFZt3lfIo5NNtd6hxmzG7hv2JOREg==
X-Received: by 2002:a17:902:f68e:b0:295:5138:10f2 with SMTP id d9443c01a7336-29556599a23mr4787225ad.11.1762149485582;
        Sun, 02 Nov 2025 21:58:05 -0800 (PST)
Received: from google.com (164.210.142.34.bc.googleusercontent.com. [34.142.210.164])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3407f26e0a6sm5783366a91.5.2025.11.02.21.57.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 02 Nov 2025 21:58:04 -0800 (PST)
Date: Mon, 3 Nov 2025 05:57:54 +0000
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
Subject: Re: [PATCH 01/22] vfio: Provide a get_region_info op
Message-ID: <aQhEYq9YVzbBlWnC@google.com>
References: <0-v1-679a6fa27d31+209-vfio_get_region_info_op_jgg@nvidia.com>
 <1-v1-679a6fa27d31+209-vfio_get_region_info_op_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1-v1-679a6fa27d31+209-vfio_get_region_info_op_jgg@nvidia.com>

On Thu, Oct 23, 2025 at 08:09:15PM -0300, Jason Gunthorpe wrote:
> Instead of hooking the general ioctl op, have the core code directly
> decode VFIO_DEVICE_GET_REGION_INFO and call an op just for it.
> 
> This is intended to allow mechanical changes to the drivers to pull their
> VFIO_DEVICE_GET_REGION_INFO int oa function. Later patches will improve
> the function signature to consolidate more code.
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/vfio/pci/vfio_pci_core.c | 9 ++++++---
>  drivers/vfio/vfio_main.c         | 7 +++++++
>  include/linux/vfio.h             | 2 ++
>  include/linux/vfio_pci_core.h    | 2 ++
>  4 files changed, 17 insertions(+), 3 deletions(-)
> 

Reviewed-by: Pranjal Shrivastava <praan@google.com>

Thanks,
Praan

