Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 690A04C0B06
	for <lists+kvm@lfdr.de>; Wed, 23 Feb 2022 05:20:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238127AbiBWEUc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Feb 2022 23:20:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238076AbiBWEUZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Feb 2022 23:20:25 -0500
Received: from mail-il1-x14a.google.com (mail-il1-x14a.google.com [IPv6:2607:f8b0:4864:20::14a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 729273B550
        for <kvm@vger.kernel.org>; Tue, 22 Feb 2022 20:19:58 -0800 (PST)
Received: by mail-il1-x14a.google.com with SMTP id k5-20020a926f05000000b002be190db91cso11819798ilc.11
        for <kvm@vger.kernel.org>; Tue, 22 Feb 2022 20:19:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=mNL+HTBUZ2MsABidwZFWaxMTNZTxqHsDRZZiQtVvY9U=;
        b=AnT6yz+jzBN+vZRmnnU3kjwLqiu3bJDpwtLDuddpuszcgrqzqhSXZ5D1upnUqYuCgs
         cXEK3U2pvCizUZ0UOIi8jHCh1VfC1GrM2HmD4ZnPWkMB9rZYWd1Enk2vqA2A5xy9wsxO
         E+mzny0LNc3xOzqkH6jLQ6R6qWfKPKw5X6meGW7xSAAj4zTNi3xO+sqccqedCgV8qCga
         fRhznPV4YXuu1WR1IUaOU8J9Rn4uHJd5964/doZzZDIhtH9+RsKPPYkg27TRddFJFG4Z
         n0CAbnRU8DaEdayNrTP6vjkeXhqvahh7ZEHhS4VszZ1JckMmkqsx3O8STOTwXgaHOQ6A
         4s2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=mNL+HTBUZ2MsABidwZFWaxMTNZTxqHsDRZZiQtVvY9U=;
        b=ywF4pcABg+YDRmPRgdtk02iGBYYgy/L1TQprmQeqetP0H9xchzMQzIm7LpxiKYZDQu
         oD1VAS+dk7sI/Dq6JyJwBS+CE2+Dx9IDZ5QydeFQiRe5VZlUr3EyxKgX9790VXz/rNX4
         oWJT25bO5Aw/vC9NQwcyWKrUj+HkvAb0yeD54tQeNfJm0DUJA/W7wS6fd2wZIFqT9RNZ
         jQi3MrjpN9YMViMhyu8UpHnLpX3LGf85Weu+6uEQIWbMGkq1s+sUZi6pH+BWGjWkSTnJ
         Kdn8afZ2JWx5Q62ZVRXSG98ePkUZsvZ3ntjah9WP08xbSSF3pPPrjibLnzjvnxJco4YA
         H1SA==
X-Gm-Message-State: AOAM531YDDrVRREbQKlrFOFpGHQOCqgOaKYfxtH6GEb5i1tXZtQ/iVtO
        hhhtym8ga/TY60OXdenjL3KW+oZ1OL4=
X-Google-Smtp-Source: ABdhPJw0kP0Dlf52lvVcBVnZ85OYD33u0JUbWlmw8FKgmBU6fU3nlvm/brYHvzUYLCy9kdMtFX8SXw/pFCk=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a02:b048:0:b0:311:85be:a797 with SMTP id
 q8-20020a02b048000000b0031185bea797mr21012184jah.284.1645589997820; Tue, 22
 Feb 2022 20:19:57 -0800 (PST)
Date:   Wed, 23 Feb 2022 04:18:42 +0000
In-Reply-To: <20220223041844.3984439-1-oupton@google.com>
Message-Id: <20220223041844.3984439-18-oupton@google.com>
Mime-Version: 1.0
References: <20220223041844.3984439-1-oupton@google.com>
X-Mailer: git-send-email 2.35.1.473.g83b2b277ed-goog
Subject: [PATCH v3 17/19] selftests: KVM: Use KVM_SET_MP_STATE to power off
 vCPU in psci_test
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

Setting a vCPU's MP state to KVM_MP_STATE_STOPPED has the effect of
powering off the vCPU. Rather than using the vCPU init feature flag, use
the KVM_SET_MP_STATE ioctl to power off the target vCPU.

Signed-off-by: Oliver Upton <oupton@google.com>
---
 tools/testing/selftests/kvm/aarch64/psci_test.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/aarch64/psci_test.c b/tools/testing/selftests/kvm/aarch64/psci_test.c
index 8c998f0b802c..fe1d5d343a2f 100644
--- a/tools/testing/selftests/kvm/aarch64/psci_test.c
+++ b/tools/testing/selftests/kvm/aarch64/psci_test.c
@@ -60,6 +60,15 @@ static void guest_main(uint64_t target_cpu)
 	GUEST_DONE();
 }
 
+static void vcpu_power_off(struct kvm_vm *vm, uint32_t vcpuid)
+{
+	struct kvm_mp_state mp_state = {
+		.mp_state = KVM_MP_STATE_STOPPED,
+	};
+
+	vcpu_set_mp_state(vm, vcpuid, &mp_state);
+}
+
 int main(void)
 {
 	uint64_t target_mpidr, obs_pc, obs_x0;
@@ -75,12 +84,12 @@ int main(void)
 	init.features[0] |= (1 << KVM_ARM_VCPU_PSCI_0_2);
 
 	aarch64_vcpu_add_default(vm, VCPU_ID_SOURCE, &init, guest_main);
+	aarch64_vcpu_add_default(vm, VCPU_ID_TARGET, &init, guest_main);
 
 	/*
 	 * make sure the target is already off when executing the test.
 	 */
-	init.features[0] |= (1 << KVM_ARM_VCPU_POWER_OFF);
-	aarch64_vcpu_add_default(vm, VCPU_ID_TARGET, &init, guest_main);
+	vcpu_power_off(vm, VCPU_ID_TARGET);
 
 	get_reg(vm, VCPU_ID_TARGET, KVM_ARM64_SYS_REG(SYS_MPIDR_EL1), &target_mpidr);
 	vcpu_args_set(vm, VCPU_ID_SOURCE, 1, target_mpidr & MPIDR_HWID_BITMASK);
-- 
2.35.1.473.g83b2b277ed-goog

