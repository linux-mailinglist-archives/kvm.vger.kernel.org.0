Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBFF067F591
	for <lists+kvm@lfdr.de>; Sat, 28 Jan 2023 08:28:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233781AbjA1H2v (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 28 Jan 2023 02:28:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232579AbjA1H2n (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 28 Jan 2023 02:28:43 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE12541092
        for <kvm@vger.kernel.org>; Fri, 27 Jan 2023 23:28:20 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id lp10so6685108pjb.4
        for <kvm@vger.kernel.org>; Fri, 27 Jan 2023 23:28:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=us5B6b3oPSKbN4nBqiSd04SSFe3RmeK4iNYbvjeKM1Q=;
        b=BrOdZ5qe+AN8KI8lC2qMGYK+L+nJ51mrWGMbP4mc2dIJx04R56JRcaA9iJfbv6PTRW
         QOleEjZyx69jObv5iR5EpHGToGUeh94Ie41NbvADbudOloW9lRk7JSlNh7OEw0pmzXu/
         q952me+8vNsNeCywDDNw+RqHlatk9Z8syy7PrtR8x9uC6BlwYigoBSdYEcXMnYyVw5Ut
         L9fYuPZYR7Sb43IpBkqalgzZCZ1ffjj3fVWp4p4G2D06Yk+LrrWRMiJGkAgmY1QSLH5K
         UbpInYVDrcP7dKSNmdrKcCOpqxiwOi2xTIZorELkQJ56UanwdKTgPS2sf0gZ3ePhZlNU
         WsVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=us5B6b3oPSKbN4nBqiSd04SSFe3RmeK4iNYbvjeKM1Q=;
        b=gy9esc9ZTWEQ/kvWMzWgY+jqxlwNnuMrHXOEgZZWC2FabVmmwps10fTgnRUKg9ih4Q
         7iX0tLBi//Q4b83H4iCxIUeTyZlzaC10d/TwcAHBDGseeWL1UhhQx+bTDZj+1ZKTWx8u
         mi5LcmV5o7+RPGXUWGiIprS6KsbKmffaRQd5BaDqnXhno6VbrHWOq0S/0PkQBvtO53nA
         GiB0yev+64OjrN+3+kgpqQauVvHj5kMcZf7rbrqwpsQek0JKRhLlLO42Hhn2Lf1b5eKc
         yh8Xo1WZVy+egKAiYksxE/P8o4EnXOSZnHVBBkC+ldu/58/L3XlIo6Re7xij7IRJSQGZ
         ZzWQ==
X-Gm-Message-State: AO0yUKV6GoU9edWcdwGkr4f1gyJ1/jGH3ZoNq+6gfjPQe4D2qO1YDEjy
        0Es1S5WMGh9IaCkpjPRw+oCnLg==
X-Google-Smtp-Source: AK7set97XI7KvrHC4kgG8ABr/KtYeQLuS83oA1GwQYk7TijEr0uOta3Q3bL6ZAmfgd7rj/1W/x4D2A==
X-Received: by 2002:a17:902:d2cd:b0:196:5484:a087 with SMTP id n13-20020a170902d2cd00b001965484a087mr6846970plc.56.1674890900317;
        Fri, 27 Jan 2023 23:28:20 -0800 (PST)
Received: from anup-ubuntu-vm.localdomain ([103.97.165.210])
        by smtp.gmail.com with ESMTPSA id jh19-20020a170903329300b00194ac38bc86sm753132plb.131.2023.01.27.23.28.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Jan 2023 23:28:19 -0800 (PST)
From:   Anup Patel <apatel@ventanamicro.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>
Cc:     Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Andrew Jones <ajones@ventanamicro.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org, Anup Patel <apatel@ventanamicro.com>
Subject: [PATCH v2 7/7] RISC-V: KVM: Implement guest external interrupt line management
Date:   Sat, 28 Jan 2023 12:57:37 +0530
Message-Id: <20230128072737.2995881-8-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230128072737.2995881-1-apatel@ventanamicro.com>
References: <20230128072737.2995881-1-apatel@ventanamicro.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The RISC-V host will have one guest external interrupt line for each
VS-level IMSICs associated with a HART. The guest external interrupt
lines are per-HART resources and hypervisor can use HGEIE, HGEIP, and
HIE CSRs to manage these guest external interrupt lines.

Signed-off-by: Anup Patel <apatel@ventanamicro.com>
---
 arch/riscv/include/asm/kvm_aia.h |  10 ++
 arch/riscv/kvm/aia.c             | 241 +++++++++++++++++++++++++++++++
 arch/riscv/kvm/main.c            |   3 +-
 arch/riscv/kvm/vcpu.c            |   2 +
 4 files changed, 255 insertions(+), 1 deletion(-)

diff --git a/arch/riscv/include/asm/kvm_aia.h b/arch/riscv/include/asm/kvm_aia.h
index 1de0717112e5..0938e0cadf80 100644
--- a/arch/riscv/include/asm/kvm_aia.h
+++ b/arch/riscv/include/asm/kvm_aia.h
@@ -44,10 +44,15 @@ struct kvm_vcpu_aia {
 
 #define irqchip_in_kernel(k)		((k)->arch.aia.in_kernel)
 
+extern unsigned int kvm_riscv_aia_nr_hgei;
 DECLARE_STATIC_KEY_FALSE(kvm_riscv_aia_available);
 #define kvm_riscv_aia_available() \
 	static_branch_unlikely(&kvm_riscv_aia_available)
 
+static inline void kvm_riscv_vcpu_aia_imsic_release(struct kvm_vcpu *vcpu)
+{
+}
+
 #define KVM_RISCV_AIA_IMSIC_TOPEI	(ISELECT_MASK + 1)
 static inline int kvm_riscv_vcpu_aia_imsic_rmw(struct kvm_vcpu *vcpu,
 					       unsigned long isel,
@@ -119,6 +124,11 @@ static inline void kvm_riscv_aia_destroy_vm(struct kvm *kvm)
 {
 }
 
+int kvm_riscv_aia_alloc_hgei(int cpu, struct kvm_vcpu *owner,
+			     void __iomem **hgei_va, phys_addr_t *hgei_pa);
+void kvm_riscv_aia_free_hgei(int cpu, int hgei);
+void kvm_riscv_aia_wakeon_hgei(struct kvm_vcpu *owner, bool enable);
+
 void kvm_riscv_aia_enable(void);
 void kvm_riscv_aia_disable(void);
 int kvm_riscv_aia_init(void);
diff --git a/arch/riscv/kvm/aia.c b/arch/riscv/kvm/aia.c
index 3d68189e0bb1..f375069fdaf4 100644
--- a/arch/riscv/kvm/aia.c
+++ b/arch/riscv/kvm/aia.c
@@ -7,11 +7,46 @@
  *	Anup Patel <apatel@ventanamicro.com>
  */
 
+#include <linux/bitops.h>
+#include <linux/irq.h>
+#include <linux/irqdomain.h>
 #include <linux/kvm_host.h>
+#include <linux/percpu.h>
+#include <linux/spinlock.h>
 #include <asm/hwcap.h>
 
+struct aia_hgei_control {
+	raw_spinlock_t lock;
+	unsigned long free_bitmap;
+	struct kvm_vcpu *owners[BITS_PER_LONG];
+};
+static DEFINE_PER_CPU(struct aia_hgei_control, aia_hgei);
+static int hgei_parent_irq;
+
+unsigned int kvm_riscv_aia_nr_hgei;
 DEFINE_STATIC_KEY_FALSE(kvm_riscv_aia_available);
 
+static int aia_find_hgei(struct kvm_vcpu *owner)
+{
+	int i, hgei;
+	unsigned long flags;
+	struct aia_hgei_control *hgctrl = this_cpu_ptr(&aia_hgei);
+
+	raw_spin_lock_irqsave(&hgctrl->lock, flags);
+
+	hgei = -1;
+	for (i = 1; i <= kvm_riscv_aia_nr_hgei; i++) {
+		if (hgctrl->owners[i] == owner) {
+			hgei = i;
+			break;
+		}
+	}
+
+	raw_spin_unlock_irqrestore(&hgctrl->lock, flags);
+
+	return hgei;
+}
+
 static void aia_set_hvictl(bool ext_irq_pending)
 {
 	unsigned long hvictl;
@@ -55,6 +90,7 @@ void kvm_riscv_vcpu_aia_sync_interrupts(struct kvm_vcpu *vcpu)
 
 bool kvm_riscv_vcpu_aia_has_interrupts(struct kvm_vcpu *vcpu, u64 mask)
 {
+	int hgei;
 	unsigned long seip;
 
 	if (!kvm_riscv_aia_available())
@@ -72,6 +108,10 @@ bool kvm_riscv_vcpu_aia_has_interrupts(struct kvm_vcpu *vcpu, u64 mask)
 	if (!kvm_riscv_aia_initialized(vcpu->kvm) || !seip)
 		return false;
 
+	hgei = aia_find_hgei(vcpu);
+	if (hgei > 0)
+		return (csr_read(CSR_HGEIP) & BIT(hgei)) ? true : false;
+
 	return false;
 }
 
@@ -343,6 +383,144 @@ int kvm_riscv_vcpu_aia_rmw_ireg(struct kvm_vcpu *vcpu, unsigned int csr_num,
 	return KVM_INSN_EXIT_TO_USER_SPACE;
 }
 
+int kvm_riscv_aia_alloc_hgei(int cpu, struct kvm_vcpu *owner,
+			     void __iomem **hgei_va, phys_addr_t *hgei_pa)
+{
+	int ret = -ENOENT;
+	unsigned long flags;
+	struct aia_hgei_control *hgctrl = per_cpu_ptr(&aia_hgei, cpu);
+
+	if (!kvm_riscv_aia_available())
+		return -ENODEV;
+	if (!hgctrl)
+		return -ENODEV;
+
+	raw_spin_lock_irqsave(&hgctrl->lock, flags);
+
+	if (hgctrl->free_bitmap) {
+		ret = __ffs(hgctrl->free_bitmap);
+		hgctrl->free_bitmap &= ~BIT(ret);
+		hgctrl->owners[ret] = owner;
+	}
+
+	raw_spin_unlock_irqrestore(&hgctrl->lock, flags);
+
+	/* TODO: To be updated later by AIA in-kernel irqchip support */
+	if (hgei_va)
+		*hgei_va = NULL;
+	if (hgei_pa)
+		*hgei_pa = 0;
+
+	return ret;
+}
+
+void kvm_riscv_aia_free_hgei(int cpu, int hgei)
+{
+	unsigned long flags;
+	struct aia_hgei_control *hgctrl = per_cpu_ptr(&aia_hgei, cpu);
+
+	if (!kvm_riscv_aia_available() || !hgctrl)
+		return;
+
+	raw_spin_lock_irqsave(&hgctrl->lock, flags);
+
+	if (hgei > 0 && hgei <= kvm_riscv_aia_nr_hgei) {
+		if (!(hgctrl->free_bitmap & BIT(hgei))) {
+			hgctrl->free_bitmap |= BIT(hgei);
+			hgctrl->owners[hgei] = NULL;
+		}
+	}
+
+	raw_spin_unlock_irqrestore(&hgctrl->lock, flags);
+}
+
+void kvm_riscv_aia_wakeon_hgei(struct kvm_vcpu *owner, bool enable)
+{
+	int hgei;
+
+	if (!kvm_riscv_aia_available())
+		return;
+
+	hgei = aia_find_hgei(owner);
+	if (hgei > 0) {
+		if (enable)
+			csr_set(CSR_HGEIE, BIT(hgei));
+		else
+			csr_clear(CSR_HGEIE, BIT(hgei));
+	}
+}
+
+static irqreturn_t hgei_interrupt(int irq, void *dev_id)
+{
+	int i;
+	unsigned long hgei_mask, flags;
+	struct aia_hgei_control *hgctrl = this_cpu_ptr(&aia_hgei);
+
+	hgei_mask = csr_read(CSR_HGEIP) & csr_read(CSR_HGEIE);
+	csr_clear(CSR_HGEIE, hgei_mask);
+
+	raw_spin_lock_irqsave(&hgctrl->lock, flags);
+
+	for_each_set_bit(i, &hgei_mask, BITS_PER_LONG) {
+		if (hgctrl->owners[i])
+			kvm_vcpu_kick(hgctrl->owners[i]);
+	}
+
+	raw_spin_unlock_irqrestore(&hgctrl->lock, flags);
+
+	return IRQ_HANDLED;
+}
+
+static int aia_hgei_init(void)
+{
+	int cpu, rc;
+	struct irq_domain *domain;
+	struct aia_hgei_control *hgctrl;
+
+	/* Initialize per-CPU guest external interrupt line management */
+	for_each_possible_cpu(cpu) {
+		hgctrl = per_cpu_ptr(&aia_hgei, cpu);
+		raw_spin_lock_init(&hgctrl->lock);
+		if (kvm_riscv_aia_nr_hgei) {
+			hgctrl->free_bitmap =
+				BIT(kvm_riscv_aia_nr_hgei + 1) - 1;
+			hgctrl->free_bitmap &= ~BIT(0);
+		} else
+			hgctrl->free_bitmap = 0;
+	}
+
+	/* Find INTC irq domain */
+	domain = irq_find_matching_fwnode(riscv_get_intc_hwnode(),
+					  DOMAIN_BUS_ANY);
+	if (!domain) {
+		kvm_err("unable to find INTC domain\n");
+		return -ENOENT;
+	}
+
+	/* Map per-CPU SGEI interrupt from INTC domain */
+	hgei_parent_irq = irq_create_mapping(domain, IRQ_S_GEXT);
+	if (!hgei_parent_irq) {
+		kvm_err("unable to map SGEI IRQ\n");
+		return -ENOMEM;
+	}
+
+	/* Request per-CPU SGEI interrupt */
+	rc = request_percpu_irq(hgei_parent_irq, hgei_interrupt,
+				"riscv-kvm", &aia_hgei);
+	if (rc) {
+		kvm_err("failed to request SGEI IRQ\n");
+		return rc;
+	}
+
+	return 0;
+}
+
+static void aia_hgei_exit(void)
+{
+	/* Free per-CPU SGEI interrupt */
+	free_percpu_irq(hgei_parent_irq, &aia_hgei);
+}
+
 void kvm_riscv_aia_enable(void)
 {
 	if (!kvm_riscv_aia_available())
@@ -357,21 +535,79 @@ void kvm_riscv_aia_enable(void)
 	csr_write(CSR_HVIPRIO1H, 0x0);
 	csr_write(CSR_HVIPRIO2H, 0x0);
 #endif
+
+	/* Enable per-CPU SGEI interrupt */
+	enable_percpu_irq(hgei_parent_irq,
+			  irq_get_trigger_type(hgei_parent_irq));
+	csr_set(CSR_HIE, BIT(IRQ_S_GEXT));
 }
 
 void kvm_riscv_aia_disable(void)
 {
+	int i;
+	unsigned long flags;
+	struct kvm_vcpu *vcpu;
+	struct aia_hgei_control *hgctrl = this_cpu_ptr(&aia_hgei);
+
 	if (!kvm_riscv_aia_available())
 		return;
 
+	/* Disable per-CPU SGEI interrupt */
+	csr_clear(CSR_HIE, BIT(IRQ_S_GEXT));
+	disable_percpu_irq(hgei_parent_irq);
+
 	aia_set_hvictl(false);
+
+	raw_spin_lock_irqsave(&hgctrl->lock, flags);
+
+	for (i = 0; i <= kvm_riscv_aia_nr_hgei; i++) {
+		vcpu = hgctrl->owners[i];
+		if (!vcpu)
+			continue;
+
+		/*
+		 * We release hgctrl->lock before notifying IMSIC
+		 * so that we don't have lock ordering issues.
+		 */
+		raw_spin_unlock_irqrestore(&hgctrl->lock, flags);
+
+		/* Notify IMSIC */
+		kvm_riscv_vcpu_aia_imsic_release(vcpu);
+
+		/*
+		 * Wakeup VCPU if it was blocked so that it can
+		 * run on other HARTs
+		 */
+		if (csr_read(CSR_HGEIE) & BIT(i)) {
+			csr_clear(CSR_HGEIE, BIT(i));
+			kvm_vcpu_kick(vcpu);
+		}
+
+		raw_spin_lock_irqsave(&hgctrl->lock, flags);
+	}
+
+	raw_spin_unlock_irqrestore(&hgctrl->lock, flags);
 }
 
 int kvm_riscv_aia_init(void)
 {
+	int rc;
+
 	if (!riscv_isa_extension_available(NULL, SxAIA))
 		return -ENODEV;
 
+	/* Figure-out number of bits in HGEIE */
+	csr_write(CSR_HGEIE, -1UL);
+	kvm_riscv_aia_nr_hgei = fls_long(csr_read(CSR_HGEIE));
+	csr_write(CSR_HGEIE, 0);
+	if (kvm_riscv_aia_nr_hgei)
+		kvm_riscv_aia_nr_hgei--;
+
+	/* Initialize guest external interrupt line management */
+	rc = aia_hgei_init();
+	if (rc)
+		return rc;
+
 	/* Enable KVM AIA support */
 	static_branch_enable(&kvm_riscv_aia_available);
 
@@ -380,4 +616,9 @@ int kvm_riscv_aia_init(void)
 
 void kvm_riscv_aia_exit(void)
 {
+	if (!kvm_riscv_aia_available())
+		return;
+
+	/* Cleanup the HGEI state */
+	aia_hgei_exit();
 }
diff --git a/arch/riscv/kvm/main.c b/arch/riscv/kvm/main.c
index d8ff44eb04ca..5cf37dbe8a38 100644
--- a/arch/riscv/kvm/main.c
+++ b/arch/riscv/kvm/main.c
@@ -125,7 +125,8 @@ int kvm_arch_init(void *opaque)
 	kvm_info("VMID %ld bits available\n", kvm_riscv_gstage_vmid_bits());
 
 	if (kvm_riscv_aia_available())
-		kvm_info("AIA available\n");
+		kvm_info("AIA available with %d guest external interrupts\n",
+			 kvm_riscv_aia_nr_hgei);
 
 	return 0;
 }
diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
index 151b35b3b05f..1daa1936b642 100644
--- a/arch/riscv/kvm/vcpu.c
+++ b/arch/riscv/kvm/vcpu.c
@@ -240,10 +240,12 @@ int kvm_cpu_has_pending_timer(struct kvm_vcpu *vcpu)
 
 void kvm_arch_vcpu_blocking(struct kvm_vcpu *vcpu)
 {
+	kvm_riscv_aia_wakeon_hgei(vcpu, true);
 }
 
 void kvm_arch_vcpu_unblocking(struct kvm_vcpu *vcpu)
 {
+	kvm_riscv_aia_wakeon_hgei(vcpu, false);
 }
 
 int kvm_arch_vcpu_runnable(struct kvm_vcpu *vcpu)
-- 
2.34.1

