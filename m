Return-Path: <kvm+bounces-6410-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0D95C830EAB
	for <lists+kvm@lfdr.de>; Wed, 17 Jan 2024 22:34:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B97902823B6
	for <lists+kvm@lfdr.de>; Wed, 17 Jan 2024 21:34:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 888722562B;
	Wed, 17 Jan 2024 21:34:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Z5HjRR86"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3318225621
	for <kvm@vger.kernel.org>; Wed, 17 Jan 2024 21:34:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705527266; cv=none; b=U3z63W82cpkjq3nxmllRNGMKn2/gmvvu6JitHprEcKIRgd6l71zvhrN4sbl3jIxi0Oq3jp7iQjVq534wqHc2tZPW36l9Xqojc6mkwHJExy3SW1ybXkj+aAcmGj3ow0qOg/d9BjOzFKwzI+do+0ds2Q6bz+9LMN6ZLLxZCdpSBeY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705527266; c=relaxed/simple;
	bh=yKFL3U0ucTT7ccDTPkWssK1XjF/G3m6zhD25FG7kZvk=;
	h=DKIM-Signature:Received:X-MC-Unique:Received:
	 X-Google-DKIM-Signature:X-Gm-Message-State:X-Received:
	 X-Google-Smtp-Source:X-Received:Received:Date:From:To:Cc:Subject:
	 Message-ID:In-Reply-To:References:X-Mailer:MIME-Version:
	 Content-Type:Content-Transfer-Encoding; b=Zh0pEX6zffaoKnLRS4q6zyYmp1ReLAx9yub18xkvWvyLKpmOQfR9FT9ISi5+8A3pgi2ozCdMC2UOKDdMqIlN1OYf4wGoamuAZnw1pSwChX/a89ovj9USLhMGh464kze12w3ghrR72IOWgpbetDQMTl2pU5yWhszqKMWfQK0gv0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Z5HjRR86; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1705527264;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=503l6S460toHyonsq12VcMMml/sPGb5kqwdWGMCKzPM=;
	b=Z5HjRR86V4OmWFk+igq+WFZoJjGU07b1R2qS0U3zFLActEVo1cdRvQCs8xUkfDaSpiyzXj
	aoFQTe6SuI1WQtrCv6ubMZau7pIN5doWQK6O0qIY9+piuYHtOdsUPK+O3S1Dlr9KmyjvYc
	Q576j83CTkVct5dfmX9/MImnS5jiYKA=
Received: from mail-ot1-f71.google.com (mail-ot1-f71.google.com
 [209.85.210.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-8-fUQPMO5cO-OTd1P_AH7ekw-1; Wed, 17 Jan 2024 16:34:22 -0500
X-MC-Unique: fUQPMO5cO-OTd1P_AH7ekw-1
Received: by mail-ot1-f71.google.com with SMTP id 46e09a7af769-6dde6d74d57so9876115a34.0
        for <kvm@vger.kernel.org>; Wed, 17 Jan 2024 13:34:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705527261; x=1706132061;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=503l6S460toHyonsq12VcMMml/sPGb5kqwdWGMCKzPM=;
        b=Zgrbwk87/axl3nS9gIjdkxgC8/SYV9g9e6lORkNI0VSvQKf+r53hWT+FmJMht1o7+p
         AwXZlvDCEZv+tX9ksEBJfCzQmpZKKXhWGDYC6VMmJgGpUptnb7tUXA1rleiVxgndDzLz
         hjoKn1LQ4X46EMzNVlm25kaIKWPe+yHoC0ssjr70AVgk+QQ5h269e/MGr1I7H5fxc4Y2
         hz3oV3nLozkLIBc0OZiGiNSGC5/vKjRzekkF+iw29/G1tTbfGlCQc747s6bQet+XrE4d
         FejywiLDX3UTRn7iDa6vlbXbRhdu7JWUTeYiv0BqQmRmc9FfxICxa1H6kj73AdqARrCN
         7s/A==
X-Gm-Message-State: AOJu0YxPWoUphp3OIw111/ZI/UmtV61/XVQD2BQezqOQMiBfsUudURsm
	zR10fTBZJHr9A+h9swADQE/ZJ9QC6FbQfyfuEBx2x+MdfvMZ0FIWZDA8hypy14OcaF4n1RcLBqC
	4gUU9bQyaBVdKYpD+RFJq
X-Received: by 2002:a9d:5f0f:0:b0:6e0:acf2:f041 with SMTP id f15-20020a9d5f0f000000b006e0acf2f041mr8359038oti.7.1705527261841;
        Wed, 17 Jan 2024 13:34:21 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFkkNhph9xnzbIqzHj5cxQhQU2TNdH9OIcZiD7SK7GKOqiaaL7d8d8JUODLQYBFoQZZywNZSQ==
X-Received: by 2002:a9d:5f0f:0:b0:6e0:acf2:f041 with SMTP id f15-20020a9d5f0f000000b006e0acf2f041mr8359027oti.7.1705527261615;
        Wed, 17 Jan 2024 13:34:21 -0800 (PST)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id g3-20020a9d6483000000b006d7eaaa65a4sm38157otl.71.2024.01.17.13.34.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Jan 2024 13:34:20 -0800 (PST)
Date: Wed, 17 Jan 2024 14:34:18 -0700
From: Alex Williamson <alex.williamson@redhat.com>
To: <ankita@nvidia.com>
Cc: <jgg@nvidia.com>, <yishaih@nvidia.com>,
 <shameerali.kolothum.thodi@huawei.com>, <kevin.tian@intel.com>,
 <eric.auger@redhat.com>, <brett.creeley@amd.com>, <horms@kernel.org>,
 <aniketa@nvidia.com>, <cjia@nvidia.com>, <kwankhede@nvidia.com>,
 <targupta@nvidia.com>, <vsethi@nvidia.com>, <acurrid@nvidia.com>,
 <apopple@nvidia.com>, <jhubbard@nvidia.com>, <danw@nvidia.com>,
 <anuaggarwal@nvidia.com>, <mochs@nvidia.com>, <kvm@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v16 2/3] vfio/pci: implement range_intesect_range to
 determine range overlap
Message-ID: <20240117143418.5696b00e.alex.williamson@redhat.com>
In-Reply-To: <20240115211516.635852-3-ankita@nvidia.com>
References: <20240115211516.635852-1-ankita@nvidia.com>
	<20240115211516.635852-3-ankita@nvidia.com>
X-Mailer: Claws Mail 4.2.0 (GTK 3.24.38; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 15 Jan 2024 21:15:15 +0000
<ankita@nvidia.com> wrote:

> From: Ankit Agrawal <ankita@nvidia.com>
> 
> Add a helper function to determine an overlap between two ranges.
> If an overlap, the function returns the overlapping offset and size.
> 
> The VFIO PCI variant driver emulates the PCI config space BAR offset
> registers. These offset may be accessed for read/write with a variety
> of lengths including sub-word sizes from sub-word offsets. The driver
> makes use of this helper function to read/write the targeted part of
> the emulated register.
> 
> This is replicated from Yishai's work in
> https://lore.kernel.org/all/20231207102820.74820-10-yishaih@nvidia.com

The virtio-vfio-net changes have been accepted, so this will need to be
rebased on the vfio next branch or v6.8-rc1 when Linus comes back
online to process the pull request.  The revised patch should
consolidate so that virtio-vfio-pci also uses the new shared function.

As noted by Rahul, the name should be updated to align with the
vfio-pci-core namespace.  Kerneldoc would also be a nice addition since
this is a somewhat complicated helper.  Thanks,

Alex

> Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
> Tested-by: Ankit Agrawal <ankita@nvidia.com>
> ---
>  drivers/vfio/pci/vfio_pci_config.c | 28 ++++++++++++++++++++++++++++
>  include/linux/vfio_pci_core.h      |  6 ++++++
>  2 files changed, 34 insertions(+)
> 
> diff --git a/drivers/vfio/pci/vfio_pci_config.c b/drivers/vfio/pci/vfio_pci_config.c
> index 7e2e62ab0869..b77c96fbc4b2 100644
> --- a/drivers/vfio/pci/vfio_pci_config.c
> +++ b/drivers/vfio/pci/vfio_pci_config.c
> @@ -1966,3 +1966,31 @@ ssize_t vfio_pci_config_rw(struct vfio_pci_core_device *vdev, char __user *buf,
>  
>  	return done;
>  }
> +
> +bool range_intersect_range(loff_t range1_start, size_t count1,
> +			   loff_t range2_start, size_t count2,
> +			   loff_t *start_offset,
> +			   size_t *intersect_count,
> +			   size_t *register_offset)
> +{
> +	if (range1_start <= range2_start &&
> +	    range1_start + count1 > range2_start) {
> +		*start_offset = range2_start - range1_start;
> +		*intersect_count = min_t(size_t, count2,
> +					 range1_start + count1 - range2_start);
> +		*register_offset = 0;
> +		return true;
> +	}
> +
> +	if (range1_start > range2_start &&
> +	    range1_start < range2_start + count2) {
> +		*start_offset = 0;
> +		*intersect_count = min_t(size_t, count1,
> +					 range2_start + count2 - range1_start);
> +		*register_offset = range1_start - range2_start;
> +		return true;
> +	}
> +
> +	return false;
> +}
> +EXPORT_SYMBOL_GPL(range_intersect_range);
> diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
> index d478e6f1be02..8a11047ac6c9 100644
> --- a/include/linux/vfio_pci_core.h
> +++ b/include/linux/vfio_pci_core.h
> @@ -133,4 +133,10 @@ ssize_t vfio_pci_core_do_io_rw(struct vfio_pci_core_device *vdev, bool test_mem,
>  			       void __iomem *io, char __user *buf,
>  			       loff_t off, size_t count, size_t x_start,
>  			       size_t x_end, bool iswrite);
> +
> +bool range_intersect_range(loff_t range1_start, size_t count1,
> +			   loff_t range2_start, size_t count2,
> +			   loff_t *start_offset,
> +			   size_t *intersect_count,
> +			   size_t *register_offset);
>  #endif /* VFIO_PCI_CORE_H */


