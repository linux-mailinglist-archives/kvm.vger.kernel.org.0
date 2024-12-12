Return-Path: <kvm+bounces-33562-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 31FD19EE093
	for <lists+kvm@lfdr.de>; Thu, 12 Dec 2024 08:49:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CEF90280D5E
	for <lists+kvm@lfdr.de>; Thu, 12 Dec 2024 07:49:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF0CD20B21F;
	Thu, 12 Dec 2024 07:49:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LpIHTh2k"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C131259483
	for <kvm@vger.kernel.org>; Thu, 12 Dec 2024 07:49:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733989768; cv=none; b=ObNgRCTEJG6AOyvMoFKU9Y89c5MeeYV/hCSCQY4RrU+3VzNloQz5jwWTSjHa101eUUjtMj1/gxpTBeaoamjBHI5ph7jyhlHbzvd/IASiSEyiz1JYaarw5OObI9quwaAz63HQ7HiwAVoS19jSypxp9jGoJPGSWkFEfRI1PLuZLpM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733989768; c=relaxed/simple;
	bh=mHjSpBL3vmykAIaKbW2WYbZBw4kigGEu4qrdClZvK5U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MQ5/4Ox0vrkG74kj6joWVg6A9YCwIRv+7gfXjxwKt8lYTDIoLR4HfgZqBgxhklo/2A9xKiD3yQprlmwOTyZDifb/whXhI+BL7vIIcwBS+DpKdSIebkfHzw18sjDd4rX1WjydP0WIhyuI5P4pQprSvNzQe565EnzjMtsiAYeA+6A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LpIHTh2k; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1733989766; x=1765525766;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=mHjSpBL3vmykAIaKbW2WYbZBw4kigGEu4qrdClZvK5U=;
  b=LpIHTh2k3c25BR21Fjj/MD2WEMkVHpurm9ulpbdLzxB2n0dLEwkn+PZr
   d6ZytAlL+2e9PTfAH/VCnX2wVwTaHr3fjaWVhj+gtgVB2PjgMGFh9yPgj
   G4NBHssV73RdA8wXnKVEN/10TLn2HMoC9Hc3t5r7fUtzWZKr70oJ9loSQ
   GtdnfIXIXBbnzVIPdHqb73lfIxQR4seeHaHON3mpgFTHzTG0ZuX0oHjHY
   lxgzN4OiSoku6dDTTPHIKMqr4dSpHbos2X/9FNs4vjy0lecpiBYUgzxSz
   1O9FctNKThyyGojQyI7NcDPsUEjUVyoLGR21ByEiThPIKQjJ/IUlokCpU
   Q==;
X-CSE-ConnectionGUID: DklQodldSY66avYwhi9v3A==
X-CSE-MsgGUID: 2NLUpb6SQ5Cg8/0FcqPd0A==
X-IronPort-AV: E=McAfee;i="6700,10204,11283"; a="34439264"
X-IronPort-AV: E=Sophos;i="6.12,227,1728975600"; 
   d="scan'208";a="34439264"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Dec 2024 23:49:26 -0800
X-CSE-ConnectionGUID: 7okOIhM0Td+7Ouqa45RhEA==
X-CSE-MsgGUID: zmgxLfqXTWedfbcXlMc7xA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,227,1728975600"; 
   d="scan'208";a="101179535"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.36])
  by orviesa004.jf.intel.com with ESMTP; 11 Dec 2024 23:49:23 -0800
Date: Thu, 12 Dec 2024 16:07:38 +0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Binbin Wu <binbin.wu@linux.intel.com>
Cc: pbonzini@redhat.com, xiaoyao.li@intel.com, qemu-devel@nongnu.org,
	seanjc@google.com, michael.roth@amd.com, rick.p.edgecombe@intel.com,
	isaku.yamahata@intel.com, farrah.chen@intel.com,
	kvm@vger.kernel.org
Subject: Re: [PATCH] i386/kvm: Set return value after handling
 KVM_EXIT_HYPERCALL
Message-ID: <Z1qZygKqvjIfpOXD@intel.com>
References: <20241212032628.475976-1-binbin.wu@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241212032628.475976-1-binbin.wu@linux.intel.com>

On Thu, Dec 12, 2024 at 11:26:28AM +0800, Binbin Wu wrote:
> Date: Thu, 12 Dec 2024 11:26:28 +0800
> From: Binbin Wu <binbin.wu@linux.intel.com>
> Subject: [PATCH] i386/kvm: Set return value after handling
>  KVM_EXIT_HYPERCALL
> X-Mailer: git-send-email 2.46.0
> 
> Userspace should set the ret field of hypercall after handling
> KVM_EXIT_HYPERCALL.  Otherwise, a stale value could be returned to KVM.
> 
> Fixes: 47e76d03b15 ("i386/kvm: Add KVM_EXIT_HYPERCALL handling for KVM_HC_MAP_GPA_RANGE")
> Reported-by: Farrah Chen <farrah.chen@intel.com>
> Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
> Tested-by: Farrah Chen <farrah.chen@intel.com>
> ---
> To test the TDX code in kvm-coco-queue, please apply the patch to the QEMU,
> otherwise, TDX guest boot could fail.
> A matching QEMU tree including this patch is here:
> https://github.com/intel-staging/qemu-tdx/releases/tag/tdx-qemu-upstream-v6.1-fix_kvm_hypercall_return_value
> 
> Previously, the issue was not triggered because no one would modify the ret
> value. But with the refactor patch for __kvm_emulate_hypercall() in KVM,
> https://lore.kernel.org/kvm/20241128004344.4072099-7-seanjc@google.com/, the
> value could be modified.

Could you explain the specific reasons here in detail? It would be
helpful with debugging or reproducing the issue.

> ---
>  target/i386/kvm/kvm.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
> index 8e17942c3b..4bcccb48d1 100644
> --- a/target/i386/kvm/kvm.c
> +++ b/target/i386/kvm/kvm.c
> @@ -6005,10 +6005,14 @@ static int kvm_handle_hc_map_gpa_range(struct kvm_run *run)
>  
>  static int kvm_handle_hypercall(struct kvm_run *run)
>  {
> +    int ret = -EINVAL;
> +
>      if (run->hypercall.nr == KVM_HC_MAP_GPA_RANGE)
> -        return kvm_handle_hc_map_gpa_range(run);
> +        ret = kvm_handle_hc_map_gpa_range(run);
> +
> +    run->hypercall.ret = ret;

ret may be negative but hypercall.ret is u64. Do we need to set it to
-ret?

> -    return -EINVAL;
> +    return ret;
>  }
>  
>  #define VMX_INVALID_GUEST_STATE 0x80000021
> 
> base-commit: ae35f033b874c627d81d51070187fbf55f0bf1a7
> -- 
> 2.46.0
> 
> 

