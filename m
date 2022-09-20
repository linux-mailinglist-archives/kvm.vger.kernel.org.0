Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 513755BF135
	for <lists+kvm@lfdr.de>; Wed, 21 Sep 2022 01:32:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231473AbiITXcw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Sep 2022 19:32:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231262AbiITXcJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Sep 2022 19:32:09 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 530BE7285C
        for <kvm@vger.kernel.org>; Tue, 20 Sep 2022 16:32:04 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id pc10-20020a17090b3b8a00b00202be8d81d2so7300707pjb.1
        for <kvm@vger.kernel.org>; Tue, 20 Sep 2022 16:32:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date;
        bh=0DnOm1NQnF4hm1qkEkLlMwUTgosZ5jnSBllcwGj9ntA=;
        b=ceL8V6iuTN2If+GjMd7E4cw5E3mU5rOZz58FfjwrGzQ5uNfCW135h1xlxXDN8dhwMw
         2N1/IEnM0z42IbDG8uclYaGuse0ixWQJzpEcqLmf/SgTuUxIdgQK3r9CFZ08u/cwR+e+
         j1TLdKsQcP0CcuGLd+R3t5SjBPGmtwU3BbopZwFYdqi2bWqEppPfQxohMH4LC+05iMTJ
         +TDlgHTJ+yKK0vI182Nm1403BHgQUExJqbmurUwiLxMKLaXPJJ+oCt3SpxTvmXAlUxna
         WWHlPZp9d48JTyFJ0fFhBg1ahja0msQkz13pl2PDA2v43auqgsI3UvnnUJ4xi34js6KL
         5zLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date;
        bh=0DnOm1NQnF4hm1qkEkLlMwUTgosZ5jnSBllcwGj9ntA=;
        b=5H1UoJw+p6u0ifHaZK3LbEljoP3XX9OPM4siYF5/qyZjtnJ3BiS4N58TvBlJTOcU+V
         G3EM9LYnTjunOPteX3+f4oZNaFTqaiusttNtweeN1QCdIsPmD6uigTfHfuCRZbY3WG47
         BlA/O1siUKbWKeWUGVbej60Dc4OltVlmCrk/dUN6LWuNlvYcsygRnuWHd+S0J7U1dBC9
         MSl96VTsK6gdL6j+qs7/ciVS+TkCfAaHP2ztDN+10Zg8MqXlGuTXhi3ZKwzN2ToQuDsc
         NF4GgFbmjYd/tt3BdQyn88yFYTOC7QARRZlnkHk9hzu4gsegXSvdntK0GLh46iZOKwzu
         i8Jw==
X-Gm-Message-State: ACrzQf1rZCn9nTo0jftSs1e9f7QxfYErDtmiOrwOhAA0oqsRpcM0jtpX
        QmY8nQWYhsA4wI3QtKFjlbRj6WsqfJA=
X-Google-Smtp-Source: AMsMyM4GS77Mx8WQq+RtjB/Ved5Et/xk/5SK5HeCEKuFxFf4ftlw3ChZyu3Kwk0MDW3j1vVGUf9Oln6+ygQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:1d82:b0:541:1ea2:e7e with SMTP id
 z2-20020a056a001d8200b005411ea20e7emr26811472pfw.71.1663716723791; Tue, 20
 Sep 2022 16:32:03 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 20 Sep 2022 23:31:22 +0000
In-Reply-To: <20220920233134.940511-1-seanjc@google.com>
Mime-Version: 1.0
References: <20220920233134.940511-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.3.968.ga6b4b080e4-goog
Message-ID: <20220920233134.940511-17-seanjc@google.com>
Subject: [PATCH v3 16/28] KVM: x86: Explicitly track all possibilities for
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
index 6475c882b359..6570b5d728ef 100644
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
index bf647af50031..84b7a1c1834d 100644
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
2.37.3.968.ga6b4b080e4-goog

