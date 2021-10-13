Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FA7A42BF6C
	for <lists+kvm@lfdr.de>; Wed, 13 Oct 2021 14:04:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232491AbhJMMGD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Oct 2021 08:06:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:56190 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230005AbhJMMGC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Oct 2021 08:06:02 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D519460EB4;
        Wed, 13 Oct 2021 12:03:59 +0000 (UTC)
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1maczF-00GTgY-Gq; Wed, 13 Oct 2021 13:03:57 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc:     will@kernel.org, james.morse@arm.com, alexandru.elisei@arm.com,
        suzuki.poulose@arm.com, mark.rutland@arm.com, pbonzini@redhat.com,
        drjones@redhat.com, oupton@google.com, qperret@google.com,
        kernel-team@android.com, tabba@google.com
Subject: [PATCH v9 00/22] KVM: arm64: Fixed features for protected VMs
Date:   Wed, 13 Oct 2021 13:03:35 +0100
Message-Id: <20211013120346.2926621-1-maz@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211010145636.1950948-12-tabba@google.com>
References: <20211010145636.1950948-12-tabba@google.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, will@kernel.org, james.morse@arm.com, alexandru.elisei@arm.com, suzuki.poulose@arm.com, mark.rutland@arm.com, pbonzini@redhat.com, drjones@redhat.com, oupton@google.com, qperret@google.com, kernel-team@android.com, tabba@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is an update on Fuad's series[1].

Instead of going going back and forth over a series that has seen a
fair few versions, I've opted for simply writing a set of fixes on
top, hopefully greatly simplifying the handling of most registers, and
moving things around to suit my own taste (just because I can).

I won't be reposting the initial 11 patches, which is why this series
in is reply to patch 11.

Thanks,

	M.

[1] https://lore.kernel.org/r/20211010145636.1950948-1-tabba@google.com

Fuad Tabba (8):
  KVM: arm64: Pass struct kvm to per-EC handlers
  KVM: arm64: Add missing field descriptor for MDCR_EL2
  KVM: arm64: Simplify masking out MTE in feature id reg
  KVM: arm64: Add handlers for protected VM System Registers
  KVM: arm64: Initialize trap registers for protected VMs
  KVM: arm64: Move sanitized copies of CPU features
  KVM: arm64: Trap access to pVM restricted features
  KVM: arm64: Handle protected guests at 32 bits

Marc Zyngier (14):
  KVM: arm64: Move __get_fault_info() and co into their own include file
  KVM: arm64: Don't include switch.h into nvhe/kvm-main.c
  KVM: arm64: Move early handlers to per-EC handlers
  KVM: arm64: Fix early exit ptrauth handling
  KVM: arm64: pkvm: Use a single function to expose all id-regs
  KVM: arm64: pkvm: Make the ERR/ERX*_EL1 registers RAZ/WI
  KVM: arm64: pkvm: Drop AArch32-specific registers
  KVM: arm64: pkvm: Drop sysregs that should never be routed to the host
  KVM: arm64: pkvm: Handle GICv3 traps as required
  KVM: arm64: pkvm: Preserve pending SError on exit from AArch32
  KVM: arm64: pkvm: Consolidate include files
  KVM: arm64: pkvm: Move kvm_handle_pvm_restricted around
  KVM: arm64: pkvm: Pass vpcu instead of kvm to
    kvm_get_exit_handler_array()
  KVM: arm64: pkvm: Give priority to standard traps over pvm handling

 arch/arm64/include/asm/kvm_arm.h              |   1 +
 arch/arm64/include/asm/kvm_asm.h              |   1 +
 arch/arm64/include/asm/kvm_host.h             |   2 +
 arch/arm64/include/asm/kvm_hyp.h              |   5 +
 arch/arm64/kvm/arm.c                          |  13 +
 arch/arm64/kvm/hyp/include/hyp/fault.h        |  75 +++
 arch/arm64/kvm/hyp/include/hyp/switch.h       | 235 ++++-----
 .../arm64/kvm/hyp/include/nvhe/fixed_config.h | 200 +++++++
 .../arm64/kvm/hyp/include/nvhe/trap_handler.h |   2 +
 arch/arm64/kvm/hyp/nvhe/Makefile              |   2 +-
 arch/arm64/kvm/hyp/nvhe/hyp-main.c            |  11 +-
 arch/arm64/kvm/hyp/nvhe/mem_protect.c         |   8 +-
 arch/arm64/kvm/hyp/nvhe/pkvm.c                | 185 +++++++
 arch/arm64/kvm/hyp/nvhe/setup.c               |   3 +
 arch/arm64/kvm/hyp/nvhe/switch.c              |  99 ++++
 arch/arm64/kvm/hyp/nvhe/sys_regs.c            | 487 ++++++++++++++++++
 arch/arm64/kvm/hyp/vhe/switch.c               |  16 +
 arch/arm64/kvm/sys_regs.c                     |  10 +-
 18 files changed, 1200 insertions(+), 155 deletions(-)
 create mode 100644 arch/arm64/kvm/hyp/include/hyp/fault.h
 create mode 100644 arch/arm64/kvm/hyp/include/nvhe/fixed_config.h
 create mode 100644 arch/arm64/kvm/hyp/nvhe/pkvm.c
 create mode 100644 arch/arm64/kvm/hyp/nvhe/sys_regs.c

-- 
2.30.2

