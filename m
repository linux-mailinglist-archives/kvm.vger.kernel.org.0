Return-Path: <kvm+bounces-47076-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 63113ABCFDC
	for <lists+kvm@lfdr.de>; Tue, 20 May 2025 08:51:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2EBAB3AE8EB
	for <lists+kvm@lfdr.de>; Tue, 20 May 2025 06:51:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4955025D1E6;
	Tue, 20 May 2025 06:51:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FX56neqn"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C4FB1D5CEA;
	Tue, 20 May 2025 06:51:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747723905; cv=none; b=EzKwL7x6RARTm6yDDW9M30Q9BtxsdoYfvEbk29a6LdsZdkP9MfYu0KnOcmf01gFJFFGWK5EFoRMn88EwHo4MBUP6ry4xzWiow/2owlKzBc3ium7cIgF8SGi4p0wtOUmFBaFZqKtyDNuAAiQC2e+oONE7HwEEItsUVNqv/q7GFSI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747723905; c=relaxed/simple;
	bh=lrahYfVNEp1NImx1ihzeATT4d2KtwWOZnfKtjTvmf6w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CN88+12b0m8GfIDFOsxP2KGzJG1BeOboCWXtnEKzMIwCqjFx80yoql/XHkrfcTkhj0QhiO3WutZXcc86noQyr6uJGW5hvC/SP4B05+LYogjEvFSHYgKKpM4qcShz3oqYb/BtTyQdRqrukiwFC6sG5re4RQNHTegD6IsicDxWH5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FX56neqn; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747723904; x=1779259904;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=lrahYfVNEp1NImx1ihzeATT4d2KtwWOZnfKtjTvmf6w=;
  b=FX56neqnMky3q4xyJxy/3h/4FAuIHbPp+lAydI9jySXvpnmZuuFb1RZl
   Busr3yeo98xcLs/6g3uVvqZbjCXVthfeQJX+iAmcGvWm3yh30YMZ0o0of
   HBwwUEwdJsVDv7yadjwDx6BA8KKjxtZawzd9v+SllHNsQ+MMuu38L4ZN6
   Q40Ktckmj8PGAPLapZrTOOaoL1xJs7k4Npk1o/Z72xQoZRoSnwjOqrdJ2
   ehPV1gssWgAB0dsQSZkt6g+vdEDeQw4H2kXkPXofNGSEbsTH471v1VKrS
   xx5YP2iAI8ncqDqQfcTgLQl6ssLYf7hsQLWi20WMAVm3B5O14ZgazLabw
   A==;
X-CSE-ConnectionGUID: vikYx9GCRLalmTuYXTdJdg==
X-CSE-MsgGUID: zmbjrS7dSlyFq4nVHVgeMQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11438"; a="49625104"
X-IronPort-AV: E=Sophos;i="6.15,302,1739865600"; 
   d="scan'208";a="49625104"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2025 23:51:43 -0700
X-CSE-ConnectionGUID: dDvxapy/RbuiKHRZgnOfrQ==
X-CSE-MsgGUID: vpD4U9gXSfmb2CXjIDzEwQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,302,1739865600"; 
   d="scan'208";a="139503204"
Received: from unknown (HELO [10.238.12.207]) ([10.238.12.207])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2025 23:51:40 -0700
Message-ID: <afd1dbe1-3055-45f4-9db1-a31e4b9a6722@linux.intel.com>
Date: Tue, 20 May 2025 14:51:37 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/6] KVM: Bound the number of dirty ring entries in a
 single reset at INT_MAX
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, Peter Xu <peterx@redhat.com>,
 Yan Zhao <yan.y.zhao@intel.com>, Maxim Levitsky <mlevitsk@redhat.com>,
 James Houghton <jthoughton@google.com>, Pankaj Gupta <pankaj.gupta@amd.com>
References: <20250516213540.2546077-1-seanjc@google.com>
 <20250516213540.2546077-2-seanjc@google.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20250516213540.2546077-2-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 5/17/2025 5:35 AM, Sean Christopherson wrote:
> Cap the number of ring entries that are reset in a single ioctl to INT_MAX
> to ensure userspace isn't confused by a wrap into negative space, and so
> that, in a truly pathological scenario, KVM doesn't miss a TLB flush due
> to the count wrapping to zero.  While the size of the ring is fixed at
> 0x10000 entries and KVM (currently) supports at most 4096, userspace is
> allowed to harvest entries from the ring while the reset is in-progress,
> i.e. it's possible for the ring to always have harvested entries.
>
> Opportunistically return an actual error code from the helper so that a
> future fix to handle pending signals can gracefully return -EINTR.  Drop
> the function comment now that the return code is a stanard 0/-errno (and

stanard -> standard

The rest looks good to me.
Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>


> because a future commit will add a proper lockdep assertion).
>
> Opportunistically drop a similarly stale comment for kvm_dirty_ring_push().
>
> Cc: Peter Xu <peterx@redhat.com>
> Cc: Yan Zhao <yan.y.zhao@intel.com>
> Cc: Maxim Levitsky <mlevitsk@redhat.com>
> Cc: Binbin Wu <binbin.wu@linux.intel.com>
> Fixes: fb04a1eddb1a ("KVM: X86: Implement ring-based dirty memory tracking")
> Reviewed-by: James Houghton <jthoughton@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   include/linux/kvm_dirty_ring.h | 18 +++++-------------
>   virt/kvm/dirty_ring.c          | 10 +++++-----
>   virt/kvm/kvm_main.c            |  9 ++++++---
>   3 files changed, 16 insertions(+), 21 deletions(-)
>
> diff --git a/include/linux/kvm_dirty_ring.h b/include/linux/kvm_dirty_ring.h
> index da4d9b5f58f1..eb10d87adf7d 100644
> --- a/include/linux/kvm_dirty_ring.h
> +++ b/include/linux/kvm_dirty_ring.h
> @@ -49,9 +49,10 @@ static inline int kvm_dirty_ring_alloc(struct kvm *kvm, struct kvm_dirty_ring *r
>   }
>   
>   static inline int kvm_dirty_ring_reset(struct kvm *kvm,
> -				       struct kvm_dirty_ring *ring)
> +				       struct kvm_dirty_ring *ring,
> +				       int *nr_entries_reset)
>   {
> -	return 0;
> +	return -ENOENT;
>   }
>   
>   static inline void kvm_dirty_ring_push(struct kvm_vcpu *vcpu,
> @@ -77,17 +78,8 @@ bool kvm_arch_allow_write_without_running_vcpu(struct kvm *kvm);
>   u32 kvm_dirty_ring_get_rsvd_entries(struct kvm *kvm);
>   int kvm_dirty_ring_alloc(struct kvm *kvm, struct kvm_dirty_ring *ring,
>   			 int index, u32 size);
> -
> -/*
> - * called with kvm->slots_lock held, returns the number of
> - * processed pages.
> - */
> -int kvm_dirty_ring_reset(struct kvm *kvm, struct kvm_dirty_ring *ring);
> -
> -/*
> - * returns =0: successfully pushed
> - *         <0: unable to push, need to wait
> - */
> +int kvm_dirty_ring_reset(struct kvm *kvm, struct kvm_dirty_ring *ring,
> +			 int *nr_entries_reset);
>   void kvm_dirty_ring_push(struct kvm_vcpu *vcpu, u32 slot, u64 offset);
>   
>   bool kvm_dirty_ring_check_request(struct kvm_vcpu *vcpu);
> diff --git a/virt/kvm/dirty_ring.c b/virt/kvm/dirty_ring.c
> index d14ffc7513ee..77986f34eff8 100644
> --- a/virt/kvm/dirty_ring.c
> +++ b/virt/kvm/dirty_ring.c
> @@ -105,19 +105,19 @@ static inline bool kvm_dirty_gfn_harvested(struct kvm_dirty_gfn *gfn)
>   	return smp_load_acquire(&gfn->flags) & KVM_DIRTY_GFN_F_RESET;
>   }
>   
> -int kvm_dirty_ring_reset(struct kvm *kvm, struct kvm_dirty_ring *ring)
> +int kvm_dirty_ring_reset(struct kvm *kvm, struct kvm_dirty_ring *ring,
> +			 int *nr_entries_reset)
>   {
>   	u32 cur_slot, next_slot;
>   	u64 cur_offset, next_offset;
>   	unsigned long mask;
> -	int count = 0;
>   	struct kvm_dirty_gfn *entry;
>   	bool first_round = true;
>   
>   	/* This is only needed to make compilers happy */
>   	cur_slot = cur_offset = mask = 0;
>   
> -	while (true) {
> +	while (likely((*nr_entries_reset) < INT_MAX)) {
>   		entry = &ring->dirty_gfns[ring->reset_index & (ring->size - 1)];
>   
>   		if (!kvm_dirty_gfn_harvested(entry))
> @@ -130,7 +130,7 @@ int kvm_dirty_ring_reset(struct kvm *kvm, struct kvm_dirty_ring *ring)
>   		kvm_dirty_gfn_set_invalid(entry);
>   
>   		ring->reset_index++;
> -		count++;
> +		(*nr_entries_reset)++;
>   		/*
>   		 * Try to coalesce the reset operations when the guest is
>   		 * scanning pages in the same slot.
> @@ -167,7 +167,7 @@ int kvm_dirty_ring_reset(struct kvm *kvm, struct kvm_dirty_ring *ring)
>   
>   	trace_kvm_dirty_ring_reset(ring);
>   
> -	return count;
> +	return 0;
>   }
>   
>   void kvm_dirty_ring_push(struct kvm_vcpu *vcpu, u32 slot, u64 offset)
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index b24db92e98f3..571688507204 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -4903,15 +4903,18 @@ static int kvm_vm_ioctl_reset_dirty_pages(struct kvm *kvm)
>   {
>   	unsigned long i;
>   	struct kvm_vcpu *vcpu;
> -	int cleared = 0;
> +	int cleared = 0, r;
>   
>   	if (!kvm->dirty_ring_size)
>   		return -EINVAL;
>   
>   	mutex_lock(&kvm->slots_lock);
>   
> -	kvm_for_each_vcpu(i, vcpu, kvm)
> -		cleared += kvm_dirty_ring_reset(vcpu->kvm, &vcpu->dirty_ring);
> +	kvm_for_each_vcpu(i, vcpu, kvm) {
> +		r = kvm_dirty_ring_reset(vcpu->kvm, &vcpu->dirty_ring, &cleared);
> +		if (r)
> +			break;
> +	}
>   
>   	mutex_unlock(&kvm->slots_lock);
>   


