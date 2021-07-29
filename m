Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B0D43D99E6
	for <lists+kvm@lfdr.de>; Thu, 29 Jul 2021 02:10:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232913AbhG2AK1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Jul 2021 20:10:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232888AbhG2AK0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Jul 2021 20:10:26 -0400
Received: from mail-ot1-x34a.google.com (mail-ot1-x34a.google.com [IPv6:2607:f8b0:4864:20::34a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F129C061757
        for <kvm@vger.kernel.org>; Wed, 28 Jul 2021 17:10:24 -0700 (PDT)
Received: by mail-ot1-x34a.google.com with SMTP id 16-20020a9d04100000b02904cdb63ceafcso1560851otc.6
        for <kvm@vger.kernel.org>; Wed, 28 Jul 2021 17:10:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=XNyGfZ2Z9WQ1sVAL8fhBnwiD8pzYXS25rkapNfjiWHg=;
        b=CtSFE/qMPXTYCHhYnIcGfx6a79Epdi2CerwEcmhP+HYfKRdpTBPMwC+QIJhVvE2oaP
         Q7cUVSu6921loBsKoCqYDWy8CPRWRncpeQmV6KJ/oqkMJggKzoDKrUPCS2j435v/bjwD
         YI8AIGjJ1L5vOuc73yOX4RYMM4ktDnrEtwY7E5TGVe4Xj4+A3MyGq+8E3TRYjdRlASrc
         p3/nw2wvQytI94fIfSqhn4aVNFr7pYX6+r4sKh+Cj4iic+ZKbVdVs1xNV17QQ4h2VTgC
         MWaju3SMyRbQ9blkDXDkTKbm70G7DaPn3xwxWWkMhRrmjddJMsp+tk7605yNtmBPXSh0
         +xZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=XNyGfZ2Z9WQ1sVAL8fhBnwiD8pzYXS25rkapNfjiWHg=;
        b=Jcpn7LBff+bUL75xK2SrypLDYWzww0b1bXKuCsqN301Qn1s/ZGgmqF/NkcqbQBTTIu
         bqyHD6WwODolvJ4ytFkP3uFgmDHGGEBjCpdIyhDGYwr556azUOwBywqn0N/m2PLtCElG
         YDjcUU9A29I6NKGDpkCcRCb5DGo7wcDkYqAs4G3dEjRKG/XbXw9ic2cO65//FyLZvRGe
         MIxCkfJgbVolaBP01KXnjbe2qyZ+qo/WUdrnIaswmy8wWtnsTsoZIupBAmovDOk26ZOe
         m2947Auj+iGZnGDXfufbT4AVUfP03bYYzcHNzbhERCSLiER54Yip7PCUc0Xjxd3QxP1V
         KGhQ==
X-Gm-Message-State: AOAM531s2+jUK+/uXhJL2+HC0OTqUIKsMESiu/c2YWsa6avB9pXUFWGb
        YOXX5BwzwmvMaPRhyKRJmjQYuTCg+9Zq+0M+1vYFc2YaWo1eq/tWD2AF5w53aIjw6nrvz3u2HOX
        3EtKsBw5zR6Kd5M15/Ucih02I2mS+PwAXcTf6i9/6oAlQ65pi+Gki226RDw==
X-Google-Smtp-Source: ABdhPJy/pAh7obK0tWDsill/tV4V0dfpseOT6QEsSMLssuDCvafi7DH0p7a/cfjHy7QL1cjTibQXCC/Ugns=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a54:4094:: with SMTP id i20mr1318895oii.159.1627517423737;
 Wed, 28 Jul 2021 17:10:23 -0700 (PDT)
Date:   Thu, 29 Jul 2021 00:10:01 +0000
In-Reply-To: <20210729001012.70394-1-oupton@google.com>
Message-Id: <20210729001012.70394-3-oupton@google.com>
Mime-Version: 1.0
References: <20210729001012.70394-1-oupton@google.com>
X-Mailer: git-send-email 2.32.0.432.gabb21c7263-goog
Subject: [PATCH v4 02/13] KVM: x86: Refactor tsc synchronization code
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
index 8138201efb09..0bf346adac2a 100644
--- a/Documentation/virt/kvm/locking.rst
+++ b/Documentation/virt/kvm/locking.rst
@@ -36,6 +36,9 @@ On x86:
   holding kvm->arch.mmu_lock (typically with ``read_lock``, otherwise
   there's no need to take kvm->arch.tdp_mmu_pages_lock at all).
 
+- kvm->arch.tsc_write_lock is taken outside
+  kvm->arch.pvclock_gtod_sync_lock
+
 Everything else is a leaf: no other lock is taken inside the critical
 sections.
 
@@ -222,6 +225,14 @@ time it will be set using the Dirty tracking mechanism described above.
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
index e052c7afaac4..27435a07fb46 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2443,13 +2443,73 @@ static inline bool kvm_check_tsc_unstable(void)
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
@@ -2495,51 +2555,11 @@ static void kvm_synchronize_tsc(struct kvm_vcpu *vcpu, u64 data)
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
2.32.0.432.gabb21c7263-goog

