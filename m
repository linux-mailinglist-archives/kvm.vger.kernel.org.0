Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D45F421573
	for <lists+kvm@lfdr.de>; Mon,  4 Oct 2021 19:49:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233597AbhJDRvK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Oct 2021 13:51:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:32912 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235347AbhJDRu4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Oct 2021 13:50:56 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A3A0F61269;
        Mon,  4 Oct 2021 17:49:04 +0000 (UTC)
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1mXS5F-00EhBv-UP; Mon, 04 Oct 2021 18:49:01 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     will@kernel.org, qperret@google.com, dbrazdil@google.com,
        Steven Price <steven.price@arm.com>,
        Andrew Jones <drjones@redhat.com>,
        Fuad Tabba <tabba@google.com>,
        Srivatsa Vaddagiri <vatsa@codeaurora.org>,
        Shanker R Donthineni <sdonthineni@nvidia.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        kernel-team@android.com
Subject: [PATCH v2 08/16] KVM: arm64: Add tracepoint for failed MMIO guard check
Date:   Mon,  4 Oct 2021 18:48:41 +0100
Message-Id: <20211004174849.2831548-9-maz@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211004174849.2831548-1-maz@kernel.org>
References: <20211004174849.2831548-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, will@kernel.org, qperret@google.com, dbrazdil@google.com, steven.price@arm.com, drjones@redhat.com, tabba@google.com, vatsa@codeaurora.org, sdonthineni@nvidia.com, james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In order to make debugging easier, expose a new trace point
that triggers when a MMIO check fails.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/mmu.c       |  4 +++-
 arch/arm64/kvm/trace_arm.h | 17 +++++++++++++++++
 2 files changed, 20 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 2470a55ca675..8c38d856533f 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1275,8 +1275,10 @@ bool kvm_check_ioguard_page(struct kvm_vcpu *vcpu, gpa_t ipa)
 	ret = __check_ioguard_page(vcpu, ipa & PAGE_MASK);
 	spin_unlock(&vcpu->kvm->mmu_lock);
 
-	if (!ret)
+	if (!ret) {
+		trace_kvm_failed_mmio_check(*vcpu_pc(vcpu), ipa);
 		kvm_inject_dabt(vcpu, kvm_vcpu_get_hfar(vcpu));
+	}
 
 	return ret;
 }
diff --git a/arch/arm64/kvm/trace_arm.h b/arch/arm64/kvm/trace_arm.h
index 33e4e7dd2719..e40cfeb251ad 100644
--- a/arch/arm64/kvm/trace_arm.h
+++ b/arch/arm64/kvm/trace_arm.h
@@ -89,6 +89,23 @@ TRACE_EVENT(kvm_access_fault,
 	TP_printk("IPA: %lx", __entry->ipa)
 );
 
+TRACE_EVENT(kvm_failed_mmio_check,
+	TP_PROTO(unsigned long vcpu_pc, unsigned long ipa),
+	TP_ARGS(vcpu_pc, ipa),
+
+	TP_STRUCT__entry(
+		__field(	unsigned long,	vcpu_pc		)
+		__field(	unsigned long,	ipa		)
+	),
+
+	TP_fast_assign(
+		__entry->vcpu_pc	= vcpu_pc;
+		__entry->ipa		= ipa;
+	),
+
+	TP_printk("PC: %lx IPA: %lx", __entry->vcpu_pc, __entry->ipa)
+);
+
 TRACE_EVENT(kvm_irq_line,
 	TP_PROTO(unsigned int type, int vcpu_idx, int irq_num, int level),
 	TP_ARGS(type, vcpu_idx, irq_num, level),
-- 
2.30.2

