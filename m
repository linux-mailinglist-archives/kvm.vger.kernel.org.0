Return-Path: <kvm+bounces-7481-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 47DC284281D
	for <lists+kvm@lfdr.de>; Tue, 30 Jan 2024 16:34:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7ABB61C23354
	for <lists+kvm@lfdr.de>; Tue, 30 Jan 2024 15:34:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3992882D8A;
	Tue, 30 Jan 2024 15:33:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="J1d9Ne19"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A10A5823C9;
	Tue, 30 Jan 2024 15:33:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706628833; cv=none; b=qpnAyR+xlGbjigdElPlRe2XFsVJAPX2naiZk4FC0Y/CdeliuZgkcxvRpkWe6G48h6/zx9j53hdijbw/2X4NO3/fWEV+jgnrZld83HYEO8x/rfIH8c2Jv90/pCyjX5qZwpIUKN7bolApCGPVIzmsEzTMQR0g5oZc2PVKKm8ca9Hs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706628833; c=relaxed/simple;
	bh=nkm0OWHFuQWKYwZc1WEkbla4lt45LORU0WQDLLCTrX8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FTN828yswo2mlGM9HpteWocxZSUQXo1Q50BEChpVKfF4OlgLB6IBTtE7BJ9/4CG26cUNn/EhtL3J6R1gugxERV0yMiNiFAZeK3E24vmRsO1qWag5NUhwsAB+aRavDrRJXqzGX/vQeSLdmmIzTDLffMHAD1EPB8ZM92H1McPHiBc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=J1d9Ne19; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706628832; x=1738164832;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=nkm0OWHFuQWKYwZc1WEkbla4lt45LORU0WQDLLCTrX8=;
  b=J1d9Ne19A4LFXTKnCitwq93tpxnz9d8oXgrBENpCJ44yk1S0dbioAnLN
   6CyUFLOsnp5z0ezptwgFQTwEfRdSEEsbOAQ2FJider9af8J+NkjfNira6
   ngZDJ7D55lV9N44axbscd/javmXpZyjZgVOuuIKkzZh6z/pYUHcr2xzy9
   zteSAvTiYidVODJxbWkHbBNSRpeGcTqlgZVY5SmR9ylGOoOWcE6yxIMCG
   m50sYCFPjibiTIIWIhzxbJOSxdUhNk5YXUtaOX3MJkdjSghHV7gK4vGYV
   gjJ3bsw9UAL87Ca82XRzx5XHgFJjFCpc0gLxCeAJd163G6fIB+uNoYk51
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10968"; a="24786745"
X-IronPort-AV: E=Sophos;i="6.05,230,1701158400"; 
   d="scan'208";a="24786745"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jan 2024 07:31:27 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,230,1701158400"; 
   d="scan'208";a="22465315"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.93.16.217]) ([10.93.16.217])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jan 2024 07:31:24 -0800
Message-ID: <9da45a6a-a40b-4768-90d0-d7de674baec1@linux.intel.com>
Date: Tue, 30 Jan 2024 23:31:22 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v18 060/121] KVM: TDX: TDP MMU TDX support
To: isaku.yamahata@intel.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
 erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
 Sagi Shahar <sagis@google.com>, Kai Huang <kai.huang@intel.com>,
 chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com
References: <cover.1705965634.git.isaku.yamahata@intel.com>
 <a47c5a9442130f45fc09c1d4ae0e4352054be636.1705965635.git.isaku.yamahata@intel.com>
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <a47c5a9442130f45fc09c1d4ae0e4352054be636.1705965635.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 1/23/2024 7:53 AM, isaku.yamahata@intel.com wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
>
> Implement hooks of TDP MMU for TDX backend.  TLB flush, TLB shootdown,
> propagating the change private EPT entry to Secure EPT and freeing Secure
> EPT page. TLB flush handles both shared EPT and private EPT.  It flushes
> shared EPT same as VMX.  It also waits for the TDX TLB shootdown.  For the
> hook to free Secure EPT page, unlinks the Secure EPT page from the Secure
> EPT so that the page can be freed to OS.
>
> Propagate the entry change to Secure EPT.  The possible entry changes are
> present -> non-present(zapping) and non-present -> present(population).  On
> population just link the Secure EPT page or the private guest page to the
> Secure EPT by TDX SEAMCALL. Because TDP MMU allows concurrent
> zapping/population, zapping requires synchronous TLB shoot down with the
> frozen EPT entry.  It zaps the secure entry, increments TLB counter, sends
> IPI to remote vcpus to trigger TLB flush, and then unlinks the private
> guest page from the Secure EPT. For simplicity, batched zapping with
> exclude lock is handled as concurrent zapping.  Although it's inefficient,
> it can be optimized in the future.
>
> For MMIO SPTE, the spte value changes as follows.
> initial value (suppress VE bit is set)
> -> Guest issues MMIO and triggers EPT violation
> -> KVM updates SPTE value to MMIO value (suppress VE bit is cleared)
> -> Guest MMIO resumes.  It triggers VE exception in guest TD
> -> Guest VE handler issues TDG.VP.VMCALL<MMIO>
> -> KVM handles MMIO
> -> Guest VE handler resumes its execution after MMIO instruction
>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
>
> ---
> v18:
> - rename tdx_sept_page_aug() -> tdx_mem_page_aug()
> - checkpatch: space => tab
>
> v15 -> v16:
> - Add the handling of TD_ATTR_SEPT_VE_DISABLE case.
>
> v14 -> v15:
> - Implemented tdx_flush_tlb_current()
> - Removed unnecessary invept in tdx_flush_tlb().  It was carry over
>    from the very old code base.
> ---
>   arch/x86/kvm/mmu/spte.c    |   3 +-
>   arch/x86/kvm/vmx/main.c    |  71 +++++++-
>   arch/x86/kvm/vmx/tdx.c     | 342 +++++++++++++++++++++++++++++++++++++
>   arch/x86/kvm/vmx/tdx.h     |   2 +-
>   arch/x86/kvm/vmx/tdx_ops.h |   6 +
>   arch/x86/kvm/vmx/x86_ops.h |   6 +
>   6 files changed, 424 insertions(+), 6 deletions(-)
[...]
> +
> +/*
> + * TLB shoot down procedure:
> + * There is a global epoch counter and each vcpu has local epoch counter.
> + * - TDH.MEM.RANGE.BLOCK(TDR. level, range) on one vcpu
> + *   This blocks the subsequenct creation of TLB translation on that range.
> + *   This corresponds to clear the present bit(all RXW) in EPT entry
> + * - TDH.MEM.TRACK(TDR): advances the epoch counter which is global.
> + * - IPI to remote vcpus
> + * - TDExit and re-entry with TDH.VP.ENTER on remote vcpus
> + * - On re-entry, TDX module compares the local epoch counter with the global
> + *   epoch counter.  If the local epoch counter is older than the global epoch
> + *   counter, update the local epoch counter and flushes TLB.
> + */
> +static void tdx_track(struct kvm *kvm)
> +{
> +	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
> +	u64 err;
> +
> +	KVM_BUG_ON(!is_hkid_assigned(kvm_tdx), kvm);
> +	/* If TD isn't finalized, it's before any vcpu running. */
> +	if (unlikely(!is_td_finalized(kvm_tdx)))
> +		return;
> +
> +	/*
> +	 * tdx_flush_tlb() waits for this function to issue TDH.MEM.TRACK() by
> +	 * the counter.  The counter is used instead of bool because multiple
> +	 * TDH_MEM_TRACK() can be issued concurrently by multiple vcpus.
> +	 */
> +	atomic_inc(&kvm_tdx->tdh_mem_track);
> +	/*
> +	 * KVM_REQ_TLB_FLUSH waits for the empty IPI handler, ack_flush(), with
> +	 * KVM_REQUEST_WAIT.
> +	 */
> +	kvm_make_all_cpus_request(kvm, KVM_REQ_TLB_FLUSH);
> +
> +	do {
> +		/*
> +		 * kvm_flush_remote_tlbs() doesn't allow to return error and
> +		 * retry.
> +		 */
> +		err = tdh_mem_track(kvm_tdx->tdr_pa);
> +	} while (unlikely((err & TDX_SEAMCALL_STATUS_MASK) == TDX_OPERAND_BUSY));

Why the sequence of the code is different from the description of the 
function.
In the description, do the TDH.MEM.TRACK before IPIs.
But in the code, do TDH.MEM.TRACK after IPIs?


> +
> +	/* Release remote vcpu waiting for TDH.MEM.TRACK in tdx_flush_tlb(). */
> +	atomic_dec(&kvm_tdx->tdh_mem_track);
> +
> +	if (KVM_BUG_ON(err, kvm))
> +		pr_tdx_error(TDH_MEM_TRACK, err, NULL);
> +
> +}
> +
[...]


