Return-Path: <kvm+bounces-41006-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 93AB4A603B8
	for <lists+kvm@lfdr.de>; Thu, 13 Mar 2025 22:56:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C8C914202A7
	for <lists+kvm@lfdr.de>; Thu, 13 Mar 2025 21:56:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 33BC71F584F;
	Thu, 13 Mar 2025 21:55:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="pUZIAnWA"
X-Original-To: kvm@vger.kernel.org
Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4CA01F30C3;
	Thu, 13 Mar 2025 21:55:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741902958; cv=none; b=ALknYYi7R6sywZJdc0dAjJlSDhG78pGqdLAB8tmTmJR04409ZcoKt6bcU64Hg1HlGnuckUAd+ulvLXz8eoYke/KmZfU9EPOjdIq8WbEpW6TW9wTSo+ho+iDkCkHe98h8NpIpCc5G9mCA+sBGZ9KF/W7b/BKB+u6X82E6XFgGMQI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741902958; c=relaxed/simple;
	bh=zIaNHML6g2op5mpDz8zA9RY//9td6nkI7FNoE0y3Ork=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=D8bo1ZW2dzwyOR4lxXBPzt4G6o7srzXMrlDtwDUcXehOVMtQzaVQIXnvLGJUEvSqZRBBELoQIS4iuUKuIyqoh0HOuiHitgebvR7UbF/uXYZyH7ZVzvXhaQLi53cU824/iOI+SUL4JW5Rc9Gb7+FRxSSb8SjMmvr9M4CoDMp1meQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=pUZIAnWA; arc=none smtp.client-ip=91.218.175.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1741902953;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=u2xLp3eRJb0919MLUyrsOpbRZIrkocs/txSYBBG9QbI=;
	b=pUZIAnWAnkIufgRZFglCgYwDTmK/+jLWPJAY3UK2judpVLy/fhoMDqnAHRGd4UrVj+B3jd
	BqLmTrzDiqEltlkA820vgrCHEfVNf35cFaFYgXaLq9PJGLy0bgBHOLv1bAwXaHz8vsb505
	iCqTqe3W2eFKBFrDnaJdb6jKlTH+h1Y=
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Maxim Levitsky <mlevitsk@redhat.com>,
	x86@kernel.org,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosry.ahmed@linux.dev>
Subject: [PATCH 0/7] Make ASIDs static for SVM
Date: Thu, 13 Mar 2025 21:55:33 +0000
Message-ID: <20250313215540.4171762-1-yosry.ahmed@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

This series changes SVM to use a single ASID per-VM, instead of using
dynamic generation-based ASIDs per-vCPU. Dynamic ASIDs were added for
CPUs without FLUSHBYASID to avoid full TLB flushes, but as Sean said,
FLUSHBYASID was added in 2010, and the case for this is no longer as
strong [1].

Furthermore, having different ASIDs for different vCPUs is not required.
ASIDs are local to physical CPUs. The only requirement is to make sure
the ASID is flushed before a differnet vCPU runs on the same physical
CPU (see below). Furthermore, SEV VMs have been using with a single ASID
per-VM anyway (required for different reasons).

A new ASID is currently allocated in 3 cases:
(a) Once when the vCPU is initialized.
(b) When the vCPU moves to a new physical CPU.
(c) On TLB flushes when FLUSHBYASID is not available.

Case (a) is trivial, instead the ASID is allocated for VM creation.
Case (b) is handled by flushing the ASID instead of assigning a new one.
Case (c) is handled by doing a full TLB flush (i.e.
TLB_CONTROL_FLUSH_ALL_ASID) instead of assinging a new ASID. This is
a bit aggressive, but FLUSHBYASID is available in all modern CPUs.

The series is organized as follows:
- Patch 1 generalizes the VPID allocation code in VMX to be
  vendor-neutral, to reuse for SVM.
- Patches 2-3 do some refactoring and cleanups.
- Patches 4-5 address cases (b) and (c) above.
- Patch 6 moves to single ASID per-VM.
- Patch 7 performs some minimal unification between SVM and SEV code.
  More unification can be done. In particular, SEV can use the
  generalized kvm_tlb_tags to allocate ASIDs, and can stop tracking the
  ASID separately in struct kvm_sev_info. However, I didn't have enough
  SEV knowledge (or testability) to do this.

The performance impact does not seem to be that bad. To test this
series, I ran 3 benchmarks in an SVM guest on a Milan machine:
- netperf
- cpuid_rate [2]
- A simple program doing mmap() and munmap() of 100M for 100 iterations,
  to trigger MMU syncs and TLB flushes when using the shadow MMU.

The benchmarks were ran with and without the patches for 5 iterations
each, and also with and without NPT and FLUSBYASID to emulate old
hardware. In all cases, there was either no difference or a 1-2%
performance hit for the old hardware case. The performance hit could be
larger for specific workloads, but niche performance-sensitive workloads
should not be running on very old hardware.

[1] https://lore.kernel.org/lkml/Z8JOvMx6iLexT3pK@google.com/
[2] https://lore.kernel.org/kvm/20231109180646.2963718-1-khorenko@virtuozzo.com/

Yosry Ahmed (7):
  KVM: VMX: Generalize VPID allocation to be vendor-neutral
  KVM: SVM: Use cached local variable in init_vmcb()
  KVM: SVM: Add helpers to set/clear ASID flush
  KVM: SVM: Flush everything if FLUSHBYASID is not available
  KVM: SVM: Flush the ASID when running on a new CPU
  KVM: SVM: Use a single ASID per VM
  KVM: SVM: Share more code between pre_sev_run() and pre_svm_run()

 arch/x86/include/asm/svm.h |  5 ---
 arch/x86/kvm/svm/nested.c  |  4 +-
 arch/x86/kvm/svm/sev.c     | 26 +++++-------
 arch/x86/kvm/svm/svm.c     | 87 ++++++++++++++++++++------------------
 arch/x86/kvm/svm/svm.h     | 28 ++++++++----
 arch/x86/kvm/vmx/nested.c  |  4 +-
 arch/x86/kvm/vmx/vmx.c     | 38 +++--------------
 arch/x86/kvm/vmx/vmx.h     |  4 +-
 arch/x86/kvm/x86.c         | 58 +++++++++++++++++++++++++
 arch/x86/kvm/x86.h         | 13 ++++++
 10 files changed, 161 insertions(+), 106 deletions(-)

-- 
2.49.0.rc1.451.g8f38331e32-goog


