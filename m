Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF1254C0AE3
	for <lists+kvm@lfdr.de>; Wed, 23 Feb 2022 05:19:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237496AbiBWETi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Feb 2022 23:19:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236919AbiBWETg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Feb 2022 23:19:36 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 696C73B540
        for <kvm@vger.kernel.org>; Tue, 22 Feb 2022 20:19:09 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id d17-20020a253611000000b006244e94b7b4so14044058yba.4
        for <kvm@vger.kernel.org>; Tue, 22 Feb 2022 20:19:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=ahiLAnvGk5WOtmVeGA8iuyeZCq4rGSdqLgd0ZvQyT98=;
        b=BX8y9VlBKsn8jL1RlTr1OBGGetvgQI1VN5gscUGj5PvXkxsZa7UrKQLI20x3uUoO7l
         ncIJvGbFbopGWOm/mzOqa2srOo9k0/7J/0wCD0l0hzyb2ACFqXFzdziavo7hYedyUxSX
         2G1OWLZcKybblkzNl1aDXnnyJ4zm7cxyAVrc1SkOxupJQ54jHriMPA3K5+DoykZJx3+6
         cGjkgTeHFlKqwPaLgFiuAId2JpQ47d5NIPiPVsYPeeYgkVxzI/9tWIHbQw4QcwXyjR3W
         WJbG90pWIu3Kc+kOKVeGCQokZE25D0T8AeN5qTr2SoRYKK2vm291FZYaZUeETUE9hM4/
         2YYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=ahiLAnvGk5WOtmVeGA8iuyeZCq4rGSdqLgd0ZvQyT98=;
        b=xBgqDe261XAYoDZaoTa31xKRvYGQ0N59681rvI+I7lGSn4VfkEMwVpCMoITZ66mD54
         wws32mJ1VjKxIr8ZDm3/hjC0qnpY5ERryLpq6tU/V8qRH2D5zwEnpXn9VF5po5ocjBVf
         th6xRkotEm2FMaJJ4tuwzbeo9dPYA66oChN9Vb8fpv8uGC5qJb3egNb2oKXUwdmO84ao
         DgR3PdSRLadpx2oNdZu5vUNVmDLixPqs3V8QVwMN4AiRfXKY0gmtnbB8R6bK6LOr2RgG
         zpxYph2ebwg7fA/X7sok559ENpm4ZHuTZOrrf5aDJ7meOK6fXm1BCz8zWSX4rmecSHdq
         63Ow==
X-Gm-Message-State: AOAM531rEhw1lMnsa1/k+/jkyYSu3hsxNmg7c5mPz94NtScRJGwdygG7
        wWUyfiwY/EGH4wrZz8AO+o8T3JpEDnE=
X-Google-Smtp-Source: ABdhPJx9rCAmlwDD8ZGLtxOAhcQ0e/5TNwlmLC3bRH71Gh8ABg+5APqO9HlhVqrCvDpcvj9jNZU6c7uzBKk=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a81:9e04:0:b0:2d5:84ae:13c9 with SMTP id
 m4-20020a819e04000000b002d584ae13c9mr26571752ywj.435.1645589948342; Tue, 22
 Feb 2022 20:19:08 -0800 (PST)
Date:   Wed, 23 Feb 2022 04:18:28 +0000
In-Reply-To: <20220223041844.3984439-1-oupton@google.com>
Message-Id: <20220223041844.3984439-4-oupton@google.com>
Mime-Version: 1.0
References: <20220223041844.3984439-1-oupton@google.com>
X-Mailer: git-send-email 2.35.1.473.g83b2b277ed-goog
Subject: [PATCH v3 03/19] KVM: arm64: Reject invalid addresses for CPU_ON PSCI call
From:   Oliver Upton <oupton@google.com>
To:     kvmarm@lists.cs.columbia.edu
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, Peter Shier <pshier@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Raghavendra Rao Ananta <rananta@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Oliver Upton <oupton@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

DEN0022D.b 5.6.2 "Caller responsibilities" states that a PSCI
implementation may return INVALID_ADDRESS for the CPU_ON call if the
provided entry address is known to be invalid. There is an additional
caveat to this rule. Prior to PSCI v1.0, the INVALID_PARAMETERS error
is returned instead. Check the guest's PSCI version and return the
appropriate error if the IPA is invalid.

Reported-by: Reiji Watanabe <reijiw@google.com>
Signed-off-by: Oliver Upton <oupton@google.com>
---
 arch/arm64/kvm/psci.c | 24 ++++++++++++++++++++++--
 1 file changed, 22 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/psci.c b/arch/arm64/kvm/psci.c
index a0c10c11f40e..de1cf554929d 100644
--- a/arch/arm64/kvm/psci.c
+++ b/arch/arm64/kvm/psci.c
@@ -12,6 +12,7 @@
 
 #include <asm/cputype.h>
 #include <asm/kvm_emulate.h>
+#include <asm/kvm_mmu.h>
 
 #include <kvm/arm_psci.h>
 #include <kvm/arm_hypercalls.h>
@@ -70,12 +71,31 @@ static unsigned long kvm_psci_vcpu_on(struct kvm_vcpu *source_vcpu)
 	struct vcpu_reset_state *reset_state;
 	struct kvm *kvm = source_vcpu->kvm;
 	struct kvm_vcpu *vcpu = NULL;
-	unsigned long cpu_id;
+	unsigned long cpu_id, entry_addr;
 
 	cpu_id = smccc_get_arg1(source_vcpu);
 	if (!kvm_psci_valid_affinity(source_vcpu, cpu_id))
 		return PSCI_RET_INVALID_PARAMS;
 
+	/*
+	 * Basic sanity check: ensure the requested entry address actually
+	 * exists within the guest's address space.
+	 */
+	entry_addr = smccc_get_arg2(source_vcpu);
+	if (!kvm_ipa_valid(kvm, entry_addr)) {
+
+		/*
+		 * Before PSCI v1.0, the INVALID_PARAMETERS error is returned
+		 * instead of INVALID_ADDRESS.
+		 *
+		 * For more details, see ARM DEN0022D.b 5.6 "CPU_ON".
+		 */
+		if (kvm_psci_version(source_vcpu) < KVM_ARM_PSCI_1_0)
+			return PSCI_RET_INVALID_PARAMS;
+		else
+			return PSCI_RET_INVALID_ADDRESS;
+	}
+
 	vcpu = kvm_mpidr_to_vcpu(kvm, cpu_id);
 
 	/*
@@ -93,7 +113,7 @@ static unsigned long kvm_psci_vcpu_on(struct kvm_vcpu *source_vcpu)
 
 	reset_state = &vcpu->arch.reset_state;
 
-	reset_state->pc = smccc_get_arg2(source_vcpu);
+	reset_state->pc = entry_addr;
 
 	/* Propagate caller endianness */
 	reset_state->be = kvm_vcpu_is_be(source_vcpu);
-- 
2.35.1.473.g83b2b277ed-goog

