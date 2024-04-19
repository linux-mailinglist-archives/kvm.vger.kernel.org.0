Return-Path: <kvm+bounces-15207-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B23048AA8DF
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 09:05:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 354DAB21829
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 07:05:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1638D3E497;
	Fri, 19 Apr 2024 07:05:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AOc+NMFp"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A928171AF;
	Fri, 19 Apr 2024 07:05:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713510303; cv=none; b=Huoja2ZJUGevBH++c44ZgaG+blVN+vlpjn7PG/ktedy8jmesNBobGBNO38G2rbhMCJMqwprbdJHk023I6xtlp8AzGObagVPluoWakANA8byN1w0U8Rs44teVEr9Q3cr6VHsH1CPgxopF67iOAApY/LkyA8D6YFY8ejTsObaUGJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713510303; c=relaxed/simple;
	bh=pMSBPEkWDp/jsic95GP6gMJqfatPqHB7pZ/fZMqhS0k=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pPNMao+L1i1cLJmamR9FjdLnmMfRouLz/DS4ZGxqlR6yPyWumCQHVq0rxSPKglpuV1PJ7Bxr5ONsE19cpadqjX5LpMvOce8gFvF7WpPu73nLyto6DzbGa0XoB9mZf+3LftiVrSUkfEBNvU/7dY2qOz7gO0KrhOYVOJlQ+6y6nEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=AOc+NMFp; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713510302; x=1745046302;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=pMSBPEkWDp/jsic95GP6gMJqfatPqHB7pZ/fZMqhS0k=;
  b=AOc+NMFpxnUz8DYj0YN0SnNxRiAfso7sWy8WsMivP9vyrYZnYXK3oxaP
   pTxwfa5wS9fdyoPkQsffkBwSbYlvBDTy2wqrbuQ3ccmgHhQGcysfr7gt8
   FNMuRrFs9ICF4ddSvym9Jw2MDnE4Us5gWvxEgOYXrnrPksJYcKO7MIyY1
   HhpC+0slzbM6bW8YiwHfeGXuXkZ0MvjpNehkKfPbq+u264245YCAS7pvm
   2f/6/HpGgzjzvY9jw1DQuOrsHy1z4P9wZ4ufU+buXWgrRRl2pXKJQuX1b
   quv4+vWvnMmYzpPgHkXrmPTCSzXbLzIeMKXje2LRebTbAmKIw3XYUIli5
   Q==;
X-CSE-ConnectionGUID: onbVQJBdR96mQ8dLkIre+Q==
X-CSE-MsgGUID: W6Hf6dsVQFe7lidSJkFEQw==
X-IronPort-AV: E=McAfee;i="6600,9927,11047"; a="8958406"
X-IronPort-AV: E=Sophos;i="6.07,213,1708416000"; 
   d="scan'208";a="8958406"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Apr 2024 00:05:01 -0700
X-CSE-ConnectionGUID: TYAZJSYfS3eHb68wJrlaXw==
X-CSE-MsgGUID: mRy+ATAURBith12OO/wGXg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,213,1708416000"; 
   d="scan'208";a="28027345"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.124.225.183]) ([10.124.225.183])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Apr 2024 00:04:57 -0700
Message-ID: <384458a2-c7be-4443-bfe3-5408a749a476@linux.intel.com>
Date: Fri, 19 Apr 2024 15:04:54 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v19 116/130] KVM: TDX: Silently discard SMI request
To: isaku.yamahata@intel.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
 erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
 Sagi Shahar <sagis@google.com>, Kai Huang <kai.huang@intel.com>,
 chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <9c4547ea234a2ba09ebe05219f180f08ac6fc2e3.1708933498.git.isaku.yamahata@intel.com>
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <9c4547ea234a2ba09ebe05219f180f08ac6fc2e3.1708933498.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 2/26/2024 4:26 PM, isaku.yamahata@intel.com wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
>
> TDX doesn't support system-management mode (SMM) and system-management
> interrupt (SMI) in guest TDs.  Because guest state (vcpu state, memory
> state) is protected, it must go through the TDX module APIs to change guest
> state, injecting SMI and changing vcpu mode into SMM.  The TDX module
> doesn't provide a way for VMM to inject SMI into guest TD and a way for VMM
                                                             ^
                                                             or

> to switch guest vcpu mode into SMM.
>
> We have two options in KVM when handling SMM or SMI in the guest TD or the
> device model (e.g. QEMU): 1) silently ignore the request or 2) return a
> meaningful error.
>
> For simplicity, we implemented the option 1).
>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
[...]
> +
> +static void vt_enable_smi_window(struct kvm_vcpu *vcpu)
> +{
> +	if (is_td_vcpu(vcpu)) {
> +		tdx_enable_smi_window(vcpu);
> +		return;

Can "return tdx_enable_smi_window(vcpu);" directly.
> +	}
> +
> +	/* RSM will cause a vmexit anyway.  */
> +	vmx_enable_smi_window(vcpu);
> +}
> +#endif
> +
[...]
>   
> +#if defined(CONFIG_INTEL_TDX_HOST) && defined(CONFIG_KVM_SMM)
> +int tdx_smi_allowed(struct kvm_vcpu *vcpu, bool for_injection);
> +int tdx_enter_smm(struct kvm_vcpu *vcpu, union kvm_smram *smram);
> +int tdx_leave_smm(struct kvm_vcpu *vcpu, const union kvm_smram *smram);
> +void tdx_enable_smi_window(struct kvm_vcpu *vcpu);
> +#else

#elif defined(CONFIG_KVM_SMM)

These functions are only needed when CONFIG_KVM_SMM is defined.

> +static inline int tdx_smi_allowed(struct kvm_vcpu *vcpu, bool for_injection) { return false; }
> +static inline int tdx_enter_smm(struct kvm_vcpu *vcpu, union kvm_smram *smram) { return 0; }
> +static inline int tdx_leave_smm(struct kvm_vcpu *vcpu, const union kvm_smram *smram) { return 0; }
> +static inline void tdx_enable_smi_window(struct kvm_vcpu *vcpu) {}
> +#endif
> +
>   #endif /* __KVM_X86_VMX_X86_OPS_H */


