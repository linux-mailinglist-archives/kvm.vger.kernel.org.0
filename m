Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 825CD354B48
	for <lists+kvm@lfdr.de>; Tue,  6 Apr 2021 05:38:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242329AbhDFDiI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Apr 2021 23:38:08 -0400
Received: from mga09.intel.com ([134.134.136.24]:4076 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233556AbhDFDiG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Apr 2021 23:38:06 -0400
IronPort-SDR: rgiU1e/z9S0t0jpg17PWQv9UqLeNgRAWE2wOstkwgFXOE9GTZLd55xDdbjk8kv6RHuRocGRw4p
 WYSUGSUcbJ/w==
X-IronPort-AV: E=McAfee;i="6000,8403,9945"; a="193087111"
X-IronPort-AV: E=Sophos;i="5.81,308,1610438400"; 
   d="scan'208";a="193087111"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Apr 2021 20:37:59 -0700
IronPort-SDR: JVp4oOLiDVaFQ83kPbOEKa/Lg5oWR0vL2vUx4BnrktgaUSp/xW6t0RRRyRMeTL9M5hboNMfzYI
 ArD7YCflsvQQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,308,1610438400"; 
   d="scan'208";a="609117686"
Received: from sqa-gate.sh.intel.com (HELO robert-ivt.tsp.org) ([10.239.48.212])
  by fmsmga006.fm.intel.com with ESMTP; 05 Apr 2021 20:37:57 -0700
Message-ID: <6dd6b2f954642ae16fc24f58dda224af0657a248.camel@linux.intel.com>
Subject: Re: [RFC PATCH 03/12] kvm/vmx: Introduce the new tertiary
 processor-based VM-execution controls
From:   Robert Hoo <robert.hu@linux.intel.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     pbonzini@redhat.com, vkuznets@redhat.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, chang.seok.bae@intel.com,
        kvm@vger.kernel.org, robert.hu@intel.com
Date:   Tue, 06 Apr 2021 11:37:56 +0800
In-Reply-To: <YGsu+ckrwEsZSUoN@google.com>
References: <1611565580-47718-1-git-send-email-robert.hu@linux.intel.com>
         <1611565580-47718-4-git-send-email-robert.hu@linux.intel.com>
         <YGsu+ckrwEsZSUoN@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-8.el7) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2021-04-05 at 15:38 +0000, Sean Christopherson wrote:
> On Mon, Jan 25, 2021, Robert Hoo wrote:
> > diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
> > index f6f66e5..94f1c27 100644
> > --- a/arch/x86/kvm/vmx/vmx.h
> > +++ b/arch/x86/kvm/vmx/vmx.h
> > @@ -373,6 +373,14 @@ static inline u8 vmx_get_rvi(void)
> >  BUILD_CONTROLS_SHADOW(exec, CPU_BASED_VM_EXEC_CONTROL)
> >  BUILD_CONTROLS_SHADOW(secondary_exec, SECONDARY_VM_EXEC_CONTROL)
> >  
> > +static inline void tertiary_exec_controls_set(struct vcpu_vmx
> > *vmx, u64 val)
> > +{
> > +	if (vmx->loaded_vmcs->controls_shadow.tertiary_exec != val) {
> > +		vmcs_write64(TERTIARY_VM_EXEC_CONTROL, val);
> > +		vmx->loaded_vmcs->controls_shadow.tertiary_exec = val;
> > +	}
> > +}
> 
> Add a "bits" param to the builder macros and use string
> concatenation, then the
> tertiary controls can share those macros.
> 
> diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
> index 7886a08505cc..328039157535 100644
> --- a/arch/x86/kvm/vmx/vmx.h
> +++ b/arch/x86/kvm/vmx/vmx.h
> @@ -398,25 +398,25 @@ static inline u8 vmx_get_rvi(void)
>         return vmcs_read16(GUEST_INTR_STATUS) & 0xff;
>  }
> 
> -#define BUILD_CONTROLS_SHADOW(lname,
> uname)                                \
> -static inline void lname##_controls_set(struct vcpu_vmx *vmx, u32
> val)     \
> -{                                                                   
>        \
> -       if (vmx->loaded_vmcs->controls_shadow.lname != val)
> {               \
> -               vmcs_write32(uname,
> val);                                   \
> -               vmx->loaded_vmcs->controls_shadow.lname =
> val;              \
> -       }                                                            
>        \
> -}                                                                   
>        \
> -static inline u32 lname##_controls_get(struct vcpu_vmx
> *vmx)               \
> -{                                                                   
>        \
> -       return vmx->loaded_vmcs-
> >controls_shadow.lname;                     \
> -}                                                                   
>        \
> -static inline void lname##_controls_setbit(struct vcpu_vmx *vmx, u32
> val)   \
> -{                                                                   
>        \
> -       lname##_controls_set(vmx, lname##_controls_get(vmx) |
> val);         \
> -}                                                                   
>        \
> -static inline void lname##_controls_clearbit(struct vcpu_vmx *vmx,
> u32 val) \
> -{                                                                   
>        \
> -       lname##_controls_set(vmx, lname##_controls_get(vmx) &
> ~val);        \
> +#define BUILD_CONTROLS_SHADOW(lname, uname,
> bits)                              \
> +static inline void lname##_controls_set(struct vcpu_vmx *vmx,
> u##bits val)     \
> +{                                                                   
>            \
> +       if (vmx->loaded_vmcs->controls_shadow.lname != val)
> {                   \
> +               vmcs_write##bits(uname,
> val);                                   \
> +               vmx->loaded_vmcs->controls_shadow.lname =
> val;                  \
> +       }                                                            
>            \
> +}                                                                   
>            \
> +static inline u##bits lname##_controls_get(struct vcpu_vmx
> *vmx)               \
> +{                                                                   
>            \
> +       return vmx->loaded_vmcs-
> >controls_shadow.lname;                         \
> +}                                                                   
>            \
> +static inline void lname##_controls_setbit(struct vcpu_vmx *vmx,
> u##bits val)  \
> +{                                                                   
>            \
> +       lname##_controls_set(vmx, lname##_controls_get(vmx) |
> val);             \
> +}                                                                   
>            \
> +static inline void lname##_controls_clearbit(struct vcpu_vmx *vmx,
> u##bits val)        \
> +{                                                                   
>            \
> +       lname##_controls_set(vmx, lname##_controls_get(vmx) &
> ~val);            \
>  }
>  BUILD_CONTROLS_SHADOW(vm_entry, VM_ENTRY_CONTROLS)
>  BUILD_CONTROLS_SHADOW(vm_exit, VM_EXIT_CONTROLS)
> 
Nice. I like this. Thanks Sean.

Shall I separated this hunk a patch and have your "Signed-off-by:"?

> > +
> >  static inline void vmx_register_cache_reset(struct kvm_vcpu *vcpu)
> >  {
> >  	vcpu->arch.regs_avail = ~((1 << VCPU_REGS_RIP) | (1 <<
> > VCPU_REGS_RSP)
> > -- 
> > 1.8.3.1
> > 

