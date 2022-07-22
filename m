Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C95257E8F2
	for <lists+kvm@lfdr.de>; Fri, 22 Jul 2022 23:38:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236236AbiGVVi4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Jul 2022 17:38:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236232AbiGVViy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Jul 2022 17:38:54 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A803B8535
        for <kvm@vger.kernel.org>; Fri, 22 Jul 2022 14:38:53 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id d10so5475531pfd.9
        for <kvm@vger.kernel.org>; Fri, 22 Jul 2022 14:38:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=9mfWyaAJoqNRd6CIZWDREmNaOiHWPvGxSlRrdfXmYSk=;
        b=U6n4pS1S313KjljFYwOWUkusI66upqXtV/G1B7AYdEFBF1ugwrGORaxlnM4AxrCMhL
         bkiT6VcZCA0qLo2KXsRCIG4zs/cpTY+A1xKtnpQ9LmR7mCnQ8LabZnNsX+xdHCW/ShVJ
         EMbUL8JVjSuT5MV7mFjeXU2EmLcOS95SH8RheCaMSAcdRB5xir65uyir31WyzSVzVTXM
         IkjqUtFSTxhMOW22GPaevCXAR+chamMqnwzpBcR5pYEeaHMA0KMq2TVfr/cfb0AbQphH
         C1gPEAyb7UciJY885hZnDacOM5vLTqruF6Dgx9JpnCO4//Rh7ELVtSvscm2bIYnjJAup
         HP5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=9mfWyaAJoqNRd6CIZWDREmNaOiHWPvGxSlRrdfXmYSk=;
        b=DHZNDfTt5RNlW+ShlwfI9KAoam/L+p8emB/DmQq1cdPTRqtN+gyHOfePe6hzdLvJRA
         2HLn2Q6tXUNOFNbCI6l5mfymn9uWXr+MRJgugCB03KQSK+Z/3vxyZOu/cSJGftN+W7br
         acd/eJRVZRsgAPMfoe2wjTDwgv6K52ZVT5D8mZslXaYzJj5LGIMLLI0/qmypuuW6A7+U
         qxVcbIe70eFrIs691UMHrl+2ajjX7rtWg6iF73bIKYNjhhj0exc23M/iZDJar8fL1/cb
         q7DiQIAzWMapuDcnoPVC4NJGZwLFC0VmJWOkUadjVk8ARKSCUiQ3LYuAECnqT/DUagV0
         Qttw==
X-Gm-Message-State: AJIora/T+nycjNVrQ3bVKrUjTZtVkmYpIjn4ViobBrQPGEYILRjZub/4
        q4/McaXOnYtuFVz21LY8yAkz2A==
X-Google-Smtp-Source: AGRyM1vxW9TitpWGxELq9f+JH5rrVHEPD71/Yq0LYiZ6rY0FKSEsHeQES120sPNMNr6to9yJYb77AA==
X-Received: by 2002:a63:a748:0:b0:40c:9a36:ff9a with SMTP id w8-20020a63a748000000b0040c9a36ff9amr1402109pgo.545.1658525932834;
        Fri, 22 Jul 2022 14:38:52 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com. [35.230.65.123])
        by smtp.gmail.com with ESMTPSA id y4-20020a17090a154400b001efa332d365sm3845092pja.33.2022.07.22.14.38.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Jul 2022 14:38:51 -0700 (PDT)
Date:   Fri, 22 Jul 2022 21:38:47 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Nathan Chancellor <nathan@kernel.org>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Anirudh Rayabharam <anrayabh@linux.microsoft.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
        llvm@lists.linux.dev
Subject: Re: [PATCH v4 15/25] KVM: VMX: Extend VMX controls macro shenanigans
Message-ID: <YtsY5xwmlQ6kFtUz@google.com>
References: <20220714091327.1085353-1-vkuznets@redhat.com>
 <20220714091327.1085353-16-vkuznets@redhat.com>
 <YtrtdylmyolAHToz@google.com>
 <YtsQ5SkCJXQIuKGS@dev-arch.thelio-3990X>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YtsQ5SkCJXQIuKGS@dev-arch.thelio-3990X>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 22, 2022, Nathan Chancellor wrote:
> On Fri, Jul 22, 2022 at 06:33:27PM +0000, Sean Christopherson wrote:
> > On Thu, Jul 14, 2022, Vitaly Kuznetsov wrote:
> > > diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
> > > index 286c88e285ea..89eaab3495a6 100644
> > > --- a/arch/x86/kvm/vmx/vmx.h
> > > +++ b/arch/x86/kvm/vmx/vmx.h
> > > @@ -467,6 +467,113 @@ static inline u8 vmx_get_rvi(void)
> > >  	return vmcs_read16(GUEST_INTR_STATUS) & 0xff;
> > >  }
> > >  
> > > +#define __KVM_REQ_VMX_VM_ENTRY_CONTROLS				\
> > > +	(VM_ENTRY_LOAD_DEBUG_CONTROLS)
> > > +#ifdef CONFIG_X86_64
> > > +	#define KVM_REQ_VMX_VM_ENTRY_CONTROLS			\
> > > +		(__KVM_REQ_VMX_VM_ENTRY_CONTROLS |		\
> > > +		VM_ENTRY_IA32E_MODE)
> > 
> > This breaks 32-bit builds, but at least we know the assert works!
> > 
> > vmx_set_efer() toggles VM_ENTRY_IA32E_MODE without a CONFIG_X86_64 guard.  That
> > should be easy enough to fix since KVM should never allow EFER_LMA.  Compile 
> > tested patch at the bottom.
> > 
> > More problematic is that clang-13 doesn't like the new asserts, and even worse gives
> > a very cryptic error.  I don't have bandwidth to look into this at the moment, and
> > probably won't next week either.
> > 
> > ERROR: modpost: "__compiletime_assert_533" [arch/x86/kvm/kvm-intel.ko] undefined!
> > ERROR: modpost: "__compiletime_assert_531" [arch/x86/kvm/kvm-intel.ko] undefined!
> > ERROR: modpost: "__compiletime_assert_532" [arch/x86/kvm/kvm-intel.ko] undefined!
> > ERROR: modpost: "__compiletime_assert_530" [arch/x86/kvm/kvm-intel.ko] undefined!
> > make[2]: *** [scripts/Makefile.modpost:128: modules-only.symvers] Error 1
> > make[1]: *** [Makefile:1753: modules] Error 2
> > make[1]: *** Waiting for unfinished jobs....
> 
> clang-14 added support for the error and warning attributes, which makes
> the BUILD_BUG_ON failures look like GCC. With allmodconfig, this
> becomes:

...

> As you mentioned in the other comment on this patch, the 'inline'
> keyword should be '__always_inline' in the BUILD_CONTROLS_SHADOW macro
> and a couple of other functions need it for BUILD_BUG_ON to see the
> value all the way through the call chain. The following diff resolves
> those errors for me, hopefully it is useful!

Thanks a ton!  Y'all are like a benevolent Beetlejuice, one needs only to mention
"clang" and you show up and solve the problem :-)

> Cheers,
> Nathan
> 
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 4ce7ed835e06..b97ed63ece56 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -790,7 +790,7 @@ static bool msr_write_intercepted(struct vcpu_vmx *vmx, u32 msr)
>  					 MSR_IA32_SPEC_CTRL);
>  }
>  
> -static void clear_atomic_switch_msr_special(struct vcpu_vmx *vmx,
> +static __always_inline void clear_atomic_switch_msr_special(struct vcpu_vmx *vmx,
>  		unsigned long entry, unsigned long exit)
>  {
>  	vm_entry_controls_clearbit(vmx, entry);
> @@ -848,7 +848,7 @@ static void clear_atomic_switch_msr(struct vcpu_vmx *vmx, unsigned msr)
>  	vmcs_write32(VM_EXIT_MSR_LOAD_COUNT, m->host.nr);
>  }
>  
> -static void add_atomic_switch_msr_special(struct vcpu_vmx *vmx,
> +static __always_inline void add_atomic_switch_msr_special(struct vcpu_vmx *vmx,
>  		unsigned long entry, unsigned long exit,
>  		unsigned long guest_val_vmcs, unsigned long host_val_vmcs,
>  		u64 guest_val, u64 host_val)
> diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
> index 758f80c41beb..acefa5b5e1b9 100644
> --- a/arch/x86/kvm/vmx/vmx.h
> +++ b/arch/x86/kvm/vmx/vmx.h
> @@ -597,12 +597,12 @@ static inline u##bits lname##_controls_get(struct vcpu_vmx *vmx)		\
>  {										\
>  	return __##lname##_controls_get(vmx->loaded_vmcs);			\
>  }										\
> -static inline void lname##_controls_setbit(struct vcpu_vmx *vmx, u##bits val)	\
> +static __always_inline void lname##_controls_setbit(struct vcpu_vmx *vmx, u##bits val)	\
>  {										\
>  	BUILD_BUG_ON(!(val & (KVM_REQ_VMX_##uname | KVM_OPT_VMX_##uname)));	\
>  	lname##_controls_set(vmx, lname##_controls_get(vmx) | val);		\
>  }										\
> -static inline void lname##_controls_clearbit(struct vcpu_vmx *vmx, u##bits val)	\
> +static __always_inline void lname##_controls_clearbit(struct vcpu_vmx *vmx, u##bits val)	\
>  {										\
>  	BUILD_BUG_ON(!(val & (KVM_REQ_VMX_##uname | KVM_OPT_VMX_##uname)));	\
>  	lname##_controls_set(vmx, lname##_controls_get(vmx) & ~val);		\
> 
> > > +#else
> > > +	#define KVM_REQ_VMX_VM_ENTRY_CONTROLS			\
> > > +		__KVM_REQ_VMX_VM_ENTRY_CONTROLS
> > > +#endif
