Return-Path: <kvm+bounces-3726-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 286458075FE
	for <lists+kvm@lfdr.de>; Wed,  6 Dec 2023 18:03:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DE29A281D45
	for <lists+kvm@lfdr.de>; Wed,  6 Dec 2023 17:03:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B3934B5DE;
	Wed,  6 Dec 2023 17:02:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="GOSIGSGh"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28D0E10EF
	for <kvm@vger.kernel.org>; Wed,  6 Dec 2023 09:02:46 -0800 (PST)
Received: by mail-ej1-x62e.google.com with SMTP id a640c23a62f3a-a1d6f4a0958so213188266b.1
        for <kvm@vger.kernel.org>; Wed, 06 Dec 2023 09:02:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1701882164; x=1702486964; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PCSKjpuLf9v8hvcS+DwLGbNivYzM6Js8UWdBsTK/9Gk=;
        b=GOSIGSGhQIcgzZNo1xvwyiKu8n3vR8bmXziIjAVD+/iCEwKInAoWnulGfqW5/xNc24
         Yfe2ZIQraNfLTfZwfG2oxaPjxk2F0OGuhoyJAddPtl380La1Q3tEknbBCKpehab2uAUV
         ELZXBgvMGCANrtCZCKum0KcXlx3w7bRPcC8Rgw16jTCzp5z3l8KcX9Up2Az7aLnxBgyV
         Kecu5xEepYnjq7yQCQ9lR+Jund5n3YWP/FoeToXRDlRQwdCJKdvUA2mQIO7f/Apha3Wu
         3fLjZBmotp35+OteVz/sezdCHAMipEsBh8z7G35Ce5UVdkFza+ijU4aYLG8GskPPP835
         XRMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701882164; x=1702486964;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PCSKjpuLf9v8hvcS+DwLGbNivYzM6Js8UWdBsTK/9Gk=;
        b=p6wDMwwA/JZGmkzHyzS4Ajd9RmRlNfZ5V/CBcgw6VOpOtmBb+txbsLTGgrRmtTYWT7
         h7vdLeuHjVvbp7g3faJwZj377s0hPPjP/O+dnzmzs9IYnbhjk14U8hWdwIXSUtR7diHd
         xmeh28O7dPL2eo1CEsXjimM2+xR0UFqcfx3/AK11CTRJdQQvzGioCGIi0gy2uu9JrPOx
         cM019MO9xeu3Lk7C7+4sTWiqCWF9Lth6f/eA6u6OGqlQAyzwftFqamrNMJeoBJSYMWih
         lhUDFkCw6vk4dZQ1g1UdOzM/n8CK/insF079z4JD36c/kvWk3if1CrXgTQqD/nuvRbNL
         dz8A==
X-Gm-Message-State: AOJu0YybFs5UCdds2n3KJKkVxN634LZBl05w+WT8OXbg37iBLd8fFQXA
	IHS1q4HjkhkBY8kekSahyF2mAxRWoYb4X7fOdVY=
X-Google-Smtp-Source: AGHT+IHnLu38hdj/87sI44BfU9qMOOxUjzsxAq4dc0zgDAovyCZoEnr9Vr8OHwTvE+rl1zyjuc81Eg==
X-Received: by 2002:a17:906:a851:b0:a1d:c376:216b with SMTP id dx17-20020a170906a85100b00a1dc376216bmr1039271ejb.45.1701882164241;
        Wed, 06 Dec 2023 09:02:44 -0800 (PST)
Received: from localhost (2001-1ae9-1c2-4c00-20f-c6b4-1e57-7965.ip6.tmcz.cz. [2001:1ae9:1c2:4c00:20f:c6b4:1e57:7965])
        by smtp.gmail.com with ESMTPSA id d10-20020a170906040a00b00a1b65249053sm167372eja.128.2023.12.06.09.02.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Dec 2023 09:02:43 -0800 (PST)
From: Andrew Jones <ajones@ventanamicro.com>
To: kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	kvm-riscv@lists.infradead.org
Cc: seanjc@google.com,
	pbonzini@redhat.com,
	maz@kernel.org,
	oliver.upton@linux.dev,
	anup@brainfault.org,
	borntraeger@linux.ibm.com,
	frankja@linux.ibm.com,
	imbrenda@linux.ibm.com
Subject: [PATCH 1/5] KVM: selftests: Remove redundant newlines
Date: Wed,  6 Dec 2023 18:02:43 +0100
Message-ID: <20231206170241.82801-8-ajones@ventanamicro.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231206170241.82801-7-ajones@ventanamicro.com>
References: <20231206170241.82801-7-ajones@ventanamicro.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit

TEST_* functions append their own newline. Remove newlines from
TEST_* callsites to avoid extra newlines in output.

Signed-off-by: Andrew Jones <ajones@ventanamicro.com>
---
 tools/testing/selftests/kvm/demand_paging_test.c |  4 ++--
 .../testing/selftests/kvm/dirty_log_perf_test.c  |  4 ++--
 tools/testing/selftests/kvm/dirty_log_test.c     |  4 ++--
 tools/testing/selftests/kvm/get-reg-list.c       |  2 +-
 tools/testing/selftests/kvm/guest_print_test.c   |  8 ++++----
 .../selftests/kvm/hardware_disable_test.c        |  6 +++---
 .../testing/selftests/kvm/kvm_create_max_vcpus.c |  2 +-
 .../testing/selftests/kvm/kvm_page_table_test.c  |  4 ++--
 tools/testing/selftests/kvm/lib/elf.c            |  2 +-
 tools/testing/selftests/kvm/lib/kvm_util.c       | 16 ++++++++--------
 tools/testing/selftests/kvm/lib/memstress.c      |  2 +-
 .../testing/selftests/kvm/lib/userfaultfd_util.c |  2 +-
 .../kvm/memslot_modification_stress_test.c       |  2 +-
 tools/testing/selftests/kvm/memslot_perf_test.c  |  6 +++---
 tools/testing/selftests/kvm/rseq_test.c          |  4 ++--
 .../selftests/kvm/set_memory_region_test.c       |  6 +++---
 .../selftests/kvm/system_counter_offset_test.c   |  2 +-
 17 files changed, 38 insertions(+), 38 deletions(-)

diff --git a/tools/testing/selftests/kvm/demand_paging_test.c b/tools/testing/selftests/kvm/demand_paging_test.c
index 09c116a82a84..bf3609f71854 100644
--- a/tools/testing/selftests/kvm/demand_paging_test.c
+++ b/tools/testing/selftests/kvm/demand_paging_test.c
@@ -45,10 +45,10 @@ static void vcpu_worker(struct memstress_vcpu_args *vcpu_args)
 
 	/* Let the guest access its memory */
 	ret = _vcpu_run(vcpu);
-	TEST_ASSERT(ret == 0, "vcpu_run failed: %d\n", ret);
+	TEST_ASSERT(ret == 0, "vcpu_run failed: %d", ret);
 	if (get_ucall(vcpu, NULL) != UCALL_SYNC) {
 		TEST_ASSERT(false,
-			    "Invalid guest sync status: exit_reason=%s\n",
+			    "Invalid guest sync status: exit_reason=%s",
 			    exit_reason_str(run->exit_reason));
 	}
 
diff --git a/tools/testing/selftests/kvm/dirty_log_perf_test.c b/tools/testing/selftests/kvm/dirty_log_perf_test.c
index d374dbcf9a53..504f6fe980e8 100644
--- a/tools/testing/selftests/kvm/dirty_log_perf_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_perf_test.c
@@ -88,9 +88,9 @@ static void vcpu_worker(struct memstress_vcpu_args *vcpu_args)
 		ret = _vcpu_run(vcpu);
 		ts_diff = timespec_elapsed(start);
 
-		TEST_ASSERT(ret == 0, "vcpu_run failed: %d\n", ret);
+		TEST_ASSERT(ret == 0, "vcpu_run failed: %d", ret);
 		TEST_ASSERT(get_ucall(vcpu, NULL) == UCALL_SYNC,
-			    "Invalid guest sync status: exit_reason=%s\n",
+			    "Invalid guest sync status: exit_reason=%s",
 			    exit_reason_str(run->exit_reason));
 
 		pr_debug("Got sync event from vCPU %d\n", vcpu_idx);
diff --git a/tools/testing/selftests/kvm/dirty_log_test.c b/tools/testing/selftests/kvm/dirty_log_test.c
index 6cbecf499767..babea97b31a4 100644
--- a/tools/testing/selftests/kvm/dirty_log_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_test.c
@@ -262,7 +262,7 @@ static void default_after_vcpu_run(struct kvm_vcpu *vcpu, int ret, int err)
 		    "vcpu run failed: errno=%d", err);
 
 	TEST_ASSERT(get_ucall(vcpu, NULL) == UCALL_SYNC,
-		    "Invalid guest sync status: exit_reason=%s\n",
+		    "Invalid guest sync status: exit_reason=%s",
 		    exit_reason_str(run->exit_reason));
 
 	vcpu_handle_sync_stop();
@@ -410,7 +410,7 @@ static void dirty_ring_after_vcpu_run(struct kvm_vcpu *vcpu, int ret, int err)
 		pr_info("vcpu continues now.\n");
 	} else {
 		TEST_ASSERT(false, "Invalid guest sync status: "
-			    "exit_reason=%s\n",
+			    "exit_reason=%s",
 			    exit_reason_str(run->exit_reason));
 	}
 }
diff --git a/tools/testing/selftests/kvm/get-reg-list.c b/tools/testing/selftests/kvm/get-reg-list.c
index be7bf5224434..5b37b7785086 100644
--- a/tools/testing/selftests/kvm/get-reg-list.c
+++ b/tools/testing/selftests/kvm/get-reg-list.c
@@ -151,7 +151,7 @@ static void check_supported(struct vcpu_reg_list *c)
 			continue;
 
 		__TEST_REQUIRE(kvm_has_cap(s->capability),
-			       "%s: %s not available, skipping tests\n",
+			       "%s: %s not available, skipping tests",
 			       config_name(c), s->name);
 	}
 }
diff --git a/tools/testing/selftests/kvm/guest_print_test.c b/tools/testing/selftests/kvm/guest_print_test.c
index 41230b746190..3502caa3590c 100644
--- a/tools/testing/selftests/kvm/guest_print_test.c
+++ b/tools/testing/selftests/kvm/guest_print_test.c
@@ -98,7 +98,7 @@ static void ucall_abort(const char *assert_msg, const char *expected_assert_msg)
 	int offset = len_str - len_substr;
 
 	TEST_ASSERT(len_substr <= len_str,
-		    "Expected '%s' to be a substring of '%s'\n",
+		    "Expected '%s' to be a substring of '%s'",
 		    assert_msg, expected_assert_msg);
 
 	TEST_ASSERT(strcmp(&assert_msg[offset], expected_assert_msg) == 0,
@@ -116,7 +116,7 @@ static void run_test(struct kvm_vcpu *vcpu, const char *expected_printf,
 		vcpu_run(vcpu);
 
 		TEST_ASSERT(run->exit_reason == UCALL_EXIT_REASON,
-			    "Unexpected exit reason: %u (%s),\n",
+			    "Unexpected exit reason: %u (%s),",
 			    run->exit_reason, exit_reason_str(run->exit_reason));
 
 		switch (get_ucall(vcpu, &uc)) {
@@ -161,11 +161,11 @@ static void test_limits(void)
 	vcpu_run(vcpu);
 
 	TEST_ASSERT(run->exit_reason == UCALL_EXIT_REASON,
-		    "Unexpected exit reason: %u (%s),\n",
+		    "Unexpected exit reason: %u (%s),",
 		    run->exit_reason, exit_reason_str(run->exit_reason));
 
 	TEST_ASSERT(get_ucall(vcpu, &uc) == UCALL_ABORT,
-		    "Unexpected ucall command: %lu,  Expected: %u (UCALL_ABORT)\n",
+		    "Unexpected ucall command: %lu,  Expected: %u (UCALL_ABORT)",
 		    uc.cmd, UCALL_ABORT);
 
 	kvm_vm_free(vm);
diff --git a/tools/testing/selftests/kvm/hardware_disable_test.c b/tools/testing/selftests/kvm/hardware_disable_test.c
index f5d59b9934f1..decc521fc760 100644
--- a/tools/testing/selftests/kvm/hardware_disable_test.c
+++ b/tools/testing/selftests/kvm/hardware_disable_test.c
@@ -41,7 +41,7 @@ static void *run_vcpu(void *arg)
 
 	vcpu_run(vcpu);
 
-	TEST_ASSERT(false, "%s: exited with reason %d: %s\n",
+	TEST_ASSERT(false, "%s: exited with reason %d: %s",
 		    __func__, run->exit_reason,
 		    exit_reason_str(run->exit_reason));
 	pthread_exit(NULL);
@@ -55,7 +55,7 @@ static void *sleeping_thread(void *arg)
 		fd = open("/dev/null", O_RDWR);
 		close(fd);
 	}
-	TEST_ASSERT(false, "%s: exited\n", __func__);
+	TEST_ASSERT(false, "%s: exited", __func__);
 	pthread_exit(NULL);
 }
 
@@ -118,7 +118,7 @@ static void run_test(uint32_t run)
 	for (i = 0; i < VCPU_NUM; ++i)
 		check_join(threads[i], &b);
 	/* Should not be reached */
-	TEST_ASSERT(false, "%s: [%d] child escaped the ninja\n", __func__, run);
+	TEST_ASSERT(false, "%s: [%d] child escaped the ninja", __func__, run);
 }
 
 void wait_for_child_setup(pid_t pid)
diff --git a/tools/testing/selftests/kvm/kvm_create_max_vcpus.c b/tools/testing/selftests/kvm/kvm_create_max_vcpus.c
index 31b3cb24b9a7..b9e23265e4b3 100644
--- a/tools/testing/selftests/kvm/kvm_create_max_vcpus.c
+++ b/tools/testing/selftests/kvm/kvm_create_max_vcpus.c
@@ -65,7 +65,7 @@ int main(int argc, char *argv[])
 
 			int r = setrlimit(RLIMIT_NOFILE, &rl);
 			__TEST_REQUIRE(r >= 0,
-				       "RLIMIT_NOFILE hard limit is too low (%d, wanted %d)\n",
+				       "RLIMIT_NOFILE hard limit is too low (%d, wanted %d)",
 				       old_rlim_max, nr_fds_wanted);
 		} else {
 			TEST_ASSERT(!setrlimit(RLIMIT_NOFILE, &rl), "setrlimit() failed!");
diff --git a/tools/testing/selftests/kvm/kvm_page_table_test.c b/tools/testing/selftests/kvm/kvm_page_table_test.c
index e37dc9c21888..e0ba97ac1c56 100644
--- a/tools/testing/selftests/kvm/kvm_page_table_test.c
+++ b/tools/testing/selftests/kvm/kvm_page_table_test.c
@@ -204,9 +204,9 @@ static void *vcpu_worker(void *data)
 		ret = _vcpu_run(vcpu);
 		ts_diff = timespec_elapsed(start);
 
-		TEST_ASSERT(ret == 0, "vcpu_run failed: %d\n", ret);
+		TEST_ASSERT(ret == 0, "vcpu_run failed: %d", ret);
 		TEST_ASSERT(get_ucall(vcpu, NULL) == UCALL_SYNC,
-			    "Invalid guest sync status: exit_reason=%s\n",
+			    "Invalid guest sync status: exit_reason=%s",
 			    exit_reason_str(vcpu->run->exit_reason));
 
 		pr_debug("Got sync event from vCPU %d\n", vcpu->id);
diff --git a/tools/testing/selftests/kvm/lib/elf.c b/tools/testing/selftests/kvm/lib/elf.c
index 266f3876e10a..f34d926d9735 100644
--- a/tools/testing/selftests/kvm/lib/elf.c
+++ b/tools/testing/selftests/kvm/lib/elf.c
@@ -184,7 +184,7 @@ void kvm_vm_elf_load(struct kvm_vm *vm, const char *filename)
 				"Seek to program segment offset failed,\n"
 				"  program header idx: %u errno: %i\n"
 				"  offset_rv: 0x%jx\n"
-				"  expected: 0x%jx\n",
+				"  expected: 0x%jx",
 				n1, errno, (intmax_t) offset_rv,
 				(intmax_t) phdr.p_offset);
 			test_read(fd, addr_gva2hva(vm, phdr.p_vaddr),
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 17a978b8a2c4..8c4a3425ebf7 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -317,7 +317,7 @@ static uint64_t vm_nr_pages_required(enum vm_guest_mode mode,
 	uint64_t nr_pages;
 
 	TEST_ASSERT(nr_runnable_vcpus,
-		    "Use vm_create_barebones() for VMs that _never_ have vCPUs\n");
+		    "Use vm_create_barebones() for VMs that _never_ have vCPUs");
 
 	TEST_ASSERT(nr_runnable_vcpus <= kvm_check_cap(KVM_CAP_MAX_VCPUS),
 		    "nr_vcpus = %d too large for host, max-vcpus = %d",
@@ -488,7 +488,7 @@ void kvm_pin_this_task_to_pcpu(uint32_t pcpu)
 	CPU_ZERO(&mask);
 	CPU_SET(pcpu, &mask);
 	r = sched_setaffinity(0, sizeof(mask), &mask);
-	TEST_ASSERT(!r, "sched_setaffinity() failed for pCPU '%u'.\n", pcpu);
+	TEST_ASSERT(!r, "sched_setaffinity() failed for pCPU '%u'.", pcpu);
 }
 
 static uint32_t parse_pcpu(const char *cpu_str, const cpu_set_t *allowed_mask)
@@ -496,7 +496,7 @@ static uint32_t parse_pcpu(const char *cpu_str, const cpu_set_t *allowed_mask)
 	uint32_t pcpu = atoi_non_negative("CPU number", cpu_str);
 
 	TEST_ASSERT(CPU_ISSET(pcpu, allowed_mask),
-		    "Not allowed to run on pCPU '%d', check cgroups?\n", pcpu);
+		    "Not allowed to run on pCPU '%d', check cgroups?", pcpu);
 	return pcpu;
 }
 
@@ -526,7 +526,7 @@ void kvm_parse_vcpu_pinning(const char *pcpus_string, uint32_t vcpu_to_pcpu[],
 	int i, r;
 
 	cpu_list = strdup(pcpus_string);
-	TEST_ASSERT(cpu_list, "strdup() allocation failed.\n");
+	TEST_ASSERT(cpu_list, "strdup() allocation failed.");
 
 	r = sched_getaffinity(0, sizeof(allowed_mask), &allowed_mask);
 	TEST_ASSERT(!r, "sched_getaffinity() failed");
@@ -535,7 +535,7 @@ void kvm_parse_vcpu_pinning(const char *pcpus_string, uint32_t vcpu_to_pcpu[],
 
 	/* 1. Get all pcpus for vcpus. */
 	for (i = 0; i < nr_vcpus; i++) {
-		TEST_ASSERT(cpu, "pCPU not provided for vCPU '%d'\n", i);
+		TEST_ASSERT(cpu, "pCPU not provided for vCPU '%d'", i);
 		vcpu_to_pcpu[i] = parse_pcpu(cpu, &allowed_mask);
 		cpu = strtok(NULL, delim);
 	}
@@ -1054,7 +1054,7 @@ void vm_mem_add(struct kvm_vm *vm, enum vm_mem_backing_src_type src_type,
 	TEST_ASSERT(ret == 0, "KVM_SET_USER_MEMORY_REGION2 IOCTL failed,\n"
 		"  rc: %i errno: %i\n"
 		"  slot: %u flags: 0x%x\n"
-		"  guest_phys_addr: 0x%lx size: 0x%lx guest_memfd: %d\n",
+		"  guest_phys_addr: 0x%lx size: 0x%lx guest_memfd: %d",
 		ret, errno, slot, flags,
 		guest_paddr, (uint64_t) region->region.memory_size,
 		region->region.guest_memfd);
@@ -1219,7 +1219,7 @@ void vm_guest_mem_fallocate(struct kvm_vm *vm, uint64_t base, uint64_t size,
 		len = min_t(uint64_t, end - gpa, region->region.memory_size - offset);
 
 		ret = fallocate(region->region.guest_memfd, mode, fd_offset, len);
-		TEST_ASSERT(!ret, "fallocate() failed to %s at %lx (len = %lu), fd = %d, mode = %x, offset = %lx\n",
+		TEST_ASSERT(!ret, "fallocate() failed to %s at %lx (len = %lu), fd = %d, mode = %x, offset = %lx",
 			    punch_hole ? "punch hole" : "allocate", gpa, len,
 			    region->region.guest_memfd, mode, fd_offset);
 	}
@@ -1262,7 +1262,7 @@ struct kvm_vcpu *__vm_vcpu_add(struct kvm_vm *vm, uint32_t vcpu_id)
 	struct kvm_vcpu *vcpu;
 
 	/* Confirm a vcpu with the specified id doesn't already exist. */
-	TEST_ASSERT(!vcpu_exists(vm, vcpu_id), "vCPU%d already exists\n", vcpu_id);
+	TEST_ASSERT(!vcpu_exists(vm, vcpu_id), "vCPU%d already exists", vcpu_id);
 
 	/* Allocate and initialize new vcpu structure. */
 	vcpu = calloc(1, sizeof(*vcpu));
diff --git a/tools/testing/selftests/kvm/lib/memstress.c b/tools/testing/selftests/kvm/lib/memstress.c
index d05487e5a371..cf2c73971308 100644
--- a/tools/testing/selftests/kvm/lib/memstress.c
+++ b/tools/testing/selftests/kvm/lib/memstress.c
@@ -192,7 +192,7 @@ struct kvm_vm *memstress_create_vm(enum vm_guest_mode mode, int nr_vcpus,
 	TEST_ASSERT(guest_num_pages < region_end_gfn,
 		    "Requested more guest memory than address space allows.\n"
 		    "    guest pages: %" PRIx64 " max gfn: %" PRIx64
-		    " nr_vcpus: %d wss: %" PRIx64 "]\n",
+		    " nr_vcpus: %d wss: %" PRIx64 "]",
 		    guest_num_pages, region_end_gfn - 1, nr_vcpus, vcpu_memory_bytes);
 
 	args->gpa = (region_end_gfn - guest_num_pages - 1) * args->guest_page_size;
diff --git a/tools/testing/selftests/kvm/lib/userfaultfd_util.c b/tools/testing/selftests/kvm/lib/userfaultfd_util.c
index 271f63891581..f4eef6eb2dc2 100644
--- a/tools/testing/selftests/kvm/lib/userfaultfd_util.c
+++ b/tools/testing/selftests/kvm/lib/userfaultfd_util.c
@@ -69,7 +69,7 @@ static void *uffd_handler_thread_fn(void *arg)
 		if (pollfd[1].revents & POLLIN) {
 			r = read(pollfd[1].fd, &tmp_chr, 1);
 			TEST_ASSERT(r == 1,
-				    "Error reading pipefd in UFFD thread\n");
+				    "Error reading pipefd in UFFD thread");
 			break;
 		}
 
diff --git a/tools/testing/selftests/kvm/memslot_modification_stress_test.c b/tools/testing/selftests/kvm/memslot_modification_stress_test.c
index 9855c41ca811..156361966612 100644
--- a/tools/testing/selftests/kvm/memslot_modification_stress_test.c
+++ b/tools/testing/selftests/kvm/memslot_modification_stress_test.c
@@ -45,7 +45,7 @@ static void vcpu_worker(struct memstress_vcpu_args *vcpu_args)
 	/* Let the guest access its memory until a stop signal is received */
 	while (!READ_ONCE(memstress_args.stop_vcpus)) {
 		ret = _vcpu_run(vcpu);
-		TEST_ASSERT(ret == 0, "vcpu_run failed: %d\n", ret);
+		TEST_ASSERT(ret == 0, "vcpu_run failed: %d", ret);
 
 		if (get_ucall(vcpu, NULL) == UCALL_SYNC)
 			continue;
diff --git a/tools/testing/selftests/kvm/memslot_perf_test.c b/tools/testing/selftests/kvm/memslot_perf_test.c
index 8698d1ab60d0..579a64f97333 100644
--- a/tools/testing/selftests/kvm/memslot_perf_test.c
+++ b/tools/testing/selftests/kvm/memslot_perf_test.c
@@ -175,11 +175,11 @@ static void wait_for_vcpu(void)
 	struct timespec ts;
 
 	TEST_ASSERT(!clock_gettime(CLOCK_REALTIME, &ts),
-		    "clock_gettime() failed: %d\n", errno);
+		    "clock_gettime() failed: %d", errno);
 
 	ts.tv_sec += 2;
 	TEST_ASSERT(!sem_timedwait(&vcpu_ready, &ts),
-		    "sem_timedwait() failed: %d\n", errno);
+		    "sem_timedwait() failed: %d", errno);
 }
 
 static void *vm_gpa2hva(struct vm_data *data, uint64_t gpa, uint64_t *rempages)
@@ -336,7 +336,7 @@ static bool prepare_vm(struct vm_data *data, int nslots, uint64_t *maxslots,
 
 		gpa = vm_phy_pages_alloc(data->vm, npages, guest_addr, slot);
 		TEST_ASSERT(gpa == guest_addr,
-			    "vm_phy_pages_alloc() failed\n");
+			    "vm_phy_pages_alloc() failed");
 
 		data->hva_slots[slot - 1] = addr_gpa2hva(data->vm, guest_addr);
 		memset(data->hva_slots[slot - 1], 0, npages * guest_page_size);
diff --git a/tools/testing/selftests/kvm/rseq_test.c b/tools/testing/selftests/kvm/rseq_test.c
index f74e76d03b7e..28f97fb52044 100644
--- a/tools/testing/selftests/kvm/rseq_test.c
+++ b/tools/testing/selftests/kvm/rseq_test.c
@@ -245,7 +245,7 @@ int main(int argc, char *argv[])
 		} while (snapshot != atomic_read(&seq_cnt));
 
 		TEST_ASSERT(rseq_cpu == cpu,
-			    "rseq CPU = %d, sched CPU = %d\n", rseq_cpu, cpu);
+			    "rseq CPU = %d, sched CPU = %d", rseq_cpu, cpu);
 	}
 
 	/*
@@ -256,7 +256,7 @@ int main(int argc, char *argv[])
 	 * migrations given the 1us+ delay in the migration task.
 	 */
 	TEST_ASSERT(i > (NR_TASK_MIGRATIONS / 2),
-		    "Only performed %d KVM_RUNs, task stalled too much?\n", i);
+		    "Only performed %d KVM_RUNs, task stalled too much?", i);
 
 	pthread_join(migration_thread, NULL);
 
diff --git a/tools/testing/selftests/kvm/set_memory_region_test.c b/tools/testing/selftests/kvm/set_memory_region_test.c
index 03ec7efd19aa..1280ecac05a7 100644
--- a/tools/testing/selftests/kvm/set_memory_region_test.c
+++ b/tools/testing/selftests/kvm/set_memory_region_test.c
@@ -98,11 +98,11 @@ static void wait_for_vcpu(void)
 	struct timespec ts;
 
 	TEST_ASSERT(!clock_gettime(CLOCK_REALTIME, &ts),
-		    "clock_gettime() failed: %d\n", errno);
+		    "clock_gettime() failed: %d", errno);
 
 	ts.tv_sec += 2;
 	TEST_ASSERT(!sem_timedwait(&vcpu_ready, &ts),
-		    "sem_timedwait() failed: %d\n", errno);
+		    "sem_timedwait() failed: %d", errno);
 
 	/* Wait for the vCPU thread to reenter the guest. */
 	usleep(100000);
@@ -302,7 +302,7 @@ static void test_delete_memory_region(void)
 	if (run->exit_reason == KVM_EXIT_INTERNAL_ERROR)
 		TEST_ASSERT(regs.rip >= final_rip_start &&
 			    regs.rip < final_rip_end,
-			    "Bad rip, expected 0x%lx - 0x%lx, got 0x%llx\n",
+			    "Bad rip, expected 0x%lx - 0x%lx, got 0x%llx",
 			    final_rip_start, final_rip_end, regs.rip);
 
 	kvm_vm_free(vm);
diff --git a/tools/testing/selftests/kvm/system_counter_offset_test.c b/tools/testing/selftests/kvm/system_counter_offset_test.c
index 7f5b330b6a1b..513d421a9bff 100644
--- a/tools/testing/selftests/kvm/system_counter_offset_test.c
+++ b/tools/testing/selftests/kvm/system_counter_offset_test.c
@@ -108,7 +108,7 @@ static void enter_guest(struct kvm_vcpu *vcpu)
 			handle_abort(&uc);
 			return;
 		default:
-			TEST_ASSERT(0, "unhandled ucall %ld\n",
+			TEST_ASSERT(0, "unhandled ucall %ld",
 				    get_ucall(vcpu, &uc));
 		}
 	}
-- 
2.43.0


