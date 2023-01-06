Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5EC4965F8FC
	for <lists+kvm@lfdr.de>; Fri,  6 Jan 2023 02:18:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233923AbjAFBSO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Jan 2023 20:18:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233429AbjAFBRo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Jan 2023 20:17:44 -0500
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBB596A0DA
        for <kvm@vger.kernel.org>; Thu,  5 Jan 2023 17:14:38 -0800 (PST)
Received: by mail-pf1-x44a.google.com with SMTP id 24-20020aa79118000000b00580476432deso22518pfh.23
        for <kvm@vger.kernel.org>; Thu, 05 Jan 2023 17:14:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=lYOUn7bh0UicjBFjjEdDwT1xATl/+MO6+EoBl3NK56I=;
        b=JFoorMQdp+YgGEAg84gXvng2oRxSc4H5kJAMfboM5Mhb3vLfvIO60QTModIJsKv4jb
         js+UtfEVxx0ljRZ4LROq3D9pzaagrjQu/rIoJrzwTwAsBWtOmbkF4MACp5qDxwmXldZ7
         Hqv5BmP5u4BHn9IfhyH3q4d9HQfLLN3//ceZhVB9phW6GJ12YdFm7CyGMHl2KzWy6ptu
         M8XdaaM/LdUnmDvHKu3UHgWArzMl9mfDM0BHwlNpIRR8SsdCTLRnqJrIhXWtdLM5eYep
         P2BPCDVq6QebSx86cXamSHSU/iG28oHVF4OZNL0BPpndI7AWGTZVH9ZxQTsiMfbC3Gvb
         YTYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lYOUn7bh0UicjBFjjEdDwT1xATl/+MO6+EoBl3NK56I=;
        b=PCJdY0RKq+T8wOSZeIywvHgYjdQ2MOd0K/BHcdruLuOt558n5Ew7qrYO84NJeHR+gI
         5I1wDIELvQ/bXhGkoZWxYe0zmejPU+RYrRuY+5aoN8+SqTYZWGEP8qH15TuJVHmluIxh
         jm2cCIU17N34EXieMRvrjfsEKosTU2TJjr1AzNaoUpYHlcDwmNvP8Z5kslByvRMiXwiM
         YTSK7+3ip69R1P6o7Eo7RH7epLf+trKTANaXzqsBdcqZArhoPDOGtJ5h9VLtHA6OGr/E
         vBQIlL+BWZ8q9GGI9R13sk6VRMJNm2SVIKZdZ+j0FQ25Nl/3MwtNGGk5Rz/gittVdVS3
         iyew==
X-Gm-Message-State: AFqh2koQB7goeKOqVSg3bQIgNqZPTrHHXOZXGM0ZzPswXXvsRDQq0cvw
        Mt27W+Z/frqOHFqvqxDoWSPlybrKMXg=
X-Google-Smtp-Source: AMrXdXs579hiyLgywoJiAnuKEjYjiSIarsQN53OmCJJWSmSEL6W2XsZ2wsa/Ao0YkU5eq+VsM+gVDOsKpWE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:e548:b0:18f:8f1e:992f with SMTP id
 n8-20020a170902e54800b0018f8f1e992fmr3573473plf.64.1672967650383; Thu, 05 Jan
 2023 17:14:10 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri,  6 Jan 2023 01:13:06 +0000
In-Reply-To: <20230106011306.85230-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230106011306.85230-1-seanjc@google.com>
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
Message-ID: <20230106011306.85230-34-seanjc@google.com>
Subject: [PATCH v5 33/33] KVM: x86: Add helpers to recalc physical vs. logical
 optimized APIC maps
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

Move the guts of kvm_recalculate_apic_map()'s main loop to two separate
helpers to handle recalculating the physical and logical pieces of the
optimized map.  Having 100+ lines of code in the for-loop makes it hard
to understand what is being calculated where.

No functional change intended.

Suggested-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/lapic.c | 250 +++++++++++++++++++++++--------------------
 1 file changed, 133 insertions(+), 117 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 856e81a2dc64..669ea125b7e2 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -218,6 +218,134 @@ static void kvm_apic_map_free(struct rcu_head *rcu)
 	kvfree(map);
 }
 
+static int kvm_recalculate_phys_map(struct kvm_apic_map *new,
+				    struct kvm_vcpu *vcpu,
+				    bool *xapic_id_mismatch)
+{
+	struct kvm_lapic *apic = vcpu->arch.apic;
+	u32 x2apic_id = kvm_x2apic_id(apic);
+	u32 xapic_id = kvm_xapic_id(apic);
+	u32 physical_id;
+
+	/*
+	 * Deliberately truncate the vCPU ID when detecting a mismatched APIC
+	 * ID to avoid false positives if the vCPU ID, i.e. x2APIC ID, is a
+	 * 32-bit value.  Any unwanted aliasing due to truncation results will
+	 * be detected below.
+	 */
+	if (!apic_x2apic_mode(apic) && xapic_id != (u8)vcpu->vcpu_id)
+		*xapic_id_mismatch = true;
+
+	/*
+	 * Apply KVM's hotplug hack if userspace has enable 32-bit APIC IDs.
+	 * Allow sending events to vCPUs by their x2APIC ID even if the target
+	 * vCPU is in legacy xAPIC mode, and silently ignore aliased xAPIC IDs
+	 * (the x2APIC ID is truncated to 8 bits, causing IDs > 0xff to wrap
+	 * and collide).
+	 *
+	 * Honor the architectural (and KVM's non-optimized) behavior if
+	 * userspace has not enabled 32-bit x2APIC IDs.  Each APIC is supposed
+	 * to process messages independently.  If multiple vCPUs have the same
+	 * effective APIC ID, e.g. due to the x2APIC wrap or because the guest
+	 * manually modified its xAPIC IDs, events targeting that ID are
+	 * supposed to be recognized by all vCPUs with said ID.
+	 */
+	if (vcpu->kvm->arch.x2apic_format) {
+		/* See also kvm_apic_match_physical_addr(). */
+		if ((apic_x2apic_mode(apic) || x2apic_id > 0xff) &&
+			x2apic_id <= new->max_apic_id)
+			new->phys_map[x2apic_id] = apic;
+
+		if (!apic_x2apic_mode(apic) && !new->phys_map[xapic_id])
+			new->phys_map[xapic_id] = apic;
+	} else {
+		/*
+		 * Disable the optimized map if the physical APIC ID is already
+		 * mapped, i.e. is aliased to multiple vCPUs.  The optimized
+		 * map requires a strict 1:1 mapping between IDs and vCPUs.
+		 */
+		if (apic_x2apic_mode(apic))
+			physical_id = x2apic_id;
+		else
+			physical_id = xapic_id;
+
+		if (new->phys_map[physical_id])
+			return -EINVAL;
+
+		new->phys_map[physical_id] = apic;
+	}
+
+	return 0;
+}
+
+static void kvm_recalculate_logical_map(struct kvm_apic_map *new,
+					struct kvm_vcpu *vcpu)
+{
+	struct kvm_lapic *apic = vcpu->arch.apic;
+	enum kvm_apic_logical_mode logical_mode;
+	struct kvm_lapic **cluster;
+	u16 mask;
+	u32 ldr;
+
+	if (new->logical_mode == KVM_APIC_MODE_MAP_DISABLED)
+		return;
+
+	if (!kvm_apic_sw_enabled(apic))
+		return;
+
+	ldr = kvm_lapic_get_reg(apic, APIC_LDR);
+	if (!ldr)
+		return;
+
+	if (apic_x2apic_mode(apic)) {
+		logical_mode = KVM_APIC_MODE_X2APIC;
+	} else {
+		ldr = GET_APIC_LOGICAL_ID(ldr);
+		if (kvm_lapic_get_reg(apic, APIC_DFR) == APIC_DFR_FLAT)
+			logical_mode = KVM_APIC_MODE_XAPIC_FLAT;
+		else
+			logical_mode = KVM_APIC_MODE_XAPIC_CLUSTER;
+	}
+
+	/*
+	 * To optimize logical mode delivery, all software-enabled APICs must
+	 * be configured for the same mode.
+	 */
+	if (new->logical_mode == KVM_APIC_MODE_SW_DISABLED) {
+		new->logical_mode = logical_mode;
+	} else if (new->logical_mode != logical_mode) {
+		new->logical_mode = KVM_APIC_MODE_MAP_DISABLED;
+		return;
+	}
+
+	/*
+	 * In x2APIC mode, the LDR is read-only and derived directly from the
+	 * x2APIC ID, thus is guaranteed to be addressable.  KVM reuses
+	 * kvm_apic_map.phys_map to optimize logical mode x2APIC interrupts by
+	 * reversing the LDR calculation to get cluster of APICs, i.e. no
+	 * additional work is required.
+	 */
+	if (apic_x2apic_mode(apic)) {
+		WARN_ON_ONCE(ldr != kvm_apic_calc_x2apic_ldr(kvm_x2apic_id(apic)));
+		return;
+	}
+
+	if (WARN_ON_ONCE(!kvm_apic_map_get_logical_dest(new, ldr,
+							&cluster, &mask))) {
+		new->logical_mode = KVM_APIC_MODE_MAP_DISABLED;
+		return;
+	}
+
+	if (!mask)
+		return;
+
+	ldr = ffs(mask) - 1;
+	if (!is_power_of_2(mask) || cluster[ldr])
+		new->logical_mode = KVM_APIC_MODE_MAP_DISABLED;
+	else
+		cluster[ldr] = apic;
+}
+
 /*
  * CLEAN -> DIRTY and UPDATE_IN_PROGRESS -> DIRTY changes happen without a lock.
  *
@@ -272,128 +400,16 @@ void kvm_recalculate_apic_map(struct kvm *kvm)
 	new->logical_mode = KVM_APIC_MODE_SW_DISABLED;
 
 	kvm_for_each_vcpu(i, vcpu, kvm) {
-		struct kvm_lapic *apic = vcpu->arch.apic;
-		struct kvm_lapic **cluster;
-		enum kvm_apic_logical_mode logical_mode;
-		u32 x2apic_id, physical_id;
-		u16 mask;
-		u32 ldr;
-		u8 xapic_id;
-
 		if (!kvm_apic_present(vcpu))
 			continue;
 
-		xapic_id = kvm_xapic_id(apic);
-		x2apic_id = kvm_x2apic_id(apic);
-
-		/*
-		 * Deliberately truncate the vCPU ID when detecting a mismatched
-		 * APIC ID to avoid false positives if the vCPU ID, i.e. x2APIC
-		 * ID, is a 32-bit value.  Any unwanted aliasing due to
-		 * truncation results will be detected below.
-		 */
-		if (!apic_x2apic_mode(apic) && xapic_id != (u8)vcpu->vcpu_id)
-			xapic_id_mismatch = true;
-
-		/*
-		 * Apply KVM's hotplug hack if userspace has enable 32-bit APIC
-		 * IDs.  Allow sending events to vCPUs by their x2APIC ID even
-		 * if the target vCPU is in legacy xAPIC mode, and silently
-		 * ignore aliased xAPIC IDs (the x2APIC ID is truncated to 8
-		 * bits, causing IDs > 0xff to wrap and collide).
-		 *
-		 * Honor the architectural (and KVM's non-optimized) behavior
-		 * if userspace has not enabled 32-bit x2APIC IDs.  Each APIC
-		 * is supposed to process messages independently.  If multiple
-		 * vCPUs have the same effective APIC ID, e.g. due to the
-		 * x2APIC wrap or because the guest manually modified its xAPIC
-		 * IDs, events targeting that ID are supposed to be recognized
-		 * by all vCPUs with said ID.
-		 */
-		if (kvm->arch.x2apic_format) {
-			/* See also kvm_apic_match_physical_addr(). */
-			if ((apic_x2apic_mode(apic) || x2apic_id > 0xff) &&
-			    x2apic_id <= new->max_apic_id)
-				new->phys_map[x2apic_id] = apic;
-
-			if (!apic_x2apic_mode(apic) && !new->phys_map[xapic_id])
-				new->phys_map[xapic_id] = apic;
-		} else {
-			/*
-			 * Disable the optimized map if the physical APIC ID is
-			 * already mapped, i.e. is aliased to multiple vCPUs.
-			 * The optimized map requires a strict 1:1 mapping
-			 * between IDs and vCPUs.
-			 */
-			if (apic_x2apic_mode(apic))
-				physical_id = x2apic_id;
-			else
-				physical_id = xapic_id;
-
-			if (new->phys_map[physical_id]) {
-				kvfree(new);
-				new = NULL;
-				goto out;
-			}
-			new->phys_map[physical_id] = apic;
-		}
-
-		if (new->logical_mode == KVM_APIC_MODE_MAP_DISABLED ||
-		    !kvm_apic_sw_enabled(apic))
-			continue;
-
-		ldr = kvm_lapic_get_reg(apic, APIC_LDR);
-		if (!ldr)
-			continue;
-
-		if (apic_x2apic_mode(apic)) {
-			logical_mode = KVM_APIC_MODE_X2APIC;
-		} else {
-			ldr = GET_APIC_LOGICAL_ID(ldr);
-			if (kvm_lapic_get_reg(apic, APIC_DFR) == APIC_DFR_FLAT)
-				logical_mode = KVM_APIC_MODE_XAPIC_FLAT;
-			else
-				logical_mode = KVM_APIC_MODE_XAPIC_CLUSTER;
+		if (kvm_recalculate_phys_map(new, vcpu, &xapic_id_mismatch)) {
+			kvfree(new);
+			new = NULL;
+			goto out;
 		}
 
-		/*
-		 * To optimize logical mode delivery, all software-enabled APICs must
-		 * be configured for the same mode.
-		 */
-		if (new->logical_mode == KVM_APIC_MODE_SW_DISABLED) {
-			new->logical_mode = logical_mode;
-		} else if (new->logical_mode != logical_mode) {
-			new->logical_mode = KVM_APIC_MODE_MAP_DISABLED;
-			continue;
-		}
-
-		/*
-		 * In x2APIC mode, the LDR is read-only and derived directly
-		 * from the x2APIC ID, thus is guaranteed to be addressable.
-		 * KVM reuses kvm_apic_map.phys_map to optimize logical mode
-		 * x2APIC interrupts by reversing the LDR calculation to get
-		 * cluster of APICs, i.e. no additional work is required.
-		 */
-		if (apic_x2apic_mode(apic)) {
-			WARN_ON_ONCE(ldr != kvm_apic_calc_x2apic_ldr(x2apic_id));
-			continue;
-		}
-
-		if (WARN_ON_ONCE(!kvm_apic_map_get_logical_dest(new, ldr,
-								&cluster, &mask))) {
-			new->logical_mode = KVM_APIC_MODE_MAP_DISABLED;
-			continue;
-		}
-
-		if (!mask)
-			continue;
-
-		ldr = ffs(mask) - 1;
-		if (!is_power_of_2(mask) || cluster[ldr]) {
-			new->logical_mode = KVM_APIC_MODE_MAP_DISABLED;
-			continue;
-		}
-		cluster[ldr] = apic;
+		kvm_recalculate_logical_map(new, vcpu);
 	}
 out:
 	/*
-- 
2.39.0.314.g84b9a713c41-goog

