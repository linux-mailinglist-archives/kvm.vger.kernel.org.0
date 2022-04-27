Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E80B510E20
	for <lists+kvm@lfdr.de>; Wed, 27 Apr 2022 03:47:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356914AbiD0Bnt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Apr 2022 21:43:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356897AbiD0Bne (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Apr 2022 21:43:34 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38ED31D321
        for <kvm@vger.kernel.org>; Tue, 26 Apr 2022 18:40:24 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id g23-20020aa78197000000b0050adbdbbec8so218866pfi.23
        for <kvm@vger.kernel.org>; Tue, 26 Apr 2022 18:40:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=tdAby1TGlV1h8nD87XtrVih1Pygj0UJbvJREenj9JnE=;
        b=ivkOoyYRCDwEv7I3kjEmBzKP6ALUjVb9oC8s04GcxHKSOoF9jV57s+M/xvmCOuZ5Yg
         k40c1NhbKEZ2seHy59bKbLcsUw6Rdz3MuX5i9gug7+X87B3tVpe2wP9dTzva/K1IxLtt
         I26MHaiA2rwTf1ZSIne2Yttolv+dAgzE5eL24RrjNyqLKt0DV37qo+El5ZftIedOh09l
         xM7aae0kzHaAg+xUvOcMLjKaobcUyClomh6hC8XbMtv08PwP+klerPRKCOf/GmWUUgAO
         Hy07rOqiLxmHuuVGMJF3nYBt0Ha9v/OQ5ckdJ+qEQsW8et6TScrzww4o6kVtW0iR+kIi
         ReaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=tdAby1TGlV1h8nD87XtrVih1Pygj0UJbvJREenj9JnE=;
        b=jb4F7mEXYocEGcgzTBD8VAzKMFLBdld88vu9iSaVuFQDMUA+pGrWYaQsecylLclgm3
         boxmINOPfGWgVTbqEIb0JEqAeBw5vIS8ESzw09G1W4l26Zz+kivcy30CuD408SeIpGbq
         AxBK9F5k2Y7cDsJQ27m/apReD9+mT+rWw86RNBfHSatviFduLksYsNfJEANktSOK38EE
         KlQlwxsqtf0u0dh/JfP7XPeKfajI4XQ5JGK0FK096eelptfcvDLOzd7Zfp2RzaPBF/1Z
         BGSoW65RRZo9m4IHGG2Sea8Lb48wyuqE0b5wtksC+mYzCD2XTC0ppdCjJpl1dN3UQV5l
         QZTw==
X-Gm-Message-State: AOAM530rfXMFXTh14/KnamTL5rSwDtpUPQuRYVuDWhdE3buZpKL9JUJe
        GwF++FUVPLFoido1rCEA7wH9Q3ERgFo=
X-Google-Smtp-Source: ABdhPJzTNiP/xXqBgporbK59dMQrSzIVhqlhXvoYgY2x5e1mB/xWz+rutzl+rGM9cviXD5nxxb0Mo5Ef3D4=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:1702:b0:50a:8181:fed7 with SMTP id
 h2-20020a056a00170200b0050a8181fed7mr27400903pfc.56.1651023623746; Tue, 26
 Apr 2022 18:40:23 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 27 Apr 2022 01:40:04 +0000
In-Reply-To: <20220427014004.1992589-1-seanjc@google.com>
Message-Id: <20220427014004.1992589-9-seanjc@google.com>
Mime-Version: 1.0
References: <20220427014004.1992589-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.0.rc2.479.g8af0fa9b8e-goog
Subject: [PATCH v2 8/8] DO NOT MERGE: Hack-a-test to verify gpc invalidation+refresh
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Woodhouse <dwmw@amazon.co.uk>,
        Mingwei Zhang <mizhang@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a VM-wide gfn=>pfn cache and a fake MSR to let userspace control the
cache.  On writes, reflect the value of the MSR into the backing page of
a gfn=>pfn cache so that userspace can detect if a value was written to
the wrong page, i.e. to a stale mapping.

Spin up 16 vCPUs (arbitrary) to use/refresh the cache, and another thread
to trigger mmu_notifier events and memslot updates.

Not-signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c                     |  30 ++++
 include/linux/kvm_host.h               |   2 +
 tools/testing/selftests/kvm/.gitignore |   1 +
 tools/testing/selftests/kvm/Makefile   |   2 +
 tools/testing/selftests/kvm/gpc_test.c | 217 +++++++++++++++++++++++++
 virt/kvm/pfncache.c                    |   2 +
 6 files changed, 254 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/gpc_test.c

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 951d0a78ccda..7afdb7f39821 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3473,6 +3473,20 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		return kvm_xen_write_hypercall_page(vcpu, data);
 
 	switch (msr) {
+	case 0xdeadbeefu: {
+		struct gfn_to_pfn_cache *gpc = &vcpu->kvm->test_cache;
+		unsigned long flags;
+
+		if (kvm_gfn_to_pfn_cache_refresh(vcpu->kvm, gpc, data, 8))
+			break;
+
+		read_lock_irqsave(&gpc->lock, flags);
+		if (kvm_gfn_to_pfn_cache_check(vcpu->kvm, gpc, data, 8))
+			*(u64 *)(gpc->khva) = data;
+		read_unlock_irqrestore(&gpc->lock, flags);
+		break;
+	}
+
 	case MSR_AMD64_NB_CFG:
 	case MSR_IA32_UCODE_WRITE:
 	case MSR_VM_HSAVE_PA:
@@ -3825,6 +3839,19 @@ static int get_msr_mce(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata, bool host)
 int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 {
 	switch (msr_info->index) {
+	case 0xdeadbeefu: {
+		struct gfn_to_pfn_cache *gpc = &vcpu->kvm->test_cache;
+		unsigned long flags;
+
+		read_lock_irqsave(&gpc->lock, flags);
+		if (kvm_gfn_to_pfn_cache_check(vcpu->kvm, gpc, gpc->gpa, 8))
+			msr_info->data = gpc->gpa;
+		else
+			msr_info->data = 0xdeadbeefu;
+		read_unlock_irqrestore(&gpc->lock, flags);
+		return 0;
+	}
+
 	case MSR_IA32_PLATFORM_ID:
 	case MSR_IA32_EBL_CR_POWERON:
 	case MSR_IA32_LASTBRANCHFROMIP:
@@ -11794,6 +11821,9 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 	kvm_hv_init_vm(kvm);
 	kvm_xen_init_vm(kvm);
 
+	kvm_gfn_to_pfn_cache_init(kvm, &kvm->test_cache, NULL,
+				  KVM_HOST_USES_PFN, 0, 0);
+
 	return static_call(kvm_x86_vm_init)(kvm);
 
 out_page_track:
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 252ee4a61b58..88ed76ad8bc7 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -718,6 +718,8 @@ struct kvm {
 	spinlock_t gpc_lock;
 	struct list_head gpc_list;
 
+	struct gfn_to_pfn_cache test_cache;
+
 	/*
 	 * created_vcpus is protected by kvm->lock, and is incremented
 	 * at the beginning of KVM_CREATE_VCPU.  online_vcpus is only
diff --git a/tools/testing/selftests/kvm/.gitignore b/tools/testing/selftests/kvm/.gitignore
index 56140068b763..0310a57a1a4f 100644
--- a/tools/testing/selftests/kvm/.gitignore
+++ b/tools/testing/selftests/kvm/.gitignore
@@ -70,3 +70,4 @@
 /steal_time
 /kvm_binary_stats_test
 /system_counter_offset_test
+/gpc_test
diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index af582d168621..0adc9ac954d1 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -104,6 +104,8 @@ TEST_GEN_PROGS_x86_64 += steal_time
 TEST_GEN_PROGS_x86_64 += kvm_binary_stats_test
 TEST_GEN_PROGS_x86_64 += system_counter_offset_test
 
+TEST_GEN_PROGS_x86_64 += gpc_test
+
 TEST_GEN_PROGS_aarch64 += aarch64/arch_timer
 TEST_GEN_PROGS_aarch64 += aarch64/debug-exceptions
 TEST_GEN_PROGS_aarch64 += aarch64/get-reg-list
diff --git a/tools/testing/selftests/kvm/gpc_test.c b/tools/testing/selftests/kvm/gpc_test.c
new file mode 100644
index 000000000000..5c509e7bb4da
--- /dev/null
+++ b/tools/testing/selftests/kvm/gpc_test.c
@@ -0,0 +1,217 @@
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
+#define PAGE_SIZE 4096
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
+	switch (get_ucall(vm, vcpu_id, &uc)) {
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
+			  exit_reason_str(vcpu_state(vm, vcpu_id)->exit_reason));
+		break;
+	}
+}
+
+static void *vcpu_worker(void *data)
+{
+	int vcpu_id = (unsigned long)data;
+
+	vcpu_args_set(vm, vcpu_id, 1, vcpu_id);
+
+	while (!READ_ONCE(fight))
+		cpu_relax();
+
+	usleep(10);
+
+	vcpu_run(vm, vcpu_id);
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
+	vm = vm_create_default_with_vcpus(NR_VCPUS, 0, 0, guest_code, NULL);
+	ucall_init(vm, NULL);
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
+	gpa = vcpu_get_msr(vm, 0, 0xdeadbeefu);
+	hva = (void *)gpa;
+	if (gpa != 0xdeadbeefu)
+		TEST_ASSERT(*hva == gpa, "Want '%lx', got '%lx'\n", gpa, *hva);
+
+	kvm_vm_free(vm);
+
+	return 0;
+}
diff --git a/virt/kvm/pfncache.c b/virt/kvm/pfncache.c
index 3cb439b505b4..7881e6e6d91a 100644
--- a/virt/kvm/pfncache.c
+++ b/virt/kvm/pfncache.c
@@ -372,6 +372,8 @@ int kvm_gfn_to_pfn_cache_init(struct kvm *kvm, struct gfn_to_pfn_cache *gpc,
 		list_add(&gpc->list, &kvm->gpc_list);
 		spin_unlock(&kvm->gpc_lock);
 	}
+	if (!len)
+		return -EINVAL;
 	return kvm_gfn_to_pfn_cache_refresh(kvm, gpc, gpa, len);
 }
 EXPORT_SYMBOL_GPL(kvm_gfn_to_pfn_cache_init);
-- 
2.36.0.rc2.479.g8af0fa9b8e-goog

