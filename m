Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E48164328D8
	for <lists+kvm@lfdr.de>; Mon, 18 Oct 2021 23:12:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233389AbhJRVOZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Oct 2021 17:14:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:60790 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229674AbhJRVOX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Oct 2021 17:14:23 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C48116113D;
        Mon, 18 Oct 2021 21:12:11 +0000 (UTC)
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1mcZvW-0004Sc-1c; Mon, 18 Oct 2021 22:12:10 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc:     James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Quentin Perret <qperret@google.com>,
        Will Deacon <will@kernel.org>,
        Andrew Jones <drjones@redhat.com>, kernel-team@android.com
Subject: [PATCH v2 2/5] KVM: arm64: Move kvm_arch_vcpu_run_pid_change() out of line
Date:   Mon, 18 Oct 2021 22:11:55 +0100
Message-Id: <20211018211158.3050779-3-maz@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211018211158.3050779-1-maz@kernel.org>
References: <20211018211158.3050779-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, qperret@google.com, will@kernel.org, drjones@redhat.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Having kvm_arch_vcpu_run_pid_change() inline doesn't bring anything
to the table. Move it next to kvm_vcpu_first_run_init(), which will
be convenient for what is next to come.

Reviewed-by: Andrew Jones <drjones@redhat.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h | 7 +------
 arch/arm64/kvm/arm.c              | 5 +++++
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index f8be56d5342b..d7107d627c54 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -748,12 +748,7 @@ static inline bool kvm_pmu_counter_deferred(struct perf_event_attr *attr)
 void kvm_arch_vcpu_load_debug_state_flags(struct kvm_vcpu *vcpu);
 void kvm_arch_vcpu_put_debug_state_flags(struct kvm_vcpu *vcpu);
 
-#ifdef CONFIG_KVM /* Avoid conflicts with core headers if CONFIG_KVM=n */
-static inline int kvm_arch_vcpu_run_pid_change(struct kvm_vcpu *vcpu)
-{
-	return kvm_arch_vcpu_run_map_fp(vcpu);
-}
-
+#ifdef CONFIG_KVM
 void kvm_set_pmu_events(u32 set, struct perf_event_attr *attr);
 void kvm_clr_pmu_events(u32 clr);
 
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index fe102cd2e518..ccb59ac54976 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -583,6 +583,11 @@ static void update_vmid(struct kvm_vmid *vmid)
 	spin_unlock(&kvm_vmid_lock);
 }
 
+int kvm_arch_vcpu_run_pid_change(struct kvm_vcpu *vcpu)
+{
+	return kvm_arch_vcpu_run_map_fp(vcpu);
+}
+
 static int kvm_vcpu_first_run_init(struct kvm_vcpu *vcpu)
 {
 	struct kvm *kvm = vcpu->kvm;
-- 
2.30.2

