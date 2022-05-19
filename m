Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A31F452D45C
	for <lists+kvm@lfdr.de>; Thu, 19 May 2022 15:44:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238886AbiESNm7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 May 2022 09:42:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230193AbiESNma (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 May 2022 09:42:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1C8B3CA70
        for <kvm@vger.kernel.org>; Thu, 19 May 2022 06:42:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 507E06179A
        for <kvm@vger.kernel.org>; Thu, 19 May 2022 13:42:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40F4CC385B8;
        Thu, 19 May 2022 13:42:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652967748;
        bh=+SbCfNgWLW4Z/wQFkJ7g6gPp4VOqgUcRYGDcNHgxoBg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PMtezuAy/ngvBpF5do3D42T34NTAcmsd4Q86k7oJ9AxvbxFpqs+fK67NszNsHoK4W
         4q1u8ibvPKHnktBQhxIKnOiqNRL4zXkyfCmsuRmuRD9uRLfZRbc68yPr+PSOmiSxWq
         wTiFGs9rMhKzHmgI+wpkViqlLiA1GLGh0YuRwv6KueV2WCeHET8/gscWkOMgUvzDPN
         eXwweQaQ3NLJ2SGyMvqDNukhnGGRusfNLTNzPRT/y9d1WKi8hR9iHdldn0p/Bsd2wp
         CKfqx1U8wVzAITh/Tk8F77lcSu0eRrd8XRXFTEdsdTQsSqBluQsskMBJ0p8nt1z6Pa
         OauJgVfHfCLIw==
From:   Will Deacon <will@kernel.org>
To:     kvmarm@lists.cs.columbia.edu
Cc:     Will Deacon <will@kernel.org>, Ard Biesheuvel <ardb@kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Catalin Marinas <catalin.marinas@arm.com>,
        James Morse <james.morse@arm.com>,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Quentin Perret <qperret@google.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Michael Roth <michael.roth@amd.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Fuad Tabba <tabba@google.com>,
        Oliver Upton <oupton@google.com>,
        Marc Zyngier <maz@kernel.org>, kernel-team@android.com,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH 01/89] KVM: arm64: Handle all ID registers trapped for a protected VM
Date:   Thu, 19 May 2022 14:40:36 +0100
Message-Id: <20220519134204.5379-2-will@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20220519134204.5379-1-will@kernel.org>
References: <20220519134204.5379-1-will@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Marc Zyngier <maz@kernel.org>

A protected VM accessing ID_AA64ISAR2_EL1 gets punished with an UNDEF,
while it really should only get a zero back if the register is not
handled by the hypervisor emulation (as mandated by the architecture).

Introduce all the missing ID registers (including the unallocated ones),
and have them to return 0.

Reported-by: Will Deacon <will@kernel.org>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/hyp/nvhe/sys_regs.c | 42 ++++++++++++++++++++++++------
 1 file changed, 34 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/sys_regs.c b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
index 33f5181af330..188fed1c174b 100644
--- a/arch/arm64/kvm/hyp/nvhe/sys_regs.c
+++ b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
@@ -246,15 +246,9 @@ u64 pvm_read_id_reg(const struct kvm_vcpu *vcpu, u32 id)
 	case SYS_ID_AA64MMFR2_EL1:
 		return get_pvm_id_aa64mmfr2(vcpu);
 	default:
-		/*
-		 * Should never happen because all cases are covered in
-		 * pvm_sys_reg_descs[].
-		 */
-		WARN_ON(1);
-		break;
+		/* Unhandled ID register, RAZ */
+		return 0;
 	}
-
-	return 0;
 }
 
 static u64 read_id_reg(const struct kvm_vcpu *vcpu,
@@ -335,6 +329,16 @@ static bool pvm_gic_read_sre(struct kvm_vcpu *vcpu,
 /* Mark the specified system register as an AArch64 feature id register. */
 #define AARCH64(REG) { SYS_DESC(REG), .access = pvm_access_id_aarch64 }
 
+/*
+ * sys_reg_desc initialiser for architecturally unallocated cpufeature ID
+ * register with encoding Op0=3, Op1=0, CRn=0, CRm=crm, Op2=op2
+ * (1 <= crm < 8, 0 <= Op2 < 8).
+ */
+#define ID_UNALLOCATED(crm, op2) {			\
+	Op0(3), Op1(0), CRn(0), CRm(crm), Op2(op2),	\
+	.access = pvm_access_id_aarch64,		\
+}
+
 /* Mark the specified system register as Read-As-Zero/Write-Ignored */
 #define RAZ_WI(REG) { SYS_DESC(REG), .access = pvm_access_raz_wi }
 
@@ -378,24 +382,46 @@ static const struct sys_reg_desc pvm_sys_reg_descs[] = {
 	AARCH32(SYS_MVFR0_EL1),
 	AARCH32(SYS_MVFR1_EL1),
 	AARCH32(SYS_MVFR2_EL1),
+	ID_UNALLOCATED(3,3),
 	AARCH32(SYS_ID_PFR2_EL1),
 	AARCH32(SYS_ID_DFR1_EL1),
 	AARCH32(SYS_ID_MMFR5_EL1),
+	ID_UNALLOCATED(3,7),
 
 	/* AArch64 ID registers */
 	/* CRm=4 */
 	AARCH64(SYS_ID_AA64PFR0_EL1),
 	AARCH64(SYS_ID_AA64PFR1_EL1),
+	ID_UNALLOCATED(4,2),
+	ID_UNALLOCATED(4,3),
 	AARCH64(SYS_ID_AA64ZFR0_EL1),
+	ID_UNALLOCATED(4,5),
+	ID_UNALLOCATED(4,6),
+	ID_UNALLOCATED(4,7),
 	AARCH64(SYS_ID_AA64DFR0_EL1),
 	AARCH64(SYS_ID_AA64DFR1_EL1),
+	ID_UNALLOCATED(5,2),
+	ID_UNALLOCATED(5,3),
 	AARCH64(SYS_ID_AA64AFR0_EL1),
 	AARCH64(SYS_ID_AA64AFR1_EL1),
+	ID_UNALLOCATED(5,6),
+	ID_UNALLOCATED(5,7),
 	AARCH64(SYS_ID_AA64ISAR0_EL1),
 	AARCH64(SYS_ID_AA64ISAR1_EL1),
+	AARCH64(SYS_ID_AA64ISAR2_EL1),
+	ID_UNALLOCATED(6,3),
+	ID_UNALLOCATED(6,4),
+	ID_UNALLOCATED(6,5),
+	ID_UNALLOCATED(6,6),
+	ID_UNALLOCATED(6,7),
 	AARCH64(SYS_ID_AA64MMFR0_EL1),
 	AARCH64(SYS_ID_AA64MMFR1_EL1),
 	AARCH64(SYS_ID_AA64MMFR2_EL1),
+	ID_UNALLOCATED(7,3),
+	ID_UNALLOCATED(7,4),
+	ID_UNALLOCATED(7,5),
+	ID_UNALLOCATED(7,6),
+	ID_UNALLOCATED(7,7),
 
 	/* Scalable Vector Registers are restricted. */
 
-- 
2.36.1.124.g0e6072fb45-goog

