Return-Path: <kvm+bounces-34201-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id AA6439F89A4
	for <lists+kvm@lfdr.de>; Fri, 20 Dec 2024 02:42:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D8B0A1888852
	for <lists+kvm@lfdr.de>; Fri, 20 Dec 2024 01:42:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1450917BEBF;
	Fri, 20 Dec 2024 01:39:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Al7Oj66y"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8ABF9186E54
	for <kvm@vger.kernel.org>; Fri, 20 Dec 2024 01:39:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734658763; cv=none; b=itQUNy52dmXVor2KbN2xJbS0I1s8fBgOelxJC895BDPRvC7LFIW/TQiuhS9aAAvzd4tkKHbK2pHM5y4rtrZkSxskrsNiJBrQudK63eMFze10K4OP8+dycc0knlHOQ9WTq4uFMFJkrsi3c6INaDZk9xnMeBnnwFqnseF3HnPa2Rk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734658763; c=relaxed/simple;
	bh=B+RJp0TYVNSYdkENveDWwDdnsH059YtVcZm9zws4alI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=KFllteyVk8tqZpOYPsuFTNaZ1SHx3KCHTE1q0AzdHEZFpQhywDCuokN+t7kyOmWoKRJZuEEd46XmxNRePAC5xuIuLHp/t+RAd+7zcWQI35Hegi5d+ugLOA8vtzIWbg5vOMtuUS3xk7DM/gBDYGrBf1mcmfVM6dyacqLp7/dpBuo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Al7Oj66y; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2ef9da03117so1749213a91.1
        for <kvm@vger.kernel.org>; Thu, 19 Dec 2024 17:39:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1734658761; x=1735263561; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=dH5y8/UE39Fu2msLM/JJYa9i5LZG9N1ZOJAUvzMfFnk=;
        b=Al7Oj66ydz8dPcNCKh4q0gXlV+MOOD7aAQQss8of06t7hMxi8z628f6gqgD31Gt4e3
         xFGXY1rp5/2MnBm+nuwk2tU+sP6i9nFCt1dOV1CfDpy20vbNF6//WJIoCiYmNjHgy5lG
         4m1hr2EgYoec88H0VzD5XRBtf400nA7y9esYkYd/WnJic/x1UUD5enbSaSxknGgBF/8x
         143vgHGBG7Ylv4jDXWJbVYq+JHXTcPvbNdG8Ezk6JOQWy6pqPUfLAjkp4U5ORG5cyPtl
         HhkI0P/zruV+JrU//Cg18PW9Zn7V9gYubXSdcHWf6RJyo+jRu/RxiQIMcaOBrOc2D7TX
         ThxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734658761; x=1735263561;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dH5y8/UE39Fu2msLM/JJYa9i5LZG9N1ZOJAUvzMfFnk=;
        b=G7wEr0xEcL/HIsukZAodefAkukNTN17F8CTflfO92JG0vAlGaIzThliyoEXAk3FECW
         G0FLTKSHf8IIr3v80+m/OcsPGhojEY05R0VLRZhMTcApG1XsU5737oJuy7H2Q5NMC72B
         OGUMzwxnXHsgFnALJq7wis/KqRMO2S+OcspZCINYQ0uCS73TtajcybdKaDKqHHfZgoCl
         8AM9VJF2afITCONgFeL/Ifvck4IoeugwlKOqeaK9Je6o6N4g8o4/9n/cYBIcgfmJm0eD
         OTxZkJp49zlwccuZc1AyMQs7j5MTyiv79EUylXfVrGwYz9ezGjKNYIG44LSjyHMOJmKU
         XGqA==
X-Forwarded-Encrypted: i=1; AJvYcCUSh9FouBtl0VxHzlgLzPP2B94ELQA/Xq/q0Jubvy6syNTBRo7SN4aLa5cF5lt9JNRdLO0=@vger.kernel.org
X-Gm-Message-State: AOJu0YxmyC2HYQlY4o+n9wwmFV/u/5MI94jRYMjFP92XYoB0HduU+4iT
	N1h+z/57vKH6TIn+4HchZdM38S2gkIAmtBoiowfO490E7Qz41ndd0uu4HbWBDYRj3aVjFV6q0My
	+3w==
X-Google-Smtp-Source: AGHT+IEWDX/fMBQN37LNDm8pwZAbb4nPz2A12lsLKXmgW0NfsvdhBH23GcxtGNe29UPGQ7kGMBybcOA6PXg=
X-Received: from pjbqn15.prod.google.com ([2002:a17:90b:3d4f:b0:2ef:8612:dd6b])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:e18b:b0:2ee:9902:18b4
 with SMTP id 98e67ed59e1d1-2f452ee838bmr1687135a91.27.1734658760980; Thu, 19
 Dec 2024 17:39:20 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 19 Dec 2024 17:39:05 -0800
In-Reply-To: <20241220013906.3518334-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241220013906.3518334-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.1.613.gc27f4b7a9f-goog
Message-ID: <20241220013906.3518334-8-seanjc@google.com>
Subject: [PATCH 7/8] KVM: selftests: Add infrastructure for getting vCPU
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

To sanity check that the infrastructure actually works, and to get a bit
of bonus coverage, add an assert in x86's xapic_ipi_test to verify that
the number of HLTs executed by the test matches the number of HLT exits
observed by KVM.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../testing/selftests/kvm/include/kvm_util.h  | 20 +++++++++------
 tools/testing/selftests/kvm/lib/kvm_util.c    | 25 +++++++------------
 .../selftests/kvm/x86/xapic_ipi_test.c        |  2 ++
 3 files changed, 23 insertions(+), 24 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
index 9a64bab42f89..e0d23873158e 100644
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
index 16ee03e76d66..99fe8bcd2346 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -712,6 +712,8 @@ static void vm_vcpu_rm(struct kvm_vm *vm, struct kvm_vcpu *vcpu)
 	ret = close(vcpu->fd);
 	TEST_ASSERT(!ret,  __KVM_SYSCALL_ERROR("close()", ret));
 
+	kvm_stats_release(&vcpu->stats);
+
 	list_del(&vcpu->list);
 
 	vcpu_arch_free(vcpu);
@@ -1305,6 +1307,11 @@ struct kvm_vcpu *__vm_vcpu_add(struct kvm_vm *vm, uint32_t vcpu_id)
 	TEST_ASSERT(vcpu->run != MAP_FAILED,
 		    __KVM_SYSCALL_ERROR("mmap()", (int)(unsigned long)MAP_FAILED));
 
+	if (kvm_has_cap(KVM_CAP_BINARY_STATS_FD))
+		vcpu->stats.fd = vcpu_get_stats_fd(vcpu);
+	else
+		vcpu->stats.fd = -1;
+
 	/* Add to linked-list of VCPUs. */
 	list_add(&vcpu->list, &vm->vcpus);
 
@@ -2217,23 +2224,9 @@ void read_stat_data(int stats_fd, struct kvm_stats_header *header,
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


