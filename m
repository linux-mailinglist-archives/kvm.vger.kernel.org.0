Return-Path: <kvm+bounces-57186-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D8BFFB5125D
	for <lists+kvm@lfdr.de>; Wed, 10 Sep 2025 11:22:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 69A68487C15
	for <lists+kvm@lfdr.de>; Wed, 10 Sep 2025 09:22:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5ABA331329F;
	Wed, 10 Sep 2025 09:22:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FRv5nYnh"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3BD42D660E;
	Wed, 10 Sep 2025 09:22:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757496147; cv=none; b=XqVl5xabcNNFByZP0AIc1fqgzORKmhQ6mgJSQMnNidTsZSsFPUqwlYjT7L6mdzp/AmgYpBR/MDOCtNDnFh+E7T36PzmHX/0mwarfh1FCOto7VEoIkxxHYkXzhOoWJdtOTD6ydiU02H5a2lzMo8IkDNrFE/JdVeMclMxb6tsbMms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757496147; c=relaxed/simple;
	bh=POyrcT+H2+ifea66XZUZbdvqwEmir36s8daZOE6z70c=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=iGgLbhoQygFkk7u524OkhmEybJ+LHLV7jGgYFbADT0qVNDxdErTld5RwNGs1dQhsNpK+f7uUMVozOFieJ6A3EjVdxSGmEle7E8YavQtJee8os+FnHcnYcVtZHkOhQ13DoyAk9U52NpZw3OzzoI/il4sW246YqzSoRMv0XVQwXZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FRv5nYnh; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1757496146; x=1789032146;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=POyrcT+H2+ifea66XZUZbdvqwEmir36s8daZOE6z70c=;
  b=FRv5nYnhXl4u6Ft0TxdamDG7fYA1Gf2CItf/QzniOot5AMFoxy1JAa79
   nZkcf4i/McbBFmaFj8dLDUk6x0bmuDLFdmzFjc4dEMKlrjdyGvHlBJu6S
   QWxIrl76bgsAFNzvAn2PxQYcE+mhDbDWMzLVGo8IwPSoaQl8co3YtCli9
   rREhZttTw/NRoxNkNf8EA/w9kVfukQwYW1r3Isd3xDeQGvtblURdFjCL7
   kvqRyUh/spcvq2FTnzzNsrtweYq1OGVIKHqGwrNONh1AHf3PFVE6iG1p1
   SUXcVNmnbL66a24Rr/1b4qYphC8/3OC56FQUN8nAK62Fxhjto0kCyyU9D
   w==;
X-CSE-ConnectionGUID: fEW1SkgTRiO+CLXOoQHQtA==
X-CSE-MsgGUID: 8V4Cw/SGRFKS908f/sfZzg==
X-IronPort-AV: E=McAfee;i="6800,10657,11548"; a="77256362"
X-IronPort-AV: E=Sophos;i="6.18,253,1751266800"; 
   d="scan'208";a="77256362"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Sep 2025 02:22:25 -0700
X-CSE-ConnectionGUID: cBdMZC66SdWbnoOpHHhlBg==
X-CSE-MsgGUID: wLv2eARwRnuaAw1fUcBlow==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,253,1751266800"; 
   d="scan'208";a="204103417"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.238.14]) ([10.124.238.14])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Sep 2025 02:22:19 -0700
Message-ID: <c0e5cd9b-6bdd-4f42-9d1b-d61a8f52f4b8@intel.com>
Date: Wed, 10 Sep 2025 17:22:15 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v14 03/22] KVM: x86: Check XSS validity against guest
 CPUIDs
To: Chao Gao <chao.gao@intel.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org
Cc: acme@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
 hpa@zytor.com, john.allen@amd.com, mingo@kernel.org, mingo@redhat.com,
 minipli@grsecurity.net, mlevitsk@redhat.com, namhyung@kernel.org,
 pbonzini@redhat.com, prsampat@amd.com, rick.p.edgecombe@intel.com,
 seanjc@google.com, shuah@kernel.org, tglx@linutronix.de,
 weijiang.yang@intel.com, x86@kernel.org, xin@zytor.com
References: <20250909093953.202028-1-chao.gao@intel.com>
 <20250909093953.202028-4-chao.gao@intel.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20250909093953.202028-4-chao.gao@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/9/2025 5:39 PM, Chao Gao wrote:
> Maintain per-guest valid XSS bits and check XSS validity against them
> rather than against KVM capabilities. This is to prevent bits that are
> supported by KVM but not supported for a guest from being set.
> 
> Opportunistically return KVM_MSR_RET_UNSUPPORTED on IA32_XSS MSR accesses
> if guest CPUID doesn't enumerate X86_FEATURE_XSAVES. Since
> KVM_MSR_RET_UNSUPPORTED takes care of host_initiated cases, drop the
> host_initiated check.
> 
> Signed-off-by: Chao Gao <chao.gao@intel.com>

Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>

<snip>
> @@ -4011,15 +4011,14 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>   		}
>   		break;
>   	case MSR_IA32_XSS:
> -		if (!msr_info->host_initiated &&
> -		    !guest_cpuid_has(vcpu, X86_FEATURE_XSAVES))
> -			return 1;
> +		if (!guest_cpuid_has(vcpu, X86_FEATURE_XSAVES))
> +			return KVM_MSR_RET_UNSUPPORTED;
>   		/*
>   		 * KVM supports exposing PT to the guest, but does not support
>   		 * IA32_XSS[bit 8]. Guests have to use RDMSR/WRMSR rather than
>   		 * XSAVES/XRSTORS to save/restore PT MSRs.
>   		 */

Not an issue of this patch, there seems not the proper place to put 
above comment.
> -		if (data & ~kvm_caps.supported_xss)
> +		if (data & ~vcpu->arch.guest_supported_xss)
>   			return 1;
>   		vcpu->arch.ia32_xss = data;
>   		vcpu->arch.cpuid_dynamic_bits_dirty = true;


