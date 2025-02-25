Return-Path: <kvm+bounces-39093-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id A18CCA435DF
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2025 08:00:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E5A947A3A47
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2025 06:59:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B56282586FE;
	Tue, 25 Feb 2025 07:00:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="W4iaVXM3"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9518B19F495;
	Tue, 25 Feb 2025 07:00:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740466817; cv=none; b=MNt9MXORUs8mkUnq5+0RDv76/WJfRaYMvJzH6MrJ1D4uneqWrCJgsiJARTKGcGmL6fROWpgcxwPO47ugeWblVtIqoDolYwXyTXb35VfijnBPvOcqZIQqL4LC1jtItlqZeWYYrhcETjfwcVDgoHW1r37jzleo1rVzrK2byWLblJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740466817; c=relaxed/simple;
	bh=Jm9aY5N8Dq6B/Se5BKvQ1YCroA5kAnewWsbVHEv5BFQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BW4hTlrWSH3UNVleYcxMF3jkPRAwq4PmOh20JLcDCfh2iCpraiVx1m291pfh4oBg8ohUtQZrBmK1jPp46UJXRjpztEw4kSN+Aw4oq+siTdOXw0oiMUQX6Wt4uwb+wcGYp7TjTjvH0D9ClrPFSsseb9s6tSlXpCz8wGftFrurRTQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=W4iaVXM3; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1740466816; x=1772002816;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Jm9aY5N8Dq6B/Se5BKvQ1YCroA5kAnewWsbVHEv5BFQ=;
  b=W4iaVXM3kIa2Q1Kz8QITLF7kDRIJDa+aTZUUbDdt33hvRqCtIlAARU8/
   KjCyY/X92nNsG9rZvn9p/vdq5Y5HU46Yni1kN8yna17jM5sXfXX7eztFm
   8aH9cmtHz5L6HHPD4n1DNUbVk2FW7hniJ1BFHAFA/HFOUeJja/WZWEGwn
   C/POyYrC8oWh21YJ2oezNeJDVhDwt7h5hxjLbG6Wzxxk30e2hIFz9qWQO
   9kgtBK4MH6Szg6i1C6sH0XrzmsVEZ9HkVDnSr35aaLBS2xmRJeNNkIcSU
   1KFEVIfabtl3xXY2Da3sOy5tDg8CwRhI1Etnq3+w4lTJ2Nz6KCFJL9RXG
   Q==;
X-CSE-ConnectionGUID: kjaD/FYuTsWUGz2SqNQANw==
X-CSE-MsgGUID: Epq0gFQgRXSrRVs9qgNydw==
X-IronPort-AV: E=McAfee;i="6700,10204,11355"; a="41139948"
X-IronPort-AV: E=Sophos;i="6.13,313,1732608000"; 
   d="scan'208";a="41139948"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Feb 2025 23:00:13 -0800
X-CSE-ConnectionGUID: WV/FS0LjRB2TisF+x+zDLg==
X-CSE-MsgGUID: oJ4khU6BQ8OOcG0mMINBsg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,313,1732608000"; 
   d="scan'208";a="121242251"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.247.1]) ([10.124.247.1])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Feb 2025 23:00:07 -0800
Message-ID: <84cc95e6-74a5-47b2-9f36-ae33f1e8b5c8@intel.com>
Date: Tue, 25 Feb 2025 15:00:03 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V2 08/12] KVM: x86: Allow to update cached values in
 kvm_user_return_msrs w/o wrmsr
To: Adrian Hunter <adrian.hunter@intel.com>, pbonzini@redhat.com,
 seanjc@google.com
Cc: kvm@vger.kernel.org, rick.p.edgecombe@intel.com, kai.huang@intel.com,
 reinette.chatre@intel.com, tony.lindgren@linux.intel.com,
 binbin.wu@linux.intel.com, dmatlack@google.com, isaku.yamahata@intel.com,
 nik.borisov@suse.com, linux-kernel@vger.kernel.org, yan.y.zhao@intel.com,
 chao.gao@intel.com, weijiang.yang@intel.com
References: <20250129095902.16391-1-adrian.hunter@intel.com>
 <20250129095902.16391-9-adrian.hunter@intel.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20250129095902.16391-9-adrian.hunter@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/29/2025 5:58 PM, Adrian Hunter wrote:
> From: Chao Gao <chao.gao@intel.com>
> 
> Several MSRs are constant and only used in userspace(ring 3).  But VMs may
> have different values.  KVM uses kvm_set_user_return_msr() to switch to
> guest's values and leverages user return notifier to restore them when the
> kernel is to return to userspace.  To eliminate unnecessary wrmsr, KVM also
> caches the value it wrote to an MSR last time.
> 
> TDX module unconditionally resets some of these MSRs to architectural INIT
> state on TD exit.  It makes the cached values in kvm_user_return_msrs are
> inconsistent with values in hardware.  This inconsistency needs to be
> fixed.  Otherwise, it may mislead kvm_on_user_return() to skip restoring
> some MSRs to the host's values.  kvm_set_user_return_msr() can help correct
> this case, but it is not optimal as it always does a wrmsr.  So, introduce
> a variation of kvm_set_user_return_msr() to update cached values and skip
> that wrmsr.
> 
> Signed-off-by: Chao Gao <chao.gao@intel.com>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
> Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>

Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>

> ---
> TD vcpu enter/exit v2:
>   - No changes
> 
> TD vcpu enter/exit v1:
>   - Rename functions and remove useless comment (Binbin)
> ---
>   arch/x86/include/asm/kvm_host.h |  1 +
>   arch/x86/kvm/x86.c              | 24 +++++++++++++++++++-----
>   2 files changed, 20 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 6b686d62c735..e557a441fade 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -2322,6 +2322,7 @@ int kvm_pv_send_ipi(struct kvm *kvm, unsigned long ipi_bitmap_low,
>   int kvm_add_user_return_msr(u32 msr);
>   int kvm_find_user_return_msr(u32 msr);
>   int kvm_set_user_return_msr(unsigned index, u64 val, u64 mask);
> +void kvm_user_return_msr_update_cache(unsigned int index, u64 val);
>   
>   static inline bool kvm_is_supported_user_return_msr(u32 msr)
>   {
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 5cf9f023fd4b..15447fe7687c 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -636,6 +636,15 @@ static void kvm_user_return_msr_cpu_online(void)
>   	}
>   }
>   
> +static void kvm_user_return_register_notifier(struct kvm_user_return_msrs *msrs)
> +{
> +	if (!msrs->registered) {
> +		msrs->urn.on_user_return = kvm_on_user_return;
> +		user_return_notifier_register(&msrs->urn);
> +		msrs->registered = true;
> +	}
> +}
> +
>   int kvm_set_user_return_msr(unsigned slot, u64 value, u64 mask)
>   {
>   	struct kvm_user_return_msrs *msrs = this_cpu_ptr(user_return_msrs);
> @@ -649,15 +658,20 @@ int kvm_set_user_return_msr(unsigned slot, u64 value, u64 mask)
>   		return 1;
>   
>   	msrs->values[slot].curr = value;
> -	if (!msrs->registered) {
> -		msrs->urn.on_user_return = kvm_on_user_return;
> -		user_return_notifier_register(&msrs->urn);
> -		msrs->registered = true;
> -	}
> +	kvm_user_return_register_notifier(msrs);
>   	return 0;
>   }
>   EXPORT_SYMBOL_GPL(kvm_set_user_return_msr);
>   
> +void kvm_user_return_msr_update_cache(unsigned int slot, u64 value)
> +{
> +	struct kvm_user_return_msrs *msrs = this_cpu_ptr(user_return_msrs);
> +
> +	msrs->values[slot].curr = value;
> +	kvm_user_return_register_notifier(msrs);
> +}
> +EXPORT_SYMBOL_GPL(kvm_user_return_msr_update_cache);
> +
>   static void drop_user_return_notifiers(void)
>   {
>   	struct kvm_user_return_msrs *msrs = this_cpu_ptr(user_return_msrs);


