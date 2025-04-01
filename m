Return-Path: <kvm+bounces-42322-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7F2BBA77DAB
	for <lists+kvm@lfdr.de>; Tue,  1 Apr 2025 16:27:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5AD3C3B0D4C
	for <lists+kvm@lfdr.de>; Tue,  1 Apr 2025 14:23:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6976D205AD6;
	Tue,  1 Apr 2025 14:22:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="I4CVfNX6"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AA28204859
	for <kvm@vger.kernel.org>; Tue,  1 Apr 2025 14:22:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743517363; cv=none; b=MsE4rhoupT8h/tmtvr7BouMnbL21QHikYQQJZzk2TQE5eZIuT16+tYgsUiOENsyFMBovyHD9TaowiEEr9YnA78oH8HeLJwY8dldyLzHEYYDNPslnxa/pG46YuqjtoGgZQ0848UhrL923VHf4xvZgXzZsITsBpgxBGlmBe0zeSPo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743517363; c=relaxed/simple;
	bh=sw+aC5ewjJj5UHGw0yY9U0SXiO6WO4oeB/HY4wRa14o=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=tMNH4x/24aCqsH4PZCVNVCMgrR5s9/8TeAOdt1CLm9D5Yxfaxzzo+opDabLPdifKW8NJeO17IE/6vE8Cg+X6iFtIIF1IVxjjvs6IZWDIdFFCqPc7Ts4CKnhaTWOL1F0XJowqiztNjUa5U4pGWy+BvCi2M8tWVb4KuRufM62tb84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=I4CVfNX6; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-224191d9228so3577485ad.3
        for <kvm@vger.kernel.org>; Tue, 01 Apr 2025 07:22:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1743517361; x=1744122161; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GRRQLmB2UHTKWjLPNOKgO+07J02Vyv6Q87GOygHVBSc=;
        b=I4CVfNX692iIbBsdOeBa+thYY68GzkY0qyOgrjD8DP7/JeYyvNmgXFfReshST3eu8+
         d50ABGowy1Mdlinu+zbR0BCyBz79x9qFKlm5f/CR1m13CJqT5NoBArwPOmv2HjZyRo5g
         DiNmI/E/RxDp0i4up87S6gZtVhPSePmEx3lAUhhjGjgAdbUKqHPyEExVVWeBRsCzg2tt
         l7ug4IZ8fu40FSLy3TdMaA4NOSqm3QfxXPhUhTu7kobjsgiN+XUrn60ssvMTiNNOmaPt
         5DsfggPVpR2oSjd6G9SvFNbqItAeGj01jTXTDZkUUhWDxBOOE3jqqORpH4PLPNmwn4wd
         qHdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743517361; x=1744122161;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GRRQLmB2UHTKWjLPNOKgO+07J02Vyv6Q87GOygHVBSc=;
        b=VqtjIqp0ztAlrFIRSVuNs3H2NB4BbhyQyliwpuPy3jUMQFzjBXHS3JywxaSJto8ZBy
         LjhXFxWYurZboUAEcfs8YDtkEVuPynRVzQKCiIMy7jHUVLsqSYrSlH0B7rtjd0jL11hw
         x+RnOW0cRRBCrVw2UihW11y88Dq6AhgIcl5n0WDN4zpxyIQLgrka4lHU6j/ilua8F9pI
         kchEOYJCe/zjJxVqcG2RMeMY+pEUCPZb4PqmTYoHx2yQVLjRNV0JkVCA3eUf9DMjoL2q
         YAkpKQ/5S0boLyO9YTkq6stL5lFYTMILLNUnFAn83VdcqQ+rBdHtkfiaIqDkPpuQr/Gp
         mslA==
X-Gm-Message-State: AOJu0YzKHouvWsnqpVvu6kmbyzn3stNqHmehINtakzcPu8imcqOibmku
	U7vDzYnjzxgtZ6/jic+KGyrMTNv0WZt9fV+JhXm2rdaIZw/WZrrEv+7PGzBhUf08HbBSdOdVsSx
	xBw==
X-Google-Smtp-Source: AGHT+IEj5AB9UPwSuBWy7y5gfFeTD62CFXIYtj8wLb2uV6AxixKP7fkmJtTBIxCecQBTTXeak4Qv5N/DQ9g=
X-Received: from pfbhx12.prod.google.com ([2002:a05:6a00:898c:b0:732:6425:de9a])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:d489:b0:220:e9ef:ec98
 with SMTP id d9443c01a7336-2292f9629bemr199164595ad.19.1743517361442; Tue, 01
 Apr 2025 07:22:41 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue,  1 Apr 2025 07:22:38 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.49.0.472.ge94155a9ec-goog
Message-ID: <20250401142238.819487-1-seanjc@google.com>
Subject: [PATCH] KVM: selftests: Add option to rseq test to override /dev/cpu_dma_latency
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Dongsheng Zhang <dongsheng.x.zhang@intel.com>, Zide Chen <zide.chen@intel.com>, 
	Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

Add a "-l <latency>" param to the rseq test so that the user can override
/dev/cpu_dma_latency, as described by the test's suggested workaround for
not being able to complete enough migrations.

cpu_dma_latency is not a normal file, even as far as procfs files go.
Writes to cpu_dma_latency only persist so long as the file is open, e.g.
so that the kernel automatically reverts back to a power-optimized state
once the sensitive workload completes.  Provide the necessary functionality
instead of effectively forcing the user to write a non-obvious wrapper.

Cc: Dongsheng Zhang <dongsheng.x.zhang@intel.com>
Cc: Zide Chen <zide.chen@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/rseq_test.c | 31 ++++++++++++++++++++-----
 1 file changed, 25 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/kvm/rseq_test.c b/tools/testing/selftests/kvm/rseq_test.c
index e5898678bfab..1375fca80bcd 100644
--- a/tools/testing/selftests/kvm/rseq_test.c
+++ b/tools/testing/selftests/kvm/rseq_test.c
@@ -196,25 +196,27 @@ static void calc_min_max_cpu(void)
 static void help(const char *name)
 {
 	puts("");
-	printf("usage: %s [-h] [-u]\n", name);
+	printf("usage: %s [-h] [-u] [-l latency]\n", name);
 	printf(" -u: Don't sanity check the number of successful KVM_RUNs\n");
+	printf(" -l: Set /dev/cpu_dma_latency to suppress deep sleep states\n");
 	puts("");
 	exit(0);
 }
 
 int main(int argc, char *argv[])
 {
+	int r, i, snapshot, opt, fd = -1, latency = -1;
 	bool skip_sanity_check = false;
-	int r, i, snapshot;
 	struct kvm_vm *vm;
 	struct kvm_vcpu *vcpu;
 	u32 cpu, rseq_cpu;
-	int opt;
 
-	while ((opt = getopt(argc, argv, "hu")) != -1) {
+	while ((opt = getopt(argc, argv, "hl:u")) != -1) {
 		switch (opt) {
 		case 'u':
 			skip_sanity_check = true;
+		case 'l':
+			latency = atoi_paranoid(optarg);
 			break;
 		case 'h':
 		default:
@@ -243,6 +245,20 @@ int main(int argc, char *argv[])
 	pthread_create(&migration_thread, NULL, migration_worker,
 		       (void *)(unsigned long)syscall(SYS_gettid));
 
+	if (latency >= 0) {
+		/*
+		 * Writes to cpu_dma_latency persist only while the file is
+		 * open, i.e. it allows userspace to provide guaranteed latency
+		 * while running a workload.  Keep the file open until the test
+		 * completes, otherwise writing cpu_dma_latency is meaningless.
+		 */
+		fd = open("/dev/cpu_dma_latency", O_RDWR);
+		TEST_ASSERT(fd >= 0, __KVM_SYSCALL_ERROR("open() /dev/cpu_dma_latency", fd));
+
+		r = write(fd, &latency, 4);
+		TEST_ASSERT(r >= 1, "Error setting /dev/cpu_dma_latency");
+	}
+
 	for (i = 0; !done; i++) {
 		vcpu_run(vcpu);
 		TEST_ASSERT(get_ucall(vcpu, NULL) == UCALL_SYNC,
@@ -278,6 +294,9 @@ int main(int argc, char *argv[])
 			    "rseq CPU = %d, sched CPU = %d", rseq_cpu, cpu);
 	}
 
+	if (fd > 0)
+		close(fd);
+
 	/*
 	 * Sanity check that the test was able to enter the guest a reasonable
 	 * number of times, e.g. didn't get stalled too often/long waiting for
@@ -293,8 +312,8 @@ int main(int argc, char *argv[])
 	TEST_ASSERT(skip_sanity_check || i > (NR_TASK_MIGRATIONS / 2),
 		    "Only performed %d KVM_RUNs, task stalled too much?\n\n"
 		    "  Try disabling deep sleep states to reduce CPU wakeup latency,\n"
-		    "  e.g. via cpuidle.off=1 or setting /dev/cpu_dma_latency to '0',\n"
-		    "  or run with -u to disable this sanity check.", i);
+		    "  e.g. via cpuidle.off=1 or via -l <latency>, or run with -u to\n"
+		    "  disable this sanity check.", i);
 
 	pthread_join(migration_thread, NULL);
 

base-commit: 782f9feaa9517caf33186dcdd6b50a8f770ed29b
-- 
2.49.0.472.ge94155a9ec-goog


