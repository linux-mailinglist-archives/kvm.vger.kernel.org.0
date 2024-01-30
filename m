Return-Path: <kvm+bounces-7437-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A32FF841D5B
	for <lists+kvm@lfdr.de>; Tue, 30 Jan 2024 09:15:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 50E0828F14B
	for <lists+kvm@lfdr.de>; Tue, 30 Jan 2024 08:15:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 705C85914F;
	Tue, 30 Jan 2024 08:14:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="b4kF8FIm"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4282F5823A;
	Tue, 30 Jan 2024 08:14:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.55.52.88
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706602463; cv=none; b=ixOfQtJXoL36vAqlxTjK7qIYNI2mC6GNNPwR59U0CTYrVCVxBE68i0rjTm8UNijChRCUJXqp54fCW6U0XSiY1lGqFLk/iqxXEDpd6VeeGmmtu1qZfMG5pt5Gl5QdvEbI/WbfCREi3zW5t72Vqn+UaSnQGXGmwXqmeRBpXOltz8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706602463; c=relaxed/simple;
	bh=E8RAqBrguK3vR29UWlT3SGFAVHtLTsrLAzb3l9M3J3c=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=S5iU6cCkWPNUwlXqcgA1Yez1WTRn/ssH6MrtLOje1AjmCQvg6u6U6LM5YCDExp5TqA3Xg6CfIg8w9+p56q+uzaHBFc4OnrySP7DPQ28RXFakXkpL5Q05YAxoWp2qTfanw4s3mBWjKPquhfMwB0UYwlkuTEZdABToY0WO3S5ZpZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=b4kF8FIm; arc=none smtp.client-ip=192.55.52.88
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706602462; x=1738138462;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=E8RAqBrguK3vR29UWlT3SGFAVHtLTsrLAzb3l9M3J3c=;
  b=b4kF8FImrRrTh1q251wn+SXmyA2zx10jvILfUixAmHrRe1isx5PsBN13
   wmCAQcV55nWVy68LrbvIYtqz0T98vhIizU90ZBsroMb7XmE67rFQztcD2
   5FxPdRp70SpmQpm7FHhNP/UYp+D2iIHt9OU5VaEVSRMWRG+pF+m5iaQPp
   52KZq7sj+xDhLmEj/NMo2ciUISE2V0OQFiLb5Qt5fnm7x1M62c0PG83hH
   2sQ6gT2TTDVCdQFzsoBMxy3Cyj/PL3DilwkHXVgjVo8y4TKwFpWg3/hnY
   +tL3lWi7Ud/FZChgegv3VGMazCro4i6NAQrculGpyCFCrvdnxopzaGfZQ
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10968"; a="434376209"
X-IronPort-AV: E=Sophos;i="6.05,707,1701158400"; 
   d="scan'208";a="434376209"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jan 2024 00:14:21 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,707,1701158400"; 
   d="scan'208";a="36420080"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.238.10.49]) ([10.238.10.49])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jan 2024 00:14:18 -0800
Message-ID: <3ef50211-7746-4054-84b6-6861d6a91341@linux.intel.com>
Date: Tue, 30 Jan 2024 16:14:15 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v18 050/121] KVM: x86/tdp_mmu: Sprinkle __must_check
To: isaku.yamahata@intel.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
 erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
 Sagi Shahar <sagis@google.com>, Kai Huang <kai.huang@intel.com>,
 chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com
References: <cover.1705965634.git.isaku.yamahata@intel.com>
 <8f7d5a1b241bf5351eaab828d1a1efe5c17699ca.1705965635.git.isaku.yamahata@intel.com>
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <8f7d5a1b241bf5351eaab828d1a1efe5c17699ca.1705965635.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 1/23/2024 7:53 AM, isaku.yamahata@intel.com wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
>
> TDP MMU allows tdp_mmu_set_spte_atomic() and tdp_mmu_zap_spte_atomic() to
> return -EBUSY or -EAGAIN error.  The caller must check the return value and
> retry.  Sprinkle __must_check to guarantee it.

Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>

>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>   arch/x86/kvm/mmu/tdp_mmu.c | 10 +++++-----
>   1 file changed, 5 insertions(+), 5 deletions(-)
>
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index fdc6e2221c33..2aacfab25e93 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -507,9 +507,9 @@ static void handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
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
> @@ -539,8 +539,8 @@ static inline int tdp_mmu_set_spte_atomic(struct kvm *kvm,
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


