Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED9D04D67D3
	for <lists+kvm@lfdr.de>; Fri, 11 Mar 2022 18:41:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350854AbiCKRmS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Mar 2022 12:42:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350835AbiCKRmM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Mar 2022 12:42:12 -0500
Received: from mail-io1-xd4a.google.com (mail-io1-xd4a.google.com [IPv6:2607:f8b0:4864:20::d4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C52BE1C57EA
        for <kvm@vger.kernel.org>; Fri, 11 Mar 2022 09:41:08 -0800 (PST)
Received: by mail-io1-xd4a.google.com with SMTP id d19-20020a0566022bf300b00645eba5c992so6778373ioy.4
        for <kvm@vger.kernel.org>; Fri, 11 Mar 2022 09:41:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=9XdJKUFytcHkfxO8A0zHHdaSq5C6RUOo0dHsNroWzi4=;
        b=iBYHZZIu4+glns+DBM+1sLjFX7LQFA3zP0tDyNnFwpnRI/lNEol8HGFtx6Y2+Mi7ZK
         bQtPSTWOAKYg0fLgu1VqZ6kbC9RU/AJW6FF/ihA6uwiYBOHi1mk8SMwigIy/2ixjySNR
         tPuIxyMPycs0AUgDQulOYiG6DlF4YTQTc3sq37NMQn+Ohtd7drMQyK77PNolcn2BeeOV
         qzyTOTnZmWjZ6VaMTWv36WU9dPNOA1B5S+XBQqnCsDEK/FRqSBALFbxs5m91dBcFGMae
         y4S1v/2F5Sil92fkkuNmvMeX1cSkC8BFJL67AirOBoNyu1OH5kEKaDoVbtFCenBSFAzW
         w4uA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=9XdJKUFytcHkfxO8A0zHHdaSq5C6RUOo0dHsNroWzi4=;
        b=XWnHYNrmwFnA/JO6vvqu+qOOJwaelrpu1740QPwDs/qp6okrY9xqkbJ2ONldlq4NCu
         oR2/TpWhKAbGhzBPyP0pTVXJFsMKNOkXQ4s7aDUbmi4M6RLu7KU2QTZhAWSAD5pwALCR
         aZT6Dmb3ubp/jIvTYbdKDFdjP8u9QmUmLbyY6Bki52QidO/QkLQImbm8+DSmTvnYK1P6
         kuuYaTDNpIJi3jdIbz8BuhPw7RGhArUh45lfyrs00Vbnx5yHybsMYsQoaziZgNlOA7on
         lXyTrWoWO4BlTKF2k5IQicxf9bcAcZvE3ZXN/COIgUdkUFfdmtbV/gV4hzitGPUp/TbT
         dfrw==
X-Gm-Message-State: AOAM53029e7Hh3er/drtKGVIV6FI+MQyBXDB8qLuBTsGAhl43GcZyZL7
        UhOhnh5D2zkZ9MH1q15Lz9jc3IVT9w8=
X-Google-Smtp-Source: ABdhPJy0gVFdG3BgjTaM6i8MVhqzhgFYYyl2pWvpkR0CNXcn7tlc65SXQKYNv9FC9ebaoIoCLgIk9P8Y8yM=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a05:6e02:1569:b0:2be:ffc9:8bb4 with SMTP id
 k9-20020a056e02156900b002beffc98bb4mr9168928ilu.229.1647020468144; Fri, 11
 Mar 2022 09:41:08 -0800 (PST)
Date:   Fri, 11 Mar 2022 17:39:53 +0000
In-Reply-To: <20220311174001.605719-1-oupton@google.com>
Message-Id: <20220311174001.605719-8-oupton@google.com>
Mime-Version: 1.0
References: <20220311174001.605719-1-oupton@google.com>
X-Mailer: git-send-email 2.35.1.723.g4982287a31-goog
Subject: [PATCH v4 07/15] KVM: Create helper for setting a system event exit
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
 arch/arm64/kvm/psci.c         | 5 +----
 arch/riscv/kvm/vcpu_sbi_v01.c | 4 +---
 arch/x86/kvm/x86.c            | 6 ++----
 include/linux/kvm_host.h      | 2 ++
 virt/kvm/kvm_main.c           | 8 ++++++++
 5 files changed, 14 insertions(+), 11 deletions(-)

diff --git a/arch/arm64/kvm/psci.c b/arch/arm64/kvm/psci.c
index efd4428fda1c..78266716165e 100644
--- a/arch/arm64/kvm/psci.c
+++ b/arch/arm64/kvm/psci.c
@@ -173,10 +173,7 @@ static void kvm_prepare_system_event(struct kvm_vcpu *vcpu, u32 type, u64 flags)
 		tmp->arch.mp_state.mp_state = KVM_MP_STATE_STOPPED;
 	kvm_make_all_cpus_request(vcpu->kvm, KVM_REQ_SLEEP);
 
-	memset(&vcpu->run->system_event, 0, sizeof(vcpu->run->system_event));
-	vcpu->run->system_event.type = type;
-	vcpu->run->system_event.flags = flags;
-	vcpu->run->exit_reason = KVM_EXIT_SYSTEM_EVENT;
+	kvm_vcpu_set_system_event_exit(vcpu, type, flags);
 }
 
 static void kvm_psci_system_off(struct kvm_vcpu *vcpu)
diff --git a/arch/riscv/kvm/vcpu_sbi_v01.c b/arch/riscv/kvm/vcpu_sbi_v01.c
index 07e2de14433a..c5581008dd88 100644
--- a/arch/riscv/kvm/vcpu_sbi_v01.c
+++ b/arch/riscv/kvm/vcpu_sbi_v01.c
@@ -24,9 +24,7 @@ static void kvm_sbi_system_shutdown(struct kvm_vcpu *vcpu,
 		tmp->arch.power_off = true;
 	kvm_make_all_cpus_request(vcpu->kvm, KVM_REQ_SLEEP);
 
-	memset(&run->system_event, 0, sizeof(run->system_event));
-	run->system_event.type = type;
-	run->exit_reason = KVM_EXIT_SYSTEM_EVENT;
+	kvm_vcpu_set_system_event_exit(vcpu, type, 0);
 }
 
 static int kvm_sbi_ext_v01_handler(struct kvm_vcpu *vcpu, struct kvm_run *run,
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 7131d735b1ef..b3b94408cc61 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9903,14 +9903,12 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
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
index f11039944c08..c2a4fd2382e2 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -2202,6 +2202,8 @@ static inline void kvm_handle_signal_exit(struct kvm_vcpu *vcpu)
 }
 #endif /* CONFIG_KVM_XFER_TO_GUEST_WORK */
 
+void kvm_vcpu_set_system_event_exit(struct kvm_vcpu *vcpu, u32 type, u64 flags);
+
 /*
  * This defines how many reserved entries we want to keep before we
  * kick the vcpu to the userspace to avoid dirty ring full.  This
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 58d31da8a2f7..197bae04ca34 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3194,6 +3194,14 @@ void kvm_vcpu_mark_page_dirty(struct kvm_vcpu *vcpu, gfn_t gfn)
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
2.35.1.723.g4982287a31-goog

