Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BBA642BF78
	for <lists+kvm@lfdr.de>; Wed, 13 Oct 2021 14:04:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233108AbhJMMGJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Oct 2021 08:06:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:56376 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232677AbhJMMGE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Oct 2021 08:06:04 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DE89D610C9;
        Wed, 13 Oct 2021 12:04:01 +0000 (UTC)
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1maczI-00GTgY-3K; Wed, 13 Oct 2021 13:04:00 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc:     will@kernel.org, james.morse@arm.com, alexandru.elisei@arm.com,
        suzuki.poulose@arm.com, mark.rutland@arm.com, pbonzini@redhat.com,
        drjones@redhat.com, oupton@google.com, qperret@google.com,
        kernel-team@android.com, tabba@google.com
Subject: [PATCH v9 18/22] KVM: arm64: pkvm: Preserve pending SError on exit from AArch32
Date:   Wed, 13 Oct 2021 13:03:42 +0100
Message-Id: <20211013120346.2926621-8-maz@kernel.org>
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

Don't drop a potential SError when a guest gets caught red-handed
running AArch32 code.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/hyp/nvhe/switch.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
index f25b6353a598..481c365ef144 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -256,7 +256,8 @@ static bool handle_aarch32_guest(struct kvm_vcpu *vcpu, u64 *exit_code)
 		 * protected VMs.
 		 */
 		vcpu->arch.target = -1;
-		*exit_code = ARM_EXCEPTION_IL;
+		*exit_code &= BIT(ARM_EXIT_WITH_SERROR_BIT);
+		*exit_code |= ARM_EXCEPTION_IL;
 		return false;
 	}
 
-- 
2.30.2

