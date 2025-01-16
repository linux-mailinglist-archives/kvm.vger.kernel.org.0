Return-Path: <kvm+bounces-35619-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 264ECA1331F
	for <lists+kvm@lfdr.de>; Thu, 16 Jan 2025 07:30:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9E5983A72C9
	for <lists+kvm@lfdr.de>; Thu, 16 Jan 2025 06:30:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BC4171917F4;
	Thu, 16 Jan 2025 06:30:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mvgeZedZ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A71324A7E8;
	Thu, 16 Jan 2025 06:30:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737009036; cv=none; b=oKf9tcLA0dKCVXWMjK6ifEISl5ogYnNKawFsmOxcVvBmWw4CjoubC8FJCLYml9vChFYmf/hrVec2m+g22bKruJ+EWsWHcszTSdJE52Vm2e/FsaglxavskHiqGEtVrXsBq3H5VsILMyv8sQydZR3wjS84FfS7xtIK56AE1ZWmrf8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737009036; c=relaxed/simple;
	bh=ut1JOVcPzfgRH2hUsRRNYPuANJf/H9HJMFbAwMwApUk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=eqBQHVzQyD5z9Cg8h5EpMNbUwhFSwgZZAl0meN3AtX0QVw/cK0SZEBeR/FyL3BDJzRiBI6ahaHurRkzWHXj8tu2nIuCS0gIE7qXuk022JlcWJWTi/PYGgtUVEiwmitZT500DIzFxp6vD1F6vFQG8Bid8y0MolKny42Q7vsX3jOE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mvgeZedZ; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1737009036; x=1768545036;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=ut1JOVcPzfgRH2hUsRRNYPuANJf/H9HJMFbAwMwApUk=;
  b=mvgeZedZrnvB2F1F3+7z9wkuoPxiY+SDtZE7kp2QW49Eh2dsz6R3A2hW
   GLZBA6No0OSU3oN2QiO6oQoFGtEc1KoumgZpu9kSot8B+tNXV4+VVRgpn
   BLHd3VwwATlVjQRHPuitEbdwt/b29AZdS/T2QuLBq915P4sx6PBbOrgYJ
   Zf8HuWt3JakpNUWHUmJPxfuviggHkmc0ZQnK8TbC4ZZDdgZrY4gNXUqlH
   Diyp2hgpehP2GFMKusI3yZhYsXel4VJKaSHsEkMRmkNjEpQiuqm6/Cvb8
   EDbD4rtIHCaY6E4fmOQg8wQnYL4MJefJ0HnJVY2gVHPtPtPqMqUI0SBAS
   g==;
X-CSE-ConnectionGUID: eifLsZ3cTpG9nyC5mJweBQ==
X-CSE-MsgGUID: 3dgNwhg4SF6vZQ3spa7k1w==
X-IronPort-AV: E=McAfee;i="6700,10204,11316"; a="62748753"
X-IronPort-AV: E=Sophos;i="6.13,208,1732608000"; 
   d="scan'208";a="62748753"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jan 2025 22:30:35 -0800
X-CSE-ConnectionGUID: mKgRXg2bRKmgkMYJmmbVYw==
X-CSE-MsgGUID: xv/nDJXJTqmrs6EZSu9ZsA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,208,1732608000"; 
   d="scan'208";a="105923393"
Received: from dliang1-mobl.ccr.corp.intel.com (HELO [10.238.10.216]) ([10.238.10.216])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jan 2025 22:30:32 -0800
Message-ID: <5c220a51-d956-4434-992b-8f97f8d00922@linux.intel.com>
Date: Thu, 16 Jan 2025 14:30:30 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5/7] fixup! KVM: TDX: Implement hooks to propagate changes
 of TDP MMU mirror page table
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: pbonzini@redhat.com, seanjc@google.com, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, rick.p.edgecombe@intel.com,
 kai.huang@intel.com, adrian.hunter@intel.com, reinette.chatre@intel.com,
 xiaoyao.li@intel.com, tony.lindgren@intel.com, dmatlack@google.com,
 isaku.yamahata@intel.com, isaku.yamahata@gmail.com
References: <20250113020925.18789-1-yan.y.zhao@intel.com>
 <20250113021301.18962-1-yan.y.zhao@intel.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20250113021301.18962-1-yan.y.zhao@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit




On 1/13/2025 10:13 AM, Yan Zhao wrote:
> Return -EBUSY instead of -EAGAIN when tdh_mem_sept_add() encounters any err
> of TDX_OPERAND_BUSY.
>
> Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
> ---
>   arch/x86/kvm/vmx/tdx.c | 5 +++--
>   1 file changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index 09677a4cd605..4fb9faca5db2 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -1740,8 +1740,9 @@ int tdx_sept_link_private_spt(struct kvm *kvm, gfn_t gfn,
>   
>   	err = tdh_mem_sept_add(to_kvm_tdx(kvm)->tdr_pa, gpa, tdx_level, hpa, &entry,
>   			       &level_state);
> -	if (unlikely(err == TDX_ERROR_SEPT_BUSY))
> -		return -EAGAIN;
> +	if (unlikely(err & TDX_OPERAND_BUSY))

Some issue here as mentioned in the previous patch.

> +		return -EBUSY;
> +
>   	if (KVM_BUG_ON(err, kvm)) {
>   		pr_tdx_error_2(TDH_MEM_SEPT_ADD, err, entry, level_state);
>   		return -EIO;


