Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06EE63DFD82
	for <lists+kvm@lfdr.de>; Wed,  4 Aug 2021 10:59:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236939AbhHDI7M (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Aug 2021 04:59:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236871AbhHDI7I (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Aug 2021 04:59:08 -0400
Received: from mail-qt1-x84a.google.com (mail-qt1-x84a.google.com [IPv6:2607:f8b0:4864:20::84a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3F71C0613D5
        for <kvm@vger.kernel.org>; Wed,  4 Aug 2021 01:58:55 -0700 (PDT)
Received: by mail-qt1-x84a.google.com with SMTP id h18-20020ac856920000b029025eb726dd9bso747410qta.8
        for <kvm@vger.kernel.org>; Wed, 04 Aug 2021 01:58:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=xEsi9T4OqglNe742KkivPaDxPwp3ZoFaFAtWROXbBVo=;
        b=ChSZQBwkJB66ulFJ3pUxF49mjFQq4MBi3vZvx3rv+9LE+Wi7bTs1eRJQzexlr+JRSY
         n8GGWqtHE6Gj0UzXp8u7OVcee5UjmtXgNekWCLLa5kYlfHloNwdxCdc+Ct0rKHZ9H5MS
         Lkfrmt/805DmNFA9xjBhD6iryqm8HFC8yEIAfGsd6QT62XFkkQdbUnqv+KeQRQQcaoKc
         ooADx9GQgfZmou14MKEHG/t4rhEESUtzhs6w4fmnvAlQZTc1x6TOFShLv0Ltd4CyQ4mp
         W5tQu0tDthrEE4M9igHoxYjuLR+gA4eHJ/5/Iob0qnQunOUx/bJFNJrWm1phkPrntUr2
         kgbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=xEsi9T4OqglNe742KkivPaDxPwp3ZoFaFAtWROXbBVo=;
        b=La8/gsP9SY7aA8dKh9DsYIRUOzqbP5dFCFQpnX9tSTs75YOyRRgTrba/RJzN+0EVom
         OfZNWp4iF3fFf/kIuV5+hP2ttT5k9Su5oTSwmthIEZFAyKqVUuvzEoC3l7HTeqf/a+Ix
         D05Y+Sa2Bn5/tvxb6sZc3EN38gLdzkXowXZSeL9BkoBjZgawmlZn7EsSlwB1TYMSgXxE
         e5AcNaX8iH09O9RQZhv40O4sQ3q1lCBZQhsl0sJC9LtFLEZJadNTnap77UjsMgavci1V
         fgQkNSM/xTv5jg6Qrpe50eZBGusc0JDTtwtMJmD0R2m6fq8sS9XhUy0hUlgJLxgdmX8G
         FOgg==
X-Gm-Message-State: AOAM531lEIR6kXTZQa5XJqS79g53m8dFFuSWETCfUWJkC9WfdKx3j7AN
        Tvpr9gbfc4Qr5FmaktqAWmPCJ52HWutV+m3KOO9ZPMeB5hntuem/ConYt69VKiGNAmhC92UmIli
        eSq+7sp9LUAGbq+Q0TcxQlk1D8P1InTUMtDtiEpBthXc6CBAfJtBa7AVlLg==
X-Google-Smtp-Source: ABdhPJw4uOQBnarbZ8Pq5S9gvLmcNwTMIjaIMpvh+qw/OSoRZsXJkePXii8fJVoN7ZA8FRpp8uLdyyoJ81g=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a05:6214:104b:: with SMTP id
 l11mr25726502qvr.40.1628067534598; Wed, 04 Aug 2021 01:58:54 -0700 (PDT)
Date:   Wed,  4 Aug 2021 08:58:16 +0000
In-Reply-To: <20210804085819.846610-1-oupton@google.com>
Message-Id: <20210804085819.846610-19-oupton@google.com>
Mime-Version: 1.0
References: <20210804085819.846610-1-oupton@google.com>
X-Mailer: git-send-email 2.32.0.605.g8dce9f2422-goog
Subject: [PATCH v6 18/21] KVM: arm64: Configure timer traps in vcpu_load() for VHE
From:   Oliver Upton <oupton@google.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Marc Zyngier <maz@kernel.org>, Peter Shier <pshier@google.com>,
        Jim Mattson <jmattson@google.com>,
        David Matlack <dmatlack@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Andrew Jones <drjones@redhat.com>,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Oliver Upton <oupton@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In preparation for emulated physical counter-timer offsetting, configure
traps on every vcpu_load() for VHE systems. As before, these trap
settings do not affect host userspace, and are only active for the
guest.

Suggested-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Oliver Upton <oupton@google.com>
---
 arch/arm64/kvm/arch_timer.c  | 10 +++++++---
 arch/arm64/kvm/arm.c         |  4 +---
 include/kvm/arm_arch_timer.h |  2 --
 3 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
index f15058612994..9ead94aa867d 100644
--- a/arch/arm64/kvm/arch_timer.c
+++ b/arch/arm64/kvm/arch_timer.c
@@ -51,6 +51,7 @@ static void kvm_arm_timer_write(struct kvm_vcpu *vcpu,
 static u64 kvm_arm_timer_read(struct kvm_vcpu *vcpu,
 			      struct arch_timer_context *timer,
 			      enum kvm_arch_timer_regs treg);
+static void kvm_timer_enable_traps_vhe(void);
 
 u32 timer_get_ctl(struct arch_timer_context *ctxt)
 {
@@ -668,6 +669,9 @@ void kvm_timer_vcpu_load(struct kvm_vcpu *vcpu)
 
 	if (map.emul_ptimer)
 		timer_emulate(map.emul_ptimer);
+
+	if (has_vhe())
+		kvm_timer_enable_traps_vhe();
 }
 
 bool kvm_timer_should_notify_user(struct kvm_vcpu *vcpu)
@@ -1383,12 +1387,12 @@ int kvm_timer_enable(struct kvm_vcpu *vcpu)
 }
 
 /*
- * On VHE system, we only need to configure the EL2 timer trap register once,
- * not for every world switch.
+ * On VHE system, we only need to configure the EL2 timer trap register on
+ * vcpu_load(), but not every world switch into the guest.
  * The host kernel runs at EL2 with HCR_EL2.TGE == 1,
  * and this makes those bits have no effect for the host kernel execution.
  */
-void kvm_timer_init_vhe(void)
+static void kvm_timer_enable_traps_vhe(void)
 {
 	/* When HCR_EL2.E2H ==1, EL1PCEN and EL1PCTEN are shifted by 10 */
 	u32 cnthctl_shift = 10;
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index e9a2b8f27792..47ea1e1ba80b 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1558,9 +1558,7 @@ static void cpu_hyp_reinit(void)
 
 	cpu_hyp_reset();
 
-	if (is_kernel_in_hyp_mode())
-		kvm_timer_init_vhe();
-	else
+	if (!is_kernel_in_hyp_mode())
 		cpu_init_hyp_mode();
 
 	cpu_set_hyp_vector();
diff --git a/include/kvm/arm_arch_timer.h b/include/kvm/arm_arch_timer.h
index 615f9314f6a5..254653b42da0 100644
--- a/include/kvm/arm_arch_timer.h
+++ b/include/kvm/arm_arch_timer.h
@@ -87,8 +87,6 @@ u64 kvm_phys_timer_read(void);
 void kvm_timer_vcpu_load(struct kvm_vcpu *vcpu);
 void kvm_timer_vcpu_put(struct kvm_vcpu *vcpu);
 
-void kvm_timer_init_vhe(void);
-
 bool kvm_arch_timer_get_input_level(int vintid);
 
 #define vcpu_timer(v)	(&(v)->arch.timer_cpu)
-- 
2.32.0.605.g8dce9f2422-goog

