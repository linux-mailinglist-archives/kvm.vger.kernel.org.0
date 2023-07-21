Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D19A775D579
	for <lists+kvm@lfdr.de>; Fri, 21 Jul 2023 22:19:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231197AbjGUUT2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Jul 2023 16:19:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230248AbjGUUTS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Jul 2023 16:19:18 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8609335AD
        for <kvm@vger.kernel.org>; Fri, 21 Jul 2023 13:19:08 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-d061f324d64so526866276.1
        for <kvm@vger.kernel.org>; Fri, 21 Jul 2023 13:19:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1689970748; x=1690575548;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=8mt2rx9ZLjLB1KoF/SJo016XQ9rXRtE6G9Sw+PvIk2E=;
        b=46uRXOuIfr0DhaSfjJ1gilpLeWI3SkY0gBhy4/JE8Ffy8aB+wmHHv0eZLbPKwxGf1W
         zRibu2Q+TOMsOsJJb4OHXHOPphrSRQVtzF5JSYhNBOCF7LUJtPtEWSRYc2JzZ4acAnor
         /zmJ7rgJese6SY0MTnK9LF9xzGYySIQj6WHl2lAxP+dEQMc/jN7H8FWycEgSVz1jPhiN
         kHTFjuNTxv4dt/QE31tPp7lm/S5hHzAiuf3QYbCoqwzmHIbVLyemLu2fOiOfokkTKl20
         itFUL9M3X8lEkW6ABJkQLWfuSKa41xBM+UYU6HXoNTkiMFGmgDhcqWF7uCFWGdPxsAIv
         jV9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689970748; x=1690575548;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8mt2rx9ZLjLB1KoF/SJo016XQ9rXRtE6G9Sw+PvIk2E=;
        b=Ek5IVjtCleXgpipB7Adlu+ma3v7B9OMyRg0br+DPlLtfhAebP3Q+ZCCV+erPtxv8Jn
         y59aP5oXxda8Srbzc7hC/GpruvTz/srPa9lIjrwIDnXVrqoGSuq009/OywSg/ujO0c7+
         9PfT5K/wO68i6rGbfh8DWPjqD6iOhpwqVWHa8fUSdNeSAzkEdnJxQE67bgM6tfRqMnot
         lK2RCaRz8oNIkvC5MUFHY2QvCac6wQVmcwDPpI/ECU0DmHKylApfdBurted1MdV8WTaN
         aqRVjUES/DXdJJe6uLe2SvbVCmnG216HN8+TyfsTY1CTtqUy661OSkhkoj4/kHFSptoZ
         hpzA==
X-Gm-Message-State: ABy/qLYbsYLtdn+JuA8zh+vd2s8cqYrhWAelNKPkNnhPnlpN2JqR1TcE
        8tfcoTxHWOFtGDc6HsOV1iklfagfYNM=
X-Google-Smtp-Source: APBJJlF95+kSFxBs9d4pDOtehohhALNf2zhk0CRH0P4ZIcPOxfGtYaIR5ilvDhFJ1p2u7OpKqjT4MbBf20Q=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:8208:0:b0:cf2:9e82:a5b5 with SMTP id
 q8-20020a258208000000b00cf29e82a5b5mr18342ybk.8.1689970747834; Fri, 21 Jul
 2023 13:19:07 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 21 Jul 2023 13:18:42 -0700
In-Reply-To: <20230721201859.2307736-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230721201859.2307736-1-seanjc@google.com>
X-Mailer: git-send-email 2.41.0.487.g6d72f3e995-goog
Message-ID: <20230721201859.2307736-3-seanjc@google.com>
Subject: [PATCH v4 02/19] x86/reboot: Harden virtualization hooks for
 emergency reboot
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
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Provide dedicated helpers to (un)register virt hooks used during an
emergency crash/reboot, and WARN if there is an attempt to overwrite
the registered callback, or an attempt to do an unpaired unregister.

Opportunsitically use rcu_assign_pointer() instead of RCU_INIT_POINTER(),
mainly so that the set/unset paths are more symmetrical, but also because
any performance gains from using RCU_INIT_POINTER() are meaningless for
this code.

Reviewed-by: Kai Huang <kai.huang@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/reboot.h |  5 +++--
 arch/x86/kernel/reboot.c      | 30 ++++++++++++++++++++++++------
 arch/x86/kvm/vmx/vmx.c        |  6 ++----
 3 files changed, 29 insertions(+), 12 deletions(-)

diff --git a/arch/x86/include/asm/reboot.h b/arch/x86/include/asm/reboot.h
index dc201724a643..74c6a624d166 100644
--- a/arch/x86/include/asm/reboot.h
+++ b/arch/x86/include/asm/reboot.h
@@ -25,8 +25,9 @@ void __noreturn machine_real_restart(unsigned int type);
 #define MRR_BIOS	0
 #define MRR_APM		1
 
-typedef void crash_vmclear_fn(void);
-extern crash_vmclear_fn __rcu *crash_vmclear_loaded_vmcss;
+typedef void (cpu_emergency_virt_cb)(void);
+void cpu_emergency_register_virt_callback(cpu_emergency_virt_cb *callback);
+void cpu_emergency_unregister_virt_callback(cpu_emergency_virt_cb *callback);
 void cpu_emergency_disable_virtualization(void);
 
 typedef void (*nmi_shootdown_cb)(int, struct pt_regs*);
diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index 3fa4c6717a1d..62ccedeb5e2b 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -794,17 +794,35 @@ void machine_crash_shutdown(struct pt_regs *regs)
  *
  * protected by rcu.
  */
-crash_vmclear_fn __rcu *crash_vmclear_loaded_vmcss;
-EXPORT_SYMBOL_GPL(crash_vmclear_loaded_vmcss);
+static cpu_emergency_virt_cb __rcu *cpu_emergency_virt_callback;
+
+void cpu_emergency_register_virt_callback(cpu_emergency_virt_cb *callback)
+{
+	if (WARN_ON_ONCE(rcu_access_pointer(cpu_emergency_virt_callback)))
+		return;
+
+	rcu_assign_pointer(cpu_emergency_virt_callback, callback);
+}
+EXPORT_SYMBOL_GPL(cpu_emergency_register_virt_callback);
+
+void cpu_emergency_unregister_virt_callback(cpu_emergency_virt_cb *callback)
+{
+	if (WARN_ON_ONCE(rcu_access_pointer(cpu_emergency_virt_callback) != callback))
+		return;
+
+	rcu_assign_pointer(cpu_emergency_virt_callback, NULL);
+	synchronize_rcu();
+}
+EXPORT_SYMBOL_GPL(cpu_emergency_unregister_virt_callback);
 
 static inline void cpu_crash_vmclear_loaded_vmcss(void)
 {
-	crash_vmclear_fn *do_vmclear_operation = NULL;
+	cpu_emergency_virt_cb *callback;
 
 	rcu_read_lock();
-	do_vmclear_operation = rcu_dereference(crash_vmclear_loaded_vmcss);
-	if (do_vmclear_operation)
-		do_vmclear_operation();
+	callback = rcu_dereference(cpu_emergency_virt_callback);
+	if (callback)
+		callback();
 	rcu_read_unlock();
 }
 
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 7f692d97a821..019cefc65142 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -8590,8 +8590,7 @@ static void __vmx_exit(void)
 {
 	allow_smaller_maxphyaddr = false;
 
-	RCU_INIT_POINTER(crash_vmclear_loaded_vmcss, NULL);
-	synchronize_rcu();
+	cpu_emergency_unregister_virt_callback(crash_vmclear_local_loaded_vmcss);
 
 	vmx_cleanup_l1d_flush();
 }
@@ -8641,8 +8640,7 @@ static int __init vmx_init(void)
 		pi_init_cpu(cpu);
 	}
 
-	rcu_assign_pointer(crash_vmclear_loaded_vmcss,
-			   crash_vmclear_local_loaded_vmcss);
+	cpu_emergency_register_virt_callback(crash_vmclear_local_loaded_vmcss);
 
 	vmx_check_vmcs12_offsets();
 
-- 
2.41.0.487.g6d72f3e995-goog

