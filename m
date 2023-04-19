Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2851A6E7115
	for <lists+kvm@lfdr.de>; Wed, 19 Apr 2023 04:19:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231617AbjDSCTM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Apr 2023 22:19:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231588AbjDSCTL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Apr 2023 22:19:11 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B90BC7
        for <kvm@vger.kernel.org>; Tue, 18 Apr 2023 19:19:09 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-54c17fb245dso335116907b3.21
        for <kvm@vger.kernel.org>; Tue, 18 Apr 2023 19:19:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1681870748; x=1684462748;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=xOVoOXEuKgQg2tBCLrjO+Ie6Feguqmtzji3r08inyQ8=;
        b=GBpDxzuZ8iJftmRFbQ4u416CLpAaocgcZ258FLuBJdT5LXUXVoFni09Eq8Jyypgsdi
         i3e3mWkR61bQcOBiE2Na5nyLZ9Vodg+T18Ab03ypVpChrLseDg7l+pl9A/nIiyCxU2oa
         rXUs/G8SdfeIcRJ9MrRo96XWQfkkPzlaaoYvG8YVrySHFFhSYSJlQNXpboOcNU7QnRi2
         N23NYdPybyffUM3dTo4131YLhg/3VGFXDfAx0oFFH9pojA5Pwdv2A7+FS+yWFrvLJImB
         EZfnFhoF34L7GoYAEWgrIRv2pu3Dzo4nE9mWrei7GCzVdLnkXrcmMY5eeBzO40mvwy/g
         rw+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681870748; x=1684462748;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xOVoOXEuKgQg2tBCLrjO+Ie6Feguqmtzji3r08inyQ8=;
        b=WrAWDfvzVlCvIRxRNys3kpqFfRiOm+RpXoyhSUCAc8Dd9zXhDNr/g3dfw7yMJNuA0l
         dPmWS+IbQcGjYynyFbTj0UXEoEz8kDyKBDPS2MkjzV8Yxctvjsmru4u1lBBbDtpmpmZb
         pJhEA4T52NOitkRg/swHKSy3rESL+WI7dyZ8Ux5eezLTaUuhYUHM99/FMSlp3iacl5pp
         Ljb4K0HVlZ6PI+Uol+1hYBaujnfMsGN+WdGOn+qhX5pfg0vvWx7xZvkkAR4Pc5BspL5F
         f2u7rFVF6Kc5NphaI5D/p4CYlvSDU6i2B+6UmGOXr1UVyVQlCxpoZy32MSJo5KL8lJTF
         usAw==
X-Gm-Message-State: AAQBX9cXGNe9HkByBGUTRSSM3Msu6p+bHPNbDdNAKw1nJ/LPhzFqX7JR
        Bg/wvGHSSa14G7cebSCvpDg1Wi2vG3A=
X-Google-Smtp-Source: AKy350ZAJNC+m10rAkRY8MhHkLcGAFWbMx7c2WWQF2YMC1seAPFdQ+q3ICVHOmnhHJFjhA4DMarFTvB+Emo=
X-Received: from reijiw-west4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:aa1])
 (user=reijiw job=sendgmr) by 2002:a25:d68c:0:b0:b92:25bf:a6ba with SMTP id
 n134-20020a25d68c000000b00b9225bfa6bamr7234069ybg.6.1681870748829; Tue, 18
 Apr 2023 19:19:08 -0700 (PDT)
Date:   Tue, 18 Apr 2023 19:18:52 -0700
In-Reply-To: <20230419021852.2981107-1-reijiw@google.com>
Mime-Version: 1.0
References: <20230419021852.2981107-1-reijiw@google.com>
X-Mailer: git-send-email 2.40.0.396.gfff15efe05-goog
Message-ID: <20230419021852.2981107-3-reijiw@google.com>
Subject: [PATCH v1 2/2] KVM: arm64: Have kvm_psci_vcpu_on() use WRITE_ONCE()
 to update mp_state
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

All accessors of kvm_vcpu_arch::mp_state should be {READ,WRITE}_ONCE(),
since readers of the mp_state don't acquire the mp_state_lock.
Nonetheless, kvm_psci_vcpu_on() updates the mp_state without using
WRITE_ONCE(). So, fix the code to update the mp_state using WRITE_ONCE.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/kvm/psci.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/psci.c b/arch/arm64/kvm/psci.c
index 5767e6baa61a..d046e82e3723 100644
--- a/arch/arm64/kvm/psci.c
+++ b/arch/arm64/kvm/psci.c
@@ -110,7 +110,7 @@ static unsigned long kvm_psci_vcpu_on(struct kvm_vcpu *source_vcpu)
 	 */
 	smp_wmb();
 
-	vcpu->arch.mp_state.mp_state = KVM_MP_STATE_RUNNABLE;
+	WRITE_ONCE(vcpu->arch.mp_state.mp_state, KVM_MP_STATE_RUNNABLE);
 	kvm_vcpu_wake_up(vcpu);
 
 out_unlock:
-- 
2.40.0.396.gfff15efe05-goog

