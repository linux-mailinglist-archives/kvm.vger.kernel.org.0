Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A1AC6CD038
	for <lists+kvm@lfdr.de>; Wed, 29 Mar 2023 04:40:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229986AbjC2CkP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Mar 2023 22:40:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229972AbjC2CkL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Mar 2023 22:40:11 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 601DF2D4F
        for <kvm@vger.kernel.org>; Tue, 28 Mar 2023 19:40:01 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id z4-20020a25bb04000000b00b392ae70300so14128797ybg.21
        for <kvm@vger.kernel.org>; Tue, 28 Mar 2023 19:40:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680057600;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=g+L6ngmQzqeAkDT2zaXK2CAjwgR4YJ46Vd4xGrMqvOI=;
        b=I8QIadBdOlQ7lazV39hVWI0Kws6dkOboQeyNkOYTnlXnAnszJyff8w0ygPp8su/4Zu
         Nny1qhPbY5EOcYeQP1NkrwbXxY9MfZ9fB9M6RWdP3JzQNJkPujH5JbCWDapX+IxYy7+I
         qnJKGvD4Xsjb2nMJiMKeVTp/IrQWdvZoczS1B0WMdtjAJbNlLBD2BEy198yTua4eFZ7O
         Z+plU+9ITDrs63mqQpAEZZgu718LG4YwwwpdYMpJiczCIS0Hz/f5Pw4NCQFaRQhUGVQu
         f3c+eYfO/VIoCeOqsBFoU4wsPozrWQHpb/ikLkDBG2iATuNEw4LBou028tCKfEyUO5E0
         z9eA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680057600;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=g+L6ngmQzqeAkDT2zaXK2CAjwgR4YJ46Vd4xGrMqvOI=;
        b=vHZF12mGO1DHDTPOAgyhvDVhBCE25urTrDL1TIG9rivbWrZdXh2E+LMIAAGbmZxmtF
         JcCyD0RTJGV+o1NyFrR9fzIUQurEZXl9Sk7sv7L6YBnYyQauC8fpRsrE+hGoDuNHABa3
         2UjxUQe9XbfeiwGLQcPfCj8mGt/KdoIjFJw8MicvOi5AeP8OnDG/+YEC/Zq9yZMZ7u1f
         mbUJ3AgUGg82bHGS6K4eNsaz5kkySBD3+BjeCu/LNjvNGO7R9oedtfQVs40tE8nAbp0c
         bd3J5RvdtPLHmglxTxdiNbHjxHSNRwbKEr98HU2m3U8iaCLM2lej/TKJaKT3cCWSQAG8
         lNQQ==
X-Gm-Message-State: AAQBX9d+s3LU7Z75BLlQ+8iS/XwstH8yN2nEmFMBk0r7C4IHle7fqFDI
        MHTJaNaVdfqqOf09bYGbBHXru3ZkwFQ=
X-Google-Smtp-Source: AKy350Z396WmO5htsaorEF4lDrOAYg2qSUXByMyFmFnN20rjqJnOIXx38KZo3aNWtmyFJDUISkk9iVSdNco=
X-Received: from reijiw-west4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:aa1])
 (user=reijiw job=sendgmr) by 2002:a81:ad05:0:b0:545:fff5:b639 with SMTP id
 l5-20020a81ad05000000b00545fff5b639mr3570058ywh.1.1680057600649; Tue, 28 Mar
 2023 19:40:00 -0700 (PDT)
Date:   Tue, 28 Mar 2023 19:39:44 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.40.0.348.gf938b09366-goog
Message-ID: <20230329023944.2488484-1-reijiw@google.com>
Subject: [PATCH v2] KVM: arm64: PMU: Restore the guest's EL0 event counting
 after migration
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
        Reiji Watanabe <reijiw@google.com>, stable@vger.kernel.org
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

Currently, with VHE, KVM enables the EL0 event counting for the
guest on vcpu_load() or KVM enables it as a part of the PMU
register emulation process, when needed.  However, in the migration
case (with VHE), the same handling is lacking, as vPMU register
values that were restored by userspace haven't been propagated yet
(the PMU events haven't been created) at the vcpu load-time on the
first KVM_RUN (kvm_vcpu_pmu_restore_guest() called from vcpu_load()
on the first KVM_RUN won't do anything as events_{guest,host} of
kvm_pmu_events are still zero).

So, with VHE, enable the guest's EL0 event counting on the first
KVM_RUN (after the migration) when needed.  More specifically,
have kvm_pmu_handle_pmcr() call kvm_vcpu_pmu_restore_guest()
so that kvm_pmu_handle_pmcr() on the first KVM_RUN can take
care of it.

Fixes: d0c94c49792c ("KVM: arm64: Restore PMU configuration on first run")
Cc: stable@vger.kernel.org
Reviewed-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Reiji Watanabe <reijiw@google.com>

---
v2:
 - Added more explanation to the commit message [Marc]
 - Added Marc's r-b tag (Thank you!)

v1: https://lore.kernel.org/all/20230328034725.2051499-1-reijiw@google.com/
---
 arch/arm64/kvm/pmu-emul.c | 1 +
 arch/arm64/kvm/sys_regs.c | 1 -
 2 files changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index 24908400e190..74e0d2b153b5 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -557,6 +557,7 @@ void kvm_pmu_handle_pmcr(struct kvm_vcpu *vcpu, u64 val)
 		for_each_set_bit(i, &mask, 32)
 			kvm_pmu_set_pmc_value(kvm_vcpu_idx_to_pmc(vcpu, i), 0, true);
 	}
+	kvm_vcpu_pmu_restore_guest(vcpu);
 }
 
 static bool kvm_pmu_counter_is_enabled(struct kvm_pmc *pmc)
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 53749d3a0996..425e1e9adae7 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -794,7 +794,6 @@ static bool access_pmcr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 		if (!kvm_supports_32bit_el0())
 			val |= ARMV8_PMU_PMCR_LC;
 		kvm_pmu_handle_pmcr(vcpu, val);
-		kvm_vcpu_pmu_restore_guest(vcpu);
 	} else {
 		/* PMCR.P & PMCR.C are RAZ */
 		val = __vcpu_sys_reg(vcpu, PMCR_EL0)

base-commit: 197b6b60ae7bc51dd0814953c562833143b292aa
-- 
2.40.0.348.gf938b09366-goog

