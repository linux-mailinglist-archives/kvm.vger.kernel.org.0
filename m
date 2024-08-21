Return-Path: <kvm+bounces-24798-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D611E95A5DE
	for <lists+kvm@lfdr.de>; Wed, 21 Aug 2024 22:29:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 072CA1C22C0B
	for <lists+kvm@lfdr.de>; Wed, 21 Aug 2024 20:29:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5053617B4E1;
	Wed, 21 Aug 2024 20:28:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="CYIGYeoN"
X-Original-To: kvm@vger.kernel.org
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD924175D44;
	Wed, 21 Aug 2024 20:28:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724272115; cv=none; b=H61/YSLAXtcCqGqPKLxE8lEqjer4kbHgpAO/4o0Me3zz0C4RYqBzQKm1YGRr1y0ZcNcpHGYbUHM5QU6Hs1QiOIS7aumYyUe1oaNIwCIbleD4dowy7y3+f3K7QvFiJpWcov4PID8Y3btSqVy1agO8Oz0IvQVVJjOcmzZlkFXZ6SY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724272115; c=relaxed/simple;
	bh=zhYvuRfsmvYozZROGCUyto52jsKNY3QqVc8r5eQUgYc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jmti6RZDdyIearABuoGdMBEIKdwG821//PVMCoWHpnbUFaG/MZPXcSkycvqBacFhCXqfrKhUYo7+yrzSDveiARmWLoXiZoyB1wMMGq77Ua/HGVCE5EZi3ebLUWarr98DZz4CTQvKLsNIOimDtztOWETc4efFr2ccoVl3TPIuzqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=desiato.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=CYIGYeoN; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=desiato.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=y07ALXmdNM/dzK4Ybsd0kGURE7f/SjK1VeGfZzQy5jw=; b=CYIGYeoN6k9TZFC8USMKRiPKDt
	YRJLoJQWww608HgIcIsZD/WNbjwsICzFR/t/s3egwyrUEeAB8W2WJrDbvAQBRbdnnYUrYf66CFYAI
	EU9b9k6jVRGxBmz/WepyyqXECB7hBcyj6n06H/Spgnm7YAJyGMHOjzJfg6TWW4Q0IBv/sffp1Za8U
	Aaxc8cGLDy0/dJnP2tRsGltQJKtb0Bt4gYpvEWIa2oW7gODSQz4M/HuiV+8wG1c3DPiA93PcxMfZ2
	vDD8vH4unXrCqdYQWZ12EhwQQC09WhIgc9iCBlEvv6GpyIFulvwE5+2LFb2PRpWemCfOlpN6TrPX+
	kNwevO2Q==;
Received: from [2001:8b0:10b:1::ebe] (helo=i7.infradead.org)
	by desiato.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sgrwG-00000009hco-1hLr;
	Wed, 21 Aug 2024 20:28:18 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sgrwE-00000002z91-1NWg;
	Wed, 21 Aug 2024 21:28:14 +0100
From: David Woodhouse <dwmw2@infradead.org>
To: Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	"Hussain, Mushahid" <hmushi@amazon.co.uk>
Cc: Vitaly Kuznetsov <vkuznets@redhat.com>,
	Wanpeng Li <wanpengli@tencent.com>,
	Jim Mattson <jmattson@google.com>,
	Joerg Roedel <joro@8bytes.org>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Mingwei Zhang <mizhang@google.com>,
	Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH v3 5/5] DO NOT MERGE: Hack-a-test to verify gpc invalidation+refresh
Date: Wed, 21 Aug 2024 21:28:13 +0100
Message-ID: <20240821202814.711673-5-dwmw2@infradead.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240821202814.711673-1-dwmw2@infradead.org>
References: <20240821202814.711673-1-dwmw2@infradead.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: David Woodhouse <dwmw2@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by desiato.infradead.org. See http://www.infradead.org/rpr.html

From: Sean Christopherson <seanjc@google.com>

Add a VM-wide gfn=>pfn cache and a fake MSR to let userspace control the
cache.  On writes, reflect the value of the MSR into the backing page of
a gfn=>pfn cache so that userspace can detect if a value was written to
the wrong page, i.e. to a stale mapping.

Spin up 16 vCPUs (arbitrary) to use/refresh the cache, and another thread
to trigger mmu_notifier events and memslot updates.

Co-authored-by: David Woodhouse <dwmw@amazon.co.uk>
Not-signed-off-by: Sean Christopherson <seanjc@google.com>
Not-signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
 arch/x86/kvm/x86.c                     |  28 ++++
 include/linux/kvm_host.h               |   2 +
 tools/testing/selftests/kvm/Makefile   |   1 +
 tools/testing/selftests/kvm/gpc_test.c | 215 +++++++++++++++++++++++++
 4 files changed, 246 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/gpc_test.c

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 70219e406987..910fef96409a 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3767,6 +3767,19 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		return kvm_xen_write_hypercall_page(vcpu, data);
 
 	switch (msr) {
+	case 0xdeadbeefu: {
+		struct gfn_to_pfn_cache *gpc = &vcpu->kvm->test_cache;
+
+		if (kvm_gpc_activate(gpc, data, 8))
+			break;
+
+		read_lock(&gpc->lock);
+		if (kvm_gpc_check(gpc, 8))
+			*(u64 *)(gpc->khva) = data;
+		read_unlock(&gpc->lock);
+		break;
+	}
+
 	case MSR_AMD64_NB_CFG:
 	case MSR_IA32_UCODE_WRITE:
 	case MSR_VM_HSAVE_PA:
@@ -4206,6 +4219,18 @@ static int get_msr_mce(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata, bool host)
 int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 {
 	switch (msr_info->index) {
+	case 0xdeadbeefu: {
+		struct gfn_to_pfn_cache *gpc = &vcpu->kvm->test_cache;
+
+		read_lock(&gpc->lock);
+		if (kvm_gpc_check(gpc, 8))
+			msr_info->data = gpc->gpa;
+		else
+			msr_info->data = 0xdeadbeefu;
+		read_unlock(&gpc->lock);
+		return 0;
+	}
+
 	case MSR_IA32_PLATFORM_ID:
 	case MSR_IA32_EBL_CR_POWERON:
 	case MSR_IA32_LASTBRANCHFROMIP:
@@ -12693,6 +12718,8 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 	kvm_hv_init_vm(kvm);
 	kvm_xen_init_vm(kvm);
 
+	kvm_gpc_init(&kvm->test_cache, kvm);
+
 	return 0;
 
 out_uninit_mmu:
@@ -12840,6 +12867,7 @@ void kvm_arch_destroy_vm(struct kvm *kvm)
 	kvm_page_track_cleanup(kvm);
 	kvm_xen_destroy_vm(kvm);
 	kvm_hv_destroy_vm(kvm);
+	kvm_gpc_deactivate(&kvm->test_cache);
 }
 
 static void memslot_rmap_free(struct kvm_memory_slot *slot)
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index a0739c343da5..d4d155091bfd 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -741,6 +741,8 @@ struct kvm {
 
 	struct mutex slots_lock;
 
+	struct gfn_to_pfn_cache test_cache;
+
 	/*
 	 * Protects the arch-specific fields of struct kvm_memory_slots in
 	 * use by the VM. To be used under the slots_lock (above) or in a
diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index 48d32c5aa3eb..1c9f601d7f7d 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -65,6 +65,7 @@ TEST_PROGS_x86_64 += x86_64/nx_huge_pages_test.sh
 
 # Compiled test targets
 TEST_GEN_PROGS_x86_64 = x86_64/cpuid_test
+TEST_GEN_PROGS_x86_64 += gpc_test
 TEST_GEN_PROGS_x86_64 += x86_64/cr4_cpuid_sync_test
 TEST_GEN_PROGS_x86_64 += x86_64/dirty_log_page_splitting_test
 TEST_GEN_PROGS_x86_64 += x86_64/get_msr_index_features
diff --git a/tools/testing/selftests/kvm/gpc_test.c b/tools/testing/selftests/kvm/gpc_test.c
new file mode 100644
index 000000000000..611d2342d7d4
--- /dev/null
+++ b/tools/testing/selftests/kvm/gpc_test.c
@@ -0,0 +1,215 @@
+// SPDX-License-Identifier: GPL-2.0-only
+#define _GNU_SOURCE /* for program_invocation_short_name */
+#include <errno.h>
+#include <fcntl.h>
+#include <pthread.h>
+#include <sched.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <signal.h>
+#include <syscall.h>
+#include <sys/ioctl.h>
+#include <sys/sysinfo.h>
+#include <asm/barrier.h>
+#include <linux/atomic.h>
+#include <linux/rseq.h>
+#include <linux/unistd.h>
+
+#include "kvm_util.h"
+#include "processor.h"
+#include "test_util.h"
+
+#define NR_VCPUS 16
+
+#define NR_ITERATIONS	1000
+
+#ifndef MAP_FIXED_NOREPLACE
+#define MAP_FIXED_NOREPLACE	0x100000
+#endif
+
+static const uint64_t gpa_base = (4ull * (1 << 30));
+
+static struct kvm_vm *vm;
+
+static pthread_t memory_thread;
+static pthread_t vcpu_threads[NR_VCPUS];
+struct kvm_vcpu *vcpus[KVM_MAX_VCPUS];
+
+static bool fight;
+
+static uint64_t per_vcpu_gpa_aligned(int vcpu_id)
+{
+	return gpa_base + (vcpu_id * PAGE_SIZE);
+}
+
+static uint64_t per_vcpu_gpa(int vcpu_id)
+{
+	return per_vcpu_gpa_aligned(vcpu_id) + vcpu_id;
+}
+
+static void guest_code(int vcpu_id)
+{
+	uint64_t this_vcpu_gpa;
+	int i;
+
+	this_vcpu_gpa = per_vcpu_gpa(vcpu_id);
+
+	for (i = 0; i < NR_ITERATIONS; i++)
+		wrmsr(0xdeadbeefu, this_vcpu_gpa);
+	GUEST_SYNC(0);
+}
+
+static void *memory_worker(void *ign)
+{
+	int i, x, r, k;
+	uint64_t *hva;
+	uint64_t gpa;
+	void *mem;
+
+	while (!READ_ONCE(fight))
+		cpu_relax();
+
+	for (k = 0; k < 50; k++) {
+		i = (unsigned int)random() % NR_VCPUS;
+
+		gpa = per_vcpu_gpa_aligned(i);
+		hva = (void *)gpa;
+
+		x = (unsigned int)random() % 5;
+		switch (x) {
+		case 0:
+			r = munmap(hva, PAGE_SIZE);
+			TEST_ASSERT(!r, "Failed to mumap (hva = %lx), errno = %d (%s)",
+				    (unsigned long)hva, errno, strerror(errno));
+
+			mem = mmap(hva, PAGE_SIZE, PROT_READ | PROT_WRITE,
+				MAP_FIXED_NOREPLACE | MAP_ANONYMOUS | MAP_PRIVATE, -1, 0);
+			TEST_ASSERT(mem != MAP_FAILED || mem != hva,
+				    "Failed to mmap (hva = %lx), errno = %d (%s)",
+				    (unsigned long)hva, errno, strerror(errno));
+			break;
+		case 1:
+			vm_set_user_memory_region(vm, i + 1, KVM_MEM_LOG_DIRTY_PAGES,
+						  gpa, PAGE_SIZE, hva);
+			vm_set_user_memory_region(vm, i + 1, 0, gpa, PAGE_SIZE, hva);
+			break;
+		case 2:
+			r = mprotect(hva, PAGE_SIZE, PROT_NONE);
+			TEST_ASSERT(!r, "Failed to mprotect (hva = %lx), errno = %d (%s)",
+				    (unsigned long)hva, errno, strerror(errno));
+
+			r = mprotect(hva, PAGE_SIZE, PROT_READ | PROT_WRITE);
+			TEST_ASSERT(!r, "Failed to mprotect (hva = %lx), errno = %d (%s)",
+				    (unsigned long)hva, errno, strerror(errno));
+			break;
+		case 3:
+			r = mprotect(hva, PAGE_SIZE, PROT_READ);
+			TEST_ASSERT(!r, "Failed to mprotect (hva = %lx), errno = %d (%s)",
+				    (unsigned long)hva, errno, strerror(errno));
+
+			r = mprotect(hva, PAGE_SIZE, PROT_READ | PROT_WRITE);
+			TEST_ASSERT(!r, "Failed to mprotect (hva = %lx), errno = %d (%s)",
+				    (unsigned long)hva, errno, strerror(errno));
+			break;
+		case 4:
+			vm_set_user_memory_region(vm, i + 1, 0, gpa, 0, 0);
+			vm_set_user_memory_region(vm, i + 1, 0, gpa, PAGE_SIZE,
+						  (void *)per_vcpu_gpa_aligned(NR_VCPUS));
+			vm_set_user_memory_region(vm, i + 1, 0, gpa, 0, 0);
+			vm_set_user_memory_region(vm, i + 1, 0, gpa, PAGE_SIZE, hva);
+			break;
+		}
+	}
+	return NULL;
+}
+
+static void sync_guest(int vcpu_id)
+{
+	struct ucall uc;
+
+	switch (get_ucall(vcpus[vcpu_id], &uc)) {
+	case UCALL_SYNC:
+		TEST_ASSERT(uc.args[1] == 0,
+			   "Unexpected sync ucall, got %lx", uc.args[1]);
+		break;
+	case UCALL_ABORT:
+			TEST_FAIL("%s at %s:%ld\n\tvalues: %#lx, %#lx",
+		(const char *)uc.args[0],
+		__FILE__, uc.args[1], uc.args[2], uc.args[3]);
+		break;
+	default:
+		TEST_FAIL("Unexpected userspace exit, reason = %s\n",
+			  exit_reason_str(vcpus[vcpu_id]->run->exit_reason));
+		break;
+	}
+}
+
+static void *vcpu_worker(void *data)
+{
+	int vcpu_id = (unsigned long)data;
+
+	vcpu_args_set(vcpus[vcpu_id], 1, vcpu_id);
+
+	while (!READ_ONCE(fight))
+		cpu_relax();
+
+	usleep(10);
+
+	vcpu_run(vcpus[vcpu_id]);
+
+	sync_guest(vcpu_id);
+
+	return NULL;
+}
+
+int main(int argc, char *argv[])
+{
+	uint64_t *hva;
+	uint64_t gpa;
+	void *r;
+	int i;
+
+	srandom(time(0));
+
+	vm = vm_create_with_vcpus(NR_VCPUS, guest_code, vcpus);
+
+	pthread_create(&memory_thread, NULL, memory_worker, 0);
+
+	for (i = 0; i < NR_VCPUS; i++) {
+		pthread_create(&vcpu_threads[i], NULL, vcpu_worker, (void *)(unsigned long)i);
+
+		gpa = per_vcpu_gpa_aligned(i);
+		hva = (void *)gpa;
+		r = mmap(hva, PAGE_SIZE, PROT_READ | PROT_WRITE,
+			 MAP_FIXED_NOREPLACE | MAP_ANONYMOUS | MAP_PRIVATE, -1, 0);
+		TEST_ASSERT(r != MAP_FAILED, "mmap() '%lx' failed, errno = %d (%s)",
+			    gpa, errno, strerror(errno));
+
+		vm_set_user_memory_region(vm, i + 1, 0, gpa, PAGE_SIZE, hva);
+	}
+
+	WRITE_ONCE(fight, true);
+
+	for (i = 0; i < NR_VCPUS; i++)
+		pthread_join(vcpu_threads[i], NULL);
+
+	pthread_join(memory_thread, NULL);
+
+	for (i = 0; i < NR_VCPUS; i++) {
+		gpa = per_vcpu_gpa(i);
+		hva = (void *)gpa;
+
+		TEST_ASSERT(*hva == 0 || *hva == gpa,
+			    "Want '0' or '%lx', got '%lx'\n", gpa, *hva);
+	}
+
+	gpa = vcpu_get_msr(vcpus[0], 0xdeadbeefu);
+	hva = (void *)gpa;
+	if (gpa != 0xdeadbeefu)
+		TEST_ASSERT(*hva == gpa, "Want '%lx', got '%lx'\n", gpa, *hva);
+
+	kvm_vm_free(vm);
+
+	return 0;
+}
-- 
2.44.0


