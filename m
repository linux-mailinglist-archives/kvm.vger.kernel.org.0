Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB61C65F8DD
	for <lists+kvm@lfdr.de>; Fri,  6 Jan 2023 02:15:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231964AbjAFBPY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Jan 2023 20:15:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231520AbjAFBOt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Jan 2023 20:14:49 -0500
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5537272D29
        for <kvm@vger.kernel.org>; Thu,  5 Jan 2023 17:13:45 -0800 (PST)
Received: by mail-pj1-x1049.google.com with SMTP id lx15-20020a17090b4b0f00b0022627a15369so3306418pjb.0
        for <kvm@vger.kernel.org>; Thu, 05 Jan 2023 17:13:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=MIpLae0T5AbCbYssh6yL+LWrf7kA0VhnIInAr1jWLwo=;
        b=HMV/ef6O14LeBA3Jy7RqRsvThrAAzkTKxDiHiaZ9sAkaBr0ro37oTgiEwA/2yxIKft
         fHqxeCDK+EmfSK/sNshmtOqXfhoHeJAyZxIFhJaAJBYw9pgZzd1DP/0HMCLppyGxMSOW
         F4wU1IlrC056jJXzE72fMZnJhq4j8jfx6vhBXaYIXY4Y8y2/o9nXuJOg4xdbWcjEjNCg
         +lcCaA6l7jWboOVXvSIeQc2judfhqwsz6MKx3CEwaPmxxGHoWYkloKqro27ynw+3mcqZ
         5P3/uyqw4Yx/HSxK4+ir/2D+TsDg6sA0c4D+JJlYT97htW+lehezmeQLRFwuSwfoHyMb
         HpuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MIpLae0T5AbCbYssh6yL+LWrf7kA0VhnIInAr1jWLwo=;
        b=ApGvALV+nzjcGfS/mChNBVxBU3UIQV1b51m1Pdqin+kobry2jICWogdlbUqBoucvHf
         Q/2nHU7jGKonySiR9vFD3OCtFwAYohO4HZxTKhGKGWNA8mHz+9Hyu/HJxOG/0a7bB6r2
         5zBPPkmBJlJKqnn/7WPHGj9S+es65nlxfq/q55lBGTsoTOYdZVrN9WpkTo5KzfSLerTY
         gVr9tttYF/opRadAxSqr8DqFLKSdrwSvBLGlP995sOde8CTSmnEJ+Hu8dsoQNsbTprXy
         qRpZsY7qufCXxXrWp+HeBHdHdADavpl8QDE9Vw1QhrLloqx8rHUpP+FE2UjnG30TQJdl
         +U6Q==
X-Gm-Message-State: AFqh2kqJVopS6mOsVXPR21J0YreONd3aWu4aBZuCGSh0rXaOh5rTBX3M
        vdOBMz5y5OgHvnfZGg4cDMZrQwlOH9k=
X-Google-Smtp-Source: AMrXdXvvw++u47Qs40R5b1mXS1QCnB2I9NNrgWTFloOJVufaN7u+the61ku5jAGuieiQbdlQ0HAkbXEiW9s=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:e482:b0:186:5a0c:85a2 with SMTP id
 i2-20020a170902e48200b001865a0c85a2mr2799022ple.79.1672967624670; Thu, 05 Jan
 2023 17:13:44 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri,  6 Jan 2023 01:12:51 +0000
In-Reply-To: <20230106011306.85230-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230106011306.85230-1-seanjc@google.com>
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
Message-ID: <20230106011306.85230-19-seanjc@google.com>
Subject: [PATCH v5 18/33] KVM: x86: Explicitly track all possibilities for
 APIC map's logical modes
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Li RongQing <lirongqing@baidu.com>,
        Greg Edwards <gedwards@ddn.com>
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
 arch/x86/include/asm/kvm_host.h | 29 ++++++++++++++++--------
 arch/x86/kvm/lapic.c            | 40 ++++++++++++++++++++++++++-------
 2 files changed, 52 insertions(+), 17 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 1d92c148e799..732421a0ad02 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1022,19 +1022,30 @@ struct kvm_arch_memory_slot {
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
+	/* All local APICs are software disabled. */
+	KVM_APIC_MODE_SW_DISABLED,
+	/* All software enabled local APICs in xAPIC cluster addressing mode. */
+	KVM_APIC_MODE_XAPIC_CLUSTER,
+	/* All software enabled local APICs in xAPIC flat addressing mode. */
+	KVM_APIC_MODE_XAPIC_FLAT,
+	/* All software enabled local APICs in x2APIC mode. */
+	KVM_APIC_MODE_X2APIC,
+	/*
+	 * Optimized map disabled, e.g. not all local APICs in the same logical
+	 * mode, same logical ID assigned to multiple APICs, etc.
+	 */
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
index 2aee712e42bb..2567998b692c 100644
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
@@ -290,17 +300,31 @@ void kvm_recalculate_apic_map(struct kvm *kvm)
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
 
-		if (!kvm_apic_map_get_logical_dest(new, ldr, &cluster, &mask))
+		/*
+		 * To optimize logical mode delivery, all software-enabled APICs must
+		 * be configured for the same mode.
+		 */
+		if (new->logical_mode == KVM_APIC_MODE_SW_DISABLED) {
+			new->logical_mode = logical_mode;
+		} else if (new->logical_mode != logical_mode) {
+			new->logical_mode = KVM_APIC_MODE_MAP_DISABLED;
 			continue;
+		}
+
+		if (WARN_ON_ONCE(!kvm_apic_map_get_logical_dest(new, ldr,
+								&cluster, &mask))) {
+			new->logical_mode = KVM_APIC_MODE_MAP_DISABLED;
+			continue;
+		}
 
 		if (mask)
 			cluster[ffs(mask) - 1] = apic;
@@ -953,7 +977,7 @@ static bool kvm_apic_is_broadcast_dest(struct kvm *kvm, struct kvm_lapic **src,
 {
 	if (kvm->arch.x2apic_broadcast_quirk_disabled) {
 		if ((irq->dest_id == APIC_BROADCAST &&
-				map->mode != KVM_APIC_MODE_X2APIC))
+		     map->logical_mode != KVM_APIC_MODE_X2APIC))
 			return true;
 		if (irq->dest_id == X2APIC_BROADCAST)
 			return true;
-- 
2.39.0.314.g84b9a713c41-goog

