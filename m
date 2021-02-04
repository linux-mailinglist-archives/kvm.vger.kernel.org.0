Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CFE830ED08
	for <lists+kvm@lfdr.de>; Thu,  4 Feb 2021 08:11:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233760AbhBDHKp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Feb 2021 02:10:45 -0500
Received: from mga18.intel.com ([134.134.136.126]:8709 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232704AbhBDHK2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Feb 2021 02:10:28 -0500
IronPort-SDR: IBf5/UlxlLauNnha7Wiq99sm4hDTG5qq5ZDJuPBTCRAMY7/IHYD/BrPsdW5DTblM1E9SdoTxYE
 vY6SSMz+jU6w==
X-IronPort-AV: E=McAfee;i="6000,8403,9884"; a="168867254"
X-IronPort-AV: E=Sophos;i="5.79,400,1602572400"; 
   d="scan'208";a="168867254"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2021 23:09:48 -0800
IronPort-SDR: z+bWTJLNKhrD7CmO8Jvwa8HK3C5f51kv6G7DFXH+PfWsDQ/wbbpNlYfswQX3CcKeBYvlAtbbAA
 aEKuSx2Awi9Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,400,1602572400"; 
   d="scan'208";a="414887014"
Received: from unknown (HELO localhost) ([10.239.159.166])
  by fmsmga002.fm.intel.com with ESMTP; 03 Feb 2021 23:09:45 -0800
Date:   Thu, 4 Feb 2021 15:22:00 +0800
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Yang Weijiang <weijiang.yang@intel.com>, pbonzini@redhat.com,
        jmattson@google.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, yu.c.zhang@linux.intel.com
Subject: Re: [PATCH v15 04/14] KVM: x86: Add #CP support in guest exception
 dispatch
Message-ID: <20210204072200.GA10094@local-michael-cet-test>
References: <20210203113421.5759-1-weijiang.yang@intel.com>
 <20210203113421.5759-5-weijiang.yang@intel.com>
 <YBsZwvwhshw+s7yQ@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YBsZwvwhshw+s7yQ@google.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 03, 2021 at 01:46:42PM -0800, Sean Christopherson wrote:
> On Wed, Feb 03, 2021, Yang Weijiang wrote:
> > Add handling for Control Protection (#CP) exceptions, vector 21, used
> > and introduced by Intel's Control-Flow Enforcement Technology (CET).
> > relevant CET violation case.  See Intel's SDM for details.
> > 
> > Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> > ---
> >  arch/x86/include/uapi/asm/kvm.h | 1 +
> >  arch/x86/kvm/x86.c              | 1 +
> >  arch/x86/kvm/x86.h              | 2 +-
> >  3 files changed, 3 insertions(+), 1 deletion(-)
> > 
> > diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
> > index 8e76d3701db3..507263d1d0b2 100644
> > --- a/arch/x86/include/uapi/asm/kvm.h
> > +++ b/arch/x86/include/uapi/asm/kvm.h
> > @@ -32,6 +32,7 @@
> >  #define MC_VECTOR 18
> >  #define XM_VECTOR 19
> >  #define VE_VECTOR 20
> > +#define CP_VECTOR 21
> >  
> >  /* Select x86 specific features in <linux/kvm.h> */
> >  #define __KVM_HAVE_PIT
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index 99f787152d12..d9d3bae40a8c 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -436,6 +436,7 @@ static int exception_class(int vector)
> >  	case NP_VECTOR:
> >  	case SS_VECTOR:
> >  	case GP_VECTOR:
> > +	case CP_VECTOR:
> >  		return EXCPT_CONTRIBUTORY;
> >  	default:
> >  		break;
> > diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
> > index c5ee0f5ce0f1..bdbd0b023ecc 100644
> > --- a/arch/x86/kvm/x86.h
> > +++ b/arch/x86/kvm/x86.h
> > @@ -116,7 +116,7 @@ static inline bool x86_exception_has_error_code(unsigned int vector)
> >  {
> >  	static u32 exception_has_error_code = BIT(DF_VECTOR) | BIT(TS_VECTOR) |
> >  			BIT(NP_VECTOR) | BIT(SS_VECTOR) | BIT(GP_VECTOR) |
> > -			BIT(PF_VECTOR) | BIT(AC_VECTOR);
> > +			BIT(PF_VECTOR) | BIT(AC_VECTOR) | BIT(CP_VECTOR);
> 
> These need to be conditional on CET being exposed to the guest.  TBD exceptions
> are non-contributory and don't have an error code.  Found when running unit
> tests in L1 with a kvm/queue as L1, but an older L0.  cr4_guest_rsvd_bits can be
> used to avoid guest_cpuid_has() lookups.
> 
> The SDM also gets this wrong.  Section 26.2.1.3, VM-Entry Control Fields, needs
> to be updated to add #CP to the list.
> 
>   — The field's deliver-error-code bit (bit 11) is 1 if each of the following
>     holds: (1) the interruption type is hardware exception; (2) bit 0
>     (corresponding to CR0.PE) is set in the CR0 field in the guest-state area;
>     (3) IA32_VMX_BASIC[56] is read as 0 (see Appendix A.1); and (4) the vector
>     indicates one of the following exceptions: #DF (vector 8), #TS (10),
>     #NP (11), #SS (12), #GP (13), #PF (14), or #AC (17).
> 
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index dbca1687ae8e..0b6dab6915a3 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -2811,7 +2811,7 @@ static int nested_check_vm_entry_controls(struct kvm_vcpu *vcpu,
>                 /* VM-entry interruption-info field: deliver error code */
>                 should_have_error_code =
>                         intr_type == INTR_TYPE_HARD_EXCEPTION && prot_mode &&
> -                       x86_exception_has_error_code(vector);
> +                       x86_exception_has_error_code(vcpu, vector);
>                 if (CC(has_error_code != should_have_error_code))
>                         return -EINVAL;
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 28fea7ff7a86..0288d6a364bd 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -437,17 +437,20 @@ EXPORT_SYMBOL_GPL(kvm_spurious_fault);
>  #define EXCPT_CONTRIBUTORY     1
>  #define EXCPT_PF               2
> 
> -static int exception_class(int vector)
> +static int exception_class(struct kvm_vcpu *vcpu, int vector)
>  {
>         switch (vector) {
>         case PF_VECTOR:
>                 return EXCPT_PF;
> +       case CP_VECTOR:
> +               if (vcpu->arch.cr4_guest_rsvd_bits & X86_CR4_CET)
> +                       return EXCPT_BENIGN;
> +               return EXCPT_CONTRIBUTORY;
>         case DE_VECTOR:
>         case TS_VECTOR:
>         case NP_VECTOR:
>         case SS_VECTOR:
>         case GP_VECTOR:
> -       case CP_VECTOR:
>                 return EXCPT_CONTRIBUTORY;
>         default:
>                 break;
> @@ -588,8 +591,8 @@ static void kvm_multiple_exception(struct kvm_vcpu *vcpu,
>                 kvm_make_request(KVM_REQ_TRIPLE_FAULT, vcpu);
>                 return;
>         }
> -       class1 = exception_class(prev_nr);
> -       class2 = exception_class(nr);
> +       class1 = exception_class(vcpu, prev_nr);
> +       class2 = exception_class(vcpu, nr);
>         if ((class1 == EXCPT_CONTRIBUTORY && class2 == EXCPT_CONTRIBUTORY)
>                 || (class1 == EXCPT_PF && class2 != EXCPT_BENIGN)) {
>                 /*
> diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
> index a14da36a30ed..dce756ffb577 100644
> --- a/arch/x86/kvm/x86.h
> +++ b/arch/x86/kvm/x86.h
> @@ -120,12 +120,16 @@ static inline bool is_la57_mode(struct kvm_vcpu *vcpu)
>  #endif
>  }
> 
> -static inline bool x86_exception_has_error_code(unsigned int vector)
> +static inline bool x86_exception_has_error_code(struct kvm_vcpu *vcpu,
> +                                               unsigned int vector)
>  {
>         static u32 exception_has_error_code = BIT(DF_VECTOR) | BIT(TS_VECTOR) |
>                         BIT(NP_VECTOR) | BIT(SS_VECTOR) | BIT(GP_VECTOR) |
>                         BIT(PF_VECTOR) | BIT(AC_VECTOR) | BIT(CP_VECTOR);
> 
> +       if (vector == CP_VECTOR && (vcpu->arch.cr4_guest_rsvd_bits & X86_CR4_CET))
> +               return false;
> +
>         return (1U << vector) & exception_has_error_code;
>  }
Thanks Sean for catching this!

Hi, Paolo,
Do I need to send another version to include Sean's change?

> 
> 
> 
