Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 761CA4D67D7
	for <lists+kvm@lfdr.de>; Fri, 11 Mar 2022 18:41:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350835AbiCKRmT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Mar 2022 12:42:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350837AbiCKRmN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Mar 2022 12:42:13 -0500
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 173011C57EA
        for <kvm@vger.kernel.org>; Fri, 11 Mar 2022 09:41:10 -0800 (PST)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-2d726bd83a2so74286237b3.20
        for <kvm@vger.kernel.org>; Fri, 11 Mar 2022 09:41:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=w/UueSoSfkkV5ZaqeN0ZkehJnNoFhHswChR0IcyQwpo=;
        b=TfK01IHyAJv8UjNfgpMHJTRDOcY+rjaLXLwHX8CTPaggNTNSs0HThWZMwPyEW+RH6b
         Df/jtoIuvebeXdJL5qwLz6xDhezAQfiw2Q2Kqlk7SMBqvPfhBdPpqinjwyM6JndYT29J
         T5JEBqfXLSys4nSDeEviHGA23CQ5D40dPJYzfP8su0JbVaUV4U0ohlDz4pUmaPuJM7Xo
         f05u8DHN2kp/671bnZG7AMZ7a+0bvS+xvkBRgOuzxHHtfqq1CcbXJwn8ZtcOsTWUL7MZ
         FPM9x9cuBiYHoNf60PAc9taPpdHg3t5D2RCSUBVSWG+trlTI+MZ93yJFGyuuX9cQfLN8
         sLdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=w/UueSoSfkkV5ZaqeN0ZkehJnNoFhHswChR0IcyQwpo=;
        b=tZT3TTVIA0DfNsDlbS8zzbxyPwJkUez1FDBtT61MuGK1MCzf5UHQe237U6yhFBJI3n
         p2PfQjhX6UFEJQxKhZpLkcsWhWBHnICM1r9InDv/UZKA9ybwwVutfhzdaR83nhNV/jT4
         MkO7F0jTRjOj8jgtNCT/jwqSu/9NbQ5bE++gR7w7BTURQgawBswhX0T6EZHpNGdi2J53
         gPS5lRG0TD1y+s+vH+A98C24RW13tov1NaGBYFtBo1adN6zZ1+45XZaTTcgzhniQmbS5
         jckPQpl21IK42id888kHmq6j+HBpueVrS9LKFb8zbWM68mCRPv3wwaLY2BgLM4z3jAEk
         Tjxg==
X-Gm-Message-State: AOAM530zWu5COFNP0D3JERjdMPxuyMEmuQv3pedW+YC2JbOI4y7TyRdi
        3THoCTCapxtBs/77KPAcfH/SwT92Xgw=
X-Google-Smtp-Source: ABdhPJxoEVMNtFjxHU99BsNcOYHXwhP+US3YZzXI2U5bhTrho6KkLYFgzIovIc/T+wSFvNoNO7bsaIvB9iM=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a5b:dcc:0:b0:628:d6d9:d4bc with SMTP id
 t12-20020a5b0dcc000000b00628d6d9d4bcmr8743678ybr.178.1647020469266; Fri, 11
 Mar 2022 09:41:09 -0800 (PST)
Date:   Fri, 11 Mar 2022 17:39:54 +0000
In-Reply-To: <20220311174001.605719-1-oupton@google.com>
Message-Id: <20220311174001.605719-9-oupton@google.com>
Mime-Version: 1.0
References: <20220311174001.605719-1-oupton@google.com>
X-Mailer: git-send-email 2.35.1.723.g4982287a31-goog
Subject: [PATCH v4 08/15] KVM: arm64: Return a value from check_vcpu_requests()
From:   Oliver Upton <oupton@google.com>
To:     kvmarm@lists.cs.columbia.edu
Cc:     alexandru.elisei@arm.com, anup@brainfault.org,
        atishp@atishpatra.org, james.morse@arm.com, jingzhangos@google.com,
        jmattson@google.com, joro@8bytes.org,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org, maz@kernel.org,
        pbonzini@redhat.com, pshier@google.com, rananta@google.com,
        reijiw@google.com, ricarkol@google.com, seanjc@google.com,
        suzuki.poulose@arm.com, vkuznets@redhat.com, wanpengli@tencent.com,
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

A subsequent change to KVM will introduce a vCPU request that could
result in an exit to userspace. Change check_vcpu_requests() to return a
value and document the function. Unconditionally return 1 for now.

Signed-off-by: Oliver Upton <oupton@google.com>
---
 arch/arm64/kvm/arm.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 7c297ddc8177..8eed0556ccaa 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -648,7 +648,16 @@ void kvm_vcpu_wfi(struct kvm_vcpu *vcpu)
 	preempt_enable();
 }
 
-static void check_vcpu_requests(struct kvm_vcpu *vcpu)
+/**
+ * check_vcpu_requests - check and handle pending vCPU requests
+ * @vcpu:	the VCPU pointer
+ *
+ * Return: 1 if we should enter the guest
+ *	   0 if we should exit to userspace
+ *	   <= 0 if we should exit to userspace, where the return value indicates
+ *	   an error
+ */
+static int check_vcpu_requests(struct kvm_vcpu *vcpu)
 {
 	if (kvm_request_pending(vcpu)) {
 		if (kvm_check_request(KVM_REQ_SLEEP, vcpu))
@@ -678,6 +687,8 @@ static void check_vcpu_requests(struct kvm_vcpu *vcpu)
 			kvm_pmu_handle_pmcr(vcpu,
 					    __vcpu_sys_reg(vcpu, PMCR_EL0));
 	}
+
+	return 1;
 }
 
 static bool vcpu_mode_is_bad_32bit(struct kvm_vcpu *vcpu)
@@ -793,7 +804,8 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 		if (!ret)
 			ret = 1;
 
-		check_vcpu_requests(vcpu);
+		if (ret > 0)
+			ret = check_vcpu_requests(vcpu);
 
 		/*
 		 * Preparing the interrupts to be injected also
-- 
2.35.1.723.g4982287a31-goog

