Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5CB575D577
	for <lists+kvm@lfdr.de>; Fri, 21 Jul 2023 22:19:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230497AbjGUUTZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Jul 2023 16:19:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230290AbjGUUTT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Jul 2023 16:19:19 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD1B9B7
        for <kvm@vger.kernel.org>; Fri, 21 Jul 2023 13:19:12 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-57059e6f9c7so39817197b3.0
        for <kvm@vger.kernel.org>; Fri, 21 Jul 2023 13:19:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1689970752; x=1690575552;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=KapJsJDXZSaTZ0KCMkqJA+w32osB4ivWYrQOtexabwQ=;
        b=TrXZbzXJvXjAFMtmdjbY6g43FEEUJ51e56dkvtg+kfgYdfON7FtAc+d4i+2limdYih
         Fjpb36idC7mIVH+9ApO7W85B+EBgNR1y6VZFqbg9bjcKv172M5172Tu0I1dzmE0TZhX3
         D9a4xyqNrw76UX3aD/sp0MisPY3yUWWKy6fXVSHGN4RpngnPjxMpr1WT6B57I5nDMM9h
         IGtYIrkL6QnQtXLq3ifiyUfnkXFyNu8goNHHb5EOEskvSfgSpgVq/fQOHdiQZkOKHfsp
         pRjXnhp8+gJFBM/PT+CJZnzWIouDqwd+pTmAWoAH8rgQR31KG+5TVJ87+VibBetAjN4U
         9KGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689970752; x=1690575552;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KapJsJDXZSaTZ0KCMkqJA+w32osB4ivWYrQOtexabwQ=;
        b=jmk9YBMHrxAuuP3zH4MOKn1wcdaM36qSooMjx248bViltqumT/7qzx6as9UCnAXjcv
         9sFL8b+/UL8xoccG1F1YgAh15vZhpBzY8/hEB4MuYWWef8vU1+jNx1iuG0LVntXP6nHY
         HNO/JMJhwT3RIFUeNoxvWON6edXwl9XwfLovbQTvWmHPTDddBO4lQjJiyT/oXrrxcGa5
         TPvQbn0KiX4Ro5LJrViMErylJGYLMNvjv46zqYVfOs/PqqFeJwRdwWbEdOyecfZ/OIWI
         qXFTYvauW2GT5Ajn8AosybBkGhx9uHeSGa5/nrUhLcLnazWQ1Mw+c3Epe8xhWd/dB2dd
         Svrw==
X-Gm-Message-State: ABy/qLZGLyVW5Lc7T69syeZAPmlHWO/WqHMnIFWsy6L+RQPcfE15HmAk
        1XPQBJD5+9I0Oi/fPsO4XQBUw8zx6ek=
X-Google-Smtp-Source: APBJJlGu5YOBwzaswNuu+hMFwXKYPw6WfFvR2MaNIQNXi7dan4IRvarFADNDlK9IoFXtUVAADyo+h6fqziI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:ad24:0:b0:56c:e53d:ae90 with SMTP id
 l36-20020a81ad24000000b0056ce53dae90mr13963ywh.4.1689970752188; Fri, 21 Jul
 2023 13:19:12 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 21 Jul 2023 13:18:44 -0700
In-Reply-To: <20230721201859.2307736-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230721201859.2307736-1-seanjc@google.com>
X-Mailer: git-send-email 2.41.0.487.g6d72f3e995-goog
Message-ID: <20230721201859.2307736-5-seanjc@google.com>
Subject: [PATCH v4 04/19] x86/reboot: KVM: Disable SVM during reboot via
 virt/KVM reboot callback
From:   Sean Christopherson <seanjc@google.com>
To:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Andrew Cooper <Andrew.Cooper3@citrix.com>,
        Kai Huang <kai.huang@intel.com>, Chao Gao <chao.gao@intel.com>
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

Use the virt callback to disable SVM (and set GIF=1) during an emergency
instead of blindly attempting to disable SVM.  Like the VMX case, if a
hypervisor, i.e. KVM, isn't loaded/active, SVM can't be in use.

Acked-by: Kai Huang <kai.huang@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/virtext.h |  8 --------
 arch/x86/kernel/reboot.c       |  3 ---
 arch/x86/kvm/svm/svm.c         | 19 +++++++++++++++++--
 3 files changed, 17 insertions(+), 13 deletions(-)

diff --git a/arch/x86/include/asm/virtext.h b/arch/x86/include/asm/virtext.h
index 5bc29fab15da..aaed66249ccf 100644
--- a/arch/x86/include/asm/virtext.h
+++ b/arch/x86/include/asm/virtext.h
@@ -133,12 +133,4 @@ static inline void cpu_svm_disable(void)
 	}
 }
 
-/** Makes sure SVM is disabled, if it is supported on the CPU
- */
-static inline void cpu_emergency_svm_disable(void)
-{
-	if (cpu_has_svm(NULL))
-		cpu_svm_disable();
-}
-
 #endif /* _ASM_X86_VIRTEX_H */
diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index d2d0f2672a64..48ad2d1ff83d 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -826,9 +826,6 @@ void cpu_emergency_disable_virtualization(void)
 	if (callback)
 		callback();
 	rcu_read_unlock();
-
-	/* KVM_AMD doesn't yet utilize the common callback. */
-	cpu_emergency_svm_disable();
 }
 
 #if defined(CONFIG_SMP)
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index d381ad424554..1ae9c2c7eacb 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -39,6 +39,7 @@
 #include <asm/spec-ctrl.h>
 #include <asm/cpu_device_id.h>
 #include <asm/traps.h>
+#include <asm/reboot.h>
 #include <asm/fpu/api.h>
 
 #include <asm/virtext.h>
@@ -563,6 +564,11 @@ void __svm_write_tsc_multiplier(u64 multiplier)
 	preempt_enable();
 }
 
+static void svm_emergency_disable(void)
+{
+	cpu_svm_disable();
+}
+
 static void svm_hardware_disable(void)
 {
 	/* Make sure we clean up behind us */
@@ -5209,6 +5215,13 @@ static struct kvm_x86_init_ops svm_init_ops __initdata = {
 	.pmu_ops = &amd_pmu_ops,
 };
 
+static void __svm_exit(void)
+{
+	kvm_x86_vendor_exit();
+
+	cpu_emergency_unregister_virt_callback(svm_emergency_disable);
+}
+
 static int __init svm_init(void)
 {
 	int r;
@@ -5222,6 +5235,8 @@ static int __init svm_init(void)
 	if (r)
 		return r;
 
+	cpu_emergency_register_virt_callback(svm_emergency_disable);
+
 	/*
 	 * Common KVM initialization _must_ come last, after this, /dev/kvm is
 	 * exposed to userspace!
@@ -5234,14 +5249,14 @@ static int __init svm_init(void)
 	return 0;
 
 err_kvm_init:
-	kvm_x86_vendor_exit();
+	__svm_exit();
 	return r;
 }
 
 static void __exit svm_exit(void)
 {
 	kvm_exit();
-	kvm_x86_vendor_exit();
+	__svm_exit();
 }
 
 module_init(svm_init)
-- 
2.41.0.487.g6d72f3e995-goog

