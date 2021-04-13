Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D6AF35E860
	for <lists+kvm@lfdr.de>; Tue, 13 Apr 2021 23:36:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343970AbhDMVhH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Apr 2021 17:37:07 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:43071 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232147AbhDMVhG (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 13 Apr 2021 17:37:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618349805;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=XycHoA1nL8vAycQ/cqP0i1ZIVgjvhSm3zs7dfnDh6ic=;
        b=Fwk3ZpOS2D2ukAFjki80v7Rb1FVU7qDOo/LDqfRf7Hb/6FXj0P+1iOAai7uDFh+tPSd5Rg
        C36c0m7oFUfMWc+KKd8UoWajVn+wL6WOswxZoyUWn7kLJ/VOeBAbpzgr6+tPxIX+d+UXwA
        XwoGSztIJoNh2b5UXp13MisrpSrmEVg=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-18-moc0qm-PO4SwqcEV-doPJQ-1; Tue, 13 Apr 2021 17:36:44 -0400
X-MC-Unique: moc0qm-PO4SwqcEV-doPJQ-1
Received: by mail-qv1-f71.google.com with SMTP id g9so6623119qvi.19
        for <kvm@vger.kernel.org>; Tue, 13 Apr 2021 14:36:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XycHoA1nL8vAycQ/cqP0i1ZIVgjvhSm3zs7dfnDh6ic=;
        b=U+AI0wKT5lRu0t5f432Gzv4Q1jtCnr5DnpLSe30PEolC5IHmCNi1rRQ9LcLtK2oB6Z
         KiFtZPxnVnwvq5re+fUUl8llzQsUSS7RqG27S/hE8XTNVGJ+hcUZNQ3RTsykvXSU5ShK
         6TvuN98Og0YwhJceVKtXyiLRx4BIsEiI6REQg+FmqHsOBhtl3/l13maC9SgZY1Uw6Gik
         uCu4Mk0DmH3KMdthfq4oMscNYNMd8DK3+tqn5eAAmLl90hgFR5oCad5ikvkVtZy1v5xA
         kT80phVt7rTZE9kWziis5oQ9EFMrrF29HIPobUqXm8u+ZJG47c40H2uwht+4qGtIiNrs
         mBcQ==
X-Gm-Message-State: AOAM53125St4Ph3Yr/hNvOC6Rn/wdmUjnOr4AM8eOyUHki9ms5CRdhvT
        dycoB5qJ1hKvzUfdOGWEDr/4f2rv++QU7nMtc2r2uZ3YiDnm+pQIdFeJC/7OPVb848jCDEGsBia
        TIN7m7OkZ3EsQNHeWtcLoxlB/zj+GTWjFR5euxlMSgjmh7JZ99Wjv/JY5MJiolQ==
X-Received: by 2002:ae9:f719:: with SMTP id s25mr34512460qkg.42.1618349803789;
        Tue, 13 Apr 2021 14:36:43 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwLEpeasSayGgW415t75h7+UXOGP3qXino9298zZjgJ7RCJAr3cBVoCtVcWn54NfLNGHB0teQ==
X-Received: by 2002:ae9:f719:: with SMTP id s25mr34512434qkg.42.1618349803507;
        Tue, 13 Apr 2021 14:36:43 -0700 (PDT)
Received: from xz-x1.redhat.com (bras-base-toroon474qw-grc-88-174-93-75-154.dsl.bell.ca. [174.93.75.154])
        by smtp.gmail.com with ESMTPSA id p10sm7206792qtl.17.2021.04.13.14.36.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Apr 2021 14:36:42 -0700 (PDT)
From:   Peter Xu <peterx@redhat.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     peterx@redhat.com, Andrew Jones <drjones@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Subject: [PATCH v2] kvm/selftests: Fix race condition with dirty_log_test
Date:   Tue, 13 Apr 2021 17:36:41 -0400
Message-Id: <20210413213641.23742-1-peterx@redhat.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This fixes a bug that can trigger with e.g. "taskset -c 0 ./dirty_log_test" or
when the testing host is very busy.

The issue is when the vcpu thread got the dirty bit set but got preempted by
other threads _before_ the data is written, we won't be able to see the latest
data only until the vcpu threads do VMENTER. IOW, the guest write operation and
dirty bit set cannot guarantee atomicity. The race could look like:

    main thread                            vcpu thread
    ===========                            ===========
    iteration=X
                                           *addr = X
                                           (so latest data is X)
    iteration=X+1
    ...
    iteration=X+N
                                           guest executes "*addr = X+N"
                                             reg=READ_ONCE(iteration)=X+N
                                             host page fault
                                               set dirty bit for page "addr"
                                             (_before_ VMENTER happens...
                                              so *addr is still X!)
                                           vcpu thread got preempted
    get dirty log
    verify data
      detected dirty bit set, data is X
      not X+N nor X+N-1, data too old!

This patch closes this race by allowing the main thread to give the vcpu thread
chance to do a VMENTER to complete that write operation.  It's done by adding a
vcpu loop counter (must be defined as volatile as main thread will do read
loop), then the main thread can guarantee the vcpu got at least another VMENTER
by making sure the guest_vcpu_loops increases by 2.

Dirty ring does not need this since dirty_ring_last_page would already help
avoid this specific race condition.

Cc: Andrew Jones <drjones@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>
Signed-off-by: Peter Xu <peterx@redhat.com>
---
v2:
- drop one unnecessary check on "!matched"
---
 tools/testing/selftests/kvm/dirty_log_test.c | 53 +++++++++++++++++++-
 1 file changed, 52 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/dirty_log_test.c b/tools/testing/selftests/kvm/dirty_log_test.c
index bb2752d78fe3..b639f088bb86 100644
--- a/tools/testing/selftests/kvm/dirty_log_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_test.c
@@ -160,6 +160,10 @@ static bool dirty_ring_vcpu_ring_full;
  * verifying process, we let it pass.
  */
 static uint64_t dirty_ring_last_page;
+/*
+ * Record how many loops the guest vcpu thread has went through
+ */
+static volatile uint64_t guest_vcpu_loops;
 
 enum log_mode_t {
 	/* Only use KVM_GET_DIRTY_LOG for logging */
@@ -526,6 +530,7 @@ static void *vcpu_worker(void *data)
 			assert(sig == SIG_IPI);
 		}
 		log_mode_after_vcpu_run(vm, ret, errno);
+		guest_vcpu_loops++;
 	}
 
 	pr_info("Dirtied %"PRIu64" pages\n", pages_count);
@@ -553,6 +558,7 @@ static void vm_dirty_log_verify(enum vm_guest_mode mode, unsigned long *bmap)
 		}
 
 		if (test_and_clear_bit_le(page, bmap)) {
+			uint64_t current_loop;
 			bool matched;
 
 			host_dirty_count++;
@@ -565,7 +571,12 @@ static void vm_dirty_log_verify(enum vm_guest_mode mode, unsigned long *bmap)
 			matched = (*value_ptr == iteration ||
 				   *value_ptr == iteration - 1);
 
-			if (host_log_mode == LOG_MODE_DIRTY_RING && !matched) {
+			if (matched)
+				continue;
+
+			/* Didn't match..  Let's figure out what's wrong.. */
+			switch (host_log_mode) {
+			case LOG_MODE_DIRTY_RING:
 				if (*value_ptr == iteration - 2 && min_iter <= iteration - 2) {
 					/*
 					 * Short answer: this case is special
@@ -608,6 +619,46 @@ static void vm_dirty_log_verify(enum vm_guest_mode mode, unsigned long *bmap)
 					 */
 					continue;
 				}
+				break;
+			case LOG_MODE_DIRTY_LOG:
+			case LOG_MODE_CLEAR_LOG:
+				/*
+				 * This fixes a bug that can trigger with
+				 * e.g. "taskset -c 0 ./dirty_log_test" or when
+				 * the testing host is very busy, when the vcpu
+				 * thread got the dirty bit set but got
+				 * preempted by other threads _before_ the data
+				 * is written, so we won't be able to see the
+				 * latest data only until the vcpu threads do
+				 * VMENTER and the write finally lands to the
+				 * memory.  So when !matched happened, we give
+				 * the vcpu thread _one_ more chance to do a
+				 * VMENTER so as to flush the written data.  We
+				 * do that by observing guest_vcpu_loops to
+				 * increase +2: as +1 is not enough to
+				 * guarantee a complete VMENTER.
+				 *
+				 * Dirty ring does not need this since
+				 * dirty_ring_last_page would already help
+				 * avoid it.
+				 */
+				current_loop = guest_vcpu_loops;
+
+				/*
+				 * Wait until the vcpu thread at least
+				 * completes one VMENTER again.  the usleep()
+				 * gives the vcpu thread a better chance to be
+				 * scheduled earlier.
+				 */
+				while (guest_vcpu_loops <= current_loop + 2)
+					usleep(1);
+				/* Recalculate */
+				matched = (*value_ptr == iteration ||
+					   *value_ptr == iteration - 1);
+				break;
+			default:
+				/* Just to avoid some strict compile warning */
+				break;
 			}
 
 			TEST_ASSERT(matched,
-- 
2.26.2

