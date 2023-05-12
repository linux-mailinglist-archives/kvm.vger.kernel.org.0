Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A87870127E
	for <lists+kvm@lfdr.de>; Sat, 13 May 2023 01:31:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240815AbjELXbk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 May 2023 19:31:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240779AbjELXbe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 May 2023 19:31:34 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 409FD30F0
        for <kvm@vger.kernel.org>; Fri, 12 May 2023 16:31:32 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id 98e67ed59e1d1-24deb9c5f8dso5536917a91.0
        for <kvm@vger.kernel.org>; Fri, 12 May 2023 16:31:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1683934291; x=1686526291;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=NwZBPWdtO/ryX4s5SybYGIvceJOpqL00ruN6lX2awnM=;
        b=I5cbSAqjIEnw5/qA+SDzjgh/7wgSqDk/YzpaFGJ7XoAzj+2/l7pFdtD5ThRZCIUl/W
         j89Z/QLK01RU1+FF7Q1NSVNIXc9+WeqCYfcXKkLBsNlH7pN+KD952mpxIOfZNnNaPPAx
         kJEIeLUQuqO6MlSJGSX/4+kTSk5nsmrcqpyV0TIyrG1f4BE5jjQbGlKPuKOWPgS3c+Zg
         CkGfru99WPin3KXQTN2x4uQPR85Bw8T6bo9L8TC2sJXkrUmbzS1Tr9K5UkpAw8NlpIfE
         nUcO4fytBd/+p7f42PwcenWjH6Vj0RsnJlWnQA86zrYZPv69LDVCZYbHCIddmIm0YfdS
         6reg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683934291; x=1686526291;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NwZBPWdtO/ryX4s5SybYGIvceJOpqL00ruN6lX2awnM=;
        b=CumBrG0Qjh/UD4CZ8A4cERwK7SeKSiJMYaLOGKFYhFIxXbVbZD0HMExHYOafkrtPo2
         H+d+ep6LNIphRhro5345R1pOY+hDZFcRQh9RKdDEfEJJnNCxCmZSVv9sqH40A3WLrouw
         Rjs2RUBzd6+CiISlR+pGNjIwTpSsQrML5UFBW53kT4i1EEuMWfXEyc+01NwbSyRIlsOa
         T0AnZxyjzNmBsgi5dyY5gI+M5uMjL7kO978hwxv6nGt/M7Jl/pKkkPbWMFsEvn+mQa+r
         pCdYWlyluOKELQkzcASW0gKjvynwuauiMxs5FslZKXoBLwe97ajEGZVZ+iCy9lxIiM3r
         XLgQ==
X-Gm-Message-State: AC+VfDwpv0pIDOGObtMpMEbt+AzF/M9mWn4KLg74oSQBPYzzPurvfXLu
        tcS8PT2+rY781QcoEO2OLZZ7MOFvyj4=
X-Google-Smtp-Source: ACHHUZ4yUt9N5BqOTLmaCILe8ZuPRN9eXE67MV+WK1Qa1rT2H0gDzMRZjCiyKyrvKWegiGaVwmxlZ8fH0Ns=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90b:895:b0:250:a6c1:b843 with SMTP id
 bj21-20020a17090b089500b00250a6c1b843mr4708527pjb.9.1683934291769; Fri, 12
 May 2023 16:31:31 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 12 May 2023 16:31:26 -0700
In-Reply-To: <20230512233127.804012-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230512233127.804012-1-seanjc@google.com>
X-Mailer: git-send-email 2.40.1.606.ga4b1b128d6-goog
Message-ID: <20230512233127.804012-2-seanjc@google.com>
Subject: [PATCH v2 1/2] KVM: Use syscore_ops instead of reboot_notifier to
 hook restart/shutdown
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Marc Zyngier <maz@kernel.org>,
        Oliver Upton <oliver.upton@linux.dev>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>, kvmarm@lists.linux.dev,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        kvm-riscv@lists.infradead.org,
        Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use syscore_ops.shutdown to disable hardware virtualization during a
reboot instead of using the dedicated reboot_notifier so that KVM disables
virtualization _after_ system_state has been updated.  This will allow
fixing a race in KVM's handling of a forced reboot where KVM can end up
enabling hardware virtualization between kernel_restart_prepare() and
machine_restart().

Rename KVM's hook to match the syscore op to avoid any possible confusion
from wiring up a "reboot" helper to a "shutdown" hook (neither "shutdown
nor "reboot" is completely accurate as the hook handles both).

Opportunistically rewrite kvm_shutdown()'s comment to make it less VMX
specific, and to explain why kvm_rebooting exists.

Cc: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oliver.upton@linux.dev>
Cc: James Morse <james.morse@arm.com>
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: Zenghui Yu <yuzenghui@huawei.com>
Cc: kvmarm@lists.linux.dev
Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>
Cc: Anup Patel <anup@brainfault.org>
Cc: Atish Patra <atishp@atishpatra.org>
Cc: kvm-riscv@lists.infradead.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 virt/kvm/kvm_main.c | 26 +++++++++++---------------
 1 file changed, 11 insertions(+), 15 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index d1abb331ea68..e771b6a013c9 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -5211,26 +5211,24 @@ static int hardware_enable_all(void)
 	return r;
 }
 
-static int kvm_reboot(struct notifier_block *notifier, unsigned long val,
-		      void *v)
+static void kvm_shutdown(void)
 {
 	/*
-	 * Some (well, at least mine) BIOSes hang on reboot if
-	 * in vmx root mode.
-	 *
-	 * And Intel TXT required VMX off for all cpu when system shutdown.
+	 * Disable hardware virtualization and set kvm_rebooting to indicate
+	 * that KVM has asynchronously disabled hardware virtualization, i.e.
+	 * that relevant errors and exceptions aren't entirely unexpected.
+	 * Some flavors of hardware virtualization need to be disabled before
+	 * transferring control to firmware (to perform shutdown/reboot), e.g.
+	 * on x86, virtualization can block INIT interrupts, which are used by
+	 * firmware to pull APs back under firmware control.  Note, this path
+	 * is used for both shutdown and reboot scenarios, i.e. neither name is
+	 * 100% comprehensive.
 	 */
 	pr_info("kvm: exiting hardware virtualization\n");
 	kvm_rebooting = true;
 	on_each_cpu(hardware_disable_nolock, NULL, 1);
-	return NOTIFY_OK;
 }
 
-static struct notifier_block kvm_reboot_notifier = {
-	.notifier_call = kvm_reboot,
-	.priority = 0,
-};
-
 static int kvm_suspend(void)
 {
 	/*
@@ -5261,6 +5259,7 @@ static void kvm_resume(void)
 static struct syscore_ops kvm_syscore_ops = {
 	.suspend = kvm_suspend,
 	.resume = kvm_resume,
+	.shutdown = kvm_shutdown,
 };
 #else /* CONFIG_KVM_GENERIC_HARDWARE_ENABLING */
 static int hardware_enable_all(void)
@@ -5965,7 +5964,6 @@ int kvm_init(unsigned vcpu_size, unsigned vcpu_align, struct module *module)
 	if (r)
 		return r;
 
-	register_reboot_notifier(&kvm_reboot_notifier);
 	register_syscore_ops(&kvm_syscore_ops);
 #endif
 
@@ -6037,7 +6035,6 @@ int kvm_init(unsigned vcpu_size, unsigned vcpu_align, struct module *module)
 err_vcpu_cache:
 #ifdef CONFIG_KVM_GENERIC_HARDWARE_ENABLING
 	unregister_syscore_ops(&kvm_syscore_ops);
-	unregister_reboot_notifier(&kvm_reboot_notifier);
 	cpuhp_remove_state_nocalls(CPUHP_AP_KVM_ONLINE);
 #endif
 	return r;
@@ -6063,7 +6060,6 @@ void kvm_exit(void)
 	kvm_async_pf_deinit();
 #ifdef CONFIG_KVM_GENERIC_HARDWARE_ENABLING
 	unregister_syscore_ops(&kvm_syscore_ops);
-	unregister_reboot_notifier(&kvm_reboot_notifier);
 	cpuhp_remove_state_nocalls(CPUHP_AP_KVM_ONLINE);
 #endif
 	kvm_irqfd_exit();
-- 
2.40.1.606.ga4b1b128d6-goog

