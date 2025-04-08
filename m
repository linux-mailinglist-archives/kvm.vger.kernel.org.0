Return-Path: <kvm+bounces-42899-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 04D7BA7FB18
	for <lists+kvm@lfdr.de>; Tue,  8 Apr 2025 12:09:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1F18117FC1E
	for <lists+kvm@lfdr.de>; Tue,  8 Apr 2025 10:06:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3CEF526460A;
	Tue,  8 Apr 2025 10:06:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FB2q/Y+V"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF60D8488
	for <kvm@vger.kernel.org>; Tue,  8 Apr 2025 10:06:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744106805; cv=none; b=epw3z+dX+sfuxvd10a3uhTIdzfM2iTmEvO7TtB6UYYvkWVXRL7OnkJhtuD2mryJIqavV2tPS/5kwjNGnNNA50UxgkV1k2wA7idQ5lA8CijVQECCdHCT5+QuFTzu6dnZBzHjJPLI5H4/0rQXFjbN9m2xwTRrizcECCIkPRSr7uwk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744106805; c=relaxed/simple;
	bh=HIyFphJUM9jy+iUZFnRsHxLdlZSwSRVPaSAJF+efhzk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=rV4RbsZFnSqJX3ccartfswhVSpf2yT8O6SaohkM2fLLrbROHvgYAMXbNRxzWp7BQGLeP4ru/IExRiIWqaRWYIfpCWhkF+dtf0OouemH/+NcmrYhxtNzujhMelj0O+uSqmjp0Ydl8bdzduk7frVsmtUEiWhow0dhQotTwFBgrmmY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FB2q/Y+V; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1744106802;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=MW9+6v6k+evGNRMDRy26B9obQdgiWj36fdWvVuxMzGI=;
	b=FB2q/Y+VzrETZjbJ3QtJNZ10Y9Hn2N5flXY6bqL8M6ucYZEAkWx1PIp2ERHmMZNYgKAXt0
	cqtb/OOGNN4pMKtEnNJfdHyUFJS5Fa+W9ZZt2i3inlqX6O6Ngx0/WqOXgjTmqUy6s0O1q9
	gP7JbnnNrGBqElKnP3Pc50g1RaSgZ3Y=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-386-DPOX-k0rNHGDLbO_tbD06A-1; Tue,
 08 Apr 2025 06:06:41 -0400
X-MC-Unique: DPOX-k0rNHGDLbO_tbD06A-1
X-Mimecast-MFC-AGG-ID: DPOX-k0rNHGDLbO_tbD06A_1744106800
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 23CE7195608F;
	Tue,  8 Apr 2025 10:06:40 +0000 (UTC)
Received: from virtlab1023.lab.eng.rdu2.redhat.com (virtlab1023.lab.eng.rdu2.redhat.com [10.8.1.187])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 8442F1956094;
	Tue,  8 Apr 2025 10:06:39 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Subject: [GIT PULL] KVM fixes for Linux 6.15-rc2
Date: Tue,  8 Apr 2025 06:06:37 -0400
Message-ID: <20250408100638.202531-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15

Linus,

The following changes since commit 782f9feaa9517caf33186dcdd6b50a8f770ed29b:

  Merge branch 'kvm-pre-tdx' into HEAD (2025-03-20 13:13:13 -0400)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

for you to fetch changes up to c478032df0789250afe861bff5306d0dc4a8f9e5:

  Merge tag 'kvmarm-fixes-6.15-1' of https://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm into HEAD (2025-04-08 05:49:31 -0400)

The diffstat is dominated by moving around some docs that were in the wrong
section ("Documentation: kvm: organize capabilities in the right section").

----------------------------------------------------------------
ARM:

* Rework heuristics for resolving the fault IPA (HPFAR_EL2 v. re-walk
  stage-1 page tables) to align with the architecture. This avoids
  possibly taking an SEA at EL2 on the page table walk or using an
  architecturally UNKNOWN fault IPA.

* Use acquire/release semantics in the KVM FF-A proxy to avoid reading
  a stale value for the FF-A version.

* Fix KVM guest driver to match PV CPUID hypercall ABI.

* Use Inner Shareable Normal Write-Back mappings at stage-1 in KVM
  selftests, which is the only memory type for which atomic
  instructions are architecturally guaranteed to work.

s390:

* Don't use %pK for debug printing and tracepoints.

x86:

* Use a separate subclass when acquiring KVM's per-CPU posted interrupts
  wakeup lock in the scheduled out path, i.e. when adding a vCPU on
  the list of vCPUs to wake, to workaround a false positive deadlock.
  The schedule out code runs with a scheduler lock that the wakeup
  handler takes in the opposite order; but it does so with IRQs disabled
  and cannot run concurrently with a wakeup.

* Explicitly zero-initialize on-stack CPUID unions

* Allow building irqbypass.ko as as module when kvm.ko is a module

* Wrap relatively expensive sanity check with KVM_PROVE_MMU

* Acquire SRCU in KVM_GET_MP_STATE to protect guest memory accesses

selftests:

* Add more scenarios to the MONITOR/MWAIT test.

* Add option to rseq test to override /dev/cpu_dma_latency

* Bring list of exit reasons up to date

* Cleanup Makefile to list once tests that are valid on all architectures

Other:

* Documentation fixes

----------------------------------------------------------------
Chen Ni (1):
      smccc: kvm_guest: Remove unneeded semicolon

Oliver Upton (4):
      smccc: kvm_guest: Align with DISCOVER_IMPL_CPUS ABI
      KVM: arm64: Only read HPFAR_EL2 when value is architecturally valid
      arm64: Convert HPFAR_EL2 to sysreg table
      KVM: arm64: Don't translate FAR if invalid/unsafe

Paolo Bonzini (14):
      Merge tag 'kvm-s390-next-6.15-1' of https://git.kernel.org/pub/scm/linux/kernel/git/kvms390/linux into HEAD
      selftests: kvm: revamp MONITOR/MWAIT tests
      selftests: kvm: bring list of exit reasons up to date
      selftests: kvm: list once tests that are valid on all architectures
      Documentation: KVM: KVM_GET_SUPPORTED_CPUID now exposes TSC_DEADLINE
      Documentation: kvm: give correct name for KVM_CAP_SPAPR_MULTITCE
      Documentation: kvm: drop "Capability" heading from capabilities
      Documentation: kvm: fix some definition lists
      Documentation: kvm: organize capabilities in the right section
      Documentation: kvm: remove KVM_CAP_MIPS_TE
      Merge branch 'kvm-6.15-rc2-cleanups' into HEAD
      Merge branch 'kvm-6.15-rc2-fixes' into HEAD
      Merge branch 'kvm-pi-fix-lockdep' into HEAD
      Merge tag 'kvmarm-fixes-6.15-1' of https://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm into HEAD

Raghavendra Rao Ananta (2):
      KVM: arm64: selftests: Introduce and use hardware-definition macros
      KVM: arm64: selftests: Explicitly set the page attrs to Inner-Shareable

Sean Christopherson (6):
      KVM: x86: Acquire SRCU in KVM_GET_MP_STATE to protect guest memory accesses
      KVM: selftests: Add option to rseq test to override /dev/cpu_dma_latency
      KVM: x86/mmu: Wrap sanity check on number of TDP MMU pages with KVM_PROVE_MMU
      KVM: Allow building irqbypass.ko as as module when kvm.ko is a module
      KVM: x86: Explicitly zero-initialize on-stack CPUID unions
      KVM: VMX: Assert that IRQs are disabled when putting vCPU on PI wakeup list

Thomas Weißschuh (2):
      KVM: s390: Don't use %pK through tracepoints
      KVM: s390: Don't use %pK through debug printing

Will Deacon (1):
      KVM: arm64: Use acquire/release to communicate FF-A version negotiation

Yan Zhao (1):
      KVM: VMX: Use separate subclasses for PI wakeup lock to squash false positive

 Documentation/virt/kvm/api.rst                     | 1147 ++++++++++----------
 arch/arm64/include/asm/esr.h                       |   44 +-
 arch/arm64/include/asm/kvm_emulate.h               |    7 +-
 arch/arm64/include/asm/kvm_ras.h                   |    2 +-
 arch/arm64/kvm/hyp/include/hyp/fault.h             |   70 +-
 arch/arm64/kvm/hyp/nvhe/ffa.c                      |    9 +-
 arch/arm64/kvm/hyp/nvhe/mem_protect.c              |    9 +-
 arch/arm64/kvm/mmu.c                               |   31 +-
 arch/arm64/tools/sysreg                            |    7 +
 arch/s390/kvm/intercept.c                          |    2 +-
 arch/s390/kvm/interrupt.c                          |    8 +-
 arch/s390/kvm/kvm-s390.c                           |   10 +-
 arch/s390/kvm/trace-s390.h                         |    4 +-
 arch/x86/include/asm/kvm_host.h                    |    7 +-
 arch/x86/kvm/cpuid.c                               |    8 +-
 arch/x86/kvm/mmu/tdp_mmu.c                         |    8 +-
 arch/x86/kvm/vmx/posted_intr.c                     |   37 +-
 arch/x86/kvm/x86.c                                 |    4 +
 drivers/firmware/smccc/kvm_guest.c                 |    4 +-
 include/linux/kvm_host.h                           |    2 +-
 tools/testing/selftests/kvm/Makefile.kvm           |   45 +-
 .../testing/selftests/kvm/arm64/page_fault_test.c  |    2 +-
 .../selftests/kvm/include/arm64/processor.h        |   67 +-
 tools/testing/selftests/kvm/lib/arm64/processor.c  |   60 +-
 tools/testing/selftests/kvm/lib/kvm_util.c         |    5 +-
 tools/testing/selftests/kvm/rseq_test.c            |   31 +-
 .../testing/selftests/kvm/x86/monitor_mwait_test.c |  108 +-
 virt/kvm/Kconfig                                   |    2 +-
 virt/kvm/eventfd.c                                 |   10 +-
 29 files changed, 964 insertions(+), 786 deletions(-)


