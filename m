Return-Path: <kvm+bounces-56265-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C8D5FB3B7C4
	for <lists+kvm@lfdr.de>; Fri, 29 Aug 2025 11:52:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DA4021BA7494
	for <lists+kvm@lfdr.de>; Fri, 29 Aug 2025 09:53:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 41EDE3054CE;
	Fri, 29 Aug 2025 09:52:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kA9PXWyL"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A7B6270EBC;
	Fri, 29 Aug 2025 09:52:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756461169; cv=none; b=NwOVNO8ZrjWOzbqgIS4xX8w/MTeYfquPncbycVXoiC1t14NGbUih9M2lZgxpHWWPei9enD5DtlF7vTASDks9oBGhMrCyNfjnWOui21fzI4BGJvPFrNnD5IvWdtkMPJRBl/uxi1RLOBwosHadYe0DKisK1DxNA1Kd3aOgmtK8cqk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756461169; c=relaxed/simple;
	bh=T5E7MUA3xyACQTwyysefk6cF5tOE6ceeLrQtL6q37gw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lth2xRPAnPxGOWwpu724iFZ6XXnrKskCoSkPShWlj1sZEUj08nq9dO6VkZidClUjasMeELGXhXH3M4iP2VGnuQOmH4idQUP7hBf6XWgl2Z9ijubajTCy9wf+l2Z4ayO8HZMlVzJQfuCAsW+LR1LmvHFLtncrxXfmhPou2TCe6wc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kA9PXWyL; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756461168; x=1787997168;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=T5E7MUA3xyACQTwyysefk6cF5tOE6ceeLrQtL6q37gw=;
  b=kA9PXWyLs5qJG/1E2NYxGK53gWrq6VLT1MMWtpkTf13EGWqgNrd760qJ
   VL60Sw/BnC8nJE9fD7XZD2vrEGeNYIqmjWQlcu/xhp7OcV50nDkhdq0ZE
   Y/zjIP/VtZ7oG6urhznNTiFgeyqg5y2RY7PfizMOgru2JOxfl1CI2VgBM
   B2w3ZCthZ/7XCANDasR4aKkS1+FaSRIlfeylnYKfIlCGO9MWrxQc2rXtD
   v4/Z/WZAR3cyy/bpl3M9Emttoq6SAJhSl4hnsXK1fMvcoo5ZnRzTPr/Ce
   V+KR6H9vmLsoPMtaRPG2ioAnnBw3udcb4TIJuosnZzBjyQEgeVeuxklCR
   w==;
X-CSE-ConnectionGUID: rT07jn04QO2VkLGOwg97lQ==
X-CSE-MsgGUID: 0VjzFN5cTkqgEmvskHKIXA==
X-IronPort-AV: E=McAfee;i="6800,10657,11536"; a="62561240"
X-IronPort-AV: E=Sophos;i="6.18,221,1751266800"; 
   d="scan'208";a="62561240"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Aug 2025 02:52:47 -0700
X-CSE-ConnectionGUID: cEimaGQsSfOmw3S0IybNNg==
X-CSE-MsgGUID: USiDBVVKRbS9jZfizR0wxg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,221,1751266800"; 
   d="scan'208";a="174717959"
Received: from unknown (HELO [10.238.0.107]) ([10.238.0.107])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Aug 2025 02:52:44 -0700
Message-ID: <0f4225bf-92fd-48a2-8015-65da12a135c8@linux.intel.com>
Date: Fri, 29 Aug 2025 17:52:41 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2 09/18] KVM: TDX: Avoid a double-KVM_BUG_ON() in
 tdx_sept_zap_private_spte()
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, Ira Weiny <ira.weiny@intel.com>,
 Kai Huang <kai.huang@intel.com>, Michael Roth <michael.roth@amd.com>,
 Yan Zhao <yan.y.zhao@intel.com>, Vishal Annapurve <vannapurve@google.com>,
 Rick Edgecombe <rick.p.edgecombe@intel.com>,
 Ackerley Tng <ackerleytng@google.com>
References: <20250829000618.351013-1-seanjc@google.com>
 <20250829000618.351013-10-seanjc@google.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20250829000618.351013-10-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 8/29/2025 8:06 AM, Sean Christopherson wrote:
> Return -EIO immediately from tdx_sept_zap_private_spte() if the number of
> to-be-added pages underflows, so that the following "KVM_BUG_ON(err, kvm)"
> isn't also triggered.  Isolating the check from the "is premap error"
> if-statement will also allow adding a lockdep assertion that premap errors
> are encountered if and only if slots_lock is held.
>
> Reviewed-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>

> ---
>   arch/x86/kvm/vmx/tdx.c | 6 ++++--
>   1 file changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index 07f9ad1fbfb6..cafd618ca43c 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -1724,8 +1724,10 @@ static int tdx_sept_zap_private_spte(struct kvm *kvm, gfn_t gfn,
>   		err = tdh_mem_range_block(&kvm_tdx->td, gpa, tdx_level, &entry, &level_state);
>   		tdx_no_vcpus_enter_stop(kvm);
>   	}
> -	if (tdx_is_sept_zap_err_due_to_premap(kvm_tdx, err, entry, level) &&
> -	    !KVM_BUG_ON(!atomic64_read(&kvm_tdx->nr_premapped), kvm)) {
> +	if (tdx_is_sept_zap_err_due_to_premap(kvm_tdx, err, entry, level)) {
> +		if (KVM_BUG_ON(!atomic64_read(&kvm_tdx->nr_premapped), kvm))
> +			return -EIO;
> +
>   		atomic64_dec(&kvm_tdx->nr_premapped);
>   		return 0;
>   	}


