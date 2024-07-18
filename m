Return-Path: <kvm+bounces-21878-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 174CD9352E0
	for <lists+kvm@lfdr.de>; Thu, 18 Jul 2024 23:10:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 483A81C20CB0
	for <lists+kvm@lfdr.de>; Thu, 18 Jul 2024 21:10:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E0CAB145A1B;
	Thu, 18 Jul 2024 21:10:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="eAHZ3ejz"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FE727711F
	for <kvm@vger.kernel.org>; Thu, 18 Jul 2024 21:10:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721337027; cv=none; b=afZwitPqO7Hv4v5O88VN2zYY9HInqhShVJQsVGLwJGrwyZMgCBNUddh+N/utbcXOS1E+fmb4GiEk9aVzFO01/JUon1pgO7XMeh/ZM5zlEpjoYl4G+u2/wr5QgkrTeONOPXtJ7pTslJCieTNv9TSLhx10Z0QWgxdnwV6f+BEQV/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721337027; c=relaxed/simple;
	bh=zE17BZkwy8UycCJoMocpdUeKfD78ndYlxuRu42pElz0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KfZMqgGjhEbp/tPA6MguWguSqtneSX2ZlwQMKGtB5d5mOzMOtGMYbjmQn4UVig3WE6LsjbDCWs+kCqhym3DmECj52QO94JNvrYecG1/rfoHFgnXRYjKtS79TCGJGZVqLg64eDKs19MebvbC+l/em6ZNCgoWYpb5dfi9CYS5z3Ro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=eAHZ3ejz; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1721337025; x=1752873025;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=zE17BZkwy8UycCJoMocpdUeKfD78ndYlxuRu42pElz0=;
  b=eAHZ3ejzk2oSkpm8TN8nY5iFUM3Z5huSkWjon2WZ9nAqnkj2sblYM4h1
   dwrg0uoKbqE1DbeUFn202Q8owSZxSRjZH2+Xoa2+tgeq7Db5pBAbwM5pF
   tETne1A60RKzSO1mghUt+5WeLGZMP6EsQTPo4l8wZ+jM/ICoJ9toDeFBW
   HYWNtOVwv9WO2sJ9BIiwB5LZ1SsctIey7HpPvAZgn5m6Nxdgm4Quu/jkl
   KThIBSNa5Vk0uS1ah+Jod4+TiBWNQKqYhvTqdHS3jAjhh+FUK1dscIzWg
   bL+3IffCx2GhCiFi1qHDxlgBbweB8+8KrzVsH4NY1h6iJk7iI1WNQQ6Pm
   g==;
X-CSE-ConnectionGUID: eRhTj1UUTD6ztPYnAYp1lg==
X-CSE-MsgGUID: e5cjenk4TOGHm/+HikrGzQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11137"; a="21831740"
X-IronPort-AV: E=Sophos;i="6.09,218,1716274800"; 
   d="scan'208";a="21831740"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jul 2024 14:10:25 -0700
X-CSE-ConnectionGUID: BgUkApG2TkSl7t7DPCmCNw==
X-CSE-MsgGUID: QSRmJP61RIukymHCxKByyw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,218,1716274800"; 
   d="scan'208";a="55179111"
Received: from soc-cp83kr3.jf.intel.com (HELO [10.24.10.107]) ([10.24.10.107])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jul 2024 14:10:25 -0700
Message-ID: <eac04a1a-d340-4d63-9d2e-91d8e4859073@intel.com>
Date: Thu, 18 Jul 2024 14:10:24 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 5/9] target/i386/kvm: Drop workaround for
 KVM_X86_DISABLE_EXITS_HTL typo
To: Zhao Liu <zhao1.liu@intel.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 Eduardo Habkost <eduardo@habkost.net>, "Michael S . Tsirkin"
 <mst@redhat.com>, Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
 Marcelo Tosatti <mtosatti@redhat.com>
Cc: Xiaoyao Li <xiaoyao.li@intel.com>, Pankaj Gupta <pankaj.gupta@amd.com>,
 qemu-devel@nongnu.org, kvm@vger.kernel.org
References: <20240716161015.263031-1-zhao1.liu@intel.com>
 <20240716161015.263031-6-zhao1.liu@intel.com>
Content-Language: en-US
From: "Chen, Zide" <zide.chen@intel.com>
In-Reply-To: <20240716161015.263031-6-zhao1.liu@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 7/16/2024 9:10 AM, Zhao Liu wrote:
> The KVM_X86_DISABLE_EXITS_HTL typo has been fixed in commit
> 77d361b13c19 ("linux-headers: Update to kernel mainline commit
> b357bf602").
> 
> Drop the related workaround.
> 
> Signed-off-by: Zhao Liu <zhao1.liu@intel.com>

Reviewed-by: Zide Chen <zide.chen@intel.com>

> ---
>  target/i386/kvm/kvm.c | 4 ----
>  1 file changed, 4 deletions(-)
> 
> diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
> index 64e54beac7b3..4aae4ffc9ccd 100644
> --- a/target/i386/kvm/kvm.c
> +++ b/target/i386/kvm/kvm.c
> @@ -2728,10 +2728,6 @@ int kvm_arch_init(MachineState *ms, KVMState *s)
>  
>      if (enable_cpu_pm) {
>          int disable_exits = kvm_check_extension(s, KVM_CAP_X86_DISABLE_EXITS);
> -/* Work around for kernel header with a typo. TODO: fix header and drop. */
> -#if defined(KVM_X86_DISABLE_EXITS_HTL) && !defined(KVM_X86_DISABLE_EXITS_HLT)
> -#define KVM_X86_DISABLE_EXITS_HLT KVM_X86_DISABLE_EXITS_HTL
> -#endif
>          if (disable_exits) {
>              disable_exits &= (KVM_X86_DISABLE_EXITS_MWAIT |
>                                KVM_X86_DISABLE_EXITS_HLT |

