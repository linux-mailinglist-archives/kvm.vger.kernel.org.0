Return-Path: <kvm+bounces-7958-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B995D8492BA
	for <lists+kvm@lfdr.de>; Mon,  5 Feb 2024 04:15:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 56ABFB2203F
	for <lists+kvm@lfdr.de>; Mon,  5 Feb 2024 03:15:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0B90EB645;
	Mon,  5 Feb 2024 03:14:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KCrNTATx"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D031947F;
	Mon,  5 Feb 2024 03:14:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707102851; cv=none; b=NRszLPHvPaSUtHBiPUlgIZFLoUYHhj/x3iwFePbH8sMMRGm1fX1/jycG9Qv2JmDS9OhbKlBaAFmeYqk1G/QHe86kVqP0JAyt+zgTI1O8oCRkyUbdYfue9eCgrdvRq1oRFiJvxSSL06SlkB1Dbv2UeoEW0DY/e879UN0GUnEQJiU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707102851; c=relaxed/simple;
	bh=MWsnU2xeLcim5q2Ctdfdd7941DBKVOOsy4cTw5k6d8w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Eon3qev6Mm6vs4k3GISCXOjVh4Lavt6KJ4LwnsDpFWUUppLkSwDph60ZSZ+R4WeuTfv4EWS5aXvHqEGglE9eM9O57PSwHprbWm0eQCDYbP65y2OLGgbSY7YCRq/XAK+sQ/s6oV7uvp26He5zGXzTwELvyRX5iTTVHWW6rvK9apg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KCrNTATx; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1707102850; x=1738638850;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=MWsnU2xeLcim5q2Ctdfdd7941DBKVOOsy4cTw5k6d8w=;
  b=KCrNTATxtDopM2s3MCR1mxSGDYvFgcj7ehy5S7VTaKfcjwek8Rp+oqLK
   n7fzd4uyYCXpMG06tp9gJh16kXvBSyXS4iKhZGd4KngVCZqZ2w2mbZAwH
   m+3z9FV79FVtqdWePIlEy2Yy99L0xTdYDJE4SqUjmwAEm7xAPgYmoQZYh
   xQojHi0EGDCgO7WEGTm5UjGnvKuCTkbGHbsi/NkRVotHN3qClkeckREOO
   P8UzWzOhQnSpCIdeWqWoM5N51UBq+Ni32wBeYFhl80VcQDDewhiT5EF6f
   I0ZXnEnaDecXU8u6KDu81Z5KdLoYGo2Riwfxl8gUdK9FvjZ7S5HFTgU9d
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10974"; a="17857324"
X-IronPort-AV: E=Sophos;i="6.05,242,1701158400"; 
   d="scan'208";a="17857324"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Feb 2024 19:14:09 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,242,1701158400"; 
   d="scan'208";a="5210744"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.238.10.49]) ([10.238.10.49])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Feb 2024 19:14:05 -0800
Message-ID: <de174460-018c-4402-8fca-8555be669aa2@linux.intel.com>
Date: Mon, 5 Feb 2024 11:14:03 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v18 058/121] KVM: TDX: Retry seamcall when
 TDX_OPERAND_BUSY with operand SEPT
To: isaku.yamahata@intel.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
 erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
 Sagi Shahar <sagis@google.com>, Kai Huang <kai.huang@intel.com>,
 chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com,
 Yuan Yao <yuan.yao@intel.com>
References: <cover.1705965634.git.isaku.yamahata@intel.com>
 <d854fa4415ca6d2b5d055d0b29b147a5cdf232f7.1705965635.git.isaku.yamahata@intel.com>
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <d854fa4415ca6d2b5d055d0b29b147a5cdf232f7.1705965635.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 1/23/2024 7:53 AM, isaku.yamahata@intel.com wrote:
> From: Yuan Yao <yuan.yao@intel.com>
>
> TDX module internally uses locks to protect internal resources.  It tries
> to acquire the locks.  If it fails to obtain the lock, it returns
> TDX_OPERAND_BUSY error without spin because its execution time limitation.
>
> TDX SEAMCALL API reference describes what resources are used.  It's known
> which TDX SEAMCALL can cause contention with which resources.  VMM can
> avoid contention inside the TDX module by avoiding contentious TDX SEAMCALL
> with, for example, spinlock.  Because OS knows better its process
> scheduling and its scalability, a lock at OS/VMM layer would work better
> than simply retrying TDX SEAMCALLs.
>
> TDH.MEM.* API except for TDH.MEM.TRACK operates on a secure EPT tree and
> the TDX module internally tries to acquire the lock of the secure EPT tree.
> They return TDX_OPERAND_BUSY | TDX_OPERAND_ID_SEPT in case of failure to
> get the lock.  TDX KVM allows sept callbacks to return error so that TDP
> MMU layer can retry.
>
> TDH.VP.ENTER is an exception with zero-step attack mitigation.  Normally
> TDH.VP.ENTER uses only TD vcpu resources and it doesn't cause contention.
> When a zero-step attack is suspected, it obtains a secure EPT tree lock and
> tracks the GPAs causing a secure EPT fault.  Thus TDG.VP.ENTER may result

Should be TDH.VP.ENTER.

> in TDX_OPERAND_BUSY | TDX_OPERAND_ID_SEPT.  Also TDH.MEM.* SEAMCALLs may
> result in TDX_OPERAN_BUSY | TDX_OPERAND_ID_SEPT.
s/TDX_OPERAN_BUSY/TDX_OPERAND_BUSY

>
> Retry TDX TDH.MEM.* API and TDH.VP.ENTER on the error because the error is
> a rare event caused by zero-step attack mitigation and spinlock can not be
> used for TDH.VP.ENTER due to indefinite time execution.

Does it retry TDH.VP.ENTER on SEPT busy?
I didn't see the related code in this patch.


>
> Signed-off-by: Yuan Yao <yuan.yao@intel.com>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>   arch/x86/kvm/vmx/tdx_ops.h | 48 +++++++++++++++++++++++++++++++-------
>   1 file changed, 39 insertions(+), 9 deletions(-)
>
> diff --git a/arch/x86/kvm/vmx/tdx_ops.h b/arch/x86/kvm/vmx/tdx_ops.h
> index cd12e9c2a421..53a6c3f692b0 100644
> --- a/arch/x86/kvm/vmx/tdx_ops.h
> +++ b/arch/x86/kvm/vmx/tdx_ops.h
> @@ -52,6 +52,36 @@ static inline u64 tdx_seamcall(u64 op, struct tdx_module_args *in,
>   void pr_tdx_error(u64 op, u64 error_code, const struct tdx_module_args *out);
>   #endif
>   
> +/*
> + * TDX module acquires its internal lock for resources.  It doesn't spin to get
> + * locks because of its restrictions of allowed execution time.  Instead, it
> + * returns TDX_OPERAND_BUSY with an operand id.
> + *
> + * Multiple VCPUs can operate on SEPT.  Also with zero-step attack mitigation,
> + * TDH.VP.ENTER may rarely acquire SEPT lock and release it when zero-step
> + * attack is suspected.  It results in TDX_OPERAND_BUSY | TDX_OPERAND_ID_SEPT
> + * with TDH.MEM.* operation.  Note: TDH.MEM.TRACK is an exception.
> + *
> + * Because TDP MMU uses read lock for scalability, spin lock around SEAMCALL
> + * spoils TDP MMU effort.  Retry several times with the assumption that SEPT
> + * lock contention is rare.  But don't loop forever to avoid lockup.  Let TDP
> + * MMU retry.
> + */
> +#define TDX_ERROR_SEPT_BUSY    (TDX_OPERAND_BUSY | TDX_OPERAND_ID_SEPT)
> +
> +static inline u64 tdx_seamcall_sept(u64 op, struct tdx_module_args *in,
> +				    struct tdx_module_args *out)
> +{
> +#define SEAMCALL_RETRY_MAX     16
> +	int retry = SEAMCALL_RETRY_MAX;
> +	u64 ret;
> +
> +	do {
> +		ret = tdx_seamcall(op, in, out);
> +	} while (ret == TDX_ERROR_SEPT_BUSY && retry-- > 0);
> +	return ret;
> +}
> +
>   static inline u64 tdh_mng_addcx(hpa_t tdr, hpa_t addr)
>   {
>   	struct tdx_module_args in = {
> @@ -74,7 +104,7 @@ static inline u64 tdh_mem_page_add(hpa_t tdr, gpa_t gpa, hpa_t hpa, hpa_t source
>   	};
>   
>   	clflush_cache_range(__va(hpa), PAGE_SIZE);
> -	return tdx_seamcall(TDH_MEM_PAGE_ADD, &in, out);
> +	return tdx_seamcall_sept(TDH_MEM_PAGE_ADD, &in, out);
>   }
>   
>   static inline u64 tdh_mem_sept_add(hpa_t tdr, gpa_t gpa, int level, hpa_t page,
> @@ -87,7 +117,7 @@ static inline u64 tdh_mem_sept_add(hpa_t tdr, gpa_t gpa, int level, hpa_t page,
>   	};
>   
>   	clflush_cache_range(__va(page), PAGE_SIZE);
> -	return tdx_seamcall(TDH_MEM_SEPT_ADD, &in, out);
> +	return tdx_seamcall_sept(TDH_MEM_SEPT_ADD, &in, out);
>   }
>   
>   static inline u64 tdh_mem_sept_rd(hpa_t tdr, gpa_t gpa, int level,
> @@ -98,7 +128,7 @@ static inline u64 tdh_mem_sept_rd(hpa_t tdr, gpa_t gpa, int level,
>   		.rdx = tdr,
>   	};
>   
> -	return tdx_seamcall(TDH_MEM_SEPT_RD, &in, out);
> +	return tdx_seamcall_sept(TDH_MEM_SEPT_RD, &in, out);
>   }
>   
>   static inline u64 tdh_mem_sept_remove(hpa_t tdr, gpa_t gpa, int level,
> @@ -109,7 +139,7 @@ static inline u64 tdh_mem_sept_remove(hpa_t tdr, gpa_t gpa, int level,
>   		.rdx = tdr,
>   	};
>   
> -	return tdx_seamcall(TDH_MEM_SEPT_REMOVE, &in, out);
> +	return tdx_seamcall_sept(TDH_MEM_SEPT_REMOVE, &in, out);
>   }
>   
>   static inline u64 tdh_vp_addcx(hpa_t tdvpr, hpa_t addr)
> @@ -133,7 +163,7 @@ static inline u64 tdh_mem_page_relocate(hpa_t tdr, gpa_t gpa, hpa_t hpa,
>   	};
>   
>   	clflush_cache_range(__va(hpa), PAGE_SIZE);
> -	return tdx_seamcall(TDH_MEM_PAGE_RELOCATE, &in, out);
> +	return tdx_seamcall_sept(TDH_MEM_PAGE_RELOCATE, &in, out);
>   }
>   
>   static inline u64 tdh_mem_page_aug(hpa_t tdr, gpa_t gpa, hpa_t hpa,
> @@ -146,7 +176,7 @@ static inline u64 tdh_mem_page_aug(hpa_t tdr, gpa_t gpa, hpa_t hpa,
>   	};
>   
>   	clflush_cache_range(__va(hpa), PAGE_SIZE);
> -	return tdx_seamcall(TDH_MEM_PAGE_AUG, &in, out);
> +	return tdx_seamcall_sept(TDH_MEM_PAGE_AUG, &in, out);
>   }
>   
>   static inline u64 tdh_mem_range_block(hpa_t tdr, gpa_t gpa, int level,
> @@ -157,7 +187,7 @@ static inline u64 tdh_mem_range_block(hpa_t tdr, gpa_t gpa, int level,
>   		.rdx = tdr,
>   	};
>   
> -	return tdx_seamcall(TDH_MEM_RANGE_BLOCK, &in, out);
> +	return tdx_seamcall_sept(TDH_MEM_RANGE_BLOCK, &in, out);
>   }
>   
>   static inline u64 tdh_mng_key_config(hpa_t tdr)
> @@ -307,7 +337,7 @@ static inline u64 tdh_mem_page_remove(hpa_t tdr, gpa_t gpa, int level,
>   		.rdx = tdr,
>   	};
>   
> -	return tdx_seamcall(TDH_MEM_PAGE_REMOVE, &in, out);
> +	return tdx_seamcall_sept(TDH_MEM_PAGE_REMOVE, &in, out);
>   }
>   
>   static inline u64 tdh_sys_lp_shutdown(void)
> @@ -335,7 +365,7 @@ static inline u64 tdh_mem_range_unblock(hpa_t tdr, gpa_t gpa, int level,
>   		.rdx = tdr,
>   	};
>   
> -	return tdx_seamcall(TDH_MEM_RANGE_UNBLOCK, &in, out);
> +	return tdx_seamcall_sept(TDH_MEM_RANGE_UNBLOCK, &in, out);
>   }
>   
>   static inline u64 tdh_phymem_cache_wb(bool resume)


