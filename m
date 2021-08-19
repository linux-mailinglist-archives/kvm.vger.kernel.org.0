Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFBCF3F2334
	for <lists+kvm@lfdr.de>; Fri, 20 Aug 2021 00:36:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236414AbhHSWhZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Aug 2021 18:37:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232906AbhHSWhY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Aug 2021 18:37:24 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83D50C061575
        for <kvm@vger.kernel.org>; Thu, 19 Aug 2021 15:36:47 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id j21-20020a25d2150000b029057ac4b4e78fso7936655ybg.4
        for <kvm@vger.kernel.org>; Thu, 19 Aug 2021 15:36:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=B7ft+C53yDXB0+yPktYYFl4h/nCqhSyvFK9vusSpZaQ=;
        b=wSbb7a2mokCW7Vs5IFUwP7z/yN0MDjb+llO8oOLIteb4rYqrhrSDAD8r0dm2TYxEaU
         foypJs+EmRl/rYnzANu/2VINLqpPj2EDZEFhOdmgKAQLsh0KaF9rMcPDcN/1UV+7kJQI
         INkUs4cEizbVIdRHclAk9zBN/drqrBDSe3UYSKR02DbKbXD6EK/M7A0dIiAjxFc54LGC
         DnfWlorZc82U81Qio71vbTW/wZnCGpoKbXDH3mgFnokwNnIrDsQGvtrvCpfHje7YKdWh
         VFjvUR18CrDWpd9WAn13H0Xwzs1xl8xUMCfetGXNTW/9I1lDUA7LfqgbhinO6UbrYYcL
         z+ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=B7ft+C53yDXB0+yPktYYFl4h/nCqhSyvFK9vusSpZaQ=;
        b=tuUqy9z3ZpfCOILB9CeE7d8l8kT48LqQfO513SapNamO7E6PHGJwKJqaoLY//DqkJJ
         pI3NhDGsJo0lCIhxPH7ML6klyu1r4gNzW0BQcQjMhN6Np+VauIt4deLFYt+7X/VA06iH
         2oeuFoAwPml2of02oWL/jMp++Tonms9G+9oXocm+U3g1gLOTagYrTU2bRXt4zrs3C0Y4
         9ojcg8lNm8FyMGlJSTvSp7YI6wqKRY7IETv3SHle5nl/mbAN4Bz9IQ572EVsExBmcsqC
         yW0R2N1HCoPJ3/KYbYc5fPz5HNjsV1/iPnkyCm37TAGsSmX85IVCpQdYJqUCzoo5PE8M
         GuDA==
X-Gm-Message-State: AOAM530fjg0ukrFjccHhkFkbLoRqQRjQmxqU8yGuif82xc8m89BnI6Ht
        7T5KbZXvwiKPC+ureX780J9PK6EEUdinl99SwXFDYeGl8EPJfxA2wVoMr0KUuK6RwGVP5wZjBYX
        E++GcEjMadYOEabVUkt+ioxqlS6cuGAmhHnffeInglwszdUANZhj9t1CIRw==
X-Google-Smtp-Source: ABdhPJwtsiVe5jRaLujMbQ5x1J3N15UiiWapXS3MYaqiqc1m7Pd0dt6bAARdt2fFZ+uOeGFvehaMJLs0gUE=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a25:d68a:: with SMTP id n132mr20212107ybg.483.1629412606727;
 Thu, 19 Aug 2021 15:36:46 -0700 (PDT)
Date:   Thu, 19 Aug 2021 22:36:37 +0000
In-Reply-To: <20210819223640.3564975-1-oupton@google.com>
Message-Id: <20210819223640.3564975-4-oupton@google.com>
Mime-Version: 1.0
References: <20210819223640.3564975-1-oupton@google.com>
X-Mailer: git-send-email 2.33.0.rc2.250.ged5fa647cd-goog
Subject: [PATCH 3/6] KVM: arm64: Encapsulate reset request logic in a helper function
From:   Oliver Upton <oupton@google.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc:     Marc Zyngier <maz@kernel.org>, Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Andrew Jones <drjones@redhat.com>,
        Oliver Upton <oupton@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In its implementation of the PSCI function, KVM needs to request that a
target vCPU resets before its next entry into the guest. Wrap the logic
for requesting a reset in a function for later use by other implemented
PSCI calls.

No functional change intended.

Signed-off-by: Oliver Upton <oupton@google.com>
---
 arch/arm64/kvm/psci.c | 59 +++++++++++++++++++++++++------------------
 1 file changed, 35 insertions(+), 24 deletions(-)

diff --git a/arch/arm64/kvm/psci.c b/arch/arm64/kvm/psci.c
index 310b9cb2b32b..bb59b692998b 100644
--- a/arch/arm64/kvm/psci.c
+++ b/arch/arm64/kvm/psci.c
@@ -64,9 +64,40 @@ static inline bool kvm_psci_valid_affinity(unsigned long affinity)
 	return !(affinity & ~MPIDR_HWID_BITMASK);
 }
 
-static unsigned long kvm_psci_vcpu_on(struct kvm_vcpu *source_vcpu)
+static void kvm_psci_vcpu_request_reset(struct kvm_vcpu *vcpu,
+					unsigned long entry_addr,
+					unsigned long context_id,
+					bool big_endian)
 {
 	struct vcpu_reset_state *reset_state;
+
+	lockdep_assert_held(&vcpu->kvm->lock);
+
+	reset_state = &vcpu->arch.reset_state;
+	reset_state->pc = entry_addr;
+
+	/* Propagate caller endianness */
+	reset_state->be = big_endian;
+
+	/*
+	 * NOTE: We always update r0 (or x0) because for PSCI v0.1
+	 * the general purpose registers are undefined upon CPU_ON.
+	 */
+	reset_state->r0 = context_id;
+
+	WRITE_ONCE(reset_state->reset, true);
+	kvm_make_request(KVM_REQ_VCPU_RESET, vcpu);
+
+	/*
+	 * Make sure the reset request is observed if the change to
+	 * power_state is observed.
+	 */
+	smp_wmb();
+	vcpu->arch.power_off = false;
+}
+
+static unsigned long kvm_psci_vcpu_on(struct kvm_vcpu *source_vcpu)
+{
 	struct kvm *kvm = source_vcpu->kvm;
 	struct kvm_vcpu *vcpu = NULL;
 	unsigned long cpu_id;
@@ -90,29 +121,9 @@ static unsigned long kvm_psci_vcpu_on(struct kvm_vcpu *source_vcpu)
 			return PSCI_RET_INVALID_PARAMS;
 	}
 
-	reset_state = &vcpu->arch.reset_state;
-
-	reset_state->pc = smccc_get_arg2(source_vcpu);
-
-	/* Propagate caller endianness */
-	reset_state->be = kvm_vcpu_is_be(source_vcpu);
-
-	/*
-	 * NOTE: We always update r0 (or x0) because for PSCI v0.1
-	 * the general purpose registers are undefined upon CPU_ON.
-	 */
-	reset_state->r0 = smccc_get_arg3(source_vcpu);
-
-	WRITE_ONCE(reset_state->reset, true);
-	kvm_make_request(KVM_REQ_VCPU_RESET, vcpu);
-
-	/*
-	 * Make sure the reset request is observed if the change to
-	 * power_state is observed.
-	 */
-	smp_wmb();
-
-	vcpu->arch.power_off = false;
+	kvm_psci_vcpu_request_reset(vcpu, smccc_get_arg2(source_vcpu),
+				    smccc_get_arg3(source_vcpu),
+				    kvm_vcpu_is_be(source_vcpu));
 	kvm_vcpu_wake_up(vcpu);
 
 	return PSCI_RET_SUCCESS;
-- 
2.33.0.rc2.250.ged5fa647cd-goog

