Return-Path: <kvm+bounces-32726-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1ED889DB2E8
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2024 07:51:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C5D3D281825
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2024 06:51:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CEAAA1465BD;
	Thu, 28 Nov 2024 06:51:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="C2A/s+Zo"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 097D513B590;
	Thu, 28 Nov 2024 06:51:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732776669; cv=none; b=uXmL/hkTJ6PVKPL1S1aw/PHIWqeLyivxlxVeIkYvjOxZD/xtupsZPbm1nj3iOMlrlM8dB2kE9mbCx7Sn0jLgdSa7S+Iri4vHMKXBMPXUQVExLQfK7wF6uyXQ1do1cOLnfLWR5GlfDnWrbjzZn+mK6GtSNg8CEIj5TFNIUZjtWYE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732776669; c=relaxed/simple;
	bh=Z2z0QzyzyFSl7HNYC3s0OEXu+S0W+69xdU5xFXL8Z10=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OR6k2wuHg8twBadbw6QEf+6GCt/zTqyCftgi0rt0lv3Dw2vWL9MzAEC76XmG3QtUV17qBOPCUZopc4rR0LDV/gpSjREck6sJZnYKu8B+6nSGXRsHK8UFEobJCvOR99ToNhjm+mGb+IOWcCdHm72blva1S55EWPOe/QHUH9bbGqc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=C2A/s+Zo; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1732776667; x=1764312667;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Z2z0QzyzyFSl7HNYC3s0OEXu+S0W+69xdU5xFXL8Z10=;
  b=C2A/s+ZoizGZOTQPgjaKvUOTGQEbq+6MGQwI75mvk+k3Q8MNYcCfULhd
   43AhVcxUbCcIvZRfSqXfzo7CQN+YLuOVJWpwMEuUF9CdJ/lsYKBRcHhbM
   4pvavFise9QswNG8h3mtIoxcp5pvUeDQNAGH0LbdMWwaTWBWwWESTuNZJ
   AoRnOY2sAmvbIWFaLh045qJTHlINwT7DkW4YGA+sypGQpvQXtrnP2M8mK
   Ma/tLCl/v4gGD2iDO9ndfKnehA/ycz+D3srTHrE+of03BGWxNnjqC2vM0
   XwGgywXBbt0Pen0Q03xJnEcEEWS7CH/nttQmonyyYMLJkxKPPhNwfeiNl
   A==;
X-CSE-ConnectionGUID: juhAohp+SmSeld3zAs6OIg==
X-CSE-MsgGUID: IXfLGspwQYWW2ofu5GEyiA==
X-IronPort-AV: E=McAfee;i="6700,10204,11269"; a="20590435"
X-IronPort-AV: E=Sophos;i="6.12,191,1728975600"; 
   d="scan'208";a="20590435"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Nov 2024 22:51:06 -0800
X-CSE-ConnectionGUID: RoqwNJYuSDGgNavJOzqJrg==
X-CSE-MsgGUID: Tau+qCbeRPGMSEYE3rUM4g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,191,1728975600"; 
   d="scan'208";a="97111235"
Received: from ahunter6-mobl1.ger.corp.intel.com (HELO [10.0.2.15]) ([10.245.89.141])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Nov 2024 22:51:00 -0800
Message-ID: <5f4e8e8d-81e8-4cf3-bda1-4858fa1f2fff@intel.com>
Date: Thu, 28 Nov 2024 08:50:53 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/7] KVM: TDX: restore host xsave state when exit from the
 guest TD
To: Chao Gao <chao.gao@intel.com>
Cc: pbonzini@redhat.com, seanjc@google.com, kvm@vger.kernel.org,
 dave.hansen@linux.intel.com, rick.p.edgecombe@intel.com,
 kai.huang@intel.com, reinette.chatre@intel.com, xiaoyao.li@intel.com,
 tony.lindgren@linux.intel.com, binbin.wu@linux.intel.com,
 dmatlack@google.com, isaku.yamahata@intel.com, nik.borisov@suse.com,
 linux-kernel@vger.kernel.org, x86@kernel.org, yan.y.zhao@intel.com,
 weijiang.yang@intel.com
References: <20241121201448.36170-1-adrian.hunter@intel.com>
 <20241121201448.36170-5-adrian.hunter@intel.com> <Z0AbZWd/avwcMoyX@intel.com>
 <a42183ab-a25a-423e-9ef3-947abec20561@intel.com> <Z0UwWT9bvmdOZiiq@intel.com>
Content-Language: en-US
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
In-Reply-To: <Z0UwWT9bvmdOZiiq@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 26/11/24 04:20, Chao Gao wrote:
> On Mon, Nov 25, 2024 at 01:10:37PM +0200, Adrian Hunter wrote:
>> On 22/11/24 07:49, Chao Gao wrote:
>>>> +static void tdx_restore_host_xsave_state(struct kvm_vcpu *vcpu)
>>>> +{
>>>> +	struct kvm_tdx *kvm_tdx = to_kvm_tdx(vcpu->kvm);
>>>> +
>>>> +	if (static_cpu_has(X86_FEATURE_XSAVE) &&
>>>> +	    kvm_host.xcr0 != (kvm_tdx->xfam & kvm_caps.supported_xcr0))
>>>> +		xsetbv(XCR_XFEATURE_ENABLED_MASK, kvm_host.xcr0);
>>>> +	if (static_cpu_has(X86_FEATURE_XSAVES) &&
>>>> +	    /* PT can be exposed to TD guest regardless of KVM's XSS support */
>>>> +	    kvm_host.xss != (kvm_tdx->xfam &
>>>> +			 (kvm_caps.supported_xss | XFEATURE_MASK_PT |
>>>> +			  XFEATURE_MASK_CET_USER | XFEATURE_MASK_CET_KERNEL)))
>>>
>>> Should we drop CET/PT from this series? I think they are worth a new
>>> patch/series.
>>
>> This is not really about CET/PT
>>
>> What is happening here is that we are calculating the current
>> MSR_IA32_XSS value based on the TDX Module spec which says the
>> TDX Module sets MSR_IA32_XSS to the XSS bits from XFAM.  The
>> TDX Module does that literally, from TDX Module source code:
>>
>> 	#define XCR0_SUPERVISOR_BIT_MASK            0x0001FD00
>> and
>> 	ia32_wrmsr(IA32_XSS_MSR_ADDR, xfam & XCR0_SUPERVISOR_BIT_MASK);
>>
>> For KVM, rather than:
>>
>> 			kvm_tdx->xfam &
>> 			 (kvm_caps.supported_xss | XFEATURE_MASK_PT |
>> 			  XFEATURE_MASK_CET_USER | XFEATURE_MASK_CET_KERNEL)
>>
>> it would be more direct to define the bits and enforce them
>> via tdx_get_supported_xfam() e.g.
>>
>> /* 
>> * Before returning from TDH.VP.ENTER, the TDX Module assigns:
>> *   XCR0 to the TD’s user-mode feature bits of XFAM (bits 7:0, 9)
>> *   IA32_XSS to the TD's supervisor-mode feature bits of XFAM (bits 8, 16:10)
>> */
>> #define TDX_XFAM_XCR0_MASK	(GENMASK(7, 0) | BIT(9))
>> #define TDX_XFAM_XSS_MASK	(GENMASK(16, 10) | BIT(8))
>> #define TDX_XFAM_MASK		(TDX_XFAM_XCR0_MASK | TDX_XFAM_XSS_MASK)
>>
>> static u64 tdx_get_supported_xfam(const struct tdx_sys_info_td_conf *td_conf)
>> {
>> 	u64 val = kvm_caps.supported_xcr0 | kvm_caps.supported_xss;
>>
>> 	/* Ensure features are in the masks */
>> 	val &= TDX_XFAM_MASK;
> 
> Before exposing a feature to TD VMs, both the TDX module and KVM must support
> it. In other words, kvm_tdx->xfam & kvm_caps.supported_xss should yield the
> same result as kvm_tdx->xfam & TDX_XFAM_XSS_MASK. So, to me, the current
> approach and your new proposal are functionally identical.
> 
> I prefer checking against kvm_caps.supported_xss because we don't need to
> update TDX_XFAM_XSS/XCR0_MASK when new user/supervisor xstate bits are added.

Arguably, making the addition of new XFAM bits more visible
is a good thing.

> Note kvm_caps.supported_xss/xcr0 need to be updated for normal VMs anyway.

The way the code is at the moment, that seems too fragile.
At the moment there are direct changes to XFAM bits in
tdx_get_supported_xfam() that are not reflected in supported_xss
and so have to be added to tdx_restore_host_xsave_state() as well.
That is, with the current code, changes to tdx_get_supported_xfam()
can break tdx_restore_host_xsave_state().

The new approach:
	reflects what the TDX Module does
	reflects what the TDX Module base spec says
	makes it harder to break tdx_restore_host_xsave_state()

> 
>>
>> 	if ((val & td_conf->xfam_fixed1) != td_conf->xfam_fixed1)
>> 		return 0;
>>
>> 	val &= td_conf->xfam_fixed0;
>>
>> 	return val;
>> }
>>
>> and then:
>>
>> 	if (static_cpu_has(X86_FEATURE_XSAVE) &&
>> 	    kvm_host.xcr0 != (kvm_tdx->xfam & TDX_XFAM_XCR0_MASK))
>> 		xsetbv(XCR_XFEATURE_ENABLED_MASK, kvm_host.xcr0);
>> 	if (static_cpu_has(X86_FEATURE_XSAVES) &&
>> 	    kvm_host.xss != (kvm_tdx->xfam & TDX_XFAM_XSS_MASK))
>> 		wrmsrl(MSR_IA32_XSS, kvm_host.xss);
>>


