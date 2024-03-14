Return-Path: <kvm+bounces-11784-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1659587B895
	for <lists+kvm@lfdr.de>; Thu, 14 Mar 2024 08:31:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C72F6283C92
	for <lists+kvm@lfdr.de>; Thu, 14 Mar 2024 07:31:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9D8E25CDD9;
	Thu, 14 Mar 2024 07:30:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SYBkjq9Z"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D71804A12;
	Thu, 14 Mar 2024 07:30:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710401452; cv=none; b=t+aLstddmAz7XNXXssrGympubqlFUgYLfLDIVaNmF6PVlIxUoCsV99huMWEMi1wWGB9hDMCBpJkuSU9MF/futeDMpcYRektfL9teL7JlgWPn7hFODVdmrMxGRlMIrTHUN6nHiLyvdUvWP8JEZst4vfoN+RQr2eF79xTZ9hJJjwI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710401452; c=relaxed/simple;
	bh=F6TeUAp84mNXVZccqSO8QiqkdZep+IZt47gbd0nMjmc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JUNif6Wbhkg0kM67NJas4jqz2lAyhKrfTndyzyyE3eVmDehpYR8fX0vBv4Iv4RrMSFOOyg5qqOulWALixMNtMY13NGpOiX85o0NDlSjOGQMe3ulxmiVBPrX7uBYA3XPFKxJMcJBbMaMtax4U3UHBsYungXzAL+fDFIfaeH8obb8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=SYBkjq9Z; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1710401451; x=1741937451;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=F6TeUAp84mNXVZccqSO8QiqkdZep+IZt47gbd0nMjmc=;
  b=SYBkjq9Zgz4xmQWIgru9cONJ5fOP7h4B2fj9GBROtun2aSoV99xF678T
   76lfUG+d59lqcHI6ESj8hmRNjsTLQl+PWnooDHC5216qdXRh2JaLOxdZj
   Z0KjOyIeZJyug09WnxSETrApAM+j2eXetkx4SCLojQQHpvZCOUVZUUjqa
   snYEzAV2NNqg92o3fkPVL0d5Whds0pyE7aNftjSCS6IB9/ADh/OnU79Sa
   SQ9AhaySrgbsHbrYjXsf47HuR3whL8gzb9avJsJRkHLjo3XwL706SkCMs
   QJx1Vrf7oEUMfQ6nFHwaOFmboTCt8xKkXxVWXeuK6i7Iu8vN8SgMQNpMU
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,11012"; a="5330033"
X-IronPort-AV: E=Sophos;i="6.07,124,1708416000"; 
   d="scan'208";a="5330033"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Mar 2024 00:30:51 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,124,1708416000"; 
   d="scan'208";a="12215035"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.124.242.47]) ([10.124.242.47])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Mar 2024 00:30:47 -0700
Message-ID: <f8d50f45-eb7e-46bf-b3a8-35f02efd4e4c@linux.intel.com>
Date: Thu, 14 Mar 2024 15:30:43 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v19 027/130] KVM: TDX: Define TDX architectural
 definitions
To: isaku.yamahata@intel.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
 erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
 Sagi Shahar <sagis@google.com>, Kai Huang <kai.huang@intel.com>,
 chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com,
 Sean Christopherson <sean.j.christopherson@intel.com>,
 Xiaoyao Li <xiaoyao.li@intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <522cbfe6e5a351f88480790fe3c3be36c82ca4b1.1708933498.git.isaku.yamahata@intel.com>
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <522cbfe6e5a351f88480790fe3c3be36c82ca4b1.1708933498.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 2/26/2024 4:25 PM, isaku.yamahata@intel.com wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
>
> Define architectural definitions for KVM to issue the TDX SEAMCALLs.
>
> Structures and values that are architecturally defined in the TDX module
> specifications the chapter of ABI Reference.
>
> Co-developed-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
> Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
> ---
> v19:
> - drop tdvmcall constants by Xiaoyao
>
> v18:
> - Add metadata field id
>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>   arch/x86/kvm/vmx/tdx_arch.h | 265 ++++++++++++++++++++++++++++++++++++
>   1 file changed, 265 insertions(+)
>   create mode 100644 arch/x86/kvm/vmx/tdx_arch.h
>
> diff --git a/arch/x86/kvm/vmx/tdx_arch.h b/arch/x86/kvm/vmx/tdx_arch.h
> new file mode 100644
> index 000000000000..e2c1a6f429d7
> --- /dev/null
> +++ b/arch/x86/kvm/vmx/tdx_arch.h
> @@ -0,0 +1,265 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/* architectural constants/data definitions for TDX SEAMCALLs */
> +
> +#ifndef __KVM_X86_TDX_ARCH_H
> +#define __KVM_X86_TDX_ARCH_H
> +
> +#include <linux/types.h>
> +
> +/*
> + * TDX SEAMCALL API function leaves
> + */
> +#define TDH_VP_ENTER			0
> +#define TDH_MNG_ADDCX			1
> +#define TDH_MEM_PAGE_ADD		2
> +#define TDH_MEM_SEPT_ADD		3
> +#define TDH_VP_ADDCX			4
> +#define TDH_MEM_PAGE_RELOCATE		5
> +#define TDH_MEM_PAGE_AUG		6
> +#define TDH_MEM_RANGE_BLOCK		7
> +#define TDH_MNG_KEY_CONFIG		8
> +#define TDH_MNG_CREATE			9
> +#define TDH_VP_CREATE			10
> +#define TDH_MNG_RD			11
> +#define TDH_MR_EXTEND			16
> +#define TDH_MR_FINALIZE			17
> +#define TDH_VP_FLUSH			18
> +#define TDH_MNG_VPFLUSHDONE		19
> +#define TDH_MNG_KEY_FREEID		20
> +#define TDH_MNG_INIT			21
> +#define TDH_VP_INIT			22
> +#define TDH_MEM_SEPT_RD			25
> +#define TDH_VP_RD			26
> +#define TDH_MNG_KEY_RECLAIMID		27
> +#define TDH_PHYMEM_PAGE_RECLAIM		28
> +#define TDH_MEM_PAGE_REMOVE		29
> +#define TDH_MEM_SEPT_REMOVE		30
> +#define TDH_SYS_RD			34
> +#define TDH_MEM_TRACK			38
> +#define TDH_MEM_RANGE_UNBLOCK		39
> +#define TDH_PHYMEM_CACHE_WB		40
> +#define TDH_PHYMEM_PAGE_WBINVD		41
> +#define TDH_VP_WR			43
> +#define TDH_SYS_LP_SHUTDOWN		44
> +
> +/* TDX control structure (TDR/TDCS/TDVPS) field access codes */
> +#define TDX_NON_ARCH			BIT_ULL(63)
> +#define TDX_CLASS_SHIFT			56
> +#define TDX_FIELD_MASK			GENMASK_ULL(31, 0)
> +
> +#define __BUILD_TDX_FIELD(non_arch, class, field)	\
> +	(((non_arch) ? TDX_NON_ARCH : 0) |		\
> +	 ((u64)(class) << TDX_CLASS_SHIFT) |		\
> +	 ((u64)(field) & TDX_FIELD_MASK))
> +
> +#define BUILD_TDX_FIELD(class, field)			\
> +	__BUILD_TDX_FIELD(false, (class), (field))
> +
> +#define BUILD_TDX_FIELD_NON_ARCH(class, field)		\
> +	__BUILD_TDX_FIELD(true, (class), (field))
> +
> +
> +/* Class code for TD */
> +#define TD_CLASS_EXECUTION_CONTROLS	17ULL
> +
> +/* Class code for TDVPS */
> +#define TDVPS_CLASS_VMCS		0ULL
> +#define TDVPS_CLASS_GUEST_GPR		16ULL
> +#define TDVPS_CLASS_OTHER_GUEST		17ULL
> +#define TDVPS_CLASS_MANAGEMENT		32ULL
> +
> +enum tdx_tdcs_execution_control {
> +	TD_TDCS_EXEC_TSC_OFFSET = 10,
> +};
> +
> +/* @field is any of enum tdx_tdcs_execution_control */
> +#define TDCS_EXEC(field)		BUILD_TDX_FIELD(TD_CLASS_EXECUTION_CONTROLS, (field))
> +
> +/* @field is the VMCS field encoding */
> +#define TDVPS_VMCS(field)		BUILD_TDX_FIELD(TDVPS_CLASS_VMCS, (field))
> +
> +enum tdx_vcpu_guest_other_state {
> +	TD_VCPU_STATE_DETAILS_NON_ARCH = 0x100,
> +};
> +
> +union tdx_vcpu_state_details {
> +	struct {
> +		u64 vmxip	: 1;
> +		u64 reserved	: 63;
> +	};
> +	u64 full;
> +};
> +
> +/* @field is any of enum tdx_guest_other_state */
> +#define TDVPS_STATE(field)		BUILD_TDX_FIELD(TDVPS_CLASS_OTHER_GUEST, (field))
> +#define TDVPS_STATE_NON_ARCH(field)	BUILD_TDX_FIELD_NON_ARCH(TDVPS_CLASS_OTHER_GUEST, (field))
> +
> +/* Management class fields */
> +enum tdx_vcpu_guest_management {
> +	TD_VCPU_PEND_NMI = 11,
> +};
> +
> +/* @field is any of enum tdx_vcpu_guest_management */
> +#define TDVPS_MANAGEMENT(field)		BUILD_TDX_FIELD(TDVPS_CLASS_MANAGEMENT, (field))
> +
> +#define TDX_EXTENDMR_CHUNKSIZE		256
> +
> +struct tdx_cpuid_value {
> +	u32 eax;
> +	u32 ebx;
> +	u32 ecx;
> +	u32 edx;
> +} __packed;
> +
> +#define TDX_TD_ATTRIBUTE_DEBUG		BIT_ULL(0)
> +#define TDX_TD_ATTR_SEPT_VE_DISABLE	BIT_ULL(28)
It's better to align the style of the naming.

Either use TDX_TD_ATTR_* or TDX_TD_ATTRIBUTE_*?

> +#define TDX_TD_ATTRIBUTE_PKS		BIT_ULL(30)
> +#define TDX_TD_ATTRIBUTE_KL		BIT_ULL(31)
> +#define TDX_TD_ATTRIBUTE_PERFMON	BIT_ULL(63)
> +
> +/*
> + * TD_PARAMS is provided as an input to TDH_MNG_INIT, the size of which is 1024B.
> + */
> +#define TDX_MAX_VCPUS	(~(u16)0)
> +
> +struct td_params {
> +	u64 attributes;
> +	u64 xfam;
> +	u16 max_vcpus;
> +	u8 reserved0[6];
> +
> +	u64 eptp_controls;
> +	u64 exec_controls;
> +	u16 tsc_frequency;
> +	u8  reserved1[38];
> +
> +	u64 mrconfigid[6];
> +	u64 mrowner[6];
> +	u64 mrownerconfig[6];
> +	u64 reserved2[4];
> +
> +	union {
> +		DECLARE_FLEX_ARRAY(struct tdx_cpuid_value, cpuid_values);
> +		u8 reserved3[768];
> +	};
> +} __packed __aligned(1024);
> +
> +/*
> + * Guest uses MAX_PA for GPAW when set.
> + * 0: GPA.SHARED bit is GPA[47]
> + * 1: GPA.SHARED bit is GPA[51]
> + */
> +#define TDX_EXEC_CONTROL_MAX_GPAW      BIT_ULL(0)
> +
> +/*
> + * TDH.VP.ENTER, TDG.VP.VMCALL preserves RBP
> + * 0: RBP can be used for TDG.VP.VMCALL input. RBP is clobbered.
> + * 1: RBP can't be used for TDG.VP.VMCALL input. RBP is preserved.
> + */
> +#define TDX_CONTROL_FLAG_NO_RBP_MOD	BIT_ULL(2)
> +
> +
> +/*
> + * TDX requires the frequency to be defined in units of 25MHz, which is the
> + * frequency of the core crystal clock on TDX-capable platforms, i.e. the TDX
> + * module can only program frequencies that are multiples of 25MHz.  The
> + * frequency must be between 100mhz and 10ghz (inclusive).
> + */
> +#define TDX_TSC_KHZ_TO_25MHZ(tsc_in_khz)	((tsc_in_khz) / (25 * 1000))
> +#define TDX_TSC_25MHZ_TO_KHZ(tsc_in_25mhz)	((tsc_in_25mhz) * (25 * 1000))
> +#define TDX_MIN_TSC_FREQUENCY_KHZ		(100 * 1000)
> +#define TDX_MAX_TSC_FREQUENCY_KHZ		(10 * 1000 * 1000)
> +
> +union tdx_sept_entry {
> +	struct {
> +		u64 r		:  1;
> +		u64 w		:  1;
> +		u64 x		:  1;
> +		u64 mt		:  3;
> +		u64 ipat	:  1;
> +		u64 leaf	:  1;
> +		u64 a		:  1;
> +		u64 d		:  1;
> +		u64 xu		:  1;
> +		u64 ignored0	:  1;
> +		u64 pfn		: 40;
> +		u64 reserved	:  5;
> +		u64 vgp		:  1;
> +		u64 pwa		:  1;
> +		u64 ignored1	:  1;
> +		u64 sss		:  1;
> +		u64 spp		:  1;
> +		u64 ignored2	:  1;
> +		u64 sve		:  1;
> +	};
> +	u64 raw;
> +};
> +
> +enum tdx_sept_entry_state {
> +	TDX_SEPT_FREE = 0,
> +	TDX_SEPT_BLOCKED = 1,
> +	TDX_SEPT_PENDING = 2,
> +	TDX_SEPT_PENDING_BLOCKED = 3,
> +	TDX_SEPT_PRESENT = 4,
> +};
> +
> +union tdx_sept_level_state {
> +	struct {
> +		u64 level	:  3;
> +		u64 reserved0	:  5;
> +		u64 state	:  8;
> +		u64 reserved1	: 48;
> +	};
> +	u64 raw;
> +};
> +
> +/*
> + * Global scope metadata field ID.
> + * See Table "Global Scope Metadata", TDX module 1.5 ABI spec.
> + */
> +#define MD_FIELD_ID_SYS_ATTRIBUTES		0x0A00000200000000ULL
> +#define MD_FIELD_ID_FEATURES0			0x0A00000300000008ULL
> +#define MD_FIELD_ID_ATTRS_FIXED0		0x1900000300000000ULL
> +#define MD_FIELD_ID_ATTRS_FIXED1		0x1900000300000001ULL
> +#define MD_FIELD_ID_XFAM_FIXED0			0x1900000300000002ULL
> +#define MD_FIELD_ID_XFAM_FIXED1			0x1900000300000003ULL
> +
> +#define MD_FIELD_ID_TDCS_BASE_SIZE		0x9800000100000100ULL
> +#define MD_FIELD_ID_TDVPS_BASE_SIZE		0x9800000100000200ULL
> +
> +#define MD_FIELD_ID_NUM_CPUID_CONFIG		0x9900000100000004ULL
> +#define MD_FIELD_ID_CPUID_CONFIG_LEAVES		0x9900000300000400ULL
> +#define MD_FIELD_ID_CPUID_CONFIG_VALUES		0x9900000300000500ULL
> +
> +#define MD_FIELD_ID_FEATURES0_NO_RBP_MOD	BIT_ULL(18)
> +
> +#define TDX_MAX_NR_CPUID_CONFIGS       37
> +
> +#define TDX_MD_ELEMENT_SIZE_8BITS      0
> +#define TDX_MD_ELEMENT_SIZE_16BITS     1
> +#define TDX_MD_ELEMENT_SIZE_32BITS     2
> +#define TDX_MD_ELEMENT_SIZE_64BITS     3
> +
> +union tdx_md_field_id {
> +	struct {
> +		u64 field                       : 24;
> +		u64 reserved0                   : 8;
> +		u64 element_size_code           : 2;
> +		u64 last_element_in_field       : 4;
> +		u64 reserved1                   : 3;
> +		u64 inc_size                    : 1;
> +		u64 write_mask_valid            : 1;
> +		u64 context                     : 3;
> +		u64 reserved2                   : 1;
> +		u64 class                       : 6;
> +		u64 reserved3                   : 1;
> +		u64 non_arch                    : 1;
> +	};
> +	u64 raw;
> +};
> +
> +#define TDX_MD_ELEMENT_SIZE_CODE(_field_id)			\
> +	({ union tdx_md_field_id _fid = { .raw = (_field_id)};  \
> +		_fid.element_size_code; })
> +
> +#endif /* __KVM_X86_TDX_ARCH_H */


