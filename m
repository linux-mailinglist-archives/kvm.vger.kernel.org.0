Return-Path: <kvm+bounces-63111-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id EC686C5AA50
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 00:38:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sea.lore.kernel.org (Postfix) with ESMTPS id 97CDF2413C
	for <lists+kvm@lfdr.de>; Thu, 13 Nov 2025 23:38:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4CF2F330310;
	Thu, 13 Nov 2025 23:38:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="S39ukbzX"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C184232E73B
	for <kvm@vger.kernel.org>; Thu, 13 Nov 2025 23:37:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763077079; cv=none; b=shhCYQSdp/C90pZOKshqM+6ux7tKAYu+kTJxeluNksdCOMrS0GjmlVFSv9L9s1p0+ewyMlEHmjiHd4keKfgY7ihGVBONXcP3+oRRMTvMRq6mZz3twQkHiSSxP6Gef26ylXkWTWfN6Uo2ZFK33/6gGGalbixxByWpbJrLHznzQMY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763077079; c=relaxed/simple;
	bh=d4Ss4Bie//Rr0NehfKTBbGKRdKpFqMe2NJQy4QCkjd4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=WtHp3XzEGgVK+RHivLyTFGsRQko58s/n1rS+NXgZrNtsZvbSv6rSWTitn7CYk3htUCq+C+5FaZqy0ejxAe/dq4B2C91drv296q9rdjBr8XngoUX7+Pcm8hTUfCUKqb1a6ZIxz7ew7+ni4iWLGsx2TFU8NY4XcDt3foi3yXW3dSk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=S39ukbzX; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-298389232c4so16592145ad.2
        for <kvm@vger.kernel.org>; Thu, 13 Nov 2025 15:37:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763077077; x=1763681877; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=Y0gZwwuvfs6rvtvGFUKGkBP9OUyn1AHhc63Drntnn+4=;
        b=S39ukbzXq+OBsLg8PFyZyDrf9L3fi/ka/aRz7LJwa17O76kIwaYjHAGf3ZBwiV2cuk
         LbTa4BloJagxmo1Eni9VsenKpbJJ8tStZN5eheOg/Qpi/SM2h1AVxyTkxY2Pv8Xv4tSq
         gNaKhrqqWO+PAjkoZVB//NuizK9v4mGKXhZcVIZVxFFnJ6nbBc14hJYXbUvgjH6ZNfgX
         YPongXQvAQCgIIMPE+HHBA38DhAgdiM+nOSZrFuuZycNLIh2HTOrvydXG1TtTw5bJdYC
         52nwU4g7fBA8T/+FOK4320L10xHrSs6FT9a8HUMPhZlXBjnq1IzkEW6CMOhP0yebT6Ke
         GK1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763077077; x=1763681877;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Y0gZwwuvfs6rvtvGFUKGkBP9OUyn1AHhc63Drntnn+4=;
        b=RmjJtClAFhA7OMbh986dg4agb8aF0d/meYxVBMBwMTGUafslyHKOsqg3GXi1vq71zD
         cD29Q3IaRUjZ0n5OkoHNXFrd1kAJ34RVkH88t4sXjusUbzS7eY+/8sUTbavdQKJglafO
         g3LSMF0owoys53vmyqo7H/drnQh+D8JBMTwHY3wKbUF6Rt0IA8w082hOxWhxTQQ1gGq5
         Of8I1sCbqSUvfBQ/9sZwqdrwc9qBNUVtRpuz6N2cuvf7eyQNObmRcNanahI9WG9MjA15
         VkK5A2aZnuL5kidLyNin4no4TjKvVL9gEiHW4EiHt+oE7YHZjnWK9BBEZ45Ptfm7K03O
         LRig==
X-Gm-Message-State: AOJu0YxxrjOnmvMeLn/tHvQdlV89MuNmdN1KnNDm6a22mAA8pBb2q8VP
	HUJQdzNDcLDDwKu2DCZInwCG+t8zxVAoJoobqy2NLyv0GOFopnYHONpb0B0okQPYOebRx4Bqprg
	5B52nTQ==
X-Google-Smtp-Source: AGHT+IF/MsWtitpYBRrB7SlBYDAk36Vj1bzh4ME0GTQ/U++QGLuF+9AXN185HkhWGohHoPbQawzS+yjMke4=
X-Received: from pjk5.prod.google.com ([2002:a17:90b:5585:b0:343:6849:31ae])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3dcb:b0:32e:528c:60ee
 with SMTP id 98e67ed59e1d1-343fa62bf59mr1148602a91.24.1763077077060; Thu, 13
 Nov 2025 15:37:57 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 13 Nov 2025 15:37:42 -0800
In-Reply-To: <20251113233746.1703361-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251113233746.1703361-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
Message-ID: <20251113233746.1703361-6-seanjc@google.com>
Subject: [PATCH v5 5/9] KVM: VMX: Handle MMIO Stale Data in VM-Enter assembly
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
MMIO Stale Data via X86_FEATURE_CLEAR_CPU_BUF_VM_MMIO, another mitigation
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
Reviewed-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/vmenter.S | 16 ++++++++++++++--
 arch/x86/kvm/vmx/vmx.c     | 13 -------------
 2 files changed, 14 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmenter.S b/arch/x86/kvm/vmx/vmenter.S
index 7e7bb9b7162f..92a85d95b3e4 100644
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
@@ -164,8 +165,19 @@ SYM_FUNC_START(__vmx_vcpu_run)
 	/* Load guest RAX.  This kills the @regs pointer! */
 	mov VCPU_RAX(%_ASM_AX), %_ASM_AX
 
-	/* Clobbers EFLAGS.ZF */
-	VM_CLEAR_CPU_BUFFERS
+	/*
+	 * Note, ALTERNATIVE_2 works in reverse order.  If CLEAR_CPU_BUF_VM is
+	 * enabled, do VERW unconditionally.  If CPU_BUF_VM_MMIO is enabled,
+	 * check @flags to see if the vCPU has access to host MMIO, and if so,
+	 * do VERW.  Else, do nothing (no mitigations needed/enabled).
+	 */
+	ALTERNATIVE_2 "",									  \
+		      __stringify(testl $VMX_RUN_CLEAR_CPU_BUFFERS_FOR_MMIO, WORD_SIZE(%_ASM_SP); \
+				  jz .Lskip_mmio_verw;						  \
+				  VERW;								  \
+				  .Lskip_mmio_verw:),					  	  \
+		      X86_FEATURE_CLEAR_CPU_BUF_VM_MMIO,					  \
+		      __stringify(VERW), X86_FEATURE_CLEAR_CPU_BUF_VM
 
 	/* Check @flags to see if vmlaunch or vmresume is needed. */
 	testl $VMX_RUN_VMRESUME, WORD_SIZE(%_ASM_SP)
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 18d9e0eacd0f..e378bd4d875c 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7340,21 +7340,8 @@ static noinstr void vmx_vcpu_enter_exit(struct kvm_vcpu *vcpu,
 
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
-	else if (cpu_feature_enabled(X86_FEATURE_CLEAR_CPU_BUF_VM_MMIO) &&
-		 (flags & VMX_RUN_CLEAR_CPU_BUFFERS_FOR_MMIO))
-		x86_clear_cpu_buffers();
 
 	vmx_disable_fb_clear(vmx);
 
-- 
2.52.0.rc1.455.g30608eb744-goog


