Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A92CE42BFED
	for <lists+kvm@lfdr.de>; Wed, 13 Oct 2021 14:26:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233226AbhJMM25 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Oct 2021 08:28:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:35440 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233251AbhJMM2x (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Oct 2021 08:28:53 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B990161151;
        Wed, 13 Oct 2021 12:26:50 +0000 (UTC)
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1maczJ-00GTgY-EP; Wed, 13 Oct 2021 13:04:01 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc:     will@kernel.org, james.morse@arm.com, alexandru.elisei@arm.com,
        suzuki.poulose@arm.com, mark.rutland@arm.com, pbonzini@redhat.com,
        drjones@redhat.com, oupton@google.com, qperret@google.com,
        kernel-team@android.com, tabba@google.com
Subject: [PATCH v9 22/22] KVM: arm64: pkvm: Give priority to standard traps over pvm handling
Date:   Wed, 13 Oct 2021 13:03:46 +0100
Message-Id: <20211013120346.2926621-12-maz@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211013120346.2926621-1-maz@kernel.org>
References: <20211010145636.1950948-12-tabba@google.com>
 <20211013120346.2926621-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, will@kernel.org, james.morse@arm.com, alexandru.elisei@arm.com, suzuki.poulose@arm.com, mark.rutland@arm.com, pbonzini@redhat.com, drjones@redhat.com, oupton@google.com, qperret@google.com, kernel-team@android.com, tabba@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Checking for pvm handling first means that we cannot handle ptrauth
traps or apply any of the workarounds (GICv3 or TX2 #219).

Flip the order around.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/hyp/nvhe/switch.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
index 50c7d48e0fa0..c0e3fed26d93 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -167,10 +167,13 @@ static void __pmu_switch_to_host(struct kvm_cpu_context *host_ctxt)
  */
 static bool kvm_handle_pvm_sys64(struct kvm_vcpu *vcpu, u64 *exit_code)
 {
-	if (kvm_handle_pvm_sysreg(vcpu, exit_code))
-		return true;
-
-	return kvm_hyp_handle_sysreg(vcpu, exit_code);
+	/*
+	 * Make sure we handle the exit for workarounds and ptrauth
+	 * before the pKVM handling, as the latter could decide to
+	 * UNDEF.
+	 */
+	return (kvm_hyp_handle_sysreg(vcpu, exit_code) ||
+		kvm_handle_pvm_sysreg(vcpu, exit_code));
 }
 
 /**
-- 
2.30.2

