Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC8522ECF0D
	for <lists+kvm@lfdr.de>; Thu,  7 Jan 2021 12:51:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727954AbhAGLuk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Jan 2021 06:50:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:39252 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727871AbhAGLuk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Jan 2021 06:50:40 -0500
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3178C2333E;
        Thu,  7 Jan 2021 11:49:59 +0000 (UTC)
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94)
        (envelope-from <maz@kernel.org>)
        id 1kxTM8-005p1o-9V; Thu, 07 Jan 2021 11:21:28 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        David Brazdil <dbrazdil@google.com>,
        Eric Auger <eric.auger@redhat.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Qian Cai <qcai@redhat.com>,
        Shannon Zhao <shannon.zhao@linux.alibaba.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        kernel-team@android.com, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH 14/18] KVM: arm64: Consolidate dist->ready setting into kvm_vgic_map_resources()
Date:   Thu,  7 Jan 2021 11:20:57 +0000
Message-Id: <20210107112101.2297944-15-maz@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210107112101.2297944-1-maz@kernel.org>
References: <20210107112101.2297944-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, alexandru.elisei@arm.com, catalin.marinas@arm.com, dbrazdil@google.com, eric.auger@redhat.com, mark.rutland@arm.com, natechancellor@gmail.com, qcai@redhat.com, shannon.zhao@linux.alibaba.com, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, kernel-team@android.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

dist->ready setting is pointlessly spread across the two vgic
backends, while it could be consolidated in kvm_vgic_map_resources().

Move it there, and slightly simplify the flows in both backends.

Suggested-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/vgic/vgic-init.c |  2 ++
 arch/arm64/kvm/vgic/vgic-v2.c   | 17 ++++++-----------
 arch/arm64/kvm/vgic/vgic-v3.c   | 18 ++++++------------
 3 files changed, 14 insertions(+), 23 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-init.c
index 5b54787a9ad5..052917deb149 100644
--- a/arch/arm64/kvm/vgic/vgic-init.c
+++ b/arch/arm64/kvm/vgic/vgic-init.c
@@ -446,6 +446,8 @@ int kvm_vgic_map_resources(struct kvm *kvm)
 
 	if (ret)
 		__kvm_vgic_destroy(kvm);
+	else
+		dist->ready = true;
 
 out:
 	mutex_unlock(&kvm->lock);
diff --git a/arch/arm64/kvm/vgic/vgic-v2.c b/arch/arm64/kvm/vgic/vgic-v2.c
index 7f38c1a93639..11934c2af2f4 100644
--- a/arch/arm64/kvm/vgic/vgic-v2.c
+++ b/arch/arm64/kvm/vgic/vgic-v2.c
@@ -309,14 +309,12 @@ int vgic_v2_map_resources(struct kvm *kvm)
 	if (IS_VGIC_ADDR_UNDEF(dist->vgic_dist_base) ||
 	    IS_VGIC_ADDR_UNDEF(dist->vgic_cpu_base)) {
 		kvm_err("Need to set vgic cpu and dist addresses first\n");
-		ret = -ENXIO;
-		goto out;
+		return -ENXIO;
 	}
 
 	if (!vgic_v2_check_base(dist->vgic_dist_base, dist->vgic_cpu_base)) {
 		kvm_err("VGIC CPU and dist frames overlap\n");
-		ret = -EINVAL;
-		goto out;
+		return -EINVAL;
 	}
 
 	/*
@@ -326,13 +324,13 @@ int vgic_v2_map_resources(struct kvm *kvm)
 	ret = vgic_init(kvm);
 	if (ret) {
 		kvm_err("Unable to initialize VGIC dynamic data structures\n");
-		goto out;
+		return ret;
 	}
 
 	ret = vgic_register_dist_iodev(kvm, dist->vgic_dist_base, VGIC_V2);
 	if (ret) {
 		kvm_err("Unable to register VGIC MMIO regions\n");
-		goto out;
+		return ret;
 	}
 
 	if (!static_branch_unlikely(&vgic_v2_cpuif_trap)) {
@@ -341,14 +339,11 @@ int vgic_v2_map_resources(struct kvm *kvm)
 					    KVM_VGIC_V2_CPU_SIZE, true);
 		if (ret) {
 			kvm_err("Unable to remap VGIC CPU to VCPU\n");
-			goto out;
+			return ret;
 		}
 	}
 
-	dist->ready = true;
-
-out:
-	return ret;
+	return 0;
 }
 
 DEFINE_STATIC_KEY_FALSE(vgic_v2_cpuif_trap);
diff --git a/arch/arm64/kvm/vgic/vgic-v3.c b/arch/arm64/kvm/vgic/vgic-v3.c
index 35029c5cb0f1..52915b342351 100644
--- a/arch/arm64/kvm/vgic/vgic-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-v3.c
@@ -505,21 +505,18 @@ int vgic_v3_map_resources(struct kvm *kvm)
 
 		if (IS_VGIC_ADDR_UNDEF(vgic_cpu->rd_iodev.base_addr)) {
 			kvm_debug("vcpu %d redistributor base not set\n", c);
-			ret = -ENXIO;
-			goto out;
+			return -ENXIO;
 		}
 	}
 
 	if (IS_VGIC_ADDR_UNDEF(dist->vgic_dist_base)) {
 		kvm_err("Need to set vgic distributor addresses first\n");
-		ret = -ENXIO;
-		goto out;
+		return -ENXIO;
 	}
 
 	if (!vgic_v3_check_base(kvm)) {
 		kvm_err("VGIC redist and dist frames overlap\n");
-		ret = -EINVAL;
-		goto out;
+		return -EINVAL;
 	}
 
 	/*
@@ -527,22 +524,19 @@ int vgic_v3_map_resources(struct kvm *kvm)
 	 * the VGIC before we need to use it.
 	 */
 	if (!vgic_initialized(kvm)) {
-		ret = -EBUSY;
-		goto out;
+		return -EBUSY;
 	}
 
 	ret = vgic_register_dist_iodev(kvm, dist->vgic_dist_base, VGIC_V3);
 	if (ret) {
 		kvm_err("Unable to register VGICv3 dist MMIO regions\n");
-		goto out;
+		return ret;
 	}
 
 	if (kvm_vgic_global_state.has_gicv4_1)
 		vgic_v4_configure_vsgis(kvm);
-	dist->ready = true;
 
-out:
-	return ret;
+	return 0;
 }
 
 DEFINE_STATIC_KEY_FALSE(vgic_v3_cpuif_trap);
-- 
2.29.2

