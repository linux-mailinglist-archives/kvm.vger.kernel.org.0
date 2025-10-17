Return-Path: <kvm+bounces-60336-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 85611BEA143
	for <lists+kvm@lfdr.de>; Fri, 17 Oct 2025 17:43:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id E29C75879FA
	for <lists+kvm@lfdr.de>; Fri, 17 Oct 2025 15:27:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1F7EE2F12C5;
	Fri, 17 Oct 2025 15:27:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="YFlb0FRW"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B18903BB5A
	for <kvm@vger.kernel.org>; Fri, 17 Oct 2025 15:27:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760714846; cv=none; b=PoHrl9TdCs+0G2F/HAP99Dqa8qgDNwrZzUzkut/kfRiCGWJW8U1FQcy61Hg5SeLCLjo6up0i4UeQHvK4jT5fo+3vPll9fY8+GoPs7rLjUarmYBuwBpigCz/BwZOuJXm10uxxSDl1rwyjL5kLX3+Fphs61TTeogsLa/sRH/0tma8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760714846; c=relaxed/simple;
	bh=3aZ/p1HpFYU923O5p/q4vA96EIt39CRccY3dgGPfSyc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=hqmqe7sOlr7AkFmdjJXYiaocArZSqEl+zpuXOBLEU8vMq+9aNCGiTpxZmg0XahNCrZ0/2/KU30CQgT1ghRnay6Ar4G8u4hQRpMWpazNS8IvvuCxaRdjDj1b4TOFsnPH0wG+5FfB3jJ+H2KaMdIPzHqOd258L2xJxJiXqj5pNFTY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=YFlb0FRW; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-272b7bdf41fso27739515ad.0
        for <kvm@vger.kernel.org>; Fri, 17 Oct 2025 08:27:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760714844; x=1761319644; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ss/8g+etyv1zIY4NyclRxI5mt3qeT/bquVhBLMxoBys=;
        b=YFlb0FRWdjxGG4URhU2n56aqJjJ5Mvrw9BaFsiJrXzopsg8VKEQhi28W8PP45uRcbX
         tlQUaKn2YIC52l24s0njKwRJWDRfViGiLYUNHuYGggDKYKdfpMncxThOOKHuXBB2SavO
         EWFTIlOP1sgkFtUq4UqbGVOXfZx5KfQFuFcCIt4PDqOstR22YTtu7s67YGRfKXAYx/wl
         aSFbzBX/qLpwNNxkApbvopOmvMBJcP3v+X1RxFggHek5r68j4t2uNnxRe6y1T9KrjjY5
         2cM7zA4JCb9KwC2ewPFEXjmlVnAxzC5rqouqcSl788JXnWdfHMMFVbOMCwkDKqfVDlWA
         T9ZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760714844; x=1761319644;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ss/8g+etyv1zIY4NyclRxI5mt3qeT/bquVhBLMxoBys=;
        b=sfvxVcuTgMOA2K++lnGeDZxQmdwUvhDtwp3gm29Y6L2eV1xj+rydeuGiYhCCuFg8M5
         9+O+DEbPdkyL6/cbLoP5YEmwdkHOP7IZnM0I7ieB7bt7iksHLonc/8HsePDW5Q9q6HpI
         CjuyQ5nEUqYS+eTequKA63TD8sM6viBFuQex6a2f+nlpkIXKpf8L5UXlru1dt4eM3yGo
         84IgwE6oHfqENy/E/Il5PY0uU17eAJW/0L3aaUzlPbA4tkvXDNxKtuK5J3qNJO5M2FTW
         DIZ+SY8GyjaVmdKFxoVrWIfiNGWBplmR3jIpApCH5K1NO8gFaxL7LPKOVxznF/2P/zma
         PnLw==
X-Forwarded-Encrypted: i=1; AJvYcCW3KfVvG3UqxAXMt3x96ig8KXv/UlJHSjoOQBO1U0BpU+9eeiklVlKw8XDsbzrNEf6OY8k=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzcc04DzKHQDxW7oW1U8AZTTB3D1ARMZtFf3eX4ezNr5K0r4TN1
	U+EGA3qd989gvvzadCooCKLGEnURsKNfxfOEI2SeCKAAc+w62cUBCeoIhFkWHvtxybka//9Uv95
	4HbrUKw==
X-Google-Smtp-Source: AGHT+IGU12bTnRG/I4W0jIR1RxuzbBA+lTiUxcvs3Lm7U4yONDzuiQ14vzbiGb18p1Twgo/9xWWrXrqIhvA=
X-Received: from plrd20.prod.google.com ([2002:a17:902:aa94:b0:24c:7ef0:65c3])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:f78b:b0:290:ab61:6a4f
 with SMTP id d9443c01a7336-290c9cb367fmr42913425ad.15.1760714844098; Fri, 17
 Oct 2025 08:27:24 -0700 (PDT)
Date: Fri, 17 Oct 2025 08:27:22 -0700
In-Reply-To: <aPHU+RZKwCK0BK7t@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251016222816.141523-1-seanjc@google.com> <20251016222816.141523-3-seanjc@google.com>
 <aPHU+RZKwCK0BK7t@intel.com>
Message-ID: <aPJgWhywMXZdiyU5@google.com>
Subject: Re: [PATCH v4 2/4] KVM: x86: Leave user-return notifier registered on reboot/shutdown
From: Sean Christopherson <seanjc@google.com>
To: Chao Gao <chao.gao@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, "Kirill A. Shutemov" <kas@kernel.org>, kvm@vger.kernel.org, 
	x86@kernel.org, linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org, 
	Yan Zhao <yan.y.zhao@intel.com>, Xiaoyao Li <xiaoyao.li@intel.com>, 
	Rick Edgecombe <rick.p.edgecombe@intel.com>, Hou Wenlong <houwenlong.hwl@antgroup.com>
Content-Type: text/plain; charset="us-ascii"

On Fri, Oct 17, 2025, Chao Gao wrote:
> > bool kvm_vcpu_is_reset_bsp(struct kvm_vcpu *vcpu)
> >@@ -14363,6 +14377,11 @@ module_init(kvm_x86_init);
> > 
> > static void __exit kvm_x86_exit(void)
> > {
> >+	int cpu;
> >+
> >+	for_each_possible_cpu(cpu)
> >+		WARN_ON_ONCE(per_cpu_ptr(user_return_msrs, cpu)->registered);
> 
> Is it OK to reference user_return_msrs during kvm.ko unloading? IIUC,
> user_return_msrs has already been freed during kvm-{intel,amd}.ko unloading.
> See:
> 
> vmx_exit/svm_exit()
>   -> kvm_x86_vendor_exit()
>        -> free_percpu(user_return_msrs);

Ouch.  Guess who didn't run with KASAN...

And rather than squeezing the WARN into this patch, I'm strongly leaning toward
adding it in a prep patch, as the WARN is valuable irrespective of how KVM handles
reboot.

Not yet tested...

--
From: Sean Christopherson <seanjc@google.com>
Date: Fri, 17 Oct 2025 06:10:30 -0700
Subject: [PATCH 2/5] KVM: x86: WARN if user-return MSR notifier is registered
 on exit

When freeing the per-CPU user-return MSRs structures, WARN if any CPU has
a registered notifier to help detect and/or debug potential use-after-free
issues.  The lifecycle of the notifiers is rather convoluted, and has
several non-obvious paths where notifiers are unregistered, i.e. isn't
exactly the most robust code possible.

The notifiers they are registered on-demand in KVM, on the first WRMSR to
a tracked register.  _Usually_ the notifier is unregistered whenever the
CPU returns to userspace.  But because any given CPU isn't guaranteed to
return to userspace, e.g. the CPU could be offlined before doing so, KVM
also "drops", a.k.a. unregisters, the notifiers when virtualization is
disabled on the CPU.

Further complicating the unregister path is the fact that the calls to
disable virtualization come from common KVM, and the per-CPU calls are
guarded by a per-CPU flag (to harden _that_ code against bugs, e.g. due to
mishandling reboot).  Reboot/shutdown in particular is problematic, as KVM
disables virtualization via IPI function call, i.e. from IRQ context,
instead of using the cpuhp framework, which runs in task context.  I.e. on
reboot/shutdown, drop_user_return_notifiers() is called asynchronously.

Forced reboot/shutdown is the most problematic scenario, as userspace tasks
are not frozen before kvm_shutdown() is invoked, i.e. KVM could be actively
manipulating the user-return MSR lists and/or notifiers when the IPI
arrives.  To a certain extent, all bets are off when userspace forces a
reboot/shutdown, but KVM should at least avoid a use-after-free, e.g. to
avoid crashing the kernel when trying to reboot.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 33 +++++++++++++++++++++++++--------
 1 file changed, 25 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index b4b5d2d09634..334a911b36c5 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -575,6 +575,27 @@ static inline void kvm_async_pf_hash_reset(struct kvm_vcpu *vcpu)
 		vcpu->arch.apf.gfns[i] = ~0;
 }
 
+static int kvm_init_user_return_msrs(void)
+{
+	user_return_msrs = alloc_percpu(struct kvm_user_return_msrs);
+	if (!user_return_msrs) {
+		pr_err("failed to allocate percpu user_return_msrs\n");
+		return -ENOMEM;
+	}
+	kvm_nr_uret_msrs = 0;
+	return 0;
+}
+
+static void kvm_free_user_return_msrs(void)
+{
+	int cpu;
+
+	for_each_possible_cpu(cpu)
+		WARN_ON_ONCE(per_cpu_ptr(user_return_msrs, cpu)->registered);
+
+	free_percpu(user_return_msrs);
+}
+
 static void kvm_on_user_return(struct user_return_notifier *urn)
 {
 	unsigned slot;
@@ -10032,13 +10053,9 @@ int kvm_x86_vendor_init(struct kvm_x86_init_ops *ops)
 		return -ENOMEM;
 	}
 
-	user_return_msrs = alloc_percpu(struct kvm_user_return_msrs);
-	if (!user_return_msrs) {
-		pr_err("failed to allocate percpu kvm_user_return_msrs\n");
-		r = -ENOMEM;
+	r = kvm_init_user_return_msrs();
+	if (r)
 		goto out_free_x86_emulator_cache;
-	}
-	kvm_nr_uret_msrs = 0;
 
 	r = kvm_mmu_vendor_module_init();
 	if (r)
@@ -10141,7 +10158,7 @@ int kvm_x86_vendor_init(struct kvm_x86_init_ops *ops)
 out_mmu_exit:
 	kvm_mmu_vendor_module_exit();
 out_free_percpu:
-	free_percpu(user_return_msrs);
+	kvm_free_user_return_msrs();
 out_free_x86_emulator_cache:
 	kmem_cache_destroy(x86_emulator_cache);
 	return r;
@@ -10170,7 +10187,7 @@ void kvm_x86_vendor_exit(void)
 #endif
 	kvm_x86_call(hardware_unsetup)();
 	kvm_mmu_vendor_module_exit();
-	free_percpu(user_return_msrs);
+	kvm_free_user_return_msrs();
 	kmem_cache_destroy(x86_emulator_cache);
 #ifdef CONFIG_KVM_XEN
 	static_key_deferred_flush(&kvm_xen_enabled);
-- 

