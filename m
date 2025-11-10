Return-Path: <kvm+bounces-62599-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 508CFC49793
	for <lists+kvm@lfdr.de>; Mon, 10 Nov 2025 23:04:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id C95E634BADE
	for <lists+kvm@lfdr.de>; Mon, 10 Nov 2025 22:04:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 98F8D2F7444;
	Mon, 10 Nov 2025 22:04:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Th+o4/P/"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DE6628980A
	for <kvm@vger.kernel.org>; Mon, 10 Nov 2025 22:04:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762812241; cv=none; b=TFlMCvZfpTU/sys/zMlB5i1l947MB5DRyR+OYJ0blq04Bz2QEGJ1+lsCDOCjynwlX2L8LFxzC0yioFIarG1izQXDVONtys2lCH+lQoCsbhvwsbECAxP7p/TmXIXZsK3UKkQg/CNphCvrU8xZaaHCg9l9pbR8fAm/zSarPuisUaI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762812241; c=relaxed/simple;
	bh=W/+Qb13fLuIC+pUVsrfpojLJCEkS1lN/GKOP++Gtp9A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qqIDCfBe1i1JggPzJySS8ltIh4LRMeBJ3GwyPIB5CeF/BfoYeVXJnSpCkMHbd0M07AuAbvW//mFeyr3lJi7b6ZwcO9J9Z3lYmatXUyIhwxIeuucKxTr/9GTMBmWNXz42Oo+eA9aQ8VykYupHBEQ/ivaShIPx3DWFi8e44ps8GWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Th+o4/P/; arc=none smtp.client-ip=209.85.210.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-7ae4656d6e4so4283711b3a.1
        for <kvm@vger.kernel.org>; Mon, 10 Nov 2025 14:04:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762812239; x=1763417039; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=zhck2YVv24x1Tq6SL/L5kEfr8DPVNBJogPUSyg2Wx54=;
        b=Th+o4/P//bDKiz9NLRI23QbRXf6Jc1voFKAX0PDAn2iWqxCxrUlRHUgNQfNirMTbtS
         kT9y483e/32sCiQDcelfHtUS45H8ovDLzmKmaCTujp3Q0bPEFDQNkdDBE5pfeKpj7p+v
         WdPqmfzD6j09lrWrZRmR58rUFePaiRuYrmFwnAzcqRzxQGlgfQMVoCcmeil65IylSFax
         HQ/wlZ1z/N7GwVtW8NUktXg1UQ9SayuJuQR7arqMMoNiT1vjIAb3A/+AofZ3kGtsIQne
         5kTA6xU2ypyRm7EsyDKPAh7GaLAFQQHtptW9mD+vXZvUvXecuil8zmMmVANMLL0e/PHd
         6Ixw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762812239; x=1763417039;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zhck2YVv24x1Tq6SL/L5kEfr8DPVNBJogPUSyg2Wx54=;
        b=ZfSmJs2WOQMmM9bRojdso9JMDtofSwfCzbX9URmKplcYjIMmuuQ6ZS1ywwhppvM3N3
         F7JxCJlOJnOl3ExBa2l3HDvca1CWOMnRnL/whA/BvetJh98bEwElsWLWZ5D0m+2sPeCc
         8ZGPLQZZxXRQ3E4GAgbYBM9sMlqEzYglvFnBB33SNUdJY/no/RWY61Qet98ic5jEzfSV
         JUnRUpOqz1yOQmhZry9rKlWthNYK4VKRHXlbXGy7xJTUZ2aRCSpiT/+0JAM9nMy/Z/jG
         U6MJif7qK3t9AlgSNG9Hpqro4nSMfOU1BoB7KrDkqTohTXl22MPmYuBKrJhfX+yEaaVM
         Kxfw==
X-Forwarded-Encrypted: i=1; AJvYcCWpCGlLeaSRANwYAf23bAnyW+vD72pBaXW9KlkJ5H0AIRlBqy3a/3pvSPeWRJbi9oIfG/E=@vger.kernel.org
X-Gm-Message-State: AOJu0YzV5EAU2BfQ3Lgveg9VwR9vWxxnPbfffTql4M+4j+keAlYUmUpE
	ZkOG1XDIJXT1q7+mieCbDVA2XZQQh3OGTlyeOk2lFy1jvJ+7OrEqVoIpOeziQ9t14w==
X-Gm-Gg: ASbGnctVh3Fz01QyOzATJGv2gZxVrwt/JCC0q4GWAJvljBA2h9cKn21ruA19G64P8qq
	A0oiEqIJL2Z1j3Eh9KED1k+cuStXxektYnpK6pWPtuLQIixoegHJJ/Zj6v/vNE0UQK6Z5XZuMY+
	ENKCM0VSRMXHGprAMPgAIueZwFbOdXjm9hlraJDH43N2eFeaP9lrzRVl1z03d1pTPr35NoAPRLK
	fq34tq0w79LhP5fQt9hEWF1d3CM/pmaThnjuRa0gs8Rbh8TceCZR31H23oSviTHxN97rt3wMiHE
	0Cd2w1P02vznVrhu9YH+4Sy/UPpcGhco253mTJ5RgDrocD6bE2VEZG53SlWv+JjCRTjjo5lfo/d
	eaxt05S99rkCHj2jn5kEHoV+SEZHFmbglyjG251uanvs4n8aKIBlD802OYFecjdO+/vH1r5H6Kl
	FkLf52ezCpJa57cP7sj1ejxhJ9s1csvZ4lMRoZ4mAAlSZiiTSkmedbzXCZ3N983mU=
X-Google-Smtp-Source: AGHT+IGLIV/g6MCRKuipubTB9GVYmkpYIEQQohBhRaIhOj/Ez+CYSKMkODJsxMq554gdnbdi8bX1Mw==
X-Received: by 2002:a05:6a00:1892:b0:7ab:4fce:fa1b with SMTP id d2e1a72fcca58-7b225adc01fmr11346982b3a.4.1762812239386;
        Mon, 10 Nov 2025 14:03:59 -0800 (PST)
Received: from google.com (132.200.185.35.bc.googleusercontent.com. [35.185.200.132])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7b0cc179f77sm12733156b3a.34.2025.11.10.14.03.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Nov 2025 14:03:58 -0800 (PST)
Date: Mon, 10 Nov 2025 22:03:54 +0000
From: David Matlack <dmatlack@google.com>
To: Alex Mastro <amastro@fb.com>
Cc: Alex Williamson <alex@shazbot.org>, Shuah Khan <shuah@kernel.org>,
	kvm@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org, Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH 1/4] vfio: selftests: add iova range query helpers
Message-ID: <aRJhSkj6S48G_pHI@google.com>
References: <20251110-iova-ranges-v1-0-4d441cf5bf6d@fb.com>
 <20251110-iova-ranges-v1-1-4d441cf5bf6d@fb.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251110-iova-ranges-v1-1-4d441cf5bf6d@fb.com>

On 2025-11-10 01:10 PM, Alex Mastro wrote:
> +/*
> + * Return iova ranges for the device's container. Normalize vfio_iommu_type1 to
> + * report iommufd's iommu_iova_range. Free with free().
> + */
> +static struct iommu_iova_range *vfio_iommu_iova_ranges(struct vfio_pci_device *device,
> +						       size_t *nranges)
> +{
> +	struct vfio_iommu_type1_info_cap_iova_range *cap_range;
> +	struct vfio_iommu_type1_info *buf;

nit: Maybe name this variable `info` here and in vfio_iommu_info_buf()
and vfio_iommu_info_cap_hdr()? It is not an opaque buffer.

> +	struct vfio_info_cap_header *hdr;
> +	struct iommu_iova_range *ranges = NULL;
> +
> +	buf = vfio_iommu_info_buf(device);

nit: How about naming this vfio_iommu_get_info() since it actually
fetches the info from VFIO? (It doesn't just allocate a buffer.)

> +	VFIO_ASSERT_NOT_NULL(buf);

This assert is unnecessary.

> +
> +	hdr = vfio_iommu_info_cap_hdr(buf, VFIO_IOMMU_TYPE1_INFO_CAP_IOVA_RANGE);
> +	if (!hdr)
> +		goto free_buf;

Is this to account for running on old versions of VFIO? Or are there
some scenarios when VFIO can't report the list of IOVA ranges?

> +
> +	cap_range = container_of(hdr, struct vfio_iommu_type1_info_cap_iova_range, header);
> +	if (!cap_range->nr_iovas)
> +		goto free_buf;
> +
> +	ranges = malloc(cap_range->nr_iovas * sizeof(*ranges));
> +	VFIO_ASSERT_NOT_NULL(ranges);
> +
> +	for (u32 i = 0; i < cap_range->nr_iovas; i++) {
> +		ranges[i] = (struct iommu_iova_range){
> +			.start = cap_range->iova_ranges[i].start,
> +			.last = cap_range->iova_ranges[i].end,
> +		};
> +	}
> +
> +	*nranges = cap_range->nr_iovas;
> +
> +free_buf:
> +	free(buf);
> +	return ranges;
> +}
> +
> +/* Return iova ranges of the device's IOAS. Free with free() */
> +struct iommu_iova_range *iommufd_iova_ranges(struct vfio_pci_device *device,
> +					     size_t *nranges)
> +{
> +	struct iommu_iova_range *ranges;
> +	int ret;
> +
> +	struct iommu_ioas_iova_ranges query = {
> +		.size = sizeof(query),
> +		.ioas_id = device->ioas_id,
> +	};
> +
> +	ret = ioctl(device->iommufd, IOMMU_IOAS_IOVA_RANGES, &query);
> +	VFIO_ASSERT_EQ(ret, -1);
> +	VFIO_ASSERT_EQ(errno, EMSGSIZE);
> +	VFIO_ASSERT_GT(query.num_iovas, 0);
> +
> +	ranges = malloc(query.num_iovas * sizeof(*ranges));
> +	VFIO_ASSERT_NOT_NULL(ranges);
> +
> +	query.allowed_iovas = (uintptr_t)ranges;
> +
> +	ioctl_assert(device->iommufd, IOMMU_IOAS_IOVA_RANGES, &query);
> +	*nranges = query.num_iovas;
> +
> +	return ranges;
> +}
> +
> +struct iommu_iova_range *vfio_pci_iova_ranges(struct vfio_pci_device *device,
> +					      size_t *nranges)

nit: Both iommufd and VFIO represent the number of IOVA ranges as a u32.
Perhaps we should do the same in VFIO selftests?

