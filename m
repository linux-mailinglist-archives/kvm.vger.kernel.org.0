Return-Path: <kvm+bounces-10595-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1516C86DC43
	for <lists+kvm@lfdr.de>; Fri,  1 Mar 2024 08:45:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4728A1C2233A
	for <lists+kvm@lfdr.de>; Fri,  1 Mar 2024 07:45:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 945C06996E;
	Fri,  1 Mar 2024 07:44:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hQUEroIx"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D982F6995D;
	Fri,  1 Mar 2024 07:44:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709279092; cv=none; b=KtGs7JFVevmDN1w2GcFRRLpjrFGayEpEi3ZCBKg4NzU9pSjjKJ6q6etWQX3qOKmoDdX77wyTQZ2e8bugSap16Ctd5RiKV4CjJGjFZgSjCPH/taThjc0dHRTS5IXBJd1REDUCpqtorGzC6xqhmjHmNf13k3fCLv1iyWhpDzR1haI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709279092; c=relaxed/simple;
	bh=7a1lsGBnWJLzO4eKjNjWM3PpBUzHMyfsQrth9Is9Nq0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PthzACda3LH9mzyOvRbm8RuKob/RnWunBhywbYZNmTNZcBbkfLpCSWzAjiZPJROOknW5FIu4x/qpxfsn4UKx3sCuLvWmPT67yHf/UDYxwStcPUt6Kt0G2+/wSjjIkSNzg5hXlvt/uOkCfwqkSol61Cq1Hv351B65MJnSb1N+agw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hQUEroIx; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709279091; x=1740815091;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=7a1lsGBnWJLzO4eKjNjWM3PpBUzHMyfsQrth9Is9Nq0=;
  b=hQUEroIxEHzsXXWmWwur9WEMObaeXhlagg4hWM1TN5J0N06PJfFNTsj+
   w6fItj9V1BazwqKqeJnOpt3t54fFfbzEZcNHdqoRWMxnkRCZ+4RARKeld
   1bRTKCowP1f9Dt/8bODreDrc4nihxAdSdyeuDKM8O2jkrguSt7xAk2i2b
   yruaavnIEejfrjXXFWdlbzTHoTlFsLqFoKF6QgcbYjyYyYWOMdJ82hZKs
   lASQK88KvihfEv9zFA93jswIFUz7VYxdKVEKDN0knn7xGI/M//Q8QuUp9
   v5Tk6Y1N2Olu8jZExnxfXVdY20pU6nIzLFvrcF1slPbs8TUAKuT06AosL
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10999"; a="3658825"
X-IronPort-AV: E=Sophos;i="6.06,195,1705392000"; 
   d="scan'208";a="3658825"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Feb 2024 23:44:48 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,195,1705392000"; 
   d="scan'208";a="8536375"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.125.243.127]) ([10.125.243.127])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Feb 2024 23:44:45 -0800
Message-ID: <c4f1b284-5b86-4cd9-9629-56bdd7244cd1@intel.com>
Date: Fri, 1 Mar 2024 15:44:42 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 06/21] KVM: x86/mmu: Track shadow MMIO value on a per-VM
 basis
Content-Language: en-US
To: Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org
Cc: seanjc@google.com, michael.roth@amd.com, isaku.yamahata@intel.com,
 thomas.lendacky@amd.com
References: <20240227232100.478238-1-pbonzini@redhat.com>
 <20240227232100.478238-7-pbonzini@redhat.com>
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20240227232100.478238-7-pbonzini@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/28/2024 7:20 AM, Paolo Bonzini wrote:
> From: Sean Christopherson <seanjc@google.com>
> 
> TDX will use a different shadow PTE entry value for MMIO from VMX.  Add
> members to kvm_arch and track value for MMIO per-VM instead of global
> variables.  By using the per-VM EPT entry value for MMIO, the existing VMX
> logic is kept working.  Introduce a separate setter function so that guest
> TD can override later.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> Message-Id: <229a18434e5d83f45b1fcd7bf1544d79db1becb6.1705965635.git.isaku.yamahata@intel.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>   arch/x86/include/asm/kvm_host.h |  2 ++
>   arch/x86/kvm/mmu.h              |  1 +
>   arch/x86/kvm/mmu/mmu.c          |  8 +++++---
>   arch/x86/kvm/mmu/spte.c         | 10 ++++++++--
>   arch/x86/kvm/mmu/spte.h         |  4 ++--
>   arch/x86/kvm/mmu/tdp_mmu.c      |  6 +++---
>   6 files changed, 21 insertions(+), 10 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 85dc0f7d09e3..a4514c2ef0ec 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1313,6 +1313,8 @@ struct kvm_arch {
>   	 */
>   	spinlock_t mmu_unsync_pages_lock;
>   
> +	u64 shadow_mmio_value;
> +
>   	struct iommu_domain *iommu_domain;
>   	bool iommu_noncoherent;
>   #define __KVM_HAVE_ARCH_NONCOHERENT_DMA
> diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
> index 60f21bb4c27b..2c54ba5b0a28 100644
> --- a/arch/x86/kvm/mmu.h
> +++ b/arch/x86/kvm/mmu.h
> @@ -101,6 +101,7 @@ static inline u8 kvm_get_shadow_phys_bits(void)
>   }
>   
>   void kvm_mmu_set_mmio_spte_mask(u64 mmio_value, u64 mmio_mask, u64 access_mask);
> +void kvm_mmu_set_mmio_spte_value(struct kvm *kvm, u64 mmio_value);

Now, the new added function along with above function mislead people on 
their names. It's easily to think

  - kvm_mmu_set_mmio_spte_mask() is to set shadow_mmio_mask, while
  - kvm_mmu_set_mmio_spte_value() is to set shadow_mmio_value

we'd better come up with a better name.

Other than it, the patch looks good to me.

Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>

