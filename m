Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63CFF424491
	for <lists+kvm@lfdr.de>; Wed,  6 Oct 2021 19:40:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239338AbhJFRmj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Oct 2021 13:42:39 -0400
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:53560 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234560AbhJFRme (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 6 Oct 2021 13:42:34 -0400
Received: from smtp.bitdefender.com (smtp01.buh.bitdefender.com [10.17.80.75])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id 0DA3E307CAFE;
        Wed,  6 Oct 2021 20:31:12 +0300 (EEST)
Received: from localhost (unknown [91.199.104.28])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id E274F3064495;
        Wed,  6 Oct 2021 20:31:11 +0300 (EEST)
X-Is-Junk-Enabled: fGZTSsP0qEJE2AIKtlSuFiRRwg9xyHmJ
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Mathieu Tarral <mathieu.tarral@protonmail.com>,
        Tamas K Lengyel <tamas@tklengyel.com>,
        =?UTF-8?q?Mihai=20Don=C8=9Bu?= <mdontu@bitdefender.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [PATCH v12 44/77] KVM: introspection: add KVMI_VCPU_GET_INFO
Date:   Wed,  6 Oct 2021 20:30:40 +0300
Message-Id: <20211006173113.26445-45-alazar@bitdefender.com>
In-Reply-To: <20211006173113.26445-1-alazar@bitdefender.com>
References: <20211006173113.26445-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Mihai Donțu <mdontu@bitdefender.com>

This command returns the TSC frequency (in HZ) for the specified
vCPU if available (otherwise it returns zero).

Signed-off-by: Mihai Donțu <mdontu@bitdefender.com>
Co-developed-by: Adalbert Lazăr <alazar@bitdefender.com>
Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 Documentation/virt/kvm/kvmi.rst               |  29 ++++
 arch/x86/include/asm/kvmi_host.h              |   2 +
 arch/x86/include/uapi/asm/kvmi.h              |  13 ++
 arch/x86/kvm/kvmi_msg.c                       |  14 ++
 include/uapi/linux/kvmi.h                     |   2 +
 .../testing/selftests/kvm/x86_64/kvmi_test.c  | 153 +++++++++++++++++-
 virt/kvm/introspection/kvmi_int.h             |   3 +
 virt/kvm/introspection/kvmi_msg.c             |   9 ++
 8 files changed, 223 insertions(+), 2 deletions(-)
 create mode 100644 arch/x86/include/uapi/asm/kvmi.h

diff --git a/Documentation/virt/kvm/kvmi.rst b/Documentation/virt/kvm/kvmi.rst
index 79152f47b30f..2f41fce79d95 100644
--- a/Documentation/virt/kvm/kvmi.rst
+++ b/Documentation/virt/kvm/kvmi.rst
@@ -441,6 +441,35 @@ one page (offset + size <= PAGE_SIZE).
 * -KVM_EINVAL - the specified gpa/size pair is invalid
 * -KVM_EINVAL - the padding is not zero
 
+8. KVMI_VCPU_GET_INFO
+---------------------
+
+:Architectures: x86
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
 
diff --git a/arch/x86/include/asm/kvmi_host.h b/arch/x86/include/asm/kvmi_host.h
index 360a57dd9019..05ade3a16b24 100644
--- a/arch/x86/include/asm/kvmi_host.h
+++ b/arch/x86/include/asm/kvmi_host.h
@@ -2,6 +2,8 @@
 #ifndef _ASM_X86_KVMI_HOST_H
 #define _ASM_X86_KVMI_HOST_H
 
+#include <asm/kvmi.h>
+
 struct kvm_vcpu_arch_introspection {
 };
 
diff --git a/arch/x86/include/uapi/asm/kvmi.h b/arch/x86/include/uapi/asm/kvmi.h
new file mode 100644
index 000000000000..2b6192e1a9a4
--- /dev/null
+++ b/arch/x86/include/uapi/asm/kvmi.h
@@ -0,0 +1,13 @@
+/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
+#ifndef _UAPI_ASM_X86_KVMI_H
+#define _UAPI_ASM_X86_KVMI_H
+
+/*
+ * KVM introspection - x86 specific structures and definitions
+ */
+
+struct kvmi_vcpu_get_info_reply {
+	__u64 tsc_speed;
+};
+
+#endif /* _UAPI_ASM_X86_KVMI_H */
diff --git a/arch/x86/kvm/kvmi_msg.c b/arch/x86/kvm/kvmi_msg.c
index 0a6edfe16f17..0d83c47f3758 100644
--- a/arch/x86/kvm/kvmi_msg.c
+++ b/arch/x86/kvm/kvmi_msg.c
@@ -8,7 +8,21 @@
 
 #include "../../../virt/kvm/introspection/kvmi_int.h"
 
+static int handle_vcpu_get_info(const struct kvmi_vcpu_msg_job *job,
+				const struct kvmi_msg_hdr *msg,
+				const void *req)
+{
+	struct kvmi_vcpu_get_info_reply rpl;
+
+	memset(&rpl, 0, sizeof(rpl));
+	if (kvm_has_tsc_control)
+		rpl.tsc_speed = 1000ul * job->vcpu->arch.virtual_tsc_khz;
+
+	return kvmi_msg_vcpu_reply(job, msg, 0, &rpl, sizeof(rpl));
+}
+
 static const kvmi_vcpu_msg_job_fct msg_vcpu[] = {
+	[KVMI_VCPU_GET_INFO] = handle_vcpu_get_info,
 };
 
 kvmi_vcpu_msg_job_fct kvmi_arch_vcpu_msg_handler(u16 id)
diff --git a/include/uapi/linux/kvmi.h b/include/uapi/linux/kvmi.h
index 7ba1c8758aba..da766427231e 100644
--- a/include/uapi/linux/kvmi.h
+++ b/include/uapi/linux/kvmi.h
@@ -31,6 +31,8 @@ enum {
 };
 
 enum {
+	KVMI_VCPU_GET_INFO = KVMI_VCPU_MESSAGE_ID(1),
+
 	KVMI_NEXT_VCPU_MESSAGE
 };
 
diff --git a/tools/testing/selftests/kvm/x86_64/kvmi_test.c b/tools/testing/selftests/kvm/x86_64/kvmi_test.c
index 28dd6414a7e8..337f295d69ff 100644
--- a/tools/testing/selftests/kvm/x86_64/kvmi_test.c
+++ b/tools/testing/selftests/kvm/x86_64/kvmi_test.c
@@ -9,6 +9,7 @@
 #include <sys/types.h>
 #include <sys/socket.h>
 #include <time.h>
+#include <pthread.h>
 
 #include "test_util.h"
 
@@ -18,6 +19,7 @@
 
 #include "linux/kvm_para.h"
 #include "linux/kvmi.h"
+#include "asm/kvmi.h"
 
 #define VCPU_ID 1
 
@@ -25,12 +27,49 @@ static int socket_pair[2];
 #define Kvm_socket       socket_pair[0]
 #define Userspace_socket socket_pair[1]
 
+static int test_id;
 static vm_vaddr_t test_gva;
 static void *test_hva;
 static vm_paddr_t test_gpa;
 
 static int page_size;
 
+struct vcpu_worker_data {
+	struct kvm_vm *vm;
+	int vcpu_id;
+	int test_id;
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
+#define HOST_TEST_DONE(uc)       (uc.cmd == UCALL_SYNC && uc.args[1] == 1)
+
+static pthread_t start_vcpu_worker(struct vcpu_worker_data *data);
+static void wait_vcpu_worker(pthread_t vcpu_thread);
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
@@ -104,19 +143,23 @@ static void allow_command(struct kvm_vm *vm, __s32 id)
 
 static void hook_introspection(struct kvm_vm *vm)
 {
+	struct vcpu_worker_data data = {.vm = vm, .vcpu_id = VCPU_ID };
 	__u32 allow = 1, disallow = 0, allow_inval = 2;
+	pthread_t vcpu_thread;
 	__s32 all_IDs = -1;
 
 	set_command_perm(vm, all_IDs, allow, EFAULT);
 	set_event_perm(vm, all_IDs, allow, EFAULT);
 
-	/* do_hook_ioctl(vm, -1, EINVAL); */
+	do_hook_ioctl(vm, -1, EINVAL);
 
 	/*
 	 * The last call failed "too late".
 	 * We have to let the vCPU run and clean up its structures,
 	 * otherwise the next call will fail with EEXIST.
 	 */
+	vcpu_thread = start_vcpu_worker(&data);
+	wait_vcpu_worker(vcpu_thread);
 
 	do_hook_ioctl(vm, Kvm_socket, 0);
 	do_hook_ioctl(vm, Kvm_socket, EEXIST);
@@ -537,6 +580,111 @@ static void test_memory_access(struct kvm_vm *vm)
 	read_invalid_guest_page(vm);
 }
 
+static void *vcpu_worker(void *data)
+{
+	struct vcpu_worker_data *ctx = data;
+	struct kvm_run *run;
+
+	run = vcpu_state(ctx->vm, ctx->vcpu_id);
+
+	while (true) {
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
+		} else if (HOST_TEST_DONE(uc)) {
+			break;
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
+	r = do_command(cmd_id, req, req_size, rpl, rpl_size);
+
+	wait_vcpu_worker(vcpu_thread);
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
+			       void *rpl, size_t rpl_size,
+			       int expected_err)
+{
+	int r;
+
+	r = do_vcpu0_command(vm, cmd_id, req, req_size, rpl, rpl_size);
+	TEST_ASSERT(r == expected_err,
+		"Command %d failed, error %d (%s) instead of %d (%s)\n",
+		cmd_id, -r, kvm_strerror(-r),
+		expected_err, kvm_strerror(expected_err));
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
+
+	test_vcpu0_command(vm, cmd_id, &req.hdr, sizeof(req),
+			   &rpl, sizeof(rpl), 0);
+
+	pr_debug("tsc_speed: %llu HZ\n", rpl.tsc_speed);
+
+	req.vcpu_hdr.vcpu = 99;
+	test_vm_command(cmd_id, &req.hdr, sizeof(req),
+			&rpl, sizeof(rpl), -KVM_EINVAL);
+}
+
 static void test_introspection(struct kvm_vm *vm)
 {
 	srandom(time(0));
@@ -551,6 +699,7 @@ static void test_introspection(struct kvm_vm *vm)
 	test_event_unhook(vm);
 	test_cmd_vm_control_events(vm);
 	test_memory_access(vm);
+	test_cmd_vcpu_get_info(vm);
 
 	unhook_introspection(vm);
 }
@@ -573,7 +722,7 @@ int main(int argc, char *argv[])
 		exit(KSFT_SKIP);
 	}
 
-	vm = vm_create_default(VCPU_ID, 0, NULL);
+	vm = vm_create_default(VCPU_ID, 0, guest_code);
 	vcpu_set_cpuid(vm, VCPU_ID, kvm_get_supported_cpuid());
 
 	page_size = getpagesize();
diff --git a/virt/kvm/introspection/kvmi_int.h b/virt/kvm/introspection/kvmi_int.h
index c3e4da7e7f20..126e72201518 100644
--- a/virt/kvm/introspection/kvmi_int.h
+++ b/virt/kvm/introspection/kvmi_int.h
@@ -32,6 +32,9 @@ void kvmi_sock_shutdown(struct kvm_introspection *kvmi);
 void kvmi_sock_put(struct kvm_introspection *kvmi);
 bool kvmi_msg_process(struct kvm_introspection *kvmi);
 int kvmi_msg_send_unhook(struct kvm_introspection *kvmi);
+int kvmi_msg_vcpu_reply(const struct kvmi_vcpu_msg_job *job,
+			const struct kvmi_msg_hdr *msg, int err,
+			const void *rpl, size_t rpl_size);
 
 /* kvmi.c */
 void *kvmi_msg_alloc(void);
diff --git a/virt/kvm/introspection/kvmi_msg.c b/virt/kvm/introspection/kvmi_msg.c
index 82e2b49a960e..4cb19f069de2 100644
--- a/virt/kvm/introspection/kvmi_msg.c
+++ b/virt/kvm/introspection/kvmi_msg.c
@@ -105,6 +105,15 @@ static int kvmi_msg_vm_reply(struct kvm_introspection *kvmi,
 	return kvmi_msg_reply(kvmi, msg, err, rpl, rpl_size);
 }
 
+int kvmi_msg_vcpu_reply(const struct kvmi_vcpu_msg_job *job,
+			const struct kvmi_msg_hdr *msg, int err,
+			const void *rpl, size_t rpl_size)
+{
+	struct kvm_introspection *kvmi = KVMI(job->vcpu->kvm);
+
+	return kvmi_msg_reply(kvmi, msg, err, rpl, rpl_size);
+}
+
 static struct kvm_vcpu *kvmi_get_vcpu(struct kvm_introspection *kvmi,
 				      unsigned int vcpu_idx)
 {
