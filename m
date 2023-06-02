Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9321D720C59
	for <lists+kvm@lfdr.de>; Sat,  3 Jun 2023 01:33:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236885AbjFBXdL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Jun 2023 19:33:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236854AbjFBXdH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Jun 2023 19:33:07 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B0FC197
        for <kvm@vger.kernel.org>; Fri,  2 Jun 2023 16:33:06 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-5692be06cb2so31488747b3.1
        for <kvm@vger.kernel.org>; Fri, 02 Jun 2023 16:33:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685748786; x=1688340786;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=5mmxUWbNXCWcSKNxzb01KGCvCtOMb6rFR6D6MsiL8rA=;
        b=WoUEDQ5ddpi/oFfFOoBl18AoWb3GZ6rToUETa/0Sz/BJfgDYlktlML5eoKlq8u2Q+b
         cJBMCzxzbFBhmCaWyqTLD5b0MQi2Jlt1+Kpxpv361mlWS0fDkbi1Rtp2WT2kll/jgEpj
         SM+NEGAGmxKHxnlV9fh5xrJrX3GDHlJMqu5i9oE/iA0gyEOavlMdewoDkXKnwtI7A6/R
         OxdeBopFScxg8WK+70Qfe2uf1umiJQnX9VSojaJyXdwFYW/J0IH/OCOoMUiXgqnjZHQ2
         gkU79mN3ZyosGJCBIAKfydsc54p2hbMO9A4vGUy1JsMKsCSeU+Bn4Utgm3+4y1q1438/
         dj1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685748786; x=1688340786;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5mmxUWbNXCWcSKNxzb01KGCvCtOMb6rFR6D6MsiL8rA=;
        b=F4WZo/zQ67Ff0eKJuLN3w5LURWhxKZ99nHKEtepepycC5oybi07JseWAE5Mrwvn5y7
         LN3iTbTm9nBmaKV6c+xniNuqU8ICaObQiYs3nn1+y1K88WTbo5WKcHi2E9UkBpewZwOq
         MtMMzt9vRVh4ikVSSYcx+pp0lcI0RWtG7cSOBI1K0o2DFpQptcOzu3HssoEinGg9tlZN
         KAfilePHeDwsd8Vd1vTLTxZtXuJqMWUAhIvnFTC4sAy3yFcN+scWXXGtHVEY345p7JVv
         /ZPbdNOaKIB/ZASpPBagHgG7qoYej//AcOXhBe2KZokttTMi53jazTMi/F0kmuSPRcE2
         gG2g==
X-Gm-Message-State: AC+VfDxivRj0pqBwtRDRH56zyBY996LYv8bknwiB1fsjTRod+Iv4mTfs
        yP+BwTiS9SivW9kah7FQposk+8rqj1k=
X-Google-Smtp-Source: ACHHUZ5bEUhJdYvxdgTGwYML3221yKwmF2F7wPtdS+NYUy73iU2lQAxLNanRUxKSXSJRKxQ+GUPwQjaL14g=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:ac06:0:b0:561:8e86:9818 with SMTP id
 k6-20020a81ac06000000b005618e869818mr629972ywh.7.1685748785936; Fri, 02 Jun
 2023 16:33:05 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri,  2 Jun 2023 16:32:49 -0700
In-Reply-To: <20230602233250.1014316-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230602233250.1014316-1-seanjc@google.com>
X-Mailer: git-send-email 2.41.0.rc2.161.g9c6817b8e7-goog
Message-ID: <20230602233250.1014316-3-seanjc@google.com>
Subject: [PATCH v3 2/3] KVM: x86: Retry APIC optimized map recalc if vCPU is added/enabled
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
2.41.0.rc2.161.g9c6817b8e7-goog

