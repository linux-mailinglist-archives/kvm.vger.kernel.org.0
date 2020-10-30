Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D93822A0FC7
	for <lists+kvm@lfdr.de>; Fri, 30 Oct 2020 21:57:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727557AbgJ3U5E (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Oct 2020 16:57:04 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:35998 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727331AbgJ3U5E (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 30 Oct 2020 16:57:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604091423;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=G4Sd/bJr19YSAd9GdvU3fP5HNJ+0V8eKs7dPTIY2nYM=;
        b=Mc78R1F+M2RXKP5x4SMSBHNUUfWmZtjLEvPhkRbjdE98o+RbNPV6w0xSOyrzKVTvHi6Qt0
        BaIXd3zzK0p+zR7lahTkdvyNIeiZpka5565qKjlgobkf0vO5h+ZSr/pWg3jeeycXa3aLLj
        EgdCWXRbVgsOH0vnRIZh68RtQ5Jd+YQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-182-dQ9rhtvwMhy-8YCCyffXSA-1; Fri, 30 Oct 2020 16:56:58 -0400
X-MC-Unique: dQ9rhtvwMhy-8YCCyffXSA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B73C91087D68;
        Fri, 30 Oct 2020 20:56:56 +0000 (UTC)
Received: from w520.home (ovpn-112-213.phx2.redhat.com [10.3.112.213])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8918476642;
        Fri, 30 Oct 2020 20:56:55 +0000 (UTC)
Date:   Fri, 30 Oct 2020 14:56:55 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Lu Baolu <baolu.lu@linux.intel.com>
Cc:     Joerg Roedel <joro@8bytes.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Cornelia Huck <cohuck@redhat.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Ashok Raj <ashok.raj@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Liu Yi L <yi.l.liu@intel.com>, Zeng Xin <xin.zeng@intel.com>,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH v6 4/5] iommu/vt-d: Add iommu_ops support for subdevice
 bus
Message-ID: <20201030145655.07c692d8@w520.home>
In-Reply-To: <20201030045809.957927-5-baolu.lu@linux.intel.com>
References: <20201030045809.957927-1-baolu.lu@linux.intel.com>
        <20201030045809.957927-5-baolu.lu@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 30 Oct 2020 12:58:08 +0800
Lu Baolu <baolu.lu@linux.intel.com> wrote:

> +static const struct iommu_ops siov_iommu_ops = {
> +	.capable		= intel_iommu_capable,
> +	.domain_alloc		= siov_iommu_domain_alloc,
> +	.domain_free		= intel_iommu_domain_free,
> +	.attach_dev		= siov_iommu_attach_device,
> +	.detach_dev		= siov_iommu_detach_device,
> +	.map			= intel_iommu_map,
> +	.unmap			= intel_iommu_unmap,
> +	.iova_to_phys		= intel_iommu_iova_to_phys,
> +	.probe_device		= siov_iommu_probe_device,
> +	.release_device		= siov_iommu_release_device,
> +	.get_resv_regions	= siov_iommu_get_resv_regions,
> +	.put_resv_regions	= generic_iommu_put_resv_regions,
> +	.device_group		= generic_device_group,
> +	.pgsize_bitmap		= (~0xFFFUL),
> +};
> +
> +void intel_siov_init(void)
> +{
> +	if (!scalable_mode_support() || !iommu_pasid_support())
> +		return;
> +
> +	bus_set_iommu(&mdev_bus_type, &siov_iommu_ops);
> +	pr_info("Intel(R) Scalable I/O Virtualization supported\n");
> +}

How can you presume to take over iommu_ops for an entire virtual bus?
This also forces mdev and all the dependencies of mdev to be built into
the kernel.  I don't find that acceptable.  Thanks,

Alex

