Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC9382289B5
	for <lists+kvm@lfdr.de>; Tue, 21 Jul 2020 22:18:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730470AbgGUUSX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jul 2020 16:18:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726658AbgGUUSW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Jul 2020 16:18:22 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A157C0619DA
        for <kvm@vger.kernel.org>; Tue, 21 Jul 2020 13:18:22 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id i1so17062934pgn.13
        for <kvm@vger.kernel.org>; Tue, 21 Jul 2020 13:18:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=QD4uV54IL68Del4fdGOvf6XTmyV/0hAZrgqJbqMObDM=;
        b=Q5CH8IBM95uJncMg5tBpzXhLrW40QO9BBs46QsH0ZTt7UZ30/+QEAICEuHlFMjj7in
         biP9ZMDO0EDUeC22w/ux7KABFfvj5fOXkQ5KdIjSxgBxjH2xgq2CfLxO5TOPZiBkwSYy
         WT+oaeWYe7BzVdWuclCAsYUz4/iWo6/zuuci9MvDzvIZE42F6r+7P6cUJLY2aJWD41El
         JYfnl6lWYL9fC+v6W7mT0Ye3p2UShdxU60NpFx4UmIgeZRiwLjGhB4Kmy6ELAO3uKI8o
         RF3cH+0dqeeu9a2PlZ24n6FLMK3KQkyDEehLxyULViv5ezfdOeo8oFXPu2DljarUH/mN
         wQ6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=QD4uV54IL68Del4fdGOvf6XTmyV/0hAZrgqJbqMObDM=;
        b=eOvVt/xS4nuS3XdSg9ND6nuBLZjkwhKlTJdFv/i62kxp/3tUg2/j90XEKVQn3EXT65
         JvEcx2TwekyiyyqXycFJwGtkPIH2EBVbFbRjI/kxN9fgLwdk3GhIvoWxUsQgmDCI62Hs
         VM/rqfMrBEk4VJ3G5M8fxIHyrV/50PPMkJ7xe6gpRv3aZQyqbprXDfBpHjSroip5KG7l
         IFUwjggJSP34xvp1D7YnJl+om20RADB/bSB4EC6QYSXt3QmZV+aeCTFFWAIoc304g4f0
         ifQCQ6zcxCRRlyBShPc2moxpCdlxCf0FLaxXAPnlvyFJyqcq0uykneVEFkKkX0jTCkGE
         VkQg==
X-Gm-Message-State: AOAM533hiThapPdRoe4UN2YeQGIYWNt9gbzt6gbZLMrpzuCcaU/zBA55
        MHm2xUq+jHuvalewSTHMc3B3enQKiXSmU4tqWO149FZZfrIvyRtTw3OeVkT3xYw+HUje8MbpSNC
        gnjcV6mXoAJajvUNds9/ECTqZsguyfSlJNQQ6sNPDZLT8tePfh61yEa5HKg==
X-Google-Smtp-Source: ABdhPJy05uK558uc7madzS1wDCualoB8i8Ui8Ny6Z2xk0olg2kaKQSD14M2WQ8+wESig5WvEFWd3+0AKggE=
X-Received: by 2002:a63:3fc2:: with SMTP id m185mr24863899pga.426.1595362701346;
 Tue, 21 Jul 2020 13:18:21 -0700 (PDT)
Date:   Tue, 21 Jul 2020 20:18:10 +0000
In-Reply-To: <20200721201814.2340705-1-oupton@google.com>
Message-Id: <20200721201814.2340705-2-oupton@google.com>
Mime-Version: 1.0
References: <20200721201814.2340705-1-oupton@google.com>
X-Mailer: git-send-email 2.28.0.rc0.142.g3c755180ce-goog
Subject: [PATCH v2 1/5] kvm: x86: refactor masterclock sync heuristics out of kvm_write_tsc
From:   Oliver Upton <oupton@google.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Peter Shier <pshier@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Peter Hornyack <peterhornyack@google.com>,
        Oliver Upton <oupton@google.com>,
        Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

kvm_write_tsc() determines when the host or guest is attempting to
synchronize the TSCs and does some bookkeeping for tracking this. Retain
the existing sync checks (host is writing 0 or TSCs being written within
a second of one another) in kvm_write_tsc(), but split off the
bookkeeping and TSC offset write into a new function. This allows for a
new ioctl to be introduced, yielding control of the TSC offset field to
userspace in a manner that respects the existing masterclock heuristics.

Reviewed-by: Jim Mattson <jmattson@google.com>
Reviewed-by: Peter Shier <pshier@google.com>
Signed-off-by: Oliver Upton <oupton@google.com>
---
 arch/x86/kvm/x86.c | 98 +++++++++++++++++++++++++---------------------
 1 file changed, 54 insertions(+), 44 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index e27d3db7e43f..1ad6bcb21f56 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2045,13 +2045,64 @@ static inline bool kvm_check_tsc_unstable(void)
 	return check_tsc_unstable();
 }
 
+/*
+ * Sets the TSC offset for the vCPU and tracks the TSC matching generation. Must
+ * hold the kvm->arch.tsc_write_lock to call this function.
+ */
+void kvm_write_tsc_offset(struct kvm_vcpu *vcpu, u64 offset, u64 tsc, u64 ns,
+			  bool matched)
+{
+	struct kvm *kvm = vcpu->kvm;
+	bool already_matched;
+
+	already_matched = (vcpu->arch.this_tsc_generation == kvm->arch.cur_tsc_generation);
+	/*
+	 * We also track the most recent recorded KHZ, write and time to
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
+	spin_lock(&kvm->arch.pvclock_gtod_sync_lock);
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
+		kvm->arch.nr_vcpus_matched_tsc = 0;
+		kvm->arch.cur_tsc_generation++;
+		kvm->arch.cur_tsc_nsec = ns;
+		kvm->arch.cur_tsc_write = tsc;
+		kvm->arch.cur_tsc_offset = offset;
+	} else if (!already_matched) {
+		kvm->arch.nr_vcpus_matched_tsc++;
+	}
+
+	kvm_track_tsc_matching(vcpu);
+	spin_unlock(&kvm->arch.pvclock_gtod_sync_lock);
+}
+
 void kvm_write_tsc(struct kvm_vcpu *vcpu, struct msr_data *msr)
 {
 	struct kvm *kvm = vcpu->kvm;
 	u64 offset, ns, elapsed;
 	unsigned long flags;
-	bool matched;
-	bool already_matched;
+	bool matched = false;
 	u64 data = msr->data;
 	bool synchronizing = false;
 
@@ -2098,54 +2149,13 @@ void kvm_write_tsc(struct kvm_vcpu *vcpu, struct msr_data *msr)
 			offset = kvm_compute_tsc_offset(vcpu, data);
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
 	if (!msr->host_initiated && guest_cpuid_has(vcpu, X86_FEATURE_TSC_ADJUST))
 		update_ia32_tsc_adjust_msr(vcpu, offset);
 
-	kvm_vcpu_write_tsc_offset(vcpu, offset);
+	kvm_write_tsc_offset(vcpu, offset, data, ns, matched);
 	raw_spin_unlock_irqrestore(&kvm->arch.tsc_write_lock, flags);
-
-	spin_lock(&kvm->arch.pvclock_gtod_sync_lock);
-	if (!matched) {
-		kvm->arch.nr_vcpus_matched_tsc = 0;
-	} else if (!already_matched) {
-		kvm->arch.nr_vcpus_matched_tsc++;
-	}
-
-	kvm_track_tsc_matching(vcpu);
-	spin_unlock(&kvm->arch.pvclock_gtod_sync_lock);
 }
 
 EXPORT_SYMBOL_GPL(kvm_write_tsc);
-- 
2.28.0.rc0.142.g3c755180ce-goog

