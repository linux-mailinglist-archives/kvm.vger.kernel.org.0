Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 650553A0664
	for <lists+kvm@lfdr.de>; Tue,  8 Jun 2021 23:48:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234643AbhFHVuY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Jun 2021 17:50:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234625AbhFHVuY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Jun 2021 17:50:24 -0400
Received: from mail-il1-x14a.google.com (mail-il1-x14a.google.com [IPv6:2607:f8b0:4864:20::14a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95B5EC061787
        for <kvm@vger.kernel.org>; Tue,  8 Jun 2021 14:48:30 -0700 (PDT)
Received: by mail-il1-x14a.google.com with SMTP id q4-20020a056e020784b02901e2ee9a8333so15585500ils.20
        for <kvm@vger.kernel.org>; Tue, 08 Jun 2021 14:48:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=V441yi9NFbr1zLEPRX6rZzogwZk2O2NHoTW1SdrwQz0=;
        b=RrEhuyAGvy7n4Z230SQn5erzHDHZV14ZiRzmyU7qS7EtGyzBvorh9yADusm1lCinf/
         WVcuWVkzvDNwzqZAfWXDokqI5lAT+Qs7Y0+ft7CRYbGTxH/xvSrOlvlekCxl20Uz0STp
         QSOnuZuirGHWp1OGH03LM2g5MCiLL5AcwOTW+vd81Ldcs7Xmo/AQ4+CBbBXK72Ld9jux
         R5MNTEX7cgzJP3n1Vdics1aqGJIC+TH/pxKzYVW5KlTSaWYqAxcFQjRqL56CblAapIZA
         UwicB9ZHCZb0o8lAB5BOgkXwbCmtd4X/TdMZmml6vemqAthBn+741qYe/AxuYycR2/v8
         5Cnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=V441yi9NFbr1zLEPRX6rZzogwZk2O2NHoTW1SdrwQz0=;
        b=OWHcmq3y8suI3BTNu+3E3iwZ0Fuk9WPPlCSob2fd+kP3Rpb+dRFdOKbb58dAEUuuhn
         GaeJ+153f5UcxLpsbdj6C8V8Klct5ShvPKqCDvSGl3tdgKb5zDdkdBRVnAT83gusQXPt
         VSHoY1TfyWxGJCbdo0+rKGqafz91HbhAoO6ayhVH+zd4Huw1vULc4ltkwu47mSM8ZQ1g
         VMcgt5e14vzwUnToCnOKRUTuOmcZZXvQpHLkC9dBxbvJJ8/FhoRfrgSD7tE+IjAz3gbc
         XKXNLuzrt5JeM7zq06bTB1k2WPyUGUyPSdNxsluhCKq7qfeQ5/0/2bWxOiR/UzKoGbsU
         K1IQ==
X-Gm-Message-State: AOAM531tTxjv0kefxh/CdKdmFGwhxD4iwCqg4zoUW/cg3V2UwPT5AlVm
        P3ifqu22oNjdDoJu0Nsz5AlnIE/pzDS06XAa0+4ch83+EdWmqVhTSiWByXXQfnEKVllp7HBAVVu
        y3Az6PkEH80geBkVxemeBEEGN/XC3/XhF0T9aLDHp0adze5dBvGw6qzYe/g==
X-Google-Smtp-Source: ABdhPJx2UsCEL2axJZTGIvmQZ2dIVVT3dzGmnONSw4l/0DJG9Hp/Proa7NFVaaB024/4wdx+UhYYYjniirQ=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:10:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a05:6638:16d6:: with SMTP id
 g22mr12795895jat.142.1623188909951; Tue, 08 Jun 2021 14:48:29 -0700 (PDT)
Date:   Tue,  8 Jun 2021 21:47:39 +0000
In-Reply-To: <20210608214742.1897483-1-oupton@google.com>
Message-Id: <20210608214742.1897483-8-oupton@google.com>
Mime-Version: 1.0
References: <20210608214742.1897483-1-oupton@google.com>
X-Mailer: git-send-email 2.32.0.rc1.229.g3e70b5a671-goog
Subject: [PATCH 07/10] KVM: x86: Refactor tsc synchronization code
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
        Oliver Upton <oupton@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Refactor kvm_synchronize_tsc to make a new function that allows callers
to specify TSC parameters (offset, value, nanoseconds, etc.) explicitly
for the sake of participating in TSC synchronization.

This changes the locking semantics around TSC writes. Writes to the TSC
will now take the pvclock gtod lock while holding the tsc write lock,
whereas before these locks were disjoint.

Reviewed-by: David Matlack <dmatlack@google.com>
Signed-off-by: Oliver Upton <oupton@google.com>
---
 Documentation/virt/kvm/locking.rst |  11 +++
 arch/x86/kvm/x86.c                 | 106 +++++++++++++++++------------
 2 files changed, 74 insertions(+), 43 deletions(-)

diff --git a/Documentation/virt/kvm/locking.rst b/Documentation/virt/kvm/locking.rst
index 1fc860c007a3..d21e0e480d63 100644
--- a/Documentation/virt/kvm/locking.rst
+++ b/Documentation/virt/kvm/locking.rst
@@ -25,6 +25,9 @@ On x86:
   holding kvm->arch.mmu_lock (typically with ``read_lock``, otherwise
   there's no need to take kvm->arch.tdp_mmu_pages_lock at all).
 
+- kvm->arch.tsc_write_lock is taken outside
+  kvm->arch.pvclock_gtod_sync_lock
+
 Everything else is a leaf: no other lock is taken inside the critical
 sections.
 
@@ -211,6 +214,14 @@ time it will be set using the Dirty tracking mechanism described above.
 :Comment:	'raw' because hardware enabling/disabling must be atomic /wrt
 		migration.
 
+:Name:		kvm_arch::pvclock_gtod_sync_lock
+:Type:		raw_spinlock_t
+:Arch:		x86
+:Protects:	kvm_arch::{cur_tsc_generation,cur_tsc_nsec,cur_tsc_write,
+			cur_tsc_offset,nr_vcpus_matched_tsc}
+:Comment:	'raw' because updating the kvm master clock must not be
+		preempted.
+
 :Name:		kvm_arch::tsc_write_lock
 :Type:		raw_spinlock
 :Arch:		x86
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 9b6bca616929..61069995a592 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2351,13 +2351,73 @@ static inline bool kvm_check_tsc_unstable(void)
 	return check_tsc_unstable();
 }
 
+/*
+ * Infers attempts to synchronize the guest's tsc from host writes. Sets the
+ * offset for the vcpu and tracks the TSC matching generation that the vcpu
+ * participates in.
+ *
+ * Must hold kvm->arch.tsc_write_lock to call this function.
+ */
+static void __kvm_synchronize_tsc(struct kvm_vcpu *vcpu, u64 offset, u64 tsc,
+				  u64 ns, bool matched)
+{
+	struct kvm *kvm = vcpu->kvm;
+	bool already_matched;
+	unsigned long flags;
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
+	spin_lock_irqsave(&kvm->arch.pvclock_gtod_sync_lock, flags);
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
+		matched = false;
+	} else if (!already_matched) {
+		kvm->arch.nr_vcpus_matched_tsc++;
+	}
+
+	kvm_track_tsc_matching(vcpu);
+	spin_unlock_irqrestore(&kvm->arch.pvclock_gtod_sync_lock, flags);
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
@@ -2403,51 +2463,11 @@ static void kvm_synchronize_tsc(struct kvm_vcpu *vcpu, u64 data)
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
+	__kvm_synchronize_tsc(vcpu, offset, data, ns, matched);
 
-	/* Keep track of which generation this VCPU has synchronized to */
-	vcpu->arch.this_tsc_generation = kvm->arch.cur_tsc_generation;
-	vcpu->arch.this_tsc_nsec = kvm->arch.cur_tsc_nsec;
-	vcpu->arch.this_tsc_write = kvm->arch.cur_tsc_write;
-
-	kvm_vcpu_write_tsc_offset(vcpu, offset);
 	raw_spin_unlock_irqrestore(&kvm->arch.tsc_write_lock, flags);
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
 }
 
 static inline void adjust_tsc_offset_guest(struct kvm_vcpu *vcpu,
-- 
2.32.0.rc1.229.g3e70b5a671-goog

