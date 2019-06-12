Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8998A42065
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2019 11:15:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408577AbfFLJLy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Jun 2019 05:11:54 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:60762 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2408175AbfFLJLy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Jun 2019 05:11:54 -0400
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 2DDE0B6C3954A0597502;
        Wed, 12 Jun 2019 17:11:51 +0800 (CST)
Received: from HGHY2Y004646261.china.huawei.com (10.184.12.158) by
 DGGEMS409-HUB.china.huawei.com (10.3.19.209) with Microsoft SMTP Server id
 14.3.439.0; Wed, 12 Jun 2019 17:11:44 +0800
From:   Zenghui Yu <yuzenghui@huawei.com>
To:     <linux-arm-kernel@lists.infradead.org>,
        <kvmarm@lists.cs.columbia.edu>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-perf-users@vger.kernel.org>
CC:     <christoffer.dall@arm.com>, <marc.zyngier@arm.com>,
        <acme@redhat.com>, <peterz@infradead.org>, <mingo@redhat.com>,
        <ganapatrao.kulkarni@cavium.com>, <catalin.marinas@arm.com>,
        <will.deacon@arm.com>, <mark.rutland@arm.com>, <acme@kernel.org>,
        <alexander.shishkin@linux.intel.com>, <jolsa@redhat.com>,
        <namhyung@kernel.org>, <wanghaibin.wang@huawei.com>,
        <xiexiangyou@huawei.com>, <linuxarm@huawei.com>,
        Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH v1 2/5] KVM: arm/arm64: Adjust entry/exit and trap related tracepoints
Date:   Wed, 12 Jun 2019 09:08:43 +0000
Message-ID: <1560330526-15468-3-git-send-email-yuzenghui@huawei.com>
X-Mailer: git-send-email 2.6.4.windows.1
In-Reply-To: <1560330526-15468-1-git-send-email-yuzenghui@huawei.com>
References: <1560330526-15468-1-git-send-email-yuzenghui@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.184.12.158]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Currently, we use trace_kvm_exit() to report exception type (e.g.,
"IRQ", "TRAP") and exception class (ESR_ELx's bit[31:26]) together.
But hardware only saves the exit class to ESR_ELx on synchronous
exceptions, not on asynchronous exceptions. When the guest exits
due to external interrupts, we will get tracing output like:

	"kvm_exit: IRQ: HSR_EC: 0x0000 (UNKNOWN), PC: 0xffff87259e30"

Obviously, "HSR_EC" here is meaningless.

This patch splits "exit" and "trap" events by adding two tracepoints
explicitly in handle_trap_exceptions(). Let trace_kvm_exit() report VM
exit events, and trace_kvm_trap_exit() report VM trap events.

These tracepoints are adjusted also in preparation for supporting
'perf kvm stat' on arm64.

Cc: Christoffer Dall <christoffer.dall@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Signed-off-by: Zenghui Yu <yuzenghui@huawei.com>
---
 arch/arm64/kvm/handle_exit.c |  3 +++
 arch/arm64/kvm/trace.h       | 35 +++++++++++++++++++++++++++++++++++
 virt/kvm/arm/arm.c           |  4 ++--
 virt/kvm/arm/trace.h         | 21 +++++++++++----------
 4 files changed, 51 insertions(+), 12 deletions(-)

diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
index 516aead..af3c732 100644
--- a/arch/arm64/kvm/handle_exit.c
+++ b/arch/arm64/kvm/handle_exit.c
@@ -264,7 +264,10 @@ static int handle_trap_exceptions(struct kvm_vcpu *vcpu, struct kvm_run *run)
 		exit_handle_fn exit_handler;
 
 		exit_handler = kvm_get_exit_handler(vcpu);
+		trace_kvm_trap_enter(vcpu->vcpu_id,
+				     kvm_vcpu_trap_get_class(vcpu));
 		handled = exit_handler(vcpu, run);
+		trace_kvm_trap_exit(vcpu->vcpu_id);
 	}
 
 	return handled;
diff --git a/arch/arm64/kvm/trace.h b/arch/arm64/kvm/trace.h
index eab91ad..6014c73 100644
--- a/arch/arm64/kvm/trace.h
+++ b/arch/arm64/kvm/trace.h
@@ -8,6 +8,41 @@
 #undef TRACE_SYSTEM
 #define TRACE_SYSTEM kvm
 
+TRACE_EVENT(kvm_trap_enter,
+	TP_PROTO(unsigned int vcpu_id, unsigned int esr_ec),
+	TP_ARGS(vcpu_id, esr_ec),
+
+	TP_STRUCT__entry(
+		__field(unsigned int,	vcpu_id)
+		__field(unsigned int,	esr_ec)
+	),
+
+	TP_fast_assign(
+		__entry->vcpu_id	= vcpu_id;
+		__entry->esr_ec		= esr_ec;
+	),
+
+	TP_printk("VCPU %u: HSR_EC=0x%04x (%s)",
+		  __entry->vcpu_id,
+		  __entry->esr_ec,
+		  __print_symbolic(__entry->esr_ec, kvm_arm_exception_class))
+);
+
+TRACE_EVENT(kvm_trap_exit,
+	TP_PROTO(unsigned int vcpu_id),
+	TP_ARGS(vcpu_id),
+
+	TP_STRUCT__entry(
+		__field(unsigned int,	vcpu_id)
+	),
+
+	TP_fast_assign(
+		__entry->vcpu_id	= vcpu_id;
+	),
+
+	TP_printk("VCPU %u", __entry->vcpu_id)
+);
+
 TRACE_EVENT(kvm_wfx_arm64,
 	TP_PROTO(unsigned long vcpu_pc, bool is_wfe),
 	TP_ARGS(vcpu_pc, is_wfe),
diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
index 90cedeb..9f63fd9 100644
--- a/virt/kvm/arm/arm.c
+++ b/virt/kvm/arm/arm.c
@@ -758,7 +758,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
 		/**************************************************************
 		 * Enter the guest
 		 */
-		trace_kvm_entry(*vcpu_pc(vcpu));
+		trace_kvm_entry(vcpu->vcpu_id, *vcpu_pc(vcpu));
 		guest_enter_irqoff();
 
 		if (has_vhe()) {
@@ -822,7 +822,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
 		 * guest time.
 		 */
 		guest_exit();
-		trace_kvm_exit(ret, kvm_vcpu_trap_get_class(vcpu), *vcpu_pc(vcpu));
+		trace_kvm_exit(vcpu->vcpu_id, ret, *vcpu_pc(vcpu));
 
 		/* Exit types that need handling before we can be preempted */
 		handle_exit_early(vcpu, run, ret);
diff --git a/virt/kvm/arm/trace.h b/virt/kvm/arm/trace.h
index 8b7dff2..edd9dae 100644
--- a/virt/kvm/arm/trace.h
+++ b/virt/kvm/arm/trace.h
@@ -12,40 +12,41 @@
  * Tracepoints for entry/exit to guest
  */
 TRACE_EVENT(kvm_entry,
-	TP_PROTO(unsigned long vcpu_pc),
-	TP_ARGS(vcpu_pc),
+	TP_PROTO(unsigned int vcpu_id, unsigned long vcpu_pc),
+	TP_ARGS(vcpu_id, vcpu_pc),
 
 	TP_STRUCT__entry(
+		__field(	unsigned int,	vcpu_id		)
 		__field(	unsigned long,	vcpu_pc		)
 	),
 
 	TP_fast_assign(
+		__entry->vcpu_id		= vcpu_id;
 		__entry->vcpu_pc		= vcpu_pc;
 	),
 
-	TP_printk("PC: 0x%08lx", __entry->vcpu_pc)
+	TP_printk("VCPU %u: PC=0x%08lx", __entry->vcpu_id, __entry->vcpu_pc)
 );
 
 TRACE_EVENT(kvm_exit,
-	TP_PROTO(int ret, unsigned int esr_ec, unsigned long vcpu_pc),
-	TP_ARGS(ret, esr_ec, vcpu_pc),
+	TP_PROTO(unsigned int vcpu_id, int ret, unsigned long vcpu_pc),
+	TP_ARGS(vcpu_id, ret, vcpu_pc),
 
 	TP_STRUCT__entry(
+		__field(	unsigned int,	vcpu_id		)
 		__field(	int,		ret		)
-		__field(	unsigned int,	esr_ec		)
 		__field(	unsigned long,	vcpu_pc		)
 	),
 
 	TP_fast_assign(
+		__entry->vcpu_id		= vcpu_id;
 		__entry->ret			= ARM_EXCEPTION_CODE(ret);
-		__entry->esr_ec = ARM_EXCEPTION_IS_TRAP(ret) ? esr_ec : 0;
 		__entry->vcpu_pc		= vcpu_pc;
 	),
 
-	TP_printk("%s: HSR_EC: 0x%04x (%s), PC: 0x%08lx",
+	TP_printk("VCPU %u: exit_type=%s, PC=0x%08lx",
+		  __entry->vcpu_id,
 		  __print_symbolic(__entry->ret, kvm_arm_exception_type),
-		  __entry->esr_ec,
-		  __print_symbolic(__entry->esr_ec, kvm_arm_exception_class),
 		  __entry->vcpu_pc)
 );
 
-- 
1.8.3.1


