Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9B5A2C7448
	for <lists+kvm@lfdr.de>; Sat, 28 Nov 2020 23:19:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732670AbgK1Vtn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 28 Nov 2020 16:49:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:48924 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732199AbgK1S7c (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 28 Nov 2020 13:59:32 -0500
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 79547223C7;
        Sat, 28 Nov 2020 12:47:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606567625;
        bh=fnB3UrwreWz3sJGIlA6kos60u0AVN2W7lWnz1F1QPas=;
        h=From:To:Cc:Subject:Date:From;
        b=dtsEoM1jAO3kNJRwc8dSFjNYZHDw2+n4lN1ZUh1mKzpYKmzJ98hgLtg0BeVKBIEte
         2IAbF4XwG42xL1aT9mzmhMmoR4KS3Ww9FcrI0HAt3LS1veAIhX0v2xHiCpv2E1BC3b
         wUMtrY5JzhuMPVM57z4wNp6naLXdolpc6ZmP57K4=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94)
        (envelope-from <maz@kernel.org>)
        id 1kizd1-00EHHF-CD; Sat, 28 Nov 2020 12:47:03 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        kernel-team@android.com
Subject: [PATCH 0/2] KVM: arm64: Expose CSV3 to guests on running on Meltdown-safe HW
Date:   Sat, 28 Nov 2020 12:46:57 +0000
Message-Id: <20201128124659.669578-1-maz@kernel.org>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, will@kernel.org, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, kernel-team@android.com
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

Marc Zyngier (2):
  arm64: Make the Meltdown mitigation state available
  KVM: arm64: Advertise ID_AA64PFR0_EL1.CSV3=1 if the CPUs are
    Meltdown-safe

 arch/arm64/include/asm/kvm_host.h |  1 +
 arch/arm64/include/asm/spectre.h  |  2 ++
 arch/arm64/kernel/cpufeature.c    | 20 +++++++++++++++++---
 arch/arm64/kvm/arm.c              |  6 ++++--
 arch/arm64/kvm/sys_regs.c         | 15 ++++++++++++---
 5 files changed, 36 insertions(+), 8 deletions(-)

-- 
2.28.0

