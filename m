Return-Path: <kvm+bounces-26574-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CFFDB975BE3
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 22:42:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 953DF283D24
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 20:42:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 628781ACDF5;
	Wed, 11 Sep 2024 20:42:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="XYMuGdVT"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D84C1428E4
	for <kvm@vger.kernel.org>; Wed, 11 Sep 2024 20:42:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726087343; cv=none; b=Mh2195qMDNF2MOYePOJzikMSa8Cu0CsEsPMKGSkLG0Wn8NUpFVfYeWPZzm/QnOOcM4cWjQQ/OxDPtiXkWO9Z+8C1d+JxU+pY6rehjsg+joqfte2N+8C2a90hptb6kUnCYysIT8Q7AORK0h0H8aebv0oHxcQ1wSo7glHlxWPflZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726087343; c=relaxed/simple;
	bh=i3WL/U3Ij/2riywM9Udf//RtaBTjCk16LTXvMwDfo9g=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=RynrjraVGkUx5n6QlM4phCqZ6ZcDsQsDFh0mesG2VRalmD984EZVGwJEf4dUcWEUQF0NdZyVbmp5z07yGOlIUQaHqrXmsSsat+f/10B8/WDap4OuVC0eWIe+tfMEpokq7z91nOZU1dikSvE9NGcd+x6urgX3nfoqNOb1MuarVfw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=XYMuGdVT; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2052918b4f4so4644285ad.1
        for <kvm@vger.kernel.org>; Wed, 11 Sep 2024 13:42:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1726087340; x=1726692140; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=orNyJOAcZD+rHQnmy1du5vjxEg5EiEek+mzQd7BXIvg=;
        b=XYMuGdVTyrti6o4MMvInGZ9YCSn/v8tfKx2rRyUkugkOxGnXyJcPPRbohGKfJRXOCg
         G5mydwKxEApE4XRWkj8l8aFo1scd0rLcnNWLjrMw70Dv5y0sIW7v48URrDOIZ4xFB27W
         W0OlH+nlCGyQldSet67qIO5fgSYGGhK/sODIKTggkz5LgnoxMxiPGUGRc2zHUoLKsvTd
         nKd+wRSi+Rxgcl30aMvtyziUCFDjaqj2GOt2Acle0hN9mTBlTcpphpLNUjop6SfWLpBW
         Ey7FxhcCcmuuiGw5izHexRhj0WGmvHK+0XYE885OzwnYiUZuqHSTzyW3YNiQsgbuuwi1
         omHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726087340; x=1726692140;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=orNyJOAcZD+rHQnmy1du5vjxEg5EiEek+mzQd7BXIvg=;
        b=pi+wKN1z2W9xi0IgHtHUQ8tVvQ+9IlIIRjZK1TLZA/VqAFS5QyX3U/iuZ58Db7Sj1R
         z2quvYefJA87Pn1QFvkk+okE1UflhwmHDc7Z0HxszszgYr9yTzd0kgXfoCbD02/Uujzu
         c6yZ8/1jqiPROuw3Q26Yj4hCXA396D38bMeNzW7XbaJWnWjCmErMGFJBxLIZ8NyFhjE6
         EQWc101102mnqsQzJlc/iv74rkxKMjoTADrWu9P2whG4REcnY9yXFOjHYrNUSgguMnhR
         0p3b6SOvN5zAqibXFCxgj0LB9+oAu0CPX3HwphJXqcmVGo1x0Lq/CgMH8ABYmVC9II9y
         hScQ==
X-Forwarded-Encrypted: i=1; AJvYcCXNbnY+OdgTARdd0baY+gcKh7zq3ShzeolTTwG2/X5dYUZMT/2AnHEZL1qEueKCOag1+Fo=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyc7ZkuVou//fSLQfB4+9A9URj11flhNoWcXzTTyuLs31hMnV22
	p0zsRNTFUn4Xk7U3ruHyguh26s33xIgUBvVu3ksK1GqK/B+b7cEA/hkJ9RfjLbYGSPPbogSW0vz
	EpQ==
X-Google-Smtp-Source: AGHT+IFaujE7hEx/7weEqZv4CBEUENGoY66e8hJCtiz3GOrHctREiAah0BDLkxA9YXouCGo9V+1XVtyv7hY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:dac9:b0:1fd:60c4:6930 with SMTP id
 d9443c01a7336-2076e44762amr350555ad.10.1726087340433; Wed, 11 Sep 2024
 13:42:20 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 11 Sep 2024 13:41:45 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.46.0.598.g6f2099f65c-goog
Message-ID: <20240911204158.2034295-1-seanjc@google.com>
Subject: [PATCH v2 00/13] KVM: selftests: Morph max_guest_mem to mmu_stress
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Anup Patel <anup@brainfault.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Sean Christopherson <seanjc@google.com>, James Houghton <jthoughton@google.com>
Content-Type: text/plain; charset="UTF-8"

Marc/Oliver,

I would love a sanity check on patches 2 and 3 before I file a bug against
gcc.  The code is pretty darn simple, so I don't think I've misdiagnosed the
problem, but I've also been second guessing myself _because_ it's so simple;
it seems super unlikely that no one else would have run into this before.

On to the patches...

The main purpose of this series is to convert the max_guest_memory_test into
a more generic mmu_stress_test.  The patches were originally posted as part
a KVM x86/mmu series to test the x86/mmu changes, hence the v2.

The basic gist of the "conversion" is to have the test do mprotect() on
guest memory while vCPUs are accessing said memory, e.g. to verify KVM and
mmu_notifiers are working as intended.

Patches 1-4 are a somewhat unexpected side quest that I can (arguably should)
post separately if that would make things easier.  The original plan was that
patch 2 would be a single patch, but things snowballed.

Patch 2 reworks vcpu_get_reg() to return a value instead of using an
out-param.  This is the entire motivation for including these patches;
having to define a variable just to bump the program counter on arm64
annoyed me.

Patch 4 adds hardening to vcpu_{g,s}et_reg() to detect potential truncation,
as KVM's uAPI allows for registers greater than the 64 bits the are supported
in the "outer" selftests APIs ((vcpu_set_reg() takes a u64, vcpu_get_reg()
now returns a u64).

Patch 1 is a change to KVM's uAPI headers to move the KVM_REG_SIZE
definition to common code so that the selftests side of things doesn't
need #ifdefs to implement the hardening in patch 4.

Patch 3 is the truly unexpected part.  With the vcpu_get_reg() rework,
arm64's vpmu_counter_test fails when compiled with gcc-13, and on gcc-11
with an added "noinline".  AFAICT, the failure doesn't actually have
anything to with vcpu_get_reg(); I suspect the largely unrelated change
just happened to run afoul of a latent gcc bug.

Pending a sanity check, I will file a gcc bug.  In the meantime, I am
hoping to fudge around the issue in KVM selftests so that the vcpu_get_reg()
cleanup isn't blocked, and because the hack-a-fix is arguably a cleanup
on its own.

v2:
 - Rebase onto kvm/next.
 - Add the aforementioned vcpu_get_reg() changes/disaster.
 - Actually add arm64 support for the fancy mprotect() testcase (I did this
   before v1, but managed to forget to include the changes when posting).
 - Emit "mov %rax, (%rax)" on x86. [James]
 - Add a comment to explain the fancy mprotect() vs. vCPUs logic.
 - Drop the KVM x86 patches (applied and/or will be handled separately).

v1: https://lore.kernel.org/all/20240809194335.1726916-1-seanjc@google.com

Sean Christopherson (13):
  KVM: Move KVM_REG_SIZE() definition to common uAPI header
  KVM: selftests: Return a value from vcpu_get_reg() instead of using an
    out-param
  KVM: selftests: Fudge around an apparent gcc bug in arm64's PMU test
  KVM: selftests: Assert that vcpu_{g,s}et_reg() won't truncate
  KVM: selftests: Check for a potential unhandled exception iff KVM_RUN
    succeeded
  KVM: selftests: Rename max_guest_memory_test to mmu_stress_test
  KVM: selftests: Only muck with SREGS on x86 in mmu_stress_test
  KVM: selftests: Compute number of extra pages needed in
    mmu_stress_test
  KVM: selftests: Enable mmu_stress_test on arm64
  KVM: selftests: Use vcpu_arch_put_guest() in mmu_stress_test
  KVM: selftests: Precisely limit the number of guest loops in
    mmu_stress_test
  KVM: selftests: Add a read-only mprotect() phase to mmu_stress_test
  KVM: selftests: Verify KVM correctly handles mprotect(PROT_READ)

 arch/arm64/include/uapi/asm/kvm.h             |   3 -
 arch/riscv/include/uapi/asm/kvm.h             |   3 -
 include/uapi/linux/kvm.h                      |   4 +
 tools/testing/selftests/kvm/Makefile          |   3 +-
 .../selftests/kvm/aarch64/aarch32_id_regs.c   |  10 +-
 .../selftests/kvm/aarch64/debug-exceptions.c  |   4 +-
 .../selftests/kvm/aarch64/hypercalls.c        |   6 +-
 .../testing/selftests/kvm/aarch64/psci_test.c |   6 +-
 .../selftests/kvm/aarch64/set_id_regs.c       |  18 +-
 .../kvm/aarch64/vpmu_counter_access.c         |  27 ++-
 .../testing/selftests/kvm/include/kvm_util.h  |  10 +-
 .../selftests/kvm/lib/aarch64/processor.c     |   8 +-
 tools/testing/selftests/kvm/lib/kvm_util.c    |   3 +-
 .../selftests/kvm/lib/riscv/processor.c       |  66 +++----
 ..._guest_memory_test.c => mmu_stress_test.c} | 161 ++++++++++++++++--
 .../testing/selftests/kvm/riscv/arch_timer.c  |   2 +-
 .../testing/selftests/kvm/riscv/ebreak_test.c |   2 +-
 .../selftests/kvm/riscv/sbi_pmu_test.c        |   2 +-
 tools/testing/selftests/kvm/s390x/resets.c    |   2 +-
 tools/testing/selftests/kvm/steal_time.c      |   3 +-
 20 files changed, 236 insertions(+), 107 deletions(-)
 rename tools/testing/selftests/kvm/{max_guest_memory_test.c => mmu_stress_test.c} (60%)


base-commit: 15e1c3d65975524c5c792fcd59f7d89f00402261
-- 
2.46.0.598.g6f2099f65c-goog


