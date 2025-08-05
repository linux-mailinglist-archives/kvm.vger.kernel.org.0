Return-Path: <kvm+bounces-54054-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5D803B1BB57
	for <lists+kvm@lfdr.de>; Tue,  5 Aug 2025 22:22:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0EAFF18A610C
	for <lists+kvm@lfdr.de>; Tue,  5 Aug 2025 20:22:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 98391242D87;
	Tue,  5 Aug 2025 20:22:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="r6aYExZi"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 615581401B
	for <kvm@vger.kernel.org>; Tue,  5 Aug 2025 20:22:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754425350; cv=none; b=Fx5xATB9zFdfyGSMRWVvR+cvwwYVyuF+mO0x/7Yji6CQ81dGe8SNl3xZ311MpzxMOqvbUgpdtAPFnqfonqX4gP5Hv7kuvv2ND8IwrOyAMy8Q7G9VB/nKOARBTMDHZyLqvvrMlKUsTzLmEfFge0iu8T6Wejo44CKNymJ9y40fSFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754425350; c=relaxed/simple;
	bh=QcBUlYt1R7LPHeweiP1yPx9OZlFVFmYXWZvSDuChNI8=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=iUTm24Co4Am60AIqcuxeBKH0Z/rONF4UcB6uG564qHLcx2kBaJa057fJLwuOxP8hvdXjeEtRrl7CQ9pqzO4e1A10sgXsSd50s4gy7ihb5ulUAT8y6tVrUeRBZQKEGmOYbmynXspBfTA2JrXg9kerLcW8mEvQ0ziXykfpSNyGNzU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=r6aYExZi; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-31edd69d754so4530649a91.1
        for <kvm@vger.kernel.org>; Tue, 05 Aug 2025 13:22:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754425349; x=1755030149; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rIKuNcCEEy4d1Lnb9vFuuPNEj5BYXJY2MfS6bx587ys=;
        b=r6aYExZivSM5ZVcbCBx/GpXgO7wolXJ0vQ2tTN9q96xKva9HiGr+r9YAlOVycT6ae2
         9uDSm928UHoJlzv2eUR/MUTzSWCM6EIyNHog4gWaSKTVN4IF9LKC6LqqQTNEBmqWMgIe
         0vN72LpLMOViftgSvV12Q5LfpkGqyEAhRgQM1hl/OqZZEHvLOAR253WpvoeZxLiG3R5+
         EeRWeRFvBRkxxoRNwcWjyuKdsB1KYvfDQ2sEv19MYZ4CbIDqIja0UrRv+jZO4+al3cpe
         2c7GyqaMiZ+nqhfls2KtQ1gfRdhVMJtakmjrn5i3bmTNhEPcMcttRj37gYTfrqX7N5ct
         7AFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754425349; x=1755030149;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rIKuNcCEEy4d1Lnb9vFuuPNEj5BYXJY2MfS6bx587ys=;
        b=KQdJQdOh8vLPbfpVv1g/gQGbnemohdF0tZJGyKg8lOeF5Fe5TURea1cSafYnIXovst
         qjy6cmYM2KRMH+WfC9DvjsEfItvtbOKwToc2kjXFrnu0j3zZDcyDq9qce7u7UkcSJ4SM
         bggUhCSGJheKdlcaBYOGsiL3Y/NfmwORCzRMY64BqV/9igqmcAgRGWsomlfWihTLODX3
         7WEwyqbUPXy7uVYpePosSajo5R91nb/nWXE0DfYCWCry0Be/1TGMCcPpj3BlhE7eKi3m
         fs0lRTysUU/PFIoxY/5rRoWpthPETxQAcDzeZX3O3DMDJrbeNWFO0fZwnQ3rw6ngOmY9
         94TQ==
X-Gm-Message-State: AOJu0Yxa/JTyg7BMnQMk4a8VWrdTjkPOuV9byxcj7j5nHEt6L8rJGVDy
	AoiOuXctZyyEr2VLBXJjDqEVywzrvUxXm7esHvR96mO+EcvdPLQ55UmBsKYISjDmYC94bEFuCY8
	eVKY+Ew==
X-Google-Smtp-Source: AGHT+IE6U61qhafIDWBzagByS8xaVy780THwV6kGJd6xzP4Z+/iOWdC/TR08MgA3sk98reGaWJVBTybIPvc=
X-Received: from pjqo21.prod.google.com ([2002:a17:90a:ac15:b0:312:1e70:e233])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3848:b0:31f:1744:e7fd
 with SMTP id 98e67ed59e1d1-321675ac368mr90445a91.31.1754425348700; Tue, 05
 Aug 2025 13:22:28 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue,  5 Aug 2025 13:22:18 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.50.1.565.gc32cd1483b-goog
Message-ID: <20250805202224.1475590-1-seanjc@google.com>
Subject: [PATCH v3 0/6] KVM: VMX: Handle the immediate form of MSR instructions
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Borislav Petkov <bp@alien8.de>, Xin Li <xin@zytor.com>
Content-Type: text/plain; charset="UTF-8"

On behalf of Xin, to avoid having to resolve conflicts when applying.
This applies on the fastpath cleanup series:
https://lore.kernel.org/all/20250805190526.1453366-1-seanjc@google.com

This patch set handles two newly introduced VM exit reasons associated
with the immediate form of MSR instructions to ensure proper
virtualization of these instructions.

The immediate form of MSR access instructions are primarily motivated
by performance, not code size: by having the MSR number in an immediate,
it is available *much* earlier in the pipeline, which allows the
hardware much more leeway about how a particular MSR is handled.

For proper virtualization of the immediate form of MSR instructions,
Intel VMX architecture adds the following changes:

  1) The immediate form of RDMSR uses VM exit reason 84.

  2) The immediate form of WRMSRNS uses VM exit reason 85.

  3) For both VM exit reasons 84 and 85, the exit qualification is set
     to the MSR address causing the VM exit.

  4) Bits 3 ~ 6 of the VM exit instruction information field represent
     the operand register used in the immediate form of MSR instruction.

  5) The VM-exit instruction length field records the size of the
     immediate form of the MSR instruction.

Note: The VMX specification for the immediate form of MSR instructions
was inadvertently omitted from the last published ISE, but it will be
included in the upcoming edition.

Linux bare metal support of the immediate form of MSR instructions is
still under development; however, the KVM support effort is proceeding
independently of the bare metal implementation.

v3:
 - Rebase on the fastpath cleanups.
 - Split patches to better isolate the functional changes.
 - Massage and expand on a changelogs.
 - Make a handful of (mostly) stylistic changes (shouldn't affect
   functionality, key word "should").

v2: https://lore.kernel.org/all/20250802001520.3142577-1-xin@zytor.com
v1: https://lore.kernel.org/lkml/20250730174605.1614792-1-xin@zytor.com

Sean Christopherson (1):
  KVM: x86: Rename local "ecx" variables to "msr" and "pmc" as
    appropriate

Xin Li (5):
  x86/cpufeatures: Add a CPU feature bit for MSR immediate form
    instructions
  KVM: x86: Rename handle_fastpath_set_msr_irqoff() to
    handle_fastpath_wrmsr()
  KVM: x86: Add support for RDMSR/WRMSRNS w/ immediate on Intel
  KVM: VMX: Support the immediate form of WRMSRNS in the VM-Exit
    fastpath
  KVM: x86: Advertise support for the immediate form of MSR instructions

 arch/x86/include/asm/cpufeatures.h |  1 +
 arch/x86/include/asm/kvm_host.h    |  4 ++
 arch/x86/include/uapi/asm/vmx.h    |  6 +-
 arch/x86/kernel/cpu/scattered.c    |  1 +
 arch/x86/kvm/cpuid.c               |  6 +-
 arch/x86/kvm/reverse_cpuid.h       |  5 ++
 arch/x86/kvm/svm/svm.c             |  8 ++-
 arch/x86/kvm/vmx/nested.c          | 13 ++++-
 arch/x86/kvm/vmx/vmx.c             | 26 ++++++++-
 arch/x86/kvm/vmx/vmx.h             |  5 ++
 arch/x86/kvm/x86.c                 | 94 ++++++++++++++++++++++--------
 arch/x86/kvm/x86.h                 |  3 +-
 12 files changed, 139 insertions(+), 33 deletions(-)


base-commit: 53d61a43a7973f812caa08fa922b607574befef4
-- 
2.50.1.565.gc32cd1483b-goog


