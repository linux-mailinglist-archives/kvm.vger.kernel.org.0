Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EEA142ED38
	for <lists+kvm@lfdr.de>; Fri, 15 Oct 2021 11:10:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236895AbhJOJMV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Oct 2021 05:12:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:59058 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230471AbhJOJMU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Oct 2021 05:12:20 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5F21961108;
        Fri, 15 Oct 2021 09:10:14 +0000 (UTC)
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1mbJCT-00GvHX-V6; Fri, 15 Oct 2021 10:10:12 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc:     James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Quentin Perret <qperret@google.com>,
        Will Deacon <will@kernel.org>, kernel-team@android.com
Subject: [PATCH 0/5] KVM: arm64: Reorganise vcpu first run
Date:   Fri, 15 Oct 2021 10:08:17 +0100
Message-Id: <20211015090822.2994920-1-maz@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, qperret@google.com, will@kernel.org, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

KVM/arm64 relies heavily on a bunch of things to be done on the first
run of the vcpu. We also do a bunch of things on PID change. It turns
out that these two things are pretty similar (the first PID change is
also the first run).

This small series aims at simplifying all that, and to get rid of the
vcpu->arch.has_run_once state.

Marc Zyngier (5):
  KVM: arm64: Move SVE state mapping at HYP to finalize-time
  KVM: arm64: Move kvm_arch_vcpu_run_pid_change() out of line
  KVM: arm64: Merge kvm_arch_vcpu_run_pid_change() and
    kvm_vcpu_first_run_init()
  KVM: arm64: Restructure the point where has_run_once is advertised
  KVM: arm64: Drop vcpu->arch.has_run_once for vcpu->pid

 arch/arm64/include/asm/kvm_host.h | 12 +++------
 arch/arm64/kvm/arm.c              | 43 ++++++++++++++++++-------------
 arch/arm64/kvm/fpsimd.c           | 11 --------
 arch/arm64/kvm/reset.c            | 11 +++++++-
 arch/arm64/kvm/vgic/vgic-init.c   |  2 +-
 5 files changed, 39 insertions(+), 40 deletions(-)

-- 
2.30.2

