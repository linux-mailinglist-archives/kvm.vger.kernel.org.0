Return-Path: <kvm+bounces-66300-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 5757DCCE66E
	for <lists+kvm@lfdr.de>; Fri, 19 Dec 2025 04:57:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 6E7C130A9C8C
	for <lists+kvm@lfdr.de>; Fri, 19 Dec 2025 03:54:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A95C229D275;
	Fri, 19 Dec 2025 03:54:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RjyKucZ5"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DB862BDC03
	for <kvm@vger.kernel.org>; Fri, 19 Dec 2025 03:54:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766116446; cv=none; b=TN3G2yicGHvhkY9fD6WELq2G/u6WpgY3rbdjPb39nSmFVNkwArYj84v6O7OfhpjqCWkQg4kv2wKPVKOFYEDOg+R2gZtfuUsa8nGsfWCo0/3YNQQc5DS+AreU9vGyZRcGC8CiZ3TgTZ8TW71cV/ecypiIhDrmyuVopY5VqI5fM+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766116446; c=relaxed/simple;
	bh=sVeNQkwu85XNwFxKvxwdIm3b68K3U61I7sq3MYJ3BoY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q/ejclt6Aj0y81eoTA3/HGMgISBD+aPnbBSw8b5lDFuFmybLKk1h6zUn1mQPHtMavpfnzX90kr2ZleW7TiCUq7ZEWLVWiM5aDHYY5mNt39ua0vwmyOntbzjt/X3TjQ/zbOYsRST8Mbs31q0beDIVIqzHxv/FhXP4d2ki66AMZTo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RjyKucZ5; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2a110548cdeso18318825ad.0
        for <kvm@vger.kernel.org>; Thu, 18 Dec 2025 19:54:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766116443; x=1766721243; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=A9JN/VeY7DZSzpzlV6Lpconwg2zYhw/ALk1DMLwxvu4=;
        b=RjyKucZ5WKB4ZEzUrPPRqiKEPveNjGedCwU+SeB03B716VLe3vzV8SWMu/aGugDARV
         PzAfgmqr+7I6bVDMKyive32TvS34hUoLIuH72MdacS3qvIk+blg2PYXggWtASLckLUIz
         yNRMyUoshMeAJQvUmqcChJdts+vxBZfgScCIdJ7a083lWd7rY7goMB2QlqDode35CcC/
         SE4/4fn7uz9MN8KVxnm78PkaSZbt/za2ao26fZBhBkyhLhTdsGlBAaC0SHNGietll6F0
         ZzlIVUpGXU6HG+AQNQRngO6h7v+A2S2lJfIEMg2j8voe3fxVqJbDt+BOqn8ONeCm94Da
         gizg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766116443; x=1766721243;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=A9JN/VeY7DZSzpzlV6Lpconwg2zYhw/ALk1DMLwxvu4=;
        b=hIbq2R3qujmvx9I9h4VAMqdOnB2TP0m6AI/ZnezayOW+u3oA4aN2NaHzdToFlpWRIH
         +EphpwmqC/drGX+soC7marHCRx9T7EM1WqwuctCavq4hCek75TUf0+OWoa3qg7Qlltdh
         iiZNH9afKEzJhCYAsmWiCOWJIRc4d1/DrOU5NRxtJL+u/e+WyAYskaqU+bjFwwkX81UX
         HCCdSmCOVgibagyBKLiepgg5GsSkQASA/6rMTaj0Q0ohmGzULg9BDwbycclmZyVJaZG7
         /48JtLXzdvWVQc0UsFo4ntEiSD7wkbPZ7BJOjFMA8s4ZraLxUnNb4VOT41aM43WcxHpz
         7Psw==
X-Forwarded-Encrypted: i=1; AJvYcCWvVMVivnMsBz1QXLzuJVBpm2DspYYIYMaJR/DFO4EjH14rPq1w/PRQnQas0ZETOCSlgFs=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxbej3Z893eQjUys1xDz9cKMoLkvHEeDL/AokOqwo6GcwtK/kcY
	lfVmS2GtjV7uqZAgTVVsPzAMA6vH7/Vsmuw6cJA0Vrvt+4naRhoD6NT5
X-Gm-Gg: AY/fxX7CZcG2fMHynGIOqV2qBWUfJ5kblBtqTP81rIsx6/waXvhcBh0um75P42/4QQB
	H0VoCq2DMCPEjlpBeuGWHVXU4Fil59UaDrsZHtHp5TSSCnTW4Xt85AekV/Eta+cEU5FzHPgeBht
	MOlilMth4hr3xWbF8mXEDggDMp9eEesWIGYDidkbY9zo5h6GJK2BoKXqOShZfoaHjzjTkte+xgd
	gmHaP4klPJEqprfIkCFjh3AQOxNeS5HemiNkFocQmEiGLKYeXXIbO7Ts/o+zdzwGxabaZS/SAzT
	CNxlLO/UH9NWCq+HQzMVrUV2QXmOasxm1VtVFddZYIol02mEkOOfOyV3fuDHN9dGnurHdE+vpb5
	Vaz9B4refa20iTYAMXUo409ntX/QI1IukhuIsdJif//slBO7Ttvk2PkqfRqHhbuibknvHN7supf
	C7Aqe4NNg7QCxOTRoOAgmS
X-Google-Smtp-Source: AGHT+IF9f0bhXfHfqC6drh9F1fDq7qKUfvR+6r5Ke7n7dMoyvnUf3088wxma2hCwi2MheKEe1yqRDQ==
X-Received: by 2002:a17:902:c94f:b0:29f:2b9:6cca with SMTP id d9443c01a7336-2a2f293d118mr15012375ad.44.1766116442731;
        Thu, 18 Dec 2025 19:54:02 -0800 (PST)
Received: from wanpengli.. ([175.170.92.22])
        by smtp.googlemail.com with ESMTPSA id d9443c01a7336-2a2f3d4d36esm7368135ad.63.2025.12.18.19.53.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Dec 2025 19:54:02 -0800 (PST)
From: Wanpeng Li <kernellwp@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>
Cc: K Prateek Nayak <kprateek.nayak@amd.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	Wanpeng Li <wanpengli@tencent.com>
Subject: [PATCH v2 6/9] KVM: x86: Add IPI tracking infrastructure
Date: Fri, 19 Dec 2025 11:53:30 +0800
Message-ID: <20251219035334.39790-7-kernellwp@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251219035334.39790-1-kernellwp@gmail.com>
References: <20251219035334.39790-1-kernellwp@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Wanpeng Li <wanpengli@tencent.com>

Add foundational infrastructure for tracking IPI sender/receiver
relationships to improve directed yield candidate selection.

Introduce per-vCPU ipi_context structure containing:
- last_ipi_receiver: vCPU index that received the last IPI from this vCPU
- last_ipi_time_ns: timestamp of the last IPI send
- ipi_pending: flag indicating an unacknowledged IPI
- last_ipi_sender: vCPU index that sent an IPI to this vCPU
- last_ipi_recv_time_ns: timestamp when IPI was received

Add module parameters for runtime control:
- ipi_tracking_enabled (default: true): master switch for IPI tracking
- ipi_window_ns (default: 50ms): recency window for IPI validity

Implement helper functions:
- kvm_ipi_tracking_enabled(): check if tracking is active
- kvm_vcpu_is_ipi_receiver(): determine if a vCPU is a recent IPI target

The infrastructure is inert until integrated with interrupt delivery
in subsequent patches.

v1 -> v2:
- Improve documentation for module parameters explaining the 50ms
  window rationale
- Add kvm_vcpu_is_ipi_receiver() declaration to x86.h header
- Add weak function annotation comment in kvm_host.h

Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
 arch/x86/include/asm/kvm_host.h | 12 ++++++
 arch/x86/kvm/lapic.c            | 76 +++++++++++++++++++++++++++++++++
 arch/x86/kvm/x86.c              |  3 ++
 arch/x86/kvm/x86.h              |  8 ++++
 include/linux/kvm_host.h        |  3 ++
 virt/kvm/kvm_main.c             |  6 +++
 6 files changed, 108 insertions(+)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 5a3bfa293e8b..2464c310f0a2 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1052,6 +1052,18 @@ struct kvm_vcpu_arch {
 	int pending_external_vector;
 	int highest_stale_pending_ioapic_eoi;
 
+	/*
+	 * IPI tracking for directed yield optimization.
+	 * Records sender/receiver relationships when IPIs are delivered
+	 * to enable IPI-aware vCPU scheduling decisions.
+	 */
+	struct {
+		int last_ipi_sender;	/* vCPU index of last IPI sender */
+		int last_ipi_receiver;	/* vCPU index of last IPI receiver */
+		bool pending_ipi;	/* Awaiting IPI response */
+		u64 ipi_time_ns;	/* Timestamp when IPI was sent */
+	} ipi_context;
+
 	/* be preempted when it's in kernel-mode(cpl=0) */
 	bool preempted_in_kernel;
 
diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 1597dd0b0cc6..23f247a3b127 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -75,6 +75,19 @@ module_param(lapic_timer_advance, bool, 0444);
 /* step-by-step approximation to mitigate fluctuation */
 #define LAPIC_TIMER_ADVANCE_ADJUST_STEP 8
 
+/*
+ * IPI tracking for directed yield optimization.
+ * - ipi_tracking_enabled: global toggle (default on)
+ * - ipi_window_ns: recency window for IPI validity (default 50ms)
+ *   The 50ms window is chosen to be long enough to capture IPI response
+ *   patterns while short enough to avoid stale information affecting
+ *   scheduling decisions in throughput-sensitive workloads.
+ */
+static bool ipi_tracking_enabled = true;
+static unsigned long ipi_window_ns = 50 * NSEC_PER_MSEC;
+module_param(ipi_tracking_enabled, bool, 0644);
+module_param(ipi_window_ns, ulong, 0644);
+
 static bool __read_mostly vector_hashing_enabled = true;
 module_param_named(vector_hashing, vector_hashing_enabled, bool, 0444);
 
@@ -1113,6 +1126,69 @@ static int kvm_apic_compare_prio(struct kvm_vcpu *vcpu1, struct kvm_vcpu *vcpu2)
 	return vcpu1->arch.apic_arb_prio - vcpu2->arch.apic_arb_prio;
 }
 
+/*
+ * Track IPI communication for directed yield optimization.
+ * Records sender/receiver relationship when a unicast IPI is delivered.
+ * Only tracks when a unique receiver exists; ignores self-IPI.
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
+/*
+ * Clear IPI context for a vCPU (e.g., on EOI or reset).
+ */
+void kvm_vcpu_clear_ipi_context(struct kvm_vcpu *vcpu)
+{
+	WRITE_ONCE(vcpu->arch.ipi_context.pending_ipi, false);
+	WRITE_ONCE(vcpu->arch.ipi_context.last_ipi_sender, -1);
+	WRITE_ONCE(vcpu->arch.ipi_context.last_ipi_receiver, -1);
+}
+
+/*
+ * Reset IPI context completely (e.g., on vCPU creation/destruction).
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
index 0c6d899d53dd..d4c401ef04ca 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -12728,6 +12728,7 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 		goto free_guest_fpu;
 
 	kvm_xen_init_vcpu(vcpu);
+	kvm_vcpu_reset_ipi_context(vcpu);
 	vcpu_load(vcpu);
 	kvm_vcpu_after_set_cpuid(vcpu);
 	kvm_set_tsc_khz(vcpu, vcpu->kvm->arch.default_tsc_khz);
@@ -12795,6 +12796,7 @@ void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
 	kvm_mmu_destroy(vcpu);
 	srcu_read_unlock(&vcpu->kvm->srcu, idx);
 	free_page((unsigned long)vcpu->arch.pio_data);
+	kvm_vcpu_reset_ipi_context(vcpu);
 	kvfree(vcpu->arch.cpuid_entries);
 }
 
@@ -12871,6 +12873,7 @@ void kvm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 		kvm_leave_nested(vcpu);
 
 	kvm_lapic_reset(vcpu, init_event);
+	kvm_vcpu_clear_ipi_context(vcpu);
 
 	WARN_ON_ONCE(is_guest_mode(vcpu) || is_smm(vcpu));
 	vcpu->arch.hflags = 0;
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index fdab0ad49098..cfc24fb207e0 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -466,6 +466,14 @@ fastpath_t handle_fastpath_wrmsr_imm(struct kvm_vcpu *vcpu, u32 msr, int reg);
 fastpath_t handle_fastpath_hlt(struct kvm_vcpu *vcpu);
 fastpath_t handle_fastpath_invd(struct kvm_vcpu *vcpu);
 
+/* IPI tracking helpers for directed yield */
+void kvm_track_ipi_communication(struct kvm_vcpu *sender,
+				 struct kvm_vcpu *receiver);
+bool kvm_vcpu_is_ipi_receiver(struct kvm_vcpu *sender,
+			      struct kvm_vcpu *receiver);
+void kvm_vcpu_clear_ipi_context(struct kvm_vcpu *vcpu);
+void kvm_vcpu_reset_ipi_context(struct kvm_vcpu *vcpu);
+
 extern struct kvm_caps kvm_caps;
 extern struct kvm_host_values kvm_host;
 
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index d93f75b05ae2..f42315d341b3 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1535,6 +1535,9 @@ static inline void kvm_vcpu_kick(struct kvm_vcpu *vcpu)
 int kvm_vcpu_yield_to(struct kvm_vcpu *target);
 void kvm_vcpu_on_spin(struct kvm_vcpu *vcpu, bool yield_to_kernel_mode);
 
+/* Weak function, overridden by arch/x86/kvm for IPI-aware directed yield */
+bool kvm_vcpu_is_ipi_receiver(struct kvm_vcpu *sender, struct kvm_vcpu *receiver);
+
 void kvm_flush_remote_tlbs(struct kvm *kvm);
 void kvm_flush_remote_tlbs_range(struct kvm *kvm, gfn_t gfn, u64 nr_pages);
 void kvm_flush_remote_tlbs_memslot(struct kvm *kvm,
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 5fcd401a5897..ff771a872c6d 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3964,6 +3964,12 @@ bool __weak kvm_arch_dy_has_pending_interrupt(struct kvm_vcpu *vcpu)
 	return false;
 }
 
+bool __weak kvm_vcpu_is_ipi_receiver(struct kvm_vcpu *sender,
+				     struct kvm_vcpu *receiver)
+{
+	return false;
+}
+
 void kvm_vcpu_on_spin(struct kvm_vcpu *me, bool yield_to_kernel_mode)
 {
 	int nr_vcpus, start, i, idx, yielded;
-- 
2.43.0


