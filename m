Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B78763F0C9F
	for <lists+kvm@lfdr.de>; Wed, 18 Aug 2021 22:21:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233681AbhHRUWO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Aug 2021 16:22:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233554AbhHRUWN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Aug 2021 16:22:13 -0400
Received: from mail-qk1-x74a.google.com (mail-qk1-x74a.google.com [IPv6:2607:f8b0:4864:20::74a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F645C061764
        for <kvm@vger.kernel.org>; Wed, 18 Aug 2021 13:21:38 -0700 (PDT)
Received: by mail-qk1-x74a.google.com with SMTP id 21-20020a370815000000b003d5a81a4d12so2618097qki.3
        for <kvm@vger.kernel.org>; Wed, 18 Aug 2021 13:21:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=kvKtrAMG5/B2xy9v8H2FiPsJUDywEb7U/VFv10BGAsU=;
        b=S/1pSOiATU/vW+PQwJSN5RtYqU/6D2RUGu3fWtiYYp8duK0t1St5G0FSkM8hD38t5A
         f9fDCXnfnp8xGPLkX17IQ7ZC8VDhmEsePO90TD5QigC63rzKCk95I1PRIT42jJLHKaGR
         iJc+FrUNTpB+Be0WDgVkn+ZZaB2Dwau03J8XcJR7+L3T9VP9NDePahgbyTVe2Ks06hsT
         LLOo+ALm+OJ1oqMXsD323LdSWFT74NExX6nzIzE4uW6ZrzHTf1B0m6X/YvqsGALCbZ+9
         TRl170pakEEhRXhxkNKgGD1iD92gWK77v/cc5TDq0PFlExib1e2yIitemSbHTxLPXlGF
         iTQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=kvKtrAMG5/B2xy9v8H2FiPsJUDywEb7U/VFv10BGAsU=;
        b=Qu4GLH9q2fHudw4v8Sv3Ac4XZrX4ZI+QF1jcMmneVizC0Egh99eNRdyIIT9eWy92Ki
         pJX6osddepTjqOG+p0p3RV+WPxC/JOBXfYUaSRBirfb0b9EjaHadg5nGlqQK4ObG8OdZ
         zbQfaXyO2eqw/sNU9UM9/GktmYAAD3ZtS2iOan2+lh6n2ufcHcZ9Oo8a48GZTdYCVNMi
         DFDMLWcS+4a6el0og/JnCB5PLQcPYq/JNItl/ThasNXpTQnUFXFKWj2hDPzecdWAsaaL
         XwDXVq58koHVXZjIEnotbehY/31fSbCtiRxsKpCv3fKa/riAwS83HNtqphuhnzMirCi1
         LCDw==
X-Gm-Message-State: AOAM530b5hKrooI1OrIW4pF7TI6x40Q7mN3SqKXjsB7xFs+Kr4JEqKjz
        Oj1HucEy/wWMWvnKwaE+SRhk2IEPR8UsNMg1QsDi2s7mQtMiAyl8dotWS7f/U+DmF0XKOvE2bp5
        2gL0td+3lsmAk0VsiLm63TNjquaULKTvrZUzS645qk+yZVFw8wwg8kMi9Ig==
X-Google-Smtp-Source: ABdhPJzeVUqlbjJkSBQ4IlhwKRJxJl7Np7SGxoszuSv8QX+fTbAJgDGS9IB+KhTQDNDEuqystjSZo6XwBgs=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a05:6214:621:: with SMTP id
 a1mr11008909qvx.12.1629318097796; Wed, 18 Aug 2021 13:21:37 -0700 (PDT)
Date:   Wed, 18 Aug 2021 20:21:31 +0000
In-Reply-To: <20210818202133.1106786-1-oupton@google.com>
Message-Id: <20210818202133.1106786-3-oupton@google.com>
Mime-Version: 1.0
References: <20210818202133.1106786-1-oupton@google.com>
X-Mailer: git-send-email 2.33.0.rc1.237.g0d66db33f3-goog
Subject: [PATCH v2 2/4] KVM: arm64: Handle PSCI resets before userspace
 touches vCPU state
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

The CPU_ON PSCI call takes a payload that KVM uses to configure a
destination vCPU to run. This payload is non-architectural state and not
exposed through any existing UAPI. Effectively, we have a race between
CPU_ON and userspace saving/restoring a guest: if the target vCPU isn't
ran again before the VMM saves its state, the requested PC and context
ID are lost. When restored, the target vCPU will be runnable and start
executing at its old PC.

We can avoid this race by making sure the reset payload is serviced
before userspace can access a vCPU's state.

Fixes: 358b28f09f0a ("arm/arm64: KVM: Allow a VCPU to fully reset itself")
Signed-off-by: Oliver Upton <oupton@google.com>
---
 arch/arm64/kvm/arm.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 0ca72f5cda41..a9763db0d27b 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1219,6 +1219,14 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
 		if (copy_from_user(&reg, argp, sizeof(reg)))
 			break;
 
+		/*
+		 * We could owe a reset due to PSCI. Handle the pending reset
+		 * here to ensure userspace register accesses are ordered after
+		 * the reset.
+		 */
+		if (kvm_check_request(KVM_REQ_VCPU_RESET, vcpu))
+			kvm_reset_vcpu(vcpu);
+
 		if (ioctl == KVM_SET_ONE_REG)
 			r = kvm_arm_set_reg(vcpu, &reg);
 		else
-- 
2.33.0.rc1.237.g0d66db33f3-goog

