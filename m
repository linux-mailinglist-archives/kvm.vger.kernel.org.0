Return-Path: <kvm+bounces-37832-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E7AD2A306A7
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 10:08:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 309B6160CC4
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 09:08:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 20D9F1F0E5D;
	Tue, 11 Feb 2025 09:08:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="I1Y995mP"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91DAA1E3DF8;
	Tue, 11 Feb 2025 09:08:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739264896; cv=none; b=sYWfuOnJ1dp6q03S6zGwM8qu9p+pzE0oRgIguiFwZodXkgvNe17PlEUOFdSd1Mn/bcW6QiQ4wz0zp/0NLUEFAbnvMi/UJXTrcMLhFFW2+HbzEuEdbKd9LMHPZh75sE+hrQar7D8y0TZBgQDr23pi2keOgsa0y+GrMFOLfnDxVNs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739264896; c=relaxed/simple;
	bh=OE5eo2QP2yH1+bZm0ixbuLvSgsIKBZKT9ra3KjtgB98=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hvyvDx4rmt/cubqmYQD7Ipr4VyDFdq8GKk6JkAc5Vad7a74N9Yj2XM5nPEjg0Zb0MciaLOxO5zcm3MMdKmRQig+WQZ5AW2fjC3wHD11q3iCHBEPdWXnn6r1kx+u1com+wk4uhYbCno7vcZjb9FU33qdXX4gRc4HKbDYbe6Zp1bs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=I1Y995mP; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1739264894; x=1770800894;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=OE5eo2QP2yH1+bZm0ixbuLvSgsIKBZKT9ra3KjtgB98=;
  b=I1Y995mPNxeX19hjoY5/O1cMn2nwRV8rG5/pZobV52HII+zRleSHx7mr
   7nr+IjC5HADE8hGIfMUXL+HFVW1Rp19i5l22JDmUo7wqdbDzPZhj4i/Ro
   oDz61NLOHMs9hpXslvQVD4mUQw8EtKd9DMYtLCB5n0XQwM/QJWhAM2KKN
   uhlPOQ+crzbYzR/l8Csb+3kiAJ1teh/bUrdo59UkHfYmdT/U7yjjv3Cy6
   tpGYFgb5eEtt6xNWA1Sv3N62UE8ezPXSO4wTO+HIm6UxcsgGVuk+a0SxR
   Xwc4JbHfBV+z+hGJejE7J2haBNwXfn4UzGnH1rb8Cuxh9pRnVAXEVFDcs
   g==;
X-CSE-ConnectionGUID: geU+U0vZQAS2uAR0aiIW2Q==
X-CSE-MsgGUID: 2hWSfUveSgeP7OuaIc3PIw==
X-IronPort-AV: E=McAfee;i="6700,10204,11341"; a="39894240"
X-IronPort-AV: E=Sophos;i="6.13,277,1732608000"; 
   d="scan'208";a="39894240"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Feb 2025 01:08:14 -0800
X-CSE-ConnectionGUID: 0vyT0Yt4R/CFBm5Q8V3Zlw==
X-CSE-MsgGUID: ce74Xdh5SXWe1MXFTxiJEQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,277,1732608000"; 
   d="scan'208";a="112218344"
Received: from unknown (HELO [10.238.9.235]) ([10.238.9.235])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Feb 2025 01:08:10 -0800
Message-ID: <175a8914-67ec-4b14-972d-98e9a1122daf@linux.intel.com>
Date: Tue, 11 Feb 2025 17:08:07 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/8] KVM: TDX: Add a place holder for handler of TDX
 hypercalls (TDG.VP.VMCALL)
To: Chao Gao <chao.gao@intel.com>
Cc: pbonzini@redhat.com, seanjc@google.com, kvm@vger.kernel.org,
 rick.p.edgecombe@intel.com, kai.huang@intel.com, adrian.hunter@intel.com,
 reinette.chatre@intel.com, xiaoyao.li@intel.com, tony.lindgren@intel.com,
 isaku.yamahata@intel.com, yan.y.zhao@intel.com, linux-kernel@vger.kernel.org
References: <20250211025442.3071607-1-binbin.wu@linux.intel.com>
 <20250211025442.3071607-4-binbin.wu@linux.intel.com>
 <Z6sNVHulm4Lovz2T@intel.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <Z6sNVHulm4Lovz2T@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 2/11/2025 4:41 PM, Chao Gao wrote:
>> +static __always_inline unsigned long tdvmcall_exit_type(struct kvm_vcpu *vcpu)
>> +{
>> +	return to_tdx(vcpu)->vp_enter_args.r10;
>> +}
> please add a newline here.
>
>> +static __always_inline unsigned long tdvmcall_leaf(struct kvm_vcpu *vcpu)
>> +{
>> +	return to_tdx(vcpu)->vp_enter_args.r11;
>> +}
> ..
>
>> +static __always_inline void tdvmcall_set_return_code(struct kvm_vcpu *vcpu,
>> +						     long val)
>> +{
>> +	to_tdx(vcpu)->vp_enter_args.r10 = val;
>> +}
> ditto.
>
>> +static __always_inline void tdvmcall_set_return_val(struct kvm_vcpu *vcpu,
>> +						    unsigned long val)
>> +{
>> +	to_tdx(vcpu)->vp_enter_args.r11 = val;
>> +}
>> +
>> static inline void tdx_hkid_free(struct kvm_tdx *kvm_tdx)
>> {
>> 	tdx_guest_keyid_free(kvm_tdx->hkid);
>> @@ -810,6 +829,7 @@ static bool tdx_guest_state_is_invalid(struct kvm_vcpu *vcpu)
>> static __always_inline u32 tdx_to_vmx_exit_reason(struct kvm_vcpu *vcpu)
>> {
>> 	struct vcpu_tdx *tdx = to_tdx(vcpu);
>> +	u32 exit_reason;
>>
>> 	switch (tdx->vp_enter_ret & TDX_SEAMCALL_STATUS_MASK) {
>> 	case TDX_SUCCESS:
>> @@ -822,7 +842,21 @@ static __always_inline u32 tdx_to_vmx_exit_reason(struct kvm_vcpu *vcpu)
>> 		return -1u;
>> 	}
>>
>> -	return tdx->vp_enter_ret;
>> +	exit_reason = tdx->vp_enter_ret;
>> +
>> +	switch (exit_reason) {
>> +	case EXIT_REASON_TDCALL:
>> +		if (tdvmcall_exit_type(vcpu))
>> +			return EXIT_REASON_VMCALL;
>> +
>> +		if (tdvmcall_leaf(vcpu) < 0x10000)
> Can you add a comment for the hard-coded 0x10000?
>
> I am wondering what would happen if the guest tries to make a tdvmcall with
> leaf=0 or leaf=1 to mislead KVM into calling the NMI/interrupt handling
> routine. Would it trigger the unknown NMI warning or effectively inject an
> interrupt into the host?
Oh, yes, it's possible.

>
> I think we should do the conversion for leafs that are defined in the current
> GHCI spec.
Yes, it should be limited to the supported leaves defined in the GHCI.
Thanks for pointing it out!

>
>> +			return tdvmcall_leaf(vcpu);
>> +		break;
>> +	default:
>> +		break;
>> +	}
>> +
>> +	return exit_reason;
>> }


