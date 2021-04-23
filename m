Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD93B368D61
	for <lists+kvm@lfdr.de>; Fri, 23 Apr 2021 08:53:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240699AbhDWGyQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Apr 2021 02:54:16 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:32008 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236806AbhDWGyP (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 23 Apr 2021 02:54:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619160819;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=/2UnVx5VtX3OfRIVJ/IURmI0gb2kX8kbuxn/wS3RET8=;
        b=FlAjuRBv+DvHcpANQDxvvzL4yMS6oKWLM0DGZksz7OX/E6qgBwtT1WGsF3FnUr6Q+5K4DX
        EJMX/+iaK82L6sYYvGc+aeWkOPoqGt81Pl+Iuxl27qpZzhwzZMiMTMwV3sgPUtB1VG7fTd
        fG1GatrhLyr9evNmARLR0IHaU2BlYD0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-591-eJUaEOAHNMagwUnNp9SOEw-1; Fri, 23 Apr 2021 02:53:36 -0400
X-MC-Unique: eJUaEOAHNMagwUnNp9SOEw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9967E107ACE8;
        Fri, 23 Apr 2021 06:53:35 +0000 (UTC)
Received: from virtlab511.virt.lab.eng.bos.redhat.com (virtlab511.virt.lab.eng.bos.redhat.com [10.19.152.198])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 55CF8369A;
        Fri, 23 Apr 2021 06:53:35 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Krish Sadhukhan <krish.sadhukhan@oracle.com>
Subject: [PATCH kvm-unit-tests] nSVM: Test addresses of MSR and IO permissions maps
Date:   Fri, 23 Apr 2021 02:53:34 -0400
Message-Id: <20210423065334.1701680-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Krish Sadhukhan <krish.sadhukhan@oracle.com>

According to section "Canonicalization and Consistency Checks" in APM vol 2,
the following guest state is illegal:

    "The MSR or IOIO intercept tables extend to a physical address that
     is greater than or equal to the maximum supported physical address.
     The VMRUN instruction ignores the lower 12 bits of the address
     specified in the VMCB."

Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
Message-Id: <20210412215611.110095-8-krish.sadhukhan@oracle.com>
[Fix the test so that it passes when VMRUN does ignore the lower 12
 bits of the address. - Paolo]
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 x86/svm_tests.c | 79 ++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 78 insertions(+), 1 deletion(-)

diff --git a/x86/svm_tests.c b/x86/svm_tests.c
index 1c7416f..d689e73 100644
--- a/x86/svm_tests.c
+++ b/x86/svm_tests.c
@@ -2422,15 +2422,92 @@ static void test_dr(void)
 	vmcb->save.dr7 = dr_saved;
 }
 
+/* TODO: verify if high 32-bits are sign- or zero-extended on bare metal */
+#define	TEST_BITMAP_ADDR(save_intercept, type, addr, exit_code,		\
+			 msg) {						\
+	vmcb->control.intercept = saved_intercept | 1ULL << type;	\
+	if (type == INTERCEPT_MSR_PROT)					\
+		vmcb->control.msrpm_base_pa = addr;			\
+	else								\
+		vmcb->control.iopm_base_pa = addr;			\
+	report(svm_vmrun() == exit_code,				\
+	    "Test %s address: %lx", msg, addr);                         \
+}
+
+/*
+ * If the MSR or IOIO intercept table extends to a physical address that
+ * is greater than or equal to the maximum supported physical address, the
+ * guest state is illegal.
+ *
+ * The VMRUN instruction ignores the lower 12 bits of the address specified
+ * in the VMCB.
+ *
+ * MSRPM spans 2 contiguous 4KB pages while IOPM spans 2 contiguous 4KB
+ * pages + 1 byte.
+ *
+ * [APM vol 2]
+ *
+ * Note: Unallocated MSRPM addresses conforming to consistency checks, generate
+ * #NPF.
+ */
+static void test_msrpm_iopm_bitmap_addrs(void)
+{
+	u64 saved_intercept = vmcb->control.intercept;
+	u64 addr_beyond_limit = 1ull << cpuid_maxphyaddr();
+	u64 addr = virt_to_phys(msr_bitmap) & (~((1ull << 12) - 1));
+
+	TEST_BITMAP_ADDR(saved_intercept, INTERCEPT_MSR_PROT,
+			addr_beyond_limit - 3 * PAGE_SIZE, SVM_EXIT_ERR,
+			"MSRPM");
+	TEST_BITMAP_ADDR(saved_intercept, INTERCEPT_MSR_PROT,
+			addr_beyond_limit - 2 * PAGE_SIZE, SVM_EXIT_ERR,
+			"MSRPM");
+	TEST_BITMAP_ADDR(saved_intercept, INTERCEPT_MSR_PROT,
+			addr_beyond_limit - 2 * PAGE_SIZE + 1, SVM_EXIT_ERR,
+			"MSRPM");
+	TEST_BITMAP_ADDR(saved_intercept, INTERCEPT_MSR_PROT,
+			addr_beyond_limit - PAGE_SIZE, SVM_EXIT_ERR,
+			"MSRPM");
+	TEST_BITMAP_ADDR(saved_intercept, INTERCEPT_MSR_PROT, addr,
+			SVM_EXIT_VMMCALL, "MSRPM");
+	addr |= (1ull << 12) - 1;
+	TEST_BITMAP_ADDR(saved_intercept, INTERCEPT_MSR_PROT, addr,
+			SVM_EXIT_VMMCALL, "MSRPM");
+
+	TEST_BITMAP_ADDR(saved_intercept, INTERCEPT_IOIO_PROT,
+			addr_beyond_limit - 4 * PAGE_SIZE, SVM_EXIT_VMMCALL,
+			"IOPM");
+	TEST_BITMAP_ADDR(saved_intercept, INTERCEPT_IOIO_PROT,
+			addr_beyond_limit - 3 * PAGE_SIZE, SVM_EXIT_VMMCALL,
+			"IOPM");
+	TEST_BITMAP_ADDR(saved_intercept, INTERCEPT_IOIO_PROT,
+			addr_beyond_limit - 2 * PAGE_SIZE - 2, SVM_EXIT_VMMCALL,
+			"IOPM");
+	TEST_BITMAP_ADDR(saved_intercept, INTERCEPT_IOIO_PROT,
+			addr_beyond_limit - 2 * PAGE_SIZE, SVM_EXIT_ERR,
+			"IOPM");
+	TEST_BITMAP_ADDR(saved_intercept, INTERCEPT_IOIO_PROT,
+			addr_beyond_limit - PAGE_SIZE, SVM_EXIT_ERR,
+			"IOPM");
+	addr = virt_to_phys(io_bitmap) & (~((1ull << 11) - 1));
+	TEST_BITMAP_ADDR(saved_intercept, INTERCEPT_IOIO_PROT, addr,
+			SVM_EXIT_VMMCALL, "IOPM");
+	addr |= (1ull << 12) - 1;
+	TEST_BITMAP_ADDR(saved_intercept, INTERCEPT_IOIO_PROT, addr,
+			SVM_EXIT_VMMCALL, "IOPM");
+
+	vmcb->control.intercept = saved_intercept;
+}
+
 static void svm_guest_state_test(void)
 {
 	test_set_guest(basic_guest_main);
-
 	test_efer();
 	test_cr0();
 	test_cr3();
 	test_cr4();
 	test_dr();
+	test_msrpm_iopm_bitmap_addrs();
 }
 
 
-- 
2.26.2

