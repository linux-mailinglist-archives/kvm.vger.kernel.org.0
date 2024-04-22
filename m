Return-Path: <kvm+bounces-15464-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0084A8AC590
	for <lists+kvm@lfdr.de>; Mon, 22 Apr 2024 09:29:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 27B0B1C21C71
	for <lists+kvm@lfdr.de>; Mon, 22 Apr 2024 07:29:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 99FA54DA13;
	Mon, 22 Apr 2024 07:27:50 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from baptiste.telenet-ops.be (baptiste.telenet-ops.be [195.130.132.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0940C8F3
	for <kvm@vger.kernel.org>; Mon, 22 Apr 2024 07:27:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.130.132.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713770870; cv=none; b=Z1uF6nYq6e04RNNevgjNbv1HhdpUFXcShWgVisRLhBEmQM8yU/GjhVBI8bnFWGQEvWKEiLAx5bqM2ercRLHcDcgllvPMutXqnlvT3Qr//ZdYvJixssAFqIB0PFlXgZsSyf3hx93upIbaR4abIr20mL9a8nHsal+EzUJ4PvmiO6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713770870; c=relaxed/simple;
	bh=RWyYEIWJ8XsfZ071NpRMCzhHu+Pnox/bWNT0IZqhBNM=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=Ue4HvN7sikqFFYQWy4qS4EmX9hu99GLmfvKiUvr/OWhDV0d8GCJPh54fcgeoapJ4pgHtmTlNZMLi8snOhoj4FkKVebWLQwfvuP/lsOKS1gqLWUueGk/jyBAEIWIg1dhWI3qbAQf55Dy2bZ7WoqW/zqT3T4Khc5PixvvLd/Y+180=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org; spf=none smtp.mailfrom=linux-m68k.org; arc=none smtp.client-ip=195.130.132.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux-m68k.org
Received: from ramsan.of.borg ([IPv6:2a02:1810:ac12:ed80:76d0:2bff:fec8:549])
	by baptiste.telenet-ops.be with bizsmtp
	id E7TJ2C0080SSLxL017TJcV; Mon, 22 Apr 2024 09:27:40 +0200
Received: from geert (helo=localhost)
	by ramsan.of.borg with local-esmtp (Exim 4.95)
	(envelope-from <geert@linux-m68k.org>)
	id 1ryo58-001FLD-7g;
	Mon, 22 Apr 2024 09:27:18 +0200
Date: Mon, 22 Apr 2024 09:27:18 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Jason Gunthorpe <jgg@nvidia.com>
cc: Anthony Krowiak <akrowiak@linux.ibm.com>, 
    Alex Williamson <alex.williamson@redhat.com>, 
    Bagas Sanjaya <bagasdotme@gmail.com>, Lu Baolu <baolu.lu@linux.intel.com>, 
    Chaitanya Kulkarni <chaitanyak@nvidia.com>, 
    Cornelia Huck <cohuck@redhat.com>, Jonathan Corbet <corbet@lwn.net>, 
    Daniel Jordan <daniel.m.jordan@oracle.com>, 
    David Gibson <david@gibson.dropbear.id.au>, 
    Eric Auger <eric.auger@redhat.com>, Eric Farman <farman@linux.ibm.com>, 
    iommu@lists.linux.dev, Jason Wang <jasowang@redhat.com>, 
    Jean-Philippe Brucker <jean-philippe@linaro.org>, 
    Jason Herne <jjherne@linux.ibm.com>, 
    Joao Martins <joao.m.martins@oracle.com>, 
    Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org, 
    Lixiao Yang <lixiao.yang@intel.com>, 
    Matthew Rosato <mjrosato@linux.ibm.com>, 
    "Michael S. Tsirkin" <mst@redhat.com>, Nicolin Chen <nicolinc@nvidia.com>, 
    Halil Pasic <pasic@linux.ibm.com>, 
    Niklas Schnelle <schnelle@linux.ibm.com>, 
    Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>, 
    Yi Liu <yi.l.liu@intel.com>, Yu He <yu.he@intel.com>, 
    Keqian Zhu <zhukeqian1@huawei.com>
Subject: Re: [PATCH v6 16/19] iommufd: Add kernel support for testing
 iommufd
In-Reply-To: <16-v6-a196d26f289e+11787-iommufd_jgg@nvidia.com>
Message-ID: <6860aa59-3a8b-74ca-3c33-2f3ec936075@linux-m68k.org>
References:  <16-v6-a196d26f289e+11787-iommufd_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed

 	Hi Jason,

On Tue, 29 Nov 2022, Jason Gunthorpe wrote:
> Provide a mock kernel module for the iommu_domain that allows it to run
> without any HW and the mocking provides a way to directly validate that
> the PFNs loaded into the iommu_domain are correct. This exposes the access
> kAPI toward userspace to allow userspace to explore the functionality of
> pages.c and io_pagetable.c
>
> The mock also simulates the rare case of PAGE_SIZE > iommu page size as
> the mock will operate at a 2K iommu page size. This allows exercising all
> of the calculations to support this mismatch.
>
> This is also intended to support syzkaller exploring the same space.
>
> However, it is an unusually invasive config option to enable all of
> this. The config option should not be enabled in a production kernel.
>
> Tested-by: Matthew Rosato <mjrosato@linux.ibm.com> # s390
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Replaying to and old email, after noticing commit 8541323285994528
("iommufd: Add missing IOMMUFD_DRIVER kconfig for the selftest") in
v6.9-rc5.

> --- a/drivers/iommu/iommufd/Kconfig
> +++ b/drivers/iommu/iommufd/Kconfig
> @@ -10,3 +10,15 @@ config IOMMUFD
> 	  it relates to managing IO page tables that point at user space memory.
>
> 	  If you don't know what to do here, say N.
> +
> +if IOMMUFD
> +config IOMMUFD_TEST
> +	bool "IOMMU Userspace API Test support"
> +	depends on DEBUG_KERNEL
> +	depends on FAULT_INJECTION
> +	depends on RUNTIME_TESTING_MENU
> +	default n
> +	help
> +	  This is dangerous, do not enable unless running
> +	  tools/testing/selftests/iommu
> +endif

How dangerous is this?
I.e. is it now unsafe to run an allyesconfig or allmodconfig kernel?

Probably this symbol should be tristate?

Gr{oetje,eeting}s,

 						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
 							    -- Linus Torvalds

