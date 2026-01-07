Return-Path: <kvm+bounces-67303-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id AE10BD0062C
	for <lists+kvm@lfdr.de>; Thu, 08 Jan 2026 00:23:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 449663014D9B
	for <lists+kvm@lfdr.de>; Wed,  7 Jan 2026 23:22:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0653E2F6930;
	Wed,  7 Jan 2026 23:22:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="GAXQFfhX"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80C512EDD76
	for <kvm@vger.kernel.org>; Wed,  7 Jan 2026 23:22:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767828170; cv=none; b=s0Oh/0NaIRIryXwaRO4BgBlw4gz/l+E5j5hIlXrLwJh9Em9E4i8MyKARWMUT6+dEpcfy53sXsuQM4RIwQXX/IWv6MzsZdBmoVbuNiOoKnRix1ULf45onumo2ubk0nc56ZtTD2HvFcYzD1+uqZrUJ1A3Ymzq5sXzNc1x8gAl54PU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767828170; c=relaxed/simple;
	bh=Y0apOWxCxJEtiyyIz7o8kSQYmhxJacV6R/ASISLkGKU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Rog6Jp5xU/7F907cWDkjngQBxAgiZvoZh7SNXG/M5O79RVKMG7Hdf1xD0EXT1F7i4KJpv1lYd3QscssBcdwAX7GVd5PnOgLKYNuQtCJp/TNbkEshNi8eGhtWTg7LRTU/lngTA3oEnxN+BVJbAguyl5hXaI1nzwBINz6+2bU5JaM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=GAXQFfhX; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2a0d52768ccso20106215ad.1
        for <kvm@vger.kernel.org>; Wed, 07 Jan 2026 15:22:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767828168; x=1768432968; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=saP6/ffuY5vMrIZ58eJfSyCX3/vEpiWaIFkpYUXoNxM=;
        b=GAXQFfhX4lYS4dDXDeqisMB/tp3e0mvbRXgxWENd18hxi/8XRREWzOC5nvu8ifWlof
         +vB3bqj6efZOMqSoTbOk/5eGI70B8wMj5lwbrDS6fz+5vQZEXCJ8FfFB6h8bAIr9MiCU
         zKyrU9r7mB0iqSA4QoxuLSxwSO6UdG4d03JofG4pPeXnFBDqxkiZGhTHq+3g/z2A5KZh
         Yxq3pTyOY2jGs/9LqQ+bym6G5uB9Q5Rx7c7JPIss51+wbczhzwHl8MBZlwyv4LaosW4y
         MAbuXcX6EKCQPY+q/eDznhFTjm3mpzPlBDGRzauJnnRYl6WPcg7/8YBD0629Z4PgcISU
         Tjlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767828168; x=1768432968;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=saP6/ffuY5vMrIZ58eJfSyCX3/vEpiWaIFkpYUXoNxM=;
        b=kaVmlAEfyexA/2EwAnDcJI+n7o+WOZ8Uskt2YuYCoqM+Y+5EUd+Uhr67e/8Ly9hqfW
         tAOIrzhVeqKR1defQymasZSbHfJhVYJ95c4/0T1ZWQOrNl6aecCMAqCfH+vYiwT59xyC
         gUTHuj0MYVEalceUTgemOn1RTx9AoKluJ0/NKDfwS/8NMyu+XearnHs/Ju9p4S+Vk578
         Dzmd3o+O83JkjkV3pcHjuEpWDrfhVgnOEodTjNuYtIu3vX/Ib4JtthJiYnb8aS+LerOH
         COBqjIePpMGr+hmpiYHji/jw/7M3yHvPKrMNpxrcHFt8mp080ch3zJZhOp6Jqrnp149q
         Y7KA==
X-Forwarded-Encrypted: i=1; AJvYcCUNEpUwr/ayfTeSjBolPSovcU/KYUruyTjuAtb5dOe0H1tswPBFxIIUEFCus33IRUfTpwA=@vger.kernel.org
X-Gm-Message-State: AOJu0YxkQSMT+jEWCxOsB1kU23J+xH+I4IU7OCWBaJXyhlIgVgQcTKV9
	BEvnbXXNbLBblLaD7kVtzZv9vk/6DUJHROKSIkXdvVJwFQYCmqFDrqVLV7LCZ7s+ag==
X-Gm-Gg: AY/fxX7ZSNyQEfSQN0INt4XVgQOVprxnXO9UzGZY6jMiki5loiiJ4CeSViZaJ2AQPzu
	TYF/13orLiA/EmMgbzWr7TQ5VN9X31vZ5Ja1WZUc5gMA1VbeLy3jlt2H4eYTZmzvvwn971e7V2c
	z0X4lg+AhRxKCF3Oq8RXCi0BqIrSn17lprV2nXPjTqRo/nSFxFPCADMT3XjBLj/P0zqEbrUVd9/
	fJk1EXdVEz2K34BgpZhN/nxN/dEMoWH3j5feN0ahEom19QDrbr1G1L2YtUInK1ka+BCaaZx2N8M
	kEvYsHQjRFqvmMYc0Eg6I+IDJVXFB0NyJNpXx3OkXF6c+H2uyGb2ud0p/TSSqo04ywLnO85H8UU
	ui7bfRZ3oXHRKn2frUSGIcl4MEK2lK3ElYG9k+iAgp42yHkSOYdsjOvdSRPptr/5g7+g1Ad9NXU
	J29sX1R7OqZDnx03QMlCnxMAYBRQirss1yxngcPPW2QVDP
X-Google-Smtp-Source: AGHT+IEeQtXwtbDk/5Dj++mTabOGSRVkMHVrEGiX/jNYeZkmyH74Mvo4NgMnBQYBuEFoUIpMSFsAnA==
X-Received: by 2002:a17:903:1a0c:b0:29e:e642:95d6 with SMTP id d9443c01a7336-2a3ee51f755mr41380695ad.59.1767828167431;
        Wed, 07 Jan 2026 15:22:47 -0800 (PST)
Received: from google.com (76.9.127.34.bc.googleusercontent.com. [34.127.9.76])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a3e3cc88e3sm59056525ad.75.2026.01.07.15.22.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jan 2026 15:22:46 -0800 (PST)
Date: Wed, 7 Jan 2026 23:22:42 +0000
From: David Matlack <dmatlack@google.com>
To: Raghavendra Rao Ananta <rananta@google.com>
Cc: Alex Williamson <alex@shazbot.org>,
	Alex Williamson <alex.williamson@redhat.com>,
	Josh Hilke <jrhilke@google.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 6/6] vfio: selftests: Add tests to validate SR-IOV UAPI
Message-ID: <aV7qwp4N_G6f_Bt7@google.com>
References: <20251210181417.3677674-1-rananta@google.com>
 <20251210181417.3677674-7-rananta@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251210181417.3677674-7-rananta@google.com>

On 2025-12-10 06:14 PM, Raghavendra Rao Ananta wrote:
> Add a selfttest, vfio_pci_sriov_uapi_test.c, to validate the
> SR-IOV UAPI, including the following cases, iterating over
> all the IOMMU modes currently supported:
>  - Setting correct/incorrect/NULL tokens during device init.
>  - Close the PF device immediately after setting the token.
>  - Change/override the PF's token after device init.
> 
> Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> ---
>  tools/testing/selftests/vfio/Makefile         |   1 +
>  .../selftests/vfio/vfio_pci_sriov_uapi_test.c | 215 ++++++++++++++++++
>  2 files changed, 216 insertions(+)
>  create mode 100644 tools/testing/selftests/vfio/vfio_pci_sriov_uapi_test.c
> 
> diff --git a/tools/testing/selftests/vfio/Makefile b/tools/testing/selftests/vfio/Makefile
> index 3c796ca99a509..f00a63902fbfb 100644
> --- a/tools/testing/selftests/vfio/Makefile
> +++ b/tools/testing/selftests/vfio/Makefile
> @@ -4,6 +4,7 @@ TEST_GEN_PROGS += vfio_iommufd_setup_test
>  TEST_GEN_PROGS += vfio_pci_device_test
>  TEST_GEN_PROGS += vfio_pci_device_init_perf_test
>  TEST_GEN_PROGS += vfio_pci_driver_test
> +TEST_GEN_PROGS += vfio_pci_sriov_uapi_test
>  
>  TEST_FILES += scripts/cleanup.sh
>  TEST_FILES += scripts/lib.sh
> diff --git a/tools/testing/selftests/vfio/vfio_pci_sriov_uapi_test.c b/tools/testing/selftests/vfio/vfio_pci_sriov_uapi_test.c
> new file mode 100644
> index 0000000000000..4c2951d6e049c
> --- /dev/null
> +++ b/tools/testing/selftests/vfio/vfio_pci_sriov_uapi_test.c
> @@ -0,0 +1,215 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +#include <fcntl.h>
> +#include <unistd.h>
> +#include <stdlib.h>
> +#include <sys/ioctl.h>
> +#include <linux/limits.h>
> +
> +#include <libvfio.h>
> +
> +#include "../kselftest_harness.h"
> +
> +#define UUID_1 "52ac9bff-3a88-4fbd-901a-0d767c3b6c97"
> +#define UUID_2 "88594674-90a0-47a9-aea8-9d9b352ac08a"
> +
> +static const char *pf_dev_bdf;

nit: I think you could simplify some of the names in this file. This
code isn't in a library so the names dont' have to be globally unique
and quite so long.

  s/pf_dev_bdf/pf_bdf/
  s/vf_dev_bdf/vf_bdf/
  s/pf_device/pf/
  s/vf_device/vf/
  s/test_vfio_pci_container_setup/container_setup/
  s/test_vfio_pci_iommufd_setup/iommufd_setup/
  s/test_vfio_pci_device_init/device_init/
  s/test_vfio_pci_device_cleanup/device_cleanup/

Feel free to ignore this though if you think it makes the names too
terse.

> +
> +static int test_vfio_pci_container_setup(struct vfio_pci_device *device,
> +					 const char *bdf,
> +					 const char *vf_token)
> +{
> +	vfio_pci_group_setup(device, bdf);
> +	vfio_container_set_iommu(device);
> +	__vfio_pci_group_get_device_fd(device, bdf, vf_token);
> +
> +	/* The device fd will be -1 in case of mismatched tokens */
> +	return (device->fd < 0);
> +}
> +
> +static int test_vfio_pci_iommufd_setup(struct vfio_pci_device *device,
> +				       const char *bdf, const char *vf_token)
> +{
> +	vfio_pci_iommufd_cdev_open(device, bdf);
> +	return __vfio_device_bind_iommufd(device->fd,
> +					  device->iommu->iommufd, vf_token);
> +}
> +
> +static struct vfio_pci_device *test_vfio_pci_device_init(const char *bdf,
> +							 struct iommu *iommu,
> +							 const char *vf_token,
> +							 int *out_ret)
> +{
> +	struct vfio_pci_device *device;
> +
> +	device = calloc(1, sizeof(*device));
> +	VFIO_ASSERT_NOT_NULL(device);
> +
> +	device->iommu = iommu;
> +	device->bdf = bdf;

Can you put this in a helper exposed by vfio_pci_device.h? e.g.
vfio_pci_device_alloc()

> +
> +	if (iommu->mode->container_path)
> +		*out_ret = test_vfio_pci_container_setup(device, bdf, vf_token);
> +	else
> +		*out_ret = test_vfio_pci_iommufd_setup(device, bdf, vf_token);
> +
> +	return device;
> +}
> +
> +static void test_vfio_pci_device_cleanup(struct vfio_pci_device *device)
> +{
> +	if (device->fd > 0)
> +		VFIO_ASSERT_EQ(close(device->fd), 0);
> +
> +	if (device->group_fd)
> +		VFIO_ASSERT_EQ(close(device->group_fd), 0);
> +
> +	free(device);
> +}
> +
> +FIXTURE(vfio_pci_sriov_uapi_test) {
> +	char vf_dev_bdf[16];
> +	char vf_driver[32];
> +	bool sriov_drivers_autoprobe;
> +};
> +
> +FIXTURE_SETUP(vfio_pci_sriov_uapi_test)
> +{
> +	int nr_vfs;
> +	int ret;
> +
> +	nr_vfs = sysfs_get_sriov_totalvfs(pf_dev_bdf);
> +	if (nr_vfs < 0)
> +		SKIP(return, "SR-IOV may not be supported by the device\n");

Should this be <= 0?

And replace "the device" with the BDF.

> +
> +	nr_vfs = sysfs_get_sriov_numvfs(pf_dev_bdf);
> +	if (nr_vfs != 0)
> +		SKIP(return, "SR-IOV already configured for the PF\n");

Let's print the BDF and nr_vfs for the user.

> +
> +	self->sriov_drivers_autoprobe =
> +		sysfs_get_sriov_drivers_autoprobe(pf_dev_bdf);
> +	if (self->sriov_drivers_autoprobe)
> +		sysfs_set_sriov_drivers_autoprobe(pf_dev_bdf, 0);
> +
> +	/* Export only one VF for testing */

s/Export/Create/

> +	sysfs_set_sriov_numvfs(pf_dev_bdf, 1);
> +
> +	sysfs_get_sriov_vf_bdf(pf_dev_bdf, 0, self->vf_dev_bdf);
> +	if (sysfs_get_driver(self->vf_dev_bdf, self->vf_driver) == 0)
> +		sysfs_unbind_driver(self->vf_dev_bdf, self->vf_driver);

This should be impossible since we disabled autoprobing.

> +	sysfs_bind_driver(self->vf_dev_bdf, "vfio-pci");

Some devices also require setting driver_override to "vfio-pci" as well
so the device can be bound to vfio-pci. Let's just do that
unconditionally.

> +}
> +
> +FIXTURE_TEARDOWN(vfio_pci_sriov_uapi_test)
> +{
> +	sysfs_unbind_driver(self->vf_dev_bdf, "vfio-pci");
> +	sysfs_bind_driver(self->vf_dev_bdf, self->vf_driver);
> +	sysfs_set_sriov_numvfs(pf_dev_bdf, 0);
> +	sysfs_set_sriov_drivers_autoprobe(pf_dev_bdf,
> +					  self->sriov_drivers_autoprobe);
> +}
> +
> +FIXTURE_VARIANT(vfio_pci_sriov_uapi_test) {
> +	const char *iommu_mode;
> +	char *vf_token;
> +};
> +
> +#define FIXTURE_VARIANT_ADD_IOMMU_MODE(_iommu_mode, _name, _vf_token)		\
> +FIXTURE_VARIANT_ADD(vfio_pci_sriov_uapi_test, _iommu_mode ## _ ## _name) {	\
> +	.iommu_mode = #_iommu_mode,						\
> +	.vf_token = (_vf_token),						\
> +}
> +
> +FIXTURE_VARIANT_ADD_ALL_IOMMU_MODES(same_uuid, UUID_1);
> +FIXTURE_VARIANT_ADD_ALL_IOMMU_MODES(diff_uuid, UUID_2);
> +FIXTURE_VARIANT_ADD_ALL_IOMMU_MODES(null_uuid, NULL);
> +
> +/*
> + * PF's token is always set with UUID_1 and VF's token is rotated with
> + * various tokens (including UUID_1 and NULL).
> + * This asserts if the VF device is successfully created for a match
> + * in the token or actually fails during a mismatch.
> + */
> +#define ASSERT_VF_CREATION(_ret) do {					\
> +	if (!variant->vf_token || strcmp(UUID_1, variant->vf_token)) {	\
> +		ASSERT_NE((_ret), 0);					\
> +	} else {							\
> +		ASSERT_EQ((_ret), 0);					\
> +	}								\
> +} while (0)
> +
> +/*
> + * Validate if the UAPI handles correctly and incorrectly set token on the VF.
> + */
> +TEST_F(vfio_pci_sriov_uapi_test, init_token_match)
> +{
> +	struct vfio_pci_device *pf_device;
> +	struct vfio_pci_device *vf_device;
> +	struct iommu *iommu;
> +	int ret;
> +
> +	iommu = iommu_init(variant->iommu_mode);
> +	pf_device = test_vfio_pci_device_init(pf_dev_bdf, iommu, UUID_1, &ret);
> +	vf_device = test_vfio_pci_device_init(self->vf_dev_bdf, iommu,
> +					      variant->vf_token, &ret);
> +
> +	ASSERT_VF_CREATION(ret);
> +
> +	test_vfio_pci_device_cleanup(vf_device);
> +	test_vfio_pci_device_cleanup(pf_device);
> +	iommu_cleanup(iommu);
> +}
> +
> +/*
> + * After setting a token on the PF, validate if the VF can still set the
> + * expected token.
> + */
> +TEST_F(vfio_pci_sriov_uapi_test, pf_early_close)
> +{
> +	struct vfio_pci_device *pf_device;
> +	struct vfio_pci_device *vf_device;
> +	struct iommu *iommu;
> +	int ret;
> +
> +	iommu = iommu_init(variant->iommu_mode);
> +	pf_device = test_vfio_pci_device_init(pf_dev_bdf, iommu, UUID_1, &ret);
> +	test_vfio_pci_device_cleanup(pf_device);
> +
> +	vf_device = test_vfio_pci_device_init(self->vf_dev_bdf, iommu,
> +					      variant->vf_token, &ret);
> +
> +	ASSERT_VF_CREATION(ret);
> +
> +	test_vfio_pci_device_cleanup(vf_device);
> +	iommu_cleanup(iommu);
> +}
> +
> +/*
> + * After PF device init, override the existing token and validate if the newly
> + * set token is the one that's active.
> + */
> +TEST_F(vfio_pci_sriov_uapi_test, override_token)
> +{
> +	struct vfio_pci_device *pf_device;
> +	struct vfio_pci_device *vf_device;
> +	struct iommu *iommu;
> +	int ret;
> +
> +	iommu = iommu_init(variant->iommu_mode);
> +	pf_device = test_vfio_pci_device_init(pf_dev_bdf, iommu, UUID_2, &ret);
> +	vfio_device_set_vf_token(pf_device->fd, UUID_1);
> +
> +	vf_device = test_vfio_pci_device_init(self->vf_dev_bdf, iommu,
> +					      variant->vf_token, &ret);
> +
> +	ASSERT_VF_CREATION(ret);
> +
> +	test_vfio_pci_device_cleanup(vf_device);
> +	test_vfio_pci_device_cleanup(pf_device);
> +	iommu_cleanup(iommu);
> +}
> +
> +int main(int argc, char *argv[])
> +{
> +	pf_dev_bdf = vfio_selftests_get_bdf(&argc, argv);
> +	return test_harness_run(argc, argv);
> +}
> -- 
> 2.52.0.239.gd5f0c6e74e-goog
> 

