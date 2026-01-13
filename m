Return-Path: <kvm+bounces-67983-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 3DEC2D1BA2C
	for <lists+kvm@lfdr.de>; Tue, 13 Jan 2026 23:54:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 44D2530373B2
	for <lists+kvm@lfdr.de>; Tue, 13 Jan 2026 22:54:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5FF2C355057;
	Tue, 13 Jan 2026 22:54:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="DWY5gWs1"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C82026E710
	for <kvm@vger.kernel.org>; Tue, 13 Jan 2026 22:54:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768344873; cv=none; b=NNeN464M5+ya1wPujZKogWQYFpvl6KboMPdjJ+5ZvMh4RZrIqIa9ZmJe+XKFvFpsYSnPn1QlnpjCLKqKpa1AXTDJyruySTCC7BqCkz2n/ygTeyDlH/LLhpaCBvGgNSprFZR+shGGtJO/i/MXJxQRdtlYdoCB9kmxNh5BM4e8NOE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768344873; c=relaxed/simple;
	bh=kjYxer+/3V1jI4OHoFVGD+5pSEYcQa3i5tlZizYE17k=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=OFu4reZuPKU5vB4/XkaVeeetC4hJdVolvTak4Dg+7Isti+lf/cecg6TZfejkR/fXgQ1KrLchYOQY6unyo+kwElz1tdUK9tlIQ1apAPJoLHDaK/ADen0YGnMHEJDF0dVXskol99w/f55vqh8Ta6uSsds1m64MHYOAzP0y7wJ4giY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jmattson.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=DWY5gWs1; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jmattson.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-34c904a1168so8718372a91.1
        for <kvm@vger.kernel.org>; Tue, 13 Jan 2026 14:54:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768344872; x=1768949672; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=AJghbSsJpIgQjxA5ov9Uplap9HJ8WXvKzTlzG3h11mk=;
        b=DWY5gWs1bHBol3/xdmp8hdy7G8u5ITbsWJ8MLfJbYjLug84WkcaWAhOnEDyZdiVBAE
         WzMaQChj4/QEzXXDe3zqVHzyfJ1hB+HP7lTXci2CBv8pXTa48VpihTg70ghUiVVvngWi
         dvRZseoqZTtwatBUoxg9U+cVuysRl0NzEYju/FndC/4U4nmRWg9KoGMhpfwGkiPHQipn
         bTI/nHI30kFTD2xYCoGP9TG8tBwG0GBw8tWg6JrZ8p2x9hcbWSOgmTpURK/E/0ymXe/q
         fMRaQBf27D936A++fNJcfhqYGIcYanLvenQy25PeYcVtRaMTU2LUCB+sBlSaM8r0kKBc
         60vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768344872; x=1768949672;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=AJghbSsJpIgQjxA5ov9Uplap9HJ8WXvKzTlzG3h11mk=;
        b=jxseqDyGIBSR4mtgqhfoy0svPVaV3wbe+gWkMQPyZLEunqEJsjIl6tRNrHNahg7f/v
         TX0FfSNhkKX3zZgEDySu6Fv9TufqWy+OMaldBusV8LCzxJN4tEQLAT95qXnzQnwE7Qpc
         zlFR8bG7liITWbWkcXhePsvaQM3PS2G8fgja3cI8J7RVX/gRMrxZCeYv0Aj5lEHsD1zi
         QMhouWp6x/7TKgWx+sXmUzW9FXjCxQMbcUJb59MPDZag0GQZ+aUQ7/ZzodVugYYRtmNi
         h6FlhvPY3jbwCkujxHAjqTPsWAK6+r6LhUIye6cPbRkyZPn0VCEN7xcM+haewvtPCDre
         qUDQ==
X-Forwarded-Encrypted: i=1; AJvYcCWFiA4NF4+okjs+9Yr+ybn1X0uhDoE+sbtssjKmLQlM9MPQsmNB0Ytr6U0EX6JndSNoB6o=@vger.kernel.org
X-Gm-Message-State: AOJu0YzHf0oOlcdW4y18dnBypMXDIUszDQVx66/b9/NhfojGWpLXbgNq
	ziVnWpwyiwwQFOCjovdDL1TuPvlQTt9Zl8onqdYmxV54yeV3LrCCk57Pbj9GOQgZ5T9872RAABV
	JDTIovCSrYfgfSw==
X-Received: from pjbci23.prod.google.com ([2002:a17:90a:fc97:b0:340:c53d:2599])
 (user=jmattson job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:2f4c:b0:32d:e780:e9d5 with SMTP id 98e67ed59e1d1-35109129cb5mr473381a91.22.1768344871600;
 Tue, 13 Jan 2026 14:54:31 -0800 (PST)
Date: Tue, 13 Jan 2026 14:53:52 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
Message-ID: <20260113225406.273373-1-jmattson@google.com>
Subject: [PATCH] KVM: VMX: Add quirk to allow L1 to set FREEZE_IN_SMM in vmcs12
From: Jim Mattson <jmattson@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>, 
	Sean Christopherson <seanjc@google.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"

Add KVM_X86_QUIRK_VMCS12_FREEZE_IN_SMM to allow L1 to set
IA32_DEBUGCTL.FREEZE_IN_SMM in vmcs12 when using nested VMX.  Prior to
commit 6b1dd26544d0 ("KVM: VMX: Preserve host's
DEBUGCTLMSR_FREEZE_IN_SMM while running the guest"), L1 could set
FREEZE_IN_SMM in vmcs12 to freeze PMCs during physical SMM coincident
with L2's execution.  The quirk is enabled by default for backwards
compatibility; userspace can disable it via KVM_CAP_DISABLE_QUIRKS2 if
consistency with WRMSR(IA32_DEBUGCTL) is desired.

Fixes: 095686e6fcb4 ("KVM: nVMX: Check vmcs12->guest_ia32_debugctl on nested VM-Enter")
Signed-off-by: Jim Mattson <jmattson@google.com>
---
 Documentation/virt/kvm/api.rst  | 10 ++++++++++
 arch/x86/include/asm/kvm_host.h |  3 ++-
 arch/x86/include/uapi/asm/kvm.h |  1 +
 arch/x86/kvm/vmx/nested.c       | 22 ++++++++++++++++++----
 4 files changed, 31 insertions(+), 5 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 01a3abef8abb..31019675f2f2 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -8414,6 +8414,16 @@ KVM_X86_QUIRK_IGNORE_GUEST_PAT      By default, on Intel platforms, KVM ignores
                                     guest software, for example if it does not
                                     expose a bochs graphics device (which is
                                     known to have had a buggy driver).
+
+KVM_X86_QUIRK_VMCS12_FREEZE_IN_SMM
+                                    By default, KVM allows L1 to set FREEZE_IN_SMM
+                                    in vmcs12 when using nested VMX.  When this
+                                    quirk is disabled, KVM does not allow L1 to
+                                    set the bit.  Prior to KVM taking ownership
+                                    of the bit to ensure PMCs are frozen during
+                                    physical SMM, L1 could set FREEZE_IN_SMM in
+                                    vmcs12 to freeze PMCs during physical SMM
+                                    coincident with L2's execution.
 =================================== ============================================
 
 7.32 KVM_CAP_MAX_VCPU_ID
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index ecd4019b84b7..80f9806862ab 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -2476,7 +2476,8 @@ int memslot_rmap_alloc(struct kvm_memory_slot *slot, unsigned long npages);
 	 KVM_X86_QUIRK_MWAIT_NEVER_UD_FAULTS |	\
 	 KVM_X86_QUIRK_SLOT_ZAP_ALL |		\
 	 KVM_X86_QUIRK_STUFF_FEATURE_MSRS |	\
-	 KVM_X86_QUIRK_IGNORE_GUEST_PAT)
+	 KVM_X86_QUIRK_IGNORE_GUEST_PAT |	\
+	 KVM_X86_QUIRK_VMCS12_FREEZE_IN_SMM)
 
 #define KVM_X86_CONDITIONAL_QUIRKS		\
 	(KVM_X86_QUIRK_CD_NW_CLEARED |		\
diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index 7ceff6583652..2b1c494f3adf 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -476,6 +476,7 @@ struct kvm_sync_regs {
 #define KVM_X86_QUIRK_SLOT_ZAP_ALL		(1 << 7)
 #define KVM_X86_QUIRK_STUFF_FEATURE_MSRS	(1 << 8)
 #define KVM_X86_QUIRK_IGNORE_GUEST_PAT		(1 << 9)
+#define KVM_X86_QUIRK_VMCS12_FREEZE_IN_SMM	(1 << 10)
 
 #define KVM_STATE_NESTED_FORMAT_VMX	0
 #define KVM_STATE_NESTED_FORMAT_SVM	1
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 0521b55d47a5..bc8f0b3aa70b 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -3298,10 +3298,24 @@ static int nested_vmx_check_guest_state(struct kvm_vcpu *vcpu,
 	if (CC(vmcs12->guest_cr4 & X86_CR4_CET && !(vmcs12->guest_cr0 & X86_CR0_WP)))
 		return -EINVAL;
 
-	if ((vmcs12->vm_entry_controls & VM_ENTRY_LOAD_DEBUG_CONTROLS) &&
-	    (CC(!kvm_dr7_valid(vmcs12->guest_dr7)) ||
-	     CC(!vmx_is_valid_debugctl(vcpu, vmcs12->guest_ia32_debugctl, false))))
-		return -EINVAL;
+	if (vmcs12->vm_entry_controls & VM_ENTRY_LOAD_DEBUG_CONTROLS) {
+		u64 debugctl = vmcs12->guest_ia32_debugctl;
+
+		/*
+		 * FREEZE_IN_SMM is not virtualized, but allow L1 to set it in
+		 * L2's DEBUGCTL under a quirk for backwards compatibility.
+		 * Prior to KVM taking ownership of the bit to ensure PMCs are
+		 * frozen during physical SMM, L1 could set FREEZE_IN_SMM in
+		 * vmcs12 to freeze PMCs during physical SMM coincident with
+		 * L2's execution.
+		 */
+		if (kvm_check_has_quirk(vcpu->kvm, KVM_X86_QUIRK_VMCS12_FREEZE_IN_SMM))
+			debugctl &= ~DEBUGCTLMSR_FREEZE_IN_SMM;
+
+		if (CC(!kvm_dr7_valid(vmcs12->guest_dr7)) ||
+		    CC(!vmx_is_valid_debugctl(vcpu, debugctl, false)))
+			return -EINVAL;
+	}
 
 	if ((vmcs12->vm_entry_controls & VM_ENTRY_LOAD_IA32_PAT) &&
 	    CC(!kvm_pat_valid(vmcs12->guest_ia32_pat)))
-- 
2.52.0.457.g6b5491de43-goog


