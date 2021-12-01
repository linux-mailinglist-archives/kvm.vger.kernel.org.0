Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65EDD464D79
	for <lists+kvm@lfdr.de>; Wed,  1 Dec 2021 13:04:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349155AbhLAMIL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Dec 2021 07:08:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349149AbhLAMII (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Dec 2021 07:08:08 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 787C6C061574
        for <kvm@vger.kernel.org>; Wed,  1 Dec 2021 04:04:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 31F01B81E6E
        for <kvm@vger.kernel.org>; Wed,  1 Dec 2021 12:04:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F902C5831C;
        Wed,  1 Dec 2021 12:04:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638360284;
        bh=Xuvuq9xi1oPynnpJ9g9P6Pu8AvZApVB57E9AL6qkFRE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Vy1aSaBNEckUVzBM6A432jEfW/PSv8WXY+TE2K3qg+IuuE5e2nmufbEyqmTEr+XKX
         8+2AuNoaPqW9tm9iY94+rs6T3AzkHHbqU7p1SfR+AxIddwWfIiWZspFA25IjDOq1EH
         PIDy5Lu2EF5BdbF1r9rT8lOwBY1frOvUXXxOIYXRgoqlO9z+S6Yolr+whsUk1/xJcX
         MvFxoryjWxD/PVpftDkDQVmNln7jXbYuUYBx0adIt50N16BslIIHNQKgw6hsYicks3
         u+cjLF8/F3jufKihdk2QKGCbqpvhhk+r3NoLcj9PU3t38/dFLg1IPrs1oKxalxU/HW
         ZBcH57jzp6xrA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1msOLq-0097Ab-Ax; Wed, 01 Dec 2021 12:04:42 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc:     James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Quentin Perret <qperret@google.com>,
        Will Deacon <will@kernel.org>, broonie@kernel.org,
        Zenghui Yu <yuzenghui@huawei.com>, kernel-team@android.com
Subject: [PATCH v3 5/6] KVM: arm64: Stop mapping current thread_info at EL2
Date:   Wed,  1 Dec 2021 12:04:35 +0000
Message-Id: <20211201120436.389756-6-maz@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211201120436.389756-1-maz@kernel.org>
References: <20211201120436.389756-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, qperret@google.com, will@kernel.org, broonie@kernel.org, yuzenghui@huawei.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Now that we can track an equivalent of TIF_FOREIGN_FPSTATE, drop
the mapping of current's thread_info at EL2.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h       |  2 --
 arch/arm64/kvm/fpsimd.c                 | 12 +-----------
 arch/arm64/kvm/hyp/include/hyp/switch.h |  1 -
 arch/arm64/kvm/hyp/nvhe/switch.c        |  1 -
 arch/arm64/kvm/hyp/vhe/switch.c         |  1 -
 5 files changed, 1 insertion(+), 16 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 9f1703ebae15..dd5810ea37a9 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -26,7 +26,6 @@
 #include <asm/fpsimd.h>
 #include <asm/kvm.h>
 #include <asm/kvm_asm.h>
-#include <asm/thread_info.h>
 
 #define __KVM_HAVE_ARCH_INTC_INITIALIZED
 
@@ -321,7 +320,6 @@ struct kvm_vcpu_arch {
 	struct kvm_guest_debug_arch vcpu_debug_state;
 	struct kvm_guest_debug_arch external_debug_state;
 
-	struct thread_info *host_thread_info;	/* hyp VA */
 	struct user_fpsimd_state *host_fpsimd_state;	/* hyp VA */
 
 	struct {
diff --git a/arch/arm64/kvm/fpsimd.c b/arch/arm64/kvm/fpsimd.c
index a18b9c1744d5..b5b59b9f2eff 100644
--- a/arch/arm64/kvm/fpsimd.c
+++ b/arch/arm64/kvm/fpsimd.c
@@ -7,7 +7,6 @@
  */
 #include <linux/irqflags.h>
 #include <linux/sched.h>
-#include <linux/thread_info.h>
 #include <linux/kvm_host.h>
 #include <asm/fpsimd.h>
 #include <asm/kvm_asm.h>
@@ -28,17 +27,9 @@ int kvm_arch_vcpu_run_map_fp(struct kvm_vcpu *vcpu)
 {
 	int ret;
 
-	struct thread_info *ti = &current->thread_info;
 	struct user_fpsimd_state *fpsimd = &current->thread.uw.fpsimd_state;
 
-	/*
-	 * Make sure the host task thread flags and fpsimd state are
-	 * visible to hyp:
-	 */
-	ret = create_hyp_mappings(ti, ti + 1, PAGE_HYP);
-	if (ret)
-		goto error;
-
+	/* Make sure the host task fpsimd state is visible to hyp: */
 	ret = create_hyp_mappings(fpsimd, fpsimd + 1, PAGE_HYP);
 	if (ret)
 		goto error;
@@ -54,7 +45,6 @@ int kvm_arch_vcpu_run_map_fp(struct kvm_vcpu *vcpu)
 			goto error;
 	}
 
-	vcpu->arch.host_thread_info = kern_hyp_va(ti);
 	vcpu->arch.host_fpsimd_state = kern_hyp_va(fpsimd);
 error:
 	return ret;
diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index a243a2a82131..11e8580f2fdc 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -29,7 +29,6 @@
 #include <asm/fpsimd.h>
 #include <asm/debug-monitors.h>
 #include <asm/processor.h>
-#include <asm/thread_info.h>
 
 struct kvm_exception_table_entry {
 	int insn, fixup;
diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
index c0e3fed26d93..329c706af39f 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -25,7 +25,6 @@
 #include <asm/fpsimd.h>
 #include <asm/debug-monitors.h>
 #include <asm/processor.h>
-#include <asm/thread_info.h>
 
 #include <nvhe/fixed_config.h>
 #include <nvhe/mem_protect.h>
diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
index 5a2cb5d9bc4b..1d162b9c78bf 100644
--- a/arch/arm64/kvm/hyp/vhe/switch.c
+++ b/arch/arm64/kvm/hyp/vhe/switch.c
@@ -24,7 +24,6 @@
 #include <asm/fpsimd.h>
 #include <asm/debug-monitors.h>
 #include <asm/processor.h>
-#include <asm/thread_info.h>
 
 /* VHE specific context */
 DEFINE_PER_CPU(struct kvm_host_data, kvm_host_data);
-- 
2.30.2

