Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E60986CCEB4
	for <lists+kvm@lfdr.de>; Wed, 29 Mar 2023 02:22:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229765AbjC2AWJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Mar 2023 20:22:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229755AbjC2AWH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Mar 2023 20:22:07 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8BB7211B
        for <kvm@vger.kernel.org>; Tue, 28 Mar 2023 17:21:55 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3-20020a250b03000000b00b5f1fab9897so13758175ybl.19
        for <kvm@vger.kernel.org>; Tue, 28 Mar 2023 17:21:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680049315;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=iXBtTxJA82bcXFQXnQ4d5hea80kX0towjerItzNuSjc=;
        b=f3LE3sXwy/Ypo0P2WoNo8NflUs56Y6hwFUXr6NyFwI05caseJKeOArDA3LgE6Zvesh
         n8XB+vhcrio7HWaQOwAgaN3DIiP9fCowNOXVr4nI+hNQtTbatppnEfPFQKmmykKrDCdm
         BYn5i/V1hkx3deB/XcrBXFj3kTR5h1S7Xcr1lR4QtEztD3l97yuAqQGTW/v5IqFDFIB3
         /BX/s9XQQjmYW6t6MQl5kqVyqT1vco7mSDQcsmO2kRkM429zib6uYwf6k+CXWGQpYA9r
         q9xWmPJLZW8gDNFLVzvXNcN/lF/2sLxlfxPgRdF37A1YYkqf+/7neUK/EMVqdLyEtdw7
         QJUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680049315;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=iXBtTxJA82bcXFQXnQ4d5hea80kX0towjerItzNuSjc=;
        b=1ThJZ+BcWwCTSUp01+quRPUXi7/vTkhn5+4YSDHNNEiWO5kkiq9hNiJNS8O9WvySvY
         ZN+x5Or0RzmGjIlwN/9zyVeb8lOPPL8rIi8bQxtQBey9saAGzR92x6KU9PirRntE06yQ
         A7sSepnjdi3/qFMNOuAkTm4pPvXdpye7uF5X8NywCus0rLtZ/NxlNe3wIJOCw/IHL/uB
         dD7+krwhqTu9PoAfd93KuSao0qMlUZx0brQJJzUUkFdfUKDXBLO/3rsNdLbwXsfgeKco
         CdWcfA9kcUmdetb62NW5nljI9CFoJRM/4M7k6w/zSf2Jjr/xE7f8m9KOGofP6CQC75kU
         nQrg==
X-Gm-Message-State: AAQBX9enlP1Y+8rGtq/qM27LfmSgVifDc0ljRvL4cL4Ufl3nBRQcKW9U
        kmXQladQhG6zjdJOnr6CnoWpWSCc2iI=
X-Google-Smtp-Source: AKy350a64aWirwKtZfp2hNwUr2/sbk2BHCGDPtQLxA7yvFuGhqlS4CfVlAm0dtCZEFXYfpoboZnvH7OctM8=
X-Received: from reijiw-west4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:aa1])
 (user=reijiw job=sendgmr) by 2002:a05:6902:a8c:b0:b7b:fb15:8685 with SMTP id
 cd12-20020a0569020a8c00b00b7bfb158685mr5290936ybb.9.1680049315012; Tue, 28
 Mar 2023 17:21:55 -0700 (PDT)
Date:   Tue, 28 Mar 2023 17:21:36 -0700
In-Reply-To: <20230329002136.2463442-1-reijiw@google.com>
Mime-Version: 1.0
References: <20230329002136.2463442-1-reijiw@google.com>
X-Mailer: git-send-email 2.40.0.348.gf938b09366-goog
Message-ID: <20230329002136.2463442-3-reijiw@google.com>
Subject: [PATCH v1 2/2] KVM: arm64: PMU: Ensure to trap PMU access from EL0 to EL2
From:   Reiji Watanabe <reijiw@google.com>
To:     Marc Zyngier <maz@kernel.org>,
        Oliver Upton <oliver.upton@linux.dev>, kvmarm@lists.linux.dev
Cc:     kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Ricardo Koller <ricarkol@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        Will Deacon <will@kernel.org>,
        Reiji Watanabe <reijiw@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Currently, with VHE, KVM sets ER, CR, SW and EN bits of
PMUSERENR_EL0 to 1 on vcpu_load().  So, if the value of those bits
are cleared after vcpu_load() (the perf subsystem would do when PMU
counters are programmed for the guest), PMU access from the guest EL0
might be trapped to the guest EL1 directly regardless of the current
PMUSERENR_EL0 value of the vCPU.

With VHE, fix this by setting those bits of the register on every
guest entry (as with nVHE).  Also, opportunistically make the similar
change for PMSELR_EL0, which is cleared by vcpu_load(), to ensure it
is always set to zero on guest entry (PMXEVCNTR_EL0 access might cause
UNDEF at EL1 instead of being trapped to EL2, depending on the value
of PMSELR_EL0).  I think that would be more robust, although I don't
find any kernel code that writes PMSELR_EL0.

Fixes: 83a7a4d643d3 ("arm64: perf: Enable PMU counter userspace access for perf event")
Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/kvm/hyp/include/hyp/switch.h | 29 +++++++++++++------------
 1 file changed, 15 insertions(+), 14 deletions(-)

diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index 44b84fbdde0d..7d39882d8a73 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -74,18 +74,6 @@ static inline void __activate_traps_common(struct kvm_vcpu *vcpu)
 	/* Trap on AArch32 cp15 c15 (impdef sysregs) accesses (EL1 or EL0) */
 	write_sysreg(1 << 15, hstr_el2);
 
-	/*
-	 * Make sure we trap PMU access from EL0 to EL2. Also sanitize
-	 * PMSELR_EL0 to make sure it never contains the cycle
-	 * counter, which could make a PMXEVCNTR_EL0 access UNDEF at
-	 * EL1 instead of being trapped to EL2.
-	 */
-	if (kvm_arm_support_pmu_v3()) {
-		write_sysreg(0, pmselr_el0);
-		vcpu->arch.host_pmuserenr_el0 = read_sysreg(pmuserenr_el0);
-		write_sysreg(ARMV8_PMU_USERENR_MASK, pmuserenr_el0);
-	}
-
 	vcpu->arch.mdcr_el2_host = read_sysreg(mdcr_el2);
 	write_sysreg(vcpu->arch.mdcr_el2, mdcr_el2);
 
@@ -106,8 +94,6 @@ static inline void __deactivate_traps_common(struct kvm_vcpu *vcpu)
 	write_sysreg(vcpu->arch.mdcr_el2_host, mdcr_el2);
 
 	write_sysreg(0, hstr_el2);
-	if (kvm_arm_support_pmu_v3())
-		write_sysreg(vcpu->arch.host_pmuserenr_el0, pmuserenr_el0);
 
 	if (cpus_have_final_cap(ARM64_SME)) {
 		sysreg_clear_set_s(SYS_HFGRTR_EL2, 0,
@@ -130,6 +116,18 @@ static inline void ___activate_traps(struct kvm_vcpu *vcpu)
 
 	if (cpus_have_final_cap(ARM64_HAS_RAS_EXTN) && (hcr & HCR_VSE))
 		write_sysreg_s(vcpu->arch.vsesr_el2, SYS_VSESR_EL2);
+
+	/*
+	 * Make sure we trap PMU access from EL0 to EL2. Also sanitize
+	 * PMSELR_EL0 to make sure it never contains the cycle
+	 * counter, which could make a PMXEVCNTR_EL0 access UNDEF at
+	 * EL1 instead of being trapped to EL2.
+	 */
+	if (kvm_arm_support_pmu_v3()) {
+		write_sysreg(0, pmselr_el0);
+		vcpu->arch.host_pmuserenr_el0 = read_sysreg(pmuserenr_el0);
+		write_sysreg(ARMV8_PMU_USERENR_MASK, pmuserenr_el0);
+	}
 }
 
 static inline void ___deactivate_traps(struct kvm_vcpu *vcpu)
@@ -144,6 +142,9 @@ static inline void ___deactivate_traps(struct kvm_vcpu *vcpu)
 		vcpu->arch.hcr_el2 &= ~HCR_VSE;
 		vcpu->arch.hcr_el2 |= read_sysreg(hcr_el2) & HCR_VSE;
 	}
+
+	if (kvm_arm_support_pmu_v3())
+		write_sysreg(vcpu->arch.host_pmuserenr_el0, pmuserenr_el0);
 }
 
 static inline bool __populate_fault_info(struct kvm_vcpu *vcpu)
-- 
2.40.0.348.gf938b09366-goog

