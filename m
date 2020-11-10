Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80ED22AD861
	for <lists+kvm@lfdr.de>; Tue, 10 Nov 2020 15:13:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730760AbgKJONP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Nov 2020 09:13:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:34286 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730184AbgKJONP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Nov 2020 09:13:15 -0500
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BB782207E8;
        Tue, 10 Nov 2020 14:13:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605017594;
        bh=JIJiOB88U7qGpDmmoxCMenpTc0s/h87h3MJM7Q4ZwqA=;
        h=From:To:Cc:Subject:Date:From;
        b=eevBjJdxE5ATVifFoMcdFwRvrDrdPcf5A4Uq/2knK9AMjrV+rWkfyxDhEH01yIWef
         3klarVSpE4HXbH9ai0o4gTWeHp9jseRMkfwBjO6DSQaRxmLxSG8piSTXfX81nNjkn0
         bj3yquDDsN6Py/6sLS8LytdTTa4yjRyN7GGPZc8U=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94)
        (envelope-from <maz@kernel.org>)
        id 1kcUOW-009T8Q-Da; Tue, 10 Nov 2020 14:13:12 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org
Cc:     Peng Liang <liangpeng10@huawei.com>, Will Deacon <will@kernel.org>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        kernel-team@android.com
Subject: [PATCH v2 0/3] KVM: arm64: Another set of CSV2-related fixes
Date:   Tue, 10 Nov 2020 14:13:05 +0000
Message-Id: <20201110141308.451654-1-maz@kernel.org>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, liangpeng10@huawei.com, will@kernel.org, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This small series addresses a couple of Spectre-v2 related issues:

- Fix a live migration regression introduced with the setting of CSV2
  on systems that are not affected by Spectre-v2, but that don't
  directly expose it in ID_AA64PFR0_EL1

- Inject an UNDEF exception if the guest tries to access any of
  SCXTNUM_ELx, as we don't advertise it to guests.

Patches on top of 5.10-rc2.

* From v1:
  - Only register a new value for CSV2 on a valid write to ID_AA64PFR0_EL1
  - Delete even more code in patch #2

Marc Zyngier (3):
  KVM: arm64: Allow setting of ID_AA64PFR0_EL1.CSV2 from userspace
  KVM: arm64: Unify trap handlers injecting an UNDEF
  KVM: arm64: Handle SCXTNUM_ELx traps

 arch/arm64/include/asm/kvm_host.h |   2 +
 arch/arm64/include/asm/sysreg.h   |   4 ++
 arch/arm64/kvm/arm.c              |  16 +++++
 arch/arm64/kvm/sys_regs.c         | 111 ++++++++++++++++++------------
 4 files changed, 89 insertions(+), 44 deletions(-)

-- 
2.28.0

