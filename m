Return-Path: <kvm+bounces-57034-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6EC1BB49F5A
	for <lists+kvm@lfdr.de>; Tue,  9 Sep 2025 04:46:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 290A24433EB
	for <lists+kvm@lfdr.de>; Tue,  9 Sep 2025 02:46:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 24B702561AA;
	Tue,  9 Sep 2025 02:46:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="d92lNrJc"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F70C2AE99;
	Tue,  9 Sep 2025 02:46:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757385998; cv=none; b=sjsh5nsodtx05SfJETaBShpysf2n+6J/nofy6Am/MEAuxmgZCbKhqzXMkW20xYqwJDKnvFNkEk7ViMdOIIWNzC4cZiKGf8IB3S5RSoZPdnUekQL1D8HcT7MqJnPSlnSkO1kRUtZtctnEbeN3zGjFB9q7hbNDsrBB9m4qwsDK7CM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757385998; c=relaxed/simple;
	bh=VxqzwwDMmggUPxDs4iUk/QJ7RrWb0r/ma1DnZipoOL8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sN22RICgw9u6lfr7TlZfAi0X0+hBXg5Zkuf4LPaUBxABWBGFPC7UnCaNMpxQMJpxAhbErswfzg6s7MKtA8e2EoJtHzTJ7P2Cl6aQqlY9N1nCnxw2FFUivwi/VmwbRj9qae5Yxyh5JCY8V2ZuGi600/zJD4NpZq5kKTcK7+f36xc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=d92lNrJc; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1757385997; x=1788921997;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=VxqzwwDMmggUPxDs4iUk/QJ7RrWb0r/ma1DnZipoOL8=;
  b=d92lNrJciUakkSHAoPdFZdLI9zGnxHdyTW8HEe3HIJYUFPYQF4Y4jQEC
   GzY/lvIXYIuPlARkj4TotwmnnoN3j3QCfzjrr9wdxOkayH02DwlInxlj0
   Mu3VtMI0MKHTegdsDW2z0h6fxXaU1rcGo2ofjNZrRFEEFlPG9hOcPCSqW
   Tl5I6j5XQnK6qu1iDa7a+vsLEvv5pZRHVTSqIv1UlrrmN6SSgEQMWQ9iO
   3Cx+mt5ezEPxAe3g+3lXkJ43cw9oFmXPBNlANSO6iK/SwysyUdlUYUmvV
   uajs18Vo5KtjFjj77Jzuf0FPU4dQsYzVYsrBN2mn546t4IiagnWGhtzQF
   Q==;
X-CSE-ConnectionGUID: 7uHtTdNrS9KJRqB3F1xf5Q==
X-CSE-MsgGUID: yYMRfgFqSs6CnW8yAGai9Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11547"; a="77116180"
X-IronPort-AV: E=Sophos;i="6.18,250,1751266800"; 
   d="scan'208";a="77116180"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Sep 2025 19:46:36 -0700
X-CSE-ConnectionGUID: AYacolEkQjSGPIlZWaLtBg==
X-CSE-MsgGUID: NofuoqEfRvKhagpN/BQnXQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,250,1751266800"; 
   d="scan'208";a="172221910"
Received: from unknown (HELO [10.238.0.107]) ([10.238.0.107])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Sep 2025 19:46:34 -0700
Message-ID: <ea1603bc-68f2-44cd-8cdf-ec5969486dea@linux.intel.com>
Date: Tue, 9 Sep 2025 10:46:31 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/3] KVM: x86/mmu: Return -EAGAIN if userspace
 deletes/moves memslot during prefault
To: Yan Zhao <yan.y.zhao@intel.com>, seanjc@google.com
Cc: pbonzini@redhat.com, reinette.chatre@intel.com,
 rick.p.edgecombe@intel.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <20250822070305.26427-1-yan.y.zhao@intel.com>
 <20250822070347.26451-1-yan.y.zhao@intel.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20250822070347.26451-1-yan.y.zhao@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 8/22/2025 3:03 PM, Yan Zhao wrote:
> From: Sean Christopherson <seanjc@google.com>
>
> Return -EAGAIN if userspace attempts to delete or move a memslot while also
> prefaulting memory for that same memslot, i.e. force userspace to retry
> instead of trying to handle the scenario entirely within KVM.  Unlike
> KVM_RUN, which needs to handle the scenario entirely within KVM because
> userspace has come to depend on such behavior, KVM_PRE_FAULT_MEMORY can
> return -EAGAIN without breaking userspace as this scenario can't have ever
> worked (and there's no sane use case for prefaulting to a memslot that's
> being deleted/moved).
>
> And also unlike KVM_RUN, the prefault path doesn't naturally gaurantee

gaurantee -> guarantee

> forward progress.  E.g. to handle such a scenario, KVM would need to drop
> and reacquire SRCU to break the deadlock between the memslot update
> (synchronizes SRCU) and the prefault (waits for the memslot update to
> complete).
>
> However, dropping SRCU creates more problems, as completing the memslot
> update will bump the memslot generation, which in turn will invalidate the
> MMU root.  To handle that, prefaulting would need to handle pending
> KVM_REQ_MMU_FREE_OBSOLETE_ROOTS requests and do kvm_mmu_reload() prior to
> mapping each individual.
>
> I.e. to fully handle this scenario, prefaulting would eventually need to
> look a lot like vcpu_enter_guest().  Given that there's no reasonable use
> case and practically zero risk of breaking userspace, punt the problem to
> userspace and avoid adding unnecessary complexity to the prefualt path.

prefualt -> prefault

>
> Note, TDX's guest_memfd post-populate path is unaffected as slots_lock is
> held for the entire duration of populate(), i.e. any memslot modifications
> will be fully serialized against TDX's flavor of prefaulting.
>
> Reported-by: Reinette Chatre <reinette.chatre@intel.com>
> Closes: https://lore.kernel.org/all/20250519023737.30360-1-yan.y.zhao@intel.com
> Debugged-by: Yan Zhao <yan.y.zhao@intel.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Two typos above.

Otherwise,
Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>

> ---
>   arch/x86/kvm/mmu/mmu.c | 10 ++++++++--
>   1 file changed, 8 insertions(+), 2 deletions(-)
>
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 92ff15969a36..f31fad33c423 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -4653,10 +4653,16 @@ static int kvm_mmu_faultin_pfn(struct kvm_vcpu *vcpu,
>   	/*
>   	 * Retry the page fault if the gfn hit a memslot that is being deleted
>   	 * or moved.  This ensures any existing SPTEs for the old memslot will
> -	 * be zapped before KVM inserts a new MMIO SPTE for the gfn.
> +	 * be zapped before KVM inserts a new MMIO SPTE for the gfn.  Punt the
> +	 * error to userspace if this is a prefault, as KVM's prefaulting ABI
> +	 * doesn't need provide the same forward progress guarantees as KVM_RUN.
>   	 */
> -	if (slot->flags & KVM_MEMSLOT_INVALID)
> +	if (slot->flags & KVM_MEMSLOT_INVALID) {
> +		if (fault->prefetch)
> +			return -EAGAIN;
> +
>   		return RET_PF_RETRY;
> +	}
>   
>   	if (slot->id == APIC_ACCESS_PAGE_PRIVATE_MEMSLOT) {
>   		/*


