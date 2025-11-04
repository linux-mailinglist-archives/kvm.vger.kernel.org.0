Return-Path: <kvm+bounces-61945-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id DF103C2F6D1
	for <lists+kvm@lfdr.de>; Tue, 04 Nov 2025 07:18:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id B8FDF34CDD3
	for <lists+kvm@lfdr.de>; Tue,  4 Nov 2025 06:17:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA6302BEC4A;
	Tue,  4 Nov 2025 06:17:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OXrazto3"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 557AF158538;
	Tue,  4 Nov 2025 06:17:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762237025; cv=none; b=n/S+SM24o5SsQfZ8DfUU8Quj5oQUw2jJpRGof1ubHWjfv4oH10qKHk/FexexXrkKm+EKpRqK8M4sUELvaCyHaQHEj/ioapWSAG7128nku2yw8V6mo71uW+Wwk+I6hbW1R3HcUCDk7ETxcf5cN7nkWaaOUdtemsC7zd1eUON9swE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762237025; c=relaxed/simple;
	bh=mSKoZmGkcXW407B8mNGjY9EejInAopsSE39gAyEUn9k=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KxyLXMJDWe4f36kzyEg87UBSz78LaRsWAtTEPNCIXeAXBLeZrWNY7QSnHrSrW0eZl7ZlvDMi8UdWS8PpB+l+lGrYORRklXhmbr5nVLR26YzoKdDB+0vmtV0HKCFm80pcKhBYPouGs/qZtmwzAgWFA0lsZtRw1cDsMgiv3grxxsE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OXrazto3; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1762237023; x=1793773023;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=mSKoZmGkcXW407B8mNGjY9EejInAopsSE39gAyEUn9k=;
  b=OXrazto3bos6ZouLXm81qGUGmuUm3OZdCGxCNDmP4C2W+ykyqxLdNpHM
   1DxyyS4eKg+f2UC8Kt2DT1ZQ1E34vbMtAEaD2xfzDXma1x2Sr01Q4K+0I
   aF6SWWtCUu656YkV3TFUFRJN7V4ruPrFIYWNM78ZsGUX5oDCZo057lhKH
   oGGMjooTh6E1C3Pi0yfsGM4DHcneO6QWuKHfwNwXSgurXHKDEBhDMEfqa
   fFi5YiitRnTOAaF0VUY+gCJG52aM0x/NnUOEg/B33v6ZZnAMHrb19rw9x
   Om3sIeQ4LUHVoj0/B1xwvM9Kfz/8Sra1hjkH8hLcR/ILGEc8Cq+pj8vUV
   w==;
X-CSE-ConnectionGUID: BSbMDpbCR8uIRATopONiag==
X-CSE-MsgGUID: 8+m81WFlSHS/ZZsZ26Py2A==
X-IronPort-AV: E=McAfee;i="6800,10657,11602"; a="74927767"
X-IronPort-AV: E=Sophos;i="6.19,278,1754982000"; 
   d="scan'208";a="74927767"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Nov 2025 22:17:03 -0800
X-CSE-ConnectionGUID: IL8VAT68RkmI5IbPyY1fNw==
X-CSE-MsgGUID: u8bxLoPYS/KxoreV4M7Dmg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,278,1754982000"; 
   d="scan'208";a="210576877"
Received: from yinghaoj-desk.ccr.corp.intel.com (HELO [10.238.1.225]) ([10.238.1.225])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Nov 2025 22:16:56 -0800
Message-ID: <31da959f-d004-4ae0-a6a7-d5d31b646b70@linux.intel.com>
Date: Tue, 4 Nov 2025 14:16:53 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 27/28] KVM: TDX: Bug the VM if extending the initial
 measurement fails
To: Sean Christopherson <seanjc@google.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
 Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>,
 Huacai Chen <chenhuacai@kernel.org>,
 Madhavan Srinivasan <maddy@linux.ibm.com>, Anup Patel <anup@brainfault.org>,
 Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>,
 Albert Ou <aou@eecs.berkeley.edu>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Janosch Frank <frankja@linux.ibm.com>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>,
 Paolo Bonzini <pbonzini@redhat.com>, "Kirill A. Shutemov" <kas@kernel.org>,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
 kvm@vger.kernel.org, loongarch@lists.linux.dev, linux-mips@vger.kernel.org,
 linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org,
 linux-riscv@lists.infradead.org, x86@kernel.org, linux-coco@lists.linux.dev,
 linux-kernel@vger.kernel.org, Ira Weiny <ira.weiny@intel.com>,
 Kai Huang <kai.huang@intel.com>, Michael Roth <michael.roth@amd.com>,
 Yan Zhao <yan.y.zhao@intel.com>, Vishal Annapurve <vannapurve@google.com>,
 Rick Edgecombe <rick.p.edgecombe@intel.com>,
 Ackerley Tng <ackerleytng@google.com>
References: <20251030200951.3402865-1-seanjc@google.com>
 <20251030200951.3402865-28-seanjc@google.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20251030200951.3402865-28-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 10/31/2025 4:09 AM, Sean Christopherson wrote:
> WARN and terminate the VM if TDH_MR_EXTEND fails, as extending the
> measurement should fail if and only if there is a KVM bug, or if the S-EPT
> mapping is invalid.  Now that KVM makes all state transitions mutually
> exclusive via tdx_vm_state_guard, it should be impossible for S-EPT
> mappings to be removed between kvm_tdp_mmu_map_private_pfn() and
> tdh_mr_extend().
>
> Holding slots_lock prevents zaps due to memslot updates,
> filemap_invalidate_lock() prevents zaps due to guest_memfd PUNCH_HOLE,
> vcpu->mutex locks prevents updates from other vCPUs, kvm->lock prevents
> VM-scoped ioctls from creating havoc (e.g. by creating new vCPUs), and all
> usage of kvm_zap_gfn_range() is mutually exclusive with S-EPT entries that
> can be used for the initial image.
>
> For kvm_zap_gfn_range(), the call from sev.c is obviously mutually
> exclusive, TDX disallows KVM_X86_QUIRK_IGNORE_GUEST_PAT so the same goes
> for kvm_noncoherent_dma_assignment_start_or_stop(), and
> __kvm_set_or_clear_apicv_inhibit() is blocked by virtue of holding all
> VM and vCPU mutexes (and the APIC page has its own non-guest_memfd memslot

Nit:
It sounds like TDX is using the memslot for the APIC page, but for a TD, the
memslot for the APIC page is never initialized or used?

> and so can't be used for the initial image, which means that too is
> mutually exclusive irrespective of locking).
>
> Opportunistically return early if the region doesn't need to be measured
> in order to reduce line lengths and avoid wraps.  Similarly, immediately
> and explicitly return if TDH_MR_EXTEND fails to make it clear that KVM
> needs to bail entirely if extending the measurement fails.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>

> ---
>   arch/x86/kvm/vmx/tdx.c | 24 +++++++++++++-----------
>   1 file changed, 13 insertions(+), 11 deletions(-)
>
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index 8bcdec049ac6..762f2896547f 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -3123,21 +3123,23 @@ static int tdx_gmem_post_populate(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
>   
>   	put_page(src_page);
>   
> -	if (ret)
> +	if (ret || !(arg->flags & KVM_TDX_MEASURE_MEMORY_REGION))
>   		return ret;
>   
> -	if (arg->flags & KVM_TDX_MEASURE_MEMORY_REGION) {
> -		for (i = 0; i < PAGE_SIZE; i += TDX_EXTENDMR_CHUNKSIZE) {
> -			err = tdh_mr_extend(&kvm_tdx->td, gpa + i, &entry,
> -					    &level_state);
> -			if (err) {
> -				ret = -EIO;
> -				break;
> -			}
> -		}
> +	/*
> +	 * Note, MR.EXTEND can fail if the S-EPT mapping is somehow removed
> +	 * between mapping the pfn and now, but slots_lock prevents memslot
> +	 * updates, filemap_invalidate_lock() prevents guest_memfd updates,
> +	 * mmu_notifier events can't reach S-EPT entries, and KVM's internal
> +	 * zapping flows are mutually exclusive with S-EPT mappings.
> +	 */
> +	for (i = 0; i < PAGE_SIZE; i += TDX_EXTENDMR_CHUNKSIZE) {
> +		err = tdh_mr_extend(&kvm_tdx->td, gpa + i, &entry, &level_state);
> +		if (TDX_BUG_ON_2(err, TDH_MR_EXTEND, entry, level_state, kvm))
> +			return -EIO;
>   	}
>   
> -	return ret;
> +	return 0;
>   }
>   
>   static int tdx_vcpu_init_mem_region(struct kvm_vcpu *vcpu, struct kvm_tdx_cmd *cmd)


