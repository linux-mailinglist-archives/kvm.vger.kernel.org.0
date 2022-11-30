Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7141463E4C3
	for <lists+kvm@lfdr.de>; Thu,  1 Dec 2022 00:12:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229688AbiK3XM3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Nov 2022 18:12:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229944AbiK3XLU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Nov 2022 18:11:20 -0500
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0E279AE25
        for <kvm@vger.kernel.org>; Wed, 30 Nov 2022 15:10:18 -0800 (PST)
Received: by mail-pg1-x54a.google.com with SMTP id l186-20020a6388c3000000b00478410026bfso84310pgd.10
        for <kvm@vger.kernel.org>; Wed, 30 Nov 2022 15:10:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=DDPlKttPz95bIPigIbsZnvNedazYOn7GaaeDonhS6tI=;
        b=Z6nLxfTzgTUuiwpAG8cvYQa+dN+u8gdYDmvalMupYvTiyNB08ya32PPN3JMi5MQ+zn
         CKFON4bHGY9uO+OU5rvKypZLm5hBqJSLnUUDK1HFwnV5UgI7QftrXIwrcqqGD/J7JfqE
         CFBmidj59C7V6og88vcOwpoym4GNhD2bRgcqaNBUXoe/misowqQibWZd3vr8QsfUhhwX
         i4uWK4yeRp3DB4lRFiuIJyrUfchRtOmsamHvLHwY72jxQuWnDEt5quvvWruAYj+4E7Dq
         3qk+oHrWcenEcx4E4wlD8i3c5crP7WSMTS/kUAiUvOcd3cx88naWVp5yOAiefRxYVySU
         2z9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DDPlKttPz95bIPigIbsZnvNedazYOn7GaaeDonhS6tI=;
        b=UfG+3bik5/5n9RuIRKm+sQQigg3pew12nTt09KFv2AdIU2myIwiZfK3NJvhNnxZ33i
         reOBqm/F7f9/CNyBexjCJe2hByQ9VN3eKUI+AslaIIq4s4ai3uFBkRBFIcWZUYZnNl4A
         eu3PcguYHsXL6W6rDLG0C+u2q0UA6CTzrSLmAhyr5ubgWSJEXk8ek9Yb3oWTuCbc8qrH
         F4oqdCN9nSEiEDc4mLqoDXVfYiGjYDiRQpuyh4phks+uVt3yMyUetyxGdUAxwd7u9Pfj
         RiuM70GLo25ccjAwlvooS+fPbrFfdFYwaa/f8HIHA6RnbdyR4FH0KHmcOIoPJsNiQFo2
         ePyQ==
X-Gm-Message-State: ANoB5pkEHqtD1TY8f/J4QTTGrYyx9oOHUh4azCJScrMlkV3wUJecBQgZ
        ZOtLtPx3WywdlKkm1dz7evnyf1Cl03w=
X-Google-Smtp-Source: AA0mqf5zruXq4Znt6GWyW9YI72qBn8AYfe7bpB45wh6N7oxAIVQAewpSb0tYUlF1SUbzH3yBDOmCkMMzIcM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:b691:b0:17e:fb19:63ba with SMTP id
 c17-20020a170902b69100b0017efb1963bamr47034838pls.160.1669849802860; Wed, 30
 Nov 2022 15:10:02 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 30 Nov 2022 23:08:59 +0000
In-Reply-To: <20221130230934.1014142-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221130230934.1014142-1-seanjc@google.com>
X-Mailer: git-send-email 2.38.1.584.g0f3c55d4c2-goog
Message-ID: <20221130230934.1014142-16-seanjc@google.com>
Subject: [PATCH v2 15/50] KVM: x86: Serialize vendor module initialization
 (hardware setup)
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

Acquire a new mutex, vendor_module_lock, in kvm_x86_vendor_init() while
doing hardware setup to ensure that concurrent calls are fully serialized.
KVM rejects attempts to load vendor modules if a different module has
already been loaded, but doesn't handle the case where multiple vendor
modules are loaded at the same time, and module_init() doesn't run under
the global module_mutex.

Note, in practice, this is likely a benign bug as no platform exists that
supports both SVM and VMX, i.e. barring a weird VM setup, one of the
vendor modules is guaranteed to fail a support check before modifying
common KVM state.

Alternatively, KVM could perform an atomic CMPXCHG on .hardware_enable,
but that comes with its own ugliness as it would require setting
.hardware_enable before success is guaranteed, e.g. attempting to load
the "wrong" could result in spurious failure to load the "right" module.

Introduce a new mutex as using kvm_lock is extremely deadlock prone due
to kvm_lock being taken under cpus_write_lock(), and in the future, under
under cpus_read_lock().  Any operation that takes cpus_read_lock() while
holding kvm_lock would potentially deadlock, e.g. kvm_timer_init() takes
cpus_read_lock() to register a callback.  In theory, KVM could avoid
such problematic paths, i.e. do less setup under kvm_lock, but avoiding
all calls to cpus_read_lock() is subtly difficult and thus fragile.  E.g.
updating static calls also acquires cpus_read_lock().

Inverting the lock ordering, i.e. always taking kvm_lock outside
cpus_read_lock(), is not a viable option as kvm_lock is taken in various
callbacks that may be invoked under cpus_read_lock(), e.g. x86's
kvmclock_cpufreq_notifier().

The lockdep splat below is dependent on future patches to take
cpus_read_lock() in hardware_enable_all(), but as above, deadlock is
already is already possible.

  ======================================================
  WARNING: possible circular locking dependency detected
  6.0.0-smp--7ec93244f194-init2 #27 Tainted: G           O
  ------------------------------------------------------
  stable/251833 is trying to acquire lock:
  ffffffffc097ea28 (kvm_lock){+.+.}-{3:3}, at: hardware_enable_all+0x1f/0xc0 [kvm]

               but task is already holding lock:
  ffffffffa2456828 (cpu_hotplug_lock){++++}-{0:0}, at: hardware_enable_all+0xf/0xc0 [kvm]

               which lock already depends on the new lock.

               the existing dependency chain (in reverse order) is:

               -> #1 (cpu_hotplug_lock){++++}-{0:0}:
         cpus_read_lock+0x2a/0xa0
         __cpuhp_setup_state+0x2b/0x60
         __kvm_x86_vendor_init+0x16a/0x1870 [kvm]
         kvm_x86_vendor_init+0x23/0x40 [kvm]
         0xffffffffc0a4d02b
         do_one_initcall+0x110/0x200
         do_init_module+0x4f/0x250
         load_module+0x1730/0x18f0
         __se_sys_finit_module+0xca/0x100
         __x64_sys_finit_module+0x1d/0x20
         do_syscall_64+0x3d/0x80
         entry_SYSCALL_64_after_hwframe+0x63/0xcd

               -> #0 (kvm_lock){+.+.}-{3:3}:
         __lock_acquire+0x16f4/0x30d0
         lock_acquire+0xb2/0x190
         __mutex_lock+0x98/0x6f0
         mutex_lock_nested+0x1b/0x20
         hardware_enable_all+0x1f/0xc0 [kvm]
         kvm_dev_ioctl+0x45e/0x930 [kvm]
         __se_sys_ioctl+0x77/0xc0
         __x64_sys_ioctl+0x1d/0x20
         do_syscall_64+0x3d/0x80
         entry_SYSCALL_64_after_hwframe+0x63/0xcd

               other info that might help us debug this:

   Possible unsafe locking scenario:

         CPU0                    CPU1
         ----                    ----
    lock(cpu_hotplug_lock);
                                 lock(kvm_lock);
                                 lock(cpu_hotplug_lock);
    lock(kvm_lock);

                *** DEADLOCK ***

  1 lock held by stable/251833:
   #0: ffffffffa2456828 (cpu_hotplug_lock){++++}-{0:0}, at: hardware_enable_all+0xf/0xc0 [kvm]

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 Documentation/virt/kvm/locking.rst |  6 ++++++
 arch/x86/kvm/x86.c                 | 18 ++++++++++++++++--
 2 files changed, 22 insertions(+), 2 deletions(-)

diff --git a/Documentation/virt/kvm/locking.rst b/Documentation/virt/kvm/locking.rst
index 845a561629f1..132a9e5436e5 100644
--- a/Documentation/virt/kvm/locking.rst
+++ b/Documentation/virt/kvm/locking.rst
@@ -282,3 +282,9 @@ time it will be set using the Dirty tracking mechanism described above.
 		wakeup notification event since external interrupts from the
 		assigned devices happens, we will find the vCPU on the list to
 		wakeup.
+
+``vendor_module_lock``
+^^^^^^^^^^^^^^^^^^^^^^^^^^^^
+:Type:		mutex
+:Arch:		x86
+:Protects:	loading a vendor module (kvm_amd or kvm_intel)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index b33932fca36e..45184ca89317 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -128,6 +128,7 @@ static int kvm_vcpu_do_singlestep(struct kvm_vcpu *vcpu);
 static int __set_sregs2(struct kvm_vcpu *vcpu, struct kvm_sregs2 *sregs2);
 static void __get_sregs2(struct kvm_vcpu *vcpu, struct kvm_sregs2 *sregs2);
 
+static DEFINE_MUTEX(vendor_module_lock);
 struct kvm_x86_ops kvm_x86_ops __read_mostly;
 
 #define KVM_X86_OP(func)					     \
@@ -9286,7 +9287,7 @@ void kvm_arch_exit(void)
 
 }
 
-int kvm_x86_vendor_init(struct kvm_x86_init_ops *ops)
+static int __kvm_x86_vendor_init(struct kvm_x86_init_ops *ops)
 {
 	u64 host_pat;
 	int r;
@@ -9419,6 +9420,17 @@ int kvm_x86_vendor_init(struct kvm_x86_init_ops *ops)
 	kmem_cache_destroy(x86_emulator_cache);
 	return r;
 }
+
+int kvm_x86_vendor_init(struct kvm_x86_init_ops *ops)
+{
+	int r;
+
+	mutex_lock(&vendor_module_lock);
+	r = __kvm_x86_vendor_init(ops);
+	mutex_unlock(&vendor_module_lock);
+
+	return r;
+}
 EXPORT_SYMBOL_GPL(kvm_x86_vendor_init);
 
 void kvm_x86_vendor_exit(void)
@@ -9441,7 +9453,6 @@ void kvm_x86_vendor_exit(void)
 	cancel_work_sync(&pvclock_gtod_work);
 #endif
 	static_call(kvm_x86_hardware_unsetup)();
-	kvm_x86_ops.hardware_enable = NULL;
 	kvm_mmu_vendor_module_exit();
 	free_percpu(user_return_msrs);
 	kmem_cache_destroy(x86_emulator_cache);
@@ -9449,6 +9460,9 @@ void kvm_x86_vendor_exit(void)
 	static_key_deferred_flush(&kvm_xen_enabled);
 	WARN_ON(static_branch_unlikely(&kvm_xen_enabled.key));
 #endif
+	mutex_lock(&vendor_module_lock);
+	kvm_x86_ops.hardware_enable = NULL;
+	mutex_unlock(&vendor_module_lock);
 }
 EXPORT_SYMBOL_GPL(kvm_x86_vendor_exit);
 
-- 
2.38.1.584.g0f3c55d4c2-goog

