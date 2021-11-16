Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D9754531FB
	for <lists+kvm@lfdr.de>; Tue, 16 Nov 2021 13:18:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235758AbhKPMVN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Nov 2021 07:21:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232503AbhKPMVK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Nov 2021 07:21:10 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C36EBC061570;
        Tue, 16 Nov 2021 04:18:13 -0800 (PST)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1637065091;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to; bh=y0AnlWyuEUnPajzTCoPH+v+k3YtippXNdn9iPNtWse4=;
        b=Icx3tUY/78DAZIDNkszJcXjq1YUbOEDTdkM+yNboOa+3mAF1iwdCrt43yN+Cz9NGlkIcQQ
        fD7zdRx1elOky6zOPCCbzf1MX4ODvugCo6D1HBZYkw/WbQaDVMwClc2plsCyYCV0kBljcS
        /vmi5KG4ynnilKSx0qR+otoS0RN7oxq8XgHhLvYPyHPZGzxXmT2/J4ydaF5arB52JEtqHi
        0RW81SsDDlNIHBxQwDeLJ0vi2cptEU3uquUlAgtXxS5SXHBHRzKeZsMdzQlat2t3l9a+S/
        x3iX/eD5Fyq27Hu02PQQEZkUlttx/Kum7te8ZFe9lXi0ZK8s1/hI2LGBo6T/0w==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1637065091;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to; bh=y0AnlWyuEUnPajzTCoPH+v+k3YtippXNdn9iPNtWse4=;
        b=mNK5LJ3MxkZ4HBypdr8PI3qB9weR+7G+L9vtJONUY74fpcg70oeB9UkSUld43aiWLZb02a
        Lsdx9ru+5yzSdRAA==
To:     "Liu, Jing2" <jing2.liu@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Nakajima, Jun" <jun.nakajima@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Jing Liu <jing2.liu@linux.intel.com>,
        "seanjc@google.com" <seanjc@google.com>,
        "Cooper, Andrew" <andrew.cooper3@citrix.com>,
        "Liu, Jing2" <jing2.liu@intel.com>,
        "Bae, Chang Seok" <chang.seok.bae@intel.com>
Subject: Re: Thoughts of AMX KVM support based on latest kernel
In-Reply-To: <BYAPR11MB325685AB8E3DFD245846F854A9939@BYAPR11MB3256.namprd11.prod.outlook.com>
Date:   Tue, 16 Nov 2021 13:18:10 +0100
Message-ID: <87k0h85m65.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Jing,

On Wed, Nov 10 2021 at 13:01, Jing2 Liu wrote:
> Triggering of a reallocation request and error handling 
>
> First, we want to avoid weird guest failures at runtime due to (more likely) 
> permission failures of a reallocation request, checking the permissions of the
> vcpu (for the extend features) at kvm_vcpu_ioctl_set_cpuid2() time, when
> QEMU wants to advertise the extended features (e.g. AMX) for the first
> time.

That's the right thing to do. If there is no permission for the guest
granted via the prctl() extension I suggested then exposing AMX should
be rejected.

> We have no idea at vcpu_create() time whether QEMU wants to enable AMX
> or not at that time. If kvm_vcpu_ioctl_set_cpuid2() succeeds, then there is 
> no need to further check permission in reallocation path.

That's correct.

> Upon detection (interception) of an attempt by a vcpu to write to XCR0 (XSETBV)
> and XFD (WRMSR), we check if the write is valid, and we start passthrough of 
> the XFD MSRs if the dynamic feature[i] meets the condition
> XCR0[i]=1 && XFD[i]=0. And we make a reallocation request to the FPU core.  
>
> We simplify the KVM implementation by assuming that the reallocation 
> request was successful when the vcpu comes back to KVM. For such VM exit
> handling that requires a buffer-reallocation request, we don't resume the
> guest immediately. Instead, we go back to the userspace, to rely on the 
> userspace VMM (e.g. QEMU) for handling error cases. The actual reallocation
> happens when control is transferred from KVM to the kernel (FPU core). If 
> no error, QEMU will come back to KVM by repeating vcpu_ioctl_run(). 
>
> Potential failures there are due to lack of memory. But this would not be
> interesting cases; the host should have more resource problems at that 
> time if that is the case.

Indeed.

> One of potential drawbacks of the Option 2 might be additional 
> checks in the host, although we can minimize the impact by having
> CONFIG_KVM_TBD. We believe that the case
> "XFD != 0 and XINUSE != 0" should be very infrequent.

I really don't like the idea of having an extra check in switch_to().

Can we start simple and do something like the uncompiled below and see
how much overhead it creates?

Thanks,

        tglx
---
diff --git a/arch/x86/include/asm/fpu/xstate.h b/arch/x86/include/asm/fpu/xstate.h
index 0f8b90ab18c9..6175a78e0be8 100644
--- a/arch/x86/include/asm/fpu/xstate.h
+++ b/arch/x86/include/asm/fpu/xstate.h
@@ -122,4 +122,12 @@ static __always_inline __pure bool fpu_state_size_dynamic(void)
 }
 #endif
 
+void fpu_update_guest_xfd_state(void);
+
+static inline void kvm_update_guest_xfd_state(void)
+{
+	if (fpu_state_size_dynamic())
+		fpu_update_guest_xfd_state();
+}
+
 #endif
diff --git a/arch/x86/kernel/fpu/core.c b/arch/x86/kernel/fpu/core.c
index 8ea306b1bf8e..161db48c9052 100644
--- a/arch/x86/kernel/fpu/core.c
+++ b/arch/x86/kernel/fpu/core.c
@@ -199,6 +199,17 @@ void fpu_reset_from_exception_fixup(void)
 }
 
 #if IS_ENABLED(CONFIG_KVM)
+void fpu_update_guest_xfd_state(void)
+{
+	u64 xfd;
+
+	/* FIXME: Add debug */
+	rdmsrl(MSR_IA32_XFD, xfd);
+	current->thread.fpu.fpstate->xfd = xfd;
+	__this_cpu_write(xfd_state, xfd);
+}
+EXPORT_SYMBOL_GPL(fpu_update_guest_xfd_state);
+
 static void __fpstate_reset(struct fpstate *fpstate);
 
 bool fpu_alloc_guest_fpstate(struct fpu_guest *gfpu)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 2686f2edb47c..9425fdbb4806 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9576,6 +9576,8 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 	vcpu->arch.last_vmentry_cpu = vcpu->cpu;
 	vcpu->arch.last_guest_tsc = kvm_read_l1_tsc(vcpu, rdtsc());
 
+	kvm_update_guest_xfd_state();
+
 	vcpu->mode = OUTSIDE_GUEST_MODE;
 	smp_wmb();
 


