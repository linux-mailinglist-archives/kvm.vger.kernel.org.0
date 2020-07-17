Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFCCB223A99
	for <lists+kvm@lfdr.de>; Fri, 17 Jul 2020 13:34:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726619AbgGQLeb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Jul 2020 07:34:31 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:58562 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726198AbgGQLe3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Jul 2020 07:34:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594985667;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ql4tis1uscIP3qLeTRHhYQZodhivUb4DYruBJ6jvbTs=;
        b=HHA7xNGEVq9SjOGjTBRVGNgmMpFzH4Oa0ChAv58aLYgjXOwiXBa6sr0o7gwuxn56K57H9e
        TJ0XBBqacll4wMwjLt+AeJEqG/1kOQZwbFFcIvZrJyhDLRuawZ96m/3CKcR/iLEuiU2ghz
        2j/cjOdkO40L9CAZq8AWOQaCIhdiD2A=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-412-0O2DYWcYPQe54AGqXQ7A5g-1; Fri, 17 Jul 2020 07:34:26 -0400
X-MC-Unique: 0O2DYWcYPQe54AGqXQ7A5g-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A1157100A8E8;
        Fri, 17 Jul 2020 11:34:23 +0000 (UTC)
Received: from virtlab710.virt.lab.eng.bos.redhat.com (virtlab710.virt.lab.eng.bos.redhat.com [10.19.152.252])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2CD0619C58;
        Fri, 17 Jul 2020 11:34:23 +0000 (UTC)
From:   Cathy Avery <cavery@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        pbonzini@redhat.com
Subject: [PATCH kvm-unit-tests v2 1/3] svm: Add ability to execute test via test_run on a vcpu other than vcpu 0
Date:   Fri, 17 Jul 2020 07:34:20 -0400
Message-Id: <20200717113422.19575-2-cavery@redhat.com>
In-Reply-To: <20200717113422.19575-1-cavery@redhat.com>
References: <20200717113422.19575-1-cavery@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When running tests that can result in a vcpu being left in an
indeterminate state it is useful to be able to run the test on
a vcpu other than 0. This patch allows test_run to be executed
on any vcpu indicated by the on_vcpu member of the svm_test struct.
The initialized state of the vcpu0 registers used to populate the
vmcb is carried forward to the other vcpus.

Signed-off-by: Cathy Avery <cavery@redhat.com>
---
 lib/x86/vm.c | 18 ++++++++++++++++++
 lib/x86/vm.h |  7 +++++++
 x86/svm.c    | 24 +++++++++++++++++++++++-
 x86/svm.h    |  2 ++
 4 files changed, 50 insertions(+), 1 deletion(-)

diff --git a/lib/x86/vm.c b/lib/x86/vm.c
index 41d6d96..e223bb4 100644
--- a/lib/x86/vm.c
+++ b/lib/x86/vm.c
@@ -2,6 +2,7 @@
 #include "libcflat.h"
 #include "vmalloc.h"
 #include "alloc_page.h"
+#include "smp.h"
 
 pteval_t *install_pte(pgd_t *cr3,
 		      int pte_level,
@@ -139,9 +140,18 @@ static void setup_mmu_range(pgd_t *cr3, phys_addr_t start, size_t len)
 	install_pages(cr3, phys, max - phys, (void *)(ulong)phys);
 }
 
+static void set_additional_vcpu_vmregs(struct vm_vcpu_info *info)
+{
+	write_cr3(info->cr3);
+	write_cr4(info->cr4);
+	write_cr0(info->cr0);
+}
+
 void *setup_mmu(phys_addr_t end_of_memory)
 {
     pgd_t *cr3 = alloc_page();
+    struct vm_vcpu_info info;
+    int i;
 
     memset(cr3, 0, PAGE_SIZE);
 
@@ -166,6 +176,14 @@ void *setup_mmu(phys_addr_t end_of_memory)
     printf("cr0 = %lx\n", read_cr0());
     printf("cr3 = %lx\n", read_cr3());
     printf("cr4 = %lx\n", read_cr4());
+
+    info.cr3 = read_cr3();
+    info.cr4 = read_cr4();
+    info.cr0 = read_cr0();
+
+    for (i = 1; i < cpu_count(); i++)
+        on_cpu(i, (void *)set_additional_vcpu_vmregs, &info);
+
     return cr3;
 }
 
diff --git a/lib/x86/vm.h b/lib/x86/vm.h
index 8750a1e..3a1432f 100644
--- a/lib/x86/vm.h
+++ b/lib/x86/vm.h
@@ -45,4 +45,11 @@ static inline void *current_page_table(void)
 
 void split_large_page(unsigned long *ptep, int level);
 void force_4k_page(void *addr);
+
+struct vm_vcpu_info {
+        u64 cr3;
+        u64 cr4;
+        u64 cr0;
+};
+
 #endif
diff --git a/x86/svm.c b/x86/svm.c
index d8c8272..975c477 100644
--- a/x86/svm.c
+++ b/x86/svm.c
@@ -275,6 +275,17 @@ static void test_run(struct svm_test *test)
 	irq_enable();
 
 	report(test->succeeded(test), "%s", test->name);
+
+        if (test->on_vcpu)
+	    test->on_vcpu_done = true;
+}
+
+static void set_additional_vpcu_msr(void *msr_efer)
+{
+	void *hsave = alloc_page();
+
+	wrmsr(MSR_VM_HSAVE_PA, virt_to_phys(hsave));
+	wrmsr(MSR_EFER, (ulong)msr_efer | EFER_SVME | EFER_NX);
 }
 
 static void setup_svm(void)
@@ -294,6 +305,9 @@ static void setup_svm(void)
 	if (!npt_supported())
 		return;
 
+	for (i = 1; i < cpu_count(); i++)
+		on_cpu(i, (void *)set_additional_vpcu_msr, (void *)rdmsr(MSR_EFER));
+
 	printf("NPT detected - running all tests with NPT enabled\n");
 
 	/*
@@ -396,7 +410,15 @@ int main(int ac, char **av)
 		if (svm_tests[i].supported && !svm_tests[i].supported())
 			continue;
 		if (svm_tests[i].v2 == NULL) {
-			test_run(&svm_tests[i]);
+			if (svm_tests[i].on_vcpu) {
+				if (cpu_count() <= svm_tests[i].on_vcpu)
+					continue;
+				on_cpu_async(svm_tests[i].on_vcpu, (void *)test_run, &svm_tests[i]);
+				while (!svm_tests[i].on_vcpu_done)
+					cpu_relax();
+			}
+			else
+				test_run(&svm_tests[i]);
 		} else {
 			vmcb_ident(vmcb);
 			v2_test = &(svm_tests[i]);
diff --git a/x86/svm.h b/x86/svm.h
index f8e7429..1e60d52 100644
--- a/x86/svm.h
+++ b/x86/svm.h
@@ -348,6 +348,8 @@ struct svm_test {
 	ulong scratch;
 	/* Alternative test interface. */
 	void (*v2)(void);
+	int on_vcpu;
+	bool on_vcpu_done;
 };
 
 struct regs {
-- 
2.20.1

