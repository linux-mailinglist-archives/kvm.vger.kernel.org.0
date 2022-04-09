Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7A3F4FAA67
	for <lists+kvm@lfdr.de>; Sat,  9 Apr 2022 20:46:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243116AbiDISsR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 9 Apr 2022 14:48:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243091AbiDISsM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 9 Apr 2022 14:48:12 -0400
Received: from mail-il1-x14a.google.com (mail-il1-x14a.google.com [IPv6:2607:f8b0:4864:20::14a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D99122B25
        for <kvm@vger.kernel.org>; Sat,  9 Apr 2022 11:46:05 -0700 (PDT)
Received: by mail-il1-x14a.google.com with SMTP id p10-20020a056e02104a00b002caa828f7b1so78706ilj.7
        for <kvm@vger.kernel.org>; Sat, 09 Apr 2022 11:46:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=M9iTvBPFeRX7TdT7v6GSKktRRdhWcQUUVDEXOSoZ0MA=;
        b=quNSu1Jjv/0hBISLTOx0rk6fLQBVctF6MgBIRDglBMuaKCYZiquDfV74DSpRqL1IEr
         I5Wxh3kLLdATTFVTSQD+dxB35NCAKxcSAWnlgLXx7bDbHncygYwMz1CR9pRMIpHuIFlX
         Rm1PVwNOyQ9khBnTRrpJo/bsBtstwvicvNoopc735/q/uMuMCwpOb5EvGik5t2nU3fFt
         Fhgr+9svCSuUO0wcNQemmQy2L1uZRTCXNIBz+DthvKtZzgDwQ1Mjz9OmDasimZ9tdJ1r
         rgJbF04fXvOVCzsA3PDZKm/Lul1vh/r2OQlUm9OTVBKbAAAq2eQuvesqZVjIfYhOnL7J
         wz/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=M9iTvBPFeRX7TdT7v6GSKktRRdhWcQUUVDEXOSoZ0MA=;
        b=3BvC47areKolIqC763CH6/OYEUZpz4+J1rRU1P60ykymrvD7rmuwMVJJkgsDAYMvgB
         0tUt5snebt+QIKO5VcQ21heR0eTmyb6QMnKLklHyS+Js9sxiaVGiUJLMwDKa371GimC1
         SvpzlfFl1Ge/McukezkJB8rvZIctWY0QnOHcX5VHGVHo4EOlLOzMaakf49fVdVF+r9Zm
         eHpOovhihngw6rpz2jpIxKB6PVR0qwEu2OakFR/4qIAl+k8DN8VeUoGsi9Qg5HXAWr2F
         8yPOR/65wWVhF3yllva9dFwf25G0tmtlPJYiiTWR2pRc5pbIcX0LLQODD7ZGvxLF8CB7
         67Ng==
X-Gm-Message-State: AOAM530yO6KuSE7DAsk8sF9MHmIUe1ylJKuS6uHvV5iHXkLkHhcJKNyX
        PYHA3ILgs3GV2wm439KKAbXojkufsN8=
X-Google-Smtp-Source: ABdhPJxRJ4iysZdXgAeJGHll8zt3PmDZcCVUpZgsAVAZxYWkmHxpJiqPHoxgBXWTE1J7+28LpoIw6iUFAhA=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a6b:7845:0:b0:64c:9acc:9f1a with SMTP id
 h5-20020a6b7845000000b0064c9acc9f1amr10560772iop.103.1649529964447; Sat, 09
 Apr 2022 11:46:04 -0700 (PDT)
Date:   Sat,  9 Apr 2022 18:45:41 +0000
In-Reply-To: <20220409184549.1681189-1-oupton@google.com>
Message-Id: <20220409184549.1681189-6-oupton@google.com>
Mime-Version: 1.0
References: <20220409184549.1681189-1-oupton@google.com>
X-Mailer: git-send-email 2.35.1.1178.g4f1659d476-goog
Subject: [PATCH v5 05/13] KVM: Create helper for setting a system event exit
From:   Oliver Upton <oupton@google.com>
To:     kvmarm@lists.cs.columbia.edu
Cc:     alexandru.elisei@arm.com, anup@brainfault.org,
        atishp@atishpatra.org, james.morse@arm.com, jingzhangos@google.com,
        jmattson@google.com, joro@8bytes.org,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org, maz@kernel.org,
        pbonzini@redhat.com, pshier@google.com, rananta@google.com,
        reijiw@google.com, ricarkol@google.com, seanjc@google.com,
        suzuki.poulose@arm.com, vkuznets@redhat.com, wanpengli@tencent.com,
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

Create a helper that appropriately configures kvm_run for a system event
exit.

No functional change intended.

Suggested-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Oliver Upton <oupton@google.com>
Acked-by: Anup Patel <anup@brainfault.org>
---
 arch/arm64/kvm/psci.c     | 5 +----
 arch/riscv/kvm/vcpu_sbi.c | 5 +----
 arch/x86/kvm/x86.c        | 6 ++----
 include/linux/kvm_host.h  | 2 ++
 virt/kvm/kvm_main.c       | 8 ++++++++
 5 files changed, 14 insertions(+), 12 deletions(-)

diff --git a/arch/arm64/kvm/psci.c b/arch/arm64/kvm/psci.c
index f2f45a3cbe86..362d2a898b83 100644
--- a/arch/arm64/kvm/psci.c
+++ b/arch/arm64/kvm/psci.c
@@ -172,10 +172,7 @@ static void kvm_prepare_system_event(struct kvm_vcpu *vcpu, u32 type, u64 flags)
 		tmp->arch.mp_state.mp_state = KVM_MP_STATE_STOPPED;
 	kvm_make_all_cpus_request(vcpu->kvm, KVM_REQ_SLEEP);
 
-	memset(&vcpu->run->system_event, 0, sizeof(vcpu->run->system_event));
-	vcpu->run->system_event.type = type;
-	vcpu->run->system_event.flags = flags;
-	vcpu->run->exit_reason = KVM_EXIT_SYSTEM_EVENT;
+	kvm_vcpu_set_system_event_exit(vcpu, type, flags);
 }
 
 static void kvm_psci_system_off(struct kvm_vcpu *vcpu)
diff --git a/arch/riscv/kvm/vcpu_sbi.c b/arch/riscv/kvm/vcpu_sbi.c
index a09ecb97b890..3be9730ae68b 100644
--- a/arch/riscv/kvm/vcpu_sbi.c
+++ b/arch/riscv/kvm/vcpu_sbi.c
@@ -92,10 +92,7 @@ void kvm_riscv_vcpu_sbi_system_reset(struct kvm_vcpu *vcpu,
 		tmp->arch.power_off = true;
 	kvm_make_all_cpus_request(vcpu->kvm, KVM_REQ_SLEEP);
 
-	memset(&run->system_event, 0, sizeof(run->system_event));
-	run->system_event.type = type;
-	run->system_event.flags = flags;
-	run->exit_reason = KVM_EXIT_SYSTEM_EVENT;
+	kvm_vcpu_set_system_event_exit(vcpu, type, flags);
 }
 
 int kvm_riscv_vcpu_sbi_return(struct kvm_vcpu *vcpu, struct kvm_run *run)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 0c0ca599a353..54efc1b4eb28 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10014,14 +10014,12 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 		if (kvm_check_request(KVM_REQ_APIC_PAGE_RELOAD, vcpu))
 			kvm_vcpu_reload_apic_access_page(vcpu);
 		if (kvm_check_request(KVM_REQ_HV_CRASH, vcpu)) {
-			vcpu->run->exit_reason = KVM_EXIT_SYSTEM_EVENT;
-			vcpu->run->system_event.type = KVM_SYSTEM_EVENT_CRASH;
+			kvm_vcpu_set_system_event_exit(vcpu, KVM_SYSTEM_EVENT_CRASH, 0);
 			r = 0;
 			goto out;
 		}
 		if (kvm_check_request(KVM_REQ_HV_RESET, vcpu)) {
-			vcpu->run->exit_reason = KVM_EXIT_SYSTEM_EVENT;
-			vcpu->run->system_event.type = KVM_SYSTEM_EVENT_RESET;
+			kvm_vcpu_set_system_event_exit(vcpu, KVM_SYSTEM_EVENT_RESET, 0);
 			r = 0;
 			goto out;
 		}
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 3f9b22c4983a..f2f66dc0fa6e 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -2220,6 +2220,8 @@ static inline void kvm_handle_signal_exit(struct kvm_vcpu *vcpu)
 }
 #endif /* CONFIG_KVM_XFER_TO_GUEST_WORK */
 
+void kvm_vcpu_set_system_event_exit(struct kvm_vcpu *vcpu, u32 type, u64 flags);
+
 /*
  * This defines how many reserved entries we want to keep before we
  * kick the vcpu to the userspace to avoid dirty ring full.  This
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index e39a6f56fc47..b91f689dd091 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3208,6 +3208,14 @@ void kvm_vcpu_mark_page_dirty(struct kvm_vcpu *vcpu, gfn_t gfn)
 }
 EXPORT_SYMBOL_GPL(kvm_vcpu_mark_page_dirty);
 
+void kvm_vcpu_set_system_event_exit(struct kvm_vcpu *vcpu, u32 type, u64 flags)
+{
+	memset(&vcpu->run->system_event, 0, sizeof(vcpu->run->system_event));
+	vcpu->run->system_event.type = type;
+	vcpu->run->system_event.flags = flags;
+	vcpu->run->exit_reason = KVM_EXIT_SYSTEM_EVENT;
+}
+
 void kvm_sigset_activate(struct kvm_vcpu *vcpu)
 {
 	if (!vcpu->sigset_active)
-- 
2.35.1.1178.g4f1659d476-goog

