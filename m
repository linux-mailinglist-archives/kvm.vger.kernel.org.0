Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF26E4328DA
	for <lists+kvm@lfdr.de>; Mon, 18 Oct 2021 23:12:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233726AbhJRVO0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Oct 2021 17:14:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:60808 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232209AbhJRVOX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Oct 2021 17:14:23 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 51656610A2;
        Mon, 18 Oct 2021 21:12:12 +0000 (UTC)
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1mcZvW-0004Sc-Ik; Mon, 18 Oct 2021 22:12:10 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc:     James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Quentin Perret <qperret@google.com>,
        Will Deacon <will@kernel.org>,
        Andrew Jones <drjones@redhat.com>, kernel-team@android.com
Subject: [PATCH v2 4/5] KVM: arm64: Merge kvm_arch_vcpu_run_pid_change() and kvm_vcpu_first_run_init()
Date:   Mon, 18 Oct 2021 22:11:57 +0100
Message-Id: <20211018211158.3050779-5-maz@kernel.org>
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

The kvm_arch_vcpu_run_pid_change() helper gets called on each PID
change. The kvm_vcpu_first_run_init() helper gets run on the...
first run(!) of a vcpu.

As it turns out, the first run of a vcpu also triggers a PID change
event (vcpu->pid is initially NULL).

Use this property to merge these two helpers and get rid of another
arm64-specific oddity.

Reviewed-by: Andrew Jones <drjones@redhat.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/arm.c | 36 ++++++++++++++++++------------------
 1 file changed, 18 insertions(+), 18 deletions(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 42efca9853fb..a52f6a76485d 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -583,22 +583,34 @@ static void update_vmid(struct kvm_vmid *vmid)
 	spin_unlock(&kvm_vmid_lock);
 }
 
-int kvm_arch_vcpu_run_pid_change(struct kvm_vcpu *vcpu)
+static int kvm_vcpu_initialized(struct kvm_vcpu *vcpu)
 {
-	return kvm_arch_vcpu_run_map_fp(vcpu);
+	return vcpu->arch.target >= 0;
 }
 
-static int kvm_vcpu_first_run_init(struct kvm_vcpu *vcpu)
+/*
+ * Handle both the initialisation that is being done when the vcpu is
+ * run for the first time, as well as the updates that must be
+ * performed each time we get a new thread dealing with this vcpu.
+ */
+int kvm_arch_vcpu_run_pid_change(struct kvm_vcpu *vcpu)
 {
 	struct kvm *kvm = vcpu->kvm;
-	int ret = 0;
+	int ret;
 
-	if (likely(vcpu->arch.has_run_once))
-		return 0;
+	if (!kvm_vcpu_initialized(vcpu))
+		return -ENOEXEC;
 
 	if (!kvm_arm_vcpu_is_finalized(vcpu))
 		return -EPERM;
 
+	ret = kvm_arch_vcpu_run_map_fp(vcpu);
+	if (ret)
+		return ret;
+
+	if (likely(vcpu->arch.has_run_once))
+		return 0;
+
 	kvm_arm_vcpu_init_debug(vcpu);
 
 	if (likely(irqchip_in_kernel(kvm))) {
@@ -679,11 +691,6 @@ static void vcpu_req_sleep(struct kvm_vcpu *vcpu)
 	smp_rmb();
 }
 
-static int kvm_vcpu_initialized(struct kvm_vcpu *vcpu)
-{
-	return vcpu->arch.target >= 0;
-}
-
 static void check_vcpu_requests(struct kvm_vcpu *vcpu)
 {
 	if (kvm_request_pending(vcpu)) {
@@ -779,13 +786,6 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 	struct kvm_run *run = vcpu->run;
 	int ret;
 
-	if (unlikely(!kvm_vcpu_initialized(vcpu)))
-		return -ENOEXEC;
-
-	ret = kvm_vcpu_first_run_init(vcpu);
-	if (ret)
-		return ret;
-
 	if (run->exit_reason == KVM_EXIT_MMIO) {
 		ret = kvm_handle_mmio_return(vcpu);
 		if (ret)
-- 
2.30.2

