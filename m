Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BAEF4328D6
	for <lists+kvm@lfdr.de>; Mon, 18 Oct 2021 23:12:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232272AbhJRVOX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Oct 2021 17:14:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:60764 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229554AbhJRVOX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Oct 2021 17:14:23 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A119E60462;
        Mon, 18 Oct 2021 21:12:11 +0000 (UTC)
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1mcZvV-0004Sc-PQ; Mon, 18 Oct 2021 22:12:09 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc:     James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Quentin Perret <qperret@google.com>,
        Will Deacon <will@kernel.org>,
        Andrew Jones <drjones@redhat.com>, kernel-team@android.com
Subject: [PATCH v2 1/5] KVM: arm64: Move SVE state mapping at HYP to finalize-time
Date:   Mon, 18 Oct 2021 22:11:54 +0100
Message-Id: <20211018211158.3050779-2-maz@kernel.org>
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

We currently map the SVE state to HYP on detection of a PID change.
Although this matches what we do for FPSIMD, this is pretty pointless
for SVE, as the buffer is per-vcpu and has nothing to do with the
thread that is being run.

Move the mapping of the SVE state to finalize-time, which is where
we allocate the state memory, and thus the most logical place to
do this.

Reviewed-by: Andrew Jones <drjones@redhat.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/fpsimd.c | 11 -----------
 arch/arm64/kvm/reset.c  | 11 ++++++++++-
 2 files changed, 10 insertions(+), 12 deletions(-)

diff --git a/arch/arm64/kvm/fpsimd.c b/arch/arm64/kvm/fpsimd.c
index 5621020b28de..62c0d78da7be 100644
--- a/arch/arm64/kvm/fpsimd.c
+++ b/arch/arm64/kvm/fpsimd.c
@@ -43,17 +43,6 @@ int kvm_arch_vcpu_run_map_fp(struct kvm_vcpu *vcpu)
 	if (ret)
 		goto error;
 
-	if (vcpu->arch.sve_state) {
-		void *sve_end;
-
-		sve_end = vcpu->arch.sve_state + vcpu_sve_state_size(vcpu);
-
-		ret = create_hyp_mappings(vcpu->arch.sve_state, sve_end,
-					  PAGE_HYP);
-		if (ret)
-			goto error;
-	}
-
 	vcpu->arch.host_thread_info = kern_hyp_va(ti);
 	vcpu->arch.host_fpsimd_state = kern_hyp_va(fpsimd);
 error:
diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
index 5ce36b0a3343..9e904a9244c1 100644
--- a/arch/arm64/kvm/reset.c
+++ b/arch/arm64/kvm/reset.c
@@ -94,6 +94,8 @@ static int kvm_vcpu_finalize_sve(struct kvm_vcpu *vcpu)
 {
 	void *buf;
 	unsigned int vl;
+	size_t reg_sz;
+	int ret;
 
 	vl = vcpu->arch.sve_max_vl;
 
@@ -106,10 +108,17 @@ static int kvm_vcpu_finalize_sve(struct kvm_vcpu *vcpu)
 		    vl > SVE_VL_ARCH_MAX))
 		return -EIO;
 
-	buf = kzalloc(SVE_SIG_REGS_SIZE(sve_vq_from_vl(vl)), GFP_KERNEL);
+	reg_sz = vcpu_sve_state_size(vcpu);
+	buf = kzalloc(reg_sz, GFP_KERNEL);
 	if (!buf)
 		return -ENOMEM;
 
+	ret = create_hyp_mappings(buf, buf + reg_sz, PAGE_HYP);
+	if (ret) {
+		kfree(buf);
+		return ret;
+	}
+	
 	vcpu->arch.sve_state = buf;
 	vcpu->arch.flags |= KVM_ARM64_VCPU_SVE_FINALIZED;
 	return 0;
-- 
2.30.2

