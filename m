Return-Path: <kvm+bounces-52600-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D4A5CB07185
	for <lists+kvm@lfdr.de>; Wed, 16 Jul 2025 11:23:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1762F5002D8
	for <lists+kvm@lfdr.de>; Wed, 16 Jul 2025 09:22:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BD8EF2F0E5E;
	Wed, 16 Jul 2025 09:22:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="em8JsdwG"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8698228A1C8;
	Wed, 16 Jul 2025 09:22:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752657775; cv=none; b=eKzetmT7T/+Yc+rmB9rv3Fly3Q3KurAnOiTaMjOfsGWkLICnKbgP6DZ9LorNTfGP/8urA099Fcu3NLmWTUeLjdjFsNkZBBQseY2CITRF4JnP+gYKzYbrUHkg2drKAI5QM7++trfVVO1z323YRU8QmjR4d5N1diMq4XT5abS+tIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752657775; c=relaxed/simple;
	bh=G6LVwBDp7eAh6QC9rW78VYnPqNiEdxXXGEvJAnWqPRY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=eF3ZhY+APJxJ6fw4PaRXWCpvTTM9bLF3wAoxXTa0K9tUI1JMXUqIF6NzxoBYNwYyTFMpBb766qFNtmbLAHA1bnwChjI2IWrRGFWhgIcmwvZng8y17Exq/YFBiBsy6+F3diT3qQcuKm0mOgYArV/rs5WDSiRRVuEhvLg2A3Qkcd8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=em8JsdwG; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752657774; x=1784193774;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=G6LVwBDp7eAh6QC9rW78VYnPqNiEdxXXGEvJAnWqPRY=;
  b=em8JsdwGI0QHT+h2XDCx6puHnRghzF1mGDWwx5dKjBxftWgy6dse7kBh
   naXHybseOCbyEc+wQ0phJFcV3mlsZ9McR/ddQvTOUUVxIzNOmJLBBmgSY
   MCXsyaccGoVXsqmoIHrzPEXKQn8ieNfH1bI/3aCu+iiKiqi+BwE1Du0aB
   dF82XMi/KjojeC369wDoLKhAal2QimzWkhwClFyBzSv3FhtUSGArnkvhH
   u9iQ13oOJFDhaKY1GSMtTojcl3sLaXH5BEZwrR6Jaf8A0bZpgmL+AKP8q
   twYA/FGRLG1bf8cXhfMnsqC3FbEtovfBUxkSGrK5I+KfC6GR9WFjSLseG
   g==;
X-CSE-ConnectionGUID: kBpmddFDRf6Oz7SCUJC+WA==
X-CSE-MsgGUID: Co/mfbitRxiDuT28s0xaog==
X-IronPort-AV: E=McAfee;i="6800,10657,11493"; a="58551912"
X-IronPort-AV: E=Sophos;i="6.16,315,1744095600"; 
   d="scan'208";a="58551912"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jul 2025 02:22:53 -0700
X-CSE-ConnectionGUID: ssCXaxdRRsu8QMEclcBdmA==
X-CSE-MsgGUID: TXexrf8/QYmU1y20zNP0sg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,315,1744095600"; 
   d="scan'208";a="156851100"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.247.1]) ([10.124.247.1])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jul 2025 02:22:49 -0700
Message-ID: <930ca39f-41a6-44d4-85b1-552c56a417e8@intel.com>
Date: Wed, 16 Jul 2025 17:22:45 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V4 0/1] KVM: TDX: Decrease TDX VM shutdown time
To: Sean Christopherson <seanjc@google.com>
Cc: pbonzini@redhat.com, Adrian Hunter <adrian.hunter@intel.com>,
 kvm@vger.kernel.org, rick.p.edgecombe@intel.com,
 kirill.shutemov@linux.intel.com, kai.huang@intel.com,
 reinette.chatre@intel.com, tony.lindgren@linux.intel.com,
 binbin.wu@linux.intel.com, isaku.yamahata@intel.com,
 linux-kernel@vger.kernel.org, yan.y.zhao@intel.com, chao.gao@intel.com
References: <20250611095158.19398-1-adrian.hunter@intel.com>
 <175088949072.720373.4112758062004721516.b4-ty@google.com>
 <aF1uNonhK1rQ8ViZ@google.com>
 <7103b312-b02d-440e-9fa6-ba219a510c2d@intel.com>
 <aHEMBuVieGioMVaT@google.com>
 <3989f123-6888-459b-bb65-4571f5cad8ce@intel.com>
 <aHEdg0jQp7xkOJp5@google.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <aHEdg0jQp7xkOJp5@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/11/2025 10:19 PM, Sean Christopherson wrote:
> On Fri, Jul 11, 2025, Xiaoyao Li wrote:
...
>>
>> I'm wondering if we need a TDX centralized enumeration interface, e.g., new
>> field in struct kvm_tdx_capabilities. I believe there will be more and more
>> TDX new features, and assigning each a KVM_CAP seems wasteful.
> 
> Oh, yeah, that's a much better idea.  In addition to not polluting KVM_CAP,
> 
> LOL, and we certainly have the capacity in the structure:
> 
> 	__u64 reserved[250];
> 
> Sans documentation, something like so?

I suppose it will be squashed into the original patch, so just gave

Tested-by: Xiaoyao Li <xiaoyao.li@intel.com>

> --
> diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
> index 13da87c05098..70ffe6e8d216 100644
> --- a/arch/x86/include/uapi/asm/kvm.h
> +++ b/arch/x86/include/uapi/asm/kvm.h
> @@ -963,6 +963,8 @@ struct kvm_tdx_cmd {
>          __u64 hw_error;
>   };
>   
> +#define KVM_TDX_CAP_TERMINATE_VM       _BITULL(0)
> +
>   struct kvm_tdx_capabilities {
>          __u64 supported_attrs;
>          __u64 supported_xfam;
> @@ -972,7 +974,9 @@ struct kvm_tdx_capabilities {
>          __u64 kernel_tdvmcallinfo_1_r12;
>          __u64 user_tdvmcallinfo_1_r12;
>   
> -       __u64 reserved[250];
> +       __u64 supported_caps;
> +
> +       __u64 reserved[249];
>   
>          /* Configurable CPUID bits for userspace */
>          struct kvm_cpuid2 cpuid;
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index f4d4fd5cc6e8..783b1046f6c1 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -189,6 +189,8 @@ static int init_kvm_tdx_caps(const struct tdx_sys_info_td_conf *td_conf,
>          if (!caps->supported_xfam)
>                  return -EIO;
>   
> +       caps->supported_caps = KVM_TDX_CAP_TERMINATE_VM;
> +
>          caps->cpuid.nent = td_conf->num_cpuid_config;
>   
>          caps->user_tdvmcallinfo_1_r11 =

