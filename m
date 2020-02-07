Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1574A155DAC
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2020 19:17:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727588AbgBGSR4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Feb 2020 13:17:56 -0500
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:40738 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727617AbgBGSQu (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 7 Feb 2020 13:16:50 -0500
Received: from smtp.bitdefender.com (smtp01.buh.bitdefender.com [10.17.80.75])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id D51F7305D350;
        Fri,  7 Feb 2020 20:16:40 +0200 (EET)
Received: from host.bbu.bitdefender.biz (unknown [195.210.4.22])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id C9A443032046;
        Fri,  7 Feb 2020 20:16:40 +0200 (EET)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        =?UTF-8?q?Mihai=20Don=C8=9Bu?= <mdontu@bitdefender.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [RFC PATCH v7 50/78] KVM: introspection: add KVMI_VCPU_GET_INFO
Date:   Fri,  7 Feb 2020 20:16:08 +0200
Message-Id: <20200207181636.1065-51-alazar@bitdefender.com>
In-Reply-To: <20200207181636.1065-1-alazar@bitdefender.com>
References: <20200207181636.1065-1-alazar@bitdefender.com>
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
 .../testing/selftests/kvm/x86_64/kvmi_test.c  | 144 +++++++++++++++++-
 virt/kvm/introspection/kvmi_int.h             |   5 +
 virt/kvm/introspection/kvmi_msg.c             |  23 +++
 8 files changed, 226 insertions(+), 2 deletions(-)
 create mode 100644 arch/x86/kvm/kvmi.c

diff --git a/Documentation/virt/kvm/kvmi.rst b/Documentation/virt/kvm/kvmi.rst
index 38f566b07bb5..8eb0006349d6 100644
--- a/Documentation/virt/kvm/kvmi.rst
+++ b/Documentation/virt/kvm/kvmi.rst
@@ -436,6 +436,35 @@ one page (offset + size <= PAGE_SIZE).
 * -KVM_EINVAL - the specified gpa/size pair is invalid
 * -KVM_ENOENT - the guest page doesn't exists
 
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
+* -KVM_EINVAL - the selected vCPU is invalid
+* -KVM_EINVAL - padding is not zero
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
index c46ec49dfeb9..fc28f6c75648 100644
--- a/arch/x86/kvm/Makefile
+++ b/arch/x86/kvm/Makefile
@@ -8,7 +8,7 @@ KVMI := $(KVM)/introspection
 kvm-y			+= $(KVM)/kvm_main.o $(KVM)/coalesced_mmio.o \
 				$(KVM)/eventfd.o $(KVM)/irqchip.o $(KVM)/vfio.o
 kvm-$(CONFIG_KVM_ASYNC_PF)	+= $(KVM)/async_pf.o
-kvm-$(CONFIG_KVM_INTROSPECTION) += $(KVMI)/kvmi.o $(KVMI)/kvmi_msg.o
+kvm-$(CONFIG_KVM_INTROSPECTION) += $(KVMI)/kvmi.o $(KVMI)/kvmi_msg.o kvmi.o
 
 kvm-y			+= x86.o emulate.o i8259.o irq.o lapic.o \
 			   i8254.o ioapic.o irq_comm.o cpuid.o pmu.o mtrr.o \
diff --git a/arch/x86/kvm/kvmi.c b/arch/x86/kvm/kvmi.c
new file mode 100644
index 000000000000..2afb3abc97fa
--- /dev/null
+++ b/arch/x86/kvm/kvmi.c
@@ -0,0 +1,19 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * KVM introspection - x86
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
index b2cbefdb8b29..b36ecc0d6513 100644
--- a/include/uapi/linux/kvmi.h
+++ b/include/uapi/linux/kvmi.h
@@ -25,6 +25,8 @@ enum {
 	KVMI_VM_READ_PHYSICAL  = 7,
 	KVMI_VM_WRITE_PHYSICAL = 8,
 
+	KVMI_VCPU_GET_INFO     = 9,
+
 	KVMI_NUM_MESSAGES
 };
 
diff --git a/tools/testing/selftests/kvm/x86_64/kvmi_test.c b/tools/testing/selftests/kvm/x86_64/kvmi_test.c
index b0573d7e2e5b..5c55f4ce5875 100644
--- a/tools/testing/selftests/kvm/x86_64/kvmi_test.c
+++ b/tools/testing/selftests/kvm/x86_64/kvmi_test.c
@@ -8,6 +8,7 @@
 #define _GNU_SOURCE /* for program_invocation_short_name */
 #include <sys/types.h>
 #include <sys/socket.h>
+#include <pthread.h>
 
 #include "test_util.h"
 
@@ -24,6 +25,7 @@ static int socket_pair[2];
 #define Kvm_socket       socket_pair[0]
 #define Userspace_socket socket_pair[1]
 
+static int test_id;
 static vm_vaddr_t test_gva;
 static void *test_hva;
 static vm_paddr_t test_gpa;
@@ -31,6 +33,39 @@ static vm_paddr_t test_gpa;
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
@@ -507,6 +542,112 @@ static void test_memory_access(struct kvm_vm *vm)
 
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
+	while (!ctx->stop) {
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
+	data->stop = true;
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
+	struct kvmi_vcpu_hdr *vcpu_hdr = (struct kvmi_vcpu_hdr *)req;
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
+		    "Command %d failed, error %d (%s)\n",
+		    cmd_id, -r, kvm_strerror(-r));
+}
+
+static void test_cmd_get_vcpu_info(struct kvm_vm *vm)
+{
+	struct {
+		struct kvmi_msg_hdr hdr;
+		struct kvmi_vcpu_hdr vcpu_hdr;
+	} req = {};
+	struct kvmi_vcpu_get_info_reply rpl;
+
+	test_vcpu0_command(vm, KVMI_VCPU_GET_INFO, &req.hdr, sizeof(req),
+			   &rpl, sizeof(rpl));
+
+	DEBUG("tsc_speed: %llu HZ\n", rpl.tsc_speed);
+}
+
 static void test_introspection(struct kvm_vm *vm)
 {
 	setup_socket();
@@ -520,6 +661,7 @@ static void test_introspection(struct kvm_vm *vm)
 	test_event_unhook(vm);
 	test_cmd_vm_control_events();
 	test_memory_access(vm);
+	test_cmd_get_vcpu_info(vm);
 
 	unhook_introspection(vm);
 }
@@ -546,7 +688,7 @@ int main(int argc, char *argv[])
 		exit(KSFT_SKIP);
 	}
 
-	vm = vm_create_default(VCPU_ID, 0, NULL);
+	vm = vm_create_default(VCPU_ID, 0, guest_code);
 	vcpu_set_cpuid(vm, VCPU_ID, kvm_get_supported_cpuid());
 
 	page_size = getpagesize();
diff --git a/virt/kvm/introspection/kvmi_int.h b/virt/kvm/introspection/kvmi_int.h
index e7ebb4d67dd6..bab73fc232ec 100644
--- a/virt/kvm/introspection/kvmi_int.h
+++ b/virt/kvm/introspection/kvmi_int.h
@@ -33,6 +33,7 @@
 			| BIT(KVMI_VM_GET_INFO) \
 			| BIT(KVMI_VM_READ_PHYSICAL) \
 			| BIT(KVMI_VM_WRITE_PHYSICAL) \
+			| BIT(KVMI_VCPU_GET_INFO) \
 		)
 
 #define KVMI(kvm) ((struct kvm_introspection *)((kvm)->kvmi))
@@ -68,4 +69,8 @@ int kvmi_cmd_read_physical(struct kvm *kvm, u64 gpa, u64 size,
 int kvmi_cmd_write_physical(struct kvm *kvm, u64 gpa, u64 size,
 			    const void *buf);
 
+/* arch */
+int kvmi_arch_cmd_vcpu_get_info(struct kvm_vcpu *vcpu,
+				struct kvmi_vcpu_get_info_reply *rpl);
+
 #endif
diff --git a/virt/kvm/introspection/kvmi_msg.c b/virt/kvm/introspection/kvmi_msg.c
index 94225153f7cc..4e7a2ceb78da 100644
--- a/virt/kvm/introspection/kvmi_msg.c
+++ b/virt/kvm/introspection/kvmi_msg.c
@@ -24,6 +24,7 @@ static const char *const msg_IDs[] = {
 	[KVMI_VM_GET_INFO]       = "KVMI_VM_GET_INFO",
 	[KVMI_VM_READ_PHYSICAL]  = "KVMI_VM_READ_PHYSICAL",
 	[KVMI_VM_WRITE_PHYSICAL] = "KVMI_VM_WRITE_PHYSICAL",
+	[KVMI_VCPU_GET_INFO]     = "KVMI_VCPU_GET_INFO",
 };
 
 static bool is_known_message(u16 id)
@@ -126,6 +127,15 @@ static int kvmi_msg_vm_reply(struct kvm_introspection *kvmi,
 	return kvmi_msg_reply(kvmi, msg, err, rpl, rpl_size);
 }
 
+static int kvmi_msg_vcpu_reply(const struct kvmi_vcpu_cmd_job *job,
+				const struct kvmi_msg_hdr *msg, int err,
+				const void *rpl, size_t rpl_size)
+{
+	struct kvm_introspection *kvmi = KVMI(job->vcpu->kvm);
+
+	return kvmi_msg_reply(kvmi, msg, err, rpl, rpl_size);
+}
+
 static bool is_command_allowed(struct kvm_introspection *kvmi, int id)
 {
 	return test_bit(id, kvmi->cmd_allow_mask);
@@ -295,6 +305,18 @@ static int(*const msg_vm[])(struct kvm_introspection *,
 	[KVMI_VM_WRITE_PHYSICAL] = handle_write_physical,
 };
 
+static int handle_get_vcpu_info(const struct kvmi_vcpu_cmd_job *job,
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
  * These commands are executed on the vCPU thread. The receiving thread
  * passes the messages using a newly allocated 'struct kvmi_vcpu_cmd_job'
@@ -303,6 +325,7 @@ static int(*const msg_vm[])(struct kvm_introspection *,
  */
 static int(*const msg_vcpu[])(const struct kvmi_vcpu_cmd_job *,
 			      const struct kvmi_msg_hdr *, const void *) = {
+	[KVMI_VCPU_GET_INFO] = handle_get_vcpu_info,
 };
 
 static void kvmi_job_vcpu_cmd(struct kvm_vcpu *vcpu, void *ctx)
