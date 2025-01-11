Return-Path: <kvm+bounces-35181-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9AA2FA09FBF
	for <lists+kvm@lfdr.de>; Sat, 11 Jan 2025 01:53:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A146D7A4F70
	for <lists+kvm@lfdr.de>; Sat, 11 Jan 2025 00:53:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D843917A5BE;
	Sat, 11 Jan 2025 00:51:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="B8H4vmx5"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60FE415575C
	for <kvm@vger.kernel.org>; Sat, 11 Jan 2025 00:51:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736556665; cv=none; b=qDJuKeXN05S3Mav0LSeGop0RtKXE/92DUCf3L0iPvt/AqTDbB1Gm8Ogbd1HpZBlSmC+XzLjJKcO9ZnaRfA+qIhN5IN82J3hQ2kIAo0WoAu1rPWw5n8WGjwQz+qL+NqHnnGt3a3A96SP7lGnyHcSvMtXHvszQy00FQGFvE67tvfo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736556665; c=relaxed/simple;
	bh=P1tpMNzbS5Njgz1DwTNPeyi/z6xYk/XJDEeQ78FSaJY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=JBFo6kbPsJZbGl6cZlsji1x/r7quyscaYeEMZLMIlXl8ahFHB+vVwqlB3aHGJE78Q61mFKIFhBfOaS8gvJFCUfLvlZb8uU0Nw/TQTZpX6JsF2vdH/FyScyAvgFJtk3Eyv6g7eKJAS3JXtUrG1/TYOEavNxh0mQFJJbASpfJIhVQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=B8H4vmx5; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2ef9e38b0cfso4644122a91.0
        for <kvm@vger.kernel.org>; Fri, 10 Jan 2025 16:51:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1736556663; x=1737161463; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=wbJUIEbFpcT4LmqIjAYiV2s86GObQLOrAwx+1Pf2g7A=;
        b=B8H4vmx5U5R2RNRHEr+LTZQ00c6LwpNWanyQ11c3mRiFGK7Nx4S0FnbWAdMVq/g1I6
         QtFiaCkKbWcfpOZeNBb+qVMp2yDZTQQu/oUq3AD2Jvj7Wz/9buxOYgybffw30aNGWf0f
         EBzcZY7u8oAyASjsypleFdL11d+JKr75RdkagQeYxIoeNDmqLYRmZ7VSMoP8Zo+8IjLB
         z9PI66uCznYT4ffv8tde5hbk6HFCHEQY2l8muJd6C2dHzjYEEf6Q0SInMBb4hZdm58uL
         6Gsb4Y5Vbyd6sXIOqGF90uKfHaqtD0XHLjy4OoVJ+YiWM6yG3H06RvhFfIzay0rxulHM
         CYpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736556663; x=1737161463;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wbJUIEbFpcT4LmqIjAYiV2s86GObQLOrAwx+1Pf2g7A=;
        b=SLi36sk0CZK+otLp7i7cUgibXsxSjhAhYXdaaRKNbej6gmZtA6+vOqGSiIhrWBF8ym
         Gu3+E7zIVnOJBniXfLzOw7889v4yxrB58v5oagynye3rk3jX+Pz4xE7X+W9mVEoP0nf3
         8Vu1U6yOvfwoHdiBV4dzaaJgXF7GV1gJyi8/q9BHnH5+U1FGbzdDaWmO3T1nKpAHCTR2
         /dgStLsA2Rid+BoNZeUtVfqQfiK4R5c8cEwFi8HLHk2Qqc+TXfDRolCucachzESYURtF
         3VFdMOYQgaQ3SrV1T6lUGk/uidnqUOSNfgciVV5ejj4xkgEWs4U8ZcgRop+8IN4SyWKM
         zP8A==
X-Forwarded-Encrypted: i=1; AJvYcCWWGIPfew38754hzRmZu5jO/S8AVUPPldr49TCncSySFmmjL3ffzFjTjqjZedePV29EVik=@vger.kernel.org
X-Gm-Message-State: AOJu0YyGZZcwxjlb6gZVrah6nn82wLbrhztYLfzvHMT6B4Urnb22LUPm
	9wYt5/1uN7DJN934nJBq3cxaZNrBP95wqL/e0l9QV/QOrWMDE8jlTRgSygEUoisHu9QwbFAdkk4
	AOg==
X-Google-Smtp-Source: AGHT+IGH6342S92kOvdYD94+ymoteQzN/cfHIZ0hJZS0WFG0jyjicN3k4eAbOT3Lbu+t8kUVV+/QXmvVvSI=
X-Received: from pjboi12.prod.google.com ([2002:a17:90b:3a0c:b0:2eb:12c1:bf8f])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:270c:b0:2ee:6e22:bfd0
 with SMTP id 98e67ed59e1d1-2f548ee48demr16948021a91.21.1736556663692; Fri, 10
 Jan 2025 16:51:03 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 10 Jan 2025 16:50:47 -0800
In-Reply-To: <20250111005049.1247555-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250111005049.1247555-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.1.613.gc27f4b7a9f-goog
Message-ID: <20250111005049.1247555-8-seanjc@google.com>
Subject: [PATCH v2 7/9] KVM: selftests: Adjust number of files rlimit for all
 "standard" VMs
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Anup Patel <anup@brainfault.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, Sean Christopherson <seanjc@google.com>, 
	Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Move the max vCPUs test's RLIMIT_NOFILE adjustments to common code, and
use the new helper to adjust the resource limit for non-barebones VMs by
default.  x86's recalc_apic_map_test creates 512 vCPUs, and a future
change will open the binary stats fd for all vCPUs, which will put the
recalc APIC test above some distros' default limit of 1024.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../testing/selftests/kvm/include/kvm_util.h  |  2 ++
 .../selftests/kvm/kvm_create_max_vcpus.c      | 28 +--------------
 tools/testing/selftests/kvm/lib/kvm_util.c    | 34 +++++++++++++++++++
 3 files changed, 37 insertions(+), 27 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
index 9a64bab42f89..d4670b5962ab 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -966,6 +966,8 @@ static inline struct kvm_vm *vm_create_shape_with_one_vcpu(struct vm_shape shape
 
 struct kvm_vcpu *vm_recreate_with_one_vcpu(struct kvm_vm *vm);
 
+void kvm_set_files_rlimit(uint32_t nr_vcpus);
+
 void kvm_pin_this_task_to_pcpu(uint32_t pcpu);
 void kvm_print_vcpu_pinning_help(void);
 void kvm_parse_vcpu_pinning(const char *pcpus_string, uint32_t vcpu_to_pcpu[],
diff --git a/tools/testing/selftests/kvm/kvm_create_max_vcpus.c b/tools/testing/selftests/kvm/kvm_create_max_vcpus.c
index c78f34699f73..c5310736ed06 100644
--- a/tools/testing/selftests/kvm/kvm_create_max_vcpus.c
+++ b/tools/testing/selftests/kvm/kvm_create_max_vcpus.c
@@ -10,7 +10,6 @@
 #include <stdio.h>
 #include <stdlib.h>
 #include <string.h>
-#include <sys/resource.h>
 
 #include "test_util.h"
 
@@ -39,36 +38,11 @@ int main(int argc, char *argv[])
 {
 	int kvm_max_vcpu_id = kvm_check_cap(KVM_CAP_MAX_VCPU_ID);
 	int kvm_max_vcpus = kvm_check_cap(KVM_CAP_MAX_VCPUS);
-	/*
-	 * Number of file descriptors reqired, KVM_CAP_MAX_VCPUS for vCPU fds +
-	 * an arbitrary number for everything else.
-	 */
-	int nr_fds_wanted = kvm_max_vcpus + 100;
-	struct rlimit rl;
 
 	pr_info("KVM_CAP_MAX_VCPU_ID: %d\n", kvm_max_vcpu_id);
 	pr_info("KVM_CAP_MAX_VCPUS: %d\n", kvm_max_vcpus);
 
-	/*
-	 * Check that we're allowed to open nr_fds_wanted file descriptors and
-	 * try raising the limits if needed.
-	 */
-	TEST_ASSERT(!getrlimit(RLIMIT_NOFILE, &rl), "getrlimit() failed!");
-
-	if (rl.rlim_cur < nr_fds_wanted) {
-		rl.rlim_cur = nr_fds_wanted;
-		if (rl.rlim_max < nr_fds_wanted) {
-			int old_rlim_max = rl.rlim_max;
-			rl.rlim_max = nr_fds_wanted;
-
-			int r = setrlimit(RLIMIT_NOFILE, &rl);
-			__TEST_REQUIRE(r >= 0,
-				       "RLIMIT_NOFILE hard limit is too low (%d, wanted %d)",
-				       old_rlim_max, nr_fds_wanted);
-		} else {
-			TEST_ASSERT(!setrlimit(RLIMIT_NOFILE, &rl), "setrlimit() failed!");
-		}
-	}
+	kvm_set_files_rlimit(kvm_max_vcpus);
 
 	/*
 	 * Upstream KVM prior to 4.8 does not support KVM_CAP_MAX_VCPU_ID.
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 16ee03e76d66..f49bb504fa72 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -12,6 +12,7 @@
 #include <assert.h>
 #include <sched.h>
 #include <sys/mman.h>
+#include <sys/resource.h>
 #include <sys/types.h>
 #include <sys/stat.h>
 #include <unistd.h>
@@ -411,6 +412,37 @@ static uint64_t vm_nr_pages_required(enum vm_guest_mode mode,
 	return vm_adjust_num_guest_pages(mode, nr_pages);
 }
 
+void kvm_set_files_rlimit(uint32_t nr_vcpus)
+{
+	/*
+	 * Number of file descriptors required, nr_vpucs vCPU fds + an arbitrary
+	 * number for everything else.
+	 */
+	int nr_fds_wanted = nr_vcpus + 100;
+	struct rlimit rl;
+
+	/*
+	 * Check that we're allowed to open nr_fds_wanted file descriptors and
+	 * try raising the limits if needed.
+	 */
+	TEST_ASSERT(!getrlimit(RLIMIT_NOFILE, &rl), "getrlimit() failed!");
+
+	if (rl.rlim_cur < nr_fds_wanted) {
+		rl.rlim_cur = nr_fds_wanted;
+		if (rl.rlim_max < nr_fds_wanted) {
+			int old_rlim_max = rl.rlim_max;
+
+			rl.rlim_max = nr_fds_wanted;
+			__TEST_REQUIRE(setrlimit(RLIMIT_NOFILE, &rl) >= 0,
+				       "RLIMIT_NOFILE hard limit is too low (%d, wanted %d)",
+				       old_rlim_max, nr_fds_wanted);
+		} else {
+			TEST_ASSERT(!setrlimit(RLIMIT_NOFILE, &rl), "setrlimit() failed!");
+		}
+	}
+
+}
+
 struct kvm_vm *__vm_create(struct vm_shape shape, uint32_t nr_runnable_vcpus,
 			   uint64_t nr_extra_pages)
 {
@@ -420,6 +452,8 @@ struct kvm_vm *__vm_create(struct vm_shape shape, uint32_t nr_runnable_vcpus,
 	struct kvm_vm *vm;
 	int i;
 
+	kvm_set_files_rlimit(nr_runnable_vcpus);
+
 	pr_debug("%s: mode='%s' type='%d', pages='%ld'\n", __func__,
 		 vm_guest_mode_string(shape.mode), shape.type, nr_pages);
 
-- 
2.47.1.613.gc27f4b7a9f-goog


