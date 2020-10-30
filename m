Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 857AF2A0BD3
	for <lists+kvm@lfdr.de>; Fri, 30 Oct 2020 17:55:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726858AbgJ3QzW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Oct 2020 12:55:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:60446 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725808AbgJ3QzW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Oct 2020 12:55:22 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3AC752075E;
        Fri, 30 Oct 2020 16:55:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604076921;
        bh=DmlbkjwNIPgqQskMs4fVUuPst6u3+Yia7p5E2TwkbcU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EaAm8a0X+JSoUeByUK2bKd7zye7fMRJt+t0J+IhUg2LEZlfa0JHQIlSXMBXUR0IDl
         WJIqbK0PD70dD5wqfeqWwtRen88F3X3yGfcsRb+nQiNniNLn4cN+yBiijUb9ilY04M
         jMg4u4tCLOLAhvF0T+XvoKNcqY9kvYHAijfHT4kQ=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94)
        (envelope-from <maz@kernel.org>)
        id 1kYXS4-005noK-5X; Fri, 30 Oct 2020 16:40:32 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     David Brazdil <dbrazdil@google.com>, Gavin Shan <gshan@redhat.com>,
        James Morse <james.morse@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Qais Yousef <qais.yousef@arm.com>,
        Quentin Perret <qperret@google.com>,
        Santosh Shukla <sashukla@nvidia.com>,
        Vladimir Murzin <vladimir.murzin@arm.com>,
        Will Deacon <will@kernel.org>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        kernel-team@android.com, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH 12/12] KVM: arm64: Handle Asymmetric AArch32 systems
Date:   Fri, 30 Oct 2020 16:40:17 +0000
Message-Id: <20201030164017.244287-13-maz@kernel.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201030164017.244287-1-maz@kernel.org>
References: <20201030164017.244287-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, dbrazdil@google.com, gshan@redhat.com, james.morse@arm.com, mark.rutland@arm.com, qais.yousef@arm.com, qperret@google.com, sashukla@nvidia.com, vladimir.murzin@arm.com, will@kernel.org, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, kernel-team@android.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Qais Yousef <qais.yousef@arm.com>

On a system without uniform support for AArch32 at EL0, it is possible
for the guest to force run AArch32 at EL0 and potentially cause an
illegal exception if running on a core without AArch32. Add an extra
check so that if we catch the guest doing that, then we prevent it from
running again by resetting vcpu->arch.target and return
ARM_EXCEPTION_IL.

We try to catch this misbehaviour as early as possible and not rely on
an illegal exception occuring to signal the problem. Attempting to run a
32bit app in the guest will produce an error from QEMU if the guest
exits while running in AArch32 EL0.

Tested on Juno by instrumenting the host to fake asym aarch32 and
instrumenting KVM to make the asymmetry visible to the guest.

[will: Incorporated feedback from Marc]

Signed-off-by: Qais Yousef <qais.yousef@arm.com>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Cc: James Morse <james.morse@arm.com>
Cc: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20201021104611.2744565-2-qais.yousef@arm.com
Link: https://lore.kernel.org/r/20201027215118.27003-2-will@kernel.org
---
 arch/arm64/kvm/arm.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index f56122eedffc..a3b32df1afb0 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -808,6 +808,25 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 
 		preempt_enable();
 
+		/*
+		 * The ARMv8 architecture doesn't give the hypervisor
+		 * a mechanism to prevent a guest from dropping to AArch32 EL0
+		 * if implemented by the CPU. If we spot the guest in such
+		 * state and that we decided it wasn't supposed to do so (like
+		 * with the asymmetric AArch32 case), return to userspace with
+		 * a fatal error.
+		 */
+		if (!system_supports_32bit_el0() && vcpu_mode_is_32bit(vcpu)) {
+			/*
+			 * As we have caught the guest red-handed, decide that
+			 * it isn't fit for purpose anymore by making the vcpu
+			 * invalid. The VMM can try and fix it by issuing  a
+			 * KVM_ARM_VCPU_INIT if it really wants to.
+			 */
+			vcpu->arch.target = -1;
+			ret = ARM_EXCEPTION_IL;
+		}
+
 		ret = handle_exit(vcpu, ret);
 	}
 
-- 
2.28.0

