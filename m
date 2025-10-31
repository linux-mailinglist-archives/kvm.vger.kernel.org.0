Return-Path: <kvm+bounces-61622-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 79EDDC22C7F
	for <lists+kvm@lfdr.de>; Fri, 31 Oct 2025 01:30:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 7912D4E4C6A
	for <lists+kvm@lfdr.de>; Fri, 31 Oct 2025 00:30:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0B7E81D6193;
	Fri, 31 Oct 2025 00:30:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="AjBqu+q+"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8A3D282EB
	for <kvm@vger.kernel.org>; Fri, 31 Oct 2025 00:30:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761870648; cv=none; b=Zi705of3PdR6k8v8CklcAQQLQJk0PS6x95MGLnXhHFL5qR1QYMGJ7BsO2QkKLrcaf7ETdag4v9GkqEb+tuyUqB+/w/PU5diryqiBKsbBXdvzM8AZQo04wxWXLxM8mmspGT1HpXiUsjJ8RjZZpjpk7+RdRm5l825luK0tclZS1jc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761870648; c=relaxed/simple;
	bh=gPlIzeYfDGA258jPLcMw5THFnBDkxmCSUZp7s7X0tso=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=jmwdoD9QIGjNXSMhYNMacJ/RvTR1VBwgefyg3WI+XgqEcrnchoqVRSOG9S2mjuOlLe6hrE4wX7YzYairvfaCigB9Or12MGUYZlEy/OeoiKGoamj6HSDWBTO4bh6/v8kMT4kh74Ire6jk21LOxsAnsf4TdZwVec2GCWd51RJoJw0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=AjBqu+q+; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-33bbbb41a84so3547317a91.1
        for <kvm@vger.kernel.org>; Thu, 30 Oct 2025 17:30:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761870646; x=1762475446; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=N9tLwYhb23pEKSJRiBqjQRx2hF9R/IX4UqNL3Rew01U=;
        b=AjBqu+q+tVHL/283CThnrg2QOnLWgeIg8rddbTbStwFfNedQYtGxwfHIzFiYO2ZPRS
         wskXVqtb7PjU2vAjqif9wHZGzowap/QcR3iJ9i6dneagAMaroz28YFA/Y15RxQa11Hg+
         t9XwtQN0gH3L7z7AYQV/jMxtMeVg1GH5T7iAGFqG92vbb7rLmwy+Qw5ZYmimdHkUtulx
         HSUEsSPQu9Hg58sR2GW6K9lAbgqcz01soPxSG6nib1WJbDrvQ5yy7VJ3TQ6CHeF6SQCk
         /gYaYANkL+eIiGoZKmvw7B30nUg1G8igMyQCPXnBfv/pdrhkurLF+gCm/8wn/2J6qqfR
         SZSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761870646; x=1762475446;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=N9tLwYhb23pEKSJRiBqjQRx2hF9R/IX4UqNL3Rew01U=;
        b=HjhZv5ggdd9y6GOyrc8tAGHRKzmOiEkmTNUJ0daH5bTmMeFRfIiU+AiDPp1UUfxPqw
         yPF13/nC+rbER3XikNgr9Iu8mw6Cuj2kwy+R3dsInJQQLxzLmfq3bKl5bHLTVFkHNs6j
         2jVb6KSh4l80lh8UAEKH/Lx97+yNpMrLrXZfOT606mXaBoFXOZ2A4cutzUDJoeW6ou1M
         Y7eTsnWp7DApEPS//926xjgVj//NueAh2btITjeUvfNi38OIr/iI3surmepfSSY9Lu66
         3PrMHazYso+R8odEZ9THJHPO7QIkERcqMZQiYn2925/mghKqdXvoOIPDK5MauKTNLupR
         9GPw==
X-Gm-Message-State: AOJu0YxKsf8lOSznoneYt2h+D68T46YbkiREuMAGJq00KndGG0FeiMeT
	9J8xtDhDuBAh7grxhFdhG0V6cLGr4wUYqwpBTftRUg3/QgMq2B6VPkQDVKXYARHoFmOrW+0FxmI
	2/+5DLQ==
X-Google-Smtp-Source: AGHT+IFIqP2Br1l+AyG7RNfviFrGrRQqmryzEkiWym/i/FBoJUjmhjd2KxgCWe8EgzaFaRKz53fKGFoZgGQ=
X-Received: from pjod4.prod.google.com ([2002:a17:90a:8d84:b0:33b:51fe:1a7a])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3a90:b0:340:2942:dbfe
 with SMTP id 98e67ed59e1d1-34083055450mr2147907a91.17.1761870645952; Thu, 30
 Oct 2025 17:30:45 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 30 Oct 2025 17:30:32 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.51.1.930.gacf6e81ea2-goog
Message-ID: <20251031003040.3491385-1-seanjc@google.com>
Subject: [PATCH v4 0/8] x86/bugs: KVM: L1TF and MMIO Stale Data cleanups
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@alien8.de>, Peter Zijlstra <peterz@infradead.org>, 
	Josh Poimboeuf <jpoimboe@kernel.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>, Brendan Jackman <jackmanb@google.com>
Content-Type: text/plain; charset="UTF-8"

This is a combination of Brendan's work to unify the L1TF L1D flushing
mitigation, and Pawan's work to bring some sanity to the mitigations that
clear CPU buffers, with a bunch of glue code and some polishing from me.

The "v4" is relative to the L1TF series.  I smushed the two series together
as Pawan's idea to clear CPU buffers for MMIO in vmenter.S obviated the need
for a separate cleanup/fix to have vmx_l1d_flush() return true/false, and
handling the series separately would have been a lot of work+churn for no
real benefit.

TL;DR:

 - Unify L1TF flushing under per-CPU variable
 - Bury L1TF L1D flushing under CONFIG_CPU_MITIGATIONS=y
 - Move MMIO Stale Data into asm, and do VERW at most once per VM-Enter

To allow VMX to use ALTERNATIVE_2 to select slightly different flows for doing
VERW, tweak the low lever macros in nospec-branch.h to define the instruction
sequence, and then wrap it with __stringify() as needed.

The non-VMX code is lightly tested (but there's far less chance for breakage
there).  For the VMX code, I verified it does what I want (which may or may
not be correct :-D) by hacking the code to force/clear various mitigations, and
using ud2 to confirm the right path got selected.

v4:
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

Sean Christopherson (6):
  x86/bugs: Decouple ALTERNATIVE usage from VERW macro definition
  x86/bugs: Use an X86_FEATURE_xxx flag for the MMIO Stale Data
    mitigation
  KVM: VMX: Handle MMIO Stale Data in VM-Enter assembly via
    ALTERNATIVES_2
  x86/bugs: KVM: Move VM_CLEAR_CPU_BUFFERS into SVM as
    SVM_CLEAR_CPU_BUFFERS
  KVM: VMX: Bundle all L1 data cache flush mitigation code together
  KVM: VMX: Disable L1TF L1 data cache flush if CONFIG_CPU_MITIGATIONS=n

 arch/x86/include/asm/cpufeatures.h   |   1 +
 arch/x86/include/asm/hardirq.h       |   4 +-
 arch/x86/include/asm/kvm_host.h      |   3 -
 arch/x86/include/asm/nospec-branch.h |  24 +--
 arch/x86/kernel/cpu/bugs.c           |  18 +-
 arch/x86/kvm/mmu/mmu.c               |   2 +-
 arch/x86/kvm/mmu/spte.c              |   2 +-
 arch/x86/kvm/svm/vmenter.S           |   6 +-
 arch/x86/kvm/vmx/nested.c            |   2 +-
 arch/x86/kvm/vmx/vmenter.S           |  14 +-
 arch/x86/kvm/vmx/vmx.c               | 235 ++++++++++++++-------------
 arch/x86/kvm/x86.c                   |   6 +-
 arch/x86/kvm/x86.h                   |  14 ++
 13 files changed, 178 insertions(+), 153 deletions(-)


base-commit: 4cc167c50eb19d44ac7e204938724e685e3d8057
-- 
2.51.1.930.gacf6e81ea2-goog


