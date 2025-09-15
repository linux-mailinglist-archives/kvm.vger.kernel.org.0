Return-Path: <kvm+bounces-57515-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 240F9B57052
	for <lists+kvm@lfdr.de>; Mon, 15 Sep 2025 08:31:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7D1F53BE53A
	for <lists+kvm@lfdr.de>; Mon, 15 Sep 2025 06:31:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA0AC2853F3;
	Mon, 15 Sep 2025 06:31:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cyt3nriC"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 847B438DDB;
	Mon, 15 Sep 2025 06:31:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757917875; cv=none; b=dKVV5uG8OJir7VYFTq1zoWcOxCmYYyjVBhpOyEGWlkx0f9jCtb84c9k8jKU8k+G3NeQfqIr1tMI6J1CycmlqOCLohpQwVCIc+qFA6EZbUD5LKdsgINowTn/kLo7nOm49uvw0edyKMK0Vy32aXnCYa5imhl80visi9e46IiXIGOs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757917875; c=relaxed/simple;
	bh=De/mkWOtKKz4RwwC1EJU3MDAHWFBrpuPkvoKidJPgis=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NYPdWuodAgIpRRZcVovQSFgprTN2hKW1dhaDP2xMFHD+roep14AnJGVbcfaxMmEQ8Cji0tWzvdBv+ZaAGqNXBBxXXAYRY7p2JaRTDLmcmi/9lGM0+tMW2IMzCveHfwQKT6DYT4hGSjRiUUeAvLp4NAVuYjdtivxFGIWUVx302FM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cyt3nriC; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1757917873; x=1789453873;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=De/mkWOtKKz4RwwC1EJU3MDAHWFBrpuPkvoKidJPgis=;
  b=cyt3nriClesJD5Dxh261Zr5IMClDZhP3RPlu1HpkIyo7+tQK6ukvwB7Q
   6L6FUdC1VSgTHAWCpxpVIYuPCEu3IQSxkn0lNPo09dzj9khC6pLHHhXu+
   K6YbA09gHh0uYLmjdCtyn8TEcSBPARXEJjtxPpiC+R69BSXrWlHQVE6AN
   4SEiRHkLackXmYfGhOCsnJ+7NHsCQ1RjgkPs09Ziav9bl6zrkkCD004Ya
   5zLRAseMODN4Q14cuwOlr5xaRO1dT5LMBf3JSaNtaZzpeBKKgQ6YHtpwA
   uyh0JxeIJ8aGuSSdck2DDSFsNtg86qB4tniA2ZuluVpeyjHm9JFbIoGeb
   w==;
X-CSE-ConnectionGUID: GuOhEfOFQxmT1LRHvzSG8Q==
X-CSE-MsgGUID: us86naPFTyOrb65lnNaSTw==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="63979577"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="63979577"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2025 23:31:12 -0700
X-CSE-ConnectionGUID: ShvVWG3MRe2Nt7I3jHhSZQ==
X-CSE-MsgGUID: kOWvQIobQ+SunMKGhecIfQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,265,1751266800"; 
   d="scan'208";a="174974906"
Received: from junlongf-mobl.ccr.corp.intel.com (HELO [10.238.1.52]) ([10.238.1.52])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2025 23:31:09 -0700
Message-ID: <6ce69c3b-755d-4369-8d2b-71106d3d6b6e@intel.com>
Date: Mon, 15 Sep 2025 14:31:06 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v15 12/41] KVM: VMX: Introduce CET VMCS fields and control
 bits
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Tom Lendacky <thomas.lendacky@amd.com>,
 Mathias Krause <minipli@grsecurity.net>, John Allen <john.allen@amd.com>,
 Rick Edgecombe <rick.p.edgecombe@intel.com>, Chao Gao <chao.gao@intel.com>,
 Maxim Levitsky <mlevitsk@redhat.com>, Zhang Yi Z <yi.z.zhang@linux.intel.com>
References: <20250912232319.429659-1-seanjc@google.com>
 <20250912232319.429659-13-seanjc@google.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
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

Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>

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


