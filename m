Return-Path: <kvm+bounces-67299-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 3F108D005AB
	for <lists+kvm@lfdr.de>; Wed, 07 Jan 2026 23:56:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 72EBE304B3F6
	for <lists+kvm@lfdr.de>; Wed,  7 Jan 2026 22:55:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 88DAD2E7637;
	Wed,  7 Jan 2026 22:55:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ajmSN0Zk"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f194.google.com (mail-pl1-f194.google.com [209.85.214.194])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B2A5278E47
	for <kvm@vger.kernel.org>; Wed,  7 Jan 2026 22:55:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.194
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767826513; cv=none; b=u71NU747Rfhpi9fdVT0p03sD/Qf9d/p6H2eN/3aCdMCBxJN+KM3dfh8ZGTIIfJzevmkYQF0Vr2NR6a7ceaJ3eVQYJNJrgrIMeaIoSA1hRAmjghl0Dx3xg4bkBayfPbD1fudrrn9+eoZYYPdFmC0iM7e99v7Lh8fIU1dofeM3LR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767826513; c=relaxed/simple;
	bh=QlnNM8G33LFHAv4E4QupmC52vbBOTPva1B/8FJM7PdQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hsM6kh3TVxJPxjkhk9epIybAh6j4+gi3I+vqvYjk3ZX7RhIMb2mgMroWjPrlzZuHO6f1kKsOj4eb5O27QLo27/sNg14kCNvxOyMGhfHloHSsQybFOpv5eAKeJfYaVu5GiRB7NLrixdao/MRc5RbZXWMUeaqBWWqwj9o5e+Irr5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ajmSN0Zk; arc=none smtp.client-ip=209.85.214.194
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f194.google.com with SMTP id d9443c01a7336-2a09d981507so10985715ad.1
        for <kvm@vger.kernel.org>; Wed, 07 Jan 2026 14:55:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767826510; x=1768431310; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=gQYEwEgO5HZdvBOkI6YyFS22il1EyH344FtZtud2KFo=;
        b=ajmSN0Zkksl4QYCQw8IZCUd1nMMlsYk6aQBzXza4XLHKRKOskyjir8nWQrV9vZsntZ
         EbgvUQz7DNDPXgZIr4zl+BlNKejDtPtMgzMVJHuBF0YOzLTVuzLGm98PlwXm2DZR1iII
         7l4y2TiT6cEllVwhsyN0qVDjVt+rz6Yoo2yLtreiavOjGIS+Mfsg+czJ4Q2/3QtTK+TU
         Q1b+vSv8KaSqYMk1/xS8UZcBsH/u0nhy+zUuloLC5EZsEMkWUHp8GAerXJjNX8jdO540
         7UR59Ee2YUCNBAGD4/lOAlXC96wz063/BEHauZ/bTqotccq1WxhM/CwssogSrCPs9luZ
         Ivvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767826510; x=1768431310;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gQYEwEgO5HZdvBOkI6YyFS22il1EyH344FtZtud2KFo=;
        b=QZ+rZS8K8DMTavlJIgKj+2SUEQv7e/aaBW2HOBS0gpWrprIKFNQujZM8VCqcfsdfvR
         5cq8dl3Ef75p7t+3xzN5fsT2H9jM0ef0BBN07Pw1yD4+XPPwcOkehn2qL9lKIHSNRj3K
         5JoRErsYMmmaEy0wBL1WJpVVFVeBP4IaTTb3/ksY31zhG84nfwipMa+lTubTG4zrIGep
         BfWQ36lGUpgeojarcpQ8EfX222dW+/FrCLJ3iuHryCk8v5ePw4EwvUI6kUFxn+UbRO2c
         cv1wBiseMQ0urq+2BsYXo97TacGHZITvpVKxkDZmiz8EK8XlmiU7oVX+9FFIKwiijQUl
         tI1Q==
X-Forwarded-Encrypted: i=1; AJvYcCX4BxqaKUGZFPCsosS2GGl1EnPFcJdRi1mUK1eRphaT5qzbHSl/0y4PSxN/WYzRMLA3kSg=@vger.kernel.org
X-Gm-Message-State: AOJu0YxVTSh1NMgJgxxdg4IgyXkfyQbGN3TZkADtPxIaGHOqTO2ZfJtG
	5tNwDIX938JPp/qymU6YbeZg/Bv1g0xHRI8X2RqjWMr41s877X+/9BeafXvTPWyVbA==
X-Gm-Gg: AY/fxX48keG0v4Kls3uf54RO2opTvQbC9vMtxd1q6+lYvMHP3NQNu9my5l4Ne5izcjd
	SHOTVSqql2+velhARigevnKPf6DB6a9w2r2ExkdqJv7x9z9SoMUUQTPTfNY0opKwdZuIut2oiYk
	kcZR9rjGcRGWCgLUOIKD1Nn+jUBFCCgTksrdxKsWt/UhNi39ciChBx1eVGZjQ+lB7ftUfFZqF3Y
	K5CHoyOeFbBPI3D6Uznnz6aaoonu0hcAev8vwlAkILa6CjzXYJztDtnYa93gKCFEcYDUNbCLzb/
	VJjMSfJJwsjKM10hKDQHAil0vkt7dfbjHwpMgANMa18NhA0yXLa8m5PPoPjJO8AkFBTNJoJhWld
	7w1W5zmUSLAM7uXLs7MgIvtycSCyoooDkA3DiqZZOivzox6GkOZFn1jdq0Mvfen2rzA7NSZWbuK
	OFA6YHFrUrw7PJbcWlZhy5r+fSKZaQLgrCOiu+uuWjy+w0F+X5ZyALBeo=
X-Google-Smtp-Source: AGHT+IFx94sMczoLItqDdXs+++flnqgrkUGzxLw3zDHUIQw+ApmOkqsT364ITtTyiGLA9l6rYKk9WA==
X-Received: by 2002:a17:903:acc:b0:295:134:9ae5 with SMTP id d9443c01a7336-2a3edb8bf35mr36244995ad.24.1767826510241;
        Wed, 07 Jan 2026 14:55:10 -0800 (PST)
Received: from google.com (76.9.127.34.bc.googleusercontent.com. [34.127.9.76])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a3e3cc8ddfsm59173505ad.74.2026.01.07.14.55.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jan 2026 14:55:09 -0800 (PST)
Date: Wed, 7 Jan 2026 22:55:05 +0000
From: David Matlack <dmatlack@google.com>
To: Raghavendra Rao Ananta <rananta@google.com>
Cc: Alex Williamson <alex@shazbot.org>,
	Alex Williamson <alex.williamson@redhat.com>,
	Josh Hilke <jrhilke@google.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 4/6] vfio: selftests: Export more vfio_pci functions
Message-ID: <aV7kScUBdrYdKCPE@google.com>
References: <20251210181417.3677674-1-rananta@google.com>
 <20251210181417.3677674-5-rananta@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251210181417.3677674-5-rananta@google.com>

On 2025-12-10 06:14 PM, Raghavendra Rao Ananta wrote:

shotlog nit: "Expose more vfio_pci_device functions"

> Refactor and make the functions called under device initialization
> public. A later patch adds a test that calls these functions to validate
> the UAPI of SR-IOV devices. Opportunistically, to test the success
> and failure cases of the UAPI, split the functions dealing with
> VFIO_GROUP_GET_DEVICE_FD and VFIO_DEVICE_BIND_IOMMUFD into a core
> function and another one that asserts the ioctl. The former will be
> used for testing the SR-IOV UAPI, hence only export these.
> 
> Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> ---
>  .../lib/include/libvfio/vfio_pci_device.h     |  7 +++
>  .../selftests/vfio/lib/vfio_pci_device.c      | 44 ++++++++++++++-----
>  2 files changed, 39 insertions(+), 12 deletions(-)
> 
> diff --git a/tools/testing/selftests/vfio/lib/include/libvfio/vfio_pci_device.h b/tools/testing/selftests/vfio/lib/include/libvfio/vfio_pci_device.h
> index 2858885a89bbb..6186ca463ca6e 100644
> --- a/tools/testing/selftests/vfio/lib/include/libvfio/vfio_pci_device.h
> +++ b/tools/testing/selftests/vfio/lib/include/libvfio/vfio_pci_device.h
> @@ -122,4 +122,11 @@ static inline bool vfio_pci_device_match(struct vfio_pci_device *device,
>  
>  const char *vfio_pci_get_cdev_path(const char *bdf);
>  
> +void vfio_pci_group_setup(struct vfio_pci_device *device, const char *bdf);
> +void __vfio_pci_group_get_device_fd(struct vfio_pci_device *device,
> +				    const char *bdf, const char *vf_token);
> +void vfio_container_set_iommu(struct vfio_pci_device *device);
> +void vfio_pci_iommufd_cdev_open(struct vfio_pci_device *device, const char *bdf);
> +int __vfio_device_bind_iommufd(int device_fd, int iommufd, const char *vf_token);
> +
>  #endif /* SELFTESTS_VFIO_LIB_INCLUDE_LIBVFIO_VFIO_PCI_DEVICE_H */
> diff --git a/tools/testing/selftests/vfio/lib/vfio_pci_device.c b/tools/testing/selftests/vfio/lib/vfio_pci_device.c
> index ac9a5244ddc46..208da2704d9e2 100644
> --- a/tools/testing/selftests/vfio/lib/vfio_pci_device.c
> +++ b/tools/testing/selftests/vfio/lib/vfio_pci_device.c
> @@ -180,7 +180,7 @@ void vfio_pci_device_reset(struct vfio_pci_device *device)
>  	ioctl_assert(device->fd, VFIO_DEVICE_RESET, NULL);
>  }
>  
> -static void vfio_pci_group_setup(struct vfio_pci_device *device, const char *bdf)
> +void vfio_pci_group_setup(struct vfio_pci_device *device, const char *bdf)
>  {
>  	struct vfio_group_status group_status = {
>  		.argsz = sizeof(group_status),
> @@ -200,8 +200,8 @@ static void vfio_pci_group_setup(struct vfio_pci_device *device, const char *bdf
>  	ioctl_assert(device->group_fd, VFIO_GROUP_SET_CONTAINER, &device->iommu->container_fd);
>  }
>  
> -static void vfio_pci_group_get_device_fd(struct vfio_pci_device *device,
> -					 const char *bdf, const char *vf_token)
> +void __vfio_pci_group_get_device_fd(struct vfio_pci_device *device,
> +				    const char *bdf, const char *vf_token)
>  {
>  	char arg[64] = {0};
>  
> @@ -216,18 +216,21 @@ static void vfio_pci_group_get_device_fd(struct vfio_pci_device *device,
>  		snprintf(arg, ARRAY_SIZE(arg), "%s", bdf);
>  
>  	device->fd = ioctl(device->group_fd, VFIO_GROUP_GET_DEVICE_FD, arg);
> +}
> +
> +static void vfio_pci_group_get_device_fd(struct vfio_pci_device *device,
> +					 const char *bdf, const char *vf_token)
> +{
> +	__vfio_pci_group_get_device_fd(device, bdf, vf_token);
>  	VFIO_ASSERT_GE(device->fd, 0);
>  }
>  
> -static void vfio_pci_container_setup(struct vfio_pci_device *device,
> -				     const char *bdf, const char *vf_token)
> +void vfio_container_set_iommu(struct vfio_pci_device *device)
>  {
>  	struct iommu *iommu = device->iommu;
>  	unsigned long iommu_type = iommu->mode->iommu_type;
>  	int ret;
>  
> -	vfio_pci_group_setup(device, bdf);
> -
>  	ret = ioctl(iommu->container_fd, VFIO_CHECK_EXTENSION, iommu_type);
>  	VFIO_ASSERT_GT(ret, 0, "VFIO IOMMU type %lu not supported\n", iommu_type);
>  
> @@ -237,7 +240,13 @@ static void vfio_pci_container_setup(struct vfio_pci_device *device,
>  	 * because the IOMMU type is already set.
>  	 */
>  	(void)ioctl(iommu->container_fd, VFIO_SET_IOMMU, (void *)iommu_type);
> +}
>  
> +static void vfio_pci_container_setup(struct vfio_pci_device *device,
> +				     const char *bdf, const char *vf_token)
> +{
> +	vfio_pci_group_setup(device, bdf);
> +	vfio_container_set_iommu(device);
>  	vfio_pci_group_get_device_fd(device, bdf, vf_token);
>  }
>  
> @@ -299,8 +308,7 @@ const char *vfio_pci_get_cdev_path(const char *bdf)
>  	return cdev_path;
>  }
>  
> -static void vfio_device_bind_iommufd(int device_fd, int iommufd,
> -				     const char *vf_token)
> +int __vfio_device_bind_iommufd(int device_fd, int iommufd, const char *vf_token)
>  {
>  	struct vfio_device_bind_iommufd args = {
>  		.argsz = sizeof(args),
> @@ -314,7 +322,15 @@ static void vfio_device_bind_iommufd(int device_fd, int iommufd,
>  		args.token_uuid_ptr = (u64)token_uuid;
>  	}
>  
> -	ioctl_assert(device_fd, VFIO_DEVICE_BIND_IOMMUFD, &args);
> +	return ioctl(device_fd, VFIO_DEVICE_BIND_IOMMUFD, &args);
> +}
> +
> +static void vfio_device_bind_iommufd(int device_fd, int iommufd,
> +				     const char *vf_token)
> +{
> +	int ret = __vfio_device_bind_iommufd(device_fd, iommufd, vf_token);
> +
> +	VFIO_ASSERT_EQ(ret, 0, "Failed VFIO_DEVICE_BIND_IOMMUFD ioctl\n");
>  }
>  
>  static void vfio_device_attach_iommufd_pt(int device_fd, u32 pt_id)
> @@ -327,15 +343,19 @@ static void vfio_device_attach_iommufd_pt(int device_fd, u32 pt_id)
>  	ioctl_assert(device_fd, VFIO_DEVICE_ATTACH_IOMMUFD_PT, &args);
>  }
>  
> -static void vfio_pci_iommufd_setup(struct vfio_pci_device *device,
> -				   const char *bdf, const char *vf_token)
> +void vfio_pci_iommufd_cdev_open(struct vfio_pci_device *device, const char *bdf)

nit: vfio_pci_cdev_open()

Opening the cdev doesn't interact with iommufd in the kernel in any way.
It's a pure VFIO operation. So having iommufd in the name here might be
confusing.

>  {
>  	const char *cdev_path = vfio_pci_get_cdev_path(bdf);
>  
>  	device->fd = open(cdev_path, O_RDWR);
>  	VFIO_ASSERT_GE(device->fd, 0);
>  	free((void *)cdev_path);
> +}
>  
> +static void vfio_pci_iommufd_setup(struct vfio_pci_device *device,
> +				   const char *bdf, const char *vf_token)
> +{
> +	vfio_pci_iommufd_cdev_open(device, bdf);
>  	vfio_device_bind_iommufd(device->fd, device->iommu->iommufd, vf_token);
>  	vfio_device_attach_iommufd_pt(device->fd, device->iommu->ioas_id);
>  }
> -- 
> 2.52.0.239.gd5f0c6e74e-goog
> 

