Return-Path: <kvm+bounces-28383-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id DB78799806E
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2024 10:44:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id ECE8B1C25BBA
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2024 08:44:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BD2BE1CEABF;
	Thu, 10 Oct 2024 08:25:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cxw9ZSXN"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70D851CDFD1;
	Thu, 10 Oct 2024 08:25:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728548738; cv=none; b=oVUseGGkkdxSLFeS/o5G28sj+8t00LzsaG+th877dcKWtkxQLTopuE3XPzhxgENJV2oSQ8AyUpEVgSrPMpGf6jZei0VblOtsbHOcOkRGDlfiP6ibJmji/oondwV/NLG1J7iu5dzWyRb78fSef8NSUZtzCtU8oYNlGUrcBiFmfeQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728548738; c=relaxed/simple;
	bh=15x++F0Q/LooMlJFkHsqO5sjfmQAhf7B+fsCUFc+rKc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=h2281QdWE57hcO/DGBCCv5cCpS1vt5J1/nqSsxvlF5UIxuA5BpPY/Lg1b8fYcjpp1pYDM62+opOqJ2EXB8rtRViGs0XRn/M/DTwVp0mNIN95lqOwbt9Oxb2Bcy+D2Dyj4KYRL5QgeFuCzsETe7MHF+bxoHHc87rznnmxXncOBDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cxw9ZSXN; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1728548737; x=1760084737;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=15x++F0Q/LooMlJFkHsqO5sjfmQAhf7B+fsCUFc+rKc=;
  b=cxw9ZSXNaE6yXMwesL7bKSShEOG5H2YCwryZ1i1n08zSI8iG95elMoW7
   vStDBYDc388DHgw8+4Ntgx8n1RTrcl7FQMOa8J+UAfdQOtaJ0rUj66h37
   eTGGzWeGD3ZUawrlD+yGoyIqBORZiifGNediT7yFIZ1l/dG5l+SFdj1RZ
   NYjBa8tFl4Eb7ZbLmzm5huyML9XwEDc6vF2pViC8vmbjVhEXaLGd36sMZ
   8HpA1ap1R5y0CKz7uTEJAaArorFC1GhAcydz8Ouk+EVmU3GWdW7fKmq84
   BeEXIyXz8Lh5UOoHCkx6dOqPNKBERdZLHMI4qcn+o8EgIuilsX1Whupuk
   g==;
X-CSE-ConnectionGUID: ZKedd26SQmim00YhZTj3zA==
X-CSE-MsgGUID: GOuZJ07HTSmDX/QVisMPeg==
X-IronPort-AV: E=McAfee;i="6700,10204,11220"; a="38476776"
X-IronPort-AV: E=Sophos;i="6.11,192,1725346800"; 
   d="scan'208";a="38476776"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Oct 2024 01:25:37 -0700
X-CSE-ConnectionGUID: 7gO9eyIbSUqHBJCe20jtdw==
X-CSE-MsgGUID: e+LPmEbnQWiJMtNB8Ju7LA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,192,1725346800"; 
   d="scan'208";a="81317496"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.240.26]) ([10.124.240.26])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Oct 2024 01:25:35 -0700
Message-ID: <3275645a-ffd9-4dd4-bfa4-037186a989ae@intel.com>
Date: Thu, 10 Oct 2024 16:25:30 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 10/25] KVM: TDX: Initialize KVM supported capabilities
 when module setup
To: Tony Lindgren <tony.lindgren@linux.intel.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: Nikolay Borisov <nik.borisov@suse.com>,
 Rick Edgecombe <rick.p.edgecombe@intel.com>, seanjc@google.com,
 kvm@vger.kernel.org, kai.huang@intel.com, isaku.yamahata@gmail.com,
 linux-kernel@vger.kernel.org
References: <20240812224820.34826-1-rick.p.edgecombe@intel.com>
 <20240812224820.34826-11-rick.p.edgecombe@intel.com>
 <b8ed694f-3ab1-453c-b14b-25113defbdb6@suse.com>
 <Zs_-YqQ-9MUAEubx@tlindgre-MOBL1>
 <b3a46758-b0ac-4136-934b-ec38fc845eeb@redhat.com>
 <ZuFPBPLy9MqgTsR1@tlindgre-MOBL1>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <ZuFPBPLy9MqgTsR1@tlindgre-MOBL1>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/11/2024 7:04 PM, Tony Lindgren wrote:
> On Tue, Sep 10, 2024 at 07:15:12PM +0200, Paolo Bonzini wrote:
>> On 8/29/24 06:51, Tony Lindgren wrote:
>>>> nit: Since there are other similarly named functions that come later how
>>>> about rename this to init_kvm_tdx_caps, so that it's clear that the
>>>> functions that are executed ones are prefixed with "init_" and those that
>>>> will be executed on every TDV boot up can be named prefixed with "setup_"
>>> We can call setup_kvm_tdx_caps() from from tdx_get_kvm_supported_cpuid(),
>>> and drop the struct kvm_tdx_caps. So then the setup_kvm_tdx_caps() should
>>> be OK.
>>
>> I don't understand this suggestion since tdx_get_capabilities() also needs
>> kvm_tdx_caps.  I think the code is okay as it is with just the rename that
>> Nik suggested (there are already some setup_*() functions in KVM but for
>> example setup_vmcs_config() is called from hardware_setup()).
> 
> Oh sorry for the confusion, looks like I pasted the function names wrong
> way around above and left out where setup_kvm_tdx_caps() can be called
> from.
> 
> I meant only tdx_get_capabilities() needs to call setup_kvm_tdx_caps().
> And setup_kvm_tdx_caps() calls tdx_get_kvm_supported_cpuid().
> 
> The data in kvm_tdx_caps is only needed for tdx_get_capabilities(). It can
> be generated from the data already in td_conf.
> 
> At least that's what it looks like to me, but maybe I'm missing something.

kvm_tdx_caps is setup in __tdx_bringup() because it also serves the 
purpose to validate the KVM's capabilities against the specific TDX 
module. If KVM and TDX module are incompatible, it needs to fail the 
bring up of TDX in KVM. It's too late to validate it when 
KVM_TDX_CAPABILITIES issued.  E.g., if the TDX module reports some 
fixed-1 attribute bit while KVM isn't aware of, in such case KVM needs 
to set enable_tdx to 0 to reflect that TDX cannot be enabled/brought up.

> Regards,
> 
> Tony


