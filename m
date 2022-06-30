Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5E17561DB0
	for <lists+kvm@lfdr.de>; Thu, 30 Jun 2022 16:17:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237148AbiF3OOM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Jun 2022 10:14:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237519AbiF3ONY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Jun 2022 10:13:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 663643D48B
        for <kvm@vger.kernel.org>; Thu, 30 Jun 2022 06:58:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 05F9CB82AEE
        for <kvm@vger.kernel.org>; Thu, 30 Jun 2022 13:58:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 043D3C341CB;
        Thu, 30 Jun 2022 13:58:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656597534;
        bh=2z+VzqIdlmDgIeL4Gyw6Deiw7cE868Mkg1FnosIPnHc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rLqIa2JdFBtYk9APFZdiBZ7/eWILkmVwkgPMtwiNknkg+Ojj/xuHVpLfil7crGHkp
         GbUo1NRNC0lrCOPweNQK/0kRqMPgyA3iwj4ByPepvotoizkNQqWi0nXE/5/6ab4qzH
         7Zq7w2RZEuGj1JXJV4VFeFoCysI+L9ABjS8qL4sotsi40JGiOfDIFXAVxcUgjIFsZn
         TRpWy/kBaUjkPxO0O2XbXSpA81bLDkSNEdXS1v190pfJmVjbP/NPoNc5vRTl6dVJYY
         tROMdMgEk0g50ZMJYrKdomAgSlupmAid9atnl5na9OU5gDYpledQxjskG/Tplet71u
         O6ymQpXjN+NYw==
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
        Oliver Upton <oliver.upton@linux.dev>,
        Marc Zyngier <maz@kernel.org>, kernel-team@android.com,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH v2 15/24] KVM: arm64: Initialise hyp symbols regardless of pKVM
Date:   Thu, 30 Jun 2022 14:57:38 +0100
Message-Id: <20220630135747.26983-16-will@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20220630135747.26983-1-will@kernel.org>
References: <20220630135747.26983-1-will@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
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
will return an sensibly initialised value.

Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/kvm/arm.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 66e1d37858f1..a2343640c73c 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1891,11 +1891,8 @@ static int do_pkvm_init(u32 hyp_va_bits)
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
@@ -1904,6 +1901,12 @@ static int kvm_hyp_init_protection(u32 hyp_va_bits)
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
@@ -2078,6 +2081,8 @@ static int init_hyp_mode(void)
 		cpu_prepare_hyp_mode(cpu);
 	}
 
+	kvm_hyp_init_symbols();
+
 	if (is_protected_kvm_enabled()) {
 		init_cpu_logical_map();
 
@@ -2085,9 +2090,7 @@ static int init_hyp_mode(void)
 			err = -ENODEV;
 			goto out_err;
 		}
-	}
 
-	if (is_protected_kvm_enabled()) {
 		err = kvm_hyp_init_protection(hyp_va_bits);
 		if (err) {
 			kvm_err("Failed to init hyp memory protection\n");
-- 
2.37.0.rc0.161.g10f37bed90-goog

