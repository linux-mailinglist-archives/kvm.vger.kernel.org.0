Return-Path: <kvm+bounces-63106-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 5D424C5AA59
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 00:40:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 0CAEA342FF9
	for <lists+kvm@lfdr.de>; Thu, 13 Nov 2025 23:37:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C1947329C69;
	Thu, 13 Nov 2025 23:37:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="G+YpiXtY"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AC022C21F0
	for <kvm@vger.kernel.org>; Thu, 13 Nov 2025 23:37:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763077070; cv=none; b=Prg2Sj0HOuoCg4quI8lp+6uajSEHnBr4KKS4WlDuWfvzU/dqH+HuOLYUXAenUnTp+LR39LH9URK3l+QHN33DDONXBrWVAEcbqJOA6aKnFzd6KGxjWYN0hatciNT6kkCSmzM6kstyTGKZHYuZ76D1zMhCYgUIVANFo1DIOSpif7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763077070; c=relaxed/simple;
	bh=903kH64MTPH0FrxO2I20SFsP3QXq7CDc5tgGcADtgls=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=lNBr8yp5m7dcax6f0ieMzQJPJQCBvh6GyssqwWVf40MhB6ym7c9CI5aAjO5Zk0xwQH9QpnGzY6ag/tAEQ5YgGdH0qKnwZiE/jzBHdAAO6rPHe0sRStxwxcERZg+R39bxzni5tvm92gYFutTs6BRyM9xAu+3T2mto/lq02syhUms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=G+YpiXtY; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-7b90740249dso2790819b3a.0
        for <kvm@vger.kernel.org>; Thu, 13 Nov 2025 15:37:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763077069; x=1763681869; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xkbtepi4QW5KzyC1xYbQMyK3Quk4zx3aODNb7TaxfU4=;
        b=G+YpiXtYtBrPyA5SUwm7NkHEpmRHio6/kTWLJAIugl4pE+j1SZHNy1GMWkG8Nop/FZ
         IDeuV/yYVbopkKuRz/+3kT1N6+4+MFiNPca06t6MvH3G4w4L2LAj4BMtQosmt67MJZAd
         M7vK+FsEaiWkaFq7ZgNfR4535NcdTv540fvyGeUPeIB0axJVIODrx5RQQhiVnXrZSrfT
         CL3cOxYmQNqCqrKrTXL9+SCNxlHlGerI1+qhIA+sS6OkfBLJHijMPjbisLbmjCUXFK1N
         z9Gm8MVnQxcjvfjLVVuYLuLU6R5ulQc0WM2RLri5WkJr32yV8j6gGJQOhlVNQpi2Yib/
         Mc2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763077069; x=1763681869;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xkbtepi4QW5KzyC1xYbQMyK3Quk4zx3aODNb7TaxfU4=;
        b=rGL7Hsct+HSn8m1ft5mfENdJ7yvoQ4sBI1K7DZ0Q97EQFArRVKCXx+jDbNADul8jHb
         QBcfFetEdMtU56HEBs1njZpexDWTxOAKaCvNpmMFpcgKt8LgnueRzm6JqkXrM84bb7en
         3gKS+65TwmUNHbJg3UxpfQujEpG+j5acN9lK4SIIzTXzarUsxh8A95At7xcXGMpwQb3E
         S6CE5ROtXwpeidUBGJQMaeIRWAj4EPa5xiA/yGLbzcOCZ0atb7+YzyeWYOwMEi1fRwrP
         HVsBmBquxwoxu1W0jcHVqqJCt7JcXxUxTy9Xv+kT6wnsb2/kb3MVojx3KWzYDA7fdfVx
         D1xA==
X-Gm-Message-State: AOJu0Yy5GRgDluM3TizBt8SvBklJhH3tYkMCoMBks2upiG4jg7kuHscE
	LUSR0bc/m1HqjZANNUzWNgHd0pADtCJicg/23UHi3cMAzKNqFH9rR8Jvava99FKzVOyaV5hQPpG
	nv1nZsw==
X-Google-Smtp-Source: AGHT+IE58RfmRBXykqVVjWdyfAqYsq5Vc+2tQaoSIgGjVQwUWponWGs2XzQBYvFCrtYDYQ+KnLfCzVvOkDI=
X-Received: from pgna19.prod.google.com ([2002:a63:7053:0:b0:bc3:57f1:bc8e])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:7349:b0:34e:1009:4216
 with SMTP id adf61e73a8af0-35ba057f8ebmr1598941637.24.1763077068543; Thu, 13
 Nov 2025 15:37:48 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 13 Nov 2025 15:37:37 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
Message-ID: <20251113233746.1703361-1-seanjc@google.com>
Subject: [PATCH v5 0/9] x86/bugs: KVM: L1TF and MMIO Stale Data cleanups
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@alien8.de>, Peter Zijlstra <peterz@infradead.org>, 
	Josh Poimboeuf <jpoimboe@kernel.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>, Brendan Jackman <jackmanb@google.com>
Content-Type: text/plain; charset="UTF-8"

Clean up KVM's handling of L1TF and MMIO Stale data, as the code has bit
rotted a bit and is harder than it should be to understand, and has a few
warts.

TL;DR:

 - Unify L1TF flushing under per-CPU variable
 - Bury L1TF L1D flushing under CONFIG_CPU_MITIGATIONS=y
 - Move MMIO Stale Data into asm, and do VERW at most once per VM-Enter

To allow VMX to use ALTERNATIVE_2 to select slightly different flows for doing
VERW, tweak the low lever macros in nospec-branch.h to define the instruction
sequence, and then wrap it with __stringify() as needed.

As before, the non-VMX code is lightly tested (but there's far less chance
for breakage there).  For the VMX code, I verified the KVM side of things by
hacking the code to force/clear various mitigations, and using ud2 to confirm
the right path got selected.

v5:
 - Collect reviews and acks.
 - Add/improve comments for various macros and flows. [Everyone]
 - s/CLEAR_CPU_BUFFERS_SEQ/VERW [Pawan, Boris]
 - Use the on-stack copy of @flags instead of stashing information in
   RFLAGS' arithmetic flags. [Boris]
 - Fix typos (hopefully). [Boris]

v4:
 - https://lore.kernel.org/all/20251031003040.3491385-1-seanjc@google.com
 - Drop the patch to fallback to handling the MMIO mitigation if
   vmx_l1d_flush() doesn't flush, and instead use Pawan's approach of
   decoupling the two entirely.
 - Replace the static branch with X86_FEATURE_CLEAR_CPU_BUF_MMIO so that
   it can be referenced in ALTERNATIVE macros.
 - Decouple X86_FEATURE_CLEAR_CPU_BUF_VM from X86_FEATURE_CLEAR_CPU_BUF_MMIO
   (though they still interact and can both be set)

v3:
 - https://lore.kernel.org/all/20251016200417.97003-1-seanjc@google.com
 - [Pawan's series] https://lore.kernel.org/all/20251029-verw-vm-v1-0-babf9b961519@linux.intel.com
 - Put the "raw" variant in KVM, dress it up with KVM's "request" terminology,
   and add a comment explaining why _KVM_ knows its usage doesn't need to
   disable virtualization.
 - Add the prep patches.

v2:
 - https://lore.kernel.org/all/20251015-b4-l1tf-percpu-v2-1-6d7a8d3d40e9@google.com
 - Moved the bit back to irq_stat
 - Fixed DEBUG_PREEMPT issues by adding a _raw variant

v1: https://lore.kernel.org/r/20251013-b4-l1tf-percpu-v1-1-d65c5366ea1a@google.com

Brendan Jackman (1):
  KVM: x86: Unify L1TF flushing under per-CPU variable

Pawan Gupta (1):
  x86/bugs: Use VM_CLEAR_CPU_BUFFERS in VMX as well

Sean Christopherson (7):
  KVM: VMX: Use on-stack copy of @flags in __vmx_vcpu_run()
  x86/bugs: Decouple ALTERNATIVE usage from VERW macro definition
  x86/bugs: Use an x86 feature to track the MMIO Stale Data mitigation
  KVM: VMX: Handle MMIO Stale Data in VM-Enter assembly via
    ALTERNATIVES_2
  x86/bugs: KVM: Move VM_CLEAR_CPU_BUFFERS into SVM as
    SVM_CLEAR_CPU_BUFFERS
  KVM: VMX: Bundle all L1 data cache flush mitigation code together
  KVM: VMX: Disable L1TF L1 data cache flush if CONFIG_CPU_MITIGATIONS=n

 arch/x86/include/asm/cpufeatures.h   |   5 +
 arch/x86/include/asm/hardirq.h       |   4 +-
 arch/x86/include/asm/kvm_host.h      |   3 -
 arch/x86/include/asm/nospec-branch.h |  25 ++-
 arch/x86/kernel/cpu/bugs.c           |  22 +--
 arch/x86/kvm/mmu/mmu.c               |   2 +-
 arch/x86/kvm/mmu/spte.c              |   2 +-
 arch/x86/kvm/svm/vmenter.S           |   6 +-
 arch/x86/kvm/vmx/nested.c            |   2 +-
 arch/x86/kvm/vmx/run_flags.h         |  10 +-
 arch/x86/kvm/vmx/vmenter.S           |  29 ++--
 arch/x86/kvm/vmx/vmx.c               | 235 ++++++++++++++-------------
 arch/x86/kvm/x86.c                   |   6 +-
 arch/x86/kvm/x86.h                   |  14 ++
 14 files changed, 193 insertions(+), 172 deletions(-)


base-commit: 16ec4fb4ac95d878b879192d280db2baeec43272
-- 
2.52.0.rc1.455.g30608eb744-goog


