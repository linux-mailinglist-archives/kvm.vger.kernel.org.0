Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D211816BDD5
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2020 10:50:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729142AbgBYJuE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Feb 2020 04:50:04 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:36436 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726587AbgBYJuD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Feb 2020 04:50:03 -0500
Received: by mail-pf1-f195.google.com with SMTP id 185so6906049pfv.3;
        Tue, 25 Feb 2020 01:50:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=NZ4yHFQ9lP+cM+nOunLQzj4li0g3eCjBD+4fTB38jzM=;
        b=MUU/A3WWC2mMDGHZbKnyxWZOq/95Z6EE56lCGemSzBv7FZmR289xvOKqZNx2Ain5lU
         nGqnublll8dd0R0OMxuZowFFDxzJT+QfatuenellnVIWlv/TgS6F6TmRatLTQuMTWGsu
         nkrNp64re1GZyKc9+bXp7U9l866lF/5b6YVQ564UMMpLg+48hSjhdtVsWhv62bAOrNa2
         ohYXFyFS+WFPUZtMkx/5lrlyBzpu/1+kPQE443iBXRPaUzauxQcEO9BnyJR1P6TsQ3j2
         2vPDwrmCBx/pLiW6itWht3UOIur9SPlsNgr6c74jQAkRE4oDrfnpTNxB7rtktfOIkcoF
         iDqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=NZ4yHFQ9lP+cM+nOunLQzj4li0g3eCjBD+4fTB38jzM=;
        b=Btr3OA4Ef6wH0kiETNyhyJ2rIHb5YFyO+e+q9HG9OBgMSA4QqLVXyzEVOcvBgj8ixj
         veCdva3LWUDkH1IDnSBF9KzVuZbU8xWzvah1ik2YewlneaSlgilI4HR+n9ZSrjmqASnR
         m9ZzkYqf5gTMlaIbmvivPeFi+7V62Ep9jH2zHdlWszAzu1qBdu2ETD3g4ETfx+JKCj1e
         siArNP2od00IZ7lvjiYKErzjPeoCQYrnhnTbbN8WW9wCGDwLrYaBUqxQS3BJD8M+l/gt
         RoSrZs0l1rhKvQDI5/Xklb0XQHCih8PzeVD+jV8ongT9XDke14HoEX3XSAOBZS6Smf5j
         zF4A==
X-Gm-Message-State: APjAAAWl3BjlkgMH0gkb6Bpb0M+VufpRRjqoOSAYGjehPqRIZSXjAhJc
        Z6qzflcV5WOguLG2bIwDxRE4qiLNVTc5Ug==
X-Google-Smtp-Source: APXvYqw7nLVUlyrgez7SmzmW676W/mU3+wiQIdKGorhbPW//eBLOC4H+Cd1dTf+sJ1YdDwhInHOe+Q==
X-Received: by 2002:aa7:8815:: with SMTP id c21mr55095413pfo.81.1582624202814;
        Tue, 25 Feb 2020 01:50:02 -0800 (PST)
Received: from kernel.DHCP ([120.244.140.54])
        by smtp.googlemail.com with ESMTPSA id 70sm16224949pfw.140.2020.02.25.01.49.58
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 25 Feb 2020 01:50:02 -0800 (PST)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: [PATCH v2] KVM: LAPIC: Recalculate apic map in batch
Date:   Tue, 25 Feb 2020 17:47:41 +0800
Message-Id: <1582624061-5814-1-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

In the vCPU reset and set APIC_BASE MSR path, the apic map will be recalculated 
several times, each time it will consume 10+ us observed by ftrace in my 
non-overcommit environment since the expensive memory allocate/mutex/rcu etc 
operations. This patch optimizes it by recaluating apic map in batch, I hope 
this can benefit the serverless scenario which can frequently create/destroy 
VMs.

Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
v1 -> v2:
 * add apic_map_dirty to kvm_lapic
 * error condition in kvm_apic_set_state, do recalcuate  unconditionally

 arch/x86/kvm/lapic.c | 29 +++++++++++++++++++----------
 arch/x86/kvm/lapic.h |  2 ++
 arch/x86/kvm/x86.c   |  2 ++
 3 files changed, 23 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index afcd30d..3476dbc 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -164,7 +164,7 @@ static void kvm_apic_map_free(struct rcu_head *rcu)
 	kvfree(map);
 }
 
-static void recalculate_apic_map(struct kvm *kvm)
+void kvm_recalculate_apic_map(struct kvm *kvm)
 {
 	struct kvm_apic_map *new, *old = NULL;
 	struct kvm_vcpu *vcpu;
@@ -197,6 +197,7 @@ static void recalculate_apic_map(struct kvm *kvm)
 		if (!kvm_apic_present(vcpu))
 			continue;
 
+		apic->apic_map_dirty = false;
 		xapic_id = kvm_xapic_id(apic);
 		x2apic_id = kvm_x2apic_id(apic);
 
@@ -257,20 +258,20 @@ static inline void apic_set_spiv(struct kvm_lapic *apic, u32 val)
 		else
 			static_key_slow_inc(&apic_sw_disabled.key);
 
-		recalculate_apic_map(apic->vcpu->kvm);
+		apic->apic_map_dirty = true;
 	}
 }
 
 static inline void kvm_apic_set_xapic_id(struct kvm_lapic *apic, u8 id)
 {
 	kvm_lapic_set_reg(apic, APIC_ID, id << 24);
-	recalculate_apic_map(apic->vcpu->kvm);
+	apic->apic_map_dirty = true;
 }
 
 static inline void kvm_apic_set_ldr(struct kvm_lapic *apic, u32 id)
 {
 	kvm_lapic_set_reg(apic, APIC_LDR, id);
-	recalculate_apic_map(apic->vcpu->kvm);
+	apic->apic_map_dirty = true;
 }
 
 static inline u32 kvm_apic_calc_x2apic_ldr(u32 id)
@@ -286,7 +287,7 @@ static inline void kvm_apic_set_x2apic_id(struct kvm_lapic *apic, u32 id)
 
 	kvm_lapic_set_reg(apic, APIC_ID, id);
 	kvm_lapic_set_reg(apic, APIC_LDR, ldr);
-	recalculate_apic_map(apic->vcpu->kvm);
+	apic->apic_map_dirty = true;
 }
 
 static inline int apic_lvt_enabled(struct kvm_lapic *apic, int lvt_type)
@@ -1912,7 +1913,7 @@ int kvm_lapic_reg_write(struct kvm_lapic *apic, u32 reg, u32 val)
 	case APIC_DFR:
 		if (!apic_x2apic_mode(apic)) {
 			kvm_lapic_set_reg(apic, APIC_DFR, val | 0x0FFFFFFF);
-			recalculate_apic_map(apic->vcpu->kvm);
+			apic->apic_map_dirty = true;
 		} else
 			ret = 1;
 		break;
@@ -2018,6 +2019,9 @@ int kvm_lapic_reg_write(struct kvm_lapic *apic, u32 reg, u32 val)
 		break;
 	}
 
+	if (apic->apic_map_dirty)
+		kvm_recalculate_apic_map(apic->vcpu->kvm);
+
 	return ret;
 }
 EXPORT_SYMBOL_GPL(kvm_lapic_reg_write);
@@ -2166,7 +2170,7 @@ void kvm_lapic_set_base(struct kvm_vcpu *vcpu, u64 value)
 			static_key_slow_dec_deferred(&apic_hw_disabled);
 		} else {
 			static_key_slow_inc(&apic_hw_disabled.key);
-			recalculate_apic_map(vcpu->kvm);
+			apic->apic_map_dirty = true;
 		}
 	}
 
@@ -2207,6 +2211,7 @@ void kvm_lapic_reset(struct kvm_vcpu *vcpu, bool init_event)
 	if (!apic)
 		return;
 
+	apic->apic_map_dirty = false;
 	/* Stop the timer in case it's a reset to an active apic */
 	hrtimer_cancel(&apic->lapic_timer.timer);
 
@@ -2258,6 +2263,9 @@ void kvm_lapic_reset(struct kvm_vcpu *vcpu, bool init_event)
 
 	vcpu->arch.apic_arb_prio = 0;
 	vcpu->arch.apic_attention = 0;
+
+	if (vcpu->arch.apic->apic_map_dirty)
+		kvm_recalculate_apic_map(vcpu->kvm);
 }
 
 /*
@@ -2479,17 +2487,18 @@ int kvm_apic_set_state(struct kvm_vcpu *vcpu, struct kvm_lapic_state *s)
 	struct kvm_lapic *apic = vcpu->arch.apic;
 	int r;
 
-
 	kvm_lapic_set_base(vcpu, vcpu->arch.apic_base);
 	/* set SPIV separately to get count of SW disabled APICs right */
 	apic_set_spiv(apic, *((u32 *)(s->regs + APIC_SPIV)));
 
 	r = kvm_apic_state_fixup(vcpu, s, true);
-	if (r)
+	if (r) {
+		kvm_recalculate_apic_map(vcpu->kvm);
 		return r;
+	}
 	memcpy(vcpu->arch.apic->regs, s->regs, sizeof(*s));
 
-	recalculate_apic_map(vcpu->kvm);
+	kvm_recalculate_apic_map(vcpu->kvm);
 	kvm_apic_set_version(vcpu);
 
 	apic_update_ppr(apic);
diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
index ec6fbfe..ba1156c 100644
--- a/arch/x86/kvm/lapic.h
+++ b/arch/x86/kvm/lapic.h
@@ -47,6 +47,7 @@ struct kvm_lapic {
 	bool sw_enabled;
 	bool irr_pending;
 	bool lvt0_in_nmi_mode;
+	bool apic_map_dirty;
 	/* Number of bits set in ISR. */
 	s16 isr_count;
 	/* The highest vector set in ISR; if -1 - invalid, must scan ISR. */
@@ -78,6 +79,7 @@ void kvm_lapic_set_tpr(struct kvm_vcpu *vcpu, unsigned long cr8);
 void kvm_lapic_set_eoi(struct kvm_vcpu *vcpu);
 void kvm_lapic_set_base(struct kvm_vcpu *vcpu, u64 value);
 u64 kvm_lapic_get_base(struct kvm_vcpu *vcpu);
+void kvm_recalculate_apic_map(struct kvm *kvm);
 void kvm_apic_set_version(struct kvm_vcpu *vcpu);
 int kvm_lapic_reg_write(struct kvm_lapic *apic, u32 reg, u32 val);
 int kvm_lapic_reg_read(struct kvm_lapic *apic, u32 offset, int len,
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 79bc995..2200f99 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -350,6 +350,8 @@ int kvm_set_apic_base(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	}
 
 	kvm_lapic_set_base(vcpu, msr_info->data);
+	if (vcpu->arch.apic->apic_map_dirty)
+		kvm_recalculate_apic_map(vcpu->kvm);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(kvm_set_apic_base);
-- 
2.7.4

