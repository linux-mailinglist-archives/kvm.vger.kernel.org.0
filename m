Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C66363E546
	for <lists+kvm@lfdr.de>; Thu,  1 Dec 2022 00:17:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230116AbiK3XRk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Nov 2022 18:17:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229966AbiK3XQk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Nov 2022 18:16:40 -0500
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F12787743B
        for <kvm@vger.kernel.org>; Wed, 30 Nov 2022 15:11:49 -0800 (PST)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-3c44ac82606so206837b3.1
        for <kvm@vger.kernel.org>; Wed, 30 Nov 2022 15:11:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=f1ges7v12pOnWRvBGxVUQ1iVkaen+bCiwnszqRspz5I=;
        b=gLeoYszhyNvT3b/sb5uYSwOA01VKPMWAXDjqkZYRdtKGfM6Ek/arh5xQWkT5U5yzoB
         5CD5ESLZv4WU1n/4uB06OdwXMxCseYp9IaQQLNVjv3WwPdnRofjslDSFaOM0xGYsKK+C
         tKX3chEelyUD8sc6Y74rDxDyt3aY3CP6z+j1KZWlrcIRv9diHP2iozhFk/Mchi+TTVgv
         fEeeQaF+pMBa6yom6DRZvH7p+HjJ0Tg0Rdf0l2eI9+N1rfc39tpiDCp65RGs1ugAXHHv
         MGoQYmmnBoVyTjRNQhOEvAGKhAuRN2t7CBn2+Bl7DY/FSOnm9dbPq0iYKWwQsZDGX6rY
         /NUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=f1ges7v12pOnWRvBGxVUQ1iVkaen+bCiwnszqRspz5I=;
        b=QJjtW1EbIzUUTdJa6iwVuRq80SXPngTMAVd71Vw8YCYPsbag1gxp3fJweT6GglkmLa
         MYjmuEW1xVR1AJGXlwN+aUzoM5M2BVQx4Xx6TZ1p5lM6EotsiuGyr/c516QICAgSyM3V
         Sb39DAEt372TozbBRC80K1PXOPcdvr5KzGuOmKM8W7+ZhbKZKotSS6s6tPIulml2gt8V
         VBUl72lcErUzKV5ASDigbvP0mTJkmmXTXaytfqkpuSZD+oI32Yg4ngEVIigUlOG6Yxqw
         OW9cSGYgFQzR0I1lOHjoSOL5w1WXaZVAdLXtYQb3RLab9hDs7F7ftd3VL8zUGg8P1sKG
         I0Ow==
X-Gm-Message-State: ANoB5pmCxX69crXy48vxr2nf0UTp1ixC9CAjzBypfBGZJobscii0CC+3
        BArScShEzNEq+5XTHN77gi1v1YBRGh0=
X-Google-Smtp-Source: AA0mqf63ZlaX4G2YNi86TQbzic6Ybrn3ErpM5Fv6RATCbhjBaKzM7IKwyP6eEXyUhb9VuIg8OaKUkjA30b8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:a0cc:0:b0:6f7:4be9:89f8 with SMTP id
 i12-20020a25a0cc000000b006f74be989f8mr14935825ybm.345.1669849861304; Wed, 30
 Nov 2022 15:11:01 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 30 Nov 2022 23:09:32 +0000
In-Reply-To: <20221130230934.1014142-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221130230934.1014142-1-seanjc@google.com>
X-Mailer: git-send-email 2.38.1.584.g0f3c55d4c2-goog
Message-ID: <20221130230934.1014142-49-seanjc@google.com>
Subject: [PATCH v2 48/50] KVM: Register syscore (suspend/resume) ops early in kvm_init()
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
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Paul Durrant <paul@xen.org>
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
        linux-kernel@vger.kernel.org, Yuan Yao <yuan.yao@intel.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Isaku Yamahata <isaku.yamahata@intel.com>,
        "=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?=" <philmd@linaro.org>,
        Fabiano Rosas <farosas@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Kai Huang <kai.huang@intel.com>, Chao Gao <chao.gao@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>
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
 virt/kvm/kvm_main.c | 68 ++++++++++++++++++++++-----------------------
 1 file changed, 34 insertions(+), 34 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 674a9dab5411..c12db3839114 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -5154,6 +5154,38 @@ static struct notifier_block kvm_reboot_notifier = {
 	.priority = 0,
 };
 
+static int kvm_suspend(void)
+{
+	/*
+	 * Secondary CPUs and CPU hotplug are disabled across the suspend/resume
+	 * callbacks, i.e. no need to acquire kvm_lock to ensure the usage count
+	 * is stable.  Assert that kvm_lock is not held to ensure the system
+	 * isn't suspended while KVM is enabling hardware.  Hardware enabling
+	 * can be preempted, but the task cannot be frozen until it has dropped
+	 * all locks (userspace tasks are frozen via a fake signal).
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
@@ -5732,38 +5764,6 @@ static void kvm_init_debug(void)
 	}
 }
 
-static int kvm_suspend(void)
-{
-	/*
-	 * Secondary CPUs and CPU hotplug are disabled across the suspend/resume
-	 * callbacks, i.e. no need to acquire kvm_lock to ensure the usage count
-	 * is stable.  Assert that kvm_lock is not held to ensure the system
-	 * isn't suspended while KVM is enabling hardware.  Hardware enabling
-	 * can be preempted, but the task cannot be frozen until it has dropped
-	 * all locks (userspace tasks are frozen via a fake signal).
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
@@ -5879,6 +5879,7 @@ int kvm_init(unsigned vcpu_size, unsigned vcpu_align, struct module *module)
 		return r;
 
 	register_reboot_notifier(&kvm_reboot_notifier);
+	register_syscore_ops(&kvm_syscore_ops);
 
 	/* A kmem cache lets us meet the alignment requirements of fx_save. */
 	if (!vcpu_align)
@@ -5913,8 +5914,6 @@ int kvm_init(unsigned vcpu_size, unsigned vcpu_align, struct module *module)
 
 	kvm_chardev_ops.owner = module;
 
-	register_syscore_ops(&kvm_syscore_ops);
-
 	kvm_preempt_ops.sched_in = kvm_sched_in;
 	kvm_preempt_ops.sched_out = kvm_sched_out;
 
@@ -5948,6 +5947,7 @@ int kvm_init(unsigned vcpu_size, unsigned vcpu_align, struct module *module)
 		free_cpumask_var(per_cpu(cpu_kick_mask, cpu));
 	kmem_cache_destroy(kvm_vcpu_cache);
 out_free_3:
+	unregister_syscore_ops(&kvm_syscore_ops);
 	unregister_reboot_notifier(&kvm_reboot_notifier);
 	cpuhp_remove_state_nocalls(CPUHP_AP_KVM_ONLINE);
 	return r;
-- 
2.38.1.584.g0f3c55d4c2-goog

