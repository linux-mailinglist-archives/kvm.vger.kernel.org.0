Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C10043DFD9
	for <lists+kvm@lfdr.de>; Thu, 28 Oct 2021 13:16:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230077AbhJ1LTV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Oct 2021 07:19:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:57072 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230216AbhJ1LTN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Oct 2021 07:19:13 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1089E6112E;
        Thu, 28 Oct 2021 11:16:47 +0000 (UTC)
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1mg3On-002BtD-6b; Thu, 28 Oct 2021 12:16:45 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc:     James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Quentin Perret <qperret@google.com>,
        Will Deacon <will@kernel.org>, broonie@kernel.org,
        kernel-team@android.com
Subject: [PATCH v2 5/5] arm64/fpsimd: Document the use of TIF_FOREIGN_FPSTATE by KVM
Date:   Thu, 28 Oct 2021 12:16:40 +0100
Message-Id: <20211028111640.3663631-6-maz@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211028111640.3663631-1-maz@kernel.org>
References: <20211028111640.3663631-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, qperret@google.com, will@kernel.org, broonie@kernel.org, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The bit of documentation that talks about TIF_FOREIGN_FPSTATE
does not mention the ungodly tricks that KVM plays with this flag.

Try and document this for the posterity.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kernel/fpsimd.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kernel/fpsimd.c b/arch/arm64/kernel/fpsimd.c
index ff4962750b3d..1fbd6ba7dbac 100644
--- a/arch/arm64/kernel/fpsimd.c
+++ b/arch/arm64/kernel/fpsimd.c
@@ -78,7 +78,11 @@
  * indicate whether or not the userland FPSIMD state of the current task is
  * present in the registers. The flag is set unless the FPSIMD registers of this
  * CPU currently contain the most recent userland FPSIMD state of the current
- * task.
+ * task. If the task is behaving as a VMM, then this is will be managed by
+ * KVM which will clear it to indicate that the vcpu FPSIMD state is currently
+ * loaded on the CPU, allowing the state to be saved if a FPSIMD-aware
+ * softirq kicks in. Upon vcpu_put(), KVM will save the vcpu FP state and
+ * flag the register state as invalid.
  *
  * In order to allow softirq handlers to use FPSIMD, kernel_neon_begin() may
  * save the task's FPSIMD context back to task_struct from softirq context.
-- 
2.30.2

