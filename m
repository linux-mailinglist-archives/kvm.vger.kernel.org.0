Return-Path: <kvm+bounces-35182-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EAB8DA09FBD
	for <lists+kvm@lfdr.de>; Sat, 11 Jan 2025 01:53:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2DFEF3A1E1C
	for <lists+kvm@lfdr.de>; Sat, 11 Jan 2025 00:53:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 92354187342;
	Sat, 11 Jan 2025 00:51:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="CL4GneyD"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1F4B16C687
	for <kvm@vger.kernel.org>; Sat, 11 Jan 2025 00:51:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736556668; cv=none; b=gR8DECy711wQXYUAWcorHvFo9830h5IfYc296bN9XN67i7HK/WATgu6MtGKKes3H6zXXBod4L6CdDS71aEgKF1ym6//C6uA9i9OoSmEmQ5k6Avk+hBR27cg7/hxoQHSVMtyhZfEJPcv5EE0VWmYbT+r5P+TBWt5DOSRU/D/g7cs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736556668; c=relaxed/simple;
	bh=icJ/SksT713q+MIz2dX20BPrbRU3ISPR44l7a9C713I=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=mnAozlPuN5bhZjJ0NkwGJJKZZfC776xBhNP9KswWSj9tiUZsYobo5bsA+yuJgUb4CBv3QFIIxuxU7PJViiKHJpKigwDoSH3EphNeZ7lYsmkqAKWfjFuRrI510TevZDoi9loLKXHDsyRWSqm8ZBeWChQYPyNZBqxrQa7xvVlcQpQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=CL4GneyD; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2ee5616e986so6637172a91.2
        for <kvm@vger.kernel.org>; Fri, 10 Jan 2025 16:51:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1736556665; x=1737161465; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=jTPjKFoWnkMFK18trrM7yX38QagKVQtox0CY8pTl0Bc=;
        b=CL4GneyDPu/q9YXz07J1h1D92k6IGZXthw/Sf7/4E8Qxv+nnz6O9bMRDDc7aZRHE80
         0RlIwURKkQSsjD0eglqZhudloQgJ1fhiIKGeZGyGH6hQaloz354K7FZrhUwyu7FiEzlf
         uvyv9fRd/2OqSGksNjbxz8mVh7DPa8J6cWJyTDewpQisjVSPVqCEU0gKEJKa2/lf8Yge
         qihn1T6r5wf28se6882mG1rAr8cW0bdC3GdjFAjel8nGkKYcdcK7RbJoiROrTc7EWtiz
         omxy1Oo5B28FjJWj/Bp8N6ng1GvRBeAEBVcEQFd1DE4ugMnNIn6NhHBqc367RAIjNVq7
         +8CQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736556665; x=1737161465;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jTPjKFoWnkMFK18trrM7yX38QagKVQtox0CY8pTl0Bc=;
        b=lV+NIv7NSUZlalJMo87PFAgTNKGsX2t/IaPM2fQILvB63vZewyTVpRUMaTv6MGJcCy
         w08DAThEvMSRAPqML9YihE+dHrz1p5/6LZXdE+URkOMOVXnptDSbXubEFgS8upxeCHYu
         jx+KNaFj/xLOPZYKSF5YORUweB8hjyTFzv4WKOT0dYRWpI51JPJZpjPvkJ6bM/TtD0uV
         w6a3eX+wK4o5YLUuuRQ+IN9ycWZIkQI8pSSMb6uv71dvi4ZJalUJZjSjnWz8gtNrJEQs
         Zy66uChD4x9sKrnYpm16968kdznB1Edi1jGURZA7uvyn4lgZBFEBAsl7HNDDtPOp1oUE
         2wpw==
X-Forwarded-Encrypted: i=1; AJvYcCUP0yWFxYwPsGtGZtxedhfZRZ1FM++wQ7cVYLwpyTJF6I2klX+uodPjEaMZQSYh172rDWA=@vger.kernel.org
X-Gm-Message-State: AOJu0YzU8yBJ8vQ+H4xYGTNmlpHF4R5sJ5NVPR4xR9IjrPfpFzqX24BT
	YyP0jYbCPfF1DiHKfREJWyj1KYhp6J7y1kg1njUKoU+kcTv3BBzTfc2O6GW1I7JyDet0WMqBfqi
	C7Q==
X-Google-Smtp-Source: AGHT+IFOLE/1SSJYHsGdzvK8LKxhrHPTw3kVbRGTeeJk8BpZZB2Ck9vGEUtjLxLwAqw4e0hK1JN9nSs0EVE=
X-Received: from pjbsg5.prod.google.com ([2002:a17:90b:5205:b0:2ee:3cc1:793d])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2c84:b0:2ea:a25d:3baa
 with SMTP id 98e67ed59e1d1-2f548f17351mr17744741a91.5.1736556665395; Fri, 10
 Jan 2025 16:51:05 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 10 Jan 2025 16:50:48 -0800
In-Reply-To: <20250111005049.1247555-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250111005049.1247555-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.1.613.gc27f4b7a9f-goog
Message-ID: <20250111005049.1247555-9-seanjc@google.com>
Subject: [PATCH v2 8/9] KVM: selftests: Add infrastructure for getting vCPU
 binary stats
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

Now that the binary stats cache infrastructure is largely scope agnostic,
add support for vCPU-scoped stats.  Like VM stats, open and cache the
stats FD when the vCPU is created so that it's guaranteed to be valid when
vcpu_get_stats() is invoked.

Account for the extra per-vCPU file descriptor in kvm_set_files_rlimit(),
so that tests that create large VMs don't run afoul of resource limits.

To sanity check that the infrastructure actually works, and to get a bit
of bonus coverage, add an assert in x86's xapic_ipi_test to verify that
the number of HLTs executed by the test matches the number of HLT exits
observed by KVM.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../testing/selftests/kvm/include/kvm_util.h  | 20 +++++++-----
 tools/testing/selftests/kvm/lib/kvm_util.c    | 32 ++++++++-----------
 .../selftests/kvm/x86/xapic_ipi_test.c        |  2 ++
 3 files changed, 27 insertions(+), 27 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
index d4670b5962ab..373912464fb4 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -61,6 +61,7 @@ struct kvm_vcpu {
 #ifdef __x86_64__
 	struct kvm_cpuid2 *cpuid;
 #endif
+	struct kvm_binary_stats stats;
 	struct kvm_dirty_gfn *dirty_gfns;
 	uint32_t fetch_index;
 	uint32_t dirty_gfns_count;
@@ -534,17 +535,20 @@ void read_stat_data(int stats_fd, struct kvm_stats_header *header,
 		    struct kvm_stats_desc *desc, uint64_t *data,
 		    size_t max_elements);
 
-void __vm_get_stat(struct kvm_vm *vm, const char *stat_name, uint64_t *data,
-		   size_t max_elements);
+void kvm_get_stat(struct kvm_binary_stats *stats, const char *name,
+		  uint64_t *data, size_t max_elements);
 
-#define vm_get_stat(vm, stat)				\
-({							\
-	uint64_t data;					\
-							\
-	__vm_get_stat(vm, #stat, &data, 1);		\
-	data;						\
+#define __get_stat(stats, stat)							\
+({										\
+	uint64_t data;								\
+										\
+	kvm_get_stat(stats, #stat, &data, 1);					\
+	data;									\
 })
 
+#define vm_get_stat(vm, stat) __get_stat(&(vm)->stats, stat)
+#define vcpu_get_stat(vcpu, stat) __get_stat(&(vcpu)->stats, stat)
+
 void vm_create_irqchip(struct kvm_vm *vm);
 
 static inline int __vm_create_guest_memfd(struct kvm_vm *vm, uint64_t size,
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index f49bb504fa72..b1c3c7260902 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -415,10 +415,11 @@ static uint64_t vm_nr_pages_required(enum vm_guest_mode mode,
 void kvm_set_files_rlimit(uint32_t nr_vcpus)
 {
 	/*
-	 * Number of file descriptors required, nr_vpucs vCPU fds + an arbitrary
-	 * number for everything else.
+	 * Each vCPU will open two file descriptors: the vCPU itself and the
+	 * vCPU's binary stats file descriptor.  Add an arbitrary amount of
+	 * buffer for all other files a test may open.
 	 */
-	int nr_fds_wanted = nr_vcpus + 100;
+	int nr_fds_wanted = nr_vcpus * 2 + 100;
 	struct rlimit rl;
 
 	/*
@@ -746,6 +747,8 @@ static void vm_vcpu_rm(struct kvm_vm *vm, struct kvm_vcpu *vcpu)
 	ret = close(vcpu->fd);
 	TEST_ASSERT(!ret,  __KVM_SYSCALL_ERROR("close()", ret));
 
+	kvm_stats_release(&vcpu->stats);
+
 	list_del(&vcpu->list);
 
 	vcpu_arch_free(vcpu);
@@ -1339,6 +1342,11 @@ struct kvm_vcpu *__vm_vcpu_add(struct kvm_vm *vm, uint32_t vcpu_id)
 	TEST_ASSERT(vcpu->run != MAP_FAILED,
 		    __KVM_SYSCALL_ERROR("mmap()", (int)(unsigned long)MAP_FAILED));
 
+	if (kvm_has_cap(KVM_CAP_BINARY_STATS_FD))
+		vcpu->stats.fd = vcpu_get_stats_fd(vcpu);
+	else
+		vcpu->stats.fd = -1;
+
 	/* Add to linked-list of VCPUs. */
 	list_add(&vcpu->list, &vm->vcpus);
 
@@ -2251,23 +2259,9 @@ void read_stat_data(int stats_fd, struct kvm_stats_header *header,
 		    desc->name, size, ret);
 }
 
-/*
- * Read the data of the named stat
- *
- * Input Args:
- *   vm - the VM for which the stat should be read
- *   stat_name - the name of the stat to read
- *   max_elements - the maximum number of 8-byte values to read into data
- *
- * Output Args:
- *   data - the buffer into which stat data should be read
- *
- * Read the data values of a specified stat from the binary stats interface.
- */
-void __vm_get_stat(struct kvm_vm *vm, const char *name, uint64_t *data,
-		   size_t max_elements)
+void kvm_get_stat(struct kvm_binary_stats *stats, const char *name,
+		  uint64_t *data, size_t max_elements)
 {
-	struct kvm_binary_stats *stats = &vm->stats;
 	struct kvm_stats_desc *desc;
 	size_t size_desc;
 	int i;
diff --git a/tools/testing/selftests/kvm/x86/xapic_ipi_test.c b/tools/testing/selftests/kvm/x86/xapic_ipi_test.c
index a76078a08ff8..574a944763b7 100644
--- a/tools/testing/selftests/kvm/x86/xapic_ipi_test.c
+++ b/tools/testing/selftests/kvm/x86/xapic_ipi_test.c
@@ -465,6 +465,8 @@ int main(int argc, char *argv[])
 	cancel_join_vcpu_thread(threads[0], params[0].vcpu);
 	cancel_join_vcpu_thread(threads[1], params[1].vcpu);
 
+	TEST_ASSERT_EQ(data->hlt_count, vcpu_get_stat(params[0].vcpu, halt_exits));
+
 	fprintf(stderr,
 		"Test successful after running for %d seconds.\n"
 		"Sending vCPU sent %lu IPIs to halting vCPU\n"
-- 
2.47.1.613.gc27f4b7a9f-goog


