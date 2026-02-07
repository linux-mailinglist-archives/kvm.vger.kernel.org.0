Return-Path: <kvm+bounces-70543-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 0JQNLo+7hmkEQgQAu9opvQ
	(envelope-from <kvm+bounces-70543-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Sat, 07 Feb 2026 05:11:59 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 32B7D104D7E
	for <lists+kvm@lfdr.de>; Sat, 07 Feb 2026 05:11:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 7B409306A1A5
	for <lists+kvm@lfdr.de>; Sat,  7 Feb 2026 04:10:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 59D0133FE1A;
	Sat,  7 Feb 2026 04:10:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="x0U9vHuq"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77C6733F8B1
	for <kvm@vger.kernel.org>; Sat,  7 Feb 2026 04:10:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770437429; cv=none; b=bWKRX01qzmLH0QRR3rlh1Xv3YCyGm2YpwDQn7T8g6nALUNL3SalZK7rOLF0I+fq6IwwCq/LJL6gOzIKGBa3zkXNzsotIzqRZOQ0rMqkD20B1K8EULnOy9O0yiPi/ugb/yBGTpC0NrvcBSytHhCDboOoHi4nb428rU6DkilMSHvk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770437429; c=relaxed/simple;
	bh=BTGQvs4H1Ngyfpfd4mjTDMOwEHd20pq0CRO2DNrKsqA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=YYyFDjkFbERrVBtJdLGpFsWV1CoQmLv9Lfnw70LEAcwSEpVG5vbWEV7C/O6ttX41vUYoSp51UYV09Bp8LtHIrIF0I7Zp/j4tWAM6ZXo8r/HjcHdk6f6DhWn7xSZftsrt/spQHMhSac5+uW6qXZdEj4GIY9WEqLUsoWoAY0U0S8s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=x0U9vHuq; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-34cc88eca7eso2710791a91.2
        for <kvm@vger.kernel.org>; Fri, 06 Feb 2026 20:10:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770437423; x=1771042223; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=H1uj9+WsCNCOqupGVMjBYAPK/R2I8MXRE7T7KcZiv/A=;
        b=x0U9vHuqkOdhTQMPeyrkQlhmvkYKLDZhnbisJyuEf9aBNnHP7KGG5NKu6rUg4V9+/o
         HxA2SsaHXGFSBtBxLK0PDtPhEBkktH9kSJ3T30TT1mi1JvkD90bzo+vkkh4PEhbYdGna
         5oQi9tD3djR75Tkgq8C5JEQLxqjk+PkgGforpTCW7gtwzPK894+5DRN6SiphZxPQcLzD
         qvfyq31Jh1bmJ59tYJ54zlx3jThNCmTeH+pBHt/GmW4CZTlYDwmvGu1m6BdJOQNm1JIi
         T2pqojiYcWeJlC9JYsPAzkfTglRCpAuW7+mb0DhN4g/GpfL+mAk0r5u+L+wS72sCFWo2
         RxPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770437423; x=1771042223;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=H1uj9+WsCNCOqupGVMjBYAPK/R2I8MXRE7T7KcZiv/A=;
        b=RkwF3TEmtY2i9qDj+TBLtf/f7xVXqJWyFyXCJFC48J0oSbRYtIsn8i2FL8mb0+Qezs
         I5QZjb23qu3Ds5fnrn8vQPgNfuPPJ0ngsMagPpatfxE2zFQHjcFv+SmwhBRg7bNTgDZU
         59Aa5jqfa/CP2smJtiUhcanGzx4PqHfTsYWppAxJ1zy2pEXX/q/p7qBPMh/4f6SQQ6pc
         6/KnmPaWsXSs2NpLMvCHGXteFtzpXAkAZ/hjG3Ksqzk4NLa0ZXpD/hbRV5qA6NX6fk5G
         0Db4aToHetqc1NBJnRGcX+iOwMqwT0vJGvCgAcMXuZ96oZDc8ocU079YeipKb2OKPVgB
         pnLw==
X-Gm-Message-State: AOJu0Yw8K6z7bVRgQEUpB8Jn2A2V7tkZiPCmIxiMcexDO6LTy8/saBhi
	fwzKH/8B0cl2X7RYhUWHnJueWQKdeoW4V9ZQPJyPykGM65XhsJO3+6J2XTB4z1f9PDc8dq/BWbn
	9eY25PQ==
X-Received: from pjbgo22.prod.google.com ([2002:a17:90b:3d6:b0:354:bd11:74ae])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1650:b0:353:6373:590b
 with SMTP id 98e67ed59e1d1-354b3c40705mr4400845a91.7.1770437422865; Fri, 06
 Feb 2026 20:10:22 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  6 Feb 2026 20:10:07 -0800
In-Reply-To: <20260207041011.913471-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260207041011.913471-1-seanjc@google.com>
X-Mailer: git-send-email 2.53.0.rc2.204.g2597b5adb4-goog
Message-ID: <20260207041011.913471-6-seanjc@google.com>
Subject: [GIT PULL] KVM: x86: Mediated PMU for 6.20
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70543-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	HAS_REPLYTO(0.00)[seanjc@google.com];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	REPLYTO_EQ_FROM(0.00)[]
X-Rspamd-Queue-Id: 32B7D104D7E
X-Rspamd-Action: no action

Mediated PMU support.  Note, this is based on perf-core-kvm-mediated-pmu from
the tip tree.  If the KVM pull request is merged before the perf request, this
will pull in another ~25 commits.

The following changes since commit 01122b89361e565b3c88b9fbebe92dc5c7420cb7:

  perf: Use EXPORT_SYMBOL_FOR_KVM() for the mediated APIs (2025-12-19 08:54:59 +0100)

are available in the Git repository at:

  https://github.com/kvm-x86/linux.git tags/kvm-x86-pmu-6.20

for you to fetch changes up to d374b89edbb9a8d552e03348f59287ff779b4c9d:

  KVM: VMX: Add mediated PMU support for CPUs without "save perf global ctrl" (2026-01-08 11:52:23 -0800)

----------------------------------------------------------------
KVM mediated PMU support for 6.20

Add support for mediated PMUs, where KVM gives the guest full ownership of PMU
hardware (contexted switched around the fastpath run loop) and allows direct
access to data MSRs and PMCs (restricted by the vPMU model), but intercepts
access to control registers, e.g. to enforce event filtering and to prevent the
guest from profiling sensitive host state.

To keep overall complexity reasonable, mediated PMU usage is all or nothing
for a given instance of KVM (controlled via module param).  The Mediated PMU
is disabled default, partly to maintain backwards compatilibity for existing
setup, partly because there are tradeoffs when running with a mediated PMU that
may be non-starters for some use cases, e.g. the host loses the ability to
profile guests with mediated PMUs, the fastpath run loop is also a blind spot,
entry/exit transitions are more expensive, etc.

Versus the emulated PMU, where KVM is "just another perf user", the mediated
PMU delivers more accurate profiling and monitoring (no risk of contention and
thus dropped events), with significantly less overhead (fewer exits and faster
emulation/programming of event selectors) E.g. when running Specint-2017 on
a single-socket Sapphire Rapids with 56 cores and no-SMT, and using perf from
within the guest:

  Perf command:
  a. basic-sampling: perf record -F 1000 -e 6-instructions  -a --overwrite
  b. multiplex-sampling: perf record -F 1000 -e 10-instructions -a --overwrite

  Guest performance overhead:
  ---------------------------------------------------------------------------
  | Test case          | emulated vPMU | all passthrough | passthrough with |
  |                    |               |                 | event filters    |
  ---------------------------------------------------------------------------
  | basic-sampling     |   33.62%      |    4.24%        |   6.21%          |
  ---------------------------------------------------------------------------
  | multiplex-sampling |   79.32%      |    7.34%        |   10.45%         |
  ---------------------------------------------------------------------------

----------------------------------------------------------------
Dapeng Mi (11):
      KVM: x86/pmu: Start stubbing in mediated PMU support
      KVM: x86/pmu: Implement Intel mediated PMU requirements and constraints
      KVM: x86/pmu: Disable RDPMC interception for compatible mediated vPMU
      KVM: x86/pmu: Load/save GLOBAL_CTRL via entry/exit fields for mediated PMU
      KVM: x86/pmu: Disable interception of select PMU MSRs for mediated vPMUs
      KVM: x86/pmu: Bypass perf checks when emulating mediated PMU counter accesses
      KVM: x86/pmu: Reprogram mediated PMU event selectors on event filter updates
      KVM: x86/pmu: Load/put mediated PMU context when entering/exiting guest
      KVM: x86/pmu: Handle emulated instruction for mediated vPMU
      KVM: nVMX: Add macros to simplify nested MSR interception setting
      KVM: x86/pmu: Expose enable_mediated_pmu parameter to user space

Mingwei Zhang (2):
      KVM: x86/pmu: Introduce eventsel_hw to prepare for pmu event filtering
      KVM: nVMX: Disable PMU MSR interception as appropriate while running L2

Sandipan Das (1):
      KVM: x86/pmu: Always stuff GuestOnly=1,HostOnly=0 for mediated PMCs on AMD

Sean Christopherson (15):
      KVM: Add a simplified wrapper for registering perf callbacks
      KVM: x86/pmu: Implement AMD mediated PMU requirements
      KVM: x86/pmu: Disallow emulation in the fastpath if mediated PMCs are active
      KVM: nSVM: Disable PMU MSR interception as appropriate while running L2
      KVM: x86/pmu: Elide WRMSRs when loading guest PMCs if values already match
      KVM: VMX: Drop intermediate "guest" field from msr_autostore
      KVM: nVMX: Don't update msr_autostore count when saving TSC for vmcs12
      KVM: VMX: Dedup code for removing MSR from VMCS's auto-load list
      KVM: VMX: Drop unused @entry_only param from add_atomic_switch_msr()
      KVM: VMX: Bug the VM if either MSR auto-load list is full
      KVM: VMX: Set MSR index auto-load entry if and only if entry is "new"
      KVM: VMX: Compartmentalize adding MSRs to host vs. guest auto-load list
      KVM: VMX: Dedup code for adding MSR to VMCS's auto list
      KVM: VMX: Initialize vmcs01.VM_EXIT_MSR_STORE_ADDR with list address
      KVM: VMX: Add mediated PMU support for CPUs without "save perf global ctrl"

Xiong Zhang (1):
      KVM: x86/pmu: Register PMI handler for mediated vPMU

 Documentation/admin-guide/kernel-parameters.txt |  49 ++++++++++++++++++++++
 arch/arm64/kvm/arm.c                            |   2 +-
 arch/loongarch/kvm/main.c                       |   2 +-
 arch/riscv/kvm/main.c                           |   2 +-
 arch/x86/include/asm/kvm-x86-pmu-ops.h          |   4 ++
 arch/x86/include/asm/kvm_host.h                 |   3 ++
 arch/x86/include/asm/msr-index.h                |   1 +
 arch/x86/include/asm/vmx.h                      |   1 +
 arch/x86/kvm/pmu.c                              | 269 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++---
 arch/x86/kvm/pmu.h                              |  37 +++++++++++++++-
 arch/x86/kvm/svm/nested.c                       |  18 +++++++-
 arch/x86/kvm/svm/pmu.c                          |  44 +++++++++++++++++++
 arch/x86/kvm/svm/svm.c                          |  46 ++++++++++++++++++++
 arch/x86/kvm/vmx/capabilities.h                 |   9 +++-
 arch/x86/kvm/vmx/nested.c                       | 144 ++++++++++++++++++++++++++++++++++-----------------------------
 arch/x86/kvm/vmx/pmu_intel.c                    |  92 ++++++++++++++++++++++++++++++++++------
 arch/x86/kvm/vmx/pmu_intel.h                    |  15 +++++++
 arch/x86/kvm/vmx/vmx.c                          | 212 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++----------------------
 arch/x86/kvm/vmx/vmx.h                          |   9 ++--
 arch/x86/kvm/x86.c                              |  54 ++++++++++++++++++++++--
 arch/x86/kvm/x86.h                              |   1 +
 include/linux/kvm_host.h                        |  11 ++++-
 virt/kvm/kvm_main.c                             |   5 ++-
 23 files changed, 876 insertions(+), 154 deletions(-)

