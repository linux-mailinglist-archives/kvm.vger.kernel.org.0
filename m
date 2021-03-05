Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46C5432F33C
	for <lists+kvm@lfdr.de>; Fri,  5 Mar 2021 19:53:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229848AbhCESx0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Mar 2021 13:53:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:58170 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229465AbhCESxB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Mar 2021 13:53:01 -0500
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9478A65090;
        Fri,  5 Mar 2021 18:53:00 +0000 (UTC)
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94)
        (envelope-from <maz@kernel.org>)
        id 1lIFZK-00HYFA-HR; Fri, 05 Mar 2021 18:52:58 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>,
        Andre Przywara <andre.przywara@arm.com>,
        Andrew Scull <ascull@google.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Howard Zhang <Howard.Zhang@arm.com>,
        Jia He <justin.he@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Quentin Perret <qperret@google.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Will Deacon <will@kernel.org>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        kernel-team@android.com, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Subject: [PATCH 0/8] KVM/arm64 fixes for 5.12, take #1
Date:   Fri,  5 Mar 2021 18:52:46 +0000
Message-Id: <20210305185254.3730990-1-maz@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <87eegtzbch.wl-maz@kernel.org>
References: <87eegtzbch.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, alexandru.elisei@arm.com, andre.przywara@arm.com, ascull@google.com, catalin.marinas@arm.com, christoffer.dall@arm.com, Howard.Zhang@arm.com, justin.he@arm.com, mark.rutland@arm.com, qperret@google.com, shameerali.kolothum.thodi@huawei.com, suzuki.poulose@arm.com, will@kernel.org, james.morse@arm.com, julien.thierry.kdev@gmail.com, kernel-team@android.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Paolo,

Here's the first batch of fixes for 5.12. We have a handful of low
level world-switch regressions, a page table walker fix, more PMU
tidying up, and a workaround for systems with creative firmware.

This will need to go on top of the current state of mainline.

Please apply,

	M.

Andrew Scull (1):
      KVM: arm64: Fix nVHE hyp panic host context restore

Jia He (1):
      KVM: arm64: Fix range alignment when walking page tables

Marc Zyngier (4):
      KVM: arm64: Turn kvm_arm_support_pmu_v3() into a static key
      KVM: arm64: Don't access PMSELR_EL0/PMUSERENR_EL0 when no PMU is available
      KVM: arm64: Rename __vgic_v3_get_ich_vtr_el2() to __vgic_v3_get_gic_config()
      KVM: arm64: Workaround firmware wrongly advertising GICv2-on-v3 compatibility

Suzuki K Poulose (1):
      KVM: arm64: nvhe: Save the SPE context early

Will Deacon (1):
      KVM: arm64: Avoid corrupting vCPU context register in guest exit

 arch/arm64/include/asm/kvm_asm.h        |  4 ++--
 arch/arm64/include/asm/kvm_hyp.h        |  8 ++++++-
 arch/arm64/kernel/image-vars.h          |  3 +++
 arch/arm64/kvm/hyp/entry.S              |  2 +-
 arch/arm64/kvm/hyp/include/hyp/switch.h |  9 +++++---
 arch/arm64/kvm/hyp/nvhe/debug-sr.c      | 12 ++++++++--
 arch/arm64/kvm/hyp/nvhe/host.S          | 15 +++++++------
 arch/arm64/kvm/hyp/nvhe/hyp-main.c      |  6 ++---
 arch/arm64/kvm/hyp/nvhe/switch.c        | 14 +++++++++---
 arch/arm64/kvm/hyp/pgtable.c            |  1 +
 arch/arm64/kvm/hyp/vgic-v3-sr.c         | 40 +++++++++++++++++++++++++++++++--
 arch/arm64/kvm/perf.c                   | 10 +++++++++
 arch/arm64/kvm/pmu-emul.c               | 10 ---------
 arch/arm64/kvm/vgic/vgic-v3.c           | 12 +++++++---
 include/kvm/arm_pmu.h                   |  9 ++++++--
 15 files changed, 116 insertions(+), 39 deletions(-)
