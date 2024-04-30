Return-Path: <kvm+bounces-16264-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 634528B808C
	for <lists+kvm@lfdr.de>; Tue, 30 Apr 2024 21:32:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 839DD1C2307A
	for <lists+kvm@lfdr.de>; Tue, 30 Apr 2024 19:32:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 85886199E9C;
	Tue, 30 Apr 2024 19:32:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="pVbL//pF"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6826194C9D
	for <kvm@vger.kernel.org>; Tue, 30 Apr 2024 19:32:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714505522; cv=none; b=ojbE1aJaHI1CSFvaP4sHTFV4Q4W/jL6E6bQ0dYELtmtj8HvTWKFigzx5Ote+YKiA3hhewpCFHOeUUuTSx/ppDyn/wn/9w7/1Ne1+8L2XGpIDyn38mSWEfXgAqVZpgVAtVYF0C/cu1jsqyKufyp5F0YAvYBl2SLTN4GpxYnirnzA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714505522; c=relaxed/simple;
	bh=ZyEi6X5pCM2tp1slqyp4M7rxWVN5czCX48iQBtE7Jeo=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=Eb4T1+AKV34EDmstbOz/VcGDlRxJO4sYYQqFdZvLUIo96Bv8YIe9EG+SDGHM1cROc4m/vSiZDZaXecAarb+rgDxpUAa0IC5DbnChKnAOz0zZn/Yqrlu7iPenXQPs57BIcCx9VmuoXde66+/1jyfjqHujIxLNGxTLszkZVcZa0Ow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=pVbL//pF; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2ac3403b27eso6941949a91.0
        for <kvm@vger.kernel.org>; Tue, 30 Apr 2024 12:32:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1714505520; x=1715110320; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=z8cKIw53BRkz+z0+cac0VztUPzZ2bkNPe6LEvW4OcBU=;
        b=pVbL//pFn986soxarrKWGavPTzgb+nNosoRNSY7l4l+G7TXLTTPIsqVy8S3fRMOrGx
         kA2WtNhsSfmZ8NcJzpm58DPU4GvSzS5zOWDpMS1TXtzBDUKj6FnNzV4y8GIseweI3tc0
         mRilImRhOjk+WS3GLE2oARsGeH2N+K+ydBVllC/04KBn8mo7ItfLZDDNV+4gTNZTXzIF
         i5unsMQpZ7x15jTxb16NJohmtPwvwBbUKRRn9tO4eQA+EUQbUZiXKKkW2d0md3MwuaDn
         7JAJbATuYkYYWeLAWcESPrNuFQi+T4uS9aUddK0FrbVNayrWHJI/GKqZHg0LGOYZMhXq
         xcGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714505520; x=1715110320;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=z8cKIw53BRkz+z0+cac0VztUPzZ2bkNPe6LEvW4OcBU=;
        b=lVFRBIWBDK+Nh7lybrPvGeFq+Um83veBY0XNX2jfi/W6MBaIO5x2wW1nr4DUekJC3I
         lRcFmTlQ+JDE75rHUX4jXBaanWFnRrKKEU1NFoxzffHy3dgmjbshSGTLUQQgjXAJPab1
         PFzqiX+HN51+3MllTEliPOlnZ7XDVU0vQQrY8kJLxAByN/Ld0R4ZRIfHnfO0UvGyfIBE
         P8EDjIrAJR0lWQKw3vzNS+UDmFVxHDN1PAoev/qlWPJaSDHEyoMgx01qCde14vHu1Dmc
         NGh0a8qSysMHGxr6cf2i8ClzZc2ZnTKF8GVSi/VVWzkxXQv4gJfcMRYFb7ffTnXHj57q
         MVDA==
X-Forwarded-Encrypted: i=1; AJvYcCXyEKvFok9ZEdE2CY5z3zV29y1Ht/KGqtW+Wg3+s0fMJTE6typg7gGo3608WC6WkB9pn/VsIjH5ySfdZPENe0QIGgyB
X-Gm-Message-State: AOJu0Yxcc1oYXFXDXPRB/Eh258CNLPW/QMlyneWHrqEaIgrxrMYs5rfQ
	FpYKligPTHTLpz5I7Em6Io+PdFScztfVV9YS8n+Dakp+fxwKgvo3iypGRYm9jk4CkHfqM7RhIKE
	uuA==
X-Google-Smtp-Source: AGHT+IH3JUNqnUxIpxTDCx/ljNN0s2y6mLqDYiJH9gncvZUrZrTQ/cL7Kjz1TcqYgEZ6lTuIQ7azs+1F9y4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:e504:b0:2a2:ff01:dd7c with SMTP id
 t4-20020a17090ae50400b002a2ff01dd7cmr1190pjy.8.1714505520000; Tue, 30 Apr
 2024 12:32:00 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 30 Apr 2024 12:31:53 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.45.0.rc0.197.gbae5840b3b-goog
Message-ID: <20240430193157.419425-1-seanjc@google.com>
Subject: [PATCH 0/4] KVM: Fold kvm_arch_sched_in() into kvm_arch_vcpu_load()
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>, 
	Huacai Chen <chenhuacai@kernel.org>, Michael Ellerman <mpe@ellerman.id.au>, 
	Anup Patel <anup@brainfault.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, Sean Christopherson <seanjc@google.com>, 
	Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, loongarch@lists.linux.dev, linux-mips@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Drop kvm_arch_sched_in() and instead pass a @sched_in boolean to
kvm_arch_vcpu_load().

While fiddling with an idea for optimizing state management on AMD CPUs,
I wanted to skip re-saving certain host state when a vCPU is scheduled back
in, as the state (theoretically) shouldn't change for the task while it's
scheduled out.  Actually doing that was annoying and unnecessarily brittle
due to having a separate API for the kvm_sched_in() case (the state save
needed to be in kvm_arch_vcpu_load() for the common path).

E.g. I could have set a "temporary"-ish flag somewhere in kvm_vcpu, but (a)
that's gross and (b) it would rely on the arbitrary ordering between
sched_in() and vcpu_load() staying the same.

The only real downside I see is that arm64 and riscv end up having to pass
"false" for their direct usage of kvm_arch_vcpu_load(), and passing boolean
literals isn't ideal.  But that can be solved by adding an inner helper that
omits the @sched_in param (I almost added a patch to do that, but I couldn't
convince myself it was necessary).

The other motivation for this is to avoid yet another arch hook, and more
arbitrary ordering, if there's a future need to hook kvm_sched_out() (we've
come close on the x86 side several times).

Sean Christopherson (4):
  KVM: Plumb in a @sched_in flag to kvm_arch_vcpu_load()
  KVM: VMX: Move PLE grow/shrink helpers above vmx_vcpu_load()
  KVM: x86: Fold kvm_arch_sched_in() into kvm_arch_vcpu_load()
  KVM: Delete the now unused kvm_arch_sched_in()

 arch/arm64/include/asm/kvm_host.h     |  1 -
 arch/arm64/kvm/arm.c                  |  2 +-
 arch/arm64/kvm/emulate-nested.c       |  4 +-
 arch/arm64/kvm/reset.c                |  2 +-
 arch/loongarch/include/asm/kvm_host.h |  1 -
 arch/loongarch/kvm/vcpu.c             |  2 +-
 arch/mips/include/asm/kvm_host.h      |  1 -
 arch/mips/kvm/mmu.c                   |  2 +-
 arch/powerpc/include/asm/kvm_host.h   |  1 -
 arch/powerpc/kvm/powerpc.c            |  2 +-
 arch/riscv/include/asm/kvm_host.h     |  1 -
 arch/riscv/kvm/vcpu.c                 |  4 +-
 arch/s390/include/asm/kvm_host.h      |  1 -
 arch/s390/kvm/kvm-s390.c              |  2 +-
 arch/x86/include/asm/kvm-x86-ops.h    |  1 -
 arch/x86/include/asm/kvm_host.h       |  4 +-
 arch/x86/kvm/pmu.c                    |  6 +--
 arch/x86/kvm/svm/svm.c                | 13 ++---
 arch/x86/kvm/vmx/main.c               |  2 -
 arch/x86/kvm/vmx/vmx.c                | 75 +++++++++++++--------------
 arch/x86/kvm/vmx/x86_ops.h            |  3 +-
 arch/x86/kvm/x86.c                    | 26 +++++-----
 include/linux/kvm_host.h              |  4 +-
 virt/kvm/kvm_main.c                   |  5 +-
 24 files changed, 70 insertions(+), 95 deletions(-)


base-commit: a96cb3bf390eebfead5fc7a2092f8452a7997d1b
-- 
2.45.0.rc0.197.gbae5840b3b-goog


