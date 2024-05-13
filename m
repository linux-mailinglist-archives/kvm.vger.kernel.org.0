Return-Path: <kvm+bounces-17296-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0B5F78C3B4D
	for <lists+kvm@lfdr.de>; Mon, 13 May 2024 08:29:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3D69F1C20F9F
	for <lists+kvm@lfdr.de>; Mon, 13 May 2024 06:29:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2DD28146A62;
	Mon, 13 May 2024 06:29:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MoBBGSYb"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEF361465A3;
	Mon, 13 May 2024 06:29:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715581742; cv=none; b=cUqgU6TZM/PXd/KhmvhwEEw/noFEBvwAUHE+BM2qWPvFuEkOk5Tgc1NfItUMGgs59Mvgpxq3rl/Q8Aoto5lsJO5v4jGojp/jJbSkZqqQvn2EE6zZohNLJ35il9b4AMBS8LVLghS5CJpiXKr8nqMR0LA9dFU72n3G3V02AqhJqiQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715581742; c=relaxed/simple;
	bh=X1WHHiya6vKnFWtiDbQo4wx4R3OC4bn9qs/Gt454L2Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MBSkqGgILdoh+YjxE3KiLZ7laNfMiOcAJNLF/XpTQr7NeZE1Xwwoks7n4tsGdl0zz2j5SImAYwEVzGKuLo0VosfZx/MFPHn5tGmIsFRbphJ9/Jie3cKbeocjgF1C0JKnLmEmOqA/UVQlpCYpeiVJCK3xBkKetojdmiXg34a6pEA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MoBBGSYb; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715581741; x=1747117741;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=X1WHHiya6vKnFWtiDbQo4wx4R3OC4bn9qs/Gt454L2Q=;
  b=MoBBGSYbAmod7EOaGI17NFjvh88p22HPYIV1HIHZuvUqCoUYtiQFlWaf
   IaHWf2gAq+oil5J2Z+7omifanCtyNwVn/wIZZUelC8Er6/jsECbbyA5DP
   BxOWkJTggzOxna/hHbZVb14cbzgDv3Av8DfewhR13/E8R5QNhAH++DitA
   au88yX0ivEugSNch+MdjX+c+D/fVEOGTU50t5OtcOW57qgmGkfPPwISZO
   wMcu7v68310qqMqMsPuwQY1iyfSPsxPPYVLt59yo3VdBA9UCvG0KfCSxe
   SFQWRVUrBrEwcjK9zvMeTMWTTVAqR0evyXvNVG4QAtalqfqkRYCDGtlHG
   A==;
X-CSE-ConnectionGUID: YoBLKrJlTMGp4uMiIQeTIg==
X-CSE-MsgGUID: UkFzToTxQS+jqHxt11yt4Q==
X-IronPort-AV: E=McAfee;i="6600,9927,11071"; a="11624765"
X-IronPort-AV: E=Sophos;i="6.08,157,1712646000"; 
   d="scan'208";a="11624765"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 May 2024 23:29:00 -0700
X-CSE-ConnectionGUID: e+wcO4BSQxeB38WH5dpVwg==
X-CSE-MsgGUID: A5JY5W5MQ3itKyvahFw0Hg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,157,1712646000"; 
   d="scan'208";a="30267879"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.125.243.198]) ([10.125.243.198])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 May 2024 23:28:58 -0700
Message-ID: <e7ad9ad5-7f55-4a89-b4fb-2b0043a93552@intel.com>
Date: Mon, 13 May 2024 14:28:54 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 15/17] KVM: x86/mmu: Set kvm_page_fault.hva to
 KVM_HVA_ERR_BAD for "no slot" faults
To: Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org
Cc: Sean Christopherson <seanjc@google.com>, Kai Huang <kai.huang@intel.com>
References: <20240507155817.3951344-1-pbonzini@redhat.com>
 <20240507155817.3951344-16-pbonzini@redhat.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20240507155817.3951344-16-pbonzini@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/7/2024 11:58 PM, Paolo Bonzini wrote:
> From: Sean Christopherson <seanjc@google.com>
> 
> Explicitly set fault->hva to KVM_HVA_ERR_BAD when handling a "no slot"
> fault to ensure that KVM doesn't use a bogus virtual address, e.g. if
> there *was* a slot but it's unusable (APIC access page), or if there
> really was no slot, in which case fault->hva will be '0' (which is a
> legal address for x86).
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> Reviewed-by: Kai Huang <kai.huang@intel.com>
> Message-ID: <20240228024147.41573-15-seanjc@google.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>

> ---
>   arch/x86/kvm/mmu/mmu.c | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 7630ad8cb022..d717d60c6f19 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -3273,6 +3273,7 @@ static int kvm_handle_noslot_fault(struct kvm_vcpu *vcpu,
>   	fault->slot = NULL;
>   	fault->pfn = KVM_PFN_NOSLOT;
>   	fault->map_writable = false;
> +	fault->hva = KVM_HVA_ERR_BAD;
>   
>   	/*
>   	 * If MMIO caching is disabled, emulate immediately without


