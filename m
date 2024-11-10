Return-Path: <kvm+bounces-31360-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 626E39C30DD
	for <lists+kvm@lfdr.de>; Sun, 10 Nov 2024 05:19:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EFE6C28204B
	for <lists+kvm@lfdr.de>; Sun, 10 Nov 2024 04:19:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 251C81482E8;
	Sun, 10 Nov 2024 04:19:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MB150CgM"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CE10847B
	for <kvm@vger.kernel.org>; Sun, 10 Nov 2024 04:19:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731212379; cv=none; b=sMb9Rl+tbKrvmpjqHoaSrmycQo62OLZGO5KsCTUd1A9OHwri/jIU74wmlUtK+FtnC1l8/oAh/0TCQVrmEJTDDWg3wBudc3eJejqUTfIV+fvHFB2d+f/POCuW6w0sknYahW0mp7BtmoHMtKAb+F5kV7rCXz5/LITM6wd2P5gt5+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731212379; c=relaxed/simple;
	bh=+AIwq+p26TZqqlYuKiL1+LRdiG7VvcnINzDpHqNv5mo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JppqXlrrCA7oe/wor+6t8oxAmhDRbD2Hn7CqMngfOybT9CSpo3RrDBZGLxK+vuEpJZfZDI9xOcrObu6z/Hk110j+3LD8lVOedBXCogfxrt3cK11wgUCcCBKqOfsgyNTABmg0LWO7oSYq4bFLHp5cy19ebNVAiRO7tuL8GproP5U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MB150CgM; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1731212377; x=1762748377;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=+AIwq+p26TZqqlYuKiL1+LRdiG7VvcnINzDpHqNv5mo=;
  b=MB150CgMB+fp8J/mNMuBhatNZ1UfNg3bdMjgTheZI79wRteRY/lYw3cG
   hg7uo1DT2qlk+KEow8b9wpM2Iy7DjDohCWGzs55/kQNLCnlj7DG7eTHFh
   TnksEBVY1V7IRd0dFoVEJqDkt1fUv9z4PIfsyFpwjkHBuvm0/uMlB3SXP
   nqCLTZoB041cRi6S7NxMq82jpcSPlCG29Ir5y5hl2SqTkjKtlvLowwQxW
   FbnauODG5+rCoqRYNq8ZLLsjzO15VjGDM0Vmx/PDABGRwlrAaGx6e83+E
   9IGP8Z8MTgBFAtp6BzMKio/mCCjCGocxt19MtAJeEHHMuSYvRFDbK2tLw
   A==;
X-CSE-ConnectionGUID: D73G1CY1Qty5/KryilhHMg==
X-CSE-MsgGUID: KES3WDQuRL6aGjLF5Sa69g==
X-IronPort-AV: E=McAfee;i="6700,10204,11251"; a="48568168"
X-IronPort-AV: E=Sophos;i="6.12,142,1728975600"; 
   d="scan'208";a="48568168"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2024 20:19:37 -0800
X-CSE-ConnectionGUID: CVtKf7tTQCeBm453L0bKmg==
X-CSE-MsgGUID: T0GbcRBIS9mu0dJhc/W/bA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,142,1728975600"; 
   d="scan'208";a="87095702"
Received: from allen-sbox.sh.intel.com (HELO [10.239.159.30]) ([10.239.159.30])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2024 20:19:34 -0800
Message-ID: <933e4c41-38b4-49dd-a6da-f699cfc7c344@linux.intel.com>
Date: Sun, 10 Nov 2024 12:18:38 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 5/7] iommu/vt-d: Make the blocked domain support PASID
To: Yi Liu <yi.l.liu@intel.com>, joro@8bytes.org, jgg@nvidia.com,
 kevin.tian@intel.com
Cc: alex.williamson@redhat.com, eric.auger@redhat.com, nicolinc@nvidia.com,
 kvm@vger.kernel.org, chao.p.peng@linux.intel.com, iommu@lists.linux.dev,
 zhenzhong.duan@intel.com, vasant.hegde@amd.com, willy@infradead.org
References: <20241108120427.13562-1-yi.l.liu@intel.com>
 <20241108120427.13562-6-yi.l.liu@intel.com>
Content-Language: en-US
From: Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <20241108120427.13562-6-yi.l.liu@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/8/24 20:04, Yi Liu wrote:
> The blocked domain can be extended to park PASID of a device to be the
> DMA blocking state. By this the remove_dev_pasid() op is dropped.
> 
> Reviewed-by: Kevin Tian<kevin.tian@intel.com>
> Reviewed-by: Jason Gunthorpe<jgg@nvidia.com>
> Signed-off-by: Yi Liu<yi.l.liu@intel.com>
> ---
>   drivers/iommu/intel/iommu.c | 15 +++++++++++----
>   1 file changed, 11 insertions(+), 4 deletions(-)

Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>

