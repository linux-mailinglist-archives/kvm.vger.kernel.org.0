Return-Path: <kvm+bounces-29236-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F2A4D9A5A10
	for <lists+kvm@lfdr.de>; Mon, 21 Oct 2024 08:00:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 64EC1B22E18
	for <lists+kvm@lfdr.de>; Mon, 21 Oct 2024 06:00:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 74C621D0148;
	Mon, 21 Oct 2024 05:59:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OEIkGZeM"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D816F1CF2B9
	for <kvm@vger.kernel.org>; Mon, 21 Oct 2024 05:59:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729490344; cv=none; b=e97Cn3mtHQ10B7YBgieRReDucBeU0MqKnvHyUoUr+bAoEHsmxAX38KAsHG/bnaaEL4i4HmCuJuIUQQczusWGosj8D8o1uSH4g8yAMNZ8RNZX66oPd2zr7pXW/9K+lX/h3O1XtBZrC+/KS+ItmstdlungX+8bmwThIPtog4AXLLo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729490344; c=relaxed/simple;
	bh=32hE2d1IW4eTH6QO0nI4ylv+Un2iWqWmF9fzlaKXPDM=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=sjiwYFBPzG824ZYsrz1Dobo28wHZ9SFZM5CoUpBQpQ/F4CnwVqxSg0lg1YCl9NMbCW2e6xejG05LzpSvmgjsBASPGQZTfVX8kAU4kxoMVMD+Hbqc9GaQmTH/3t8pNdKsTzVqmITpke6jjkoFDABR6Mk1o37b5pr56WPUvQery1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OEIkGZeM; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1729490343; x=1761026343;
  h=message-id:date:mime-version:cc:subject:to:references:
   from:in-reply-to:content-transfer-encoding;
  bh=32hE2d1IW4eTH6QO0nI4ylv+Un2iWqWmF9fzlaKXPDM=;
  b=OEIkGZeMjIGlI/os97asS4jHodxm35VvVJEwcGmpQhBcoxldOxERFHCc
   JMEYEacTZxgEa5S2ddWF6QyLrxQFb7kJNgQJ2Q2+N6Uisv+JnNka8BH0k
   QWThHvzYc9ecwbpu4vRApuRtH20jcxo/bKwIElLl7WsaANALtCVvHw/Vi
   7/NL8B/zQrBsLNNZ+TYSKxfdPv2X74g+4QMwG74ejAczWW77ij0//cld6
   qVl23mP45WbtzylYXI5RLkgnGwnNU5pfBiOhnVDvKJJMZxUUZ97gh1kKw
   OmpTAqn85V8gCHJh5OemhVP6H2BsxqVfl26O3Z4nsL9lek+omCUdnt2QS
   w==;
X-CSE-ConnectionGUID: gTSYW9OLQY67YbZpR0Rc2A==
X-CSE-MsgGUID: uBnQaAqZR0iYl94gZDa8bQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11231"; a="40347090"
X-IronPort-AV: E=Sophos;i="6.11,220,1725346800"; 
   d="scan'208";a="40347090"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Oct 2024 22:59:02 -0700
X-CSE-ConnectionGUID: Kbjqv3NWSjCPMAspzOkwTA==
X-CSE-MsgGUID: K0a/rhQpT1u5580SNzRQNQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,220,1725346800"; 
   d="scan'208";a="110183085"
Received: from unknown (HELO [10.238.0.51]) ([10.238.0.51])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Oct 2024 22:58:59 -0700
Message-ID: <1a75f311-79b1-4165-9c9b-5af1eeb1b935@linux.intel.com>
Date: Mon, 21 Oct 2024 13:58:57 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Cc: baolu.lu@linux.intel.com, alex.williamson@redhat.com,
 eric.auger@redhat.com, nicolinc@nvidia.com, kvm@vger.kernel.org,
 chao.p.peng@linux.intel.com, iommu@lists.linux.dev,
 zhenzhong.duan@intel.com, vasant.hegde@amd.com
Subject: Re: [PATCH v3 2/9] iommu/vt-d: Move intel_drain_pasid_prq() into
 intel_pasid_tear_down_entry()
To: Yi Liu <yi.l.liu@intel.com>, joro@8bytes.org, jgg@nvidia.com,
 kevin.tian@intel.com, will@kernel.org
References: <20241018055402.23277-1-yi.l.liu@intel.com>
 <20241018055402.23277-3-yi.l.liu@intel.com>
Content-Language: en-US
From: Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <20241018055402.23277-3-yi.l.liu@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2024/10/18 13:53, Yi Liu wrote:
> Draining PRQ is mostly conjuncted with pasid teardown, and with more
> callers coming, it makes sense to move it into the
> intel_pasid_tear_down_entry(). But there is scenario that only teardown
> pasid entry but no PRQ drain, so passing a flag to mark it.
> 
> Reviewed-by: Kevin Tian<kevin.tian@intel.com>
> Signed-off-by: Yi Liu<yi.l.liu@intel.com>
> ---
>   drivers/iommu/intel/iommu.c |  8 ++++----
>   drivers/iommu/intel/pasid.c | 12 ++++++++++--
>   drivers/iommu/intel/pasid.h |  8 +++++---
>   drivers/iommu/intel/svm.c   |  3 ++-
>   4 files changed, 21 insertions(+), 10 deletions(-)

Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>

Thanks,
baolu

