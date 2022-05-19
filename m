Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4AA052D4E6
	for <lists+kvm@lfdr.de>; Thu, 19 May 2022 15:47:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239271AbiESNqA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 May 2022 09:46:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239190AbiESNpn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 May 2022 09:45:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BA5C384
        for <kvm@vger.kernel.org>; Thu, 19 May 2022 06:45:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D50D4B824A6
        for <kvm@vger.kernel.org>; Thu, 19 May 2022 13:45:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35805C385AA;
        Thu, 19 May 2022 13:45:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652967939;
        bh=HFRJpgCE92vv/8Xgnf9OmEXUkv8UW/YItxgJ7HnU+bc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ps84NFP9x4Ubm9E1OtA0g8yrueW1XFv9aVFu70FM0t0nZ2gNSTEdiE/MTqoLE144+
         y6q8RYW3A1qiqSshj71BduHi7uz1tLUnAtG/3Z8Y5v4/yVCj6pIyFX8DbXyW+CXsLq
         0+7Lr7rTTsnFaISZPDvjVtEYWkqNKXjhBTYfgZxdhlVNp+HpdhSHqjRzG+ojnEgVeZ
         G2Vv+kvmejx9Fx39uwt7nqKLwpVaiLan6DRASOodof+sKnzjhSScEDHfj/2tuao08S
         i6zJ8qd0xpd5wDwScezFcFmld212A3c+RRqTvZvyj+maAheJKo/5Yb+znCuoIN0lPp
         RMC1X3rsc6mYA==
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
Subject: [PATCH 49/89] KVM: arm64: Add hyp per_cpu variable to track current physical cpu number
Date:   Thu, 19 May 2022 14:41:24 +0100
Message-Id: <20220519134204.5379-50-will@kernel.org>
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

From: Fuad Tabba <tabba@google.com>

Hyp cannot trust the equivalent variable at the host.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/include/asm/kvm_hyp.h  | 3 +++
 arch/arm64/kvm/arm.c              | 4 ++++
 arch/arm64/kvm/hyp/nvhe/hyp-smp.c | 2 ++
 3 files changed, 9 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_hyp.h
index 4adf7c2a77bd..e38869e88019 100644
--- a/arch/arm64/include/asm/kvm_hyp.h
+++ b/arch/arm64/include/asm/kvm_hyp.h
@@ -15,6 +15,9 @@
 DECLARE_PER_CPU(struct kvm_cpu_context, kvm_hyp_ctxt);
 DECLARE_PER_CPU(unsigned long, kvm_hyp_vector);
 DECLARE_PER_CPU(struct kvm_nvhe_init_params, kvm_init_params);
+DECLARE_PER_CPU(int, hyp_cpu_number);
+
+#define hyp_smp_processor_id() (__this_cpu_read(hyp_cpu_number))
 
 #define read_sysreg_elx(r,nvh,vh)					\
 	({								\
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 514519563976..3bb379f15c07 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -52,6 +52,7 @@ DECLARE_KVM_HYP_PER_CPU(unsigned long, kvm_hyp_vector);
 
 static DEFINE_PER_CPU(unsigned long, kvm_arm_hyp_stack_page);
 DECLARE_KVM_NVHE_PER_CPU(struct kvm_nvhe_init_params, kvm_init_params);
+DECLARE_KVM_NVHE_PER_CPU(int, hyp_cpu_number);
 
 static bool vgic_present;
 
@@ -1487,6 +1488,9 @@ static void cpu_prepare_hyp_mode(int cpu)
 {
 	struct kvm_nvhe_init_params *params = per_cpu_ptr_nvhe_sym(kvm_init_params, cpu);
 	unsigned long tcr;
+	int *hyp_cpu_number_ptr = per_cpu_ptr_nvhe_sym(hyp_cpu_number, cpu);
+
+	*hyp_cpu_number_ptr = cpu;
 
 	/*
 	 * Calculate the raw per-cpu offset without a translation from the
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-smp.c b/arch/arm64/kvm/hyp/nvhe/hyp-smp.c
index 04d194583f1e..9fcb92abd0b5 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-smp.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-smp.c
@@ -8,6 +8,8 @@
 #include <asm/kvm_hyp.h>
 #include <asm/kvm_mmu.h>
 
+DEFINE_PER_CPU(int, hyp_cpu_number);
+
 /*
  * nVHE copy of data structures tracking available CPU cores.
  * Only entries for CPUs that were online at KVM init are populated.
-- 
2.36.1.124.g0e6072fb45-goog

