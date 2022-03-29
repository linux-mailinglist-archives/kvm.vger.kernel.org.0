Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BCEF4EA47B
	for <lists+kvm@lfdr.de>; Tue, 29 Mar 2022 03:14:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229507AbiC2BPA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Mar 2022 21:15:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbiC2BO6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Mar 2022 21:14:58 -0400
Received: from mail-il1-x14a.google.com (mail-il1-x14a.google.com [IPv6:2607:f8b0:4864:20::14a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32C84BC8B
        for <kvm@vger.kernel.org>; Mon, 28 Mar 2022 18:13:12 -0700 (PDT)
Received: by mail-il1-x14a.google.com with SMTP id q6-20020a056e0215c600b002c2c4091914so8771318ilu.14
        for <kvm@vger.kernel.org>; Mon, 28 Mar 2022 18:13:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=jCZIg6oJ3kZxDitZcGMrdotQowBtH5W4mOx7XkPi7gU=;
        b=Rpxf+SKm7n/b4t3VELmOnIJrHiHu9/K+DxCrwRHVjDQj/uWXB71UY5WiD+Umx35Mrh
         qqQFiRV5kP7+fawlWj5HwEmzUjLavw9Yh35YkfGjLNOGttMBCIlL+XYWNjfWLaVWPK0s
         ziJksz3JbOiT28svnSSLBmBkKTLPFtvfWtJ+43pksOYA3zJu9hZMkMmaykbQR76+amaz
         f5+1YpQtLu08mKpkLlMfqrsdCD6eWO+dyr1se94TRSVdOZ7YLmZKeMGkdOv+G80CU/Lw
         VrwB9vhG4zghqgtr0CFB9wp/a9W3ETkNQWTk+eZLKkdbifoX7UXvhdZqWOszhizqTj8K
         Mdog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=jCZIg6oJ3kZxDitZcGMrdotQowBtH5W4mOx7XkPi7gU=;
        b=jOM5+u6RDLE1YX66ozegLqawXJIEZxp+BPlOH/FTO7DVE8hMZfiyotWi5iSDKjfSJh
         9Ph/FLE4Sx1zNOhvttnja6G3caN6a7poXNHvWct4jbGPRYfWytzs+ExKweNAxpKiS+yM
         79h9vLGjtr8NYh7jlNsVoP9nrNseZjxIAKs4tmmdQEpIK7e4UNKQI8vQl4pfKU+VN0Jf
         PVU/8QOAwhJuBknjmS99yPzE2YMU5dFd/X5xduxZOb02UCDWuAUB7M4Nq1OO9NxVHHw8
         OKtCCQSz2ifRGqmSU7XCmw77yn6boAX032416oQIAByRoIvHsI2MY0Fh+X1Pf2Uow8Hk
         oK0w==
X-Gm-Message-State: AOAM532x2C1iYxPH/DQjZsze+U9N5jKZGW+3AH+V5p7zUupOeJT7Hq5T
        Xk5uFwKARALnwjKbdN1jOD7Dnbq4dtg=
X-Google-Smtp-Source: ABdhPJzMiIPF9aog40Q6g1bfGI90vVfRdEF42d1RPWK7+pYd+Ke9O4ykn+bVKN5P0qkUUR1AB+e5+faEfoA=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a6b:e60a:0:b0:646:3e9e:172f with SMTP id
 g10-20020a6be60a000000b006463e9e172fmr7910028ioh.1.1648516392132; Mon, 28 Mar
 2022 18:13:12 -0700 (PDT)
Date:   Tue, 29 Mar 2022 01:13:01 +0000
In-Reply-To: <20220329011301.1166265-1-oupton@google.com>
Message-Id: <20220329011301.1166265-4-oupton@google.com>
Mime-Version: 1.0
References: <20220329011301.1166265-1-oupton@google.com>
X-Mailer: git-send-email 2.35.1.1021.g381101b075-goog
Subject: [PATCH 3/3] KVM: arm64: Start trapping ID registers for 32 bit guests
From:   Oliver Upton <oupton@google.com>
To:     kvmarm@lists.cs.columbia.edu
Cc:     kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Reiji Watanabe <reijiw@google.com>,
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

To date KVM has not trapped ID register accesses from AArch32, meaning
that guests get an unconstrained view of what hardware supports. This
can be a serious problem because we try to base the guest's feature
registers on values that are safe system-wide. Furthermore, KVM does not
implement the latest ISA in the PMU and Debug architecture, so we
constrain these fields to supported values.

Since KVM now correctly handles CP15 and CP10 register traps, we no
longer need to clear HCR_EL2.TID3 for 32 bit guests and will instead
emulate reads with their safe values.

Signed-off-by: Oliver Upton <oupton@google.com>
---
 arch/arm64/include/asm/kvm_emulate.h | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index d62405ce3e6d..fe32b4c8b35b 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -75,14 +75,6 @@ static inline void vcpu_reset_hcr(struct kvm_vcpu *vcpu)
 	if (test_bit(KVM_ARM_VCPU_EL1_32BIT, vcpu->arch.features))
 		vcpu->arch.hcr_el2 &= ~HCR_RW;
 
-	/*
-	 * TID3: trap feature register accesses that we virtualise.
-	 * For now this is conditional, since no AArch32 feature regs
-	 * are currently virtualised.
-	 */
-	if (!vcpu_el1_is_32bit(vcpu))
-		vcpu->arch.hcr_el2 |= HCR_TID3;
-
 	if (cpus_have_const_cap(ARM64_MISMATCHED_CACHE_TYPE) ||
 	    vcpu_el1_is_32bit(vcpu))
 		vcpu->arch.hcr_el2 |= HCR_TID2;
-- 
2.35.1.1021.g381101b075-goog

