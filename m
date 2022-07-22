Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76CC457E8AA
	for <lists+kvm@lfdr.de>; Fri, 22 Jul 2022 23:04:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233004AbiGVVEm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Jul 2022 17:04:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229593AbiGVVEl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Jul 2022 17:04:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3EE6AFB49;
        Fri, 22 Jul 2022 14:04:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 423E8614F9;
        Fri, 22 Jul 2022 21:04:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DCB2C341CA;
        Fri, 22 Jul 2022 21:04:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658523879;
        bh=SmDj6eH7SiQMUYtkLw4y1LTUeAvvwQXs0wVSKDYMoLc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Sy/O14pXNi/bDfzqciJayPxn0fyOOQ2awEpx9UuTeQN06MvY0WKuksQ72DSewaOnJ
         44GYRQFR35W/3YS4DKkaB8MeRFlLP4KuQE/SBcEzidg41zBcwb1ZugcmxsLGHQWGMY
         a18oqsTUo1GyC7ESH0wu/PXjYIToICS/GRRfg2rcI8HywMMoI3+Bo+tCYJ/aeIhysw
         GT98g5EfIEHeP3A3iTUhnNFeJtega43C1IGjn31NOjdfjt7alk1FaNWRG+XYKFztxX
         2fG/BEP3ajYoI+G06ZsUEK3jEm5GqCHJi3uagbohgYNFilWQdbZKNbvCkwl1oKKTCB
         aD/LnDhZMKsmQ==
Date:   Fri, 22 Jul 2022 14:04:37 -0700
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
Message-ID: <YtsQ5SkCJXQIuKGS@dev-arch.thelio-3990X>
References: <20220714091327.1085353-1-vkuznets@redhat.com>
 <20220714091327.1085353-16-vkuznets@redhat.com>
 <YtrtdylmyolAHToz@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YtrtdylmyolAHToz@google.com>
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 22, 2022 at 06:33:27PM +0000, Sean Christopherson wrote:
> On Thu, Jul 14, 2022, Vitaly Kuznetsov wrote:
> > diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
> > index 286c88e285ea..89eaab3495a6 100644
> > --- a/arch/x86/kvm/vmx/vmx.h
> > +++ b/arch/x86/kvm/vmx/vmx.h
> > @@ -467,6 +467,113 @@ static inline u8 vmx_get_rvi(void)
> >  	return vmcs_read16(GUEST_INTR_STATUS) & 0xff;
> >  }
> >  
> > +#define __KVM_REQ_VMX_VM_ENTRY_CONTROLS				\
> > +	(VM_ENTRY_LOAD_DEBUG_CONTROLS)
> > +#ifdef CONFIG_X86_64
> > +	#define KVM_REQ_VMX_VM_ENTRY_CONTROLS			\
> > +		(__KVM_REQ_VMX_VM_ENTRY_CONTROLS |		\
> > +		VM_ENTRY_IA32E_MODE)
> 
> This breaks 32-bit builds, but at least we know the assert works!
> 
> vmx_set_efer() toggles VM_ENTRY_IA32E_MODE without a CONFIG_X86_64 guard.  That
> should be easy enough to fix since KVM should never allow EFER_LMA.  Compile 
> tested patch at the bottom.
> 
> More problematic is that clang-13 doesn't like the new asserts, and even worse gives
> a very cryptic error.  I don't have bandwidth to look into this at the moment, and
> probably won't next week either.
> 
> ERROR: modpost: "__compiletime_assert_533" [arch/x86/kvm/kvm-intel.ko] undefined!
> ERROR: modpost: "__compiletime_assert_531" [arch/x86/kvm/kvm-intel.ko] undefined!
> ERROR: modpost: "__compiletime_assert_532" [arch/x86/kvm/kvm-intel.ko] undefined!
> ERROR: modpost: "__compiletime_assert_530" [arch/x86/kvm/kvm-intel.ko] undefined!
> make[2]: *** [scripts/Makefile.modpost:128: modules-only.symvers] Error 1
> make[1]: *** [Makefile:1753: modules] Error 2
> make[1]: *** Waiting for unfinished jobs....

clang-14 added support for the error and warning attributes, which makes
the BUILD_BUG_ON failures look like GCC. With allmodconfig, this
becomes:

In file included from ../arch/x86/kvm/vmx/vmx.c:61:
In file included from ../arch/x86/kvm/vmx/nested.h:7:
../arch/x86/kvm/vmx/vmx.h:610:1: error: call to __compiletime_assert_1135 declared with 'error' attribute: BUILD_BUG_ON failed: !(val & (KVM_REQ_VMX_VM_ENTRY_CONTROLS | KVM_OPT_VMX_VM_ENTRY_CONTROLS))
BUILD_CONTROLS_SHADOW(vm_entry, VM_ENTRY_CONTROLS, 32)
^
../arch/x86/kvm/vmx/vmx.h:602:2: note: expanded from macro 'BUILD_CONTROLS_SHADOW'
        BUILD_BUG_ON(!(val & (KVM_REQ_VMX_##uname | KVM_OPT_VMX_##uname)));     \
        ^
../include/linux/build_bug.h:50:2: note: expanded from macro 'BUILD_BUG_ON'
        BUILD_BUG_ON_MSG(condition, "BUILD_BUG_ON failed: " #condition)
        ^
../include/linux/build_bug.h:39:37: note: expanded from macro 'BUILD_BUG_ON_MSG'
#define BUILD_BUG_ON_MSG(cond, msg) compiletime_assert(!(cond), msg)
                                    ^
note: (skipping 1 expansions in backtrace; use -fmacro-backtrace-limit=0 to see all)
../include/linux/compiler_types.h:340:2: note: expanded from macro '_compiletime_assert'
        __compiletime_assert(condition, msg, prefix, suffix)
        ^
../include/linux/compiler_types.h:333:4: note: expanded from macro '__compiletime_assert'
                        prefix ## suffix();                             \
                        ^
<scratch space>:259:1: note: expanded from here
__compiletime_assert_1135
^
In file included from ../arch/x86/kvm/vmx/vmx.c:61:
In file included from ../arch/x86/kvm/vmx/nested.h:7:
../arch/x86/kvm/vmx/vmx.h:610:1: error: call to __compiletime_assert_1136 declared with 'error' attribute: BUILD_BUG_ON failed: !(val & (KVM_REQ_VMX_VM_ENTRY_CONTROLS | KVM_OPT_VMX_VM_ENTRY_CONTROLS))
../arch/x86/kvm/vmx/vmx.h:607:2: note: expanded from macro 'BUILD_CONTROLS_SHADOW'
        BUILD_BUG_ON(!(val & (KVM_REQ_VMX_##uname | KVM_OPT_VMX_##uname)));     \
        ^
../include/linux/build_bug.h:50:2: note: expanded from macro 'BUILD_BUG_ON'
        BUILD_BUG_ON_MSG(condition, "BUILD_BUG_ON failed: " #condition)
        ^
../include/linux/build_bug.h:39:37: note: expanded from macro 'BUILD_BUG_ON_MSG'
#define BUILD_BUG_ON_MSG(cond, msg) compiletime_assert(!(cond), msg)
                                    ^
note: (skipping 1 expansions in backtrace; use -fmacro-backtrace-limit=0 to see all)
../include/linux/compiler_types.h:340:2: note: expanded from macro '_compiletime_assert'
        __compiletime_assert(condition, msg, prefix, suffix)
        ^
../include/linux/compiler_types.h:333:4: note: expanded from macro '__compiletime_assert'
                        prefix ## suffix();                             \
                        ^
<scratch space>:10:1: note: expanded from here
__compiletime_assert_1136
^
In file included from ../arch/x86/kvm/vmx/vmx.c:61:
In file included from ../arch/x86/kvm/vmx/nested.h:7:
../arch/x86/kvm/vmx/vmx.h:611:1: error: call to __compiletime_assert_1137 declared with 'error' attribute: BUILD_BUG_ON failed: !(val & (KVM_REQ_VMX_VM_EXIT_CONTROLS | KVM_OPT_VMX_VM_EXIT_CONTROLS))
BUILD_CONTROLS_SHADOW(vm_exit, VM_EXIT_CONTROLS, 32)
^
../arch/x86/kvm/vmx/vmx.h:602:2: note: expanded from macro 'BUILD_CONTROLS_SHADOW'
        BUILD_BUG_ON(!(val & (KVM_REQ_VMX_##uname | KVM_OPT_VMX_##uname)));     \
        ^
../include/linux/build_bug.h:50:2: note: expanded from macro 'BUILD_BUG_ON'
        BUILD_BUG_ON_MSG(condition, "BUILD_BUG_ON failed: " #condition)
        ^
../include/linux/build_bug.h:39:37: note: expanded from macro 'BUILD_BUG_ON_MSG'
#define BUILD_BUG_ON_MSG(cond, msg) compiletime_assert(!(cond), msg)
                                    ^
note: (skipping 1 expansions in backtrace; use -fmacro-backtrace-limit=0 to see all)
../include/linux/compiler_types.h:340:2: note: expanded from macro '_compiletime_assert'
        __compiletime_assert(condition, msg, prefix, suffix)
        ^
../include/linux/compiler_types.h:333:4: note: expanded from macro '__compiletime_assert'
                        prefix ## suffix();                             \
                        ^
<scratch space>:30:1: note: expanded from here
__compiletime_assert_1137
^
In file included from ../arch/x86/kvm/vmx/vmx.c:61:
In file included from ../arch/x86/kvm/vmx/nested.h:7:
../arch/x86/kvm/vmx/vmx.h:611:1: error: call to __compiletime_assert_1138 declared with 'error' attribute: BUILD_BUG_ON failed: !(val & (KVM_REQ_VMX_VM_EXIT_CONTROLS | KVM_OPT_VMX_VM_EXIT_CONTROLS))
../arch/x86/kvm/vmx/vmx.h:607:2: note: expanded from macro 'BUILD_CONTROLS_SHADOW'
        BUILD_BUG_ON(!(val & (KVM_REQ_VMX_##uname | KVM_OPT_VMX_##uname)));     \
        ^
../include/linux/build_bug.h:50:2: note: expanded from macro 'BUILD_BUG_ON'
        BUILD_BUG_ON_MSG(condition, "BUILD_BUG_ON failed: " #condition)
        ^
../include/linux/build_bug.h:39:37: note: expanded from macro 'BUILD_BUG_ON_MSG'
#define BUILD_BUG_ON_MSG(cond, msg) compiletime_assert(!(cond), msg)
                                    ^
note: (skipping 1 expansions in backtrace; use -fmacro-backtrace-limit=0 to see all)
../include/linux/compiler_types.h:340:2: note: expanded from macro '_compiletime_assert'
        __compiletime_assert(condition, msg, prefix, suffix)
        ^
../include/linux/compiler_types.h:333:4: note: expanded from macro '__compiletime_assert'
                        prefix ## suffix();                             \
                        ^
<scratch space>:40:1: note: expanded from here
__compiletime_assert_1138
^
4 errors generated.

As you mentioned in the other comment on this patch, the 'inline'
keyword should be '__always_inline' in the BUILD_CONTROLS_SHADOW macro
and a couple of other functions need it for BUILD_BUG_ON to see the
value all the way through the call chain. The following diff resolves
those errors for me, hopefully it is useful!

Cheers,
Nathan

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 4ce7ed835e06..b97ed63ece56 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -790,7 +790,7 @@ static bool msr_write_intercepted(struct vcpu_vmx *vmx, u32 msr)
 					 MSR_IA32_SPEC_CTRL);
 }
 
-static void clear_atomic_switch_msr_special(struct vcpu_vmx *vmx,
+static __always_inline void clear_atomic_switch_msr_special(struct vcpu_vmx *vmx,
 		unsigned long entry, unsigned long exit)
 {
 	vm_entry_controls_clearbit(vmx, entry);
@@ -848,7 +848,7 @@ static void clear_atomic_switch_msr(struct vcpu_vmx *vmx, unsigned msr)
 	vmcs_write32(VM_EXIT_MSR_LOAD_COUNT, m->host.nr);
 }
 
-static void add_atomic_switch_msr_special(struct vcpu_vmx *vmx,
+static __always_inline void add_atomic_switch_msr_special(struct vcpu_vmx *vmx,
 		unsigned long entry, unsigned long exit,
 		unsigned long guest_val_vmcs, unsigned long host_val_vmcs,
 		u64 guest_val, u64 host_val)
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 758f80c41beb..acefa5b5e1b9 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -597,12 +597,12 @@ static inline u##bits lname##_controls_get(struct vcpu_vmx *vmx)		\
 {										\
 	return __##lname##_controls_get(vmx->loaded_vmcs);			\
 }										\
-static inline void lname##_controls_setbit(struct vcpu_vmx *vmx, u##bits val)	\
+static __always_inline void lname##_controls_setbit(struct vcpu_vmx *vmx, u##bits val)	\
 {										\
 	BUILD_BUG_ON(!(val & (KVM_REQ_VMX_##uname | KVM_OPT_VMX_##uname)));	\
 	lname##_controls_set(vmx, lname##_controls_get(vmx) | val);		\
 }										\
-static inline void lname##_controls_clearbit(struct vcpu_vmx *vmx, u##bits val)	\
+static __always_inline void lname##_controls_clearbit(struct vcpu_vmx *vmx, u##bits val)	\
 {										\
 	BUILD_BUG_ON(!(val & (KVM_REQ_VMX_##uname | KVM_OPT_VMX_##uname)));	\
 	lname##_controls_set(vmx, lname##_controls_get(vmx) & ~val);		\

> > +#else
> > +	#define KVM_REQ_VMX_VM_ENTRY_CONTROLS			\
> > +		__KVM_REQ_VMX_VM_ENTRY_CONTROLS
> > +#endif
> 
> EFER.LMA patch, compile tested only.
> 
> ---
> From: Sean Christopherson <seanjc@google.com>
> Date: Fri, 22 Jul 2022 18:26:21 +0000
> Subject: [PATCH] KVM: VMX: Don't toggle VM_ENTRY_IA32E_MODE for 32-bit
>  kernels/KVM
> 
> Don't toggle VM_ENTRY_IA32E_MODE in 32-bit kernels/KVM and instead bug
> the VM if KVM attempts to run the guest with EFER.LMA=1.  KVM doesn't
> support running 64-bit guests with 32-bit hosts.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/vmx/vmx.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index bff97babf381..8623607e596d 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -2894,10 +2894,15 @@ int vmx_set_efer(struct kvm_vcpu *vcpu, u64 efer)
>  		return 0;
> 
>  	vcpu->arch.efer = efer;
> +#ifdef CONFIG_X86_64
>  	if (efer & EFER_LMA)
>  		vm_entry_controls_setbit(vmx, VM_ENTRY_IA32E_MODE);
>  	else
>  		vm_entry_controls_clearbit(vmx, VM_ENTRY_IA32E_MODE);
> +#else
> +	if (KVM_BUG_ON(efer & EFER_LMA, vcpu->kvm))
> +		return 1;
> +#endif
> 
>  	vmx_setup_uret_msrs(vmx);
>  	return 0;
> 
> base-commit: e22e2665637151a321433b2bb705f5c3b8da40bc
> --
> 
