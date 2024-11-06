Return-Path: <kvm+bounces-30874-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B3BA89BE133
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 09:41:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 04BFDB248E0
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 08:41:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF3121D47AC;
	Wed,  6 Nov 2024 08:41:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="f8Z/Sg2H"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A680D1D31B2
	for <kvm@vger.kernel.org>; Wed,  6 Nov 2024 08:41:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730882510; cv=none; b=WEYvI//tIDjRb3aSQScsAVZLtVYA5fPZVSmVScka+//HAt4V8tuGDklrJDcZbXzt/0fkpFTDIYNXt0yVTWY23nRAb/0K23GM5JZmJzTu8yLAol3EGq73CXE3vGfgmMsUUsAKCGrdDYvZaR+IBC/lLaoNEH2i2a76nbdm6LnHr+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730882510; c=relaxed/simple;
	bh=n3jfsyzyB7Wp+wndUMUhHwNwNTBPJi6SzUWEzRp4+Xk=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=gw4abPZ0PDtiXSyZGqVAmZUsv9nKH67Bzi2Iqi4Ru5nb5fbDuG4oY25ZSy8NpSF7292Nre00iYfVfQAanRyV2VIMrWLZYXPwVOC8YGnpTP1NrDRqoeTK6ZQHYNWTniEIeZev24Vz2Asr8OjeolB7o54qw6wIp53CxfQ5Fa+2A6Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=f8Z/Sg2H; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730882509; x=1762418509;
  h=message-id:date:mime-version:cc:subject:to:references:
   from:in-reply-to:content-transfer-encoding;
  bh=n3jfsyzyB7Wp+wndUMUhHwNwNTBPJi6SzUWEzRp4+Xk=;
  b=f8Z/Sg2HSptIPbmvYU93eBE00mDQE8ze32nRB1e93ob2Z0C8tk1tr9gL
   0JxfOlYMO5CWurpgbu9tjztfNjMk7bJIExa+NWaZWzMAo3TF5rjoX9WGa
   b2l3nb0YHYv/Sj4tOHBLnumbxKWXUGArI1Wjt1/UQA4ye8J0HyjjfK02D
   d2VFafHCK13ZYbu+wADbKl4gqy0n3KB0WD2GH3XQnucGqzCDDNLoi65ID
   Gg9Jp0Qv5MDcjj5Q6sTJnnK+W6Dj5PY8TUooI8zDDzC6WKNl/OIr1bQSC
   nYtkSAH651RhVj5ElnuC4cs/qojsSsOf1xzznv3d156JrIcXEYp15HKSB
   w==;
X-CSE-ConnectionGUID: 6ijsWy7sQt23c9hI+AUK1A==
X-CSE-MsgGUID: qHhP4tnQQWGwbcdvhkDd4w==
X-IronPort-AV: E=McAfee;i="6700,10204,11247"; a="34595435"
X-IronPort-AV: E=Sophos;i="6.11,262,1725346800"; 
   d="scan'208";a="34595435"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Nov 2024 00:41:48 -0800
X-CSE-ConnectionGUID: pBxoe7ZWRM+CvbMwV0j1zA==
X-CSE-MsgGUID: QUxcNiljTYGTgQMUd/ormg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,262,1725346800"; 
   d="scan'208";a="85239228"
Received: from blu2-mobl.ccr.corp.intel.com (HELO [10.124.240.228]) ([10.124.240.228])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Nov 2024 00:41:44 -0800
Message-ID: <778d4e7b-cb4f-48d6-9b5d-de5e18c1a367@linux.intel.com>
Date: Wed, 6 Nov 2024 16:41:42 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Cc: baolu.lu@linux.intel.com,
 "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
 "eric.auger@redhat.com" <eric.auger@redhat.com>,
 "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
 "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
 "Duan, Zhenzhong" <zhenzhong.duan@intel.com>,
 "vasant.hegde@amd.com" <vasant.hegde@amd.com>,
 "will@kernel.org" <will@kernel.org>
Subject: Re: [PATCH v4 11/13] iommu/vt-d: Add set_dev_pasid callback for
 nested domain
To: "Tian, Kevin" <kevin.tian@intel.com>, "Liu, Yi L" <yi.l.liu@intel.com>,
 "joro@8bytes.org" <joro@8bytes.org>, "jgg@nvidia.com" <jgg@nvidia.com>
References: <20241104131842.13303-1-yi.l.liu@intel.com>
 <20241104131842.13303-12-yi.l.liu@intel.com>
 <BN9PR11MB5276F52B50577B8963A20BEB8C532@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Language: en-US
From: Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <BN9PR11MB5276F52B50577B8963A20BEB8C532@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2024/11/6 16:17, Tian, Kevin wrote:
>> From: Liu, Yi L <yi.l.liu@intel.com>
>> Sent: Monday, November 4, 2024 9:19 PM
>>
>> +
>> +	dev_pasid = domain_add_dev_pasid(domain, dev, pasid);
>> +	if (IS_ERR(dev_pasid))
>> +		return PTR_ERR(dev_pasid);
>> +
>> +	ret = domain_setup_nested(iommu, dmar_domain, dev, pasid, old);
>> +	if (ret)
>> +		goto out_remove_dev_pasid;
>> +
>> +	domain_remove_dev_pasid(old, dev, pasid);
>> +
> 
> forgot one thing. Why not required to create a debugfs entry for
> nested dev_pasid?

This debugfs node is only created for paging domain.

