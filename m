Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 327F31B6063
	for <lists+kvm@lfdr.de>; Thu, 23 Apr 2020 18:07:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729623AbgDWQHt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Apr 2020 12:07:49 -0400
Received: from mga04.intel.com ([192.55.52.120]:53741 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729282AbgDWQHt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Apr 2020 12:07:49 -0400
IronPort-SDR: bVUndtzK5OU0fulqqZWTxhjMMM/NTz0uplgjtRo5UioK5j+AKMBCxZFi8xBZ0VQGZFitaSnqDU
 tB0zBA6aI3nQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2020 09:07:48 -0700
IronPort-SDR: 8QzfRGjB2XS7O9PVLE1nc6wgt+Pwh/J9AfozwJGNvS2l3WYJ7jpcqgGzfMd0a43l1yF0Qou1ax
 BIVwCmn9KmHw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,307,1583222400"; 
   d="scan'208";a="335012264"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by orsmga001.jf.intel.com with ESMTP; 23 Apr 2020 09:07:48 -0700
Date:   Thu, 23 Apr 2020 09:07:48 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Yang Weijiang <weijiang.yang@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, jmattson@google.com,
        yu.c.zhang@linux.intel.com
Subject: Re: [PATCH v11 1/9] KVM: VMX: Introduce CET VMX fields and flags
Message-ID: <20200423160748.GF17824@linux.intel.com>
References: <20200326081847.5870-1-weijiang.yang@intel.com>
 <20200326081847.5870-2-weijiang.yang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200326081847.5870-2-weijiang.yang@intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 26, 2020 at 04:18:38PM +0800, Yang Weijiang wrote:
> CET(Control-flow Enforcement Technology) is a CPU feature
> used to prevent Return/Jump-Oriented Programming(ROP/JOP)
> attacks. It provides the following sub-features to defend
> against ROP/JOP style control-flow subversion attacks:

Changelogs should wrap at 75 characters.  Wrapping slightly earlier is ok,
but wrapping at ~60 chars is too narrow.

> Shadow Stack (SHSTK):
>   A second stack for program which is used exclusively for
>   control transfer operations.
> 
> Indirect Branch Tracking (IBT):
>   Code branching protection to defend against jump/call oriented
>   programming.
> 
> Several new CET MSRs are defined in kernel to support CET:
>   MSR_IA32_{U,S}_CET: Controls the CET settings for user
>                       mode and kernel mode respectively.
> 
>   MSR_IA32_PL{0,1,2,3}_SSP: Stores shadow stack pointers for
>                             CPL-0,1,2,3 protection respectively.
> 
>   MSR_IA32_INT_SSP_TAB: Stores base address of shadow stack
>                         pointer table.
> 
> Two XSAVES state bits are introduced for CET:
>   IA32_XSS:[bit 11]: Control saving/restoring user mode CET states
>   IA32_XSS:[bit 12]: Control saving/restoring kernel mode CET states.
> 
> Six VMCS fields are introduced for CET:
>   {HOST,GUEST}_S_CET: Stores CET settings for kernel mode.
>   {HOST,GUEST}_SSP: Stores shadow stack pointer of current task/thread.
>   {HOST,GUEST}_INTR_SSP_TABLE: Stores base address of shadow stack pointer
>                                table.
> 
> If VM_EXIT_LOAD_HOST_CET_STATE = 1, the host CET states are restored
> from below VMCS fields at VM-Exit:
>   HOST_S_CET
>   HOST_SSP
>   HOST_INTR_SSP_TABLE
> 
> If VM_ENTRY_LOAD_GUEST_CET_STATE = 1, the guest CET states are loaded
> from below VMCS fields at VM-Entry:
>   GUEST_S_CET
>   GUEST_SSP
>   GUEST_INTR_SSP_TABLE
> 
> Co-developed-by: Zhang Yi Z <yi.z.zhang@linux.intel.com>
> Signed-off-by: Zhang Yi Z <yi.z.zhang@linux.intel.com>
> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> ---
>  arch/x86/include/asm/vmx.h      | 8 ++++++++
>  arch/x86/include/uapi/asm/kvm.h | 1 +
>  arch/x86/kvm/x86.c              | 4 ++++
>  arch/x86/kvm/x86.h              | 2 +-
>  4 files changed, 14 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
> index 5e090d1f03f8..e938bc6c37aa 100644
> --- a/arch/x86/include/asm/vmx.h
> +++ b/arch/x86/include/asm/vmx.h
> @@ -94,6 +94,7 @@
>  #define VM_EXIT_CLEAR_BNDCFGS                   0x00800000
>  #define VM_EXIT_PT_CONCEAL_PIP			0x01000000
>  #define VM_EXIT_CLEAR_IA32_RTIT_CTL		0x02000000
> +#define VM_EXIT_LOAD_HOST_CET_STATE             0x10000000
>  
>  #define VM_EXIT_ALWAYSON_WITHOUT_TRUE_MSR	0x00036dff
>  
> @@ -107,6 +108,7 @@
>  #define VM_ENTRY_LOAD_BNDCFGS                   0x00010000
>  #define VM_ENTRY_PT_CONCEAL_PIP			0x00020000
>  #define VM_ENTRY_LOAD_IA32_RTIT_CTL		0x00040000
> +#define VM_ENTRY_LOAD_GUEST_CET_STATE           0x00100000
>  
>  #define VM_ENTRY_ALWAYSON_WITHOUT_TRUE_MSR	0x000011ff
>  
> @@ -328,6 +330,9 @@ enum vmcs_field {
>  	GUEST_PENDING_DBG_EXCEPTIONS    = 0x00006822,
>  	GUEST_SYSENTER_ESP              = 0x00006824,
>  	GUEST_SYSENTER_EIP              = 0x00006826,
> +	GUEST_S_CET                     = 0x00006828,
> +	GUEST_SSP                       = 0x0000682a,
> +	GUEST_INTR_SSP_TABLE            = 0x0000682c,
>  	HOST_CR0                        = 0x00006c00,
>  	HOST_CR3                        = 0x00006c02,
>  	HOST_CR4                        = 0x00006c04,
> @@ -340,6 +345,9 @@ enum vmcs_field {
>  	HOST_IA32_SYSENTER_EIP          = 0x00006c12,
>  	HOST_RSP                        = 0x00006c14,
>  	HOST_RIP                        = 0x00006c16,
> +	HOST_S_CET                      = 0x00006c18,
> +	HOST_SSP                        = 0x00006c1a,
> +	HOST_INTR_SSP_TABLE             = 0x00006c1c
>  };
>  
>  /*
> diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
> index 3f3f780c8c65..78e5c4266270 100644
> --- a/arch/x86/include/uapi/asm/kvm.h
> +++ b/arch/x86/include/uapi/asm/kvm.h
> @@ -31,6 +31,7 @@
>  #define MC_VECTOR 18
>  #define XM_VECTOR 19
>  #define VE_VECTOR 20
> +#define CP_VECTOR 21
>  
>  /* Select x86 specific features in <linux/kvm.h> */
>  #define __KVM_HAVE_PIT
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 40c6768942ae..830afe5038d1 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -186,6 +186,9 @@ static struct kvm_shared_msrs __percpu *shared_msrs;
>  				| XFEATURE_MASK_BNDCSR | XFEATURE_MASK_AVX512 \
>  				| XFEATURE_MASK_PKRU)
>  
> +#define KVM_SUPPORTED_XSS	(XFEATURE_MASK_CET_USER | \
> +				 XFEATURE_MASK_CET_KERNEL)

This belongs in a later patch, KVM obviously doesn't support XSS.

> +
>  u64 __read_mostly host_efer;
>  EXPORT_SYMBOL_GPL(host_efer);
>  
> @@ -402,6 +405,7 @@ static int exception_class(int vector)
>  	case NP_VECTOR:
>  	case SS_VECTOR:
>  	case GP_VECTOR:
> +	case CP_VECTOR:
>  		return EXCPT_CONTRIBUTORY;
>  	default:
>  		break;
> diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
> index c1954e216b41..8f0baa6fa72f 100644
> --- a/arch/x86/kvm/x86.h
> +++ b/arch/x86/kvm/x86.h
> @@ -115,7 +115,7 @@ static inline bool x86_exception_has_error_code(unsigned int vector)
>  {
>  	static u32 exception_has_error_code = BIT(DF_VECTOR) | BIT(TS_VECTOR) |
>  			BIT(NP_VECTOR) | BIT(SS_VECTOR) | BIT(GP_VECTOR) |
> -			BIT(PF_VECTOR) | BIT(AC_VECTOR);
> +			BIT(PF_VECTOR) | BIT(AC_VECTOR) | BIT(CP_VECTOR);
>  
>  	return (1U << vector) & exception_has_error_code;

Maybe it's gratuitous, but I feel like the #CP logic should be in a patch
of its own, e.g. the changelog doesn't mention anything about #CP.

>  }
> -- 
> 2.17.2
> 
