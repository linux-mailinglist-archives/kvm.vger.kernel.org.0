Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1471110DAFD
	for <lists+kvm@lfdr.de>; Fri, 29 Nov 2019 22:33:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727310AbfK2Vde (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Nov 2019 16:33:34 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:42193 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727261AbfK2Vda (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Nov 2019 16:33:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575063207;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=eAG5Jn3OuAFdTylu6pJu+NV01EXcH/0EJLHVxQXwkPc=;
        b=cZosgmwEtE/tz8Hl4AwghmXQxamCTFQu722HoU/qiW1TGR4XMrGLoDLP8DfFzLp4H8qExN
        vYf2j2FvJYGGlc46V5TwEWh6xzxAP6sbiKPG/63tUq3YyGCYmAktXBoHMav6ZnKHFgsK8g
        2OvdIg4ittuSrwOvZvCZwZtkjOPdYTk=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-5-g9XFFZp2Pg6kCLPfSXAmqA-1; Fri, 29 Nov 2019 16:33:26 -0500
Received: by mail-qt1-f199.google.com with SMTP id t5so19116469qtp.5
        for <kvm@vger.kernel.org>; Fri, 29 Nov 2019 13:33:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1QV5ryCIGq2QV/eZOsMqVJWdaldoWJG8mcfxAcgQq7Q=;
        b=pG+3Ld+O5M0P289sJ+JrjuzxJSCTlgZiYiOYEKaEXPXwWnDb9Ku7Lrbo8+NOrwiFyT
         NUlpP3c4aGji37SNHAbgSC/Ubc4Tl50XdAixXNOzAccTQvo1dW1RJlEKVQZ/8ts7q9VL
         7+wZexkRAHU6rJu0+IDMSB3eyJV+MDYNCfrAQswUTaSEMJJXUFfBg4pZK12Y+qIHgS+o
         tDdnYZag0T+LUHlQ5bGIQH7i/OVYZxDvk/zxt2/oPQ3COAmfbHYyFXKNn6Vt4k/Kzlu7
         c5tehaE4atFuL9tbQJQVVbX35G6WU6RRyX54MVCnwwPsyeJuhiuNof6YngaDxiHKbzZs
         Y7Mw==
X-Gm-Message-State: APjAAAXQMNqwQcN+OiAZ2jNuQ1nDcl+Bsx6I08Zo5gSG4wvE3BM3O6ht
        1e2381iFPG241C3NVV69lJ7pmq9eusDCpBhUvhuw8UorxczseVjWP9r9etSbdHQr/+sRBuBWb6g
        ulakEWip/i738
X-Received: by 2002:aed:22c1:: with SMTP id q1mr54007583qtc.337.1575063205875;
        Fri, 29 Nov 2019 13:33:25 -0800 (PST)
X-Google-Smtp-Source: APXvYqzf3q4xU9le5bfUGj1s9FS5FkC907tlOwcwAdrJCp4RlCZA8IxrTXw/3cNBhJNemlPmJaCCYw==
X-Received: by 2002:aed:22c1:: with SMTP id q1mr54007545qtc.337.1575063205569;
        Fri, 29 Nov 2019 13:33:25 -0800 (PST)
Received: from xz-x1.yyz.redhat.com ([104.156.64.74])
        by smtp.gmail.com with ESMTPSA id g11sm10584673qkm.82.2019.11.29.13.33.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Nov 2019 13:33:24 -0800 (PST)
From:   Peter Xu <peterx@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>, peterx@redhat.com,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: [PATCH RFC 01/15] KVM: Move running VCPU from ARM to common code
Date:   Fri, 29 Nov 2019 16:33:08 -0500
Message-Id: <20191129213322.17386-2-peterx@redhat.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191129213322.17386-1-peterx@redhat.com>
References: <20191129213322.17386-1-peterx@redhat.com>
MIME-Version: 1.0
X-MC-Unique: g9XFFZp2Pg6kCLPfSXAmqA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Paolo Bonzini <pbonzini@redhat.com>

For ring-based dirty log tracking, it will be more efficient to account
writes during schedule-out or schedule-in to the currently running VCPU.
We would like to do it even if the write doesn't use the current VCPU's
address space, as is the case for cached writes (see commit 4e335d9e7ddb,
"Revert "KVM: Support vCPU-based gfn->hva cache"", 2017-05-02).

Therefore, add a mechanism to track the currently-loaded kvm_vcpu struct.
There is already something similar in KVM/ARM; one important difference
is that kvm_arch_vcpu_{load,put} have two callers in virt/kvm/kvm_main.c:
we have to update both the architecture-independent vcpu_{load,put} and
the preempt notifiers.

Another change made in the process is to allow using kvm_get_running_vcpu()
in preemptible code.  This is allowed because preempt notifiers ensure
that the value does not change even after the VCPU thread is migrated.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Peter Xu <peterx@redhat.com>
---
 arch/arm/include/asm/kvm_host.h   |  2 --
 arch/arm64/include/asm/kvm_host.h |  2 --
 include/linux/kvm_host.h          |  3 +++
 virt/kvm/arm/arm.c                | 29 -----------------------------
 virt/kvm/arm/perf.c               |  6 +++---
 virt/kvm/arm/vgic/vgic-mmio.c     | 15 +++------------
 virt/kvm/kvm_main.c               | 25 ++++++++++++++++++++++++-
 7 files changed, 33 insertions(+), 49 deletions(-)

diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_hos=
t.h
index 556cd818eccf..abc3f6f3ad76 100644
--- a/arch/arm/include/asm/kvm_host.h
+++ b/arch/arm/include/asm/kvm_host.h
@@ -284,8 +284,6 @@ int kvm_arm_copy_reg_indices(struct kvm_vcpu *vcpu, u64=
 __user *indices);
 int kvm_age_hva(struct kvm *kvm, unsigned long start, unsigned long end);
 int kvm_test_age_hva(struct kvm *kvm, unsigned long hva);
=20
-struct kvm_vcpu *kvm_arm_get_running_vcpu(void);
-struct kvm_vcpu __percpu **kvm_get_running_vcpus(void);
 void kvm_arm_halt_guest(struct kvm *kvm);
 void kvm_arm_resume_guest(struct kvm *kvm);
=20
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm=
_host.h
index b36dae9ee5f9..d97855e41469 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -446,8 +446,6 @@ int kvm_set_spte_hva(struct kvm *kvm, unsigned long hva=
, pte_t pte);
 int kvm_age_hva(struct kvm *kvm, unsigned long start, unsigned long end);
 int kvm_test_age_hva(struct kvm *kvm, unsigned long hva);
=20
-struct kvm_vcpu *kvm_arm_get_running_vcpu(void);
-struct kvm_vcpu * __percpu *kvm_get_running_vcpus(void);
 void kvm_arm_halt_guest(struct kvm *kvm);
 void kvm_arm_resume_guest(struct kvm *kvm);
=20
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 7ed1e2f8641e..498a39462ac1 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1342,6 +1342,9 @@ static inline void kvm_vcpu_set_dy_eligible(struct kv=
m_vcpu *vcpu, bool val)
 }
 #endif /* CONFIG_HAVE_KVM_CPU_RELAX_INTERCEPT */
=20
+struct kvm_vcpu *kvm_get_running_vcpu(void);
+struct kvm_vcpu __percpu **kvm_get_running_vcpus(void);
+
 #ifdef CONFIG_HAVE_KVM_IRQ_BYPASS
 bool kvm_arch_has_irq_bypass(void);
 int kvm_arch_irq_bypass_add_producer(struct irq_bypass_consumer *,
diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
index 12e0280291ce..1df9c39024fa 100644
--- a/virt/kvm/arm/arm.c
+++ b/virt/kvm/arm/arm.c
@@ -51,9 +51,6 @@ __asm__(".arch_extension=09virt");
 DEFINE_PER_CPU(kvm_host_data_t, kvm_host_data);
 static DEFINE_PER_CPU(unsigned long, kvm_arm_hyp_stack_page);
=20
-/* Per-CPU variable containing the currently running vcpu. */
-static DEFINE_PER_CPU(struct kvm_vcpu *, kvm_arm_running_vcpu);
-
 /* The VMID used in the VTTBR */
 static atomic64_t kvm_vmid_gen =3D ATOMIC64_INIT(1);
 static u32 kvm_next_vmid;
@@ -62,31 +59,8 @@ static DEFINE_SPINLOCK(kvm_vmid_lock);
 static bool vgic_present;
=20
 static DEFINE_PER_CPU(unsigned char, kvm_arm_hardware_enabled);
-
-static void kvm_arm_set_running_vcpu(struct kvm_vcpu *vcpu)
-{
-=09__this_cpu_write(kvm_arm_running_vcpu, vcpu);
-}
-
 DEFINE_STATIC_KEY_FALSE(userspace_irqchip_in_use);
=20
-/**
- * kvm_arm_get_running_vcpu - get the vcpu running on the current CPU.
- * Must be called from non-preemptible context
- */
-struct kvm_vcpu *kvm_arm_get_running_vcpu(void)
-{
-=09return __this_cpu_read(kvm_arm_running_vcpu);
-}
-
-/**
- * kvm_arm_get_running_vcpus - get the per-CPU array of currently running =
vcpus.
- */
-struct kvm_vcpu * __percpu *kvm_get_running_vcpus(void)
-{
-=09return &kvm_arm_running_vcpu;
-}
-
 int kvm_arch_vcpu_should_kick(struct kvm_vcpu *vcpu)
 {
 =09return kvm_vcpu_exiting_guest_mode(vcpu) =3D=3D IN_GUEST_MODE;
@@ -406,7 +380,6 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 =09vcpu->cpu =3D cpu;
 =09vcpu->arch.host_cpu_context =3D &cpu_data->host_ctxt;
=20
-=09kvm_arm_set_running_vcpu(vcpu);
 =09kvm_vgic_load(vcpu);
 =09kvm_timer_vcpu_load(vcpu);
 =09kvm_vcpu_load_sysregs(vcpu);
@@ -432,8 +405,6 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
 =09kvm_vcpu_pmu_restore_host(vcpu);
=20
 =09vcpu->cpu =3D -1;
-
-=09kvm_arm_set_running_vcpu(NULL);
 }
=20
 static void vcpu_power_off(struct kvm_vcpu *vcpu)
diff --git a/virt/kvm/arm/perf.c b/virt/kvm/arm/perf.c
index 918cdc3839ea..d45b8b9a4415 100644
--- a/virt/kvm/arm/perf.c
+++ b/virt/kvm/arm/perf.c
@@ -13,14 +13,14 @@
=20
 static int kvm_is_in_guest(void)
 {
-        return kvm_arm_get_running_vcpu() !=3D NULL;
+        return kvm_get_running_vcpu() !=3D NULL;
 }
=20
 static int kvm_is_user_mode(void)
 {
 =09struct kvm_vcpu *vcpu;
=20
-=09vcpu =3D kvm_arm_get_running_vcpu();
+=09vcpu =3D kvm_get_running_vcpu();
=20
 =09if (vcpu)
 =09=09return !vcpu_mode_priv(vcpu);
@@ -32,7 +32,7 @@ static unsigned long kvm_get_guest_ip(void)
 {
 =09struct kvm_vcpu *vcpu;
=20
-=09vcpu =3D kvm_arm_get_running_vcpu();
+=09vcpu =3D kvm_get_running_vcpu();
=20
 =09if (vcpu)
 =09=09return *vcpu_pc(vcpu);
diff --git a/virt/kvm/arm/vgic/vgic-mmio.c b/virt/kvm/arm/vgic/vgic-mmio.c
index 0d090482720d..d656ebd5f9d4 100644
--- a/virt/kvm/arm/vgic/vgic-mmio.c
+++ b/virt/kvm/arm/vgic/vgic-mmio.c
@@ -190,15 +190,6 @@ unsigned long vgic_mmio_read_pending(struct kvm_vcpu *=
vcpu,
  * value later will give us the same value as we update the per-CPU variab=
le
  * in the preempt notifier handlers.
  */
-static struct kvm_vcpu *vgic_get_mmio_requester_vcpu(void)
-{
-=09struct kvm_vcpu *vcpu;
-
-=09preempt_disable();
-=09vcpu =3D kvm_arm_get_running_vcpu();
-=09preempt_enable();
-=09return vcpu;
-}
=20
 /* Must be called with irq->irq_lock held */
 static void vgic_hw_irq_spending(struct kvm_vcpu *vcpu, struct vgic_irq *i=
rq,
@@ -221,7 +212,7 @@ void vgic_mmio_write_spending(struct kvm_vcpu *vcpu,
 =09=09=09      gpa_t addr, unsigned int len,
 =09=09=09      unsigned long val)
 {
-=09bool is_uaccess =3D !vgic_get_mmio_requester_vcpu();
+=09bool is_uaccess =3D !kvm_get_running_vcpu();
 =09u32 intid =3D VGIC_ADDR_TO_INTID(addr, 1);
 =09int i;
 =09unsigned long flags;
@@ -274,7 +265,7 @@ void vgic_mmio_write_cpending(struct kvm_vcpu *vcpu,
 =09=09=09      gpa_t addr, unsigned int len,
 =09=09=09      unsigned long val)
 {
-=09bool is_uaccess =3D !vgic_get_mmio_requester_vcpu();
+=09bool is_uaccess =3D !kvm_get_running_vcpu();
 =09u32 intid =3D VGIC_ADDR_TO_INTID(addr, 1);
 =09int i;
 =09unsigned long flags;
@@ -335,7 +326,7 @@ static void vgic_mmio_change_active(struct kvm_vcpu *vc=
pu, struct vgic_irq *irq,
 =09=09=09=09    bool active)
 {
 =09unsigned long flags;
-=09struct kvm_vcpu *requester_vcpu =3D vgic_get_mmio_requester_vcpu();
+=09struct kvm_vcpu *requester_vcpu =3D kvm_get_running_vcpu();
=20
 =09raw_spin_lock_irqsave(&irq->irq_lock, flags);
=20
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 00268290dcbd..fac0760c870e 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -108,6 +108,7 @@ struct kmem_cache *kvm_vcpu_cache;
 EXPORT_SYMBOL_GPL(kvm_vcpu_cache);
=20
 static __read_mostly struct preempt_ops kvm_preempt_ops;
+static DEFINE_PER_CPU(struct kvm_vcpu *, kvm_running_vcpu);
=20
 struct dentry *kvm_debugfs_dir;
 EXPORT_SYMBOL_GPL(kvm_debugfs_dir);
@@ -197,6 +198,8 @@ bool kvm_is_reserved_pfn(kvm_pfn_t pfn)
 void vcpu_load(struct kvm_vcpu *vcpu)
 {
 =09int cpu =3D get_cpu();
+
+=09__this_cpu_write(kvm_running_vcpu, vcpu);
 =09preempt_notifier_register(&vcpu->preempt_notifier);
 =09kvm_arch_vcpu_load(vcpu, cpu);
 =09put_cpu();
@@ -208,6 +211,7 @@ void vcpu_put(struct kvm_vcpu *vcpu)
 =09preempt_disable();
 =09kvm_arch_vcpu_put(vcpu);
 =09preempt_notifier_unregister(&vcpu->preempt_notifier);
+=09__this_cpu_write(kvm_running_vcpu, NULL);
 =09preempt_enable();
 }
 EXPORT_SYMBOL_GPL(vcpu_put);
@@ -4304,8 +4308,8 @@ static void kvm_sched_in(struct preempt_notifier *pn,=
 int cpu)
 =09WRITE_ONCE(vcpu->preempted, false);
 =09WRITE_ONCE(vcpu->ready, false);
=20
+=09__this_cpu_write(kvm_running_vcpu, vcpu);
 =09kvm_arch_sched_in(vcpu, cpu);
-
 =09kvm_arch_vcpu_load(vcpu, cpu);
 }
=20
@@ -4319,6 +4323,25 @@ static void kvm_sched_out(struct preempt_notifier *p=
n,
 =09=09WRITE_ONCE(vcpu->ready, true);
 =09}
 =09kvm_arch_vcpu_put(vcpu);
+=09__this_cpu_write(kvm_running_vcpu, NULL);
+}
+
+/**
+ * kvm_get_running_vcpu - get the vcpu running on the current CPU.
+ * Thanks to preempt notifiers, this can also be called from
+ * preemptible context.
+ */
+struct kvm_vcpu *kvm_get_running_vcpu(void)
+{
+        return __this_cpu_read(kvm_running_vcpu);
+}
+
+/**
+ * kvm_get_running_vcpus - get the per-CPU array of currently running vcpu=
s.
+ */
+struct kvm_vcpu * __percpu *kvm_get_running_vcpus(void)
+{
+        return &kvm_running_vcpu;
 }
=20
 static void check_processor_compat(void *rtn)
--=20
2.21.0

