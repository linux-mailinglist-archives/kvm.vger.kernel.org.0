Return-Path: <kvm+bounces-71936-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id EOM/Ezf6n2n3fAQAu9opvQ
	(envelope-from <kvm+bounces-71936-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 08:45:59 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id B6AA71A2019
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 08:45:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 0F96D30378D6
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 07:45:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E4B1D3921C9;
	Thu, 26 Feb 2026 07:45:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sony.com header.i=@sony.com header.b="BL1V1/0k"
X-Original-To: kvm@vger.kernel.org
Received: from jpms-ob01.noc.sony.co.jp (jpms-ob01.noc.sony.co.jp [211.125.140.164])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFD5F18DF9D;
	Thu, 26 Feb 2026 07:45:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.125.140.164
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772091944; cv=none; b=vE/eKxJsGXwcE3di6I0RdTTE3lINQBk3IKonQe5tP/NwdzQ82IGNxE1F5tK7s+1jxHFjx/pOb8bosZA5omYa2/nhZs9IJ2syRPcXsrwTIGfTUg3/lNZuKO54O1rJr8UeCMSR6OQCu9Cr272zEHOgkYQATsMyv3FqqU1eymVk4Nw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772091944; c=relaxed/simple;
	bh=XlyfTKQvT+attS79aJv44qTZ3vo2uGVzMyVcldJbDmk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aUC6+P5AEXP7qNJZMsXWBLzqOSK6z7lwB4VHKWcAop3WJDkMSyZAxD3s+h9GQeK4PQ6XAynB1s4hMauREq2usH5Q72vfYrJ6rxI64essZxM5L+kPp9KGL+PqAA9t6dKD8ODKT+ciJ5Y2EJfdOJ/wMZyeU6am2bs08EKaPiT2oZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sony.com; spf=pass smtp.mailfrom=sony.com; dkim=pass (2048-bit key) header.d=sony.com header.i=@sony.com header.b=BL1V1/0k; arc=none smtp.client-ip=211.125.140.164
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sony.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sony.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=sony.com; s=s1jp; t=1772091943; x=1803627943;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=PmAhxaglJ4zsFHlpniPU1qeRT9pDBq4QRgL4uv1x7B0=;
  b=BL1V1/0k7ie0QEns3iHWFd4tkRfrVCoQ7QGI/yh40m2DwH9NbxXbA38S
   pvBU2aMEUnUy4LQww46glPRJkOJG57TzDLYw5kII7iJNA5+CYftqeJevT
   w6jTQKpvUpb5mAfDJp7CvZ2Dk54vIxNWittuC1iT63IwSDJhCNpwK7olV
   4KxVmtXAIeH5iOZ3e0L11m+YhS+mj5I7OZm8Cd5GG1aWWLaFMuxvYcYlj
   wCrkqAIu5jRgBfL6oC8hVQv+Fa5FEYS83PM4NU4k0Vs9AGBLxL26a85wo
   8v/jh/P2FdMjM2Pn5IGOfcjtb5J/rRqI/6BIWLJVMnUPEwnZF17gEIaFS
   g==;
Received: from unknown (HELO jpmta-ob1.noc.sony.co.jp) ([IPv6:2001:cf8:0:6e7::6])
  by jpms-ob01.noc.sony.co.jp with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2026 16:35:33 +0900
X-IronPort-AV: E=Sophos;i="6.21,311,1763391600"; 
   d="scan'208";a="616141614"
Received: from unknown (HELO asagi..) ([43.11.56.84])
  by jpmta-ob1.noc.sony.co.jp with ESMTP; 26 Feb 2026 16:35:32 +0900
From: Yohei Kojima <yohei.kojima@sony.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Shuah Khan <shuah@kernel.org>
Cc: Yohei Kojima <yohei.kojima@sony.com>,
	Daniel Palmer <daniel.palmer@sony.com>,
	Tim Bird <tim.bird@sony.com>,
	kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] KVM: selftests: Add test case for readonly memslots on x86
Date: Thu, 26 Feb 2026 16:37:15 +0900
Message-ID: <26c1ddd4c80498bfba17ade1f9c88a04cf77779e.1772090306.git.yohei.kojima@sony.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1772090306.git.yohei.kojima@sony.com>
References: <cover.1772090306.git.yohei.kojima@sony.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[sony.com,none];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	R_DKIM_ALLOW(-0.20)[sony.com:s=s1jp];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71936-lists,kvm=lfdr.de];
	RCVD_COUNT_FIVE(0.00)[5];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[yohei.kojima@sony.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[8];
	NEURAL_HAM(-0.00)[-1.000];
	DKIM_TRACE(0.00)[sony.com:+];
	TAGGED_RCPT(0.00)[kvm];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sony.com:mid,sony.com:dkim,sony.com:email,sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: B6AA71A2019
X-Rspamd-Action: no action

Extend set_memory_region_test to verify the following properties:

* read on RO-memslot succeeds,
* execute on RO-memslot backed by executable memory succeeds, and
* write on RO-memslot fails with mmio fault.

Signed-off-by: Yohei Kojima <yohei.kojima@sony.com>
---
 .../selftests/kvm/set_memory_region_test.c    | 100 ++++++++++++++++++
 1 file changed, 100 insertions(+)

diff --git a/tools/testing/selftests/kvm/set_memory_region_test.c b/tools/testing/selftests/kvm/set_memory_region_test.c
index 8d4fd713347c..2f21bfcbc821 100644
--- a/tools/testing/selftests/kvm/set_memory_region_test.c
+++ b/tools/testing/selftests/kvm/set_memory_region_test.c
@@ -28,7 +28,10 @@
  * Somewhat arbitrary location and slot, intended to not overlap anything.
  */
 #define MEM_REGION_GPA		0xc0000000
+#define MEM_REGION_RO_GPA	0xd0000000
+
 #define MEM_REGION_SLOT		10
+#define MEM_REGION_RO_SLOT	11
 
 static const uint64_t MMIO_VAL = 0xbeefull;
 
@@ -49,6 +52,8 @@ static inline uint64_t guest_spin_on_val(uint64_t spin_val)
 	return val;
 }
 
+static int allow_mmio_fault;
+
 static void *vcpu_worker(void *data)
 {
 	struct kvm_vcpu *vcpu = data;
@@ -76,6 +81,13 @@ static void *vcpu_worker(void *data)
 		if (run->exit_reason != KVM_EXIT_MMIO)
 			break;
 
+		if (allow_mmio_fault && run->mmio.is_write)
+			/*
+			 * in this case, skip checking mmio-related assertions
+			 * and exit status
+			 */
+			return NULL;
+
 		TEST_ASSERT(!run->mmio.is_write, "Unexpected exit mmio write");
 		TEST_ASSERT(run->mmio.len == 8,
 			    "Unexpected exit mmio size = %u", run->mmio.len);
@@ -336,6 +348,92 @@ static void test_delete_memory_region(bool disable_slot_zap_quirk)
 	kvm_vm_free(vm);
 }
 
+static void guest_code_ro_memory_region(void)
+{
+	uint64_t val;
+	unsigned char c;
+	void *instruction_addr;
+
+	GUEST_SYNC(0);
+
+	val = guest_spin_on_val(0);
+	__GUEST_ASSERT(val == 1, "Expected '1', got '%lx'", val);
+
+	/* RO memory read; should succeed if the backing memory is readable */
+	c = *(unsigned char *)MEM_REGION_RO_GPA;
+	__GUEST_ASSERT(c == 0xab, "Expected '0xab', got '0x%x'", c);
+
+	/* RO memory exec; should succeed if the backing memory is executable */
+	instruction_addr = ((unsigned char *)MEM_REGION_RO_GPA) + 8;
+	val = ((uint32_t (*)(void))instruction_addr)();
+	__GUEST_ASSERT(val == 0xbeef,
+			"Expected 0xbeef, but got '%lx'", val);
+
+	/* Spin until the mmio fault is allowed for RO-memslot write */
+	val = guest_spin_on_val(1);
+	__GUEST_ASSERT(val == 2, "Expected '2', got '%lx'", val);
+
+	/* RO memory write; should fail */
+	WRITE_ONCE(*((uint64_t *)MEM_REGION_RO_GPA), 0x12);
+	__GUEST_ASSERT(0, "RO memory write is expected to fail, but it didn't");
+}
+
+/*
+ * On x86 environment, write access to the readonly memslots are trapped as
+ * a special MMIO fault. This test verifies that write access on the readonly
+ * memslot is blocked, and read/exec access isn't.
+ */
+static void test_ro_memory_region(void)
+{
+	pthread_t vcpu_thread;
+	uint64_t *hva, *hva_ro;
+	struct kvm_vcpu *vcpu;
+	struct kvm_vm *vm;
+
+	/*
+	 * Equivalent C function (assuming SysV ABI):
+	 * uint32_t some_function(void) {
+	 * 	return 0xbeef;
+	 * }
+	 */
+	unsigned char inst_bytes[] = {
+		0x48, 0xc7, 0xc0, 0xef, 0xbe, 0x00, 0x00,	// mov %eax, $0xbeef
+		0xc3,						// ret
+	};
+
+	pr_info("Testing write on RO memslot\n");
+
+	vm = spawn_vm(&vcpu, &vcpu_thread, guest_code_ro_memory_region);
+
+	vm_userspace_mem_region_add_map(vm,
+					MEM_REGION_RO_GPA,
+					MEM_REGION_RO_SLOT,
+					MEM_REGION_SIZE,
+					KVM_MEM_READONLY);
+
+	hva = addr_gpa2hva(vm, MEM_REGION_GPA);
+	hva_ro = addr_gpa2hva(vm, MEM_REGION_RO_GPA);
+
+	memset(hva_ro, 0xcccccccc, 0x2000);
+	WRITE_ONCE(*hva_ro, 0xab);
+	memcpy(((unsigned char *)hva_ro) + 8, inst_bytes, sizeof(inst_bytes));
+
+	WRITE_ONCE(*hva, 1);
+
+	/* Wait the vcpu thread to complete read/exec on ro memory */
+	usleep(100000);
+
+	allow_mmio_fault = true;
+	WRITE_ONCE(*hva, 2);
+
+	wait_for_vcpu();
+
+	pthread_join(vcpu_thread, NULL);
+
+	kvm_vm_free(vm);
+	allow_mmio_fault = false;
+}
+
 static void test_zero_memory_regions(void)
 {
 	struct kvm_vcpu *vcpu;
@@ -629,6 +727,8 @@ int main(int argc, char *argv[])
 	 */
 	test_zero_memory_regions();
 	test_mmio_during_vectoring();
+
+	test_ro_memory_region();
 #endif
 
 	test_invalid_memory_region_flags();
-- 
2.43.0


