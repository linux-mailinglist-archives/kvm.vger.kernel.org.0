Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26A20228E96
	for <lists+kvm@lfdr.de>; Wed, 22 Jul 2020 05:26:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731962AbgGVD0p (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jul 2020 23:26:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731781AbgGVD0o (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Jul 2020 23:26:44 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AA62C061794
        for <kvm@vger.kernel.org>; Tue, 21 Jul 2020 20:26:44 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id cq11so570188pjb.0
        for <kvm@vger.kernel.org>; Tue, 21 Jul 2020 20:26:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=rBjLpJvTlzHOoYcg3+C8dCA5VSP3fypEK3RTeWQeLVI=;
        b=iXEvVZnyqqUIHuCxPhULMAKLJYa4b9Li0gVjxyIKBvyiU8p7SFA4cK9FT8uFcXaWPQ
         Fs8yFlNg5TQRfZ7+2e1X24q9NNBqY26TDNPDMUqx6g3RukK+W1NB1VUo2b88M32kG1C6
         rY3aulX1BV/zr5Vm7XwOBVn7WImptMB0ncUS0TcfiUUEBkLpRSJocskJGSATkDxavX7o
         +lLdzRiNfEOG//FfXQ2fxRCiwlpHQNnp/fZcD0bLH8vtYf/+mxbYOj6Pjpjqeu3EiIsS
         fGmRSeMfPkwuaeotZp4+6Kt4L5543u/fOxoUOPtkiMoZ75W+qDat2Ut+G75lNXqUSG5p
         cHxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=rBjLpJvTlzHOoYcg3+C8dCA5VSP3fypEK3RTeWQeLVI=;
        b=ZDXV9i91LY/vT4ivo7VZ1QXuy73OcXwfRZIZkW7RMVs6TE8suWHHrGTJQiNdwocFxT
         3NnyVn5Lr2m+Uwr+8vBnH05RRZ+jd2c5fWcNswqShbV7Z74ZOEE7zbMVOjMhh+gStEVw
         yBlE06tP8fkFrMkIdUOYp39gdN9EtBbaozRQhWcIb+5wqQuC8gDBhnxJOBGDMDIcMtO0
         rPxMPjMTxJt83uYCszxwDLWEXxL6spcgROBSK3T33YNfposOPw9o+LuY6/fti3PI2y4v
         nBnHWyCXFDkKV77hFSHAPTSi4OexqPpYzGFyuTX2isRfXYCfkhxAZB1Kf0B/ai1vlSTI
         P7jw==
X-Gm-Message-State: AOAM532KyKu+tkZ3mvA0HGCGDydhgBZ55OWg5vsuW7ivAHNSXEgZzzsL
        HZ+WvnBNdg7aOexj7ZN61C+FTe/ucyf6DcOocMpc9L5g7DMaFnNJhgxCAMi0DllxbLQm4iEFyt+
        XmJsoOZLTSNznGDUofv4RML6B4cemOzpoYmN0g9zO4YofwjOuxd+pYbwKTw==
X-Google-Smtp-Source: ABdhPJyEdiCwV7hm7tZ+J8ksVri4B4y0gGGlhc2SciNBoTbDcHlZ6JXXNaRofbv314Idp4PiLJXS/fXO8zg=
X-Received: by 2002:a17:90a:bd8b:: with SMTP id z11mr621949pjr.0.1595388403479;
 Tue, 21 Jul 2020 20:26:43 -0700 (PDT)
Date:   Wed, 22 Jul 2020 03:26:25 +0000
In-Reply-To: <20200722032629.3687068-1-oupton@google.com>
Message-Id: <20200722032629.3687068-2-oupton@google.com>
Mime-Version: 1.0
References: <20200722032629.3687068-1-oupton@google.com>
X-Mailer: git-send-email 2.28.0.rc0.142.g3c755180ce-goog
Subject: [PATCH v3 1/5] kvm: x86: refactor masterclock sync heuristics out of kvm_write_tsc
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
index e27d3db7e43f..a5c88f747da6 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2045,13 +2045,64 @@ static inline bool kvm_check_tsc_unstable(void)
 	return check_tsc_unstable();
 }
 
+/*
+ * Sets the TSC offset for the vCPU and tracks the TSC matching generation. Must
+ * hold the kvm->arch.tsc_write_lock to call this function.
+ */
+static void kvm_write_tsc_offset(struct kvm_vcpu *vcpu, u64 offset, u64 tsc,
+				 u64 ns, bool matched)
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

