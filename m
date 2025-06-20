Return-Path: <kvm+bounces-50002-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id D59E8AE10C0
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 03:30:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5397A7AD9AF
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 01:29:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6A7EA482F2;
	Fri, 20 Jun 2025 01:30:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="defGWc5l"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2171030E820;
	Fri, 20 Jun 2025 01:30:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750383040; cv=none; b=HO24zPjpXROQjrJpAWIVA9S7MRdNiMMsLd/vizQw8ZwaOVak8mJmY61hvW8PjNM0bvnLvpztwmHf9Su3TBKvGd0LepoH9wEVvrQpmhULRsDxRmyV8LcHEM9+Q5InRWFGCROxYsKRWGgBDKft/b/gVyW+h1QD1Ag2Tcc1Yq0oUFE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750383040; c=relaxed/simple;
	bh=ySgRnI6zQBvmEVFM6GiaIrkiwvfvdT9BZ3dD9QwjPRE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GxWsCaTynXbsRCEmT4q2o4a0v/t2ktmVSbopOcv7pkBmFBkjC0wNA9bzlLR7prN55tZTkK8ajUw8Lwa9BWj+1Q4ZzarnDAB5ZZkkAweFND4esUfbgiufav8qNXeCmhAedhhwCYwv1D978qkoeD77Dt3vGvJ7OKhA0etqc+QJuKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=defGWc5l; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750383039; x=1781919039;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=ySgRnI6zQBvmEVFM6GiaIrkiwvfvdT9BZ3dD9QwjPRE=;
  b=defGWc5l+M+0pxljs6HnPoyO736p7N9PsmARVSom/F0AbsP19RdPQ0wc
   azmTNgyXpVOuUoDwrrrMZM61SZFD8MXOZKyFbcEMEa+nJhuED4CW3BlRD
   +amWkR8moUVQTMiCUnNFHXDEv/wouwLWPHTiyWfD04dz7wuaQj4SPQfAn
   TNgna29Dh895M+AmJ3pBSizPuz9c79RdO4PqopUXV7G85zhEzbCVCRyCi
   pA7FfbMoEBhDluGt26EXXZZNt0hZg0mcDtjYXJzlym9/9HRRycjcKqQnj
   tx3Dt9nR9+tZOgf7jIyKBDz7HKcJq+hAMyMmWAQjRMr6dIAqdFUvNa+dY
   g==;
X-CSE-ConnectionGUID: u6GFlxepR2+DdVMil/xgjQ==
X-CSE-MsgGUID: WwDFMw4QQ7StUOqq2UBwmw==
X-IronPort-AV: E=McAfee;i="6800,10657,11469"; a="52508574"
X-IronPort-AV: E=Sophos;i="6.16,250,1744095600"; 
   d="scan'208";a="52508574"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jun 2025 18:30:37 -0700
X-CSE-ConnectionGUID: 6VYokZolTyKhAXXm5tVRog==
X-CSE-MsgGUID: Jfga7mUpQEut13tpMjmdeA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,250,1744095600"; 
   d="scan'208";a="181800456"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.247.1]) ([10.124.247.1])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jun 2025 18:30:33 -0700
Message-ID: <3133d5e9-18d3-499a-a24d-170be7fb8357@intel.com>
Date: Fri, 20 Jun 2025 09:30:30 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/3] TDX attestation support and GHCI fixup
To: Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org, seanjc@google.com
Cc: rick.p.edgecombe@intel.com, kai.huang@intel.com, adrian.hunter@intel.com,
 reinette.chatre@intel.com, tony.lindgren@intel.com,
 isaku.yamahata@intel.com, yan.y.zhao@intel.com,
 mikko.ylinen@linux.intel.com, kirill.shutemov@intel.com,
 jiewen.yao@intel.com, binbin.wu@linux.intel.com
References: <20250619180159.187358-1-pbonzini@redhat.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20250619180159.187358-1-pbonzini@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/20/2025 2:01 AM, Paolo Bonzini wrote:
> This is a refresh of Binbin's patches with a change to the userspace
> API.  I am consolidating everything into a single KVM_EXIT_TDX and
> adding to the contract that userspace is free to ignore it *except*
> for having to reenter the guest with KVM_RUN.
> 
> If in the future this does not work, it should be possible to introduce
> an opt-in interface.  Hopefully that will not be necessary.

For <GetTdVmCallInfo> exit, I think KVM still needs to report which 
TDVMCALL leaf will exit to userspace, to differentiate between different 
KVMs.

But it's not a must for current <GetQuote> since it exits to userspace 
from day 0. So that we can leave the report interface until KVM needs to 
support user exit of another TDVMCALL leaf.

> Paolo
> 
> Binbin Wu (3):
>    KVM: TDX: Add new TDVMCALL status code for unsupported subfuncs
>    KVM: TDX: Handle TDG.VP.VMCALL<GetQuote>
>    KVM: TDX: Exit to userspace for GetTdVmCallInfo
> 
>   Documentation/virt/kvm/api.rst    | 62 ++++++++++++++++++++++++-
>   arch/x86/include/asm/shared/tdx.h |  1 +
>   arch/x86/kvm/vmx/tdx.c            | 77 ++++++++++++++++++++++++++++---
>   include/uapi/linux/kvm.h          | 22 +++++++++
>   4 files changed, 154 insertions(+), 8 deletions(-)
> 


