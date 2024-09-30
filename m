Return-Path: <kvm+bounces-27665-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 633D9989A80
	for <lists+kvm@lfdr.de>; Mon, 30 Sep 2024 08:27:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 869E31C2125E
	for <lists+kvm@lfdr.de>; Mon, 30 Sep 2024 06:27:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C06014D6F9;
	Mon, 30 Sep 2024 06:27:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TGkWrueg"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3A4923BE;
	Mon, 30 Sep 2024 06:27:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727677629; cv=none; b=Ln2qOYEr97IuAXQpZ8n+7Ye3bTQij1UQuQW60z+JAdfnpVS9FLZcm+sI952BtOhaEkAaICGgZkw6Duk35CJRUwjMHVXyW5iRt+VK6E8ZhdN3ujxas0ExKgNiVVPnqqAtcBl5bIIMY/l6yt+3hDxmP1qzQcZQaYmmwuZqDrnPVM4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727677629; c=relaxed/simple;
	bh=yQOweRVaYNfNYWgexaG2VGR9sTCWRGsLJdnZAFq8ToA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nBSGuvVuH1Tx+EevaFWrd9mR2oojYY5mQq/XhmTd7V+X/ID/5hYLpjgpgcbOfBRqWxdHEWTqazmvcV2TfjfeP8vjPWgb1NRd0uKDJLBcJDgoSKYS8BMb5DonCxdA+grgv3ca6yxEFoa+9hRWJwTzKS2k7qfDUAgmQt9bxWa4Kbw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=TGkWrueg; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1727677627; x=1759213627;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=yQOweRVaYNfNYWgexaG2VGR9sTCWRGsLJdnZAFq8ToA=;
  b=TGkWruegjOn2cPvHM54rugneS9bI4c9A0D6z5BtcumRIwg+lZSNOunJR
   HIPTYM37zqr2Wb3KR4D1XwepOuoqHR9eLws/x2Oyc/9d/xr9ntKhLu0vH
   qfghftCiWOyQxzzPvXMxzCcIDVU0UnLQBHQXOKKamOKbQJ+HAhVhA1lCe
   7XdvSjYWUw97pKf7Q+y3di9fyjgA/hePBnntAXZUf0QLkH0CuBTquaZO6
   tqNrNsCG+zUA0QsU/y26KozTx1oH2snsUDHSE/Y+TDKxKeKDmA94PRuVo
   3hJqS1aAhFl3dlRGne6H2d3vJT8wKplJjUgG1zM90BBYKly728P7bAhPY
   g==;
X-CSE-ConnectionGUID: 0YK+WyY3RjeVi0EAH+D5+w==
X-CSE-MsgGUID: jRARiV0rQM+RIH7vCec5wA==
X-IronPort-AV: E=McAfee;i="6700,10204,11210"; a="26922120"
X-IronPort-AV: E=Sophos;i="6.11,165,1725346800"; 
   d="scan'208";a="26922120"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Sep 2024 23:27:04 -0700
X-CSE-ConnectionGUID: rFDso0gnRoCDL7zyP0o9BA==
X-CSE-MsgGUID: cTVqMaKATbS+cgKsIiquVg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,164,1725346800"; 
   d="scan'208";a="73240050"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.125.247.52]) ([10.125.247.52])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Sep 2024 23:26:59 -0700
Message-ID: <08478bf1-e927-4034-b598-c0cb1ac8249a@intel.com>
Date: Mon, 30 Sep 2024 14:26:55 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 21/25] KVM: x86: Introduce KVM_TDX_GET_CPUID
To: Rick Edgecombe <rick.p.edgecombe@intel.com>, seanjc@google.com,
 pbonzini@redhat.com, kvm@vger.kernel.org
Cc: kai.huang@intel.com, isaku.yamahata@gmail.com,
 tony.lindgren@linux.intel.com, linux-kernel@vger.kernel.org
References: <20240812224820.34826-1-rick.p.edgecombe@intel.com>
 <20240812224820.34826-22-rick.p.edgecombe@intel.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20240812224820.34826-22-rick.p.edgecombe@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/13/2024 6:48 AM, Rick Edgecombe wrote:
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

This patch lacks the documentation of KVM_TDX_GET_CPUID to describe what 
it returns and how the returned data is used or expected to be used by 
userspace.

Set aside the filtering of KVM's support CPUID bits, KVM_TDX_GET_CPUID 
only returns the CPUID leaves that can be readable by TDX module (in 
tdx_mask_cpuid()). So what about the leaves that aren't readable? e.g., 
CPUID leaf 6,9,0xc,etc, and leaf 0x40000000 and 0x40000001.

Should userspace to intercept it as the leaves that aren't covered by 
KVM_TDX_GET_CPUID are totally controlled by userspace itself and it's 
userspace's responsibility to set a sane and valid value?

> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
> ---
> uAPI breakout v1:
>   - New patch
> ---
>   arch/x86/include/uapi/asm/kvm.h |   1 +
>   arch/x86/kvm/vmx/tdx.c          | 131 ++++++++++++++++++++++++++++++++
>   arch/x86/kvm/vmx/tdx.h          |   5 ++
>   arch/x86/kvm/vmx/tdx_arch.h     |   5 ++
>   arch/x86/kvm/vmx/tdx_errno.h    |   1 +
>   5 files changed, 143 insertions(+)
> 
> diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
> index b4f12997052d..39636be5c891 100644
> --- a/arch/x86/include/uapi/asm/kvm.h
> +++ b/arch/x86/include/uapi/asm/kvm.h
> @@ -931,6 +931,7 @@ enum kvm_tdx_cmd_id {
>   	KVM_TDX_CAPABILITIES = 0,
>   	KVM_TDX_INIT_VM,
>   	KVM_TDX_INIT_VCPU,
> +	KVM_TDX_GET_CPUID,
>   
>   	KVM_TDX_CMD_NR_MAX,
>   };
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index b2ed031ac0d6..fe2bbc2ced41 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -813,6 +813,76 @@ static int __tdx_td_init(struct kvm *kvm, struct td_params *td_params,
>   	return ret;
>   }
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
>   static int tdx_td_init(struct kvm *kvm, struct kvm_tdx_cmd *cmd)
>   {
>   	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
> @@ -1038,6 +1108,64 @@ static int __maybe_unused tdx_get_kvm_supported_cpuid(struct kvm_cpuid2 **cpuid)
>   	return r;
>   }
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
>   static int tdx_vcpu_init(struct kvm_vcpu *vcpu, struct kvm_tdx_cmd *cmd)
>   {
>   	struct msr_data apic_base_msr;
> @@ -1089,6 +1217,9 @@ int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp)
>   	case KVM_TDX_INIT_VCPU:
>   		ret = tdx_vcpu_init(vcpu, &cmd);
>   		break;
> +	case KVM_TDX_GET_CPUID:
> +		ret = tdx_vcpu_get_cpuid(vcpu, &cmd);
> +		break;
>   	default:
>   		ret = -EINVAL;
>   		break;
> diff --git a/arch/x86/kvm/vmx/tdx.h b/arch/x86/kvm/vmx/tdx.h
> index 8349b542836e..7eeb54fbcae1 100644
> --- a/arch/x86/kvm/vmx/tdx.h
> +++ b/arch/x86/kvm/vmx/tdx.h
> @@ -25,6 +25,11 @@ struct kvm_tdx {
>   	bool finalized;
>   
>   	u64 tsc_offset;
> +
> +	/* For KVM_MAP_MEMORY and KVM_TDX_INIT_MEM_REGION. */
> +	atomic64_t nr_premapped;
> +
> +	struct kvm_cpuid2 *cpuid;
>   };
>   
>   struct vcpu_tdx {
> diff --git a/arch/x86/kvm/vmx/tdx_arch.h b/arch/x86/kvm/vmx/tdx_arch.h
> index d2d7f9cab740..815e74408a34 100644
> --- a/arch/x86/kvm/vmx/tdx_arch.h
> +++ b/arch/x86/kvm/vmx/tdx_arch.h
> @@ -157,4 +157,9 @@ struct td_params {
>   
>   #define MD_FIELD_ID_FEATURES0_TOPOLOGY_ENUM	BIT_ULL(20)
>   
> +/*
> + * TD scope metadata field ID.
> + */
> +#define TD_MD_FIELD_ID_CPUID_VALUES		0x9410000300000000ULL
> +
>   #endif /* __KVM_X86_TDX_ARCH_H */
> diff --git a/arch/x86/kvm/vmx/tdx_errno.h b/arch/x86/kvm/vmx/tdx_errno.h
> index dc3fa2a58c2c..f9dbb3a065cc 100644
> --- a/arch/x86/kvm/vmx/tdx_errno.h
> +++ b/arch/x86/kvm/vmx/tdx_errno.h
> @@ -23,6 +23,7 @@
>   #define TDX_FLUSHVP_NOT_DONE			0x8000082400000000ULL
>   #define TDX_EPT_WALK_FAILED			0xC0000B0000000000ULL
>   #define TDX_EPT_ENTRY_STATE_INCORRECT		0xC0000B0D00000000ULL
> +#define TDX_METADATA_FIELD_NOT_READABLE		0xC0000C0200000000ULL
>   
>   /*
>    * TDX module operand ID, appears in 31:0 part of error code as


