Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB8BB414982
	for <lists+kvm@lfdr.de>; Wed, 22 Sep 2021 14:47:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236109AbhIVMs5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Sep 2021 08:48:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235958AbhIVMst (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Sep 2021 08:48:49 -0400
Received: from mail-wr1-x44a.google.com (mail-wr1-x44a.google.com [IPv6:2a00:1450:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E22C8C061762
        for <kvm@vger.kernel.org>; Wed, 22 Sep 2021 05:47:18 -0700 (PDT)
Received: by mail-wr1-x44a.google.com with SMTP id m18-20020adfe952000000b0015b0aa32fd6so2047993wrn.12
        for <kvm@vger.kernel.org>; Wed, 22 Sep 2021 05:47:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=ncTfbrWWXjvnrM1t5gDCcZGArioiisqz5PzMYrE1ABU=;
        b=ZDMybYywTFQQpVUc/dVOu/y6W7gTrKthBO61GH3XhwlQGnlKOClij0roOppKg7XSEP
         clbFYJCsJIFAy0uAppeo3k0ycBs81jPTm7rVX7FizUStIsnee+DvhptZ/GwRqMrqAs3Q
         rWUizLEJWwSDhsZhUC9K5yHWBSdif9a41afkAp+dXp7Y5z3pQnlea4M1mC3XDaq/Wul1
         G9Vq7aJ9v1hVMeLqEkakhEYiOQNmglrJbpo32OI27oT2Ye6gILcdZugwMB46ObzIWWWd
         W2mlR4Ntc+oKd4WPrapVx1fY5arueErTvdM6UfqY7WpNyKQ+meEZY1BoUnQ+RocSMOJs
         ojmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=ncTfbrWWXjvnrM1t5gDCcZGArioiisqz5PzMYrE1ABU=;
        b=l8gmgBdkAS0vd4dhBqebL/+qS5QxGDdHcoRBzoHLBT3OSsYQ1+UEKE+QqB0LK+ni6N
         z8ibWSk4c1xkLeU7QNLTS2s1UayQYLuzTxe6yLPYitILKsd3oBC/jln2fasBRyHALGYN
         6vnDucRukV9L3mUEACsdkafVdnvdAY9Co2rB6XL+blLLO6CCi2Y0X3P3GWDTIwHBrQjS
         UvrjB7Sxqg1jH+ZFH49WXn5vwv8kKgpdQLNyHuhcu8TKVHSEOoFPjXLt7O0eQvXUQfB6
         O+QgkDAYcRTTttihk3202gVP4sJzbdIIFV5/9bdFBv1wr6LdDKsWsaTDwit7/ECs2IEV
         IPyA==
X-Gm-Message-State: AOAM530arW0RiYCBPqwTiQdmkvATpzmQkIkuD3KI5YIYHSIb8z8iOwYK
        +tq9rCYrym4Nfu5K2mnrvWMZhvIjMw==
X-Google-Smtp-Source: ABdhPJyqqbcbmWWxFUAoN0ubpIg901FVokDG3zdESYltfWovzpoZnxktaZaX+Lno4ei5g7zYuT5P8w37yw==
X-Received: from tabba.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:482])
 (user=tabba job=sendgmr) by 2002:adf:db0c:: with SMTP id s12mr360252wri.322.1632314837410;
 Wed, 22 Sep 2021 05:47:17 -0700 (PDT)
Date:   Wed, 22 Sep 2021 13:46:57 +0100
In-Reply-To: <20210922124704.600087-1-tabba@google.com>
Message-Id: <20210922124704.600087-6-tabba@google.com>
Mime-Version: 1.0
References: <20210922124704.600087-1-tabba@google.com>
X-Mailer: git-send-email 2.33.0.464.g1972c5931b-goog
Subject: [PATCH v6 05/12] KVM: arm64: Pass struct kvm to per-EC handlers
From:   Fuad Tabba <tabba@google.com>
To:     kvmarm@lists.cs.columbia.edu
Cc:     maz@kernel.org, will@kernel.org, james.morse@arm.com,
        alexandru.elisei@arm.com, suzuki.poulose@arm.com,
        mark.rutland@arm.com, christoffer.dall@arm.com,
        pbonzini@redhat.com, drjones@redhat.com, oupton@google.com,
        qperret@google.com, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kernel-team@android.com,
        tabba@google.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We need struct kvm to check for protected VMs to be able to pick
the right handlers for them in subsequent patches.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/hyp/include/hyp/switch.h | 4 ++--
 arch/arm64/kvm/hyp/nvhe/switch.c        | 2 +-
 arch/arm64/kvm/hyp/vhe/switch.c         | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index 0397606c0951..733e39f5aaaf 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -403,7 +403,7 @@ static bool kvm_hyp_handle_dabt_low(struct kvm_vcpu *vcpu, u64 *exit_code)
 
 typedef bool (*exit_handler_fn)(struct kvm_vcpu *, u64 *);
 
-static const exit_handler_fn *kvm_get_exit_handler_array(void);
+static const exit_handler_fn *kvm_get_exit_handler_array(struct kvm *kvm);
 
 /*
  * Allow the hypervisor to handle the exit with an exit handler if it has one.
@@ -413,7 +413,7 @@ static const exit_handler_fn *kvm_get_exit_handler_array(void);
  */
 static inline bool kvm_hyp_handle_exit(struct kvm_vcpu *vcpu, u64 *exit_code)
 {
-	const exit_handler_fn *handlers = kvm_get_exit_handler_array();
+	const exit_handler_fn *handlers = kvm_get_exit_handler_array(kern_hyp_va(vcpu->kvm));
 	exit_handler_fn fn;
 
 	fn = handlers[kvm_vcpu_trap_get_class(vcpu)];
diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
index c52d580708e0..49080c607838 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -170,7 +170,7 @@ static const exit_handler_fn hyp_exit_handlers[] = {
 	[ESR_ELx_EC_PAC]		= kvm_hyp_handle_ptrauth,
 };
 
-static const exit_handler_fn *kvm_get_exit_handler_array(void)
+static const exit_handler_fn *kvm_get_exit_handler_array(struct kvm *kvm)
 {
 	return hyp_exit_handlers;
 }
diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
index 0e0d342358f7..34a4bd9f67a7 100644
--- a/arch/arm64/kvm/hyp/vhe/switch.c
+++ b/arch/arm64/kvm/hyp/vhe/switch.c
@@ -108,7 +108,7 @@ static const exit_handler_fn hyp_exit_handlers[] = {
 	[ESR_ELx_EC_PAC]		= kvm_hyp_handle_ptrauth,
 };
 
-static const exit_handler_fn *kvm_get_exit_handler_array(void)
+static const exit_handler_fn *kvm_get_exit_handler_array(struct kvm *kvm)
 {
 	return hyp_exit_handlers;
 }
-- 
2.33.0.464.g1972c5931b-goog

