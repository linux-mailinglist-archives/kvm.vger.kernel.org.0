Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B7876061ED
	for <lists+kvm@lfdr.de>; Thu, 20 Oct 2022 15:40:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231244AbiJTNkD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Oct 2022 09:40:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231191AbiJTNj4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Oct 2022 09:39:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95A3017415
        for <kvm@vger.kernel.org>; Thu, 20 Oct 2022 06:39:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A4DFB61B8C
        for <kvm@vger.kernel.org>; Thu, 20 Oct 2022 13:39:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E23BFC4347C;
        Thu, 20 Oct 2022 13:39:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666273173;
        bh=4V2HwMqyv2xb7RdObBC8G4vXYXopyodgR7pavmHSsEg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=clqz04q1jDURKb/1to0Aq2slwu0fIdBgnJa62zyu6i6OrUeHhMdhqQNUu6HI0RAqA
         QypzFHvBvrY5ADiyZOiRj7DNSFNEuJXCg+5Zy1p1RG5fgLL4Cp2d9VCCpsBPnr0KbZ
         XraXpGnE1X+iZHBJTj64PAFXDQi9oB1AvEy89C3YFN0bXTCVZYZDHsji0z/VA8tXxl
         bO6X8DnnckDoESGPOwpHXh/EwbC2HpuDNn6PziITtlzhTRGJ6/Kipb5mKpy9307s2Q
         /9PqJ8nYXdwoF4ceRIMEq2pyCoI97iGSPCN+FefFFbHJ7aELerAOyg4v188MsOkQ2Z
         7jJ1WZ9dnH0BQ==
From:   Will Deacon <will@kernel.org>
To:     kvmarm@lists.linux.dev
Cc:     Will Deacon <will@kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Vincent Donnefort <vdonnefort@google.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        James Morse <james.morse@arm.com>,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Quentin Perret <qperret@google.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Fuad Tabba <tabba@google.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Marc Zyngier <maz@kernel.org>, kernel-team@android.com,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH v5 15/25] KVM: arm64: Initialise hypervisor copies of host symbols unconditionally
Date:   Thu, 20 Oct 2022 14:38:17 +0100
Message-Id: <20221020133827.5541-16-will@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20221020133827.5541-1-will@kernel.org>
References: <20221020133827.5541-1-will@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The nVHE object at EL2 maintains its own copies of some host variables
so that, when pKVM is enabled, the host cannot directly modify the
hypervisor state. When running in normal nVHE mode, however, these
variables are still mirrored at EL2 but are not initialised.

Initialise the hypervisor symbols from the host copies regardless of
pKVM, ensuring that any reference to this data at EL2 with normal nVHE
will return a sensibly initialised value.

Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Tested-by: Vincent Donnefort <vdonnefort@google.com>
Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/kvm/arm.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 30d6fc5d3a93..584626e11797 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1884,11 +1884,8 @@ static int do_pkvm_init(u32 hyp_va_bits)
 	return ret;
 }
 
-static int kvm_hyp_init_protection(u32 hyp_va_bits)
+static void kvm_hyp_init_symbols(void)
 {
-	void *addr = phys_to_virt(hyp_mem_base);
-	int ret;
-
 	kvm_nvhe_sym(id_aa64pfr0_el1_sys_val) = read_sanitised_ftr_reg(SYS_ID_AA64PFR0_EL1);
 	kvm_nvhe_sym(id_aa64pfr1_el1_sys_val) = read_sanitised_ftr_reg(SYS_ID_AA64PFR1_EL1);
 	kvm_nvhe_sym(id_aa64isar0_el1_sys_val) = read_sanitised_ftr_reg(SYS_ID_AA64ISAR0_EL1);
@@ -1897,6 +1894,12 @@ static int kvm_hyp_init_protection(u32 hyp_va_bits)
 	kvm_nvhe_sym(id_aa64mmfr0_el1_sys_val) = read_sanitised_ftr_reg(SYS_ID_AA64MMFR0_EL1);
 	kvm_nvhe_sym(id_aa64mmfr1_el1_sys_val) = read_sanitised_ftr_reg(SYS_ID_AA64MMFR1_EL1);
 	kvm_nvhe_sym(id_aa64mmfr2_el1_sys_val) = read_sanitised_ftr_reg(SYS_ID_AA64MMFR2_EL1);
+}
+
+static int kvm_hyp_init_protection(u32 hyp_va_bits)
+{
+	void *addr = phys_to_virt(hyp_mem_base);
+	int ret;
 
 	ret = create_hyp_mappings(addr, addr + hyp_mem_size, PAGE_HYP);
 	if (ret)
@@ -2071,6 +2074,8 @@ static int init_hyp_mode(void)
 		cpu_prepare_hyp_mode(cpu);
 	}
 
+	kvm_hyp_init_symbols();
+
 	if (is_protected_kvm_enabled()) {
 		init_cpu_logical_map();
 
@@ -2078,9 +2083,7 @@ static int init_hyp_mode(void)
 			err = -ENODEV;
 			goto out_err;
 		}
-	}
 
-	if (is_protected_kvm_enabled()) {
 		err = kvm_hyp_init_protection(hyp_va_bits);
 		if (err) {
 			kvm_err("Failed to init hyp memory protection\n");
-- 
2.38.0.413.g74048e4d9e-goog

