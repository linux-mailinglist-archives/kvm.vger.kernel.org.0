Return-Path: <kvm+bounces-17297-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 359F78C3B4F
	for <lists+kvm@lfdr.de>; Mon, 13 May 2024 08:29:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 669351C20FB1
	for <lists+kvm@lfdr.de>; Mon, 13 May 2024 06:29:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D5FA4146A9A;
	Mon, 13 May 2024 06:29:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lwB/kgMz"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E28514659C;
	Mon, 13 May 2024 06:29:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715581745; cv=none; b=bsqV5nZVdriO2xW2+ysVn/80Nn37IK72W1/p6t0bzOlG8qgvYw3EaVTplcmKvyM6dFUvINd2MNrDuQgoAgQ1RVLZhWpn3FsZWYZ6Kxbe1TMv0WWbR2/pA20lz1m3eRLO/A2ePOdH+gYBjof2/qY+UxcyWm9PjTtEJJahBp5i5HY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715581745; c=relaxed/simple;
	bh=xeOMy3Lk1CjvWUsSxodspku39JSy9Brg2h2hu0ybUfI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qY1YqtmIEFxSSdi/7t12Y3gIaP8VO4iZP26ooAmqv/ktsccw8t2b19iX4BCY+d2lU8/GcHUEJF9+2UPHbvaKZQb7saveoOsy6vmKqpr7X77CdDpZa4J298WFGcQs10SdQKgkBItHmjEeuSFLQJ1ptPpjdPlm4dWhcUUasWkMVXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lwB/kgMz; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715581744; x=1747117744;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=xeOMy3Lk1CjvWUsSxodspku39JSy9Brg2h2hu0ybUfI=;
  b=lwB/kgMzgJi37ofEe+cKAbmXszzQGNDZZg0EWad4E46Ol55ewm/geW52
   LQQrrNR/Hnsxh4zcKL6MD8AQC8NIyL4cPIvGTvz5UAIM2SE+7/xJ8QZda
   nuM9J6yt2ZBBww4xH6hrLMrt2SM7NUzJTWNMIdkQhbQXLAsXmSPq7jw4p
   fKpogw26hxmG6adK2LIkn4wZF6daCxb573eO7qdQIhbshjP5uiEViOWKj
   mdJViaGG2yuWxALhgBQBd+CP2bpPwgz+E3jT3OYnWsjL2m/7Le9jCOfbK
   ZRTJXjdap0qtnoeH1cmPOTD0YKK5yttsbdW5Nwi4QUnCqDvW5Y6UWVpNh
   A==;
X-CSE-ConnectionGUID: U28JzG8yTZ+gziqkGAmahg==
X-CSE-MsgGUID: H9ZJ01vcQpaWcpTeWZf1Og==
X-IronPort-AV: E=McAfee;i="6600,9927,11071"; a="34010183"
X-IronPort-AV: E=Sophos;i="6.08,157,1712646000"; 
   d="scan'208";a="34010183"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 May 2024 23:28:32 -0700
X-CSE-ConnectionGUID: PqRm72rRT/+QvRZBB9FihQ==
X-CSE-MsgGUID: w4e0SKj8QougWlTr10Y+FA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,157,1712646000"; 
   d="scan'208";a="30798384"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.125.243.198]) ([10.125.243.198])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 May 2024 23:28:24 -0700
Message-ID: <4262412d-5e70-41ad-841f-f92aaa931a7d@intel.com>
Date: Mon, 13 May 2024 14:28:22 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 14/17] KVM: x86/mmu: Handle no-slot faults at the
 beginning of kvm_faultin_pfn()
To: Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org
Cc: Sean Christopherson <seanjc@google.com>,
 David Matlack <dmatlack@google.com>, Kai Huang <kai.huang@intel.com>
References: <20240507155817.3951344-1-pbonzini@redhat.com>
 <20240507155817.3951344-15-pbonzini@redhat.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20240507155817.3951344-15-pbonzini@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/7/2024 11:58 PM, Paolo Bonzini wrote:
> From: Sean Christopherson <seanjc@google.com>
> 
> Handle the "no memslot" case at the beginning of kvm_faultin_pfn(), just
> after the private versus shared check, so that there's no need to
> repeatedly query whether or not a slot exists.  This also makes it more
> obvious that, except for private vs. shared attributes, the process of
> faulting in a pfn simply doesn't apply to gfns without a slot.
> 
> Opportunistically stuff @fault's metadata in kvm_handle_noslot_fault() so
> that it doesn't need to be duplicated in all paths that invoke
> kvm_handle_noslot_fault(), and to minimize the probability of not stuffing
> the right fields.
> 
> Leave the existing handle behind, but convert it to a WARN, to guard
> against __kvm_faultin_pfn() unexpectedly nullifying fault->slot.
> 
> Cc: David Matlack <dmatlack@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> Reviewed-by: Kai Huang <kai.huang@intel.com>
> Message-ID: <20240228024147.41573-14-seanjc@google.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>



