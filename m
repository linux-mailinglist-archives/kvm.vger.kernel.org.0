Return-Path: <kvm+bounces-42468-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 99F98A78F2A
	for <lists+kvm@lfdr.de>; Wed,  2 Apr 2025 14:55:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 53058188D2A5
	for <lists+kvm@lfdr.de>; Wed,  2 Apr 2025 12:53:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1EAE12397BF;
	Wed,  2 Apr 2025 12:53:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="g9LbGOmC"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87D70238D25;
	Wed,  2 Apr 2025 12:53:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743598401; cv=none; b=EWzp+a/1atZ6evzf8Se5z1zWzzSjhgD1Ho2ySFLJlKQPCAX38d69DH/kRcMlQElYoSkaCIdnyDoTbS4tJfYrwjnmTwqLOevSJK6sOPiiJJ9YBY44iGe3d2U2y2/Dva+BKaFv7Wcl/4GLUzPifTlP17oEBghCqJEX/DHsVS0KNU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743598401; c=relaxed/simple;
	bh=i+12HA/1ppKzVebGQz08npfbBGPLxXTUCObabmI6qu8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AYK2dgns5/4kCjyyhzA0LeReJi3Cv7Jb6jIK5rH5y0zDnHB0C1Vr5hyyg/7ZkQq2Exw+UYI56jMdtIPm7bmAHC88kofMYpBDA78wd0kJTjTUcz99LQs4GjDdYUaOzi3bC8h52dSF7DMaOzmrAZ1PamnfXZJl++7ZRCih0ve7nlk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=g9LbGOmC; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1743598400; x=1775134400;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=i+12HA/1ppKzVebGQz08npfbBGPLxXTUCObabmI6qu8=;
  b=g9LbGOmC7KawHpNWP3tIlDBcVxXaLnx5b+XDwsDCNUj6FsyDA2Qqxz/g
   MfB8VLHyKCgE1SipTA7TJjajopypfSgCMBlkkpGUTu1YEXYWmVZZPe3tf
   F6Ik4eRu5csYEy+Fn09SMOD9RgMH5vCjDEGmrgEBZ85Wl0qg1bv9grdX+
   8kvN2tMOjl+ErctXE99kscm4aSeGbN5wmBVFu3HhbRlGMqEh/J0lM3BUI
   oP/lrprFSMmjlpFim8JU8hT2KxYGM+Plr8a+KNYNo2QybzYYR4w+5X6hi
   JDppb9QAzusXFrXmzYCcmHhuJwOBC1H7O2EkJhtZ4Ry13oKZt6x5ECIlT
   A==;
X-CSE-ConnectionGUID: e9f6x1nlRY65jXaXal2Sig==
X-CSE-MsgGUID: /HQJmEMASmOl3K9RgT4WEw==
X-IronPort-AV: E=McAfee;i="6700,10204,11392"; a="44844882"
X-IronPort-AV: E=Sophos;i="6.15,182,1739865600"; 
   d="scan'208";a="44844882"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Apr 2025 05:53:19 -0700
X-CSE-ConnectionGUID: 4nNe4TxNSf2rbxkyi6MlcQ==
X-CSE-MsgGUID: 4YUvaZTmQZOfmnN+/ALpAQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,182,1739865600"; 
   d="scan'208";a="131885922"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.124.242.208]) ([10.124.242.208])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Apr 2025 05:53:12 -0700
Message-ID: <112c4cdb-4757-4625-ad18-9402340cd47e@linux.intel.com>
Date: Wed, 2 Apr 2025 20:53:08 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] KVM: TDX: Handle TDG.VP.VMCALL<GetQuote>
To: "Huang, Kai" <kai.huang@intel.com>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "pbonzini@redhat.com" <pbonzini@redhat.com>,
 "seanjc@google.com" <seanjc@google.com>
Cc: "Gao, Chao" <chao.gao@intel.com>,
 "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
 "mikko.ylinen@linux.intel.com" <mikko.ylinen@linux.intel.com>,
 "Li, Xiaoyao" <xiaoyao.li@intel.com>,
 "Lindgren, Tony" <tony.lindgren@intel.com>,
 "Hunter, Adrian" <adrian.hunter@intel.com>,
 "Chatre, Reinette" <reinette.chatre@intel.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "Zhao, Yan Y" <yan.y.zhao@intel.com>,
 "Yamahata, Isaku" <isaku.yamahata@intel.com>
References: <20250402001557.173586-1-binbin.wu@linux.intel.com>
 <20250402001557.173586-2-binbin.wu@linux.intel.com>
 <40f3dcc964bfb5d922cf09ddf080d53c97d82273.camel@intel.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <40f3dcc964bfb5d922cf09ddf080d53c97d82273.camel@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 4/2/2025 8:53 AM, Huang, Kai wrote:

[...]
>
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index b61371f45e78..90aa7a328dc8 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -7162,6 +7162,25 @@ The valid value for 'flags' is:
>     - KVM_NOTIFY_CONTEXT_INVALID -- the VM context is corrupted and not valid
>       in VMCS. It would run into unknown result if resume the target VM.
>   
> +::
> +
> +		/* KVM_EXIT_TDX_GET_QUOTE */
> +		struct tdx_get_quote {
> +			__u64 ret;
> +			__u64 gpa;
> +			__u64 size;
> +		};
> +
> +If the exit reason is KVM_EXIT_TDX_GET_QUOTE, then it indicates that a TDX
> +guest has requested to generate a TD-Quote signed by a service hosting
> +TD-Quoting Enclave operating on the host. The 'gpa' field and 'size' specify
> +the guest physical address and size of a shared-memory buffer, in which the
> +TDX guest passes a TD report.
>
> "TD report" -> "TD Report"?  The changelog uses the latter.
>
>> When completed, the generated quote is returned
> "quote" -> "Quote"?
>
>> +via the same buffer. The 'ret' field represents the return value.
>>
> return value of the GetQuote TDVMCALL?
Yes, thereturn code of the GetQuote TDVMCALL.
>
>> The userspace
>> +should update the return value before resuming the vCPU according to TDX GHCI
>> +spec.
>>
> I don't quite follow.  Why userspace should "update" the return value?
Because only userspace knows whether the request has been queued successfully.

According to GHCI, TDG.VP.VMCALL<GetQuote> API allows one TD to issue multiple
requests. This is implementation specific as to how many concurrent requests
are allowed.  The TD should be able to handle TDG.VP.VMCALL_RETRY if it chooses
to issue multiple requests simultaneously.
So the userspace may set the return code as TDG.VP.VMCALL_RETRY.


>
>> It's an asynchronous request. After the TDVMCALL is returned and back to
>> +TDX guest, TDX guest can poll the status field of the shared-memory area.
>> +
>>   ::
>>   
>>   		/* Fix the size of the union. */
>> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
>> index b952bc673271..535200446c21 100644
>> --- a/arch/x86/kvm/vmx/tdx.c
>> +++ b/arch/x86/kvm/vmx/tdx.c
>> @@ -1463,6 +1463,39 @@ static int tdx_get_td_vm_call_info(struct kvm_vcpu *vcpu)
>>   	return 1;
>>   }
>>   
>> +static int tdx_complete_get_quote(struct kvm_vcpu *vcpu)
>> +{
>> +	tdvmcall_set_return_code(vcpu, vcpu->run->tdx_get_quote.ret);
>> +	return 1;
>> +}
>> +
>> +static int tdx_get_quote(struct kvm_vcpu *vcpu)
>> +{
>> +	struct vcpu_tdx *tdx = to_tdx(vcpu);
>> +
>> +	u64 gpa = tdx->vp_enter_args.r12;
>> +	u64 size = tdx->vp_enter_args.r13;
>> +
>> +	/* The buffer must be shared memory. */
>> +	if (vt_is_tdx_private_gpa(vcpu->kvm, gpa) || size == 0) {
>> +		tdvmcall_set_return_code(vcpu, TDVMCALL_STATUS_INVALID_OPERAND);
>> +		return 1;
>> +	}
> It is a little bit confusing about the shared buffer check here.  There are two
> perspectives here:
>
> 1) the buffer has already been converted to shared, i.e., the attributes are
> stored in the Xarray.
> 2) the GPA passed in the GetQuote must have the shared bit set.
>
> The key is we need 1) here.  From the spec, we need the 2) as well because it
> *seems* that the spec requires GetQuote to provide the GPA with shared bit set,
> as it says "Shared GPA as input".
>
> The above check only does 2).  I think we need to check 1) as well, because once
> you forward this GetQuote to userspace, userspace is able to access it freely.

Right.

Another discussion is whether KVM should skip the sanity checks for GetQuote
and let the userspace take the job.
Considering checking the buffer is shared memory or not, KVM seems to be a
better place.

>
> As a result, the comment
>
>    /* The buffer must be shared memory. */
>
> should also be updated to something like:
>
>    /*
>     * The buffer must be shared. GetQuote requires the GPA to have
>     * shared bit set.
>     */


