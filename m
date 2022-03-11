Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8797B4D682E
	for <lists+kvm@lfdr.de>; Fri, 11 Mar 2022 18:57:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350497AbiCKR6y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Mar 2022 12:58:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350633AbiCKR6v (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Mar 2022 12:58:51 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BF50A94DB
        for <kvm@vger.kernel.org>; Fri, 11 Mar 2022 09:57:45 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id b11-20020a5b008b000000b00624ea481d55so7932286ybp.19
        for <kvm@vger.kernel.org>; Fri, 11 Mar 2022 09:57:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=iMUX4p8oYYdLskY6YlQfUR43FNfUoWfkZJK4wIrDvVI=;
        b=kbWvR7NSwT//jyD2uA/WkBGtSra3OAWNZLtQDDPfNKfREZh2jH89JBDrkrpTgQ+YNv
         BUozf2+Uo6ONunKNVgwoR5E9m7HxiNyKMvg/WGnR+sSX0XuH3X6nfPaGNxi3vJ37o/lM
         d+e2mKjeL9oPXKYywZpE/b7Xl/51yZO7v1R8Wc8yzsnBcH7u1/IxQKScxbUdOYyJ2EmK
         LOX+JHVm4kFAdEXVqPovN8vrY7fDTjstsHEv/kIjboyaWqWt/BP/PCBTiUiUXfkaA2m/
         FTSD1xnG8bA32t2Mx3cnmlZRYON6s8EvQNUCszZAool1frje4oMd6fFK+SEr9nABWojl
         +9xQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=iMUX4p8oYYdLskY6YlQfUR43FNfUoWfkZJK4wIrDvVI=;
        b=VjJFhT6nTysXOA6sJ2KYcH8vNCfAJIJQFiR1YHiphBaLz+buzeytfpfpiFau83m1lO
         ZjVmntJCyZGrfZcrseWtyagokAV54d+0wyj4g3Io/yqQ9S0iwOQMnCOBeHr/5cNdN7U/
         FHI+vVSjzTZDO28DOojrHf/K2BOYPmFxNA/fItlCyVGn586WpM4wM4faa49b4PNHLGH0
         0CZP2oLl9KFTL1wH77KL/xUjo0cSt+Uya7yiLAznQvWxtVpVY1jMNVZzL3/LjIUIyDyt
         yDEJ9B6JS19OAbaTHY4FolWa6wZtOB/lzJvAC+i7osxCjYcvdKC7LwZyv4REbUGfREpD
         rb7g==
X-Gm-Message-State: AOAM530luwNq31QB61xr9bwjDDY3qyG7O9uDq2DWcN/J+R4Q3n/+3Pi4
        5LK42nNP7D7wkYO/X/mQeEjAs2hFGP0=
X-Google-Smtp-Source: ABdhPJzPRbWq+blf3W5J139AGKxE7e6TJnEjyAP/74A7vawiP9FcCu7oAu7fi1c5ZnCuQttujGbnOdDK+/Y=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a81:d847:0:b0:2d8:1c55:942a with SMTP id
 n7-20020a81d847000000b002d81c55942amr9375589ywl.260.1647021464480; Fri, 11
 Mar 2022 09:57:44 -0800 (PST)
Date:   Fri, 11 Mar 2022 17:57:16 +0000
In-Reply-To: <20220311175717.616958-1-oupton@google.com>
Message-Id: <20220311175717.616958-5-oupton@google.com>
Mime-Version: 1.0
References: <20220311174001.605719-1-oupton@google.com> <20220311175717.616958-1-oupton@google.com>
X-Mailer: git-send-email 2.35.1.723.g4982287a31-goog
Subject: [RFC PATCH kvmtool 4/5] ARM: Add a helper to re-init a vCPU
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
        Will Deacon <will@kernel.org>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
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

Create a helper that can be called to reinitialize a particular vCPU, or
in other words issue the KVM_ARM_VCPU_INIT and KVM_ARM_VCPU_FINALIZE
ioctls accordingly.

Make use of the helper from kvm_cpu__arch_init() after the correct
target/feature set have been identified. Calling KVM_ARM_VCPU_INIT with
the same target more than once is benign.

Signed-off-by: Oliver Upton <oupton@google.com>
---
 arm/kvm-cpu.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/arm/kvm-cpu.c b/arm/kvm-cpu.c
index 1ea56bb..164e399 100644
--- a/arm/kvm-cpu.c
+++ b/arm/kvm-cpu.c
@@ -35,6 +35,15 @@ int kvm_cpu__register_kvm_arm_target(struct kvm_arm_target *target)
 	return -ENOSPC;
 }
 
+static void kvm_cpu__arch_reinit(struct kvm_cpu *vcpu)
+{
+	if (ioctl(vcpu->vcpu_fd, KVM_ARM_VCPU_INIT, &vcpu->init) < 0)
+		die("KVM_ARM_VCPU_INIT failed");
+
+	if (kvm_cpu__configure_features(vcpu))
+		die("Unable to configure requested vcpu features");
+}
+
 struct kvm_cpu *kvm_cpu__arch_init(struct kvm *kvm, unsigned long cpu_id)
 {
 	struct kvm_arm_target *target;
@@ -132,8 +141,7 @@ struct kvm_cpu *kvm_cpu__arch_init(struct kvm *kvm, unsigned long cpu_id)
 	vcpu->cpu_compatible	= target->compatible;
 	vcpu->is_running	= true;
 
-	if (kvm_cpu__configure_features(vcpu))
-		die("Unable to configure requested vcpu features");
+	kvm_cpu__arch_reinit(vcpu);
 
 	return vcpu;
 }
-- 
2.35.1.723.g4982287a31-goog

