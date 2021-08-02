Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D13CC3DD5CC
	for <lists+kvm@lfdr.de>; Mon,  2 Aug 2021 14:38:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233652AbhHBMjF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Aug 2021 08:39:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:44756 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232815AbhHBMjE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Aug 2021 08:39:04 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5250960F58;
        Mon,  2 Aug 2021 12:38:55 +0000 (UTC)
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1mAXDZ-002Rjd-BU; Mon, 02 Aug 2021 13:38:53 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org
Cc:     James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Quentin Perret <qperret@google.com>,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        kernel-team@android.com
Subject: [PATCH v2 0/2] KVM: arm64: Prevent kmemleak from accessing HYP data
Date:   Mon,  2 Aug 2021 13:38:28 +0100
Message-Id: <20210802123830.2195174-1-maz@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, qperret@google.com, will@kernel.org, catalin.marinas@arm.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is a rework of the patch previously posted at [1].

The gist of the problem is that kmemleak can legitimately access data
that has been removed from the kernel view, for two reasons:

(1) .hyp.rodata is lumped together with the BSS
(2) there is no separation of the HYP BSS from the kernel BSS

(1) can easily be addressed by moving the .hyp.rodata section into the
    kernel's RO zone, which avoids any kmemleak into that section.
(2) must be addressed by telling kmemleak about the address range.

Tested on a SC2A11 system, in protected and non-protected modes with
kmemleak active. Both patches are stable candidates.

[1] https://lore.kernel.org/r/20210729135016.3037277-1-maz@kernel.org

Marc Zyngier (2):
  arm64: Move .hyp.rodata outside of the _sdata.._edata range
  KVM: arm64: Unregister HYP sections from kmemleak in protected mode

 arch/arm64/kernel/vmlinux.lds.S | 4 ++--
 arch/arm64/kvm/arm.c            | 7 +++++++
 2 files changed, 9 insertions(+), 2 deletions(-)

-- 
2.30.2

