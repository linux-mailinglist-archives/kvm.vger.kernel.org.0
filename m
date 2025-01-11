Return-Path: <kvm+bounces-35148-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A00B3A09F54
	for <lists+kvm@lfdr.de>; Sat, 11 Jan 2025 01:30:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 56CB57A2FB5
	for <lists+kvm@lfdr.de>; Sat, 11 Jan 2025 00:30:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D735F1CFBC;
	Sat, 11 Jan 2025 00:30:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fQ/mviTB"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1CED8479
	for <kvm@vger.kernel.org>; Sat, 11 Jan 2025 00:30:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736555413; cv=none; b=TWVp3jC+X1vGgrxg86KR9x7BWk3WY9F+ayZMyXtqPBwu4AruICDHCkhU44WzFhh5E0SShQI1aUL33hisXP7y++IEB33MFv7oHwSLUzQQh94zUhUUaatPBopKufIuIGG5RIgY2ycp7UxzA5b2KwPK1cSYis1ODLB2cxQn57nxVtg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736555413; c=relaxed/simple;
	bh=cSnwUK/2rXGD+rrAuQ2cWaSYdAoHz1OuzoU7A8Ugyzw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=mZvlSN/z5mCKscRcaVStjpKDNPhCL7530JrIjPWkF3OZB8r4+jkGg3MxxcWJQwRwXHa6qn4c05tzoRKsA/33mM+1ADRAeKT387tqQidssmVEo3v67weBrNzITv0qLz+cTrEH1lvsf9kJfUqroKCc4l43CXP523pHKnOYazOdbqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=fQ/mviTB; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2ef9204f898so4595298a91.2
        for <kvm@vger.kernel.org>; Fri, 10 Jan 2025 16:30:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1736555411; x=1737160211; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=FDkeem6MqewIEXRWoJcJJSDt8+RewhtQwmeUHyoVvwQ=;
        b=fQ/mviTB+vc0gMRH8aZt7HJpEhBjxP3GqCHJtTA/E1bNwa61Gkum1Xkix5M0VRenYK
         fHIyoqb29IXLZzpUcxEUYU8rQwC/jdxsprtwRjJipQUibJoCLudZOPpBl4n4oaEaGXn9
         LwBWZo6rp6kkHtgfEoAYoYwHmkasZjZ/sV2FO3PmDIylZH3xcqr0WJo21kVTandEMb2j
         3RqOzUID1Hqg9SH3tK1DMaKKwW12nX7XZs00PFN6l74gA3pEln9aUTK8DPvElL1uRHpa
         YEidLcjS1I89kHXXn9Ekvy9gwNpwRAljkXwj3BOWOxF9oo5i+wxbpW4206e85y5aY6e+
         ClZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736555411; x=1737160211;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FDkeem6MqewIEXRWoJcJJSDt8+RewhtQwmeUHyoVvwQ=;
        b=hfmbbvZkZxGiTUodPDJI18KVzhpzHahlyyaqs/A0uqalTiARmnZl8CA85Bz9QD4UBz
         HMX5LwyA5Ej0fqYbHubQf+6gA6wbN1tZfmYTaTOFyO2WfEkQrqrOM8H76uZu5p/XrNr7
         xED/Pc1K0Z3CltXY/p4GonzUZ6eybrEgKzVLmq5BgUFdylPZIEdZzwqpkJgNvdWhgBrO
         8W6AsSPa2zMQd7AvgDCbD0Nlqcx00JesrINBxgBFUM8amkethTigTMSplbb98gDmBUml
         auwHgOlGTBoCtvIFPYn0qgYHnf/Ofe4syDBnoCE37YDv15HkKGOuRBqIe01wIm7J6WVk
         TdLA==
X-Gm-Message-State: AOJu0YwI5THW0i4maZdVjC8i4B3XRFRtAgb/SqL8uMETZFMhPNX4jv0F
	6mzU4u8fndDVGL9PaJI2l+nt4AOI4OcBumLBpRdS8UXaDQ7A5bvwBIKL2PURaqXA6MTf3uM1bMG
	SaA==
X-Google-Smtp-Source: AGHT+IFl9e/CO6aIFQMtlWws0maKnM0IkLVkQ0R6MTG560dWJ3PE9b2Z/S4xdE96ZH1JQkGfgqN+ePxlgQQ=
X-Received: from pjbqi8.prod.google.com ([2002:a17:90b:2748:b0:2d8:8d32:2ea3])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:5487:b0:2ee:f80c:688d
 with SMTP id 98e67ed59e1d1-2f5490bd537mr18660616a91.25.1736555411003; Fri, 10
 Jan 2025 16:30:11 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 10 Jan 2025 16:29:45 -0800
In-Reply-To: <20250111003004.1235645-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250111003004.1235645-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.1.613.gc27f4b7a9f-goog
Message-ID: <20250111003004.1235645-2-seanjc@google.com>
Subject: [PATCH v2 01/20] KVM: selftests: Support multiple write retires in dirty_log_test
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Peter Xu <peterx@redhat.com>, Maxim Levitsky <mlevitsk@redhat.com>, 
	Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

From: Maxim Levitsky <mlevitsk@redhat.com>

If dirty_log_test is run nested, it is possible for entries in the emulated
PML log to appear before the actual memory write is committed to the RAM,
due to the way KVM retries memory writes as a response to a MMU fault.

In addition to that in some very rare cases retry can happen more than
once, which will lead to the test failure because once the write is
finally committed it may have a very outdated iteration value.

Detect and avoid this case.

Cc: Peter Xu <peterx@redhat.com>
Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/dirty_log_test.c | 52 +++++++++++++++++++-
 1 file changed, 50 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/dirty_log_test.c b/tools/testing/selftests/kvm/dirty_log_test.c
index aacf80f57439..cdae103314fc 100644
--- a/tools/testing/selftests/kvm/dirty_log_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_test.c
@@ -152,6 +152,7 @@ static atomic_t vcpu_sync_stop_requested;
  * sem_vcpu_stop and before vcpu continues to run.
  */
 static bool dirty_ring_vcpu_ring_full;
+
 /*
  * This is only used for verifying the dirty pages.  Dirty ring has a very
  * tricky case when the ring just got full, kvm will do userspace exit due to
@@ -166,7 +167,51 @@ static bool dirty_ring_vcpu_ring_full;
  * dirty gfn we've collected, so that if a mismatch of data found later in the
  * verifying process, we let it pass.
  */
-static uint64_t dirty_ring_last_page;
+static uint64_t dirty_ring_last_page = -1ULL;
+
+/*
+ * In addition to the above, it is possible (especially if this
+ * test is run nested) for the above scenario to repeat multiple times:
+ *
+ * The following can happen:
+ *
+ * - L1 vCPU:        Memory write is logged to PML but not committed.
+ *
+ * - L1 test thread: Ignores the write because its last dirty ring entry
+ *                   Resets the dirty ring which:
+ *                     - Resets the A/D bits in EPT
+ *                     - Issues tlb flush (invept), which is intercepted by L0
+ *
+ * - L0: frees the whole nested ept mmu root as the response to invept,
+ *       and thus ensures that when memory write is retried, it will fault again
+ *
+ * - L1 vCPU:        Same memory write is logged to the PML but not committed again.
+ *
+ * - L1 test thread: Ignores the write because its last dirty ring entry (again)
+ *                   Resets the dirty ring which:
+ *                     - Resets the A/D bits in EPT (again)
+ *                     - Issues tlb flush (again) which is intercepted by L0
+ *
+ * ...
+ *
+ * N times
+ *
+ * - L1 vCPU:        Memory write is logged in the PML and then committed.
+ *                   Lots of other memory writes are logged and committed.
+ * ...
+ *
+ * - L1 test thread: Sees the memory write along with other memory writes
+ *                   in the dirty ring, and since the write is usually not
+ *                   the last entry in the dirty-ring and has a very outdated
+ *                   iteration, the test fails.
+ *
+ *
+ * Note that this is only possible when the write was the last log entry
+ * write during iteration N-1, thus remember last iteration last log entry
+ * and also don't fail when it is reported in the next iteration, together with
+ * an outdated iteration count.
+ */
+static uint64_t dirty_ring_prev_iteration_last_page;
 
 enum log_mode_t {
 	/* Only use KVM_GET_DIRTY_LOG for logging */
@@ -316,6 +361,8 @@ static uint32_t dirty_ring_collect_one(struct kvm_dirty_gfn *dirty_gfns,
 	struct kvm_dirty_gfn *cur;
 	uint32_t count = 0;
 
+	dirty_ring_prev_iteration_last_page = dirty_ring_last_page;
+
 	while (true) {
 		cur = &dirty_gfns[*fetch_index % test_dirty_ring_count];
 		if (!dirty_gfn_is_dirtied(cur))
@@ -613,7 +660,8 @@ static void vm_dirty_log_verify(enum vm_guest_mode mode, unsigned long *bmap)
 					 */
 					min_iter = iteration - 1;
 					continue;
-				} else if (page == dirty_ring_last_page) {
+				} else if (page == dirty_ring_last_page ||
+					   page == dirty_ring_prev_iteration_last_page) {
 					/*
 					 * Please refer to comments in
 					 * dirty_ring_last_page.
-- 
2.47.1.613.gc27f4b7a9f-goog


