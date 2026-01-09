Return-Path: <kvm+bounces-67556-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 19B23D08DFE
	for <lists+kvm@lfdr.de>; Fri, 09 Jan 2026 12:25:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id A787A301996B
	for <lists+kvm@lfdr.de>; Fri,  9 Jan 2026 11:24:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B452532A3FB;
	Fri,  9 Jan 2026 11:24:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="X1ToYGRw"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5885733C53A;
	Fri,  9 Jan 2026 11:24:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767957889; cv=none; b=s5Xr/DVqa6D89wyfQL7JOGwxAv3ZzF7ueni5yAAozvN6oBRhAmcb9sPLy5Jat6fUFi/rCHvrnOUCP2odcB+RZOBI7wWiSsPcXMA1l+VdJLpPvNlPUP8cc55MSnjVNQHCbsaszoweFp1pBTlVQ87WxyUDeyCHLlJnG0uGyJ3dsug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767957889; c=relaxed/simple;
	bh=q/g/paIlzs07m20aprwloH5qY72k2sAj5LSK5urPMFs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KigRDm+/JQ6h7R70v+78xIl3PzbtkXET3pnVy22IyM1hJWKbp7qhQ9FjiE7F1VMtO66Z3sKXRncSPs+qy55wRvkMg60bvtx0hkED3sWLUOkyAZNIGis7vwms+XB0XJl0cc8QkShZqYIBeXe4AWEiq/EN8agbvD8uq5m2pHnVt68=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=X1ToYGRw; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1767957887; x=1799493887;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=q/g/paIlzs07m20aprwloH5qY72k2sAj5LSK5urPMFs=;
  b=X1ToYGRw/uCn74nkN24SFn5Da3WEJgIQFIcV7I+opyrZaVefrk+M1QUY
   AJo3fbU9JEH+k49E1hzIWX0SUPqBCywyIYEBnk6HYpDXlRbCue6qvWfRG
   mihzwdYICR6iPcVFL/DkEhKuMuMmh5A8S++GL+2zuyaBgJOxxbq1M2b7M
   kcbwKt18e5MlKnuwr+CQ0M8pIh7o4axHfDy+i1VjE3NZMKDBvj5P98aSY
   U4oSJ7MUnSUIr+R7soULLCiwpy1iWHwR4mMM1S9ilCadB251Ze+sqjjta
   OVQ2oK4m/tZJEGgBsUZ7bVwg/WAcu4FMD7KGmpQn7J79Cd+TkUhegtrBV
   Q==;
X-CSE-ConnectionGUID: moD5QJNeSAGdl5qeUvzyBQ==
X-CSE-MsgGUID: LwHmco77QyWmodOz9i4uOA==
X-IronPort-AV: E=McAfee;i="6800,10657,11665"; a="69271925"
X-IronPort-AV: E=Sophos;i="6.21,212,1763452800"; 
   d="scan'208";a="69271925"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jan 2026 03:24:41 -0800
X-CSE-ConnectionGUID: 9Y6qGwN6QOy54cKCLYpOfA==
X-CSE-MsgGUID: 9FoaNrjSS7OimcjAoyW9QA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,212,1763452800"; 
   d="scan'208";a="207930598"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.240.173]) ([10.124.240.173])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jan 2026 03:24:37 -0800
Message-ID: <dd83c23b-80f9-42e6-a1f8-fb2f45384dbf@intel.com>
Date: Fri, 9 Jan 2026 19:24:33 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/4] KVM: nVMX: Setup VMX MSRs on loading CPU during
 nested_vmx_hardware_setup()
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Chao Gao <chao.gao@intel.com>, Xin Li <xin@zytor.com>,
 Yosry Ahmed <yosry.ahmed@linux.dev>
References: <20260109041523.1027323-1-seanjc@google.com>
 <20260109041523.1027323-2-seanjc@google.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20260109041523.1027323-2-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/9/2026 12:15 PM, Sean Christopherson wrote:
> Move the call to nested_vmx_setup_ctls_msrs() from vmx_hardware_setup() to
> nested_vmx_hardware_setup() so that the nested code can deal with ordering
> dependencies without having to straddle vmx_hardware_setup() and
> nested_vmx_hardware_setup().  Specifically, an upcoming change will
> sanitize the vmcs12 fields based on hardware support, and that code needs
> to run _before_ the MSRs are configured, because the lovely vmcs_enum MSR
> depends on the max support vmcs12 field.
> 
> No functional change intended.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>

> ---
>   arch/x86/kvm/vmx/nested.c | 2 ++
>   arch/x86/kvm/vmx/vmx.c    | 2 --
>   2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index 6137e5307d0f..61113ead3d7b 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -7407,6 +7407,8 @@ __init int nested_vmx_hardware_setup(int (*exit_handlers[])(struct kvm_vcpu *))
>   {
>   	int i;
>   
> +	nested_vmx_setup_ctls_msrs(&vmcs_config, vmx_capability.ept);
> +
>   	if (!cpu_has_vmx_shadow_vmcs())
>   		enable_shadow_vmcs = 0;
>   	if (enable_shadow_vmcs) {
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 6b96f7aea20b..5bb67566e43a 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -8670,8 +8670,6 @@ __init int vmx_hardware_setup(void)
>   	 * can hide/show features based on kvm_cpu_cap_has().
>   	 */
>   	if (nested) {
> -		nested_vmx_setup_ctls_msrs(&vmcs_config, vmx_capability.ept);
> -
>   		r = nested_vmx_hardware_setup(kvm_vmx_exit_handlers);
>   		if (r)
>   			return r;


