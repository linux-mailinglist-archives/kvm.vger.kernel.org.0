Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 676A342ED3D
	for <lists+kvm@lfdr.de>; Fri, 15 Oct 2021 11:10:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236929AbhJOJMX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Oct 2021 05:12:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:59138 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236279AbhJOJMU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Oct 2021 05:12:20 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D2FD861208;
        Fri, 15 Oct 2021 09:10:14 +0000 (UTC)
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1mbJED-00GvHX-4o; Fri, 15 Oct 2021 10:10:13 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc:     James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Quentin Perret <qperret@google.com>,
        Will Deacon <will@kernel.org>, kernel-team@android.com
Subject: [PATCH 3/5] KVM: arm64: Merge kvm_arch_vcpu_run_pid_change() and kvm_vcpu_first_run_init()
Date:   Fri, 15 Oct 2021 10:08:20 +0100
Message-Id: <20211015090822.2994920-4-maz@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211015090822.2994920-1-maz@kernel.org>
References: <20211015090822.2994920-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, qperret@google.com, will@kernel.org, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The kvm_arch_vcpu_run_pid_change() helper gets called on each PID
change. The kvm_vcpu_first_run_init() helper gets run on the...
first run(!) of a vcpu.

As it turns out, the first run of a vcpu also triggers a PID change
event (vcpu->pid is initially NULL).

Use this property to merge these two helpers and get rid of another
arm64-specific oddity.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/arm.c | 26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index ccb59ac54976..30692497c4ea 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -583,22 +583,26 @@ static void update_vmid(struct kvm_vmid *vmid)
 	spin_unlock(&kvm_vmid_lock);
 }
 
+/*
+ * Handle both the initialisation that is being done when the vcpu is
+ * run for the first time, as well as the updates that must be
+ * performed each time we get a new thread dealing with this vcpu.
+ */
 int kvm_arch_vcpu_run_pid_change(struct kvm_vcpu *vcpu)
-{
-	return kvm_arch_vcpu_run_map_fp(vcpu);
-}
-
-static int kvm_vcpu_first_run_init(struct kvm_vcpu *vcpu)
 {
 	struct kvm *kvm = vcpu->kvm;
-	int ret = 0;
-
-	if (likely(vcpu->arch.has_run_once))
-		return 0;
+	int ret;
 
 	if (!kvm_arm_vcpu_is_finalized(vcpu))
 		return -EPERM;
 
+	ret = kvm_arch_vcpu_run_map_fp(vcpu);
+	if (ret)
+		return ret;
+
+	if (likely(vcpu->arch.has_run_once))
+		return 0;
+
 	vcpu->arch.has_run_once = true;
 
 	kvm_arm_vcpu_init_debug(vcpu);
@@ -778,10 +782,6 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 	if (unlikely(!kvm_vcpu_initialized(vcpu)))
 		return -ENOEXEC;
 
-	ret = kvm_vcpu_first_run_init(vcpu);
-	if (ret)
-		return ret;
-
 	if (run->exit_reason == KVM_EXIT_MMIO) {
 		ret = kvm_handle_mmio_return(vcpu);
 		if (ret)
-- 
2.30.2

