Return-Path: <kvm+bounces-67300-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id B81D9D005B4
	for <lists+kvm@lfdr.de>; Wed, 07 Jan 2026 23:57:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id C687A3041CF9
	for <lists+kvm@lfdr.de>; Wed,  7 Jan 2026 22:56:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 691E12E7F11;
	Wed,  7 Jan 2026 22:56:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="2HYEKkFR"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A645C8CE
	for <kvm@vger.kernel.org>; Wed,  7 Jan 2026 22:56:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767826610; cv=none; b=ALJULYiNW+6CMEFHg6jMx4tRck0ubVeXKJTVeTEhl8+KnJb3IFz9mT3NHP9PSqq77mo9NQ2/+PTBdIS5YyfdI/x5MWiGmYKybwjsHd0HwHuCrY27Mft836+uL5dvgQCQ18GM7j6JkVhN0s+g5briyeXX0GRZfhWhvHdVsk8vbb0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767826610; c=relaxed/simple;
	bh=bEYOmVLd9MHdfQFuuqXOyhw/mjVfgExIaPCZ914sOTM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rO6jCUK8ZyJ0+cqFNIfV9rK0XPw81gnindgpbVO5V4HkMZmfNp8GOkARIIYbOz9z6On0zNLHd7MuSdpaABCe+1/jwirM4nCZE//WIzQdwl5Z7yS2JEoJSp9/OeerxKqbH0GgBj9Kc3Ku45zxx63212nmllj7+uUFo2Txv//hhZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=2HYEKkFR; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2a0bb2f093aso20411095ad.3
        for <kvm@vger.kernel.org>; Wed, 07 Jan 2026 14:56:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767826608; x=1768431408; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=OJWhiDr1D/MjKYOeKl4sbtvtGhgARkJ8AAhcCNlROuw=;
        b=2HYEKkFRI0fMhnjAztr3aa/vbSOzJtxu9K+TlhxhkQI1TCEqsvOadXy4LtkDpZ9Kg4
         DzBmPuTNT0JbVCQXXhSA9MqgwUqC14ATtBOD4evuABRXZnAGPodoXHrh1iU5V0LDBWzS
         56M9BYd94l1DOeWJqaADcSTfvCDWY4WeyR3ebXCeAiFJ01E7KBiavYEjuKuaSGQqaeFK
         LTLY+A9AzQ79+HsBpEZ0xBatp6YJ1IJ48MDoUNwprU5kF3lKlcMGtQeu3fyuFCQ5gV+a
         ZJuzrAMF+nL1PZouFMQwbJqXAvmGa0PXbIbC7HE6vxu75U6Co9cwhNpJMuOqduWEpKMW
         +LCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767826608; x=1768431408;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OJWhiDr1D/MjKYOeKl4sbtvtGhgARkJ8AAhcCNlROuw=;
        b=VDZZr9aiB/57XvBZxcD5i0JV7/SifJCbR/LAhUw4biFvrlI4K3+rKgZwuJ2aq3U0Yy
         3ARrf1Ihs2bcSNX/k2V3G3mGSU7m5K9RKFx5f3zXrU23N23YtzRNA/DhMTDFS6PnmyYD
         kr+qwKyagh76Mewvy8JHGl6jE0jEgc1emu5TzcpyWLwksZFjVzH0v3ttrov3VdSP1m5M
         90YK1w/d07xZrm6IPaLZFYUX4XAWI/KXXoed3u6JtV/8azcSuMDhdeohgisY3XLG+kNb
         KmgoLDTnxtBHMaV5kSTK5fJFwLTUA30e2N3onLItGMiWKkNeSJAJrqQGYRflZt8JkvQL
         d8PA==
X-Forwarded-Encrypted: i=1; AJvYcCV47P9kvJsran3PM6l/0Z29GCiXgqByc1iPgPHKFHaXAWlm4WnZiB4qdjEwK4kJmdeqMjg=@vger.kernel.org
X-Gm-Message-State: AOJu0YwQGv1qi5fcslRUx7Bo7g6qSq5nWfoNxdZivNKl77YaATTRJ1Qo
	LQKXMF1jTfB8JaEVHALtxLv09wS1YT4io7vt5rxEVqwHURPnTXU4WNuE1ktAy3JTGg==
X-Gm-Gg: AY/fxX6n5K8+2STzzO4njW1FTobs5qy9JVwPKX9anbGqAShEj0CKrcX7gxaC/3UE2oo
	XSwDUtsC1RyfIvyZsjVNwhxy/IHnZ/exWXF1wBXktavo1kBTYVIH2uALSiwiF5pK6Tlx42bvn00
	+8E7RNN1mwIHfN3i7jucvqkpTF8Wimq8pn3G3A8C0Igi4YxmGYoXtS/PLt7kFpSay6BInxAXfJT
	QC5UZ4dYMzF8ShZX3X2h285gBgrSqnJM/Bcs0YDYhOeA5COc2nNWnbgQvJQK+hBBtgkCk/PZle5
	x2x4BAO0G1t6CVDNOINnYx1/qwDe4Dbn3VfceFjKttqW0DhHva6yHoIWFiDpD46sJGXdnYtbVz5
	dz4r6ewfGcGdBDdypL898HRo5DIw26uCbL3pT6xGN8qm7hTnvagdfOqi+4MbDyei2xODSXUC7F7
	dFJwtumYNlOE1Di0ycPKAQBjZQE9IMvrtLGq5OMmFKLh3h
X-Google-Smtp-Source: AGHT+IGTO1J6jb7GfhJzC/ulE53OgZ6VBQ1OD1qXgBdMMZajR7PmSbIPCZczcXxLi7aVbnzz0qLzpg==
X-Received: by 2002:a17:903:41c2:b0:2a0:d149:5d0f with SMTP id d9443c01a7336-2a3ee445ba7mr34360365ad.17.1767826607972;
        Wed, 07 Jan 2026 14:56:47 -0800 (PST)
Received: from google.com (76.9.127.34.bc.googleusercontent.com. [34.127.9.76])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a3e3c48c15sm58685025ad.27.2026.01.07.14.56.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jan 2026 14:56:47 -0800 (PST)
Date: Wed, 7 Jan 2026 22:56:43 +0000
From: David Matlack <dmatlack@google.com>
To: Raghavendra Rao Ananta <rananta@google.com>
Cc: Alex Williamson <alex@shazbot.org>,
	Alex Williamson <alex.williamson@redhat.com>,
	Josh Hilke <jrhilke@google.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 5/6] vfio: selftests: Add helper to set/override a
 vf_token
Message-ID: <aV7kq76DYIx8aNVv@google.com>
References: <20251210181417.3677674-1-rananta@google.com>
 <20251210181417.3677674-6-rananta@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251210181417.3677674-6-rananta@google.com>

On 2025-12-10 06:14 PM, Raghavendra Rao Ananta wrote:
> Add a helper function, vfio_device_set_vf_token(), to set or override a
> vf_token. Not only at init, but a vf_token can also be set via the
> VFIO_DEVICE_FEATURE ioctl, by setting the
> VFIO_DEVICE_FEATURE_PCI_VF_TOKEN flag. Hence, add an API to utilize this
> functionality from the test code. The subsequent commit will use this to
> test the functionality of this method to set the vf_token.
> 
> Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> ---
>  .../lib/include/libvfio/vfio_pci_device.h     |  2 ++
>  .../selftests/vfio/lib/vfio_pci_device.c      | 34 +++++++++++++++++++
>  2 files changed, 36 insertions(+)
> 
> diff --git a/tools/testing/selftests/vfio/lib/include/libvfio/vfio_pci_device.h b/tools/testing/selftests/vfio/lib/include/libvfio/vfio_pci_device.h
> index 6186ca463ca6e..b370aa6a74d0b 100644
> --- a/tools/testing/selftests/vfio/lib/include/libvfio/vfio_pci_device.h
> +++ b/tools/testing/selftests/vfio/lib/include/libvfio/vfio_pci_device.h
> @@ -129,4 +129,6 @@ void vfio_container_set_iommu(struct vfio_pci_device *device);
>  void vfio_pci_iommufd_cdev_open(struct vfio_pci_device *device, const char *bdf);
>  int __vfio_device_bind_iommufd(int device_fd, int iommufd, const char *vf_token);
>  
> +void vfio_device_set_vf_token(int fd, const char *vf_token);
> +
>  #endif /* SELFTESTS_VFIO_LIB_INCLUDE_LIBVFIO_VFIO_PCI_DEVICE_H */
> diff --git a/tools/testing/selftests/vfio/lib/vfio_pci_device.c b/tools/testing/selftests/vfio/lib/vfio_pci_device.c
> index 208da2704d9e2..7725ecc62b024 100644
> --- a/tools/testing/selftests/vfio/lib/vfio_pci_device.c
> +++ b/tools/testing/selftests/vfio/lib/vfio_pci_device.c
> @@ -109,6 +109,40 @@ static void vfio_pci_irq_get(struct vfio_pci_device *device, u32 index,
>  	ioctl_assert(device->fd, VFIO_DEVICE_GET_IRQ_INFO, irq_info);
>  }
>  
> +static int vfio_device_feature_ioctl(int fd, u32 flags, void *data,
> +				     size_t data_size)
> +{
> +	u8 buffer[sizeof(struct vfio_device_feature) + data_size] = {};
> +	struct vfio_device_feature *feature = (void *)buffer;
> +
> +	memcpy(feature->data, data, data_size);
> +
> +	feature->argsz = sizeof(buffer);
> +	feature->flags = flags;
> +
> +	return ioctl(fd, VFIO_DEVICE_FEATURE, feature);
> +}
> +
> +static void vfio_device_feature_set(int fd, u16 feature, void *data, size_t data_size)
> +{
> +	u32 flags = VFIO_DEVICE_FEATURE_SET | feature;
> +	int ret;
> +
> +	ret = vfio_device_feature_ioctl(fd, flags, data, data_size);
> +	VFIO_ASSERT_EQ(ret, 0, "Failed to set feature %u\n", feature);
> +}
> +
> +void vfio_device_set_vf_token(int fd, const char *vf_token)
> +{
> +	uuid_t token_uuid = {0};
> +
> +	VFIO_ASSERT_NOT_NULL(vf_token, "vf_token is NULL");
> +	VFIO_ASSERT_EQ(uuid_parse(vf_token, token_uuid), 0);
> +
> +	vfio_device_feature_set(fd, VFIO_DEVICE_FEATURE_PCI_VF_TOKEN,
> +				token_uuid, sizeof(uuid_t));
> +}

Would it be useful to have a variant that returns an int for negative
testing?

> +
>  static void vfio_pci_region_get(struct vfio_pci_device *device, int index,
>  				struct vfio_region_info *info)
>  {
> -- 
> 2.52.0.239.gd5f0c6e74e-goog
> 

