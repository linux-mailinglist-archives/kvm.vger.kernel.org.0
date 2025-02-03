Return-Path: <kvm+bounces-37137-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 872CDA26105
	for <lists+kvm@lfdr.de>; Mon,  3 Feb 2025 18:11:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0A6AA162E48
	for <lists+kvm@lfdr.de>; Mon,  3 Feb 2025 17:11:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6DB6920E339;
	Mon,  3 Feb 2025 17:10:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="H2/K9V7D"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8965720C489;
	Mon,  3 Feb 2025 17:10:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738602612; cv=none; b=q4oth2+nn7b0cG9g4AgVZItpgauISO3JXKRQu3jqiI/9rsV6iiwVcl9Khexkda2xnjgtj2cW/Z9+fTjN0xQaOxBXBvhc1buNRjvYP1RUfnVe4udeVkaeMttaMYmWM9lpEJXg7tNrffyJ+btEDOVf6Kl2g0jck9Tsfq8zNh9xB9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738602612; c=relaxed/simple;
	bh=FJPqCnT3zToQA72Beqp6zVHNkQtPn4x743KH06vgqPM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FYg42y21FzvHGgoVPIKq+2yxbVIEekPn7nKndpJXvf6Xa+vxjxafwx424jbMYOpIv/dgL5jGBa6O3mtoHD8YXBoVujNUs+v3ZlOcb6lhGPIb3iKCF+W+bDzYWaaXV4wDbX4ELCZBpAwwtIb27i2KVyiJ3hb19FPz1gD2XlodTNI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=H2/K9V7D; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C643C4CED2;
	Mon,  3 Feb 2025 17:10:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738602612;
	bh=FJPqCnT3zToQA72Beqp6zVHNkQtPn4x743KH06vgqPM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H2/K9V7DNY9TWSYpyosLBHd3YD3lB0f3NzN9wMeHjrG3GwrOVRe19fulTlznd258p
	 VoQwk5Doo3wdTTFAB/0k6sPkLPVdxMeKitFC0xTThWTdWFv4GZBxUMafdp38m1tBat
	 NqlTyNm/hyYQ6493k4d8MV9/AwkEsfqnSsNcNoXSYruE+daiPsPf/c/vZ3xy6ssmgt
	 S1yGP02q860k5ipMAbnF2gvGgRy6WGIL7mrxb0V+/F5GSGD0NaoNYUiAg7roLDaDpN
	 nyeEoS3SRhcXJM4kWkCfS0cRK2UwVkXBhIvMePD+NUaTXUfcYupwaEE/nnpSwkhPfy
	 lEAB0Y17gQCtA==
From: "Naveen N Rao (AMD)" <naveen@kernel.org>
To: <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
Cc: Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	Vasant Hegde <vasant.hegde@amd.com>,
	Maxim Levitsky <mlevitsk@redhat.com>,
	Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: [PATCH 3/3] KVM: x86: Decouple APICv activation state from apicv_inhibit_reasons
Date: Mon,  3 Feb 2025 22:33:03 +0530
Message-ID: <405a98c2f21b9fe73eddbc35c80b60d6523db70c.1738595289.git.naveen@kernel.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <cover.1738595289.git.naveen@kernel.org>
References: <cover.1738595289.git.naveen@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

apicv_inhibit_reasons is used to determine if APICv is active, and if
not, the reason(s) why it may be inhibited. In some scenarios, inhibit
reasons can be set and cleared often, resulting in increased contention
on apicv_update_lock used to guard updates to apicv_inhibit_reasons.

In particular, if a guest is using PIT in reinject mode (the default)
and if AVIC is enabled in kvm_amd kernel module, we inhibit AVIC during
kernel PIT creation (APICV_INHIBIT_REASON_PIT_REINJ), resulting in KVM
emulating x2APIC for the guest. In that case, since AVIC is enabled in
the kvm_amd kernel module, KVM additionally inhibits AVIC for requesting
a IRQ window every time it has to inject external interrupts resulting
in a barrage of inhibits being set and cleared. This shows significant
performance degradation compared to AVIC being disabled, due to high
contention on apicv_update_lock.

Though apicv_update_lock is being used to guard updates to
apicv_inhibit_reasons, it is only necessary if the APICv activation
state changes. Introduce a separate boolean, apicv_activated, to track
if APICv is active or not, and limit use of apicv_update_lock for when
APICv is being (de)activated. Convert apicv_inhibit_reasons to an atomic
and use atomic operations to fetch/update it.

Signed-off-by: Naveen N Rao (AMD) <naveen@kernel.org>
---
 arch/x86/include/asm/kvm_host.h |   7 +-
 arch/x86/kvm/x86.c              | 116 +++++++++++++++++---------------
 2 files changed, 63 insertions(+), 60 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index fb93563714c2..bc4fb3c9d54c 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1359,9 +1359,10 @@ struct kvm_arch {
 	bool apic_access_memslot_enabled;
 	bool apic_access_memslot_inhibited;
 
-	/* Protects apicv_inhibit_reasons */
+	bool apicv_activated;
+	/* Protects apicv_activated */
 	struct rw_semaphore apicv_update_lock;
-	unsigned long apicv_inhibit_reasons;
+	atomic_t apicv_inhibit_reasons;
 
 	gpa_t wall_clock;
 
@@ -2183,8 +2184,6 @@ gpa_t kvm_mmu_gva_to_gpa_system(struct kvm_vcpu *vcpu, gva_t gva,
 bool kvm_apicv_activated(struct kvm *kvm);
 bool kvm_vcpu_apicv_activated(struct kvm_vcpu *vcpu);
 void __kvm_vcpu_update_apicv(struct kvm_vcpu *vcpu);
-void __kvm_set_or_clear_apicv_inhibit(struct kvm *kvm,
-				      enum kvm_apicv_inhibit reason, bool set);
 void kvm_set_or_clear_apicv_inhibit(struct kvm *kvm,
 				    enum kvm_apicv_inhibit reason, bool set);
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 11235e91ae90..6c8f9a9d6548 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9917,33 +9917,42 @@ static void kvm_pv_kick_cpu_op(struct kvm *kvm, int apicid)
 
 bool kvm_apicv_activated(struct kvm *kvm)
 {
-	return (READ_ONCE(kvm->arch.apicv_inhibit_reasons) == 0);
+	return READ_ONCE(kvm->arch.apicv_activated);
 }
 EXPORT_SYMBOL_GPL(kvm_apicv_activated);
 
 bool kvm_vcpu_apicv_activated(struct kvm_vcpu *vcpu)
 {
-	ulong vm_reasons = READ_ONCE(vcpu->kvm->arch.apicv_inhibit_reasons);
+	ulong vm_apicv_activated = READ_ONCE(vcpu->kvm->arch.apicv_activated);
 	ulong vcpu_reasons =
 			kvm_x86_call(vcpu_get_apicv_inhibit_reasons)(vcpu);
 
-	return (vm_reasons | vcpu_reasons) == 0;
+	return vm_apicv_activated && vcpu_reasons == 0;
 }
 EXPORT_SYMBOL_GPL(kvm_vcpu_apicv_activated);
 
-static void set_or_clear_apicv_inhibit(unsigned long *inhibits,
-				       enum kvm_apicv_inhibit reason, bool set)
+static unsigned long set_or_clear_apicv_inhibit(atomic_t *inhibits, enum kvm_apicv_inhibit reason,
+						bool set, unsigned long *new_inhibits)
 {
 	const struct trace_print_flags apicv_inhibits[] = { APICV_INHIBIT_REASONS };
+	unsigned long old, new;
 
 	BUILD_BUG_ON(ARRAY_SIZE(apicv_inhibits) != NR_APICV_INHIBIT_REASONS);
 
-	if (set)
-		__set_bit(reason, inhibits);
-	else
-		__clear_bit(reason, inhibits);
+	if (set) {
+		old = new = atomic_fetch_or(BIT(reason), inhibits);
+		__set_bit(reason, &new);
+	} else {
+		old = new = atomic_fetch_andnot(BIT(reason), inhibits);
+		__clear_bit(reason, &new);
+	}
 
-	trace_kvm_apicv_inhibit_changed(reason, set, *inhibits);
+	trace_kvm_apicv_inhibit_changed(reason, set, new);
+
+	if (new_inhibits)
+		*new_inhibits = new;
+
+	return old;
 }
 
 static void kvm_apicv_init(struct kvm *kvm)
@@ -9951,7 +9960,7 @@ static void kvm_apicv_init(struct kvm *kvm)
 	enum kvm_apicv_inhibit reason = enable_apicv ? APICV_INHIBIT_REASON_ABSENT :
 						       APICV_INHIBIT_REASON_DISABLED;
 
-	set_or_clear_apicv_inhibit(&kvm->arch.apicv_inhibit_reasons, reason, true);
+	set_or_clear_apicv_inhibit(&kvm->arch.apicv_inhibit_reasons, reason, true, NULL);
 
 	init_rwsem(&kvm->arch.apicv_update_lock);
 }
@@ -10592,56 +10601,51 @@ static void kvm_vcpu_update_apicv(struct kvm_vcpu *vcpu)
 	__kvm_vcpu_update_apicv(vcpu);
 }
 
-void __kvm_set_or_clear_apicv_inhibit(struct kvm *kvm,
-				      enum kvm_apicv_inhibit reason, bool set)
-{
-	unsigned long old, new;
-
-	lockdep_assert_held_write(&kvm->arch.apicv_update_lock);
-
-	if (!(kvm_x86_ops.required_apicv_inhibits & BIT(reason)))
-		return;
-
-	old = new = kvm->arch.apicv_inhibit_reasons;
-
-	set_or_clear_apicv_inhibit(&new, reason, set);
-
-	if (!!old != !!new) {
-		/*
-		 * Kick all vCPUs before setting apicv_inhibit_reasons to avoid
-		 * false positives in the sanity check WARN in vcpu_enter_guest().
-		 * This task will wait for all vCPUs to ack the kick IRQ before
-		 * updating apicv_inhibit_reasons, and all other vCPUs will
-		 * block on acquiring apicv_update_lock so that vCPUs can't
-		 * redo vcpu_enter_guest() without seeing the new inhibit state.
-		 *
-		 * Note, holding apicv_update_lock and taking it in the read
-		 * side (handling the request) also prevents other vCPUs from
-		 * servicing the request with a stale apicv_inhibit_reasons.
-		 */
-		kvm_make_all_cpus_request(kvm, KVM_REQ_APICV_UPDATE);
-		kvm->arch.apicv_inhibit_reasons = new;
-		if (new) {
-			unsigned long gfn = gpa_to_gfn(APIC_DEFAULT_PHYS_BASE);
-			int idx = srcu_read_lock(&kvm->srcu);
-
-			kvm_zap_gfn_range(kvm, gfn, gfn+1);
-			srcu_read_unlock(&kvm->srcu, idx);
-		}
-	} else {
-		kvm->arch.apicv_inhibit_reasons = new;
-	}
-}
-
 void kvm_set_or_clear_apicv_inhibit(struct kvm *kvm,
 				    enum kvm_apicv_inhibit reason, bool set)
 {
-	if (!enable_apicv)
+	unsigned long old, new;
+
+	if (!enable_apicv || !(kvm_x86_ops.required_apicv_inhibits & BIT(reason)))
 		return;
 
-	down_write(&kvm->arch.apicv_update_lock);
-	__kvm_set_or_clear_apicv_inhibit(kvm, reason, set);
-	up_write(&kvm->arch.apicv_update_lock);
+	old = set_or_clear_apicv_inhibit(&kvm->arch.apicv_inhibit_reasons, reason, set, &new);
+
+	if (!old != !new) {
+		down_write(&kvm->arch.apicv_update_lock);
+
+		/*
+		 * Someone else may have updated the inhibit reason and the flag
+		 * between when we do the update above and take the lock. Confirm
+		 * the state change needed before proceeding.
+		 */
+		new = atomic_read(&kvm->arch.apicv_inhibit_reasons);
+		if (!new != kvm->arch.apicv_activated) {
+			/*
+			 * Kick all vCPUs before setting apicv_activated to avoid false
+			 * positives in the sanity check WARN in vcpu_enter_guest().
+			 * This task will wait for all vCPUs to ack the kick IRQ before
+			 * updating apicv_activated, and all other vCPUs will block on
+			 * acquiring apicv_update_lock so that vCPUs can't redo
+			 * vcpu_enter_guest() without seeing the new inhibit state.
+			 *
+			 * Note, holding apicv_update_lock and taking it in the read side
+			 * (handling the request) also prevents other vCPUs from servicing
+			 * the request with a stale apicv_activated value.
+			 */
+			kvm_make_all_cpus_request(kvm, KVM_REQ_APICV_UPDATE);
+			kvm->arch.apicv_activated = !new;
+			if (new) {
+				unsigned long gfn = gpa_to_gfn(APIC_DEFAULT_PHYS_BASE);
+				int idx = srcu_read_lock(&kvm->srcu);
+
+				kvm_zap_gfn_range(kvm, gfn, gfn+1);
+				srcu_read_unlock(&kvm->srcu, idx);
+			}
+		}
+
+		up_write(&kvm->arch.apicv_update_lock);
+	}
 }
 EXPORT_SYMBOL_GPL(kvm_set_or_clear_apicv_inhibit);
 
-- 
2.48.1


