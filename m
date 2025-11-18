Return-Path: <kvm+bounces-63600-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id E97F6C6BD9A
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 23:24:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sto.lore.kernel.org (Postfix) with ESMTPS id 6AA3228F92
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 22:24:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4BEB631ED80;
	Tue, 18 Nov 2025 22:23:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fitKYh4r"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB040311C07
	for <kvm@vger.kernel.org>; Tue, 18 Nov 2025 22:23:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763504618; cv=none; b=GuOaewcwiFfOSfwKJOT954Q5yh9MGrORZQf8MB7Kz4vszTbvSBpiu56TH5yBqWG8I2T1NXqqnEe3SiOK+6kRpeDoqUB+SA8SpY9ia/3+PLDMxBOrpHfnvzjvaN4ODOk9mL0ejEFPeT/t0KL0atMHAyxm/xFAPqJ1BnJyUp8Dj2Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763504618; c=relaxed/simple;
	bh=ZcXkqhGD9PzgbbKyCx8gdo8aDoDPwaqdJrHsFW+B7ME=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=j7L0jxtaxHrzrMYyKhHBVNx1MENGOsAFMEdEgkERjC7CIf8iCw9xMLaTUcK5PB5yWYlLKYlfWthcHTCmI3FdjxsBvbNTYXtfN26Nqz8L51yFw1Fnx7Xlk+T8Qtzxzux9nx+Avq7CCDhLAgDT1vk80gnU/jNFfwtyJXZ6V1r1NEg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=fitKYh4r; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2958a134514so78975075ad.2
        for <kvm@vger.kernel.org>; Tue, 18 Nov 2025 14:23:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763504616; x=1764109416; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=sX0elw2DqT+JqQ8ikKrHK9opKrqwOpcjb2Urt9cPTN8=;
        b=fitKYh4rUgoAh4AGK8gz941IklbaeBCNjbsbygMBhW6ju3QURngAxvxpCJogguet4L
         BByvf5uMgHezP6PgADpBwsD2432erTy9R3FfY2tUGBngteMVev7HFHaOfPergyW5D7Nh
         Kf+OB5SMejXfqTIQ1bN6QXRPol+wbynvsgeoq+6Qy7abyEuB5xeoGl5QiFBxe7HGynAE
         L+xXCVImXuq2RLRhZDR0E7rozPyDfZr7Esfsl+UjBp9zCZvccBkRpwPjDWckrPfyQoHK
         6pjTlKBNMKjt5VBJOjwZeJgTEFja9S3u3eXBUWuotd1NjhJXW7J+BuYKr6aVI6HSdHrP
         Cqcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763504616; x=1764109416;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=sX0elw2DqT+JqQ8ikKrHK9opKrqwOpcjb2Urt9cPTN8=;
        b=rkubxVRzCeTIuJDNgOjKzKxGYCwBSswN+E9clOx9W7ADwxFeRW24rYi4TFWNEvDLe5
         rRWg0dVcXMvm0yIYSh97pi+Lim4ymyqSdX0UWX+q4uKL2cXCMM5KRUFjC/bDpqrjQQW4
         URuF1yK+SIkYOjfvv6olP4qXtVQrJKDJgWIZRDFewnrs9Idlff//Qb6622tsW18Hb77j
         Qud+GGl4oBZdUFT47XmruubMkfqtZtblIkaCXUCcc+StEjfAWASiPlOA2cuHdvKsiu+o
         o/oZUZmigcWGa9smqPMcRZfEBJNpg9dXd/4Rqpa/Qvj/YvUW6K5HgjXz3Wv2eNa4q6r3
         a6/A==
X-Gm-Message-State: AOJu0YwsyRAc6g3INpwS6Gt+ByVxJq678c3RPmQudV2Ab+TlA/AGxm0m
	OELTu5yCWUGRNzJ9gv5MlCDNgvtSzesBV+KiX9QFZFpVwzRdXqE1o5imcFwftMic3Rg/jaB/kXj
	hOiiFvw==
X-Google-Smtp-Source: AGHT+IHub6aQoEkwDwmYjltvKOLCy+EyIsxZ+4Fg008fmfhq1lkJD2yOYl4kqF1FuX4dDzXK27Kcuy57/mg=
X-Received: from plop7.prod.google.com ([2002:a17:902:8a87:b0:273:67d3:6303])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:1211:b0:297:d6c1:26e
 with SMTP id d9443c01a7336-2986a6b7bd1mr211711575ad.6.1763504616132; Tue, 18
 Nov 2025 14:23:36 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 18 Nov 2025 14:23:27 -0800
In-Reply-To: <20251118222328.2265758-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251118222328.2265758-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
Message-ID: <20251118222328.2265758-4-seanjc@google.com>
Subject: [PATCH v2 3/4] KVM: x86: Load guest/host XCR0 and XSS outside of the
 fastpath run loop
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	"Kirill A. Shutemov" <kas@kernel.org>
Cc: kvm@vger.kernel.org, x86@kernel.org, linux-coco@lists.linux.dev, 
	linux-kernel@vger.kernel.org, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Jon Kohler <jon@nutanix.com>, Tony Lindgren <tony.lindgren@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"

Move KVM's swapping of XFEATURE masks, i.e. XCR0 and XSS, out of the
fastpath loop now that the guts of the #MC handler runs in task context,
i.e. won't invoke schedule() with preemption disabled and clobber state
(or crash the kernel) due to trying to context switch XSTATE with a mix
of host and guest state.

For all intents and purposes, this reverts commit 1811d979c716 ("x86/kvm:
move kvm_load/put_guest_xcr0 into atomic context"), which papered over an
egregious bug/flaw in the #MC handler where it would do schedule() even
though IRQs are disabled.  E.g. the call stack from the commit:

  kvm_load_guest_xcr0
  ...
  kvm_x86_ops->run(vcpu)
    vmx_vcpu_run
      vmx_complete_atomic_exit
        kvm_machine_check
          do_machine_check
            do_memory_failure
              memory_failure
                lock_page

Commit 1811d979c716 "fixed" the immediate issue of XRSTORS exploding, but
completely ignored that scheduling out a vCPU task while IRQs and
preemption is wildly broken.  Thankfully, commit 5567d11c21a1 ("x86/mce:
Send #MC singal from task work") (somewhat incidentally?) fixed that flaw
by pushing the meat of the work to the user-return path, i.e. to task
context.

KVM has also hardened itself against #MC goofs by moving #MC forwarding to
kvm_x86_ops.handle_exit_irqoff(), i.e. out of the fastpath.  While that's
by no means a robust fix, restoring as much state as possible before
handling the #MC will hopefully provide some measure of protection in the
event that #MC handling goes off the rails again.

Note, KVM always intercepts XCR0 writes for vCPUs without protected state,
e.g. there's no risk of consuming a stale XCR0 when determining if a PKRU
update is needed; kvm_load_host_xfeatures() only reads, and never writes,
vcpu->arch.xcr0.

Deferring the XCR0 and XSS loads shaves ~300 cycles off the fastpath for
Intel, and ~500 cycles for AMD.  E.g. using INVD in KVM-Unit-Test's
vmexit.c, which an extra hack to enable CR4.OXSAVE, latency numbers for
AMD Turin go from ~2000 => 1500, and for Intel Emerald Rapids, go from
~1300 => ~1000.

Cc: Jon Kohler <jon@nutanix.com>
Reviewed-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Reviewed-by: Jon Kohler <jon@nutanix.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 39 ++++++++++++++++++++++++++-------------
 1 file changed, 26 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index f98c5afa3e41..d8d547c5e014 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1216,13 +1216,12 @@ void kvm_lmsw(struct kvm_vcpu *vcpu, unsigned long msw)
 }
 EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_lmsw);
 
-void kvm_load_guest_xsave_state(struct kvm_vcpu *vcpu)
+static void kvm_load_guest_xfeatures(struct kvm_vcpu *vcpu)
 {
 	if (vcpu->arch.guest_state_protected)
 		return;
 
 	if (kvm_is_cr4_bit_set(vcpu, X86_CR4_OSXSAVE)) {
-
 		if (vcpu->arch.xcr0 != kvm_host.xcr0)
 			xsetbv(XCR_XFEATURE_ENABLED_MASK, vcpu->arch.xcr0);
 
@@ -1230,6 +1229,27 @@ void kvm_load_guest_xsave_state(struct kvm_vcpu *vcpu)
 		    vcpu->arch.ia32_xss != kvm_host.xss)
 			wrmsrq(MSR_IA32_XSS, vcpu->arch.ia32_xss);
 	}
+}
+
+static void kvm_load_host_xfeatures(struct kvm_vcpu *vcpu)
+{
+	if (vcpu->arch.guest_state_protected)
+		return;
+
+	if (kvm_is_cr4_bit_set(vcpu, X86_CR4_OSXSAVE)) {
+		if (vcpu->arch.xcr0 != kvm_host.xcr0)
+			xsetbv(XCR_XFEATURE_ENABLED_MASK, kvm_host.xcr0);
+
+		if (guest_cpu_cap_has(vcpu, X86_FEATURE_XSAVES) &&
+		    vcpu->arch.ia32_xss != kvm_host.xss)
+			wrmsrq(MSR_IA32_XSS, kvm_host.xss);
+	}
+}
+
+void kvm_load_guest_xsave_state(struct kvm_vcpu *vcpu)
+{
+	if (vcpu->arch.guest_state_protected)
+		return;
 
 	if (cpu_feature_enabled(X86_FEATURE_PKU) &&
 	    vcpu->arch.pkru != vcpu->arch.host_pkru &&
@@ -1251,17 +1271,6 @@ void kvm_load_host_xsave_state(struct kvm_vcpu *vcpu)
 		if (vcpu->arch.pkru != vcpu->arch.host_pkru)
 			wrpkru(vcpu->arch.host_pkru);
 	}
-
-	if (kvm_is_cr4_bit_set(vcpu, X86_CR4_OSXSAVE)) {
-
-		if (vcpu->arch.xcr0 != kvm_host.xcr0)
-			xsetbv(XCR_XFEATURE_ENABLED_MASK, kvm_host.xcr0);
-
-		if (guest_cpu_cap_has(vcpu, X86_FEATURE_XSAVES) &&
-		    vcpu->arch.ia32_xss != kvm_host.xss)
-			wrmsrq(MSR_IA32_XSS, kvm_host.xss);
-	}
-
 }
 EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_load_host_xsave_state);
 
@@ -11311,6 +11320,8 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 	if (vcpu->arch.guest_fpu.xfd_err)
 		wrmsrq(MSR_IA32_XFD_ERR, vcpu->arch.guest_fpu.xfd_err);
 
+	kvm_load_guest_xfeatures(vcpu);
+
 	if (unlikely(vcpu->arch.switch_db_regs &&
 		     !(vcpu->arch.switch_db_regs & KVM_DEBUGREG_AUTO_SWITCH))) {
 		set_debugreg(DR7_FIXED_1, 7);
@@ -11397,6 +11408,8 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 	vcpu->mode = OUTSIDE_GUEST_MODE;
 	smp_wmb();
 
+	kvm_load_host_xfeatures(vcpu);
+
 	/*
 	 * Sync xfd before calling handle_exit_irqoff() which may
 	 * rely on the fact that guest_fpu::xfd is up-to-date (e.g.
-- 
2.52.0.rc1.455.g30608eb744-goog


