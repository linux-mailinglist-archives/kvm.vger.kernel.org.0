Return-Path: <kvm+bounces-7604-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 53740844B0E
	for <lists+kvm@lfdr.de>; Wed, 31 Jan 2024 23:27:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 81787294CAF
	for <lists+kvm@lfdr.de>; Wed, 31 Jan 2024 22:27:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 650CC39FF7;
	Wed, 31 Jan 2024 22:27:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="WVpPhiRj"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5F5D39AFB
	for <kvm@vger.kernel.org>; Wed, 31 Jan 2024 22:27:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706740053; cv=none; b=u93rDz4Sbw9/Ezp0s/Lge5g92co52bmoncN4pYqvTNWrmI6jxtPLthC4qXiEGtAluVgyrVCBwIrgmeOfiKUHSHjsHDaNiJgT7jikg2irOELzDBaEmaq+LWwix/VOq2Nvre6NaGGsX8cv0Lu8D3q6wxDSy0kn/jwlN2RcMkL85qY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706740053; c=relaxed/simple;
	bh=q4D9PYo5wywekN5NVBk+P7J3FZKigB7Z5j1onk8+lt4=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=mur3dhL5YJJadIbxgxbQ/Bk0fTF3Ok9x6ZmIkEUlPiLyaePsKQ5w/dBjWM5e0T12ux2YDyJ3K13zloqC2Rgcv2E5JpsY95r6e9IN4hDoGSWr+Q1qWlgExwGt7lYNQXNPoOjgNg8eP+0NYBj4Z97CH3bygcLIQlYj1yaSC2u97N0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=WVpPhiRj; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-60403a678f2so5296797b3.3
        for <kvm@vger.kernel.org>; Wed, 31 Jan 2024 14:27:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1706740051; x=1707344851; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qSk8sZ6jjyJwSErBe2qUveiO/EQ0qiBkQ1PQWDlz+tI=;
        b=WVpPhiRjCIQgIPCfXKNTrKH7CCdF9rlYJlS3ZIkzJFkhXY82ps/slnN8xtWoJx2pVy
         ATlbTixDVRL5pXTl+OioQbFhv/cIyeN79RM5SKMaYSd9xlVOrpEwDorENVA8LC2wfBVJ
         uhCO3HWjj0QINIZeoNYKfOwLow9yB2zX1+uCv8KmD4PEoBuQvUKd/D4ABlZsGo3E6XZq
         8syP7sHjNLDrwnvIeMi0YXActKbwubAM9kH4CJg6MUOr52HK7OlJp+1E0IknkXHneIr/
         sKeNrOzCc29UL1liUhv8m9cVNhdHkwbu0FWKkuoaUvIoQ9jV/5umx313+Mls71XQrh/w
         g/XQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706740051; x=1707344851;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qSk8sZ6jjyJwSErBe2qUveiO/EQ0qiBkQ1PQWDlz+tI=;
        b=CWmWHBph+FkAnTDQk28YP2uF4EjG2kCj2+FiIAekpcOxKnFaH/vM88N39bBVzhy3GL
         f4SVMIA5agxwtXz+2p3WHsd1Aa2an36L+LJV88A+LDCxntW0/jxJqB5VBLR2d0A7/T7F
         8BW3Ge2oqtnaPVkqhNVFVGO0foMV+uGhdXVsoIfy6xzRd2cvZ673VYXuzjM8Mndpe+qj
         2Yj0QDtbMyWVdkt2KCiyQFLByXZv8SEDMrCpcFUt+wQIpT/cDQSk53VcHlqDVKscgEu/
         qyfbIHSUyUXgzE2iR00pODQNfZxje++b2rAdQ/Ws6GBSe/VZ83oB3kef/jzPddQSifXj
         KDKA==
X-Gm-Message-State: AOJu0YykeYuphcijAi8rIIX9XqkG+9E3y7+kpcfKM0cXD3C+ehB7Uo1Q
	TV1o1NNve5KWx5tpTZdJzWLkwQLgmGBwVgxfbx9eubsAKvMELsp7wcwlQiBqwevfvbBR3pOXlHr
	cFg==
X-Google-Smtp-Source: AGHT+IF2xLQoajJ0pUP+ciGzUq6JQNIFCc4p+/2mVMFDRmbNBoHexRvmpgDsWQSgfQHaX+DdSrdgAZhV/KM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:d:b0:604:127:3652 with SMTP id
 bc13-20020a05690c000d00b0060401273652mr675320ywb.5.1706740050921; Wed, 31 Jan
 2024 14:27:30 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 31 Jan 2024 14:27:28 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.43.0.429.g432eaa2c6b-goog
Message-ID: <20240131222728.4100079-1-seanjc@google.com>
Subject: [PATCH] KVM: selftests: Don't assert on exact number of 4KiB in dirty
 log split test
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Yi Lai <yi1.lai@intel.com>, Tao Su <tao1.su@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"

Drop dirty_log_page_splitting_test's assertion that the number of 4KiB
pages remains the same across dirty logging being enabled and disabled, as
the test doesn't guarantee that mappings outside of the memslots being
dirty logged are stable, e.g. KVM's mappings for code and pages in
memslot0 can be zapped by things like NUMA balancing.

To preserve the spirit of the check, assert that (a) the number of 4KiB
pages after splitting is _at least_ the number of 4KiB pages across all
memslots under test, and (b) the number of hugepages before splitting adds
up to the number of pages across all memslots under test.  (b) is a little
tenuous as it relies on memslot0 being incompatible with transparent
hugepages, but that holds true for now as selftests explicitly madvise()
MADV_NOHUGEPAGE for memslot0 (__vm_create() unconditionally specifies the
backing type as VM_MEM_SRC_ANONYMOUS).

Reported-by: Yi Lai <yi1.lai@intel.com>
Reported-by: Tao Su <tao1.su@linux.intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../x86_64/dirty_log_page_splitting_test.c    | 21 +++++++++++--------
 1 file changed, 12 insertions(+), 9 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/dirty_log_page_splitting_test.c b/tools/testing/selftests/kvm/x86_64/dirty_log_page_splitting_test.c
index 634c6bfcd572..4864cf3fae57 100644
--- a/tools/testing/selftests/kvm/x86_64/dirty_log_page_splitting_test.c
+++ b/tools/testing/selftests/kvm/x86_64/dirty_log_page_splitting_test.c
@@ -92,7 +92,6 @@ static void run_test(enum vm_guest_mode mode, void *unused)
 	uint64_t host_num_pages;
 	uint64_t pages_per_slot;
 	int i;
-	uint64_t total_4k_pages;
 	struct kvm_page_stats stats_populated;
 	struct kvm_page_stats stats_dirty_logging_enabled;
 	struct kvm_page_stats stats_dirty_pass[ITERATIONS];
@@ -107,6 +106,9 @@ static void run_test(enum vm_guest_mode mode, void *unused)
 	guest_num_pages = vm_adjust_num_guest_pages(mode, guest_num_pages);
 	host_num_pages = vm_num_host_pages(mode, guest_num_pages);
 	pages_per_slot = host_num_pages / SLOTS;
+	TEST_ASSERT_EQ(host_num_pages, pages_per_slot * SLOTS);
+	TEST_ASSERT(!(host_num_pages % 512),
+		    "Number of pages, '%lu' not a multiple of 2MiB", host_num_pages);
 
 	bitmaps = memstress_alloc_bitmaps(SLOTS, pages_per_slot);
 
@@ -165,10 +167,8 @@ static void run_test(enum vm_guest_mode mode, void *unused)
 	memstress_free_bitmaps(bitmaps, SLOTS);
 	memstress_destroy_vm(vm);
 
-	/* Make assertions about the page counts. */
-	total_4k_pages = stats_populated.pages_4k;
-	total_4k_pages += stats_populated.pages_2m * 512;
-	total_4k_pages += stats_populated.pages_1g * 512 * 512;
+	TEST_ASSERT_EQ((stats_populated.pages_2m * 512 +
+			stats_populated.pages_1g * 512 * 512), host_num_pages);
 
 	/*
 	 * Check that all huge pages were split. Since large pages can only
@@ -180,19 +180,22 @@ static void run_test(enum vm_guest_mode mode, void *unused)
 	 */
 	if (dirty_log_manual_caps) {
 		TEST_ASSERT_EQ(stats_clear_pass[0].hugepages, 0);
-		TEST_ASSERT_EQ(stats_clear_pass[0].pages_4k, total_4k_pages);
+		TEST_ASSERT(stats_clear_pass[0].pages_4k >= host_num_pages,
+			    "Expected at least '%lu' 4KiB pages, found only '%lu'",
+			    host_num_pages, stats_clear_pass[0].pages_4k);
 		TEST_ASSERT_EQ(stats_dirty_logging_enabled.hugepages, stats_populated.hugepages);
 	} else {
 		TEST_ASSERT_EQ(stats_dirty_logging_enabled.hugepages, 0);
-		TEST_ASSERT_EQ(stats_dirty_logging_enabled.pages_4k, total_4k_pages);
+		TEST_ASSERT(stats_dirty_logging_enabled.pages_4k >= host_num_pages,
+			    "Expected at least '%lu' 4KiB pages, found only '%lu'",
+			    host_num_pages, stats_clear_pass[0].pages_4k);
 	}
 
 	/*
 	 * Once dirty logging is disabled and the vCPUs have touched all their
-	 * memory again, the page counts should be the same as they were
+	 * memory again, the hugepage counts should be the same as they were
 	 * right after initial population of memory.
 	 */
-	TEST_ASSERT_EQ(stats_populated.pages_4k, stats_repopulated.pages_4k);
 	TEST_ASSERT_EQ(stats_populated.pages_2m, stats_repopulated.pages_2m);
 	TEST_ASSERT_EQ(stats_populated.pages_1g, stats_repopulated.pages_1g);
 }

base-commit: f0f3b810edda57f317d79f452056786257089667
-- 
2.43.0.429.g432eaa2c6b-goog


