Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A8C4600E37
	for <lists+kvm@lfdr.de>; Mon, 17 Oct 2022 13:53:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230253AbiJQLxt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Oct 2022 07:53:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229739AbiJQLx3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Oct 2022 07:53:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C12C85925A
        for <kvm@vger.kernel.org>; Mon, 17 Oct 2022 04:53:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E3099B81632
        for <kvm@vger.kernel.org>; Mon, 17 Oct 2022 11:53:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89E11C433C1;
        Mon, 17 Oct 2022 11:53:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666007595;
        bh=8MrW/qLGdmTas2m8Su33Q0MiR8j5vDsbuxe/SRO/NHI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HC9l9SOlqCT1zh2ZPmSsOc9VY2WSS1E0LM4rUc1YqB7n4PlEC1C7V53ZmqzhaAxfa
         p9vBU1lEh9wjkEi6uHyM5q7I8QDT43W2tYU/UDPhc1sSpYjzaiGnbH3WSbJUFMg4B7
         RgHdMgnLFtYt5Yf/oSX2jYM4FB7GFhOr6t2MK4uq+sdEQtAqHMkXQxLZQRJdGCgAaO
         /jpXTZL45feWda67v3lnLVaybsgMKfV6pLO8TZ5QrFz8BQkZ0XnyQp7iKTWUAz5I+D
         MsgZBsPYObVZxvm5eslA0DKDrqafBR5CrRemyMvL07BGlEIixSAu8A4Qd7MRI3yXCr
         UNfr4d5xCWrfg==
From:   Will Deacon <will@kernel.org>
To:     kvmarm@lists.linux.dev
Cc:     Will Deacon <will@kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Vincent Donnefort <vdonnefort@google.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        James Morse <james.morse@arm.com>,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Quentin Perret <qperret@google.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Fuad Tabba <tabba@google.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Marc Zyngier <maz@kernel.org>, kernel-team@android.com,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH v4 15/25] KVM: arm64: Initialise hypervisor copies of host symbols unconditionally
Date:   Mon, 17 Oct 2022 12:51:59 +0100
Message-Id: <20221017115209.2099-16-will@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20221017115209.2099-1-will@kernel.org>
References: <20221017115209.2099-1-will@kernel.org>
MIME-Version: 1.0
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

