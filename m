Return-Path: <kvm+bounces-24482-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 91DA795614E
	for <lists+kvm@lfdr.de>; Mon, 19 Aug 2024 05:05:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E1ED2281340
	for <lists+kvm@lfdr.de>; Mon, 19 Aug 2024 03:05:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1ED0E13BAC3;
	Mon, 19 Aug 2024 03:05:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VP9GuazG"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0E0C1CA8D;
	Mon, 19 Aug 2024 03:05:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724036708; cv=none; b=K8+wUpbA5P+QoOtED6Xqb2xbJG8MQG/mK4gM+C7LHVcG0fRn73N0YP+CO1BilE8IMeLgXzqTY/zpcviVP3Ynn1MV3ZPW2PDcRgRDnrfqHPcRJ982F8eiJDm2kr407oeRZ+MgoQx9nJlq8D718ybhTJqMWusQlwMvS1cqvS/PiCs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724036708; c=relaxed/simple;
	bh=IrbpoFtZg9yDzWOu06DEHE2Ffob1DwNty5eagtHqG5k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rvoTw5hoWaXLdpOXSfMrJDNN7Pk9r5SjdmUU8n3PkhL48dMBsGEFvdgeZ67V6zhRMkH0FMa08tTt/02DrheDwYMFlWwifHLq8oeVf42jAoC+UWQyaThg0Mf6xGI5c7vuXKr38l648AcxnM9SIHiEn0438GAonPA6JoEjlPuK1NQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=VP9GuazG; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1724036706; x=1755572706;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=IrbpoFtZg9yDzWOu06DEHE2Ffob1DwNty5eagtHqG5k=;
  b=VP9GuazGpSaqGA11gbcdG/x6ijxUAAZRt9f817tykVfl44QXQmD2g2/Y
   rYOgq7V6/Id2MH1dysk+m8gMOl0elhevWZEnWjSAq4RYjbyBkGtVFb6/F
   0zPrW+mAtiXkLN24jXHzfhkNQidFJhCmaaf6WWAXt4fRhqTvfzJDjan0z
   eUayZ9UFPELPiJFiUkaMVJ12Wh6MtiU8J8uAc4W1QcYEYROQzs+0Fy9O5
   rkKgK+DgHb5XKFbkjga+2iOBv09JGF8lZmqup54Lwa1EY6Oc79PzGbZ2A
   ddkl3LLKE5XUclcvyMtEIUlFHrOGb4ojxImjVR0iBDKk5JEzKSa8wJNb7
   g==;
X-CSE-ConnectionGUID: UDgKOseSRbOkx9g33gob8A==
X-CSE-MsgGUID: xj0c+FFXTSKYYom1pZDU7g==
X-IronPort-AV: E=McAfee;i="6700,10204,11168"; a="22416073"
X-IronPort-AV: E=Sophos;i="6.10,158,1719903600"; 
   d="scan'208";a="22416073"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2024 20:05:05 -0700
X-CSE-ConnectionGUID: mQfS+lWhQ/aD4chIBURFbQ==
X-CSE-MsgGUID: GQ17RcayQFucBNz3zJ9sog==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,158,1719903600"; 
   d="scan'208";a="60516213"
Received: from linux.bj.intel.com ([10.238.157.71])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2024 20:05:02 -0700
Date: Mon, 19 Aug 2024 10:59:49 +0800
From: Tao Su <tao1.su@linux.intel.com>
To: Rick Edgecombe <rick.p.edgecombe@intel.com>
Cc: seanjc@google.com, pbonzini@redhat.com, kvm@vger.kernel.org,
	kai.huang@intel.com, isaku.yamahata@gmail.com,
	tony.lindgren@linux.intel.com, xiaoyao.li@intel.com,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 21/25] KVM: x86: Introduce KVM_TDX_GET_CPUID
Message-ID: <ZsK1JRf1amTEAW6q@linux.bj.intel.com>
References: <20240812224820.34826-1-rick.p.edgecombe@intel.com>
 <20240812224820.34826-22-rick.p.edgecombe@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240812224820.34826-22-rick.p.edgecombe@intel.com>

On Mon, Aug 12, 2024 at 03:48:16PM -0700, Rick Edgecombe wrote:
> From: Xiaoyao Li <xiaoyao.li@intel.com>
> 
> Implement an IOCTL to allow userspace to read the CPUID bit values for a
> configured TD.
> 
> The TDX module doesn't provide the ability to set all CPUID bits. Instead
> some are configured indirectly, or have fixed values. But it does allow
> for the final resulting CPUID bits to be read. This information will be
> useful for userspace to understand the configuration of the TD, and set
> KVM's copy via KVM_SET_CPUID2.
> 
> To prevent userspace from starting to use features that might not have KVM
> support yet, filter the reported values by KVM's support CPUID bits.
> 
> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
> ---
> uAPI breakout v1:
>  - New patch
> ---
>  arch/x86/include/uapi/asm/kvm.h |   1 +
>  arch/x86/kvm/vmx/tdx.c          | 131 ++++++++++++++++++++++++++++++++
>  arch/x86/kvm/vmx/tdx.h          |   5 ++
>  arch/x86/kvm/vmx/tdx_arch.h     |   5 ++
>  arch/x86/kvm/vmx/tdx_errno.h    |   1 +
>  5 files changed, 143 insertions(+)
> 
> diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
> index b4f12997052d..39636be5c891 100644
> --- a/arch/x86/include/uapi/asm/kvm.h
> +++ b/arch/x86/include/uapi/asm/kvm.h
> @@ -931,6 +931,7 @@ enum kvm_tdx_cmd_id {
>  	KVM_TDX_CAPABILITIES = 0,
>  	KVM_TDX_INIT_VM,
>  	KVM_TDX_INIT_VCPU,
> +	KVM_TDX_GET_CPUID,
>  
>  	KVM_TDX_CMD_NR_MAX,
>  };
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index b2ed031ac0d6..fe2bbc2ced41 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -813,6 +813,76 @@ static int __tdx_td_init(struct kvm *kvm, struct td_params *td_params,
>  	return ret;
>  }
>  
> +static u64 tdx_td_metadata_field_read(struct kvm_tdx *tdx, u64 field_id,
> +				      u64 *data)
> +{
> +	u64 err;
> +
> +	err = tdh_mng_rd(tdx, field_id, data);
> +
> +	return err;
> +}
> +
> +#define TDX_MD_UNREADABLE_LEAF_MASK	GENMASK(30, 7)
> +#define TDX_MD_UNREADABLE_SUBLEAF_MASK	GENMASK(31, 7)
> +
> +static int tdx_mask_cpuid(struct kvm_tdx *tdx, struct kvm_cpuid_entry2 *entry)
> +{
> +	u64 field_id = TD_MD_FIELD_ID_CPUID_VALUES;
> +	u64 ebx_eax, edx_ecx;
> +	u64 err = 0;
> +
> +	if (entry->function & TDX_MD_UNREADABLE_LEAF_MASK ||
> +	    entry->index & TDX_MD_UNREADABLE_SUBLEAF_MASK)
> +		return -EINVAL;
> +
> +	/*
> +	 * bit 23:17, REVSERVED: reserved, must be 0;
> +	 * bit 16,    LEAF_31: leaf number bit 31;
> +	 * bit 15:9,  LEAF_6_0: leaf number bits 6:0, leaf bits 30:7 are
> +	 *                      implicitly 0;
> +	 * bit 8,     SUBLEAF_NA: sub-leaf not applicable flag;
> +	 * bit 7:1,   SUBLEAF_6_0: sub-leaf number bits 6:0. If SUBLEAF_NA is 1,
> +	 *                         the SUBLEAF_6_0 is all-1.
> +	 *                         sub-leaf bits 31:7 are implicitly 0;
> +	 * bit 0,     ELEMENT_I: Element index within field;
> +	 */
> +	field_id |= ((entry->function & 0x80000000) ? 1 : 0) << 16;
> +	field_id |= (entry->function & 0x7f) << 9;
> +	if (entry->flags & KVM_CPUID_FLAG_SIGNIFCANT_INDEX)
> +		field_id |= (entry->index & 0x7f) << 1;
> +	else
> +		field_id |= 0x1fe;
> +
> +	err = tdx_td_metadata_field_read(tdx, field_id, &ebx_eax);
> +	if (err) //TODO check for specific errors
> +		goto err_out;
> +
> +	entry->eax &= (u32) ebx_eax;
> +	entry->ebx &= (u32) (ebx_eax >> 32);
> +
> +	field_id++;
> +	err = tdx_td_metadata_field_read(tdx, field_id, &edx_ecx);
> +	/*
> +	 * It's weird that reading edx_ecx fails while reading ebx_eax
> +	 * succeeded.
> +	 */
> +	if (WARN_ON_ONCE(err))
> +		goto err_out;
> +
> +	entry->ecx &= (u32) edx_ecx;
> +	entry->edx &= (u32) (edx_ecx >> 32);
> +	return 0;
> +
> +err_out:
> +	entry->eax = 0;
> +	entry->ebx = 0;
> +	entry->ecx = 0;
> +	entry->edx = 0;
> +
> +	return -EIO;
> +}
> +
>  static int tdx_td_init(struct kvm *kvm, struct kvm_tdx_cmd *cmd)
>  {
>  	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
> @@ -1038,6 +1108,64 @@ static int __maybe_unused tdx_get_kvm_supported_cpuid(struct kvm_cpuid2 **cpuid)
>  	return r;
>  }
>  
> +static int tdx_vcpu_get_cpuid(struct kvm_vcpu *vcpu, struct kvm_tdx_cmd *cmd)
> +{
> +	struct kvm_cpuid2 __user *output, *td_cpuid;
> +	struct kvm_tdx *kvm_tdx = to_kvm_tdx(vcpu->kvm);
> +	struct kvm_cpuid2 *supported_cpuid;
> +	int r = 0, i, j = 0;
> +
> +	output = u64_to_user_ptr(cmd->data);
> +	td_cpuid = kzalloc(sizeof(*td_cpuid) +
> +			sizeof(output->entries[0]) * KVM_MAX_CPUID_ENTRIES,
> +			GFP_KERNEL);
> +	if (!td_cpuid)
> +		return -ENOMEM;
> +
> +	r = tdx_get_kvm_supported_cpuid(&supported_cpuid);
> +	if (r)
> +		goto out;
> +
> +	for (i = 0; i < supported_cpuid->nent; i++) {
> +		struct kvm_cpuid_entry2 *supported = &supported_cpuid->entries[i];
> +		struct kvm_cpuid_entry2 *output_e = &td_cpuid->entries[j];
> +
> +		*output_e = *supported;
> +
> +		/* Only allow values of bits that KVM's supports to be exposed */
> +		if (tdx_mask_cpuid(kvm_tdx, output_e))
> +			continue;
> +
> +		/*
> +		 * Work around missing support on old TDX modules, fetch
> +		 * guest maxpa from gfn_direct_bits.
> +		 */
> +		if (output_e->function == 0x80000008) {
> +			gpa_t gpa_bits = gfn_to_gpa(kvm_gfn_direct_bits(vcpu->kvm));
> +			unsigned int g_maxpa = __ffs(gpa_bits) + 1;
> +
> +			output_e->eax &= ~0x00ff0000;
> +			output_e->eax |= g_maxpa << 16;
> +		}

I suggest putting all guest_phys_bits related WA in a WA-only patch, which will
be clearer.

> +
> +		j++;
> +	}
> +	td_cpuid->nent = j;
> +
> +	if (copy_to_user(output, td_cpuid, sizeof(*output))) {
> +		r = -EFAULT;
> +		goto out;
> +	}
> +	if (copy_to_user(output->entries, td_cpuid->entries,
> +			 td_cpuid->nent * sizeof(struct kvm_cpuid_entry2)))
> +		r = -EFAULT;
> +
> +out:
> +	kfree(td_cpuid);
> +	kfree(supported_cpuid);
> +	return r;
> +}
> +
>  static int tdx_vcpu_init(struct kvm_vcpu *vcpu, struct kvm_tdx_cmd *cmd)
>  {
>  	struct msr_data apic_base_msr;
> @@ -1089,6 +1217,9 @@ int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp)
>  	case KVM_TDX_INIT_VCPU:
>  		ret = tdx_vcpu_init(vcpu, &cmd);
>  		break;
> +	case KVM_TDX_GET_CPUID:
> +		ret = tdx_vcpu_get_cpuid(vcpu, &cmd);
> +		break;
>  	default:
>  		ret = -EINVAL;
>  		break;
> diff --git a/arch/x86/kvm/vmx/tdx.h b/arch/x86/kvm/vmx/tdx.h
> index 8349b542836e..7eeb54fbcae1 100644
> --- a/arch/x86/kvm/vmx/tdx.h
> +++ b/arch/x86/kvm/vmx/tdx.h
> @@ -25,6 +25,11 @@ struct kvm_tdx {
>  	bool finalized;
>  
>  	u64 tsc_offset;
> +
> +	/* For KVM_MAP_MEMORY and KVM_TDX_INIT_MEM_REGION. */
> +	atomic64_t nr_premapped;

I don't see it is used in this patch set.

> +
> +	struct kvm_cpuid2 *cpuid;
>  };
>  
>  struct vcpu_tdx {
> diff --git a/arch/x86/kvm/vmx/tdx_arch.h b/arch/x86/kvm/vmx/tdx_arch.h
> index d2d7f9cab740..815e74408a34 100644
> --- a/arch/x86/kvm/vmx/tdx_arch.h
> +++ b/arch/x86/kvm/vmx/tdx_arch.h
> @@ -157,4 +157,9 @@ struct td_params {
>  
>  #define MD_FIELD_ID_FEATURES0_TOPOLOGY_ENUM	BIT_ULL(20)
>  
> +/*
> + * TD scope metadata field ID.
> + */
> +#define TD_MD_FIELD_ID_CPUID_VALUES		0x9410000300000000ULL
> +
>  #endif /* __KVM_X86_TDX_ARCH_H */
> diff --git a/arch/x86/kvm/vmx/tdx_errno.h b/arch/x86/kvm/vmx/tdx_errno.h
> index dc3fa2a58c2c..f9dbb3a065cc 100644
> --- a/arch/x86/kvm/vmx/tdx_errno.h
> +++ b/arch/x86/kvm/vmx/tdx_errno.h
> @@ -23,6 +23,7 @@
>  #define TDX_FLUSHVP_NOT_DONE			0x8000082400000000ULL
>  #define TDX_EPT_WALK_FAILED			0xC0000B0000000000ULL
>  #define TDX_EPT_ENTRY_STATE_INCORRECT		0xC0000B0D00000000ULL
> +#define TDX_METADATA_FIELD_NOT_READABLE		0xC0000C0200000000ULL
>  
>  /*
>   * TDX module operand ID, appears in 31:0 part of error code as
> -- 
> 2.34.1
> 
> 

