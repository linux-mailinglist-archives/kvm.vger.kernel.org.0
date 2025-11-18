Return-Path: <kvm+bounces-63599-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id C02AFC6BD97
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 23:24:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id A231A4E528C
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 22:24:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF0F3318144;
	Tue, 18 Nov 2025 22:23:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="rr4QUzhR"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4725A30FF27
	for <kvm@vger.kernel.org>; Tue, 18 Nov 2025 22:23:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763504616; cv=none; b=OODtRD8/Kjk3OQN5KlLgfzB4Nod6xmjdGk5DS0uiryZ4NLhmJhZ4IPaAylRYQEsEU7Zafk9slA/Ein3qM8TQruLh8NSlt2c4pj/warlet4ZW5CHcC2Toa2cAWfxbgX3sG/oo0F11mbQCUnI1jO6zmiO42yxBwi1edULiXCqoGUo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763504616; c=relaxed/simple;
	bh=/o8KfZ3cNcE/BiIE20gNBxFK6IuWDrd7yhoJMvADFS8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=fVARzAbKqc2EzYGNiZd2d3S2g3IuEnlcksFvi/zOJoHKEwGqM/0y/U0HVVBj/jQ4R8e5GeJUyV7qxJ+a8ucz4icrH6+0BVRcLQ0GB6+EpYVrMUMssKlYJWvZXil0PMY9S2LsQuvlhU8u1dclS1I1YgBiubRQzd38QjiUvcL0Cxg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=rr4QUzhR; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-297f587dc2eso110870765ad.2
        for <kvm@vger.kernel.org>; Tue, 18 Nov 2025 14:23:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763504615; x=1764109415; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=QKvebzST2buQwrtL7F9ca9a+LG6gPYB7JuXVc16J77E=;
        b=rr4QUzhRvH7W2s3Fp8iURRPG2tqmUr5v2BfGyFwiolGJAyqoe/xUVjzI78MbfpF0EG
         iy+L/Xm2i6IeHQgRIBpt9xDmRDW0puqW05ToSCLAxNOm3z+J5eMRJSq8FN8HAXEaAmfm
         w3NR6p0pJkMBN0AwzZlCjHAWNV4a/mog4ecOI2YqVK8dsZcwGIredggq18H/gdoFPNxk
         xho0ebc9rPLt+huzDr6q7Lbt25q9zqTGFugesy+89PuyBcTKMfbXnGfIBcHgUpBStuYt
         vXEeIr3P8gGxeNQh0A3sPwbEGCK2hbGLL87T1lXAuhvCqEqEYKuQ90AJ/DAYqWZl5YrO
         wQTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763504615; x=1764109415;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QKvebzST2buQwrtL7F9ca9a+LG6gPYB7JuXVc16J77E=;
        b=nyYj+TfjBc1c1m/2bZKfdyBvWDdnk4Z+IpxLyX8YRaUqxGeddlJiyIuXAyvi04WtkX
         WIidSoP5um2VwJptsQ1k/1E6hjoi+v07tbNr5HaeTZMkd/r8nPu+BsmJaGgr4QvNum2s
         o9TgY04pku2L1PUdylyUtFFYI4IzjMrjas717VNwZezVJcCWI7q2GnGI1YklK+dnoW9X
         5K/gZCpCSc87+hxavk+oScG4/yrQjf900LAVmxRcLbYcYzOuaazYa1yzAF0gZFRpkh0c
         lSc8wRLGSThCSD/GyrzLu4cZ6/Vtu+boVCJeJlDohOVJ5GXhT/T9zkZ48EWaxbpFX/So
         SS/A==
X-Gm-Message-State: AOJu0YzVbz7xVz2N7ZWJ6ZujG0PPCEHzfGvNMXKz7GNrRk2bHr+Gnpxq
	8SVm01lFEDq8K48epExJSPlbUwbZUufzAu0Giwq6AMlCeqxYhdblb8oA0wyrcVhQuSKflVf/kWw
	Mlt8crA==
X-Google-Smtp-Source: AGHT+IG+97mMZM2HDntRVzkJsusKs0yMXUhQxAwl0AvkRwKpYwsDYK71pux5+Yp/6nBGQe29LFs83wtH+Kw=
X-Received: from plrt3.prod.google.com ([2002:a17:902:b203:b0:297:d4ca:8805])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:f691:b0:295:6a9:cb62
 with SMTP id d9443c01a7336-2986a73b4a7mr217741885ad.35.1763504614611; Tue, 18
 Nov 2025 14:23:34 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 18 Nov 2025 14:23:26 -0800
In-Reply-To: <20251118222328.2265758-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251118222328.2265758-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
Message-ID: <20251118222328.2265758-3-seanjc@google.com>
Subject: [PATCH v2 2/4] KVM: VMX: Handle #MCs on VM-Enter/TD-Enter outside of
 the fastpath
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	"Kirill A. Shutemov" <kas@kernel.org>
Cc: kvm@vger.kernel.org, x86@kernel.org, linux-coco@lists.linux.dev, 
	linux-kernel@vger.kernel.org, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Jon Kohler <jon@nutanix.com>, Tony Lindgren <tony.lindgren@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"

Handle Machine Checks (#MC) that happen on VM-Enter (VMX or TDX) outside
of KVM's fastpath so that as much host state as possible is re-loaded
before invoking the kernel's #MC handler.  The only requirement is that
KVM invokes the #MC handler before enabling IRQs (and even that could
_probably_ be related to handling #MCs before enabling preemption).

Waiting to handle #MCs until "more" host state is loaded hardens KVM
against flaws in the #MC handler, which has historically been quite
brittle. E.g. prior to commit 5567d11c21a1 ("x86/mce: Send #MC singal from
task work"), the #MC code could trigger a schedule() with IRQs and
preemption disabled.  That led to a KVM hack-a-fix in commit 1811d979c716
("x86/kvm: move kvm_load/put_guest_xcr0 into atomic context").

Note, vmx_handle_exit_irqoff() is common to VMX and TDX guests.

Cc: Tony Lindgren <tony.lindgren@linux.intel.com>
Cc: Rick Edgecombe <rick.p.edgecombe@intel.com>
Cc: Jon Kohler <jon@nutanix.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/tdx.c |  3 ---
 arch/x86/kvm/vmx/vmx.c | 16 +++++++++++-----
 2 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index e6105a527372..2d7a4d52ccfb 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1110,9 +1110,6 @@ fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu, u64 run_flags)
 	if (unlikely((tdx->vp_enter_ret & TDX_SW_ERROR) == TDX_SW_ERROR))
 		return EXIT_FASTPATH_NONE;
 
-	if (unlikely(vmx_get_exit_reason(vcpu).basic == EXIT_REASON_MCE_DURING_VMENTRY))
-		kvm_machine_check();
-
 	trace_kvm_exit(vcpu, KVM_ISA_VMX);
 
 	if (unlikely(tdx_failed_vmentry(vcpu)))
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index fdcc519348cd..f369c499b2c3 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7062,10 +7062,19 @@ void vmx_handle_exit_irqoff(struct kvm_vcpu *vcpu)
 	if (to_vt(vcpu)->emulation_required)
 		return;
 
-	if (vmx_get_exit_reason(vcpu).basic == EXIT_REASON_EXTERNAL_INTERRUPT)
+	switch (vmx_get_exit_reason(vcpu).basic) {
+	case EXIT_REASON_EXTERNAL_INTERRUPT:
 		handle_external_interrupt_irqoff(vcpu, vmx_get_intr_info(vcpu));
-	else if (vmx_get_exit_reason(vcpu).basic == EXIT_REASON_EXCEPTION_NMI)
+		break;
+	case EXIT_REASON_EXCEPTION_NMI:
 		handle_exception_irqoff(vcpu, vmx_get_intr_info(vcpu));
+		break;
+	case EXIT_REASON_MCE_DURING_VMENTRY:
+		kvm_machine_check();
+		break;
+	default:
+		break;
+	}
 }
 
 /*
@@ -7528,9 +7537,6 @@ fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu, u64 run_flags)
 	if (unlikely(vmx->fail))
 		return EXIT_FASTPATH_NONE;
 
-	if (unlikely((u16)vmx_get_exit_reason(vcpu).basic == EXIT_REASON_MCE_DURING_VMENTRY))
-		kvm_machine_check();
-
 	trace_kvm_exit(vcpu, KVM_ISA_VMX);
 
 	if (unlikely(vmx_get_exit_reason(vcpu).failed_vmentry))
-- 
2.52.0.rc1.455.g30608eb744-goog


