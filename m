Return-Path: <kvm+bounces-31205-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 229939C13E1
	for <lists+kvm@lfdr.de>; Fri,  8 Nov 2024 03:13:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DB8D5283EB7
	for <lists+kvm@lfdr.de>; Fri,  8 Nov 2024 02:13:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 08DF2208C4;
	Fri,  8 Nov 2024 02:12:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="g+pX6GvW"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5106617996
	for <kvm@vger.kernel.org>; Fri,  8 Nov 2024 02:12:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731031978; cv=none; b=r+Hd104ExkKDr26oaZLspLeZHNOgLqt9C91woavNqMNJG3jpl14OMbs4IrfeE2l89LKzxFNQVSXY+Xnj8/Zu+koUp9lkRuMhoZW48C2W97insFfWgTnPvH/2FgvWZKhryuDC6vPW0+Eprj6PreVNKLk4BZLHSKpi6b8k/4dhrj4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731031978; c=relaxed/simple;
	bh=eMgr6hkzK2jB6OpaJ8mAvwSp3Zcj3gIMDM98N7BRC+M=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Vk8tDdT9s91UV24/W7SayIZy+MkNRq0dxuR1jP6IHbq5nQiF+B36fF4jmVVtshfDP3/QHJhRVVoYOvZt2HG6cBD/yP/aOsD85JRiRU+7QRU4aPrphhf0STyGTCb6zU6ctCqgs60XJABXHAyzIIUuK1qDW+pT0rpbLMLH7jd+2ME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=g+pX6GvW; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1731031976; x=1762567976;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=eMgr6hkzK2jB6OpaJ8mAvwSp3Zcj3gIMDM98N7BRC+M=;
  b=g+pX6GvWw/82uydFPj7QWLVLWqc06HTkc+eHpV+ObzgH9+RzrywqHUhM
   QxBBukReM9ea0zkenYlFDsR2IbZY39rOMd4y7ZDsM2sa6EKTOqz4+8ZI0
   9fLKs0MJgcQ9E0PzlaYpuam3IwyT44iR/9CYC6gzThVA3xpW3WRvr20/O
   DldCw2J99bnrL1REiyZfU4oPKVXJro/iUX3WZTn62N0Kz4nfkpvEmzQtE
   MpbzWrWQGEMQWNq7Ji6Li0iOiobEn6YYY73IX83CtdLI/NSnn9QP1PX+5
   avpF6PZO1JjyOb79RxR09//Sl9nQXRG4GJFlsfJC1mT0wHAgQj81N3XKs
   g==;
X-CSE-ConnectionGUID: jFe+GgUcRsifLRhkN5AIag==
X-CSE-MsgGUID: rDuESoRnSbqcgt5hAWP/Ww==
X-IronPort-AV: E=McAfee;i="6700,10204,11249"; a="56303169"
X-IronPort-AV: E=Sophos;i="6.12,136,1728975600"; 
   d="scan'208";a="56303169"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2024 18:12:56 -0800
X-CSE-ConnectionGUID: 7ivvcuKFRsexii1N5b/hCA==
X-CSE-MsgGUID: uPmSIuAIQTuwogOC5PrDaw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,136,1728975600"; 
   d="scan'208";a="122841756"
Received: from allen-sbox.sh.intel.com (HELO [10.239.159.30]) ([10.239.159.30])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2024 18:12:52 -0800
Message-ID: <b3d351dd-e75f-483f-be7d-0c0bcb1dec7a@linux.intel.com>
Date: Fri, 8 Nov 2024 10:12:01 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 00/13] Make set_dev_pasid op supporting domain
 replacement
To: Yi Liu <yi.l.liu@intel.com>, joro@8bytes.org, jgg@nvidia.com,
 kevin.tian@intel.com
Cc: alex.williamson@redhat.com, eric.auger@redhat.com, nicolinc@nvidia.com,
 kvm@vger.kernel.org, chao.p.peng@linux.intel.com, iommu@lists.linux.dev,
 zhenzhong.duan@intel.com, vasant.hegde@amd.com, willy@infradead.org
References: <20241107122234.7424-1-yi.l.liu@intel.com>
Content-Language: en-US
From: Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <20241107122234.7424-1-yi.l.liu@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/7/24 20:22, Yi Liu wrote:
> This splits the preparation works of the iommu and the Intel iommu driver
> out from the iommufd pasid attach/replace series. [1]
> 
> To support domain replacement, the definition of the set_dev_pasid op
> needs to be enhanced. Meanwhile, the existing set_dev_pasid callbacks
> should be extended as well to suit the new definition.
> 
> This series first passes the old domain to the set_dev_pasid op, and prepares
> the Intel iommu set_dev_pasid callbacks (paging domain, identity domain, and
> sva domain) for the new definition, add the missing set_dev_pasid callback
> for the nested domain, makes ARM SMMUv3 set_dev_pasid op to suit the new
> set_dev_pasid op definition, and in the end, claims the set_dev_pasid op support
> domain replacement. The AMD set_dev_pasid callback is extended to fail if the
> caller tries to do the domain replacement to meet the new definition of
> set_dev_pasid op. AMD iommu driver would support it later per Vasant [2].
> 
> [1]https://lore.kernel.org/linux-iommu/20240412081516.31168-1- 
> yi.l.liu@intel.com/
> [2]https://lore.kernel.org/linux-iommu/fa9c4fc3-9365-465e-8926- 
> b4d2d6361b9c@amd.com/
> 
> This is based on Joerg's next branch. Base commit: 75bc266cd1a6
> 
> v6:
>   - Fix a 0day compiling issue (Baolu)
>   - Refine the pasid replace helpers to compose new pasid entry and do a full
>     copy instead of setting each fields in the pasid entry from the pasid table.
>     This avoids transit the existing pasid entry multiple times. (Baolu)

Queued for v6.13. Thank you, Yi.

--
baolu

