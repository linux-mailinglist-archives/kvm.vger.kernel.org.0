Return-Path: <kvm+bounces-36223-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id CA903A18CEB
	for <lists+kvm@lfdr.de>; Wed, 22 Jan 2025 08:44:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7540C188688D
	for <lists+kvm@lfdr.de>; Wed, 22 Jan 2025 07:44:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 866101C175A;
	Wed, 22 Jan 2025 07:44:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="N5HrsORl"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B20B1BD9C7;
	Wed, 22 Jan 2025 07:44:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737531842; cv=none; b=JvogCcdaubZIzMSkWbpaVrSStZn0+3L+6lvF5cOWF/dKKpJqggSmSn/cyFL9TkayxmWLdJ6KCfabbCoXPhfMzDfvcKlJ6IFvs5kYcWh+BlDkPQsLK0l4zi7aYaB3w3LGUzseffnGuXTSUQmE+M7Z+NhU3ytqUuyNnb6Ln9LuYFA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737531842; c=relaxed/simple;
	bh=bwb28/rHGxtEir+1h5boewhCckv/VrKm7kfzCAEk2oM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tFrgEE+yS2QRtg4GjAaLOlyS5LgW8jUKv9UzjOML/bwgu97lB3NFQv72pv2/mM9feHiDFmuNNHTtDgzT1k7IrTZ4sdS/NveLUI+yOfAqsUep3U9qHOuMp648QtO1qZjvfjxZUnK1WPgonuafifZNyzzIkVnCd7x+7V2gjs8FuBU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=N5HrsORl; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1737531841; x=1769067841;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=bwb28/rHGxtEir+1h5boewhCckv/VrKm7kfzCAEk2oM=;
  b=N5HrsORl9Ca0wbZ6TR2fSHgTemuCOdInbKYOQs9Ue7lcKAmxpeT55X0a
   7l5jmb8ydxk5Vjlq2bi1VuG46OgCpoXBb1GGYSvk41Jjtz4eyOdEb7V4/
   FtPARGY+j34zOXxD4EgK3wZC++tB42uT5H2hNUaN7fs7wxGKh4MrWr9n7
   zTNvL+sJlwBie1qhQT5spkf6QCRxw77oMAVbb4I0mRMLdKBWi7NliF+Bv
   yQBMZSNru7KL2k+QrYk+WJntt/+VJdNYVbONP+2KzlJ3PrTJ65qqKPp6t
   B+j2zPfUnq5t7PALh7Q8PpRmvoHmTJ27HH+h2vLextyz9uk3WSNAg5ju8
   A==;
X-CSE-ConnectionGUID: giFZzWPwR/+DZihiXRlbTg==
X-CSE-MsgGUID: /Fx2uJWXRuayDLnyKX8mmw==
X-IronPort-AV: E=McAfee;i="6700,10204,11322"; a="37244517"
X-IronPort-AV: E=Sophos;i="6.13,224,1732608000"; 
   d="scan'208";a="37244517"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jan 2025 23:44:00 -0800
X-CSE-ConnectionGUID: Q5rLLiJhSU6b3YqdxhrxIw==
X-CSE-MsgGUID: yWWNEzhhScK4PiumDo58ug==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,224,1732608000"; 
   d="scan'208";a="112070086"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.247.1]) ([10.124.247.1])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jan 2025 23:43:58 -0800
Message-ID: <71bf1ef3-ade3-4a0c-9ec3-d095e652731a@intel.com>
Date: Wed, 22 Jan 2025 15:43:54 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 24/25] KVM: x86: Introduce KVM_TDX_GET_CPUID
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
 "pbonzini@redhat.com" <pbonzini@redhat.com>,
 "seanjc@google.com" <seanjc@google.com>
Cc: "Huang, Kai" <kai.huang@intel.com>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "Chatre, Reinette" <reinette.chatre@intel.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "Zhao, Yan Y" <yan.y.zhao@intel.com>,
 "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
 "tony.lindgren@linux.intel.com" <tony.lindgren@linux.intel.com>
References: <20241030190039.77971-1-rick.p.edgecombe@intel.com>
 <20241030190039.77971-25-rick.p.edgecombe@intel.com>
 <9e7d3f5c-156b-4257-965d-aae03beb5faa@intel.com>
 <2227406cbc6ca249c78e886c301dd39064053cc4.camel@intel.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <2227406cbc6ca249c78e886c301dd39064053cc4.camel@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 1/22/2025 4:24 AM, Edgecombe, Rick P wrote:
> On Fri, 2025-01-10 at 12:47 +0800, Xiaoyao Li wrote:
>> 0x1f needs clarification here.
>>
>> If it's going to use the maximum leaf KVM can support, it should be 0x24
>> to align with __do_cpuid_func().
>>
>> alternatively, it can use the EAX value of leaf 0 returned by TDX
>> module. That is the value TDX module presents to the TD guest.
>>
>>> +		output_e = &td_cpuid->entries[i];
>>> +		i += tdx_vcpu_get_cpuid_leaf(vcpu, leaf,
>>> +					     KVM_MAX_CPUID_ENTRIES - i - 1,
>>> +					     output_e);
>>> +	}
>>> +
>>> +	for (leaf = 0x80000000; leaf <= 0x80000008; leaf++) {
>>> +		output_e = &td_cpuid->entries[i];
>>> +		i += tdx_vcpu_get_cpuid_leaf(vcpu, leaf,
>>> +					     KVM_MAX_CPUID_ENTRIES - i - 1,
>>> +					     output_e);
> 
> Since we are not filtering by KVM supported features anymore, maybe just use the
> max leaf for the host CPU, like:

host value is not matched with the value returned by TDX module.
I.e., On my SPR machine, the boot_cpu_data.cpuid_level is 0x20, while 
TDX module returns 0x23. It at least fails to report the leaf 0x21 to 
userspace, which is a always valid leaf for TD guest.

> @@ -2790,14 +2791,14 @@ static int tdx_vcpu_get_cpuid(struct kvm_vcpu *vcpu,
> struct kvm_tdx_cmd *cmd)
>          if (!td_cpuid)
>                  return -ENOMEM;
>   
> -       for (leaf = 0; leaf <= 0x1f; leaf++) {
> +       for (leaf = 0; leaf <= boot_cpu_data.cpuid_level; leaf++) {
>                  output_e = &td_cpuid->entries[i];
>                  i += tdx_vcpu_get_cpuid_leaf(vcpu, leaf,
>                                               KVM_MAX_CPUID_ENTRIES - i - 1,
>                                               output_e);
>          }
>   
> -       for (leaf = 0x80000000; leaf <= 0x80000008; leaf++) {
> +       for (leaf = 0x80000000; leaf <= boot_cpu_data.extended_cpuid_level;
> leaf++) {
>                  output_e = &td_cpuid->entries[i];
>                  i += tdx_vcpu_get_cpuid_leaf(vcpu, leaf,
>                                               KVM_MAX_CPUID_ENTRIES - i - 1,
> 


