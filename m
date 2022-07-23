Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87E7D57EAF5
	for <lists+kvm@lfdr.de>; Sat, 23 Jul 2022 03:07:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234587AbiGWBHC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Jul 2022 21:07:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229572AbiGWBHA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Jul 2022 21:07:00 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABEAF13E32;
        Fri, 22 Jul 2022 18:06:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 57AB7B80EB8;
        Sat, 23 Jul 2022 01:06:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EA38C341C6;
        Sat, 23 Jul 2022 01:06:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658538417;
        bh=fHNuvB6T+dTuon+utp2CYAjZP2AR8Ky27DFotpM5vCo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pHWDCqhBvsuhaa1x6mo2CrB4y9dUJUEjObl40Lj3Cr0oqExCm8nPjfKrfDhdxhIQ/
         VuvfDqcUCdo2dz5kmZdao+yJpbmFZINq709K2dLM9nK3FA5ESORIC0My34XHp9c67u
         E9wOaAAnxrHbQiCm7+wwJBaMUhK9t/337/9Cj1NzD9MPDa35GV+IRPt6s/FvsHBVNF
         5Fw9I+1M5145zJ8kwKA+0C4M5n4A8/gJDF5Dpk4BhlHeBjY2hMTHu9wCeMPlILgDWs
         BogbfgS65HZcjnGynwnN1OmCxzSNOe5aWqqPKVFDRxzTlD9/95+2l2dXGLvAu7UMVM
         WnKNIMAtjw7sQ==
Date:   Fri, 22 Jul 2022 18:06:54 -0700
From:   Nathan Chancellor <nathan@kernel.org>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Anirudh Rayabharam <anrayabh@linux.microsoft.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
        llvm@lists.linux.dev
Subject: Re: [PATCH v4 15/25] KVM: VMX: Extend VMX controls macro shenanigans
Message-ID: <YttJrmcuAcL3PXno@dev-arch.thelio-3990X>
References: <20220714091327.1085353-1-vkuznets@redhat.com>
 <20220714091327.1085353-16-vkuznets@redhat.com>
 <YtrtdylmyolAHToz@google.com>
 <YtsQ5SkCJXQIuKGS@dev-arch.thelio-3990X>
 <YtsY5xwmlQ6kFtUz@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YtsY5xwmlQ6kFtUz@google.com>
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 22, 2022 at 09:38:47PM +0000, Sean Christopherson wrote:
> On Fri, Jul 22, 2022, Nathan Chancellor wrote:
> > On Fri, Jul 22, 2022 at 06:33:27PM +0000, Sean Christopherson wrote:
> > > On Thu, Jul 14, 2022, Vitaly Kuznetsov wrote:
> > > > diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
> > > > index 286c88e285ea..89eaab3495a6 100644
> > > > --- a/arch/x86/kvm/vmx/vmx.h
> > > > +++ b/arch/x86/kvm/vmx/vmx.h
> > > > @@ -467,6 +467,113 @@ static inline u8 vmx_get_rvi(void)
> > > >  	return vmcs_read16(GUEST_INTR_STATUS) & 0xff;
> > > >  }
> > > >  
> > > > +#define __KVM_REQ_VMX_VM_ENTRY_CONTROLS				\
> > > > +	(VM_ENTRY_LOAD_DEBUG_CONTROLS)
> > > > +#ifdef CONFIG_X86_64
> > > > +	#define KVM_REQ_VMX_VM_ENTRY_CONTROLS			\
> > > > +		(__KVM_REQ_VMX_VM_ENTRY_CONTROLS |		\
> > > > +		VM_ENTRY_IA32E_MODE)
> > > 
> > > This breaks 32-bit builds, but at least we know the assert works!
> > > 
> > > vmx_set_efer() toggles VM_ENTRY_IA32E_MODE without a CONFIG_X86_64 guard.  That
> > > should be easy enough to fix since KVM should never allow EFER_LMA.  Compile 
> > > tested patch at the bottom.
> > > 
> > > More problematic is that clang-13 doesn't like the new asserts, and even worse gives
> > > a very cryptic error.  I don't have bandwidth to look into this at the moment, and
> > > probably won't next week either.
> > > 
> > > ERROR: modpost: "__compiletime_assert_533" [arch/x86/kvm/kvm-intel.ko] undefined!
> > > ERROR: modpost: "__compiletime_assert_531" [arch/x86/kvm/kvm-intel.ko] undefined!
> > > ERROR: modpost: "__compiletime_assert_532" [arch/x86/kvm/kvm-intel.ko] undefined!
> > > ERROR: modpost: "__compiletime_assert_530" [arch/x86/kvm/kvm-intel.ko] undefined!
> > > make[2]: *** [scripts/Makefile.modpost:128: modules-only.symvers] Error 1
> > > make[1]: *** [Makefile:1753: modules] Error 2
> > > make[1]: *** Waiting for unfinished jobs....
> > 
> > clang-14 added support for the error and warning attributes, which makes
> > the BUILD_BUG_ON failures look like GCC. With allmodconfig, this
> > becomes:
> 
> ...
> 
> > As you mentioned in the other comment on this patch, the 'inline'
> > keyword should be '__always_inline' in the BUILD_CONTROLS_SHADOW macro
> > and a couple of other functions need it for BUILD_BUG_ON to see the
> > value all the way through the call chain. The following diff resolves
> > those errors for me, hopefully it is useful!
> 
> Thanks a ton!  Y'all are like a benevolent Beetlejuice, one needs only to mention
> "clang" and you show up and solve the problem :-)

Praise be to the mightly lei and its filters :)

FWIW, if you ever have a question about clang's behavior or any errors,
please feel free to cc llvm@lists.linux.dev, we're always happy to look
into things so that clang stays well supported upstream (and thank you
for verifying KVM changes with it!).

Cheers,
Nathan

> > diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> > index 4ce7ed835e06..b97ed63ece56 100644
> > --- a/arch/x86/kvm/vmx/vmx.c
> > +++ b/arch/x86/kvm/vmx/vmx.c
> > @@ -790,7 +790,7 @@ static bool msr_write_intercepted(struct vcpu_vmx *vmx, u32 msr)
> >  					 MSR_IA32_SPEC_CTRL);
> >  }
> >  
> > -static void clear_atomic_switch_msr_special(struct vcpu_vmx *vmx,
> > +static __always_inline void clear_atomic_switch_msr_special(struct vcpu_vmx *vmx,
> >  		unsigned long entry, unsigned long exit)
> >  {
> >  	vm_entry_controls_clearbit(vmx, entry);
> > @@ -848,7 +848,7 @@ static void clear_atomic_switch_msr(struct vcpu_vmx *vmx, unsigned msr)
> >  	vmcs_write32(VM_EXIT_MSR_LOAD_COUNT, m->host.nr);
> >  }
> >  
> > -static void add_atomic_switch_msr_special(struct vcpu_vmx *vmx,
> > +static __always_inline void add_atomic_switch_msr_special(struct vcpu_vmx *vmx,
> >  		unsigned long entry, unsigned long exit,
> >  		unsigned long guest_val_vmcs, unsigned long host_val_vmcs,
> >  		u64 guest_val, u64 host_val)
> > diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
> > index 758f80c41beb..acefa5b5e1b9 100644
> > --- a/arch/x86/kvm/vmx/vmx.h
> > +++ b/arch/x86/kvm/vmx/vmx.h
> > @@ -597,12 +597,12 @@ static inline u##bits lname##_controls_get(struct vcpu_vmx *vmx)		\
> >  {										\
> >  	return __##lname##_controls_get(vmx->loaded_vmcs);			\
> >  }										\
> > -static inline void lname##_controls_setbit(struct vcpu_vmx *vmx, u##bits val)	\
> > +static __always_inline void lname##_controls_setbit(struct vcpu_vmx *vmx, u##bits val)	\
> >  {										\
> >  	BUILD_BUG_ON(!(val & (KVM_REQ_VMX_##uname | KVM_OPT_VMX_##uname)));	\
> >  	lname##_controls_set(vmx, lname##_controls_get(vmx) | val);		\
> >  }										\
> > -static inline void lname##_controls_clearbit(struct vcpu_vmx *vmx, u##bits val)	\
> > +static __always_inline void lname##_controls_clearbit(struct vcpu_vmx *vmx, u##bits val)	\
> >  {										\
> >  	BUILD_BUG_ON(!(val & (KVM_REQ_VMX_##uname | KVM_OPT_VMX_##uname)));	\
> >  	lname##_controls_set(vmx, lname##_controls_get(vmx) & ~val);		\
> > 
> > > > +#else
> > > > +	#define KVM_REQ_VMX_VM_ENTRY_CONTROLS			\
> > > > +		__KVM_REQ_VMX_VM_ENTRY_CONTROLS
> > > > +#endif
