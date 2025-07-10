Return-Path: <kvm+bounces-52030-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7A65BAFFFA5
	for <lists+kvm@lfdr.de>; Thu, 10 Jul 2025 12:49:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C342E166D65
	for <lists+kvm@lfdr.de>; Thu, 10 Jul 2025 10:49:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F3DD62E0411;
	Thu, 10 Jul 2025 10:49:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hOIR+vgB"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73BD82D8385
	for <kvm@vger.kernel.org>; Thu, 10 Jul 2025 10:49:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752144585; cv=none; b=IpDmP0mu7PGZvdizu9xoe2bE6JYKBfLQHe2XkH+38IlTiexw7qYa+FQvLxAz/QVFEnh/Zh6vepKylCad6sXEnJTu2j9umlWZtvTFQC1tKmuumq45Lq7WNAOQpsQUoE2O7zF9sAn69agUs5uGO02DNIg8RFMVTgnIpE/PRsmLSFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752144585; c=relaxed/simple;
	bh=02B1fOvSgKAwYr1FB0P5c5GiwUBxLJNroyx1y2bNGrQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=mjKzoMJqm1NhHv9p/jtLeg7lfM0RynGq9KA6PxijB2paw5MOCgyGMXjyiSIFSRyWysGCuI7zCkf/CLoh3WtKk2MPGcn3MU4RdRfI5r6213DkaLO5r5fkNZPAGw5l2TGXUI0P055Ha+IJpFc0PGyIpzrrFxg1KBbzD3av0XCLhnQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hOIR+vgB; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1752144582;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=dHO9fvBQyVcIBTj3Z5s6OwRFbx2Ab076P87xkg3RmYc=;
	b=hOIR+vgB4YMNKtxejp3TL/0knK4IUiPb1LbG2Xjw0lFIpvEY4Eqfgxt7ub5d53VhdtdW8N
	vN0JZVkLsA/DkAHmvvGIwK2XbjPUhFS08vyIO709M13/+pMOhzB9mtbcqcZPZAS1eqQPqj
	WKyj87oIfoxcGr2m2xQmEY6NgCVlr3c=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-695-2QdOf4IePuepXsSnFEfonQ-1; Thu,
 10 Jul 2025 06:49:39 -0400
X-MC-Unique: 2QdOf4IePuepXsSnFEfonQ-1
X-Mimecast-MFC-AGG-ID: 2QdOf4IePuepXsSnFEfonQ_1752144578
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3C6851956087;
	Thu, 10 Jul 2025 10:49:38 +0000 (UTC)
Received: from virtlab1023.lab.eng.rdu2.redhat.com (virtlab1023.lab.eng.rdu2.redhat.com [10.8.1.187])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 9998218002B6;
	Thu, 10 Jul 2025 10:49:37 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Subject: [GIT PULL] KVM fixes for Linux 6.16-rc6
Date: Thu, 10 Jul 2025 06:49:36 -0400
Message-ID: <20250710104936.232026-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

Linus,

The following changes since commit 25e8b1dd4883e6c251c3db5b347f3c8ae4ade921:

  KVM: TDX: Exit to userspace for GetTdVmCallInfo (2025-06-20 13:55:47 -0400)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

for you to fetch changes up to 4578a747f3c7950be3feb93c2db32eb597a3e55b:

  KVM: x86: avoid underflow when scaling TSC frequency (2025-07-09 13:52:50 -0400)

Many patches, pretty much all of them small, that accumulated while I
was on vacation.
----------------------------------------------------------------
ARM:

- Remove the last leftovers of the ill-fated FPSIMD host state
  mapping at EL2 stage-1

- Fix unexpected advertisement to the guest of unimplemented S2 base
  granule sizes

- Gracefully fail initialising pKVM if the interrupt controller isn't
  GICv3

- Also gracefully fail initialising pKVM if the carveout allocation
  fails

- Fix the computing of the minimum MMIO range required for the host on
  stage-2 fault

- Fix the generation of the GICv3 Maintenance Interrupt in nested mode

x86:

- Reject SEV{-ES} intra-host migration if one or more vCPUs are actively
  being created, so as not to create a non-SEV{-ES} vCPU in an SEV{-ES} VM.

- Use a pre-allocated, per-vCPU buffer for handling de-sparsification of
  vCPU masks in Hyper-V hypercalls; fixes a "stack frame too large" issue.

- Allow out-of-range/invalid Xen event channel ports when configuring IRQ
  routing, to avoid dictating a specific ioctl() ordering to userspace.

- Conditionally reschedule when setting memory attributes to avoid soft
  lockups when userspace converts huge swaths of memory to/from private.

- Add back MWAIT as a required feature for the MONITOR/MWAIT selftest.

- Add a missing field in struct sev_data_snp_launch_start that resulted in
  the guest-visible workarounds field being filled at the wrong offset.

- Skip non-canonical address when processing Hyper-V PV TLB flushes to avoid
  VM-Fail on INVVPID.

- Advertise supported TDX TDVMCALLs to userspace.

- Pass SetupEventNotifyInterrupt arguments to userspace.

- Fix TSC frequency underflow.

----------------------------------------------------------------
Binbin Wu (1):
      Documentation: KVM: Fix unexpected unindent warnings

Chenyi Qiang (1):
      KVM: selftests: Add back the missing check of MONITOR/MWAIT availability

David Woodhouse (1):
      KVM: x86/xen: Allow 'out of range' event channel ports in IRQ routing table.

Liam Merwick (1):
      KVM: Allow CPU to reschedule while setting per-page memory attributes

Manuel Andreas (1):
      KVM: x86/hyper-v: Skip non-canonical addresses during PV TLB flush

Marc Zyngier (1):
      KVM: arm64: Fix handling of FEAT_GTG for unimplemented granule sizes

Mark Rutland (1):
      KVM: arm64: Remove kvm_arch_vcpu_run_map_fp()

Mostafa Saleh (1):
      KVM: arm64: Fix error path in init_hyp_mode()

Nikunj A Dadhania (1):
      KVM: SVM: Add missing member in SNP_LAUNCH_START command structure

Paolo Bonzini (6):
      KVM: TDX: Exit to userspace for SetupEventNotifyInterrupt
      KVM: TDX: Report supported optional TDVMCALLs in TDX capabilities
      Merge tag 'kvmarm-fixes-6.16-4' of https://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm into HEAD
      Merge tag 'kvmarm-fixes-6.16-5' of https://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm into HEAD
      Merge tag 'kvm-x86-fixes-6.16-rcN' of https://github.com/kvm-x86/linux into HEAD
      KVM: x86: avoid underflow when scaling TSC frequency

Quentin Perret (2):
      KVM: arm64: Adjust range correctly during host stage-2 faults
      KVM: arm64: Don't free hyp pages with pKVM on GICv2

Sean Christopherson (3):
      KVM: SVM: Reject SEV{-ES} intra host migration if vCPU creation is in-flight
      KVM: SVM: Initialize vmsa_pa in VMCB to INVALID_PAGE if VMSA page is NULL
      KVM: x86/hyper-v: Use preallocated per-vCPU buffer for de-sparsified vCPU masks

Wei-Lin Chang (1):
      KVM: arm64: nv: Fix MI line level calculation in vgic_v3_nested_update_mi()

 Documentation/virt/kvm/api.rst                     | 35 +++++++++++++---------
 Documentation/virt/kvm/x86/intel-tdx.rst           | 15 +++++++++-
 arch/arm64/include/asm/kvm_host.h                  |  1 -
 arch/arm64/kvm/arm.c                               | 16 ++++++----
 arch/arm64/kvm/fpsimd.c                            | 26 ----------------
 arch/arm64/kvm/hyp/nvhe/mem_protect.c              | 20 ++++++++-----
 arch/arm64/kvm/nested.c                            | 26 ++++++++++++++--
 arch/arm64/kvm/vgic/vgic-v3-nested.c               |  4 +--
 arch/x86/include/asm/kvm_host.h                    |  7 ++++-
 arch/x86/include/asm/shared/tdx.h                  |  1 +
 arch/x86/include/uapi/asm/kvm.h                    |  8 ++++-
 arch/x86/kvm/hyperv.c                              |  5 +++-
 arch/x86/kvm/svm/sev.c                             | 12 ++++++--
 arch/x86/kvm/vmx/tdx.c                             | 30 +++++++++++++++++++
 arch/x86/kvm/x86.c                                 |  4 ++-
 arch/x86/kvm/xen.c                                 | 15 ++++++++--
 include/linux/psp-sev.h                            |  2 ++
 include/uapi/linux/kvm.h                           |  4 +++
 .../testing/selftests/kvm/x86/monitor_mwait_test.c |  1 +
 virt/kvm/kvm_main.c                                |  3 ++
 20 files changed, 165 insertions(+), 70 deletions(-)


