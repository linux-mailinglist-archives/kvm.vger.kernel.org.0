Return-Path: <kvm+bounces-62833-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 74C57C509D1
	for <lists+kvm@lfdr.de>; Wed, 12 Nov 2025 06:27:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 576884E9E0C
	for <lists+kvm@lfdr.de>; Wed, 12 Nov 2025 05:26:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E0FFA2D9EDD;
	Wed, 12 Nov 2025 05:26:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CEPWaH13"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB6D1146588;
	Wed, 12 Nov 2025 05:26:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762925208; cv=none; b=qhX2KpYxvKDD5UI+L+1aQIWIOvImhdgVKC3sldCWDd4xxUUXEU22vCuDAvASfxupiflAcsYjpBEDk9BpeXsyV1Hl7++owt+X3Zf7xSMKPzQg3jovEKt6687WJ+ePFKsx9iP9wBaDANfhQ+/lYGQhoFunCF/ZEb2rFOHwBeMfYhc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762925208; c=relaxed/simple;
	bh=J2yCx8gANXEoEptcoVy/jvxBGR0sLdZaZJNtdCJDhDQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gch/8+hOKsq8/aK41tX1OusqUI/zOYQfcoBoElxyUAIaQDstg3lv0lBnNhNVrXM+9k4kSJ0W1WOzvHEKPJKq0yQ3ARWueRpj+uctJgMroP2d8MpZOqVvHEtAWWi3xs3JkkzYHcVSxrCC1Ikf35xL40tr8/XSI+b7PSK2xxrSTs0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=CEPWaH13; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1762925206; x=1794461206;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=J2yCx8gANXEoEptcoVy/jvxBGR0sLdZaZJNtdCJDhDQ=;
  b=CEPWaH13QuEHeyuMYIU1ab3uCDunT91ibG8+ITiwmGV/4rNBp0FVol4V
   0z8xBgPDrfPVWk6HdgpC7Defilr/MJa2GtSZlzk/NFTxtJTK4UUlkOSsO
   p4CnXaCDA+h8F/7Tf801CtamAQhuPe5m4e5ACvbPLk+MIlzHAn7QU+Og6
   uyfLG5LJSqBnGZkt3qk2HDAHbCGwgxZkk9c9KUjcFXz+5NeM5QArLRCYk
   BeMQu+wJlrIl3ov+RTlVM+ko2m6a07fPGEKkiiHhCu7le1LXoNVBDOZrQ
   Qpvk2HC/+VA3cRMgMFkeYN5WIAK95wLxmoWU7QPM3X7qInRxl7nYBrbmB
   w==;
X-CSE-ConnectionGUID: 0XBEb4WGQSm14BHCoeKlrw==
X-CSE-MsgGUID: 4RcpEAYDR3qVrZgGX7I63A==
X-IronPort-AV: E=McAfee;i="6800,10657,11610"; a="76331295"
X-IronPort-AV: E=Sophos;i="6.19,298,1754982000"; 
   d="scan'208";a="76331295"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2025 21:26:45 -0800
X-CSE-ConnectionGUID: 2KuqqVv9TuS5cZ/Ryocc5Q==
X-CSE-MsgGUID: jYiQEfIURoe/1ab0ampM7A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,298,1754982000"; 
   d="scan'208";a="189381942"
Received: from allen-sbox.sh.intel.com (HELO [10.239.159.30]) ([10.239.159.30])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2025 21:26:41 -0800
Message-ID: <f6e4ca74-2b76-4662-97eb-a1c5eab62c9a@linux.intel.com>
Date: Wed, 12 Nov 2025 13:22:38 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 2/5] iommu: Tiny domain for iommu_setup_dma_ops()
To: Nicolin Chen <nicolinc@nvidia.com>, joro@8bytes.org, afael@kernel.org,
 bhelgaas@google.com, alex@shazbot.org, jgg@nvidia.com, kevin.tian@intel.com
Cc: will@kernel.org, robin.murphy@arm.com, lenb@kernel.org,
 linux-arm-kernel@lists.infradead.org, iommu@lists.linux.dev,
 linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
 linux-pci@vger.kernel.org, kvm@vger.kernel.org, patches@lists.linux.dev,
 pjaroszynski@nvidia.com, vsethi@nvidia.com, helgaas@kernel.org,
 etzhao1900@gmail.com
References: <cover.1762835355.git.nicolinc@nvidia.com>
 <431cccb8279eb84376c641981f57e9ceece8febf.1762835355.git.nicolinc@nvidia.com>
Content-Language: en-US
From: Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <431cccb8279eb84376c641981f57e9ceece8febf.1762835355.git.nicolinc@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/11/25 13:12, Nicolin Chen wrote:
> This function can only be called on the default_domain. Trivally pass it
> in. In all three existing cases, the default domain was just attached to
> the device.
> 
> This avoids iommu_setup_dma_ops() calling iommu_get_domain_for_dev() the
> that will be used by external callers.
> 
> Suggested-by: Jason Gunthorpe<jgg@nvidia.com>
> Signed-off-by: Nicolin Chen<nicolinc@nvidia.com>
> ---
>   drivers/iommu/dma-iommu.h | 5 +++--
>   drivers/iommu/dma-iommu.c | 4 +---
>   drivers/iommu/iommu.c     | 6 +++---
>   3 files changed, 7 insertions(+), 8 deletions(-)

Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>

