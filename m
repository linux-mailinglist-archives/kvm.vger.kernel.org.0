Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B13DD28697F
	for <lists+kvm@lfdr.de>; Wed,  7 Oct 2020 22:54:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728515AbgJGUyb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Oct 2020 16:54:31 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:41097 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728563AbgJGUyE (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 7 Oct 2020 16:54:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602104042;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1Frsr00VTIsYjdqDeTzSRco7BaTYBstaIvbV6rdyHlg=;
        b=iB/zih69Bir3ZgajNv41qKiA4B2URNwEyOYZzZLIN7wyuqDhf0y0RwfWzU9iIeQ5GQtRGG
        fGS8FNr/O5ri9F+RCZy85J+nSr9peB0VHrU/Npw9oodYBc1UGkXVLTBVkJUEkKZ44hi7FZ
        c1gTHWIQhCDdDlynGoed1ibW4OPi9sI=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-219-EOIN2D5-N-qQxevOdw6lOQ-1; Wed, 07 Oct 2020 16:54:00 -0400
X-MC-Unique: EOIN2D5-N-qQxevOdw6lOQ-1
Received: by mail-qk1-f200.google.com with SMTP id y17so2233219qkf.15
        for <kvm@vger.kernel.org>; Wed, 07 Oct 2020 13:53:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1Frsr00VTIsYjdqDeTzSRco7BaTYBstaIvbV6rdyHlg=;
        b=S3+dNuXLrpmM/delb4UWtl+nN3w/PAf+yX5aRAuhx+vzFyYUd7mtWG6LPpPr1/jcyO
         /hJK4ndwfdTWnuJ5VHTKUBFgdu9Ss4qT79ciSx7AYuJ8PHIokQ/em9wOJHE1pQJ7rtIL
         OX3HOjB7RpHZSMAL76C5OjfBpsJBd59Co/QmGNYVhS3ZZRSRkcdHebJORIFyniZdz77a
         DEbkhYHv7khXHlpUOr9ocmTuBf4B96JcLn3hDFFZvDU0TftNJvg7PeIUEMNGfxuYt5JS
         AOdhMqjmRnb6D2lFTCXgCqiKsv5ICGztZ811XS30/5/f0T1w9fmvDmDvFsvYvTmNU0lb
         ZWcw==
X-Gm-Message-State: AOAM531I4Qc6nXtJ8zYLi88BVi10c1SrdanrCSmYf1tjEET7Ck4klf5D
        1YHfEY5ziC38wrNEc9ay7IZ+GdymK6LM4OsKWK8X3Ykcjo31p2EoITSOtyZx3iG1Xct/j3RfRhe
        mMba40rbJrVoG
X-Received: by 2002:a37:e214:: with SMTP id g20mr4648536qki.89.1602104039213;
        Wed, 07 Oct 2020 13:53:59 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxnCWXc1dVr/x9PO+/SDm98Ewk+coLCULpc9xT+rRiANsqyXff2wCecBJWRV0kfSlgHfw7neQ==
X-Received: by 2002:a37:e214:: with SMTP id g20mr4648516qki.89.1602104038989;
        Wed, 07 Oct 2020 13:53:58 -0700 (PDT)
Received: from xz-x1.redhat.com (toroon474qw-lp140-04-174-95-215-133.dsl.bell.ca. [174.95.215.133])
        by smtp.gmail.com with ESMTPSA id j24sm2390695qkg.107.2020.10.07.13.53.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Oct 2020 13:53:58 -0700 (PDT)
From:   Peter Xu <peterx@redhat.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     peterx@redhat.com, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Andrew Jones <drjones@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>
Subject: [PATCH v14 11/14] KVM: selftests: Introduce after_vcpu_run hook for dirty log test
Date:   Wed,  7 Oct 2020 16:53:39 -0400
Message-Id: <20201007205342.295402-12-peterx@redhat.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201007205342.295402-1-peterx@redhat.com>
References: <20201007205342.295402-1-peterx@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Provide a hook for the checks after vcpu_run() completes.  Preparation
for the dirty ring test because we'll need to take care of another
exit reason.

Reviewed-by: Andrew Jones <drjones@redhat.com>
Signed-off-by: Peter Xu <peterx@redhat.com>
---
 tools/testing/selftests/kvm/dirty_log_test.c | 36 +++++++++++++-------
 1 file changed, 24 insertions(+), 12 deletions(-)

diff --git a/tools/testing/selftests/kvm/dirty_log_test.c b/tools/testing/selftests/kvm/dirty_log_test.c
index 139ccb550618..a2160946bcf5 100644
--- a/tools/testing/selftests/kvm/dirty_log_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_test.c
@@ -178,6 +178,15 @@ static void clear_log_collect_dirty_pages(struct kvm_vm *vm, int slot,
 	kvm_vm_clear_dirty_log(vm, slot, bitmap, 0, num_pages);
 }
 
+static void default_after_vcpu_run(struct kvm_vm *vm)
+{
+	struct kvm_run *run = vcpu_state(vm, VCPU_ID);
+
+	TEST_ASSERT(get_ucall(vm, VCPU_ID, NULL) == UCALL_SYNC,
+		    "Invalid guest sync status: exit_reason=%s\n",
+		    exit_reason_str(run->exit_reason));
+}
+
 struct log_mode {
 	const char *name;
 	/* Return true if this mode is supported, otherwise false */
@@ -187,16 +196,20 @@ struct log_mode {
 	/* Hook to collect the dirty pages into the bitmap provided */
 	void (*collect_dirty_pages) (struct kvm_vm *vm, int slot,
 				     void *bitmap, uint32_t num_pages);
+	/* Hook to call when after each vcpu run */
+	void (*after_vcpu_run)(struct kvm_vm *vm);
 } log_modes[LOG_MODE_NUM] = {
 	{
 		.name = "dirty-log",
 		.collect_dirty_pages = dirty_log_collect_dirty_pages,
+		.after_vcpu_run = default_after_vcpu_run,
 	},
 	{
 		.name = "clear-log",
 		.supported = clear_log_supported,
 		.create_vm_done = clear_log_create_vm_done,
 		.collect_dirty_pages = clear_log_collect_dirty_pages,
+		.after_vcpu_run = default_after_vcpu_run,
 	},
 };
 
@@ -247,6 +260,14 @@ static void log_mode_collect_dirty_pages(struct kvm_vm *vm, int slot,
 	mode->collect_dirty_pages(vm, slot, bitmap, num_pages);
 }
 
+static void log_mode_after_vcpu_run(struct kvm_vm *vm)
+{
+	struct log_mode *mode = &log_modes[host_log_mode];
+
+	if (mode->after_vcpu_run)
+		mode->after_vcpu_run(vm);
+}
+
 static void generate_random_array(uint64_t *guest_array, uint64_t size)
 {
 	uint64_t i;
@@ -261,25 +282,16 @@ static void *vcpu_worker(void *data)
 	struct kvm_vm *vm = data;
 	uint64_t *guest_array;
 	uint64_t pages_count = 0;
-	struct kvm_run *run;
-
-	run = vcpu_state(vm, VCPU_ID);
 
 	guest_array = addr_gva2hva(vm, (vm_vaddr_t)random_array);
-	generate_random_array(guest_array, TEST_PAGES_PER_LOOP);
 
 	while (!READ_ONCE(host_quit)) {
+		generate_random_array(guest_array, TEST_PAGES_PER_LOOP);
+		pages_count += TEST_PAGES_PER_LOOP;
 		/* Let the guest dirty the random pages */
 		ret = _vcpu_run(vm, VCPU_ID);
 		TEST_ASSERT(ret == 0, "vcpu_run failed: %d\n", ret);
-		if (get_ucall(vm, VCPU_ID, NULL) == UCALL_SYNC) {
-			pages_count += TEST_PAGES_PER_LOOP;
-			generate_random_array(guest_array, TEST_PAGES_PER_LOOP);
-		} else {
-			TEST_FAIL("Invalid guest sync status: "
-				  "exit_reason=%s\n",
-				  exit_reason_str(run->exit_reason));
-		}
+		log_mode_after_vcpu_run(vm);
 	}
 
 	pr_info("Dirtied %"PRIu64" pages\n", pages_count);
-- 
2.26.2

