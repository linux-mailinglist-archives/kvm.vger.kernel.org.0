Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6874363E535
	for <lists+kvm@lfdr.de>; Thu,  1 Dec 2022 00:16:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230243AbiK3XQl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Nov 2022 18:16:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230134AbiK3XQG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Nov 2022 18:16:06 -0500
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56370A3215
        for <kvm@vger.kernel.org>; Wed, 30 Nov 2022 15:11:32 -0800 (PST)
Received: by mail-pj1-x1049.google.com with SMTP id ep17-20020a17090ae65100b00219702c495cso180834pjb.2
        for <kvm@vger.kernel.org>; Wed, 30 Nov 2022 15:11:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=pe1Kkjvkgy8PDlwU67QIc0+aecYuhy5E1AiDnDSceyU=;
        b=PtfTeuxltMAWC2r28YkEpC42/mHVqlVK9cbH6+HjFFnh8l3fnLdSvP/QyQcZjiH0fJ
         bAAP0a8yCSDYKaUdaH21SBJdNohuMejKBiChzsMvrmU4O6PwxgsyB11gpo8HZ1qpOnNj
         0KjvQaXNCIfI/gT8JFhhVnnRkflSvNYyY4jp8svnC7Lan9kSJyrM/U9WEp+pXRwL/qXE
         QPH/u84NCMboZU39GSXi9Lj4fcmoi1xI+xbEkS68VCcV+znlZLd7AdaPCKmQ9tBL0Okt
         aG5KOLnbOknW0mumwkbW75rjZaylsDPJeJ0+up/D0vzJ/h6wHyc7pmAOmpfzYxQCQRg1
         XCJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pe1Kkjvkgy8PDlwU67QIc0+aecYuhy5E1AiDnDSceyU=;
        b=PJMhFlw9Q+7pZr7gDbchUurZq8HZeybmbFxHcJiW/OL1025lG+XZqNnrWj+UpUgZTS
         TDqdYG/HwNO46t5nktCQ6tswN0dzR9oEK1bfuO6SrdJCp1Pkg9WS1IvmglssJgBgK7iH
         EJK6Pn4X1x8oxcBXMJDkSrZfYsz6Pe8oU3foIXpK9Z2OpQ51VyOshxjXia+zAyHNZSYC
         2ppLAG9XmsTw3QCEdPYMSY+wsB0Hvu4ZFipHTtxUQPVOLK3CWagqA621pgpfVB+8plAH
         RaUvrVk7+Bf4ImoAtwdX5ic2Q1mpl9B7XUf7KdqSFgyRnv9IhbzHIbZv+nDzvMDGIrkA
         sf7g==
X-Gm-Message-State: ANoB5pmpmU4B51kLPkB9B1HERUDWty3DDUXMHOGcGF4xCPEUwDhmBFB9
        fXM1RbFbzQsvwsmvbYZqEIiO38nmpZA=
X-Google-Smtp-Source: AA0mqf4jOwpuCSGbn98bo3vks+P0Y1utEHPDSunPwfv+lom3uyEWpWcpvAjoSiednnXdmVtMG3ik4xfUbWU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:2c87:b0:562:e790:dfe0 with SMTP id
 ef7-20020a056a002c8700b00562e790dfe0mr65114033pfb.16.1669849853870; Wed, 30
 Nov 2022 15:10:53 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 30 Nov 2022 23:09:28 +0000
In-Reply-To: <20221130230934.1014142-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221130230934.1014142-1-seanjc@google.com>
X-Mailer: git-send-email 2.38.1.584.g0f3c55d4c2-goog
Message-ID: <20221130230934.1014142-45-seanjc@google.com>
Subject: [PATCH v2 44/50] KVM: Drop kvm_count_lock and instead protect
 kvm_usage_count with kvm_lock
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

From: Isaku Yamahata <isaku.yamahata@intel.com>

Drop kvm_count_lock and instead protect kvm_usage_count with kvm_lock now
that KVM hooks CPU hotplug during the ONLINE phase, which can sleep.
Previously, KVM hooked the STARTING phase, which is not allowed to sleep
and thus could not take kvm_lock (a mutex).  This effectively allows the
task that's initiating hardware enabling/disabling to preempted and/or
migrated.

Note, the Documentation/virt/kvm/locking.rst statement that kvm_count_lock
is "raw" because hardware enabling/disabling needs to be atomic with
respect to migration is wrong on multiple fronts.  First, while regular
spinlocks can be preempted, the task holding the lock cannot be migrated.
Second, preventing migration is not required.  on_each_cpu() disables
preemption, which ensures that cpus_hardware_enabled correctly reflects
hardware state.  The task may be preempted/migrated between bumping
kvm_usage_count and invoking on_each_cpu(), but that's perfectly ok as
kvm_usage_count is still protected, e.g. other tasks that call
hardware_enable_all() will be blocked until the preempted/migrated owner
exits its critical section.

KVM does have lockless accesses to kvm_usage_count in the suspend/resume
flows, but those are safe because all tasks must be frozen prior to
suspending CPUs, and a task cannot be frozen while it holds one or more
locks (userspace tasks are frozen via a fake signal).

Preemption doesn't need to be explicitly disabled in the hotplug path.
The hotplug thread is pinned to the CPU that's being hotplugged, and KVM
only cares about having a stable CPU, i.e. to ensure hardware is enabled
on the correct CPU.  Lockep, i.e. check_preemption_disabled(), plays nice
with this state too, as is_percpu_thread() is true for the hotplug thread.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 Documentation/virt/kvm/locking.rst | 19 ++++++++--------
 virt/kvm/kvm_main.c                | 36 ++++++++++++++++++++----------
 2 files changed, 34 insertions(+), 21 deletions(-)

diff --git a/Documentation/virt/kvm/locking.rst b/Documentation/virt/kvm/locking.rst
index 132a9e5436e5..cd570e565522 100644
--- a/Documentation/virt/kvm/locking.rst
+++ b/Documentation/virt/kvm/locking.rst
@@ -9,6 +9,8 @@ KVM Lock Overview
 
 The acquisition orders for mutexes are as follows:
 
+- cpus_read_lock() is taken outside kvm_lock
+
 - kvm->lock is taken outside vcpu->mutex
 
 - kvm->lock is taken outside kvm->slots_lock and kvm->irq_lock
@@ -216,15 +218,10 @@ time it will be set using the Dirty tracking mechanism described above.
 :Type:		mutex
 :Arch:		any
 :Protects:	- vm_list
-
-``kvm_count_lock``
-^^^^^^^^^^^^^^^^^^
-
-:Type:		raw_spinlock_t
-:Arch:		any
-:Protects:	- hardware virtualization enable/disable
-:Comment:	'raw' because hardware enabling/disabling must be atomic /wrt
-		migration.
+		- kvm_usage_count
+		- hardware virtualization enable/disable
+:Comment:	KVM also disables CPU hotplug via cpus_read_lock() during
+		enable/disable.
 
 ``kvm->mn_invalidate_lock``
 ^^^^^^^^^^^^^^^^^^^^^^^^^^^
@@ -288,3 +285,7 @@ time it will be set using the Dirty tracking mechanism described above.
 :Type:		mutex
 :Arch:		x86
 :Protects:	loading a vendor module (kvm_amd or kvm_intel)
+:Comment:	Exists because using kvm_lock leads to deadlock.  cpu_hotplug_lock is
+    taken outside of kvm_lock, e.g. in KVM's CPU online/offline callbacks, and
+    many operations need to take cpu_hotplug_lock when loading a vendor module,
+    e.g. updating static calls.
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index a46d61e9c053..6a8fb53b32f0 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -100,7 +100,6 @@ EXPORT_SYMBOL_GPL(halt_poll_ns_shrink);
  */
 
 DEFINE_MUTEX(kvm_lock);
-static DEFINE_RAW_SPINLOCK(kvm_count_lock);
 LIST_HEAD(vm_list);
 
 static cpumask_var_t cpus_hardware_enabled;
@@ -5054,17 +5053,18 @@ static int kvm_online_cpu(unsigned int cpu)
 	 * be enabled. Otherwise running VMs would encounter unrecoverable
 	 * errors when scheduled to this CPU.
 	 */
-	raw_spin_lock(&kvm_count_lock);
+	mutex_lock(&kvm_lock);
 	if (kvm_usage_count) {
 		WARN_ON_ONCE(atomic_read(&hardware_enable_failed));
 
 		hardware_enable_nolock(NULL);
+
 		if (atomic_read(&hardware_enable_failed)) {
 			atomic_set(&hardware_enable_failed, 0);
 			ret = -EIO;
 		}
 	}
-	raw_spin_unlock(&kvm_count_lock);
+	mutex_unlock(&kvm_lock);
 	return ret;
 }
 
@@ -5080,10 +5080,10 @@ static void hardware_disable_nolock(void *junk)
 
 static int kvm_offline_cpu(unsigned int cpu)
 {
-	raw_spin_lock(&kvm_count_lock);
+	mutex_lock(&kvm_lock);
 	if (kvm_usage_count)
 		hardware_disable_nolock(NULL);
-	raw_spin_unlock(&kvm_count_lock);
+	mutex_unlock(&kvm_lock);
 	return 0;
 }
 
@@ -5099,9 +5099,9 @@ static void hardware_disable_all_nolock(void)
 static void hardware_disable_all(void)
 {
 	cpus_read_lock();
-	raw_spin_lock(&kvm_count_lock);
+	mutex_lock(&kvm_lock);
 	hardware_disable_all_nolock();
-	raw_spin_unlock(&kvm_count_lock);
+	mutex_unlock(&kvm_lock);
 	cpus_read_unlock();
 }
 
@@ -5118,7 +5118,7 @@ static int hardware_enable_all(void)
 	 * enable hardware multiple times.
 	 */
 	cpus_read_lock();
-	raw_spin_lock(&kvm_count_lock);
+	mutex_lock(&kvm_lock);
 
 	kvm_usage_count++;
 	if (kvm_usage_count == 1) {
@@ -5131,7 +5131,7 @@ static int hardware_enable_all(void)
 		}
 	}
 
-	raw_spin_unlock(&kvm_count_lock);
+	mutex_unlock(&kvm_lock);
 	cpus_read_unlock();
 
 	return r;
@@ -5737,6 +5737,17 @@ static void kvm_init_debug(void)
 
 static int kvm_suspend(void)
 {
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
 	if (kvm_usage_count)
 		hardware_disable_nolock(NULL);
 	return 0;
@@ -5744,10 +5755,11 @@ static int kvm_suspend(void)
 
 static void kvm_resume(void)
 {
-	if (kvm_usage_count) {
-		lockdep_assert_not_held(&kvm_count_lock);
+	lockdep_assert_not_held(&kvm_lock);
+	lockdep_assert_irqs_disabled();
+
+	if (kvm_usage_count)
 		hardware_enable_nolock(NULL);
-	}
 }
 
 static struct syscore_ops kvm_syscore_ops = {
-- 
2.38.1.584.g0f3c55d4c2-goog

