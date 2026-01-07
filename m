Return-Path: <kvm+bounces-67296-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id BAB5DD0058A
	for <lists+kvm@lfdr.de>; Wed, 07 Jan 2026 23:41:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 5B2BF302FA19
	for <lists+kvm@lfdr.de>; Wed,  7 Jan 2026 22:41:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 60D2B2DC792;
	Wed,  7 Jan 2026 22:41:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="idIbn+US"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E03BD13D539
	for <kvm@vger.kernel.org>; Wed,  7 Jan 2026 22:41:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767825684; cv=none; b=CSU1ohtOKOwUcgIhSQoELyhM/59iNgMXG9kgED3AeRgt6XQiaop+BBxB29y2NKw1D8Ti/wcmGHs/wfStr52RaPouAx52DUa4sNnlg7diOtUgfJjqnGztxs62rzLSsjlGs7udDK/7yQyV7ttInmuaDFt5mR55rMH9fwT8lMGk7+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767825684; c=relaxed/simple;
	bh=TfZwPqlyh1oB4i0iVYBem2dGIUyrF9FuHKELjNPyTeg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=R2j4azLrvdeDXc2mji1w1xLTlcnaL40QORDxJKfsaGo05sX2cciGuY9/v158eZehJwJbgRf3TTCWmZeFgEC7RjjQLCewlLPCPqAepqQUB1dm1Z9RxnshQSD6w3ChtaVJjnwqNuawALeS+MEqMzp6Z6uBpCr2ysPNnAPAMLPNZf8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=idIbn+US; arc=none smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-7baf61be569so1869646b3a.3
        for <kvm@vger.kernel.org>; Wed, 07 Jan 2026 14:41:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767825682; x=1768430482; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=v9R4hCYznhT9RKLlBacnnIYN5fdIevxyaDhLEalVkj4=;
        b=idIbn+USxHDE8RbIw3Zt7Fh/i5dIz6/2Y8PjbCa0u8T08hGdUQBf1544Xq9tVhlfb/
         Djri1wjiXYERADJWC4QaQZRh2Ur1UYr9NLsG5UznwtlXd8wnUeDEs8Gv0oiza6j1kAxT
         Qh39DfbXRKwfKg4V4zgykNTdIRTpWBJHhtR/q0iFE3hHjFBPx2/7F1Hk1sRDJtYhx2cj
         Lpm87s1iW0a2Tz0Ju3WMENdmadfFRLaN3mpdzmTlGymdibjgpTRtZv1BsVwQeqceNUgQ
         ibGgbdv2kegnSmvXXpT8m5/mQP3AgCq1vqfNJ8i0EXnMB24vgPM2hqPmL7qzU8HLLcYX
         wDpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767825682; x=1768430482;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=v9R4hCYznhT9RKLlBacnnIYN5fdIevxyaDhLEalVkj4=;
        b=H5BShwvNnYVdjwAyXzMJiRjoSUpocbStF6BlJJC+va5ZjjwUnYrOortQIRCen6vS6G
         crru999ASNzzdsZ8Rpkcwwf3PiL4umIJJG8n83w8JsIDmlfPiCH9rJn3/h84IXu+VceT
         NXnygh4ZxdwhEzUKRZavpjqI1HrE3Z0zVH+P9tJ3/lioscm6IDZzYZjshq6fNYykDzQ/
         uAMsvN1s5VioWcGhr5p/QmjJsFbRRh4sE2aEozAJgRSZaBDX1hSNBxDAsnE1BkJ5e3Wm
         1lXo8O9RWgOolYO4CmEq79l6Np76ZP6iPpEyhThz0b0oRNVm/e7cpD4L88D63OwH/wbX
         mwyQ==
X-Forwarded-Encrypted: i=1; AJvYcCUvZZ2ByUYGvPOmH7QRF+wkwbnShR4oAQkL+2gxwMy0uF5A0iKS/epy46q8BjKVzmAACYc=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy+Bx/eKCZjg83zUtEMBgSfk3oTBA+GPJu4Fmic/zilAQaLZ7Uc
	lU0sHbVGb5E0cLZn4gcagQlaBsy+RsZf528fPE88ip6I8jyvsTk8Qv+A1sSXkQu/ng==
X-Gm-Gg: AY/fxX5MXoHnsicu6FH6Wur5fe6eUGHUz1iNq10L3NuYybDMSYnlNVr+59/W/9V7Sfh
	1bnZSbTva+nGrcjQ0VYP8y2frgrgjD+GL9YZfElqOiX8pQKJQgpTr6aWdm8/5yU1hOQWItqMaxz
	hayqauzvuArWS8EcxgFcmOUzfuPKlYpYZVgGAapOe+F9pjjvPMSmiXl8q2ysJmf/fgIUxVJ6HEv
	J3rFxeBn55Yk9eKvnmfy8s6dhU6U/nQMRyHuAyIgy/44sanr4xKR0EyyhzCzTv33Es527paf0bA
	IKKKX3HU9gDYRKyn3DWtpP9X4ZHwvLoA10VkR9AVXH5FYXUfiU1XX1NzRJSHapGXtWZSgg9qNDR
	/tiCr928t8hL56UPmfZgQvJKFSoCQ10hREXzeoCE5VKGwt+snbsS20KdWrWwnwuexxajiAw9Ssp
	puxuSo/DEsjRpgbECvx1IVQQA0Y8hbw4RKtIakcPMvn2T4
X-Google-Smtp-Source: AGHT+IE+BvEJsS2DFv5QiWH7YYAPgCmf2jQigQ3FhEFXnmVCx8AVAgcqiTU/wMRzosOYuEry+gb3pA==
X-Received: by 2002:a05:6a21:998b:b0:342:378e:44af with SMTP id adf61e73a8af0-3898f987cbfmr3835550637.41.1767825681950;
        Wed, 07 Jan 2026 14:41:21 -0800 (PST)
Received: from google.com (76.9.127.34.bc.googleusercontent.com. [34.127.9.76])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a3e3cb2dd4sm58346295ad.47.2026.01.07.14.41.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jan 2026 14:41:21 -0800 (PST)
Date: Wed, 7 Jan 2026 22:41:16 +0000
From: David Matlack <dmatlack@google.com>
To: Raghavendra Rao Ananta <rananta@google.com>
Cc: Alex Williamson <alex@shazbot.org>,
	Alex Williamson <alex.williamson@redhat.com>,
	Josh Hilke <jrhilke@google.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/6] vfio: selftests: Introduce a sysfs lib
Message-ID: <aV7hDIe3tvehETXS@google.com>
References: <20251210181417.3677674-1-rananta@google.com>
 <20251210181417.3677674-3-rananta@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251210181417.3677674-3-rananta@google.com>

On 2025-12-10 06:14 PM, Raghavendra Rao Ananta wrote:
> Introduce a sysfs liibrary to handle the common reads/writes to the
                    library

> PCI sysfs files, for example, getting the total number of VFs supported
> by the device via /sys/bus/pci/devices/$BDF/sriov_totalvfs. The library
> will be used in the upcoming test patch to configure the VFs for a given
> PF device.
> 
> Opportunistically, move vfio_pci_get_group_from_dev() to this library as
> it falls under the same bucket. Rename it to sysfs_get_device_group() to
> align with other function names.
> 
> Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> ---
>  .../selftests/vfio/lib/include/libvfio.h      |   1 +
>  .../vfio/lib/include/libvfio/sysfs.h          |  16 ++
>  tools/testing/selftests/vfio/lib/libvfio.mk   |   1 +
>  tools/testing/selftests/vfio/lib/sysfs.c      | 151 ++++++++++++++++++
>  .../selftests/vfio/lib/vfio_pci_device.c      |  22 +--
>  5 files changed, 170 insertions(+), 21 deletions(-)
>  create mode 100644 tools/testing/selftests/vfio/lib/include/libvfio/sysfs.h
>  create mode 100644 tools/testing/selftests/vfio/lib/sysfs.c
> 
> diff --git a/tools/testing/selftests/vfio/lib/include/libvfio.h b/tools/testing/selftests/vfio/lib/include/libvfio.h
> index 279ddcd701944..bbe1d7616a648 100644
> --- a/tools/testing/selftests/vfio/lib/include/libvfio.h
> +++ b/tools/testing/selftests/vfio/lib/include/libvfio.h
> @@ -5,6 +5,7 @@
>  #include <libvfio/assert.h>
>  #include <libvfio/iommu.h>
>  #include <libvfio/iova_allocator.h>
> +#include <libvfio/sysfs.h>
>  #include <libvfio/vfio_pci_device.h>
>  #include <libvfio/vfio_pci_driver.h>
>  
> diff --git a/tools/testing/selftests/vfio/lib/include/libvfio/sysfs.h b/tools/testing/selftests/vfio/lib/include/libvfio/sysfs.h
> new file mode 100644
> index 0000000000000..1eca6b5cbcfcc
> --- /dev/null
> +++ b/tools/testing/selftests/vfio/lib/include/libvfio/sysfs.h
> @@ -0,0 +1,16 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +#ifndef SELFTESTS_VFIO_LIB_INCLUDE_LIBVFIO_SYSFS_H
> +#define SELFTESTS_VFIO_LIB_INCLUDE_LIBVFIO_SYSFS_H
> +
> +int sysfs_get_sriov_totalvfs(const char *bdf);
> +int sysfs_get_sriov_numvfs(const char *bdf);
> +void sysfs_set_sriov_numvfs(const char *bdfs, int numvfs);
> +void sysfs_get_sriov_vf_bdf(const char *pf_bdf, int i, char *out_vf_bdf);
> +bool sysfs_get_sriov_drivers_autoprobe(const char *bdf);
> +void sysfs_set_sriov_drivers_autoprobe(const char *bdf, bool val);
> +void sysfs_bind_driver(const char *bdf, const char *driver);
> +void sysfs_unbind_driver(const char *bdf, const char *driver);
> +int sysfs_get_driver(const char *bdf, char *out_driver);
> +unsigned int sysfs_get_device_group(const char *bdf);
> +
> +#endif /* SELFTESTS_VFIO_LIB_INCLUDE_LIBVFIO_SYSFS_H */
> diff --git a/tools/testing/selftests/vfio/lib/libvfio.mk b/tools/testing/selftests/vfio/lib/libvfio.mk
> index 9f47bceed16f4..b7857319c3f1f 100644
> --- a/tools/testing/selftests/vfio/lib/libvfio.mk
> +++ b/tools/testing/selftests/vfio/lib/libvfio.mk
> @@ -6,6 +6,7 @@ LIBVFIO_SRCDIR := $(selfdir)/vfio/lib
>  LIBVFIO_C := iommu.c
>  LIBVFIO_C += iova_allocator.c
>  LIBVFIO_C += libvfio.c
> +LIBVFIO_C += sysfs.c
>  LIBVFIO_C += vfio_pci_device.c
>  LIBVFIO_C += vfio_pci_driver.c
>  
> diff --git a/tools/testing/selftests/vfio/lib/sysfs.c b/tools/testing/selftests/vfio/lib/sysfs.c
> new file mode 100644
> index 0000000000000..5551e8b981075
> --- /dev/null
> +++ b/tools/testing/selftests/vfio/lib/sysfs.c
> @@ -0,0 +1,151 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +#include <fcntl.h>
> +#include <unistd.h>
> +#include <stdlib.h>
> +#include <string.h>
> +#include <linux/limits.h>
> +
> +#include <libvfio.h>
> +
> +static int sysfs_get_val(const char *component, const char *name,

nit: I'm partial to putting the verbs at the end of function names for
library calls.

e.g.

  vfio_pci_config_read()
  vfio_pci_config_write()
  vfio_pci_msi_enable()
  vfio_pci_msi_disable()

So these would be:

  sysfs_val_set()
  sysfs_val_get()
  sysfs_device_val_set()
  sysfs_device_val_get()
  sysfs_sriov_numvfs_set()
  sysfs_sriov_numvfs_get()
  ...

> +			 const char *file)
> +{
> +	char path[PATH_MAX] = {0};
> +	char buf[32] = {0};

nit: You don't need to zero-initialize these since you only use them
after they are intitialized below.

> +	int fd;
> +
> +	snprintf(path, PATH_MAX, "/sys/bus/pci/%s/%s/%s", component, name, file);

Use the new snprintf_assert() :)

> +	fd = open(path, O_RDONLY);
> +	if (fd < 0)
> +		return fd;
> +
> +	VFIO_ASSERT_GT(read(fd, buf, ARRAY_SIZE(buf)), 0);
> +	VFIO_ASSERT_EQ(close(fd), 0);
> +
> +	return strtol(buf, NULL, 0);
> +}
> +
> +static void sysfs_set_val(const char *component, const char *name,
> +			  const char *file, const char *val)
> +{
> +	char path[PATH_MAX] = {0};

Ditto here about zero-intialization being unnecessary.

> +	int fd;
> +
> +	snprintf(path, PATH_MAX, "/sys/bus/pci/%s/%s/%s", component, name, file);

Ditto here about snprintf_assert()

You get the idea... I won't comment on the ones below.

> +	VFIO_ASSERT_GT(fd = open(path, O_WRONLY), 0);
> +
> +	VFIO_ASSERT_EQ(write(fd, val, strlen(val)), strlen(val));
> +	VFIO_ASSERT_EQ(close(fd), 0);
> +}
> +
> +static int sysfs_get_device_val(const char *bdf, const char *file)
> +{
> +	sysfs_get_val("devices", bdf, file);
> +}
> +
> +static void sysfs_set_device_val(const char *bdf, const char *file, const char *val)
> +{
> +	sysfs_set_val("devices", bdf, file, val);
> +}
> +
> +static void sysfs_set_driver_val(const char *driver, const char *file, const char *val)
> +{
> +	sysfs_set_val("drivers", driver, file, val);
> +}
> +
> +static void sysfs_set_device_val_int(const char *bdf, const char *file, int val)
> +{
> +	char val_str[32] = {0};
> +
> +	snprintf(val_str, sizeof(val_str), "%d", val);
> +	sysfs_set_device_val(bdf, file, val_str);
> +}
> +
> +int sysfs_get_sriov_totalvfs(const char *bdf)
> +{
> +	return sysfs_get_device_val(bdf, "sriov_totalvfs");
> +}
> +
> +int sysfs_get_sriov_numvfs(const char *bdf)
> +{
> +	return sysfs_get_device_val(bdf, "sriov_numvfs");
> +}
> +
> +void sysfs_set_sriov_numvfs(const char *bdf, int numvfs)
> +{
> +	sysfs_set_device_val_int(bdf, "sriov_numvfs", numvfs);
> +}
> +
> +bool sysfs_get_sriov_drivers_autoprobe(const char *bdf)
> +{
> +	return (bool)sysfs_get_device_val(bdf, "sriov_drivers_autoprobe");
> +}
> +
> +void sysfs_set_sriov_drivers_autoprobe(const char *bdf, bool val)
> +{
> +	sysfs_set_device_val_int(bdf, "sriov_drivers_autoprobe", val);
> +}
> +
> +void sysfs_bind_driver(const char *bdf, const char *driver)
> +{
> +	sysfs_set_driver_val(driver, "bind", bdf);
> +}
> +
> +void sysfs_unbind_driver(const char *bdf, const char *driver)
> +{
> +	sysfs_set_driver_val(driver, "unbind", bdf);
> +}
> +
> +void sysfs_get_sriov_vf_bdf(const char *pf_bdf, int i, char *out_vf_bdf)
> +{
> +	char vf_path[PATH_MAX] = {0};
> +	char path[PATH_MAX] = {0};
> +	int ret;
> +
> +	snprintf(path, PATH_MAX, "/sys/bus/pci/devices/%s/virtfn%d", pf_bdf, i);
> +
> +	ret = readlink(path, vf_path, PATH_MAX);
> +	VFIO_ASSERT_NE(ret, -1);
> +
> +	ret = sscanf(basename(vf_path), "%s", out_vf_bdf);
> +	VFIO_ASSERT_EQ(ret, 1);
> +}
> +
> +unsigned int sysfs_get_device_group(const char *bdf)

nit: s/device_group/iommu_group/

> +{
> +	char dev_iommu_group_path[PATH_MAX] = {0};
> +	char path[PATH_MAX] = {0};
> +	unsigned int group;
> +	int ret;
> +
> +	snprintf(path, PATH_MAX, "/sys/bus/pci/devices/%s/iommu_group", bdf);
> +
> +	ret = readlink(path, dev_iommu_group_path, sizeof(dev_iommu_group_path));
> +	VFIO_ASSERT_NE(ret, -1, "Failed to get the IOMMU group for device: %s\n", bdf);
> +
> +	ret = sscanf(basename(dev_iommu_group_path), "%u", &group);
> +	VFIO_ASSERT_EQ(ret, 1, "Failed to get the IOMMU group for device: %s\n", bdf);
> +
> +	return group;
> +}
> +
> +int sysfs_get_driver(const char *bdf, char *out_driver)
> +{
> +	char driver_path[PATH_MAX] = {0};
> +	char path[PATH_MAX] = {0};
> +	int ret;
> +
> +	snprintf(path, PATH_MAX, "/sys/bus/pci/devices/%s/driver", bdf);
> +	ret = readlink(path, driver_path, PATH_MAX);
> +	if (ret == -1) {
> +		if (errno == ENOENT)
> +			return -1;
> +
> +		VFIO_FAIL("Failed to read %s\n", path);
> +	}
> +
> +	ret = sscanf(basename(driver_path), "%s", out_driver);

I think this is equivalent to:

  out_driver = basename(driver_path);

... which means out_driver to point within driver_path, which is stack
allocated? I think you want to do strcpy() after basename() to copy the
driver name to out_driver.

Also how do you prevent overflowing out_driver? Maybe it would be
cleaner for sysfs_get_driver() to allocate out_driver and return it to
the caller?

We can return an empty string for the ENOENT case.

> +	VFIO_ASSERT_EQ(ret, 1);
> +
> +	return 0;
> +}
> diff --git a/tools/testing/selftests/vfio/lib/vfio_pci_device.c b/tools/testing/selftests/vfio/lib/vfio_pci_device.c
> index 64a19481b734f..9b2a123cee5fc 100644
> --- a/tools/testing/selftests/vfio/lib/vfio_pci_device.c
> +++ b/tools/testing/selftests/vfio/lib/vfio_pci_device.c
> @@ -22,8 +22,6 @@
>  #include "../../../kselftest.h"
>  #include <libvfio.h>
>  
> -#define PCI_SYSFS_PATH	"/sys/bus/pci/devices"
> -
>  static void vfio_pci_irq_set(struct vfio_pci_device *device,
>  			     u32 index, u32 vector, u32 count, int *fds)
>  {
> @@ -181,24 +179,6 @@ void vfio_pci_device_reset(struct vfio_pci_device *device)
>  	ioctl_assert(device->fd, VFIO_DEVICE_RESET, NULL);
>  }
>  
> -static unsigned int vfio_pci_get_group_from_dev(const char *bdf)
> -{
> -	char dev_iommu_group_path[PATH_MAX] = {0};
> -	char sysfs_path[PATH_MAX] = {0};
> -	unsigned int group;
> -	int ret;
> -
> -	snprintf_assert(sysfs_path, PATH_MAX, "%s/%s/iommu_group", PCI_SYSFS_PATH, bdf);
> -
> -	ret = readlink(sysfs_path, dev_iommu_group_path, sizeof(dev_iommu_group_path));
> -	VFIO_ASSERT_NE(ret, -1, "Failed to get the IOMMU group for device: %s\n", bdf);
> -
> -	ret = sscanf(basename(dev_iommu_group_path), "%u", &group);
> -	VFIO_ASSERT_EQ(ret, 1, "Failed to get the IOMMU group for device: %s\n", bdf);
> -
> -	return group;
> -}
> -
>  static void vfio_pci_group_setup(struct vfio_pci_device *device, const char *bdf)
>  {
>  	struct vfio_group_status group_status = {
> @@ -207,7 +187,7 @@ static void vfio_pci_group_setup(struct vfio_pci_device *device, const char *bdf
>  	char group_path[32];
>  	int group;
>  
> -	group = vfio_pci_get_group_from_dev(bdf);
> +	group = sysfs_get_device_group(bdf);
>  	snprintf_assert(group_path, sizeof(group_path), "/dev/vfio/%d", group);
>  
>  	device->group_fd = open(group_path, O_RDWR);
> -- 
> 2.52.0.239.gd5f0c6e74e-goog
> 

