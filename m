Return-Path: <kvm+bounces-47081-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 551A2ABD00C
	for <lists+kvm@lfdr.de>; Tue, 20 May 2025 09:04:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 774D43A7909
	for <lists+kvm@lfdr.de>; Tue, 20 May 2025 07:04:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C2C7725D1FE;
	Tue, 20 May 2025 07:04:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QNt5u9Pp"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7475A25B1F7;
	Tue, 20 May 2025 07:04:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747724663; cv=none; b=FDJiRiniIRYUJJsPYdjB4YUqXnCBWpdDHlaPGehh4ITSLY1SLAd/VEwxk3Qc1J8iLQwr3NdpadUL4TPXRnTOttD+2TLSgLemJUCN0372q8gON3KabMRaYDzF+w3QynsNNNhGapWeNbHqOF24URsLulRA3B4IWB31OEhGRAfpZyw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747724663; c=relaxed/simple;
	bh=XgeePASKZy5NM3YiantFtATBi40OqDNYHU6kW598rUg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lnp4rrOXhslJLw/ahFgXtNyATb5gwe4/K+OZAAbypAwWP1hcWfmBUMA78lqJZHtKrJocsFZrtTEvJvb232nQlpCG7P+7pH/NRDQIRRQ9RucumKAfYvOwLp+p0eW/HHI0o89AT4h6m99ugeGjCdPfsy4GlWm+mmOMYoZ+cIJ5KL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QNt5u9Pp; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747724661; x=1779260661;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=XgeePASKZy5NM3YiantFtATBi40OqDNYHU6kW598rUg=;
  b=QNt5u9PpJbK/xCU0VP9q8nBZ+px0sAbAC2E+18IR4ZcjBNqPg1A3wVa9
   wxnMWTpLE0kaJZx2l1JgYOpcUzwL3r1hhkKSLv+nYuXS6l6+4K33nhp7+
   y8gi8OICi/EwEe0ZvM8ey2Oqo/LT9HMviaZYOi68SlaNq+jh14JQpn4w5
   y5EFPJrLV4iqfyOMmmHSaEE/IR0qRxXtKX7qh60SNCbFuJo9OFn6KPUmo
   V7bOHFl0x3tYvo+xJzAwgdg7I+1OSQgqgbthF6KfeWZoByG8ykSbUAco/
   guOwuoIRds0BkzDP1baSvGgQWxpuvpH8+t3kW9BSDJtp6e+e6Zg6RfMc1
   A==;
X-CSE-ConnectionGUID: 7cXhX09+TVyIjEah0o5shQ==
X-CSE-MsgGUID: bWGKdl+NTnyGDLz2arPs/A==
X-IronPort-AV: E=McAfee;i="6700,10204,11438"; a="48895126"
X-IronPort-AV: E=Sophos;i="6.15,302,1739865600"; 
   d="scan'208";a="48895126"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2025 00:04:20 -0700
X-CSE-ConnectionGUID: 2PbQKEJbT6ygsXbzf7VF8g==
X-CSE-MsgGUID: WSfGdTslS/2tqgszM99LOQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,302,1739865600"; 
   d="scan'208";a="170620114"
Received: from unknown (HELO [10.238.12.207]) ([10.238.12.207])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2025 00:04:18 -0700
Message-ID: <0edbcc4a-4cf6-4836-a573-dadec93f6f66@linux.intel.com>
Date: Tue, 20 May 2025 15:04:16 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 6/6] KVM: Assert that slots_lock is held when resetting
 per-vCPU dirty rings
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, Peter Xu <peterx@redhat.com>,
 Yan Zhao <yan.y.zhao@intel.com>, Maxim Levitsky <mlevitsk@redhat.com>,
 James Houghton <jthoughton@google.com>, Pankaj Gupta <pankaj.gupta@amd.com>
References: <20250516213540.2546077-1-seanjc@google.com>
 <20250516213540.2546077-7-seanjc@google.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20250516213540.2546077-7-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 5/17/2025 5:35 AM, Sean Christopherson wrote:
> Assert that slots_lock is held in kvm_dirty_ring_reset() and add a comment
> to explain _why_ slots needs to be held for the duration of the reset.
>
> Link: https://lore.kernel.org/all/aCSns6Q5oTkdXUEe@google.com
> Suggested-by: James Houghton <jthoughton@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   virt/kvm/dirty_ring.c | 8 ++++++++
>   1 file changed, 8 insertions(+)
>
> diff --git a/virt/kvm/dirty_ring.c b/virt/kvm/dirty_ring.c
> index 54734025658a..1ba02a06378c 100644
> --- a/virt/kvm/dirty_ring.c
> +++ b/virt/kvm/dirty_ring.c
> @@ -122,6 +122,14 @@ int kvm_dirty_ring_reset(struct kvm *kvm, struct kvm_dirty_ring *ring,
>   	unsigned long mask = 0;
>   	struct kvm_dirty_gfn *entry;
>   
> +	/*
> +	 * Ensure concurrent calls to KVM_RESET_DIRTY_RINGS are serialized,
> +	 * e.g. so that KVM fully resets all entries processed by a given call
It seems that "e.g." is not needed?

> +	 * before returning to userspace.  Holding slots_lock also protects
> +	 * the various memslot accesses.
> +	 */
> +	lockdep_assert_held(&kvm->slots_lock);
> +
>   	while (likely((*nr_entries_reset) < INT_MAX)) {
>   		if (signal_pending(current))
>   			return -EINTR;


