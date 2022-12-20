Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E253765278F
	for <lists+kvm@lfdr.de>; Tue, 20 Dec 2022 21:09:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234154AbiLTUJi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Dec 2022 15:09:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbiLTUJd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Dec 2022 15:09:33 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A62B1AD8E
        for <kvm@vger.kernel.org>; Tue, 20 Dec 2022 12:09:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 305FD61590
        for <kvm@vger.kernel.org>; Tue, 20 Dec 2022 20:09:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C026C433EF;
        Tue, 20 Dec 2022 20:09:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671566971;
        bh=ttZ6e5p6ormRoOUb3KNmacnIPErZGsezf9pYZ4H2bkY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hJAwdY9F1XD0MJyw2UIzvqlfmtJ88j3RmQuM/E56LTVkngx0Tdbe3lyOU8nkkRiq9
         VAGP3ViLfWwnMLZYq9XXPsnmpLpflXVCxPNz78bkyKpquXBgxSQWxCZzqbS6YnrVSe
         HVsgx94HVgPdroRvgwz/tAolACt/BL4LwN4Lj8Nkg4X2amAc8zrDlf+hQUTTt4OeoE
         OsvVNmo8UXwqex3DK53xYO4WDD2yZ/8Fv5bafuX1fiD2xsLtsRYo3y/FTCzz36dNTN
         56mZMTjBu/QYjdHjGV+EF5W/fco8SATQzRBF+PvqzrfRJVLYEXuWkUnenQqUT9+wSW
         DFYeKw4cc9LLw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1p7ivZ-00Dzct-Po;
        Tue, 20 Dec 2022 20:09:29 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     <kvmarm@lists.cs.columbia.edu>, <kvmarm@lists.linux.dev>,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc:     James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Ard Biesheuvel <ardb@kernel.org>,
        Will Deacon <will@kernel.org>,
        Quentin Perret <qperret@google.com>
Subject: [PATCH 2/3] KVM: arm64: Handle S1PTW translation with TCR_HA set as a write
Date:   Tue, 20 Dec 2022 20:09:22 +0000
Message-Id: <20221220200923.1532710-3-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221220200923.1532710-1-maz@kernel.org>
References: <20221220200923.1532710-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu, kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, oliver.upton@linux.dev, ardb@kernel.org, will@kernel.org, qperret@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

As a minor optimisation, we can retrofit the "S1PTW is a write
even on translation fault" concept *if* the vcpu is using the
HW-managed Access Flag, as setting TCR_EL1.HA is guaranteed
to result in an update of the PTE.

However, we cannot do the same thing for DB, as it would require
us to parse the PTs to find out if the DBM bit is set there.
This is not going to happen.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_emulate.h | 20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index fd6ad8b21f85..4ee467065042 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -374,6 +374,9 @@ static __always_inline int kvm_vcpu_sys_get_rt(struct kvm_vcpu *vcpu)
 static inline bool kvm_is_write_fault(struct kvm_vcpu *vcpu)
 {
 	if (kvm_vcpu_abt_iss1tw(vcpu)) {
+		unsigned int afdb;
+		u64 mmfr1;
+
 		/*
 		 * Only a permission fault on a S1PTW should be
 		 * considered as a write. Otherwise, page tables baked
@@ -385,12 +388,27 @@ static inline bool kvm_is_write_fault(struct kvm_vcpu *vcpu)
 		 * to map the page containing the PT (read only at
 		 * first), then a permission fault to allow the flags
 		 * to be set.
+		 *
+		 * We can improve things if the guest uses AF, as this
+		 * is guaranteed to result in a write to the PTE. For
+		 * DB, however, we'd need to parse the guest's PTs,
+		 * and that's not on. DB is crap anyway.
 		 */
 		switch (kvm_vcpu_trap_get_fault_type(vcpu)) {
 		case ESR_ELx_FSC_PERM:
 			return true;
 		default:
-			return false;
+			/* Can't introspect TCR_EL1 with pKVM */
+			if (kvm_vm_is_protected(vcpu->kvm))
+				return false;
+
+			mmfr1 = read_sanitised_ftr_reg(SYS_ID_AA64MMFR1_EL1);
+			afdb = cpuid_feature_extract_unsigned_field(mmfr1, ID_AA64MMFR1_EL1_HAFDBS_SHIFT);
+
+			if (afdb == ID_AA64MMFR1_EL1_HAFDBS_NI)
+				return false;
+
+			return (vcpu_read_sys_reg(vcpu, TCR_EL1) & TCR_HA);
 		}
 	}
 
-- 
2.34.1

