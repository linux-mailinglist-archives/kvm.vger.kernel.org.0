Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1440733A3A2
	for <lists+kvm@lfdr.de>; Sun, 14 Mar 2021 09:38:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235022AbhCNIiU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 14 Mar 2021 04:38:20 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:35560 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235014AbhCNIiQ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 14 Mar 2021 04:38:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615711095;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=Q5htzpqStR00s3GjmGcznA1WFQEWyNZWX9JW1434yRU=;
        b=N+Au5Xqgp3+DNz3HmP0P2CexcFjAKMb0xp1xMvG2ELTFtRg0JIsjP727FGJ4CmUV9x+Fl3
        x0iVIl4vElWn7FPmt+NRlIrKgkMIsFL3WZudsA30EgK0v1efeGSLSTy+n1b1FAYHizvt8U
        8O9NDipUPkiuxSIOsGpANvx9M9qX6Q4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-190-hqttKa4sNCK4wgkoW0wM-w-1; Sun, 14 Mar 2021 04:38:13 -0400
X-MC-Unique: hqttKa4sNCK4wgkoW0wM-w-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 56216107ACCD;
        Sun, 14 Mar 2021 08:38:12 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 067A519635;
        Sun, 14 Mar 2021 08:38:11 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     torvalds@linux-foundation.org
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [GIT PULL] KVM fixes for 5.12-rc3
Date:   Sun, 14 Mar 2021 04:38:11 -0400
Message-Id: <20210314083811.1431665-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Linus,

The following changes since commit 9e46f6c6c959d9bb45445c2e8f04a75324a0dfd0:

  KVM: SVM: Clear the CR4 register on reset (2021-03-02 14:39:11 -0500)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

for you to fetch changes up to 35737d2db2f4567106c90060ad110b27cb354fa4:

  KVM: LAPIC: Advancing the timer expiration on guest initiated write (2021-03-12 13:18:52 -0500)

----------------------------------------------------------------
More fixes for ARM and x86.

----------------------------------------------------------------
Andrew Scull (1):
      KVM: arm64: Fix nVHE hyp panic host context restore

Jia He (1):
      KVM: arm64: Fix range alignment when walking page tables

Marc Zyngier (7):
      KVM: arm64: Turn kvm_arm_support_pmu_v3() into a static key
      KVM: arm64: Don't access PMSELR_EL0/PMUSERENR_EL0 when no PMU is available
      KVM: arm64: Rename __vgic_v3_get_ich_vtr_el2() to __vgic_v3_get_gic_config()
      KVM: arm64: Workaround firmware wrongly advertising GICv2-on-v3 compatibility
      KVM: arm64: Ensure I-cache isolation between vcpus of a same VM
      KVM: arm64: Reject VM creation when the default IPA size is unsupported
      KVM: arm64: Fix exclusive limit for IPA size

Muhammad Usama Anjum (2):
      kvm: x86: use NULL instead of using plain integer as pointer
      kvm: x86: annotate RCU pointers

Sami Tolvanen (1):
      KVM: arm64: Don't use cbz/adr with external symbols

Sean Christopherson (3):
      KVM: x86: Ensure deadline timer has truly expired before posting its IRQ
      KVM: SVM: Connect 'npt' module param to KVM's internal 'npt_enabled'
      KVM: x86/mmu: Skip !MMU-present SPTEs when removing SP in exclusive mode

Suzuki K Poulose (1):
      KVM: arm64: nvhe: Save the SPE context early

Wanpeng Li (2):
      KVM: kvmclock: Fix vCPUs > 64 can't be online/hotpluged
      KVM: LAPIC: Advancing the timer expiration on guest initiated write

Will Deacon (1):
      KVM: arm64: Avoid corrupting vCPU context register in guest exit

 Documentation/virt/kvm/api.rst          |  3 +++
 arch/arm64/include/asm/kvm_asm.h        |  8 +++----
 arch/arm64/include/asm/kvm_hyp.h        |  8 ++++++-
 arch/arm64/kernel/image-vars.h          |  3 +++
 arch/arm64/kvm/arm.c                    |  7 +++++-
 arch/arm64/kvm/hyp/entry.S              |  8 ++++---
 arch/arm64/kvm/hyp/include/hyp/switch.h |  9 +++++---
 arch/arm64/kvm/hyp/nvhe/debug-sr.c      | 12 ++++++++--
 arch/arm64/kvm/hyp/nvhe/host.S          | 15 +++++++------
 arch/arm64/kvm/hyp/nvhe/hyp-main.c      | 12 +++++-----
 arch/arm64/kvm/hyp/nvhe/switch.c        | 14 +++++++++---
 arch/arm64/kvm/hyp/nvhe/tlb.c           |  3 ++-
 arch/arm64/kvm/hyp/pgtable.c            |  1 +
 arch/arm64/kvm/hyp/vgic-v3-sr.c         | 40 +++++++++++++++++++++++++++++++--
 arch/arm64/kvm/hyp/vhe/tlb.c            |  3 ++-
 arch/arm64/kvm/mmu.c                    |  3 +--
 arch/arm64/kvm/perf.c                   | 10 +++++++++
 arch/arm64/kvm/pmu-emul.c               | 10 ---------
 arch/arm64/kvm/reset.c                  | 12 ++++++----
 arch/arm64/kvm/vgic/vgic-v3.c           | 12 +++++++---
 arch/x86/include/asm/kvm_host.h         |  4 ++--
 arch/x86/kernel/kvmclock.c              | 19 ++++++++--------
 arch/x86/kvm/lapic.c                    | 12 +++++++++-
 arch/x86/kvm/mmu/tdp_mmu.c              | 11 +++++++++
 arch/x86/kvm/svm/svm.c                  | 25 +++++++++++----------
 arch/x86/kvm/x86.c                      |  2 +-
 include/kvm/arm_pmu.h                   |  9 ++++++--
 27 files changed, 194 insertions(+), 81 deletions(-)

