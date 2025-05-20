Return-Path: <kvm+bounces-47079-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5A94CABCFF7
	for <lists+kvm@lfdr.de>; Tue, 20 May 2025 08:58:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EBBFE4A1C8C
	for <lists+kvm@lfdr.de>; Tue, 20 May 2025 06:58:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1D00825CC67;
	Tue, 20 May 2025 06:58:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HrwgkV6q"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B32625B66D;
	Tue, 20 May 2025 06:58:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747724306; cv=none; b=gSgMzZUpHh3t7blGm+IXyBptkHBteNKAV5zynosTsUhlJHjSjt7QgTT1SLl2YockoDEmYpMgX9zdVXTgYOt2kJ65rHF/qua6jbpoXfjuQ4RaWTYT/Tmleo5u/blqMitCuW/4G2/qbBe43pDl19S0ep8mGBeZpiA8UAMM3EN5oes=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747724306; c=relaxed/simple;
	bh=+vubKsK5fmHWvfumZJYG6jLuWYHad54TMxsihaAmT/o=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=j5FH0+/ARAfLqKMdSKQysVaiidxYwh0SsavOeLtxGLxLxA2L8M+UUJ9dJ899VMFj0nH01KiXZy2y3W0RuZO2YkvJdirFZsLKtvIMoZI9hJ3ddOh1KdJ4QTArCR9m6H74/3QLH4aNID/90F6zcNqvgtDMpx/myMCy0dg0e4L6zgk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HrwgkV6q; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747724305; x=1779260305;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=+vubKsK5fmHWvfumZJYG6jLuWYHad54TMxsihaAmT/o=;
  b=HrwgkV6qqDVoEks2Y6B8SuwQe32gC3fo1pVDjyVMxpUfeCulH4E+p4Xt
   T0iyoBNyACK9cpFywy3KZfJEF5CpDKEPiYafzCjf+nVmaG6wHgdp5IRNt
   MvF+kNWE+l1CHH3Bvf1Yi5dD2hORvXUWtro8sAD5OmWVOGU8J/qCPV71G
   7bQazFG3f6Ae/eybZc7J6rb11FzGr48FZH/E0vvn4mAC8xFtE++HH2RGJ
   unWnX3t6Nt2EAqWk7+AIIS7387CijjcvUZKQGHGFKz9sTyh6trL/u932X
   Ed4KARIhyK19zZPSIuJw/3YW66gOQxCe0rAWlST0Jfd/JURFCE/XO6E7W
   A==;
X-CSE-ConnectionGUID: DSvLeXbFRUOddPMR/2Hrzw==
X-CSE-MsgGUID: Qeymneb+Sy+HP1TiGdcU0w==
X-IronPort-AV: E=McAfee;i="6700,10204,11438"; a="49707987"
X-IronPort-AV: E=Sophos;i="6.15,302,1739865600"; 
   d="scan'208";a="49707987"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2025 23:58:24 -0700
X-CSE-ConnectionGUID: VpnDFTqQTBqFfcLhhdztFQ==
X-CSE-MsgGUID: EBEzK/iLQACTvlR0MxWoyA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,302,1739865600"; 
   d="scan'208";a="144349981"
Received: from unknown (HELO [10.238.12.207]) ([10.238.12.207])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2025 23:58:21 -0700
Message-ID: <68077bb9-834b-455a-9b95-6a2c29e418b0@linux.intel.com>
Date: Tue, 20 May 2025 14:58:19 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 5/6] KVM: Use mask of harvested dirty ring entries to
 coalesce dirty ring resets
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, Peter Xu <peterx@redhat.com>,
 Yan Zhao <yan.y.zhao@intel.com>, Maxim Levitsky <mlevitsk@redhat.com>,
 James Houghton <jthoughton@google.com>, Pankaj Gupta <pankaj.gupta@amd.com>
References: <20250516213540.2546077-1-seanjc@google.com>
 <20250516213540.2546077-6-seanjc@google.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20250516213540.2546077-6-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 5/17/2025 5:35 AM, Sean Christopherson wrote:
> Use "mask" instead of a dedicated boolean to track whether or not there
> is at least one to-be-reset entry for the current slot+offset.  In the
> body of the loop, mask is zero only on the first iteration, i.e. !mask is
> equivalent to first_round.
>
> Opportunistically combine the adjacent "if (mask)" statements into a single
> if-statement.
>
> No functional change intended.
>
> Cc: Peter Xu <peterx@redhat.com>
> Cc: Yan Zhao <yan.y.zhao@intel.com>
> Cc: Maxim Levitsky <mlevitsk@redhat.com>
> Reviewed-by: Pankaj Gupta <pankaj.gupta@amd.com>
> Reviewed-by: James Houghton <jthoughton@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>

> ---
>   virt/kvm/dirty_ring.c | 60 +++++++++++++++++++++----------------------
>   1 file changed, 29 insertions(+), 31 deletions(-)
>
> diff --git a/virt/kvm/dirty_ring.c b/virt/kvm/dirty_ring.c
> index 84c75483a089..54734025658a 100644
> --- a/virt/kvm/dirty_ring.c
> +++ b/virt/kvm/dirty_ring.c
> @@ -121,7 +121,6 @@ int kvm_dirty_ring_reset(struct kvm *kvm, struct kvm_dirty_ring *ring,
>   	u64 cur_offset, next_offset;
>   	unsigned long mask = 0;
>   	struct kvm_dirty_gfn *entry;
> -	bool first_round = true;
>   
>   	while (likely((*nr_entries_reset) < INT_MAX)) {
>   		if (signal_pending(current))
> @@ -141,42 +140,42 @@ int kvm_dirty_ring_reset(struct kvm *kvm, struct kvm_dirty_ring *ring,
>   		ring->reset_index++;
>   		(*nr_entries_reset)++;
>   
> -		/*
> -		 * While the size of each ring is fixed, it's possible for the
> -		 * ring to be constantly re-dirtied/harvested while the reset
> -		 * is in-progress (the hard limit exists only to guard against
> -		 * wrapping the count into negative space).
> -		 */
> -		if (!first_round)
> +		if (mask) {
> +			/*
> +			 * While the size of each ring is fixed, it's possible
> +			 * for the ring to be constantly re-dirtied/harvested
> +			 * while the reset is in-progress (the hard limit exists
> +			 * only to guard against the count becoming negative).
> +			 */
>   			cond_resched();
>   
> -		/*
> -		 * Try to coalesce the reset operations when the guest is
> -		 * scanning pages in the same slot.
> -		 */
> -		if (!first_round && next_slot == cur_slot) {
> -			s64 delta = next_offset - cur_offset;
> +			/*
> +			 * Try to coalesce the reset operations when the guest
> +			 * is scanning pages in the same slot.
> +			 */
> +			if (next_slot == cur_slot) {
> +				s64 delta = next_offset - cur_offset;
>   
> -			if (delta >= 0 && delta < BITS_PER_LONG) {
> -				mask |= 1ull << delta;
> -				continue;
> -			}
> +				if (delta >= 0 && delta < BITS_PER_LONG) {
> +					mask |= 1ull << delta;
> +					continue;
> +				}
>   
> -			/* Backwards visit, careful about overflows!  */
> -			if (delta > -BITS_PER_LONG && delta < 0 &&
> -			    (mask << -delta >> -delta) == mask) {
> -				cur_offset = next_offset;
> -				mask = (mask << -delta) | 1;
> -				continue;
> +				/* Backwards visit, careful about overflows! */
> +				if (delta > -BITS_PER_LONG && delta < 0 &&
> +				(mask << -delta >> -delta) == mask) {
> +					cur_offset = next_offset;
> +					mask = (mask << -delta) | 1;
> +					continue;
> +				}
>   			}
> -		}
>   
> -		/*
> -		 * Reset the slot for all the harvested entries that have been
> -		 * gathered, but not yet fully processed.
> -		 */
> -		if (mask)
> +			/*
> +			 * Reset the slot for all the harvested entries that
> +			 * have been gathered, but not yet fully processed.
> +			 */
>   			kvm_reset_dirty_gfn(kvm, cur_slot, cur_offset, mask);
> +		}
>   
>   		/*
>   		 * The current slot was reset or this is the first harvested
> @@ -185,7 +184,6 @@ int kvm_dirty_ring_reset(struct kvm *kvm, struct kvm_dirty_ring *ring,
>   		cur_slot = next_slot;
>   		cur_offset = next_offset;
>   		mask = 1;
> -		first_round = false;
>   	}
>   
>   	/*


