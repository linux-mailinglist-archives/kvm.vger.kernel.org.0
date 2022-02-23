Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 296A64C0AFD
	for <lists+kvm@lfdr.de>; Wed, 23 Feb 2022 05:20:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238104AbiBWEUZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Feb 2022 23:20:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237820AbiBWEUT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Feb 2022 23:20:19 -0500
Received: from mail-il1-x149.google.com (mail-il1-x149.google.com [IPv6:2607:f8b0:4864:20::149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55EBE3ED3A
        for <kvm@vger.kernel.org>; Tue, 22 Feb 2022 20:19:53 -0800 (PST)
Received: by mail-il1-x149.google.com with SMTP id m3-20020a056e02158300b002b6e3d1f97cso11838254ilu.19
        for <kvm@vger.kernel.org>; Tue, 22 Feb 2022 20:19:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=ru51C74AZClZTzPkMtbBN26J3qvHNHAk8kt/SSSWmMQ=;
        b=OS4XgJOpwQ05rzV5Y5XKlGE2N+cY/5pMwS7SY66NR3hjMy7v66RbANk33sAOYp3tiS
         uCs9VBj0u8cL8xzE6/np9O45YnWpkoBtIuvo9DPB8lV4+sUVXugYFhMxiHheAWKyavY+
         LQe2HXwYwDxYT/sfaw+Iv85yF/mrky88GSev4VX3cSbyUbJ2+A209oMf6eHR7Kt+Reh4
         tYDZXGRHMlIWMUia4ZMzVO1+e+mB5rhGTNW0tAWNydhRLHuYA8+ZvA1/zxGmVYtudzKD
         ua960kB7y9v14niOJmF+16P6prZ6RH70x5D8CY5rfVMgMi3/qtfKzeA/daPo9phkD6cY
         sXDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=ru51C74AZClZTzPkMtbBN26J3qvHNHAk8kt/SSSWmMQ=;
        b=OWlE1y8VDqhUV5Fv0v/JjYEzvPWBujsP78FquQ4NRlDiBo6dbfUBIOYUK7FsmTCMHV
         uyHgEvUKY/S6HKP7f2fVgNopekqt/x2QVYCqKK1nLY76oEbmDTtVM+lPHqDY+VOTlOKJ
         VNzoBSODMYX1LrBVUyWRL/Nt9PTz47SCAY/rXnOCz2viFEPfynA7dFx+L5P9dB3KiylO
         L6+bxjgIbscXZH+/T3CK3H0Xbsn+YhG26G3AUPFDUx78LEV4+wY4tHNd3iKvWIGze79T
         ymfpIJf+4Cqcr1h+9yLjQJAhoFEzo6W8hhiFgRnLuzvp3qQ5juTY63Pet3ln0QCxjUNH
         1CaA==
X-Gm-Message-State: AOAM530L451ddjwvJ6g0rnVxnqqg8AAW1PWOJRPo63IJdZXwF6YrOz1D
        YkwnoVyUTqp76K/JzZLLz9MrYEsqlS0=
X-Google-Smtp-Source: ABdhPJxmdauL4bzLhsL5MB3LD8Tti0M1urQAR6rftDmZcqGoRvQzbf3gZpqJRycih4QHhKRBBiVuqbvRidE=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a02:b109:0:b0:314:ba3a:51ef with SMTP id
 r9-20020a02b109000000b00314ba3a51efmr16826519jah.61.1645589992709; Tue, 22
 Feb 2022 20:19:52 -0800 (PST)
Date:   Wed, 23 Feb 2022 04:18:39 +0000
In-Reply-To: <20220223041844.3984439-1-oupton@google.com>
Message-Id: <20220223041844.3984439-15-oupton@google.com>
Mime-Version: 1.0
References: <20220223041844.3984439-1-oupton@google.com>
X-Mailer: git-send-email 2.35.1.473.g83b2b277ed-goog
Subject: [PATCH v3 14/19] KVM: arm64: Raise default PSCI version to v1.1
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

As it turns out, KVM already implements the requirements of PSCI v1.1.
Raise the default PSCI version to v1.1 to actually advertise as such.

Suggested-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Oliver Upton <oupton@google.com>
---
 arch/arm64/kvm/psci.c  | 4 +++-
 include/kvm/arm_psci.h | 3 ++-
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/psci.c b/arch/arm64/kvm/psci.c
index a7de84cec2e4..0b8a603c471b 100644
--- a/arch/arm64/kvm/psci.c
+++ b/arch/arm64/kvm/psci.c
@@ -370,7 +370,7 @@ static int kvm_psci_1_0_call(struct kvm_vcpu *vcpu)
 
 	switch(psci_fn) {
 	case PSCI_0_2_FN_PSCI_VERSION:
-		val = KVM_ARM_PSCI_1_0;
+		val = kvm_psci_version(vcpu);
 		break;
 	case PSCI_1_0_FN_PSCI_FEATURES:
 		feature = smccc_get_arg1(vcpu);
@@ -456,6 +456,7 @@ static int kvm_psci_0_1_call(struct kvm_vcpu *vcpu)
 int kvm_psci_call(struct kvm_vcpu *vcpu)
 {
 	switch (kvm_psci_version(vcpu)) {
+	case KVM_ARM_PSCI_1_1:
 	case KVM_ARM_PSCI_1_0:
 		return kvm_psci_1_0_call(vcpu);
 	case KVM_ARM_PSCI_0_2:
@@ -574,6 +575,7 @@ int kvm_arm_set_fw_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 			return 0;
 		case KVM_ARM_PSCI_0_2:
 		case KVM_ARM_PSCI_1_0:
+		case KVM_ARM_PSCI_1_1:
 			if (!wants_02)
 				return -EINVAL;
 			vcpu->kvm->arch.psci_version = val;
diff --git a/include/kvm/arm_psci.h b/include/kvm/arm_psci.h
index 297645edcaff..68b96c3826c3 100644
--- a/include/kvm/arm_psci.h
+++ b/include/kvm/arm_psci.h
@@ -13,8 +13,9 @@
 #define KVM_ARM_PSCI_0_1	PSCI_VERSION(0, 1)
 #define KVM_ARM_PSCI_0_2	PSCI_VERSION(0, 2)
 #define KVM_ARM_PSCI_1_0	PSCI_VERSION(1, 0)
+#define KVM_ARM_PSCI_1_1	PSCI_VERSION(1, 1)
 
-#define KVM_ARM_PSCI_LATEST	KVM_ARM_PSCI_1_0
+#define KVM_ARM_PSCI_LATEST	KVM_ARM_PSCI_1_1
 
 static inline int kvm_psci_version(struct kvm_vcpu *vcpu)
 {
-- 
2.35.1.473.g83b2b277ed-goog

