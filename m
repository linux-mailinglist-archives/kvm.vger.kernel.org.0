Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94F027012A4
	for <lists+kvm@lfdr.de>; Sat, 13 May 2023 01:50:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240920AbjELXul (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 May 2023 19:50:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240883AbjELXug (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 May 2023 19:50:36 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDF8F269D
        for <kvm@vger.kernel.org>; Fri, 12 May 2023 16:50:34 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-552f2f940edso189893447b3.0
        for <kvm@vger.kernel.org>; Fri, 12 May 2023 16:50:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1683935434; x=1686527434;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=nr0/2P0PrhPVltPxqFEO8yZGlq+w0+NW5S2btIKs8As=;
        b=WnOy9eWYFT1JeIO58JaMN1jZcMhT11BdOKPnALDAvrjMuhmZH42P9YhiZa/7JYaYGY
         ZpHrwciGnurOfJK9oBMXECwzcbEmpZfTWoGPFiZvJ8gE7xDpEIqA+FoxYyfH6y7DyEbJ
         +lNK1HZAQoGu6aWxcQqJxEpOkzAtMrWoFOh0Eelr1BaB+ZGd4k5UOiGGNYp9UpCi9D+z
         K5up0w1/ftbLw4OwW15WahGKHXE4yaa6gTWI6h7md8aEWjTJaNNiXhCLCQ9EeQlXZjhk
         M+9AdiXDgGvYOgot5GgzVAVDi+/PP32mF4DqfsRGOyX3UZkUQ2COmITahoXI/TtRngN+
         mU6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683935434; x=1686527434;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nr0/2P0PrhPVltPxqFEO8yZGlq+w0+NW5S2btIKs8As=;
        b=Bjqkld9zgiDT/06GaFV7uVO48uvYUTqU8qamG55YIKjax63VmdliSwHFE0yWCTZgYV
         D+txkkthpxFtIXKMwpo+oGwFAgeBngBUUj0WDmoIh8H8V2phWiaZnbDPDGIncauDfS8r
         byNN4SgtAmSb6SXr0+mv4shvUK1mwskyqvI+7A9L8lEgO6ciWXrKDXhCceeCnXS2nH9v
         QMd8kCN26qRnUAmhuZie9HJOyxp8E+QGtPsGiAurW9I+c8fJmSqVrng4l37m+4JaGhZ5
         C9fEBc4yWUbD95eOZo4qKjFVvus34KiUU/eVjljhrUMYV7rVxKXBtSEMM4vaVRt9fsvZ
         p31g==
X-Gm-Message-State: AC+VfDzk8ptBFKGhV1+pAm950nXjBuQUkBLyVo/GaUNoi41bfphdYQaI
        EwKVM8/D51dzLuMqq6PWs3Xj82r6wKI=
X-Google-Smtp-Source: ACHHUZ5fCcu/o8G8jp7gcUKE/IEMSr5CBYWwKcUGKW1V18cr7ZFI2S5aWNKXh3lhFT3tw6R83mDt0fyaSK8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:ca49:0:b0:55d:9484:f153 with SMTP id
 y9-20020a81ca49000000b0055d9484f153mr16043474ywk.7.1683935434025; Fri, 12 May
 2023 16:50:34 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 12 May 2023 16:50:10 -0700
In-Reply-To: <20230512235026.808058-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230512235026.808058-1-seanjc@google.com>
X-Mailer: git-send-email 2.40.1.606.ga4b1b128d6-goog
Message-ID: <20230512235026.808058-3-seanjc@google.com>
Subject: [PATCH v3 02/18] x86/reboot: Harden virtualization hooks for
 emergency reboot
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
        autolearn=ham autolearn_force=no version=3.4.6
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

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/reboot.h |  5 +++--
 arch/x86/kernel/reboot.c      | 30 ++++++++++++++++++++++++------
 arch/x86/kvm/vmx/vmx.c        |  6 ++----
 3 files changed, 29 insertions(+), 12 deletions(-)

diff --git a/arch/x86/include/asm/reboot.h b/arch/x86/include/asm/reboot.h
index 2551baec927d..d9a38d379d18 100644
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
index 299b970e5f82..739e09527dbb 100644
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
index 317f72baf0c3..fc9cdb4114cc 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -8547,8 +8547,7 @@ static void __vmx_exit(void)
 {
 	allow_smaller_maxphyaddr = false;
 
-	RCU_INIT_POINTER(crash_vmclear_loaded_vmcss, NULL);
-	synchronize_rcu();
+	cpu_emergency_unregister_virt_callback(crash_vmclear_local_loaded_vmcss);
 
 	vmx_cleanup_l1d_flush();
 }
@@ -8598,8 +8597,7 @@ static int __init vmx_init(void)
 		pi_init_cpu(cpu);
 	}
 
-	rcu_assign_pointer(crash_vmclear_loaded_vmcss,
-			   crash_vmclear_local_loaded_vmcss);
+	cpu_emergency_register_virt_callback(crash_vmclear_local_loaded_vmcss);
 
 	vmx_check_vmcs12_offsets();
 
-- 
2.40.1.606.ga4b1b128d6-goog

