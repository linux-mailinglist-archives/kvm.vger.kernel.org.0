Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B418D417592
	for <lists+kvm@lfdr.de>; Fri, 24 Sep 2021 15:24:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345224AbhIXNZq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Sep 2021 09:25:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345895AbhIXNZB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Sep 2021 09:25:01 -0400
Received: from mail-wr1-x44a.google.com (mail-wr1-x44a.google.com [IPv6:2a00:1450:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 518B2C03401A
        for <kvm@vger.kernel.org>; Fri, 24 Sep 2021 05:54:49 -0700 (PDT)
Received: by mail-wr1-x44a.google.com with SMTP id m18-20020adfe952000000b0015b0aa32fd6so7987346wrn.12
        for <kvm@vger.kernel.org>; Fri, 24 Sep 2021 05:54:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=8jEuEzlbcfPCVXhyDainIX5VC+9wUmsaXxH+UUkLWws=;
        b=aCPwNQiwMH+K/jPh8d1XnhlEyPYKLFzJsCHQMTxy9s76o9j/JzRfStpJOLN3cyALso
         71rB9qEsFuW8yLwe3l7ZVNrQHiU4+FZctlLrDGu2EzVLM8uH1Jn6lSMCSPydgx25l1qz
         ZrhgopWhzr0lIfWQEsKBnB8GIwhByYUOd+Fe1L9voSa0eiIszncBKzGRrIX484+G2qy9
         OiCZsLo27TmIn/vHORUiQbNBsOI1I5YdimAckjJQPa5+AZsKiLiwn3N9iCDNw/yoHoiZ
         mWntjHdWNY3zW4wj7uEK3gz6ifIk/kUymefHxkNkIA1EmTjAgmzS222TFyT0yetEQ4aZ
         l3QA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=8jEuEzlbcfPCVXhyDainIX5VC+9wUmsaXxH+UUkLWws=;
        b=QkmhZmqznfTGjgvKs3c20+RX+uS8wgaMPv46ijjFS3POyLga6z675ELKWNkrT7HUz+
         3Qrmk6r93cPUsI86N5lAz3jP7yBHHd5qV5GCtkluml9g8ETqvN+w+x0CdyVjkPRBAaug
         oGRxRKw14L6Gm0xCAaSzMxs8+Au7yDkUGpaRyAJBJSc53yQWiyD0dh+gTnMRFPFGCkaM
         Mq+vxAll9jSzbU4q9CKl4Rob/OwP2fMZSnMLnGwtl30i/J2pfpGJU5a8jFSiZ62N9wmw
         MpVhKWNWCArWESUGkIAvyna7EYk2pLl28PDMwaEhNykWsyW+dDj/m6wemzmM7LvnQFp/
         Kwnw==
X-Gm-Message-State: AOAM531qEdRNGuhYWkXgMzSNG2d/2B8uLe0dvc/Xdzanus2VEmV4LS0h
        2xa8D5o9V+adwMb4qxPdVMS/Vo/yiQ==
X-Google-Smtp-Source: ABdhPJxUJbh/AE6W9VRAVaudBBE60oECmmozdjammP+VVHJRusaXJiHlbC7xhr44BgjTe/fYyj9xbkoZcQ==
X-Received: from tabba.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:482])
 (user=tabba job=sendgmr) by 2002:a7b:c048:: with SMTP id u8mr1874492wmc.113.1632488087907;
 Fri, 24 Sep 2021 05:54:47 -0700 (PDT)
Date:   Fri, 24 Sep 2021 13:53:51 +0100
In-Reply-To: <20210924125359.2587041-1-tabba@google.com>
Message-Id: <20210924125359.2587041-23-tabba@google.com>
Mime-Version: 1.0
References: <20210924125359.2587041-1-tabba@google.com>
X-Mailer: git-send-email 2.33.0.685.g46640cef36-goog
Subject: [RFC PATCH v1 22/30] KVM: arm64: reduce scope of __guest_enter to
 depend only on kvm_cpu_ctxt
From:   Fuad Tabba <tabba@google.com>
To:     kvmarm@lists.cs.columbia.edu
Cc:     maz@kernel.org, will@kernel.org, james.morse@arm.com,
        alexandru.elisei@arm.com, suzuki.poulose@arm.com,
        mark.rutland@arm.com, christoffer.dall@arm.com, drjones@redhat.com,
        qperret@google.com, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kernel-team@android.com,
        tabba@google.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

guest_enter doesn't need the vcpu, only the guest's kvm_cpu_ctxt.
Reduce its scope to that.

With this commit, the only state in struct vcpu that the
hypervisor needs to save locally in future patches is guest
context (kvm_cpu_context) and the hypervisor state
(vcpu_hyp_state).

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/include/asm/kvm_hyp.h |  2 +-
 arch/arm64/kvm/hyp/entry.S       | 10 ++++------
 arch/arm64/kvm/hyp/nvhe/switch.c |  5 ++++-
 arch/arm64/kvm/hyp/vhe/switch.c  |  5 ++++-
 4 files changed, 13 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_hyp.h
index b379c2b96f33..c5206e958136 100644
--- a/arch/arm64/include/asm/kvm_hyp.h
+++ b/arch/arm64/include/asm/kvm_hyp.h
@@ -100,7 +100,7 @@ void activate_traps_vhe_load(struct vcpu_hyp_state *vcpu_hyps);
 void deactivate_traps_vhe_put(void);
 #endif
 
-u64 __guest_enter(struct kvm_vcpu *vcpu);
+u64 __guest_enter(struct kvm_cpu_context *guest_ctxt);
 
 bool kvm_host_psci_handler(struct kvm_cpu_context *host_ctxt);
 
diff --git a/arch/arm64/kvm/hyp/entry.S b/arch/arm64/kvm/hyp/entry.S
index 8e7033aa5770..f553f184e402 100644
--- a/arch/arm64/kvm/hyp/entry.S
+++ b/arch/arm64/kvm/hyp/entry.S
@@ -18,12 +18,12 @@
 	.text
 
 /*
- * u64 __guest_enter(struct kvm_vcpu *vcpu);
+ * u64 __guest_enter(struct kvm_cpu_context *guest_ctxt);
  */
 SYM_FUNC_START(__guest_enter)
-	// x0: vcpu
+	// x0: guest context (input parameter)
 	// x1-x17: clobbered by macros
-	// x29: guest context
+	// x29: guest context (maintained for call duration)
 
 	adr_this_cpu x1, kvm_hyp_ctxt, x2
 
@@ -47,9 +47,7 @@ alternative_else_nop_endif
 	ret
 
 1:
-	set_loaded_vcpu x0, x1, x2
-
-	add	x29, x0, #VCPU_CONTEXT
+	mov	x29, x0
 
 	// Macro ptrauth_switch_to_guest format:
 	// 	ptrauth_switch_to_guest(guest cxt, tmp1, tmp2, tmp3)
diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
index 483df8fe052e..d9a69e66158c 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -228,8 +228,11 @@ int __kvm_vcpu_run(struct kvm_vcpu *vcpu)
 	__debug_switch_to_guest(vcpu);
 
 	do {
+		struct kvm_cpu_context *hyp_ctxt = this_cpu_ptr(&kvm_hyp_ctxt);
+		set_hyp_running_vcpu(hyp_ctxt, vcpu);
+
 		/* Jump in the fire! */
-		exit_code = __guest_enter(vcpu);
+		exit_code = __guest_enter(guest_ctxt);
 
 		/* And we're baaack! */
 	} while (fixup_guest_exit(vcpu, vgic, &exit_code));
diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
index 64de9f0d7636..5039910a7c80 100644
--- a/arch/arm64/kvm/hyp/vhe/switch.c
+++ b/arch/arm64/kvm/hyp/vhe/switch.c
@@ -142,8 +142,11 @@ static int __kvm_vcpu_run_vhe(struct kvm_vcpu *vcpu)
 	__debug_switch_to_guest(vcpu);
 
 	do {
+		struct kvm_cpu_context *hyp_ctxt = this_cpu_ptr(&kvm_hyp_ctxt);
+		set_hyp_running_vcpu(hyp_ctxt, vcpu);
+
 		/* Jump in the fire! */
-		exit_code = __guest_enter(vcpu);
+		exit_code = __guest_enter(guest_ctxt);
 
 		/* And we're baaack! */
 	} while (fixup_guest_exit(vcpu, vgic, &exit_code));
-- 
2.33.0.685.g46640cef36-goog

