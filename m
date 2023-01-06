Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F111A65F8FA
	for <lists+kvm@lfdr.de>; Fri,  6 Jan 2023 02:18:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232896AbjAFBR7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Jan 2023 20:17:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233770AbjAFBR0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Jan 2023 20:17:26 -0500
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7644755C2
        for <kvm@vger.kernel.org>; Thu,  5 Jan 2023 17:14:35 -0800 (PST)
Received: by mail-pj1-x104a.google.com with SMTP id z4-20020a17090ab10400b002195a146546so2087162pjq.9
        for <kvm@vger.kernel.org>; Thu, 05 Jan 2023 17:14:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=yPL//5YzExDyFBxSbINxOiuXfpNssPuyAQmCUXdDYKM=;
        b=ITnWjyO8T1tXSabcL3f42Ng1M0AJc9npIkp2Q59qXsQHAoNEWBngWKNIEljJYY382P
         LjtIJQ0Gi2WcpaeGsFihuIZREDskbZrPunbY5mFmnDacbZQh63sCnnSS7VGgSSbmF8dd
         xH2lpUiFMQDIADtGR/as+G9a0NeTzCS7ogR5daO6pwh0033NZIzhL/y0Hsi26sJxIUGG
         16tZdGTzB/m6SXpPzljyu/GHbv6GD7dEWFVUTvG4YgHjTR8WwmAxhOdMOYpZ7bzO8jN7
         gEThBdfPXiNp6fgcIBGDUdrZBodxgpm8T3oPtVVOIMIqi2WtPMICCdENwk+xIajOqJUZ
         rNxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yPL//5YzExDyFBxSbINxOiuXfpNssPuyAQmCUXdDYKM=;
        b=I+HEsAxbL920Lw4tUyUsmgyuEMov2Dxm1at/JehbGdfxdwRbymabCw5Klc/PoGInn7
         KHT+YYBshCEdXZqw0UWz3Ro6qI+bjJphjaJi6MFra5dhIQ2Ac47MNd0KxvUY0RFT5kOP
         0xU1oB9lBkrGUwVBJmj4kh4pFObtIturB+3b+sdhjmN0DLXAktOSKapnEXM6aahaxwwd
         Uk6L1/zwh1MKl8z3PpLmgxuXHjTxQyx4lhmiAYCJqrOah9fCueUK9Q2D8H7ZDvQmxdOK
         sGbEv/WIonchsOMU/6xve977hVW0jnSNJDT0idQovg3xMepM+JVpT8SbS8IuI1if5uWy
         CgjQ==
X-Gm-Message-State: AFqh2kr1IAyBmzE7dmOQPz3AgWr/LuZkdadSkZaYoXAkJfuzq60JOalK
        0Rf8A6bP/x3iaxi/leId4x6x+M/wiME=
X-Google-Smtp-Source: AMrXdXtpLq5sL01+xsDb+D2+MNcPpPFQLJXTFTZOGsk4M1JW/fDTbPx8SEolst183Tp7RqWQ4itCWSmKD5c=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:488d:b0:226:9d77:e730 with SMTP id
 b13-20020a17090a488d00b002269d77e730mr827196pjh.198.1672967648544; Thu, 05
 Jan 2023 17:14:08 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri,  6 Jan 2023 01:13:05 +0000
In-Reply-To: <20230106011306.85230-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230106011306.85230-1-seanjc@google.com>
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
Message-ID: <20230106011306.85230-33-seanjc@google.com>
Subject: [PATCH v5 32/33] KVM: x86: Allow APICv APIC ID inhibit to be cleared
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
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Greg Edwards <gedwards@ddn.com>

Legacy kernels prior to commit 4399c03c6780 ("x86/apic: Remove
verify_local_APIC()") write the APIC ID of the boot CPU twice to verify
a functioning local APIC.  This results in APIC acceleration inhibited
on these kernels for reason APICV_INHIBIT_REASON_APIC_ID_MODIFIED.

Allow the APICV_INHIBIT_REASON_APIC_ID_MODIFIED inhibit reason to be
cleared if/when all APICs in xAPIC mode set their APIC ID back to the
expected vcpu_id value.

Fold the functionality previously in kvm_lapic_xapic_id_updated() into
kvm_recalculate_apic_map(), as this allows examining all APICs in one
pass.

Fixes: 3743c2f02517 ("KVM: x86: inhibit APICv/AVIC on changes to APIC ID or APIC base")
Signed-off-by: Greg Edwards <gedwards@ddn.com>
Link: https://lore.kernel.org/r/20221117183247.94314-1-gedwards@ddn.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/lapic.c | 41 +++++++++++++++--------------------------
 1 file changed, 15 insertions(+), 26 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 0faf80cdc1be..856e81a2dc64 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -236,6 +236,7 @@ void kvm_recalculate_apic_map(struct kvm *kvm)
 	struct kvm_vcpu *vcpu;
 	unsigned long i;
 	u32 max_id = 255; /* enough space for any xAPIC ID */
+	bool xapic_id_mismatch = false;
 
 	/* Read kvm->arch.apic_map_dirty before kvm->arch.apic_map.  */
 	if (atomic_read_acquire(&kvm->arch.apic_map_dirty) == CLEAN)
@@ -285,6 +286,15 @@ void kvm_recalculate_apic_map(struct kvm *kvm)
 		xapic_id = kvm_xapic_id(apic);
 		x2apic_id = kvm_x2apic_id(apic);
 
+		/*
+		 * Deliberately truncate the vCPU ID when detecting a mismatched
+		 * APIC ID to avoid false positives if the vCPU ID, i.e. x2APIC
+		 * ID, is a 32-bit value.  Any unwanted aliasing due to
+		 * truncation results will be detected below.
+		 */
+		if (!apic_x2apic_mode(apic) && xapic_id != (u8)vcpu->vcpu_id)
+			xapic_id_mismatch = true;
+
 		/*
 		 * Apply KVM's hotplug hack if userspace has enable 32-bit APIC
 		 * IDs.  Allow sending events to vCPUs by their x2APIC ID even
@@ -401,6 +411,11 @@ void kvm_recalculate_apic_map(struct kvm *kvm)
 	else
 		kvm_clear_apicv_inhibit(kvm, APICV_INHIBIT_REASON_LOGICAL_ID_ALIASED);
 
+	if (xapic_id_mismatch)
+		kvm_set_apicv_inhibit(kvm, APICV_INHIBIT_REASON_APIC_ID_MODIFIED);
+	else
+		kvm_clear_apicv_inhibit(kvm, APICV_INHIBIT_REASON_APIC_ID_MODIFIED);
+
 	old = rcu_dereference_protected(kvm->arch.apic_map,
 			lockdep_is_held(&kvm->arch.apic_map_lock));
 	rcu_assign_pointer(kvm->arch.apic_map, new);
@@ -2160,28 +2175,6 @@ static void apic_manage_nmi_watchdog(struct kvm_lapic *apic, u32 lvt0_val)
 	}
 }
 
-static void kvm_lapic_xapic_id_updated(struct kvm_lapic *apic)
-{
-	struct kvm *kvm = apic->vcpu->kvm;
-
-	if (!kvm_apic_hw_enabled(apic))
-		return;
-
-	if (KVM_BUG_ON(apic_x2apic_mode(apic), kvm))
-		return;
-
-	/*
-	 * Deliberately truncate the vCPU ID when detecting a modified APIC ID
-	 * to avoid false positives if the vCPU ID, i.e. x2APIC ID, is a 32-bit
-	 * value.  If the wrap/truncation results in unwanted aliasing, APICv
-	 * will be inhibited as part of updating KVM's optimized APIC maps.
-	 */
-	if (kvm_xapic_id(apic) == (u8)apic->vcpu->vcpu_id)
-		return;
-
-	kvm_set_apicv_inhibit(apic->vcpu->kvm, APICV_INHIBIT_REASON_APIC_ID_MODIFIED);
-}
-
 static int get_lvt_index(u32 reg)
 {
 	if (reg == APIC_LVTCMCI)
@@ -2202,7 +2195,6 @@ static int kvm_lapic_reg_write(struct kvm_lapic *apic, u32 reg, u32 val)
 	case APIC_ID:		/* Local APIC ID */
 		if (!apic_x2apic_mode(apic)) {
 			kvm_apic_set_xapic_id(apic, val >> 24);
-			kvm_lapic_xapic_id_updated(apic);
 		} else {
 			ret = 1;
 		}
@@ -2923,9 +2915,6 @@ int kvm_apic_set_state(struct kvm_vcpu *vcpu, struct kvm_lapic_state *s)
 	}
 	memcpy(vcpu->arch.apic->regs, s->regs, sizeof(*s));
 
-	if (!apic_x2apic_mode(apic))
-		kvm_lapic_xapic_id_updated(apic);
-
 	atomic_set_release(&apic->vcpu->kvm->arch.apic_map_dirty, DIRTY);
 	kvm_recalculate_apic_map(vcpu->kvm);
 	kvm_apic_set_version(vcpu);
-- 
2.39.0.314.g84b9a713c41-goog

