Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D41EF7035CC
	for <lists+kvm@lfdr.de>; Mon, 15 May 2023 19:02:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243578AbjEORCu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 May 2023 13:02:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243392AbjEORC1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 May 2023 13:02:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E60EF9036
        for <kvm@vger.kernel.org>; Mon, 15 May 2023 10:00:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 241BD62A77
        for <kvm@vger.kernel.org>; Mon, 15 May 2023 17:00:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8533DC433A0;
        Mon, 15 May 2023 17:00:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1684170022;
        bh=yaBwlfhHBKhoy9UfTyXssm3QaX93Y5s7wLXz9SfiTQg=;
        h=From:To:Cc:Subject:Date:From;
        b=u7tHAFbqO8Z2dIoVQnCdcAnwvfjzoJjhZw75favVb8vk1AvtIj4s8L1qxC9/+3vc2
         el3bY0Ki9fpogktyL9DxX6760vx2wlnst/w+riF7xVbLGIyxNOu/dbGIyGs/OVN71K
         8ejLPYcNkIKSvzB4hrFAomogX+N7Mb0wM1YdTBfxw2SNzdcLjr7xfcqNdbuuXApi1J
         q9fBXm1wB+ywz4W/mzlhT+Xa+Et2rLKY2Y+RaZWOrmoS2yVPQ3ewtECjER09A0+G4o
         SHd3MLxyb/K1yLsz8n4gYWWw6PV+nb/7WjCjnWNgpJIIllaURxZ/1Im6B2JJYi/BcU
         G0dDgTBpYDddQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1pybYZ-00FIeI-3Y;
        Mon, 15 May 2023 18:00:20 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc:     James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH] KVM: arm64: Relax trapping of CTR_EL0 when FEAT_EVT is available
Date:   Mon, 15 May 2023 18:00:16 +0100
Message-Id: <20230515170016.965378-1-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

CTR_EL0 can often be used in userspace, and it would be nice if
KVM didn't have to emulate it unnecessarily.

While it isn't possible to trap the cache configuration registers
indemendently from CTR_EL0 in the base ARMv8.0 architecture, FEAT_EVT
allows these cache configuration registers (CCSIDR_EL1, CCSIDR2_EL1,
CLIDR_EL1 and CSSELR_EL1) to be trapped indepdently by setting
HCR_EL2.TID4.

Switch to using TID4 instead of TID2 in the cases where FEAT_EVT
is available *and* that KVM doesn't need to sanitise CTR_EL0 to
paper over mismatched cache configurations.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_arm.h     |  2 +-
 arch/arm64/include/asm/kvm_emulate.h |  6 ++++++
 arch/arm64/kernel/cpufeature.c       | 11 +++++++++++
 arch/arm64/tools/cpucaps             |  1 +
 4 files changed, 19 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
index baef29fcbeee..209a4fba5d2a 100644
--- a/arch/arm64/include/asm/kvm_arm.h
+++ b/arch/arm64/include/asm/kvm_arm.h
@@ -86,7 +86,7 @@
 #define HCR_GUEST_FLAGS (HCR_TSC | HCR_TSW | HCR_TWE | HCR_TWI | HCR_VM | \
 			 HCR_BSU_IS | HCR_FB | HCR_TACR | \
 			 HCR_AMO | HCR_SWIO | HCR_TIDCP | HCR_RW | HCR_TLOR | \
-			 HCR_FMO | HCR_IMO | HCR_PTW | HCR_TID3 | HCR_TID2)
+			 HCR_FMO | HCR_IMO | HCR_PTW | HCR_TID3)
 #define HCR_VIRT_EXCP_MASK (HCR_VSE | HCR_VI | HCR_VF)
 #define HCR_HOST_NVHE_FLAGS (HCR_RW | HCR_API | HCR_APK | HCR_ATA)
 #define HCR_HOST_NVHE_PROTECTED_FLAGS (HCR_HOST_NVHE_FLAGS | HCR_TSC)
diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index b31b32ecbe2d..a08291051ac9 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -95,6 +95,12 @@ static inline void vcpu_reset_hcr(struct kvm_vcpu *vcpu)
 		vcpu->arch.hcr_el2 |= HCR_TVM;
 	}
 
+	if (cpus_have_final_cap(ARM64_HAS_EVT) &&
+	    !cpus_have_final_cap(ARM64_MISMATCHED_CACHE_TYPE))
+		vcpu->arch.hcr_el2 |= HCR_TID4;
+	else
+		vcpu->arch.hcr_el2 |= HCR_TID2;
+	
 	if (vcpu_el1_is_32bit(vcpu))
 		vcpu->arch.hcr_el2 &= ~HCR_RW;
 
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index c331c49a7d19..bd184c2cef33 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -2783,6 +2783,17 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
 		.matches = has_cpuid_feature,
 		.cpu_enable = cpu_enable_dit,
 	},
+	{
+		.desc = "Extended Virtualization Traps",
+		.capability = ARM64_HAS_EVT,
+		.type = ARM64_CPUCAP_SYSTEM_FEATURE,
+		.sys_reg = SYS_ID_AA64MMFR2_EL1,
+		.sign = FTR_UNSIGNED,
+		.field_pos = ID_AA64MMFR2_EL1_EVT_SHIFT,
+		.field_width = 4,
+		.min_field_value = ID_AA64MMFR2_EL1_EVT_IMP,
+		.matches = has_cpuid_feature,
+	},
 	{},
 };
 
diff --git a/arch/arm64/tools/cpucaps b/arch/arm64/tools/cpucaps
index 40ba95472594..606d1184a5e9 100644
--- a/arch/arm64/tools/cpucaps
+++ b/arch/arm64/tools/cpucaps
@@ -25,6 +25,7 @@ HAS_E0PD
 HAS_ECV
 HAS_ECV_CNTPOFF
 HAS_EPAN
+HAS_EVT
 HAS_GENERIC_AUTH
 HAS_GENERIC_AUTH_ARCH_QARMA3
 HAS_GENERIC_AUTH_ARCH_QARMA5
-- 
2.34.1

