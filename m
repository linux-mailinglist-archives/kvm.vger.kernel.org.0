Return-Path: <kvm+bounces-57516-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E4686B570BA
	for <lists+kvm@lfdr.de>; Mon, 15 Sep 2025 08:55:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BB5C9175877
	for <lists+kvm@lfdr.de>; Mon, 15 Sep 2025 06:55:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 051A52C11CC;
	Mon, 15 Sep 2025 06:55:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MiICF/4M"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 432372C0F87;
	Mon, 15 Sep 2025 06:55:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757919313; cv=none; b=Ba8g09uJYTVdgGml8VfwHTzDKuy7KrbD81wWqIIhD/2DYiNqVmhl72Z6Dj9pwa9OnO/AQF2ww22QORW8YH+uKqMAsbAV/zUxGN9zTm90L9Av5D915tpKFdwfL+FbFeFlh7xLtoJXxJ+5Zc+CPfB+ZJpO4sdCK+FUiUs8weEtp3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757919313; c=relaxed/simple;
	bh=2YNL5IpCufEMGskr5s2m6EC5EkstrxD+s0uitZmeDrU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=K1VNgku7/7gLFlRD5ARrOIPT3TW9/cJ4ipZdlltXLH5NIsIIyj072oVgMjcvgvlF1FACB99pKaXC6avDVDFlp41bEcA9LGMnKn2fTQZC6Je6FNK3I7NXCbVpmnsI7+thW57Sf25L889JuNdkdolcFoQCrogfhD15DjGCGnjXhO8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MiICF/4M; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1757919311; x=1789455311;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=2YNL5IpCufEMGskr5s2m6EC5EkstrxD+s0uitZmeDrU=;
  b=MiICF/4MzeAqzpWkMA11zttX+2C8MOwP1V4PDi16QFSuPXX/BgVRhos6
   tkOxBfDW0EiJl6LqBj0yde4bQIQzw0NT2XdccMTN7/ZGHNXA74iFTgAXM
   OFzAq4vuHOBlRunAnlimC6nzbG/70I1xsDT4tXV3FBx7FRVTKRtztOBby
   +DjnHZvn9gDt22smris52z9oFqYe7nx8CZEHjrRmOSFsU2bYRmMa4RAh9
   WiWDyzs37Xt83WSc2meTKwULAWZ1G8Wlxd3xRwwG7pCmmNHglFbvuORTt
   o9qn1Ad1LHsGEWrBveodrxw1baj7jLa/cK6mgUDAldXgyM8l4SA1QjDbY
   Q==;
X-CSE-ConnectionGUID: /HwVz/ehTNOMWomrLjiNow==
X-CSE-MsgGUID: 0yngC4tkSFe4Wif6MjAEww==
X-IronPort-AV: E=McAfee;i="6800,10657,11553"; a="59206467"
X-IronPort-AV: E=Sophos;i="6.18,265,1751266800"; 
   d="scan'208";a="59206467"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2025 23:55:10 -0700
X-CSE-ConnectionGUID: S6GW/Z7uTM6U9fc398YWHA==
X-CSE-MsgGUID: 346iOnv5SwSE+SyGVzwS1g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,265,1751266800"; 
   d="scan'208";a="174610230"
Received: from junlongf-mobl.ccr.corp.intel.com (HELO [10.238.1.52]) ([10.238.1.52])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2025 23:55:08 -0700
Message-ID: <aca9d389-f11e-4811-90cf-d98e345a5cc2@intel.com>
Date: Mon, 15 Sep 2025 14:55:05 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v15 13/41] KVM: x86: Enable guest SSP read/write interface
 with new uAPIs
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Tom Lendacky <thomas.lendacky@amd.com>,
 Mathias Krause <minipli@grsecurity.net>, John Allen <john.allen@amd.com>,
 Rick Edgecombe <rick.p.edgecombe@intel.com>, Chao Gao <chao.gao@intel.com>,
 Maxim Levitsky <mlevitsk@redhat.com>, Zhang Yi Z <yi.z.zhang@linux.intel.com>
References: <20250912232319.429659-1-seanjc@google.com>
 <20250912232319.429659-14-seanjc@google.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20250912232319.429659-14-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/13/2025 7:22 AM, Sean Christopherson wrote:
> From: Yang Weijiang <weijiang.yang@intel.com>
> 
> Enable guest shadow stack pointer(SSP) access interface with new uAPIs.
> CET guest SSP is HW register which has corresponding VMCS field to save
> and restore guest values when VM-{Exit,Entry} happens. KVM handles SSP
> as a fake/synthetic MSR for userspace access.
> 
> Use a translation helper to set up mapping for SSP synthetic index and
> KVM-internal MSR index so that userspace doesn't need to take care of
> KVM's management for synthetic MSRs and avoid conflicts.
> 
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> Tested-by: Mathias Krause <minipli@grsecurity.net>
> Tested-by: John Allen <john.allen@amd.com>
> Tested-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
> Signed-off-by: Chao Gao <chao.gao@intel.com>
> Co-developed-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   Documentation/virt/kvm/api.rst  |  8 ++++++++
>   arch/x86/include/uapi/asm/kvm.h |  3 +++
>   arch/x86/kvm/x86.c              | 23 +++++++++++++++++++++--
>   arch/x86/kvm/x86.h              | 10 ++++++++++
>   4 files changed, 42 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index abd02675a24d..6ae24c5ca559 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -2911,6 +2911,14 @@ such as set vcpu counter or reset vcpu, and they have the following id bit patte
>   x86 MSR registers have the following id bit patterns::
>     0x2030 0002 <msr number:32>
>   
> +Following are the KVM-defined registers for x86:
> +
> +======================= ========= =============================================
> +    Encoding            Register  Description
> +======================= ========= =============================================
> +  0x2030 0003 0000 0000 SSP       Shadow Stack Pointer
> +======================= ========= =============================================
> +
>   4.69 KVM_GET_ONE_REG
>   --------------------
>   
> diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
> index 508b713ca52e..8cc79eca34b2 100644
> --- a/arch/x86/include/uapi/asm/kvm.h
> +++ b/arch/x86/include/uapi/asm/kvm.h
> @@ -437,6 +437,9 @@ struct kvm_xcrs {
>   #define KVM_X86_REG_KVM(index)					\
>   	KVM_X86_REG_ENCODE(KVM_X86_REG_TYPE_KVM, index)
>   
> +/* KVM-defined registers starting from 0 */
> +#define KVM_REG_GUEST_SSP	0
> +
>   #define KVM_SYNC_X86_REGS      (1UL << 0)
>   #define KVM_SYNC_X86_SREGS     (1UL << 1)
>   #define KVM_SYNC_X86_EVENTS    (1UL << 2)
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 2c9908bc8b32..460ceae11495 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -6017,7 +6017,15 @@ struct kvm_x86_reg_id {
>   
>   static int kvm_translate_kvm_reg(struct kvm_x86_reg_id *reg)
>   {
> -	return -EINVAL;
> +	switch (reg->index) {
> +	case KVM_REG_GUEST_SSP:
> +		reg->type = KVM_X86_REG_TYPE_MSR;
> +		reg->index = MSR_KVM_INTERNAL_GUEST_SSP;
> +		break;
> +	default:
> +		return -EINVAL;
> +	}
> +	return 0;
>   }
>   
>   static int kvm_get_one_msr(struct kvm_vcpu *vcpu, u32 msr, u64 __user *user_val)
> @@ -6097,11 +6105,22 @@ static int kvm_get_set_one_reg(struct kvm_vcpu *vcpu, unsigned int ioctl,
>   static int kvm_get_reg_list(struct kvm_vcpu *vcpu,
>   			    struct kvm_reg_list __user *user_list)
>   {
> -	u64 nr_regs = 0;
> +	u64 nr_regs = guest_cpu_cap_has(vcpu, X86_FEATURE_SHSTK) ? 1 : 0;

I wonder what's the semantic of KVM returning KVM_REG_GUEST_SSP on 
KVM_GET_REG_LIST. Does it ensure KVM_{G,S}ET_ONE_REG returns -EINVAL on 
KVM_REG_GUEST_SSP when it's not enumerated by KVM_GET_REG_LIST?

If so, but KVM_{G,S}ET_ONE_REG can succeed on GUEST_SSP even if
!guest_cpu_cap_has() when @ignore_msrs is true.

> +	u64 user_nr_regs;
> +
> +	if (get_user(user_nr_regs, &user_list->n))
> +		return -EFAULT;
>   
>   	if (put_user(nr_regs, &user_list->n))
>   		return -EFAULT;
>   
> +	if (user_nr_regs < nr_regs)
> +		return -E2BIG;
> +
> +	if (nr_regs &&
> +	    put_user(KVM_X86_REG_KVM(KVM_REG_GUEST_SSP), &user_list->reg[0]))
> +		return -EFAULT;
> +
>   	return 0;
>   }
>   
> diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
> index 786e36fcd0fb..a7c9c72fca93 100644
> --- a/arch/x86/kvm/x86.h
> +++ b/arch/x86/kvm/x86.h
> @@ -101,6 +101,16 @@ do {											\
>   #define KVM_SVM_DEFAULT_PLE_WINDOW_MAX	USHRT_MAX
>   #define KVM_SVM_DEFAULT_PLE_WINDOW	3000
>   
> +/*
> + * KVM's internal, non-ABI indices for synthetic MSRs. The values themselves
> + * are arbitrary and have no meaning, the only requirement is that they don't
> + * conflict with "real" MSRs that KVM supports. Use values at the upper end
> + * of KVM's reserved paravirtual MSR range to minimize churn, i.e. these values
> + * will be usable until KVM exhausts its supply of paravirtual MSR indices.
> + */
> +
> +#define MSR_KVM_INTERNAL_GUEST_SSP	0x4b564dff
> +
>   static inline unsigned int __grow_ple_window(unsigned int val,
>   		unsigned int base, unsigned int modifier, unsigned int max)
>   {


