Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D1C3203672
	for <lists+kvm@lfdr.de>; Mon, 22 Jun 2020 14:08:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728153AbgFVMIK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Jun 2020 08:08:10 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:60452 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726889AbgFVMIK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Jun 2020 08:08:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592827688;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=nnx9W/qLm351r2r0o603cG4pwGJORxcYfoZb+ozOfFI=;
        b=WwCCF/Eri/gsYbYfDLqTjrzqZ0LLKPMa4Ffe2VOFbsvgB21jR89FyGJZ1elj7GmEN53obV
        Bxey1e+Xw1sSlkqSxQVZ9B8e62JZxOTgdSa0kQzednDmh0he53Eg8Y11BRGYXzVDyYOnz0
        jwstkgEKKPbxJBnGIizjXGLxN+bkJaY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-260-lzU-v-1EO_-5Rk4xIBq9rg-1; Mon, 22 Jun 2020 08:08:06 -0400
X-MC-Unique: lzU-v-1EO_-5Rk4xIBq9rg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8AB1E18A8221;
        Mon, 22 Jun 2020 12:08:05 +0000 (UTC)
Received: from dell-r430-03.lab.eng.brq.redhat.com (dell-r430-03.lab.eng.brq.redhat.com [10.37.153.18])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 06AD210013D2;
        Mon, 22 Jun 2020 12:08:03 +0000 (UTC)
From:   Igor Mammedov <imammedo@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     pbonzini@redhat.com, sean.j.christopherson@intel.com,
        vkuznets@redhat.com, kvm@vger.kernel.org, wanpengli@tencent.com
Subject: [PATCH] Revert "KVM: LAPIC: Recalculate apic map in batch"
Date:   Mon, 22 Jun 2020 08:08:02 -0400
Message-Id: <20200622120802.376848-1-imammedo@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Guest fails to online hotplugged CPU with error
  smpboot: do_boot_cpu failed(-1) to wakeup CPU#4

It's caused by the fact that kvm_apic_set_state(), which used to call
recalculate_apic_map() unconditionally and pulled hotplugged CPU into
apic map, is updating map conditionally on state change which doesn't
happen in this case and apic map update is skipped.

Also subj commit introduces a race which can make apic map update
events loss, in case one CPU is already in process of updating
apic map and another CPU flags map as dirty asking for another
update. But the first CPU will clear update request set by another
CPU when update in progress is finished.

  CPU1 kvm_recalculate_apic_map()
     .. updating
  CPU2 apic_map_dirty = true
  CPU1 apic_map_dirty = false
  CPU2 kvm_recalculate_apic_map()
         nop due to apic_map_dirty == false

This reverts commit 4abaffce4d25aa41392d2e81835592726d757857.

Signed-off-by: Igor Mammedov <imammedo@redhat.com>
---
 arch/x86/include/asm/kvm_host.h |  1 -
 arch/x86/kvm/lapic.h            |  1 -
 arch/x86/kvm/lapic.c            | 46 +++++++--------------------------
 arch/x86/kvm/x86.c              |  1 -
 4 files changed, 10 insertions(+), 39 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index f8998e97457f..bbf066217c91 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -943,7 +943,6 @@ struct kvm_arch {
 	atomic_t vapics_in_nmi_mode;
 	struct mutex apic_map_lock;
 	struct kvm_apic_map *apic_map;
-	bool apic_map_dirty;
 
 	bool apic_access_page_done;
 	unsigned long apicv_inhibit_reasons;
diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
index 754f29beb83e..7d08ccfb69d0 100644
--- a/arch/x86/kvm/lapic.h
+++ b/arch/x86/kvm/lapic.h
@@ -81,7 +81,6 @@ void kvm_lapic_set_tpr(struct kvm_vcpu *vcpu, unsigned long cr8);
 void kvm_lapic_set_eoi(struct kvm_vcpu *vcpu);
 void kvm_lapic_set_base(struct kvm_vcpu *vcpu, u64 value);
 u64 kvm_lapic_get_base(struct kvm_vcpu *vcpu);
-void kvm_recalculate_apic_map(struct kvm *kvm);
 void kvm_apic_set_version(struct kvm_vcpu *vcpu);
 int kvm_lapic_reg_write(struct kvm_lapic *apic, u32 reg, u32 val);
 int kvm_lapic_reg_read(struct kvm_lapic *apic, u32 offset, int len,
diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 34a7e0533dad..e99d74288b9e 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -169,28 +169,14 @@ static void kvm_apic_map_free(struct rcu_head *rcu)
 	kvfree(map);
 }
 
-void kvm_recalculate_apic_map(struct kvm *kvm)
+static void recalculate_apic_map(struct kvm *kvm)
 {
 	struct kvm_apic_map *new, *old = NULL;
 	struct kvm_vcpu *vcpu;
 	int i;
 	u32 max_id = 255; /* enough space for any xAPIC ID */
 
-	if (!kvm->arch.apic_map_dirty) {
-		/*
-		 * Read kvm->arch.apic_map_dirty before
-		 * kvm->arch.apic_map
-		 */
-		smp_rmb();
-		return;
-	}
-
 	mutex_lock(&kvm->arch.apic_map_lock);
-	if (!kvm->arch.apic_map_dirty) {
-		/* Someone else has updated the map. */
-		mutex_unlock(&kvm->arch.apic_map_lock);
-		return;
-	}
 
 	kvm_for_each_vcpu(i, vcpu, kvm)
 		if (kvm_apic_present(vcpu))
@@ -255,12 +241,6 @@ void kvm_recalculate_apic_map(struct kvm *kvm)
 	old = rcu_dereference_protected(kvm->arch.apic_map,
 			lockdep_is_held(&kvm->arch.apic_map_lock));
 	rcu_assign_pointer(kvm->arch.apic_map, new);
-	/*
-	 * Write kvm->arch.apic_map before
-	 * clearing apic->apic_map_dirty
-	 */
-	smp_wmb();
-	kvm->arch.apic_map_dirty = false;
 	mutex_unlock(&kvm->arch.apic_map_lock);
 
 	if (old)
@@ -282,20 +262,20 @@ static inline void apic_set_spiv(struct kvm_lapic *apic, u32 val)
 		else
 			static_key_slow_inc(&apic_sw_disabled.key);
 
-		apic->vcpu->kvm->arch.apic_map_dirty = true;
+		recalculate_apic_map(apic->vcpu->kvm);
 	}
 }
 
 static inline void kvm_apic_set_xapic_id(struct kvm_lapic *apic, u8 id)
 {
 	kvm_lapic_set_reg(apic, APIC_ID, id << 24);
-	apic->vcpu->kvm->arch.apic_map_dirty = true;
+	recalculate_apic_map(apic->vcpu->kvm);
 }
 
 static inline void kvm_apic_set_ldr(struct kvm_lapic *apic, u32 id)
 {
 	kvm_lapic_set_reg(apic, APIC_LDR, id);
-	apic->vcpu->kvm->arch.apic_map_dirty = true;
+	recalculate_apic_map(apic->vcpu->kvm);
 }
 
 static inline u32 kvm_apic_calc_x2apic_ldr(u32 id)
@@ -311,7 +291,7 @@ static inline void kvm_apic_set_x2apic_id(struct kvm_lapic *apic, u32 id)
 
 	kvm_lapic_set_reg(apic, APIC_ID, id);
 	kvm_lapic_set_reg(apic, APIC_LDR, ldr);
-	apic->vcpu->kvm->arch.apic_map_dirty = true;
+	recalculate_apic_map(apic->vcpu->kvm);
 }
 
 static inline int apic_lvt_enabled(struct kvm_lapic *apic, int lvt_type)
@@ -1976,7 +1956,7 @@ int kvm_lapic_reg_write(struct kvm_lapic *apic, u32 reg, u32 val)
 	case APIC_DFR:
 		if (!apic_x2apic_mode(apic)) {
 			kvm_lapic_set_reg(apic, APIC_DFR, val | 0x0FFFFFFF);
-			apic->vcpu->kvm->arch.apic_map_dirty = true;
+			recalculate_apic_map(apic->vcpu->kvm);
 		} else
 			ret = 1;
 		break;
@@ -2082,8 +2062,6 @@ int kvm_lapic_reg_write(struct kvm_lapic *apic, u32 reg, u32 val)
 		break;
 	}
 
-	kvm_recalculate_apic_map(apic->vcpu->kvm);
-
 	return ret;
 }
 EXPORT_SYMBOL_GPL(kvm_lapic_reg_write);
@@ -2232,7 +2210,7 @@ void kvm_lapic_set_base(struct kvm_vcpu *vcpu, u64 value)
 			static_key_slow_dec_deferred(&apic_hw_disabled);
 		} else {
 			static_key_slow_inc(&apic_hw_disabled.key);
-			vcpu->kvm->arch.apic_map_dirty = true;
+			recalculate_apic_map(vcpu->kvm);
 		}
 	}
 
@@ -2273,7 +2251,6 @@ void kvm_lapic_reset(struct kvm_vcpu *vcpu, bool init_event)
 	if (!apic)
 		return;
 
-	vcpu->kvm->arch.apic_map_dirty = false;
 	/* Stop the timer in case it's a reset to an active apic */
 	hrtimer_cancel(&apic->lapic_timer.timer);
 
@@ -2325,8 +2302,6 @@ void kvm_lapic_reset(struct kvm_vcpu *vcpu, bool init_event)
 
 	vcpu->arch.apic_arb_prio = 0;
 	vcpu->arch.apic_attention = 0;
-
-	kvm_recalculate_apic_map(vcpu->kvm);
 }
 
 /*
@@ -2556,18 +2531,17 @@ int kvm_apic_set_state(struct kvm_vcpu *vcpu, struct kvm_lapic_state *s)
 	struct kvm_lapic *apic = vcpu->arch.apic;
 	int r;
 
+
 	kvm_lapic_set_base(vcpu, vcpu->arch.apic_base);
 	/* set SPIV separately to get count of SW disabled APICs right */
 	apic_set_spiv(apic, *((u32 *)(s->regs + APIC_SPIV)));
 
 	r = kvm_apic_state_fixup(vcpu, s, true);
-	if (r) {
-		kvm_recalculate_apic_map(vcpu->kvm);
+	if (r)
 		return r;
-	}
 	memcpy(vcpu->arch.apic->regs, s->regs, sizeof(*s));
 
-	kvm_recalculate_apic_map(vcpu->kvm);
+	recalculate_apic_map(vcpu->kvm);
 	kvm_apic_set_version(vcpu);
 
 	apic_update_ppr(apic);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 00c88c2f34e4..26055d69aaf6 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -374,7 +374,6 @@ int kvm_set_apic_base(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	}
 
 	kvm_lapic_set_base(vcpu, msr_info->data);
-	kvm_recalculate_apic_map(vcpu->kvm);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(kvm_set_apic_base);
-- 
2.26.2

