Return-Path: <kvm+bounces-36031-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 633C2A16FFC
	for <lists+kvm@lfdr.de>; Mon, 20 Jan 2025 17:19:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 38A893AA397
	for <lists+kvm@lfdr.de>; Mon, 20 Jan 2025 16:18:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 060331EB9E1;
	Mon, 20 Jan 2025 16:18:40 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 529181EB9F3
	for <kvm@vger.kernel.org>; Mon, 20 Jan 2025 16:18:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737389919; cv=none; b=rlvRU6SIvw8I6R4B6sAVIYFfkWqtKPjP1NlbC8eXS4AFQzyd7no+Pe3WqcEfP1ES9TraJRCkbzWSQ030DjNuPUiLuEBTzfI4F9sY/DnOSqb5Va/8rR+rjGSZ8IybONIWM/sJRwncrMwCA9J0aU7/XiBPFMtE3V7xaIvMXnfoWP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737389919; c=relaxed/simple;
	bh=E2aD/f9V5OHLPMomGxj/EvM8onT9LlQ8hfdWWMiEHZg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q6e+Sw2QFqwh5MrkNky8zjGfYxz4CdtPA8M9FcqnuKmodPnb91cyv7qWCo/H+0Z7OQY3KxeMzzm+WMPsrifF916w61MTU5SQUetFsfe+/iL/Q5FFun+le8o2hmpDbl+enU1IcRcWWO4nKde6ErcJjWgCZ3ivuDLJ3X6aajjDroM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id EA037106F;
	Mon, 20 Jan 2025 08:19:01 -0800 (PST)
Received: from localhost.localdomain (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4CAB43F5A1;
	Mon, 20 Jan 2025 08:18:32 -0800 (PST)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: will@kernel.org,
	julien.thierry.kdev@gmail.com
Cc: apatel@ventanamicro.com,
	andrew.jones@linux.dev,
	andre.przywara@arm.com,
	kvmarm@lists.linux.dev,
	kvm@vger.kernel.org
Subject: [PATCH kvmtool v1 1/2] Propagate the error code from any VCPU thread
Date: Mon, 20 Jan 2025 16:17:59 +0000
Message-ID: <20250120161800.30270-2-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250120161800.30270-1-alexandru.elisei@arm.com>
References: <20250120161800.30270-1-alexandru.elisei@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

kvm_cmd_run_work() doesn't capture the return code for VCPU 0 when calling
pthread_join(). Then kvm_cpu__exit() waits for the threads for VCPUs 1..N
to terminate, and it sets the return value to 0 if at least one of the VCPU
threads returns 0.

This approach creates several issues:

1. An error code from a previous VCPU is overwritten with 0 (success).
2. kvmtool will return 0 even if VCPU 0 encountered an error, as long as
   at least one of the other VCPUs exited successfully.
3. kvm_cpu__exit() will return an uninitialized value if all VCPUs 1..N
   exited with an error, or if there is only one VCPU, VCPU 0.

Fix all issues issues by propagating the return code from VCPU 0, and
saving the error code for each of the remaining VCPUs. If multiple VCPU
threads exit with an error, the exit status is set to the first error.

With this change, kvmtool will terminate with a non-zero exit code if there
was an unhandled error in KVM_RUN, as expected.

While on the subject of return values, apply the more common pattern of
using PTR_ERR(<return value>) in kvm_cpu_thread() instead of double
casting the return value.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 builtin-run.c         |  9 +++++----
 include/kvm/kvm-cpu.h |  2 +-
 kvm-cpu.c             | 17 ++++++++++-------
 3 files changed, 16 insertions(+), 12 deletions(-)

diff --git a/builtin-run.c b/builtin-run.c
index ebff9d5da49d..4b9a3917f006 100644
--- a/builtin-run.c
+++ b/builtin-run.c
@@ -293,7 +293,7 @@ static void *kvm_cpu_thread(void *arg)
 	if (kvm_cpu__start(current_kvm_cpu))
 		goto panic_kvm;
 
-	return (void *) (intptr_t) 0;
+	return ERR_PTR(0);
 
 panic_kvm:
 	pr_err("KVM exit reason: %u (\"%s\")",
@@ -310,7 +310,7 @@ panic_kvm:
 	kvm_cpu__show_code(current_kvm_cpu);
 	kvm_cpu__show_page_tables(current_kvm_cpu);
 
-	return (void *) (intptr_t) 1;
+	return ERR_PTR(1);
 }
 
 static char kernel[PATH_MAX];
@@ -830,6 +830,7 @@ static struct kvm *kvm_cmd_run_init(int argc, const char **argv)
 
 static int kvm_cmd_run_work(struct kvm *kvm)
 {
+	void *vcpu0_ret;
 	int i;
 
 	for (i = 0; i < kvm->nrcpus; i++) {
@@ -838,10 +839,10 @@ static int kvm_cmd_run_work(struct kvm *kvm)
 	}
 
 	/* Only VCPU #0 is going to exit by itself when shutting down */
-	if (pthread_join(kvm->cpus[0]->thread, NULL) != 0)
+	if (pthread_join(kvm->cpus[0]->thread, &vcpu0_ret) != 0)
 		die("unable to join with vcpu 0");
 
-	return kvm_cpu__exit(kvm);
+	return kvm_cpu__exit(kvm, PTR_ERR(vcpu0_ret));
 }
 
 static void kvm_cmd_run_exit(struct kvm *kvm, int guest_ret)
diff --git a/include/kvm/kvm-cpu.h b/include/kvm/kvm-cpu.h
index 0f16f8d6e872..8f76f8a1123a 100644
--- a/include/kvm/kvm-cpu.h
+++ b/include/kvm/kvm-cpu.h
@@ -10,7 +10,7 @@ struct kvm_cpu_task {
 };
 
 int kvm_cpu__init(struct kvm *kvm);
-int kvm_cpu__exit(struct kvm *kvm);
+int kvm_cpu__exit(struct kvm *kvm, int vcpu0_ret);
 struct kvm_cpu *kvm_cpu__arch_init(struct kvm *kvm, unsigned long cpu_id);
 void kvm_cpu__delete(struct kvm_cpu *vcpu);
 void kvm_cpu__reset_vcpu(struct kvm_cpu *vcpu);
diff --git a/kvm-cpu.c b/kvm-cpu.c
index f66dcd07220c..7362f2e99261 100644
--- a/kvm-cpu.c
+++ b/kvm-cpu.c
@@ -1,3 +1,5 @@
+#include "linux/err.h"
+
 #include "kvm/kvm-cpu.h"
 
 #include "kvm/symbol.h"
@@ -303,10 +305,11 @@ fail_alloc:
 }
 base_init(kvm_cpu__init);
 
-int kvm_cpu__exit(struct kvm *kvm)
+int kvm_cpu__exit(struct kvm *kvm, int vcpu0_ret)
 {
-	int i, r;
-	void *ret = NULL;
+	int ret = vcpu0_ret;
+	void *vcpu_ret;
+	int i;
 
 	kvm_cpu__delete(kvm->cpus[0]);
 	kvm->cpus[0] = NULL;
@@ -315,12 +318,12 @@ int kvm_cpu__exit(struct kvm *kvm)
 	for (i = 1; i < kvm->nrcpus; i++) {
 		if (kvm->cpus[i]->is_running) {
 			pthread_kill(kvm->cpus[i]->thread, SIGKVMEXIT);
-			if (pthread_join(kvm->cpus[i]->thread, &ret) != 0)
+			if (pthread_join(kvm->cpus[i]->thread, &vcpu_ret) != 0)
 				die("pthread_join");
 			kvm_cpu__delete(kvm->cpus[i]);
+			if (!ret && PTR_ERR(vcpu_ret))
+				ret = PTR_ERR(vcpu_ret);
 		}
-		if (ret == NULL)
-			r = 0;
 	}
 	kvm__continue(kvm);
 
@@ -330,5 +333,5 @@ int kvm_cpu__exit(struct kvm *kvm)
 
 	close(task_eventfd);
 
-	return r;
+	return ret;
 }
-- 
2.34.1


