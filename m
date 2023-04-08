Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C98386DB8A6
	for <lists+kvm@lfdr.de>; Sat,  8 Apr 2023 05:50:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229713AbjDHDuG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Apr 2023 23:50:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbjDHDuF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Apr 2023 23:50:05 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFA16CC23
        for <kvm@vger.kernel.org>; Fri,  7 Apr 2023 20:50:03 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id l8-20020a252508000000b00b8c009b9341so5524045ybl.18
        for <kvm@vger.kernel.org>; Fri, 07 Apr 2023 20:50:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680925803; x=1683517803;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=DVyCnj9MsgT2gsR7e3u087HLDuT+lFbQ8wpGn1PCyY8=;
        b=bMzztl++BoxzD0jfOIJzKDjn9QXopp4FEjBZBoErtKInqA2ibekx4/1zj1l0CBGXmH
         N5YQX4LCLiwT1vid3je3dWedfXjTq8I4Bbhqnq3M0RDVclxySyIs0R4NlPYi+RMnMmwh
         XlDTggjdF5V7SThMmLtIB7Qfxi09ZWSlb3j6tAtiKIKPuicshrUbzHR/Xwr40rUq1ZEo
         4YcxfXewagN2HeAwOVEuvWDkKQvshKe9/YBgyZtlCX/mSqAafCQVgDgoopU9v15NPBza
         TiCQiruWJkYyQCmU5QmRKUjiyAe1/wIcUcVAQZXjBBTv/H0vCPjuPxIP7SsPDMiSvCfg
         mV3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680925803; x=1683517803;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DVyCnj9MsgT2gsR7e3u087HLDuT+lFbQ8wpGn1PCyY8=;
        b=cNtlX1wXAhvsPIPLw0RmzChYiSOLHX7xkk8eqv0GnuUv61iIXCQhQzptAY+KVTR2da
         gk1TaZnC/0vxCSy9myl1X9Df4JYm4Y0ZgE8zuAaMOt9JG1dO8VGqOJ/dcWIbRj0JjOjL
         yUxD5eMqRNF9cQO511kr6MkSh9Gpr9GyThfruFK1EsVwx1LZyeDa1JIdzy2FoL9tH/ZW
         iKzdN2EKgHvXb8WYRIalzTsjLoApe3kgef35Dt4/wD+Kd9P0PPrbO8wGXD3KSMrXAFiE
         rzl9oAvNLdeCmIzLLiAlY2j8TFvYWKXd3iVcPfAbWd8SAarjYdUnfOQy+iYV8Mp4yM5F
         sNIA==
X-Gm-Message-State: AAQBX9dL3GOOwEvDUmrOcDNE+4hH5Pn2gEKeI45btwnJkt9hLVyUgt7b
        bgr8+UvRpnXZqGBEyfne4MersrKNUMQ=
X-Google-Smtp-Source: AKy350Y+PbYF40vl+ixnb0m4xqErgoFnHFSj2RsUTGKQeqQhI/G2CUtp/kJ7sXp2+MA0ejuWfd9siouXqzg=
X-Received: from reijiw-west4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:aa1])
 (user=reijiw job=sendgmr) by 2002:a25:740f:0:b0:b09:6f3d:ea1f with SMTP id
 p15-20020a25740f000000b00b096f3dea1fmr3081666ybc.4.1680925803168; Fri, 07 Apr
 2023 20:50:03 -0700 (PDT)
Date:   Fri,  7 Apr 2023 20:47:59 -0700
In-Reply-To: <20230408034759.2369068-1-reijiw@google.com>
Mime-Version: 1.0
References: <20230408034759.2369068-1-reijiw@google.com>
X-Mailer: git-send-email 2.40.0.577.gac1e443424-goog
Message-ID: <20230408034759.2369068-3-reijiw@google.com>
Subject: [PATCH v2 2/2] KVM: arm64: PMU: Don't overwrite PMUSERENR with vcpu loaded
From:   Reiji Watanabe <reijiw@google.com>
To:     Marc Zyngier <maz@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        kvmarm@lists.linux.dev
Cc:     kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Ricardo Koller <ricarkol@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        Shaoqin Huang <shahuang@redhat.com>,
        Rob Herring <robh@kernel.org>,
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
PMUSERENR_EL0 to 1 on vcpu_load(), and saves and restores
the register value for the host on vcpu_load() and vcpu_put().
If the value of those bits are cleared on a pCPU with a vCPU
loaded (armv8pmu_start() would do that when PMU counters are
programmed for the guest), PMU access from the guest EL0 might
be trapped to the guest EL1 directly regardless of the current
PMUSERENR_EL0 value of the vCPU.

Fix this by not letting armv8pmu_start() overwrite PMUSERENR on
the pCPU on which a vCPU is loaded, and instead updating the
saved shadow register value for the host, so that the value can
be restored on vcpu_put() later.

Suggested-by: Mark Rutland <mark.rutland@arm.com>
Suggested-by: Marc Zyngier <maz@kernel.org>
Fixes: 83a7a4d643d3 ("arm64: perf: Enable PMU counter userspace access for perf event")
Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/include/asm/kvm_host.h |  5 +++++
 arch/arm64/kernel/perf_event.c    | 21 ++++++++++++++++++---
 arch/arm64/kvm/pmu.c              | 20 ++++++++++++++++++++
 3 files changed, 43 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index bcd774d74f34..22db2f885c17 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -1028,9 +1028,14 @@ void kvm_arch_vcpu_put_debug_state_flags(struct kvm_vcpu *vcpu);
 #ifdef CONFIG_KVM
 void kvm_set_pmu_events(u32 set, struct perf_event_attr *attr);
 void kvm_clr_pmu_events(u32 clr);
+bool kvm_set_pmuserenr(u64 val);
 #else
 static inline void kvm_set_pmu_events(u32 set, struct perf_event_attr *attr) {}
 static inline void kvm_clr_pmu_events(u32 clr) {}
+static inline bool kvm_set_pmuserenr(u64 val)
+{
+	return false;
+}
 #endif
 
 void kvm_vcpu_load_sysregs_vhe(struct kvm_vcpu *vcpu);
diff --git a/arch/arm64/kernel/perf_event.c b/arch/arm64/kernel/perf_event.c
index dde06c0f97f3..0fffe4c56c28 100644
--- a/arch/arm64/kernel/perf_event.c
+++ b/arch/arm64/kernel/perf_event.c
@@ -741,9 +741,25 @@ static inline u32 armv8pmu_getreset_flags(void)
 	return value;
 }
 
+static void update_pmuserenr(u64 val)
+{
+	lockdep_assert_irqs_disabled();
+
+	/*
+	 * The current pmuserenr value might be the value for the guest.
+	 * If that's the case, have KVM keep tracking of the register value
+	 * for the host EL0 so that KVM can restore it before returning to
+	 * the host EL0. Otherwise, update the register now.
+	 */
+	if (kvm_set_pmuserenr(val))
+		return;
+
+	write_sysreg(val, pmuserenr_el0);
+}
+
 static void armv8pmu_disable_user_access(void)
 {
-	write_sysreg(0, pmuserenr_el0);
+	update_pmuserenr(0);
 }
 
 static void armv8pmu_enable_user_access(struct arm_pmu *cpu_pmu)
@@ -759,8 +775,7 @@ static void armv8pmu_enable_user_access(struct arm_pmu *cpu_pmu)
 			armv8pmu_write_evcntr(i, 0);
 	}
 
-	write_sysreg(0, pmuserenr_el0);
-	write_sysreg(ARMV8_PMU_USERENR_ER | ARMV8_PMU_USERENR_CR, pmuserenr_el0);
+	update_pmuserenr(ARMV8_PMU_USERENR_ER | ARMV8_PMU_USERENR_CR);
 }
 
 static void armv8pmu_enable_event(struct perf_event *event)
diff --git a/arch/arm64/kvm/pmu.c b/arch/arm64/kvm/pmu.c
index 7887133d15f0..40bb2cb13317 100644
--- a/arch/arm64/kvm/pmu.c
+++ b/arch/arm64/kvm/pmu.c
@@ -209,3 +209,23 @@ void kvm_vcpu_pmu_restore_host(struct kvm_vcpu *vcpu)
 	kvm_vcpu_pmu_enable_el0(events_host);
 	kvm_vcpu_pmu_disable_el0(events_guest);
 }
+
+/*
+ * With VHE, keep track of the PMUSERENR_EL0 value for the host EL0 on
+ * the pCPU where vCPU is loaded, since PMUSERENR_EL0 is switched to
+ * the value for the guest on vcpu_load().  The value for the host EL0
+ * will be restored on vcpu_put(), before returning to the EL0.
+ *
+ * Return true if KVM takes care of the register. Otherwise return false.
+ */
+bool kvm_set_pmuserenr(u64 val)
+{
+	struct kvm_cpu_context *hctxt;
+
+	if (!kvm_arm_support_pmu_v3() || !has_vhe() || !kvm_get_running_vcpu())
+		return false;
+
+	hctxt = &this_cpu_ptr(&kvm_host_data)->host_ctxt;
+	ctxt_sys_reg(hctxt, PMUSERENR_EL0) = val;
+	return true;
+}
-- 
2.40.0.577.gac1e443424-goog

