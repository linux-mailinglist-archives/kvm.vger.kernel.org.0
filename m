Return-Path: <kvm+bounces-67436-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 4206BD0548A
	for <lists+kvm@lfdr.de>; Thu, 08 Jan 2026 18:59:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 05A073042756
	for <lists+kvm@lfdr.de>; Thu,  8 Jan 2026 17:58:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F89E2EBB90;
	Thu,  8 Jan 2026 17:58:52 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D7B75D27E;
	Thu,  8 Jan 2026 17:58:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767895131; cv=none; b=ptKd24gq46b+zdmVYOQ4PI+0pLt08FHXbhzytlQYbboJOkaeLBZc9BJkMZko4rLcVr4lWhkNq8jxYWyZqfjQlMebYUGW4EvFPPBLX0TVVqs8sBjfJT+KllIGljUV8qIgGfMeUgnMQmL+6Xvo5FVao4j7GSvPmpgKUJqZHngN34s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767895131; c=relaxed/simple;
	bh=G0nxEsEsmQ1cbhrcW96b49pK99m48bXk0jVoLoffOGE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B0STH6vZUQ1WAjIrot1KYlYd6MvJPIEv5hGysZ+HlroKGPnK2DAFh4KS4oP+oRTZ5llnGoLfRceE9M24n/V66JcFEh1RJQwGVbU2KjdktesM0SXlYBPVtN2qmdE+rqJ/1JJfuR58Gc/CPh6A02jHYnfDJB0PBk6PzInoPiIyxB0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8662E497;
	Thu,  8 Jan 2026 09:58:42 -0800 (PST)
Received: from ewhatever.cambridge.arm.com (ewhatever.cambridge.arm.com [10.1.197.1])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 7C9E73F5A1;
	Thu,  8 Jan 2026 09:58:46 -0800 (PST)
From: Suzuki K Poulose <suzuki.poulose@arm.com>
To: kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org,
	maz@kernel.org,
	will@kernel.org,
	oupton@kernel.org,
	aneesh.kumar@kernel.org,
	steven.price@arm.com,
	linux-kernel@vger.kernel.org,
	alexandru.elisei@arm.com,
	tabba@google.com,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [kvmtool PATCH v5 01/15] Allow pausing the VM from vcpu thread
Date: Thu,  8 Jan 2026 17:57:39 +0000
Message-ID: <20260108175753.1292097-2-suzuki.poulose@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260108175753.1292097-1-suzuki.poulose@arm.com>
References: <20260108175753.1292097-1-suzuki.poulose@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Pausing the VM from a vCPU thread doesn't work today, as it waits indefinitely
for a signal that never comes. By using the "current_kvm_cpu", enlighten the
kvm__pause() to skip the current CPU and do it inline. This also brings in a
restriction that a following kvm__continue() must be called from the same vCPU
thread.

Cc: Will Deacon <will@kernel.org>
Cc: Oliver Upton <oliver.upton@linux.dev>
Link: https://lore.kernel.org/all/20230918104028.GA17744@willie-the-truck/
Reviewed-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
Changes since: v4
 - Drop duplicate assignment of pause_req_cpu (Marc)
---
 kvm.c | 34 ++++++++++++++++++++++++++++++----
 1 file changed, 30 insertions(+), 4 deletions(-)

diff --git a/kvm.c b/kvm.c
index 07089cf1..7a52c6a8 100644
--- a/kvm.c
+++ b/kvm.c
@@ -59,6 +59,8 @@ const char *kvm_exit_reasons[] = {
 
 static int pause_event;
 static DEFINE_MUTEX(pause_lock);
+static struct kvm_cpu *pause_req_cpu;
+
 extern struct kvm_ext kvm_req_ext[];
 
 static char kvm_dir[PATH_MAX];
@@ -573,9 +575,25 @@ void kvm__reboot(struct kvm *kvm)
 
 void kvm__continue(struct kvm *kvm)
 {
+	/*
+	 * We must ensure that the resume request comes from the same context
+	 * as the one requested the pause, especially if it was issued from a
+	 * vCPU thread.
+	 */
+	if (current_kvm_cpu) {
+		if (pause_req_cpu != current_kvm_cpu ||
+		    !current_kvm_cpu->paused)
+			die("Trying to resume VM from invalid context");
+		current_kvm_cpu->paused = 0;
+	}
 	mutex_unlock(&pause_lock);
 }
 
+/*
+ * Mark all active CPUs as paused, until kvm__continue() is issued.
+ * NOTE: If this is called from a cpu thread, kvm__continue() must
+ * be called from the same thread.
+ */
 void kvm__pause(struct kvm *kvm)
 {
 	int i, paused_vcpus = 0;
@@ -590,10 +608,16 @@ void kvm__pause(struct kvm *kvm)
 	if (pause_event < 0)
 		die("Failed creating pause notification event");
 	for (i = 0; i < kvm->nrcpus; i++) {
-		if (kvm->cpus[i]->is_running && kvm->cpus[i]->paused == 0)
-			pthread_kill(kvm->cpus[i]->thread, SIGKVMPAUSE);
-		else
-			paused_vcpus++;
+		if (kvm->cpus[i]->is_running && kvm->cpus[i]->paused == 0) {
+			if (current_kvm_cpu != kvm->cpus[i]) {
+				pthread_kill(kvm->cpus[i]->thread, SIGKVMPAUSE);
+				continue;
+			} else if (current_kvm_cpu) {
+				current_kvm_cpu->paused = 1;
+				/* fall through to update our count */
+			}
+		}
+		paused_vcpus++;
 	}
 
 	while (paused_vcpus < kvm->nrcpus) {
@@ -604,6 +628,8 @@ void kvm__pause(struct kvm *kvm)
 		paused_vcpus += cur_read;
 	}
 	close(pause_event);
+	/* Remember the context requesting pause */
+	pause_req_cpu = current_kvm_cpu;
 }
 
 void kvm__notify_paused(void)
-- 
2.43.0


