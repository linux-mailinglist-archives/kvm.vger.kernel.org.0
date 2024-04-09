Return-Path: <kvm+bounces-13977-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id CB80589D5F4
	for <lists+kvm@lfdr.de>; Tue,  9 Apr 2024 11:49:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 42B611F24365
	for <lists+kvm@lfdr.de>; Tue,  9 Apr 2024 09:49:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C7E28004B;
	Tue,  9 Apr 2024 09:49:14 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4D31A7F478;
	Tue,  9 Apr 2024 09:49:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712656153; cv=none; b=C42HlQwlLa8Eo7xSN1STnMILvp6on1pcUY6xjIrHr3aw6tZ14TyQs6yhvQI6Uv7x2JwP9aDFQ/Evq1VPRUsKNSHnEJIs/Fz2jkV6KpoRuHETlPQw6iodVS6KU4Jv5KpAo+JKbwtPqD0RVlfaFODSiHzw8dsOhSxwXJXoiVPkipY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712656153; c=relaxed/simple;
	bh=bVjFJB/ecwokMGDFoxvj9jHQOPiauqjm5NYvAjOuAU8=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=GaLCVT9F3nWjYmlk+lINMZk5j0+X3RZRHI1614WxVJxJBiIei0OEy8O0i1BM919dG39kC2q3AbdUdezcuJR1wWrD+HD3wSjQKwDMwn+1MRXMuT8FHPj9Kl8dVdjSvbTj2ThmGIQIxQernXNup84v6C3Vlp018VzhFLbk5lUq3WY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.213])
	by gateway (Coremail) with SMTP id _____8AxCLoNDxVmys4kAA--.3518S3;
	Tue, 09 Apr 2024 17:49:01 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.213])
	by localhost.localdomain (Coremail) with SMTP id AQAAf8BxHBMMDxVmrmd2AA--.31444S2;
	Tue, 09 Apr 2024 17:49:00 +0800 (CST)
From: Bibo Mao <maobibo@loongson.cn>
To: Tianrui Zhao <zhaotianrui@loongson.cn>,
	Huacai Chen <chenhuacai@kernel.org>
Cc: WANG Xuerui <kernel@xen0n.name>,
	kvm@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH] LoongArch: KVM: Add mmio trace support
Date: Tue,  9 Apr 2024 17:49:00 +0800
Message-Id: <20240409094900.1118699-1-maobibo@loongson.cn>
X-Mailer: git-send-email 2.39.3
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:AQAAf8BxHBMMDxVmrmd2AA--.31444S2
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
	ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
	nUUI43ZEXa7xR_UUUUUUUUU==

Add mmio trace event support, currently generic mmio events
KVM_TRACE_MMIO_WRITE/xxx_READ/xx_READ_UNSATISFIED are added here.

Also vcpu id field is added for all kvm trace events, since perf
KVM tool parses vcpu id information for kvm entry event.

Signed-off-by: Bibo Mao <maobibo@loongson.cn>
---
 arch/loongarch/kvm/exit.c  |  7 +++++++
 arch/loongarch/kvm/trace.h | 20 ++++++++++++++------
 2 files changed, 21 insertions(+), 6 deletions(-)

diff --git a/arch/loongarch/kvm/exit.c b/arch/loongarch/kvm/exit.c
index ed1d89d53e2e..3c05aade0122 100644
--- a/arch/loongarch/kvm/exit.c
+++ b/arch/loongarch/kvm/exit.c
@@ -9,6 +9,7 @@
 #include <linux/module.h>
 #include <linux/preempt.h>
 #include <linux/vmalloc.h>
+#include <trace/events/kvm.h>
 #include <asm/fpu.h>
 #include <asm/inst.h>
 #include <asm/loongarch.h>
@@ -417,6 +418,8 @@ int kvm_emu_mmio_read(struct kvm_vcpu *vcpu, larch_inst inst)
 		vcpu->arch.io_gpr = rd;
 		run->mmio.is_write = 0;
 		vcpu->mmio_is_write = 0;
+		trace_kvm_mmio(KVM_TRACE_MMIO_READ_UNSATISFIED, run->mmio.len,
+				run->mmio.phys_addr, NULL);
 	} else {
 		kvm_err("Read not supported Inst=0x%08x @%lx BadVaddr:%#lx\n",
 			inst.word, vcpu->arch.pc, vcpu->arch.badv);
@@ -463,6 +466,8 @@ int kvm_complete_mmio_read(struct kvm_vcpu *vcpu, struct kvm_run *run)
 		break;
 	}
 
+	trace_kvm_mmio(KVM_TRACE_MMIO_READ, run->mmio.len,
+			run->mmio.phys_addr, run->mmio.data);
 	return er;
 }
 
@@ -564,6 +569,8 @@ int kvm_emu_mmio_write(struct kvm_vcpu *vcpu, larch_inst inst)
 		run->mmio.is_write = 1;
 		vcpu->mmio_needed = 1;
 		vcpu->mmio_is_write = 1;
+		trace_kvm_mmio(KVM_TRACE_MMIO_WRITE, run->mmio.len,
+				run->mmio.phys_addr, data);
 	} else {
 		vcpu->arch.pc = curr_pc;
 		kvm_err("Write not supported Inst=0x%08x @%lx BadVaddr:%#lx\n",
diff --git a/arch/loongarch/kvm/trace.h b/arch/loongarch/kvm/trace.h
index c2484ad4cffa..1783397b1bc8 100644
--- a/arch/loongarch/kvm/trace.h
+++ b/arch/loongarch/kvm/trace.h
@@ -19,14 +19,16 @@ DECLARE_EVENT_CLASS(kvm_transition,
 	TP_PROTO(struct kvm_vcpu *vcpu),
 	TP_ARGS(vcpu),
 	TP_STRUCT__entry(
+		__field(unsigned int, vcpu_id)
 		__field(unsigned long, pc)
 	),
 
 	TP_fast_assign(
+		__entry->vcpu_id = vcpu->vcpu_id;
 		__entry->pc = vcpu->arch.pc;
 	),
 
-	TP_printk("PC: 0x%08lx", __entry->pc)
+	TP_printk("vcpu %u PC: 0x%08lx", __entry->vcpu_id, __entry->pc)
 );
 
 DEFINE_EVENT(kvm_transition, kvm_enter,
@@ -54,19 +56,22 @@ DECLARE_EVENT_CLASS(kvm_exit,
 	    TP_PROTO(struct kvm_vcpu *vcpu, unsigned int reason),
 	    TP_ARGS(vcpu, reason),
 	    TP_STRUCT__entry(
+			__field(unsigned int, vcpu_id)
 			__field(unsigned long, pc)
 			__field(unsigned int, reason)
 	    ),
 
 	    TP_fast_assign(
+			__entry->vcpu_id = vcpu->vcpu_id;
 			__entry->pc = vcpu->arch.pc;
 			__entry->reason = reason;
 	    ),
 
-	    TP_printk("[%s]PC: 0x%08lx",
-		      __print_symbolic(__entry->reason,
-				       kvm_trace_symbol_exit_types),
-		      __entry->pc)
+	    TP_printk("vcpu %u [%s] PC: 0x%08lx",
+			__entry->vcpu_id,
+			__print_symbolic(__entry->reason,
+				kvm_trace_symbol_exit_types),
+			__entry->pc)
 );
 
 DEFINE_EVENT(kvm_exit, kvm_exit_idle,
@@ -85,14 +90,17 @@ TRACE_EVENT(kvm_exit_gspr,
 	    TP_PROTO(struct kvm_vcpu *vcpu, unsigned int inst_word),
 	    TP_ARGS(vcpu, inst_word),
 	    TP_STRUCT__entry(
+			__field(unsigned int, vcpu_id)
 			__field(unsigned int, inst_word)
 	    ),
 
 	    TP_fast_assign(
+			__entry->vcpu_id = vcpu->vcpu_id;
 			__entry->inst_word = inst_word;
 	    ),
 
-	    TP_printk("Inst word: 0x%08x", __entry->inst_word)
+	    TP_printk("vcpu %u Inst word: 0x%08x", __entry->vcpu_id,
+			__entry->inst_word)
 );
 
 #define KVM_TRACE_AUX_SAVE		0

base-commit: fec50db7033ea478773b159e0e2efb135270e3b7
-- 
2.39.3


