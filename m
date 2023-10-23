Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 112C07D4000
	for <lists+kvm@lfdr.de>; Mon, 23 Oct 2023 21:15:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231642AbjJWTPn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Oct 2023 15:15:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231417AbjJWTPk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Oct 2023 15:15:40 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CB2B101
        for <kvm@vger.kernel.org>; Mon, 23 Oct 2023 12:15:38 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-d9cb79eb417so3439150276.2
        for <kvm@vger.kernel.org>; Mon, 23 Oct 2023 12:15:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1698088537; x=1698693337; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=FrhDwJ6cDjwpQACgZMKp9PJVi2cWnjnpG+wp7ryYIv8=;
        b=J65eiusCzrq37X4c4slf2jxxOzcFONjs8B1agN+AOntfVQcnwCN++SF8XF9FlcscUK
         KGNkY5m0tjBMsdZxczypp/qkGGzzQex4ysRC0Fm92Wc1xsiV8xsL9Z5tbaHCJYLNXmUI
         tgyeGo3Ibi7ySK7yuMM/62eVupeH/9th1ns3LmvlM/mzo1RkKzF97zWoUTtscBApTIo9
         DoL3/MrJTbaaPNVIXudvHy0KqM4oVqDEp1aadtXjr3KCuOudypz8orpBdRPu5I/aaIIC
         aBR18v0J97E7CmNBsJiyGpGf6S0u9gVnZkKdLZ5GMhhSmDhJzixst5XScRBFgiCzB8Fn
         XGGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698088537; x=1698693337;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FrhDwJ6cDjwpQACgZMKp9PJVi2cWnjnpG+wp7ryYIv8=;
        b=C52iNjWrg61hSPXcZBdTPR8/AiHJJT7ZAHBTe9gww0HJm4jR5kMaeAxDKiG/V7YP2Y
         OkOFmX1l2E+mwoLv29eRmMdNZ9tgtG9eTboAIELdKSebjek7FNT844fAI0YTUqGZgh3h
         DPH35CI4KtH/bpUeEszCdspMxxzCUJ1uYeR/m6qX8vpN2lripV1Ur7F2KWCwRHo/ZPle
         F97EbYnbv9cQC+5VBz/Lyq9fmKkHBgXbGRYf3gqI+lvSd5do9vRLjBozjoCwFO///jf3
         2/EZzxYD0f/uEl2ScqHP6XNKvi11NSs3hnKFv4nmNtITy5ABElNpstvZ2VwfyGCfHgrb
         hsbA==
X-Gm-Message-State: AOJu0YwLzae5ZZ9U4oHSHwLW4ZxA059ti0IXkVzIbMJkz6hnwJR1Z26X
        bjaJ4gMB+IXtJGRsKsu384g8zrWB8bU=
X-Google-Smtp-Source: AGHT+IEoy3rn7gonvhV5YaBLq4T+2/gX69osXUMwtoO2H3Nx0X8V4gYtlzob9E7wU6gwtO5DT0/R9NoZwQs=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:42c9:0:b0:d9a:bce6:acf3 with SMTP id
 p192-20020a2542c9000000b00d9abce6acf3mr190144yba.0.1698088537502; Mon, 23 Oct
 2023 12:15:37 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Mon, 23 Oct 2023 12:15:28 -0700
In-Reply-To: <20231023191532.2405326-1-seanjc@google.com>
Mime-Version: 1.0
References: <20231023191532.2405326-1-seanjc@google.com>
X-Mailer: git-send-email 2.42.0.758.gaed0368e0e-goog
Message-ID: <20231023191532.2405326-2-seanjc@google.com>
Subject: [PATCH gmem 1/5] KVM: selftests: Rework fallocate() helper to work
 across multiple memslots
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michael Roth <michael.roth@amd.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Rework vm_guest_mem_fallocate() to play nice with ranges that cover more
than one memslot.  Converting a range that covers multiple memslots is
most definitely an interesting testcase, and there's no reason to force
the caller to manually shatter the range, especially since the size of
the region might not be known by the caller.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/lib/kvm_util.c | 34 ++++++++++++----------
 1 file changed, 18 insertions(+), 16 deletions(-)

diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 8fc70c021c1c..33bc2c6be970 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -1206,30 +1206,32 @@ void vm_mem_region_delete(struct kvm_vm *vm, uint32_t slot)
 	__vm_mem_region_delete(vm, memslot2region(vm, slot), true);
 }
 
-void vm_guest_mem_fallocate(struct kvm_vm *vm, uint64_t gpa, uint64_t size,
+void vm_guest_mem_fallocate(struct kvm_vm *vm, uint64_t base, uint64_t size,
 			    bool punch_hole)
 {
+	const int mode = FALLOC_FL_KEEP_SIZE | (punch_hole ? FALLOC_FL_PUNCH_HOLE : 0);
 	struct userspace_mem_region *region;
-	uint64_t end = gpa + size - 1;
+	uint64_t end = base + size;
+	uint64_t gpa, len;
 	off_t fd_offset;
-	int mode, ret;
+	int ret;
 
-	region = userspace_mem_region_find(vm, gpa, gpa);
-	TEST_ASSERT(region && region->region.flags & KVM_MEM_PRIVATE,
-		    "Private memory region not found for GPA 0x%lx", gpa);
+	for (gpa = base; gpa < end; gpa += len) {
+		uint64_t offset;
 
-	TEST_ASSERT(region == userspace_mem_region_find(vm, end, end),
-		    "fallocate() for guest_memfd must act on a single memslot");
+		region = userspace_mem_region_find(vm, gpa, gpa);
+		TEST_ASSERT(region && region->region.flags & KVM_MEM_PRIVATE,
+			    "Private memory region not found for GPA 0x%lx", gpa);
 
-	fd_offset = region->region.gmem_offset +
-		    (gpa - region->region.guest_phys_addr);
+		offset = (gpa - region->region.guest_phys_addr);
+		fd_offset = region->region.gmem_offset + offset;
+		len = min_t(uint64_t, end - gpa, region->region.memory_size - offset);
 
-	mode = FALLOC_FL_KEEP_SIZE | (punch_hole ? FALLOC_FL_PUNCH_HOLE : 0);
-
-	ret = fallocate(region->region.gmem_fd, mode, fd_offset, size);
-	TEST_ASSERT(!ret, "fallocate() failed to %s at %lx[%lu], fd = %d, mode = %x, offset = %lx\n",
-		     punch_hole ? "punch hole" : "allocate", gpa, size,
-		     region->region.gmem_fd, mode, fd_offset);
+		ret = fallocate(region->region.gmem_fd, mode, fd_offset, len);
+		TEST_ASSERT(!ret, "fallocate() failed to %s at %lx (len = %lu), fd = %d, mode = %x, offset = %lx\n",
+			    punch_hole ? "punch hole" : "allocate", gpa, len,
+			    region->region.gmem_fd, mode, fd_offset);
+	}
 }
 
 /* Returns the size of a vCPU's kvm_run structure. */
-- 
2.42.0.758.gaed0368e0e-goog

