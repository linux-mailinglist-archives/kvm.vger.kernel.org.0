Return-Path: <kvm+bounces-61626-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 5EEC8C22CA6
	for <lists+kvm@lfdr.de>; Fri, 31 Oct 2025 01:33:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DADE3188FB57
	for <lists+kvm@lfdr.de>; Fri, 31 Oct 2025 00:32:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CB58521D59C;
	Fri, 31 Oct 2025 00:30:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="OvOm54gX"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66DDC210F59
	for <kvm@vger.kernel.org>; Fri, 31 Oct 2025 00:30:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761870656; cv=none; b=qjJT319u3h4DKxqJrLheGefp40Yq+gS603y7FkkvtCmgrUEFHJJTU1amARAhgfbTFD+E5GFu+WFf4/54pqSjmWxmMzR5BeDnaB9OuY1a5Wde7bq5qGLGodbc6y7Aa/FWicQkeCW/VyayNB4NeeBL1/ZYqMy78Ei9NifkDfZ9DaI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761870656; c=relaxed/simple;
	bh=L4B2/byDWQc7xPnaGzWQ+zlWxtR0CuqfOgb4oT+jN9Y=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ZNpPbjH3hMXfkLbMvFOzuiL5s2SL+bixfWdCGIigUVAl4/BFjR2H6hdTNV2WHmvc+xqN2O+LYrYniDsUoXf363UUA3VZ8gbt3rxcfYcEa2lodNO/bM0cTDzYH11cGvauyPrUPv7JT9a3e4A4+izJ44lTdOP6/xKRoj36YwHknr0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=OvOm54gX; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-33bc5d7c289so3040416a91.0
        for <kvm@vger.kernel.org>; Thu, 30 Oct 2025 17:30:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761870654; x=1762475454; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=VmBAwOrgzrqrpUaigLBeNdYHl3f0IKWGJYuT2uuDaXY=;
        b=OvOm54gXdpaY5lBDd1QPDKbKZakEQiFumUWwyT9nCPRdjf8JYZIPNsfSMikISjO1W/
         HukCCiN4pe64KvoaeO+0vwESQx04OTqQgrTyBipMuftRLVyvfA4VAc1DWJq/dRjHPVxH
         y33fzfGPB/vevya3SHs3SJXVR1O+fQXS+MPecD+2v5VW0tO3RuXvQbn3cHB22ys0dCX0
         HmJw/ZqONMpHr37noVtGKvIFdyZBc9MTL7o9Bs6PvWnjw8ufzTt6OQ1efLyrR3oazd7g
         +zEA/q2lpff05tr/qCkTjRZOJvwpejjdpjJAtXHMCxa//ZuIte/KHVTspUX2fTYQ9DAM
         +Vog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761870654; x=1762475454;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VmBAwOrgzrqrpUaigLBeNdYHl3f0IKWGJYuT2uuDaXY=;
        b=TPEh58iH9NVDr8Irs6NqrZce/W2Zmb4G5eFVvIPWksUXBsYC42ofiACCA1Mk+3Itxi
         OtLEtTul5pwbn7S4MJ5YYLKeMOWeMTJJOb0G6t/DefpXBaHVC1NKcQPGlKFuTzOTlPvP
         /gW3PbbaZoxtnwtYPqQyHIDMk7OQ7Pc5PcNvq7azo3pMaB/JpsI+0euN71zrbVteNhlr
         EW/U6nMNVkx11aou3sH1hSu7JZvlubmZPXqoKbQObBn6k6yD4HVZLzCcCiaRW/zR7AwI
         w05iPSnk9cHh0bs/n8shfmBC4LV3EKBEdAHOxPWWiLu78N3653PC6u5HF0cstTuHc0o7
         ZNTw==
X-Gm-Message-State: AOJu0YwSqzGiLSkoPaJZvXVME0srRf1Pt9LvwP5ROTiJEG+w0N39u40t
	w6L9s0m+TMaLPr3gf0q90dEBcbAsphdXZEZfAyopq4IA0+UOUZRXtmMawIwsSYg9MhSAFqdl3dd
	xeZh5nQ==
X-Google-Smtp-Source: AGHT+IFVRHnLID3eKFv1t9BcD3CWxlHu1pnR2jYex1mPnoWNTlz6hIST/XP7gF8RMU6dGOhlYpHQLmGQSGM=
X-Received: from pjbfh4.prod.google.com ([2002:a17:90b:344:b0:33b:a383:f4df])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:574c:b0:340:29be:7838
 with SMTP id 98e67ed59e1d1-3408308b37amr2062772a91.29.1761870653659; Thu, 30
 Oct 2025 17:30:53 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 30 Oct 2025 17:30:36 -0700
In-Reply-To: <20251031003040.3491385-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251031003040.3491385-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.1.930.gacf6e81ea2-goog
Message-ID: <20251031003040.3491385-5-seanjc@google.com>
Subject: [PATCH v4 4/8] KVM: VMX: Handle MMIO Stale Data in VM-Enter assembly
 via ALTERNATIVES_2
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@alien8.de>, Peter Zijlstra <peterz@infradead.org>, 
	Josh Poimboeuf <jpoimboe@kernel.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>, Brendan Jackman <jackmanb@google.com>
Content-Type: text/plain; charset="UTF-8"

Rework the handling of the MMIO Stale Data mitigation to clear CPU buffers
immediately prior to VM-Enter, i.e. in the same location that KVM emits a
VERW for unconditional (at runtime) clearing.  Co-locating the code and
using a single ALTERNATIVES_2 makes it more obvious how VMX mitigates the
various vulnerabilities.

Deliberately order the alternatives as:

 0. Do nothing
 1. Clear if vCPU can access MMIO
 2. Clear always

since the last alternative wins in ALTERNATIVES_2(), i.e. so that KVM will
honor the strictest mitigation (always clear CPU buffers) if multiple
mitigations are selected.  E.g. even if the kernel chooses to mitigate
MMIO Stale Data via X86_FEATURE_CLEAR_CPU_BUF_MMIO, some other mitigation
may enable X86_FEATURE_CLEAR_CPU_BUF_VM, and that other thing needs to win.

Note, decoupling the MMIO mitigation from the L1TF mitigation also fixes
a mostly-benign flaw where KVM wouldn't do any clearing/flushing if the
L1TF mitigation is configured to conditionally flush the L1D, and the MMIO
mitigation but not any other "clear CPU buffers" mitigation is enabled.
For that specific scenario, KVM would skip clearing CPU buffers for the
MMIO mitigation even though the kernel requested a clear on every VM-Enter.

Note #2, the flaw goes back to the introduction of the MDS mitigation.  The
MDS mitigation was inadvertently fixed by commit 43fb862de8f6 ("KVM/VMX:
Move VERW closer to VMentry for MDS mitigation"), but previous kernels
that flush CPU buffers in vmx_vcpu_enter_exit() are affected (though it's
unlikely the flaw is meaningfully exploitable even older kernels).

Fixes: 650b68a0622f ("x86/kvm/vmx: Add MDS protection when L1D Flush is not active")
Suggested-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/vmenter.S | 14 +++++++++++++-
 arch/x86/kvm/vmx/vmx.c     | 13 -------------
 2 files changed, 13 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmenter.S b/arch/x86/kvm/vmx/vmenter.S
index 1f99a98a16a2..61a809790a58 100644
--- a/arch/x86/kvm/vmx/vmenter.S
+++ b/arch/x86/kvm/vmx/vmenter.S
@@ -71,6 +71,7 @@
  * @regs:	unsigned long * (to guest registers)
  * @flags:	VMX_RUN_VMRESUME:	use VMRESUME instead of VMLAUNCH
  *		VMX_RUN_SAVE_SPEC_CTRL: save guest SPEC_CTRL into vmx->spec_ctrl
+ *		VMX_RUN_CLEAR_CPU_BUFFERS_FOR_MMIO: vCPU can access host MMIO
  *
  * Returns:
  *	0 on VM-Exit, 1 on VM-Fail
@@ -137,6 +138,12 @@ SYM_FUNC_START(__vmx_vcpu_run)
 	/* Load @regs to RAX. */
 	mov (%_ASM_SP), %_ASM_AX
 
+	/* Stash "clear for MMIO" in EFLAGS.ZF (used below). */
+	ALTERNATIVE_2 "",								\
+		      __stringify(test $VMX_RUN_CLEAR_CPU_BUFFERS_FOR_MMIO, %ebx), 	\
+		      X86_FEATURE_CLEAR_CPU_BUF_MMIO,					\
+		      "", X86_FEATURE_CLEAR_CPU_BUF_VM
+
 	/* Check if vmlaunch or vmresume is needed */
 	bt   $VMX_RUN_VMRESUME_SHIFT, %ebx
 
@@ -161,7 +168,12 @@ SYM_FUNC_START(__vmx_vcpu_run)
 	mov VCPU_RAX(%_ASM_AX), %_ASM_AX
 
 	/* Clobbers EFLAGS.ZF */
-	VM_CLEAR_CPU_BUFFERS
+	ALTERNATIVE_2 "",							\
+		      __stringify(jz .Lskip_clear_cpu_buffers;			\
+				  CLEAR_CPU_BUFFERS_SEQ;			\
+				  .Lskip_clear_cpu_buffers:),			\
+		      X86_FEATURE_CLEAR_CPU_BUF_MMIO,				\
+		      __CLEAR_CPU_BUFFERS, X86_FEATURE_CLEAR_CPU_BUF_VM
 
 	/* Check EFLAGS.CF from the VMX_RUN_VMRESUME bit test above. */
 	jnc .Lvmlaunch
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 68cde725d1c7..5af2338c7cb8 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7339,21 +7339,8 @@ static noinstr void vmx_vcpu_enter_exit(struct kvm_vcpu *vcpu,
 
 	guest_state_enter_irqoff();
 
-	/*
-	 * L1D Flush includes CPU buffer clear to mitigate MDS, but VERW
-	 * mitigation for MDS is done late in VMentry and is still
-	 * executed in spite of L1D Flush. This is because an extra VERW
-	 * should not matter much after the big hammer L1D Flush.
-	 *
-	 * cpu_buf_vm_clear is used when system is not vulnerable to MDS/TAA,
-	 * and is affected by MMIO Stale Data. In such cases mitigation in only
-	 * needed against an MMIO capable guest.
-	 */
 	if (static_branch_unlikely(&vmx_l1d_should_flush))
 		vmx_l1d_flush(vcpu);
-	else if (cpu_feature_enabled(X86_FEATURE_CLEAR_CPU_BUF_MMIO) &&
-		 (flags & VMX_RUN_CLEAR_CPU_BUFFERS_FOR_MMIO))
-		x86_clear_cpu_buffers();
 
 	vmx_disable_fb_clear(vmx);
 
-- 
2.51.1.930.gacf6e81ea2-goog


