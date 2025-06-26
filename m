Return-Path: <kvm+bounces-50777-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2FC7DAE934A
	for <lists+kvm@lfdr.de>; Thu, 26 Jun 2025 02:13:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D54611C220F7
	for <lists+kvm@lfdr.de>; Thu, 26 Jun 2025 00:13:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B7BF18991E;
	Thu, 26 Jun 2025 00:12:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ufvpqGi2"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2914D1494C2
	for <kvm@vger.kernel.org>; Thu, 26 Jun 2025 00:12:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750896755; cv=none; b=cWWk6Z/BMifYVb+LMC+zI5KA7RzEL+RoWDo1rvcfcR60NNGJjqBPTzb1ViHvhKwvhpffwffkisr+rEdQWFrvn+2Bce5LuFWjHP0rPld+rqrNN+zi4TgyE9V4qZOo7YR7XyI0P6n53cVsUmExFHGTOnoKVVHtg4ajWiq/iKRIQoo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750896755; c=relaxed/simple;
	bh=64rymz2Kz4S/Z4aZF2H6eAnIafN/041V9v/2O/McSuM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=oYO/X07WLZKlQGP1c+Z/GDB9GOXX3ECzb0pBOoZ5X5+ahSZUcPtZk+d6Zer8sNTJ39/fzjGiLnBXaTKo9X2c5NvSSc4JpaC0yO8xXGYJY6KrqviH9iJGbtwqVWdMsZDagsk12ZtAllexi81XQ802WWmbmXvUh3SMVIN4SjuAvt4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ufvpqGi2; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-235e1d70d67so3884875ad.0
        for <kvm@vger.kernel.org>; Wed, 25 Jun 2025 17:12:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750896753; x=1751501553; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=7jYV3TYqsZyydz0IjaYFSoLu2pCs+jwctwQKh0JY6aA=;
        b=ufvpqGi2StfUbRKMylNAPoSlUqIiXyZpmJZCyty7Y4PvfQWjkdihC+6Kj45UE/qyKd
         txBZwGdiqIJ2XKzRh+Ixnm5b8FHRUSEkJPuA4xe7zSAV/Oa/6fOUD37XdFXOngF9e7sk
         q8GBhPdAKyRHt7Yle7WQhHnxuaLwojW56uqMyZQO0N/OSoyEJBkTWM2507rQYdVBuGef
         s7YPRdABW/J+LtmpsauZXBlS4Px5vTg01C6QT3icF72MgbW43iFWgl01l20D+tYU7C4k
         Iv8QqAYCykehFG2orMA8lW6ArbQMVWqMnZnt+OCMiDGdIq+u4ZLYTvqStQ/c3LO7zNBJ
         bAPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750896753; x=1751501553;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7jYV3TYqsZyydz0IjaYFSoLu2pCs+jwctwQKh0JY6aA=;
        b=VYhcVfiTyDdKs5Zc+FKVNQ8hwVS0qQaa0bwtwdYGt985GIlCYqP3IQFFTjV1qXwYUO
         zjve/NMBTEIBasYsv0MlKMqIF0/vUxaP1LjkFk98P9f5N+oc+swhEiANRPKUq2YC3vje
         sPPc8HXzXm3/LOijEkYxR60Mj1WqLL0g0ZBdr/+hte5NeK2wQK/m5osHFzYZOZ23p9Nf
         eDd8c1Bciw5l9tws4b/gRfpm6pr9lvYg91h1UVbB2RKxF3cxchkxI2qEwtY6/otZlRSp
         FBk9p2VRMFYVMxn6/R9awq3sKPogX3oXDEKe5QpZBl9Jt48q4Cn1H2Rr4aEs/nEmTf1V
         4gpQ==
X-Gm-Message-State: AOJu0YxKjvFJZ0K/CMWhOTmj3VSD2+PSHOkpaHPk0CYJ/3G3n4Y7HrZy
	9eh/MKjc8xV0M6HrLUTDqwgQImHoymTZZrqghJSCYpFx7VZe5CFM6dDIYWJOIjeYp4fm2bMJ9k1
	t1uY6aA==
X-Google-Smtp-Source: AGHT+IEokWeu3xZE8pF2I2mOTnRiQq8sbkVZWMeUSzDfllmerKjnZZu1jBEaneetis5nr35QOidy+TLEhOA=
X-Received: from pjbta6.prod.google.com ([2002:a17:90b:4ec6:b0:312:e5dd:9248])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:2f10:b0:223:f9a4:3f99
 with SMTP id d9443c01a7336-23824044733mr89766355ad.29.1750896753599; Wed, 25
 Jun 2025 17:12:33 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 25 Jun 2025 17:12:23 -0700
In-Reply-To: <20250626001225.744268-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250626001225.744268-1-seanjc@google.com>
X-Mailer: git-send-email 2.50.0.727.gbf7dc18ff4-goog
Message-ID: <20250626001225.744268-4-seanjc@google.com>
Subject: [PATCH v5 3/5] KVM: selftests: Expand set of APIs for pinning tasks
 to a single CPU
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, 
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, 
	Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"

Expand kvm_pin_this_task_to_pcpu() into a set of APIs to allow pinning a
task (or self) to a CPU (any or specific).  This will allow deduplicating
code throughout a variety of selftests.

Opportunistically use "self" instead of "this_task" as it is both more
concise and less ambiguous.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../testing/selftests/kvm/include/kvm_util.h  | 31 ++++++++++++++++++-
 tools/testing/selftests/kvm/lib/kvm_util.c    | 15 +++++----
 tools/testing/selftests/kvm/lib/memstress.c   |  2 +-
 3 files changed, 38 insertions(+), 10 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
index 91908d4a6edf..23a506d7eca3 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -21,6 +21,8 @@
 #include <sys/eventfd.h>
 #include <sys/ioctl.h>
 
+#include <pthread.h>
+
 #include "kvm_util_arch.h"
 #include "kvm_util_types.h"
 #include "sparsebit.h"
@@ -1054,7 +1056,34 @@ struct kvm_vcpu *vm_recreate_with_one_vcpu(struct kvm_vm *vm);
 
 void kvm_set_files_rlimit(uint32_t nr_vcpus);
 
-void kvm_pin_this_task_to_pcpu(uint32_t pcpu);
+int __pin_task_to_cpu(pthread_t task, int cpu);
+
+static inline void pin_task_to_cpu(pthread_t task, int cpu)
+{
+	int r;
+
+	r = __pin_task_to_cpu(task, cpu);
+	TEST_ASSERT(!r, "Failed to set thread affinity to pCPU '%u'", cpu);
+}
+
+static inline int pin_task_to_any_cpu(pthread_t task)
+{
+	int cpu = sched_getcpu();
+
+	pin_task_to_cpu(task, cpu);
+	return cpu;
+}
+
+static inline void pin_self_to_cpu(int cpu)
+{
+	pin_task_to_cpu(pthread_self(), cpu);
+}
+
+static inline int pin_self_to_any_cpu(void)
+{
+	return pin_task_to_any_cpu(pthread_self());
+}
+
 void kvm_print_vcpu_pinning_help(void);
 void kvm_parse_vcpu_pinning(const char *pcpus_string, uint32_t vcpu_to_pcpu[],
 			    int nr_vcpus);
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 90f90f1c194f..c3f5142b0a54 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -620,15 +620,14 @@ struct kvm_vcpu *vm_recreate_with_one_vcpu(struct kvm_vm *vm)
 	return vm_vcpu_recreate(vm, 0);
 }
 
-void kvm_pin_this_task_to_pcpu(uint32_t pcpu)
+int __pin_task_to_cpu(pthread_t task, int cpu)
 {
-	cpu_set_t mask;
-	int r;
+	cpu_set_t cpuset;
 
-	CPU_ZERO(&mask);
-	CPU_SET(pcpu, &mask);
-	r = sched_setaffinity(0, sizeof(mask), &mask);
-	TEST_ASSERT(!r, "sched_setaffinity() failed for pCPU '%u'.", pcpu);
+	CPU_ZERO(&cpuset);
+	CPU_SET(cpu, &cpuset);
+
+	return pthread_setaffinity_np(task, sizeof(cpuset), &cpuset);
 }
 
 static uint32_t parse_pcpu(const char *cpu_str, const cpu_set_t *allowed_mask)
@@ -682,7 +681,7 @@ void kvm_parse_vcpu_pinning(const char *pcpus_string, uint32_t vcpu_to_pcpu[],
 
 	/* 2. Check if the main worker needs to be pinned. */
 	if (cpu) {
-		kvm_pin_this_task_to_pcpu(parse_pcpu(cpu, &allowed_mask));
+		pin_self_to_cpu(parse_pcpu(cpu, &allowed_mask));
 		cpu = strtok(NULL, delim);
 	}
 
diff --git a/tools/testing/selftests/kvm/lib/memstress.c b/tools/testing/selftests/kvm/lib/memstress.c
index 313277486a1d..557c0a0a5658 100644
--- a/tools/testing/selftests/kvm/lib/memstress.c
+++ b/tools/testing/selftests/kvm/lib/memstress.c
@@ -265,7 +265,7 @@ static void *vcpu_thread_main(void *data)
 	int vcpu_idx = vcpu->vcpu_idx;
 
 	if (memstress_args.pin_vcpus)
-		kvm_pin_this_task_to_pcpu(memstress_args.vcpu_to_pcpu[vcpu_idx]);
+		pin_self_to_cpu(memstress_args.vcpu_to_pcpu[vcpu_idx]);
 
 	WRITE_ONCE(vcpu->running, true);
 
-- 
2.50.0.727.gbf7dc18ff4-goog


