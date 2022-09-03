Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDDA25ABBCD
	for <lists+kvm@lfdr.de>; Sat,  3 Sep 2022 02:33:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230173AbiICAX5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Sep 2022 20:23:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231478AbiICAXd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Sep 2022 20:23:33 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89C73F72D0
        for <kvm@vger.kernel.org>; Fri,  2 Sep 2022 17:23:27 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id bt5-20020a056a00438500b0053b090003b0so1704609pfb.16
        for <kvm@vger.kernel.org>; Fri, 02 Sep 2022 17:23:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date;
        bh=dsW89dfckTQ7U6+iEAzjnMXnoFtieG6da3C1L59fgMo=;
        b=M+li2tgSgjLklpIjOA9VfDwPNm+OKNxfpflwRzPHIRwKx/FgUX/G18HXpTtFxWXJtg
         DsuSNy9p5JpwaF4X1yz/CMs6OOhZV5jNFdhB1X3YXGyMXj/P5rYHPc49uNaKWCqe/pc0
         5dMWxYR1SeJ18Fm5c+lr/ip8+9dbYeqTxU1zN35gj10f5J0JEAJ9203X6Jrs87E1JoAK
         kGdPfPq9wtKlALrTfFcYoQOpiWrfz3O62XPjYSxC/RsbtS+rn4qwxdfz2VOt1H832Wgq
         DEJpp6qfdl89RHXUGuoq2ZuZNfwMKS174uWnm057Nk0JntqGcTTRuCb1+kuX8yaxAbM/
         DCUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date;
        bh=dsW89dfckTQ7U6+iEAzjnMXnoFtieG6da3C1L59fgMo=;
        b=R4VW9cd4xkSfca5p9X3lB3c7npkJC4k/j+0p0mDXaFh1Ph/f6glNSQwWhF2X8FKU2J
         3ysTZ87xASKXa1ufoofnh/4MEoQR31Nhp9YgxvGNgOB5ihhhvxZ0VCGiEg6Q2oNx04Va
         Zwhcc/Sd0SP+IQYPSB4HT9o1Iy7B6OMPqdUHMyAgsiRzxHE0+dJZBW7ogDlgAbI48CaG
         AvNrUG0X46zPuzEcZNCWRIpSFXcMc15BPsVv0oL4+scGjemM1mPBWPgmFX6D6gZKwD6p
         DcXNeUN8jz/cIwdUVtHIFjN+oWDfAE3kn82UUkFYSwvyKjbiVI2hUn/jRAzVA//+70bc
         isOQ==
X-Gm-Message-State: ACgBeo3AVeuelmZCX5NNCLsl/OAvlr/X+b5xravVhXX4Y7I1RMfUFnUB
        oYwY+YAKLR7B4MHWeA5GMqxfTSwoJrc=
X-Google-Smtp-Source: AA6agR4h06+UGnMuEU1Wnc3kO/LfJikOi7PtbuVfPGKo83ROZVVtfae6ZECKmpyETJvdvT4HDAsG7+jOQzk=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:d343:b0:1fd:b437:7ae9 with SMTP id
 i3-20020a17090ad34300b001fdb4377ae9mr7759560pjx.73.1662164606644; Fri, 02 Sep
 2022 17:23:26 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Sat,  3 Sep 2022 00:22:47 +0000
In-Reply-To: <20220903002254.2411750-1-seanjc@google.com>
Mime-Version: 1.0
References: <20220903002254.2411750-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.2.789.g6183377224-goog
Message-ID: <20220903002254.2411750-17-seanjc@google.com>
Subject: [PATCH v2 16/23] KVM: x86: Explicitly track all possibilities for
 APIC map's logical modes
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Li RongQing <lirongqing@baidu.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Track all possibilities for the optimized APIC map's logical modes
instead of overloading the pseudo-bitmap and treating any "unknown" value
as "invalid".

As documented by the now-stale comment above the mode values, the values
did have meaning when the optimized map was originally added.  That
dependent logical was removed by commit e45115b62f9a ("KVM: x86: use
physical LAPIC array for logical x2APIC"), but the obfuscated behavior
and its comment were left behind.

Opportunistically rename "mode" to "logical_mode", partly to make it
clear that the "disabled" case applies only to the logical map, but also
to prove that there is no lurking code that expects "mode" to be a bitmap.

Functionally, this is a glorified nop.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_host.h | 21 ++++++++++--------
 arch/x86/kvm/lapic.c            | 38 ++++++++++++++++++++++++---------
 2 files changed, 40 insertions(+), 19 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 1fd1b66ceeb6..13dadc96d9ac 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -955,19 +955,22 @@ struct kvm_arch_memory_slot {
 };
 
 /*
- * We use as the mode the number of bits allocated in the LDR for the
- * logical processor ID.  It happens that these are all powers of two.
- * This makes it is very easy to detect cases where the APICs are
- * configured for multiple modes; in that case, we cannot use the map and
- * hence cannot use kvm_irq_delivery_to_apic_fast either.
+ * Track the mode of the optimized logical map, as the rules for decoding the
+ * destination vary per mode.  Enabling the optimized logical map requires all
+ * software-enabled local APIs to be in the same mode, each addressable APIC to
+ * be mapped to only one MDA, and each MDA to map to at most one APIC.
  */
-#define KVM_APIC_MODE_XAPIC_CLUSTER          4
-#define KVM_APIC_MODE_XAPIC_FLAT             8
-#define KVM_APIC_MODE_X2APIC                16
+enum kvm_apic_logical_mode {
+	KVM_APIC_MODE_SW_DISABLED,
+	KVM_APIC_MODE_XAPIC_CLUSTER,
+	KVM_APIC_MODE_XAPIC_FLAT,
+	KVM_APIC_MODE_X2APIC,
+	KVM_APIC_MODE_MAP_DISABLED,
+};
 
 struct kvm_apic_map {
 	struct rcu_head rcu;
-	u8 mode;
+	enum kvm_apic_logical_mode logical_mode;
 	u32 max_apic_id;
 	union {
 		struct kvm_lapic *xapic_flat_map[8];
diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 80528d86f010..407e933eb073 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -168,7 +168,12 @@ static bool kvm_use_posted_timer_interrupt(struct kvm_vcpu *vcpu)
 
 static inline bool kvm_apic_map_get_logical_dest(struct kvm_apic_map *map,
 		u32 dest_id, struct kvm_lapic ***cluster, u16 *mask) {
-	switch (map->mode) {
+	switch (map->logical_mode) {
+	case KVM_APIC_MODE_SW_DISABLED:
+		/* Arbitrarily use the flat map so that @cluster isn't NULL. */
+		*cluster = map->xapic_flat_map;
+		*mask = 0;
+		return true;
 	case KVM_APIC_MODE_X2APIC: {
 		u32 offset = (dest_id >> 16) * 16;
 		u32 max_apic_id = map->max_apic_id;
@@ -193,8 +198,10 @@ static inline bool kvm_apic_map_get_logical_dest(struct kvm_apic_map *map,
 		*cluster = map->xapic_cluster_map[(dest_id >> 4) & 0xf];
 		*mask = dest_id & 0xf;
 		return true;
+	case KVM_APIC_MODE_MAP_DISABLED:
+		return false;
 	default:
-		/* Not optimized. */
+		WARN_ON_ONCE(1);
 		return false;
 	}
 }
@@ -256,10 +263,12 @@ void kvm_recalculate_apic_map(struct kvm *kvm)
 		goto out;
 
 	new->max_apic_id = max_id;
+	new->logical_mode = KVM_APIC_MODE_SW_DISABLED;
 
 	kvm_for_each_vcpu(i, vcpu, kvm) {
 		struct kvm_lapic *apic = vcpu->arch.apic;
 		struct kvm_lapic **cluster;
+		enum kvm_apic_logical_mode logical_mode;
 		u32 x2apic_id, physical_id;
 		u16 mask;
 		u32 ldr;
@@ -314,7 +323,8 @@ void kvm_recalculate_apic_map(struct kvm *kvm)
 			new->phys_map[physical_id] = apic;
 		}
 
-		if (!kvm_apic_sw_enabled(apic))
+		if (new->logical_mode == KVM_APIC_MODE_MAP_DISABLED ||
+		    !kvm_apic_sw_enabled(apic))
 			continue;
 
 		ldr = kvm_lapic_get_reg(apic, APIC_LDR);
@@ -322,25 +332,33 @@ void kvm_recalculate_apic_map(struct kvm *kvm)
 			continue;
 
 		if (apic_x2apic_mode(apic)) {
-			new->mode |= KVM_APIC_MODE_X2APIC;
+			logical_mode = KVM_APIC_MODE_X2APIC;
 		} else {
 			ldr = GET_APIC_LOGICAL_ID(ldr);
 			if (kvm_lapic_get_reg(apic, APIC_DFR) == APIC_DFR_FLAT)
-				new->mode |= KVM_APIC_MODE_XAPIC_FLAT;
+				logical_mode = KVM_APIC_MODE_XAPIC_FLAT;
 			else
-				new->mode |= KVM_APIC_MODE_XAPIC_CLUSTER;
+				logical_mode = KVM_APIC_MODE_XAPIC_CLUSTER;
 		}
+		if (new->logical_mode != KVM_APIC_MODE_SW_DISABLED &&
+		    new->logical_mode != logical_mode) {
+			new->logical_mode = KVM_APIC_MODE_MAP_DISABLED;
+			continue;
+		}
+		new->logical_mode = logical_mode;
 
-		if (!kvm_apic_map_get_logical_dest(new, ldr, &cluster, &mask))
+		if (WARN_ON_ONCE(!kvm_apic_map_get_logical_dest(new, ldr,
+								&cluster, &mask))) {
+			new->logical_mode = KVM_APIC_MODE_MAP_DISABLED;
 			continue;
+		}
 
 		if (!mask)
 			continue;
 
 		ldr = ffs(mask) - 1;
 		if (!is_power_of_2(mask) || cluster[ldr]) {
-			new->mode = KVM_APIC_MODE_XAPIC_FLAT |
-				    KVM_APIC_MODE_XAPIC_CLUSTER;
+			new->logical_mode = KVM_APIC_MODE_MAP_DISABLED;
 			continue;
 		}
 		cluster[ldr] = apic;
@@ -993,7 +1011,7 @@ static bool kvm_apic_is_broadcast_dest(struct kvm *kvm, struct kvm_lapic **src,
 {
 	if (kvm->arch.x2apic_broadcast_quirk_disabled) {
 		if ((irq->dest_id == APIC_BROADCAST &&
-				map->mode != KVM_APIC_MODE_X2APIC))
+		     map->logical_mode != KVM_APIC_MODE_X2APIC))
 			return true;
 		if (irq->dest_id == X2APIC_BROADCAST)
 			return true;
-- 
2.37.2.789.g6183377224-goog

