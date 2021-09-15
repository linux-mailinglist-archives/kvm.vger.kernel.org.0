Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C68C540CEDD
	for <lists+kvm@lfdr.de>; Wed, 15 Sep 2021 23:30:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232477AbhIOVcE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Sep 2021 17:32:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232414AbhIOVcD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Sep 2021 17:32:03 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A9BEC061575
        for <kvm@vger.kernel.org>; Wed, 15 Sep 2021 14:30:44 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id u3-20020a17090abb0300b0019567f8a277so2751791pjr.1
        for <kvm@vger.kernel.org>; Wed, 15 Sep 2021 14:30:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=CCDBZYAQDpjPhsx32bz+fsrJPbE5p59+tr7peUsTU40=;
        b=Ar0uOkXmbWXRjFq9R3LaJwRIQng3qc7bksvsj4KmOKt+cvmmvlW/W1Eb0O0WzWsFw4
         ZN7rsli1nWW7r7dVSfBBwB/tEij5hE7OeQQloQGdeqt7ZAUHCF6fkELFp9LetstVd5ZO
         yAyRJj/Zqtg7tgkwOzfGDpF2v7tZDhaYTFBoyfPIxBk8PFDQGAtOZ7t9hpfYu9yxslYX
         LaA56OyMzkqaaaDH+Pa8MNEPmm+dsAQvOczIYQm1rA9Ic+Mw8/Dd1EL2eShQzZkT4cvw
         aSlMfCS1dVTB2yt9MApMS+NjwEN4AQVW9vO35G9Ggdu21Mw58FGk+6XTKS0MnF2iSAz8
         GhVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=CCDBZYAQDpjPhsx32bz+fsrJPbE5p59+tr7peUsTU40=;
        b=Q0WY6TNAuB6IfjWOq/WY7nX5ceaBmt1RClflhFRqMVbYlmyAiZ1ajEFcdJ2bZ2OYzC
         nX/S8gm8XOBKPv1+2cN6uUeOcF3v15jWkrPacGJQ0hwivZRb9Su2ZgsQ87nFDzX688B1
         aAIpvQ7PZVPN5Sl+ijmUuSBTDjkjNPG4jF7lcfAeX6yVPjSCo2Vv/h1RK1HIuAbqO5XX
         GCkxpbGjuF0VSup9UUsz9SCKNA5uWJHwyqR/1uM7do5vDkA7MYOEtLGvplN8pu41wRJb
         trYG8FZfsNZLUsUbMn+bZS1d3cKFPERmu+F3SirPEDWGOUoBAVCNWv3mAxoKhL7iApU8
         ZuVQ==
X-Gm-Message-State: AOAM531C2bNx4bjF/3anXsvGzriuMiIzzpCgFb28l5/fFELNhoso21gy
        unowrZ8VUu7A9ex5RXP4kSf+mV5w+SgXYQ==
X-Google-Smtp-Source: ABdhPJz1oSa+PVP4UnSwrC8YAARyTN1ZQrffQC55eqVDzfPaz/84TTifwOEpMylDLhepyByKsa9BwAr3A536qg==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a17:90b:33c8:: with SMTP id
 lk8mr10756920pjb.241.1631741443698; Wed, 15 Sep 2021 14:30:43 -0700 (PDT)
Date:   Wed, 15 Sep 2021 21:30:34 +0000
In-Reply-To: <20210915213034.1613552-1-dmatlack@google.com>
Message-Id: <20210915213034.1613552-4-dmatlack@google.com>
Mime-Version: 1.0
References: <20210915213034.1613552-1-dmatlack@google.com>
X-Mailer: git-send-email 2.33.0.309.g3052b89438-goog
Subject: [PATCH 3/3] KVM: selftests: Fix dirty bitmap offset calculation
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Andrew Jones <drjones@redhat.com>,
        Ben Gardon <bgardon@google.com>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Yanan Wang <wangyanan55@huawei.com>,
        David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The calculation to get the per-slot dirty bitmap was incorrect leading
to a buffer overrun. Fix it by dividing the number of pages by
BITS_PER_LONG, since each element of the bitmap is a long and there is
one bit per page.

Fixes: 609e6202ea5f ("KVM: selftests: Support multiple slots in dirty_log_perf_test")
Signed-off-by: David Matlack <dmatlack@google.com>
---
 tools/testing/selftests/kvm/dirty_log_perf_test.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/dirty_log_perf_test.c b/tools/testing/selftests/kvm/dirty_log_perf_test.c
index 5ad9f2bc7369..0dd4626571e9 100644
--- a/tools/testing/selftests/kvm/dirty_log_perf_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_perf_test.c
@@ -118,6 +118,12 @@ static inline void disable_dirty_logging(struct kvm_vm *vm, int slots)
 	toggle_dirty_logging(vm, slots, false);
 }
 
+static unsigned long *get_slot_bitmap(unsigned long *bitmap, uint64_t page_offset)
+{
+	/* Guaranteed to be evenly divisible by the TEST_ASSERT in run_test. */
+	return &bitmap[page_offset / BITS_PER_LONG];
+}
+
 static void get_dirty_log(struct kvm_vm *vm, int slots, unsigned long *bitmap,
 			  uint64_t nr_pages)
 {
@@ -126,7 +132,8 @@ static void get_dirty_log(struct kvm_vm *vm, int slots, unsigned long *bitmap,
 
 	for (i = 0; i < slots; i++) {
 		int slot = PERF_TEST_MEM_SLOT_INDEX + i;
-		unsigned long *slot_bitmap = bitmap + i * slot_pages;
+		uint64_t page_offset = slot_pages * i;
+		unsigned long *slot_bitmap = get_slot_bitmap(bitmap, page_offset);
 
 		kvm_vm_get_dirty_log(vm, slot, slot_bitmap);
 	}
@@ -140,7 +147,8 @@ static void clear_dirty_log(struct kvm_vm *vm, int slots, unsigned long *bitmap,
 
 	for (i = 0; i < slots; i++) {
 		int slot = PERF_TEST_MEM_SLOT_INDEX + i;
-		unsigned long *slot_bitmap = bitmap + i * slot_pages;
+		uint64_t page_offset = slot_pages * i;
+		unsigned long *slot_bitmap = get_slot_bitmap(bitmap, page_offset);
 
 		kvm_vm_clear_dirty_log(vm, slot, slot_bitmap, 0, slot_pages);
 	}
@@ -172,6 +180,9 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 	guest_num_pages = vm_adjust_num_guest_pages(mode, guest_num_pages);
 	host_num_pages = vm_num_host_pages(mode, guest_num_pages);
 	bmap = bitmap_alloc(host_num_pages);
+	TEST_ASSERT((host_num_pages / p->slots) % BITS_PER_LONG == 0,
+		    "The number of pages per slot must be divisible by %d.",
+		    BITS_PER_LONG);
 
 	if (dirty_log_manual_caps) {
 		cap.cap = KVM_CAP_MANUAL_DIRTY_LOG_PROTECT2;
-- 
2.33.0.309.g3052b89438-goog

