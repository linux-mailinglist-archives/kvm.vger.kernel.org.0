Return-Path: <kvm+bounces-33403-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 693CF9EAD31
	for <lists+kvm@lfdr.de>; Tue, 10 Dec 2024 10:57:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5AE2C16B737
	for <lists+kvm@lfdr.de>; Tue, 10 Dec 2024 09:56:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0EC9C1DC9BE;
	Tue, 10 Dec 2024 09:50:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DWS9L0aC"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98C5878F23;
	Tue, 10 Dec 2024 09:50:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733824246; cv=none; b=W/zIyiH8X/Gls3PFOXfaMwBkobzjoRSuYdVqqooV0Gj6VA5HUiue4gk3GsBOCggjSyBlWIYwvGdBM+QBhXwv+7RLBFA6zDb+WQxWRBKZaOwZ1ZGgf84azZ1j6ak84Ud/mRLPEBSjF+eZmA6kaXDLrr6HqniGD+aUkwxTzhZ0qn4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733824246; c=relaxed/simple;
	bh=qfDYEHjLp07MGd+9Ht9U14cysYZPaH49Zpe7AYdRDdQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fDY85I/60jEtW4uR+F+gEcUoVPvgtZRuYU1zxfAVI7k/6zumgXF19vbSCDsxWRRP3ScuUv2AdQp5IhF8OWsaNeg6nFJ3i9v70VFnWH55yz7H/Ti+9BnyBqhRXRe6ujE+AiEP/HOFi6T2kmpNcCagOLfYz8faoOBkdd2kAHZ/hCY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DWS9L0aC; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1733824245; x=1765360245;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=qfDYEHjLp07MGd+9Ht9U14cysYZPaH49Zpe7AYdRDdQ=;
  b=DWS9L0aC7sTYf3ypS6hlx1zVn//4BbXNV1Y1Oxshbo+fPYqTrPvJCqPG
   G73ZR7nzF204pAlLemyP2RTeBAXAqEfJsQV2RC0jMnPtsLd7XwqcfSdN4
   EmgqlBcnvfl0NTXxjBjxaZc+AnJdGUw8loCQhK8aSbKJ1b0eqbED+ao/s
   297EuigTgQK44qxdoL6sL+Bq3QbcHXeB7+Ui4G+mUiYYtfASqAa29zzF2
   RbTF6Wr5O1N845CU5nuFRApfI9sKh30+DCFeqH6WpYKjq4IGVFzbpyw2Z
   B3opwdb7EX8VzGps6Puotoe3Nwd/I8eF2dgLGhojIl1CMCtM++gQ/py5O
   w==;
X-CSE-ConnectionGUID: kgz5rg9JSzSSKxS3r/aKIg==
X-CSE-MsgGUID: IxPCKYIFQxav2CBFo9GuvQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11281"; a="36992422"
X-IronPort-AV: E=Sophos;i="6.12,222,1728975600"; 
   d="scan'208";a="36992422"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Dec 2024 01:50:40 -0800
X-CSE-ConnectionGUID: zhTra15fRUKaWkvZNr0P/Q==
X-CSE-MsgGUID: zwIr5JgBSQG50wkS2mFn/Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,222,1728975600"; 
   d="scan'208";a="100309246"
Received: from unknown (HELO [10.238.9.154]) ([10.238.9.154])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Dec 2024 01:50:36 -0800
Message-ID: <62b3c444-36db-4ac0-bc10-e8d8a5f553c9@linux.intel.com>
Date: Tue, 10 Dec 2024 17:50:33 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6/7] KVM: TDX: Handle TDX PV port I/O hypercall
To: Chao Gao <chao.gao@intel.com>
Cc: pbonzini@redhat.com, seanjc@google.com, kvm@vger.kernel.org,
 rick.p.edgecombe@intel.com, kai.huang@intel.com, adrian.hunter@intel.com,
 reinette.chatre@intel.com, xiaoyao.li@intel.com,
 tony.lindgren@linux.intel.com, isaku.yamahata@intel.com,
 yan.y.zhao@intel.com, michael.roth@amd.com, linux-kernel@vger.kernel.org
References: <20241201035358.2193078-1-binbin.wu@linux.intel.com>
 <20241201035358.2193078-7-binbin.wu@linux.intel.com>
 <Z1gNIRWSMy2w7CYp@intel.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <Z1gNIRWSMy2w7CYp@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit




On 12/10/2024 5:42 PM, Chao Gao wrote:
>> +static int tdx_emulate_io(struct kvm_vcpu *vcpu)
>> +{
>> +	struct x86_emulate_ctxt *ctxt = vcpu->arch.emulate_ctxt;
>> +	unsigned long val = 0;
>> +	unsigned int port;
>> +	int size, ret;
>> +	bool write;
> ..
>
>> +
>> +	++vcpu->stat.io_exits;
>> +
>> +	size = tdvmcall_a0_read(vcpu);
>> +	write = tdvmcall_a1_read(vcpu);
> a1 (i.e., R13) should be either 0 or 1. Other values are reserved according to
> the GHCI spec. It is not appropriate to cast it to a boolean. For example, if
> R13=2, KVM shouldn't treat it as a write request; instead, this request should
> be rejected.
Right, will fix it.

Thanks!

>> +	port = tdvmcall_a2_read(vcpu);
>> +
>> +	if (size != 1 && size != 2 && size != 4) {
>> +		tdvmcall_set_return_code(vcpu, TDVMCALL_STATUS_INVALID_OPERAND);
>> +		return 1;
>> +	}


