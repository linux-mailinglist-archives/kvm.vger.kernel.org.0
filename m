Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 244A520E39F
	for <lists+kvm@lfdr.de>; Tue, 30 Jun 2020 00:03:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390677AbgF2VP6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Jun 2020 17:15:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:42430 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729954AbgF2SzQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 Jun 2020 14:55:16 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5CDE125595;
        Mon, 29 Jun 2020 16:25:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593447935;
        bh=y9/mharb+W/Wo8t1uox6jiNNY7oYrYExuo1ibLqnBrI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yRxh8t3va+r0SZYY70IM+SupCD7KWJrc4Fh2FeUL/H8WeeyAbNSt6OvibEVWU1PZs
         1+OLP7dQQUHaABxzN6djmfymJNXZ3571UX26nWjeTZtcBL4Orcwl9eqSMHtAmDOF3X
         vtqNYqlW/JjXDeNy1dRZTYHhfnPSzzUbIyNd6t0M=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1jpwb7-007M5T-Uj; Mon, 29 Jun 2020 17:25:34 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>,
        Andrew Jones <drjones@redhat.com>,
        James Morse <james.morse@arm.com>,
        Steven Price <steven.price@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        kernel-team@android.com, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Subject: [PATCH 3/4] KVM: arm64: pvtime: Ensure task delay accounting is enabled
Date:   Mon, 29 Jun 2020 17:25:18 +0100
Message-Id: <20200629162519.825200-4-maz@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200629162519.825200-1-maz@kernel.org>
References: <20200629162519.825200-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, alexandru.elisei@arm.com, drjones@redhat.com, james.morse@arm.com, steven.price@arm.com, yuzenghui@huawei.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, kernel-team@android.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Andrew Jones <drjones@redhat.com>

Ensure we're actually accounting run_delay before we claim that we'll
expose it to the guest. If we're not, then we just pretend like steal
time isn't supported in order to avoid any confusion.

Signed-off-by: Andrew Jones <drjones@redhat.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20200622142710.18677-1-drjones@redhat.com
---
 arch/arm64/kvm/pvtime.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/pvtime.c b/arch/arm64/kvm/pvtime.c
index 1e0f4c284888..f7b52ce1557e 100644
--- a/arch/arm64/kvm/pvtime.c
+++ b/arch/arm64/kvm/pvtime.c
@@ -3,6 +3,7 @@
 
 #include <linux/arm-smccc.h>
 #include <linux/kvm_host.h>
+#include <linux/sched/stat.h>
 
 #include <asm/kvm_mmu.h>
 #include <asm/pvclock-abi.h>
@@ -73,6 +74,11 @@ gpa_t kvm_init_stolen_time(struct kvm_vcpu *vcpu)
 	return base;
 }
 
+static bool kvm_arm_pvtime_supported(void)
+{
+	return !!sched_info_on();
+}
+
 int kvm_arm_pvtime_set_attr(struct kvm_vcpu *vcpu,
 			    struct kvm_device_attr *attr)
 {
@@ -82,7 +88,8 @@ int kvm_arm_pvtime_set_attr(struct kvm_vcpu *vcpu,
 	int ret = 0;
 	int idx;
 
-	if (attr->attr != KVM_ARM_VCPU_PVTIME_IPA)
+	if (!kvm_arm_pvtime_supported() ||
+	    attr->attr != KVM_ARM_VCPU_PVTIME_IPA)
 		return -ENXIO;
 
 	if (get_user(ipa, user))
@@ -110,7 +117,8 @@ int kvm_arm_pvtime_get_attr(struct kvm_vcpu *vcpu,
 	u64 __user *user = (u64 __user *)attr->addr;
 	u64 ipa;
 
-	if (attr->attr != KVM_ARM_VCPU_PVTIME_IPA)
+	if (!kvm_arm_pvtime_supported() ||
+	    attr->attr != KVM_ARM_VCPU_PVTIME_IPA)
 		return -ENXIO;
 
 	ipa = vcpu->arch.steal.base;
@@ -125,7 +133,8 @@ int kvm_arm_pvtime_has_attr(struct kvm_vcpu *vcpu,
 {
 	switch (attr->attr) {
 	case KVM_ARM_VCPU_PVTIME_IPA:
-		return 0;
+		if (kvm_arm_pvtime_supported())
+			return 0;
 	}
 	return -ENXIO;
 }
-- 
2.27.0

