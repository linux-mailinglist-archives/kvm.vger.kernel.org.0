Return-Path: <kvm+bounces-30599-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 943B99BC3E0
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 04:31:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 46D5B1F216DF
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 03:31:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C83DC183098;
	Tue,  5 Nov 2024 03:31:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gH5pzvLY"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 672833C39
	for <kvm@vger.kernel.org>; Tue,  5 Nov 2024 03:31:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730777481; cv=none; b=NfsWIN9J4TpsIR68rvleNuR+cN3imvKEIJ+DK0uyvtG58FYOngSje+EhvbUpv1b3FhkJdIwfTUwQC1TNleIDyrPHqYrWXiW12+7WbYPiH9MNWxy8NnUc7vIdp4SiHgqDkG70PZ3VjymbMoYdWhKYRrfYOp+elwbZRjSRzJ1gDSw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730777481; c=relaxed/simple;
	bh=ah0+KjvBu5gMrCO86eq00paT8C917hvU8zxlTRQhfOI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Y/hHptedBIXPIDHGznPr9EjYkaGb/0OhS0ZLb9whfsbenbuYZuNTXCo30ltH/zqEmrVZLwTTAgvN0wYNh3k8nqQvl0L0NbOhKI0rNVrz6S6ArzpvLEOQ9PzTutZeSnOwf61NnaPkExgy6M1KBPEVneq84fYN3gBFN63eMTBFiIc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gH5pzvLY; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730777480; x=1762313480;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=ah0+KjvBu5gMrCO86eq00paT8C917hvU8zxlTRQhfOI=;
  b=gH5pzvLYW8T71JwbUy9fSiFdES03IQJMoFDVAIvoc6Zolq8rIUrpOjVg
   2HH2lv7xYU4ZZRbX5c5fjeEN7mruGXN0XYzoEwanggFRa1/2REo3cBKOn
   WtPmZ3H0hdjVzU95qGFWny2IaF20bs8bOlX9w43UJ5NJUOddCrT+ye4sU
   wiVRcWdBrF6LSXGqvr+XLtfNt3LerHFjPxkB0xvk0wL5tHe4H40rENw9m
   lu1sNeKQfkzG4z4M+8X84OMZ8RO0IHCpPqOS6yu2dRQZhCrQbSYwDOtEv
   SwUHlWorbKsFlBE4NUykG6X//25xy3D0Asa4bbawwzlzv2OVpZkIw6dTD
   g==;
X-CSE-ConnectionGUID: QNQl7ha+RaqRQ3C15/r6UA==
X-CSE-MsgGUID: ePuHw3jIRMaCqgHq3/t2aQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="41610393"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="41610393"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2024 19:31:19 -0800
X-CSE-ConnectionGUID: 20DO5kIUSUqGp/IDlT8yBA==
X-CSE-MsgGUID: SbAvkq6uQdm7JUKe7YsoKg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,259,1725346800"; 
   d="scan'208";a="114653043"
Received: from allen-sbox.sh.intel.com (HELO [10.239.159.30]) ([10.239.159.30])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2024 19:31:11 -0800
Message-ID: <0781f329-49a5-4652-ae94-d0bbefa8dbb0@linux.intel.com>
Date: Tue, 5 Nov 2024 11:30:25 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 10/13] iommu/vt-d: Fail SVA domain replacement
To: Yi Liu <yi.l.liu@intel.com>, joro@8bytes.org, jgg@nvidia.com,
 kevin.tian@intel.com
Cc: alex.williamson@redhat.com, eric.auger@redhat.com, nicolinc@nvidia.com,
 kvm@vger.kernel.org, chao.p.peng@linux.intel.com, iommu@lists.linux.dev,
 zhenzhong.duan@intel.com, vasant.hegde@amd.com, will@kernel.org
References: <20241104131842.13303-1-yi.l.liu@intel.com>
 <20241104131842.13303-11-yi.l.liu@intel.com>
Content-Language: en-US
From: Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <20241104131842.13303-11-yi.l.liu@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/4/24 21:18, Yi Liu wrote:
> There is no known usage that will attach SVA domain or detach SVA domain
> by replacing PASID to or from SVA domain. It is supposed to use the
> iommu_sva_{un}bind_device() which invoke the  iommu_{at|de}tach_device_pasid().
> So Intel iommu driver decides to fail the domain replacement if the old
> domain or new domain is SVA type.

I would suggest dropping this patch.

The iommu driver now supports switching SVA domains to and from other
types of domains. The current limitation comes from the iommu core,
where the SVA interface doesn't use replace.

Looking forward, iommu_detach_device_pasid() will be converted to switch
an SVA domain to a blocking domain. Once this is implemented, perhaps
the check and failure scenario will no longer be relevant.

--
baolu

