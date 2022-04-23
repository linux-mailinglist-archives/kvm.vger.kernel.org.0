Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95EDF50C71E
	for <lists+kvm@lfdr.de>; Sat, 23 Apr 2022 06:01:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232755AbiDWDvj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Apr 2022 23:51:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232896AbiDWDvg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Apr 2022 23:51:36 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40AB01C9CCF
        for <kvm@vger.kernel.org>; Fri, 22 Apr 2022 20:48:32 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id d6-20020aa78686000000b0050adc2b200cso4681164pfo.21
        for <kvm@vger.kernel.org>; Fri, 22 Apr 2022 20:48:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=+2AgNH8Qoc+XZ2aqZVkP0WtczvqEDl4P0Mq70NzABEw=;
        b=kGItDFS0r10ErwaqYlTjCN0WPBwM2VJ3bMsQ/gqn6/xWsMCkcd1qtw87r9LQHFUTQZ
         4iSiiuMTS1dFRSRO1CiXuvUyTcW1tePqdKeO+qb0TzC2cgrIeJbnBBZ16ocxeKpjbkZe
         yH3b0/oz3+9Pruzq0EjTpXpgIPhqltEH5ncCgsom1E5rvwdy0FSM4TQcsk4KsjrMfYqv
         AXaJRzXdN4rmtxUN4Quq68rxz9IHL7jHstt3uFRUb+ySSfMyjhq/MidNxW4i7z7l7j92
         TfkXfMSTB6FBkdBlmUcEjCkY3GZr4Uqm7v+PrASnNwWwlsj4scy4PL0nu/7SLw7VibBV
         T+8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=+2AgNH8Qoc+XZ2aqZVkP0WtczvqEDl4P0Mq70NzABEw=;
        b=y/7AyxgYsv6mu0p+zhoKvr/UNV2m7JQBUtx3h5+6PMlBkKFdKgQEfq3/KuL1vaQPMW
         CnEfTvaU7GUVQnD0tn+xX4pTGOd3ZjJRSOCfZazo/hgZQ86BEKuiwJRHL/kV3CBVrkwq
         wS7BJeaFRbPs6XAxOi49xnbZzZCwJxZ4/npAMnsKDtVtCEFFXoYtUstSholC+PEOgEGs
         vSI0GbwnOrTkxNSZ/kiS/wk+nsaj/kiLpkuDT/5ttOXqvhjfrGsIIH98Hooa+62eC0R7
         8s9TQTh2rM3FVKgXZc8XGnFUtPeWRAr6fgV9/fSM12MCecErvcA0fFPK3qVolBodx4D+
         N9Qw==
X-Gm-Message-State: AOAM531kn1o1AhmgUUVqylsdCgZUxAUkFB1rexyJzF/FUOB2QcuCRobn
        9nhiByF6eIebA67Ac2g+o0aJuqcv+lA=
X-Google-Smtp-Source: ABdhPJxOEEyTteX2y8CRdvIlhV9uOqkCk9U5/ipTsEkE9jxr9rlMcFGOy5YSFLFADMhE9OS8atlo920yY0Y=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:114e:b0:4c8:55f7:faad with SMTP id
 b14-20020a056a00114e00b004c855f7faadmr8312356pfm.86.1650685711773; Fri, 22
 Apr 2022 20:48:31 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Sat, 23 Apr 2022 03:47:52 +0000
In-Reply-To: <20220423034752.1161007-1-seanjc@google.com>
Message-Id: <20220423034752.1161007-13-seanjc@google.com>
Mime-Version: 1.0
References: <20220423034752.1161007-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.0.rc2.479.g8af0fa9b8e-goog
Subject: [PATCH 12/12] DO NOT MERGE: KVM: selftests: Attempt to detect lost
 dirty bits
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        David Matlack <dmatlack@google.com>,
        Venkatesh Srinivas <venkateshs@google.com>,
        Chao Peng <chao.p.peng@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

A failed attempt to detect improper dropping of Writable and/or Dirty
bits.  Doesn't work because the primary MMU write-protects its PTEs when
file writeback occurs, i.e. KVM's dirty bits are meaningless as far as
file-backed guest memory is concnered.

Not-signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/.gitignore        |   1 +
 tools/testing/selftests/kvm/Makefile          |   4 +
 .../selftests/kvm/volatile_spte_test.c        | 208 ++++++++++++++++++
 3 files changed, 213 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/volatile_spte_test.c

diff --git a/tools/testing/selftests/kvm/.gitignore b/tools/testing/selftests/kvm/.gitignore
index 56140068b763..3307444d9fda 100644
--- a/tools/testing/selftests/kvm/.gitignore
+++ b/tools/testing/selftests/kvm/.gitignore
@@ -70,3 +70,4 @@
 /steal_time
 /kvm_binary_stats_test
 /system_counter_offset_test
+/volatile_spte_test
diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index af582d168621..bc0907de6638 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -103,6 +103,7 @@ TEST_GEN_PROGS_x86_64 += set_memory_region_test
 TEST_GEN_PROGS_x86_64 += steal_time
 TEST_GEN_PROGS_x86_64 += kvm_binary_stats_test
 TEST_GEN_PROGS_x86_64 += system_counter_offset_test
+TEST_GEN_PROGS_x86_64 += volatile_spte_test
 
 TEST_GEN_PROGS_aarch64 += aarch64/arch_timer
 TEST_GEN_PROGS_aarch64 += aarch64/debug-exceptions
@@ -122,6 +123,7 @@ TEST_GEN_PROGS_aarch64 += rseq_test
 TEST_GEN_PROGS_aarch64 += set_memory_region_test
 TEST_GEN_PROGS_aarch64 += steal_time
 TEST_GEN_PROGS_aarch64 += kvm_binary_stats_test
+TEST_GEN_PROGS_aarch64 += volatile_spte_test
 
 TEST_GEN_PROGS_s390x = s390x/memop
 TEST_GEN_PROGS_s390x += s390x/resets
@@ -134,6 +136,7 @@ TEST_GEN_PROGS_s390x += kvm_page_table_test
 TEST_GEN_PROGS_s390x += rseq_test
 TEST_GEN_PROGS_s390x += set_memory_region_test
 TEST_GEN_PROGS_s390x += kvm_binary_stats_test
+TEST_GEN_PROGS_s390x += volatile_spte_test
 
 TEST_GEN_PROGS_riscv += demand_paging_test
 TEST_GEN_PROGS_riscv += dirty_log_test
@@ -141,6 +144,7 @@ TEST_GEN_PROGS_riscv += kvm_create_max_vcpus
 TEST_GEN_PROGS_riscv += kvm_page_table_test
 TEST_GEN_PROGS_riscv += set_memory_region_test
 TEST_GEN_PROGS_riscv += kvm_binary_stats_test
+TEST_GEN_PROGS_riscv += volatile_spte_test
 
 TEST_GEN_PROGS += $(TEST_GEN_PROGS_$(UNAME_M))
 LIBKVM += $(LIBKVM_$(UNAME_M))
diff --git a/tools/testing/selftests/kvm/volatile_spte_test.c b/tools/testing/selftests/kvm/volatile_spte_test.c
new file mode 100644
index 000000000000..a4277216eb3d
--- /dev/null
+++ b/tools/testing/selftests/kvm/volatile_spte_test.c
@@ -0,0 +1,208 @@
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
+#define VCPU_ID 0
+
+#define PAGE_SIZE 4096
+
+#define NR_ITERATIONS		1000
+
+#define MEM_FILE_NAME		"volatile_spte_test_mem"
+#define MEM_FILE_MEMSLOT	1
+#define MEM_FILE_DATA_PATTERN	0xa5a5a5a5a5a5a5a5ul
+
+static const uint64_t gpa = (4ull * (1 << 30));
+
+static uint64_t *hva;
+
+static pthread_t mprotect_thread;
+static atomic_t rendezvous;
+static bool done;
+
+static void guest_code(void)
+{
+	uint64_t *gva = (uint64_t *)gpa;
+
+	while (!READ_ONCE(done)) {
+		WRITE_ONCE(*gva, 0);
+		GUEST_SYNC(0);
+
+		WRITE_ONCE(*gva, MEM_FILE_DATA_PATTERN);
+		GUEST_SYNC(1);
+	}
+}
+
+static void *mprotect_worker(void *ign)
+{
+	int i, r;
+
+	i = 0;
+	while (!READ_ONCE(done)) {
+		for ( ; atomic_read(&rendezvous) != 1; i++)
+			cpu_relax();
+
+		usleep((i % 10) + 1);
+
+		r = mprotect(hva, PAGE_SIZE, PROT_NONE);
+		TEST_ASSERT(!r, "Failed to mprotect file (hva = %lx), errno = %d (%s)",
+			    (unsigned long)hva, errno, strerror(errno));
+
+		atomic_inc(&rendezvous);
+	}
+	return NULL;
+}
+
+int main(int argc, char *argv[])
+{
+	uint64_t bitmap = -1ull, val;
+	int i, r, fd, nr_writes;
+	struct kvm_regs regs;
+	struct ucall ucall;
+	struct kvm_vm *vm;
+
+	vm = vm_create_default(VCPU_ID, 0, guest_code);
+	vcpu_regs_get(vm, VCPU_ID, &regs);
+	ucall_init(vm, NULL);
+
+	pthread_create(&mprotect_thread, NULL, mprotect_worker, 0);
+
+	fd = open(MEM_FILE_NAME, O_RDWR | O_CREAT, 0644);
+	TEST_ASSERT(fd >= 0, "Failed to open '%s', errno = %d (%s)",
+		    MEM_FILE_NAME, errno, strerror(errno));
+
+	r = ftruncate(fd, PAGE_SIZE);
+	TEST_ASSERT(fd >= 0, "Failed to ftruncate '%s', errno = %d (%s)",
+		    MEM_FILE_NAME, errno, strerror(errno));
+
+	hva = mmap(NULL, PAGE_SIZE, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
+	TEST_ASSERT(hva != MAP_FAILED,  "Failed to map file, errno = %d (%s)",
+		    errno, strerror(errno));
+
+	vm_set_user_memory_region(vm, MEM_FILE_MEMSLOT, KVM_MEM_LOG_DIRTY_PAGES,
+				  gpa, PAGE_SIZE, hva);
+	virt_pg_map(vm, gpa, gpa);
+
+	for (i = 0, nr_writes = 0; i < NR_ITERATIONS; i++) {
+		fdatasync(fd);
+
+		vcpu_run(vm, VCPU_ID);
+		ASSERT_EQ(*hva, 0);
+		ASSERT_EQ(get_ucall(vm, VCPU_ID, &ucall), UCALL_SYNC);
+		ASSERT_EQ(ucall.args[1], 0);
+
+		/*
+		 * The origin hope/intent was to detect dropped Dirty bits by
+		 * checking for missed file writeback.  Sadly, the kernel is
+		 * too smart and write-protects the primary MMU's PTEs, which
+		 * zaps KVM's SPTEs and ultimately causes the folio/page to get
+		 * marked marked dirty by the primary MMU when KVM re-faults on
+		 * the page.
+		 *
+		 * Triggering swap _might_ be a way to detect failure, as swap
+		 * is treated differently than "normal" files.
+		 *
+		 * RIP: 0010:kvm_unmap_gfn_range+0xf1/0x100 [kvm]
+		 * Call Trace:
+		 * <TASK>
+		 *   kvm_mmu_notifier_invalidate_range_start+0x11c/0x2c0 [kvm]
+		 *   __mmu_notifier_invalidate_range_start+0x7e/0x190
+		 *   page_mkclean_one+0x226/0x250
+		 *   rmap_walk_file+0x213/0x430
+		 *   folio_mkclean+0x95/0xb0
+		 *   folio_clear_dirty_for_io+0x5d/0x1c0
+		 *   mpage_submit_page+0x1f/0x70
+		 *   mpage_process_page_bufs+0xf8/0x110
+		 *   mpage_prepare_extent_to_map+0x1e3/0x420
+		 *   ext4_writepages+0x277/0xca0
+		 *   do_writepages+0xd1/0x190
+		 *   filemap_fdatawrite_wbc+0x62/0x90
+		 *   file_write_and_wait_range+0xa3/0xe0
+		 *   ext4_sync_file+0xdb/0x340
+		 *   do_fsync+0x38/0x70
+		 *   __x64_sys_fdatasync+0x13/0x20
+		 *   do_syscall_64+0x31/0x50
+		 *   entry_SYSCALL_64_after_hwframe+0x44/0xae
+		 * </TASK>
+		 *
+		 * RIP: 0010:__folio_mark_dirty+0x266/0x310
+		 * Call Trace:
+		 * <TASK>
+		 *   mark_buffer_dirty+0xe7/0x140
+		 *   __block_commit_write.isra.0+0x59/0xc0
+		 *   block_page_mkwrite+0x15a/0x170
+		 *   ext4_page_mkwrite+0x485/0x620
+		 *   do_page_mkwrite+0x54/0x150
+		 *   __handle_mm_fault+0xe2a/0x1600
+		 *   handle_mm_fault+0xbd/0x280
+		 *   do_user_addr_fault+0x192/0x600
+		 *   exc_page_fault+0x6c/0x140
+		 *   asm_exc_page_fault+0x1e/0x30
+		 * </TASK>
+		 */
+		/* fdatasync(fd); */
+
+		/*
+		 * Clear the dirty log to coerce KVM into write-protecting the
+		 * SPTE (or into clearing dirty bits when using PML).
+		 */
+		kvm_vm_clear_dirty_log(vm, MEM_FILE_MEMSLOT, &bitmap, 0, 1);
+
+		atomic_inc(&rendezvous);
+
+		usleep(i % 10);
+
+		r = _vcpu_run(vm, VCPU_ID);
+
+		while (atomic_read(&rendezvous) != 2)
+			cpu_relax();
+
+		atomic_set(&rendezvous, 0);
+
+		fdatasync(fd);
+		mprotect(hva, PAGE_SIZE, PROT_READ | PROT_WRITE);
+
+		val = READ_ONCE(*hva);
+		if (r) {
+			TEST_ASSERT(!val, "Memory should be zero, write faulted\n");
+			vcpu_regs_set(vm, VCPU_ID, &regs);
+			continue;
+		}
+		nr_writes++;
+		TEST_ASSERT(val == MEM_FILE_DATA_PATTERN,
+			    "Memory doesn't match data pattern, want 0x%lx, got 0x%lx",
+			    MEM_FILE_DATA_PATTERN, val);
+		ASSERT_EQ(get_ucall(vm, VCPU_ID, &ucall), UCALL_SYNC);
+		ASSERT_EQ(ucall.args[1], 1);
+	}
+
+	printf("%d of %d iterations wrote memory\n", nr_writes, NR_ITERATIONS);
+
+	atomic_inc(&rendezvous);
+	WRITE_ONCE(done, true);
+
+	pthread_join(mprotect_thread, NULL);
+
+	kvm_vm_free(vm);
+
+	return 0;
+}
+
-- 
2.36.0.rc2.479.g8af0fa9b8e-goog

