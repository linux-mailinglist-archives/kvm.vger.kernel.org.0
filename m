Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F1816A7B23
	for <lists+kvm@lfdr.de>; Thu,  2 Mar 2023 06:54:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230154AbjCBFyV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Mar 2023 00:54:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230148AbjCBFyC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Mar 2023 00:54:02 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E096584B3
        for <kvm@vger.kernel.org>; Wed,  1 Mar 2023 21:52:21 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id e195-20020a25e7cc000000b00a1e59ba7ed9so2970879ybh.11
        for <kvm@vger.kernel.org>; Wed, 01 Mar 2023 21:52:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=hAeigAPYX6PnR/b5lR1z3A0Ou4mZhyXw4iE+Gul5d2w=;
        b=S1M+msyVuazCZC1jdDkuyZB99/+UoLVYJNPhJKpNeE44O4EuVXwpeh9BnXm61qBeb9
         ApoySJ5SBBEcy/KXGkwEeq0SsgXOtPv24dFS8dfs4hEu/GVyxpF0rkDbrhn3MajXaChC
         MC+9c9RB10yvKep1RFvNhhOF9UI3T6u37HtD9hTwGH/DPMQpgpSm1MMRumJJC3olWXN7
         Ch/125Oj7tyI+1HZEP+OLDDxPUNBYg//+JhMCtEedg/mGQ2QvweA4h4Cq4+w6lxsHs/F
         KCGVJg9WVPz8VneF8B+hhahBoOZfB/yGsUsOzGPiDPNVizsbuLwSVtclrHAtjDUmKRD3
         IFWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hAeigAPYX6PnR/b5lR1z3A0Ou4mZhyXw4iE+Gul5d2w=;
        b=c8NHk87BzQg5qUGB5QeKXwMYvT0owr21/hrhDCh0dGsPBpmvPMLdTWPdBlRXOAnFEP
         dHvRALp3GNET6LNwM0j5eziClUUs3nRulTPiKjQLOaQWhfuSoEcjjRE1q4fFjHq3hGEZ
         f7O6j1oclRBOnUuGbfTq4XqK7uI0k/fMf8XF5Y4mfV1N8hfWLm3Y8faKnzPdelxVGTW5
         w/nYMYsBS5iENiuqUToLO42YNCBUKPP9mB/3a3ueY6NvFw6+3xPk/UXgajaAjadoxcm8
         CaPp8Sv/vhAXusQEKXGHOWuKNOUzl/LwihfPwrYyQj1evkFTBVmKYZI/PNvWBiAfE4Fh
         1I3w==
X-Gm-Message-State: AO0yUKWFbZ4E3gFRYRLZExyg93v8YkOczqb5VJUcrHrJIdwZplCkNEAd
        6h2M7enDwV3KAhFMl4a1nq1uS/hKApQ=
X-Google-Smtp-Source: AK7set8SIN82F7pX/7DIs31aOFCLmpZGlyZYmaWI9McxHHG3QjtT/R2ncOCELjAhdRqJsIDoAk0eWd1GuTg=
X-Received: from reijiw-west4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:aa1])
 (user=reijiw job=sendgmr) by 2002:a25:9112:0:b0:9fe:1493:8bb with SMTP id
 v18-20020a259112000000b009fe149308bbmr3722651ybl.13.1677736283390; Wed, 01
 Mar 2023 21:51:23 -0800 (PST)
Date:   Wed,  1 Mar 2023 21:50:33 -0800
In-Reply-To: <20230302055033.3081456-1-reijiw@google.com>
Mime-Version: 1.0
References: <20230302055033.3081456-1-reijiw@google.com>
X-Mailer: git-send-email 2.39.2.722.g9855ee24e9-goog
Message-ID: <20230302055033.3081456-3-reijiw@google.com>
Subject: [PATCH 2/2] KVM: arm64: PMU: Don't save PMCR_EL0.{C,P} for the vCPU
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
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Presently, when a guest writes 1 to PMCR_EL0.{C,P}, which is WO/RAZ,
KVM saves the register value, including these bits.
When userspace reads the register using KVM_GET_ONE_REG, KVM returns
the saved register value as it is (the saved value might have these
bits set).  This could result in userspace setting these bits on the
destination during migration.  Consequently, KVM may end up resetting
the vPMU counter registers (PMCCNTR_EL0 and/or PMEVCNTR<n>_EL0) to
zero on the first KVM_RUN after migration.

Fix this by not saving those bits when a guest writes 1 to those bits.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/kvm/pmu-emul.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index 24908400e190..a5a0a9811ddb 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -538,7 +538,9 @@ void kvm_pmu_handle_pmcr(struct kvm_vcpu *vcpu, u64 val)
 	if (!kvm_pmu_is_3p5(vcpu))
 		val &= ~ARMV8_PMU_PMCR_LP;
 
-	__vcpu_sys_reg(vcpu, PMCR_EL0) = val;
+	/* The reset bits don't indicate any state, and shouldn't be saved. */
+	__vcpu_sys_reg(vcpu, PMCR_EL0) =
+				val & ~(ARMV8_PMU_PMCR_C | ARMV8_PMU_PMCR_P);
 
 	if (val & ARMV8_PMU_PMCR_E) {
 		kvm_pmu_enable_counter_mask(vcpu,
-- 
2.39.2.722.g9855ee24e9-goog

