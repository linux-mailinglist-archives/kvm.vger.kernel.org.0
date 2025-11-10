Return-Path: <kvm+bounces-62477-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 40C2AC44D7A
	for <lists+kvm@lfdr.de>; Mon, 10 Nov 2025 04:34:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DDB2B188BCE7
	for <lists+kvm@lfdr.de>; Mon, 10 Nov 2025 03:34:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C43FF28643C;
	Mon, 10 Nov 2025 03:33:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KDdf6lve"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36F34298CA7
	for <kvm@vger.kernel.org>; Mon, 10 Nov 2025 03:33:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762745587; cv=none; b=Kup9L8q1rbJ/Mr4XVZOtmB2/pomFiy/pxGJk2LgHCG4NP1xoAn/XkpVhQAek9VorzK/vUJzqd+A6/cQwDuTI1gMZFCVxpDV4cVzkiBGVd2P7yLEHTE3xOT58d1ekiG/RM5DSWMxIRKMEfb3Y7/stJY5PohDVAh/tW/mHDG4oREM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762745587; c=relaxed/simple;
	bh=omCSAA7vln4anVLAOIJztO6RTXHY5tp1jYfhHNg3aTo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=djcHHUXnah0wnrH5rJIrTz41rgOZn52Cbsae4Xk+jHRciJ3AkYfs3kBDF5MNnA8smfl4KAJOn8cOIQ6V8cRPMcEr4buBH5UecdbusOSyN5FSBWLuNoOIx3jKtDGvDGf2HBk4qae7MQw3482/3HouztNus2QGWYvNNEktF282X30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KDdf6lve; arc=none smtp.client-ip=209.85.210.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-781ea2cee3fso1957558b3a.0
        for <kvm@vger.kernel.org>; Sun, 09 Nov 2025 19:33:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762745585; x=1763350385; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zI25yvgMgmKpZ+riRGmrC49sBpY1vnEsOnvyePmQqA8=;
        b=KDdf6lve+8t9LvGK810AG7ubqt55Bw17rHuq5hSNgOHSoKqex7Oglk6I0NZ6YAG2Yw
         1BdONmDLG4j3bdE/44CoZgtAldE/GomM7zXzI8RO8mDRQfEqm5I+/oKXOZhVzDJOXT/j
         oREy1XFe/02icdbKzK+lAWqWUWOF2xLOKQTw7nrdA45bSNuS4bS0uSSQQgIRkZvqFdCv
         75Ylsc+h13Ip3GmO5ToRj92QYe15pLn4ZrPwByonZmchBZQ9TZzasrggPjDo6WIzgeRW
         8kYxOSqjhsDsgypyguLoS8etPufxzhPwKr+zONA0QC4SHH3NPEPRFAr7qcIpUhcERaUv
         lrBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762745585; x=1763350385;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=zI25yvgMgmKpZ+riRGmrC49sBpY1vnEsOnvyePmQqA8=;
        b=AUHmU0ZxSgm8KPjgpCKf8Yi5ETTnQQ9Mm5k1aFRqnodMHfn7rEn7u7cyTuwAMSL+UR
         ey1saGG/80WeWhXr2RGGIFpfBi3uqv5y8sd7UFgWpyfzbW2nG9GYDUKJX3SeypYt71cA
         wVXyJzwEyrshRJwXh13NhXMs2ZmGmf+ZVoT9kSRbHBUlK+3c8XAwcxI8edp2QlBVH5zQ
         deVUfkEiAGYluxxPbXBIA6ghKG02Ln/MyuE/x9h0v3BN5Ems8CjFiCyuvryMFvehJAtD
         b4K/+oBNw9Hd7U72DXzM1PdHRfHlCV419J3sBI4QDou+dhwrzEEAxnTjedyAWSHQqZgF
         kcGA==
X-Forwarded-Encrypted: i=1; AJvYcCU0vkU13Aet4mVNmM/OjTDO5L2fnBemFF3uyVFafP5JwRWfImgyy81BqcnD9o0p+8/neMA=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz5sAO8qekZfoVv/NTmxASIHBjXKHNmo2tmlrR74krFbqrsoXXq
	k6RP7bD+3T3sajhmGRwQayw5hOncqfQWdP6R8n5CMRM+fzdNE3ZVurqo92vCjxMtz5dcxA==
X-Gm-Gg: ASbGncsifqZHXPw/nxt8gq+7HuXftcwPMpQDlUrQDvHXqpC9zyNC40qDUoEsbkacfrM
	VLZKngvnXWVmWz4g1gk43dOZL6KGZh5+j0ZKNpBB8EFGSGI/Dv+crm9KUNf+Is9NBSLtldQZ5gW
	g3cmfvHLelL8GoTbqaCT+innqq/6Dv5hMG6JogASUn2UE3cwYmd8Rlh0uAGS8nG7k7pvclMyTC6
	srMu4Fr4GEJtDrViPE3uesiG6o3kPzyUc4eE1R+N9avbychM0G2Lg7slHyV/wklGNgldmbAEN0z
	4Ygi6QOtz+YzJ2QWCZRiYWE08MIQkakfF9Dtua+WkdV71jDj9BUQ1hk9f+3n06JXt80+ZR3+dUY
	lDUfJJ/1g7VZnpwbfggfXzVfLygAG/flXwpHEgbcrupAk3LzF27EOknZJIIuX+bmT/xLMIV2rUc
	wjK2bIMmEA
X-Google-Smtp-Source: AGHT+IFfM6QJhgtxRy0KI76qJOOp5q6ndwJLMeTfKL9VJrg5PQCm1tz8ioZF+ZERw1dgXpiNoCMtDg==
X-Received: by 2002:a05:6a20:7f9f:b0:33d:7c76:5d68 with SMTP id adf61e73a8af0-353a3d59618mr10257486637.46.1762745585408;
        Sun, 09 Nov 2025 19:33:05 -0800 (PST)
Received: from wanpengli.. ([124.93.80.37])
        by smtp.googlemail.com with ESMTPSA id 41be03b00d2f7-ba900fa571esm10913877a12.26.2025.11.09.19.33.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 09 Nov 2025 19:33:05 -0800 (PST)
From: Wanpeng Li <kernellwp@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	Wanpeng Li <wanpengli@tencent.com>
Subject: [PATCH 07/10] KVM: x86: Add IPI tracking infrastructure
Date: Mon, 10 Nov 2025 11:32:28 +0800
Message-ID: <20251110033232.12538-8-kernellwp@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251110033232.12538-1-kernellwp@gmail.com>
References: <20251110033232.12538-1-kernellwp@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Wanpeng Li <wanpengli@tencent.com>

From: Wanpeng Li <wanpengli@tencent.com>

Introduce IPI tracking infrastructure for directed yield optimization.

Add per-vCPU IPI tracking context in kvm_vcpu_arch with
last_ipi_sender/receiver to track IPI communication pairs, pending_ipi
flag to indicate awaiting IPI response, and ipi_time_ns monotonic
timestamp for recency validation.

Add module parameters ipi_tracking_enabled (global toggle, default
true) and ipi_window_ns (recency window, default 50ms).

Add core helper functions: kvm_track_ipi_communication() to record
sender/receiver pairs, kvm_vcpu_is_ipi_receiver() to validate recent
IPI relationship, and kvm_vcpu_clear/reset_ipi_context() for lifecycle
management.

Use lockless READ_ONCE/WRITE_ONCE for minimal overhead. The short time
window prevents stale IPI information from affecting throughput
workloads.

The infrastructure is inert until integrated with interrupt delivery in
subsequent patches.

Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
 arch/x86/include/asm/kvm_host.h |  8 ++++
 arch/x86/kvm/lapic.c            | 65 +++++++++++++++++++++++++++++++++
 arch/x86/kvm/x86.c              |  6 +++
 arch/x86/kvm/x86.h              |  4 ++
 include/linux/kvm_host.h        |  1 +
 virt/kvm/kvm_main.c             |  5 +++
 6 files changed, 89 insertions(+)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 48598d017d6f..b5bdc115ff45 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1052,6 +1052,14 @@ struct kvm_vcpu_arch {
 	int pending_external_vector;
 	int highest_stale_pending_ioapic_eoi;
 
+	/* IPI tracking for directed yield (x86 only) */
+	struct {
+		int last_ipi_sender;    /* vCPU ID of last IPI sender */
+		int last_ipi_receiver;  /* vCPU ID of last IPI receiver */
+		bool pending_ipi;       /* Pending IPI response */
+		u64 ipi_time_ns;        /* Monotonic ns when IPI was sent */
+	} ipi_context;
+
 	/* be preempted when it's in kernel-mode(cpl=0) */
 	bool preempted_in_kernel;
 
diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 0ae7f913d782..98ec2b18b02c 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -75,6 +75,12 @@ module_param(lapic_timer_advance, bool, 0444);
 /* step-by-step approximation to mitigate fluctuation */
 #define LAPIC_TIMER_ADVANCE_ADJUST_STEP 8
 
+/* IPI tracking window and runtime toggle (runtime-adjustable) */
+static bool ipi_tracking_enabled = true;
+static unsigned long ipi_window_ns = 50 * NSEC_PER_MSEC;
+module_param(ipi_tracking_enabled, bool, 0644);
+module_param(ipi_window_ns, ulong, 0644);
+
 static bool __read_mostly vector_hashing_enabled = true;
 module_param_named(vector_hashing, vector_hashing_enabled, bool, 0444);
 
@@ -1113,6 +1119,65 @@ static int kvm_apic_compare_prio(struct kvm_vcpu *vcpu1, struct kvm_vcpu *vcpu2)
 	return vcpu1->arch.apic_arb_prio - vcpu2->arch.apic_arb_prio;
 }
 
+/*
+ * Track IPI communication for directed yield when a unique receiver exists.
+ * This only writes sender/receiver context and timestamp; ignores self-IPI.
+ */
+void kvm_track_ipi_communication(struct kvm_vcpu *sender, struct kvm_vcpu *receiver)
+{
+	if (!sender || !receiver || sender == receiver)
+		return;
+	if (unlikely(!READ_ONCE(ipi_tracking_enabled)))
+		return;
+
+	WRITE_ONCE(sender->arch.ipi_context.last_ipi_receiver, receiver->vcpu_idx);
+	WRITE_ONCE(sender->arch.ipi_context.pending_ipi, true);
+	WRITE_ONCE(sender->arch.ipi_context.ipi_time_ns, ktime_get_mono_fast_ns());
+
+	WRITE_ONCE(receiver->arch.ipi_context.last_ipi_sender, sender->vcpu_idx);
+}
+
+/*
+ * Check if 'receiver' is the recent IPI target of 'sender'.
+ *
+ * Rationale:
+ * - Use a short window to avoid stale IPI inflating boost priority
+ *   on throughput-sensitive workloads.
+ */
+bool kvm_vcpu_is_ipi_receiver(struct kvm_vcpu *sender, struct kvm_vcpu *receiver)
+{
+	u64 then, now;
+
+	if (unlikely(!READ_ONCE(ipi_tracking_enabled)))
+		return false;
+
+	then = READ_ONCE(sender->arch.ipi_context.ipi_time_ns);
+	now = ktime_get_mono_fast_ns();
+	if (READ_ONCE(sender->arch.ipi_context.pending_ipi) &&
+	    READ_ONCE(sender->arch.ipi_context.last_ipi_receiver) ==
+	    receiver->vcpu_idx &&
+	    now - then <= ipi_window_ns)
+		return true;
+
+	return false;
+}
+
+void kvm_vcpu_clear_ipi_context(struct kvm_vcpu *vcpu)
+{
+	WRITE_ONCE(vcpu->arch.ipi_context.pending_ipi, false);
+	WRITE_ONCE(vcpu->arch.ipi_context.last_ipi_sender, -1);
+	WRITE_ONCE(vcpu->arch.ipi_context.last_ipi_receiver, -1);
+}
+
+/*
+ * Reset helper: clear ipi_context and zero ipi_time for hard reset paths.
+ */
+void kvm_vcpu_reset_ipi_context(struct kvm_vcpu *vcpu)
+{
+	kvm_vcpu_clear_ipi_context(vcpu);
+	WRITE_ONCE(vcpu->arch.ipi_context.ipi_time_ns, 0);
+}
+
 /* Return true if the interrupt can be handled by using *bitmap as index mask
  * for valid destinations in *dst array.
  * Return false if kvm_apic_map_get_dest_lapic did nothing useful.
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index b4b5d2d09634..649e016c131f 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -12708,6 +12708,8 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 		goto free_guest_fpu;
 
 	kvm_xen_init_vcpu(vcpu);
+	/* Initialize IPI tracking */
+	kvm_vcpu_reset_ipi_context(vcpu);
 	vcpu_load(vcpu);
 	kvm_vcpu_after_set_cpuid(vcpu);
 	kvm_set_tsc_khz(vcpu, vcpu->kvm->arch.default_tsc_khz);
@@ -12781,6 +12783,8 @@ void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
 	kvm_mmu_destroy(vcpu);
 	srcu_read_unlock(&vcpu->kvm->srcu, idx);
 	free_page((unsigned long)vcpu->arch.pio_data);
+	/* Clear IPI tracking context */
+	kvm_vcpu_reset_ipi_context(vcpu);
 	kvfree(vcpu->arch.cpuid_entries);
 }
 
@@ -12846,6 +12850,8 @@ void kvm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 		kvm_leave_nested(vcpu);
 
 	kvm_lapic_reset(vcpu, init_event);
+	/* Clear IPI tracking context on reset */
+	kvm_vcpu_clear_ipi_context(vcpu);
 
 	WARN_ON_ONCE(is_guest_mode(vcpu) || is_smm(vcpu));
 	vcpu->arch.hflags = 0;
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index f3dc77f006f9..86a10c653eac 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -451,6 +451,10 @@ fastpath_t handle_fastpath_wrmsr(struct kvm_vcpu *vcpu);
 fastpath_t handle_fastpath_wrmsr_imm(struct kvm_vcpu *vcpu, u32 msr, int reg);
 fastpath_t handle_fastpath_hlt(struct kvm_vcpu *vcpu);
 fastpath_t handle_fastpath_invd(struct kvm_vcpu *vcpu);
+void kvm_track_ipi_communication(struct kvm_vcpu *sender,
+				struct kvm_vcpu *receiver);
+void kvm_vcpu_clear_ipi_context(struct kvm_vcpu *vcpu);
+void kvm_vcpu_reset_ipi_context(struct kvm_vcpu *vcpu);
 
 extern struct kvm_caps kvm_caps;
 extern struct kvm_host_values kvm_host;
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 5bd76cf394fa..5ae8327fdf21 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1532,6 +1532,7 @@ static inline void kvm_vcpu_kick(struct kvm_vcpu *vcpu)
 }
 #endif
 
+bool kvm_vcpu_is_ipi_receiver(struct kvm_vcpu *sender, struct kvm_vcpu *receiver);
 int kvm_vcpu_yield_to(struct kvm_vcpu *target);
 void kvm_vcpu_on_spin(struct kvm_vcpu *vcpu, bool yield_to_kernel_mode);
 
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index cde1eddbaa91..495e769c7ddf 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3963,6 +3963,11 @@ bool __weak kvm_arch_dy_has_pending_interrupt(struct kvm_vcpu *vcpu)
 	return false;
 }
 
+bool __weak kvm_vcpu_is_ipi_receiver(struct kvm_vcpu *sender, struct kvm_vcpu *receiver)
+{
+	return false;
+}
+
 void kvm_vcpu_on_spin(struct kvm_vcpu *me, bool yield_to_kernel_mode)
 {
 	int nr_vcpus, start, i, idx, yielded;
-- 
2.43.0


