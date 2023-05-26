Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F6837130A9
	for <lists+kvm@lfdr.de>; Sat, 27 May 2023 01:51:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237735AbjEZXvC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 May 2023 19:51:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236849AbjEZXu6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 May 2023 19:50:58 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30E9283
        for <kvm@vger.kernel.org>; Fri, 26 May 2023 16:50:55 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id 41be03b00d2f7-5341081a962so1325747a12.2
        for <kvm@vger.kernel.org>; Fri, 26 May 2023 16:50:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685145054; x=1687737054;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=LQ1i2DguubB/+TBn/4idJEX6+htUYXJLnvWqgTtQ+sE=;
        b=Qb4rdYu25sLs0lTzHE4ARDdUbhO/L0r1lri2Eh42yzbC2ec9iL0kyLgvlu1q2Oxknc
         GDHb9LthFCdvxEtVvUaFY6pYVJl9tgaUBIvOaSeLHnav+i9QDTUaLPVytgOabMrhZCOi
         aS20kL8vBcozW6FC/kolZZ0JH4yIy1yQLD5IAIRhJitL4QUUTDVLwEWWZwpgjlJl3Cs6
         0jNDFS7Ch830eU8VaeQnJvBDu2Sppxiomf7botktlWZA73DVTdEYQqwmyFDmsCBiSino
         gHtxz3uaJqFeIBPxuY/j00/LCk6Kg4p9LjtoEesicP8WLIhC6CtCopoxX6wpio7w/nDn
         xK5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685145054; x=1687737054;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LQ1i2DguubB/+TBn/4idJEX6+htUYXJLnvWqgTtQ+sE=;
        b=V3MyVFYtP5/xf3AsqysKpHAdT5m6yw2y9mZWiucXihDURAvXCeP+2T/mBFDnG7TqR1
         7Y1gU2/wHu8fY80iT9fYcOrQHDwooTL85osB53S5g8odUyAFqdMZpMKaMfDk6obd4b2j
         E25NJ75XygGYvaooFNkgOWtlLudg4nARUEiaLMqsXz0tURGju31mf4Ansk9fQA/g1ug2
         x+jUWiPA+PqTRza/lyshrO/9vkl+T2pCexjh377wMt17TrrKsOcR7Ez3kU7e3EyfAp5V
         PcNZvIxorLJe77sspNEYAdZMIvyypy9cct35DqYJpJdaPO/ibB0zbYXeqT/Q4UPvcJ6e
         wr6w==
X-Gm-Message-State: AC+VfDzvMpOncwQp291Ya328Nkyr2LmNCB2IO8Bnjzr0tjy7k/AWWL5P
        8m4tMwaKhkZc8vcN76cpeVRUsPP5kFE=
X-Google-Smtp-Source: ACHHUZ63QxfDBJN5gcO9zbQioZ92vLq9NWqlULPbXcgIfsDEZwl5bOocAFcUbzwZq1IWilptEAhIrasqwCw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:6c2:0:b0:53f:5c6c:3d18 with SMTP id
 185-20020a6306c2000000b0053f5c6c3d18mr205156pgg.10.1685145054665; Fri, 26 May
 2023 16:50:54 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 26 May 2023 16:50:47 -0700
In-Reply-To: <20230526235048.2842761-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230526235048.2842761-1-seanjc@google.com>
X-Mailer: git-send-email 2.41.0.rc0.172.g3f132b7071-goog
Message-ID: <20230526235048.2842761-3-seanjc@google.com>
Subject: [PATCH v2 2/3] KVM: x86: Retry APIC optimized map recalc if vCPU is added/enabled
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michal Luczaj <mhal@rbox.co>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Retry the optimized APIC map recalculation if an APIC-enabled vCPU shows
up between allocating the map and filling in the map data.  Conditionally
reschedule before retrying even though the number of vCPUs that can be
created is bounded by KVM.  Retrying a few thousand times isn't so slow
as to be hugely problematic, but it's not blazing fast either.

Reset xapic_id_mistach on each retry as a vCPU could change its xAPIC ID
between loops, but do NOT reset max_id.  The map size also factors in
whether or not a vCPU's local APIC is hardware-enabled, i.e. userspace
and/or the guest can theoretically keep KVM retrying indefinitely.  The
only downside is that KVM will allocate more memory than is strictly
necessary if the vCPU with the highest x2APIC ID disabled its APIC while
the recalculation was in-progress.

Refresh kvm->arch.apic_map_dirty to opportunistically change it from
DIRTY => UPDATE_IN_PROGRESS to avoid an unnecessary recalc from a
different task, i.e. if another task is waiting to attempt an update
(which is likely since a retry happens if and only if an update is
required).

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/lapic.c | 29 +++++++++++++++++++++++++----
 1 file changed, 25 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 3c300a196bdf..cadeaba25e65 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -381,7 +381,8 @@ void kvm_recalculate_apic_map(struct kvm *kvm)
 	struct kvm_vcpu *vcpu;
 	unsigned long i;
 	u32 max_id = 255; /* enough space for any xAPIC ID */
-	bool xapic_id_mismatch = false;
+	bool xapic_id_mismatch;
+	int r;
 
 	/* Read kvm->arch.apic_map_dirty before kvm->arch.apic_map.  */
 	if (atomic_read_acquire(&kvm->arch.apic_map_dirty) == CLEAN)
@@ -391,9 +392,14 @@ void kvm_recalculate_apic_map(struct kvm *kvm)
 		  "Dirty APIC map without an in-kernel local APIC");
 
 	mutex_lock(&kvm->arch.apic_map_lock);
+
+retry:
 	/*
-	 * Read kvm->arch.apic_map_dirty before kvm->arch.apic_map
-	 * (if clean) or the APIC registers (if dirty).
+	 * Read kvm->arch.apic_map_dirty before kvm->arch.apic_map (if clean)
+	 * or the APIC registers (if dirty).  Note, on retry the map may have
+	 * not yet been marked dirty by whatever task changed a vCPU's x2APIC
+	 * ID, i.e. the map may still show up as in-progress.  In that case
+	 * this task still needs to retry and copmlete its calculation.
 	 */
 	if (atomic_cmpxchg_acquire(&kvm->arch.apic_map_dirty,
 				   DIRTY, UPDATE_IN_PROGRESS) == CLEAN) {
@@ -402,6 +408,15 @@ void kvm_recalculate_apic_map(struct kvm *kvm)
 		return;
 	}
 
+	/*
+	 * Reset the mismatch flag between attempts so that KVM does the right
+	 * thing if a vCPU changes its xAPIC ID, but do NOT reset max_id, i.e.
+	 * keep max_id strictly increasing.  Disallowing max_id from shrinking
+	 * ensures KVM won't get stuck in an infinite loop, e.g. if the vCPU
+	 * with the highest x2APIC ID is toggling its APIC on and off.
+	 */
+	xapic_id_mismatch = false;
+
 	kvm_for_each_vcpu(i, vcpu, kvm)
 		if (kvm_apic_present(vcpu))
 			max_id = max(max_id, kvm_x2apic_id(vcpu->arch.apic));
@@ -420,9 +435,15 @@ void kvm_recalculate_apic_map(struct kvm *kvm)
 		if (!kvm_apic_present(vcpu))
 			continue;
 
-		if (kvm_recalculate_phys_map(new, vcpu, &xapic_id_mismatch)) {
+		r = kvm_recalculate_phys_map(new, vcpu, &xapic_id_mismatch);
+		if (r) {
 			kvfree(new);
 			new = NULL;
+			if (r == -E2BIG) {
+				cond_resched();
+				goto retry;
+			}
+
 			goto out;
 		}
 
-- 
2.41.0.rc0.172.g3f132b7071-goog

