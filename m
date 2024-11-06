Return-Path: <kvm+bounces-30914-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2B9A69BE48F
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 11:45:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4EA281C21E72
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 10:45:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5EA121DE4DA;
	Wed,  6 Nov 2024 10:45:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="c+IHW/34"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE5C11DE3BB
	for <kvm@vger.kernel.org>; Wed,  6 Nov 2024 10:45:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730889931; cv=none; b=W3v77HFsGPgCx8D9PdNJjqeGmmN3IraNCn0REOgl/2fmBUr/4GUAi/Ujr4WBGyF09TzejJE4ojNUWkJhX8rvpuxj8m6qvqDM+iKA+usXAypOhmDq2wKX5ZlKD/ENwBGVCSSrq5pgaj942NKDbV37IcWsLXflDfnp2xKn495E+Ck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730889931; c=relaxed/simple;
	bh=Ql9YJ8edhXOoxBuRaVDC4Se/l6K3AWhdDZPp1yWOLbU=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=mC/wr0Kdg4N9VHwVsHvsYAF0O6tPfQmvB/5rNpcBCMVkWgt+tqAJpJ9lMQGAm7fLpo/RQsthtGaMUusHmlcvgerEVt17zLXB7pW+Tc1s/YgO1nuQ/imqWrsYZpCrfzqlynQRJXvYjKGhhrQ1oIWVcwvJGSJqDCP2GwSsrOBtmXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=c+IHW/34; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730889930; x=1762425930;
  h=message-id:date:mime-version:cc:subject:to:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Ql9YJ8edhXOoxBuRaVDC4Se/l6K3AWhdDZPp1yWOLbU=;
  b=c+IHW/34dudPcU3MaDf779Piz5CGr7K2jlkuMttZuGRxSbz+Kt2ifpf4
   OG/67aUk88ydvdV9ilE3wNb5008wt9r0kwnt466x1yMeOgjC3TN1h5E/q
   iUrq8fyYxjQo3FlDarrOFByDl7vIhVLiqt/nimSd3mj5IHBsCjxNFZfYP
   +Kkf3wsZuHrFs23IJgNgA1KZWqr1ns0jZF3cCsslIWEb/XFLICkYp0y9g
   DlSwHI9av/eondUe6N9VwGSBww308F8WNdriK+oqLs31gNK1YP1KrwC2J
   LQFMo6O/+buKDHKHS9D6VKkNElbb7Pmlc5t8jXgP4pD6dbWGosSNsGlhm
   A==;
X-CSE-ConnectionGUID: jouGofb8S6OvKmtg3gLVfg==
X-CSE-MsgGUID: mW+8OVmqQNa6c1XySIQJlg==
X-IronPort-AV: E=McAfee;i="6700,10204,11247"; a="33525435"
X-IronPort-AV: E=Sophos;i="6.11,262,1725346800"; 
   d="scan'208";a="33525435"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Nov 2024 02:45:29 -0800
X-CSE-ConnectionGUID: 6Pfw9i9lTxelemxAhMg0qA==
X-CSE-MsgGUID: KCi/LJP2S8eVVUtsPgiE+A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,262,1725346800"; 
   d="scan'208";a="84112080"
Received: from blu2-mobl.ccr.corp.intel.com (HELO [10.124.240.228]) ([10.124.240.228])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Nov 2024 02:45:26 -0800
Message-ID: <ae559732-1586-4099-a753-092fc7a698cf@linux.intel.com>
Date: Wed, 6 Nov 2024 18:45:24 +0800
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
To: Yi Liu <yi.l.liu@intel.com>, "Tian, Kevin" <kevin.tian@intel.com>,
 "joro@8bytes.org" <joro@8bytes.org>, "jgg@nvidia.com" <jgg@nvidia.com>
References: <20241104131842.13303-1-yi.l.liu@intel.com>
 <20241104131842.13303-12-yi.l.liu@intel.com>
 <BN9PR11MB5276F52B50577B8963A20BEB8C532@BN9PR11MB5276.namprd11.prod.outlook.com>
 <778d4e7b-cb4f-48d6-9b5d-de5e18c1a367@linux.intel.com>
 <982f10e2-5fc7-4b13-9877-77042ce20a11@intel.com>
Content-Language: en-US
From: Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <982f10e2-5fc7-4b13-9877-77042ce20a11@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 2024/11/6 17:14, Yi Liu wrote:
> On 2024/11/6 16:41, Baolu Lu wrote:
>> On 2024/11/6 16:17, Tian, Kevin wrote:
>>>> From: Liu, Yi L <yi.l.liu@intel.com>
>>>> Sent: Monday, November 4, 2024 9:19 PM
>>>>
>>>> +
>>>> +    dev_pasid = domain_add_dev_pasid(domain, dev, pasid);
>>>> +    if (IS_ERR(dev_pasid))
>>>> +        return PTR_ERR(dev_pasid);
>>>> +
>>>> +    ret = domain_setup_nested(iommu, dmar_domain, dev, pasid, old);
>>>> +    if (ret)
>>>> +        goto out_remove_dev_pasid;
>>>> +
>>>> +    domain_remove_dev_pasid(old, dev, pasid);
>>>> +
>>>
>>> forgot one thing. Why not required to create a debugfs entry for
>>> nested dev_pasid?
>>
>> This debugfs node is only created for paging domain.
> 
> I think Kevin got one point. The debugfs is added when paging domain
> is attached. How about the paging domains that is only used as nested
> parent domain. We seem to lack a debugfs node for such paging domains.

Are you talking about the nested parent domain? It's also a paging
domain, hence a debugfs node will be created.

