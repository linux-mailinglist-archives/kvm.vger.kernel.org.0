Return-Path: <kvm+bounces-47078-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 53096ABCFEA
	for <lists+kvm@lfdr.de>; Tue, 20 May 2025 08:56:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 792FF3AC8C4
	for <lists+kvm@lfdr.de>; Tue, 20 May 2025 06:56:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE4C925D1FE;
	Tue, 20 May 2025 06:56:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="REPzlcvA"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44A5C25CC69;
	Tue, 20 May 2025 06:56:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747724188; cv=none; b=pTwJf0BKS4fTMtdFCVewqRe+03+qz3EELkTXa8OxvLXm+NeyR1RcthAP1Y6Fi+ObwCYqDq303L4wzFpZ5dG8PFIXvMEfXo487+T50VvHfTsZRBFsFCjmOhhy3vS6IjNMJ8p7iCXqoh05qpcU0nFUxx2WQtWie2bWkkN5AU4bILk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747724188; c=relaxed/simple;
	bh=3aWwOp9UEjmcpihhEo4C2y5qOhYUSXsWAf8r1X/58sY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QXaCgr8YBdhhKAyBfX6WFTDDrbH1xA2UaqL7TlV5yGmDzF9/Jvfen8bYBYVMlCWzSnj31zAq6GAy0z0r9emdsyuf+wGSuFyCTueZ6P+Xy98OinD4IfWXSo++vl0wT0ocQ9eySLuwUObJx72q+ZkS0E1HRK9+pdLb2C9wC+XJwRU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=REPzlcvA; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747724188; x=1779260188;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=3aWwOp9UEjmcpihhEo4C2y5qOhYUSXsWAf8r1X/58sY=;
  b=REPzlcvAYQLe6ZTsfsXTa4ERGvN6Q+CiBR9yKLK8tfNv6T7BWpzo/Nh6
   HzLaoYwH8iKT+ayaXDDxX40ao5BIMNmJtIxVuIdsGpb/IhJNJ2zi9/E6T
   bYEwf5VXXAaQu30o+ktUxyxfhyQns06cQ8aSxmnxs75nrDV4R4TDojnq4
   wfxAX7YV6h3Lq+wWMArrNxgwVi2i0OSSKHJeq7sZrkTNIZhWRrVP7TgaN
   Vk0FR2SJZdsirdUqj7bhGXRsHN7MEHl9N+MpUmmnlKTDdafAGts3Xxrid
   cbkdlgsq7Fiegjkr11KIwob6doSC5fyCkXLIPJU3kzxGQ70RqLTc5vKk+
   g==;
X-CSE-ConnectionGUID: +WHPaln6TTqzdm9ONAcfrg==
X-CSE-MsgGUID: 4noJsVehTPiV5BDSN+orQw==
X-IronPort-AV: E=McAfee;i="6700,10204,11438"; a="49572206"
X-IronPort-AV: E=Sophos;i="6.15,302,1739865600"; 
   d="scan'208";a="49572206"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2025 23:56:27 -0700
X-CSE-ConnectionGUID: L+Zh0fK3TZqXUPHXo+VU/Q==
X-CSE-MsgGUID: 7vvydILUSDq/41RAyXVcdQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,302,1739865600"; 
   d="scan'208";a="144459174"
Received: from unknown (HELO [10.238.12.207]) ([10.238.12.207])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2025 23:56:24 -0700
Message-ID: <62136542-fe81-4f23-89bf-1e08e66c2269@linux.intel.com>
Date: Tue, 20 May 2025 14:56:22 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 4/6] KVM: Check for empty mask of harvested dirty ring
 entries in caller
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, Peter Xu <peterx@redhat.com>,
 Yan Zhao <yan.y.zhao@intel.com>, Maxim Levitsky <mlevitsk@redhat.com>,
 James Houghton <jthoughton@google.com>, Pankaj Gupta <pankaj.gupta@amd.com>
References: <20250516213540.2546077-1-seanjc@google.com>
 <20250516213540.2546077-5-seanjc@google.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20250516213540.2546077-5-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 5/17/2025 5:35 AM, Sean Christopherson wrote:
> When resetting a dirty ring, explicitly check that there is work to be
> done before calling kvm_reset_dirty_gfn(), e.g. if no harvested entries
> are found and/or on the loop's first iteration, and delete the extremely
> misleading comment "This is only needed to make compilers happy".  KVM
> absolutely relies on mask to be zero-initialized, i.e. the comment is an
> outright lie.  Furthermore, the compiler is right to complain that KVM is
> calling a function with uninitialized data, as there are no guarantees
> the implementation details of kvm_reset_dirty_gfn() will be visible to
> kvm_dirty_ring_reset().
>
> While the flaw could be fixed by simply deleting (or rewording) the
> comment, and duplicating the check is unfortunate, checking mask in the
> caller will allow for additional cleanups.
>
> Opportunistically drop the zero-initialization of cur_slot and cur_offset.
> If a bug were introduced where either the slot or offset was consumed
> before mask is set to a non-zero value, then it is highly desirable for
> the compiler (or some other sanitizer) to yell.
>
> Cc: Peter Xu <peterx@redhat.com>
> Cc: Yan Zhao <yan.y.zhao@intel.com>
> Cc: Maxim Levitsky <mlevitsk@redhat.com>
> Cc: Binbin Wu <binbin.wu@linux.intel.com>
> Reviewed-by: Pankaj Gupta <pankaj.gupta@amd.com>
> Reviewed-by: James Houghton <jthoughton@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>

> ---
>   virt/kvm/dirty_ring.c | 44 ++++++++++++++++++++++++++++++++++---------
>   1 file changed, 35 insertions(+), 9 deletions(-)
>
> diff --git a/virt/kvm/dirty_ring.c b/virt/kvm/dirty_ring.c
> index 97cca0c02fd1..84c75483a089 100644
> --- a/virt/kvm/dirty_ring.c
> +++ b/virt/kvm/dirty_ring.c
> @@ -55,9 +55,6 @@ static void kvm_reset_dirty_gfn(struct kvm *kvm, u32 slot, u64 offset, u64 mask)
>   	struct kvm_memory_slot *memslot;
>   	int as_id, id;
>   
> -	if (!mask)
> -		return;
> -
>   	as_id = slot >> 16;
>   	id = (u16)slot;
>   
> @@ -108,15 +105,24 @@ static inline bool kvm_dirty_gfn_harvested(struct kvm_dirty_gfn *gfn)
>   int kvm_dirty_ring_reset(struct kvm *kvm, struct kvm_dirty_ring *ring,
>   			 int *nr_entries_reset)
>   {
> +	/*
> +	 * To minimize mmu_lock contention, batch resets for harvested entries
> +	 * whose gfns are in the same slot, and are within N frame numbers of
> +	 * each other, where N is the number of bits in an unsigned long.  For
> +	 * simplicity, process the current set of entries when the next entry
> +	 * can't be included in the batch.
> +	 *
> +	 * Track the current batch slot, the gfn offset into the slot for the
> +	 * batch, and the bitmask of gfns that need to be reset (relative to
> +	 * offset).  Note, the offset may be adjusted backwards, e.g. so that
> +	 * a sequence of gfns X, X-1, ... X-N can be batched.
> +	 */
>   	u32 cur_slot, next_slot;
>   	u64 cur_offset, next_offset;
> -	unsigned long mask;
> +	unsigned long mask = 0;
>   	struct kvm_dirty_gfn *entry;
>   	bool first_round = true;
>   
> -	/* This is only needed to make compilers happy */
> -	cur_slot = cur_offset = mask = 0;
> -
>   	while (likely((*nr_entries_reset) < INT_MAX)) {
>   		if (signal_pending(current))
>   			return -EINTR;
> @@ -164,14 +170,34 @@ int kvm_dirty_ring_reset(struct kvm *kvm, struct kvm_dirty_ring *ring,
>   				continue;
>   			}
>   		}
> -		kvm_reset_dirty_gfn(kvm, cur_slot, cur_offset, mask);
> +
> +		/*
> +		 * Reset the slot for all the harvested entries that have been
> +		 * gathered, but not yet fully processed.
> +		 */
> +		if (mask)
> +			kvm_reset_dirty_gfn(kvm, cur_slot, cur_offset, mask);
> +
> +		/*
> +		 * The current slot was reset or this is the first harvested
> +		 * entry, (re)initialize the metadata.
> +		 */
>   		cur_slot = next_slot;
>   		cur_offset = next_offset;
>   		mask = 1;
>   		first_round = false;
>   	}
>   
> -	kvm_reset_dirty_gfn(kvm, cur_slot, cur_offset, mask);
> +	/*
> +	 * Perform a final reset if there are harvested entries that haven't
> +	 * been processed, which is guaranteed if at least one harvested was
> +	 * found.  The loop only performs a reset when the "next" entry can't
> +	 * be batched with the "current" entry(s), and that reset processes the
> +	 * _current_ entry(s); i.e. the last harvested entry, a.k.a. next, will
> +	 * always be left pending.
> +	 */
> +	if (mask)
> +		kvm_reset_dirty_gfn(kvm, cur_slot, cur_offset, mask);
>   
>   	/*
>   	 * The request KVM_REQ_DIRTY_RING_SOFT_FULL will be cleared


