Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 519C1426E38
	for <lists+kvm@lfdr.de>; Fri,  8 Oct 2021 17:58:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243220AbhJHQAk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Oct 2021 12:00:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230365AbhJHQAj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Oct 2021 12:00:39 -0400
Received: from mail-qv1-xf49.google.com (mail-qv1-xf49.google.com [IPv6:2607:f8b0:4864:20::f49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE835C061570
        for <kvm@vger.kernel.org>; Fri,  8 Oct 2021 08:58:43 -0700 (PDT)
Received: by mail-qv1-xf49.google.com with SMTP id p9-20020a05621421e900b003830bb235fbso9031723qvj.14
        for <kvm@vger.kernel.org>; Fri, 08 Oct 2021 08:58:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=25eLjj7S096UhlQv84j+y5ZsIz1F9KN7hX8cPXIiaYA=;
        b=gpL6FgtFQU7IFWTRpKU8iOgdAAyOqI+HTrp/lkYRtI4LxWgISzc4xTuEPeQm5RcPbG
         xcgafVhz5W4y1PzQCXSXCjYS3csvKTlIQ9pG5sjM6O9NeJl4cn4HRqh5sEjM3V/24D41
         n3Jeb14r6NMI62TasyQ7i22EDfUktAHHz95Yu9hsKR1Kz+I7mG5mdI4CRmOy1pNMTJ6/
         lplVCqNArbM8Jf/bD4SGENALBYfA3TN2IyMUZLSnsY1i3iIkQwk+G44eOOvRMOWjDISp
         HonpJQ3lRqZsMA5AzS5wSZ0USyfco97qJ5lhhQJm2w7gsd1VBy3awB/zPL22GrpB7FJr
         8lDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=25eLjj7S096UhlQv84j+y5ZsIz1F9KN7hX8cPXIiaYA=;
        b=S/L90utxUlrAdwSgW8TY/IpHREJD9xSl+KqKbToDQK66kgcsfA4C3e+U+t8QzkZG58
         JAmXaa+Ua7n3BDqsQ3tMQdUGXrFlGq+BQ2E/drqpsdViQlU7Hxn7pNdoG+5ETDxt/6g/
         JpL876u28oEnTzIfuWrEoC3QcPhL+oIwgH6gGolSth7wgabmgXXBEdSlvjCC5TSoxBqm
         U/fsLrZKO1kgpHfJF33JzpE630UYrAEMQzp2tHzoYXaXrdPHtH0xy/AT+9VRC4OQLplp
         3XTsUyHQCa5UlxJWeUsozyQdcDFuVZUKHzejGJanFiVhwDkOLAXrERzwPTJxPMNdM/nY
         2Nww==
X-Gm-Message-State: AOAM530rGqWbjmbkn7oYUT9BxCyg5IB7evUKg5ecDvRm5p+TOiKtyPQm
        NpJbw0bwZsc6Fkj6QDql1IEB/ctppA==
X-Google-Smtp-Source: ABdhPJyTaPc1iTgeWbqlhkYbN2AuKF/xf0Z1BKI6rgM6DA5R+mBinWpvIBC9He9rng/3K6DLqjd+qp1oBg==
X-Received: from tabba.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:482])
 (user=tabba job=sendgmr) by 2002:ac8:7955:: with SMTP id r21mr12500188qtt.6.1633708723038;
 Fri, 08 Oct 2021 08:58:43 -0700 (PDT)
Date:   Fri,  8 Oct 2021 16:58:25 +0100
In-Reply-To: <20211008155832.1415010-1-tabba@google.com>
Message-Id: <20211008155832.1415010-5-tabba@google.com>
Mime-Version: 1.0
References: <20211008155832.1415010-1-tabba@google.com>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
Subject: [PATCH v7 04/11] KVM: arm64: Pass struct kvm to per-EC handlers
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

