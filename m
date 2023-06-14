Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4804D712FD6
	for <lists+kvm@lfdr.de>; Sat, 27 May 2023 00:17:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244369AbjEZWRs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 May 2023 18:17:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244359AbjEZWRn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 May 2023 18:17:43 -0400
Received: from out-60.mta0.migadu.com (out-60.mta0.migadu.com [91.218.175.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38418E44
        for <kvm@vger.kernel.org>; Fri, 26 May 2023 15:17:42 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1685139460;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XrnQ0lECyiKFCj8+X7OE/JFYUvx/t/t4X51sd6Vz/YQ=;
        b=h/A451xOUKMq1UQAUuEq/nJ7DOiYDn6J/EBm4X5bdj9FTqu/O28pHMxKlYLgDsTGryIUUf
        I6RIyN2FabwjvE7lyiwwfZABnJT4EYJy0qOW8mWVjkRpDYPVX4RBXWayDD7Ki/8t6qBNy3
        fI99ybrBdh/D3AM+s35rF2xD5ZaBqB4=
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
Subject: [PATCH kvmtool 09/21] arm: Use KVM_SET_MP_STATE ioctl to power off non-boot vCPUs
Date:   Fri, 26 May 2023 22:17:00 +0000
Message-ID: <20230526221712.317287-10-oliver.upton@linux.dev>
In-Reply-To: <20230526221712.317287-1-oliver.upton@linux.dev>
References: <20230526221712.317287-1-oliver.upton@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Using the POWER_OFF flag in kvm_vcpu_init gets in the way of resetting a
vCPU in response to a PSCI CPU_ON call, for obvious reasons. Drop the
flag in favor of using the KVM_SET_MP_STATE call for non-boot vCPUs.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arm/kvm-cpu.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/arm/kvm-cpu.c b/arm/kvm-cpu.c
index 426fc135f927..12a366b9b38b 100644
--- a/arm/kvm-cpu.c
+++ b/arm/kvm-cpu.c
@@ -72,10 +72,6 @@ struct kvm_cpu *kvm_cpu__arch_init(struct kvm *kvm, unsigned long cpu_id)
 	if (vcpu->kvm_run == MAP_FAILED)
 		die("unable to mmap vcpu fd");
 
-	/* VCPU 0 is the boot CPU, the others start in a poweroff state. */
-	if (cpu_id > 0)
-		vcpu_init.features[0] |= (1UL << KVM_ARM_VCPU_POWER_OFF);
-
 	/* Set KVM_ARM_VCPU_PSCI_0_2 if available */
 	if (kvm__supports_extension(kvm, KVM_CAP_ARM_PSCI_0_2)) {
 		vcpu_init.features[0] |= (1UL << KVM_ARM_VCPU_PSCI_0_2);
@@ -133,6 +129,16 @@ struct kvm_cpu *kvm_cpu__arch_init(struct kvm *kvm, unsigned long cpu_id)
 
 	kvm_cpu__arm_reset(vcpu);
 
+	/* VCPU 0 is the boot CPU, the others start in a poweroff state. */
+	if (cpu_id > 0) {
+		struct kvm_mp_state mp_state = {
+			.mp_state	= KVM_MP_STATE_STOPPED,
+		};
+
+		if (ioctl(vcpu->vcpu_fd, KVM_SET_MP_STATE, &mp_state))
+			die_perror("KVM_SET_MP_STATE failed");
+	}
+
 	coalesced_offset = ioctl(kvm->sys_fd, KVM_CHECK_EXTENSION,
 				 KVM_CAP_COALESCED_MMIO);
 	if (coalesced_offset)
-- 
2.41.0.rc0.172.g3f132b7071-goog

