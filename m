Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1206129A4A
	for <lists+kvm@lfdr.de>; Fri, 24 May 2019 16:48:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404202AbfEXOsE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 May 2019 10:48:04 -0400
Received: from usa-sjc-mx-foss1.foss.arm.com ([217.140.101.70]:44500 "EHLO
        foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404198AbfEXOsD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 May 2019 10:48:03 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5A32D1682;
        Fri, 24 May 2019 07:48:03 -0700 (PDT)
Received: from filthy-habits.cambridge.arm.com (filthy-habits.cambridge.arm.com [10.1.197.61])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B133B3F575;
        Fri, 24 May 2019 07:48:01 -0700 (PDT)
From:   Marc Zyngier <marc.zyngier@arm.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc:     James Morse <james.morse@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Julien Thierry <julien.thierry@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Subject: [PATCH 2/3] KVM: arm64: Move pmu hyp code under hyp's Makefile to avoid instrumentation
Date:   Fri, 24 May 2019 15:47:44 +0100
Message-Id: <20190524144745.227242-3-marc.zyngier@arm.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190524144745.227242-1-marc.zyngier@arm.com>
References: <20190524144745.227242-1-marc.zyngier@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: James Morse <james.morse@arm.com>

KVM's pmu.c contains the __hyp_text needed to switch the pmu registers
between host and guest. Because this isn't covered by the 'hyp' Makefile,
it can be built with kasan and friends when these are enabled in Kconfig.

When starting a guest, this results in:
| Kernel panic - not syncing: HYP panic:
| PS:a00003c9 PC:000083000028ada0 ESR:86000007
| FAR:000083000028ada0 HPFAR:0000000029df5300 PAR:0000000000000000
| VCPU:000000004e10b7d6
| CPU: 0 PID: 3088 Comm: qemu-system-aar Not tainted 5.2.0-rc1 #11026
| Hardware name: ARM LTD ARM Juno Development Platform/ARM Juno Development Plat
| Call trace:
|  dump_backtrace+0x0/0x200
|  show_stack+0x20/0x30
|  dump_stack+0xec/0x158
|  panic+0x1ec/0x420
|  panic+0x0/0x420
| SMP: stopping secondary CPUs
| Kernel Offset: disabled
| CPU features: 0x002,25006082
| Memory Limit: none
| ---[ end Kernel panic - not syncing: HYP panic:

This is caused by functions in pmu.c calling the instrumented
code, which isn't mapped to hyp. From objdump -r:
| RELOCATION RECORDS FOR [.hyp.text]:
| OFFSET           TYPE              VALUE
| 0000000000000010 R_AARCH64_CALL26  __sanitizer_cov_trace_pc
| 0000000000000018 R_AARCH64_CALL26  __asan_load4_noabort
| 0000000000000024 R_AARCH64_CALL26  __asan_load4_noabort

Move the affected code to a new file under 'hyp's Makefile.

Fixes: 3d91befbb3a0 ("arm64: KVM: Enable !VHE support for :G/:H perf event modifiers")
Cc: Andrew Murray <Andrew.Murray@arm.com>
Signed-off-by: James Morse <james.morse@arm.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/include/asm/kvm_host.h |  3 ---
 arch/arm64/kvm/hyp/switch.c       | 39 +++++++++++++++++++++++++++++++
 arch/arm64/kvm/pmu.c              | 38 ------------------------------
 3 files changed, 39 insertions(+), 41 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 2a8d3f8ca22c..4bcd9c1291d5 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -592,9 +592,6 @@ static inline int kvm_arch_vcpu_run_pid_change(struct kvm_vcpu *vcpu)
 void kvm_set_pmu_events(u32 set, struct perf_event_attr *attr);
 void kvm_clr_pmu_events(u32 clr);
 
-void __pmu_switch_to_host(struct kvm_cpu_context *host_ctxt);
-bool __pmu_switch_to_guest(struct kvm_cpu_context *host_ctxt);
-
 void kvm_vcpu_pmu_restore_guest(struct kvm_vcpu *vcpu);
 void kvm_vcpu_pmu_restore_host(struct kvm_vcpu *vcpu);
 #else
diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
index 22b4c335e0b2..8799e0c267d4 100644
--- a/arch/arm64/kvm/hyp/switch.c
+++ b/arch/arm64/kvm/hyp/switch.c
@@ -16,6 +16,7 @@
  */
 
 #include <linux/arm-smccc.h>
+#include <linux/kvm_host.h>
 #include <linux/types.h>
 #include <linux/jump_label.h>
 #include <uapi/linux/psci.h>
@@ -505,6 +506,44 @@ static void __hyp_text __set_host_arch_workaround_state(struct kvm_vcpu *vcpu)
 #endif
 }
 
+/**
+ * Disable host events, enable guest events
+ */
+static bool __hyp_text __pmu_switch_to_guest(struct kvm_cpu_context *host_ctxt)
+{
+	struct kvm_host_data *host;
+	struct kvm_pmu_events *pmu;
+
+	host = container_of(host_ctxt, struct kvm_host_data, host_ctxt);
+	pmu = &host->pmu_events;
+
+	if (pmu->events_host)
+		write_sysreg(pmu->events_host, pmcntenclr_el0);
+
+	if (pmu->events_guest)
+		write_sysreg(pmu->events_guest, pmcntenset_el0);
+
+	return (pmu->events_host || pmu->events_guest);
+}
+
+/**
+ * Disable guest events, enable host events
+ */
+static void __hyp_text __pmu_switch_to_host(struct kvm_cpu_context *host_ctxt)
+{
+	struct kvm_host_data *host;
+	struct kvm_pmu_events *pmu;
+
+	host = container_of(host_ctxt, struct kvm_host_data, host_ctxt);
+	pmu = &host->pmu_events;
+
+	if (pmu->events_guest)
+		write_sysreg(pmu->events_guest, pmcntenclr_el0);
+
+	if (pmu->events_host)
+		write_sysreg(pmu->events_host, pmcntenset_el0);
+}
+
 /* Switch to the guest for VHE systems running in EL2 */
 int kvm_vcpu_run_vhe(struct kvm_vcpu *vcpu)
 {
diff --git a/arch/arm64/kvm/pmu.c b/arch/arm64/kvm/pmu.c
index 3da94a5bb6b7..e71d00bb5271 100644
--- a/arch/arm64/kvm/pmu.c
+++ b/arch/arm64/kvm/pmu.c
@@ -53,44 +53,6 @@ void kvm_clr_pmu_events(u32 clr)
 	ctx->pmu_events.events_guest &= ~clr;
 }
 
-/**
- * Disable host events, enable guest events
- */
-bool __hyp_text __pmu_switch_to_guest(struct kvm_cpu_context *host_ctxt)
-{
-	struct kvm_host_data *host;
-	struct kvm_pmu_events *pmu;
-
-	host = container_of(host_ctxt, struct kvm_host_data, host_ctxt);
-	pmu = &host->pmu_events;
-
-	if (pmu->events_host)
-		write_sysreg(pmu->events_host, pmcntenclr_el0);
-
-	if (pmu->events_guest)
-		write_sysreg(pmu->events_guest, pmcntenset_el0);
-
-	return (pmu->events_host || pmu->events_guest);
-}
-
-/**
- * Disable guest events, enable host events
- */
-void __hyp_text __pmu_switch_to_host(struct kvm_cpu_context *host_ctxt)
-{
-	struct kvm_host_data *host;
-	struct kvm_pmu_events *pmu;
-
-	host = container_of(host_ctxt, struct kvm_host_data, host_ctxt);
-	pmu = &host->pmu_events;
-
-	if (pmu->events_guest)
-		write_sysreg(pmu->events_guest, pmcntenclr_el0);
-
-	if (pmu->events_host)
-		write_sysreg(pmu->events_host, pmcntenset_el0);
-}
-
 #define PMEVTYPER_READ_CASE(idx)				\
 	case idx:						\
 		return read_sysreg(pmevtyper##idx##_el0)
-- 
2.20.1

