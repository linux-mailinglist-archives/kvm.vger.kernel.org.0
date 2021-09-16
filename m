Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80C6640EA64
	for <lists+kvm@lfdr.de>; Thu, 16 Sep 2021 20:56:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344237AbhIPS5k (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Sep 2021 14:57:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244458AbhIPS52 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Sep 2021 14:57:28 -0400
Received: from mail-io1-xd49.google.com (mail-io1-xd49.google.com [IPv6:2607:f8b0:4864:20::d49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7F78C04A14E
        for <kvm@vger.kernel.org>; Thu, 16 Sep 2021 11:15:31 -0700 (PDT)
Received: by mail-io1-xd49.google.com with SMTP id s6-20020a5ec646000000b005b7f88ffdd3so13765851ioo.13
        for <kvm@vger.kernel.org>; Thu, 16 Sep 2021 11:15:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=BVbFEb6A6+ovQK9ZEoIX753R5coZv2LaotY72yo0M9w=;
        b=Duaxw6Wdi+yt/FlgC80aDKbBVPAXpMQF8KpI6OQKf2suNWjt8X9L6kgb8q0LvcmszK
         u8MOMNwfq8+JhPlY5+TlV755nb8F/R6K0kkrOZNPQVJJGYQEpwyrC6QfwfsLVidVJcYH
         DIrhMhUnd0i2HV8uj2zqmBanyssDy57he+G5BSHT77y+HCxH6ESkSxo8HH4UybBf6bdf
         8rbY16XYfxL+06vdlWIBQu3txdt9JVh+uuExVJfG+y0OvyBphM1K1dA9n/+M3JQv4mat
         2ShobZszJNFipL0q8XFcwa/pym5HY0EzsrDsa71fSNB+ohJ5YAB+rvxBKxDIWgyyVj7+
         n7ZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=BVbFEb6A6+ovQK9ZEoIX753R5coZv2LaotY72yo0M9w=;
        b=VXTc1qmhSTSHEpfmiF+jAawQhh53qlMjJFNvuKKJRVCM3d5Rh2efgaSBZ3lt84OT4V
         nn42IOyEcvUEAw0A1tw2INlI4NJMr8u+ZTM9suJtIUd/vEQDdZa6g5CIZvQ3BROM3Agn
         Lw7+KyAnaQEf9ZqfvxgmT3E9RCIGuMJL0RGn7nCuaZBfpc1EgWBb/8mFckfmGSrloI6T
         Z8k73YyjADWXu/hHSDPs/zUablem6UYbeaemo+JMhQAl8dC40fo7gIG47UJaYDHRee4n
         ZSDamHKpleQpInVwsDaZCG/9YO3P5bzPH7tmyhX4JCuk3kh/JHHkggwIn+ks5jLVhx4B
         HSbg==
X-Gm-Message-State: AOAM530ep4q3FywUvJejejazW7E3fn/IOMSNEYunRWIQ0TLjh7y5pKAO
        8fLPz7uCwrriL0++LZ7hoMV8VGJSo5TMRxlUk8Cj8kZ4xHjZyPulsvRGNb7lUvJy0ZDFtVaTzp3
        7uTj2RPFADoOu64f0KNa4wA1qEYWug8kj8NXy/D68yJhGAHoG0snvhbRe7A==
X-Google-Smtp-Source: ABdhPJyNg0qALAw81ZPQoxY23q7Z3u2HDpDm1FTp2Br+FAAFtSr5K2bD/9X8TXlFZ8y1kQxeb0TfJQ01Wvk=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a6b:e917:: with SMTP id u23mr5504852iof.19.1631816131056;
 Thu, 16 Sep 2021 11:15:31 -0700 (PDT)
Date:   Thu, 16 Sep 2021 18:15:09 +0000
In-Reply-To: <20210916181510.963449-1-oupton@google.com>
Message-Id: <20210916181510.963449-8-oupton@google.com>
Mime-Version: 1.0
References: <20210916181510.963449-1-oupton@google.com>
X-Mailer: git-send-email 2.33.0.464.g1972c5931b-goog
Subject: [PATCH v8 7/8] KVM: arm64: Configure timer traps in vcpu_load() for VHE
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
Reviewed-by: Andrew Jones <drjones@redhat.com>
---
 arch/arm64/kvm/arch_timer.c  | 10 +++++++---
 arch/arm64/kvm/arm.c         |  4 +---
 include/kvm/arm_arch_timer.h |  2 --
 3 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
index 4bba149d140c..68fb5ddb9e7a 100644
--- a/arch/arm64/kvm/arch_timer.c
+++ b/arch/arm64/kvm/arch_timer.c
@@ -51,6 +51,7 @@ static void kvm_arm_timer_write(struct kvm_vcpu *vcpu,
 static u64 kvm_arm_timer_read(struct kvm_vcpu *vcpu,
 			      struct arch_timer_context *timer,
 			      enum kvm_arch_timer_regs treg);
+static void kvm_timer_enable_traps_vhe(void);
 
 u32 timer_get_ctl(struct arch_timer_context *ctxt)
 {
@@ -663,6 +664,9 @@ void kvm_timer_vcpu_load(struct kvm_vcpu *vcpu)
 
 	if (map.emul_ptimer)
 		timer_emulate(map.emul_ptimer);
+
+	if (has_vhe())
+		kvm_timer_enable_traps_vhe();
 }
 
 bool kvm_timer_should_notify_user(struct kvm_vcpu *vcpu)
@@ -1355,12 +1359,12 @@ int kvm_timer_enable(struct kvm_vcpu *vcpu)
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
index a562b36f28e2..086c9672c8ac 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1590,9 +1590,7 @@ static void cpu_hyp_reinit(void)
 
 	cpu_hyp_reset();
 
-	if (is_kernel_in_hyp_mode())
-		kvm_timer_init_vhe();
-	else
+	if (!is_kernel_in_hyp_mode())
 		cpu_init_hyp_mode();
 
 	cpu_set_hyp_vector();
diff --git a/include/kvm/arm_arch_timer.h b/include/kvm/arm_arch_timer.h
index aa666373f603..d06294aa356e 100644
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
2.33.0.309.g3052b89438-goog

