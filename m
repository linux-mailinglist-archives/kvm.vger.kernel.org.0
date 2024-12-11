Return-Path: <kvm+bounces-33507-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 644E09ED69F
	for <lists+kvm@lfdr.de>; Wed, 11 Dec 2024 20:38:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A54761885653
	for <lists+kvm@lfdr.de>; Wed, 11 Dec 2024 19:38:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E72D0229666;
	Wed, 11 Dec 2024 19:37:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="djPAPY/5"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57A9A2210EB
	for <kvm@vger.kernel.org>; Wed, 11 Dec 2024 19:37:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733945842; cv=none; b=KEzDL8hwer8laaH41Kk28/Qu1+EQ5MgY+UaLkWa7Kz57Ja9MaXxX4Nk3GHrKBplLy92Ngcu0+/9KEOCujwZfWVXDgoiCTjT1Dx7UEdnLUiWsYtdcAwYgdu2jgyznX3FRJsyBUqAmJpey64k1tWuhPlM5Cok0kud/CzfQEUegHGQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733945842; c=relaxed/simple;
	bh=SKU4owpgrLuU+O36UTv52dBkluhmqyl+EdfAMYBpPRs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=B7GVjdCPDykfN6GKDAtjZO5m8EOrCrDtQmgVlLe32WG4cEpk3eDAXYnbEHyR5XoH48P4HLFkmmoxspHBAvsY1S+O84j03rfovDLBHSkS5egoWZ3fLoW1iPt9bIqc2A0wFlXfs5DbPlsWvqmPA0tYwtSnIuB1H7lVVx6kcqNvms8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=djPAPY/5; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1733945839;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oRbzOlXXgzk56NiVC7qJmmj47BtRpf1glV0jPA4JBGg=;
	b=djPAPY/5bNT6VB/0EhlPfdcun28QbwsVZcMLjF12jAe+JkMuJ7ATozG8/6PD0qX2afEjME
	rzmTpWYyxJ7RM8sPqysFT2QUJatw23lvnuSQjWocL0oLx20uX2Cv0Lfcy3srbsNx/YpTa1
	Rq3twH3WfZuJVh4vNRDcxlLLJeHNy2s=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-588-1xFFN5XpMXe2ml3pKzlnUg-1; Wed,
 11 Dec 2024 14:37:17 -0500
X-MC-Unique: 1xFFN5XpMXe2ml3pKzlnUg-1
X-Mimecast-MFC-AGG-ID: 1xFFN5XpMXe2ml3pKzlnUg
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 501C11944B11;
	Wed, 11 Dec 2024 19:37:16 +0000 (UTC)
Received: from starship.lan (unknown [10.22.82.46])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id EB1FC1956052;
	Wed, 11 Dec 2024 19:37:14 +0000 (UTC)
From: Maxim Levitsky <mlevitsk@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kselftest@vger.kernel.org,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	linux-kernel@vger.kernel.org,
	x86@kernel.org,
	Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH 4/4] KVM: selftests: dirty_log_test: support multiple write retires
Date: Wed, 11 Dec 2024 14:37:06 -0500
Message-Id: <20241211193706.469817-5-mlevitsk@redhat.com>
In-Reply-To: <20241211193706.469817-1-mlevitsk@redhat.com>
References: <20241211193706.469817-1-mlevitsk@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

If dirty_log_test is run nested, it is possible for entries in the emulated
PML log to appear before the actual memory write is committed to the RAM,
due to the way KVM retries memory writes as a response to a MMU fault.

In addition to that in some very rare cases retry can happen more than
once, which will lead to the test failure because once the write is
finally committed it may have a very outdated iteration value.

Detect and avoid this case.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 tools/testing/selftests/kvm/dirty_log_test.c | 52 +++++++++++++++++++-
 1 file changed, 50 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/dirty_log_test.c b/tools/testing/selftests/kvm/dirty_log_test.c
index a9428076a681..f07126b0205d 100644
--- a/tools/testing/selftests/kvm/dirty_log_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_test.c
@@ -154,6 +154,7 @@ static atomic_t vcpu_sync_stop_requested;
  * sem_vcpu_stop and before vcpu continues to run.
  */
 static bool dirty_ring_vcpu_ring_full;
+
 /*
  * This is only used for verifying the dirty pages.  Dirty ring has a very
  * tricky case when the ring just got full, kvm will do userspace exit due to
@@ -168,7 +169,51 @@ static bool dirty_ring_vcpu_ring_full;
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
@@ -320,6 +365,8 @@ static uint32_t dirty_ring_collect_one(struct kvm_dirty_gfn *dirty_gfns,
 	struct kvm_dirty_gfn *cur;
 	uint32_t count = 0;
 
+	dirty_ring_prev_iteration_last_page = dirty_ring_last_page;
+
 	while (true) {
 		cur = &dirty_gfns[*fetch_index % test_dirty_ring_count];
 		if (!dirty_gfn_is_dirtied(cur))
@@ -622,7 +669,8 @@ static void vm_dirty_log_verify(enum vm_guest_mode mode, unsigned long *bmap)
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
2.26.3


