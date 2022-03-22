Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57A464E4617
	for <lists+kvm@lfdr.de>; Tue, 22 Mar 2022 19:35:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234742AbiCVShO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Mar 2022 14:37:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234112AbiCVShN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Mar 2022 14:37:13 -0400
Received: from mail-oo1-xc4a.google.com (mail-oo1-xc4a.google.com [IPv6:2607:f8b0:4864:20::c4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91A8A3CFD3
        for <kvm@vger.kernel.org>; Tue, 22 Mar 2022 11:35:45 -0700 (PDT)
Received: by mail-oo1-xc4a.google.com with SMTP id o136-20020a4a2c8e000000b00321224df797so12103445ooo.20
        for <kvm@vger.kernel.org>; Tue, 22 Mar 2022 11:35:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=3PzR5vzjBym0Xrr1WAh6EkOFmL2w1PsYl+ih5Ad/dqk=;
        b=SGblp6gYJTNQJbOVKJuZHzVH1+KspPybgjStuKKj0ooDhsYubYE8RgbOz71CqIVIjr
         SP/4dvB0b76AjPGSoyzVZ1LBu501I1vwxlx8D1FWgRrsHFXbOuQci+fEdW5XRxq4bGOX
         5rlIbDFc2u7S1S7WTteu0BD6kmSRpMILcW1q6F4oKF0zemBXr5gKSSOuPwbCiLDpRkkP
         2c5b8tXImTSrhnxbW/JVf+0W7g3mBcSg64r10QY+/AJQ+fiXoTxUjbtz1cjBNvw8Aw0F
         Ls0OzeMV1Ac8oK7Yww2DOCYx+7o3/XAGcuiFnV2+o8Wh/vssPQd/XsBMgzi6x8gYr0UT
         yMcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=3PzR5vzjBym0Xrr1WAh6EkOFmL2w1PsYl+ih5Ad/dqk=;
        b=RLnf23eDMmlBdtul1eZfmxUMUydzXrNmrjtPOZeNoMnY0fYfvxPkFRcQRmIC2n4449
         /xpBxQUNcw2R5QPYwWPnsXM8C+81oBfDeUdvy7xR9R66/FaBsYX35wZ8Ps4ChojVQ7xV
         +w3fPKRVndlcxqiCBxL8kFUzbpRA3VAdRZ9rvm+/mdNgs6Cf2lA2zvwoLow/5l4vgmQO
         u9pISHECfCRZJ90hwR7dpbbVOaOTApyPQXY3DY5/p3U7jL8NkE5XEl2wdoOf0dtrDydp
         GR/qzq+LZypCCpk2QhfDDhngOMwV+6ML6j0UFaGZk18JdSZSMDMhtQwyyH6cjCCYV6TR
         q8oA==
X-Gm-Message-State: AOAM5323RIXF3jQfdmvzqAvRtMA3Pk4f60Jdm6Pd97nX7T2T8vzoklC0
        NRZ4OhY309KSYwkaW4JesNtruEoX3m0=
X-Google-Smtp-Source: ABdhPJzn9OAifeYpnFU+SY/qxn1hQQpBef9smelEDXHHVlma7uJiqUTGI5RF9LlKNBUY6ZOaiPTb3GAZ4wE=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a05:6808:1283:b0:2ec:f440:e076 with SMTP id
 a3-20020a056808128300b002ecf440e076mr2801595oiw.157.1647974144916; Tue, 22
 Mar 2022 11:35:44 -0700 (PDT)
Date:   Tue, 22 Mar 2022 18:35:36 +0000
In-Reply-To: <20220322183538.2757758-1-oupton@google.com>
Message-Id: <20220322183538.2757758-2-oupton@google.com>
Mime-Version: 1.0
References: <20220322183538.2757758-1-oupton@google.com>
X-Mailer: git-send-email 2.35.1.894.gb6a874cedc-goog
Subject: [PATCH v2 1/3] KVM: arm64: Generally disallow SMC64 for AArch32 guests
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
        Will Deacon <will@kernel.org>,
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

Note that without this change KVM advertises the SMC64 flavor of
SYSTEM_RESET2 to AArch32 guests.

Fixes: d43583b890e7 ("KVM: arm64: Expose PSCI SYSTEM_RESET2 call to the guest")
Acked-by: Will Deacon <will@kernel.org>
Reviewed-by: Reiji Watanabe <reijiw@google.com>
Reviewed-by: Andrew Jones <drjones@redhat.com>
Signed-off-by: Oliver Upton <oupton@google.com>
---
 arch/arm64/kvm/psci.c | 14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/kvm/psci.c b/arch/arm64/kvm/psci.c
index a433c3eac9b7..cd3ee947485f 100644
--- a/arch/arm64/kvm/psci.c
+++ b/arch/arm64/kvm/psci.c
@@ -216,15 +216,11 @@ static void kvm_psci_narrow_to_32bit(struct kvm_vcpu *vcpu)
 
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
2.35.1.894.gb6a874cedc-goog

