Return-Path: <kvm+bounces-25355-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 811D19646B1
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2024 15:34:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2A33D1F211D5
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2024 13:34:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 42DD71AED5E;
	Thu, 29 Aug 2024 13:28:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="aFhOSGW4"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A22841AED49;
	Thu, 29 Aug 2024 13:28:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724938122; cv=none; b=h+teVKvVSKiuNlKwT8y8quaJ37cq04+CwUUNJb4eIiJ+WlviVugwEC5dpnG0L6HvwiXwZpMbbmTCfUbSiZwMgTk2Ck7BLjZibYDeZUgJ7JDua5QFFYgFsZvj45YT9qy0HySMTZsWi4eachClz/RqL2AY/RgWenxuKXrofDuzDQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724938122; c=relaxed/simple;
	bh=XcZnN+sONOz86hmUv31FEtcHd4Mqk4wajnuJARJuoug=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=W8mMmfjONTpJmLWFd1v1fL+Jhy5zkuCx3TSaxYpV/9unT1mVi8j38FrsvxxKoETm/E33o0VXXFU6x4/wYZXAqYwnKxtcY32tE3GUwL/tDrdihMH9DYDgPsT/KgxjQt6ng0aIXrcVEKLvXLD15FtRZOqUt3sL5qqiQk/SQvufUs4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=aFhOSGW4; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1724938121; x=1756474121;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=XcZnN+sONOz86hmUv31FEtcHd4Mqk4wajnuJARJuoug=;
  b=aFhOSGW4YLAS6EImNHn/0wgQRnPqxVW2bfP1pwWfEukD5HFymby/QT9+
   ZBrens/drKbZ8wHWCZuRHYE1WhWBjvm6YuggJhgkM74oPQMrFNvVIA70k
   L5upXphCRVEj8VAcu4JmYljNnmubzLcUSsW1oqCgpTFgdqgrottu8fkP+
   C0EBztVxM2CXLyMog7t+Pl7sgPCtjd5AjgoyCQY9IpWp7r4eB904/dAkv
   vU+kZilp425A8PGXVUv5WytY23FZGFiYvWntD9GnmEdIrmJpKf91mZh6v
   Uo4zjEo0r79L57MdG2ZVvNhE6utIYWTThxkrzi2mZIrV67W7TMO14tAEM
   Q==;
X-CSE-ConnectionGUID: zz/zAyB/RsS1Ul4Yeqpv5A==
X-CSE-MsgGUID: q+FI3s6hSvGjeRLzXc0PHw==
X-IronPort-AV: E=McAfee;i="6700,10204,11179"; a="26427368"
X-IronPort-AV: E=Sophos;i="6.10,185,1719903600"; 
   d="scan'208";a="26427368"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Aug 2024 06:28:20 -0700
X-CSE-ConnectionGUID: g2JK1xS0QlS21QbH2+cw+Q==
X-CSE-MsgGUID: Ma4s0KDcROG8gm3cVo6j9w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,185,1719903600"; 
   d="scan'208";a="64060751"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.240.26]) ([10.124.240.26])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Aug 2024 06:28:16 -0700
Message-ID: <2947ba8d-cb5a-4db4-9c41-8ff60571e9e3@intel.com>
Date: Thu, 29 Aug 2024 21:28:14 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 10/25] KVM: TDX: Initialize KVM supported capabilities
 when module setup
To: Tao Su <tao1.su@linux.intel.com>,
 Rick Edgecombe <rick.p.edgecombe@intel.com>
Cc: seanjc@google.com, pbonzini@redhat.com, kvm@vger.kernel.org,
 kai.huang@intel.com, isaku.yamahata@gmail.com,
 tony.lindgren@linux.intel.com, linux-kernel@vger.kernel.org
References: <20240812224820.34826-1-rick.p.edgecombe@intel.com>
 <20240812224820.34826-11-rick.p.edgecombe@intel.com>
 <ZsKg2fIjo41T0VTH@linux.bj.intel.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <ZsKg2fIjo41T0VTH@linux.bj.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/19/2024 9:33 AM, Tao Su wrote:
> On Mon, Aug 12, 2024 at 03:48:05PM -0700, Rick Edgecombe wrote:
>> From: Xiaoyao Li <xiaoyao.li@intel.com>
>>
>> While TDX module reports a set of capabilities/features that it
>> supports, what KVM currently supports might be a subset of them.
>> E.g., DEBUG and PERFMON are supported by TDX module but currently not
>> supported by KVM.
>>
>> Introduce a new struct kvm_tdx_caps to store KVM's capabilities of TDX.
>> supported_attrs and suppported_xfam are validated against fixed0/1
>> values enumerated by TDX module. Configurable CPUID bits derive from TDX
>> module plus applying KVM's capabilities (KVM_GET_SUPPORTED_CPUID),
>> i.e., mask off the bits that are configurable in the view of TDX module
>> but not supported by KVM yet.
>>
> 
> But this mask is not implemented in this patch, which should be in patch24?

yes, the commit message needs to be updated. Even more the patches need 
to be re-organized.

>> KVM_TDX_CPUID_NO_SUBLEAF is the concept from TDX module, switch it to 0
>> and use KVM_CPUID_FLAG_SIGNIFCANT_INDEX, which are the concept of KVM.
>>
>> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
>> Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
> 
> [...]


