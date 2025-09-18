Return-Path: <kvm+bounces-58008-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id D4BB6B84C93
	for <lists+kvm@lfdr.de>; Thu, 18 Sep 2025 15:22:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6F56F7AC1BF
	for <lists+kvm@lfdr.de>; Thu, 18 Sep 2025 13:20:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 419D7306484;
	Thu, 18 Sep 2025 13:22:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GI+20U/r"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4C711A9FB8
	for <kvm@vger.kernel.org>; Thu, 18 Sep 2025 13:22:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758201750; cv=none; b=VVjyXFbB3MesrxZi6kX58ko0cPaXRI+ZNxF3hYBUD8T6glxewOuYogxS+V19jC+fZP9dIBM+MQHhMpn7Q4xmcRx5mcxxFOkro4yh1s2+wsRGdA7jnMIEG1DP3ninJPclr0TapDoLvJJVJJZRECg/FZ5soFtoLiv1T156hvvkLd8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758201750; c=relaxed/simple;
	bh=BmmjhMSlULa0Sw2G+j4w0doVs9sVms2g/7FH0QyVzCM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=HmCNTeeXbtM2fnd3esfnW69ZP3eUO1KPFJXZWsCUHW/HvpOBOgM03YxlLfzCMMdPBKBQi/Rh324GCfSXsfQnA9gntm7rRmu3c+TRRuwrAdpVqCaBsAc23VhKjGU4vnT+zPfZ70Au6YaoEfzIMKsis5pD3770NgTq830GNH9YnH0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GI+20U/r; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758201747;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=hLU1auxJCtyqjrL1fEtHv+sYbxXpMTlL4qrOP76xkuI=;
	b=GI+20U/rCmWl6gWMuwOcCHLvx071mge1gZSGyUf6IvtwcYNhz6aiPjiGCZ+lwsSZNbO/KA
	ll+NWq2eSTdKh1Tr9VtZi/U+ET8e3pKC1PO8zVZasym36vfQn6qnRfzdzmEKC2T0BJhTeo
	FL+ciYyM2wBrK37l9YrWRwtvJOlb8Kw=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-296-emOI2IXvMlS8EiEiaXianA-1; Thu,
 18 Sep 2025 09:22:25 -0400
X-MC-Unique: emOI2IXvMlS8EiEiaXianA-1
X-Mimecast-MFC-AGG-ID: emOI2IXvMlS8EiEiaXianA_1758201744
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id F41DA180AC7C;
	Thu, 18 Sep 2025 13:22:18 +0000 (UTC)
Received: from avogadro.redhat.com (unknown [10.44.32.97])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 785AF3002D26;
	Thu, 18 Sep 2025 13:22:17 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Subject: [GIT PULL] KVM changes for Linux 6.17-rc7
Date: Thu, 18 Sep 2025 15:22:15 +0200
Message-ID: <20250918132215.16700-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

Linus,

The following changes since commit f83ec76bf285bea5727f478a68b894f5543ca76e:

  Linux 6.17-rc6 (2025-09-14 14:21:14 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

for you to fetch changes up to ecd42dd170ea7bacdd9d01d8e74658df8dff621d:

  Merge tag 'kvm-s390-master-6.17-1' of https://git.kernel.org/pub/scm/linux/kernel/git/kvms390/linux into HEAD (2025-09-17 19:45:21 +0200)

These are for the most Oliver's Arm changes: lock ordering fixes for the
vGIC, and reverts for a buggy attempt to avoid RCU stalls on large VMs.

----------------------------------------------------------------
Arm:

- Invalidate nested MMUs upon freeing the PGD to avoid WARNs when
  visiting from an MMU notifier

- Fixes to the TLB match process and TLB invalidation range for
  managing the VCNR pseudo-TLB

- Prevent SPE from erroneously profiling guests due to UNKNOWN reset
  values in PMSCR_EL1

- Fix save/restore of host MDCR_EL2 to account for eagerly programming
  at vcpu_load() on VHE systems

- Correct lock ordering when dealing with VGIC LPIs, avoiding scenarios
  where an xarray's spinlock was nested with a *raw* spinlock

- Permit stage-2 read permission aborts which are possible in the case
  of NV depending on the guest hypervisor's stage-2 translation

- Call raw_spin_unlock() instead of the internal spinlock API

- Fix parameter ordering when assigning VBAR_EL1

- Reverted a couple of fixes for RCU stalls when destroying a stage-2
  page table. There appears to be some nasty refcounting / UAF issues
  lurking in those patches and the band-aid we tried to apply didn't
  hold.

s390:

- mm fixes, including userfaultfd bug fix

x86:

- Sync the vTPR from the local APIC to the VMCB even when AVIC is active.
  This fixes a bug where host updates to the vTPR, e.g. via KVM_SET_LAPIC or
  emulation of a guest access, are lost and result in interrupt delivery
  issues in the guest.

----------------------------------------------------------------
Alexandru Elisei (2):
      KVM: arm64: Initialize PMSCR_EL1 when in VHE
      KVM: arm64: VHE: Save and restore host MDCR_EL2 value correctly

Alok Tiwari (1):
      KVM: arm64: vgic: fix incorrect spinlock API usage

Claudio Imbrenda (2):
      KVM: s390: Fix incorrect usage of mmu_notifier_register()
      KVM: s390: Fix FOLL_*/FAULT_FLAG_* confusion

Dongha Lee (1):
      KVM: arm64: nv: Fix incorrect VNCR invalidation range calculation

Fuad Tabba (1):
      KVM: arm64: Fix parameter ordering for VBAR_EL1 assignment

Geonha Lee (1):
      KVM: arm64: nv: fix VNCR TLB ASID match logic for non-Global entries

Maciej S. Szmigiero (1):
      KVM: SVM: Sync TPR from LAPIC into VMCB::V_TPR even if AVIC is active

Marc Zyngier (1):
      KVM: arm64: Mark freed S2 MMUs as invalid

Oliver Upton (8):
      KVM: arm64: vgic: Drop stale comment on IRQ active state
      KVM: arm64: vgic-v3: Use bare refcount for VGIC LPIs
      KVM: arm64: Spin off release helper from vgic_put_irq()
      KVM: arm64: vgic-v3: Erase LPIs from xarray outside of raw spinlocks
      KVM: arm64: vgic-v3: Don't require IRQs be disabled for LPI xarray lock
      KVM: arm64: vgic-v3: Indicate vgic_put_irq() may take LPI xarray lock
      Revert "KVM: arm64: Reschedule as needed when destroying the stage-2 page-tables"
      Revert "KVM: arm64: Split kvm_pgtable_stage2_destroy()"

Paolo Bonzini (3):
      Merge tag 'kvmarm-fixes-6.17-2' of https://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm into HEAD
      Merge tag 'kvm-x86-fixes-6.17-rcN' of https://github.com/kvm-x86/linux into HEAD
      Merge tag 'kvm-s390-master-6.17-1' of https://git.kernel.org/pub/scm/linux/kernel/git/kvms390/linux into HEAD

Thomas Huth (1):
      KVM: s390: Fix access to unavailable adapter indicator pages during postcopy

Wei-Lin Chang (1):
      KVM: arm64: Remove stage 2 read fault check

 arch/arm64/include/asm/kvm_host.h       |  1 +
 arch/arm64/include/asm/kvm_pgtable.h    | 30 -------------
 arch/arm64/include/asm/kvm_pkvm.h       |  4 +-
 arch/arm64/kvm/arm.c                    |  4 +-
 arch/arm64/kvm/debug.c                  | 13 ++++++
 arch/arm64/kvm/hyp/include/hyp/switch.h |  5 ---
 arch/arm64/kvm/hyp/nvhe/switch.c        |  6 +++
 arch/arm64/kvm/hyp/nvhe/sys_regs.c      |  2 +-
 arch/arm64/kvm/hyp/pgtable.c            | 25 ++---------
 arch/arm64/kvm/mmu.c                    | 45 +++----------------
 arch/arm64/kvm/nested.c                 |  6 +--
 arch/arm64/kvm/pkvm.c                   | 11 +----
 arch/arm64/kvm/vgic/vgic-debug.c        |  2 +-
 arch/arm64/kvm/vgic/vgic-init.c         |  6 +--
 arch/arm64/kvm/vgic/vgic-its.c          | 15 +++----
 arch/arm64/kvm/vgic/vgic-v4.c           |  2 +-
 arch/arm64/kvm/vgic/vgic.c              | 80 ++++++++++++++++++++++++---------
 arch/arm64/kvm/vgic/vgic.h              |  8 ++--
 arch/s390/kvm/interrupt.c               | 15 +++++--
 arch/s390/kvm/kvm-s390.c                | 24 +++++-----
 arch/s390/kvm/pv.c                      | 16 ++++---
 arch/x86/kvm/svm/svm.c                  |  3 +-
 include/kvm/arm_vgic.h                  |  9 ++--
 23 files changed, 155 insertions(+), 177 deletions(-)


