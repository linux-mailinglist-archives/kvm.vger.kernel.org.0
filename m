Return-Path: <kvm+bounces-24483-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 276379562FD
	for <lists+kvm@lfdr.de>; Mon, 19 Aug 2024 07:04:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4C1301C212C5
	for <lists+kvm@lfdr.de>; Mon, 19 Aug 2024 05:04:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3CB67149C57;
	Mon, 19 Aug 2024 05:04:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lTU2W4dB"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 353602556E;
	Mon, 19 Aug 2024 05:04:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724043862; cv=none; b=VCbHJoickP/mMvBuTP+2KNwpQVzNkyCS981LEnYIYaUI8XmBCCjoahtEfRPomx/Psz7PkXXo+TebvuZDS7L3JEsWLV8tDH1IJLKFcTIbSg5HswnGk6hsCUfCr7WGKPBUxRp9qEkaBy+i9TXZ4Y7Pgw6kcChjs9S71vnfBvpmQZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724043862; c=relaxed/simple;
	bh=DB9WcJmbBlrGDUK/yLs+kZJ47/oOQAEYWS9fKe1ktAg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=q8VdMUH26mhax+3RYlW2DUxkDGWprxXyRkOhKKGxfpHJgFMAhf3rz+L3YZG1c1y5Ksh3BxcJ8BfjpiFTJ9LXmZ2Sr3EUyEIvaLPGbCeh++v7NtFYmxNQVZ03HFwUrcXl+nVEHvjj5KAM6roi7f7X5FhrO/N8v3cX+kwZlPXTp0o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lTU2W4dB; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1724043860; x=1755579860;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=DB9WcJmbBlrGDUK/yLs+kZJ47/oOQAEYWS9fKe1ktAg=;
  b=lTU2W4dBJWjXIdtK/omQUts6k99h/XDHHK65rusKjr8eA8BUE+hVAcjS
   d3shGtTDlX2u9PdZH9u1+k0mmYZNmSRa1HjoHl7Ug6LmW6GWSjTjpT5My
   GeHE2hf0tmowdSTZDA9WOd8LIgBlGI8eQZign+DdvS9zYJTR980Nr8YZs
   6aGt/lD6EY9KmVdU0RwDbGlPxbGzOWd62Vd6wZFtzjFSc7ZfAoyDBmKPq
   yjjoGhvPAqKOuN4GBFlqQiu4WPPaFls7KEUoIdbI1If10Ro2on6Fjv0FI
   eOncqhwMc1vGDCFF+Xi7Lv6EODqQIIXSpsoBTuxVo3XauILa6TQdPmE2d
   g==;
X-CSE-ConnectionGUID: m+tjxytIQz+4FEuz2krePg==
X-CSE-MsgGUID: UBm0QfAPQJSVX8G2ekWCfA==
X-IronPort-AV: E=McAfee;i="6700,10204,11168"; a="21889708"
X-IronPort-AV: E=Sophos;i="6.10,158,1719903600"; 
   d="scan'208";a="21889708"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2024 22:04:20 -0700
X-CSE-ConnectionGUID: kyftsm2yQziOwMY9s8PX6g==
X-CSE-MsgGUID: UdKmdW3PRImYy96mGm6DfQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,158,1719903600"; 
   d="scan'208";a="61021709"
Received: from yilunxu-optiplex-7050.sh.intel.com (HELO localhost) ([10.239.159.165])
  by orviesa008.jf.intel.com with ESMTP; 18 Aug 2024 22:04:17 -0700
Date: Mon, 19 Aug 2024 13:02:02 +0800
From: Xu Yilun <yilun.xu@linux.intel.com>
To: Rick Edgecombe <rick.p.edgecombe@intel.com>
Cc: seanjc@google.com, pbonzini@redhat.com, kvm@vger.kernel.org,
	kai.huang@intel.com, isaku.yamahata@gmail.com,
	tony.lindgren@linux.intel.com, xiaoyao.li@intel.com,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 21/25] KVM: x86: Introduce KVM_TDX_GET_CPUID
Message-ID: <ZsLRyk5F9SRgafIO@yilunxu-OptiPlex-7050>
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

Some fields contains a N-bits wide value instead of a bitmask, why a &=
just work?

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

Personally I don't like the definition of this function. I need to look
into the inner implementation to see if kfree(supported_cpuid); is needed
or safe. How about:

  supported_cpuid = tdx_get_kvm_supported_cpuid();
  if (!supported_cpuid)
	goto out_td_cpuid;

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

Is it possible this workaround escapes the KVM supported bits check?

> +		}
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

Traditionally we do:

  out_supported_cpuid:
	kfree(supported_cpuid);
  out_td_cpuid:
	kfree(td_cpuid);

I'm not sure what's the advantage to make people think more about whether
kfree is safe.

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

This doesn't belong to this patch.

> +
> +	struct kvm_cpuid2 *cpuid;

Didn't find the usage of this field.

Thanks,
Yilun

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

