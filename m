Return-Path: <kvm+bounces-67298-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id D233ED005A5
	for <lists+kvm@lfdr.de>; Wed, 07 Jan 2026 23:52:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 7A149304F648
	for <lists+kvm@lfdr.de>; Wed,  7 Jan 2026 22:49:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 560392773EE;
	Wed,  7 Jan 2026 22:49:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="nRMWCIOl"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f196.google.com (mail-pl1-f196.google.com [209.85.214.196])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 589601DBB3A
	for <kvm@vger.kernel.org>; Wed,  7 Jan 2026 22:49:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.196
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767826161; cv=none; b=PLVePIGVRVdcXHLhAVbfkbZCAuFKuVY5A0e1awSOnJYIo+OPiuQl5V6BXtHld0EKjL8fk0M/LklQ6BcX2tCcI84n5t2MwBFgC4gmW+IB3w3axneLviKxrUhl/tOwhGgoPd3SWJxdn7stsXcAsN6Gp0pfkek4HwOi0U0465Y0TQI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767826161; c=relaxed/simple;
	bh=2kKpvI6ZFSKHORTpkWXd4AljDkhpjfHIoY5AyWZsWqM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MYol09s79WZDugtWk93qua/sASYB/bkT5LRitB5ZgPV+P7dl12bIwPf/1y0qPiv1e9aYXpPSGUMtD90rPqQUO8rx0+a+xXuZyCc9xYZ+6BC6xlPr9gnVCo17AHNhYyHpU310l/Td0RIceiTCsHxHjpznYGakLexJmiRllK9R1VE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=nRMWCIOl; arc=none smtp.client-ip=209.85.214.196
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f196.google.com with SMTP id d9443c01a7336-29f1bc40b35so31145165ad.2
        for <kvm@vger.kernel.org>; Wed, 07 Jan 2026 14:49:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767826157; x=1768430957; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=JnVLVYG1IRfpUlm6+VrOi9vquCcu14DZdquCNFExRV0=;
        b=nRMWCIOlHo7+haceAc4yTeQJi7GbnNRqhPNa6l+vRrsaQpuMtUbkvZ0KryMRcEev2Z
         g8Uhy5rUB8kdIgZ7m68O8tbSQCGwx2pp2seozI6FTgZfhoH1nKSqgiW+Bb8VjRh1INtp
         gElTT3pXbIHxPdGhI/DNjPYQT2uBsy04vKnss9ljQaFoq3Pa9nMGVXDQmnqU2DFbWoM+
         i2YVu6G5Fu6i6DJP26mPsux4UkBn5KWf2CPf//1Pa6kcsHXzSKkEzemrmbw7CJQo+fsW
         EILjDIlH3NEPVVwtFnqA3h1xiCovndF5mGwAlgiD5FLTAJKzZiY+MXKwNhIo1jHjGste
         lxEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767826157; x=1768430957;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JnVLVYG1IRfpUlm6+VrOi9vquCcu14DZdquCNFExRV0=;
        b=sbOqlYRxwrXZ2Yx8ZstgfRfTEPzQhiMWY2DHrYPwOK6jAjdDs420jlC+qKuyudFDnL
         0jmuMT5l8phY3ptTMjFzJxAJAenDTI1CxUrcHB4K54LIUtEFXp0ZzIb0aol0R87CzHbT
         LJA4S8RcmcH343biBgpmSttrp6diloE5rgwfDCgpaEKS7vN0eYZ/Cpcr/fbGj6fdZf3a
         d3K4dpnr97b/z90zUAk/FJkCdxJ6q8VixWzsJhEcmgoHSwPsEn5asD9h3Zcc8JfMGlLi
         DaTCA3QkZcSxkt5kfDHYr9G8F2HhOFm538HqipmIwgBTCgXlry9MoMEw3N2+lb4AkRaU
         0vPQ==
X-Forwarded-Encrypted: i=1; AJvYcCVGajDD0DaicKCChVFn4xFXJ/jrq3U5M5nlTtttmxKQIf8CSzCnxMFwyL7DhQYn6lQNB48=@vger.kernel.org
X-Gm-Message-State: AOJu0YzcOc42vR6lalxBVEDd5ojMqaB3eNwAiXbdCq4rElqhpzMWbWwL
	qHUpoYVRgCjfj23Sd8QNF93IIx8Fkudo55quNB7bffWSEYGYYSAN8XPnnePG0wGgSA==
X-Gm-Gg: AY/fxX6YXGN+37lh/hAfA+ETeaidMFnyx0OX84b26pJVizg8qTRylCXHuwzDVZtZJy8
	jqFQ5qAe4wu8wsv4QvTQyTPZ2gOiY35ooNQVRulf5IUc1AiSvtgtva/rEqLsH6CwtrLxsMebG4B
	OfH7o43eBY45SXBpiq2fE0GL99QiZNQ/QFOwpLX449KJ2U8oRM0XImpOZRT0ltUdZnetTpsSWJ8
	0B/VDMiphs0D54QWpQrv0w9Wrg2XxGZrLDqeIXqNTHOvJVY7BPNxbAY6zpxJpUwyQMgEaA8ZOw9
	t6yMgfVxCUbXuQgHKevXM0Ml0Y7Gyy8KZWRTLpM1GB3Po/yY2Q+aDXHIJVYI0FiIbzaJBRvfysc
	8/QP84etE+kVSIS+P2b8ZIzTy/T/bkkz2XSx2+yZLNKZSnIpZ2lujYq75Yz30MGXm9wu6gz//zk
	fk5Kw5L7bGHLJqwNuTMvjUT3ZaHK1G39sZMQ1mnpLZN2Jx
X-Google-Smtp-Source: AGHT+IERoVyKgTh/iF+e5eqgPhiHGb2vF1b2fNZbwYe3hAIlTypkzbgNZaLRgU/AO3Bjg8Kp9EBkxQ==
X-Received: by 2002:a17:902:f70e:b0:2a0:a0cc:9997 with SMTP id d9443c01a7336-2a3ee4b4c12mr36133335ad.50.1767826157041;
        Wed, 07 Jan 2026 14:49:17 -0800 (PST)
Received: from google.com (76.9.127.34.bc.googleusercontent.com. [34.127.9.76])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a3e3c3a560sm58824415ad.21.2026.01.07.14.49.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jan 2026 14:49:16 -0800 (PST)
Date: Wed, 7 Jan 2026 22:49:12 +0000
From: David Matlack <dmatlack@google.com>
To: Raghavendra Rao Ananta <rananta@google.com>
Cc: Alex Williamson <alex@shazbot.org>,
	Alex Williamson <alex.williamson@redhat.com>,
	Josh Hilke <jrhilke@google.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 3/6] vfio: selftests: Extend container/iommufd setup
 for passing vf_token
Message-ID: <aV7i6P3FqPZu1Tq0@google.com>
References: <20251210181417.3677674-1-rananta@google.com>
 <20251210181417.3677674-4-rananta@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251210181417.3677674-4-rananta@google.com>

On 2025-12-10 06:14 PM, Raghavendra Rao Ananta wrote:
> A UUID is normally set as a vf_token to correspond the VFs with the
> PFs, if they are both bound by the vfio-pci driver. This is true for
> iommufd-based approach and container-based approach. The token can be
> set either during device creation (VFIO_GROUP_GET_DEVICE_FD) in
> container-based approach or during iommu bind (VFIO_DEVICE_BIND_IOMMUFD)
> in the iommu-fd case. Hence extend the functions,
         iommufd

> vfio_pci_iommufd_setup() and vfio_pci_container_setup(), to accept
> vf_token as an (optional) argument and handle the necessary setup.
> 
> No functional changes are expected.
> 
> Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> ---
>  tools/testing/selftests/vfio/lib/libvfio.mk   |  4 +-
>  .../selftests/vfio/lib/vfio_pci_device.c      | 45 +++++++++++++++----
>  2 files changed, 40 insertions(+), 9 deletions(-)
> 
> diff --git a/tools/testing/selftests/vfio/lib/libvfio.mk b/tools/testing/selftests/vfio/lib/libvfio.mk
> index b7857319c3f1f..459b14c6885a8 100644
> --- a/tools/testing/selftests/vfio/lib/libvfio.mk
> +++ b/tools/testing/selftests/vfio/lib/libvfio.mk
> @@ -15,6 +15,8 @@ LIBVFIO_C += drivers/ioat/ioat.c
>  LIBVFIO_C += drivers/dsa/dsa.c
>  endif
>  
> +LDLIBS += -luuid
> +
>  LIBVFIO_OUTPUT := $(OUTPUT)/libvfio
>  
>  LIBVFIO_O := $(patsubst %.c, $(LIBVFIO_OUTPUT)/%.o, $(LIBVFIO_C))
> @@ -25,6 +27,6 @@ $(shell mkdir -p $(LIBVFIO_O_DIRS))
>  CFLAGS += -I$(LIBVFIO_SRCDIR)/include
>  
>  $(LIBVFIO_O): $(LIBVFIO_OUTPUT)/%.o : $(LIBVFIO_SRCDIR)/%.c
> -	$(CC) $(CFLAGS) $(CPPFLAGS) $(TARGET_ARCH) -c $< -o $@
> +	$(CC) $(CFLAGS) $(CPPFLAGS) $(TARGET_ARCH) -c $< $(LDLIBS) -o $@

Do we need $(LDLIBS) when compiling the intermediate .o files? I thought
we would only need it when linking the selftests binaries.

>  
>  EXTRA_CLEAN += $(LIBVFIO_OUTPUT)
> diff --git a/tools/testing/selftests/vfio/lib/vfio_pci_device.c b/tools/testing/selftests/vfio/lib/vfio_pci_device.c
> index 9b2a123cee5fc..ac9a5244ddc46 100644
> --- a/tools/testing/selftests/vfio/lib/vfio_pci_device.c
> +++ b/tools/testing/selftests/vfio/lib/vfio_pci_device.c
> @@ -12,6 +12,7 @@
>  #include <sys/mman.h>
>  
>  #include <uapi/linux/types.h>
> +#include <uuid/uuid.h>
>  #include <linux/iommufd.h>
>  #include <linux/limits.h>
>  #include <linux/mman.h>
> @@ -199,7 +200,27 @@ static void vfio_pci_group_setup(struct vfio_pci_device *device, const char *bdf
>  	ioctl_assert(device->group_fd, VFIO_GROUP_SET_CONTAINER, &device->iommu->container_fd);
>  }
>  
> -static void vfio_pci_container_setup(struct vfio_pci_device *device, const char *bdf)
> +static void vfio_pci_group_get_device_fd(struct vfio_pci_device *device,
> +					 const char *bdf, const char *vf_token)
> +{
> +	char arg[64] = {0};

unnecessary intitialization

> +
> +	/*
> +	 * If a vf_token exists, argument to VFIO_GROUP_GET_DEVICE_FD
> +	 * will be in the form of the following example:
> +	 * "0000:04:10.0 vf_token=bd8d9d2b-5a5f-4f5a-a211-f591514ba1f3"
> +	 */
> +	if (vf_token)
> +		snprintf(arg, ARRAY_SIZE(arg), "%s vf_token=%s", bdf, vf_token);

snprintf_assert() :)

> +	else
> +		snprintf(arg, ARRAY_SIZE(arg), "%s", bdf);
> +
> +	device->fd = ioctl(device->group_fd, VFIO_GROUP_GET_DEVICE_FD, arg);
> +	VFIO_ASSERT_GE(device->fd, 0);
> +}
> +
> +static void vfio_pci_container_setup(struct vfio_pci_device *device,
> +				     const char *bdf, const char *vf_token)
>  {
>  	struct iommu *iommu = device->iommu;
>  	unsigned long iommu_type = iommu->mode->iommu_type;
> @@ -217,8 +238,7 @@ static void vfio_pci_container_setup(struct vfio_pci_device *device, const char
>  	 */
>  	(void)ioctl(iommu->container_fd, VFIO_SET_IOMMU, (void *)iommu_type);
>  
> -	device->fd = ioctl(device->group_fd, VFIO_GROUP_GET_DEVICE_FD, bdf);
> -	VFIO_ASSERT_GE(device->fd, 0);
> +	vfio_pci_group_get_device_fd(device, bdf, vf_token);
>  }
>  
>  static void vfio_pci_device_setup(struct vfio_pci_device *device)
> @@ -279,12 +299,20 @@ const char *vfio_pci_get_cdev_path(const char *bdf)
>  	return cdev_path;
>  }
>  
> -static void vfio_device_bind_iommufd(int device_fd, int iommufd)
> +static void vfio_device_bind_iommufd(int device_fd, int iommufd,
> +				     const char *vf_token)
>  {
>  	struct vfio_device_bind_iommufd args = {
>  		.argsz = sizeof(args),
>  		.iommufd = iommufd,
>  	};
> +	uuid_t token_uuid = {0};

unnecessary intitialization

> +
> +	if (vf_token) {
> +		VFIO_ASSERT_EQ(uuid_parse(vf_token, token_uuid), 0);
> +		args.flags |= VFIO_DEVICE_BIND_FLAG_TOKEN;
> +		args.token_uuid_ptr = (u64)token_uuid;
> +	}
>  
>  	ioctl_assert(device_fd, VFIO_DEVICE_BIND_IOMMUFD, &args);
>  }
> @@ -299,7 +327,8 @@ static void vfio_device_attach_iommufd_pt(int device_fd, u32 pt_id)
>  	ioctl_assert(device_fd, VFIO_DEVICE_ATTACH_IOMMUFD_PT, &args);
>  }
>  
> -static void vfio_pci_iommufd_setup(struct vfio_pci_device *device, const char *bdf)
> +static void vfio_pci_iommufd_setup(struct vfio_pci_device *device,
> +				   const char *bdf, const char *vf_token)
>  {
>  	const char *cdev_path = vfio_pci_get_cdev_path(bdf);
>  
> @@ -307,7 +336,7 @@ static void vfio_pci_iommufd_setup(struct vfio_pci_device *device, const char *b
>  	VFIO_ASSERT_GE(device->fd, 0);
>  	free((void *)cdev_path);
>  
> -	vfio_device_bind_iommufd(device->fd, device->iommu->iommufd);
> +	vfio_device_bind_iommufd(device->fd, device->iommu->iommufd, vf_token);
>  	vfio_device_attach_iommufd_pt(device->fd, device->iommu->ioas_id);
>  }
>  
> @@ -323,9 +352,9 @@ struct vfio_pci_device *vfio_pci_device_init(const char *bdf, struct iommu *iomm
>  	device->bdf = bdf;
>  
>  	if (iommu->mode->container_path)
> -		vfio_pci_container_setup(device, bdf);
> +		vfio_pci_container_setup(device, bdf, NULL);
>  	else
> -		vfio_pci_iommufd_setup(device, bdf);
> +		vfio_pci_iommufd_setup(device, bdf, NULL);
>  
>  	vfio_pci_device_setup(device);
>  	vfio_pci_driver_probe(device);
> -- 
> 2.52.0.239.gd5f0c6e74e-goog
> 

