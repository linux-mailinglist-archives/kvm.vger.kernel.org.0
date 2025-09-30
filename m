Return-Path: <kvm+bounces-59204-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 64DB2BAE302
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 19:31:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 43B501885CE4
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 17:31:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 340B230DEA2;
	Tue, 30 Sep 2025 17:29:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="QiXW/bYW"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA2AD30DD3D
	for <kvm@vger.kernel.org>; Tue, 30 Sep 2025 17:29:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759253351; cv=none; b=AMgHTpSHYWZ3uBocO4q+i7yGyStrwRhaPUJV7UxEN+QWkMG6L+YluAMjKBWMpU1whSPdjtteLSR75GpSsAf+7FPkpF/9BhYOYHn1u7dxkLC6cl5Div+krFKSGbgniR0ekUZoGhIlJft5jUcIMA9YEXyBhtsivl5Rqu0UGcx6XWk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759253351; c=relaxed/simple;
	bh=n+pm1Tzp0fX9Woesz3maNmLxRH7hRrSoa2S948LYM2Q=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=QkKkKJdVHmG/RblCS55DSMrpYfyX083quNi3gAIRyZOvGdXg4+uUzYJ7sg5AlJmE6Yz+Wa/M1Cs+JEYDVbaL4gqnQF45gyXFlBgv+YB8dIckzaueb7Yo99jdNU5Rveod2EB9okRQ7OOY2dPdaXSlldPAX0wcJo68dUmqMBbFIOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=QiXW/bYW; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-32eddb7e714so5414586a91.1
        for <kvm@vger.kernel.org>; Tue, 30 Sep 2025 10:29:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759253349; x=1759858149; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Vw+is60elbQtO0wwD/2XU6waUg/I4wOE9b9vLsqfwE0=;
        b=QiXW/bYWFOdQsZEc05xD78QRosuGh4FXHDA3EVY++t2hGwnL/bzX835vlHHgVgyphh
         /2Amx4DsRpKTDx8uu0CMl30+2Vbm54jBmTae1hFkVNctCCKYCH6ysaveaPlrP165/liL
         QzYSn1R34eoAwvch75FlMxIydvPcD4r6CiQXtXqfohSYWlOce+OrL/JoR5OGYcSG2B8W
         LSTrRxlqcl9CkCP0UDrTTT5ss5ceZBO30SbMzjX5B/ILvmghms7LJy5ftJc4vsXKRpn+
         TV/LAWrTZX0NIJnjcU+xxyJhl22QqH3mbHlo3B7kYq0PIoqFU4WJq4xs4Z58Oyw2HUlO
         y5wA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759253349; x=1759858149;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Vw+is60elbQtO0wwD/2XU6waUg/I4wOE9b9vLsqfwE0=;
        b=wROr3TMd54cMh83vq6L3TZHlWQDVipgvqShW2Jl0ao6ddIkhrLVDX1qQdF/I9VDdOI
         a/fgNrB2TkcWvqXlwVgRIJKD6WL2r48k6DdQzgQ66cETpWv1+A4VlFkXfSj0gQzVkJYK
         Z2CNo2xqgfuwuR40VodHGEaqpRiAV7tccVJ7p+cKaWn0cc/dJnzX1bPDKNLqne2cxN3Y
         NVf2GyqjMr4useyamhxf3DTaKm/w3yfMCNh/TmqJUaFG0uhvqd49jyNc9qZriRp4A1uf
         WSXmkkQGYqw+ahLsS3Gf3tci0GhYd4eFMkmz8wfhSZacMyG2qcQjb3aj5GxlAu5kW8Dz
         1cpg==
X-Forwarded-Encrypted: i=1; AJvYcCUks5IWrp3FZTvwlke3rI6DFq059YfXvZE2UV+/V3YmmokdeGcLjljOlJ2Jy5LfCcwovYc=@vger.kernel.org
X-Gm-Message-State: AOJu0YwgsvYFWtV6X5X+wCg+MoS3a36O1k0R2e/nvujYwC9x+5lDlAcP
	E+ZfZ/pbgnuAN6CTKbvlcEhMX3hXsUuKL1230rpKD1uM9Uyyiid/TTZduxih7EyDurLiqJk8Sfo
	xm40+kdTysHs/xhZre/Q00g==
X-Google-Smtp-Source: AGHT+IGdL9Ry3P3DwBkpnSXkYT5+WSHErQCisnYVa6t/02kcKG+f669JdC7/aSKfvH0zLfBC6GwoZJEhovnoFKVs
X-Received: from pjbcm23.prod.google.com ([2002:a17:90a:fa17:b0:32e:ddac:6ea5])
 (user=jthoughton job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:33c2:b0:334:cb89:bde6 with SMTP id 98e67ed59e1d1-339a6e83b68mr247132a91.4.1759253348928;
 Tue, 30 Sep 2025 10:29:08 -0700 (PDT)
Date: Tue, 30 Sep 2025 17:28:50 +0000
In-Reply-To: <20250930172850.598938-1-jthoughton@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250930172850.598938-1-jthoughton@google.com>
X-Mailer: git-send-email 2.51.0.618.g983fd99d29-goog
Message-ID: <20250930172850.598938-2-jthoughton@google.com>
Subject: [PATCH 2/2] KVM: selftests: Add parallel KVM_GET_DIRTY_LOG to dirty_log_perf_test
From: James Houghton <jthoughton@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: James Houghton <jthoughton@google.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

The parallelism is by memslot. This is useful because KVM no longer
serializes KVM_GET_DIRTY_LOG if KVM_CAP_MANUAL_DIRTY_LOG_PROTECT2 is
enabled.

Signed-off-by: James Houghton <jthoughton@google.com>
---
 .../selftests/kvm/dirty_log_perf_test.c       | 20 ++++++++--
 .../testing/selftests/kvm/include/memstress.h |  2 +
 tools/testing/selftests/kvm/lib/kvm_util.c    |  2 +
 tools/testing/selftests/kvm/lib/memstress.c   | 40 +++++++++++++++++++
 4 files changed, 61 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/kvm/dirty_log_perf_test.c b/tools/testing/selftests/kvm/dirty_log_perf_test.c
index e79817bd0e29..8a5f289c4966 100644
--- a/tools/testing/selftests/kvm/dirty_log_perf_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_perf_test.c
@@ -131,8 +131,18 @@ struct test_params {
 	int slots;
 	uint32_t write_percent;
 	bool random_access;
+	bool parallel_get_dirty_log;
 };
 
+static void get_dirty_log(struct kvm_vm *vm, unsigned long *bitmaps[],
+			  struct test_params *p)
+{
+	if (p->parallel_get_dirty_log)
+		memstress_get_dirty_log_parallel(vm, bitmaps, p->slots);
+	else
+		memstress_get_dirty_log(vm, bitmaps, p->slots);
+}
+
 static void run_test(enum vm_guest_mode mode, void *arg)
 {
 	struct test_params *p = arg;
@@ -230,7 +240,7 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 			iteration, ts_diff.tv_sec, ts_diff.tv_nsec);
 
 		clock_gettime(CLOCK_MONOTONIC, &start);
-		memstress_get_dirty_log(vm, bitmaps, p->slots);
+		get_dirty_log(vm, bitmaps, p);
 		ts_diff = timespec_elapsed(start);
 		get_dirty_log_total = timespec_add(get_dirty_log_total,
 						   ts_diff);
@@ -292,7 +302,7 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 static void help(char *name)
 {
 	puts("");
-	printf("usage: %s [-h] [-a] [-i iterations] [-p offset] [-g] "
+	printf("usage: %s [-h] [-a] [-i iterations] [-p offset] [-g] [-l] "
 	       "[-m mode] [-n] [-b vcpu bytes] [-v vcpus] [-o] [-r random seed ] [-s mem type]"
 	       "[-x memslots] [-w percentage] [-c physical cpus to run test on]\n", name);
 	puts("");
@@ -305,6 +315,7 @@ static void help(char *name)
 	       "     and writes will be tracked as soon as dirty logging is\n"
 	       "     enabled on the memslot (i.e. KVM_DIRTY_LOG_INITIALLY_SET\n"
 	       "     is not enabled).\n");
+	printf(" -l: Do KVM_GET_DIRTY_LOG calls for each memslot in parallel.\n");
 	printf(" -p: specify guest physical test memory offset\n"
 	       "     Warning: a low offset can conflict with the loaded test code.\n");
 	guest_modes_help();
@@ -355,7 +366,7 @@ int main(int argc, char *argv[])
 
 	guest_modes_append_default();
 
-	while ((opt = getopt(argc, argv, "ab:c:eghi:m:nop:r:s:v:x:w:")) != -1) {
+	while ((opt = getopt(argc, argv, "ab:c:eghi:lm:nop:r:s:v:x:w:")) != -1) {
 		switch (opt) {
 		case 'a':
 			p.random_access = true;
@@ -379,6 +390,9 @@ int main(int argc, char *argv[])
 		case 'i':
 			p.iterations = atoi_positive("Number of iterations", optarg);
 			break;
+		case 'l':
+			p.parallel_get_dirty_log = true;
+			break;
 		case 'm':
 			guest_modes_cmdline(optarg);
 			break;
diff --git a/tools/testing/selftests/kvm/include/memstress.h b/tools/testing/selftests/kvm/include/memstress.h
index 9071eb6dea60..3e6ad2cdec80 100644
--- a/tools/testing/selftests/kvm/include/memstress.h
+++ b/tools/testing/selftests/kvm/include/memstress.h
@@ -74,6 +74,8 @@ void memstress_setup_nested(struct kvm_vm *vm, int nr_vcpus, struct kvm_vcpu *vc
 void memstress_enable_dirty_logging(struct kvm_vm *vm, int slots);
 void memstress_disable_dirty_logging(struct kvm_vm *vm, int slots);
 void memstress_get_dirty_log(struct kvm_vm *vm, unsigned long *bitmaps[], int slots);
+void memstress_get_dirty_log_parallel(struct kvm_vm *vm, unsigned long *bitmaps[],
+				      int slots);
 void memstress_clear_dirty_log(struct kvm_vm *vm, unsigned long *bitmaps[],
 			       int slots, uint64_t pages_per_slot);
 unsigned long **memstress_alloc_bitmaps(int slots, uint64_t pages_per_slot);
diff --git a/tools/testing/selftests/kvm/lib/memstress.c b/tools/testing/selftests/kvm/lib/memstress.c
index 557c0a0a5658..abbd96a1c3ba 100644
--- a/tools/testing/selftests/kvm/lib/memstress.c
+++ b/tools/testing/selftests/kvm/lib/memstress.c
@@ -40,6 +40,12 @@ static bool all_vcpu_threads_running;
 
 static struct kvm_vcpu *vcpus[KVM_MAX_VCPUS];
 
+struct get_dirty_log_args {
+	struct kvm_vm *vm;
+	unsigned long *bitmap;
+	int slot;
+};
+
 /*
  * Continuously write to the first 8 bytes of each page in the
  * specified region.
@@ -341,6 +347,15 @@ void memstress_disable_dirty_logging(struct kvm_vm *vm, int slots)
 	toggle_dirty_logging(vm, slots, false);
 }
 
+static void *get_dirty_log_worker(void *arg)
+{
+	struct get_dirty_log_args *args = arg;
+
+	kvm_vm_get_dirty_log(args->vm, args->slot, args->bitmap);
+
+	return NULL;
+}
+
 void memstress_get_dirty_log(struct kvm_vm *vm, unsigned long *bitmaps[], int slots)
 {
 	int i;
@@ -352,6 +367,31 @@ void memstress_get_dirty_log(struct kvm_vm *vm, unsigned long *bitmaps[], int sl
 	}
 }
 
+void memstress_get_dirty_log_parallel(struct kvm_vm *vm, unsigned long *bitmaps[],
+				      int slots)
+{
+	struct {
+		pthread_t thd;
+		struct get_dirty_log_args args;
+	} *threads;
+	int i;
+
+	threads = malloc(slots * sizeof(*threads));
+
+	for (i = 0; i < slots; i++) {
+		threads[i].args.vm = vm;
+		threads[i].args.slot = MEMSTRESS_MEM_SLOT_INDEX + i;
+		threads[i].args.bitmap = bitmaps[i];
+		pthread_create(&threads[i].thd, NULL, get_dirty_log_worker,
+			       &threads[i].args);
+	}
+
+	for (i = 0; i < slots; i++)
+		pthread_join(threads[i].thd, NULL);
+
+	free(threads);
+}
+
 void memstress_clear_dirty_log(struct kvm_vm *vm, unsigned long *bitmaps[],
 			       int slots, uint64_t pages_per_slot)
 {
-- 
2.51.0.618.g983fd99d29-goog


