Return-Path: <kvm+bounces-60795-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 92BABBF9CF0
	for <lists+kvm@lfdr.de>; Wed, 22 Oct 2025 05:16:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4F1943B16C5
	for <lists+kvm@lfdr.de>; Wed, 22 Oct 2025 03:16:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2829F23313E;
	Wed, 22 Oct 2025 03:15:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="i4nG5H7p"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 393F12F29;
	Wed, 22 Oct 2025 03:15:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761102958; cv=none; b=IxiK9GBFegIBgT3udD9RhmwofRqWf+r7Ro3P+gV9ZepT88UZ0VIfX7bfRcvMUtDfDAoaw8erXhHRMVmb3WxSEd1VZjLTwq94O1ujn/xe8CMbBt68ozRf52VyQeaSWtN5KQzHZxaFs0suKYD1qIAEyR9szlOYx4YiZXqEgd2jddI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761102958; c=relaxed/simple;
	bh=C4vq3UaKFDwToRnrsRh+czOcOkuL3mJDA1+8OYAo9rg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Gu4Fq4ThJouKmI059knzqUexvDUURd7s58dOQH7l8KoDyOR9z+bHr8PVwm4TR9Eh+kGnRg/tPEvN0XAQX/cYqU5JcNAfDRl5CWwJQvEzmkRDlT7bVzax/3lFHvcQo9AXG8WFtNUDFN+gSDbg3VFWQQnZ4jhhFB3LI9I7jufewZ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=i4nG5H7p; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761102956; x=1792638956;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=C4vq3UaKFDwToRnrsRh+czOcOkuL3mJDA1+8OYAo9rg=;
  b=i4nG5H7pT/VjYzRliiapnet3/p7dQh4EvBS6SoFyAvhOCNkK0uG1mYYg
   YdJOcK/dLkdKQ+RX/ywKDkLf/tmA7KoG+Pt9Ea4gqXavFKaHDPRiAITJ2
   SPXw/dbG0I0vPXiJiqpmLJBxJWWuq5AYWsyK5AaOq1HlUh3lIzYIHNRgc
   IpE+3XLUo43fFGuP7xCq78nnC9SH5HiFJbQdbTsuEfVx33bSt3SYekoB6
   oowsbd0JufKwMQWlmVro1CkQVQ56QQyjHz6wV/rTzxrY59IzonpxUztMk
   q643KEwK7OR1NsZSRdXZsNdIzlFHWpBPqbe5YgNLyWd0L22kFor700HgE
   A==;
X-CSE-ConnectionGUID: VgRBMjEkTEmUOh64IBq9rg==
X-CSE-MsgGUID: D65/HnjER2KQQS/QlZmkTg==
X-IronPort-AV: E=McAfee;i="6800,10657,11586"; a="88708844"
X-IronPort-AV: E=Sophos;i="6.19,246,1754982000"; 
   d="scan'208";a="88708844"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Oct 2025 20:15:56 -0700
X-CSE-ConnectionGUID: rS/w9ShoRTOr0LOxJ5xyUg==
X-CSE-MsgGUID: oNdfq1G9T4yNJ67V9X9aAw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,246,1754982000"; 
   d="scan'208";a="184159739"
Received: from yinghaoj-desk.ccr.corp.intel.com (HELO [10.238.1.225]) ([10.238.1.225])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Oct 2025 20:15:49 -0700
Message-ID: <eb6a2ca0-84eb-4770-8300-cd8892eae6ad@linux.intel.com>
Date: Wed, 22 Oct 2025 11:15:46 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 03/25] KVM: TDX: Drop PROVE_MMU=y sanity check on
 to-be-populated mappings
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
References: <20251017003244.186495-1-seanjc@google.com>
 <20251017003244.186495-4-seanjc@google.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20251017003244.186495-4-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 10/17/2025 8:32 AM, Sean Christopherson wrote:
> Drop TDX's sanity check that a mirror EPT mapping isn't zapped between
> creating said mapping and doing TDH.MEM.PAGE.ADD, as the check is
> simultaneously superfluous and incomplete.  Per commit 2608f1057601
> ("KVM: x86/tdp_mmu: Add a helper function to walk down the TDP MMU"), the
> justification for introducing kvm_tdp_mmu_gpa_is_mapped() was to check
> that the target gfn was pre-populated, with a link that points to this
> snippet:
>
>   : > One small question:
>   : >
>   : > What if the memory region passed to KVM_TDX_INIT_MEM_REGION hasn't been pre-
>   : > populated?  If we want to make KVM_TDX_INIT_MEM_REGION work with these regions,
>   : > then we still need to do the real map.  Or we can make KVM_TDX_INIT_MEM_REGION
>   : > return error when it finds the region hasn't been pre-populated?
>   :
>   : Return an error.  I don't love the idea of bleeding so many TDX details into
>   : userspace, but I'm pretty sure that ship sailed a long, long time ago.
>
> But that justification makes little sense for the final code, as the check
> on nr_premapped after TDH.MEM.PAGE.ADD will detect and return an error if
> KVM attempted to zap a S-EPT entry (tdx_sept_zap_private_spte() will fail
> on TDH.MEM.RANGE.BLOCK due lack of a valid S-EPT entry).  And as evidenced
> by the "is mapped?" code being guarded with CONFIG_KVM_PROVE_MMU=y, KVM is
> NOT relying on the check for general correctness.
>
> The sanity check is also incomplete in the sense that mmu_lock is dropped
> between the check and TDH.MEM.PAGE.ADD, i.e. will only detect KVM bugs that
> zap SPTEs in a very specific window (note, this also applies to the check
> on nr_premapped).
>
> Removing the sanity check will allow removing kvm_tdp_mmu_gpa_is_mapped(),
> which has no business being exposed to vendor code, and more importantly
> will pave the way for eliminating the "pre-map" approach entirely in favor
> of doing TDH.MEM.PAGE.ADD under mmu_lock.
>
> Reviewed-by: Ira Weiny <ira.weiny@intel.com>
> Reviewed-by: Kai Huang <kai.huang@intel.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>

> ---
>   arch/x86/kvm/vmx/tdx.c | 14 --------------
>   1 file changed, 14 deletions(-)
>
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index 326db9b9c567..4c3014befe9f 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -3181,20 +3181,6 @@ static int tdx_gmem_post_populate(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
>   	if (ret < 0)
>   		goto out;
>   
> -	/*
> -	 * The private mem cannot be zapped after kvm_tdp_map_page()
> -	 * because all paths are covered by slots_lock and the
> -	 * filemap invalidate lock.  Check that they are indeed enough.
> -	 */
> -	if (IS_ENABLED(CONFIG_KVM_PROVE_MMU)) {
> -		scoped_guard(read_lock, &kvm->mmu_lock) {
> -			if (KVM_BUG_ON(!kvm_tdp_mmu_gpa_is_mapped(vcpu, gpa), kvm)) {
> -				ret = -EIO;
> -				goto out;
> -			}
> -		}
> -	}
> -
>   	ret = 0;
>   	err = tdh_mem_page_add(&kvm_tdx->td, gpa, pfn_to_page(pfn),
>   			       src_page, &entry, &level_state);


