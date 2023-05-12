Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D49FC7012A8
	for <lists+kvm@lfdr.de>; Sat, 13 May 2023 01:50:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241004AbjELXuu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 May 2023 19:50:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240900AbjELXuj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 May 2023 19:50:39 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A069E72BC
        for <kvm@vger.kernel.org>; Fri, 12 May 2023 16:50:36 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id 41be03b00d2f7-5287c9b01fdso9668892a12.2
        for <kvm@vger.kernel.org>; Fri, 12 May 2023 16:50:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1683935436; x=1686527436;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=+s2vjHRYRtpZyb+3MD4uIyfdE2NLcpaPYwgApb/ZFNM=;
        b=eL4nHQSDwW7gmn00vvldj9MYIw/3vl4sCi/gnCCZSk6YcH5PAXQT7/IXU9zbw1lNI9
         z+L1Zy318WhArTc/IZwxY2CV/HxE6817Z6q5II4naCiKmZwRCydxx9BFa3lSMUkDWQXs
         uQTqwaP1wdkQmPAB+fuSO33FjSoWj/+WsZ5JB83+H3v3s5puS+/LPVNmUvWnx9bcX9RF
         AYH5XguXq4T2STOgcQIcPxf6BixVfX46SeQfMIqlMJ9k08ja3rveKxzZUzkpQuNLnvcn
         oENOWnPIVaCFGgVgYvMUxe6OMGVjh3GK8kO3QPex+mbdBytrp1xOd2AfIy8LFooshtE4
         fe+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683935436; x=1686527436;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+s2vjHRYRtpZyb+3MD4uIyfdE2NLcpaPYwgApb/ZFNM=;
        b=TtT3UceL5OT49PLRxevEJpulkFbbDQxY1a9Dkz6xevHxvwm9gAt5GSMiOOdLMWw3wV
         irMpw4Rnd9XreQPhIwQZDM5caafLwBifWKJXwiJ+CPCAou9UDIbhny4amI7id6OfOlKI
         nfNkXLGtJKX1o1b+XKp5iBfnyN4VknQezwHxqMoCVoghpmNrIv9TSvXaDJK7GgASoehX
         JQUT0ZvCmwJDZ3pAeonzZKnFMieXH871lGPD3b2vuf9GglY5IyGlpQI5Hz/h6RL0H/Vc
         Mge+c5hz0vPmPkL8PHeaspy8YNcJ7IYYEnPyEKQjjRsIqNcSFTULdtXzfGRzfH2XH8NA
         xtOg==
X-Gm-Message-State: AC+VfDzg2NiSRE0lIERZ6PLtu8YUNkhOGwtBr42T7zSx90s9nude/Xu7
        m/TPZRf7pzW81uM9YrhgWOB7IdAj1F8=
X-Google-Smtp-Source: ACHHUZ7YCOK7NeYCRWfTly2nekYy4l2odBN0e7AOiKGNjhSjgZdoa73xpxS+RBUYSn0lbsw0WS09kiQdiYg=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:28c6:0:b0:520:bbac:7c4e with SMTP id
 bs189-20020a6328c6000000b00520bbac7c4emr7385721pgb.9.1683935436148; Fri, 12
 May 2023 16:50:36 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 12 May 2023 16:50:11 -0700
In-Reply-To: <20230512235026.808058-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230512235026.808058-1-seanjc@google.com>
X-Mailer: git-send-email 2.40.1.606.ga4b1b128d6-goog
Message-ID: <20230512235026.808058-4-seanjc@google.com>
Subject: [PATCH v3 03/18] x86/reboot: KVM: Handle VMXOFF in KVM's reboot callback
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrew Cooper <Andrew.Cooper3@citrix.com>,
        Kai Huang <kai.huang@intel.com>, Chao Gao <chao.gao@intel.com>
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

Use KVM VMX's reboot/crash callback to do VMXOFF in an emergency instead
of manually and blindly doing VMXOFF.  There's no need to attempt VMXOFF
if a hypervisor, i.e. KVM, isn't loaded/active, i.e. if the CPU can't
possibly be post-VMXON.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/virtext.h | 10 ----------
 arch/x86/kernel/reboot.c       | 29 +++++++++--------------------
 arch/x86/kvm/vmx/vmx.c         |  8 +++++---
 3 files changed, 14 insertions(+), 33 deletions(-)

diff --git a/arch/x86/include/asm/virtext.h b/arch/x86/include/asm/virtext.h
index 3b12e6b99412..5bc29fab15da 100644
--- a/arch/x86/include/asm/virtext.h
+++ b/arch/x86/include/asm/virtext.h
@@ -70,16 +70,6 @@ static inline void __cpu_emergency_vmxoff(void)
 		cpu_vmxoff();
 }
 
-/** Disable VMX if it is supported and enabled on the current CPU
- */
-static inline void cpu_emergency_vmxoff(void)
-{
-	if (cpu_has_vmx())
-		__cpu_emergency_vmxoff();
-}
-
-
-
 
 /*
  * SVM functions:
diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index 739e09527dbb..0cf2261c2dec 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -787,13 +787,7 @@ void machine_crash_shutdown(struct pt_regs *regs)
 }
 #endif
 
-/*
- * This is used to VMCLEAR all VMCSs loaded on the
- * processor. And when loading kvm_intel module, the
- * callback function pointer will be assigned.
- *
- * protected by rcu.
- */
+/* RCU-protected callback to disable virtualization prior to reboot. */
 static cpu_emergency_virt_cb __rcu *cpu_emergency_virt_callback;
 
 void cpu_emergency_register_virt_callback(cpu_emergency_virt_cb *callback)
@@ -815,17 +809,6 @@ void cpu_emergency_unregister_virt_callback(cpu_emergency_virt_cb *callback)
 }
 EXPORT_SYMBOL_GPL(cpu_emergency_unregister_virt_callback);
 
-static inline void cpu_crash_vmclear_loaded_vmcss(void)
-{
-	cpu_emergency_virt_cb *callback;
-
-	rcu_read_lock();
-	callback = rcu_dereference(cpu_emergency_virt_callback);
-	if (callback)
-		callback();
-	rcu_read_unlock();
-}
-
 /* This is the CPU performing the emergency shutdown work. */
 int crashing_cpu = -1;
 
@@ -836,9 +819,15 @@ int crashing_cpu = -1;
  */
 void cpu_emergency_disable_virtualization(void)
 {
-	cpu_crash_vmclear_loaded_vmcss();
+	cpu_emergency_virt_cb *callback;
 
-	cpu_emergency_vmxoff();
+	rcu_read_lock();
+	callback = rcu_dereference(cpu_emergency_virt_callback);
+	if (callback)
+		callback();
+	rcu_read_unlock();
+
+	/* KVM_AMD doesn't yet utilize the common callback. */
 	cpu_emergency_svm_disable();
 }
 
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index fc9cdb4114cc..76cdb189f1b5 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -744,7 +744,7 @@ static int vmx_set_guest_uret_msr(struct vcpu_vmx *vmx,
 	return ret;
 }
 
-static void crash_vmclear_local_loaded_vmcss(void)
+static void vmx_emergency_disable(void)
 {
 	int cpu = raw_smp_processor_id();
 	struct loaded_vmcs *v;
@@ -752,6 +752,8 @@ static void crash_vmclear_local_loaded_vmcss(void)
 	list_for_each_entry(v, &per_cpu(loaded_vmcss_on_cpu, cpu),
 			    loaded_vmcss_on_cpu_link)
 		vmcs_clear(v->vmcs);
+
+	__cpu_emergency_vmxoff();
 }
 
 static void __loaded_vmcs_clear(void *arg)
@@ -8547,7 +8549,7 @@ static void __vmx_exit(void)
 {
 	allow_smaller_maxphyaddr = false;
 
-	cpu_emergency_unregister_virt_callback(crash_vmclear_local_loaded_vmcss);
+	cpu_emergency_unregister_virt_callback(vmx_emergency_disable);
 
 	vmx_cleanup_l1d_flush();
 }
@@ -8597,7 +8599,7 @@ static int __init vmx_init(void)
 		pi_init_cpu(cpu);
 	}
 
-	cpu_emergency_register_virt_callback(crash_vmclear_local_loaded_vmcss);
+	cpu_emergency_register_virt_callback(vmx_emergency_disable);
 
 	vmx_check_vmcs12_offsets();
 
-- 
2.40.1.606.ga4b1b128d6-goog

