Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8FEAF160595
	for <lists+kvm@lfdr.de>; Sun, 16 Feb 2020 19:53:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726256AbgBPSxk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 16 Feb 2020 13:53:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:38416 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725989AbgBPSxk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 16 Feb 2020 13:53:40 -0500
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A672E20857;
        Sun, 16 Feb 2020 18:53:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581879219;
        bh=CDMcIuGZauuEKnBrc2rOLv93aehoxJbaP6h3f0RnX18=;
        h=From:To:Cc:Subject:Date:From;
        b=hcLuvQ6t0pWiScsDk331LZ8xUf9I4J6C+AiHvBLI3vBXX3yrK/XbyHYS20LSJm7YS
         X6PJnMmZQk1psVCfFEa5F8a92HT7yAYyrI5or5hNtb/dYcsUpg9QytOly26kPX5D2n
         0ayVE3bL7IL1dSbRJJwUUkf/Vakab8Ine9qDJ0Wc=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1j3P2v-005iWD-O3; Sun, 16 Feb 2020 18:53:37 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     Peter Maydell <peter.maydell@linaro.org>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH 0/5] Random debug/PMU fixes for 5.6
Date:   Sun, 16 Feb 2020 18:53:19 +0000
Message-Id: <20200216185324.32596-1-maz@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, peter.maydell@linaro.org, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Here's a few cleanups and fixes for 5.6, all around our debug and
PMU ID register emulation:

1) Missing RES1 bit in DBGDIDR
2) Limiting PMU version to v8.1
3) Limiting debug version to ARMv8.0
4) Support for ARMv8.4-PMU

(1) was reported by Peter, (2) had a patch from Andrew Murray on the
list, but it's been a while since he was going to rebase and fix it,
so I did bite the bullet. (3) is needed until we implement the right
thing with NV. (4) was too easy not to be done right away.

Patch #2 is a cleanup that helps the following patches.

Unless someone objects, I'd like to take this into 5.6 (except maybe
for the last patch).

Marc Zyngier (5):
  KVM: arm64: Fix missing RES1 in emulation of DBGBIDR
  KVM: arm64: Refactor filtering of ID registers
  kvm: arm64: Limit PMU version to ARMv8.1
  KVM: arm64: Limit the debug architecture to ARMv8.0
  KVM: arm64: Upgrade PMU support to ARMv8.4

 arch/arm64/include/asm/sysreg.h |  2 ++
 arch/arm64/kvm/sys_regs.c       | 35 +++++++++++++++++++++++++--------
 2 files changed, 29 insertions(+), 8 deletions(-)

-- 
2.20.1

