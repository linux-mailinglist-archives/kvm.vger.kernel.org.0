Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFC404E35FD
	for <lists+kvm@lfdr.de>; Tue, 22 Mar 2022 02:34:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234686AbiCVBel (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Mar 2022 21:34:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234673AbiCVBek (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Mar 2022 21:34:40 -0400
Received: from mail-il1-x149.google.com (mail-il1-x149.google.com [IPv6:2607:f8b0:4864:20::149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2C041FB53C
        for <kvm@vger.kernel.org>; Mon, 21 Mar 2022 18:33:13 -0700 (PDT)
Received: by mail-il1-x149.google.com with SMTP id o14-20020a92d38e000000b002c7f344af18so5518763ilo.2
        for <kvm@vger.kernel.org>; Mon, 21 Mar 2022 18:33:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=qjnBCMCBFj8PplPtYytxZfhoVlLYfUvFpjjjdycnFWE=;
        b=pII/Xw7Dal4aBB+0PLm2RyxWxoqjmtvsNRZQUUfR8ns77VDJYyDzs2nROTIb/UUqAA
         pOLPYNJLawy0NMA2CTpM/hp7vTo7rIebJsWKYgdAdRvsxw9rBxbE5a2hL+ma38I9AtbL
         xJlNHTMBF+w4lcS3PXcjeCxP1olVlxESHzW0LMS1qpFdc72NqG7R+mndkElUfBpFX7oV
         c0/MgLBIHNm2lFKCG/S3LAAHjSMU9Zlct80kEqajjVsWN0oBRQwd9zgVqwYl4Ecs1z8R
         mRwQw5elwVXfc1hf9Mm1hfeyorNWbGBLLqTIJwPApN5eRiuoSnQ10XVgqx8O4VkWvWoC
         7Ldg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=qjnBCMCBFj8PplPtYytxZfhoVlLYfUvFpjjjdycnFWE=;
        b=Oit9yktsV1vqqVlPgI8ukP3+uU6qUp0duhFQf1+V/mSRRt9LdKD2R+wm5jk9IgNMaM
         cNTdOobWJbWW76OMeUlMycYrQxD4LIqNUQ5FoHpAkLQ4IzopSLxmRU1aOF3w2wzLjaXg
         0W8c5G52uQg/N6q2zX64UqweHqIrvugIeDS8V7bEspxgDoI/cEKlHeJwFZH4zxM7NWy2
         avQENOFqiESHQNBSirUkJdxyLClo3eM+LmTGKn94aNe7RTQXyLLt/hcy3JUFUtScBFeJ
         42ro9PJizakgfN7P5jrgWuWYUF2eSDuJyLyXuP1zE5o/lCNXXwAf5hAe3moSfeThwSBL
         Z+pw==
X-Gm-Message-State: AOAM533UdkWaHWbL5Ebk0QYAn8YBt1U0zyLX0QvcTwMg64yDFTvhbMUA
        Wv8tSdqkMPGLsV/PBIOWMup8XGp1Uhw=
X-Google-Smtp-Source: ABdhPJwbCwwXb7MoS1YP0fzzPvJ9s+3FAN1k0iq644mgxX1DYCS9sZ9azTh6FyvitRYmbm8F1GECFravlPg=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a05:6602:73c:b0:649:5e22:f3ee with SMTP id
 g28-20020a056602073c00b006495e22f3eemr8149186iox.156.1647912792555; Mon, 21
 Mar 2022 18:33:12 -0700 (PDT)
Date:   Tue, 22 Mar 2022 01:33:10 +0000
In-Reply-To: <20220318193831.482349-1-oupton@google.com>
Message-Id: <20220322013310.1880100-1-oupton@google.com>
Mime-Version: 1.0
References: <20220318193831.482349-1-oupton@google.com>
X-Mailer: git-send-email 2.35.1.894.gb6a874cedc-goog
Subject: [PATCH] KVM: arm64: Drop unneeded minor version check from PSCI v1.x handler
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
        Paolo Bonzini <pbonzini@redhat.com>,
        Will Deacon <will@kernel.org>, Oliver Upton <oupton@google.com>
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

We already sanitize the guest's PSCI version when it is being written by
userspace, rejecting unsupported version numbers. Additionally, the
'minor' parameter to kvm_psci_1_x_call() is a constant known at compile
time for all callsites.

Though it is benign, the additional check against the
PSCI kvm_psci_1_x_call() is unnecessary and likely to be missed the next
time KVM raises its maximum PSCI version. Drop the check altogether and
rely on sanitization when the PSCI version is set by userspace.

No functional change intended.

Signed-off-by: Oliver Upton <oupton@google.com>
---

Sorry for not sending this with the other ones. I took another read and
do not believe this check is necessary + might hurt when we raise the
PSCI version again.

Applies on top of the series [1], which itself is based on kvmarm/next
at commit:

  21ea45784275 ("KVM: arm64: fix typos in comments")

[1]: http://lore.kernel.org/r/20220318193831.482349-1-oupton@google.com

 arch/arm64/kvm/psci.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/arch/arm64/kvm/psci.c b/arch/arm64/kvm/psci.c
index 0d771468b708..7cd3fe62275f 100644
--- a/arch/arm64/kvm/psci.c
+++ b/arch/arm64/kvm/psci.c
@@ -315,9 +315,6 @@ static int kvm_psci_1_x_call(struct kvm_vcpu *vcpu, u32 minor)
 	unsigned long val;
 	int ret = 1;
 
-	if (minor > 1)
-		return -EINVAL;
-
 	val = kvm_psci_check_allowed_function(vcpu, psci_fn);
 	if (val)
 		goto out;
-- 
2.35.1.894.gb6a874cedc-goog

