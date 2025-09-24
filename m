Return-Path: <kvm+bounces-58612-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 76835B985D7
	for <lists+kvm@lfdr.de>; Wed, 24 Sep 2025 08:15:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 39A1F17A0C5
	for <lists+kvm@lfdr.de>; Wed, 24 Sep 2025 06:15:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C0DF523AB8B;
	Wed, 24 Sep 2025 06:15:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="IIiO1ezR"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF7B31990D9;
	Wed, 24 Sep 2025 06:15:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758694520; cv=none; b=bPeKDU7Ubrouq8O7Tl0CkV0ldfXXiTaRoKZPOddogOQ2mZvQrBqdu9TyOGRHqAGR6/+gQPixy4ZbsifCP6m0u741qqCyPzrKAEo56+AQCNqC+ia2vbS4NI8hdTLcmsw5gOiEnvLJlxp7Sa7apB67nxvcejNCnO7I1EKDl1wF3g4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758694520; c=relaxed/simple;
	bh=UQKOU4aOyyJuEOQGOD3vHgI8e0kGhF/WCbFuBJ3fxps=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Cuy51Q4r0Ku6+76GwQsyEvDdJRz8dDRoUCIwW8VKYy77DIM1md5/8UCQhhCNtPtTXqFzTze6JO0XnGUfR/EB0xjOoXTRLqcGegfVd7lmmhT4KNqSCGNbLpF2eAyYp17ap4jf4iUK+si6thsW6qaldIqhWe4UkLKgwxeIax3wBdc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=IIiO1ezR; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758694519; x=1790230519;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=UQKOU4aOyyJuEOQGOD3vHgI8e0kGhF/WCbFuBJ3fxps=;
  b=IIiO1ezRy2Y6xoOEYmJQSuTzz22oXtnam4DhuglYKiB8z3nvqcAodol8
   dtIm/7zxJjaAu44NDvYtV4SHH8dd3MWtHnYRdSWp/KdrHKYPicZ7PY80/
   HrN9i3UHDAlImtdEXKEaXbUu1yQ1SZ/J1+dZGc0Fqn0HcGwuOwu6fv2w+
   gT/eF6/k3WlzRzf0QNURE6fMdr9LkDo12YABesEvdvuho0V0WAYCy+qa7
   c6auBbbgYiujzUoQQXhBGuHrG+3ARDuAF3Y1VUZASa4idVxBVfrlCw2DK
   49aiucVvurX423pEVoH5+Ck0FWb4OPDEDcQxGQlevZw29rQg3g84BU3PJ
   A==;
X-CSE-ConnectionGUID: hBh4tlIyTr+JctSIShhdhQ==
X-CSE-MsgGUID: Gy1fe/6cRFOPqHSaghiDCg==
X-IronPort-AV: E=McAfee;i="6800,10657,11561"; a="78420765"
X-IronPort-AV: E=Sophos;i="6.18,290,1751266800"; 
   d="scan'208";a="78420765"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2025 23:15:18 -0700
X-CSE-ConnectionGUID: BwNK/+FdQIap4yTcPLbJDw==
X-CSE-MsgGUID: j5m87MtgSauJ+9GwEE8sxg==
X-ExtLoop1: 1
Received: from unknown (HELO [10.238.0.107]) ([10.238.0.107])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2025 23:15:13 -0700
Message-ID: <86ab9923-624d-4950-abea-46780e94c6ce@linux.intel.com>
Date: Wed, 24 Sep 2025 14:15:11 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 08/16] x86/virt/tdx: Optimize tdx_alloc/free_page()
 helpers
To: Rick Edgecombe <rick.p.edgecombe@intel.com>
Cc: kas@kernel.org, bp@alien8.de, chao.gao@intel.com,
 dave.hansen@linux.intel.com, isaku.yamahata@intel.com, kai.huang@intel.com,
 kvm@vger.kernel.org, linux-coco@lists.linux.dev,
 linux-kernel@vger.kernel.org, mingo@redhat.com, pbonzini@redhat.com,
 seanjc@google.com, tglx@linutronix.de, x86@kernel.org, yan.y.zhao@intel.com,
 vannapurve@google.com, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
References: <20250918232224.2202592-1-rick.p.edgecombe@intel.com>
 <20250918232224.2202592-9-rick.p.edgecombe@intel.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20250918232224.2202592-9-rick.p.edgecombe@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 9/19/2025 7:22 AM, Rick Edgecombe wrote:
> From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
>
> Optimize the PAMT alloc/free helpers to avoid taking the global lock when
> possible.
>
> The recently introduced PAMT alloc/free helpers maintain a refcount to
> keep track of when it is ok to reclaim and free a 4KB PAMT page. This
> refcount is protected by a global lock in order to guarantee that races
> don’t result in the PAMT getting freed while another caller requests it
> be mapped. But a global lock is a bit heavyweight, especially since the
> refcounts can be (already are) updated atomically.
>
> A simple approach would be to increment/decrement the refcount outside of
> the lock before actually adjusting the PAMT, and only adjust the PAMT if
> the refcount transitions from/to 0. This would correctly allocate and free
> the PAMT page without getting out of sync. But there it leaves a race
> where a simultaneous caller could see the refcount already incremented and
> return before it is actually mapped.
>
> So treat the refcount 0->1 case as a special case. On add, if the refcount
> is zero *don’t* increment the refcount outside the lock (to 1). Always
> take the lock in that case and only set the refcount to 1 after the PAMT
> is actually added. This way simultaneous adders, when PAMT is not
> installed yet, will take the slow lock path.
>
> On the 1->0 case, it is ok to return from tdx_pamt_put() when the DPAMT is
> not actually freed yet, so the basic approach works. Just decrement the
> refcount before  taking the lock. Only do the lock and removal of the PAMT
> when the refcount goes to zero.
>
> There is an asymmetry between tdx_pamt_get() and tdx_pamt_put() in that
> tdx_pamt_put() goes 1->0 outside the lock, but tdx_pamt_put() does 0-1
                                                      ^
                                                 tdx_pamt_get() ?
> inside the lock. Because of this, there is a special race where
> tdx_pamt_put() could decrement the refcount to zero before the PAMT is
> actually removed, and tdx_pamt_get() could try to do a PAMT.ADD when the
> page is already mapped. Luckily the TDX module will tell return a special
> error that tells us we hit this case. So handle it specially by looking
> for the error code.
>
> The optimization is a little special, so make the code extra commented
> and verbose.
>
> Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> [Clean up code, update log]
> Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
> ---
> v3:
>   - Split out optimization from “x86/virt/tdx: Add tdx_alloc/free_page() helpers”
>   - Remove edge case handling that I could not find a reason for
>   - Write log
> ---
>   arch/x86/include/asm/shared/tdx_errno.h |  2 ++
>   arch/x86/virt/vmx/tdx/tdx.c             | 46 +++++++++++++++++++++----
>   2 files changed, 42 insertions(+), 6 deletions(-)
>
> diff --git a/arch/x86/include/asm/shared/tdx_errno.h b/arch/x86/include/asm/shared/tdx_errno.h
> index 49ab7ecc7d54..4bc0b9c9e82b 100644
> --- a/arch/x86/include/asm/shared/tdx_errno.h
> +++ b/arch/x86/include/asm/shared/tdx_errno.h
> @@ -21,6 +21,7 @@
>   #define TDX_PREVIOUS_TLB_EPOCH_BUSY		0x8000020100000000ULL
>   #define TDX_RND_NO_ENTROPY			0x8000020300000000ULL
>   #define TDX_PAGE_METADATA_INCORRECT		0xC000030000000000ULL
> +#define TDX_HPA_RANGE_NOT_FREE			0xC000030400000000ULL
>   #define TDX_VCPU_NOT_ASSOCIATED			0x8000070200000000ULL
>   #define TDX_KEY_GENERATION_FAILED		0x8000080000000000ULL
>   #define TDX_KEY_STATE_INCORRECT			0xC000081100000000ULL
> @@ -100,6 +101,7 @@ DEFINE_TDX_ERRNO_HELPER(TDX_SUCCESS);
>   DEFINE_TDX_ERRNO_HELPER(TDX_RND_NO_ENTROPY);
>   DEFINE_TDX_ERRNO_HELPER(TDX_OPERAND_INVALID);
>   DEFINE_TDX_ERRNO_HELPER(TDX_OPERAND_BUSY);
> +DEFINE_TDX_ERRNO_HELPER(TDX_HPA_RANGE_NOT_FREE);
>   DEFINE_TDX_ERRNO_HELPER(TDX_VCPU_NOT_ASSOCIATED);
>   DEFINE_TDX_ERRNO_HELPER(TDX_FLUSHVP_NOT_DONE);
>   
> diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
> index af73b6c2e917..c25e238931a7 100644
> --- a/arch/x86/virt/vmx/tdx/tdx.c
> +++ b/arch/x86/virt/vmx/tdx/tdx.c
> @@ -2117,7 +2117,7 @@ int tdx_pamt_get(struct page *page)
>   	u64 pamt_pa_array[MAX_DPAMT_ARG_SIZE];
>   	atomic_t *pamt_refcount;
>   	u64 tdx_status;
> -	int ret;
> +	int ret = 0;
>   
>   	if (!tdx_supports_dynamic_pamt(&tdx_sysinfo))
>   		return 0;
> @@ -2128,14 +2128,40 @@ int tdx_pamt_get(struct page *page)
>   
>   	pamt_refcount = tdx_find_pamt_refcount(hpa);
>   
> +	if (atomic_inc_not_zero(pamt_refcount))
> +		goto out_free;
> +
>   	scoped_guard(spinlock, &pamt_lock) {
> -		if (atomic_read(pamt_refcount))
> +		/*
> +		 * Lost race to other tdx_pamt_add(). Other task has already allocated
> +		 * PAMT memory for the HPA.
> +		 */
> +		if (atomic_read(pamt_refcount)) {
> +			atomic_inc(pamt_refcount);
>   			goto out_free;
> +		}
>   
>   		tdx_status = tdh_phymem_pamt_add(hpa | TDX_PS_2M, pamt_pa_array);
>   
>   		if (IS_TDX_SUCCESS(tdx_status)) {
> +			/*
> +			 * The refcount is zero, and this locked path is the only way to
> +			 * increase it from 0-1. If the PAMT.ADD was successful, set it
> +			 * to 1 (obviously).
> +			 */
> +			atomic_set(pamt_refcount, 1);
> +		} else if (IS_TDX_HPA_RANGE_NOT_FREE(tdx_status)) {
> +			/*
> +			 * Less obviously, another CPU's call to tdx_pamt_put() could have
> +			 * decremented the refcount before entering its lock section.
> +			 * In this case, the PAMT is not actually removed yet. Luckily
> +			 * TDX module tells about this case, so increment the refcount
> +			 * 0-1, so tdx_pamt_put() skips its pending PAMT.REMOVE.
> +			 *
> +			 * The call didn't need the pages though, so free them.
> +			 */
>   			atomic_inc(pamt_refcount);
> +			goto out_free;
>   		} else {
>   			pr_err("TDH_PHYMEM_PAMT_ADD failed: %#llx\n", tdx_status);
>   			goto out_free;
> @@ -2167,15 +2193,23 @@ void tdx_pamt_put(struct page *page)
>   
>   	pamt_refcount = tdx_find_pamt_refcount(hpa);
>   
> +	/*
> +	 * Unlike the paired call in tdx_pamt_get(), decrement the refcount
> +	 * outside the lock even if it's not the special 0<->1 transition.
it's not -> it's ?

> +	 * See special logic around HPA_RANGE_NOT_FREE in tdx_pamt_get().
> +	 */
> +	if (!atomic_dec_and_test(pamt_refcount))
> +		return;
> +
>   	scoped_guard(spinlock, &pamt_lock) {
> -		if (!atomic_read(pamt_refcount))
> +		/* Lost race with tdx_pamt_get() */
> +		if (atomic_read(pamt_refcount))
>   			return;
>   
>   		tdx_status = tdh_phymem_pamt_remove(hpa | TDX_PS_2M, pamt_pa_array);
>   
> -		if (IS_TDX_SUCCESS(tdx_status)) {
> -			atomic_dec(pamt_refcount);
> -		} else {
> +		if (!IS_TDX_SUCCESS(tdx_status)) {
> +			atomic_inc(pamt_refcount);
>   			pr_err("TDH_PHYMEM_PAMT_REMOVE failed: %#llx\n", tdx_status);
>   			return;
>   		}


