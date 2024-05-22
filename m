Return-Path: <kvm+bounces-17898-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 897838CB890
	for <lists+kvm@lfdr.de>; Wed, 22 May 2024 03:40:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0461F1F218C4
	for <lists+kvm@lfdr.de>; Wed, 22 May 2024 01:40:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 914EBF4F1;
	Wed, 22 May 2024 01:40:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="eE6mn8ev"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53E86211C
	for <kvm@vger.kernel.org>; Wed, 22 May 2024 01:40:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716342019; cv=none; b=upV5rwMq8EqsmEuPhxghoEfUlH1CICExXH6I4aso4vD1ElDPi2/5+brDvUX4lryX/wSklimqO939SCQkfOxOlo8rCGIsD9JnmBkz99Kht+CK/N5Op2sAo5D6nrVuxG2vGRvy50BDjuA1s+Zb2KX123gj7u5LsF8mjPybdpRMCp0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716342019; c=relaxed/simple;
	bh=U8u9ZX67H1rnYv/prrk0VhN0vNHEl9qh4LwcmqvwAWs=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=KQ275tkic4gWewHvL/DuF/ci5rtbyZBwo9kMASj05ObZt+JRYwOqHk8m8v9FTQDpecmmZdbitjgAL5ZVGoIw/6w10r+jR6+s+78W016pnCmr4Wew6KRp1wBHpjsZ/9MYDGIetXvqZvRkrX/vsbetz+2bBzPhiWFwBhQS5OtkJCQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=eE6mn8ev; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-df1cfa720aaso11515189276.2
        for <kvm@vger.kernel.org>; Tue, 21 May 2024 18:40:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1716342016; x=1716946816; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zcj+niLGOsOBGFG/wxz5ssr64Z9mR+IM9s4JveywwVo=;
        b=eE6mn8evLWaQxHpT4P9LcEvg64AhA+UGIXg+26lXT0wvoc1GHJJuOYlsHwlJTCmVER
         k9WmqAzTJ68N33eLNQPD1RKdrTvorl7e+ligH9YVmcXa1rjavRYw0dI8I4W7k5bg0gF+
         8tOfXXmguBm06mXQ/ubK0Da3vXVjkxfvmS+p4SMj4+gOGHI6eOPvgAtcL3wO6ux9e4He
         E0AoUjbbvpQBiRwswVIoUfDS/lj087JQ/gAWw4Xq0uElwfjFSItDosqdMJWxrlwZ77bO
         qCggnMZHTzLVh7pktPs80WFXZMSG+Q9ksq43hhjy/KK9Hc7mbfNjsvY5mcnQgP2LI+Y6
         MuJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716342016; x=1716946816;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zcj+niLGOsOBGFG/wxz5ssr64Z9mR+IM9s4JveywwVo=;
        b=NrPbK/tLNXBylpcYu6QdpkGjlVb5Fjgt5A4X+agT1g95HDpJtGnjuGR6+bDY2MPav+
         LY9Aj1iTbhFqZC3hgBar1HVc5r+0gAhTWUuk1pAjE38msi0NIimEHYsKQMQiway3g0wy
         oqtau/ECK1PBcoqb+NIzb0NhS4wqcWTwUYT1Z3bJu/y3gNrEG13lV/1ChWvHcfrNqG/z
         9ZazaFGtvCL+g+smXdI3Z1rfBEEAJcw1kHkD02B4ow6sDATvO5xbszVmQN/NPfp/MjiR
         ZtN0JO4Q73vnUhkuYPk8raO4WqTeva+RHOIaWISUj0rMYs7u/uMx8A5tMGbGUthMlsgd
         f5dA==
X-Forwarded-Encrypted: i=1; AJvYcCV+tAWNKB3qMiT0wRHwdZbry8gyIcWNoFSNi8AyKIllp/Le7+0HeSwMp0mxv/Ibkb72Zn6EzBgPMMIl2TYIr9Jx03ag
X-Gm-Message-State: AOJu0Yy06GGFRJ+scMMMVmRlGcP3xKNuPT6EzUcEGKczUb4Na5k8qanp
	Ub0LeiIgSEdTmuubI0yVHL6PHNkue4I2oX+Kd/ifd3Wv4HJmw4XmRD0JEgfk0SXIMU4AcBnzw8d
	rLw==
X-Google-Smtp-Source: AGHT+IF8tl2Sd1O1Adb/DEG65NrlAsoUAahexLMaCbbpQeSeG4ZOBg+4u/hLB5lJUUIzwhVDdo9qeU1encA=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:20c1:b0:de5:3003:4b64 with SMTP id
 3f1490d57ef6-df4e0a80c05mr82582276.1.1716342016391; Tue, 21 May 2024 18:40:16
 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 21 May 2024 18:40:07 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.45.0.215.g3402c0e53f-goog
Message-ID: <20240522014013.1672962-1-seanjc@google.com>
Subject: [PATCH v2 0/6] KVM: Fold kvm_arch_sched_in() into kvm_arch_vcpu_load()
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

Drop kvm_arch_sched_in() and instead add and use kvm_vcpu.scheduled_out
to communicate to kvm_arch_vcpu_load() that the vCPU is being scheduling
back in.

While fiddling with an idea for optimizing state management on AMD CPUs,
I wanted to skip re-saving certain host state when a vCPU is scheduled back
in, as the state (theoretically) shouldn't change for the task while it's
scheduled out.  Actually doing that was annoying and unnecessarily brittle
due to having a separate API for the kvm_sched_in() case (the state save
needed to be in kvm_arch_vcpu_load() for the common path).

The other motivation for this is to avoid yet another arch hook, and more
arbitrary ordering, if there's a future need to hook kvm_sched_out() (we've
come close on the x86 side several times).  E.g. kvm_arch_vcpu_put() can
simply check kvm_vcpu.scheduled_out if it needs to something specific for
the vCPU being scheduled out.

v2:
 - Add scheduled_out flag instead of passing a bool to kvm_arch_vcpu_load().
   [Oliver]
 - Tack on patches to clean up x86's setting of l1tf_flush_l1d in
   kvm_arch_sched_load() (the code looked slightly less weird when the flag
   was being set by kvm_arch_sched_in()).

v1: https://lore.kernel.org/all/20240430193157.419425-1-seanjc@google.com

Sean Christopherson (6):
  KVM: Add a flag to track if a loaded vCPU is scheduled out
  KVM: VMX: Move PLE grow/shrink helpers above vmx_vcpu_load()
  KVM: x86: Fold kvm_arch_sched_in() into kvm_arch_vcpu_load()
  KVM: Delete the now unused kvm_arch_sched_in()
  KVM: x86: Unconditionally set l1tf_flush_l1d during vCPU load
  KVM: x86: Drop now-superflous setting of l1tf_flush_l1d in vcpu_run()

 arch/arm64/include/asm/kvm_host.h     |  1 -
 arch/loongarch/include/asm/kvm_host.h |  1 -
 arch/mips/include/asm/kvm_host.h      |  1 -
 arch/powerpc/include/asm/kvm_host.h   |  1 -
 arch/riscv/include/asm/kvm_host.h     |  1 -
 arch/s390/include/asm/kvm_host.h      |  1 -
 arch/x86/include/asm/kvm-x86-ops.h    |  1 -
 arch/x86/include/asm/kvm_host.h       |  2 -
 arch/x86/kvm/pmu.c                    |  6 +-
 arch/x86/kvm/svm/svm.c                | 11 +---
 arch/x86/kvm/vmx/main.c               |  2 -
 arch/x86/kvm/vmx/vmx.c                | 80 +++++++++++++--------------
 arch/x86/kvm/vmx/x86_ops.h            |  1 -
 arch/x86/kvm/x86.c                    | 22 +++-----
 include/linux/kvm_host.h              |  3 +-
 virt/kvm/kvm_main.c                   |  5 +-
 16 files changed, 59 insertions(+), 80 deletions(-)


base-commit: 4aad0b1893a141f114ba40ed509066f3c9bc24b0
-- 
2.45.0.215.g3402c0e53f-goog


