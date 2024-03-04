Return-Path: <kvm+bounces-10770-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2AFD086FBE1
	for <lists+kvm@lfdr.de>; Mon,  4 Mar 2024 09:30:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DB2C5282645
	for <lists+kvm@lfdr.de>; Mon,  4 Mar 2024 08:30:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE83917731;
	Mon,  4 Mar 2024 08:30:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gOvFZj7L"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8352A17BB6;
	Mon,  4 Mar 2024 08:30:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709541007; cv=none; b=H38Nq3KuKbcd9/Mm4dbg9aHxTYyagTpZiRbrHSLb/nO3Jt1aZB+uiF0JB4QDkhJSI0gL5v79fmE0x6kTTgr5sluWVXE/azOMiPbJQLCvYeZTPVRgxruEqjM0czEvDDzB5uLc9pAyBFXz/FwFoXL8VNTnzmd8nfi2exUBlzkU3sI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709541007; c=relaxed/simple;
	bh=YoGW//VtiZf3jZLSkMBfX0sul8AjDFh5eSagI4O10BU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kT8pkJZz9EiOENygRfCO+ydAOy9YDi61ygWs4K8sVh4mmUfeVl5KwxthuUGqYeGQZ2p9YeCJZVJnPRz8E/s9eW4yQiZ4ft77YMRZ6wt3lwgNfMXnjskUgDk9tBt9+kFAsRUs47ryGlgK6lXzorpFsJKwrUEggfJybMO5Oq9lN+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gOvFZj7L; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709541004; x=1741077004;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=YoGW//VtiZf3jZLSkMBfX0sul8AjDFh5eSagI4O10BU=;
  b=gOvFZj7LfV5DGii6xa02h3NLfnCBDIRgBImYyBGHWpfDGV33i2yma9NR
   bExm56jwlmOotqFq+e5z+4FnICu4j1g0Gh1ToMNA+VVTD+NJe2M11leWD
   Qv3AzA8Sf3RiLHMiNYN96Cgjs6R4lE8csV4EQgixU+L9Ejl/1oQAovVnk
   TKbPV3nj+m1lshJR4oUkrhiJBMCwEOz+YY2jIvCljeSGMByyokCaqsFqR
   XteHccnoRh2abCM+FrBQF1wKSUJZ4qPCI9TALpv7bhIEsfZjoM12tSkre
   uHUULos7MYMmeYbuCSa5GtJ3fCTA0iclFeW4DypQ5izwx+jZ90QLCfnYT
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,11002"; a="21476234"
X-IronPort-AV: E=Sophos;i="6.06,203,1705392000"; 
   d="scan'208";a="21476234"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2024 00:30:03 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,203,1705392000"; 
   d="scan'208";a="13497217"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.125.243.127]) ([10.125.243.127])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2024 00:30:01 -0800
Message-ID: <858bdeb8-2f83-4a10-8d4c-7e7956d8b0a6@intel.com>
Date: Mon, 4 Mar 2024 16:29:59 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 12/21] KVM: x86/tdp_mmu: Sprinkle __must_check
Content-Language: en-US
To: Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org
Cc: seanjc@google.com, michael.roth@amd.com, isaku.yamahata@intel.com,
 thomas.lendacky@amd.com, Binbin Wu <binbin.wu@linux.intel.com>
References: <20240227232100.478238-1-pbonzini@redhat.com>
 <20240227232100.478238-13-pbonzini@redhat.com>
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20240227232100.478238-13-pbonzini@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/28/2024 7:20 AM, Paolo Bonzini wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
> 
> TDP MMU allows tdp_mmu_set_spte_atomic() and tdp_mmu_zap_spte_atomic() to
> return -EBUSY or -EAGAIN error.  The caller must check the return value and
> retry.  Add __must_check to ensure that it does so.
> 
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>
> Message-Id: <8f7d5a1b241bf5351eaab828d1a1efe5c17699ca.1705965635.git.isaku.yamahata@intel.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>

> ---
>   arch/x86/kvm/mmu/tdp_mmu.c | 10 +++++-----
>   1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index 55b5e3857e98..3627744fcab6 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -539,9 +539,9 @@ static void handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
>    *            no side-effects other than setting iter->old_spte to the last
>    *            known value of the spte.
>    */
> -static inline int tdp_mmu_set_spte_atomic(struct kvm *kvm,
> -					  struct tdp_iter *iter,
> -					  u64 new_spte)
> +static inline int __must_check tdp_mmu_set_spte_atomic(struct kvm *kvm,
> +						       struct tdp_iter *iter,
> +						       u64 new_spte)
>   {
>   	u64 *sptep = rcu_dereference(iter->sptep);
>   
> @@ -571,8 +571,8 @@ static inline int tdp_mmu_set_spte_atomic(struct kvm *kvm,
>   	return 0;
>   }
>   
> -static inline int tdp_mmu_zap_spte_atomic(struct kvm *kvm,
> -					  struct tdp_iter *iter)
> +static inline int __must_check tdp_mmu_zap_spte_atomic(struct kvm *kvm,
> +						       struct tdp_iter *iter)
>   {
>   	int ret;
>   


