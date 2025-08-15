Return-Path: <kvm+bounces-54725-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4FAC6B273BE
	for <lists+kvm@lfdr.de>; Fri, 15 Aug 2025 02:25:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 495EC17471B
	for <lists+kvm@lfdr.de>; Fri, 15 Aug 2025 00:25:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3824D282EB;
	Fri, 15 Aug 2025 00:25:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="3ahrOL6o"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF68DA926
	for <kvm@vger.kernel.org>; Fri, 15 Aug 2025 00:25:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755217546; cv=none; b=Q0PFsGk+S5nTaE3sF3qAFJJue9DHqkTttqnDnpUZwblDiT4sGQ73IRT7CLCuWfgklnUUEz9lz/J3LGSfqw2jBG5tdxLMwoZYjYIoYBuxeCrAWj23IUAIJaBh0Lr3c1fdF8Wxbvk1hG4eJpSGFcm7fJW9XPGkdy39aJeCTKtzNbw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755217546; c=relaxed/simple;
	bh=JKI720vt7QEil30Jfj6xnkXSugJaBGfS5qsvBzopfBs=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=LFLFnWUrGj3pSm3YgVqj0svYU3D1+tEg5UrWXp2axta1oy8vBVMHX+ilWemX0cxe8nI7zDHuMTn8tCi59hLZWkZiwisZy0fxr2r3rjrX+Eef/HHjP1xMkT9SotUQw3nC+5lyn/DI9cDwXWNhIwXeK1ncvs6yoTVukoKCJaO/+rU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=3ahrOL6o; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-24457efb475so17442225ad.0
        for <kvm@vger.kernel.org>; Thu, 14 Aug 2025 17:25:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755217544; x=1755822344; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WZJJF6wTF+BZ7erSZwQoxWh2GZlvEJtjYuPdirsln1Y=;
        b=3ahrOL6otjAnYf3vv6cV9OXiqQTOm/HrUrmsEAdf9qCK9IgDjp0KOaRTAQtbi/1Zqv
         FjKtd0y4tPtqy4JHk8/05bhCmGdxVQBYAnO0dDuqxpGSjnR2G8/WMgUtTqnh2nuC9iJC
         tbjrvTRcmkx2yFIruh+7D4Vj+9uuu5HEbyJqugNq3Y4uz1mkegjCGu+rxz536k9nw25u
         ft8ksVK6+3OARYZwtSKFSRLfQOJ/SieUeBGh5ywAl3xLii0RUZ+xLImdW6mgs3CnwJyU
         g+bkyDmIrVOLXkVGsvEEBOSFeynAhOfP402oImajyxPKkBInsd3KWJXRXXpDlw9cFQ4E
         cHlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755217544; x=1755822344;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WZJJF6wTF+BZ7erSZwQoxWh2GZlvEJtjYuPdirsln1Y=;
        b=riHLv7TLBDLvdbppdssSVprjGwsRA/tB3wkYOZxSQe8pgwLlZOwqijcKtooSE8xNT3
         l3RsPDxqGpSYuizNzq815kJ+WhhILafsGkSo7FTb+Tah04MqSU3MjQSY1x6aa8OKnrZw
         SsNnPV0OYZeTclfH74mUQDBPwCE014DKijlMFcEGyXMwKRLtsyq0zjfu7WFL7+kx3f7D
         rwwevTkV0eR/uzZYRPgCt2EITu2f12vIlIFhHEI5uua1kQV0Lg6rylNlq+ZuSkm3+gWI
         BKsvmWf4/f4Z/d7R6pCj8irOQ1OzwRjsJ2LinR/hE+aVWBO7FmY4/itbNXY+CF+fc2K+
         kUMg==
X-Gm-Message-State: AOJu0YwvmEEtlHiJvMv1XVBWv4pz1qKdHEgnyNJJnt0ciLZyTLkG7fmG
	+nAiIjU2JMX1RVoV+yEdjqDasp14O73UD95eytehlPdiVzjBaNNxdK3J9Q939ycO5y8uIV/yH1P
	35/05ZA==
X-Google-Smtp-Source: AGHT+IGnXGGMRhOfG2atnAVCAAEYr2mCt7hhg4jO3kMfdxsXlK8f1c0VzuyQn6W5n2cG3fj5Bn5EGFZtl8E=
X-Received: from plwp11.prod.google.com ([2002:a17:903:248b:b0:244:661d:4a19])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:1aac:b0:240:cd3e:d860
 with SMTP id d9443c01a7336-2446d927d92mr1841645ad.41.1755217544123; Thu, 14
 Aug 2025 17:25:44 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 14 Aug 2025 17:25:20 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.51.0.rc1.163.g2494970778-goog
Message-ID: <20250815002540.2375664-1-seanjc@google.com>
Subject: [PATCH 6.6.y 00/20] KVM: x86: Backports for 6.6.y
From: Sean Christopherson <seanjc@google.com>
To: stable@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Sasha Levin <sashal@kernel.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"

Same spiel as the 6.1.y collection...

This is a collection of backports for patches that were Cc'd to stable,
but failed to apply, along with their dependencies.

Note, Sasha already posted[1][2] these (and I acked them):

  KVM: VMX: Allow guest to set DEBUGCTL.RTM_DEBUG if RTM is supported
  KVM: x86/pmu: Gate all "unimplemented MSR" prints on report_ignored_msrs
  KVM: VMX: Extract checking of guest's DEBUGCTL into helper
  KVM: nVMX: Check vmcs12->guest_ia32_debugctl on nested VM-Enter
  KVM: VMX: Wrap all accesses to IA32_DEBUGCTL with getter/setter APIs

I'm including them here to hopefully make life easier for y'all, and because
the order they are presented here is the preferred ordering, i.e. should be
the same ordering as the original upstream patches.

But, if you end up grabbing Sasha's patches first, it's not a big deal as the
only true dependencies is that the DEBUGCTL.RTM_DEBUG patch needs to land
before "Check vmcs12->guest_ia32_debugctl on nested VM-Enter".

Many of the patches to get to the last patch (the DEBUGCTLMSR_FREEZE_IN_SMM
fix) are dependencies that arguably shouldn't be backported to LTS kernels.
I opted to do the backports because none of the patches are scary (if it was
1-3 dependency patches instead of 8 I wouldn't hesitate), and there's a decent
chance they'll be dependencies for future fixes.

[1] https://lore.kernel.org/all/20250813183728.2070321-1-sashal@kernel.org
[2] https://lore.kernel.org/all/20250814131146.2093579-1-sashal@kernel.org

Chao Gao (1):
  KVM: nVMX: Defer SVI update to vmcs01 on EOI when L2 is active w/o VID

Manuel Andreas (1):
  KVM: x86/hyper-v: Skip non-canonical addresses during PV TLB flush

Maxim Levitsky (3):
  KVM: nVMX: Check vmcs12->guest_ia32_debugctl on nested VM-Enter
  KVM: VMX: Wrap all accesses to IA32_DEBUGCTL with getter/setter APIs
  KVM: VMX: Preserve host's DEBUGCTLMSR_FREEZE_IN_SMM while running the
    guest

Sean Christopherson (15):
  KVM: SVM: Set RFLAGS.IF=1 in C code, to get VMRUN out of the STI
    shadow
  KVM: x86: Plumb in the vCPU to kvm_x86_ops.hwapic_isr_update()
  KVM: x86: Take irqfds.lock when adding/deleting IRQ bypass producer
  KVM: x86: Snapshot the host's DEBUGCTL in common x86
  KVM: x86: Snapshot the host's DEBUGCTL after disabling IRQs
  KVM: x86: Plumb "force_immediate_exit" into kvm_entry() tracepoint
  KVM: VMX: Re-enter guest in fastpath for "spurious" preemption timer
    exits
  KVM: VMX: Handle forced exit due to preemption timer in fastpath
  KVM: x86: Move handling of is_guest_mode() into fastpath exit handlers
  KVM: VMX: Handle KVM-induced preemption timer exits in fastpath for L2
  KVM: x86: Fully defer to vendor code to decide how to force immediate
    exit
  KVM: x86: Convert vcpu_run()'s immediate exit param into a generic
    bitmap
  KVM: x86: Drop kvm_x86_ops.set_dr6() in favor of a new KVM_RUN flag
  KVM: VMX: Allow guest to set DEBUGCTL.RTM_DEBUG if RTM is supported
  KVM: VMX: Extract checking of guest's DEBUGCTL into helper

 arch/x86/include/asm/kvm-x86-ops.h |   2 -
 arch/x86/include/asm/kvm_host.h    |  22 ++--
 arch/x86/include/asm/msr-index.h   |   1 +
 arch/x86/kvm/hyperv.c              |   3 +
 arch/x86/kvm/lapic.c               |  19 +++-
 arch/x86/kvm/lapic.h               |   1 +
 arch/x86/kvm/svm/svm.c             |  42 +++++---
 arch/x86/kvm/svm/vmenter.S         |   9 +-
 arch/x86/kvm/trace.h               |   9 +-
 arch/x86/kvm/vmx/nested.c          |  26 ++++-
 arch/x86/kvm/vmx/pmu_intel.c       |   8 +-
 arch/x86/kvm/vmx/vmx.c             | 164 +++++++++++++++++++----------
 arch/x86/kvm/vmx/vmx.h             |  31 +++++-
 arch/x86/kvm/x86.c                 |  46 +++++---
 14 files changed, 265 insertions(+), 118 deletions(-)


base-commit: 3a8ababb8b6a0ced2be230b60b6e3ddbd8d67014
-- 
2.51.0.rc1.163.g2494970778-goog


