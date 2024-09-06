Return-Path: <kvm+bounces-25983-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1A29B96E8AA
	for <lists+kvm@lfdr.de>; Fri,  6 Sep 2024 06:35:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 36BA51C23694
	for <lists+kvm@lfdr.de>; Fri,  6 Sep 2024 04:35:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C816B13210D;
	Fri,  6 Sep 2024 04:34:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="z6qUfcVF"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EE6A54656
	for <kvm@vger.kernel.org>; Fri,  6 Sep 2024 04:34:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725597264; cv=none; b=ENFVND1+jOfZZs9yAyRL86Z4sYE9tNp+FbWL4GDQjxxF6sGhji4Fd1zLP0YW1AYLSzClMqn54kfKz+rmvrx92QcKcSEr+gVwuSj2C6XMyM5nG1GpB16YzYfObRz89vvxx5FtT6Whyvj+CyWuXKBw51Tjda0HzIcG/ba/u7Sv6Bo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725597264; c=relaxed/simple;
	bh=eDNwSm0+gbgy/kZmZL0w/jpknN55gI59zurj7zb2dhI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ppWCzpIV/c2O9D7w6FyzfAnqDd2fSmmexMnuMbQMteBLkbKXRoklNLU31fceJD6wrffVW6xTeqFgQljsK1IgAXzIlEev5lcLTUBI+UU0xpeqYK3ygA5ewKiH/WuFutj9PTlVSYjgjP9Rqi+54g+VTiCAD+b2tc5+ql8Hr5w83qM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=z6qUfcVF; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-6d4bd76f5a8so52557087b3.0
        for <kvm@vger.kernel.org>; Thu, 05 Sep 2024 21:34:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1725597260; x=1726202060; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=mJlh6I1bqg+VJjot9mgJ443ha3usj4WF5fwSb0yKCRc=;
        b=z6qUfcVFty3w5sjiH0ssZ+6fQW4EL0rVjaHewPvndsjgjgDuMkM2lUUkPu45JY0yuA
         o2a1AUITRMKPopdeiKTpHqLoIMHEX7Fx5PE6KmQaPgirjXZ97RKx4AofdbRTHi8Lap3R
         h0B66iT6z0Bsmvy2VnYfnnXNHQwDxiQJN/ymw/eVZAxuc1rFwQrtJBjk13z4LfqicGof
         cio6B8Y+nMgBOymaWEfXedKSdEQQmMceZ0K9uLEnLPe2IWTreR3iRfVBTyuQsIdIjwzG
         eN8S8Byc/Hga+FosILUEvGL9Ku/pyGxwsP//RmAnAN7EDuOFIjQChZjDeuTFbfu+F9pT
         /Ykw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725597260; x=1726202060;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mJlh6I1bqg+VJjot9mgJ443ha3usj4WF5fwSb0yKCRc=;
        b=oUnWvEZ+WldVBFJQSl/NRNc2ejP1dQQ6n3ey6l4jKnjNA5d7rrB3Wwzd4RnatVHrgs
         P4px8g507LYnEkW4iyfX1ND9X09xOR2OiUjAPYr62svizvvnEVojyZniNIOgQVkPqpfm
         IEd1otIJAY9peDYnuyhzTGs2hemyXuw+pn16fYRdurueOdspN8iZFR2fHDIsOk237WnQ
         B71TuYtSOtiuNIx2Whmykzf5L1DscDRyItXyy3uk0+y2rb6z3bNeRkZ6mXs8UO7wH3aR
         XRLFeRD6WGnq8fY6gXCW5cSrS57FV8kRc862zVqfZOraUzvTkLF+FElh5Nr6PMMz5UOy
         LQ3A==
X-Gm-Message-State: AOJu0Yz8w1FFeXjueFCHejH/p0kPA82wGzBbZzW8Sutk/uPeh2OEVScr
	07T6rk2waxmar4VlN9R9eDP4AV7qLKpTyZMfXIAgJJf8GZO+AWhCChwFyJcQwYt9z8WPG7cAgb4
	wOQ==
X-Google-Smtp-Source: AGHT+IEPohibJVK7CmOK3wntKFvrjLv1A44TW/i8I3yEYDsA5G0xDa+I83WX8upp1fWDeFMg/T0IzHbDDpU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:2c11:b0:690:8ad7:55f9 with SMTP id
 00721157ae682-6db44d6c217mr285207b3.2.1725597260254; Thu, 05 Sep 2024
 21:34:20 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu,  5 Sep 2024 21:34:08 -0700
In-Reply-To: <20240906043413.1049633-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240906043413.1049633-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.469.g59c65b2a67-goog
Message-ID: <20240906043413.1049633-3-seanjc@google.com>
Subject: [PATCH v2 2/7] KVM: nVMX: Get to-be-acknowledge IRQ for nested
 VM-Exit at injection site
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Nathan Chancellor <nathan@kernel.org>, Chao Gao <chao.gao@intel.com>, 
	Zeng Guang <guang.zeng@intel.com>
Content-Type: text/plain; charset="UTF-8"

Move the logic to get the to-be-acknowledge IRQ for a nested VM-Exit from
nested_vmx_vmexit() to vmx_check_nested_events(), which is subtly the one
and only path where KVM invokes nested_vmx_vmexit() with
EXIT_REASON_EXTERNAL_INTERRUPT.  A future fix will perform a last-minute
check on L2's nested posted interrupt notification vector, just before
injecting a nested VM-Exit.  To handle that scenario correctly, KVM needs
to get the interrupt _before_ injecting VM-Exit, as simply querying the
highest priority interrupt, via kvm_cpu_has_interrupt(), would result in
TOCTOU bug, as a new, higher priority interrupt could arrive between
kvm_cpu_has_interrupt() and kvm_cpu_get_interrupt().

Unfortunately, simply moving the call to kvm_cpu_get_interrupt() doesn't
suffice, as a VMWRITE to GUEST_INTERRUPT_STATUS.SVI is hiding in
kvm_get_apic_interrupt(), and acknowledging the interrupt before nested
VM-Exit would cause the VMWRITE to hit vmcs02 instead of vmcs01.

Open code a rough equivalent to kvm_cpu_get_interrupt() so that the IRQ
is acknowledged after emulating VM-Exit, taking care to avoid the TOCTOU
issue described above.

Opportunistically convert the WARN_ON() to a WARN_ON_ONCE().  If KVM has
a bug that results in a false positive from kvm_cpu_has_interrupt(),
spamming dmesg won't help the situation.

Note, nested_vmx_reflect_vmexit() can never reflect external interrupts as
they are always "wanted" by L0.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/irq.c              |  3 ++-
 arch/x86/kvm/vmx/nested.c       | 36 ++++++++++++++++++++++++---------
 3 files changed, 30 insertions(+), 10 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 950a03e0181e..d66d562c0ab3 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -2251,6 +2251,7 @@ int kvm_cpu_has_injectable_intr(struct kvm_vcpu *v);
 int kvm_cpu_has_interrupt(struct kvm_vcpu *vcpu);
 int kvm_cpu_has_extint(struct kvm_vcpu *v);
 int kvm_arch_interrupt_allowed(struct kvm_vcpu *vcpu);
+int kvm_cpu_get_extint(struct kvm_vcpu *v);
 int kvm_cpu_get_interrupt(struct kvm_vcpu *v);
 void kvm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event);
 
diff --git a/arch/x86/kvm/irq.c b/arch/x86/kvm/irq.c
index 3d7eb11d0e45..810da99ff7ed 100644
--- a/arch/x86/kvm/irq.c
+++ b/arch/x86/kvm/irq.c
@@ -108,7 +108,7 @@ EXPORT_SYMBOL_GPL(kvm_cpu_has_interrupt);
  * Read pending interrupt(from non-APIC source)
  * vector and intack.
  */
-static int kvm_cpu_get_extint(struct kvm_vcpu *v)
+int kvm_cpu_get_extint(struct kvm_vcpu *v)
 {
 	if (!kvm_cpu_has_extint(v)) {
 		WARN_ON(!lapic_in_kernel(v));
@@ -131,6 +131,7 @@ static int kvm_cpu_get_extint(struct kvm_vcpu *v)
 	} else
 		return kvm_pic_read_irq(v->kvm); /* PIC */
 }
+EXPORT_SYMBOL_GPL(kvm_cpu_get_extint);
 
 /*
  * Read pending interrupt vector and intack.
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 2392a7ef254d..e6af5f1d3b61 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -4284,11 +4284,37 @@ static int vmx_check_nested_events(struct kvm_vcpu *vcpu)
 	}
 
 	if (kvm_cpu_has_interrupt(vcpu) && !vmx_interrupt_blocked(vcpu)) {
+		int irq;
+
 		if (block_nested_events)
 			return -EBUSY;
 		if (!nested_exit_on_intr(vcpu))
 			goto no_vmexit;
-		nested_vmx_vmexit(vcpu, EXIT_REASON_EXTERNAL_INTERRUPT, 0, 0);
+
+		if (!nested_exit_intr_ack_set(vcpu)) {
+			nested_vmx_vmexit(vcpu, EXIT_REASON_EXTERNAL_INTERRUPT, 0, 0);
+			return 0;
+		}
+
+		irq = kvm_cpu_get_extint(vcpu);
+		if (irq != -1) {
+			nested_vmx_vmexit(vcpu, EXIT_REASON_EXTERNAL_INTERRUPT,
+					  INTR_INFO_VALID_MASK | INTR_TYPE_EXT_INTR | irq, 0);
+			return 0;
+		}
+
+		irq = kvm_apic_has_interrupt(vcpu);
+		WARN_ON_ONCE(irq < 0);
+
+		nested_vmx_vmexit(vcpu, EXIT_REASON_EXTERNAL_INTERRUPT,
+				  INTR_INFO_VALID_MASK | INTR_TYPE_EXT_INTR | irq, 0);
+
+		/*
+		 * ACK the interrupt _after_ emulating VM-Exit, as the IRQ must
+		 * be marked as in-service in vmcs01.GUEST_INTERRUPT_STATUS.SVI
+		 * if APICv is active.
+		 */
+		kvm_apic_ack_interrupt(vcpu, irq);
 		return 0;
 	}
 
@@ -4969,14 +4995,6 @@ void nested_vmx_vmexit(struct kvm_vcpu *vcpu, u32 vm_exit_reason,
 	vcpu->arch.mp_state = KVM_MP_STATE_RUNNABLE;
 
 	if (likely(!vmx->fail)) {
-		if ((u16)vm_exit_reason == EXIT_REASON_EXTERNAL_INTERRUPT &&
-		    nested_exit_intr_ack_set(vcpu)) {
-			int irq = kvm_cpu_get_interrupt(vcpu);
-			WARN_ON(irq < 0);
-			vmcs12->vm_exit_intr_info = irq |
-				INTR_INFO_VALID_MASK | INTR_TYPE_EXT_INTR;
-		}
-
 		if (vm_exit_reason != -1)
 			trace_kvm_nested_vmexit_inject(vmcs12->vm_exit_reason,
 						       vmcs12->exit_qualification,
-- 
2.46.0.469.g59c65b2a67-goog


