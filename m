Return-Path: <kvm+bounces-8595-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E115E852C4E
	for <lists+kvm@lfdr.de>; Tue, 13 Feb 2024 10:33:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 682561F25545
	for <lists+kvm@lfdr.de>; Tue, 13 Feb 2024 09:33:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E7DD8225CB;
	Tue, 13 Feb 2024 09:33:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="vo8RB2qf"
X-Original-To: kvm@vger.kernel.org
Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D36CB224C6
	for <kvm@vger.kernel.org>; Tue, 13 Feb 2024 09:33:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707816799; cv=none; b=s/lc2nAkXwk9Bo3J/ptznD9GfOzd/CS+kdqy6ngVwpLdyqVOsVPIW9yW98ErVqnZu3cf6tjoKravWz/hO028m5QjMySSYYqf/nAI9Ts0FtKs6+Z0AcUNup1JqgWFj8p3pHwsLWuqwlgLLjdFM7/VFLY672YpfvT2ZCZ5xzN3WQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707816799; c=relaxed/simple;
	bh=bwAh/HjIrt1hqUnlvYVrZwrrMVLgoGSwee3tzVmP50s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OG2muiUO6/q1zmWw9Bii7hocnIxsWn1D5Ucadbe08R4FZ1X9qzXfjuO0+GuMrtgJAZ3DxGj6OeU7J22oa56O03DGWu4gHSjhUTH/a8+cmiRctTKE3jlvrJ/jhSctm5IjnQtPE27F9OI2qSp0K8i0OuEMU2dgBMrqSAxjDElWmNs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=vo8RB2qf; arc=none smtp.client-ip=95.215.58.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1707816794;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cyUnvVECpp/8iTljvXmQPWzrvEO1ZBGnoQKIdU51DBU=;
	b=vo8RB2qfGqEonVTQPePSakr2QqTty/7P7NdKqNQyptvl5bDfkijfU1kXX6vvVTY6dFU+c3
	HogKV3EfdrrPBOPunsoemPi/WzmFuHTnAflQrWwQm5WlW5x/RrSrKna+v5kRUktY0CUQnw
	ARsEvSc++Dh03U+obakDaYrOC/LfaT8=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org,
	Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-kernel@vger.kernel.org,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v2 01/23] KVM: arm64: Add tracepoints + stats for LPI cache effectiveness
Date: Tue, 13 Feb 2024 09:32:38 +0000
Message-ID: <20240213093250.3960069-2-oliver.upton@linux.dev>
In-Reply-To: <20240213093250.3960069-1-oliver.upton@linux.dev>
References: <20240213093250.3960069-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

LPI translation and injection has been shown to have a significant
impact on the performance of VM workloads, so it probably makes sense to
add some signals in this area.

Introduce the concept of a KVM tracepoint that associates with a VM
stat and use it for the LPI translation cache tracepoints. It isn't too
uncommon for a kernel hacker to attach to tracepoints, while at the same
time userspace may open a 'binary stats' FD to peek at the corresponding
VM stats.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/include/asm/kvm_host.h |  3 ++
 arch/arm64/kvm/guest.c            |  5 ++-
 arch/arm64/kvm/vgic/trace.h       | 66 +++++++++++++++++++++++++++++++
 arch/arm64/kvm/vgic/vgic-its.c    | 14 ++++++-
 include/linux/kvm_host.h          |  4 ++
 5 files changed, 89 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 21c57b812569..6f88b76373a5 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -966,6 +966,9 @@ static inline bool __vcpu_write_sys_reg_to_cpu(u64 val, int reg)
 
 struct kvm_vm_stat {
 	struct kvm_vm_stat_generic generic;
+	u64 vgic_its_trans_cache_hit;
+	u64 vgic_its_trans_cache_miss;
+	u64 vgic_its_trans_cache_victim;
 };
 
 struct kvm_vcpu_stat {
diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
index aaf1d4939739..354d67251fc2 100644
--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -30,7 +30,10 @@
 #include "trace.h"
 
 const struct _kvm_stats_desc kvm_vm_stats_desc[] = {
-	KVM_GENERIC_VM_STATS()
+	KVM_GENERIC_VM_STATS(),
+	STATS_DESC_COUNTER(VM, vgic_its_trans_cache_hit),
+	STATS_DESC_COUNTER(VM, vgic_its_trans_cache_miss),
+	STATS_DESC_COUNTER(VM, vgic_its_trans_cache_victim)
 };
 
 const struct kvm_stats_header kvm_vm_stats_header = {
diff --git a/arch/arm64/kvm/vgic/trace.h b/arch/arm64/kvm/vgic/trace.h
index 83c64401a7fc..ff6423f22c91 100644
--- a/arch/arm64/kvm/vgic/trace.h
+++ b/arch/arm64/kvm/vgic/trace.h
@@ -27,6 +27,72 @@ TRACE_EVENT(vgic_update_irq_pending,
 		  __entry->vcpu_id, __entry->irq, __entry->level)
 );
 
+TRACE_EVENT(vgic_its_trans_cache_hit,
+	TP_PROTO(__u64 db_addr, __u32 device_id, __u32 event_id, __u32 intid),
+	TP_ARGS(db_addr, device_id, event_id, intid),
+
+	TP_STRUCT__entry(
+		__field(	__u64,		db_addr		)
+		__field(	__u32,		device_id	)
+		__field(	__u32,		event_id	)
+		__field(	__u32,		intid		)
+	),
+
+	TP_fast_assign(
+		__entry->db_addr	= db_addr;
+		__entry->device_id	= device_id;
+		__entry->event_id	= event_id;
+		__entry->intid		= intid;
+	),
+
+	TP_printk("DB: %016llx, device_id %u, event_id %u, intid %u",
+                  __entry->db_addr, __entry->device_id, __entry->event_id,
+                  __entry->intid)
+);
+
+TRACE_EVENT(vgic_its_trans_cache_miss,
+	TP_PROTO(__u64 db_addr, __u32 device_id, __u32 event_id),
+	TP_ARGS(db_addr, device_id, event_id),
+
+	TP_STRUCT__entry(
+		__field(	__u64,		db_addr		)
+		__field(	__u32,		device_id	)
+		__field(	__u32,		event_id	)
+	),
+
+	TP_fast_assign(
+		__entry->db_addr	= db_addr;
+		__entry->device_id	= device_id;
+		__entry->event_id	= event_id;
+	),
+
+	TP_printk("DB: %016llx, device_id %u, event_id %u",
+                  __entry->db_addr, __entry->device_id, __entry->event_id)
+);
+
+TRACE_EVENT(vgic_its_trans_cache_victim,
+	TP_PROTO(__u64 db_addr, __u32 device_id, __u32 event_id, __u32 intid),
+	TP_ARGS(db_addr, device_id, event_id, intid),
+
+	TP_STRUCT__entry(
+		__field(	__u64,		db_addr		)
+		__field(	__u32,		device_id	)
+		__field(	__u32,		event_id	)
+		__field(	__u32,		intid		)
+	),
+
+	TP_fast_assign(
+		__entry->db_addr	= db_addr;
+		__entry->device_id	= device_id;
+		__entry->event_id	= event_id;
+		__entry->intid		= intid;
+	),
+
+	TP_printk("DB: %016llx, device_id %u, event_id %u, intid %u",
+                  __entry->db_addr, __entry->device_id, __entry->event_id,
+                  __entry->intid)
+);
+
 #endif /* _TRACE_VGIC_H */
 
 #undef TRACE_INCLUDE_PATH
diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
index e2764d0ffa9f..59179268ac2d 100644
--- a/arch/arm64/kvm/vgic/vgic-its.c
+++ b/arch/arm64/kvm/vgic/vgic-its.c
@@ -20,6 +20,7 @@
 #include <asm/kvm_arm.h>
 #include <asm/kvm_mmu.h>
 
+#include "trace.h"
 #include "vgic.h"
 #include "vgic-mmio.h"
 
@@ -636,8 +637,11 @@ static void vgic_its_cache_translation(struct kvm *kvm, struct vgic_its *its,
 	 * to the interrupt, so drop the potential reference on what
 	 * was in the cache, and increment it on the new interrupt.
 	 */
-	if (cte->irq)
+	if (cte->irq) {
+		KVM_VM_TRACE_EVENT(kvm, vgic_its_trans_cache_victim, cte->db,
+				   cte->devid, cte->eventid, cte->irq->intid);
 		__vgic_put_lpi_locked(kvm, cte->irq);
+	}
 
 	vgic_get_irq_kref(irq);
 
@@ -767,8 +771,14 @@ int vgic_its_inject_cached_translation(struct kvm *kvm, struct kvm_msi *msi)
 
 	db = (u64)msi->address_hi << 32 | msi->address_lo;
 	irq = vgic_its_check_cache(kvm, db, msi->devid, msi->data);
-	if (!irq)
+	if (!irq) {
+		KVM_VM_TRACE_EVENT(kvm, vgic_its_trans_cache_miss, db, msi->devid,
+				   msi->data);
 		return -EWOULDBLOCK;
+	}
+
+	KVM_VM_TRACE_EVENT(kvm, vgic_its_trans_cache_hit, db, msi->devid,
+			   msi->data, irq->intid);
 
 	raw_spin_lock_irqsave(&irq->irq_lock, flags);
 	irq->pending_latch = true;
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 7e7fd25b09b3..846b447b6798 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1927,6 +1927,10 @@ struct _kvm_stats_desc {
 			HALT_POLL_HIST_COUNT),				       \
 	STATS_DESC_IBOOLEAN(VCPU_GENERIC, blocking)
 
+#define KVM_VM_TRACE_EVENT(vm, event, ...)					\
+	((vm)->stat.event)++; trace_## event(__VA_ARGS__)
+
+
 extern struct dentry *kvm_debugfs_dir;
 
 ssize_t kvm_stats_read(char *id, const struct kvm_stats_header *header,
-- 
2.43.0.687.g38aa6559b0-goog


