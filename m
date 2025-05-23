Return-Path: <kvm+bounces-47446-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2CE8FAC18E5
	for <lists+kvm@lfdr.de>; Fri, 23 May 2025 02:12:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id ADE881890E9E
	for <lists+kvm@lfdr.de>; Fri, 23 May 2025 00:12:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 37002BA49;
	Fri, 23 May 2025 00:11:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Bdw99PL1"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D43307E9
	for <kvm@vger.kernel.org>; Fri, 23 May 2025 00:11:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747959105; cv=none; b=IrWCr7msO/XKh3fhTjt/pCp+qByl2nI9f5ggpwhYytnHp5H1Mwj9rlQPnjYggmUreuIFL77QshOA6qaK8xFhO7zTH+3nx375z+nJmrLSALYBmb+HETh+YgaM4/ufh6QGcdfI0e4HLTvTnrYpHCIwfa9UZc3SR/fBJPEo0xedDCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747959105; c=relaxed/simple;
	bh=G0RDgBaetD99CnRPKH6iyJ3zEre2Mdnla3R/SEbQaoQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Vv+0ZU1DIdVnRp919SQDB3OYF1PZ12xIuV+Iyc2oFQk2akTdZqO6/FwaSr17qu53lGit0eU9+Pu/MfryUiQ9Wd69gn6gFUZw539vm4XLSE3MwrliT9xuaOsi9dpXOSYsxTbSH2sRuVGFcODsysGS4fZ3UUnCqixzdlRBNfw1DTg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Bdw99PL1; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-30e9e81d4b0so8195714a91.3
        for <kvm@vger.kernel.org>; Thu, 22 May 2025 17:11:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747959103; x=1748563903; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=ZTz7h4GlYFASCSDvq3MGwO0zKatp0Zx+JK9Pkw18hXA=;
        b=Bdw99PL1di+5L3Ufh//gKcfPS8ryxnSdM9elOPZZQy9GxO/26yMKq8Q1FQlxYkqgfX
         s/kMbAysf1hx9NNJMv/hr00QGTmkUKd1x1ZVgB+P1gYoavZ5g/MG8mIuwCQHOzrbKaTG
         DHIytBlR1EpelOZtaCzKWH6ByUedMa8spHbPTbEfB/OYWhNEqD3xglFuInp4zxdppP1c
         Df+6w/xYewI6WsayCBsbGskfBj/TM7waHDGP3XH1snY49786+YAridr9T1A+aWrfdGuA
         dtM1ZZg7tk1ClsLWX142ERXWBFA+PiG3xxHcmLn3fnajO+02U+QOB5L6ZCi9lEufZAog
         R2qA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747959103; x=1748563903;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZTz7h4GlYFASCSDvq3MGwO0zKatp0Zx+JK9Pkw18hXA=;
        b=klbzi7PKyB2lMpIPz5mxf4KzgvOdn1JVf0bcBUYsttIoO+ocLEtlRmd2B/7iIxeUyd
         CLY94ubMhSTGIVgg37qUYOWK+nz63uH0OYTFt5v8VQlhyucZ27H+2CT5GlojqDumFNLH
         D+kwlvy7SPAjYlEX6w6HiwjptmL62kqtT9oz5kuzKzrl46Gg0JNiOecMAe7J2N4smZLb
         vMoaWyxuuKJkrkc01Ri8XK2Ajoth4t3qGLhxvzzIAiMQkEbHy6TarVSahioD2PyuVphg
         ahaoBfdEk1Om1VPeykY3wrC55X4usslmVBbRyrK2WwSaRIC3uMYaBg4sGEuIX1KpBmkK
         GNxw==
X-Gm-Message-State: AOJu0YzzEtyTbzA8AHd105Ri4WtmMrR3Pbt90T2Tgdw1uSqgvbYns/53
	8VOzvHSpixuWElBSV722lExkLoeu3OlcWs+EYW+Otjs9Rzey0TFcFYA4c0K5aTaxDygPCxmXlhA
	g7E6arg==
X-Google-Smtp-Source: AGHT+IHONfSPdCJFXkshmuSt+zEMD7DSeSIrKIz/GIuk8D7dE7BGyxB9Vk9j/E/m1jYUQkiFGIU9BvhAhWs=
X-Received: from pjbpt18.prod.google.com ([2002:a17:90b:3d12:b0:2ff:6e58:8a0a])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3684:b0:310:ca8f:18d3
 with SMTP id 98e67ed59e1d1-310ca8f18e2mr5191236a91.17.1747959103244; Thu, 22
 May 2025 17:11:43 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 22 May 2025 17:11:35 -0700
In-Reply-To: <20250523001138.3182794-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250523001138.3182794-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.1151.ga128411c76-goog
Message-ID: <20250523001138.3182794-2-seanjc@google.com>
Subject: [PATCH v4 1/4] KVM: TDX: Move TDX hardware setup from main.c to tdx.c
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Vipin Sharma <vipinsh@google.com>, James Houghton <jthoughton@google.com>
Content-Type: text/plain; charset="UTF-8"

Move TDX hardware setup to tdx.c, as the code is obviously TDX specific,
co-locating the setup with tdx_bringup() makes it easier to see and
document the success_disable_tdx "error" path, and configuring the TDX
specific hooks in tdx.c reduces the number of globally visible TDX symbols.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/main.c    | 36 ++----------------------------
 arch/x86/kvm/vmx/tdx.c     | 45 +++++++++++++++++++++++++++-----------
 arch/x86/kvm/vmx/tdx.h     |  1 +
 arch/x86/kvm/vmx/x86_ops.h | 10 ---------
 4 files changed, 35 insertions(+), 57 deletions(-)

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
index b952bc673271..1790f6dee870 100644
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
@@ -3524,3 +3528,18 @@ int __init tdx_bringup(void)
 	enable_tdx = 0;
 	return 0;
 }
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
-- 
2.49.0.1151.ga128411c76-goog


