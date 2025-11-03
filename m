Return-Path: <kvm+bounces-61818-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0BF7DC2B3B9
	for <lists+kvm@lfdr.de>; Mon, 03 Nov 2025 12:04:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7F8FE3AD622
	for <lists+kvm@lfdr.de>; Mon,  3 Nov 2025 11:03:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 31F57301461;
	Mon,  3 Nov 2025 11:03:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="bRVmQ2zX"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D20EE2FF64C
	for <kvm@vger.kernel.org>; Mon,  3 Nov 2025 11:03:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762167830; cv=none; b=jefxu1XfpHcYbCKfjSwVkpcuyQz5fR5ZlE4Puf6JBwkYeTTECg9N3C8QAXjh60xbp87tvaxLYYJWBxc4WJBoKw+tA5W36XxC40nSXvxFY7Sh7F77syr0eVD5J1oPw3J6nbvtO6L6zRJ5C33wCnHq5HbyQxh8TFZZ2wjczL+/hQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762167830; c=relaxed/simple;
	bh=oQx/ydTW/nop4AcGUNLqHSf/CC+CTlJRuLVJVH3L6VA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FCBzmThAMi0NMlGK5zNqQf7z+otNCYZuaCXxApTq7pqm0xaevO6T9nfheYp/NguEn5MKrPeidRUIq/PlXAiW43p0Om/N85K9DkJwvucGZt4j/w6kBWMPRWXXDSSx25h+KTsnpMq9101XWLgN8ABTKT5RzlPscg5fek0u0yPLDlM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=bRVmQ2zX; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-295c64cb951so131645ad.0
        for <kvm@vger.kernel.org>; Mon, 03 Nov 2025 03:03:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762167827; x=1762772627; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=JG+etGO4DCF1PIFwJUo34O2NHRXv7sGubVRA4h3tffk=;
        b=bRVmQ2zXPdGFc+lD7QW8lkWRxOkiU3FbeBUvS9oL1tI4C6PpIMP6iO0sTiNBy6vgH3
         mrz/o1uZWUar997JrzXtMJufZBEjurpKwWYEeyk7fED4GkF2gflB15JTNca0tDHQSaMl
         nsPL+F0lSqvFlQio+t4exBEdq4AnmyCUDR5Rd5t5xHZ4EYBBdDrF0LraUU9eRoaUs6pQ
         IKyp/cpp2DPTgWVvxu+5TE17m0Umr0O/AMdG1l+aorm1/xwSngPlnxxw+UChmbs+LQ62
         Eamf4j4reFmOaF0VKqqnqfnbbgnoAJgTzOLMC6fuZyGecxOB8o4BZXQN8zVHUxqvMfra
         nftg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762167827; x=1762772627;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JG+etGO4DCF1PIFwJUo34O2NHRXv7sGubVRA4h3tffk=;
        b=UhRVou9xN3oQb/sjECS4KewxplvtANOBqMzjkf0C7/6EcQxFTja0424/G0UuyAmjeE
         7rOGpJMx3WzqSNq6TeLgwTD8z4pVOP39anymosk6JgbR70usLhjeFuqB3Gpt0WhEkW9+
         T/ttwepFuD3OOfdc/HNCoqxzp6mcxpOzPwe3TdKRf86+q2UR9smrS7yclUHEF5ij4h9L
         IbH9EZrLS9ymRHMotK97RDoFauVDX0SOWL1aNREaKpqA1ii4d9jWjgUdSHW0JJc1u9my
         izoROl1MP9atfRjRYp6zUE7T1js7dYdm8G2773zQ9XOArVih+ezIaFiobCkTwjjf6S5P
         UCuQ==
X-Forwarded-Encrypted: i=1; AJvYcCXKtxMJ3MjwxVKB4PJ7wzClp0uQF50NJtYsNa91Sajj8v1e8Zdz8v5BpTpDP5TyTgX0a2Y=@vger.kernel.org
X-Gm-Message-State: AOJu0YyHilhCWMVuGYG7rGHtLmOtDu2+xf3LPPFnsc/5W7n6VnNs+eYR
	05mMBn9KVTZOiiNKEpq/rLAXW/isxLN9CfQis9lFANWGPssAXFV3omDOuAVVTN0yCQ==
X-Gm-Gg: ASbGncujiVE7Fek9Z3G1ZDsirqcqOEJw6bymd8aJjrG/ecElNCa7JHQZm1Wok7TidgC
	HFf9dOwx3wqfE4r/EAaBXJqScF4AmiB6m2/eMFTJfoMhlgrR+qQUf9jy1V8rDQFBJVWnHM3pREu
	DJEFWmWha0iPpVYcSZ8x9eDyfPY30FMOkkm81OjB3OfG+LMdLIKig3JQ4mowQwsdUhcSZco9MAN
	ejLuEfwLT6v/uva8ruS/REcwdHueHdoJdd9owr6nt56hetxYXhGOkq5uZUPreYaH3ymH9KI67eQ
	DN0S9sKhJuhtpt3zTyfjqxW6pSxTpXF79Q/q8ocioXEv4tf5jNRZ9C4GJxan/mkxf0JjDh+PTi1
	Os9mMWBtaaQX2UVwDF1ZWyD33r4zMmROKpwYxxo6nqY+YpZXhP/ZP8FftWgtoDdVNjioUIvk3Na
	oiHB4UGTiBh84S7+7fiXwpA6vQmnvjg9w6htoVAw==
X-Google-Smtp-Source: AGHT+IGcDUbk6qqLdQjGL3Yxey3X8mTSWxpSXkjqaoDl6gxo10SeAyfD2HQnpWNy1nfGBwMDtJcUBw==
X-Received: by 2002:a17:903:228c:b0:271:9873:80d9 with SMTP id d9443c01a7336-29556476bd0mr5742325ad.7.1762167826744;
        Mon, 03 Nov 2025 03:03:46 -0800 (PST)
Received: from google.com (164.210.142.34.bc.googleusercontent.com. [34.142.210.164])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29537cccdecsm102934645ad.19.2025.11.03.03.03.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Nov 2025 03:03:46 -0800 (PST)
Date: Mon, 3 Nov 2025 11:03:36 +0000
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
Message-ID: <aQiMCKszFCvDDHhH@google.com>
References: <0-v1-679a6fa27d31+209-vfio_get_region_info_op_jgg@nvidia.com>
 <15-v1-679a6fa27d31+209-vfio_get_region_info_op_jgg@nvidia.com>
 <aQiBGEgQ3vCpCvXM@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aQiBGEgQ3vCpCvXM@google.com>

On Mon, Nov 03, 2025 at 10:16:56AM +0000, Pranjal Shrivastava wrote:
> On Thu, Oct 23, 2025 at 08:09:29PM -0300, Jason Gunthorpe wrote:
> > This op does the copy to/from user for the info and can return back
> > a cap chain through a vfio_info_cap * result.
> > 
> > Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> > ---
> >  drivers/vfio/vfio_main.c | 54 +++++++++++++++++++++++++++++++++++++---
> >  include/linux/vfio.h     |  4 +++
> >  2 files changed, 54 insertions(+), 4 deletions(-)
> 
> The newly added vfio_get_region_info seems to pull-in common boilerplate
> code (like copy_from_user, arg size validation) into the core code,
> removing redundancy across all other vfio drivers. LGTM.

I missed one thing in this patch (luckily caught it in patch 22):

> diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
> index f056e82ba35075..82e7d79b1f9fe2 100644
> --- a/drivers/vfio/vfio_main.c
> +++ b/drivers/vfio/vfio_main.c
> @@ -1259,6 +1259,55 @@ static int vfio_ioctl_device_feature(struct vfio_device *device,
>  	}
>  }
>  
> +static long vfio_get_region_info(struct vfio_device *device,
> +				 struct vfio_region_info __user *arg)
> +{
> +	unsigned long minsz = offsetofend(struct vfio_region_info, offset);
> +	struct vfio_region_info info = {};
> +	int ret;
> +
> +	if (copy_from_user(&info, arg, minsz))
> +		return -EFAULT;
> +	if (info.argsz < minsz)
> +		return -EINVAL;
> +
> +	if (device->ops->get_region_info_caps) {
> +		struct vfio_info_cap caps = { .buf = NULL, .size = 0 };
> +
> +		ret = device->ops->get_region_info_caps(device, &info, &caps);
> +		if (ret)
> +			return ret;

device->ops->get_region_info_caps (via vfio_info_add_capability) can
allocate caps.buf and then return an error for a different reason. The
if (ret) check returns early and the kfree(caps.buf) on the success path
is never reached.

Should we add kfree(caps.buf) to the error path here?
This keeps the allocation and cleanup logic centralized in the core code

Let's either write comment saying that the get_region_info_caps op is required
to free caps.buf before returning error OR add a kfree(caps.buf) here.

> +
> +		if (caps.size) {
> +			info.flags |= VFIO_REGION_INFO_FLAG_CAPS;
> +			if (info.argsz < sizeof(info) + caps.size) {
> +				info.argsz = sizeof(info) + caps.size;
> +				info.cap_offset = 0;
> +			} else {
> +				vfio_info_cap_shift(&caps, sizeof(info));
> +				if (copy_to_user(arg + 1, caps.buf,
> +						 caps.size)) {
> +					kfree(caps.buf);
> +					return -EFAULT;
> +				}
> +				info.cap_offset = sizeof(info);
> +			}
> +			kfree(caps.buf);
> +		}
> +
> +		if (copy_to_user(arg, &info, minsz))
> +			return -EFAULT;
> +	} else if (device->ops->get_region_info) {
> +		ret = device->ops->get_region_info(device, arg);
> +		if (ret)
> +			return ret;

With the above comment addressed,

Reviewed-by: Pranjal Shrivastava <praan@google.com>

Thanks,
Praan

