Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB47B3ECBEB
	for <lists+kvm@lfdr.de>; Mon, 16 Aug 2021 02:12:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231921AbhHPAM1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 15 Aug 2021 20:12:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231843AbhHPAML (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 15 Aug 2021 20:12:11 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81659C061796
        for <kvm@vger.kernel.org>; Sun, 15 Aug 2021 17:11:40 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id c63-20020a25e5420000b0290580b26e708aso14973641ybh.12
        for <kvm@vger.kernel.org>; Sun, 15 Aug 2021 17:11:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=Dz4OQO7fko2xnm4bF9gtGHyuF6byVH0iKDoKQ9+K0Hk=;
        b=nG02hDlOtRC4KMB166Vy/WGh+WM1WqWLqoL9SZhFphHrdt7+VGLAwmWCuohkTHG09W
         qutphgh99ADbQ04rhvA8LKDsAP+PLuBGZVfX6CsIlwTBHn6j1ge13dmrDOQc/smYQfij
         KPWPWRIVRlB3EriEo/xoctVVzJUObu/x7xovD9XeuNYhRk6uYKiZw+BV5pFtGdV9a4tc
         nvsgIvqHBuviNCQWPM8HO56W+tOa30KchZXhGEeUXYEC/ZDclh79E9PPgJx/+wcbJCHb
         /w6w1lECCO5Ja8sYwFNhywkGt3KmcdRiSDJcb6AlSJRaOymWy44wwnqT4ZcbZ+U1s16l
         nAag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=Dz4OQO7fko2xnm4bF9gtGHyuF6byVH0iKDoKQ9+K0Hk=;
        b=Th0zxF6PHdilcCmIbg2PyTnolVWOwqo56iBxAFVsgg1n2TSHx+NQtHKNorE+z2xLhB
         hyUjoSKbz02BDutkhqMOu0Im172APVrn57GQZrBJjJkACcW1ILxHQcyVFmHTwNMCFPIO
         H6MAnAjZ+Xj/bp9rDcKDj1jnx6gvsUmkBBCMg5kOxOoruhkMF62cEqvh0i6vX5U4Bemy
         TzzcnQcLPDRYwuuTOme3w3g8VkkE/aB583ClNW9F8K/pA0r78HAI1z3BkznTS7cogTEp
         gKl6ND+JYLc5e9R6gMwpzyQ0UdDF7/ANPECsD8cIVJio6aY5XNvC+bXUwF1lYOqGguOR
         xJqg==
X-Gm-Message-State: AOAM5300xUAJnhMm9sJJ4tnLDCB9eNbMdNOrIz3WtW6nBDzPO0fPhUoE
        oFHswmk2MGakIarvfCKIVA9soWmQ9At770prurY/JSA7aE+SsDUaHNf+Jn+ULilESKCU3jfEstx
        dtsxCY00JltGmFdB8sahJ5gnRj6EnI6SXseBN7C2w5PH49wx8ZHaUv5KK4w==
X-Google-Smtp-Source: ABdhPJz9cl6CBqtVJqMeLgOBubeEV1ZIVpCy0Cv8/HD8GcR/AFOkA5Fnz9sYJeChQ3DsMEpVB1XuZCGCFoc=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a25:41ce:: with SMTP id o197mr18562489yba.365.1629072699675;
 Sun, 15 Aug 2021 17:11:39 -0700 (PDT)
Date:   Mon, 16 Aug 2021 00:11:29 +0000
In-Reply-To: <20210816001130.3059564-1-oupton@google.com>
Message-Id: <20210816001130.3059564-6-oupton@google.com>
Mime-Version: 1.0
References: <20210816001130.3059564-1-oupton@google.com>
X-Mailer: git-send-email 2.33.0.rc1.237.g0d66db33f3-goog
Subject: [PATCH v7 5/6] KVM: x86: Refactor tsc synchronization code
From:   Oliver Upton <oupton@google.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Marc Zyngier <maz@kernel.org>, Peter Shier <pshier@google.com>,
        Jim Mattson <jmattson@google.com>,
        David Matlack <dmatlack@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Andrew Jones <drjones@redhat.com>,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Oliver Upton <oupton@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Refactor kvm_synchronize_tsc to make a new function that allows callers
to specify TSC parameters (offset, value, nanoseconds, etc.) explicitly
for the sake of participating in TSC synchronization.

Signed-off-by: Oliver Upton <oupton@google.com>
---
 arch/x86/kvm/x86.c | 105 ++++++++++++++++++++++++++-------------------
 1 file changed, 61 insertions(+), 44 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index f1434cd388b9..9d0445527dad 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2447,13 +2447,71 @@ static inline bool kvm_check_tsc_unstable(void)
 	return check_tsc_unstable();
 }
 
+/*
+ * Infers attempts to synchronize the guest's tsc from host writes. Sets the
+ * offset for the vcpu and tracks the TSC matching generation that the vcpu
+ * participates in.
+ */
+static void __kvm_synchronize_tsc(struct kvm_vcpu *vcpu, u64 offset, u64 tsc,
+				  u64 ns, bool matched)
+{
+	struct kvm *kvm = vcpu->kvm;
+	bool already_matched;
+
+	lockdep_assert_held(&kvm->arch.tsc_write_lock);
+
+	already_matched =
+	       (vcpu->arch.this_tsc_generation == kvm->arch.cur_tsc_generation);
+
+	/*
+	 * We track the most recent recorded KHZ, write and time to
+	 * allow the matching interval to be extended at each write.
+	 */
+	kvm->arch.last_tsc_nsec = ns;
+	kvm->arch.last_tsc_write = tsc;
+	kvm->arch.last_tsc_khz = vcpu->arch.virtual_tsc_khz;
+
+	vcpu->arch.last_guest_tsc = tsc;
+
+	/* Keep track of which generation this VCPU has synchronized to */
+	vcpu->arch.this_tsc_generation = kvm->arch.cur_tsc_generation;
+	vcpu->arch.this_tsc_nsec = kvm->arch.cur_tsc_nsec;
+	vcpu->arch.this_tsc_write = kvm->arch.cur_tsc_write;
+
+	kvm_vcpu_write_tsc_offset(vcpu, offset);
+
+	if (!matched) {
+		/*
+		 * We split periods of matched TSC writes into generations.
+		 * For each generation, we track the original measured
+		 * nanosecond time, offset, and write, so if TSCs are in
+		 * sync, we can match exact offset, and if not, we can match
+		 * exact software computation in compute_guest_tsc()
+		 *
+		 * These values are tracked in kvm->arch.cur_xxx variables.
+		 */
+		kvm->arch.cur_tsc_generation++;
+		kvm->arch.cur_tsc_nsec = ns;
+		kvm->arch.cur_tsc_write = tsc;
+		kvm->arch.cur_tsc_offset = offset;
+
+		spin_lock(&kvm->arch.pvclock_gtod_sync_lock);
+		kvm->arch.nr_vcpus_matched_tsc = 0;
+	} else if (!already_matched) {
+		spin_lock(&kvm->arch.pvclock_gtod_sync_lock);
+		kvm->arch.nr_vcpus_matched_tsc++;
+	}
+
+	kvm_track_tsc_matching(vcpu);
+	spin_unlock(&kvm->arch.pvclock_gtod_sync_lock);
+}
+
 static void kvm_synchronize_tsc(struct kvm_vcpu *vcpu, u64 data)
 {
 	struct kvm *kvm = vcpu->kvm;
 	u64 offset, ns, elapsed;
 	unsigned long flags;
-	bool matched;
-	bool already_matched;
+	bool matched = false;
 	bool synchronizing = false;
 
 	raw_spin_lock_irqsave(&kvm->arch.tsc_write_lock, flags);
@@ -2499,50 +2557,9 @@ static void kvm_synchronize_tsc(struct kvm_vcpu *vcpu, u64 data)
 			offset = kvm_compute_l1_tsc_offset(vcpu, data);
 		}
 		matched = true;
-		already_matched = (vcpu->arch.this_tsc_generation == kvm->arch.cur_tsc_generation);
-	} else {
-		/*
-		 * We split periods of matched TSC writes into generations.
-		 * For each generation, we track the original measured
-		 * nanosecond time, offset, and write, so if TSCs are in
-		 * sync, we can match exact offset, and if not, we can match
-		 * exact software computation in compute_guest_tsc()
-		 *
-		 * These values are tracked in kvm->arch.cur_xxx variables.
-		 */
-		kvm->arch.cur_tsc_generation++;
-		kvm->arch.cur_tsc_nsec = ns;
-		kvm->arch.cur_tsc_write = data;
-		kvm->arch.cur_tsc_offset = offset;
-		matched = false;
 	}
 
-	/*
-	 * We also track th most recent recorded KHZ, write and time to
-	 * allow the matching interval to be extended at each write.
-	 */
-	kvm->arch.last_tsc_nsec = ns;
-	kvm->arch.last_tsc_write = data;
-	kvm->arch.last_tsc_khz = vcpu->arch.virtual_tsc_khz;
-
-	vcpu->arch.last_guest_tsc = data;
-
-	/* Keep track of which generation this VCPU has synchronized to */
-	vcpu->arch.this_tsc_generation = kvm->arch.cur_tsc_generation;
-	vcpu->arch.this_tsc_nsec = kvm->arch.cur_tsc_nsec;
-	vcpu->arch.this_tsc_write = kvm->arch.cur_tsc_write;
-
-	kvm_vcpu_write_tsc_offset(vcpu, offset);
-
-	spin_lock_irqsave(&kvm->arch.pvclock_gtod_sync_lock, flags);
-	if (!matched) {
-		kvm->arch.nr_vcpus_matched_tsc = 0;
-	} else if (!already_matched) {
-		kvm->arch.nr_vcpus_matched_tsc++;
-	}
-
-	kvm_track_tsc_matching(vcpu);
-	spin_unlock_irqrestore(&kvm->arch.pvclock_gtod_sync_lock, flags);
+	__kvm_synchronize_tsc(vcpu, offset, data, ns, matched);
 	raw_spin_unlock_irqrestore(&kvm->arch.tsc_write_lock, flags);
 }
 
-- 
2.33.0.rc1.237.g0d66db33f3-goog

