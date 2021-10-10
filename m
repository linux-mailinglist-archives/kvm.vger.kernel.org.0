Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8159A428209
	for <lists+kvm@lfdr.de>; Sun, 10 Oct 2021 16:56:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232758AbhJJO6r (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 10 Oct 2021 10:58:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232740AbhJJO6r (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 10 Oct 2021 10:58:47 -0400
Received: from mail-wr1-x449.google.com (mail-wr1-x449.google.com [IPv6:2a00:1450:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F660C061570
        for <kvm@vger.kernel.org>; Sun, 10 Oct 2021 07:56:48 -0700 (PDT)
Received: by mail-wr1-x449.google.com with SMTP id v15-20020adfa1cf000000b00160940b17a2so11171611wrv.19
        for <kvm@vger.kernel.org>; Sun, 10 Oct 2021 07:56:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=25eLjj7S096UhlQv84j+y5ZsIz1F9KN7hX8cPXIiaYA=;
        b=ffsMRCP9vJs7rknTgWabfjPMV08OT9mRSBP86r3Nfa8tm/IyT58sfpzda2NEQVhdTF
         r8wPA9ToE8b+TaBpLVZXrHcoHPLaDBq4j5j3B7QfsUbLvt9kPGWnwS5gU3YuLQEykWtS
         t4uM7W24nzW3/am8UfEG4mRSb70lrIZFTlzcGd05aCvyohQb6jc3qzdTb62hR5GdblHF
         hz8E8wHC+K20q7MDDR7z1tZYXWMmQPLB4n3UUoBwULWhxyPRFGNL1Vn9Qpqu89oMv12V
         o4M/8cAy+tb9FvvhaxlgdF6RBIYQ0VSniVx60zlLwxHPO4b6f23GRKj2s6B+7YIT7zk3
         Plyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=25eLjj7S096UhlQv84j+y5ZsIz1F9KN7hX8cPXIiaYA=;
        b=cejW3d7yo2EBtls/twuy5pbQLzyMVH27piVCJ8dph++i8RH+u1kyGO33ysoYzqk1FY
         md1XbP3b/czfCoT5YAWnHJSmx1v1e+AXPnqpi/hF/25JpoxkrM+e4a4mGPjtANTQBAwv
         4BDGt+h7Urrg95iAVb9R73BdvX+eXbvHCDCwq6QET5tcKPzhzWYvJ5H+YLiUJ0W1Bpeb
         DyxR3ZOVSTIn83LtMZk5qo+je+S4vEF1+Pf/6Oc5Y/3nR8Vc6UcsKhJEktv42YP2ms6D
         fw60HxNlZF6e0Lpa8VVoRGDFDXBv+QNLkY8xuFS7My4FBOeqTtP8HlaQQz9gX9tOB8PX
         N//Q==
X-Gm-Message-State: AOAM533dj63/KH1TQw1qTwJ2ReS5xSSiXpX+K15dD3cBmcCDYsFJk2sS
        +pzI9zt+RWaPbnxD0J47z2s5lej66w==
X-Google-Smtp-Source: ABdhPJzI0uhdxK/iRI1Zi5E5n9hvogQCkcTFqBsFmKPxfwOCY5UebQ3rx53GN7HiYXKS8VbWpKtlYtouIA==
X-Received: from tabba.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:482])
 (user=tabba job=sendgmr) by 2002:a1c:4484:: with SMTP id r126mr15596115wma.150.1633877807007;
 Sun, 10 Oct 2021 07:56:47 -0700 (PDT)
Date:   Sun, 10 Oct 2021 15:56:29 +0100
In-Reply-To: <20211010145636.1950948-1-tabba@google.com>
Message-Id: <20211010145636.1950948-5-tabba@google.com>
Mime-Version: 1.0
References: <20211010145636.1950948-1-tabba@google.com>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
Subject: [PATCH v8 04/11] KVM: arm64: Pass struct kvm to per-EC handlers
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
index 1e4177322be7..481399bf9b94 100644
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
index 4f3992a1aabd..8c9a0464be00 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -169,7 +169,7 @@ static const exit_handler_fn hyp_exit_handlers[] = {
 	[ESR_ELx_EC_PAC]		= kvm_hyp_handle_ptrauth,
 };
 
-static const exit_handler_fn *kvm_get_exit_handler_array(void)
+static const exit_handler_fn *kvm_get_exit_handler_array(struct kvm *kvm)
 {
 	return hyp_exit_handlers;
 }
diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
index 9aedc8afc8b9..f6fb97accf65 100644
--- a/arch/arm64/kvm/hyp/vhe/switch.c
+++ b/arch/arm64/kvm/hyp/vhe/switch.c
@@ -107,7 +107,7 @@ static const exit_handler_fn hyp_exit_handlers[] = {
 	[ESR_ELx_EC_PAC]		= kvm_hyp_handle_ptrauth,
 };
 
-static const exit_handler_fn *kvm_get_exit_handler_array(void)
+static const exit_handler_fn *kvm_get_exit_handler_array(struct kvm *kvm)
 {
 	return hyp_exit_handlers;
 }
-- 
2.33.0.882.g93a45727a2-goog

