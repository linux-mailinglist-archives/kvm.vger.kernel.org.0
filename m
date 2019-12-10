Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA20511929A
	for <lists+kvm@lfdr.de>; Tue, 10 Dec 2019 22:00:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726898AbfLJVAq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Dec 2019 16:00:46 -0500
Received: from mga03.intel.com ([134.134.136.65]:2974 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725999AbfLJVAq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Dec 2019 16:00:46 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 10 Dec 2019 13:00:44 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,300,1571727600"; 
   d="scan'208";a="387708359"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by orsmga005.jf.intel.com with ESMTP; 10 Dec 2019 13:00:44 -0800
Date:   Tue, 10 Dec 2019 13:00:44 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Yang Weijiang <weijiang.yang@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, jmattson@google.com,
        yu.c.zhang@linux.intel.com, yu-cheng.yu@intel.com
Subject: Re: [PATCH v8 2/7] KVM: VMX: Define CET VMCS fields and #CP flag
Message-ID: <20191210210044.GK15758@linux.intel.com>
References: <20191101085222.27997-1-weijiang.yang@intel.com>
 <20191101085222.27997-3-weijiang.yang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191101085222.27997-3-weijiang.yang@intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Nov 01, 2019 at 04:52:17PM +0800, Yang Weijiang wrote:
> CET(Control-flow Enforcement Technology) is an upcoming Intel(R)
> processor feature that blocks Return/Jump-Oriented Programming(ROP)
> attacks. It provides the following capabilities to defend
> against ROP/JOP style control-flow subversion attacks:
> 
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
>                       mode and suervisor mode respectively.
> 
>   MSR_IA32_PL{0,1,2,3}_SSP: Stores shadow stack pointers for
>                             CPL-0,1,2,3 level respectively.
> 
>   MSR_IA32_INT_SSP_TAB: Stores base address of shadow stack
>                         pointer table.
> 
> Two XSAVES state bits are introduced for CET:
>   IA32_XSS:[bit 11]: For saving/restoring user mode CET states
>   IA32_XSS:[bit 12]: For saving/restoring supervisor mode CET states.
> 
> Six VMCS fields are introduced for CET:
>   {HOST,GUEST}_S_CET: Stores CET settings for supervisor mode.
>   {HOST,GUEST}_SSP: Stores shadow stack pointer for supervisor mode.
>   {HOST,GUEST}_INTR_SSP_TABLE: Stores base address of shadow stack pointer
>                                table.
> 
> If VM_EXIT_LOAD_HOST_CET_STATE = 1, the host's CET MSRs are restored
> from below VMCS fields at VM-Exit:
>   HOST_S_CET
>   HOST_SSP
>   HOST_INTR_SSP_TABLE
> 
> If VM_ENTRY_LOAD_GUEST_CET_STATE = 1, the guest's CET MSRs are loaded
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
>  arch/x86/kvm/x86.c              | 1 +
>  arch/x86/kvm/x86.h              | 5 +++--
>  4 files changed, 13 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
> index a39136b0d509..68bca290a203 100644
> --- a/arch/x86/include/asm/vmx.h
> +++ b/arch/x86/include/asm/vmx.h
> @@ -90,6 +90,7 @@
>  #define VM_EXIT_CLEAR_BNDCFGS                   0x00800000
>  #define VM_EXIT_PT_CONCEAL_PIP			0x01000000
>  #define VM_EXIT_CLEAR_IA32_RTIT_CTL		0x02000000
> +#define VM_EXIT_LOAD_HOST_CET_STATE             0x10000000
>  
>  #define VM_EXIT_ALWAYSON_WITHOUT_TRUE_MSR	0x00036dff
>  
> @@ -103,6 +104,7 @@
>  #define VM_ENTRY_LOAD_BNDCFGS                   0x00010000
>  #define VM_ENTRY_PT_CONCEAL_PIP			0x00020000
>  #define VM_ENTRY_LOAD_IA32_RTIT_CTL		0x00040000
> +#define VM_ENTRY_LOAD_GUEST_CET_STATE           0x00100000
>  
>  #define VM_ENTRY_ALWAYSON_WITHOUT_TRUE_MSR	0x000011ff
>  
> @@ -321,6 +323,9 @@ enum vmcs_field {
>  	GUEST_PENDING_DBG_EXCEPTIONS    = 0x00006822,
>  	GUEST_SYSENTER_ESP              = 0x00006824,
>  	GUEST_SYSENTER_EIP              = 0x00006826,
> +	GUEST_S_CET                     = 0x00006828,
> +	GUEST_SSP                       = 0x0000682a,
> +	GUEST_INTR_SSP_TABLE            = 0x0000682c,
>  	HOST_CR0                        = 0x00006c00,
>  	HOST_CR3                        = 0x00006c02,
>  	HOST_CR4                        = 0x00006c04,
> @@ -333,6 +338,9 @@ enum vmcs_field {
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
> index 503d3f42da16..e68d6b448730 100644
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
> index 290c3c3efb87..540490d5385f 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -378,6 +378,7 @@ static int exception_class(int vector)
>  	case NP_VECTOR:
>  	case SS_VECTOR:
>  	case GP_VECTOR:
> +	case CP_VECTOR:
>  		return EXCPT_CONTRIBUTORY;
>  	default:
>  		break;
> diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
> index f10c12b5197d..7e7b5b5cc956 100644
> --- a/arch/x86/kvm/x86.h
> +++ b/arch/x86/kvm/x86.h
> @@ -114,7 +114,7 @@ static inline bool x86_exception_has_error_code(unsigned int vector)
>  {
>  	static u32 exception_has_error_code = BIT(DF_VECTOR) | BIT(TS_VECTOR) |
>  			BIT(NP_VECTOR) | BIT(SS_VECTOR) | BIT(GP_VECTOR) |
> -			BIT(PF_VECTOR) | BIT(AC_VECTOR);
> +			BIT(PF_VECTOR) | BIT(AC_VECTOR) | BIT(CP_VECTOR);
>  
>  	return (1U << vector) & exception_has_error_code;
>  }
> @@ -298,7 +298,8 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu, unsigned long cr2,
>   * Right now, no XSS states are used on x86 platform,
>   * expand the macro for new features.

I assume this comment needs to be updated?

>   */
> -#define KVM_SUPPORTED_XSS	0
> +#define KVM_SUPPORTED_XSS	(XFEATURE_MASK_CET_USER \
> +				| XFEATURE_MASK_CET_KERNEL)
>  
>  extern u64 host_xcr0;
>  
> -- 
> 2.17.2
> 
