Return-Path: <kvm+bounces-30300-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id B122E9B9110
	for <lists+kvm@lfdr.de>; Fri,  1 Nov 2024 13:19:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 3B290B20EDC
	for <lists+kvm@lfdr.de>; Fri,  1 Nov 2024 12:19:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AC4F019D8BE;
	Fri,  1 Nov 2024 12:19:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NBHuxN/p"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA65AC13C;
	Fri,  1 Nov 2024 12:18:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730463539; cv=none; b=UJmUOXmKJYhUMtY/lR5P39HCvv3ppCjp2OzGVdVSuZW0XbgwAfo0bNsZLfxhPUuZONyhv9ojjrNvACyRESoEAqK4u5/WRz7YfEQHlW99KAMsZf5PuujbfdCxGksNuyilyo7VI8gA1KDuSm2ZrN0/LV+cf4fTnl6FUOPPvo/jrMQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730463539; c=relaxed/simple;
	bh=+HDgzWKsUKx97E2mppbNA0tlv52sTXzgPdKbp7JsyHc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EH2rRfi0EVqj+A25Al8Cs4RadLaY5Mwo+rAtJk0k7yCbJibz+5efhSdUp+sm4EIlz9iFL6EKrg7ePdZzcVxYPRiAHy3ubbGJQfxakjUF/x0zSlratMsvqdmDAINZ9WztHTaP9zWGYK1lOI2P3N3geBXw/q+QUJfG71BB4acM2D0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NBHuxN/p; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C80BC4CECD;
	Fri,  1 Nov 2024 12:18:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730463539;
	bh=+HDgzWKsUKx97E2mppbNA0tlv52sTXzgPdKbp7JsyHc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=NBHuxN/pAPf8IHixhryTxZ/futb2LvKpXXCyR/SW5uqdlFGHVLyrlBC+FoDgxJK/8
	 BXZ1Fn1ywsP56K2duT3rd3UI+AOCVdZmtR/HykfvCUXf3jv+5ZNKavkqEnCI4LKVwF
	 LRMnqS48aXxmJsDs31Z4xPwsC+bm4UTb7nLroxbppw7andSl//KM3oM0Tk4BPncaBZ
	 w1Qs2YqwVqIpnwUXRzbOyRf6LMKWgSiY+Z1kSvOokZF2WryjywWEbsMTi0AdGzTtx3
	 DxocfHC4sNGzai1qJLidnKNIKvKXS5sFlWCK6RoNSgw6FiIuVJ2TXQJsams+pxngiG
	 /RIoyXXF0y6rQ==
Date: Fri, 1 Nov 2024 12:18:50 +0000
From: Will Deacon <will@kernel.org>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: acpica-devel@lists.linux.dev, iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>, Kevin Tian <kevin.tian@intel.com>,
	kvm@vger.kernel.org, Len Brown <lenb@kernel.org>,
	linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Robert Moore <robert.moore@intel.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Sudeep Holla <sudeep.holla@arm.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Donald Dutile <ddutile@redhat.com>,
	Eric Auger <eric.auger@redhat.com>,
	Hanjun Guo <guohanjun@huawei.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Jerry Snitselaar <jsnitsel@redhat.com>,
	Moritz Fischer <mdf@kernel.org>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>, patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
	Mostafa Saleh <smostafa@google.com>
Subject: Re: [PATCH v4 00/12] Initial support for SMMUv3 nested translation
Message-ID: <20241101121849.GD8518@willie-the-truck>
References: <0-v4-9e99b76f3518+3a8-smmuv3_nesting_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0-v4-9e99b76f3518+3a8-smmuv3_nesting_jgg@nvidia.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Wed, Oct 30, 2024 at 09:20:44PM -0300, Jason Gunthorpe wrote:
> [This is now based on Nicolin's iommufd patches for vIOMMU and will need
> to go through the iommufd tree, please ack]

Can't we separate out the SMMUv3 driver changes? They shouldn't depend on
Nicolin's work afaict.

Will

