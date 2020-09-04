Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7DA125D767
	for <lists+kvm@lfdr.de>; Fri,  4 Sep 2020 13:33:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730021AbgIDLdI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Sep 2020 07:33:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729954AbgIDLc1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Sep 2020 07:32:27 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F2C6C061244
        for <kvm@vger.kernel.org>; Fri,  4 Sep 2020 04:32:27 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id g6so2928271pjl.0
        for <kvm@vger.kernel.org>; Fri, 04 Sep 2020 04:32:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=from:content-transfer-encoding:mime-version:subject:message-id:date
         :cc:to;
        bh=BBVb3FSWiPJHFK9MBBhv4J63/7k1Ou4B0fnv9L/nxTI=;
        b=lcamAIZFPcvWQVNO5/253V4+ERhvPT2Q5LAlBZHLHAyI6ui4mBPLCWu1ktvzgI70dj
         +K9tEsapN/kBrnvF7D+AjKssXopLMmAAJ76A7hRmxK1w5CxMIWpP9B5gL7Iwx+G62Cbw
         nuocnkj31/ZzzaRPtO+wQvYsgIOgDzd6tBLNUUCXPwVGgqfOwxnu1p58oYyqusosnmPA
         9KLrh9YWuyV9Kgn6Kz1VieYKEK6WGlSs1/vW8GQQtVvmEgObFu3YVIkfFTcK1QMeU3ru
         yksXYcFgjVRXM3fvLEx4+9tVsnONXSOekPk0t1RQyF2ML/oTIvdSiAIijQA+tAtkbAJl
         5+6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:content-transfer-encoding:mime-version
         :subject:message-id:date:cc:to;
        bh=BBVb3FSWiPJHFK9MBBhv4J63/7k1Ou4B0fnv9L/nxTI=;
        b=hUIvxKbIdywzqtpUygWBUuRZZkGpk1NfwpCMrEROTOtVApj9L0iPgg9LIkPdziam+p
         llXI2An5orLdZlQynEu+LI9BadFCJGmdNdd7kN0orCKrsLqVqvNzQD9Bg0ogJbd+ZyV7
         aWfGyMigx+MS9YnQ2o40isLxamxv8EfeSlLRIhA8aQNXDeFBzUXwN+gAMSbz0NKyBG7C
         36wvU93qvs8hppoxlmeoMlYWlPOivESxetEZcjr1APmbVYmHC0jDQczZsK93vF164hhf
         3dk2q5Pz6UyNwHGnHXXdNs1QRuUQ+QCDO4OHxT1XXP8TgKy+PzExKaLmThKa4SCBp373
         ryDQ==
X-Gm-Message-State: AOAM531hcBfhn2Axv0q+uzYn5+FBAPc63cI2pYZmjyRzfM7EkMfB+esG
        CSxIJ7TO6t9cQ6xMJNtplFcPdyRZd1M8JJe7
X-Google-Smtp-Source: ABdhPJxEUVcK4BhucchgJRiMM4UbUM8Nz7g/4rVRSUlN7fb3qrdLfUggYiBgvLBKxuqFPXzhM4wYrQ==
X-Received: by 2002:a17:902:7d84:: with SMTP id a4mr8395802plm.44.1599219146168;
        Fri, 04 Sep 2020 04:32:26 -0700 (PDT)
Received: from [10.94.81.238] ([103.136.221.68])
        by smtp.gmail.com with ESMTPSA id h15sm5522142pjf.54.2020.09.04.04.32.23
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 04 Sep 2020 04:32:25 -0700 (PDT)
From:   =?utf-8?B?6YKT5qGl?= <dengqiao.joey@bytedance.com>
Content-Type: text/plain;
        charset=utf-8
Content-Transfer-Encoding: quoted-printable
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.80.23.2.2\))
Subject: [RFC] KVM: X86: implement Passthrough IPI 
Message-Id: <0109A01C-59D0-4C72-8B05-14959AD26AD2@bytedance.com>
Date:   Fri, 4 Sep 2020 19:31:51 +0800
Cc:     pbonzini@redhat.com, rkrcmar@redhat.com, yang.zhang.wz@gmail.com,
        zhouyibo@bytedance.com, zhanghaozhong@bytedance.com
To:     kvm@vger.kernel.org
X-Mailer: Apple Mail (2.3608.80.23.2.2)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch paravirtualize the IPI sending process in guest by exposing
posted interrupt capability to guest directly . Since there is no VM =
Exit=20
and VM Entry when sending IPI, the overhead is therefore reduced.

The basic idea is that:
Exposing the PI_DESC  and msr.icr to guest. When sending a IPI, set=20
the PIR of destination VCPU=E2=80=99s PI_DESC from guest directly and =
write
the ICR with notification vector and destination PCPU which are got=20
from hypervisor.=20

This mechanism only handle the normal IPI. For SIPI/NMI/INIT, still=20
goes to legacy way but which write a new msr instead msr.icr.

The cost is reduced from 7k cycles to 2k cycles, which is 1500 cycles
on the host.

However it may increase the risk in the system since the guest could
decide to send IPI to any processor.

This patch is based on Linux-5.0 and we can rebase it on latest tree if =
the idea
is accepted. We will introduce this idea at KVM Forum 2020.

Signed-off-by: dengqiao.joey <dengqiao.joey@bytedance.com>
Signed-off-by: Yang Zhang <yang.zhang.wz@gmail.com>
---
 arch/x86/include/asm/kvm_host.h      |  28 ++++-
 arch/x86/include/asm/kvm_para.h      |   6 ++
 arch/x86/include/asm/vmx.h           |   1 +
 arch/x86/include/uapi/asm/kvm_para.h |  25 +++++
 arch/x86/kernel/apic/apic.c          |   1 +
 arch/x86/kernel/kvm.c                | 199 =
++++++++++++++++++++++++++++++++++-
 arch/x86/kvm/cpuid.c                 |  15 ++-
 arch/x86/kvm/lapic.c                 |  12 +++
 arch/x86/kvm/lapic.h                 |   9 ++
 arch/x86/kvm/svm.c                   |   6 ++
 arch/x86/kvm/vmx/vmx.c               | 132 ++++++++++++++++++++---
 arch/x86/kvm/vmx/vmx.h               |   8 +-
 arch/x86/kvm/x86.c                   |  19 ++++
 include/uapi/linux/kvm.h             |   1 +
 14 files changed, 434 insertions(+), 28 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h =
b/arch/x86/include/asm/kvm_host.h
index 1803733..fb148c3 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -40,9 +40,9 @@
 #define KVM_MAX_VCPUS 288
 #define KVM_SOFT_MAX_VCPUS 240
 #define KVM_MAX_VCPU_ID 1023
-#define KVM_USER_MEM_SLOTS 509
+#define KVM_USER_MEM_SLOTS 508
 /* memory slots that are not exposed to userspace */
-#define KVM_PRIVATE_MEM_SLOTS 3
+#define KVM_PRIVATE_MEM_SLOTS 4
 #define KVM_MEM_SLOTS_NUM (KVM_USER_MEM_SLOTS + KVM_PRIVATE_MEM_SLOTS)

 #define KVM_HALT_POLL_NS_DEFAULT 200000
@@ -753,6 +753,20 @@ struct kvm_vcpu_arch {
 		struct gfn_to_hva_cache data;
 	} pv_eoi;

+	/* Definition for msr pv ipi:
+	 *	Bit 0: pi_desc valid bit.
+	 *	       Indicate hypervisor has prepared pi_desc address.
+	 *	Bit 1: pv_ipi enable bit.
+	 *	       Guest set 1 to indicate pv_ipi is enabled in =
guest.
+	 *	       Guest read this bit(1) to get whether hypervisor =
has
+	 *	       enabled pv_ipi(don=E2=80=99t intercept 0x830).
+	 *	Bit 8-11: count of pages for struct pi_desc takes.
+	 *	Bit 12-63: base address of pi_desc in gpa.
+	 */
+	struct {
+		u64 msr_val;
+	} pv_ipi;
+
 	/*
 	 * Indicate whether the access faults on its page table in guest
 	 * which is set when fix page fault and used to detect =
unhandeable
@@ -780,6 +794,9 @@ struct kvm_vcpu_arch {

 	/* Flush the L1 Data cache for L1TF mitigation on VMENTER */
 	bool l1tf_flush_l1d;
+
+	/* Indicate whether PV IPI is enabled on this vcpu */
+	bool pvipi_enabled;
 };

 struct kvm_lpage_info {
@@ -926,6 +943,12 @@ struct kvm_arch {

 	bool guest_can_read_msr_platform_info;
 	bool exception_payload_enabled;
+
+	/*
+	 * `pvipi.enable` is a per-vcpu bit, which is saved in
+	 * `struct  kvm_vcpu_arch` rather than here.
+	 */
+	union pvipi_msr pvipi;
 };

 struct kvm_vm_stat {
@@ -1196,6 +1219,7 @@ struct kvm_x86_ops {
 	int (*nested_enable_evmcs)(struct kvm_vcpu *vcpu,
 				   uint16_t *vmcs_version);
 	uint16_t (*nested_get_evmcs_version)(struct kvm_vcpu *vcpu);
+	int (*set_pvipi_addr)(struct kvm *kvm, unsigned long addr);
 };

 struct kvm_arch_async_pf {
diff --git a/arch/x86/include/asm/kvm_para.h =
b/arch/x86/include/asm/kvm_para.h
index 5ed3cf1..f7eaf82 100644
--- a/arch/x86/include/asm/kvm_para.h
+++ b/arch/x86/include/asm/kvm_para.h
@@ -93,6 +93,7 @@ void kvm_async_pf_task_wake(u32 token);
 u32 kvm_read_and_reset_pf_reason(void);
 extern void kvm_disable_steal_time(void);
 void do_async_page_fault(struct pt_regs *regs, unsigned long =
error_code);
+void kvm_pv_ipi_init(void);

 #ifdef CONFIG_PARAVIRT_SPINLOCKS
 void __init kvm_spinlock_init(void);
@@ -130,6 +131,11 @@ static inline void kvm_disable_steal_time(void)
 {
 	return;
 }
+
+static void kvm_pv_ipi_init(void)
+{
+	return;
+}
 #endif

 #endif /* _ASM_X86_KVM_PARA_H */
diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
index 4e4133e..837a233 100644
--- a/arch/x86/include/asm/vmx.h
+++ b/arch/x86/include/asm/vmx.h
@@ -458,6 +458,7 @@ enum vmcs_field {
 #define TSS_PRIVATE_MEMSLOT			(KVM_USER_MEM_SLOTS + 0)
 #define APIC_ACCESS_PAGE_PRIVATE_MEMSLOT	(KVM_USER_MEM_SLOTS + 1)
 #define IDENTITY_PAGETABLE_PRIVATE_MEMSLOT	(KVM_USER_MEM_SLOTS + 2)
+#define PVIPI_PAGE_PRIVATE_MEMSLOT		(KVM_USER_MEM_SLOTS + 3)

 #define VMX_NR_VPIDS				(1 << 16)
 #define VMX_VPID_EXTENT_INDIVIDUAL_ADDR		0
diff --git a/arch/x86/include/uapi/asm/kvm_para.h =
b/arch/x86/include/uapi/asm/kvm_para.h
index 19980ec..cb38abc 100644
--- a/arch/x86/include/uapi/asm/kvm_para.h
+++ b/arch/x86/include/uapi/asm/kvm_para.h
@@ -29,6 +29,7 @@
 #define KVM_FEATURE_PV_TLB_FLUSH	9
 #define KVM_FEATURE_ASYNC_PF_VMEXIT	10
 #define KVM_FEATURE_PV_SEND_IPI	11
+#define KVM_FEATURE_PV_IPI	12

 #define KVM_HINTS_REALTIME      0

@@ -47,6 +48,8 @@
 #define MSR_KVM_ASYNC_PF_EN 0x4b564d02
 #define MSR_KVM_STEAL_TIME  0x4b564d03
 #define MSR_KVM_PV_EOI_EN      0x4b564d04
+#define MSR_KVM_PV_IPI      0x4b564d05
+#define MSR_KVM_PV_ICR      0x4b564d06

 struct kvm_steal_time {
 	__u64 steal;
@@ -119,4 +122,26 @@ struct kvm_vcpu_pv_apf_data {
 #define KVM_PV_EOI_ENABLED KVM_PV_EOI_MASK
 #define KVM_PV_EOI_DISABLED 0x0

+union pvipi_msr {
+	u64 msr_val;
+	struct {
+		u64 enable:1;
+		u64 reserved:7;
+		u64 count:4;
+		u64 addr:51;
+		u64 valid:1;
+	};
+};
+
+#define KVM_PV_IPI_ENABLE 0x1UL
+#define KVM_PV_IPI_ADDR_SHIFT 12
+/*
+ * To avoild waste memory, only uses two pages as descriptor page which =
means
+ * only support 128 pi descriptors(64 bytes per descriptor) now.
+ */
+#define PI_DESC_PAGES 2
+#define PI_DESC_SIZE 64
+#define PI_DESC_PER_PAGE (PAGE_SIZE / PI_DESC_SIZE)
+#define MAX_PI_DESC (PI_DESC_PAGES * PI_DESC_PER_PAGE)
+
 #endif /* _UAPI_ASM_X86_KVM_PARA_H */
diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index b7bcdd7..5a699ed 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -1635,6 +1635,7 @@ static void end_local_APIC_setup(void)
 #endif

 	apic_pm_activate();
+	kvm_pv_ipi_init();
 }

 /*
diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index 5c93a65..3e6264d 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -46,6 +46,7 @@
 #include <asm/apicdef.h>
 #include <asm/hypervisor.h>
 #include <asm/tlb.h>
+#include <asm/ipi.h>

 static int kvmapf =3D 1;

@@ -253,7 +254,6 @@ u32 kvm_read_and_reset_pf_reason(void)
 }
 EXPORT_SYMBOL_GPL(kvm_read_and_reset_pf_reason);
 NOKPROBE_SYMBOL(kvm_read_and_reset_pf_reason);
-
 dotraplinkage void
 do_async_page_fault(struct pt_regs *regs, unsigned long error_code)
 {
@@ -537,7 +537,194 @@ static void kvm_setup_pv_ipi(void)
 	apic->send_IPI_mask_allbutself =3D kvm_send_ipi_mask_allbutself;
 	apic->send_IPI_allbutself =3D kvm_send_ipi_allbutself;
 	apic->send_IPI_all =3D kvm_send_ipi_all;
-	pr_info("KVM setup pv IPIs\n");
+	pr_info("KVM setup old pv IPIs\n");
+}
+
+/* Posted-Interrupt Descriptor */
+struct pi_desc {
+	u32 pir[8];     /* Posted interrupt requested */
+	union {
+		struct {
+				/* bit 256 - Outstanding Notification */
+			u16     on      : 1,
+				/* bit 257 - Suppress Notification */
+			sn      : 1,
+				/* bit 271:258 - Reserved */
+			rsvd_1  : 14;
+				/* bit 279:272 - Notification Vector */
+			u8      nv;
+				/* bit 287:280 - Reserved */
+			u8      rsvd_2;
+				/* bit 319:288 - Notification =
Destination */
+			u32     ndst;
+		};
+		u64 control;
+	};
+	u32 rsvd[6];
+} __aligned(64);
+
+#define POSTED_INTR_ON  0
+#define POSTED_INTR_SN  1
+
+static inline bool pi_test_and_set_on(struct pi_desc *pi_desc)
+{
+	return test_and_set_bit(POSTED_INTR_ON,
+			(unsigned long *)&pi_desc->control);
+}
+
+static inline int pi_test_and_set_pir(int vector, struct pi_desc =
*pi_desc)
+{
+	return test_and_set_bit(vector, (unsigned long *)pi_desc->pir);
+}
+
+static struct pi_desc *pi_desc_page;
+
+static void x2apic_send_IPI_dest(unsigned int apicid, int vector, =
unsigned int dest)
+{
+	unsigned long cfg =3D __prepare_ICR(0, vector, dest);
+
+	native_x2apic_icr_write(cfg, apicid);
+}
+
+static void kvm_send_ipi(int cpu, int vector)
+{
+	/* In x2apic mode, apicid is equal to vcpu id.*/
+	u32 vcpu_id =3D per_cpu(x86_cpu_to_apicid, cpu);
+	unsigned int nv, dest/* , val */;
+
+	x2apic_wrmsr_fence();
+
+	WARN(vector =3D=3D NMI_VECTOR, "try to deliver NMI");
+
+	/* TODO: rollback to old approach. */
+	if (vcpu_id >=3D MAX_PI_DESC)
+		return;
+
+	if (pi_test_and_set_pir(vector, &pi_desc_page[vcpu_id]))
+		return;
+
+	if (pi_test_and_set_on(&pi_desc_page[vcpu_id]))
+		return;
+
+	nv =3D pi_desc_page[vcpu_id].nv;
+	dest =3D pi_desc_page[vcpu_id].ndst;
+
+	x2apic_send_IPI_dest(dest, nv, APIC_DEST_PHYSICAL);
+
+}
+
+static void __kvm_send_ipi_mask(const struct cpumask *mask, int vector,
+				int apic_dest)
+{
+	unsigned long query_cpu;
+	unsigned long this_cpu;
+	unsigned long flags;
+
+	local_irq_save(flags);
+
+	this_cpu =3D smp_processor_id();
+	for_each_cpu(query_cpu, mask) {
+		if (apic_dest =3D=3D APIC_DEST_ALLBUT && this_cpu =3D=3D =
query_cpu)
+			continue;
+		kvm_send_ipi(query_cpu, vector);
+	}
+
+	local_irq_restore(flags);
+}
+
+static void kvm_send_ipi_mask2(const struct cpumask *mask, int vector)
+{
+	__kvm_send_ipi_mask(mask, vector, APIC_DEST_ALLINC);
+}
+
+static void kvm_send_ipi_mask_allbutself2(const struct cpumask *mask, =
int vector)
+{
+	__kvm_send_ipi_mask(mask, vector, APIC_DEST_ALLBUT);
+}
+
+static void kvm_send_ipi_allbutself2(int vector)
+{
+	__kvm_send_ipi_mask(cpu_online_mask, vector, APIC_DEST_ALLBUT);
+}
+
+static void kvm_send_ipi_all2(int vector)
+{
+	__kvm_send_ipi_mask(cpu_online_mask, vector, APIC_DEST_ALLINC);
+}
+
+static inline void kvm_icr_write(u32 low, u32 id)
+{
+	wrmsrl(MSR_KVM_PV_ICR, ((__u64) id) << 32 | low);
+}
+
+static inline u64 kvm_icr_read(void)
+{
+	unsigned long val;
+
+	rdmsrl(MSR_KVM_PV_ICR, val);
+	return val;
+}
+
+static int kvm_setup_pv_ipi2(void)
+{
+	union pvipi_msr msr;
+
+	rdmsrl(MSR_KVM_PV_IPI, msr.msr_val);
+
+	if (msr.valid !=3D 1)
+		return -EINVAL;
+
+	if (msr.enable) {
+		/* set enable bit and read back. */
+		wrmsrl(MSR_KVM_PV_IPI, msr.msr_val | KVM_PV_IPI_ENABLE);
+
+		rdmsrl(MSR_KVM_PV_IPI, msr.msr_val);
+
+		if (!(msr.msr_val & KVM_PV_IPI_ENABLE)) {
+			pr_emerg("pv ipi enable failed\n");
+			iounmap(pi_desc_page);
+			return -EINVAL;
+		}
+
+		goto out;
+	} else {
+
+		pi_desc_page =3D ioremap_cache(msr.addr << PAGE_SHIFT,
+				PAGE_SIZE << msr.count);
+
+		if (!pi_desc_page)
+			return -ENOMEM;
+
+
+		pr_emerg("pv ipi msr val %lx, pi_desc_page %lx, %lx\n",
+				(unsigned long)msr.msr_val,
+				(unsigned long)pi_desc_page,
+				(unsigned long)&pi_desc_page[1]);
+
+		/* set enable bit and read back. */
+		wrmsrl(MSR_KVM_PV_IPI, msr.msr_val | KVM_PV_IPI_ENABLE);
+
+		rdmsrl(MSR_KVM_PV_IPI, msr.msr_val);
+
+		if (!(msr.msr_val & KVM_PV_IPI_ENABLE)) {
+			pr_emerg("pv ipi enable failed\n");
+			iounmap(pi_desc_page);
+			return -EINVAL;
+		}
+		apic->send_IPI =3D kvm_send_ipi;
+		apic->send_IPI_mask =3D kvm_send_ipi_mask2;
+		apic->send_IPI_mask_allbutself =3D =
kvm_send_ipi_mask_allbutself2;
+		apic->send_IPI_allbutself =3D kvm_send_ipi_allbutself2;
+		apic->send_IPI_all =3D kvm_send_ipi_all2;
+		apic->icr_read =3D kvm_icr_read;
+		apic->icr_write =3D kvm_icr_write;
+		pr_emerg("pv ipi enabled\n");
+	}
+out:
+	pr_emerg("pv ipi KVM setup real PV IPIs for cpu %d\n",
+			smp_processor_id());
+
+	return 0;
 }

 static void __init kvm_smp_prepare_cpus(unsigned int max_cpus)
@@ -709,9 +896,17 @@ static uint32_t __init kvm_detect(void)
 	return kvm_cpuid_base();
 }

+void __init kvm_pv_ipi_init(void)
+{
+	if (kvm_para_has_feature(KVM_FEATURE_PV_IPI) && =
x2apic_enabled())
+		kvm_setup_pv_ipi2();
+}
+EXPORT_SYMBOL_GPL(kvm_pv_ipi_init);
+
 static void __init kvm_apic_init(void)
 {
 #if defined(CONFIG_SMP)
+
 	if (kvm_para_has_feature(KVM_FEATURE_PV_SEND_IPI))
 		kvm_setup_pv_ipi();
 #endif
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index c07958b..4641a84 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -133,9 +133,15 @@ int kvm_update_cpuid(struct kvm_vcpu *vcpu)
 	}

 	best =3D kvm_find_cpuid_entry(vcpu, KVM_CPUID_FEATURES, 0);
-	if (kvm_hlt_in_guest(vcpu->kvm) && best &&
-		(best->eax & (1 << KVM_FEATURE_PV_UNHALT)))
-		best->eax &=3D ~(1 << KVM_FEATURE_PV_UNHALT);
+	if (best) {
+		if (kvm_hlt_in_guest(vcpu->kvm) &&
+				(best->eax & (1 << =
KVM_FEATURE_PV_UNHALT)))
+			best->eax &=3D ~(1 << KVM_FEATURE_PV_UNHALT);
+		if (!kvm_vcpu_apicv_active(vcpu) || !x2apic_enabled()) {
+			best->eax &=3D ~(1 << KVM_FEATURE_PV_IPI);
+			pr_emerg("pv ipi: remove pv ipi from cpuid\n");
+		}
+	}

 	/* Update physical-address width */
 	vcpu->arch.maxphyaddr =3D cpuid_query_maxphyaddr(vcpu);
@@ -641,7 +647,8 @@ static inline int __do_cpuid_ent(struct =
kvm_cpuid_entry2 *entry, u32 function,
 			     (1 << KVM_FEATURE_PV_UNHALT) |
 			     (1 << KVM_FEATURE_PV_TLB_FLUSH) |
 			     (1 << KVM_FEATURE_ASYNC_PF_VMEXIT) |
-			     (1 << KVM_FEATURE_PV_SEND_IPI);
+			     (1 << KVM_FEATURE_PV_SEND_IPI) |
+			     (1 << KVM_FEATURE_PV_IPI);

 		if (sched_info_on())
 			entry->eax |=3D (1 << KVM_FEATURE_STEAL_TIME);
diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 4b6c2da..f53eac9 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -381,6 +381,7 @@ bool __kvm_apic_update_irr(u32 *pir, void *regs, int =
*max_irr)
 	u32 i, vec;
 	u32 pir_val, irr_val, prev_irr_val;
 	int max_updated_irr;
+	unsigned long *pir2 =3D (unsigned long *)pir;

 	max_updated_irr =3D -1;
 	*max_irr =3D -1;
@@ -2172,6 +2173,7 @@ void kvm_lapic_reset(struct kvm_vcpu *vcpu, bool =
init_event)
 		kvm_lapic_set_base(vcpu,
 				vcpu->arch.apic_base | =
MSR_IA32_APICBASE_BSP);
 	vcpu->arch.pv_eoi.msr_val =3D 0;
+	//vcpu->arch.pv_eoi.msr_val =3D
 	apic_update_ppr(apic);
 	if (vcpu->arch.apicv_active) {
 		kvm_x86_ops->apicv_post_state_restore(vcpu);
@@ -2671,6 +2673,16 @@ int kvm_lapic_enable_pv_eoi(struct kvm_vcpu =
*vcpu, u64 data, unsigned long len)
 	return kvm_gfn_to_hva_cache_init(vcpu->kvm, ghc, addr, new_len);
 }

+void kvm_pvipi_init(struct kvm *kvm, u64 pi_desc_gfn)
+{
+	kvm->arch.pvipi.addr =3D pi_desc_gfn;
+	kvm->arch.pvipi.count =3D PI_DESC_PAGES;
+	/* make sure addr and count is visible before set valid bit */
+	smp_wmb();
+	kvm->arch.pvipi.valid =3D 1;
+}
+EXPORT_SYMBOL_GPL(kvm_pvipi_init);
+
 void kvm_apic_accept_events(struct kvm_vcpu *vcpu)
 {
 	struct kvm_lapic *apic =3D vcpu->arch.apic;
diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
index ff6ef9c..2abf16a 100644
--- a/arch/x86/kvm/lapic.h
+++ b/arch/x86/kvm/lapic.h
@@ -16,6 +16,8 @@
 #define APIC_BUS_CYCLE_NS       1
 #define APIC_BUS_FREQUENCY      (1000000000ULL / APIC_BUS_CYCLE_NS)

+#define X2APIC_MSR(r) (APIC_BASE_MSR + ((r) >> 4))
+
 enum lapic_mode {
 	LAPIC_MODE_DISABLED =3D 0,
 	LAPIC_MODE_INVALID =3D X2APIC_ENABLE,
@@ -194,6 +196,11 @@ static inline int apic_x2apic_mode(struct kvm_lapic =
*apic)
 	return apic->vcpu->arch.apic_base & X2APIC_ENABLE;
 }

+static inline int kvm_x2apic_mode(struct kvm_vcpu *vcpu)
+{
+	return apic_x2apic_mode(vcpu->arch.apic);
+}
+
 static inline bool kvm_vcpu_apicv_active(struct kvm_vcpu *vcpu)
 {
 	return vcpu->arch.apic && vcpu->arch.apicv_active;
@@ -234,4 +241,6 @@ static inline enum lapic_mode kvm_apic_mode(u64 =
apic_base)
 	return apic_base & (MSR_IA32_APICBASE_ENABLE | X2APIC_ENABLE);
 }

+void kvm_pvipi_init(struct kvm *kvm, u64 pi_desc_gfn);
+
 #endif
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index f13a3a2..cf54968 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -5449,6 +5449,11 @@ static void enable_nmi_window(struct kvm_vcpu =
*vcpu)
 	svm->vmcb->save.rflags |=3D (X86_EFLAGS_TF | X86_EFLAGS_RF);
 }

+static int svm_set_pvipi_addr(struct kvm *kvm, unsigned long addr)
+{
+	return 0;
+}
+
 static int svm_set_tss_addr(struct kvm *kvm, unsigned int addr)
 {
 	return 0;
@@ -7182,6 +7187,7 @@ static struct kvm_x86_ops svm_x86_ops =
__ro_after_init =3D {
 	.apicv_post_state_restore =3D avic_post_state_restore,

 	.set_tss_addr =3D svm_set_tss_addr,
+	.set_pvipi_addr =3D svm_set_pvipi_addr,
 	.set_identity_map_addr =3D svm_set_identity_map_addr,
 	.get_tdp_level =3D get_npt_level,
 	.get_mt_mask =3D svm_get_mt_mask,
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 30a6bcd..eab9d6d 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -336,6 +336,8 @@ static bool guest_state_valid(struct kvm_vcpu =
*vcpu);
 static u32 vmx_segment_access_rights(struct kvm_segment *var);
 static __always_inline void vmx_disable_intercept_for_msr(unsigned long =
*msr_bitmap,
 							  u32 msr, int =
type);
+static __always_inline void vmx_enable_intercept_for_msr(unsigned long =
*msr_bitmap,
+							 u32 msr, int =
type);

 void vmx_vmexit(void);

@@ -1767,6 +1769,11 @@ static int vmx_get_msr(struct kvm_vcpu *vcpu, =
struct msr_data *msr_info)
 		else
 			msr_info->data =3D =
vmx->pt_desc.guest.addr_a[index / 2];
 		break;
+	case MSR_KVM_PV_IPI:
+		msr_info->data =3D
+			(vcpu->kvm->arch.pvipi.msr_val & ~(u64)0x1) |
+			vcpu->arch.pvipi_enabled;
+		break;
 	case MSR_TSC_AUX:
 		if (!msr_info->host_initiated &&
 		    !guest_cpuid_has(vcpu, X86_FEATURE_RDTSCP))
@@ -2005,6 +2012,31 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, =
struct msr_data *msr_info)
 		else
 			vmx->pt_desc.guest.addr_a[index / 2] =3D data;
 		break;
+	case MSR_KVM_PV_IPI:
+		if (!vcpu->kvm->arch.pvipi.valid)
+			break;
+
+		/* Userspace (e.g., QEMU) initiated disabling PV IPI */
+		if (msr_info->host_initiated && !(data & =
KVM_PV_IPI_ENABLE)) {
+			=
vmx_enable_intercept_for_msr(vmx->vmcs01.msr_bitmap,
+						     =
X2APIC_MSR(APIC_ICR),
+						     MSR_TYPE_RW);
+			vcpu->arch.pvipi_enabled =3D false;
+			pr_debug("host-initiated disabling PV IPI on =
vcpu %d\n",
+			       vcpu->vcpu_id);
+			break;
+		}
+
+		if (!kvm_x2apic_mode(vcpu))
+			break;
+
+		if (data & KVM_PV_IPI_ENABLE && =
!vcpu->arch.pvipi_enabled) {
+			=
vmx_disable_intercept_for_msr(vmx->vmcs01.msr_bitmap,
+					X2APIC_MSR(APIC_ICR), =
MSR_TYPE_RW);
+			vcpu->arch.pvipi_enabled =3D true;
+			pr_emerg("enable pv ipi for vcpu %d\n", =
vcpu->vcpu_id);
+		}
+		break;
 	case MSR_TSC_AUX:
 		if (!msr_info->host_initiated &&
 		    !guest_cpuid_has(vcpu, X86_FEATURE_RDTSCP))
@@ -3548,8 +3580,8 @@ static u8 vmx_msr_bitmap_mode(struct kvm_vcpu =
*vcpu)
 	return mode;
 }

-static void vmx_update_msr_bitmap_x2apic(unsigned long *msr_bitmap,
-					 u8 mode)
+static void vmx_update_msr_bitmap_x2apic(struct kvm_vcpu *vcpu,
+					unsigned long *msr_bitmap, u8 =
mode)
 {
 	int msr;

@@ -3569,6 +3601,11 @@ static void vmx_update_msr_bitmap_x2apic(unsigned =
long *msr_bitmap,
 			vmx_enable_intercept_for_msr(msr_bitmap, =
X2APIC_MSR(APIC_TMCCT), MSR_TYPE_R);
 			vmx_disable_intercept_for_msr(msr_bitmap, =
X2APIC_MSR(APIC_EOI), MSR_TYPE_W);
 			vmx_disable_intercept_for_msr(msr_bitmap, =
X2APIC_MSR(APIC_SELF_IPI), MSR_TYPE_W);
+
+			vmx_set_intercept_for_msr(msr_bitmap,
+						  X2APIC_MSR(APIC_ICR),
+						  MSR_TYPE_RW,
+						  =
!vcpu->arch.pvipi_enabled);
 		}
 	}
 }
@@ -3584,7 +3621,7 @@ void vmx_update_msr_bitmap(struct kvm_vcpu *vcpu)
 		return;

 	if (changed & (MSR_BITMAP_MODE_X2APIC | =
MSR_BITMAP_MODE_X2APIC_APICV))
-		vmx_update_msr_bitmap_x2apic(msr_bitmap, mode);
+		vmx_update_msr_bitmap_x2apic(vcpu, msr_bitmap, mode);

 	vmx->msr_bitmap_mode =3D mode;
 }
@@ -3712,11 +3749,11 @@ static void vmx_deliver_posted_interrupt(struct =
kvm_vcpu *vcpu, int vector)
 	if (!r)
 		return;

-	if (pi_test_and_set_pir(vector, &vmx->pi_desc))
+	if (pi_test_and_set_pir(vector, vmx->pi_desc))
 		return;

 	/* If a previous notification has sent the IPI, nothing to do.  =
*/
-	if (pi_test_and_set_on(&vmx->pi_desc))
+	if (pi_test_and_set_on(vmx->pi_desc))
 		return;

 	if (!kvm_vcpu_trigger_posted_interrupt(vcpu, false))
@@ -3999,6 +4036,30 @@ static void ept_set_mmio_spte_mask(void)
 				   VMX_EPT_MISCONFIG_WX_VALUE);
 }

+static int pi_desc_setup(struct kvm_vcpu *vcpu)
+{
+	struct kvm_vmx *kvm_vmx =3D to_kvm_vmx(vcpu->kvm);
+	struct page *page;
+	int page_index, ret =3D 0;
+
+	page_index =3D vcpu->vcpu_id / PI_DESC_PER_PAGE;
+
+	/* pin pages in memory */
+	/* TODO: allow to move those page to support memory unplug.
+	 * See commtnes in kvm_vcpu_reload_apic_access_page for details.
+	 */
+	page =3D kvm_vcpu_gfn_to_page(vcpu, kvm_vmx->pvipi_gfn + =
page_index);
+	if (is_error_page(page)) {
+		ret =3D -EFAULT;
+		goto out;
+	}
+
+	to_vmx(vcpu)->pi_desc =3D page_address(page)
+		+ vcpu->vcpu_id * PI_DESC_SIZE;
+out:
+	return ret;
+}
+
 #define VMX_XSS_EXIT_BITMAP 0

 /*
@@ -4037,7 +4098,7 @@ static void vmx_vcpu_setup(struct vcpu_vmx *vmx)
 		vmcs_write16(GUEST_INTR_STATUS, 0);

 		vmcs_write16(POSTED_INTR_NV, POSTED_INTR_VECTOR);
-		vmcs_write64(POSTED_INTR_DESC_ADDR, =
__pa((&vmx->pi_desc)));
+		vmcs_write64(POSTED_INTR_DESC_ADDR, =
__pa((vmx->pi_desc)));
 	}

 	if (!kvm_pause_in_guest(vmx->vcpu.kvm)) {
@@ -4345,6 +4406,30 @@ static int vmx_interrupt_allowed(struct kvm_vcpu =
*vcpu)
 			(GUEST_INTR_STATE_STI | =
GUEST_INTR_STATE_MOV_SS));
 }

+static int vmx_set_pvipi_addr(struct kvm *kvm, unsigned long addr)
+{
+	int ret;
+
+	if (!enable_apicv || !x2apic_enabled())
+		return 0;
+
+	if (!IS_ALIGNED(addr, PAGE_SIZE)) {
+		pr_err("addr is not aligned\n");
+		return 0;
+	}
+
+	ret =3D x86_set_memory_region(kvm, PVIPI_PAGE_PRIVATE_MEMSLOT, =
addr,
+				    PAGE_SIZE * PI_DESC_PAGES);
+	if (ret)
+		return ret;
+
+	to_kvm_vmx(kvm)->pvipi_gfn =3D addr >> PAGE_SHIFT;
+	kvm_pvipi_init(kvm, to_kvm_vmx(kvm)->pvipi_gfn);
+
+	return ret;
+
+}
+
 static int vmx_set_tss_addr(struct kvm *kvm, unsigned int addr)
 {
 	int ret;
@@ -4833,6 +4918,7 @@ static int handle_cpuid(struct kvm_vcpu *vcpu)
 	return kvm_emulate_cpuid(vcpu);
 }

+static unsigned long pvipi[4];
 static int handle_rdmsr(struct kvm_vcpu *vcpu)
 {
 	u32 ecx =3D vcpu->arch.regs[VCPU_REGS_RCX];
@@ -6046,15 +6132,15 @@ static int vmx_sync_pir_to_irr(struct kvm_vcpu =
*vcpu)
 	bool max_irr_updated;

 	WARN_ON(!vcpu->arch.apicv_active);
-	if (pi_test_on(&vmx->pi_desc)) {
-		pi_clear_on(&vmx->pi_desc);
+	if (pi_test_on(vmx->pi_desc)) {
+		pi_clear_on(vmx->pi_desc);
 		/*
 		 * IOMMU can write to PIR.ON, so the barrier matters =
even on UP.
 		 * But on x86 this is just a compiler barrier anyway.
 		 */
 		smp_mb__after_atomic();
 		max_irr_updated =3D
-			kvm_apic_update_irr(vcpu, vmx->pi_desc.pir, =
&max_irr);
+			kvm_apic_update_irr(vcpu, vmx->pi_desc->pir, =
&max_irr);

 		/*
 		 * If we are running L2 and L1 has a new pending =
interrupt
@@ -6092,8 +6178,8 @@ static void vmx_apicv_post_state_restore(struct =
kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx =3D to_vmx(vcpu);

-	pi_clear_on(&vmx->pi_desc);
-	memset(vmx->pi_desc.pir, 0, sizeof(vmx->pi_desc.pir));
+	pi_clear_on(vmx->pi_desc);
+	memset(vmx->pi_desc->pir, 0, sizeof(vmx->pi_desc->pir));
 }

 static void vmx_complete_atomic_exit(struct vcpu_vmx *vmx)
@@ -6505,6 +6591,7 @@ static void __vmx_vcpu_run(struct kvm_vcpu *vcpu, =
struct vcpu_vmx *vmx)
 }
 STACK_FRAME_NON_STANDARD(__vmx_vcpu_run);

+static bool msr_write_intercepted(struct kvm_vcpu *vcpu, u32 msr);
 static void vmx_vcpu_run(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx =3D to_vmx(vcpu);
@@ -6707,6 +6794,17 @@ static struct kvm_vcpu *vmx_create_vcpu(struct =
kvm *kvm, unsigned int id)

 	err =3D -ENOMEM;

+	if (kvm_vcpu_apicv_active(&vmx->vcpu)) {
+		if (id > MAX_PI_DESC) {
+			pr_err("kvm: failed to alloc pi descriptor,
+					no enough pi descs left\n");
+			goto free_vcpu;
+		}
+		err =3D pi_desc_setup(&vmx->vcpu);
+		if (err < 0)
+			goto free_vcpu;
+	}
+
 	/*
 	 * If PML is turned on, failure on enabling PML just results in =
failure
 	 * of creating the vcpu, therefore we can simplify PML logic (by
@@ -6775,8 +6873,10 @@ static struct kvm_vcpu *vmx_create_vcpu(struct =
kvm *kvm, unsigned int id)
 	 * Enforce invariant: pi_desc.nv is always either =
POSTED_INTR_VECTOR
 	 * or POSTED_INTR_WAKEUP_VECTOR.
 	 */
-	vmx->pi_desc.nv =3D POSTED_INTR_VECTOR;
-	vmx->pi_desc.sn =3D 1;
+	if (kvm_vcpu_apicv_active(&vmx->vcpu)) {
+		vmx->pi_desc->nv =3D POSTED_INTR_VECTOR;
+		vmx->pi_desc->sn =3D 1;
+	}

 	vmx->ept_pointer =3D INVALID_PAGE;

@@ -7297,9 +7397,8 @@ static int pi_pre_block(struct kvm_vcpu *vcpu)
 	struct pi_desc old, new;
 	struct pi_desc *pi_desc =3D vcpu_to_pi_desc(vcpu);

-	if (!kvm_arch_has_assigned_device(vcpu->kvm) ||
-		!irq_remapping_cap(IRQ_POSTING_CAP)  ||
-		!kvm_vcpu_apicv_active(vcpu))
+
+	if (!kvm_vcpu_apicv_active(vcpu))
 		return 0;

 	WARN_ON(irqs_disabled());
@@ -7766,6 +7865,7 @@ static struct kvm_x86_ops vmx_x86_ops =
__ro_after_init =3D {
 	.deliver_posted_interrupt =3D vmx_deliver_posted_interrupt,

 	.set_tss_addr =3D vmx_set_tss_addr,
+	.set_pvipi_addr =3D vmx_set_pvipi_addr,
 	.set_identity_map_addr =3D vmx_set_identity_map_addr,
 	.get_tdp_level =3D get_ept_level,
 	.get_mt_mask =3D vmx_get_mt_mask,
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 0ac0a64..1b55d75 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -18,8 +18,6 @@ extern u64 host_efer;
 #define MSR_TYPE_W	2
 #define MSR_TYPE_RW	3

-#define X2APIC_MSR(r) (APIC_BASE_MSR + ((r) >> 4))
-
 #define NR_AUTOLOAD_MSRS 8

 struct vmx_msrs {
@@ -235,7 +233,7 @@ struct vcpu_vmx {
 	u32 exit_reason;

 	/* Posted interrupt descriptor */
-	struct pi_desc pi_desc;
+	struct pi_desc *pi_desc;

 	/* Support for a guest hypervisor (nested VMX) */
 	struct nested_vmx nested;
@@ -286,6 +284,8 @@ struct kvm_vmx {

 	enum ept_pointers_status ept_pointers_match;
 	spinlock_t ept_pointer_lock;
+
+	unsigned long pvipi_gfn;
 };

 bool nested_vmx_allowed(struct kvm_vcpu *vcpu);
@@ -475,7 +475,7 @@ static inline struct vcpu_vmx *to_vmx(struct =
kvm_vcpu *vcpu)

 static inline struct pi_desc *vcpu_to_pi_desc(struct kvm_vcpu *vcpu)
 {
-	return &(to_vmx(vcpu)->pi_desc);
+	return to_vmx(vcpu)->pi_desc;
 }

 struct vmcs *alloc_vmcs_cpu(bool shadow, int cpu);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 941f932..c3cca66 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1155,6 +1155,8 @@ static u32 emulated_msrs[] =3D {

 	MSR_KVM_ASYNC_PF_EN, MSR_KVM_STEAL_TIME,
 	MSR_KVM_PV_EOI_EN,
+	MSR_KVM_PV_IPI,
+	MSR_KVM_PV_ICR,

 	MSR_IA32_TSC_ADJUST,
 	MSR_IA32_TSCDEADLINE,
@@ -2479,6 +2481,8 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, =
struct msr_data *msr_info)
 		return kvm_mtrr_set_msr(vcpu, msr, data);
 	case MSR_IA32_APICBASE:
 		return kvm_set_apic_base(vcpu, msr_info);
+	case MSR_KVM_PV_ICR:
+		return kvm_x2apic_msr_write(vcpu, X2APIC_MSR(APIC_ICR), =
data);
 	case APIC_BASE_MSR ... APIC_BASE_MSR + 0x3ff:
 		return kvm_x2apic_msr_write(vcpu, msr, data);
 	case MSR_IA32_TSCDEADLINE:
@@ -2773,6 +2777,9 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, =
struct msr_data *msr_info)
 	case MSR_IA32_APICBASE:
 		msr_info->data =3D kvm_get_apic_base(vcpu);
 		break;
+	case MSR_KVM_PV_ICR:
+		return kvm_x2apic_msr_read(vcpu,
+				X2APIC_MSR(APIC_ICR), &msr_info->data);
 	case APIC_BASE_MSR ... APIC_BASE_MSR + 0x3ff:
 		return kvm_x2apic_msr_read(vcpu, msr_info->index, =
&msr_info->data);
 		break;
@@ -4240,6 +4247,14 @@ vm_fault_t kvm_arch_vcpu_fault(struct kvm_vcpu =
*vcpu, struct vm_fault *vmf)
 	return VM_FAULT_SIGBUS;
 }

+static int kvm_vm_ioctl_set_pvipi_addr(struct kvm *kvm, unsigned long =
addr)
+{
+	int ret;
+
+	ret =3D kvm_x86_ops->set_pvipi_addr(kvm, addr);
+	return ret;
+}
+
 static int kvm_vm_ioctl_set_tss_addr(struct kvm *kvm, unsigned long =
addr)
 {
 	int ret;
@@ -4866,6 +4881,9 @@ long kvm_arch_vm_ioctl(struct file *filp,
 		r =3D kvm_vm_ioctl_hv_eventfd(kvm, &hvevfd);
 		break;
 	}
+	case KVM_SET_PVIPI_ADDR:
+		r =3D kvm_vm_ioctl_set_pvipi_addr(kvm, arg);
+		break;
 	default:
 		r =3D -ENOTTY;
 	}
@@ -9248,6 +9266,7 @@ void kvm_arch_destroy_vm(struct kvm *kvm)
 		x86_set_memory_region(kvm, =
APIC_ACCESS_PAGE_PRIVATE_MEMSLOT, 0, 0);
 		x86_set_memory_region(kvm, =
IDENTITY_PAGETABLE_PRIVATE_MEMSLOT, 0, 0);
 		x86_set_memory_region(kvm, TSS_PRIVATE_MEMSLOT, 0, 0);
+		x86_set_memory_region(kvm, PVIPI_PAGE_PRIVATE_MEMSLOT, =
0, 0);
 	}
 	if (kvm_x86_ops->vm_destroy)
 		kvm_x86_ops->vm_destroy(kvm);
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 6d4ea4b..db88c4d 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1440,6 +1440,7 @@ struct kvm_enc_region {
 /* Available with KVM_CAP_HYPERV_CPUID */
 #define KVM_GET_SUPPORTED_HV_CPUID _IOWR(KVMIO, 0xc1, struct =
kvm_cpuid2)

+#define KVM_SET_PVIPI_ADDR            _IO(KVMIO, 0xc2)
 /* Secure Encrypted Virtualization command */
 enum sev_cmd_id {
 	/* Guest initialization commands */
--
2.11.0=
