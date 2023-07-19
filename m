Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B76F75A0DA
	for <lists+kvm@lfdr.de>; Wed, 19 Jul 2023 23:57:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230061AbjGSV5c (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Jul 2023 17:57:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229981AbjGSV5a (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Jul 2023 17:57:30 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F7A81FE2
        for <kvm@vger.kernel.org>; Wed, 19 Jul 2023 14:57:29 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-cfc6bb04c36so91788276.2
        for <kvm@vger.kernel.org>; Wed, 19 Jul 2023 14:57:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1689803848; x=1690408648;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=d3Ht7L7dsVm5KYjvx2fbdO1jyBq4m055oYZLq1pDnXs=;
        b=Ra8+xJNP/sYgyLpaDBs1F288TIvL1tnzWLHFmnzM7/dQqrNn5YcbKDgTbFtPDZD/ha
         K8MFOKEa+OQyC87XpoOeppzZtaRCkoHPRaR+wC1YoKWuo1BAl875kJyfty5HOfA/hD9+
         DfLJhptuW65V2HY78jzcImh3piPxWnQw9n9gcwz97bbRazS7jcez6cAmtuqzFBjG12+w
         mtv2cEj7lNF4fu2yhTlpdewK1595/OJ//S3L+ici78yhdckGjZky1+pC4CyEGkAidHWm
         IBziZwUK+XXVoHgvync2hHaby+uusAd+25S0ybYENq7qI1Wh9pAbi7wcu7J7bvZIarxv
         g/Fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689803848; x=1690408648;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=d3Ht7L7dsVm5KYjvx2fbdO1jyBq4m055oYZLq1pDnXs=;
        b=cndAktGc2gHPKIIsrCNeUVUOb1CNCR4ZuIqG1VNVAcO053pFW0R0QZagOYK+9ql0sQ
         ORobCTwnv1LPQPWIOiXPcwjm2Xtmty/SblbUjBGlNrL7JoZa759BGYRzvcM8wVeXSz2b
         xGkyMzfA2emBr6vOYCN/3igYuYuq6lCAolVO+Hh69IZXD0aTUVGs+gFUp/Dw9ksk7eQy
         rladE8eG+DoaZlYUIKQZ7IJYEPnyTOFJw/h1Sh2sGjl1XzmP3y7M+XZd9ivFkqw1Mi04
         dA6l6OZ7Y96QoKvNlRgdXZZLKbYchLxPkW4ykd2NbACtHb/iitXNd7emiC90J7AmJhf0
         58DA==
X-Gm-Message-State: ABy/qLZZJ7vI4MSizHJHZ4mFQsAV4N8Go+QtxpIYlp95Dvnqpknd/9gQ
        QvgF4Vjt533UV0BzzS+/fCzNvd3hGHWm
X-Google-Smtp-Source: APBJJlFhBf7IMPO6XHr8iP300gZpPf9iE5qcascfXqirJteE6s/G8oXQ/YGVmqERwG2BAFqqgzagvO/iZ6Qg
X-Received: from rananta-linux.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:22b5])
 (user=rananta job=sendgmr) by 2002:a5b:352:0:b0:cc7:b850:7f2 with SMTP id
 q18-20020a5b0352000000b00cc7b85007f2mr30000ybp.5.1689803848368; Wed, 19 Jul
 2023 14:57:28 -0700 (PDT)
Date:   Wed, 19 Jul 2023 21:57:25 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.41.0.487.g6d72f3e995-goog
Message-ID: <20230719215725.799162-1-rananta@google.com>
Subject: [PATCH v2] KVM: arm64: Fix hardware enable/disable flows for pKVM
From:   Raghavendra Rao Ananta <rananta@google.com>
To:     Oliver Upton <oliver.upton@linux.dev>,
        Marc Zyngier <maz@kernel.org>
Cc:     James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Will Deacon <will@kernel.org>, Fuad Tabba <tabba@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Colton Lewis <coltonlewis@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When running in protected mode, the hyp stub is disabled after pKVM is
initialized, meaning the host cannot enable/disable the hyp at
runtime. As such, kvm_arm_hardware_enabled is always 1 after
initialization, and kvm_arch_hardware_enable() never enables the vgic
maintenance irq or timer irqs.

Unconditionally enable/disable the vgic + timer irqs in the respective
calls, instead relying on the percpu bookkeeping in the generic code
to keep track of which cpus have the interrupts unmasked.

Fixes: 466d27e48d7c ("KVM: arm64: Simplify the CPUHP logic")
Reported-by: Oliver Upton <oliver.upton@linux.dev>
Suggested-by: Oliver Upton <oliver.upton@linux.dev>
Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
---
 arch/arm64/kvm/arm.c | 14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index c2c14059f6a8..010ebfa69650 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1867,14 +1867,10 @@ static void _kvm_arch_hardware_enable(void *discard)
 
 int kvm_arch_hardware_enable(void)
 {
-	int was_enabled = __this_cpu_read(kvm_arm_hardware_enabled);
-
 	_kvm_arch_hardware_enable(NULL);
 
-	if (!was_enabled) {
-		kvm_vgic_cpu_up();
-		kvm_timer_cpu_up();
-	}
+	kvm_vgic_cpu_up();
+	kvm_timer_cpu_up();
 
 	return 0;
 }
@@ -1889,10 +1885,8 @@ static void _kvm_arch_hardware_disable(void *discard)
 
 void kvm_arch_hardware_disable(void)
 {
-	if (__this_cpu_read(kvm_arm_hardware_enabled)) {
-		kvm_timer_cpu_down();
-		kvm_vgic_cpu_down();
-	}
+	kvm_timer_cpu_down();
+	kvm_vgic_cpu_down();
 
 	if (!is_protected_kvm_enabled())
 		_kvm_arch_hardware_disable(NULL);
-- 
2.41.0.487.g6d72f3e995-goog

