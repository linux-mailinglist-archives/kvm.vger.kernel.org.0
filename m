Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B40061729A
	for <lists+kvm@lfdr.de>; Thu,  3 Nov 2022 00:27:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231137AbiKBX1Y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Nov 2022 19:27:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231602AbiKBXZi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Nov 2022 19:25:38 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFF6612088
        for <kvm@vger.kernel.org>; Wed,  2 Nov 2022 16:20:44 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id k7-20020a256f07000000b006cbcc030bc8so333478ybc.18
        for <kvm@vger.kernel.org>; Wed, 02 Nov 2022 16:20:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=nvDOwkn7hwg+zfvJUXf8AHfTsU5S0iCSbbYe/XAvrQI=;
        b=kPsyz565Bs3nWd/vXeOuSWMgvIdI7+RJdtnuc0znmJIjMQ8uzXLRwKs8W7PumGf1FB
         TInnWKg6dZjNDAKuYUbWAGztsfGiZ+tk8yY6bKPVrq1xzztMo8xlFpqIJ6lhzJTHDPrm
         lou7lyJZKFxoJ8wozjn3uJXVRhz+EYknGTCWfTAQUsNnFbSP/SLgEfh6MyRvKfldCG8U
         pqOyiOjbRpZeYdvtQ7S7c4kgRIPHFaJSoTRioybyXKPMMU3h/v/TNXPFUOrsn8FChvzn
         JAwsqVkjZPDDeC2WWvWJ0112+KgndOYyfFTaXcofTGWmMGiul8k48NIfwWZFm0EpNX4X
         UhZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nvDOwkn7hwg+zfvJUXf8AHfTsU5S0iCSbbYe/XAvrQI=;
        b=MJntOLZpOvnT9+cEWvNYRAaKsll2oiHijCD+jqhLdWCTzAdbD3GWOHpJyaJev8C9Rz
         ZpMCbw4IsjSa76B9AaFScOmVO5A64rZmmCecVdRB57pArLXukbuiwcKgIlnKSrdc7ey1
         ga23iayZzK9VgTnmW936++pdr3SBnryvakX/baGGEs6DgeD6zxRhuTWOrXaf5rqYINfJ
         VmQyXbJE03laNjQDhlhYrgN67bIPDULrwY89GqifrRQOSOKijIRmc+IrGx+8j3ak5ihX
         gnbUhZayzsriyG7D/i4ubizHsitT5xigt6Knd2YYeoVyPwKVPufutIR8z/lysN2Jiy6G
         5s+w==
X-Gm-Message-State: ACrzQf1spjlf1u2XGbt3u1LpMjr0XGON54FxgF5HcUfOHMbjJdmrzATT
        yyFA50BLTUnxAUkd3eZQjT5Ed6iG7BU=
X-Google-Smtp-Source: AMsMyM5eowv7lcJiOd868nUuFM6ikjnC3RuvYPPk5CroI1jtu45SCXqk7PcUOxGjfgiO1DuVsExFVnovkSQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:b9b:b0:367:7d5a:3403 with SMTP id
 ck27-20020a05690c0b9b00b003677d5a3403mr179885ywb.148.1667431228175; Wed, 02
 Nov 2022 16:20:28 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  2 Nov 2022 23:19:10 +0000
In-Reply-To: <20221102231911.3107438-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221102231911.3107438-1-seanjc@google.com>
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Message-ID: <20221102231911.3107438-44-seanjc@google.com>
Subject: [PATCH 43/44] KVM: Register syscore (suspend/resume) ops early in kvm_init()
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Anup Patel <anup@brainfault.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Atish Patra <atishp@atishpatra.org>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        kvmarm@lists.cs.columbia.edu, linux-mips@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Isaku Yamahata <isaku.yamahata@intel.com>,
        Fabiano Rosas <farosas@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Chao Gao <chao.gao@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Yuan Yao <yuan.yao@intel.com>
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

Register the suspend/resume notifier hooks at the same time KVM registers
its reboot notifier so that all the code in kvm_init() that deals with
enabling/disabling hardware is bundled together.  Opportunstically move
KVM's implementations to reside near the reboot notifier code for the
same reason.

Bunching the code together will allow architectures to opt out of KVM's
generic hardware enable/disable logic with minimal #ifdeffery.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 virt/kvm/kvm_main.c | 64 ++++++++++++++++++++++-----------------------
 1 file changed, 32 insertions(+), 32 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index a18296ee731b..859bc27091cd 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -5142,6 +5142,36 @@ static struct notifier_block kvm_reboot_notifier = {
 	.priority = 0,
 };
 
+static int kvm_suspend(void)
+{
+	/*
+	 * Secondary CPUs and CPU hotplug are disabled across the suspend/resume
+	 * callbacks, i.e. no need to acquire kvm_lock to ensure the usage count
+	 * is stable.  Assert that kvm_lock is not held as a paranoid sanity
+	 * check that the system isn't suspended when KVM is enabling hardware.
+	 */
+	lockdep_assert_not_held(&kvm_lock);
+	lockdep_assert_irqs_disabled();
+
+	if (kvm_usage_count)
+		hardware_disable_nolock(NULL);
+	return 0;
+}
+
+static void kvm_resume(void)
+{
+	lockdep_assert_not_held(&kvm_lock);
+	lockdep_assert_irqs_disabled();
+
+	if (kvm_usage_count)
+		WARN_ON_ONCE(__hardware_enable_nolock());
+}
+
+static struct syscore_ops kvm_syscore_ops = {
+	.suspend = kvm_suspend,
+	.resume = kvm_resume,
+};
+
 static void kvm_io_bus_destroy(struct kvm_io_bus *bus)
 {
 	int i;
@@ -5720,36 +5750,6 @@ static void kvm_init_debug(void)
 	}
 }
 
-static int kvm_suspend(void)
-{
-	/*
-	 * Secondary CPUs and CPU hotplug are disabled across the suspend/resume
-	 * callbacks, i.e. no need to acquire kvm_lock to ensure the usage count
-	 * is stable.  Assert that kvm_lock is not held as a paranoid sanity
-	 * check that the system isn't suspended when KVM is enabling hardware.
-	 */
-	lockdep_assert_not_held(&kvm_lock);
-	lockdep_assert_irqs_disabled();
-
-	if (kvm_usage_count)
-		hardware_disable_nolock(NULL);
-	return 0;
-}
-
-static void kvm_resume(void)
-{
-	lockdep_assert_not_held(&kvm_lock);
-	lockdep_assert_irqs_disabled();
-
-	if (kvm_usage_count)
-		WARN_ON_ONCE(__hardware_enable_nolock());
-}
-
-static struct syscore_ops kvm_syscore_ops = {
-	.suspend = kvm_suspend,
-	.resume = kvm_resume,
-};
-
 static inline
 struct kvm_vcpu *preempt_notifier_to_vcpu(struct preempt_notifier *pn)
 {
@@ -5865,6 +5865,7 @@ int kvm_init(unsigned vcpu_size, unsigned vcpu_align, struct module *module)
 		return r;
 
 	register_reboot_notifier(&kvm_reboot_notifier);
+	register_syscore_ops(&kvm_syscore_ops);
 
 	/* A kmem cache lets us meet the alignment requirements of fx_save. */
 	if (!vcpu_align)
@@ -5899,8 +5900,6 @@ int kvm_init(unsigned vcpu_size, unsigned vcpu_align, struct module *module)
 
 	kvm_chardev_ops.owner = module;
 
-	register_syscore_ops(&kvm_syscore_ops);
-
 	kvm_preempt_ops.sched_in = kvm_sched_in;
 	kvm_preempt_ops.sched_out = kvm_sched_out;
 
@@ -5934,6 +5933,7 @@ int kvm_init(unsigned vcpu_size, unsigned vcpu_align, struct module *module)
 		free_cpumask_var(per_cpu(cpu_kick_mask, cpu));
 	kmem_cache_destroy(kvm_vcpu_cache);
 out_free_3:
+	unregister_syscore_ops(&kvm_syscore_ops);
 	unregister_reboot_notifier(&kvm_reboot_notifier);
 	cpuhp_remove_state_nocalls(CPUHP_AP_KVM_ONLINE);
 	return r;
-- 
2.38.1.431.g37b22c650d-goog

