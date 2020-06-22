Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FE01203A2D
	for <lists+kvm@lfdr.de>; Mon, 22 Jun 2020 17:00:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729439AbgFVPAC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Jun 2020 11:00:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729399AbgFVO75 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Jun 2020 10:59:57 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 407B9C061573;
        Mon, 22 Jun 2020 07:59:57 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id r9so15190105wmh.2;
        Mon, 22 Jun 2020 07:59:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qjSTpOx1f56iFgaO+NU8TyLZb7WbmaX8dzGpT5a8k9c=;
        b=QdC4ageFNjGFqfuJ5zOPmcy0Zek9teeLvjDxiAasLgYKuvtzSjOhecWkqBbc45SJ9W
         VgC46xc3TLSFCXuxzIJc/CTLCt/Vqp1OV+AHKkbsdIUXCK/MnhkGoVfeqJd7111qLDf4
         ZPubLr7Z2ppru/kZd8ZHORwzmTRWUnCbWcT4+9dyn6/oMb6YbK5wOOSQOLENgf5HYGvw
         iN5SYNTaEB3Jzb7+vd4LEffa3YXPgrlydmD9HyibTvpM1kjTZNxOwjV6neUezXy7rh6u
         TQUAy5XENnnGjD3E28ifKViGlJGvXNLQPfjlaKPp4P3hJ6bQl7zLoVULgna/wof1I6Jl
         EhOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=qjSTpOx1f56iFgaO+NU8TyLZb7WbmaX8dzGpT5a8k9c=;
        b=JwXoPQqNtbLWrT0WNiINfzwbnwtXib0LrwwYlPA5MGyflFfX+MFX4vRNcjHgCoj2A6
         FLlz1kAvB2S7afk4DyFDB1A5frRfkyr3S9bAGIAHNXGV1ZgAzTYj22dBtpfBL0vkP9K1
         CwCP0vKGg8Y5UlnYSM7+UUV5UfcujTadKLJXcXvPj+H2OReNW7gXEyBPVlZapoqJtDJy
         J7nbH2VyXLiAOOH2/jhm/kzCXIngsQ5UR0cIwElq/Q1oIuxbIhkiFblR4HTeCkrrQqt+
         FuhFsGS4hFCSpx2GB0pkZTIy8XeWgKnDdIf1Z/d/3sB77MDIuitTuAend68hmzFj2OpN
         n93w==
X-Gm-Message-State: AOAM532QHZ+E3SYFNIUxa6Ata+amqeMs+gDIvQQ9PwP/wQYb8YmMd8Cj
        bZtNBaTN//9qM2V+QNorvSHFxq28srU=
X-Google-Smtp-Source: ABdhPJwA8xXLcqPBJmCRdS3o9ebWim/QBXgcamtIJm1bEpbBLy5MWC1znFH7T51ioAPZ8Enl5lU4ow==
X-Received: by 2002:a7b:c7d2:: with SMTP id z18mr19420099wmk.149.1592837995575;
        Mon, 22 Jun 2020 07:59:55 -0700 (PDT)
Received: from donizetti.redhat.com ([2001:b07:6468:f312:fd64:dd90:5ad5:d2e1])
        by smtp.gmail.com with ESMTPSA id 1sm13135806wmf.0.2020.06.22.07.59.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Jun 2020 07:59:54 -0700 (PDT)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Igor Mammedov <imammedo@redhat.com>
Subject: [PATCH] KVM: LAPIC: ensure APIC map is up to date on concurrent update requests
Date:   Mon, 22 Jun 2020 16:59:53 +0200
Message-Id: <20200622145953.41931-1-pbonzini@redhat.com>
X-Mailer: git-send-email 2.25.4
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The following race can cause lost map update events:

         cpu1                            cpu2

                                apic_map_dirty = true
  ------------------------------------------------------------
                                kvm_recalculate_apic_map:
                                     pass check
                                         mutex_lock(&kvm->arch.apic_map_lock);
                                         if (!kvm->arch.apic_map_dirty)
                                     and in process of updating map
  -------------------------------------------------------------
    other calls to
       apic_map_dirty = true         might be too late for affected cpu
  -------------------------------------------------------------
                                     apic_map_dirty = false
  -------------------------------------------------------------
    kvm_recalculate_apic_map:
    bail out on
      if (!kvm->arch.apic_map_dirty)

To fix it, record the beginning of an update of the APIC map in
apic_map_dirty.  If another APIC map change switches apic_map_dirty
back to DIRTY, kvm_recalculate_apic_map should not make it CLEAN and
let the other caller go through the slow path.

Reported-by: Igor Mammedov <imammedo@redhat.com>
---
 arch/x86/include/asm/kvm_host.h |  2 +-
 arch/x86/kvm/lapic.c            | 45 +++++++++++++++++++--------------
 2 files changed, 27 insertions(+), 20 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 1da5858501ca..d814032a81e7 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -943,7 +943,7 @@ struct kvm_arch {
 	atomic_t vapics_in_nmi_mode;
 	struct mutex apic_map_lock;
 	struct kvm_apic_map *apic_map;
-	bool apic_map_dirty;
+	atomic_t apic_map_dirty;
 
 	bool apic_access_page_done;
 	unsigned long apicv_inhibit_reasons;
diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 34a7e0533dad..ef98f2fd3bbd 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -169,6 +169,18 @@ static void kvm_apic_map_free(struct rcu_head *rcu)
 	kvfree(map);
 }
 
+/*
+ * CLEAN -> DIRTY and UPDATE_IN_PROGRESS -> DIRTY changes happen without a lock.
+ *
+ * DIRTY -> UPDATE_IN_PROGRESS and UPDATE_IN_PROGRESS -> CLEAN happen with
+ * apic_map_lock_held.
+ */
+enum {
+	CLEAN,
+	UPDATE_IN_PROGRESS,
+	DIRTY
+};
+
 void kvm_recalculate_apic_map(struct kvm *kvm)
 {
 	struct kvm_apic_map *new, *old = NULL;
@@ -176,17 +188,13 @@ void kvm_recalculate_apic_map(struct kvm *kvm)
 	int i;
 	u32 max_id = 255; /* enough space for any xAPIC ID */
 
-	if (!kvm->arch.apic_map_dirty) {
-		/*
-		 * Read kvm->arch.apic_map_dirty before
-		 * kvm->arch.apic_map
-		 */
-		smp_rmb();
+	/* Read kvm->arch.apic_map_dirty before kvm->arch.apic_map.  */
+	if (atomic_read_acquire(&kvm->arch.apic_map_dirty) == CLEAN)
 		return;
-	}
 
 	mutex_lock(&kvm->arch.apic_map_lock);
-	if (!kvm->arch.apic_map_dirty) {
+	if (atomic_cmpxchg_acquire(&kvm->arch.apic_map_dirty,
+				   DIRTY, UPDATE_IN_PROGRESS) == CLEAN) {
 		/* Someone else has updated the map. */
 		mutex_unlock(&kvm->arch.apic_map_lock);
 		return;
@@ -256,11 +264,11 @@ void kvm_recalculate_apic_map(struct kvm *kvm)
 			lockdep_is_held(&kvm->arch.apic_map_lock));
 	rcu_assign_pointer(kvm->arch.apic_map, new);
 	/*
-	 * Write kvm->arch.apic_map before
-	 * clearing apic->apic_map_dirty
+	 * Write kvm->arch.apic_map before clearing apic->apic_map_dirty.
+	 * If another update came in, leave it DIRTY.
 	 */
-	smp_wmb();
-	kvm->arch.apic_map_dirty = false;
+	atomic_cmpxchg_release(&kvm->arch.apic_map_dirty,
+			       UPDATE_IN_PROGRESS, CLEAN);
 	mutex_unlock(&kvm->arch.apic_map_lock);
 
 	if (old)
@@ -282,20 +290,20 @@ static inline void apic_set_spiv(struct kvm_lapic *apic, u32 val)
 		else
 			static_key_slow_inc(&apic_sw_disabled.key);
 
-		apic->vcpu->kvm->arch.apic_map_dirty = true;
+		atomic_set(&apic->vcpu->kvm->arch.apic_map_dirty, DIRTY);
 	}
 }
 
 static inline void kvm_apic_set_xapic_id(struct kvm_lapic *apic, u8 id)
 {
 	kvm_lapic_set_reg(apic, APIC_ID, id << 24);
-	apic->vcpu->kvm->arch.apic_map_dirty = true;
+	atomic_set(&apic->vcpu->kvm->arch.apic_map_dirty, DIRTY);
 }
 
 static inline void kvm_apic_set_ldr(struct kvm_lapic *apic, u32 id)
 {
 	kvm_lapic_set_reg(apic, APIC_LDR, id);
-	apic->vcpu->kvm->arch.apic_map_dirty = true;
+	atomic_set(&apic->vcpu->kvm->arch.apic_map_dirty, DIRTY);
 }
 
 static inline u32 kvm_apic_calc_x2apic_ldr(u32 id)
@@ -311,7 +319,7 @@ static inline void kvm_apic_set_x2apic_id(struct kvm_lapic *apic, u32 id)
 
 	kvm_lapic_set_reg(apic, APIC_ID, id);
 	kvm_lapic_set_reg(apic, APIC_LDR, ldr);
-	apic->vcpu->kvm->arch.apic_map_dirty = true;
+	atomic_set(&apic->vcpu->kvm->arch.apic_map_dirty, DIRTY);
 }
 
 static inline int apic_lvt_enabled(struct kvm_lapic *apic, int lvt_type)
@@ -1976,7 +1984,7 @@ int kvm_lapic_reg_write(struct kvm_lapic *apic, u32 reg, u32 val)
 	case APIC_DFR:
 		if (!apic_x2apic_mode(apic)) {
 			kvm_lapic_set_reg(apic, APIC_DFR, val | 0x0FFFFFFF);
-			apic->vcpu->kvm->arch.apic_map_dirty = true;
+			atomic_set(&apic->vcpu->kvm->arch.apic_map_dirty, DIRTY);
 		} else
 			ret = 1;
 		break;
@@ -2232,7 +2240,7 @@ void kvm_lapic_set_base(struct kvm_vcpu *vcpu, u64 value)
 			static_key_slow_dec_deferred(&apic_hw_disabled);
 		} else {
 			static_key_slow_inc(&apic_hw_disabled.key);
-			vcpu->kvm->arch.apic_map_dirty = true;
+			atomic_set(&apic->vcpu->kvm->arch.apic_map_dirty, DIRTY);
 		}
 	}
 
@@ -2273,7 +2281,6 @@ void kvm_lapic_reset(struct kvm_vcpu *vcpu, bool init_event)
 	if (!apic)
 		return;
 
-	vcpu->kvm->arch.apic_map_dirty = false;
 	/* Stop the timer in case it's a reset to an active apic */
 	hrtimer_cancel(&apic->lapic_timer.timer);
 
-- 
2.25.4

