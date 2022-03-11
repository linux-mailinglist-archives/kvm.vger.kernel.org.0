Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 551244D67CA
	for <lists+kvm@lfdr.de>; Fri, 11 Mar 2022 18:41:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350836AbiCKRmM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Mar 2022 12:42:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348821AbiCKRmK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Mar 2022 12:42:10 -0500
Received: from mail-il1-x14a.google.com (mail-il1-x14a.google.com [IPv6:2607:f8b0:4864:20::14a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDAF21C57EB
        for <kvm@vger.kernel.org>; Fri, 11 Mar 2022 09:41:03 -0800 (PST)
Received: by mail-il1-x14a.google.com with SMTP id k5-20020a926f05000000b002be190db91cso5978705ilc.11
        for <kvm@vger.kernel.org>; Fri, 11 Mar 2022 09:41:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=bb6B842pEmhb30IvOzOiYqYYt77sVbIbggImUmDeV5M=;
        b=h/4vsGpJyL/y/LTn5xTMyoq+QkJyJ59Xi9313T5WhXTIsMtDBSJmbACMzL4slDnoKp
         kIA6/1hycnhNho9//xNJfeaYXzKCjk3Ec5Ix81+73rzg3+OAT+oC3kzOVvW6mo1n6zUF
         GSn+9mH69PuLAsh5LipoiG4W4ivojlNhQRAcxJPaz+xDAH7FW2wBcHAhvZsMyM7Mx3G3
         iPJpoPZgK/JDOZzsZWSvrPPX9QQe3KRS+Y4EEnuAABhwrI/Ia2bfYPkgqssjz0/4AVYN
         mX1ejFS0BmN9ZyhJ1+iy+SQHkAYMdyjJq0+3J58xuAW19dJo3pDpYHv7davgyHzTvXHU
         anTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=bb6B842pEmhb30IvOzOiYqYYt77sVbIbggImUmDeV5M=;
        b=0pWkhiwtW4LwSiU2pURa3x42cgaPHD7VvlEX60NIHsmTIN9qeUlXk9qQB0xytWhfw9
         CKEESq9Aw1+v4uySI3WkHFBTSAwPLew9m9RjnLf7GPROoV2c/cw5rjDno4UPR/ITsH3y
         HSNcgftFxpzC1GsorzHOpegnIjhC3893YzSY/sMHiQutNSCzEUHwk1GyILKvUtkr3lJP
         lmcGQsu/KLw3ZXGwr6VsF0s30c0jBlsCcejTrQf+1+C9hYfsrhluOz/SU/jnlyOgfNwh
         39wNkWXIcrmp6x6wb34+op7VWWS9QqGEsU3ieMLzygFfadleFee3kVPZXCjmCzccE7ob
         JEDQ==
X-Gm-Message-State: AOAM532wbvQN5Lnt1uOeMfWGg5KZY6CLS/FJ1DndbDnocHMf6iUzgKBx
        53+c9HDmiaTBWABeAcMIOL93GsiWaLE=
X-Google-Smtp-Source: ABdhPJy26RVyRtQLKLLzR4hA+MhLcGGs86k+aA8I8jFVqssnsm7zreR/BVCQ4wVXWIAy9nqH55+p8NmX3Xs=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a05:6638:12c3:b0:319:9b70:5ad8 with SMTP id
 v3-20020a05663812c300b003199b705ad8mr9045950jas.132.1647020463061; Fri, 11
 Mar 2022 09:41:03 -0800 (PST)
Date:   Fri, 11 Mar 2022 17:39:48 +0000
In-Reply-To: <20220311174001.605719-1-oupton@google.com>
Message-Id: <20220311174001.605719-3-oupton@google.com>
Mime-Version: 1.0
References: <20220311174001.605719-1-oupton@google.com>
X-Mailer: git-send-email 2.35.1.723.g4982287a31-goog
Subject: [PATCH v4 02/15] KVM: arm64: Generally disallow SMC64 for AArch32 guests
From:   Oliver Upton <oupton@google.com>
To:     kvmarm@lists.cs.columbia.edu
Cc:     alexandru.elisei@arm.com, anup@brainfault.org,
        atishp@atishpatra.org, james.morse@arm.com, jingzhangos@google.com,
        jmattson@google.com, joro@8bytes.org,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org, maz@kernel.org,
        pbonzini@redhat.com, pshier@google.com, rananta@google.com,
        reijiw@google.com, ricarkol@google.com, seanjc@google.com,
        suzuki.poulose@arm.com, vkuznets@redhat.com, wanpengli@tencent.com,
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

It is important to note that the SMC64 flavor of SYSTEM_RESET2
is unintentionally allowed for AArch32 guests without this change.

Signed-off-by: Oliver Upton <oupton@google.com>
Reviewed-by: Reiji Watanabe <reijiw@google.com>
Reviewed-by: Andrew Jones <drjones@redhat.com>
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
2.35.1.723.g4982287a31-goog

