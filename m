Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90E5A5ABBB6
	for <lists+kvm@lfdr.de>; Sat,  3 Sep 2022 02:33:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231699AbiICAXx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Sep 2022 20:23:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231444AbiICAX2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Sep 2022 20:23:28 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24ED9F63F4
        for <kvm@vger.kernel.org>; Fri,  2 Sep 2022 17:23:24 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id s3-20020a17090a5d0300b001fb3ac54a03so1690995pji.2
        for <kvm@vger.kernel.org>; Fri, 02 Sep 2022 17:23:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date;
        bh=PvUdDgcJt2n+rsBljDkGNrBoyU4Rfeywa67YYhOs2Os=;
        b=hp9UsSaSUQW6/lS6OEq+lgoNM/OAL7afsdN/wWTzCsgzlK076VC8AFsMhM6/hFneDU
         ztVGZp1AZH4Co9RVgIHkAvQLvWUth/LCfTEBMDyOVqin9kYRLyuANehjIZ536rFUw4eN
         cgoRNLUtbm8gplTkPvzNcL6PSsJ3qGQhSaJx3vywyL/8uB1qZToCbGGAUsh9xLkK5Vx1
         8kw7m+THQnb/knMpULq3URVZT8S8y+94k3f8XzE7BnOWUgyh4d/YOr2Kicwv69r2pO4A
         Muac4bWq62mNQ9BzKAM3d2mG82E+8zv/VgFy15BCJN5cMHirlAc76BZKGWL1G5GmnL19
         KUBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date;
        bh=PvUdDgcJt2n+rsBljDkGNrBoyU4Rfeywa67YYhOs2Os=;
        b=VAU7FAtbVeTZFpY+II4qf30yxVEn9fSr+F3sq9S7GEk9+IyzDBjZIOXYnCL9nsoHFM
         cDgelemGFB2A6ZRrOjGkjJuVNhxsK9vTuhGbCK55d8mcRwFH1vfOooE4Y6YdDBPc555k
         FKjwiYFv5H9vQMo+VDdzPD94vGOPoGlaxqxu+m/7RI2br4q+D8IwjK0Eap5F9ZAsft9S
         ziR5tDJcIzZGUfAPLe9qGkVMnFsW1gUl3DCSQw/0iumOf/H4vKWROo56GzPkat6X+/XH
         P8kuWw8W29ug6AE1U0+TJRl1gtZldgr6+vxc9EwBi9gvXC5XbnGWP2Z5aLqMlJ5Kr/oK
         30Uw==
X-Gm-Message-State: ACgBeo2wC+U5e13qYqkGURsHVQRJeamKHkWg95x0fPDrPmlrUR07eiAW
        HS8+LIL0R3bO2uvCnLtps5pXP8Ufbb4=
X-Google-Smtp-Source: AA6agR7d9kLZfyjpjnJDkIqPfDKJtru5IjWJBCPmBn2Kv1abPDq9p9t5cjddNhVgcjVy4czww9KyQ/VvxO8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:e7c2:b0:1f5:85ab:938c with SMTP id
 kb2-20020a17090ae7c200b001f585ab938cmr7624680pjb.133.1662164603472; Fri, 02
 Sep 2022 17:23:23 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Sat,  3 Sep 2022 00:22:45 +0000
In-Reply-To: <20220903002254.2411750-1-seanjc@google.com>
Mime-Version: 1.0
References: <20220903002254.2411750-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.2.789.g6183377224-goog
Message-ID: <20220903002254.2411750-15-seanjc@google.com>
Subject: [PATCH v2 14/23] KVM: x86: Honor architectural behavior for aliased
 8-bit APIC IDs
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

Apply KVM's hotplug hack if and only if userspace has enabled 32-bit IDs
for x2APIC.  If 32-bit IDs are not enabled, disable the optimized map to
honor x86 architectural behavior if multiple vCPUs shared a physical APIC
ID.  As called out in the changelog that added the hack, all CPUs whose
(possibly truncated) APIC ID matches the target are supposed to receive
the IPI.

  KVM intentionally differs from real hardware, because real hardware
  (Knights Landing) does just "x2apic_id & 0xff" to decide whether to
  accept the interrupt in xAPIC mode and it can deliver one interrupt to
  more than one physical destination, e.g. 0x123 to 0x123 and 0x23.

Applying the hack even when x2APIC is not fully enabled means KVM doesn't
correctly handle scenarios where the guest has aliased xAPIC IDs across
multiple vCPUs, as only the vCPU with the lowest vCPU ID will receive any
interrupts.  It's extremely unlikely any real world guest aliase APIC IDs,
or even modifies APIC IDs, but KVM's behavior is arbitrary, e.g. the
lowest vCPU ID "wins" regardless of which vCPU is "aliasing" and which
vCPU is "normal".

Furthermore, the hack is _not_ guaranteed to work!  The hack works if and
only if the optimized APIC map is successfully allocated.  If the map
allocation fails (unlikely), KVM will fall back to its unoptimized
behavior, which _does_ honor the architectural behavior.

Pivot on 32-bit x2APIC IDs being enabled as that is required to take
advantage of the hotplug hack (see kvm_apic_state_fixup()), i.e. won't
break existing setups unless they are way, way off in the weeds.

And an entry in KVM's errata to document the hack.  Alternatively, KVM
could provide an actual x2APIC quirk and document the hack that way, but
there's unlikely to ever be a use case for disabling the quirk.  Go the
errata route to avoid having to validate a quirk no one cares about.

Fixes: 5bd5db385b3e ("KVM: x86: allow hotplug of VCPU with APIC ID over 0xff")
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 Documentation/virt/kvm/x86/errata.rst | 11 ++++++
 arch/x86/kvm/lapic.c                  | 50 ++++++++++++++++++++++-----
 2 files changed, 52 insertions(+), 9 deletions(-)

diff --git a/Documentation/virt/kvm/x86/errata.rst b/Documentation/virt/kvm/x86/errata.rst
index 410e0aa63493..49a05f24747b 100644
--- a/Documentation/virt/kvm/x86/errata.rst
+++ b/Documentation/virt/kvm/x86/errata.rst
@@ -37,3 +37,14 @@ Nested virtualization features
 ------------------------------
 
 TBD
+
+x2APIC
+------
+When KVM_X2APIC_API_USE_32BIT_IDS is enabled, KVM activates a hack/quirk that
+allows sending events to a single vCPU using its x2APIC ID even if the target
+vCPU has legacy xAPIC enabled, e.g. to bring up hotplugged vCPUs via INIT-SIPI
+on VMs with > 255 vCPUs.  A side effect of the quirk is that, if multiple vCPUs
+have the same physical APIC ID, KVM will deliver events targeting that APIC ID
+only to the vCPU with the lowest vCPU ID.  If KVM_X2APIC_API_USE_32BIT_IDS is
+not enabled, KVM follows x86 architecture when processing interrupts (all vCPUs
+matching the target APIC ID receive the interrupt).
diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 75748c380ceb..4c5f49c4d4f1 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -260,10 +260,10 @@ void kvm_recalculate_apic_map(struct kvm *kvm)
 	kvm_for_each_vcpu(i, vcpu, kvm) {
 		struct kvm_lapic *apic = vcpu->arch.apic;
 		struct kvm_lapic **cluster;
+		u32 x2apic_id, physical_id;
 		u16 mask;
 		u32 ldr;
 		u8 xapic_id;
-		u32 x2apic_id;
 
 		if (!kvm_apic_present(vcpu))
 			continue;
@@ -271,16 +271,48 @@ void kvm_recalculate_apic_map(struct kvm *kvm)
 		xapic_id = kvm_xapic_id(apic);
 		x2apic_id = kvm_x2apic_id(apic);
 
-		/* Hotplug hack: see kvm_apic_match_physical_addr(), ... */
-		if ((apic_x2apic_mode(apic) || x2apic_id > 0xff) &&
-				x2apic_id <= new->max_apic_id)
-			new->phys_map[x2apic_id] = apic;
 		/*
-		 * ... xAPIC ID of VCPUs with APIC ID > 0xff will wrap-around,
-		 * prevent them from masking VCPUs with APIC ID <= 0xff.
+		 * Apply KVM's hotplug hack if userspace has enable 32-bit APIC
+		 * IDs.  Allow sending events to vCPUs by their x2APIC ID even
+		 * if the target vCPU is in legacy xAPIC mode, and silently
+		 * ignore aliased xAPIC IDs (the x2APIC ID is truncated to 8
+		 * bits, causing IDs > 0xff to wrap and collide).
+		 *
+		 * Honor the architectural (and KVM's non-optimized) behavior
+		 * if userspace has not enabled 32-bit x2APIC IDs.  Each APIC
+		 * is supposed to process messages independently.  If multiple
+		 * vCPUs have the same effective APIC ID, e.g. due to the
+		 * x2APIC wrap or because the guest manually modified its xAPIC
+		 * IDs, events targeting that ID are supposed to be recognized
+		 * by all vCPUs with said ID.
 		 */
-		if (!apic_x2apic_mode(apic) && !new->phys_map[xapic_id])
-			new->phys_map[xapic_id] = apic;
+		if (kvm->arch.x2apic_format) {
+			/* See also kvm_apic_match_physical_addr(). */
+			if ((apic_x2apic_mode(apic) || x2apic_id > 0xff) &&
+			    x2apic_id <= new->max_apic_id)
+				new->phys_map[x2apic_id] = apic;
+
+			if (!apic_x2apic_mode(apic) && !new->phys_map[xapic_id])
+				new->phys_map[xapic_id] = apic;
+		} else {
+			/*
+			 * Disable the optimized map if the physical APIC ID is
+			 * already mapped, i.e. is aliased to multiple vCPUs.
+			 * The optimized map requires a strict 1:1 mapping
+			 * between IDs and vCPUs.
+			 */
+			if (apic_x2apic_mode(apic))
+				physical_id = x2apic_id;
+			else
+				physical_id = xapic_id;
+
+			if (new->phys_map[physical_id]) {
+				kvfree(new);
+				new = NULL;
+				goto out;
+			}
+			new->phys_map[physical_id] = apic;
+		}
 
 		if (!kvm_apic_sw_enabled(apic))
 			continue;
-- 
2.37.2.789.g6183377224-goog

