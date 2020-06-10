Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 421A31F5346
	for <lists+kvm@lfdr.de>; Wed, 10 Jun 2020 13:34:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728527AbgFJLeQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Jun 2020 07:34:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:42712 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728491AbgFJLeQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Jun 2020 07:34:16 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B0BCA20734;
        Wed, 10 Jun 2020 11:34:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591788855;
        bh=9N6nffWe0REroh98cZzvRnmfrffUIT7lJJ7yMkeQ6uI=;
        h=From:To:Cc:Subject:Date:From;
        b=Ksvks8e29KLnHD9le872+c+3SUvatPHr3scAMz190kRFvyApeml9YWHh8o+yITFcD
         Mj8bsnfTJ1Vtcu0R5MHp396KaIIEEQ11lRB+vXVJj0rIdF/qd77dIO2NIfDLl5PFao
         YoBbsMa+nMUOr7bfYEkscw/tyWNN//u47xzi+XXM=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1jiyzm-001lrp-8M; Wed, 10 Jun 2020 12:34:14 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org
Cc:     James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Andrew Scull <ascull@google.com>, kernel-team@android.com
Subject: [PATCH v2 0/4] kvm: arm64: Pointer Authentication handling fixes
Date:   Wed, 10 Jun 2020 12:34:02 +0100
Message-Id: <20200610113406.1493170-1-maz@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, will@kernel.org, catalin.marinas@arm.com, mark.rutland@arm.com, ascull@google.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

I recently discovered that the Pointer Authentication (PtrAuth)
handling code in KVM is busted, and has been for a while. The main
issue is that the we save the host's keys from a preemptible
context. Things will go wrong at some point.

In order to address this, the first patch move the saving of the
host's keys to vcpu_load(). It is done eagerly, which is a bore, but
is at least safe. This is definitely stable material.

The following patch is adding an optimisatioe: we handle key saving
and HCR massaging as a fixup, much like the FPSIMD code.

Subsequent patch cleans up our HYP per-CPU accessor and make it sparse
friendly, asthe last patch makes heavy use of it by killing the
per-vcpu backpointer to the physical CPU context, avoiding the first
bug altogether.

This has been very lightly tested on a model. Unless someone shouts, I
plan to send this as part of the pending set of fixes.

* From v1:
  - Dropped the misbehaving guest handling patch
  - Added the two cleanup patches to the series (previously posted separately)

Marc Zyngier (4):
  KVM: arm64: Save the host's PtrAuth keys in non-preemptible context
  KVM: arm64: Handle PtrAuth traps early
  KVM: arm64: Stop sparse from moaning at __hyp_this_cpu_ptr
  KVM: arm64: Remove host_cpu_context member from vcpu structure

 arch/arm64/include/asm/kvm_asm.h     | 13 ++++--
 arch/arm64/include/asm/kvm_emulate.h |  6 ---
 arch/arm64/include/asm/kvm_host.h    |  3 --
 arch/arm64/kvm/arm.c                 |  6 +--
 arch/arm64/kvm/handle_exit.c         | 32 ++------------
 arch/arm64/kvm/hyp/debug-sr.c        |  4 +-
 arch/arm64/kvm/hyp/switch.c          | 65 +++++++++++++++++++++++++++-
 arch/arm64/kvm/hyp/sysreg-sr.c       |  6 ++-
 arch/arm64/kvm/pmu.c                 |  8 +---
 arch/arm64/kvm/sys_regs.c            | 13 +++---
 10 files changed, 91 insertions(+), 65 deletions(-)

-- 
2.26.2

