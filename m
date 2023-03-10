Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D9C96B52FB
	for <lists+kvm@lfdr.de>; Fri, 10 Mar 2023 22:42:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231908AbjCJVmr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Mar 2023 16:42:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231872AbjCJVmn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Mar 2023 16:42:43 -0500
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C76D130C1C
        for <kvm@vger.kernel.org>; Fri, 10 Mar 2023 13:42:42 -0800 (PST)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-536a545bfbaso67510527b3.20
        for <kvm@vger.kernel.org>; Fri, 10 Mar 2023 13:42:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678484561;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=enCDXi9YsDemt2TTHxfwszJvRc2dXqyk89onukiwfQc=;
        b=SPuqihFsYK9loRsqerF2bubjM61LStKypskZQztDWFydbqKu4vX/erViPPJeSHsWvS
         rppVs6WV756orTYsyXgV+CjCRh365Fc5NpZI5KUA0XyW3pnmbiYruP15pQapOP52kQla
         EtuUG+8Jw357D32wLqbTIVCqAPfinsvXQpYfzJMc5sq/caBnqgXO88T8aLxhVIgvOnEb
         5owsW7BZvOZY2T8ls1H4Zw3mzTqVb7cXLPtdphlxezMpqOcdGM6cPlgwAnWSJomydpam
         5u/+pfPjb1ViCYG8h9uMxcGnfrMh6DUEDezA60Pe82tUdlOloVcnXkBTDLhCHaqAd20r
         tfIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678484561;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=enCDXi9YsDemt2TTHxfwszJvRc2dXqyk89onukiwfQc=;
        b=WXp9LwwZ764CNPv3iq2kjVEg0O9l+8i84xTJt4ONoGHhwOMXo+1+Sa6NRHqGYL2x+c
         d6/s4rBNXrj3pGTaG//9iAEWxdEO78To+uR/axcgvisY20x/Ffe5ituFCQ9sPv6QMURM
         tP1skdQQUdPj9NuqBgtSWgDKNf3viBAku3dIRoOGzkcr0QCDVIELIMH69hDndeolYidz
         2MyzbVfI+H8B/DXgKFDhIPAMFNb7n0PJ7+1MovpCEvomIE4jqaU5SJHzg+TTSs/Cmye5
         F6Ph36jwpCoZA/Msoog6lDNpEn2iOOZuZmueYtJ0zYoTWy5BihFIkS4MJ7FLVWARArDm
         XCEw==
X-Gm-Message-State: AO0yUKVZMamluxRq6wcA7f8RD3mI4B4Tz5INq9Lvx+ZSpu3PKXM6BqaF
        QdTJutcZ11zDb3SkfRh4DAXbYML5w6U=
X-Google-Smtp-Source: AK7set89sCoMUWq5lPoXpJ9IKev+DEMXpVUOi8qRUXRsyvW/chtV44e9uokRRM+YlyhpTR525TX5FmQjGdE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:a989:0:b0:534:1d7:fcf0 with SMTP id
 g131-20020a81a989000000b0053401d7fcf0mr17579810ywh.1.1678484561398; Fri, 10
 Mar 2023 13:42:41 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 10 Mar 2023 13:42:16 -0800
In-Reply-To: <20230310214232.806108-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230310214232.806108-1-seanjc@google.com>
X-Mailer: git-send-email 2.40.0.rc1.284.g88254d51c5-goog
Message-ID: <20230310214232.806108-3-seanjc@google.com>
Subject: [PATCH v2 02/18] x86/reboot: Expose VMCS crash hooks if and only if
 KVM_INTEL is enabled
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

Expose the crash/reboot hooks used by KVM to do VMCLEAR+VMXOFF if and
only if there's a potential in-tree user, KVM_INTEL.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/reboot.h | 2 ++
 arch/x86/kernel/reboot.c      | 4 ++++
 2 files changed, 6 insertions(+)

diff --git a/arch/x86/include/asm/reboot.h b/arch/x86/include/asm/reboot.h
index 2551baec927d..33c8e911e0de 100644
--- a/arch/x86/include/asm/reboot.h
+++ b/arch/x86/include/asm/reboot.h
@@ -25,8 +25,10 @@ void __noreturn machine_real_restart(unsigned int type);
 #define MRR_BIOS	0
 #define MRR_APM		1
 
+#if IS_ENABLED(CONFIG_KVM_INTEL)
 typedef void crash_vmclear_fn(void);
 extern crash_vmclear_fn __rcu *crash_vmclear_loaded_vmcss;
+#endif
 void cpu_emergency_disable_virtualization(void);
 
 typedef void (*nmi_shootdown_cb)(int, struct pt_regs*);
diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index 299b970e5f82..6c0b1634b884 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -787,6 +787,7 @@ void machine_crash_shutdown(struct pt_regs *regs)
 }
 #endif
 
+#if IS_ENABLED(CONFIG_KVM_INTEL)
 /*
  * This is used to VMCLEAR all VMCSs loaded on the
  * processor. And when loading kvm_intel module, the
@@ -807,6 +808,7 @@ static inline void cpu_crash_vmclear_loaded_vmcss(void)
 		do_vmclear_operation();
 	rcu_read_unlock();
 }
+#endif
 
 /* This is the CPU performing the emergency shutdown work. */
 int crashing_cpu = -1;
@@ -818,7 +820,9 @@ int crashing_cpu = -1;
  */
 void cpu_emergency_disable_virtualization(void)
 {
+#if IS_ENABLED(CONFIG_KVM_INTEL)
 	cpu_crash_vmclear_loaded_vmcss();
+#endif
 
 	cpu_emergency_vmxoff();
 	cpu_emergency_svm_disable();
-- 
2.40.0.rc1.284.g88254d51c5-goog

