Return-Path: <kvm+bounces-43037-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2F116A834ED
	for <lists+kvm@lfdr.de>; Thu, 10 Apr 2025 02:06:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7300F8C154C
	for <lists+kvm@lfdr.de>; Thu, 10 Apr 2025 00:06:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3FF31BA33;
	Thu, 10 Apr 2025 00:06:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XN+Ogr+n"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACFD44685;
	Thu, 10 Apr 2025 00:06:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744243605; cv=none; b=C2Yhr3GDaDpf5nl5eM6WPve54o+J2lXH+LgF4R+W16nNP4lMDj9sekamvROEnL0jHz61NN3YxO/wU2CPFSgAefQLlFdeCyONVABWG3nHmt0fpy2KijymOQVS472GRh0vu06/iZV9s3qo79PdK2IdDokQrX8qKPKuisfaiC1HHEE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744243605; c=relaxed/simple;
	bh=OLodTnTgJkofh6jLGFZarJ/OW/GdDgxrc1bqoT8ziB4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SkcGnzgdsUpbFmMqU1kP9zZPBnRAC2d2hTtExwpGnYq9dAG95EJQNjoep0EBl7ljGIXmYHQJnS2J9Vz++PciQtvgYWTvJaZ5UNWd9YKf/RhZTxHFOS2/AzEc8vVinbQwwthLNZ8NZCcyyEgPpDny7mDXE8e1Y16k7MP/5ny0vs4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XN+Ogr+n; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1744243604; x=1775779604;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=OLodTnTgJkofh6jLGFZarJ/OW/GdDgxrc1bqoT8ziB4=;
  b=XN+Ogr+nRbfGYJQFqePKZqUsz5l15/OWUaC3MD0v7gnSTvqjgnUCYmxf
   V2trdK5AJ7jSs1cm3hPWfBOzxx4cmvOQgofDiVv6aGPeeVpDfD27S2JBS
   7A03m/ehSHVaJ1rmO0cj534jkoMJkTVo8I13gJZcQpdakNBmGj2WLn/72
   iD1loKXd8kRhr3LeYZ5wZHU07OaFnEyvt+i+2jLLX7zHaAVoXfQXsooZq
   147iQ9jFSjlBfwqD62s2rYBgNf++zY+1Su8IiVrk32H46hA7LkruCwkEq
   6jUqOmUQTob/dTaBWWCcf0YZJShE4oEtslKe5e+xRLKxqGLKZe2xZCFE+
   g==;
X-CSE-ConnectionGUID: MGsBwlHrQ42YoirePA1AqQ==
X-CSE-MsgGUID: D1I67MXNR8+P0u/Ff0jr2Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11399"; a="33350022"
X-IronPort-AV: E=Sophos;i="6.15,201,1739865600"; 
   d="scan'208";a="33350022"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Apr 2025 17:06:43 -0700
X-CSE-ConnectionGUID: e8jag2BrTN2cTH1GFXRBZw==
X-CSE-MsgGUID: /ESmiYJiRQ+AbIVbpGK40A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,201,1739865600"; 
   d="scan'208";a="159718665"
Received: from yuntin1x-mobl1.ccr.corp.intel.com (HELO [10.238.11.203]) ([10.238.11.203])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Apr 2025 17:06:40 -0700
Message-ID: <dc825cf8-eb78-47ad-8e3e-509183624368@linux.intel.com>
Date: Thu, 10 Apr 2025 08:06:37 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] KVM: TDX: Handle TDG.VP.VMCALL<GetQuote>
To: Sean Christopherson <seanjc@google.com>
Cc: Kai Huang <kai.huang@intel.com>, "kvm@vger.kernel.org"
 <kvm@vger.kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
 Chao Gao <chao.gao@intel.com>, Rick P Edgecombe
 <rick.p.edgecombe@intel.com>,
 "mikko.ylinen@linux.intel.com" <mikko.ylinen@linux.intel.com>,
 Xiaoyao Li <xiaoyao.li@intel.com>, Tony Lindgren <tony.lindgren@intel.com>,
 Adrian Hunter <adrian.hunter@intel.com>,
 Reinette Chatre <reinette.chatre@intel.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 Yan Y Zhao <yan.y.zhao@intel.com>, Isaku Yamahata <isaku.yamahata@intel.com>
References: <20250402001557.173586-1-binbin.wu@linux.intel.com>
 <20250402001557.173586-2-binbin.wu@linux.intel.com>
 <40f3dcc964bfb5d922cf09ddf080d53c97d82273.camel@intel.com>
 <112c4cdb-4757-4625-ad18-9402340cd47e@linux.intel.com>
 <Z_Z61UlNM1vlEdW1@google.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <Z_Z61UlNM1vlEdW1@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 4/9/2025 9:49 PM, Sean Christopherson wrote:
> On Wed, Apr 02, 2025, Binbin Wu wrote:
>> On 4/2/2025 8:53 AM, Huang, Kai wrote:
>>>> +static int tdx_get_quote(struct kvm_vcpu *vcpu)
>>>> +{
>>>> +	struct vcpu_tdx *tdx = to_tdx(vcpu);
>>>> +
>>>> +	u64 gpa = tdx->vp_enter_args.r12;
>>>> +	u64 size = tdx->vp_enter_args.r13;
>>>> +
>>>> +	/* The buffer must be shared memory. */
>>>> +	if (vt_is_tdx_private_gpa(vcpu->kvm, gpa) || size == 0) {
>>>> +		tdvmcall_set_return_code(vcpu, TDVMCALL_STATUS_INVALID_OPERAND);
>>>> +		return 1;
>>>> +	}
>>> It is a little bit confusing about the shared buffer check here.  There are two
>>> perspectives here:
>>>
>>> 1) the buffer has already been converted to shared, i.e., the attributes are
>>> stored in the Xarray.
>>> 2) the GPA passed in the GetQuote must have the shared bit set.
>>>
>>> The key is we need 1) here.  From the spec, we need the 2) as well because it
>>> *seems* that the spec requires GetQuote to provide the GPA with shared bit set,
>>> as it says "Shared GPA as input".
>>>
>>> The above check only does 2).  I think we need to check 1) as well, because once
>>> you forward this GetQuote to userspace, userspace is able to access it freely.
> (1) is inherently racy.  By the time KVM exits to userspace, the page could have
> already been converted to private in the memory attributes.  KVM doesn't control
> shared<=>private conversions, so ultimately it's userspace's responsibility to
> handle this check.  E.g. userspace needs to take its lock on conversions across
> the check+access on the buffer.  Or if userpsace unmaps its shared mappings when
> a gfn is private, userspace could blindly access the region and handle the
> resulting SIGBUS (or whatever error manifests).
>
> For (2), the driving motiviation for doing the checks (or not) is KVM's ABI.
> I.e. whether nor KVM should handle the check depends on what KVM does for
> similar exits to userspace.  Helping userspace is nice-to-have, but not mandatory
> (and helping userspace can also create undesirable ABI).
>
> My preference would be that KVM doesn't bleed the SHARED bit into its exit ABI.
> And at a glance, that's exactly what KVM does for KVM_HC_MAP_GPA_RANGE.  In
> __tdx_map_gpa(), the so called "direct" bits are dropped (OMG, who's brilliant
> idea was it to add more use of "direct" in the MMU code):
>
> 	tdx->vcpu.run->hypercall.args[0] = gpa & ~gfn_to_gpa(kvm_gfn_direct_bits(tdx->vcpu.kvm));
> 	tdx->vcpu.run->hypercall.args[1] = size / PAGE_SIZE;
> 	tdx->vcpu.run->hypercall.args[2] = vt_is_tdx_private_gpa(tdx->vcpu.kvm, gpa) ?
> 					   KVM_MAP_GPA_RANGE_ENCRYPTED :
> 					   KVM_MAP_GPA_RANGE_DECRYPTED;
GetQuote is the first TDX specific KVM exit reason, previous TDVMCALLs that
exit to userspace are converted to exist KVM exit ABIs, e.g., TDVMCALL_MAP_GPA
is converted to KVM_EXIT_HYPERCALL with KVM_HC_MAP_GPA_RANGE, so the GPA passed
to userspace must have the shared bit dropped.

>
> So, KVM should keep the vt_is_tdx_private_gpa(), but KVM also needs to strip the
> SHARED bit from the GPA reported to userspace.
It makes sense to make the GPA format consistent to userspace.
Thanks for the suggestion!

