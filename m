Return-Path: <kvm+bounces-45968-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 29DA0AB0321
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 20:47:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 941AB5076CA
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 18:47:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E5FC288508;
	Thu,  8 May 2025 18:46:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jQLY8BDU"
X-Original-To: kvm@vger.kernel.org
Received: from mail-vs1-f74.google.com (mail-vs1-f74.google.com [209.85.217.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BAA32798ED
	for <kvm@vger.kernel.org>; Thu,  8 May 2025 18:46:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746730015; cv=none; b=jFyRJi1O1bbF6diTFgdNFSTExG+UoGggbDBAmxkIbQXolwIcjVFvkO9jGPO8VAv4j1WiCDakIJGBasjEUXKD9uXa3nBAoObGt+/nt+f57098z3ztX0FRYz3Kv/N8QupcfGMLoV0na/5dbz4dJsB1UnfIDzki1IgNBDdEqGWNM/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746730015; c=relaxed/simple;
	bh=ZcVsgXQwg2/GyQr/vof0NC0TWU9+fC8WarKxZppgA0g=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=S+BOsWpWpSMDgoOnwU17tTA7EC1nHZsLVUWnvn35s9QZsoPzRFBxGTURdS9G+LWf2XtSxUwb/tmQ+PkIVse7mN5JEXF3UEVtdlQKEMGVp66pJe6lrmoIKYwqwci+YKtMGrFJYBrrFpoXvPQ9xXYcaCYhOi51U1l/odqqpDvR/bQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=jQLY8BDU; arc=none smtp.client-ip=209.85.217.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com
Received: by mail-vs1-f74.google.com with SMTP id ada2fe7eead31-4ddb99510b7so179083137.0
        for <kvm@vger.kernel.org>; Thu, 08 May 2025 11:46:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1746730012; x=1747334812; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=qj43d6+YzTB6RT1En1eLIwlHOTDu4X6j9DjphPgdOm8=;
        b=jQLY8BDUgIdDMmC41cTGDETLKQLEb6y+JMMM3Ym0d+cBz2Pheo/fGgWvzGARk+XfCt
         msNpHLd1J47KWbcFNrYKPAaMUxci81m7cFdvnL88z+UM6mt051ekXKI/v8yWQ8UaPYDt
         LyucROCoHy3a92O6cf0ESGkYNol7hkWlIKYBA0RSHtb5SAZ0bLpsVxewvP+KJ/3RY4cj
         9Q3FVqRNsugNfk7Wa4KIWlfAZLniRKw8VSoKpUEDk6c71P5JerYN1tKuRAQMrciv5+9r
         0+xnY7niqoh+t5O/XvGXeWvd1BXDz57RSjvwymenA5fpQmp1eiiE+i9ETTbi90sggjsM
         ABoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746730012; x=1747334812;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qj43d6+YzTB6RT1En1eLIwlHOTDu4X6j9DjphPgdOm8=;
        b=vFAYRcOXP99krBOKkMhqfkIiwyPNrTbPAjgEODeIs46FlHdYHBlmc7sHfZTnhN0q/1
         La0PWC9hI8iYdKtUWSx0cOs9h8qm82pD4C3+GaYibG+IV0OHAsVXN7WFH7QGXuEROmEE
         15SEv8AxQUDyGVEhS01AQySXBTYVPYO5+DPQY1qLBY5ecTYfEseFQm1JWKfTha4NwuYM
         L6LdZu9VL4iAW4R3cGQMKl791Y/UFGS8xD4Oi3RUAkCNJ/YVEyBdFwmcduHk6670ZS5v
         6fU2yJPNKE6Rqq9m39D1ZQ/mkcG3HMq34vfHVcFhxADsjpbyBI4Dnw84ugVcQIoIRg+3
         OBgA==
X-Forwarded-Encrypted: i=1; AJvYcCXwN/s8/Y1xocdSF63mBdSFzyjlu8uj2BiKC7gkR4qA8t/P9OAyNDDUHbKrK0kLlk9NM4U=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw5cEke4uOHb0bg0eJNIyYs+fjzx2UkBsQR837HcBfGoN+ywnjT
	UK/GRFHkhInx+/Zj8wJZOFS3ckWto/2qPsl7ydvA1lsMBIFxMTuMRYykqefMrvMxnWt3kbU2OP4
	cDPt3t8SJlLFMG2rtDg==
X-Google-Smtp-Source: AGHT+IGiJCw0IZYg4Spkkv5MvH3n/nmBvrY1UsIkawmfL66rCGdSh6drerePqQFfzIMxCsgsCNqImNaJ+BexciQP
X-Received: from uabfe4.prod.google.com ([2002:a05:6130:1884:b0:877:a5a1:6bc6])
 (user=jthoughton job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6102:2c19:b0:4c2:f972:b699 with SMTP id ada2fe7eead31-4deed3053e4mr494779137.5.1746730012318;
 Thu, 08 May 2025 11:46:52 -0700 (PDT)
Date: Thu,  8 May 2025 18:46:43 +0000
In-Reply-To: <20250508184649.2576210-1-jthoughton@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250508184649.2576210-1-jthoughton@google.com>
X-Mailer: git-send-email 2.49.0.1015.ga840276032-goog
Message-ID: <20250508184649.2576210-3-jthoughton@google.com>
Subject: [PATCH v4 2/7] KVM: selftests: access_tracking_perf_test: Add option
 to skip the sanity check
From: James Houghton <jthoughton@google.com>
To: Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org
Cc: Maxim Levitsky <mlevitsk@redhat.com>, Axel Rasmussen <axelrasmussen@google.com>, 
	Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, mkoutny@suse.com, 
	Yosry Ahmed <yosry.ahmed@linux.dev>, Yu Zhao <yuzhao@google.com>, 
	David Matlack <dmatlack@google.com>, James Houghton <jthoughton@google.com>, cgroups@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

From: Maxim Levitsky <mlevitsk@redhat.com>

Add an option to skip sanity check of number of still idle pages,
and set it by default to skip, in case hypervisor or NUMA balancing
is detected.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
Co-developed-by: James Houghton <jthoughton@google.com>
Signed-off-by: James Houghton <jthoughton@google.com>
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 .../selftests/kvm/access_tracking_perf_test.c | 62 ++++++++++++++++---
 .../testing/selftests/kvm/include/test_util.h |  1 +
 tools/testing/selftests/kvm/lib/test_util.c   |  7 +++
 3 files changed, 61 insertions(+), 9 deletions(-)

diff --git a/tools/testing/selftests/kvm/access_tracking_perf_test.c b/tools/testing/selftests/kvm/access_tracking_perf_test.c
index 447e619cf856e..a2ac6fa2ba141 100644
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
@@ -328,6 +332,32 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 	memstress_destroy_vm(vm);
 }
 
+static int access_tracking_unreliable(void)
+{
+#ifdef __x86_64__
+	/*
+	 * When running nested, the TLB size may be effectively unlimited (for
+	 * example, this is the case when running on KVM L0), and KVM doesn't
+	 * explicitly flush the TLB when aging SPTEs.  As a result, more pages
+	 * are cached and the guest won't see the "idle" bit cleared.
+	 */
+	if (this_cpu_has(X86_FEATURE_HYPERVISOR)) {
+		puts("Skipping idle page count sanity check, because the test is run nested");
+		return 1;
+	}
+#endif
+	/*
+	 * When NUMA balancing is enabled, guest memory will be unmapped to get
+	 * NUMA faults, dropping the Accessed bits.
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
@@ -342,6 +372,12 @@ static void help(char *name)
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
@@ -359,7 +395,7 @@ int main(int argc, char *argv[])
 
 	guest_modes_append_default();
 
-	while ((opt = getopt(argc, argv, "hm:b:v:os:")) != -1) {
+	while ((opt = getopt(argc, argv, "hm:b:v:os:w:")) != -1) {
 		switch (opt) {
 		case 'm':
 			guest_modes_cmdline(optarg);
@@ -376,6 +412,11 @@ int main(int argc, char *argv[])
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
@@ -388,6 +429,9 @@ int main(int argc, char *argv[])
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
2.49.0.1015.ga840276032-goog


