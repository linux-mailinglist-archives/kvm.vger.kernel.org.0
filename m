Return-Path: <kvm+bounces-46992-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 54B34ABC2AD
	for <lists+kvm@lfdr.de>; Mon, 19 May 2025 17:39:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B972616044D
	for <lists+kvm@lfdr.de>; Mon, 19 May 2025 15:39:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 934AD28642D;
	Mon, 19 May 2025 15:39:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="FYX5hZEM"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7A5A283FFC
	for <kvm@vger.kernel.org>; Mon, 19 May 2025 15:39:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747669146; cv=none; b=tl/Ha+HhhxwJMKK4cIZ0HYkQnlLrqtuxSps6dZGVQHnsDbxJmcyN5fp3m3zHhTIuYw1+ieo6tzqErH79ctrlcnEkFkXyXTLpsNUuqdh5Jc+uo8JKMgBXVB/NR4d5xu1YdQSKxechneqDohBjK5ZvwUkRCVAD6fJJbpk0BNCuMfE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747669146; c=relaxed/simple;
	bh=RkiTEaTgsDKZS1LMzYtSUiwJJoAkW85IpypuMzS8fh0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Ax/7N4t2volIfnUAszypr9tdbII97ddatr8x92ht4tfjo0A0Qhxnd6bURPuuM8BWct3YrZRV57zihCU1mt/Sx9b51vNTjHZQpmy9dhYu7RIOQZXgl+TQQfc8evtAdzVVkZvv4nhA/OQ5RSkxdskLGQlSsYIvOSGsf77FD1BOFY4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=FYX5hZEM; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-232054aa634so16938485ad.3
        for <kvm@vger.kernel.org>; Mon, 19 May 2025 08:39:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747669143; x=1748273943; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=1QdhIevUckRM85Eul7weCGqK25Pk22Hqm4bxUt5Zutk=;
        b=FYX5hZEMfxWiM1Yx/XiGBh7PUbXGLMy3RbRTfyb+wZlAeFE+nFvesXeUp3IH8fjX9B
         EbbKYUyWLBmuTQMn07IGAMdJ4vu3QCeAljQ7wDdHcdzJ0U7rxfZGSVOfHift4YSKTx0U
         DmE2mlq2+bOzbiMhcyiboKlsfx/7pEsKijOHqX0xcPyRyS6gGrti6LHck/mcTCtQu/Fe
         +mQB+ijiDk8R/7ALEiTKUZ7tQ0yUVaWPYtzVdH/mZGbv//Tdh0+psULB+xiRuzEVwGeG
         zTS84RCZ71AzfuXHgahp9JScenHQ5XaiylR66zi2zPs9qMRprfuiOBx46VKtm0pKUOPK
         zqbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747669143; x=1748273943;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1QdhIevUckRM85Eul7weCGqK25Pk22Hqm4bxUt5Zutk=;
        b=ExXMazCXdMlgRQhfHblKnO73Edj8xH7VkWHQlGh4mUd3ozGBojQl15JAaCkF/08FGm
         frW2svDiM4X/EmMRs7hnyDj1VlOF3Jzr2dvYizPX2DHqaULTeXxMR7U7sHYMtNVGZ1qE
         Q0cgOVfrayIXppcTQn/65OESavLphOpUOiO999UX9EocP3FDCvngQ8o5nltCNa99t9Ry
         5NzkYumFAYU2VuT526oUMo04U1u2ni0RgtOeNiOMSEmhOzWSbWdH1ADTp2ONa1fx4s1V
         alFadS7UjlknzHJsPVCSfjiENJEwLMMC7ZbQ8Cr/Be/DScm0iiYRceDhwbAnbk9qSDJm
         mtEQ==
X-Gm-Message-State: AOJu0YxOveexa8yXUebUn5Le9Nz83tfhpJRk7krdiOWQODaA8nv2dB5Y
	BjfsUjKFikXYY7qpaCKLqKo52Qpcsw8Khdl0xxCy0eEma7HgMXc9XaMzP1OVDj11zz0hPeVnJQ3
	hfVVVDw==
X-Google-Smtp-Source: AGHT+IEyqfPKnawqbuXKFepZP285ulA/QK6RDEu1gwwb0LyeFW4qWKWMIH8ZiO/mqNoKhEj601dDIn5Fxdg=
X-Received: from plbcp12.prod.google.com ([2002:a17:902:e78c:b0:231:cb69:764d])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:ef4e:b0:21f:45d:21fb
 with SMTP id d9443c01a7336-231de2e962cmr147708915ad.3.1747669142994; Mon, 19
 May 2025 08:39:02 -0700 (PDT)
Date: Mon, 19 May 2025 08:39:01 -0700
In-Reply-To: <219b6bd5-9afe-4d1c-aaab-03e5c580ce5c@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250516215422.2550669-1-seanjc@google.com> <20250516215422.2550669-3-seanjc@google.com>
 <219b6bd5-9afe-4d1c-aaab-03e5c580ce5c@redhat.com>
Message-ID: <aCtQlanun-Kaq4NY@google.com>
Subject: Re: [PATCH v3 2/3] KVM: x86: Use kvzalloc() to allocate VM struct
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Vipin Sharma <vipinsh@google.com>
Content-Type: text/plain; charset="us-ascii"

On Sat, May 17, 2025, Paolo Bonzini wrote:
> On 5/16/25 23:54, Sean Christopherson wrote:
> > diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> > index 0ad1a6d4fb6d..d13e475c3407 100644
> > --- a/arch/x86/kvm/svm/svm.c
> > +++ b/arch/x86/kvm/svm/svm.c
> > @@ -5675,6 +5675,8 @@ static int __init svm_init(void)
> >   {
> >   	int r;
> > +	KVM_SANITY_CHECK_VM_STRUCT_SIZE(kvm_svm);
> > +
> >   	__unused_size_checks();
> >   	if (!kvm_is_svm_supported())
> > diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
> > index d1e02e567b57..e18dfada2e90 100644
> > --- a/arch/x86/kvm/vmx/main.c
> > +++ b/arch/x86/kvm/vmx/main.c
> > @@ -64,6 +64,8 @@ static __init int vt_hardware_setup(void)
> >   		vt_x86_ops.protected_apic_has_interrupt = tdx_protected_apic_has_interrupt;
> >   	}
> > +	KVM_SANITY_CHECK_VM_STRUCT_SIZE(kvm_tdx);
> 
> I would put either both or no checks in main.c.

Yeah, I agree the current split is ugly.  I originally had 'em both in main.c,
but then the assert effectively becomes dependent on CONFIG_KVM_INTEL_TDX=y.

Aha!  If we add a proper tdx_hardware_setup(), then there's a convenient location
for the assert, IMO it's much easier to see/document the "TDX module not loaded"
behavior, and the TDX-specific kvm_x86_ops hooks don't need to be visible symbols.

I'll slot the below in, unless you've got a better idea.

> Or if you use static_assert, you can also place the macro invocation close
> to the struct definition.

Already tried that, get_order() doesn't play nice with static_assert :-/

--
From: Sean Christopherson <seanjc@google.com>
Date: Mon, 19 May 2025 07:15:27 -0700
Subject: [PATCH] KVM: TDX: Move TDX hardware setup from main.c to tdx.c

Move TDX hardware setup to tdx.c, as the code is obviously TDX specific,
co-locating the setup with tdx_bringup() makes it easier to see and
document the success_disable_tdx "error" path, and configuring the TDX
specific hooks in tdx.c reduces the number of globally visible TDX symbols.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/main.c    | 36 ++---------------------------
 arch/x86/kvm/vmx/tdx.c     | 46 +++++++++++++++++++++++++++-----------
 arch/x86/kvm/vmx/tdx.h     |  1 +
 arch/x86/kvm/vmx/x86_ops.h | 10 ---------
 4 files changed, 36 insertions(+), 57 deletions(-)

diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index d1e02e567b57..d7178d15ac8f 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -29,40 +29,8 @@ static __init int vt_hardware_setup(void)
 	if (ret)
 		return ret;
 
-	/*
-	 * Update vt_x86_ops::vm_size here so it is ready before
-	 * kvm_ops_update() is called in kvm_x86_vendor_init().
-	 *
-	 * Note, the actual bringing up of TDX must be done after
-	 * kvm_ops_update() because enabling TDX requires enabling
-	 * hardware virtualization first, i.e., all online CPUs must
-	 * be in post-VMXON state.  This means the @vm_size here
-	 * may be updated to TDX's size but TDX may fail to enable
-	 * at later time.
-	 *
-	 * The VMX/VT code could update kvm_x86_ops::vm_size again
-	 * after bringing up TDX, but this would require exporting
-	 * either kvm_x86_ops or kvm_ops_update() from the base KVM
-	 * module, which looks overkill.  Anyway, the worst case here
-	 * is KVM may allocate couple of more bytes than needed for
-	 * each VM.
-	 */
-	if (enable_tdx) {
-		vt_x86_ops.vm_size = max_t(unsigned int, vt_x86_ops.vm_size,
-				sizeof(struct kvm_tdx));
-		/*
-		 * Note, TDX may fail to initialize in a later time in
-		 * vt_init(), in which case it is not necessary to setup
-		 * those callbacks.  But making them valid here even
-		 * when TDX fails to init later is fine because those
-		 * callbacks won't be called if the VM isn't TDX guest.
-		 */
-		vt_x86_ops.link_external_spt = tdx_sept_link_private_spt;
-		vt_x86_ops.set_external_spte = tdx_sept_set_private_spte;
-		vt_x86_ops.free_external_spt = tdx_sept_free_private_spt;
-		vt_x86_ops.remove_external_spte = tdx_sept_remove_private_spte;
-		vt_x86_ops.protected_apic_has_interrupt = tdx_protected_apic_has_interrupt;
-	}
+	if (enable_tdx)
+		tdx_hardware_setup();
 
 	return 0;
 }
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index b952bc673271..b4985a64501c 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -738,7 +738,7 @@ bool tdx_interrupt_allowed(struct kvm_vcpu *vcpu)
 	       !to_tdx(vcpu)->vp_enter_args.r12;
 }
 
-bool tdx_protected_apic_has_interrupt(struct kvm_vcpu *vcpu)
+static bool tdx_protected_apic_has_interrupt(struct kvm_vcpu *vcpu)
 {
 	u64 vcpu_state_details;
 
@@ -1543,8 +1543,8 @@ static int tdx_mem_page_record_premap_cnt(struct kvm *kvm, gfn_t gfn,
 	return 0;
 }
 
-int tdx_sept_set_private_spte(struct kvm *kvm, gfn_t gfn,
-			      enum pg_level level, kvm_pfn_t pfn)
+static int tdx_sept_set_private_spte(struct kvm *kvm, gfn_t gfn,
+				     enum pg_level level, kvm_pfn_t pfn)
 {
 	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
 	struct page *page = pfn_to_page(pfn);
@@ -1624,8 +1624,8 @@ static int tdx_sept_drop_private_spte(struct kvm *kvm, gfn_t gfn,
 	return 0;
 }
 
-int tdx_sept_link_private_spt(struct kvm *kvm, gfn_t gfn,
-			      enum pg_level level, void *private_spt)
+static int tdx_sept_link_private_spt(struct kvm *kvm, gfn_t gfn,
+				     enum pg_level level, void *private_spt)
 {
 	int tdx_level = pg_level_to_tdx_sept_level(level);
 	gpa_t gpa = gfn_to_gpa(gfn);
@@ -1760,8 +1760,8 @@ static void tdx_track(struct kvm *kvm)
 	kvm_make_all_cpus_request(kvm, KVM_REQ_OUTSIDE_GUEST_MODE);
 }
 
-int tdx_sept_free_private_spt(struct kvm *kvm, gfn_t gfn,
-			      enum pg_level level, void *private_spt)
+static int tdx_sept_free_private_spt(struct kvm *kvm, gfn_t gfn,
+				     enum pg_level level, void *private_spt)
 {
 	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
 
@@ -1783,8 +1783,8 @@ int tdx_sept_free_private_spt(struct kvm *kvm, gfn_t gfn,
 	return tdx_reclaim_page(virt_to_page(private_spt));
 }
 
-int tdx_sept_remove_private_spte(struct kvm *kvm, gfn_t gfn,
-				 enum pg_level level, kvm_pfn_t pfn)
+static int tdx_sept_remove_private_spte(struct kvm *kvm, gfn_t gfn,
+					enum pg_level level, kvm_pfn_t pfn)
 {
 	struct page *page = pfn_to_page(pfn);
 	int ret;
@@ -3507,10 +3507,14 @@ int __init tdx_bringup(void)
 	r = __tdx_bringup();
 	if (r) {
 		/*
-		 * Disable TDX only but don't fail to load module if
-		 * the TDX module could not be loaded.  No need to print
-		 * message saying "module is not loaded" because it was
-		 * printed when the first SEAMCALL failed.
+		 * Disable TDX only but don't fail to load module if the TDX
+		 * module could not be loaded.  No need to print message saying
+		 * "module is not loaded" because it was printed when the first
+		 * SEAMCALL failed.  Don't bother unwinding the S-EPT hooks or
+		 * vm_size, as kvm_x86_ops have already been finalized (and are
+		 * intentionally not exported).  The S-EPT code is unreachable,
+		 * and allocating a few more bytes per VM in a should-be-rare
+		 * failure scenario is a non-issue.
 		 */
 		if (r == -ENODEV)
 			goto success_disable_tdx;
@@ -3524,3 +3528,19 @@ int __init tdx_bringup(void)
 	enable_tdx = 0;
 	return 0;
 }
+
+
+void __init tdx_hardware_setup(void)
+{
+	/*
+	 * Note, if the TDX module can't be loaded, KVM TDX support will be
+	 * disabled but KVM will continue loading (see tdx_bringup()).
+	 */
+	vt_x86_ops.vm_size = max_t(unsigned int, vt_x86_ops.vm_size, sizeof(struct kvm_tdx));
+
+	vt_x86_ops.link_external_spt = tdx_sept_link_private_spt;
+	vt_x86_ops.set_external_spte = tdx_sept_set_private_spte;
+	vt_x86_ops.free_external_spt = tdx_sept_free_private_spt;
+	vt_x86_ops.remove_external_spte = tdx_sept_remove_private_spte;
+	vt_x86_ops.protected_apic_has_interrupt = tdx_protected_apic_has_interrupt;
+}
diff --git a/arch/x86/kvm/vmx/tdx.h b/arch/x86/kvm/vmx/tdx.h
index 51f98443e8a2..ca39a9391db1 100644
--- a/arch/x86/kvm/vmx/tdx.h
+++ b/arch/x86/kvm/vmx/tdx.h
@@ -8,6 +8,7 @@
 #ifdef CONFIG_KVM_INTEL_TDX
 #include "common.h"
 
+void tdx_hardware_setup(void);
 int tdx_bringup(void);
 void tdx_cleanup(void);
 
diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
index b4596f651232..87e855276a88 100644
--- a/arch/x86/kvm/vmx/x86_ops.h
+++ b/arch/x86/kvm/vmx/x86_ops.h
@@ -136,7 +136,6 @@ int tdx_vcpu_pre_run(struct kvm_vcpu *vcpu);
 fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu, bool force_immediate_exit);
 void tdx_prepare_switch_to_guest(struct kvm_vcpu *vcpu);
 void tdx_vcpu_put(struct kvm_vcpu *vcpu);
-bool tdx_protected_apic_has_interrupt(struct kvm_vcpu *vcpu);
 int tdx_handle_exit(struct kvm_vcpu *vcpu,
 		enum exit_fastpath_completion fastpath);
 
@@ -151,15 +150,6 @@ int tdx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr);
 
 int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp);
 
-int tdx_sept_link_private_spt(struct kvm *kvm, gfn_t gfn,
-			      enum pg_level level, void *private_spt);
-int tdx_sept_free_private_spt(struct kvm *kvm, gfn_t gfn,
-			      enum pg_level level, void *private_spt);
-int tdx_sept_set_private_spte(struct kvm *kvm, gfn_t gfn,
-			      enum pg_level level, kvm_pfn_t pfn);
-int tdx_sept_remove_private_spte(struct kvm *kvm, gfn_t gfn,
-				 enum pg_level level, kvm_pfn_t pfn);
-
 void tdx_flush_tlb_current(struct kvm_vcpu *vcpu);
 void tdx_flush_tlb_all(struct kvm_vcpu *vcpu);
 void tdx_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa, int root_level);

base-commit: 7ef51a41466bc846ad794d505e2e34ff97157f7f
--

