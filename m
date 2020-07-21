Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39498228AD3
	for <lists+kvm@lfdr.de>; Tue, 21 Jul 2020 23:17:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731388AbgGUVRX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jul 2020 17:17:23 -0400
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:38064 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731315AbgGUVQK (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 21 Jul 2020 17:16:10 -0400
Received: from smtp.bitdefender.com (smtp02.buh.bitdefender.net [10.17.80.76])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id 26976305D599;
        Wed, 22 Jul 2020 00:09:27 +0300 (EEST)
Received: from localhost.localdomain (unknown [91.199.104.27])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id 0418F304FA13;
        Wed, 22 Jul 2020 00:09:27 +0300 (EEST)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Mihai=20Don=C8=9Bu?= <mdontu@bitdefender.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [PATCH v9 51/84] KVM: introspection: add KVMI_VCPU_GET_INFO
Date:   Wed, 22 Jul 2020 00:08:49 +0300
Message-Id: <20200721210922.7646-52-alazar@bitdefender.com>
In-Reply-To: <20200721210922.7646-1-alazar@bitdefender.com>
References: <20200721210922.7646-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Mihai Donțu <mdontu@bitdefender.com>

For now, this command returns the TSC frequency (in HZ) for the specified
vCPU if available (otherwise it returns zero).

Signed-off-by: Mihai Donțu <mdontu@bitdefender.com>
Co-developed-by: Adalbert Lazăr <alazar@bitdefender.com>
Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 Documentation/virt/kvm/kvmi.rst               |  29 ++++
 arch/x86/include/uapi/asm/kvmi.h              |   4 +
 arch/x86/kvm/Makefile                         |   2 +-
 arch/x86/kvm/kvmi.c                           |  19 +++
 include/uapi/linux/kvmi.h                     |   2 +
 .../testing/selftests/kvm/x86_64/kvmi_test.c  | 152 +++++++++++++++++-
 virt/kvm/introspection/kvmi_int.h             |   4 +
 virt/kvm/introspection/kvmi_msg.c             |  22 +++
 8 files changed, 232 insertions(+), 2 deletions(-)
 create mode 100644 arch/x86/kvm/kvmi.c

diff --git a/Documentation/virt/kvm/kvmi.rst b/Documentation/virt/kvm/kvmi.rst
index 383bf39ec1e4..5ead29a7b2a7 100644
--- a/Documentation/virt/kvm/kvmi.rst
+++ b/Documentation/virt/kvm/kvmi.rst
@@ -451,6 +451,35 @@ one page (offset + size <= PAGE_SIZE).
 * -KVM_EINVAL - the specified gpa/size pair is invalid
 * -KVM_EINVAL - the padding is not zero
 
+8. KVMI_VCPU_GET_INFO
+---------------------
+
+:Architectures: all
+:Versions: >= 1
+:Parameters:
+
+::
+
+	struct kvmi_vcpu_hdr;
+
+:Returns:
+
+::
+
+	struct kvmi_error_code;
+	struct kvmi_vcpu_get_info_reply {
+		__u64 tsc_speed;
+	};
+
+Returns the TSC frequency (in HZ) for the specified vCPU if available
+(otherwise it returns zero).
+
+:Errors:
+
+* -KVM_EINVAL - the padding is not zero
+* -KVM_EINVAL - the selected vCPU is invalid
+* -KVM_EAGAIN - the selected vCPU can't be introspected yet
+
 Events
 ======
 
diff --git a/arch/x86/include/uapi/asm/kvmi.h b/arch/x86/include/uapi/asm/kvmi.h
index 551f9ed1ed9c..89adf84cefe4 100644
--- a/arch/x86/include/uapi/asm/kvmi.h
+++ b/arch/x86/include/uapi/asm/kvmi.h
@@ -26,4 +26,8 @@ struct kvmi_event_arch {
 	} msrs;
 };
 
+struct kvmi_vcpu_get_info_reply {
+	__u64 tsc_speed;
+};
+
 #endif /* _UAPI_ASM_X86_KVMI_H */
diff --git a/arch/x86/kvm/Makefile b/arch/x86/kvm/Makefile
index fb0242032cd1..3cfe76299dee 100644
--- a/arch/x86/kvm/Makefile
+++ b/arch/x86/kvm/Makefile
@@ -13,7 +13,7 @@ KVMI := $(KVM)/introspection
 kvm-y			+= $(KVM)/kvm_main.o $(KVM)/coalesced_mmio.o \
 				$(KVM)/eventfd.o $(KVM)/irqchip.o $(KVM)/vfio.o
 kvm-$(CONFIG_KVM_ASYNC_PF)	+= $(KVM)/async_pf.o
-kvm-$(CONFIG_KVM_INTROSPECTION) += $(KVMI)/kvmi.o $(KVMI)/kvmi_msg.o
+kvm-$(CONFIG_KVM_INTROSPECTION) += $(KVMI)/kvmi.o $(KVMI)/kvmi_msg.o kvmi.o
 
 kvm-y			+= x86.o emulate.o i8259.o irq.o lapic.o \
 			   i8254.o ioapic.o irq_comm.o cpuid.o pmu.o mtrr.o \
diff --git a/arch/x86/kvm/kvmi.c b/arch/x86/kvm/kvmi.c
new file mode 100644
index 000000000000..cf7bfff6c8c5
--- /dev/null
+++ b/arch/x86/kvm/kvmi.c
@@ -0,0 +1,19 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * KVM Introspection - x86
+ *
+ * Copyright (C) 2019-2020 Bitdefender S.R.L.
+ */
+
+#include "../../../virt/kvm/introspection/kvmi_int.h"
+
+int kvmi_arch_cmd_vcpu_get_info(struct kvm_vcpu *vcpu,
+				struct kvmi_vcpu_get_info_reply *rpl)
+{
+	if (kvm_has_tsc_control)
+		rpl->tsc_speed = 1000ul * vcpu->arch.virtual_tsc_khz;
+	else
+		rpl->tsc_speed = 0;
+
+	return 0;
+}
diff --git a/include/uapi/linux/kvmi.h b/include/uapi/linux/kvmi.h
index b206b7441859..a3dca420c887 100644
--- a/include/uapi/linux/kvmi.h
+++ b/include/uapi/linux/kvmi.h
@@ -25,6 +25,8 @@ enum {
 	KVMI_VM_READ_PHYSICAL  = 6,
 	KVMI_VM_WRITE_PHYSICAL = 7,
 
+	KVMI_VCPU_GET_INFO     = 8,
+
 	KVMI_NUM_MESSAGES
 };
 
diff --git a/tools/testing/selftests/kvm/x86_64/kvmi_test.c b/tools/testing/selftests/kvm/x86_64/kvmi_test.c
index 97dec49d52b7..107661fbe52f 100644
--- a/tools/testing/selftests/kvm/x86_64/kvmi_test.c
+++ b/tools/testing/selftests/kvm/x86_64/kvmi_test.c
@@ -9,6 +9,7 @@
 #include <sys/types.h>
 #include <sys/socket.h>
 #include <time.h>
+#include <pthread.h>
 
 #include "test_util.h"
 
@@ -25,6 +26,7 @@ static int socket_pair[2];
 #define Kvm_socket       socket_pair[0]
 #define Userspace_socket socket_pair[1]
 
+static int test_id;
 static vm_vaddr_t test_gva;
 static void *test_hva;
 static vm_paddr_t test_gpa;
@@ -32,6 +34,39 @@ static vm_paddr_t test_gpa;
 static uint8_t test_write_pattern;
 static int page_size;
 
+struct vcpu_worker_data {
+	struct kvm_vm *vm;
+	int vcpu_id;
+	int test_id;
+	bool stop;
+};
+
+enum {
+	GUEST_TEST_NOOP = 0,
+};
+
+#define GUEST_REQUEST_TEST()     GUEST_SYNC(0)
+#define GUEST_SIGNAL_TEST_DONE() GUEST_SYNC(1)
+
+#define HOST_SEND_TEST(uc)       (uc.cmd == UCALL_SYNC && uc.args[1] == 0)
+
+static int guest_test_id(void)
+{
+	GUEST_REQUEST_TEST();
+	return READ_ONCE(test_id);
+}
+
+static void guest_code(void)
+{
+	while (true) {
+		switch (guest_test_id()) {
+		case GUEST_TEST_NOOP:
+			break;
+		}
+		GUEST_SIGNAL_TEST_DONE();
+	}
+}
+
 void setup_socket(void)
 {
 	int r;
@@ -587,6 +622,120 @@ static void test_memory_access(struct kvm_vm *vm)
 
 	read_invalid_guest_page(vm);
 }
+
+static void *vcpu_worker(void *data)
+{
+	struct vcpu_worker_data *ctx = data;
+	struct kvm_run *run;
+
+	run = vcpu_state(ctx->vm, ctx->vcpu_id);
+
+	while (!READ_ONCE(ctx->stop)) {
+		struct ucall uc;
+
+		vcpu_run(ctx->vm, ctx->vcpu_id);
+
+		TEST_ASSERT(run->exit_reason == KVM_EXIT_IO,
+			"vcpu_run() failed, test_id %d, exit reason %u (%s)\n",
+			ctx->test_id, run->exit_reason,
+			exit_reason_str(run->exit_reason));
+
+		TEST_ASSERT(get_ucall(ctx->vm, ctx->vcpu_id, &uc),
+			"No guest request\n");
+
+		if (HOST_SEND_TEST(uc)) {
+			test_id = READ_ONCE(ctx->test_id);
+			sync_global_to_guest(ctx->vm, test_id);
+		}
+	}
+
+	return NULL;
+}
+
+static pthread_t start_vcpu_worker(struct vcpu_worker_data *data)
+{
+	pthread_t thread_id;
+
+	pthread_create(&thread_id, NULL, vcpu_worker, data);
+
+	return thread_id;
+}
+
+static void wait_vcpu_worker(pthread_t vcpu_thread)
+{
+	pthread_join(vcpu_thread, NULL);
+}
+
+static void stop_vcpu_worker(pthread_t vcpu_thread,
+			     struct vcpu_worker_data *data)
+{
+	WRITE_ONCE(data->stop, true);
+
+	wait_vcpu_worker(vcpu_thread);
+}
+
+static int do_vcpu_command(struct kvm_vm *vm, int cmd_id,
+			   struct kvmi_msg_hdr *req, size_t req_size,
+			   void *rpl, size_t rpl_size)
+{
+	struct vcpu_worker_data data = {.vm = vm, .vcpu_id = VCPU_ID };
+	pthread_t vcpu_thread;
+	int r;
+
+	vcpu_thread = start_vcpu_worker(&data);
+
+	send_message(cmd_id, req, req_size);
+	r = receive_cmd_reply(req, rpl, rpl_size);
+
+	stop_vcpu_worker(vcpu_thread, &data);
+	return r;
+}
+
+static int do_vcpu0_command(struct kvm_vm *vm, int cmd_id,
+			    struct kvmi_msg_hdr *req, size_t req_size,
+			    void *rpl, size_t rpl_size)
+{
+	struct kvmi_vcpu_hdr *vcpu_hdr = (struct kvmi_vcpu_hdr *)(req + 1);
+
+	vcpu_hdr->vcpu = 0;
+
+	return do_vcpu_command(vm, cmd_id, req, req_size, rpl, rpl_size);
+}
+
+static void test_vcpu0_command(struct kvm_vm *vm, int cmd_id,
+			       struct kvmi_msg_hdr *req, size_t req_size,
+			       void *rpl, size_t rpl_size)
+{
+	int r;
+
+	r = do_vcpu0_command(vm, cmd_id, req, req_size, rpl, rpl_size);
+	TEST_ASSERT(r == 0,
+		"Command %d failed, error %d (%s)\n",
+		cmd_id, -r, kvm_strerror(-r));
+}
+
+static void test_cmd_vcpu_get_info(struct kvm_vm *vm)
+{
+	struct {
+		struct kvmi_msg_hdr hdr;
+		struct kvmi_vcpu_hdr vcpu_hdr;
+	} req = {};
+	struct kvmi_vcpu_get_info_reply rpl;
+	int cmd_id = KVMI_VCPU_GET_INFO;
+	int r;
+
+	test_vcpu0_command(vm, cmd_id, &req.hdr, sizeof(req),
+			   &rpl, sizeof(rpl));
+
+	pr_info("tsc_speed: %llu HZ\n", rpl.tsc_speed);
+
+	req.vcpu_hdr.vcpu = 99;
+	r = do_command(cmd_id, &req.hdr, sizeof(req), &rpl, sizeof(rpl));
+	TEST_ASSERT(r == -KVM_EINVAL,
+		"KVMI_VCPU_GET_INFO didn't failed with -KVM_EINVAL, error %d (%s)\n",
+		-r, kvm_strerror(-r));
+}
+
 static void test_introspection(struct kvm_vm *vm)
 {
 	srandom(time(0));
@@ -601,6 +750,7 @@ static void test_introspection(struct kvm_vm *vm)
 	test_event_unhook(vm);
 	test_cmd_vm_control_events(vm);
 	test_memory_access(vm);
+	test_cmd_vcpu_get_info(vm);
 
 	unhook_introspection(vm);
 }
@@ -626,7 +776,7 @@ int main(int argc, char *argv[])
 		exit(KSFT_SKIP);
 	}
 
-	vm = vm_create_default(VCPU_ID, 0, NULL);
+	vm = vm_create_default(VCPU_ID, 0, guest_code);
 	vcpu_set_cpuid(vm, VCPU_ID, kvm_get_supported_cpuid());
 
 	page_size = getpagesize();
diff --git a/virt/kvm/introspection/kvmi_int.h b/virt/kvm/introspection/kvmi_int.h
index fe5190ab31d6..42803b6d0e81 100644
--- a/virt/kvm/introspection/kvmi_int.h
+++ b/virt/kvm/introspection/kvmi_int.h
@@ -47,4 +47,8 @@ int kvmi_cmd_read_physical(struct kvm *kvm, u64 gpa, size_t size,
 int kvmi_cmd_write_physical(struct kvm *kvm, u64 gpa, size_t size,
 			    const void *buf);
 
+/* arch */
+int kvmi_arch_cmd_vcpu_get_info(struct kvm_vcpu *vcpu,
+				struct kvmi_vcpu_get_info_reply *rpl);
+
 #endif
diff --git a/virt/kvm/introspection/kvmi_msg.c b/virt/kvm/introspection/kvmi_msg.c
index 31a471df4b12..ee25ba44fb0b 100644
--- a/virt/kvm/introspection/kvmi_msg.c
+++ b/virt/kvm/introspection/kvmi_msg.c
@@ -109,6 +109,15 @@ static int kvmi_msg_vm_reply(struct kvm_introspection *kvmi,
 	return kvmi_msg_reply(kvmi, msg, err, rpl, rpl_size);
 }
 
+static int kvmi_msg_vcpu_reply(const struct kvmi_vcpu_msg_job *job,
+				const struct kvmi_msg_hdr *msg, int err,
+				const void *rpl, size_t rpl_size)
+{
+	struct kvm_introspection *kvmi = KVMI(job->vcpu->kvm);
+
+	return kvmi_msg_reply(kvmi, msg, err, rpl, rpl_size);
+}
+
 static bool invalid_vcpu_hdr(const struct kvmi_vcpu_hdr *hdr)
 {
 	return hdr->padding1 || hdr->padding2;
@@ -274,6 +283,18 @@ static bool is_vm_command(u16 id)
 	return id < ARRAY_SIZE(msg_vm) && !!msg_vm[id];
 }
 
+static int handle_vcpu_get_info(const struct kvmi_vcpu_msg_job *job,
+				const struct kvmi_msg_hdr *msg,
+				const void *req)
+{
+	struct kvmi_vcpu_get_info_reply rpl;
+
+	memset(&rpl, 0, sizeof(rpl));
+	kvmi_arch_cmd_vcpu_get_info(job->vcpu, &rpl);
+
+	return kvmi_msg_vcpu_reply(job, msg, 0, &rpl, sizeof(rpl));
+}
+
 /*
  * These functions are executed from the vCPU thread. The receiving thread
  * passes the messages using a newly allocated 'struct kvmi_vcpu_msg_job'
@@ -282,6 +303,7 @@ static bool is_vm_command(u16 id)
  */
 static int(*const msg_vcpu[])(const struct kvmi_vcpu_msg_job *,
 			      const struct kvmi_msg_hdr *, const void *) = {
+	[KVMI_VCPU_GET_INFO] = handle_vcpu_get_info,
 };
 
 static bool is_vcpu_command(u16 id)
