Return-Path: <kvm+bounces-24338-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1CD4B953FD9
	for <lists+kvm@lfdr.de>; Fri, 16 Aug 2024 04:56:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CD6CC281E5F
	for <lists+kvm@lfdr.de>; Fri, 16 Aug 2024 02:56:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A8C955898;
	Fri, 16 Aug 2024 02:56:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jSrBxCcY"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29E4E1C14
	for <kvm@vger.kernel.org>; Fri, 16 Aug 2024 02:56:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723776992; cv=none; b=u6BCITRU59JSQCIWYkN/eQ+dstlEF9UWQmv8CmhsVYIvS1mjx5LSvku54yu0vllVnlY879vTeQ5K/IqApa6ukfGoa0tr7eRp6QH/o6G/yLMgbD0WuXgbFxqyd1bsz5dWOC9c0PmQdaVVj+UHgGe9QmQhDClU2t6PnKbgQ5TCye8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723776992; c=relaxed/simple;
	bh=UcCflUrO8MTjMv0Qq2HWX1SqGNsVQ+wdRA8MjsEdkJQ=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=aBc+d56E1mQ9j6x8guh+zebS2sEU4krMUFzB6og2ecjksndEY0T2HN/dk4XqN17HxbCszDtktyEONG625TsIbXpdmS4PzK94IEQfR5MRm3PD51otqNZfOOP2D2FifhkrWLujb7YWlB7G9tvZsZV63MlVOBYBr/S2CP0KDyBYP+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jSrBxCcY; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1723776991; x=1755312991;
  h=message-id:date:mime-version:cc:subject:to:references:
   from:in-reply-to:content-transfer-encoding;
  bh=UcCflUrO8MTjMv0Qq2HWX1SqGNsVQ+wdRA8MjsEdkJQ=;
  b=jSrBxCcYL2TyLUVIHfW4rJCQZwMDSEL6uYfOpvam3Z2dUp9cUINarWYC
   DyWlfitTYqGtduqw1FarhhGKNqRfYz0B9f2QkXc3g2mU0RtjcbY1FbVyE
   yD2a+PBNBp3atkgMqZsO69mZTcTsZ7JavqCEpJsHEbxMnTcrwRpmpI+6w
   0SNqXNKuZ3umjRFuAtjruz5xJ9CpdnIIwMRagDdP6cv8KluR+smQAoS7R
   QdUfIaqXqt2Xemu3ZSIzS5eYoIAFLec01ziGBHuqsdJ5EYUcZA5PIqooX
   R33gEly1Z6N5fpyHRMtKR4jVnE4M4D1VR94jpqzvCcWjDuHqO/1eMq/29
   Q==;
X-CSE-ConnectionGUID: eGTNrsFaRCOUwNnnadVUgg==
X-CSE-MsgGUID: FIXcAuSrTlCIFPOdGBoNbg==
X-IronPort-AV: E=McAfee;i="6700,10204,11165"; a="22206203"
X-IronPort-AV: E=Sophos;i="6.10,150,1719903600"; 
   d="scan'208";a="22206203"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Aug 2024 19:56:31 -0700
X-CSE-ConnectionGUID: FuOX1X5dTyqMunJSgmYBbQ==
X-CSE-MsgGUID: 49e3ZLaCR9KulV/0r9xdEA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,150,1719903600"; 
   d="scan'208";a="59554766"
Received: from allen-box.sh.intel.com (HELO [10.239.159.127]) ([10.239.159.127])
  by fmviesa008.fm.intel.com with ESMTP; 15 Aug 2024 19:56:28 -0700
Message-ID: <33eaf2b1-75be-4167-be05-16414abe8385@linux.intel.com>
Date: Fri, 16 Aug 2024 10:52:55 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Cc: baolu.lu@linux.intel.com, alex.williamson@redhat.com,
 robin.murphy@arm.com, eric.auger@redhat.com, nicolinc@nvidia.com,
 kvm@vger.kernel.org, chao.p.peng@linux.intel.com, iommu@lists.linux.dev
Subject: Re: [PATCH 0/6] Make set_dev_pasid op supportting domain replacement
To: Yi Liu <yi.l.liu@intel.com>, Vasant Hegde <vasant.hegde@amd.com>,
 joro@8bytes.org, jgg@nvidia.com, kevin.tian@intel.com
References: <20240628085538.47049-1-yi.l.liu@intel.com>
 <99f66c8d-57cf-4f0d-8545-b019dcf78a94@amd.com>
 <06f5fc87-b414-4266-a17a-cb2b86111e7a@intel.com>
Content-Language: en-US
From: Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <06f5fc87-b414-4266-a17a-cb2b86111e7a@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 8/16/24 9:19 AM, Yi Liu wrote:
>> So the expectation is replace existing PASID from PASID table only if 
>> old_domain
>> is passed. Otherwise sev_dev_pasid() should throw an error right?
>>
> 
> yes. If no old_domain passed in, then it is just a normal attachment. As
> you are working on AMD iommu, it would be great if you can have a patch to
> make the AMD set_dev_pasid() op suit this expectation. Then it can be
> incorporated in this series. 🙂

Perhaps this has been discussed before, but I can't recall. Out of
curiosity, why not introduce a specific replace_dev_pasid callback?

Thanks,
baolu

