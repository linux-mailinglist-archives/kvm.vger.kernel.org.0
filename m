Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B014712FD5
	for <lists+kvm@lfdr.de>; Sat, 27 May 2023 00:17:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244371AbjEZWRr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 May 2023 18:17:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244414AbjEZWRm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 May 2023 18:17:42 -0400
Received: from out-36.mta0.migadu.com (out-36.mta0.migadu.com [IPv6:2001:41d0:1004:224b::24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50529E4A
        for <kvm@vger.kernel.org>; Fri, 26 May 2023 15:17:40 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1685139458;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MU2M1ZiX5q0ate1WNsMicGGyt4l+oxVKOB4rPZVtPdc=;
        b=o2nk8FiBcSon0KJRIx4Tf2UelcNYGYlN+6lPzDozMRPqEveNF49s5Iu3k5DbTBZbP0U1Lh
        cMU4d8zMUCJE81/N4x5xhM7nnT6AwySoTgwrkvs1gIS2Dr/joUIFt0PAjDBb+GG3yFG7pp
        taNWQkaMOFyKXpNyAvbe53Rfayvpz0E=
From:   Oliver Upton <oliver.upton@linux.dev>
To:     kvmarm@lists.linux.dev
Cc:     kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Will Deacon <will@kernel.org>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH kvmtool 08/21] arm: Add support for resetting a vCPU
Date:   Fri, 26 May 2023 22:16:59 +0000
Message-ID: <20230526221712.317287-9-oliver.upton@linux.dev>
In-Reply-To: <20230526221712.317287-1-oliver.upton@linux.dev>
References: <20230526221712.317287-1-oliver.upton@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In order to handle PSCI, we need a way to reset a vCPU. Fortunately, the
KVM_ARM_VCPU_INIT ioctl is said to have the effect of an architectural
reset. Reconfigure features after the INIT ioctl, if necessary (SVE).

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arm/include/arm-common/kvm-cpu-arch.h |  2 ++
 arm/kvm-cpu.c                         | 14 +++++++++++---
 2 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/arm/include/arm-common/kvm-cpu-arch.h b/arm/include/arm-common/kvm-cpu-arch.h
index bf5223eaa851..64a4fecd0aee 100644
--- a/arm/include/arm-common/kvm-cpu-arch.h
+++ b/arm/include/arm-common/kvm-cpu-arch.h
@@ -38,6 +38,8 @@ void kvm_cpu__set_kvm_arm_generic_target(struct kvm_arm_target *target);
 
 int kvm_cpu__register_kvm_arm_target(struct kvm_arm_target *target);
 
+void kvm_cpu__arm_reset(struct kvm_cpu *vcpu);
+
 static inline bool kvm_cpu__emulate_io(struct kvm_cpu *vcpu, u16 port, void *data,
 				       int direction, int size, u32 count)
 {
diff --git a/arm/kvm-cpu.c b/arm/kvm-cpu.c
index 0ac488a93eef..426fc135f927 100644
--- a/arm/kvm-cpu.c
+++ b/arm/kvm-cpu.c
@@ -35,6 +35,15 @@ int kvm_cpu__register_kvm_arm_target(struct kvm_arm_target *target)
 	return -ENOSPC;
 }
 
+void kvm_cpu__arm_reset(struct kvm_cpu *vcpu)
+{
+	if (ioctl(vcpu->vcpu_fd, KVM_ARM_VCPU_INIT, &vcpu->init))
+		die_perror("KVM_ARM_VCPU_INIT failed");
+
+	if (kvm_cpu__configure_features(vcpu))
+		die("Unable to configure requested vcpu features");
+}
+
 struct kvm_cpu *kvm_cpu__arch_init(struct kvm *kvm, unsigned long cpu_id)
 {
 	struct kvm_arm_target *target;
@@ -122,15 +131,14 @@ struct kvm_cpu *kvm_cpu__arch_init(struct kvm *kvm, unsigned long cpu_id)
 	if (err || target->init(vcpu))
 		die("Unable to initialise vcpu");
 
+	kvm_cpu__arm_reset(vcpu);
+
 	coalesced_offset = ioctl(kvm->sys_fd, KVM_CHECK_EXTENSION,
 				 KVM_CAP_COALESCED_MMIO);
 	if (coalesced_offset)
 		vcpu->ring = (void *)vcpu->kvm_run +
 			     (coalesced_offset * PAGE_SIZE);
 
-	if (kvm_cpu__configure_features(vcpu))
-		die("Unable to configure requested vcpu features");
-
 	return vcpu;
 }
 
-- 
2.41.0.rc0.172.g3f132b7071-goog

