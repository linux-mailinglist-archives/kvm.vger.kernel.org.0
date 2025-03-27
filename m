Return-Path: <kvm+bounces-42089-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4A0A0A72818
	for <lists+kvm@lfdr.de>; Thu, 27 Mar 2025 02:25:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 301A73AF17A
	for <lists+kvm@lfdr.de>; Thu, 27 Mar 2025 01:25:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8DB591474B8;
	Thu, 27 Mar 2025 01:24:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vDqshJIt"
X-Original-To: kvm@vger.kernel.org
Received: from mail-vk1-f201.google.com (mail-vk1-f201.google.com [209.85.221.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0B713A1DB
	for <kvm@vger.kernel.org>; Thu, 27 Mar 2025 01:24:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743038696; cv=none; b=HtmMFBo4mPWhAQAfLJY44Ui1vcnFXxJRlwAgRe4SqRizSSe4KPdC5ydrJ/nKZgTlfRdv6Ri8Ae0DJaW1/Vsv0BqweNZ1qTLzgLAt6Y4ycCj8t/sZRpRb7RSA0++kSBnfzQF+iR7aqo9S8PMjs3LcmEbAvU6lQcsrZaMhKnctZPQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743038696; c=relaxed/simple;
	bh=t3Wu8WcpTKr4Hin+dqDU2xino9yOT2vt8H5/bautCRE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=GTrE0MZ04Q6xlF5cASccV/HghArruzYyIyYx0yLjyTLAHpB2S5yVQ3q1rZroOejj0/ME8sYuvWdiozsAjj32t8kpiAZKLvTcZKrOs2iz5kn2aLlktTXjHTR3/7hFJamdgDTaTFbU5vVvrzUfRBGf6jjibGWdTb5JBDmnt8tnKcM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=vDqshJIt; arc=none smtp.client-ip=209.85.221.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com
Received: by mail-vk1-f201.google.com with SMTP id 71dfb90a1353d-523eb742ffbso150963e0c.3
        for <kvm@vger.kernel.org>; Wed, 26 Mar 2025 18:24:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1743038694; x=1743643494; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=v0fJldEh3ljJ4akdD7WwAxn/Ekty9pCM03IX50ZdZwg=;
        b=vDqshJIt4TrIrHLwYkq2s+Ews+BnUk+gqOBJzu7lltl4HgZpUlnj8+0JntsuC5Wx3C
         zbWwuWKMohwzV3jg7+UmKhmZ8mlrUYYePEfzo0lAiatpG0UyKs5nEEi8i/2yQa6MQrpR
         w8s6VxRF2ZYF5ukqSO4pC4DWI4IZCiqF+TTT/Rjyvoan9OdwR15WR/NMxym4n9l/sULa
         DCQm/UQ3w8HjBtCu4/fDkLdd2f9W+Z5J8hiS8IdkHmAmBg+Wqrjslu4n3kVuvqcotiby
         lzUZYXYLAS441qTEIGCFTr1EvmL8XKzdhqTSB9rOrmBxsh4LIt9y7XV8gwlev+RYwh/O
         yLYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743038694; x=1743643494;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=v0fJldEh3ljJ4akdD7WwAxn/Ekty9pCM03IX50ZdZwg=;
        b=v4IUBE/m06FCOiIs/gpsYXo5nWs1Oz7Vf64gC0YpYAGyDjfsK9sSVuprO6v+na8bob
         RzL18HI9imKnYGvmDN0s0YVDLASAuyQSVUVFHXPHYa7X0gCK4QcHN5rehSIyAiREKXHV
         HmyTKSNZRnPoRbWjNnUM68/fpn69/DAx64Fz5AiyyxgExhA6iEXZ1oVJhKjoVTwJDxWy
         /kYDaaVn6wg6QpZd4q2ViqDA4PtgERhcBTcdcaX0V1Zu2mLJ612wPOL/1uSiwz/zN7+p
         fz9Pgoh6cNMrTKwzGwbVG9fxS933gttRYCdlvISEgcSUsiyk9skQJ9Ugc+SSm0N+Plnw
         8+Ug==
X-Forwarded-Encrypted: i=1; AJvYcCWTxbROLhTsKbslxS7ZtG4+b6lUxt5ExFa54LSVcBsFj9zyftPruZ54cr8FXUFNxuA64Ps=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy4Mpe9pXnROeYaND5CdepGsJ5IomA/yL40jMvprP0Nym8cEJuh
	uTZuEIrabq5yN7UU23IbvGtsZ4C7o/qaLmyqzLRKYpv19R/76vljp3FZu84l+ETRCUIwpZ+dDU8
	YSgIJUu8H+phCLST3qw==
X-Google-Smtp-Source: AGHT+IFSht9Rl/okSnd4o3+xfp04VCJSDQHoeYgTEaziVfScJ5lh7/JF2NmdZD1IhD0J/mpc5enurRpuXJWld2NG
X-Received: from uabil9.prod.google.com ([2002:a05:6130:6009:b0:86b:9d15:75ab])
 (user=jthoughton job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6102:3585:b0:4c5:1bff:4589 with SMTP id ada2fe7eead31-4c5870b7afcmr2199208137.22.1743038693829;
 Wed, 26 Mar 2025 18:24:53 -0700 (PDT)
Date: Thu, 27 Mar 2025 01:23:47 +0000
In-Reply-To: <20250327012350.1135621-1-jthoughton@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250327012350.1135621-1-jthoughton@google.com>
X-Mailer: git-send-email 2.49.0.395.g12beb8f557-goog
Message-ID: <20250327012350.1135621-3-jthoughton@google.com>
Subject: [PATCH 2/5] KVM: selftests: access_tracking_perf_test: Add option to
 skip the sanity check
From: James Houghton <jthoughton@google.com>
To: Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org
Cc: Maxim Levitsky <mlevitsk@redhat.com>, Axel Rasmussen <axelrasmussen@google.com>, 
	Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, mkoutny@suse.com, 
	Yu Zhao <yuzhao@google.com>, James Houghton <jthoughton@google.com>, cgroups@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

From: Maxim Levitsky <mlevitsk@redhat.com>

Add an option to skip sanity check of number of still idle pages,
and set it by default to skip, in case hypervisor or NUMA balancing
is detected.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
Co-developed-by: James Houghton <jthoughton@google.com>
Signed-off-by: James Houghton <jthoughton@google.com>
---
 .../selftests/kvm/access_tracking_perf_test.c | 61 ++++++++++++++++---
 .../testing/selftests/kvm/include/test_util.h |  1 +
 tools/testing/selftests/kvm/lib/test_util.c   |  7 +++
 3 files changed, 60 insertions(+), 9 deletions(-)

diff --git a/tools/testing/selftests/kvm/access_tracking_perf_test.c b/tools/testing/selftests/kvm/access_tracking_perf_test.c
index 447e619cf856e..0e594883ec13e 100644
--- a/tools/testing/selftests/kvm/access_tracking_perf_test.c
+++ b/tools/testing/selftests/kvm/access_tracking_perf_test.c
@@ -65,6 +65,16 @@ static int vcpu_last_completed_iteration[KVM_MAX_VCPUS];
 /* Whether to overlap the regions of memory vCPUs access. */
 static bool overlap_memory_access;
 
+/*
+ * If the test should only warn if there are too many idle pages (i.e., it is
+ * expected).
+ * -1: Not yet set.
+ *  0: We do not expect too many idle pages, so FAIL if too many idle pages.
+ *  1: Having too many idle pages is expected, so merely print a warning if
+ *     too many idle pages are found.
+ */
+static int idle_pages_warn_only = -1;
+
 struct test_params {
 	/* The backing source for the region of memory. */
 	enum vm_mem_backing_src_type backing_src;
@@ -177,18 +187,12 @@ static void mark_vcpu_memory_idle(struct kvm_vm *vm,
 	 * arbitrary; high enough that we ensure most memory access went through
 	 * access tracking but low enough as to not make the test too brittle
 	 * over time and across architectures.
-	 *
-	 * When running the guest as a nested VM, "warn" instead of asserting
-	 * as the TLB size is effectively unlimited and the KVM doesn't
-	 * explicitly flush the TLB when aging SPTEs.  As a result, more pages
-	 * are cached and the guest won't see the "idle" bit cleared.
 	 */
 	if (still_idle >= pages / 10) {
-#ifdef __x86_64__
-		TEST_ASSERT(this_cpu_has(X86_FEATURE_HYPERVISOR),
+		TEST_ASSERT(idle_pages_warn_only,
 			    "vCPU%d: Too many pages still idle (%lu out of %lu)",
 			    vcpu_idx, still_idle, pages);
-#endif
+
 		printf("WARNING: vCPU%d: Too many pages still idle (%lu out of %lu), "
 		       "this will affect performance results.\n",
 		       vcpu_idx, still_idle, pages);
@@ -328,6 +332,31 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 	memstress_destroy_vm(vm);
 }
 
+static int access_tracking_unreliable(void)
+{
+#ifdef __x86_64__
+	/*
+	 * When running nested, the TLB size is effectively unlimited and the
+	 * KVM doesn't explicitly flush the TLB when aging SPTEs.  As a result,
+	 * more pages are cached and the guest won't see the "idle" bit cleared.
+	 */
+	if (this_cpu_has(X86_FEATURE_HYPERVISOR)) {
+		puts("Skipping idle page count sanity check, because the test is run nested");
+		return 1;
+	}
+#endif
+	/*
+	 * When NUMA balancing is enabled, guest memory can be mapped
+	 * PROT_NONE, and the Accessed bits won't be queriable.
+	 */
+	if (is_numa_balancing_enabled()) {
+		puts("Skipping idle page count sanity check, because NUMA balancing is enabled");
+		return 1;
+	}
+
+	return 0;
+}
+
 static void help(char *name)
 {
 	puts("");
@@ -342,6 +371,12 @@ static void help(char *name)
 	printf(" -v: specify the number of vCPUs to run.\n");
 	printf(" -o: Overlap guest memory accesses instead of partitioning\n"
 	       "     them into a separate region of memory for each vCPU.\n");
+	printf(" -w: Control whether the test warns or fails if more than 10%\n"
+	       "     of pages are still seen as idle/old after accessing guest\n"
+	       "     memory.  >0 == warn only, 0 == fail, <0 == auto.  For auto\n"
+	       "     mode, the test fails by default, but switches to warn only\n"
+	       "     if NUMA balancing is enabled or the test detects it's running\n"
+	       "     in a VM.\n");
 	backing_src_help("-s");
 	puts("");
 	exit(0);
@@ -359,7 +394,7 @@ int main(int argc, char *argv[])
 
 	guest_modes_append_default();
 
-	while ((opt = getopt(argc, argv, "hm:b:v:os:")) != -1) {
+	while ((opt = getopt(argc, argv, "hm:b:v:os:w:")) != -1) {
 		switch (opt) {
 		case 'm':
 			guest_modes_cmdline(optarg);
@@ -376,6 +411,11 @@ int main(int argc, char *argv[])
 		case 's':
 			params.backing_src = parse_backing_src_type(optarg);
 			break;
+		case 'w':
+			idle_pages_warn_only =
+				atoi_non_negative("Idle pages warning",
+						  optarg);
+			break;
 		case 'h':
 		default:
 			help(argv[0]);
@@ -388,6 +428,9 @@ int main(int argc, char *argv[])
 		       "CONFIG_IDLE_PAGE_TRACKING is not enabled");
 	close(page_idle_fd);
 
+	if (idle_pages_warn_only == -1)
+		idle_pages_warn_only = access_tracking_unreliable();
+
 	for_each_guest_mode(run_test, &params);
 
 	return 0;
diff --git a/tools/testing/selftests/kvm/include/test_util.h b/tools/testing/selftests/kvm/include/test_util.h
index 77d13d7920cb8..c6ef895fbd9ab 100644
--- a/tools/testing/selftests/kvm/include/test_util.h
+++ b/tools/testing/selftests/kvm/include/test_util.h
@@ -153,6 +153,7 @@ bool is_backing_src_hugetlb(uint32_t i);
 void backing_src_help(const char *flag);
 enum vm_mem_backing_src_type parse_backing_src_type(const char *type_name);
 long get_run_delay(void);
+bool is_numa_balancing_enabled(void);
 
 /*
  * Whether or not the given source type is shared memory (as opposed to
diff --git a/tools/testing/selftests/kvm/lib/test_util.c b/tools/testing/selftests/kvm/lib/test_util.c
index 3dc8538f5d696..03eb99af9b8de 100644
--- a/tools/testing/selftests/kvm/lib/test_util.c
+++ b/tools/testing/selftests/kvm/lib/test_util.c
@@ -176,6 +176,13 @@ size_t get_trans_hugepagesz(void)
 	return get_sysfs_val("/sys/kernel/mm/transparent_hugepage/hpage_pmd_size");
 }
 
+bool is_numa_balancing_enabled(void)
+{
+	if (!test_sysfs_path("/proc/sys/kernel/numa_balancing"))
+		return false;
+	return get_sysfs_val("/proc/sys/kernel/numa_balancing") == 1;
+}
+
 size_t get_def_hugetlb_pagesz(void)
 {
 	char buf[64];
-- 
2.49.0.395.g12beb8f557-goog


