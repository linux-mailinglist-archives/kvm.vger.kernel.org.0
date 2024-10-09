Return-Path: <kvm+bounces-28259-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 64F9D9970B2
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 18:10:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0EA621F22D41
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 16:10:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B8A8E1FF7D8;
	Wed,  9 Oct 2024 15:49:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="PVcHGzag"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D99F1E32D1
	for <kvm@vger.kernel.org>; Wed,  9 Oct 2024 15:49:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728488998; cv=none; b=iC8az5QdtVRoJ8ZJfTR3UcEiw/PBl95rNsK+5QeTQJJPAhhBToOAk79mUSAi2TxdlDjskGfMYwFKrZrM2OsY6owJKB+Hf1U2OqzmyzGTNTcH4XJfMEn8gwjrcuc7cmb80vJh7wNSaz6yNPdHDwBOpjv/bvsHyEmA07vHWiXFqLM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728488998; c=relaxed/simple;
	bh=lSrxQ0o4lzW28SX3OpFxYNNm5zyTaJtY872EDLEASgA=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=Yz+sMQ144baK0J2QWzl0sx5CAaZgsDGfZ4HHMHjwsYKKqCfdM+CfkddCb5917rprIL62U7lM2zzXeZ1zE7PJmS791etDygYvdtTnpeupuJVstTGi2Zg0FDju0sHwwMDyDp9VUnrJS2mDU46sax1FigSw4nCSmeo0Qa0Ua7kCtyw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=PVcHGzag; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2e292f3e85fso304a91.2
        for <kvm@vger.kernel.org>; Wed, 09 Oct 2024 08:49:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1728488996; x=1729093796; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mp1GmMvEsdG1xOqt7J6qefXNw1tx4nozkIWjiF4j3SI=;
        b=PVcHGzag1ufwUKkgc0jFS5LtMuZyZQaR0RVDBF0NgNbA6XHuUWSfHCWMQHewhayKVi
         fTDxjQ3/9CrutAbmcPlMPJiSdNJ3dVXfqOtZ92vQfT5TUu5pOOpekt13Ilj7kXTR9H0b
         7D+aXFTKxU6D4HCAUz3J2nKUU3qWeSIY1Iw5hT4WEOTVhZTvga0Yi2FAHfWF3M6mF5Ll
         nQRQ1qrgMkoeXrlosMeHiokof/xr1J8em69OCh/bd3VYDhQFizw3CdhvSiafxk51jUes
         +BEnSBbiBS4j8HLxoRpCwjVWu2gz8BeZjlNn4nmFL0u5t8hFKavVQTul0FB28PUBQVZ9
         IilQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728488996; x=1729093796;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mp1GmMvEsdG1xOqt7J6qefXNw1tx4nozkIWjiF4j3SI=;
        b=RjzFXuY3VLxauiw7pYG4ur2svhqAEGguvCz5EAEfr7R23kAYIA/VZIDGN8LtWRohlI
         1AgTnMBFZoGgLZcwp244z0ymwVOgQFOhrAjt4lRblOM08YJCnVco+U/rLQr+C582Hsef
         /ccSUuwE1D+aIZ5Hw+9km1gf0+FddJZiOaDS4aQE8EIcueFq141QayBN6eh3ED017ms3
         Z+OQ4cEZyDqxFyAwImaE/coqLALACVD49xPb4kCQ39ikFG/y3yoqEV0WZ26kqkkDQISd
         uaQEk5HSlG0J4SzTAqiZl+da6/WWNLKFBxv/xTRGsxuhZfJp39uMyLMYpiktf5JNk0GZ
         LJsQ==
X-Forwarded-Encrypted: i=1; AJvYcCWfWAmX0d3bd8sp/P034sXV/41VVyMDlH7YYuIKhIeKUAn9IOUGscpVQIkENLF21U8CiA0=@vger.kernel.org
X-Gm-Message-State: AOJu0YzrQAueG+FatbI7jTEzlvqS37pxJQEyaVczb6b1lRhhJe0OklIM
	cvZz5IysLpplOWojI6nU6RnidLlyFd/3mhaNjpepJyEjaz2XtqdzY5EyW7OE+ojizIL0BGZ4u/1
	3yg==
X-Google-Smtp-Source: AGHT+IEKF1Ho4VsrxKapa7g6WWX3VRxIkgUDz21gNBA5z4SeEUBMmHmDj2XN+crbLzcKc/g4iyRtc0M+qRE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a17:90a:468a:b0:2e0:6c40:e384 with SMTP id
 98e67ed59e1d1-2e2a251444emr3074a91.4.1728488995562; Wed, 09 Oct 2024 08:49:55
 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed,  9 Oct 2024 08:49:39 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.47.0.rc0.187.ge670bccf7e-goog
Message-ID: <20241009154953.1073471-1-seanjc@google.com>
Subject: [PATCH v3 00/14] KVM: selftests: Morph max_guest_mem to mmu_stress
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Anup Patel <anup@brainfault.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Paolo Bonzini <pbonzini@redhat.com>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Sean Christopherson <seanjc@google.com>, Andrew Jones <ajones@ventanamicro.com>, 
	James Houghton <jthoughton@google.com>
Content-Type: text/plain; charset="UTF-8"

The main purpose of this series is to convert the max_guest_memory_test
into a more generic mmu_stress_test.  The basic gist of the "conversion"
is to have the test do mprotect() on guest memory while vCPUs are
accessing said memory, e.g. to verify KVM and mmu_notifiers are working
as intended.

Patches 1-4 are a somewhat unexpected side quest.  The original plan was
that patch 3 would be a single patch, but things snowballed.

Patch 3 reworks vcpu_get_reg() to return a value instead of using an
out-param.  This is the entire motivation for including these patches;
having to define a variable just to bump the program counter on arm64
annoyed me.

Patch 4 adds hardening to vcpu_{g,s}et_reg() to detect potential
truncation, as KVM's uAPI allows for registers greater than the 64 bits
that are supported in the "outer" selftests APIs ((vcpu_set_reg() takes a
u64, vcpu_get_reg() now returns a u64).

Patch 1 is a change to KVM's uAPI headers to move the KVM_REG_SIZE
definition to common code so that the selftests side of things doesn't
need #ifdefs to implement the hardening in patch 4.

Patch 2 is the truly unexpected part.  With the vcpu_get_reg() rework,
arm64's vpmu_counter_test fails when compiled with gcc-13, and on gcc-11
with an added "noinline".  Long story short, selftests are being compiled
with strict aliasing enabled, which allows the compiler to optimize away
"u64 *" => "uint64_t *" casts as u64 (unsigned long long) and uint64_t
(unsigned long) are technically not aliases of each other.  *sigh*

v3:
 - Rebased onto v6.12-rc2.
 - Disable strict aliasing to fix the PMCR snafu.
 - Collect reviews. [Drew]
 - Minor changelog fixes. [Drew]
 - Include ucall_common.h to prep for RISC-V. [Drew]

v2:
 - Rebase onto kvm/next.
 - Add the aforementioned vcpu_get_reg() changes/disaster.
 - Actually add arm64 support for the fancy mprotect() testcase (I did this
   before v1, but managed to forget to include the changes when posting).
 - Emit "mov %rax, (%rax)" on x86. [James]
 - Add a comment to explain the fancy mprotect() vs. vCPUs logic.
 - Drop the KVM x86 patches (applied and/or will be handled separately).

v1: https://lore.kernel.org/all/20240809194335.1726916-1-seanjc@google.com

Sean Christopherson (14):
  KVM: Move KVM_REG_SIZE() definition to common uAPI header
  KVM: selftests: Disable strict aliasing
  KVM: selftests: Return a value from vcpu_get_reg() instead of using an
    out-param
  KVM: selftests: Assert that vcpu_{g,s}et_reg() won't truncate
  KVM: selftests: Check for a potential unhandled exception iff KVM_RUN
    succeeded
  KVM: selftests: Rename max_guest_memory_test to mmu_stress_test
  KVM: selftests: Only muck with SREGS on x86 in mmu_stress_test
  KVM: selftests: Compute number of extra pages needed in
    mmu_stress_test
  KVM: sefltests: Explicitly include ucall_common.h in mmu_stress_test.c
  KVM: selftests: Enable mmu_stress_test on arm64
  KVM: selftests: Use vcpu_arch_put_guest() in mmu_stress_test
  KVM: selftests: Precisely limit the number of guest loops in
    mmu_stress_test
  KVM: selftests: Add a read-only mprotect() phase to mmu_stress_test
  KVM: selftests: Verify KVM correctly handles mprotect(PROT_READ)

 arch/arm64/include/uapi/asm/kvm.h             |   3 -
 arch/riscv/include/uapi/asm/kvm.h             |   3 -
 include/uapi/linux/kvm.h                      |   4 +
 tools/testing/selftests/kvm/Makefile          |  11 +-
 .../selftests/kvm/aarch64/aarch32_id_regs.c   |  10 +-
 .../selftests/kvm/aarch64/debug-exceptions.c  |   4 +-
 .../selftests/kvm/aarch64/hypercalls.c        |   6 +-
 .../selftests/kvm/aarch64/no-vgic-v3.c        |   2 +-
 .../testing/selftests/kvm/aarch64/psci_test.c |   6 +-
 .../selftests/kvm/aarch64/set_id_regs.c       |  18 +-
 .../kvm/aarch64/vpmu_counter_access.c         |  19 +-
 .../testing/selftests/kvm/include/kvm_util.h  |  10 +-
 .../selftests/kvm/lib/aarch64/processor.c     |   8 +-
 tools/testing/selftests/kvm/lib/kvm_util.c    |   3 +-
 .../selftests/kvm/lib/riscv/processor.c       |  66 +++----
 ..._guest_memory_test.c => mmu_stress_test.c} | 162 ++++++++++++++++--
 .../testing/selftests/kvm/riscv/arch_timer.c  |   2 +-
 .../testing/selftests/kvm/riscv/ebreak_test.c |   2 +-
 .../selftests/kvm/riscv/sbi_pmu_test.c        |   2 +-
 tools/testing/selftests/kvm/s390x/resets.c    |   2 +-
 tools/testing/selftests/kvm/steal_time.c      |   3 +-
 21 files changed, 241 insertions(+), 105 deletions(-)
 rename tools/testing/selftests/kvm/{max_guest_memory_test.c => mmu_stress_test.c} (60%)


base-commit: 8cf0b93919e13d1e8d4466eb4080a4c4d9d66d7b
-- 
2.47.0.rc0.187.ge670bccf7e-goog


