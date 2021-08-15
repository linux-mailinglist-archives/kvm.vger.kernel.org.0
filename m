Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 584653EC68E
	for <lists+kvm@lfdr.de>; Sun, 15 Aug 2021 03:05:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235896AbhHOBEI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 14 Aug 2021 21:04:08 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:31774 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237460AbhHOBDj (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 14 Aug 2021 21:03:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628989390;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zmdBvLLhJfb1csChY5ukCjA4xux/SVCGMbiRknEqz7Y=;
        b=cJOMhPiayIMzyhorVk13XFOQ2mf3GqV5UzUq4iTlDJ2OsgNpZURARBLE2bzXuug7Il9Ing
        kcbt6I6HZ7NeBMiqf+Tkp1VB77rK3e+lYQt3td5pJuxXEZGM8q8pB173/Qu4qv7RNr8fok
        rQCXvDLmV3AC8wW/o8OEt6nbXMe/Lww=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-217-vIHuds8uPEKqO2rck0-ZBA-1; Sat, 14 Aug 2021 21:03:08 -0400
X-MC-Unique: vIHuds8uPEKqO2rck0-ZBA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 37DAC1853030;
        Sun, 15 Aug 2021 01:03:07 +0000 (UTC)
Received: from gshan.redhat.com (vpn2-54-103.bne.redhat.com [10.64.54.103])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 1662D6091B;
        Sun, 15 Aug 2021 01:02:57 +0000 (UTC)
From:   Gavin Shan <gshan@redhat.com>
To:     kvmarm@lists.cs.columbia.edu
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        james.morse@arm.com, mark.rutland@arm.com,
        Jonathan.Cameron@huawei.com, will@kernel.org, maz@kernel.org,
        pbonzini@redhat.com, vkuznets@redhat.com, shan.gavin@gmail.com
Subject: [PATCH v4 14/15] arm64: Enable async PF
Date:   Sun, 15 Aug 2021 08:59:46 +0800
Message-Id: <20210815005947.83699-15-gshan@redhat.com>
In-Reply-To: <20210815005947.83699-1-gshan@redhat.com>
References: <20210815005947.83699-1-gshan@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This enables asynchronous page fault from guest side. The design
is highlighted as below:

   * The per-vCPU shared memory region, which is represented by
     "struct kvm_vcpu_pv_apf_data", is allocated. The reason and
     token associated with the received notifications of asynchronous
     page fault are delivered through it.

   * A per-vCPU table, which is represented by "struct kvm_apf_table",
     is allocated. The process, on which the page-not-present notification
     is received, is added into the table so that it can reschedule
     itself on switching from kernel to user mode. Afterwards, the
     process, identified by token, is removed from the table and put
     into runnable state when page-ready notification is received.

   * During CPU hotplug, the (private) SDEI event is expected to be
     enabled or disabled on the affected CPU by SDEI client driver.
     The (PPI) interrupt is enabled or disabled on the affected CPU
     by ourself. When the system is going to reboot, the SDEI event
     is disabled and unregistered and the (PPI) interrupt is disabled.

   * The SDEI event and (PPI) interrupt number are retrieved from host
     through SMCCC interface. Besides, the version of the asynchronous
     page fault is validated when the feature is enabled on the guest.

   * The feature is disabled on guest when boot parameter "no-kvmapf"
     is specified.

Signed-off-by: Gavin Shan <gshan@redhat.com>
---
 arch/arm64/kernel/Makefile |   1 +
 arch/arm64/kernel/kvm.c    | 452 +++++++++++++++++++++++++++++++++++++
 2 files changed, 453 insertions(+)
 create mode 100644 arch/arm64/kernel/kvm.c

diff --git a/arch/arm64/kernel/Makefile b/arch/arm64/kernel/Makefile
index 3f1490bfb938..f0c1a6a7eaa7 100644
--- a/arch/arm64/kernel/Makefile
+++ b/arch/arm64/kernel/Makefile
@@ -59,6 +59,7 @@ obj-$(CONFIG_ACPI)			+= acpi.o
 obj-$(CONFIG_ACPI_NUMA)			+= acpi_numa.o
 obj-$(CONFIG_ARM64_ACPI_PARKING_PROTOCOL)	+= acpi_parking_protocol.o
 obj-$(CONFIG_PARAVIRT)			+= paravirt.o
+obj-$(CONFIG_KVM_GUEST)			+= kvm.o
 obj-$(CONFIG_RANDOMIZE_BASE)		+= kaslr.o
 obj-$(CONFIG_HIBERNATION)		+= hibernate.o hibernate-asm.o
 obj-$(CONFIG_KEXEC_CORE)		+= machine_kexec.o relocate_kernel.o	\
diff --git a/arch/arm64/kernel/kvm.c b/arch/arm64/kernel/kvm.c
new file mode 100644
index 000000000000..effe8dc7e921
--- /dev/null
+++ b/arch/arm64/kernel/kvm.c
@@ -0,0 +1,452 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Asynchronous page fault support.
+ *
+ * Copyright (C) 2021 Red Hat, Inc.
+ *
+ * Author(s): Gavin Shan <gshan@redhat.com>
+ */
+
+#include <linux/kernel.h>
+#include <linux/spinlock.h>
+#include <linux/slab.h>
+#include <linux/interrupt.h>
+#include <linux/irq.h>
+#include <linux/of.h>
+#include <linux/of_fdt.h>
+#include <linux/arm-smccc.h>
+#include <linux/kvm_para.h>
+#include <linux/arm_sdei.h>
+#include <linux/acpi.h>
+#include <linux/cpuhotplug.h>
+#include <linux/reboot.h>
+
+struct kvm_apf_task {
+	unsigned int		token;
+	struct task_struct	*task;
+	struct swait_queue_head	wq;
+};
+
+struct kvm_apf_table {
+	raw_spinlock_t		lock;
+	unsigned int		count;
+	struct kvm_apf_task	tasks[0];
+};
+
+static bool async_pf_available = true;
+static DEFINE_PER_CPU_DECRYPTED(struct kvm_vcpu_pv_apf_data, apf_data) __aligned(64);
+static struct kvm_apf_table __percpu *apf_tables;
+static unsigned int apf_tasks;
+static unsigned int apf_sdei_num;
+static unsigned int apf_ppi_num;
+static int apf_irq;
+
+static bool kvm_async_pf_add_task(struct task_struct *task,
+				  unsigned int token)
+{
+	struct kvm_apf_table *table = this_cpu_ptr(apf_tables);
+	unsigned int i, index = apf_tasks;
+	bool ret = false;
+
+	raw_spin_lock(&table->lock);
+
+	if (WARN_ON(table->count >= apf_tasks))
+		goto unlock;
+
+	for (i = 0; i < apf_tasks; i++) {
+		if (!table->tasks[i].task) {
+			if (index == apf_tasks) {
+				ret = true;
+				index = i;
+			}
+		} else if (table->tasks[i].task == task) {
+			WARN_ON(table->tasks[i].token != token);
+			ret = false;
+			break;
+		}
+	}
+
+	if (!ret)
+		goto unlock;
+
+	task->thread.data = &table->tasks[index].wq;
+	set_tsk_thread_flag(task, TIF_ASYNC_PF);
+
+	table->count++;
+	table->tasks[index].task = task;
+	table->tasks[index].token = token;
+
+unlock:
+	raw_spin_unlock(&table->lock);
+	return ret;
+}
+
+static inline void kvm_async_pf_remove_one_task(struct kvm_apf_table *table,
+						unsigned int index)
+{
+	clear_tsk_thread_flag(table->tasks[index].task, TIF_ASYNC_PF);
+	WRITE_ONCE(table->tasks[index].task->thread.data, NULL);
+
+	table->count--;
+	table->tasks[index].task = NULL;
+	table->tasks[index].token = 0;
+
+	swake_up_one(&table->tasks[index].wq);
+}
+
+static bool kvm_async_pf_remove_task(unsigned int token)
+{
+	struct kvm_apf_table *table = this_cpu_ptr(apf_tables);
+	unsigned int i;
+	bool ret = (token == UINT_MAX);
+
+	raw_spin_lock(&table->lock);
+
+	for (i = 0; i < apf_tasks; i++) {
+		if (!table->tasks[i].task)
+			continue;
+
+		/* Wakeup all */
+		if (token == UINT_MAX) {
+			kvm_async_pf_remove_one_task(table, i);
+			continue;
+		}
+
+		if (table->tasks[i].token == token) {
+			kvm_async_pf_remove_one_task(table, i);
+			ret = true;
+			break;
+		}
+	}
+
+	raw_spin_unlock(&table->lock);
+
+	return ret;
+}
+
+static int kvm_async_pf_sdei_handler(unsigned int event,
+				     struct pt_regs *regs,
+				     void *arg)
+{
+	unsigned int reason = __this_cpu_read(apf_data.reason);
+	unsigned int token = __this_cpu_read(apf_data.token);
+	bool ret;
+
+	if (reason != KVM_PV_REASON_PAGE_NOT_PRESENT) {
+		pr_warn("%s: Bogus notification (%d, 0x%08x)\n",
+			__func__, reason, token);
+		return -EINVAL;
+	}
+
+	ret = kvm_async_pf_add_task(current, token);
+	__this_cpu_write(apf_data.token, 0);
+	__this_cpu_write(apf_data.reason, 0);
+
+	if (!ret)
+		return -ENOSPC;
+
+	smp_send_reschedule(smp_processor_id());
+
+	return 0;
+}
+
+static irqreturn_t kvm_async_pf_irq_handler(int irq, void *dev_id)
+{
+	unsigned int reason = __this_cpu_read(apf_data.reason);
+	unsigned int token = __this_cpu_read(apf_data.token);
+	struct arm_smccc_res res;
+
+	if (reason != KVM_PV_REASON_PAGE_READY) {
+		pr_warn("%s: Bogus interrupt %d (%d, 0x%08x)\n",
+			__func__, irq, reason, token);
+		return IRQ_HANDLED;
+	}
+
+	kvm_async_pf_remove_task(token);
+
+	__this_cpu_write(apf_data.token, 0);
+	__this_cpu_write(apf_data.reason, 0);
+	arm_smccc_1_1_invoke(ARM_SMCCC_VENDOR_HYP_KVM_ASYNC_PF_FUNC_ID,
+			     ARM_SMCCC_KVM_FUNC_ASYNC_PF_IRQ_ACK, &res);
+
+	return IRQ_HANDLED;
+}
+
+static int __init kvm_async_pf_available(char *arg)
+{
+	async_pf_available = false;
+
+	return 0;
+}
+early_param("no-kvmapf", kvm_async_pf_available);
+
+static void kvm_async_pf_disable(void)
+{
+	struct arm_smccc_res res;
+	u32 enabled = __this_cpu_read(apf_data.enabled);
+
+	if (!enabled)
+		return;
+
+	/* Disable the functionality */
+	arm_smccc_1_1_invoke(ARM_SMCCC_VENDOR_HYP_KVM_ASYNC_PF_FUNC_ID,
+			     ARM_SMCCC_KVM_FUNC_ASYNC_PF_ENABLE,
+			     0, 0, &res);
+	if (res.a0 != SMCCC_RET_SUCCESS) {
+		pr_warn("%s: Error %ld to disable on CPU%d\n",
+			__func__, res.a0, smp_processor_id());
+		return;
+	}
+
+	__this_cpu_write(apf_data.enabled, 0);
+
+	pr_info("Async PF disabled on CPU%d\n", smp_processor_id());
+}
+
+static void kvm_async_pf_enable(void)
+{
+	struct arm_smccc_res res;
+	u32 enabled = __this_cpu_read(apf_data.enabled);
+	u64 val = virt_to_phys(this_cpu_ptr(&apf_data));
+
+	if (enabled)
+		return;
+
+	val |= KVM_ASYNC_PF_ENABLED;
+	arm_smccc_1_1_invoke(ARM_SMCCC_VENDOR_HYP_KVM_ASYNC_PF_FUNC_ID,
+			     ARM_SMCCC_KVM_FUNC_ASYNC_PF_ENABLE,
+			     (u32)val, (u32)(val >> 32), &res);
+	if (res.a0 != SMCCC_RET_SUCCESS) {
+		pr_warn("%s: Error %ld to enable CPU%d\n",
+			__func__, res.a0, smp_processor_id());
+		return;
+	}
+
+	__this_cpu_write(apf_data.enabled, 1);
+
+	pr_info("Async PF enabled on CPU%d\n", smp_processor_id());
+}
+
+static void kvm_async_pf_cpu_disable(void *info)
+{
+	disable_percpu_irq(apf_irq);
+	kvm_async_pf_disable();
+}
+
+static void kvm_async_pf_cpu_enable(void *info)
+{
+	enable_percpu_irq(apf_irq, IRQ_TYPE_LEVEL_HIGH);
+	kvm_async_pf_enable();
+}
+
+static int kvm_async_pf_cpu_reboot_notify(struct notifier_block *nb,
+					  unsigned long code,
+					  void *unused)
+{
+	if (code == SYS_RESTART) {
+		sdei_event_disable(apf_sdei_num);
+		sdei_event_unregister(apf_sdei_num);
+
+		on_each_cpu(kvm_async_pf_cpu_disable, NULL, 1);
+	}
+
+	return NOTIFY_DONE;
+}
+
+static struct notifier_block kvm_async_pf_cpu_reboot_nb = {
+	.notifier_call = kvm_async_pf_cpu_reboot_notify,
+};
+
+static int kvm_async_pf_cpu_online(unsigned int cpu)
+{
+	kvm_async_pf_cpu_enable(NULL);
+
+	return 0;
+}
+
+static int kvm_async_pf_cpu_offline(unsigned int cpu)
+{
+	kvm_async_pf_cpu_disable(NULL);
+
+	return 0;
+}
+
+static int __init kvm_async_pf_check_version(void)
+{
+	struct arm_smccc_res res;
+
+	/*
+	 * Check the version and v1.0.0 or higher version is required
+	 * to support the functionality.
+	 */
+	arm_smccc_1_1_invoke(ARM_SMCCC_VENDOR_HYP_KVM_ASYNC_PF_FUNC_ID,
+			     ARM_SMCCC_KVM_FUNC_ASYNC_PF_VERSION, &res);
+	if (res.a0 != SMCCC_RET_SUCCESS) {
+		pr_warn("%s: Error %ld to get version\n",
+			__func__, res.a0);
+		return -EPERM;
+	}
+
+	if ((res.a1 & 0xFFFFFFFFFF000000) ||
+	    ((res.a1 & 0xFF0000) >> 16) < 0x1) {
+		pr_warn("%s: Invalid version (0x%016lx)\n",
+			__func__, res.a1);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int __init kvm_async_pf_info(void)
+{
+	struct arm_smccc_res res;
+
+	/* Retrieve number of tokens */
+	arm_smccc_1_1_invoke(ARM_SMCCC_VENDOR_HYP_KVM_ASYNC_PF_FUNC_ID,
+			     ARM_SMCCC_KVM_FUNC_ASYNC_PF_SLOTS, &res);
+	if (res.a0 != SMCCC_RET_SUCCESS) {
+		pr_warn("%s: Error %ld to get token number\n",
+			__func__, res.a0);
+		return -EPERM;
+	}
+
+	apf_tasks = res.a1 * 2;
+
+	/* Retrieve SDEI event number */
+	arm_smccc_1_1_invoke(ARM_SMCCC_VENDOR_HYP_KVM_ASYNC_PF_FUNC_ID,
+			     ARM_SMCCC_KVM_FUNC_ASYNC_PF_SDEI, &res);
+	if (res.a0 != SMCCC_RET_SUCCESS) {
+		pr_warn("%s: Error %ld to get SDEI event number\n",
+			__func__, res.a0);
+		return -EPERM;
+	}
+
+	apf_sdei_num = res.a1;
+
+	/* Retrieve (PPI) interrupt number */
+	arm_smccc_1_1_invoke(ARM_SMCCC_VENDOR_HYP_KVM_ASYNC_PF_FUNC_ID,
+			     ARM_SMCCC_KVM_FUNC_ASYNC_PF_IRQ, &res);
+	if (res.a0 != SMCCC_RET_SUCCESS) {
+		pr_warn("%s: Error %ld to get IRQ\n",
+			__func__, res.a0);
+		return -EPERM;
+	}
+
+	apf_ppi_num = res.a1;
+
+	return 0;
+}
+
+static int __init kvm_async_pf_init(void)
+{
+	struct kvm_apf_table *table;
+	size_t size;
+	int cpu, i, ret;
+
+	if (!kvm_para_has_feature(KVM_FEATURE_ASYNC_PF) ||
+	    !async_pf_available)
+		return -EPERM;
+
+	ret = kvm_async_pf_check_version();
+	if (ret)
+		return ret;
+
+	ret = kvm_async_pf_info();
+	if (ret)
+		return ret;
+
+	/* Allocate and initialize the sleeper table */
+	size = sizeof(struct kvm_apf_table) +
+	       apf_tasks * sizeof(struct kvm_apf_task);
+	apf_tables = __alloc_percpu(size, 0);
+	if (!apf_tables) {
+		pr_warn("%s: Unable to alloc async PF table\n",
+			__func__);
+		return -ENOMEM;
+	}
+
+	for_each_possible_cpu(cpu) {
+		table = per_cpu_ptr(apf_tables, cpu);
+		raw_spin_lock_init(&table->lock);
+		for (i = 0; i < apf_tasks; i++)
+			init_swait_queue_head(&table->tasks[i].wq);
+	}
+
+	/*
+	 * Initialize SDEI event for page-not-present notification.
+	 * The SDEI event number should have been retrieved from
+	 * the host.
+	 */
+	ret = sdei_event_register(apf_sdei_num,
+				  kvm_async_pf_sdei_handler, NULL);
+	if (ret) {
+		pr_warn("%s: Error %d to register SDEI event\n",
+			__func__, ret);
+		ret = -EIO;
+		goto release_tables;
+	}
+
+	ret = sdei_event_enable(apf_sdei_num);
+	if (ret) {
+		pr_warn("%s: Error %d to enable SDEI event\n",
+			__func__, ret);
+		goto unregister_event;
+	}
+
+	/*
+	 * Initialize interrupt for page-ready notification. The
+	 * interrupt number and its properties should have been
+	 * retrieved from the ACPI:APFT table.
+	 */
+	apf_irq = acpi_register_gsi(NULL, apf_ppi_num,
+				    ACPI_LEVEL_SENSITIVE, ACPI_ACTIVE_HIGH);
+	if (apf_irq <= 0) {
+		ret = -EIO;
+		pr_warn("%s: Error %d to register IRQ\n",
+			__func__, apf_irq);
+		goto disable_event;
+	}
+
+	ret = request_percpu_irq(apf_irq, kvm_async_pf_irq_handler,
+				 "Asynchronous Page Fault", &apf_data);
+	if (ret) {
+		pr_warn("%s: Error %d to request IRQ\n",
+			__func__, ret);
+		goto unregister_irq;
+	}
+
+	register_reboot_notifier(&kvm_async_pf_cpu_reboot_nb);
+	ret = cpuhp_setup_state_nocalls(CPUHP_AP_ONLINE_DYN,
+			"arm/kvm:online", kvm_async_pf_cpu_online,
+			kvm_async_pf_cpu_offline);
+	if (ret < 0) {
+		pr_warn("%s: Error %d to install cpu hotplug callbacks\n",
+			__func__, ret);
+		goto release_irq;
+	}
+
+	/* Enable async PF on the online CPUs */
+	on_each_cpu(kvm_async_pf_cpu_enable, NULL, 1);
+
+	return 0;
+
+release_irq:
+	free_percpu_irq(apf_irq, &apf_data);
+unregister_irq:
+	acpi_unregister_gsi(apf_ppi_num);
+disable_event:
+	sdei_event_disable(apf_sdei_num);
+unregister_event:
+	sdei_event_unregister(apf_sdei_num);
+release_tables:
+	free_percpu(apf_tables);
+
+	return ret;
+}
+
+static int __init kvm_guest_init(void)
+{
+	return kvm_async_pf_init();
+}
+
+fs_initcall(kvm_guest_init);
-- 
2.23.0

