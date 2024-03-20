Return-Path: <kvm+bounces-12214-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C897D880CDC
	for <lists+kvm@lfdr.de>; Wed, 20 Mar 2024 09:15:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 82707282778
	for <lists+kvm@lfdr.de>; Wed, 20 Mar 2024 08:15:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 694C92E62E;
	Wed, 20 Mar 2024 08:15:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="aSR1T30Y"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60F3732C88;
	Wed, 20 Mar 2024 08:15:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710922533; cv=none; b=jo9wKnP4Sk6ofEnabzhy7Kuxyst3dY16s4Kx6tlKKtIxw6Iut2DKU7g6YimxC5kJxJLXKDuu7yP1DipQG/x+LvwAv6up55aDNybm21dVgVkSN8U4unxpTSJyiTeeXYrtFoXM7i86bkZp4KrFloN9tlNwHvEJRmjOW5hG0q1jIGE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710922533; c=relaxed/simple;
	bh=h9HIO8VuvpI1WqTJ4Bhe68D/lm3eG/5STtea5dda5jE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=huMVciMSJioMO2E5I0VGoP7joHd1CYNDcMJwTsqpV5OIBf5IK2Y5TOf3DSCGxSv+DbEeeLWeumzFCSmSCDp3S667ZPvtdMzHUOxnDvUoiaaiqgCbXGRp/DH0zTfXyPLd1sCeZV/ZAXbKmEoGtWJjxjZLMDHluy34WrzckbDVXPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=aSR1T30Y; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1710922532; x=1742458532;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=h9HIO8VuvpI1WqTJ4Bhe68D/lm3eG/5STtea5dda5jE=;
  b=aSR1T30YLubItPjT7CfUGwM8GHgTfPTU/47qvbtg6vJuX82sB/AJhlZB
   MI+pED+gS9gz5s+Gn8trSBA57U+hti0D6HXZL9prff6BVDlabeK46FVIT
   gH03QwKZ2IuHw7DpCXZiVXtwdII2o60JS19Tun5yYBtBWX7Enwx4b4lZK
   Y4LFvf+7qsawmpYS5l2bOdSNJ33cRmiG4Ce3zwU6SOfypoZgZEB6hSIEQ
   CxhbTVe4Fm4CwiUxrt5mNeyfdIidXoL0xKZG+anW42pvZu9Bwv+ReSxDx
   6V7UEI4ujkB+d3h424g6j7T00bZQyhiQ5Y8B4b97+juga7oFl1r84ahYw
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,11018"; a="16976023"
X-IronPort-AV: E=Sophos;i="6.07,139,1708416000"; 
   d="scan'208";a="16976023"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2024 01:15:30 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,139,1708416000"; 
   d="scan'208";a="45046185"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.242.48]) ([10.124.242.48])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2024 01:15:26 -0700
Message-ID: <5702443b-510e-4ce5-823f-999582a6aced@intel.com>
Date: Wed, 20 Mar 2024 16:15:23 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v19 039/130] KVM: TDX: initialize VM with TDX specific
 parameters
Content-Language: en-US
To: isaku.yamahata@intel.com, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org
Cc: isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
 erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
 Sagi Shahar <sagis@google.com>, Kai Huang <kai.huang@intel.com>,
 chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <5eca97e6a3978cf4dcf1cff21be6ec8b639a66b9.1708933498.git.isaku.yamahata@intel.com>
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <5eca97e6a3978cf4dcf1cff21be6ec8b639a66b9.1708933498.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/26/2024 4:25 PM, isaku.yamahata@intel.com wrote:

...

> +static int setup_tdparams_xfam(struct kvm_cpuid2 *cpuid, struct td_params *td_params)
> +{
> +	const struct kvm_cpuid_entry2 *entry;
> +	u64 guest_supported_xcr0;
> +	u64 guest_supported_xss;
> +
> +	/* Setup td_params.xfam */
> +	entry = kvm_find_cpuid_entry2(cpuid->entries, cpuid->nent, 0xd, 0);
> +	if (entry)
> +		guest_supported_xcr0 = (entry->eax | ((u64)entry->edx << 32));
> +	else
> +		guest_supported_xcr0 = 0;
> +	guest_supported_xcr0 &= kvm_caps.supported_xcr0;
> +
> +	entry = kvm_find_cpuid_entry2(cpuid->entries, cpuid->nent, 0xd, 1);
> +	if (entry)
> +		guest_supported_xss = (entry->ecx | ((u64)entry->edx << 32));
> +	else
> +		guest_supported_xss = 0;
> +
> +	/*
> +	 * PT and CET can be exposed to TD guest regardless of KVM's XSS, PT
> +	 * and, CET support.
> +	 */
> +	guest_supported_xss &=
> +		(kvm_caps.supported_xss | XFEATURE_MASK_PT | TDX_TD_XFAM_CET);
> +
> +	td_params->xfam = guest_supported_xcr0 | guest_supported_xss;
> +	if (td_params->xfam & XFEATURE_MASK_LBR) {
> +		/*
> +		 * TODO: once KVM supports LBR(save/restore LBR related
> +		 * registers around TDENTER), remove this guard.
> +		 */
> +#define MSG_LBR	"TD doesn't support LBR yet. KVM needs to save/restore IA32_LBR_DEPTH properly.\n"
> +		pr_warn(MSG_LBR);
> +		return -EOPNOTSUPP;

This unsupported behavior is totally decided by KVM even if TDX module 
supports it. I think we need to reflect it in tdx_info->xfam_fixed0, 
which gets reported to userspace via KVM_TDX_CAPABILITIES. So userspace 
will aware that LBR is not supported for TDs.

> +	}
> +
> +	return 0;
> +}
> +
> +static int setup_tdparams(struct kvm *kvm, struct td_params *td_params,
> +			struct kvm_tdx_init_vm *init_vm)
> +{
> +	struct kvm_cpuid2 *cpuid = &init_vm->cpuid;
> +	int ret;
> +
> +	if (kvm->created_vcpus)
> +		return -EBUSY;
> +
> +	if (init_vm->attributes & TDX_TD_ATTRIBUTE_PERFMON) {
> +		/*
> +		 * TODO: save/restore PMU related registers around TDENTER.
> +		 * Once it's done, remove this guard.
> +		 */
> +#define MSG_PERFMON	"TD doesn't support perfmon yet. KVM needs to save/restore host perf registers properly.\n"
> +		pr_warn(MSG_PERFMON);
> +		return -EOPNOTSUPP;

similar as above, we need reflect it in tdx_info->attributes_fixed0

> +	}
> +


