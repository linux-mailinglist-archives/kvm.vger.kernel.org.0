Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7922E7A8BE1
	for <lists+kvm@lfdr.de>; Wed, 20 Sep 2023 20:33:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229678AbjITSdq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Sep 2023 14:33:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229663AbjITSdo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Sep 2023 14:33:44 -0400
Received: from out-210.mta1.migadu.com (out-210.mta1.migadu.com [IPv6:2001:41d0:203:375::d2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C07EC9
        for <kvm@vger.kernel.org>; Wed, 20 Sep 2023 11:33:38 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1695234816;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=urpT7DYpWddYyOHkqJREBoJa3eM7v1IrFVmDElQJ+38=;
        b=V7L6oEiCgCORxt6iI7stNxS+OSFysXI7vYfE4hQ2s+WpFJZcfwBrYbWD9w7cPDu6gjuvsy
        YuMpDro2OWf28aoWTWVz3RVpjt3MY2izniGqXQ6VXb8JiTXb+bHlAMjIL7Y83WUvE0p6Ox
        z0Zdg1OA+lODgyNdMEWSvs6Mv0gvM00=
From:   Oliver Upton <oliver.upton@linux.dev>
To:     kvmarm@lists.linux.dev
Cc:     kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Will Deacon <will@kernel.org>,
        Cornelia Huck <cohuck@redhat.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Jing Zhang <jingzhangos@google.com>
Subject: [PATCH v10 06/12] KVM: arm64: Allow userspace to change ID_AA64ISAR{0-2}_EL1
Date:   Wed, 20 Sep 2023 18:33:03 +0000
Message-ID: <20230920183310.1163034-7-oliver.upton@linux.dev>
In-Reply-To: <20230920183310.1163034-1-oliver.upton@linux.dev>
References: <20230920183310.1163034-1-oliver.upton@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Almost all of the features described by the ISA registers have no KVM
involvement. Allow userspace to change the value of these registers with
a couple exceptions:

 - MOPS is not writable as KVM does not currently virtualize FEAT_MOPS.

 - The PAuth fields are not writable as KVM requires both address and
   generic authentication be enabled.

 - Override the kernel's handling of BC to LOWER_SAFE.

Co-developed-by: Jing Zhang <jingzhangos@google.com>
Signed-off-by: Jing Zhang <jingzhangos@google.com>
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/sys_regs.c | 42 ++++++++++++++++++++++++++++-----------
 1 file changed, 30 insertions(+), 12 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 10e3e6a736dc..71664bec2808 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1225,6 +1225,10 @@ static s64 kvm_arm64_ftr_safe_value(u32 id, const struct arm64_ftr_bits *ftrp,
 			break;
 		}
 		break;
+	case SYS_ID_AA64ISAR2_EL1:
+		if (kvm_ftr.shift == ID_AA64ISAR2_EL1_BC_SHIFT)
+			kvm_ftr.type = FTR_LOWER_SAFE;
+		break;
 	case SYS_ID_DFR0_EL1:
 		if (kvm_ftr.shift == ID_DFR0_EL1_PerfMon_SHIFT)
 			kvm_ftr.type = FTR_LOWER_SAFE;
@@ -1851,11 +1855,14 @@ static unsigned int elx2_visibility(const struct kvm_vcpu *vcpu,
  * from userspace.
  */
 
-/* sys_reg_desc initialiser for known cpufeature ID registers */
-#define ID_SANITISED(name) {			\
+#define ID_DESC(name)				\
 	SYS_DESC(SYS_##name),			\
 	.access	= access_id_reg,		\
-	.get_user = get_id_reg,			\
+	.get_user = get_id_reg			\
+
+/* sys_reg_desc initialiser for known cpufeature ID registers */
+#define ID_SANITISED(name) {			\
+	ID_DESC(name),				\
 	.set_user = set_id_reg,			\
 	.visibility = id_visibility,		\
 	.reset = kvm_read_sanitised_id_reg,	\
@@ -1864,15 +1871,22 @@ static unsigned int elx2_visibility(const struct kvm_vcpu *vcpu,
 
 /* sys_reg_desc initialiser for known cpufeature ID registers */
 #define AA32_ID_SANITISED(name) {		\
-	SYS_DESC(SYS_##name),			\
-	.access	= access_id_reg,		\
-	.get_user = get_id_reg,			\
+	ID_DESC(name),				\
 	.set_user = set_id_reg,			\
 	.visibility = aa32_id_visibility,	\
 	.reset = kvm_read_sanitised_id_reg,	\
 	.val = 0,				\
 }
 
+/* sys_reg_desc initialiser for writable ID registers */
+#define ID_WRITABLE(name, mask) {		\
+	ID_DESC(name),				\
+	.set_user = set_id_reg,			\
+	.visibility = id_visibility,		\
+	.reset = kvm_read_sanitised_id_reg,	\
+	.val = mask,				\
+}
+
 /*
  * sys_reg_desc initialiser for architecturally unallocated cpufeature ID
  * register with encoding Op0=3, Op1=0, CRn=0, CRm=crm, Op2=op2
@@ -1894,9 +1908,7 @@ static unsigned int elx2_visibility(const struct kvm_vcpu *vcpu,
  * RAZ for the guest.
  */
 #define ID_HIDDEN(name) {			\
-	SYS_DESC(SYS_##name),			\
-	.access = access_id_reg,		\
-	.get_user = get_id_reg,			\
+	ID_DESC(name),				\
 	.set_user = set_id_reg,			\
 	.visibility = raz_visibility,		\
 	.reset = kvm_read_sanitised_id_reg,	\
@@ -2075,9 +2087,15 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	ID_UNALLOCATED(5,7),
 
 	/* CRm=6 */
-	ID_SANITISED(ID_AA64ISAR0_EL1),
-	ID_SANITISED(ID_AA64ISAR1_EL1),
-	ID_SANITISED(ID_AA64ISAR2_EL1),
+	ID_WRITABLE(ID_AA64ISAR0_EL1, ~ID_AA64ISAR0_EL1_RES0),
+	ID_WRITABLE(ID_AA64ISAR1_EL1, ~(ID_AA64ISAR1_EL1_GPI |
+					ID_AA64ISAR1_EL1_GPA |
+					ID_AA64ISAR1_EL1_API |
+					ID_AA64ISAR1_EL1_APA)),
+	ID_WRITABLE(ID_AA64ISAR2_EL1, ~(ID_AA64ISAR2_EL1_RES0 |
+					ID_AA64ISAR2_EL1_MOPS |
+					ID_AA64ISAR2_EL1_APA3 |
+					ID_AA64ISAR2_EL1_GPA3)),
 	ID_UNALLOCATED(6,3),
 	ID_UNALLOCATED(6,4),
 	ID_UNALLOCATED(6,5),
-- 
2.42.0.515.g380fc7ccd1-goog

