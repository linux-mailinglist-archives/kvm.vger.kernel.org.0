Return-Path: <kvm+bounces-61660-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id E4145C23F0D
	for <lists+kvm@lfdr.de>; Fri, 31 Oct 2025 09:55:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id C1A134E67BF
	for <lists+kvm@lfdr.de>; Fri, 31 Oct 2025 08:55:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1F974327213;
	Fri, 31 Oct 2025 08:54:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="G5YBnmMS"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 661AA303C87;
	Fri, 31 Oct 2025 08:54:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761900892; cv=none; b=ngSlLLwvazoMjqU6kDL3CBGrwIEnuSt9OTbxQFEt56aBoNrfORcN0NZeQ3cDsHjHSzkYEdFVMZ6muJj6eQPk8KxIFHAxTwwiwUwlnV7tsHqFevcFbYXOKj7xeWkD0RuWuW3M7vcomxCR12mfaymChSFbSQST84zeM8fkaC1NVOU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761900892; c=relaxed/simple;
	bh=iU1XFUVtQH6LI61M4J5u+MgZ1klxrWMInWe7hZiTFt8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Oyi9vksvsCS3Ev2q8kIcdv5ViafGexK27NVEWC9KGS8kTTveDu/ixT+T2othR0lK8P0S+Xt9e3i0nkIYT1I6j8vY5uZH4vm9mUEustGK3HfbNin0PUTfk1LTG7p/9YQPsBwF80XKH7CyORc331w5PJUf80QZfGKT0HPxx4UU9/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=G5YBnmMS; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761900890; x=1793436890;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=iU1XFUVtQH6LI61M4J5u+MgZ1klxrWMInWe7hZiTFt8=;
  b=G5YBnmMSgCrQryj6BJcFYAHdqYHvybdwBHTJH5H85HHS6j1q6vPQcQjU
   bKZtD375TKFns3fXotNfY4LoW8/nwTQpzDwbY3T3p7xAOQoOHiDfuHAQ1
   WJnFUPVb/2ICEEg6YI4cOrk/tw9fGSROKn4IVFqvDkcJsMoJr/XCuxOw0
   Npwx/5QEVqGxRvJlNA7vOkey6RJPt7s3hzTgCiXw2t9yjcf5JLelaO0b7
   zMdLrXB8FlbY4/XhUp9SUnHaePookox27RUZlDRVmGIiuVMWT87bXMcIK
   Z3c6EW8AbSAGmSKzuPiYQ3gCwyEhjZfd8sYqyC7z35DFy4pVObPl/JEtk
   A==;
X-CSE-ConnectionGUID: 7+CHVsQPRoi/RRmNK8/ubA==
X-CSE-MsgGUID: A2+pGsOHTKKUZNetVHO6DQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11598"; a="89521982"
X-IronPort-AV: E=Sophos;i="6.19,268,1754982000"; 
   d="scan'208";a="89521982"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Oct 2025 01:54:49 -0700
X-CSE-ConnectionGUID: 4Xvcl/miQfWM+8RZoCX16A==
X-CSE-MsgGUID: H6esMYuyQ0eLrmr7cZvmKA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,268,1754982000"; 
   d="scan'208";a="186117901"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.124.240.28]) ([10.124.240.28])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Oct 2025 01:54:42 -0700
Message-ID: <91e3ca2f-2336-416a-bd37-3f6fa84d0613@linux.intel.com>
Date: Fri, 31 Oct 2025 16:54:39 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 16/28] KVM: TDX: ADD pages to the TD image while
 populating mirror EPT entries
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
 <20251030200951.3402865-17-seanjc@google.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20251030200951.3402865-17-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 10/31/2025 4:09 AM, Sean Christopherson wrote:
> When populating the initial memory image for a TDX guest, ADD pages to the
> TD as part of establishing the mappings in the mirror EPT, as opposed to
> creating the mappings and then doing ADD after the fact.  Doing ADD in the
> S-EPT callbacks eliminates the need to track "premapped" pages, as the
> mirror EPT (M-EPT) and S-EPT are always synchronized, e.g. if ADD fails,
> KVM reverts to the previous M-EPT entry (guaranteed to be !PRESENT).
>
> Eliminating the hole where the M-EPT can have a mapping that doesn't exist
> in the S-EPT in turn obviates the need to handle errors that are unique to
> encountering a missing S-EPT entry (see tdx_is_sept_zap_err_due_to_premap()).
>
> Keeping the M-EPT and S-EPT synchronized also eliminates the need to check
> for unconsumed "premap" entries during tdx_td_finalize(), as there simply
> can't be any such entries.  Dropping that check in particular reduces the
> overall cognitive load, as the management of nr_premapped with respect
> to removal of S-EPT is _very_ subtle.  E.g. successful removal of an S-EPT
> entry after it completed ADD doesn't adjust nr_premapped, but it's not
> clear why that's "ok" but having half-baked entries is not (it's not truly
> "ok" in that removing pages from the image will likely prevent the guest
> from booting, but from KVM's perspective it's "ok").
>
> Doing ADD in the S-EPT path requires passing an argument via a scratch
> field, but the current approach of tracking the number of "premapped"
> pages effectively does the same.  And the "premapped" counter is much more
> dangerous, as it doesn't have a singular lock to protect its usage, since
> nr_premapped can be modified as soon as mmu_lock is dropped, at least in
> theory.  I.e. nr_premapped is guarded by slots_lock, but only for "happy"
> paths.
>
> Note, this approach was used/tried at various points in TDX development,
> but was ultimately discarded due to a desire to avoid stashing temporary
> state in kvm_tdx.  But as above, KVM ended up with such state anyways,
> and fully committing to using temporary state provides better access
> rules (100% guarded by slots_lock), and makes several edge cases flat out
> impossible.
>
> Note #2, continue to extend the measurement outside of mmu_lock, as it's
> a slow operation (typically 16 SEAMCALLs per page whose data is included
> in the measurement), and doesn't *need* to be done under mmu_lock, e.g.
> for consistency purposes.  However, MR.EXTEND isn't _that_ slow, e.g.
> ~1ms latency to measure a full page, so if it needs to be done under
> mmu_lock in the future, e.g. because KVM gains a flow that can remove
> S-EPT entries during KVM_TDX_INIT_MEM_REGION, then extending the
> measurement can also be moved into the S-EPT mapping path (again, only if
> absolutely necessary).  P.S. _If_ MR.EXTEND is moved into the S-EPT path,
> take care not to return an error up the stack if TDH_MR_EXTEND fails, as
> removing the M-EPT entry but not the S-EPT entry would result in
> inconsistent state!
>
> Reviewed-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
> Reviewed-by: Kai Huang <kai.huang@intel.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>

One nit below.

> ---
>   arch/x86/kvm/vmx/tdx.c | 106 ++++++++++++++---------------------------
>   arch/x86/kvm/vmx/tdx.h |   8 +++-
>   2 files changed, 43 insertions(+), 71 deletions(-)
>
[...]
> diff --git a/arch/x86/kvm/vmx/tdx.h b/arch/x86/kvm/vmx/tdx.h
> index ca39a9391db1..1b00adbbaf77 100644
> --- a/arch/x86/kvm/vmx/tdx.h
> +++ b/arch/x86/kvm/vmx/tdx.h
> @@ -36,8 +36,12 @@ struct kvm_tdx {
>   
>   	struct tdx_td td;
>   
> -	/* For KVM_TDX_INIT_MEM_REGION. */
> -	atomic64_t nr_premapped;
> +	/*
> +	 * Scratch pointer used to pass the source page to tdx_mem_page_add.
tdx_mem_page_add -> tdx_mem_page_add()

> +	 * Protected by slots_lock, and non-NULL only when mapping a private
> +	 * pfn via tdx_gmem_post_populate().
> +	 */
> +	struct page *page_add_src;
>   
>   	/*
>   	 * Prevent vCPUs from TD entry to ensure SEPT zap related SEAMCALLs do


