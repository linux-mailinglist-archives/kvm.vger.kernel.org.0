Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 834AA7012B2
	for <lists+kvm@lfdr.de>; Sat, 13 May 2023 01:51:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241147AbjELXvc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 May 2023 19:51:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241002AbjELXvB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 May 2023 19:51:01 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03ED1A5EA
        for <kvm@vger.kernel.org>; Fri, 12 May 2023 16:50:45 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id 41be03b00d2f7-5301ed4ba6bso4215134a12.1
        for <kvm@vger.kernel.org>; Fri, 12 May 2023 16:50:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1683935444; x=1686527444;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=/1IPICvf7oBSkQ+FrPIawf/Mg2EXS+lcMpbXqr7FjNI=;
        b=TymfnqyOMHELbo2UfU2++anjDyQ5g/Fd3TGS65R1rGGjB5ZdpTRVOXWGPFiLTKxtrv
         wyJwbLAFaG+N5fESRVELoolS3Ul5LAUQJUBqoWxGuaYg7kIBA6li7RU69Y3DVPBExuRj
         Gz1TmaQpvxIm8yq8J96nz+Oy0ixKCzQ/92URbshs0tQynmouaoSlkYRkCUGvL2dQZLnw
         OURA4pD1v+JIREOhUZ+cjyPIOh2nkk+u0EgwbQhEgrifasOJ4LgFsX1ONtqhrf8PM17V
         yzAx6U/uE7gXlrCYy1lBNHL4CGo0tog2DdHnZmEY9831+q9P6JXpZGiTnNjxJAmQpWnJ
         aatA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683935444; x=1686527444;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/1IPICvf7oBSkQ+FrPIawf/Mg2EXS+lcMpbXqr7FjNI=;
        b=iotw3Kb/Hbv674fIG96ey5YbocHWJOTCpa7xpw1ZRr8p5XZ1po6jy+Y5f8GL8xW8M0
         XhAnqBDskesmki2lajVIY7ZZrkTeB4yJxDGDh4Ntna8Nq8Og4Qg9UGMOXKBQsN+Jv4mO
         sR9Q9RwKmCewyDTJPq6H3QBWBtojt60QSEjtT3LodT/w3180jk9AX7PjU9p4XV/nGAkx
         HziNXcawrzwqDRa+1KfhGuXfQKHfXB2TIJTaQkN/ysIwWuvyU6tZz+9zOJv5T/RibTPP
         qa26yQ50rSC+gM4qsaAK7NnzMlsHpRpDrHNJhUTxN/kaV1/m3xv8PlFv6vfS2LcM4/UX
         vbmg==
X-Gm-Message-State: AC+VfDwFtJX9heGKtYXRkF8AnjFd6aP20G2enSAS/7HEKk8lhJo5HH3c
        sDEoUhGk6ZmFTCIVHjZXZV6Pd477g74=
X-Google-Smtp-Source: ACHHUZ4NkybXz2S8sZ+f7jfd9GQ8/ArkxwtmNPQiM8HUXTMa0NPm7uvWK7LDMj15Q8ugWGuQHxy6T5Nx4TM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:8ac1:0:b0:52c:8878:65dc with SMTP id
 y184-20020a638ac1000000b0052c887865dcmr7791562pgd.1.1683935444712; Fri, 12
 May 2023 16:50:44 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 12 May 2023 16:50:16 -0700
In-Reply-To: <20230512235026.808058-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230512235026.808058-1-seanjc@google.com>
X-Mailer: git-send-email 2.40.1.606.ga4b1b128d6-goog
Message-ID: <20230512235026.808058-9-seanjc@google.com>
Subject: [PATCH v3 08/18] x86/reboot: Expose VMCS crash hooks if and only if
 KVM_{INTEL,AMD} is enabled
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

Expose the crash/reboot hooks used by KVM to disable virtualization in
hardware and unblock INIT only if there's a potential in-tree user,
i.e. either KVM_INTEL or KVM_AMD is enabled.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/reboot.h | 4 ++++
 arch/x86/kernel/reboot.c      | 5 ++++-
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/reboot.h b/arch/x86/include/asm/reboot.h
index d9a38d379d18..9cf0b21bf495 100644
--- a/arch/x86/include/asm/reboot.h
+++ b/arch/x86/include/asm/reboot.h
@@ -25,10 +25,14 @@ void __noreturn machine_real_restart(unsigned int type);
 #define MRR_BIOS	0
 #define MRR_APM		1
 
+#if IS_ENABLED(CONFIG_KVM_INTEL) || IS_ENABLED(CONFIG_KVM_AMD)
 typedef void (cpu_emergency_virt_cb)(void);
 void cpu_emergency_register_virt_callback(cpu_emergency_virt_cb *callback);
 void cpu_emergency_unregister_virt_callback(cpu_emergency_virt_cb *callback);
 void cpu_emergency_disable_virtualization(void);
+#else
+static inline void cpu_emergency_disable_virtualization(void) {}
+#endif /* CONFIG_KVM_INTEL || CONFIG_KVM_AMD */
 
 typedef void (*nmi_shootdown_cb)(int, struct pt_regs*);
 void nmi_panic_self_stop(struct pt_regs *regs);
diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index 493d66e59a4f..6818d8de85a1 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -529,6 +529,7 @@ static inline void kb_wait(void)
 
 static inline void nmi_shootdown_cpus_on_restart(void);
 
+#if IS_ENABLED(CONFIG_KVM_INTEL) || IS_ENABLED(CONFIG_KVM_AMD)
 /* RCU-protected callback to disable virtualization prior to reboot. */
 static cpu_emergency_virt_cb __rcu *cpu_emergency_virt_callback;
 
@@ -596,7 +597,9 @@ static void emergency_reboot_disable_virtualization(void)
 		nmi_shootdown_cpus_on_restart();
 	}
 }
-
+#else
+static void emergency_reboot_disable_virtualization(void) { }
+#endif /* CONFIG_KVM_INTEL || CONFIG_KVM_AMD */
 
 void __attribute__((weak)) mach_reboot_fixups(void)
 {
-- 
2.40.1.606.ga4b1b128d6-goog

