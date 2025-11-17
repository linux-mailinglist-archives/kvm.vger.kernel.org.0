Return-Path: <kvm+bounces-63428-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 868D8C66836
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 00:04:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 75D204E2B48
	for <lists+kvm@lfdr.de>; Mon, 17 Nov 2025 23:04:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 21D7230F958;
	Mon, 17 Nov 2025 23:04:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AN5kg5me"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26C59242D79;
	Mon, 17 Nov 2025 23:04:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763420658; cv=none; b=ardhTcvnehUptKC1dEyoEE0oVluZuFLFFrk9nurkMzls5RmB5CqNvicKxHLxXB60BuHob+GCOXnO1GRHrVQTTeTiY8Kj+/80rAqIpCLWJ1T8/l3LLAn2yJpkSEooi7YAJuejB/EPxNeiRQE8AXAL6pH9LH3MfLOlT22XmZtVe0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763420658; c=relaxed/simple;
	bh=WDy4B5MpxbqhpxY50CYIosUO/OJPo/Xo2FnrKtc4l60=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=Q+W5XDnEFHVzuZugauy7B0EDn2Y8bkHX1lvQESX15QYBptn80xPi6VaobFLIuiYfu5R3ykS5A9lg1VUJvhBy1prX2XqvMfQjwSVyzoRSfQ8uOqHJ58U3gKk6P2XF296Ieu7v1/H0wapEmfxAkmPV9Ty0pkYMKPWbRiGbFDcoAZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AN5kg5me; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95830C4CEF1;
	Mon, 17 Nov 2025 23:04:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763420657;
	bh=WDy4B5MpxbqhpxY50CYIosUO/OJPo/Xo2FnrKtc4l60=;
	h=Date:From:To:Cc:Subject:In-Reply-To:From;
	b=AN5kg5meQGtxz+cRYWriS1/NMxGsJvAXW55WuzhlF2cIbIvnOE+HfQBZhFGA6vVZ4
	 8/j7sqTlUgXCEkiA3Qi/pKj3WUAx/Us/2n94lIn3wYzKfhM2j3rDD0E4hU/ugNra1U
	 e3JvfcVnnLQ9t1rQkOJk0h5o9kvhwTrStYRikWEfhVTI1h4tfVRfXtFwEeGs7mQZXZ
	 pwjJpJkNsBuQTkHXYq3skt71fl1OAxKlWY8to3xGrBMmVMjJ2Srn8IvlU8YJ20RMSW
	 cedp5OC03/dJ83o3lt14fTLY9VdwdAcgsudVwaBOibWtfmn+3Q+gDXmr78dtHQNYLQ
	 KD43b9+WrkRhw==
Date: Mon, 17 Nov 2025 17:04:14 -0600
From: Bjorn Helgaas <helgaas@kernel.org>
To: Nicolin Chen <nicolinc@nvidia.com>
Cc: joro@8bytes.org, rafael@kernel.org, bhelgaas@google.com,
	alex@shazbot.org, jgg@nvidia.com, kevin.tian@intel.com,
	will@kernel.org, robin.murphy@arm.com, lenb@kernel.org,
	baolu.lu@linux.intel.com, linux-arm-kernel@lists.infradead.org,
	iommu@lists.linux.dev, linux-kernel@vger.kernel.org,
	linux-acpi@vger.kernel.org, linux-pci@vger.kernel.org,
	kvm@vger.kernel.org, patches@lists.linux.dev,
	pjaroszynski@nvidia.com, vsethi@nvidia.com, etzhao1900@gmail.com
Subject: Re: [PATCH v5 4/5] iommu: Introduce iommu_dev_reset_prepare() and
 iommu_dev_reset_done()
Message-ID: <20251117230414.GA2537490@bhelgaas>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <28af027371a981a2b4154633e12cdb1e5a11da4a.1762835355.git.nicolinc@nvidia.com>

On Mon, Nov 10, 2025 at 09:12:54PM -0800, Nicolin Chen wrote:
> PCIe permits a device to ignore ATS invalidation TLPs, while processing a
> reset. This creates a problem visible to the OS where an ATS invalidation
> command will time out. E.g. an SVA domain will have no coordination with a
> reset event and can racily issue ATS invalidations to a resetting device.

s/TLPs, while/TLPs while/

> The OS should do something to mitigate this as we do not want production
> systems to be reporting critical ATS failures, especially in a hypervisor
> environment. Broadly, OS could arrange to ignore the timeouts, block page
> table mutations to prevent invalidations, or disable and block ATS.
> 
> The PCIe spec in sec 10.3.1 IMPLEMENTATION NOTE recommends to disable and
> block ATS before initiating a Function Level Reset. It also mentions that
> other reset methods could have the same vulnerability as well.
> 
> Provide a callback from the PCI subsystem that will enclose the reset and
> have the iommu core temporarily change all the attached domain to BLOCKED.
> After attaching a BLOCKED domain, IOMMU hardware would fence any incoming
> ATS queries. And IOMMU drivers should also synchronously stop issuing new
> ATS invalidations and wait for all ATS invalidations to complete. This can
> avoid any ATS invaliation timeouts.
> 
> However, if there is a domain attachment/replacement happening during an
> ongoing reset, ATS routines may be re-activated between the two function
> calls. So, introduce a new resetting_domain in the iommu_group structure
> to reject any concurrent attach_dev/set_dev_pasid call during a reset for
> a concern of compatibility failure. Since this changes the behavior of an
> attach operation, update the uAPI accordingly.
> 
> Note that there are two corner cases:
>  1. Devices in the same iommu_group
>     Since an attachment is always per iommu_group, disallowing one device
>     to switch domains (or HWPTs in iommufd) would have to disallow others
>     in the same iommu_group to switch domains as well. So, play safe by
>     preventing a shared iommu_group from going through the iommu reset.
>  2. SRIOV devices that its PF is resetting while its VF isn't

Slightly awkward.  Maybe:

  2. An SR-IOV PF that is being reset while its VF is not

(Obviously resetting a PF destroys all the VFs, which I guess is what
you're hinting at below.)

>     In such case, the VF itself is already broken. So, there is no point
>     in preventing PF from going through the iommu reset.

> + * iommu_dev_reset_prepare() - Block IOMMU to prepare for a device reset
> + * @dev: device that is going to enter a reset routine
> + *
> + * When certain device is entering a reset routine, it wants to block any IOMMU
> + * activity during the reset routine. This includes blocking any translation as
> + * well as cache invalidation (especially the device cache).
> + *
> + * This function attaches all RID/PASID of the device's to IOMMU_DOMAIN_BLOCKED
> + * allowing any blocked-domain-supporting IOMMU driver to pause translation and
> + * cahce invalidation, but leaves the software domain pointers intact so later

s/cahce/cache/

