Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C13A2CF436
	for <lists+kvm@lfdr.de>; Fri,  4 Dec 2020 19:38:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730173AbgLDSi1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Dec 2020 13:38:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:48474 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727210AbgLDSi1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Dec 2020 13:38:27 -0500
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6B3FE22AAB;
        Fri,  4 Dec 2020 18:37:46 +0000 (UTC)
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94)
        (envelope-from <maz@kernel.org>)
        id 1klFxg-00G3Uh-30; Fri, 04 Dec 2020 18:37:44 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        David Brazdil <dbarzdil@google.com>, kernel-team@android.com
Subject: [PATCH v2 0/2] KVM: arm64: Expose CSV3 to guests on running on Meltdown-safe HW
Date:   Fri,  4 Dec 2020 18:37:07 +0000
Message-Id: <20201204183709.784533-1-maz@kernel.org>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, will@kernel.org, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, dbarzdil@google.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Will recently pointed out that when running on big-little systems that
are known not to be vulnerable to Metldown, guests are not presented
with the CSV3 property if the physical HW include a core that doesn't
have CSV3, despite being known to be safe (it is on the kpti_safe_list).

Since this is valuable information that can be cheaply given to the
guest, let's just do that. The scheme is the same as what we do for
CSV2, allowing userspace to change the default setting if this doesn't
advertise a safer setting than what the kernel thinks it is.

* From v1:
  - Fix the clearing of ID_AA64PFR0_EL1.CSV3 on update from userspace
  - Actually store the userspace value

Marc Zyngier (2):
  arm64: Make the Meltdown mitigation state available
  KVM: arm64: Advertise ID_AA64PFR0_EL1.CSV3=1 if the CPUs are
    Meltdown-safe

 arch/arm64/include/asm/kvm_host.h |  1 +
 arch/arm64/include/asm/spectre.h  |  2 ++
 arch/arm64/kernel/cpufeature.c    | 20 +++++++++++++++++---
 arch/arm64/kvm/arm.c              |  6 ++++--
 arch/arm64/kvm/sys_regs.c         | 16 +++++++++++++---
 5 files changed, 37 insertions(+), 8 deletions(-)

-- 
2.28.0

