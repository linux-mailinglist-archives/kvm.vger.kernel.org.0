Return-Path: <kvm+bounces-21849-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id AA7B3934EA1
	for <lists+kvm@lfdr.de>; Thu, 18 Jul 2024 15:59:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 561FB1F21531
	for <lists+kvm@lfdr.de>; Thu, 18 Jul 2024 13:59:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA9DD13FD86;
	Thu, 18 Jul 2024 13:59:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vdsfmwzt"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84E0213E88B
	for <kvm@vger.kernel.org>; Thu, 18 Jul 2024 13:59:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721311161; cv=none; b=MumJDHIUSph+K/8567BzwK+mirUYtjvx1S/Hmf2vcmKFnMTMRaYxNX2ZujzV7b7/gsQUpFXCpIfpCk0co8VRiXdXBpr0mSmTkhTREwo2ULYOhqX82FFh2ESh+vsJsVxWExp38Cq/Q8180XoNloN7sUaR0fK7Uhn4Ij/g7ujzimk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721311161; c=relaxed/simple;
	bh=T8bAsK99/W2j3NZ1VELdAZTOdjS+fYWbu5w670iDhg8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=thK38X1geR0fjMj998oTV7FgYRCG9termnQS+iV4/S8xgpMohD5Au8yeG+bf3EIErcpPINZZi/TOEJ8XG2vYJjXc4sbABb6+5ubI/HsV85tbibktr54v3ZD7dl6p/TOxl3xGTj7F2umOrXtIc5n047tElNAB6XdhuQj/t5VVfV0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=vdsfmwzt; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-1fca868b53cso68575ad.1
        for <kvm@vger.kernel.org>; Thu, 18 Jul 2024 06:59:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1721311159; x=1721915959; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=CUVmMYfxbiF1qMd6LNSBVnSoJ9dOPghzfJiSlpscXu0=;
        b=vdsfmwztIUIdYphYfWGvLpnqWDien4lEnmw1vBb04O6ha9iEHMUST+Smy/gMm3I4yB
         0adcFe6PqhzlCuvSzHuGCtnR4/poZO6gPdIK+sfJfPLer/rLI7b2shX7lxI+e+9RzfH2
         2C+WrTMkRBJ5DOPow0kqKnMwjUoJIR3Kwm8m7ZssezfojMzniY4jkfdvGLpwg3Z3lQSi
         5WDK8+O6XGMoaLDWC1eZKdO63htWORD5wvUSqPubj5xXsk3ZjlyCzFObepvKP11LY6w9
         l8xrvxeD8iAXfVN61AjC5SxNT5ytNZoIbT1t2HoutwkHy2AgYGBEQqgS/fbAA0n0FhCP
         3x9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721311159; x=1721915959;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CUVmMYfxbiF1qMd6LNSBVnSoJ9dOPghzfJiSlpscXu0=;
        b=Lw/6E26TmS1d7DfeWnHxegYBxbi2dMErkIic3AkEZrKRmvMeks+5y9rjxs4oatlkrt
         U0Ab8k06vEoMUXmVsiaft0JJiy/J4vShzM5ebGO4wS72+7qwWasbjQSbqWJXercToEE4
         CQaVfSAart/tsQH05VLfeIIx6J5zTxwC9URykpKPcvTG67jMVQ8z72ZxzqU2JehWCFzB
         uoJ3Zmo651bvH5k1HaHXBjTrNWPhZdFlVkbaG/PekFPatqTvZGTswy2Y+Lkk3VrcyZBd
         xOjY3AtSXuiZUMPdz2nfefzyAQZ3WolKDzLg14HKVKyQaHFxgje0nJb9N+uXLng5NXyf
         ZWTw==
X-Forwarded-Encrypted: i=1; AJvYcCXcxWk5VHhpVYuv3iILuOehn/M8Pk1z+NUVkqKlpWDszZpZdQ6DpkhPG73zrn2lqmilO0i38cFfrjvtxBdsbMFuI5hn
X-Gm-Message-State: AOJu0Yza8DvA2f7Gv4mb5VE6NEm7e5GyvZ6+l4BFmKdLi+QY6kveRUif
	+n8BNiBYw9qQ7ihUKEDAXhqfBTp/7c8qTayRa3c0f1LSy/OWuMAIOl6LH3O7xG4vj9v0/DnUKci
	3bA==
X-Google-Smtp-Source: AGHT+IHT4qxBt2UqkBpDq67/VkzDurpRxyf3IhB2d+KduaJBwouF6xPXKPAFEVZfRpq+CtWXOejhaTdCwxU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:f601:b0:1fb:4b59:d0f5 with SMTP id
 d9443c01a7336-1fc4e10ec8emr673635ad.3.1721311158695; Thu, 18 Jul 2024
 06:59:18 -0700 (PDT)
Date: Thu, 18 Jul 2024 06:59:17 -0700
In-Reply-To: <SA1PR11MB67348CCC02DE80B2DAA4C7A0A8A32@SA1PR11MB6734.namprd11.prod.outlook.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240207172646.3981-1-xin3.li@intel.com> <20240207172646.3981-10-xin3.li@intel.com>
 <ZmoYvcbFBPJ5ARma@google.com> <SA1PR11MB67348BD07CCCF8D52FCAC8FEA8A42@SA1PR11MB6734.namprd11.prod.outlook.com>
 <ZpFH86n_YY5ModwK@google.com> <SA1PR11MB67341A4D3E4D11DAE8AF6D2EA8A62@SA1PR11MB6734.namprd11.prod.outlook.com>
 <ZpFZg-9MTveHfn_4@google.com> <SA1PR11MB67349D5D7B0E26A49B8A1112A8A62@SA1PR11MB6734.namprd11.prod.outlook.com>
 <SA1PR11MB67348CCC02DE80B2DAA4C7A0A8A32@SA1PR11MB6734.namprd11.prod.outlook.com>
Message-ID: <ZpkfkSMPiXrS9r2K@google.com>
Subject: Re: [PATCH v2 09/25] KVM: VMX: Switch FRED RSP0 between host and guest
From: Sean Christopherson <seanjc@google.com>
To: Xin3 Li <xin3.li@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, 
	"linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>, 
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "corbet@lwn.net" <corbet@lwn.net>, 
	"tglx@linutronix.de" <tglx@linutronix.de>, "mingo@redhat.com" <mingo@redhat.com>, "bp@alien8.de" <bp@alien8.de>, 
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "x86@kernel.org" <x86@kernel.org>, 
	"hpa@zytor.com" <hpa@zytor.com>, "shuah@kernel.org" <shuah@kernel.org>, 
	"vkuznets@redhat.com" <vkuznets@redhat.com>, "peterz@infradead.org" <peterz@infradead.org>, 
	Ravi V Shankar <ravi.v.shankar@intel.com>, "xin@zytor.com" <xin@zytor.com>
Content-Type: text/plain; charset="us-ascii"

On Wed, Jul 17, 2024, Xin3 Li wrote:
> > > > > E.g. if it's somewhere in task_struct, then kvm_on_user_return()
> > > > > would restore the current task's desired RSP0.
> > > >
> > > > So you're suggesting to extend the framework to allow per task constants?
> > >
> > > Yeah, or more likely, special case MSR_IA32_FRED_RSP0.  If KVM didn't
> > > already have the user return framework, I wouldn't suggest this as I
> > > doubt avoiding WRMSR when switching between vCPU tasks will be very
> > > meaningful, but it's easy to handle FRED_RSP0, so why not.
> > 
> > Great, I will take the patch.
> 
> I tried to make this work, however because FRED RSP0 is per task and
> keeps changing during context switch[1], we lose track of FRED RSP0
> values from both host and guest,

Ah, right, the host value is volatile.  And MSR_IA32_FRED_RSP0 is passed through
to the guest, so the guest value is volatile/unknown too.

> thus we need to:
> 
> 1) *always* save guest FRED RSP0 in vmx_prepare_switch_to_host().
> 
> 2) *always* restore guest FRED RSP0 in vmx_prepare_switch_to_guest(),
>    because sometimes context switches happen but the CPU does NOT
>    return to user mode thus the user return framework detects no change.
> 
> So it essentially becomes the same as what the original patch does.
> 
> I guess It's probably not worth the change, how do you think?

One idea would be to have the kernel write MSR_IA32_FRED_RSP0 on return to
userspace instead of on context switch.  As is, amusingly, there's no need to
restore the host value if a context switch occurs as the kernel will have written
the new task's value.  RSP0 only needs to be manually restored if the kernel
returns to userspace for the vCPU task.  Using a TI flag to track if RSP0 needs
to be loaded would avoid a fair number of WRMSRs in both KVM and the kernel.

E.g.

diff --git a/arch/x86/include/asm/entry-common.h b/arch/x86/include/asm/entry-common.h
index ce8f50192ae3..76724cc42869 100644
--- a/arch/x86/include/asm/entry-common.h
+++ b/arch/x86/include/asm/entry-common.h
@@ -57,6 +57,11 @@ static inline void arch_exit_to_user_mode_prepare(struct pt_regs *regs,
        if (unlikely(ti_work & _TIF_NEED_FPU_LOAD))
                switch_fpu_return();
 
+       if (cpu_feature_enabled(X86_FEATURE_FRED) &&
+           (ti_work & _TIF_NEED_RSP0_LOAD))
+               wrmsrns(MSR_IA32_FRED_RSP0,
+                       (unsigned long)task_stack_page(current) + THREAD_SIZE);
+
 #ifdef CONFIG_COMPAT
        /*
         * Compat syscalls set TS_COMPAT.  Make sure we clear it before
diff --git a/arch/x86/include/asm/switch_to.h b/arch/x86/include/asm/switch_to.h
index c3bd0c0758c9..1674d98a8850 100644
--- a/arch/x86/include/asm/switch_to.h
+++ b/arch/x86/include/asm/switch_to.h
@@ -71,8 +71,7 @@ static inline void update_task_stack(struct task_struct *task)
        this_cpu_write(cpu_tss_rw.x86_tss.sp1, task->thread.sp0);
 #else
        if (cpu_feature_enabled(X86_FEATURE_FRED)) {
-               /* WRMSRNS is a baseline feature for FRED. */
-               wrmsrns(MSR_IA32_FRED_RSP0, (unsigned long)task_stack_page(task) + THREAD_SIZE);
+               set_thread_flag(TIF_NEED_RSP0_LOAD);
        } else if (cpu_feature_enabled(X86_FEATURE_XENPV)) {
                /* Xen PV enters the kernel on the thread stack. */
                load_sp0(task_top_of_stack(task));
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 5c6bb26463e8..cb7e3bcb001f 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1338,15 +1338,9 @@ void vmx_prepare_switch_to_guest(struct kvm_vcpu *vcpu)
 
        wrmsrl(MSR_KERNEL_GS_BASE, vmx->msr_guest_kernel_gs_base);
 
-       if (guest_can_use(vcpu, X86_FEATURE_FRED)) {
-               /*
-                * MSR_IA32_FRED_RSP0 is top of task stack, which never changes.
-                * Thus it should be initialized only once.
-                */
-               if (unlikely(vmx->msr_host_fred_rsp0 == 0))
-                       vmx->msr_host_fred_rsp0 = read_msr(MSR_IA32_FRED_RSP0);
-               wrmsrl(MSR_IA32_FRED_RSP0, vmx->msr_guest_fred_rsp0);
-       }
+       if (cpu_feature_enabled(X86_FEATURE_FRED) &&
+           guest_can_use(vcpu, X86_FEATURE_FRED))
+               wrmsrns(MSR_IA32_FRED_RSP0, vmx->msr_guest_fred_rsp0);
 #else
        savesegment(fs, fs_sel);
        savesegment(gs, gs_sel);
@@ -1392,9 +1386,10 @@ static void vmx_prepare_switch_to_host(struct vcpu_vmx *vmx)
 #ifdef CONFIG_X86_64
        wrmsrl(MSR_KERNEL_GS_BASE, vmx->msr_host_kernel_gs_base);
 
-       if (guest_can_use(&vmx->vcpu, X86_FEATURE_FRED)) {
+       if (cpu_feature_enabled(X86_FEATURE_FRED) &&
+           guest_can_use(&vmx->vcpu, X86_FEATURE_FRED)) {
                vmx->msr_guest_fred_rsp0 = read_msr(MSR_IA32_FRED_RSP0);
-               wrmsrl(MSR_IA32_FRED_RSP0, vmx->msr_host_fred_rsp0);
+               set_thread_flag(TIF_NEED_RSP0_LOAD);
        }
 #endif
        load_fixmap_gdt(raw_smp_processor_id());

