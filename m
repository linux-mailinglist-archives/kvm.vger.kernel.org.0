Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 453A96B52FF
	for <lists+kvm@lfdr.de>; Fri, 10 Mar 2023 22:43:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231952AbjCJVnC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Mar 2023 16:43:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231906AbjCJVmr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Mar 2023 16:42:47 -0500
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16B45132BCA
        for <kvm@vger.kernel.org>; Fri, 10 Mar 2023 13:42:46 -0800 (PST)
Received: by mail-pf1-x44a.google.com with SMTP id a25-20020a056a001d1900b005e82b3dc9f4so3454134pfx.1
        for <kvm@vger.kernel.org>; Fri, 10 Mar 2023 13:42:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678484565;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=ZTdlaahA+hJ1PbOJKq8XkVSpenQe+RFMEt4am3hb+Bk=;
        b=BOROzPRv5X6s9tSVq3z98BwKTJA8HOlvQwrcpQkN6WYT7vS2UberlqOHxU6LOf9/No
         vnPJYo/hIcw84Y+K5/ymxzpbt0gx6purMOlBR2LqSk9NI7rUSgZcDRmCx8zDGlZjeE9H
         2qB5i7GsugLTyrrDTn+QrsaKhxR30KMebMJm5Gjz9KQlN1hWLt0uKWdyf+9aFJpQMZa6
         KJ+SVMO1L7qsi3MHudN5kpGpyKDTqWIiiXuwIXT7o2rvhSrvIDWZfaJsg46m/A9tCCRm
         L9mRTradiTVpYVq0IUgcq+EgTnDxAkQzskCQKbLf6sxeM4gQI7gDohUU3Hvvv91ntW6F
         Mbiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678484565;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZTdlaahA+hJ1PbOJKq8XkVSpenQe+RFMEt4am3hb+Bk=;
        b=bgDc7yzsmeVEBhmjUHCmIPNx20qAA34BkuiB68lWvrpqzcONjO/AHWtTRnzjnkDDsQ
         2uISXHmUI+aj1oROweGbAZ5OwKyDxeZg9OeulB5GVJo61eY4Npoffkm48r2NQU5qCVDr
         2WmpPwzVbsNW+lBoa7PXMdHDh5oBABxV6SZ16FfmORGL2fhJaeVvEEPSKgwveXlRboqV
         Ot0Bn2+YILWED+XR3CLhUpouAmma45uuuF1PlrR2/5oQkeJmWlx6CpZBNn7Di3a+z2ZL
         HW9+r9ikCDel1zhnHlDdaRMVPg96Op+9vnHxL1EZXPRoCgMtHK81o3nWBqN/AMVaZU4L
         A4bg==
X-Gm-Message-State: AO0yUKULJgroNtOYcgnbMpoCXIrTjNlERpoXDRiMlKU6+F91tHmBG+MA
        3+cbDNXeMOIlF++fYfty51SXwUMT2og=
X-Google-Smtp-Source: AK7set9/zHBTCb66IekbNgNXWU8abOgSoCp4RR5C23Cy1KenqvHWXUpxDuhvPLou1wC7CS10eEBX8TeYdhk=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:2746:0:b0:503:83e8:9b54 with SMTP id
 n67-20020a632746000000b0050383e89b54mr1160320pgn.1.1678484565499; Fri, 10 Mar
 2023 13:42:45 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 10 Mar 2023 13:42:18 -0800
In-Reply-To: <20230310214232.806108-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230310214232.806108-1-seanjc@google.com>
X-Mailer: git-send-email 2.40.0.rc1.284.g88254d51c5-goog
Message-ID: <20230310214232.806108-5-seanjc@google.com>
Subject: [PATCH v2 04/18] x86/reboot: KVM: Handle VMXOFF in KVM's reboot callback
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
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use KVM VMX's reboot/crash callback to do VMXOFF in an emergency instead
of manually and blindly doing VMXOFF.  There's no need to attempt VMXOFF
if KVM (or some other out-of-tree hypervisor) isn't loaded/active, i.e.
if the CPU can't possibly be post-VMXON.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/virtext.h | 10 ----------
 arch/x86/kernel/reboot.c       | 30 +++++++++---------------------
 arch/x86/kvm/vmx/vmx.c         |  8 +++++---
 3 files changed, 14 insertions(+), 34 deletions(-)

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
index 78182b2969db..5fb1fbf14c82 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -788,13 +788,7 @@ void machine_crash_shutdown(struct pt_regs *regs)
 #endif
 
 #if IS_ENABLED(CONFIG_KVM_INTEL)
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
 	synchronize_rcu();
 }
 EXPORT_SYMBOL_GPL(cpu_emergency_unregister_virt_callback);
-
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
 #endif
 
 /* This is the CPU performing the emergency shutdown work. */
@@ -839,10 +822,15 @@ int crashing_cpu = -1;
 void cpu_emergency_disable_virtualization(void)
 {
 #if IS_ENABLED(CONFIG_KVM_INTEL)
-	cpu_crash_vmclear_loaded_vmcss();
-#endif
+	cpu_emergency_virt_cb *callback;
 
-	cpu_emergency_vmxoff();
+	rcu_read_lock();
+	callback = rcu_dereference(cpu_emergency_virt_callback);
+	if (callback)
+		callback();
+	rcu_read_unlock();
+#endif
+	/* KVM_AMD doesn't yet utilize the common callback. */
 	cpu_emergency_svm_disable();
 }
 
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 41095fc864f3..9e196b9fe183 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -743,7 +743,7 @@ static int vmx_set_guest_uret_msr(struct vcpu_vmx *vmx,
 	return ret;
 }
 
-static void crash_vmclear_local_loaded_vmcss(void)
+static void vmx_emergency_disable(void)
 {
 	int cpu = raw_smp_processor_id();
 	struct loaded_vmcs *v;
@@ -751,6 +751,8 @@ static void crash_vmclear_local_loaded_vmcss(void)
 	list_for_each_entry(v, &per_cpu(loaded_vmcss_on_cpu, cpu),
 			    loaded_vmcss_on_cpu_link)
 		vmcs_clear(v->vmcs);
+
+	__cpu_emergency_vmxoff();
 }
 
 static void __loaded_vmcs_clear(void *arg)
@@ -8551,7 +8553,7 @@ static void __vmx_exit(void)
 {
 	allow_smaller_maxphyaddr = false;
 
-	cpu_emergency_unregister_virt_callback(crash_vmclear_local_loaded_vmcss);
+	cpu_emergency_unregister_virt_callback(vmx_emergency_disable);
 
 	vmx_cleanup_l1d_flush();
 }
@@ -8601,7 +8603,7 @@ static int __init vmx_init(void)
 		pi_init_cpu(cpu);
 	}
 
-	cpu_emergency_register_virt_callback(crash_vmclear_local_loaded_vmcss);
+	cpu_emergency_register_virt_callback(vmx_emergency_disable);
 
 	vmx_check_vmcs12_offsets();
 
-- 
2.40.0.rc1.284.g88254d51c5-goog

