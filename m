Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF3963DB88F
	for <lists+kvm@lfdr.de>; Fri, 30 Jul 2021 14:26:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238822AbhG3M0y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Jul 2021 08:26:54 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:50143 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238838AbhG3M0w (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 30 Jul 2021 08:26:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1627648007;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FMYzHnNd772jovT/0UPowsD8iExQ4yvLWYcwXjSPrGo=;
        b=H4yHErLgahtOJLUyi4vnxXGvBgtfpu5b8r/seHOzdAnRqQ26iPEBdLIDyPS7iYw70x3o2p
        yl8EsRqLP4rqF7XSk6RCoaKOwV/rSn60bwrcOXfDF7rvbvlALjM0YFTdKDHipJf2lLetYV
        J3jmSO/IWd01NrosVTcSxdsfLh/HzqY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-471-tG266UC4NRmq0h1QijsrGg-1; Fri, 30 Jul 2021 08:26:46 -0400
X-MC-Unique: tG266UC4NRmq0h1QijsrGg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A8B2810066E6;
        Fri, 30 Jul 2021 12:26:44 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.194.154])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9787718C7A;
        Fri, 30 Jul 2021 12:26:42 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] KVM: selftests: Test access to XMM fast hypercalls
Date:   Fri, 30 Jul 2021 14:26:25 +0200
Message-Id: <20210730122625.112848-5-vkuznets@redhat.com>
In-Reply-To: <20210730122625.112848-1-vkuznets@redhat.com>
References: <20210730122625.112848-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

HYPERV_CPUID_FEATURES.EDX and an 'XMM fast' hypercall is issued.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 .../selftests/kvm/include/x86_64/hyperv.h     |  5 ++-
 .../selftests/kvm/x86_64/hyperv_features.c    | 41 +++++++++++++++++--
 2 files changed, 42 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/x86_64/hyperv.h b/tools/testing/selftests/kvm/include/x86_64/hyperv.h
index 412eaee7884a..b66910702c0a 100644
--- a/tools/testing/selftests/kvm/include/x86_64/hyperv.h
+++ b/tools/testing/selftests/kvm/include/x86_64/hyperv.h
@@ -117,7 +117,7 @@
 #define HV_X64_GUEST_DEBUGGING_AVAILABLE		BIT(1)
 #define HV_X64_PERF_MONITOR_AVAILABLE			BIT(2)
 #define HV_X64_CPU_DYNAMIC_PARTITIONING_AVAILABLE	BIT(3)
-#define HV_X64_HYPERCALL_PARAMS_XMM_AVAILABLE		BIT(4)
+#define HV_X64_HYPERCALL_XMM_INPUT_AVAILABLE		BIT(4)
 #define HV_X64_GUEST_IDLE_STATE_AVAILABLE		BIT(5)
 #define HV_FEATURE_FREQUENCY_MSRS_AVAILABLE		BIT(8)
 #define HV_FEATURE_GUEST_CRASH_MSR_AVAILABLE		BIT(10)
@@ -182,4 +182,7 @@
 #define HV_STATUS_INVALID_CONNECTION_ID		18
 #define HV_STATUS_INSUFFICIENT_BUFFERS		19
 
+/* hypercall options */
+#define HV_HYPERCALL_FAST_BIT		BIT(16)
+
 #endif /* !SELFTEST_KVM_HYPERV_H */
diff --git a/tools/testing/selftests/kvm/x86_64/hyperv_features.c b/tools/testing/selftests/kvm/x86_64/hyperv_features.c
index af27c7e829c1..91d88aaa9899 100644
--- a/tools/testing/selftests/kvm/x86_64/hyperv_features.c
+++ b/tools/testing/selftests/kvm/x86_64/hyperv_features.c
@@ -47,6 +47,7 @@ static void do_wrmsr(u32 idx, u64 val)
 }
 
 static int nr_gp;
+static int nr_ud;
 
 static inline u64 hypercall(u64 control, vm_vaddr_t input_address,
 			    vm_vaddr_t output_address)
@@ -80,6 +81,12 @@ static void guest_gp_handler(struct ex_regs *regs)
 		regs->rip = (uint64_t)&wrmsr_end;
 }
 
+static void guest_ud_handler(struct ex_regs *regs)
+{
+	nr_ud++;
+	regs->rip += 3;
+}
+
 struct msr_data {
 	uint32_t idx;
 	bool available;
@@ -90,6 +97,7 @@ struct msr_data {
 struct hcall_data {
 	uint64_t control;
 	uint64_t expect;
+	bool ud_expected;
 };
 
 static void guest_msr(struct msr_data *msr)
@@ -117,13 +125,26 @@ static void guest_msr(struct msr_data *msr)
 static void guest_hcall(vm_vaddr_t pgs_gpa, struct hcall_data *hcall)
 {
 	int i = 0;
+	u64 res, input, output;
 
 	wrmsr(HV_X64_MSR_GUEST_OS_ID, LINUX_OS_ID);
 	wrmsr(HV_X64_MSR_HYPERCALL, pgs_gpa);
 
 	while (hcall->control) {
-		GUEST_ASSERT(hypercall(hcall->control, pgs_gpa,
-				       pgs_gpa + 4096) == hcall->expect);
+		nr_ud = 0;
+		if (!(hcall->control & HV_HYPERCALL_FAST_BIT)) {
+			input = pgs_gpa;
+			output = pgs_gpa + 4096;
+		} else {
+			input = output = 0;
+		}
+
+		res = hypercall(hcall->control, input, output);
+		if (hcall->ud_expected)
+			GUEST_ASSERT(nr_ud == 1);
+		else
+			GUEST_ASSERT(res == hcall->expect);
+
 		GUEST_SYNC(i++);
 	}
 
@@ -552,8 +573,18 @@ static void guest_test_hcalls_access(struct kvm_vm *vm, struct hcall_data *hcall
 			recomm.ebx = 0xfff;
 			hcall->expect = HV_STATUS_SUCCESS;
 			break;
-
 		case 17:
+			/* XMM fast hypercall */
+			hcall->control = HVCALL_FLUSH_VIRTUAL_ADDRESS_SPACE | HV_HYPERCALL_FAST_BIT;
+			hcall->ud_expected = true;
+			break;
+		case 18:
+			feat.edx |= HV_X64_HYPERCALL_XMM_INPUT_AVAILABLE;
+			hcall->ud_expected = false;
+			hcall->expect = HV_STATUS_SUCCESS;
+			break;
+
+		case 19:
 			/* END */
 			hcall->control = 0;
 			break;
@@ -625,6 +656,10 @@ int main(void)
 	/* Test hypercalls */
 	vm = vm_create_default(VCPU_ID, 0, guest_hcall);
 
+	vm_init_descriptor_tables(vm);
+	vcpu_init_descriptor_tables(vm, VCPU_ID);
+	vm_install_exception_handler(vm, UD_VECTOR, guest_ud_handler);
+
 	/* Hypercall input/output */
 	hcall_page = vm_vaddr_alloc_pages(vm, 2);
 	memset(addr_gva2hva(vm, hcall_page), 0x0, 2 * getpagesize());
-- 
2.31.1

