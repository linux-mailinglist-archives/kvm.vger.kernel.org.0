Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C31055B2DAF
	for <lists+kvm@lfdr.de>; Fri,  9 Sep 2022 06:47:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229862AbiIIErG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Sep 2022 00:47:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229867AbiIIErD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Sep 2022 00:47:03 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA9F3F9132
        for <kvm@vger.kernel.org>; Thu,  8 Sep 2022 21:47:00 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id f3-20020a056902038300b00696588a0e87so758337ybs.3
        for <kvm@vger.kernel.org>; Thu, 08 Sep 2022 21:47:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date;
        bh=qVBGSrI/KWTPkFtct01o77r/n8MEFbFBIyqHK8mbnss=;
        b=A+f8ccaReT78Mwr926D5zlus5ryXHfto50Ldpi0s9C5izCShLC+jvi3H3HpPwHgiW1
         XynSsZFsuLULMM1uIRAQjFeMBiRclaBgOq3b077Y6TGYw8a2f0FV2XwVx1c7sM9xUcON
         Lx+p6gimmASMygHqi7BWdXIqsj1C1gwasz0C7PoVfiekkcjql3fuuFkOJGOTi77Y7f9Q
         m/vV/W7X/38f33WtwECtJMdPGm8TDJSy66KHbUhGRfepKwNsM8rNVLVi0urb2BNf4CYv
         tPygzgftFS3sMHB/0T5HhrjApKv6pWtgwZIDB8o7QpvOIPe0Gzg7opLiK2Uu4GdP9ECU
         FVDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date;
        bh=qVBGSrI/KWTPkFtct01o77r/n8MEFbFBIyqHK8mbnss=;
        b=tl7eXXiQ0U/5QgGVVrHHt+NGFHV2NqlxUJZ2Wvr+RA5TwkoF5PcqmPAVaMfDXy9SS7
         vJ5b23cUScO83G3VU6oOuOqXvl8IyP9jAJLjbXEYYvLOwRhyM3FGu9HYOwppRlV15kLq
         OKqA0XR84QkMoSRf4YyDTBZdLqt/q50lxPk55Oz/nn325kwGV6wr963tBEcOde90UOL0
         agkD8C9Mnz5aQjznTxFmx/a3oAk3ldmxS8Q7jfUAJbIBeZ1Egi7HB+4gYm6rWKBftoVq
         GABB+EagdCWQ62NsDFEr1pLk5TRTkYVUBkXOtkpebGhSa9Pfze8yGJd0rv9q5yzc6HGw
         Be3Q==
X-Gm-Message-State: ACgBeo3PED6BXd2iRIGvU5q0HT+W9+76PCv4+6iyiZcejveAp1TqgZgB
        EVENa3Rbyhe00StFHhqo1YIi0iA641E=
X-Google-Smtp-Source: AA6agR6cNEIBry9BgSshMGxwWWRc5xAzxMKV1YLdQXwf+d9BHb/bCy3OT+neJ1h+yygWbHJZgWChiqkfD2E=
X-Received: from reijiw-west4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:aa1])
 (user=reijiw job=sendgmr) by 2002:a81:8681:0:b0:33c:7394:9ee1 with SMTP id
 w123-20020a818681000000b0033c73949ee1mr10317707ywf.408.1662698820238; Thu, 08
 Sep 2022 21:47:00 -0700 (PDT)
Date:   Thu,  8 Sep 2022 21:46:34 -0700
In-Reply-To: <20220909044636.1997755-1-reijiw@google.com>
Mime-Version: 1.0
References: <20220909044636.1997755-1-reijiw@google.com>
X-Mailer: git-send-email 2.37.2.789.g6183377224-goog
Message-ID: <20220909044636.1997755-2-reijiw@google.com>
Subject: [PATCH 1/3] KVM: arm64: Don't set PSTATE.SS when Software Step state
 is Active-pending
From:   Reiji Watanabe <reijiw@google.com>
To:     Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu
Cc:     kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Ricardo Koller <ricarkol@google.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        Reiji Watanabe <reijiw@google.com>
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

Currently, PSTATE.SS is set on every guest entry if single-step is
enabled for the vCPU by userspace.  However, it could cause extra
single-step execution without returning to userspace, which shouldn't
be performed, if the Software Step state at the last guest exit was
Active-pending (i.e. the last exit was not triggered by Software Step
exception, but by an asynchronous exception after the single-step
execution is performed).

Fix this by not setting PSTATE.SS on guest entry if the Software
Step state at the last exit was Active-pending.

Fixes: 337b99bf7edf ("KVM: arm64: guest debug, add support for single-step")
Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/include/asm/kvm_host.h |  3 +++
 arch/arm64/kvm/debug.c            | 19 ++++++++++++++++++-
 arch/arm64/kvm/guest.c            |  1 +
 arch/arm64/kvm/handle_exit.c      |  2 ++
 4 files changed, 24 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index e9c9388ccc02..4cf6eef02565 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -535,6 +535,9 @@ struct kvm_vcpu_arch {
 #define IN_WFIT			__vcpu_single_flag(sflags, BIT(3))
 /* vcpu system registers loaded on physical CPU */
 #define SYSREGS_ON_CPU		__vcpu_single_flag(sflags, BIT(4))
+/* Software step state is Active-pending */
+#define DBG_SS_ACTIVE_PENDING	__vcpu_single_flag(sflags, BIT(5))
+
 
 /* Pointer to the vcpu's SVE FFR for sve_{save,load}_state() */
 #define vcpu_sve_pffr(vcpu) (kern_hyp_va((vcpu)->arch.sve_state) +	\
diff --git a/arch/arm64/kvm/debug.c b/arch/arm64/kvm/debug.c
index 0b28d7db7c76..125cfb94b4ad 100644
--- a/arch/arm64/kvm/debug.c
+++ b/arch/arm64/kvm/debug.c
@@ -188,7 +188,16 @@ void kvm_arm_setup_debug(struct kvm_vcpu *vcpu)
 		 * debugging the system.
 		 */
 		if (vcpu->guest_debug & KVM_GUESTDBG_SINGLESTEP) {
-			*vcpu_cpsr(vcpu) |=  DBG_SPSR_SS;
+			/*
+			 * If the software step state at the last guest exit
+			 * was Active-pending, we don't set DBG_SPSR_SS so
+			 * that the state is maintained (to not run another
+			 * single-step until the pending Software Step
+			 * exception is taken).
+			 */
+			if (!vcpu_get_flag(vcpu, DBG_SS_ACTIVE_PENDING))
+				*vcpu_cpsr(vcpu) |= DBG_SPSR_SS;
+
 			mdscr = vcpu_read_sys_reg(vcpu, MDSCR_EL1);
 			mdscr |= DBG_MDSCR_SS;
 			vcpu_write_sys_reg(vcpu, mdscr, MDSCR_EL1);
@@ -279,6 +288,14 @@ void kvm_arm_clear_debug(struct kvm_vcpu *vcpu)
 						&vcpu->arch.debug_ptr->dbg_wcr[0],
 						&vcpu->arch.debug_ptr->dbg_wvr[0]);
 		}
+
+		if ((vcpu->guest_debug & KVM_GUESTDBG_SINGLESTEP) &&
+		    !(*vcpu_cpsr(vcpu) & DBG_SPSR_SS))
+			/*
+			 * Mark the vcpu as ACTIVE_PENDING
+			 * until Software Step exception is confirmed.
+			 */
+			vcpu_set_flag(vcpu, DBG_SS_ACTIVE_PENDING);
 	}
 }
 
diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
index f802a3b3f8db..2ff13a3f8479 100644
--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -937,6 +937,7 @@ int kvm_arch_vcpu_ioctl_set_guest_debug(struct kvm_vcpu *vcpu,
 	} else {
 		/* If not enabled clear all flags */
 		vcpu->guest_debug = 0;
+		vcpu_clear_flag(vcpu, DBG_SS_ACTIVE_PENDING);
 	}
 
 out:
diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
index bbe5b393d689..8e43b2668d67 100644
--- a/arch/arm64/kvm/handle_exit.c
+++ b/arch/arm64/kvm/handle_exit.c
@@ -154,6 +154,8 @@ static int kvm_handle_guest_debug(struct kvm_vcpu *vcpu)
 
 	if (ESR_ELx_EC(esr) == ESR_ELx_EC_WATCHPT_LOW)
 		run->debug.arch.far = vcpu->arch.fault.far_el2;
+	else if (ESR_ELx_EC(esr) == ESR_ELx_EC_SOFTSTP_LOW)
+		vcpu_clear_flag(vcpu, DBG_SS_ACTIVE_PENDING);
 
 	return 0;
 }
-- 
2.37.2.789.g6183377224-goog

