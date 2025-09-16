Return-Path: <kvm+bounces-57701-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 9EFBEB59179
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 11:01:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 899D97AC444
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 08:59:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9EFE128D8F4;
	Tue, 16 Sep 2025 09:01:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="K3Zo5m4D"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0A60222566;
	Tue, 16 Sep 2025 09:00:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758013261; cv=none; b=Y9RzpPiUsXniLGHLu3p9al0RGw4YKgMcoiseeNPNAyKwlKDzaEo7J1Hgo0P6Ud4W1BAVldRGX6GpFthPOkV+4mS0EjdgCOjg+w71u9iFAFJJu9Z2utBtQquFpQiyMpGq6G6iKDCVRNAVHRLJNb5JGFwY3aw3G5ywRDvCvWjOQpU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758013261; c=relaxed/simple;
	bh=VaPGPN4sNkzZCieQe1ppVzBXnQbc0jSLL06ZRxkEbSQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pn3OY2rnHAXI1G2GoHd0uHmu5S1sDRAMBNfp26eMEI4pmswd1uPhIpkWbaIkPSS0bXSREj0UOETduNzYFcUd5p/kBooTRlKxQzTgbUF1XuXowbt2zNfPCcjh161MUanXB6XLeL+trVwof9igkfVFm1GQLmIGfbkz6ncCGuLeIFM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=K3Zo5m4D; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758013260; x=1789549260;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=VaPGPN4sNkzZCieQe1ppVzBXnQbc0jSLL06ZRxkEbSQ=;
  b=K3Zo5m4D0+myzZykUIpEjHRP/s37A1j6f2lHP8/eiswzAIil/VMYLjmg
   seytsXXTZDareP5+U1c3jsraay71oEDu4LZ8jAI+lSUYs9lG/80Qm5tdq
   1+hO9nolxLKc9IySjDBRVrKd1aJbwH+OJ/Cfi4WEXZerY1qkn5YM6BOfA
   3X+BhrI0uzYqBiCY+q8lrwDEAKEHNKKwgpNCOemoRB2ldFscU7Ri1d8GH
   la8cnT1A9MIJOXSXNZGNJm9MzjTmKsQzb7lRsAr4ULPZxtGVkp/lBHyNU
   YBOp7YvPeQ+zILJRS0j2fug1nI5/BaZQizMCGvHrYL/y+GN2OSgiS43Mg
   g==;
X-CSE-ConnectionGUID: wJsT6TJyRrCqKSY+R0Kjcg==
X-CSE-MsgGUID: lUORnVfxQiWOgAHZQ3IQ2Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11554"; a="63918574"
X-IronPort-AV: E=Sophos;i="6.18,268,1751266800"; 
   d="scan'208";a="63918574"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Sep 2025 02:00:59 -0700
X-CSE-ConnectionGUID: doz86orBSxGGmFrsT2JHDQ==
X-CSE-MsgGUID: WDZmb+ePTSuLs8kbY+lU/A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,268,1751266800"; 
   d="scan'208";a="175302937"
Received: from unknown (HELO [10.238.0.107]) ([10.238.0.107])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Sep 2025 02:00:56 -0700
Message-ID: <48a597f9-a1eb-400b-81ae-244b6b1f76a3@linux.intel.com>
Date: Tue, 16 Sep 2025 17:00:54 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v15 12/41] KVM: VMX: Introduce CET VMCS fields and control
 bits
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, Tom Lendacky <thomas.lendacky@amd.com>,
 Mathias Krause <minipli@grsecurity.net>, John Allen <john.allen@amd.com>,
 Rick Edgecombe <rick.p.edgecombe@intel.com>, Chao Gao <chao.gao@intel.com>,
 Maxim Levitsky <mlevitsk@redhat.com>, Xiaoyao Li <xiaoyao.li@intel.com>,
 Zhang Yi Z <yi.z.zhang@linux.intel.com>
References: <20250912232319.429659-1-seanjc@google.com>
 <20250912232319.429659-13-seanjc@google.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20250912232319.429659-13-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 9/13/2025 7:22 AM, Sean Christopherson wrote:
> From: Yang Weijiang <weijiang.yang@intel.com>
>
> Control-flow Enforcement Technology (CET) is a kind of CPU feature used
> to prevent Return/CALL/Jump-Oriented Programming (ROP/COP/JOP) attacks.
> It provides two sub-features(SHSTK,IBT) to defend against ROP/COP/JOP
> style control-flow subversion attacks.
>
> Shadow Stack (SHSTK):
>    A shadow stack is a second stack used exclusively for control transfer
>    operations. The shadow stack is separate from the data/normal stack and
>    can be enabled individually in user and kernel mode. When shadow stack
>    is enabled, CALL pushes the return address on both the data and shadow
>    stack. RET pops the return address from both stacks and compares them.
>    If the return addresses from the two stacks do not match, the processor
>    generates a #CP.
>
> Indirect Branch Tracking (IBT):
>    IBT introduces instruction(ENDBRANCH)to mark valid target addresses of
>    indirect branches (CALL, JMP etc...). If an indirect branch is executed
>    and the next instruction is _not_ an ENDBRANCH, the processor generates
>    a #CP. These instruction behaves as a NOP on platforms that have no CET.

These -> The

>
> Several new CET MSRs are defined to support CET:
>    MSR_IA32_{U,S}_CET: CET settings for {user,supervisor} CET respectively.
>
>    MSR_IA32_PL{0,1,2,3}_SSP: SHSTK pointer linear address for CPL{0,1,2,3}.
>
>    MSR_IA32_INT_SSP_TAB: Linear address of SHSTK pointer table, whose entry
> 			is indexed by IST of interrupt gate desc.
>
> Two XSAVES state bits are introduced for CET:
>    IA32_XSS:[bit 11]: Control saving/restoring user mode CET states
>    IA32_XSS:[bit 12]: Control saving/restoring supervisor mode CET states.
>
> Six VMCS fields are introduced for CET:
>    {HOST,GUEST}_S_CET: Stores CET settings for kernel mode.
>    {HOST,GUEST}_SSP: Stores current active SSP.
>    {HOST,GUEST}_INTR_SSP_TABLE: Stores current active MSR_IA32_INT_SSP_TAB.
>
> On Intel platforms, two additional bits are defined in VM_EXIT and VM_ENTRY
> control fields:
> If VM_EXIT_LOAD_CET_STATE = 1, host CET states are loaded from following
> VMCS fields at VM-Exit:
>    HOST_S_CET
>    HOST_SSP
>    HOST_INTR_SSP_TABLE
>
> If VM_ENTRY_LOAD_CET_STATE = 1, guest CET states are loaded from following
> VMCS fields at VM-Entry:
>    GUEST_S_CET
>    GUEST_SSP
>    GUEST_INTR_SSP_TABLE
>
> Co-developed-by: Zhang Yi Z <yi.z.zhang@linux.intel.com>
> Signed-off-by: Zhang Yi Z <yi.z.zhang@linux.intel.com>
> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> Reviewed-by: Chao Gao <chao.gao@intel.com>
> Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
> Tested-by: Mathias Krause <minipli@grsecurity.net>
> Tested-by: John Allen <john.allen@amd.com>
> Tested-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
> Signed-off-by: Chao Gao <chao.gao@intel.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>

> ---
>   arch/x86/include/asm/vmx.h | 8 ++++++++
>   1 file changed, 8 insertions(+)
>
> diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
> index cca7d6641287..ce10a7e2d3d9 100644
> --- a/arch/x86/include/asm/vmx.h
> +++ b/arch/x86/include/asm/vmx.h
> @@ -106,6 +106,7 @@
>   #define VM_EXIT_CLEAR_BNDCFGS                   0x00800000
>   #define VM_EXIT_PT_CONCEAL_PIP			0x01000000
>   #define VM_EXIT_CLEAR_IA32_RTIT_CTL		0x02000000
> +#define VM_EXIT_LOAD_CET_STATE                  0x10000000
>   
>   #define VM_EXIT_ALWAYSON_WITHOUT_TRUE_MSR	0x00036dff
>   
> @@ -119,6 +120,7 @@
>   #define VM_ENTRY_LOAD_BNDCFGS                   0x00010000
>   #define VM_ENTRY_PT_CONCEAL_PIP			0x00020000
>   #define VM_ENTRY_LOAD_IA32_RTIT_CTL		0x00040000
> +#define VM_ENTRY_LOAD_CET_STATE                 0x00100000
>   
>   #define VM_ENTRY_ALWAYSON_WITHOUT_TRUE_MSR	0x000011ff
>   
> @@ -369,6 +371,9 @@ enum vmcs_field {
>   	GUEST_PENDING_DBG_EXCEPTIONS    = 0x00006822,
>   	GUEST_SYSENTER_ESP              = 0x00006824,
>   	GUEST_SYSENTER_EIP              = 0x00006826,
> +	GUEST_S_CET                     = 0x00006828,
> +	GUEST_SSP                       = 0x0000682a,
> +	GUEST_INTR_SSP_TABLE            = 0x0000682c,
>   	HOST_CR0                        = 0x00006c00,
>   	HOST_CR3                        = 0x00006c02,
>   	HOST_CR4                        = 0x00006c04,
> @@ -381,6 +386,9 @@ enum vmcs_field {
>   	HOST_IA32_SYSENTER_EIP          = 0x00006c12,
>   	HOST_RSP                        = 0x00006c14,
>   	HOST_RIP                        = 0x00006c16,
> +	HOST_S_CET                      = 0x00006c18,
> +	HOST_SSP                        = 0x00006c1a,
> +	HOST_INTR_SSP_TABLE             = 0x00006c1c
>   };
>   
>   /*


