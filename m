Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4EDF5F17D6
	for <lists+kvm@lfdr.de>; Sat,  1 Oct 2022 03:02:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233038AbiJABCN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Sep 2022 21:02:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232942AbiJABBG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Sep 2022 21:01:06 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCDCAB14F3
        for <kvm@vger.kernel.org>; Fri, 30 Sep 2022 18:00:05 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id n9-20020a170902d2c900b001782ad97c7aso4214327plc.8
        for <kvm@vger.kernel.org>; Fri, 30 Sep 2022 18:00:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date;
        bh=zK4Jovt37qXFHbFlJBhO5Jau1lhwM5kyjhPyeBb+zxM=;
        b=bQBPOXSXvplAlxFdnxFpTG+zTd/dDqqmFwtaX2mEDQNfR5JfQJO6evuNicPDuus+uM
         /DXorvYQ778zXY84K+4GPabUJX9hYVodbuLHrnFxJodBiRGFY+RqTp9ExIZRH5UE6Axt
         TwMltMYnqPQqemOK3okKCNccGi+wlcgtBYEYL2MJMfl1o5VS7STs0IBd1H9841qh8Yyr
         dFIVW4Y/2pBkxmvxEgNrKyvYrmxySCy96cRPwWhkp5uzZLNIPDxcJFQ3wXFhsTXNme9C
         WfZ8M0J3+7npYGvTwDZxDtvOif99lNvjaWwgcxgeWObUSmhSDXTK8Qj53zzlS1KW8EMF
         iCQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date;
        bh=zK4Jovt37qXFHbFlJBhO5Jau1lhwM5kyjhPyeBb+zxM=;
        b=LMpEEOePXQp1k80SZPYJ/a+vw3N4lgGB2rzs1G4gtG0VLskHyc5bN3mNB80Gjk1hI+
         ZXHyF0LYsr/OYRd6ysApXqybKvQw5le5NVE9l+Z5UTglREUWl8VuYAfC6hJOXPhjjc71
         dtfkY1PVvc3nPe6wGyP8pNnAT3BCaZFcKmU+p466EiE/QAXz+P2bvOVsfNVS+YmF7mEN
         SRFmkHebscTas/M7xhF1axp7lgNjvFplwPOvEXG2BAPlZy2GIHjIvd3eG73pTVVhdEJs
         yYTXkiKqdklfzxHjRX/ZYaDxCQxyEIU1+IJBGN5AG7TsX4j/ZNYVsoHQwpIoUc+XMPnj
         ofxw==
X-Gm-Message-State: ACrzQf3WbT1wA9nyRafFiOmihqWNR4v2wED0rXgXQRu6pvo/XfEuwgUx
        uRN9haq0rVJoR67RSXEMXVouTkFBkvY=
X-Google-Smtp-Source: AMsMyM5Ux1hAYz3UA9Uvu+UD0d4yLnaEUrhhU3gxI44ARyfveGvEK+y7RexFIBSc9bzXkd6EMgoSxUmDrSo=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:2314:b0:546:ce91:89a3 with SMTP id
 h20-20020a056a00231400b00546ce9189a3mr11596003pfh.77.1664585990992; Fri, 30
 Sep 2022 17:59:50 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Sat,  1 Oct 2022 00:59:02 +0000
In-Reply-To: <20221001005915.2041642-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221001005915.2041642-1-seanjc@google.com>
X-Mailer: git-send-email 2.38.0.rc1.362.ged0d419d3c-goog
Message-ID: <20221001005915.2041642-20-seanjc@google.com>
Subject: [PATCH v4 19/32] KVM: x86: Explicitly track all possibilities for
 APIC map's logical modes
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Li RongQing <lirongqing@baidu.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
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
 arch/x86/include/asm/kvm_host.h | 21 +++++++++++---------
 arch/x86/kvm/lapic.c            | 35 +++++++++++++++++++++++++--------
 2 files changed, 39 insertions(+), 17 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 062758135c86..ac28bbfbf0e3 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -962,19 +962,22 @@ struct kvm_arch_memory_slot {
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
index cef8b202490b..9989893fef69 100644
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
 		u16 mask;
 		u32 ldr;
 		u8 xapic_id;
@@ -282,7 +291,8 @@ void kvm_recalculate_apic_map(struct kvm *kvm)
 		if (!apic_x2apic_mode(apic) && !new->phys_map[xapic_id])
 			new->phys_map[xapic_id] = apic;
 
-		if (!kvm_apic_sw_enabled(apic))
+		if (new->logical_mode == KVM_APIC_MODE_MAP_DISABLED ||
+		    !kvm_apic_sw_enabled(apic))
 			continue;
 
 		ldr = kvm_lapic_get_reg(apic, APIC_LDR);
@@ -290,17 +300,26 @@ void kvm_recalculate_apic_map(struct kvm *kvm)
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
 
 		if (mask)
 			cluster[ffs(mask) - 1] = apic;
@@ -953,7 +972,7 @@ static bool kvm_apic_is_broadcast_dest(struct kvm *kvm, struct kvm_lapic **src,
 {
 	if (kvm->arch.x2apic_broadcast_quirk_disabled) {
 		if ((irq->dest_id == APIC_BROADCAST &&
-				map->mode != KVM_APIC_MODE_X2APIC))
+		     map->logical_mode != KVM_APIC_MODE_X2APIC))
 			return true;
 		if (irq->dest_id == X2APIC_BROADCAST)
 			return true;
-- 
2.38.0.rc1.362.ged0d419d3c-goog

