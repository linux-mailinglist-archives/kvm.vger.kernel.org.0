Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1637A10416D
	for <lists+kvm@lfdr.de>; Wed, 20 Nov 2019 17:51:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732786AbfKTQvp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Nov 2019 11:51:45 -0500
Received: from inca-roads.misterjones.org ([213.251.177.50]:37414 "EHLO
        inca-roads.misterjones.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729818AbfKTQvp (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 20 Nov 2019 11:51:45 -0500
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by cheepnis.misterjones.org with esmtpsa (TLSv1.2:DHE-RSA-AES128-GCM-SHA256:128)
        (Exim 4.80)
        (envelope-from <maz@kernel.org>)
        id 1iXT4K-0007RI-T9; Wed, 20 Nov 2019 17:43:04 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc:     Alexander Graf <graf@amazon.com>,
        Andrew Jones <drjones@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Eric Auger <eric.auger@redhat.com>,
        Heinrich Schuchardt <xypron.glpk@gmx.de>,
        Julien Grall <julien.grall@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Steven Price <steven.price@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Will Deacon <will@kernel.org>,
        Zenghui Yu <yuzenghui@huawei.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu
Subject: [PATCH 13/22] KVM: arm64: Select TASK_DELAY_ACCT+TASKSTATS rather than SCHEDSTATS
Date:   Wed, 20 Nov 2019 16:42:27 +0000
Message-Id: <20191120164236.29359-14-maz@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191120164236.29359-1-maz@kernel.org>
References: <20191120164236.29359-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, rkrcmar@redhat.com, graf@amazon.com, drjones@redhat.com, borntraeger@de.ibm.com, christoffer.dall@arm.com, eric.auger@redhat.com, xypron.glpk@gmx.de, julien.grall@arm.com, mark.rutland@arm.com, bigeasy@linutronix.de, steven.price@arm.com, tglx@linutronix.de, will@kernel.org, yuzenghui@huawei.com, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on cheepnis.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Steven Price <steven.price@arm.com>

SCHEDSTATS requires DEBUG_KERNEL (and PROC_FS) and therefore isn't a
good choice for enabling the scheduling statistics required for stolen
time.

Instead match the x86 configuration and select TASK_DELAY_ACCT and
TASKSTATS. This adds the dependencies of NET && MULTIUSER for arm64 KVM.

Suggested-by: Marc Zyngier <maz@kernel.org>
Fixes: 8564d6372a7d ("KVM: arm64: Support stolen time reporting via shared structure")
Signed-off-by: Steven Price <steven.price@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/Kconfig | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
index d8b88e40d223..a475c68cbfec 100644
--- a/arch/arm64/kvm/Kconfig
+++ b/arch/arm64/kvm/Kconfig
@@ -21,6 +21,8 @@ if VIRTUALIZATION
 config KVM
 	bool "Kernel-based Virtual Machine (KVM) support"
 	depends on OF
+	# for TASKSTATS/TASK_DELAY_ACCT:
+	depends on NET && MULTIUSER
 	select MMU_NOTIFIER
 	select PREEMPT_NOTIFIERS
 	select HAVE_KVM_CPU_RELAX_INTERCEPT
@@ -39,7 +41,8 @@ config KVM
 	select IRQ_BYPASS_MANAGER
 	select HAVE_KVM_IRQ_BYPASS
 	select HAVE_KVM_VCPU_RUN_PID_CHANGE
-	select SCHEDSTATS
+	select TASKSTATS
+	select TASK_DELAY_ACCT
 	---help---
 	  Support hosting virtualized guest machines.
 	  We don't support KVM with 16K page tables yet, due to the multiple
-- 
2.20.1

