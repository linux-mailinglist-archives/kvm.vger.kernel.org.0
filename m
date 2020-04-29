Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF97B1BD869
	for <lists+kvm@lfdr.de>; Wed, 29 Apr 2020 11:37:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726850AbgD2JhM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Apr 2020 05:37:12 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:35354 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726819AbgD2JhH (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 29 Apr 2020 05:37:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588153024;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3hW+HeZnFZOKXi+gCk37OElUlM0zG/ML7+gcMlzZtQ4=;
        b=U0feogkkQnJm8UvNxLhqUjJPEauqzRljDSU0Jpa/qAP63aJvhrBeozTD1J1r503gyLyxdT
        ICSjzqd+vv/uXN9ygDCJd7BPnYIxJ7Opsk4ueLgu9F+X+1KE5l+myJePgrQ6DaIiYWqpQ6
        /MozSVUBdL/1rH/nrCACFIoYSvsZBgk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-199-OHz0JqO7PQmkhkH2HFRKPA-1; Wed, 29 Apr 2020 05:37:02 -0400
X-MC-Unique: OHz0JqO7PQmkhkH2HFRKPA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6CF8B45F;
        Wed, 29 Apr 2020 09:37:00 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.193.242])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 188395D9C9;
        Wed, 29 Apr 2020 09:36:56 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     x86@kernel.org, kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Andy Lutomirski <luto@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>
Subject: [PATCH RFC 6/6] KVM: x86: Switch KVM guest to using interrupts for page ready APF delivery
Date:   Wed, 29 Apr 2020 11:36:34 +0200
Message-Id: <20200429093634.1514902-7-vkuznets@redhat.com>
In-Reply-To: <20200429093634.1514902-1-vkuznets@redhat.com>
References: <20200429093634.1514902-1-vkuznets@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

KVM now supports using interrupt for type 2 APF event delivery (page read=
y
notifications). Switch KVM guests to using it when the feature is present=
.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/entry/entry_32.S          |  5 ++++
 arch/x86/entry/entry_64.S          |  5 ++++
 arch/x86/include/asm/hardirq.h     |  3 +++
 arch/x86/include/asm/irq_vectors.h |  6 ++++-
 arch/x86/include/asm/kvm_para.h    |  6 +++++
 arch/x86/kernel/irq.c              |  9 +++++++
 arch/x86/kernel/kvm.c              | 42 ++++++++++++++++++++++++++++++
 7 files changed, 75 insertions(+), 1 deletion(-)

diff --git a/arch/x86/entry/entry_32.S b/arch/x86/entry/entry_32.S
index b67bae7091d7..d574dadcb2a1 100644
--- a/arch/x86/entry/entry_32.S
+++ b/arch/x86/entry/entry_32.S
@@ -1475,6 +1475,11 @@ BUILD_INTERRUPT3(hv_stimer0_callback_vector, HYPER=
V_STIMER0_VECTOR,
=20
 #endif /* CONFIG_HYPERV */
=20
+#ifdef CONFIG_KVM_GUEST
+BUILD_INTERRUPT3(kvm_async_pf_vector, KVM_ASYNC_PF_VECTOR,
+		 kvm_async_pf_intr)
+#endif
+
 SYM_CODE_START(page_fault)
 	ASM_CLAC
 	pushl	$do_page_fault
diff --git a/arch/x86/entry/entry_64.S b/arch/x86/entry/entry_64.S
index 0e9504fabe52..6f127c1a6547 100644
--- a/arch/x86/entry/entry_64.S
+++ b/arch/x86/entry/entry_64.S
@@ -1190,6 +1190,11 @@ apicinterrupt3 HYPERVISOR_CALLBACK_VECTOR \
 	acrn_hv_callback_vector acrn_hv_vector_handler
 #endif
=20
+#ifdef CONFIG_KVM_GUEST
+apicinterrupt3 KVM_ASYNC_PF_VECTOR \
+	kvm_async_pf_vector kvm_async_pf_intr
+#endif
+
 idtentry debug			do_debug		has_error_code=3D0	paranoid=3D1 shift_ist=3DI=
ST_INDEX_DB ist_offset=3DDB_STACK_OFFSET
 idtentry int3			do_int3			has_error_code=3D0	create_gap=3D1
 idtentry stack_segment		do_stack_segment	has_error_code=3D1
diff --git a/arch/x86/include/asm/hardirq.h b/arch/x86/include/asm/hardir=
q.h
index 07533795b8d2..be0fbb15ad7f 100644
--- a/arch/x86/include/asm/hardirq.h
+++ b/arch/x86/include/asm/hardirq.h
@@ -44,6 +44,9 @@ typedef struct {
 	unsigned int irq_hv_reenlightenment_count;
 	unsigned int hyperv_stimer0_count;
 #endif
+#ifdef CONFIG_KVM_GUEST
+	unsigned int kvm_async_pf_pageready_count;
+#endif
 } ____cacheline_aligned irq_cpustat_t;
=20
 DECLARE_PER_CPU_SHARED_ALIGNED(irq_cpustat_t, irq_stat);
diff --git a/arch/x86/include/asm/irq_vectors.h b/arch/x86/include/asm/ir=
q_vectors.h
index 889f8b1b5b7f..8879a9ecd908 100644
--- a/arch/x86/include/asm/irq_vectors.h
+++ b/arch/x86/include/asm/irq_vectors.h
@@ -104,7 +104,11 @@
 #define HYPERV_STIMER0_VECTOR		0xed
 #endif
=20
-#define LOCAL_TIMER_VECTOR		0xec
+#ifdef CONFIG_KVM_GUEST
+#define KVM_ASYNC_PF_VECTOR		0xec
+#endif
+
+#define LOCAL_TIMER_VECTOR		0xeb
=20
 #define NR_VECTORS			 256
=20
diff --git a/arch/x86/include/asm/kvm_para.h b/arch/x86/include/asm/kvm_p=
ara.h
index 9b4df6eaa11a..fde4f21607f9 100644
--- a/arch/x86/include/asm/kvm_para.h
+++ b/arch/x86/include/asm/kvm_para.h
@@ -4,6 +4,7 @@
=20
 #include <asm/processor.h>
 #include <asm/alternative.h>
+#include <linux/interrupt.h>
 #include <uapi/asm/kvm_para.h>
=20
 extern void kvmclock_init(void);
@@ -93,6 +94,11 @@ void kvm_async_pf_task_wake(u32 token);
 u32 kvm_read_and_reset_pf_reason(void);
 extern void kvm_disable_steal_time(void);
 void do_async_page_fault(struct pt_regs *regs, unsigned long error_code,=
 unsigned long address);
+extern void kvm_async_pf_vector(void);
+#ifdef CONFIG_TRACING
+#define trace_kvm_async_pf_vector kvm_async_pf_vector
+#endif
+__visible void __irq_entry kvm_async_pf_intr(struct pt_regs *regs);
=20
 #ifdef CONFIG_PARAVIRT_SPINLOCKS
 void __init kvm_spinlock_init(void);
diff --git a/arch/x86/kernel/irq.c b/arch/x86/kernel/irq.c
index c7965ff429c5..a4c2f25ad74d 100644
--- a/arch/x86/kernel/irq.c
+++ b/arch/x86/kernel/irq.c
@@ -159,6 +159,15 @@ int arch_show_interrupts(struct seq_file *p, int pre=
c)
 				   irq_stats(j)->hyperv_stimer0_count);
 		seq_puts(p, "  Hyper-V stimer0 interrupts\n");
 	}
+#endif
+#ifdef CONFIG_KVM_GUEST
+	if (test_bit(KVM_ASYNC_PF_VECTOR, system_vectors)) {
+		seq_printf(p, "%*s: ", prec, "APF");
+		for_each_online_cpu(j)
+			seq_printf(p, "%10u ",
+				   irq_stats(j)->kvm_async_pf_pageready_count);
+		seq_puts(p, "  KVM async PF page ready interrupts\n");
+	}
 #endif
 	seq_printf(p, "%*s: %10u\n", prec, "ERR", atomic_read(&irq_err_count));
 #if defined(CONFIG_X86_IO_APIC)
diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index 6efe0410fb72..1c00c7ba01ff 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -259,9 +259,39 @@ do_async_page_fault(struct pt_regs *regs, unsigned l=
ong error_code, unsigned lon
 		rcu_irq_exit();
 		break;
 	}
+
+	if (kvm_para_has_feature(KVM_FEATURE_ASYNC_PF_INT))
+		wrmsrl(MSR_KVM_ASYNC_PF_ACK, 1);
 }
 NOKPROBE_SYMBOL(do_async_page_fault);
=20
+__visible void __irq_entry kvm_async_pf_intr(struct pt_regs *regs)
+{
+	u32 token, reason;
+
+	entering_ack_irq();
+
+	inc_irq_stat(kvm_async_pf_pageready_count);
+
+	if (__this_cpu_read(apf_reason.enabled)) {
+		reason =3D __this_cpu_read(apf_reason.reason);
+		if (reason =3D=3D KVM_PV_REASON_PAGE_READY) {
+			token =3D __this_cpu_read(apf_reason.token);
+			/*
+			 * Make sure we read 'token' before we reset
+			 * 'reason' or it can get lost.
+			 */
+			mb();
+			__this_cpu_write(apf_reason.reason, 0);
+			kvm_async_pf_task_wake(token);
+		}
+	}
+
+	wrmsrl(MSR_KVM_ASYNC_PF_ACK, 1);
+
+	exiting_irq();
+}
+
 static void __init paravirt_ops_setup(void)
 {
 	pv_info.name =3D "KVM";
@@ -316,10 +346,17 @@ static void kvm_guest_cpu_init(void)
 		if (kvm_para_has_feature(KVM_FEATURE_ASYNC_PF_VMEXIT))
 			pa |=3D KVM_ASYNC_PF_DELIVERY_AS_PF_VMEXIT;
=20
+		if (kvm_para_has_feature(KVM_FEATURE_ASYNC_PF_INT))
+			pa |=3D KVM_ASYNC_PF_DELIVERY_AS_INT;
+
 		wrmsrl(MSR_KVM_ASYNC_PF_EN, pa);
 		__this_cpu_write(apf_reason.enabled, 1);
 		printk(KERN_INFO"KVM setup async PF for cpu %d\n",
 		       smp_processor_id());
+
+		if (kvm_para_has_feature(KVM_FEATURE_ASYNC_PF_INT))
+			wrmsrl(MSR_KVM_ASYNC_PF2, KVM_ASYNC_PF2_ENABLED |
+			       KVM_ASYNC_PF_VECTOR);
 	}
=20
 	if (kvm_para_has_feature(KVM_FEATURE_PV_EOI)) {
@@ -649,6 +686,11 @@ static void __init kvm_guest_init(void)
 	if (kvm_para_has_feature(KVM_FEATURE_PV_EOI))
 		apic_set_eoi_write(kvm_guest_apic_eoi_write);
=20
+	if (kvm_para_has_feature(KVM_FEATURE_ASYNC_PF_INT)) {
+		pr_info("KVM using interrupt for async PF page-ready\n");
+		alloc_intr_gate(KVM_ASYNC_PF_VECTOR, kvm_async_pf_vector);
+	}
+
 #ifdef CONFIG_SMP
 	smp_ops.smp_prepare_cpus =3D kvm_smp_prepare_cpus;
 	smp_ops.smp_prepare_boot_cpu =3D kvm_smp_prepare_boot_cpu;
--=20
2.25.3

