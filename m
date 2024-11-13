Return-Path: <kvm+bounces-31699-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 246749C6778
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2024 03:57:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D4FBC1F24CB2
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2024 02:57:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4087515ADAF;
	Wed, 13 Nov 2024 02:56:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dRUFIbR0"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD58D158848;
	Wed, 13 Nov 2024 02:56:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731466611; cv=none; b=n6UPCbTLC4EJEgG7EjbZWeKtL3EKQNuXZoYtGQ1FXrjKS+bZ3RR1EBjzfa61NvcxjCRbbt+GRVmbZyyX/lAQAh+xMDn9+4I13km+p7K6kBF8ZiZyBhcOhN04DpqkbFIqakAs3uuZlpDasSt6hZMBKDBod9UVfAUxWC4uhUDUi6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731466611; c=relaxed/simple;
	bh=ceSuWOSaH+psoiQRK0fCAi9iXALt92xZBLKjvgklJjw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GmL5+5dJi6Kw5QGsX/b3DVzUWSQ58+ERI7Os3fYEStBlbR8rJdSNKLPFEC1eO6PTcd9RUjT8kCVDtJcEJFBhJ8JTEek4KtlzDxtQj/rAr6DkFqm8k2H6X6UgVBCEdu0l3thj3Om1T67kYa2j3mRjPeNuzDVTn8lZnxldlx/YBpQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dRUFIbR0; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1731466610; x=1763002610;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=ceSuWOSaH+psoiQRK0fCAi9iXALt92xZBLKjvgklJjw=;
  b=dRUFIbR0ZE3whFc7iFp8DCHUbcHGtZsOrHEbqLd84LqKPKbrnYinXkKl
   XqyxoxsUzsIOT4vVxtE9Epzd+lcPN+b5q4EHw3GoHhwSK0OL1dfFas1va
   rsFujAdCAgwWVjFnVRWtvEAgHv0mCQA6i3M5mMyfr3No7ieJyDWZ63Y6u
   itNJlNZJuBr1OHvZEwJTrzQIHmBCSoKFt2CqtERGbJK/FDZDp3CE+p420
   Zv9sPgRb4N7KStPQUjkW5G94FL1X9MQPBuQlfiexEjTqqn/TlY6IWXIY7
   MyJjJXNmf74XWfyu7ghbIFwMx2Y/zffs7tf2thxS562LmY5Nj0OU2krTO
   A==;
X-CSE-ConnectionGUID: zF3sdEj2Q9ikkFwYRS/KPg==
X-CSE-MsgGUID: uaTabGEoR5m759qI4DoxWg==
X-IronPort-AV: E=McAfee;i="6700,10204,11254"; a="31442142"
X-IronPort-AV: E=Sophos;i="6.12,149,1728975600"; 
   d="scan'208";a="31442142"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Nov 2024 18:56:49 -0800
X-CSE-ConnectionGUID: g2GulBb6RSSg5ikrECfKxg==
X-CSE-MsgGUID: Oj2A52ANTnmNTqlZZd4sgw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,149,1728975600"; 
   d="scan'208";a="87703179"
Received: from allen-sbox.sh.intel.com (HELO [10.239.159.30]) ([10.239.159.30])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Nov 2024 18:56:43 -0800
Message-ID: <9df3dd17-375a-4327-b2a8-e9f7690d81b1@linux.intel.com>
Date: Wed, 13 Nov 2024 10:55:41 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 00/12] Initial support for SMMUv3 nested translation
To: Jason Gunthorpe <jgg@nvidia.com>, Zhangfei Gao <zhangfei.gao@linaro.org>
Cc: acpica-devel@lists.linux.dev, iommu@lists.linux.dev,
 Joerg Roedel <joro@8bytes.org>, Kevin Tian <kevin.tian@intel.com>,
 kvm@vger.kernel.org, Len Brown <lenb@kernel.org>,
 linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 Lorenzo Pieralisi <lpieralisi@kernel.org>,
 "Rafael J. Wysocki" <rafael@kernel.org>,
 Robert Moore <robert.moore@intel.com>, Robin Murphy <robin.murphy@arm.com>,
 Sudeep Holla <sudeep.holla@arm.com>, Will Deacon <will@kernel.org>,
 Alex Williamson <alex.williamson@redhat.com>,
 Donald Dutile <ddutile@redhat.com>, Eric Auger <eric.auger@redhat.com>,
 Hanjun Guo <guohanjun@huawei.com>,
 Jean-Philippe Brucker <jean-philippe@linaro.org>,
 Jerry Snitselaar <jsnitsel@redhat.com>, Moritz Fischer <mdf@kernel.org>,
 Michael Shavit <mshavit@google.com>, Nicolin Chen <nicolinc@nvidia.com>,
 patches@lists.linux.dev, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
 Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
 Mostafa Saleh <smostafa@google.com>
References: <0-v4-9e99b76f3518+3a8-smmuv3_nesting_jgg@nvidia.com>
 <20241112182938.GA172989@nvidia.com>
 <CABQgh9HOHzeRF7JfrXrRAcGB53o29HkW9rnVTf4JefeVWDvzyQ@mail.gmail.com>
 <20241113012359.GB35230@nvidia.com>
Content-Language: en-US
From: Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <20241113012359.GB35230@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/13/24 09:23, Jason Gunthorpe wrote:
>> https://github.com/Linaro/linux-kernel-uadk/tree/6.12-wip
>> https://github.com/Linaro/qemu/tree/6.12-wip
>>
>> Still need this hack
>> https://github.com/Linaro/linux-kernel-uadk/commit/ 
>> eaa194d954112cad4da7852e29343e546baf8683
>>
>> One is adding iommu_dev_enable/disable_feature IOMMU_DEV_FEAT_SVA,
>> which you have patchset before.
> Yes, I have a more complete version of that here someplace. Need some
> help on vt-d but hope to get that done next cycle.

Can you please elaborate this a bit more? Are you talking about below
change

+	ret = iommu_dev_enable_feature(idev->dev, IOMMU_DEV_FEAT_SVA);
+	if (ret)
+		return ret;

in iommufd_fault_iopf_enable()?

I have no idea about why SVA is affected when enabling iopf.

--
baolu

