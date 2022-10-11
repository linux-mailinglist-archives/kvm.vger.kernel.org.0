Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3E485FAC77
	for <lists+kvm@lfdr.de>; Tue, 11 Oct 2022 08:17:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229717AbiJKGRt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Oct 2022 02:17:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229662AbiJKGRj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Oct 2022 02:17:39 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CC17870B7
        for <kvm@vger.kernel.org>; Mon, 10 Oct 2022 23:17:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1665469057;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cNQilMgvXDneE1h9HbtAPKvGFLnkNGwhukg91aqJDGY=;
        b=TnvRyYc0QA3qjwGGN43V1kxt25mmJvQF3pcCkPBhUbCOfRif6q4IOk/K3Yd0ul0HaXBRva
        W9jQ5hFxNw8C4DYYz/tTgDkqnohaKR3t0ifxcgZ3VMs8htOZVbq1pi047hV8caga/W/lQG
        MHLA3ww8wbIqoAkKKPVfq6ByaEgVR6Q=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-626-uxJukNkYMemuZnO23yzMxg-1; Tue, 11 Oct 2022 02:17:34 -0400
X-MC-Unique: uxJukNkYMemuZnO23yzMxg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 92F531C08967;
        Tue, 11 Oct 2022 06:17:33 +0000 (UTC)
Received: from gshan.redhat.com (vpn2-54-52.bne.redhat.com [10.64.54.52])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 71170112D402;
        Tue, 11 Oct 2022 06:17:27 +0000 (UTC)
From:   Gavin Shan <gshan@redhat.com>
To:     kvmarm@lists.linux.dev
Cc:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        peterx@redhat.com, maz@kernel.org, will@kernel.org,
        catalin.marinas@arm.com, bgardon@google.com, shuah@kernel.org,
        andrew.jones@linux.dev, dmatlack@google.com, pbonzini@redhat.com,
        zhenyzha@redhat.com, james.morse@arm.com, suzuki.poulose@arm.com,
        alexandru.elisei@arm.com, oliver.upton@linux.dev,
        seanjc@google.com, shan.gavin@gmail.com
Subject: [PATCH v6 7/8] KVM: selftests: Clear dirty ring states between two modes in dirty_log_test
Date:   Tue, 11 Oct 2022 14:14:46 +0800
Message-Id: <20221011061447.131531-8-gshan@redhat.com>
In-Reply-To: <20221011061447.131531-1-gshan@redhat.com>
References: <20221011061447.131531-1-gshan@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

There are two states, which need to be cleared before next mode
is executed. Otherwise, we will hit failure as the following messages
indicate.

- The variable 'dirty_ring_vcpu_ring_full' shared by main and vcpu
  thread. It's indicating if the vcpu exit due to full ring buffer.
  The value can be carried from previous mode (VM_MODE_P40V48_4K) to
  current one (VM_MODE_P40V48_64K) when VM_MODE_P40V48_16K isn't
  supported.

- The current ring buffer index needs to be reset before next mode
  (VM_MODE_P40V48_64K) is executed. Otherwise, the stale value is
  carried from previous mode (VM_MODE_P40V48_4K).

  # ./dirty_log_test -M dirty-ring
  Setting log mode to: 'dirty-ring'
  Test iterations: 32, interval: 10 (ms)
  Testing guest mode: PA-bits:40,  VA-bits:48,  4K pages
  guest physical test memory offset: 0xffbfffc000
    :
  Dirtied 995328 pages
  Total bits checked: dirty (1012434), clear (7114123), track_next (966700)
  Testing guest mode: PA-bits:40,  VA-bits:48, 64K pages
  guest physical test memory offset: 0xffbffc0000
  vcpu stops because vcpu is kicked out...
  vcpu continues now.
  Notifying vcpu to continue
  Iteration 1 collected 0 pages
  vcpu stops because dirty ring is full...
  vcpu continues now.
  vcpu stops because dirty ring is full...
  vcpu continues now.
  vcpu stops because dirty ring is full...
  ==== Test Assertion Failure ====
  dirty_log_test.c:369: cleared == count
  pid=10541 tid=10541 errno=22 - Invalid argument
     1	0x0000000000403087: dirty_ring_collect_dirty_pages at dirty_log_test.c:369
     2	0x0000000000402a0b: log_mode_collect_dirty_pages at dirty_log_test.c:492
     3	 (inlined by) run_test at dirty_log_test.c:795
     4	 (inlined by) run_test at dirty_log_test.c:705
     5	0x0000000000403a37: for_each_guest_mode at guest_modes.c:100
     6	0x0000000000401ccf: main at dirty_log_test.c:938
     7	0x0000ffff9ecd279b: ?? ??:0
     8	0x0000ffff9ecd286b: ?? ??:0
     9	0x0000000000401def: _start at ??:?
  Reset dirty pages (0) mismatch with collected (35566)

Fix the issues by clearing 'dirty_ring_vcpu_ring_full' and the ring
buffer index before next new mode is to be executed.

Signed-off-by: Gavin Shan <gshan@redhat.com>
---
 tools/testing/selftests/kvm/dirty_log_test.c | 27 ++++++++++++--------
 1 file changed, 17 insertions(+), 10 deletions(-)

diff --git a/tools/testing/selftests/kvm/dirty_log_test.c b/tools/testing/selftests/kvm/dirty_log_test.c
index b5234d6efbe1..8758c10ec850 100644
--- a/tools/testing/selftests/kvm/dirty_log_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_test.c
@@ -226,13 +226,15 @@ static void clear_log_create_vm_done(struct kvm_vm *vm)
 }
 
 static void dirty_log_collect_dirty_pages(struct kvm_vcpu *vcpu, int slot,
-					  void *bitmap, uint32_t num_pages)
+					  void *bitmap, uint32_t num_pages,
+					  uint32_t *unused)
 {
 	kvm_vm_get_dirty_log(vcpu->vm, slot, bitmap);
 }
 
 static void clear_log_collect_dirty_pages(struct kvm_vcpu *vcpu, int slot,
-					  void *bitmap, uint32_t num_pages)
+					  void *bitmap, uint32_t num_pages,
+					  uint32_t *unused)
 {
 	kvm_vm_get_dirty_log(vcpu->vm, slot, bitmap);
 	kvm_vm_clear_dirty_log(vcpu->vm, slot, bitmap, 0, num_pages);
@@ -329,10 +331,9 @@ static void dirty_ring_continue_vcpu(void)
 }
 
 static void dirty_ring_collect_dirty_pages(struct kvm_vcpu *vcpu, int slot,
-					   void *bitmap, uint32_t num_pages)
+					   void *bitmap, uint32_t num_pages,
+					   uint32_t *ring_buf_idx)
 {
-	/* We only have one vcpu */
-	static uint32_t fetch_index = 0;
 	uint32_t count = 0, cleared;
 	bool continued_vcpu = false;
 
@@ -349,7 +350,8 @@ static void dirty_ring_collect_dirty_pages(struct kvm_vcpu *vcpu, int slot,
 
 	/* Only have one vcpu */
 	count = dirty_ring_collect_one(vcpu_map_dirty_ring(vcpu),
-				       slot, bitmap, num_pages, &fetch_index);
+				       slot, bitmap, num_pages,
+				       ring_buf_idx);
 
 	cleared = kvm_vm_reset_dirty_ring(vcpu->vm);
 
@@ -406,7 +408,8 @@ struct log_mode {
 	void (*create_vm_done)(struct kvm_vm *vm);
 	/* Hook to collect the dirty pages into the bitmap provided */
 	void (*collect_dirty_pages) (struct kvm_vcpu *vcpu, int slot,
-				     void *bitmap, uint32_t num_pages);
+				     void *bitmap, uint32_t num_pages,
+				     uint32_t *ring_buf_idx);
 	/* Hook to call when after each vcpu run */
 	void (*after_vcpu_run)(struct kvm_vcpu *vcpu, int ret, int err);
 	void (*before_vcpu_join) (void);
@@ -471,13 +474,14 @@ static void log_mode_create_vm_done(struct kvm_vm *vm)
 }
 
 static void log_mode_collect_dirty_pages(struct kvm_vcpu *vcpu, int slot,
-					 void *bitmap, uint32_t num_pages)
+					 void *bitmap, uint32_t num_pages,
+					 uint32_t *ring_buf_idx)
 {
 	struct log_mode *mode = &log_modes[host_log_mode];
 
 	TEST_ASSERT(mode->collect_dirty_pages != NULL,
 		    "collect_dirty_pages() is required for any log mode!");
-	mode->collect_dirty_pages(vcpu, slot, bitmap, num_pages);
+	mode->collect_dirty_pages(vcpu, slot, bitmap, num_pages, ring_buf_idx);
 }
 
 static void log_mode_after_vcpu_run(struct kvm_vcpu *vcpu, int ret, int err)
@@ -696,6 +700,7 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 	struct kvm_vcpu *vcpu;
 	struct kvm_vm *vm;
 	unsigned long *bmap;
+	uint32_t ring_buf_idx = 0;
 
 	if (!log_mode_supported()) {
 		print_skip("Log mode '%s' not supported",
@@ -771,6 +776,7 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 	host_dirty_count = 0;
 	host_clear_count = 0;
 	host_track_next_count = 0;
+	WRITE_ONCE(dirty_ring_vcpu_ring_full, false);
 
 	pthread_create(&vcpu_thread, NULL, vcpu_worker, vcpu);
 
@@ -778,7 +784,8 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 		/* Give the vcpu thread some time to dirty some pages */
 		usleep(p->interval * 1000);
 		log_mode_collect_dirty_pages(vcpu, TEST_MEM_SLOT_INDEX,
-					     bmap, host_num_pages);
+					     bmap, host_num_pages,
+					     &ring_buf_idx);
 
 		/*
 		 * See vcpu_sync_stop_requested definition for details on why
-- 
2.23.0

