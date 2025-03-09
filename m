Return-Path: <kvm+bounces-40524-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0F84DA58178
	for <lists+kvm@lfdr.de>; Sun,  9 Mar 2025 09:11:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DDC683AC66F
	for <lists+kvm@lfdr.de>; Sun,  9 Mar 2025 08:11:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C96A818C008;
	Sun,  9 Mar 2025 08:11:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="V4ifpFYy"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DC3328DD0
	for <kvm@vger.kernel.org>; Sun,  9 Mar 2025 08:11:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741507887; cv=none; b=HqqgUB4iyQvCdasX0nS7qK7P+JdWMQfiMaO2wnehuSOpJ/oTjG2X6eRoruu2GwBAJPMdGH8Hxa2pQ+LUy3zXHdNMVr6qHppeygmgdtJuyOstBh9WUzQRxDWk/T0Axwh9OCWrMEJexSvLDhDUbEBQL1YJhCBpJDNsAjIes2PW6Ho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741507887; c=relaxed/simple;
	bh=ywIIx7CiwkSiZ7dUfWCVTJcaWhwCEYd2mnYkP29YtLU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=W1mPTJ/bLVbc0l8PTq4lx/aEfuD8FEdqHAPyTIgkOV8Ign+2ixFcCJEwDz08PuwtXkZ8n2vm3TTfowTsgM0HI1dTO+oM2WIVviMpEyI9xpzb+pH+1+s5lo5ur/ilH8dtibdH26ePd5ZDqWK6PT7PRZLbasAEdVispxuly7sTS7U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=V4ifpFYy; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741507884;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=7sH7FGfqnhoLEuqI61iUbKKZNJk8uSxjiDzSzhKVUkA=;
	b=V4ifpFYyiWi26bWYaXFsAs+BS6m838goeZTIiNwB4nfW0KuPUyflMjD3X+22VYkvzwRHiC
	2TwPRU4uWmesWfSwekepWFI+pO4bdOr+obiYVO0NPvRqh9R6+S8ZnqjUT5bsvmDAUFvw9J
	1B7VSCUY9FOed+znzEde2cT3TOf6MxY=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-222-MWeIDluvMKy8ay3kww2keg-1; Sun,
 09 Mar 2025 04:11:21 -0400
X-MC-Unique: MWeIDluvMKy8ay3kww2keg-1
X-Mimecast-MFC-AGG-ID: MWeIDluvMKy8ay3kww2keg_1741507880
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0D9731956080;
	Sun,  9 Mar 2025 08:11:20 +0000 (UTC)
Received: from virtlab1023.lab.eng.rdu2.redhat.com (virtlab1023.lab.eng.rdu2.redhat.com [10.8.1.187])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 46D0E1800370;
	Sun,  9 Mar 2025 08:11:19 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Subject: [GIT PULL] KVM fixes for Linux-6.14-rc6
Date: Sun,  9 Mar 2025 04:11:18 -0400
Message-ID: <20250309081118.2953196-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

Linus,

The following changes since commit 916b7f42b3b3b539a71c204a9b49fdc4ca92cd82:

  kvm: retry nx_huge_page_recovery_thread creation (2025-03-01 02:54:18 -0500)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

for you to fetch changes up to ea9bd29a9c0d757b3384ae3e633e6bbaddf00725:

  Merge tag 'kvm-x86-fixes-6.14-rcN.2' of https://github.com/kvm-x86/linux into HEAD (2025-03-09 03:44:06 -0400)

This remains quite an active rc period, but these are "just" bugs and
issues introduced during this merge window.  So, no big deal overall.

Paolo

----------------------------------------------------------------
KVM/arm64 fixes for 6.14, take #4

* Fix a couple of bugs affecting pKVM's PSCI relay implementation
  when running in the hVHE mode, resulting in the host being entered
  with the MMU in an unknown state, and EL2 being in the wrong mode.

x86:

* Set RFLAGS.IF in C code on SVM to get VMRUN out of the STI shadow.

* Ensure DEBUGCTL is context switched on AMD to avoid running the guest with
  the host's value, which can lead to unexpected bus lock #DBs.

* Suppress DEBUGCTL.BTF on AMD (to match Intel), as KVM doesn't properly
  emulate BTF.  KVM's lack of context switching has meant BTF has always been
  broken to some extent.

* Always save DR masks for SNP vCPUs if DebugSwap is *supported*, as the guest
  can enable DebugSwap without KVM's knowledge.

* Fix a bug in mmu_stress_tests where a vCPU could finish the "writes to RO
  memory" phase without actually generating a write-protection fault.

* Fix a printf() goof in the SEV smoke test that causes build failures with
  -Werror.

* Explicitly zero EAX and EBX in CPUID.0x8000_0022 output when PERFMON_V2
  isn't supported by KVM.

----------------------------------------------------------------
Ahmed Genidi (1):
      KVM: arm64: Initialize SCTLR_EL1 in __kvm_hyp_init_cpu()

Mark Rutland (1):
      KVM: arm64: Initialize HCR_EL2.E2H early

Paolo Bonzini (2):
      Merge tag 'kvmarm-fixes-6.14-4' of git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm into HEAD
      Merge tag 'kvm-x86-fixes-6.14-rcN.2' of https://github.com/kvm-x86/linux into HEAD

Sean Christopherson (11):
      KVM: SVM: Set RFLAGS.IF=1 in C code, to get VMRUN out of the STI shadow
      KVM: selftests: Assert that STI blocking isn't set after event injection
      KVM: SVM: Drop DEBUGCTL[5:2] from guest's effective value
      KVM: SVM: Suppress DEBUGCTL.BTF on AMD
      KVM: x86: Snapshot the host's DEBUGCTL in common x86
      KVM: SVM: Manually context switch DEBUGCTL if LBR virtualization is disabled
      KVM: x86: Snapshot the host's DEBUGCTL after disabling IRQs
      KVM: SVM: Save host DR masks on CPUs with DebugSwap
      KVM: SVM: Don't rely on DebugSwap to restore host DR0..DR3
      KVM: selftests: Ensure all vCPUs hit -EFAULT during initial RO stage
      KVM: selftests: Fix printf() format goof in SEV smoke test

Xiaoyao Li (1):
      KVM: x86: Explicitly zero EAX and EBX when PERFMON_V2 isn't supported by KVM

 arch/arm64/include/asm/el2_setup.h                 | 31 +++++++++++---
 arch/arm64/kernel/head.S                           | 22 ++--------
 arch/arm64/kvm/hyp/nvhe/hyp-init.S                 | 10 +++--
 arch/arm64/kvm/hyp/nvhe/psci-relay.c               |  3 ++
 arch/x86/include/asm/kvm_host.h                    |  1 +
 arch/x86/kvm/cpuid.c                               |  2 +-
 arch/x86/kvm/svm/sev.c                             | 24 +++++++----
 arch/x86/kvm/svm/svm.c                             | 49 ++++++++++++++++++++++
 arch/x86/kvm/svm/svm.h                             |  2 +-
 arch/x86/kvm/svm/vmenter.S                         | 10 +----
 arch/x86/kvm/vmx/vmx.c                             |  8 +---
 arch/x86/kvm/vmx/vmx.h                             |  2 -
 arch/x86/kvm/x86.c                                 |  2 +
 tools/testing/selftests/kvm/mmu_stress_test.c      | 21 ++++++----
 .../selftests/kvm/x86/nested_exceptions_test.c     |  2 +
 tools/testing/selftests/kvm/x86/sev_smoke_test.c   |  3 +-
 16 files changed, 130 insertions(+), 62 deletions(-)


