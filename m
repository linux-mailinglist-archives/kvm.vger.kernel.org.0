Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4077D720BCA
	for <lists+kvm@lfdr.de>; Sat,  3 Jun 2023 00:15:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236565AbjFBWPO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Jun 2023 18:15:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236399AbjFBWPM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Jun 2023 18:15:12 -0400
Received: from smtp-fw-80006.amazon.com (smtp-fw-80006.amazon.com [99.78.197.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09B971B7
        for <kvm@vger.kernel.org>; Fri,  2 Jun 2023 15:15:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1685744112; x=1717280112;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=M/pB0Sn9Zyc2BxOPXPcGGAHlw3YZBnje4rXEs81o8no=;
  b=dEYLFN6Azc4WWLEy6+QPzMgr6W2u1EZ/IwiUPoicleJTDEXQKdprHsHL
   EtZO2trr3BMPJherMLmW7KFgD5vmWPL9F2LenJ5khaofqfHALI8x4lHt3
   mjX47xcznQO46uldDfN7CDDukVdPfJ02HhmkHlM4pNTC6xVQxIrN97zmO
   s=;
X-IronPort-AV: E=Sophos;i="6.00,214,1681171200"; 
   d="scan'208";a="218333667"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-iad-1a-m6i4x-b5bd57cf.us-east-1.amazon.com) ([10.25.36.210])
  by smtp-border-fw-80006.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jun 2023 22:15:10 +0000
Received: from EX19MTAUWA002.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1a-m6i4x-b5bd57cf.us-east-1.amazon.com (Postfix) with ESMTPS id 00BC146487;
        Fri,  2 Jun 2023 22:15:04 +0000 (UTC)
Received: from EX19D030UWB002.ant.amazon.com (10.13.139.182) by
 EX19MTAUWA002.ant.amazon.com (10.250.64.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Fri, 2 Jun 2023 22:14:59 +0000
Received: from u1e958862c3245e.ant.amazon.com (10.187.170.26) by
 EX19D030UWB002.ant.amazon.com (10.13.139.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Fri, 2 Jun 2023 22:14:59 +0000
From:   Suraj Jitindar Singh <surajjs@amazon.com>
To:     <jingzhangos@google.com>
CC:     <alexandru.elisei@arm.com>, <james.morse@arm.com>,
        <kvm@vger.kernel.org>, <kvmarm@lists.linux.dev>,
        <linux-arm-kernel@lists.infradead.org>, <maz@kernel.org>,
        <oupton@google.com>, <pbonzini@redhat.com>, <rananta@google.com>,
        <reijiw@google.com>, <suzuki.poulose@arm.com>, <tabba@google.com>,
        <will@kernel.org>, <sjitindarsingh@gmail.com>,
        "Suraj Jitindar Singh" <surajjs@amazon.com>
Subject: [PATCH 3/3] KVM: arm64: Use per guest ID register for ID_AA64PFR1_EL1.MTE
Date:   Fri, 2 Jun 2023 15:14:47 -0700
Message-ID: <20230602221447.1809849-4-surajjs@amazon.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230602221447.1809849-1-surajjs@amazon.com>
References: <20230602005118.2899664-1-jingzhangos@google.com>
 <20230602221447.1809849-1-surajjs@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.187.170.26]
X-ClientProxiedBy: EX19D031UWC003.ant.amazon.com (10.13.139.252) To
 EX19D030UWB002.ant.amazon.com (10.13.139.182)
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

With per guest ID registers, MTE settings from userspace can be stored in
its corresponding ID register.

No functional change intended.

Signed-off-by: Suraj Jitindar Singh <surajjs@amazon.com>
---
 arch/arm64/include/asm/kvm_host.h | 21 ++++++++++-----------
 arch/arm64/kvm/arm.c              | 11 ++++++++++-
 arch/arm64/kvm/sys_regs.c         |  5 +++++
 3 files changed, 25 insertions(+), 12 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 7b0f43373dbe..861997a14ba1 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -226,9 +226,7 @@ struct kvm_arch {
 	 */
 #define KVM_ARCH_FLAG_RETURN_NISV_IO_ABORT_TO_USER	0
 	/* Memory Tagging Extension enabled for the guest */
-#define KVM_ARCH_FLAG_MTE_ENABLED			1
-	/* At least one vCPU has ran in the VM */
-#define KVM_ARCH_FLAG_HAS_RAN_ONCE			2
+#define KVM_ARCH_FLAG_HAS_RAN_ONCE			1
 	/*
 	 * The following two bits are used to indicate the guest's EL1
 	 * register width configuration. A value of KVM_ARCH_FLAG_EL1_32BIT
@@ -236,22 +234,22 @@ struct kvm_arch {
 	 * Otherwise, the guest's EL1 register width has not yet been
 	 * determined yet.
 	 */
-#define KVM_ARCH_FLAG_REG_WIDTH_CONFIGURED		3
-#define KVM_ARCH_FLAG_EL1_32BIT				4
+#define KVM_ARCH_FLAG_REG_WIDTH_CONFIGURED		2
+#define KVM_ARCH_FLAG_EL1_32BIT				3
 	/* PSCI SYSTEM_SUSPEND enabled for the guest */
-#define KVM_ARCH_FLAG_SYSTEM_SUSPEND_ENABLED		5
+#define KVM_ARCH_FLAG_SYSTEM_SUSPEND_ENABLED		4
 	/* VM counter offset */
-#define KVM_ARCH_FLAG_VM_COUNTER_OFFSET			6
+#define KVM_ARCH_FLAG_VM_COUNTER_OFFSET			5
 	/* Timer PPIs made immutable */
-#define KVM_ARCH_FLAG_TIMER_PPIS_IMMUTABLE		7
+#define KVM_ARCH_FLAG_TIMER_PPIS_IMMUTABLE		6
 	/* SMCCC filter initialized for the VM */
-#define KVM_ARCH_FLAG_SMCCC_FILTER_CONFIGURED		8
+#define KVM_ARCH_FLAG_SMCCC_FILTER_CONFIGURED		7
 	/*
 	 * AA64DFR0_EL1.PMUver was set as ID_AA64DFR0_EL1_PMUVer_IMP_DEF
 	 * or DFR0_EL1.PerfMon was set as ID_DFR0_EL1_PerfMon_IMPDEF from
 	 * userspace for VCPUs without PMU.
 	 */
-#define KVM_ARCH_FLAG_VCPU_HAS_IMP_DEF_PMU		9
+#define KVM_ARCH_FLAG_VCPU_HAS_IMP_DEF_PMU		8
 
 	unsigned long flags;
 
@@ -1112,7 +1110,8 @@ bool kvm_arm_vcpu_is_finalized(struct kvm_vcpu *vcpu);
 
 #define kvm_has_mte(kvm)					\
 	(system_supports_mte() &&				\
-	 test_bit(KVM_ARCH_FLAG_MTE_ENABLED, &(kvm)->arch.flags))
+	 FIELD_GET(ID_AA64PFR1_EL1_MTE_MASK,			\
+		   IDREG(kvm, SYS_ID_AA64PFR1_EL1)))
 
 #define kvm_supports_32bit_el0()				\
 	(system_supports_32bit_el0() &&				\
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index ca18c09ccf82..6fc4190559d1 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -80,8 +80,17 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 		if (!system_supports_mte() || kvm->created_vcpus) {
 			r = -EINVAL;
 		} else {
+			u64 val;
+
+			/* Protects the idregs against modification */
+			mutex_lock(&kvm->arch.config_lock);
+
+			val = IDREG(kvm, SYS_ID_AA64PFR1_EL1);
+			val |= FIELD_PREP(ID_AA64PFR1_EL1_MTE_MASK, 1);
+			IDREG(kvm, SYS_ID_AA64PFR1_EL1) = val;
+
+			mutex_unlock(&kvm->arch.config_lock);
 			r = 0;
-			set_bit(KVM_ARCH_FLAG_MTE_ENABLED, &kvm->arch.flags);
 		}
 		mutex_unlock(&kvm->lock);
 		break;
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 59f8adda47fa..8cffb82dd10d 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -3672,6 +3672,11 @@ void kvm_arm_init_id_regs(struct kvm *kvm)
 		idreg++;
 		id = reg_to_encoding(idreg);
 	}
+
+	/* MTE disabled by default even when supported */
+	val = IDREG(kvm, SYS_ID_AA64PFR1_EL1);
+	val &= ~ARM64_FEATURE_MASK(ID_AA64PFR1_EL1_MTE);
+	IDREG(kvm, SYS_ID_AA64PFR1_EL1) = val;
 }
 
 int __init kvm_sys_reg_table_init(void)
-- 
2.34.1

