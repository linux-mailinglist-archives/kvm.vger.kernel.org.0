Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C487A6E7114
	for <lists+kvm@lfdr.de>; Wed, 19 Apr 2023 04:19:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231613AbjDSCTK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Apr 2023 22:19:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231577AbjDSCTI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Apr 2023 22:19:08 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42DEF187
        for <kvm@vger.kernel.org>; Tue, 18 Apr 2023 19:19:07 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-54fba72c1adso151083177b3.18
        for <kvm@vger.kernel.org>; Tue, 18 Apr 2023 19:19:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1681870746; x=1684462746;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=z7zzcGDZPbSte4f8fT9vbCw5LuF4xstdxjEG9JI5LdU=;
        b=1BpmpgNYdsRKvRk6qrTEJbdcclnYFCXUZ1sKONbsw5Ac+UIEhNn+Cnjg4xjnCGB5JQ
         Shim51D/sV8i+svuoxMw06bFf0Ucel+aJs/jZJJQ1BNVWu7V4xKCnMR7ZBqzsal8nEcV
         kZiYnCBxW/ZfmJF0FbIPl2er+nfPek/CxhnGqU0yeGxTQkO0OY60TJ9f3whZk7pwzDPA
         rVKqlgZTUyLiVhks/K6jyM9QOfSJkfori6PQ0DzF2ye/sOHYLOlYUmsp0B2Nv5eywmkS
         EwDe+BL0VSwDvG3ugu5GwSLOR0/NsBzFakFVtuLsKy/yuAWsB+PVHPnR285JBPVa1X9+
         hNhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681870746; x=1684462746;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=z7zzcGDZPbSte4f8fT9vbCw5LuF4xstdxjEG9JI5LdU=;
        b=ArqWMhw6uE2lyDEASdiieHWqnv33Hu80t1kS8DEb6WmbMKCJL69PbNhBGzEOskvA/3
         14NX9PJ0sH4QpbYAutbJ9TK8e/QMkwZoCWBNZQMgkx9rT77vpcViiBn73FP+SJyBkfee
         2bawhjdoVR2Ly0ywJZldtoGA9t3Lr6citxOlHxvPzrAz8zMhsAWO3gOnHlbmH+Vwazkd
         iXmwvE9Y1VwWbDym39dN9XQdXVWIov11z7Ki9cFpgSWkiGY60C0f2x0zBue/T3t0NbyI
         ekeSsZDIy0fakQlZ5AaDStMv4ncDaG2ZubEPbamzuCj5UWG3x2Sndlgor7pkeJxGgJ5d
         wFGQ==
X-Gm-Message-State: AAQBX9cGUpm0pAsMTCqHT5fsxh6LHJjQfZOgDLrtrcHsF1v2ThmztGaD
        P7DKL/AsWiB0NMV91Siiv3aHRsrKBPg=
X-Google-Smtp-Source: AKy350Z/I1GCXlm8WzCDIqkLOeoag4XllnSKJRp0ZAYYdDCimf2ANR08QBaZ+Z2bMGMmbTBDeu0l1oEfJ0E=
X-Received: from reijiw-west4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:aa1])
 (user=reijiw job=sendgmr) by 2002:a25:d814:0:b0:b96:7676:db47 with SMTP id
 p20-20020a25d814000000b00b967676db47mr433801ybg.13.1681870746505; Tue, 18 Apr
 2023 19:19:06 -0700 (PDT)
Date:   Tue, 18 Apr 2023 19:18:51 -0700
In-Reply-To: <20230419021852.2981107-1-reijiw@google.com>
Mime-Version: 1.0
References: <20230419021852.2981107-1-reijiw@google.com>
X-Mailer: git-send-email 2.40.0.396.gfff15efe05-goog
Message-ID: <20230419021852.2981107-2-reijiw@google.com>
Subject: [PATCH v1 1/2] KVM: arm64: Acquire mp_state_lock in kvm_arch_vcpu_ioctl_vcpu_init()
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
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

kvm_arch_vcpu_ioctl_vcpu_init() doesn't acquire mp_state_lock
when setting the mp_state to KVM_MP_STATE_RUNNABLE. Fix the
code to acquire the lock.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/kvm/arm.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index fbafcbbcc463..388aa4f18f21 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1244,8 +1244,11 @@ static int kvm_arch_vcpu_ioctl_vcpu_init(struct kvm_vcpu *vcpu,
 	 */
 	if (test_bit(KVM_ARM_VCPU_POWER_OFF, vcpu->arch.features))
 		kvm_arm_vcpu_power_off(vcpu);
-	else
+	else {
+		spin_lock(&vcpu->arch.mp_state_lock);
 		WRITE_ONCE(vcpu->arch.mp_state.mp_state, KVM_MP_STATE_RUNNABLE);
+		spin_unlock(&vcpu->arch.mp_state_lock);
+	}
 
 	return 0;
 }
-- 
2.40.0.396.gfff15efe05-goog

