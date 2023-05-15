Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B63B4703A56
	for <lists+kvm@lfdr.de>; Mon, 15 May 2023 19:50:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244899AbjEORul (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 May 2023 13:50:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244758AbjEORuV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 May 2023 13:50:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C09319BCF
        for <kvm@vger.kernel.org>; Mon, 15 May 2023 10:48:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 34E3E62F08
        for <kvm@vger.kernel.org>; Mon, 15 May 2023 17:48:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95526C4339E;
        Mon, 15 May 2023 17:48:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1684172894;
        bh=QEbp9zhl7ZTha0RZKm4yw/HK0JS6VcF1zmjMPT+c4sY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R/v+tkI45IIn1VDNqIdzPpBjpck7xmxTxtPYDsg49+QC43rAbN1OQo7BLhLksZod9
         kOHID/X76D1qnIrvFpeiCz9pib3Le4BqYTTKmr6k/T+1WDjl2n2j9iXsihiK5lMAXt
         kOSAYfUlOplTXcmGnufFJ4KA6rW8OCohsf73E2hJfbQjNPqad7WiSOtlfF8fHcuPbQ
         4a2t3fKh42JiVW1FMM1PmqHLjgxI/bHgouGPQk8toZq8jegRjU0Cc0R9NfmML7s8A4
         YHC8w+xh1TKNCWkKqqEJazlwsBtoxj0lpBz9eyoEmVRKxaRdmQzTj0Xvo/AtFH86Oe
         RBxT81r5sIo0A==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1pyc39-00FJAF-Fx;
        Mon, 15 May 2023 18:31:55 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>,
        Andre Przywara <andre.przywara@arm.com>,
        Chase Conklin <chase.conklin@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
        Darren Hart <darren@os.amperecomputing.com>,
        Jintack Lim <jintack@cs.columbia.edu>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Miguel Luis <miguel.luis@oracle.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH v10 50/59] KVM: arm64: Add FEAT_NV2 cpu feature
Date:   Mon, 15 May 2023 18:30:54 +0100
Message-Id: <20230515173103.1017669-51-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230515173103.1017669-1-maz@kernel.org>
References: <20230515173103.1017669-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, alexandru.elisei@arm.com, andre.przywara@arm.com, chase.conklin@arm.com, christoffer.dall@arm.com, gankulkarni@os.amperecomputing.com, darren@os.amperecomputing.com, jintack@cs.columbia.edu, rmk+kernel@armlinux.org.uk, miguel.luis@oracle.com, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
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

Add the detection code for the FEAT_NV2 feature.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_nested.h |  6 ++++++
 arch/arm64/kernel/cpufeature.c      | 11 +++++++++++
 2 files changed, 17 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_nested.h b/arch/arm64/include/asm/kvm_nested.h
index d1596d28a5f8..6a4ddf3683b9 100644
--- a/arch/arm64/include/asm/kvm_nested.h
+++ b/arch/arm64/include/asm/kvm_nested.h
@@ -14,6 +14,12 @@ static inline bool vcpu_has_nv(const struct kvm_vcpu *vcpu)
 		test_bit(KVM_ARM_VCPU_HAS_EL2, vcpu->arch.features));
 }
 
+static inline bool vcpu_has_nv2(const struct kvm_vcpu *vcpu)
+{
+	return cpus_have_final_cap(ARM64_HAS_ENHANCED_NESTED_VIRT) &&
+		vcpu_has_nv(vcpu);
+}
+
 /* Translation helpers from non-VHE EL2 to EL1 */
 static inline u64 tcr_el2_ps_to_tcr_el1_ips(u64 tcr_el2)
 {
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index bd184c2cef33..4f345f11d89d 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -2298,6 +2298,17 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
 		.field_width = 4,
 		.min_field_value = ID_AA64MMFR2_EL1_NV_IMP,
 	},
+	{
+		.desc = "Enhanced Nested Virtualization Support",
+		.capability = ARM64_HAS_ENHANCED_NESTED_VIRT,
+		.type = ARM64_CPUCAP_SYSTEM_FEATURE,
+		.matches = has_nested_virt_support,
+		.sys_reg = SYS_ID_AA64MMFR2_EL1,
+		.sign = FTR_UNSIGNED,
+		.field_pos = ID_AA64MMFR2_EL1_NV_SHIFT,
+		.field_width = 4,
+		.min_field_value = ID_AA64MMFR2_EL1_NV_NV2,
+	},
 	{
 		.capability = ARM64_HAS_32BIT_EL0_DO_NOT_USE,
 		.type = ARM64_CPUCAP_SYSTEM_FEATURE,
-- 
2.34.1

