Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F102A4C0AE6
	for <lists+kvm@lfdr.de>; Wed, 23 Feb 2022 05:19:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237716AbiBWETj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Feb 2022 23:19:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237177AbiBWETh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Feb 2022 23:19:37 -0500
Received: from mail-io1-xd49.google.com (mail-io1-xd49.google.com [IPv6:2607:f8b0:4864:20::d49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05B973B546
        for <kvm@vger.kernel.org>; Tue, 22 Feb 2022 20:19:11 -0800 (PST)
Received: by mail-io1-xd49.google.com with SMTP id e11-20020a5d8e0b000000b006412cf3f627so4230121iod.17
        for <kvm@vger.kernel.org>; Tue, 22 Feb 2022 20:19:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=uWbRYWTJnCUA8B0m1XqBGGOg6aYqCe4xM0wdu1aYSFo=;
        b=bRtQOIBWnzglQDthYZQEg4R64vK2cq/f77YtdtQkrhMtj29gKK28wkyzLwvgdgXxlq
         U/MgFH/VrWkqymNlz2aBFl/uqvxMJBEElXcvrOGGd7f2yeoyZSly9DxJCRIop7YDhD5v
         TvgaN2nxJQH3Y6BQnVszO0fCUPiY1btF3S/xUV1gCpxo7HFoFzHKwBGg4+RJvrZax5d5
         otsZVN27i7gRsxm4mUOeXAt8qgEF4cyMLmHRlSjTVupL999U0egKcdjm7mWMlKFUZJg1
         FX8CiZd1idDFLVGGZK/JZQIn9GfJfFPeqmhaNmCOFcvVorhaWVFoGo24Q2XZXy5iUMe9
         ucHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=uWbRYWTJnCUA8B0m1XqBGGOg6aYqCe4xM0wdu1aYSFo=;
        b=K4tV+EVTMHtEaNnFW12ixr0FP9CmzSj5S/LqQX3rI5BLdhatwsvqQ5Yxr/d3VWsPOa
         1dJwDTsTbuEKcbtnnJLL4mpWSukKNS1rJGqWQ6qMkUxNLyt0tl68ecpR7UK2m4RdR1aH
         eI1BbBiDrB2PX3XCN6afZqTnloswlIhEPZTmOcm8S4bCZ1FuB+Q6zI7vsQqx35ScChgQ
         7aTF03sQMrQ+sdNiWHuPkd0/t7pZ5q9jdD8EqpBxMWygQLFbj0SnujE0pHZMDHN9iVuw
         /QoyKWFMg+gj+bpgpj+l44LqHDhgNYTGkAIZVbUjP5gwdEO/95Z9FE6D7b1/ewRR6yXa
         NszQ==
X-Gm-Message-State: AOAM532oJOAN7DLjYd7BJAa1ygeLSzmyZGEGIU839pA9xL/nM5v4i/tr
        Twx9MX3x7qzTH8fpI9YcRX4nnpW9XY0=
X-Google-Smtp-Source: ABdhPJyvsx2h/KZBIMiFVVSt3DhBBXlspYS8MfSfF2nPMCpfqGuyTsJgaKVrZ1Bx7e3kEjpyTSXSWt1l5gI=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a6b:7d44:0:b0:641:347:477a with SMTP id
 d4-20020a6b7d44000000b006410347477amr10352933ioq.160.1645589950392; Tue, 22
 Feb 2022 20:19:10 -0800 (PST)
Date:   Wed, 23 Feb 2022 04:18:29 +0000
In-Reply-To: <20220223041844.3984439-1-oupton@google.com>
Message-Id: <20220223041844.3984439-5-oupton@google.com>
Mime-Version: 1.0
References: <20220223041844.3984439-1-oupton@google.com>
X-Mailer: git-send-email 2.35.1.473.g83b2b277ed-goog
Subject: [PATCH v3 04/19] KVM: arm64: Clean up SMC64 PSCI filtering for
 AArch32 guests
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
        Oliver Upton <oupton@google.com>,
        Andrew Jones <drjones@redhat.com>
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

The only valid calling SMC calling convention from an AArch32 state is
SMC32. Disallow any PSCI function that sets the SMC64 function ID bit
when called from AArch32 rather than comparing against known SMC64 PSCI
functions.

Signed-off-by: Oliver Upton <oupton@google.com>
Reviewed-by: Reiji Watanabe <reijiw@google.com>
Reviewed-by: Andrew Jones <drjones@redhat.com>
---
 arch/arm64/kvm/psci.c | 14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/kvm/psci.c b/arch/arm64/kvm/psci.c
index de1cf554929d..4335cd5193b8 100644
--- a/arch/arm64/kvm/psci.c
+++ b/arch/arm64/kvm/psci.c
@@ -229,15 +229,11 @@ static void kvm_psci_narrow_to_32bit(struct kvm_vcpu *vcpu)
 
 static unsigned long kvm_psci_check_allowed_function(struct kvm_vcpu *vcpu, u32 fn)
 {
-	switch(fn) {
-	case PSCI_0_2_FN64_CPU_SUSPEND:
-	case PSCI_0_2_FN64_CPU_ON:
-	case PSCI_0_2_FN64_AFFINITY_INFO:
-		/* Disallow these functions for 32bit guests */
-		if (vcpu_mode_is_32bit(vcpu))
-			return PSCI_RET_NOT_SUPPORTED;
-		break;
-	}
+	/*
+	 * Prevent 32 bit guests from calling 64 bit PSCI functions.
+	 */
+	if ((fn & PSCI_0_2_64BIT) && vcpu_mode_is_32bit(vcpu))
+		return PSCI_RET_NOT_SUPPORTED;
 
 	return 0;
 }
-- 
2.35.1.473.g83b2b277ed-goog

