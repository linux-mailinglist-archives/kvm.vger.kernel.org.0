Return-Path: <kvm+bounces-30596-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 5601A9BC388
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 04:02:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 012CC1F22C7B
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 03:02:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CB1606F307;
	Tue,  5 Nov 2024 03:02:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SxNZmk8/"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A244270826
	for <kvm@vger.kernel.org>; Tue,  5 Nov 2024 03:02:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730775753; cv=none; b=I4DQcI7mBBqBBZCbK5Tc6OX/nsw1GQM4NlIEwtYmAxbTGo2BgacdkKagi/6Q0Ho8quxQFD6+eYlDKO4zjeVEKfIf/40UOk/nkJoHEOln39LxEdCX8i+SLeUnXNNjkEaCGurfGxvVd+kPj+pkWK6OomIadKE5a8C/VOaw/ZT14eY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730775753; c=relaxed/simple;
	bh=YkxnAQ77eagaLVzTjHyyd7r/VPoIyXDoCYEIrQFvYac=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BF8JvxhNFZNfRJdldeEcJPrlQMxJaNbyqzksA/D8TpsstAE4SBK07qPcBteXZGIxVQv390uIJJXkyLJ+ZcGbtp7bQ9Chuky89n/4/+XP5OSk83Rw1Q5AJC93DXj1yD6G2Pvux+ql4ikT5BDzh7k17vTzkBcmfUXsbLrrKmbjM7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=SxNZmk8/; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730775752; x=1762311752;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=YkxnAQ77eagaLVzTjHyyd7r/VPoIyXDoCYEIrQFvYac=;
  b=SxNZmk8/sQGzBXT12HLL9Lc73NFLTlqJyxVDZStLYxrjgC/2Q7KmSCsQ
   0+vmGK42GssVN5mf2dkHbGCahnWgCao7A1/jUUip8nKE154pB3SFOd9L0
   JuHutp59wuWcD6Mp9+ed4j3m7md7HozfJtbuGWlPLWk/WQySvWjMyfHA7
   BqisBsUWcKElPhCZq6WVBV8Ro0i6OPAgXqcDf/2dLUniyTbW3ed9PFeEO
   wrUaa0qVoR2EW5tDZ89ezOTXxIEHdo//iXpfnfIa0ZkUfnzdO1o1Vz7aA
   WCU8zRyXYGaXBpPULswwXxW1+5rxiS+h3J5wu5T1QRNTg35KtGClswRlZ
   A==;
X-CSE-ConnectionGUID: JAWiMT/iRxS36O8NLeQARg==
X-CSE-MsgGUID: ig9wZwO8R7aNo2XLunFXcg==
X-IronPort-AV: E=McAfee;i="6700,10204,11246"; a="33340510"
X-IronPort-AV: E=Sophos;i="6.11,258,1725346800"; 
   d="scan'208";a="33340510"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2024 19:02:31 -0800
X-CSE-ConnectionGUID: jGjvI/vbQuySe39NZUeMrQ==
X-CSE-MsgGUID: eZLGDiXGT1mp16pai/LU6w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,258,1725346800"; 
   d="scan'208";a="88997312"
Received: from allen-sbox.sh.intel.com (HELO [10.239.159.30]) ([10.239.159.30])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2024 19:02:28 -0800
Message-ID: <7f1d145f-f3f1-413f-b2ca-d2d89c903c26@linux.intel.com>
Date: Tue, 5 Nov 2024 11:01:41 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 07/13] iommu/vt-d: Limit intel_iommu_set_dev_pasid()
 for paging domain
To: Yi Liu <yi.l.liu@intel.com>, joro@8bytes.org, jgg@nvidia.com,
 kevin.tian@intel.com
Cc: alex.williamson@redhat.com, eric.auger@redhat.com, nicolinc@nvidia.com,
 kvm@vger.kernel.org, chao.p.peng@linux.intel.com, iommu@lists.linux.dev,
 zhenzhong.duan@intel.com, vasant.hegde@amd.com, will@kernel.org
References: <20241104131842.13303-1-yi.l.liu@intel.com>
 <20241104131842.13303-8-yi.l.liu@intel.com>
Content-Language: en-US
From: Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <20241104131842.13303-8-yi.l.liu@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/4/24 21:18, Yi Liu wrote:
> intel_iommu_set_dev_pasid() is only supposed to be used by paging domain,
> so limit it.
> 
> Signed-off-by: Yi Liu<yi.l.liu@intel.com>
> ---
>   drivers/iommu/intel/iommu.c | 6 ++++--
>   1 file changed, 4 insertions(+), 2 deletions(-)

Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>

