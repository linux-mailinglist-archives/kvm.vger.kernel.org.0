Return-Path: <kvm+bounces-7426-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A8539841C74
	for <lists+kvm@lfdr.de>; Tue, 30 Jan 2024 08:19:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 58F871F267D8
	for <lists+kvm@lfdr.de>; Tue, 30 Jan 2024 07:19:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1715251C28;
	Tue, 30 Jan 2024 07:19:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="V+MwBcZg"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.115])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DF123C498;
	Tue, 30 Jan 2024 07:19:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.55.52.115
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706599186; cv=none; b=NWy6I0cboMQlQ3hkac7+GTWF4PYKCXGU39hIv3li+QEwEpRJf4ggYBWuPVbsACLSplI05YIrbSN3Z3zTT8AciPDqVk7cSQOSBOUR/d/kBVX9lzE+2PrS/ygBtVxGCC3hkle11xqpf7B0PfVU5q+wZfe98ronA0/ycyMz0Cmtc3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706599186; c=relaxed/simple;
	bh=JIWHomHQ/bgABZFIZYxMyetlwrTR/dSFit34KIYnSjk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JOQg2pLg1ndC12AV8Ey5FuAJo2NkxLmrKX2Jk3CnVTgKM2nJijFvJ/aUARkByMVxvBDdAHRlzByGw7+oo1+GiB1dgixDRCNW+/mP7bnaGzjuC+idtWj2VTXmt0XoWfTDkR3TAKYb6KfSBvTV7VPpI4JVJQ5f17KMTpPDJQYGq9g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=V+MwBcZg; arc=none smtp.client-ip=192.55.52.115
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706599184; x=1738135184;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=JIWHomHQ/bgABZFIZYxMyetlwrTR/dSFit34KIYnSjk=;
  b=V+MwBcZgyJWO/qgB4AnYbQJKmVk71IHPHUXG8ok9FBhxsg1V1GZ3pXbZ
   5v/vmpRoCrUbe9LLP8sXq7mokyMSJQ6aqp+8NBWHpAw0LhPPChl7db0V6
   hqvGiuLS1+1eKb1zJF0HvMN63zgzV+2FXkEdAfzvyt2UC8eK8I2M6UpaR
   u5Ket2z/svXFFcIiFjkvKLV3um7cWWbEjEeURg8GyI1GlIUSOLX5iHV89
   ggWLnGmV1IPzhR9VBT5lwUupcFlNgjEBOaY6YQdRZklOyU0nzpFUiWPvq
   ZNEIrNPyyVaNDCxilJFZfFhNIsagP0o6UfXs/DRVRhpvno+KGi9xB87GH
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10968"; a="402824433"
X-IronPort-AV: E=Sophos;i="6.05,707,1701158400"; 
   d="scan'208";a="402824433"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jan 2024 23:19:42 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,707,1701158400"; 
   d="scan'208";a="3652047"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.238.10.49]) ([10.238.10.49])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jan 2024 23:19:41 -0800
Message-ID: <d9cfb88b-ec87-4ddd-9770-da1f8742f5a2@linux.intel.com>
Date: Tue, 30 Jan 2024 15:19:37 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v18 049/121] KVM: x86/tdp_mmu: Apply mmu notifier callback
 to only shared GPA
To: isaku.yamahata@intel.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
 erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
 Sagi Shahar <sagis@google.com>, Kai Huang <kai.huang@intel.com>,
 chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com
References: <cover.1705965634.git.isaku.yamahata@intel.com>
 <9f64fe39a205b769bf08f2996efb0b5afc6c1900.1705965635.git.isaku.yamahata@intel.com>
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <9f64fe39a205b769bf08f2996efb0b5afc6c1900.1705965635.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 1/23/2024 7:53 AM, isaku.yamahata@intel.com wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
>
> The private GPAs that typically guest memfd backs aren't subject to MMU
> notifier because it isn't mapped into virtual address of user process.
> kvm_tdp_mmu_handle_gfn() handles the callback of the MMU notifier,
> clear_flush_young(), clear_young(), test_gfn() and change_pte().  Make

Nit: test_gfn() -> test_young(), and a same typo in the comment below.

Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>

> kvm_tdp_mmu_handle_gfn() aware of private mapping and skip private mapping.
>
> Even with AS_UNMOVABLE set, those mmu notifier are called.  For example,
> ksmd triggers change_pte().
>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
> v18:
> - newly added
> ---
>   arch/x86/kvm/mmu/tdp_mmu.c | 22 +++++++++++++++++++++-
>   1 file changed, 21 insertions(+), 1 deletion(-)
>
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index e7514a807134..fdc6e2221c33 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -1157,9 +1157,29 @@ static __always_inline bool kvm_tdp_mmu_handle_gfn(struct kvm *kvm,
>   	 * into this helper allow blocking; it'd be dead, wasteful code.
>   	 */
>   	for_each_tdp_mmu_root(kvm, root, range->slot->as_id) {
> +		gfn_t start, end;
> +
> +		/*
> +		 * This function is called on behalf of mmu_notifier of
> +		 * clear_flush_young(), clear_young(), test_gfn(), and
test_gfn() should be test_young()

> +		 * change_pte().  They apply to only shared GPAs.
> +		 */
> +		WARN_ON_ONCE(range->only_private);
> +		WARN_ON_ONCE(!range->only_shared);
> +		if (is_private_sp(root))
> +			continue;
> +
> +		/*
> +		 * For TDX shared mapping, set GFN shared bit to the range,
> +		 * so the handler() doesn't need to set it, to avoid duplicated
> +		 * code in multiple handler()s.
> +		 */
> +		start = kvm_gfn_to_shared(kvm, range->start);
> +		end = kvm_gfn_to_shared(kvm, range->end);
> +
>   		rcu_read_lock();
>   
> -		tdp_root_for_each_leaf_pte(iter, root, range->start, range->end)
> +		tdp_root_for_each_leaf_pte(iter, root, start, end)
>   			ret |= handler(kvm, &iter, range);
>   
>   		rcu_read_unlock();


