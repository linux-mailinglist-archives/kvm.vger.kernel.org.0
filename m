Return-Path: <kvm+bounces-47077-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 57A59ABCFE0
	for <lists+kvm@lfdr.de>; Tue, 20 May 2025 08:53:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F317617D652
	for <lists+kvm@lfdr.de>; Tue, 20 May 2025 06:53:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CBDE325D1E9;
	Tue, 20 May 2025 06:53:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jM9WtWTH"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CEF0255250;
	Tue, 20 May 2025 06:53:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747724003; cv=none; b=J9j/RNSqbCVRR/fY06D14GohJ0LazT5j5HfVpBxCZXLUE8gHJpCWrHSe6qiQXCOrzNdfuArtN+z6MwRelo8BjZf24jgs/b3apK4HgmC+s8f++643HBIJ7G5Deg/r00OpgR8L/cqCyMW9COIkiCX4ljAJiWrHuGWFBSpxdFoN2ak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747724003; c=relaxed/simple;
	bh=m9NVgEbRc/3y9uOeQ797i1MBAfD/B/9qS2qNLXZnWZg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pQlQqMmek8ot4UGxeObB+x+su8eHCJ0vy19dhbu4po9si4ep5RZ1NOk5zopEOp0DQUl1XfMuOpFsvZJl11rnGj1BW9GFoowaWNcUhEl1pQae8hR465ExdsfP8CE4xiuhGp7ho2pxR/hEMKmQLflV73UV4zqNRn7TXetpkCNnzgY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jM9WtWTH; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747724002; x=1779260002;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=m9NVgEbRc/3y9uOeQ797i1MBAfD/B/9qS2qNLXZnWZg=;
  b=jM9WtWTHYuT8HUrW+YJU/1vYMGxWvWuez9LtkSDRN9b5mNINMO/CU0a9
   ad2EILmx+u2OhiXb3A1vC/IcrzSixa312kSzOggf58kcursHzXHdEwxIB
   Y+BKPBxY26Th5Fw6AU3S7YcGtIxFyyFFNpnnuuYalVaQaUJq+tfT7k3ZA
   CJWliEkJUa44WCbvgmEqDahlR+GISpYYuL916FrSSJRIkUaiz+fbf8Njx
   ZNFr3cTFzlZ4KOniai0tLKlfUr+5VFZu7Gk6wX9NEJiOTMofkHmrDH0fN
   HsubEZqJSaLCV+QFREiiOUhPsxg54JUJ85hieWm8SP2TNQY6cIyXP2k6O
   Q==;
X-CSE-ConnectionGUID: opoda9JuTvWmizx3CEeKMw==
X-CSE-MsgGUID: fkfCArhqSqimkKjXis27Fg==
X-IronPort-AV: E=McAfee;i="6700,10204,11438"; a="49625337"
X-IronPort-AV: E=Sophos;i="6.15,302,1739865600"; 
   d="scan'208";a="49625337"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2025 23:53:22 -0700
X-CSE-ConnectionGUID: uKw3dgC3ThipVPcHE3mgXQ==
X-CSE-MsgGUID: uyjdhHjtRZaLloDbkoVw+g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,302,1739865600"; 
   d="scan'208";a="139503839"
Received: from unknown (HELO [10.238.12.207]) ([10.238.12.207])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2025 23:53:06 -0700
Message-ID: <ddcfa7f2-c330-4482-98bf-98bbbc68e954@linux.intel.com>
Date: Tue, 20 May 2025 14:53:04 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/6] KVM: Bail from the dirty ring reset flow if a
 signal is pending
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, Peter Xu <peterx@redhat.com>,
 Yan Zhao <yan.y.zhao@intel.com>, Maxim Levitsky <mlevitsk@redhat.com>,
 James Houghton <jthoughton@google.com>, Pankaj Gupta <pankaj.gupta@amd.com>
References: <20250516213540.2546077-1-seanjc@google.com>
 <20250516213540.2546077-3-seanjc@google.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20250516213540.2546077-3-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 5/17/2025 5:35 AM, Sean Christopherson wrote:
> Abort a dirty ring reset if the current task has a pending signal, as the
> hard limit of INT_MAX entries doesn't ensure KVM will respond to a signal
> in a timely fashion.
>
> Fixes: fb04a1eddb1a ("KVM: X86: Implement ring-based dirty memory tracking")
> Reviewed-by: James Houghton <jthoughton@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>

> ---
>   virt/kvm/dirty_ring.c | 3 +++
>   1 file changed, 3 insertions(+)
>
> diff --git a/virt/kvm/dirty_ring.c b/virt/kvm/dirty_ring.c
> index 77986f34eff8..e844e869e8c7 100644
> --- a/virt/kvm/dirty_ring.c
> +++ b/virt/kvm/dirty_ring.c
> @@ -118,6 +118,9 @@ int kvm_dirty_ring_reset(struct kvm *kvm, struct kvm_dirty_ring *ring,
>   	cur_slot = cur_offset = mask = 0;
>   
>   	while (likely((*nr_entries_reset) < INT_MAX)) {
> +		if (signal_pending(current))
> +			return -EINTR;
> +
>   		entry = &ring->dirty_gfns[ring->reset_index & (ring->size - 1)];
>   
>   		if (!kvm_dirty_gfn_harvested(entry))


