Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BECD4EE3E0
	for <lists+kvm@lfdr.de>; Fri,  1 Apr 2022 00:14:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242337AbiCaWPw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 31 Mar 2022 18:15:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242163AbiCaWPv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 31 Mar 2022 18:15:51 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E44695D18C
        for <kvm@vger.kernel.org>; Thu, 31 Mar 2022 15:14:01 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id b18-20020a63d812000000b0037e1aa59c0bso521445pgh.12
        for <kvm@vger.kernel.org>; Thu, 31 Mar 2022 15:14:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:message-id:mime-version:subject:from:to:cc;
        bh=WqFtWphR/UHLeYzM1oGSvJgyeqw888ZXSOYKR2JBBUI=;
        b=am0uxU0L8wBDJedtxT9qkkbTUSFBgUty0LD1cYLq8JJi+EbE/65eI9nyL3Jm0q/SLc
         jddtZXKIpljr9U1jxRRo2qBdVy5LQNAIxV/OU/rLPlONfNoF1tfcmAcFonFtfJiyUM8n
         wEEs+M+nsyBfTXZFTCuERAgcQQ07YhQj1M+WgNLLWVvAWQbuWFQm0nRtCMo89sIcsPg4
         hxuPeCxQoGDJ9jyZb9Owb4Ex1CaW18TlUFIkhI71nsmcnGrAi57194BSF5EJkW1Vu0VU
         2IMmquLkcLqAUu1PH/oBlqPmCpjIurF0TXn7iqEvHe1cEyBT60Dc/mfcUxA94C/eyMaK
         nyXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:message-id:mime-version:subject
         :from:to:cc;
        bh=WqFtWphR/UHLeYzM1oGSvJgyeqw888ZXSOYKR2JBBUI=;
        b=6Z3JTaJUGYfIuXrPeW/dFEkE/j1sJcF8GMRNC5NpVEmwz66xKDoin/yzSOXdPJYwkt
         Tjg/qkGOz0jEEpHi+uaPo7HW6Vjcw+KL7SpXCKftto4MSI5zlHCjOMYqKCM0HcG24sIm
         nL3S1NKMCs2b2Awg+FJfceCVJMSkCVEUSDSCN4ejobykBE4s7ukmrufIW1kJoHB+aqSL
         1X51+uCIga3vf6aU3Ve7kLyWB2H+/HLDXEOwyl0vFRpB+hSmKTdgbcWcmB7nu+JVht1f
         ZOvbC3vdPJ1jZdC6B3QWwW5AxxVlT4YEBWyhxD+JuBzn8PKffJlASq9FDy1WCJQmprVv
         SpKA==
X-Gm-Message-State: AOAM531D+vVbi4Q7KpbJk7OOavoDPntx9n6JHykrENM6vvSRSTSN7jts
        A4hAJu4xKi72bAh3+efIo5qv7Z8UsUQ=
X-Google-Smtp-Source: ABdhPJzD7ZMubJruHEu0Kc8DIKiJXX/VvHZ7/irSHnQQoRbTrKrgzD/n5MDJQtNkacipDlzWrGtgVwC8BWE=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:903:32c7:b0:154:4156:f384 with SMTP id
 i7-20020a17090332c700b001544156f384mr7444389plr.34.1648764841447; Thu, 31 Mar
 2022 15:14:01 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 31 Mar 2022 22:13:59 +0000
Message-Id: <20220331221359.3912754-1-seanjc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.35.1.1094.g7c7d902a7c-goog
Subject: [PATCH] KVM: x86/mmu: Resolve nx_huge_pages when kvm.ko is loaded
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Bruno Goncalves <bgoncalv@redhat.com>,
        Jan Stancek <jstancek@redhat.com>
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

Resolve nx_huge_pages to true/false when kvm.ko is loaded, leaving it as
-1 is technically undefined behavior when its value is read out by
param_get_bool(), as boolean values are supposed to be '0' or '1'.

Alternatively, KVM could define a custom getter for the param, but the
auto value doesn't depend on the vendor module in any way, and printing
"auto" would be unnecessarily unfriendly to the user.

In addition to fixing the undefined behavior, resolving the auto value
also fixes the scenario where the auto value resolves to N and no vendor
module is loaded.  Previously, -1 would result in Y being printed even
though KVM would ultimately disable the mitigation.

Rename the existing MMU module init/exit helpers to clarify that they're
invoked with respect to the vendor module, and add comments to document
why KVM has two separate "module init" flows.

  =========================================================================
  UBSAN: invalid-load in kernel/params.c:320:33
  load of value 255 is not a valid value for type '_Bool'
  CPU: 6 PID: 892 Comm: tail Not tainted 5.17.0-rc3+ #799
  Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 0.0.0 02/06/2015
  Call Trace:
   <TASK>
   dump_stack_lvl+0x34/0x44
   ubsan_epilogue+0x5/0x40
   __ubsan_handle_load_invalid_value.cold+0x43/0x48
   param_get_bool.cold+0xf/0x14
   param_attr_show+0x55/0x80
   module_attr_show+0x1c/0x30
   sysfs_kf_seq_show+0x93/0xc0
   seq_read_iter+0x11c/0x450
   new_sync_read+0x11b/0x1a0
   vfs_read+0xf0/0x190
   ksys_read+0x5f/0xe0
   do_syscall_64+0x3b/0xc0
   entry_SYSCALL_64_after_hwframe+0x44/0xae
   </TASK>
  =========================================================================

Fixes: b8e8c8303ff2 ("kvm: mmu: ITLB_MULTIHIT mitigation")
Cc: stable@vger.kernel.org
Reported-by: Bruno Goncalves <bgoncalv@redhat.com>
Reported-by: Jan Stancek <jstancek@redhat.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_host.h |  5 +++--
 arch/x86/kvm/mmu/mmu.c          | 20 ++++++++++++++++----
 arch/x86/kvm/x86.c              | 20 ++++++++++++++++++--
 3 files changed, 37 insertions(+), 8 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 676705ad1e23..e58d630a5c76 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1598,8 +1598,9 @@ static inline int kvm_arch_flush_remote_tlb(struct kvm *kvm)
 #define kvm_arch_pmi_in_guest(vcpu) \
 	((vcpu) && (vcpu)->arch.handling_intr_from_guest)
 
-int kvm_mmu_module_init(void);
-void kvm_mmu_module_exit(void);
+void kvm_mmu_x86_module_init(void);
+int kvm_mmu_vendor_module_init(void);
+void kvm_mmu_vendor_module_exit(void);
 
 void kvm_mmu_destroy(struct kvm_vcpu *vcpu);
 int kvm_mmu_create(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index dbf46dd98618..c623019929a7 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -6237,12 +6237,24 @@ static int set_nx_huge_pages(const char *val, const struct kernel_param *kp)
 	return 0;
 }
 
-int kvm_mmu_module_init(void)
+/*
+ * nx_huge_pages needs to be resolved to true/false when kvm.ko is loaded, as
+ * its default value of -1 is technically undefined behavior for a boolean.
+ */
+void kvm_mmu_x86_module_init(void)
 {
-	int ret = -ENOMEM;
-
 	if (nx_huge_pages == -1)
 		__set_nx_huge_pages(get_nx_auto_mode());
+}
+
+/*
+ * The bulk of the MMU initialization is deferred until the vendor module is
+ * loaded as many of the masks/values may be modified by VMX or SVM, i.e. need
+ * to be reset when a potentially different vendor module is loaded.
+ */
+int kvm_mmu_vendor_module_init(void)
+{
+	int ret = -ENOMEM;
 
 	/*
 	 * MMU roles use union aliasing which is, generally speaking, an
@@ -6290,7 +6302,7 @@ void kvm_mmu_destroy(struct kvm_vcpu *vcpu)
 	mmu_free_memory_caches(vcpu);
 }
 
-void kvm_mmu_module_exit(void)
+void kvm_mmu_vendor_module_exit(void)
 {
 	mmu_destroy_caches();
 	percpu_counter_destroy(&kvm_total_used_mmu_pages);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 7a066cf92692..ad36f08a740d 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8954,7 +8954,7 @@ int kvm_arch_init(void *opaque)
 	}
 	kvm_nr_uret_msrs = 0;
 
-	r = kvm_mmu_module_init();
+	r = kvm_mmu_vendor_module_init();
 	if (r)
 		goto out_free_percpu;
 
@@ -9002,7 +9002,7 @@ void kvm_arch_exit(void)
 	cancel_work_sync(&pvclock_gtod_work);
 #endif
 	kvm_x86_ops.hardware_enable = NULL;
-	kvm_mmu_module_exit();
+	kvm_mmu_vendor_module_exit();
 	free_percpu(user_return_msrs);
 	kmem_cache_destroy(x86_emulator_cache);
 #ifdef CONFIG_KVM_XEN
@@ -13043,3 +13043,19 @@ EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_vmgexit_enter);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_vmgexit_exit);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_vmgexit_msr_protocol_enter);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_vmgexit_msr_protocol_exit);
+
+static int __init kvm_x86_init(void)
+{
+	kvm_mmu_x86_module_init();
+	return 0;
+}
+module_init(kvm_x86_init);
+
+static void __exit kvm_x86_exit(void)
+{
+	/*
+	 * If module_init() is implemented, module_exit() must also be
+	 * implemented to allow module unload.
+	 */
+}
+module_exit(kvm_x86_exit);

base-commit: 81d50efcff6cf4310aaf6a19806416ffeccf1cdb
-- 
2.35.1.1094.g7c7d902a7c-goog

