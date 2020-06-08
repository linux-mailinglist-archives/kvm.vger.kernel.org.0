Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E2FF1F18BA
	for <lists+kvm@lfdr.de>; Mon,  8 Jun 2020 14:28:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729753AbgFHM2O (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Jun 2020 08:28:14 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:44998 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729668AbgFHM2M (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Jun 2020 08:28:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591619290;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=t1ZQ22N4GS1aOVvRJb6q+OxNNqR941WJ3Ue4dl0p7rw=;
        b=VLGGDM4ORtDVTA6AG1/XrP0t+Lc00UvHWnBQNnEFVnp+c5Gj3KnLxsgBPuEZNC3boKGQL8
        xb7/3q+JhxghQ5G+Esh2nNicEdk7s64N4uz5IqrvaX5W4h70BZAGoTrQkOqzgEL6AfEedX
        bHQ10Z7Oqc13cgsaT5xvufVhea5mYiU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-286-fonlKfq2PLiCRa6Xci7Qkg-1; Mon, 08 Jun 2020 08:28:04 -0400
X-MC-Unique: fonlKfq2PLiCRa6Xci7Qkg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 51AC6108BD0A;
        Mon,  8 Jun 2020 12:28:03 +0000 (UTC)
Received: from virtlab710.virt.lab.eng.bos.redhat.com (virtlab710.virt.lab.eng.bos.redhat.com [10.19.152.252])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A4822768BB;
        Mon,  8 Jun 2020 12:28:02 +0000 (UTC)
From:   Cathy Avery <cavery@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        pbonzini@redhat.com
Subject: [PATCH kvm-unit-tests 1/2] svm: Add ability to execute test via test_run on a vcpu other than vcpu 0
Date:   Mon,  8 Jun 2020 08:27:59 -0400
Message-Id: <20200608122800.6315-2-cavery@redhat.com>
In-Reply-To: <20200608122800.6315-1-cavery@redhat.com>
References: <20200608122800.6315-1-cavery@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
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
 x86/svm.c | 49 ++++++++++++++++++++++++++++++++++++++++++++++++-
 x86/svm.h | 13 +++++++++++++
 2 files changed, 61 insertions(+), 1 deletion(-)

diff --git a/x86/svm.c b/x86/svm.c
index 41685bf..9f7ae7e 100644
--- a/x86/svm.c
+++ b/x86/svm.c
@@ -367,6 +367,45 @@ test_wanted(const char *name, char *filters[], int filter_count)
         }
 }
 
+static void set_additional_vpcu_regs(struct extra_vcpu_info *info)
+{
+    wrmsr(MSR_VM_HSAVE_PA, info->hsave);
+    wrmsr(MSR_EFER, rdmsr(MSR_EFER) | EFER_SVME);
+    wrmsr(MSR_EFER, rdmsr(MSR_EFER) | EFER_NX);
+    write_cr3(info->cr3);
+    write_cr4(info->cr4);
+    write_cr0(info->cr0);
+    write_dr6(info->dr6);
+    write_dr7(info->dr7);
+    write_cr2(info->cr2);
+    wrmsr(MSR_IA32_CR_PAT, info->g_pat);
+    wrmsr(MSR_IA32_DEBUGCTLMSR, info->dbgctl);
+}
+
+static void get_additional_vcpu_regs(struct extra_vcpu_info *info)
+{
+    info->hsave = rdmsr(MSR_VM_HSAVE_PA);
+    info->cr3 = read_cr3();
+    info->cr4 = read_cr4();
+    info->cr0 = read_cr0();
+    info->dr7 = read_dr7();
+    info->dr6 = read_dr6();
+    info->cr2 = read_cr2();
+    info->g_pat = rdmsr(MSR_IA32_CR_PAT);
+    info->dbgctl = rdmsr(MSR_IA32_DEBUGCTLMSR);
+}
+
+static void init_additional_vcpu_regs(void)
+{
+    int i;
+    struct extra_vcpu_info info;
+
+    get_additional_vcpu_regs(&info);
+
+    for (i = 1; i < cpu_count(); i++)
+        on_cpu(i, (void *)set_additional_vpcu_regs, &info);
+}
+
 int main(int ac, char **av)
 {
 	int i = 0;
@@ -384,6 +423,8 @@ int main(int ac, char **av)
 
 	setup_svm();
 
+        init_additional_vcpu_regs();
+
 	vmcb = alloc_page();
 
 	for (; svm_tests[i].name != NULL; i++) {
@@ -392,7 +433,13 @@ int main(int ac, char **av)
 		if (svm_tests[i].supported && !svm_tests[i].supported())
 			continue;
 		if (svm_tests[i].v2 == NULL) {
-			test_run(&svm_tests[i]);
+			if (svm_tests[i].on_vcpu) {
+				if (cpu_count() <= svm_tests[i].on_vcpu)
+					continue;
+				on_cpu(svm_tests[i].on_vcpu, (void *)test_run, &svm_tests[i]);
+			}
+			else
+				test_run(&svm_tests[i]);
 		} else {
 			vmcb_ident(vmcb);
 			v2_test = &(svm_tests[i]);
diff --git a/x86/svm.h b/x86/svm.h
index 645deb7..d023a32 100644
--- a/x86/svm.h
+++ b/x86/svm.h
@@ -338,6 +338,7 @@ struct svm_test {
 	ulong scratch;
 	/* Alternative test interface. */
 	void (*v2)(void);
+	int on_vcpu;
 };
 
 struct regs {
@@ -360,6 +361,18 @@ struct regs {
 	u64 rflags;
 };
 
+struct extra_vcpu_info {
+	u64 hsave;
+	u64 cr3;
+	u64 cr4;
+	u64 cr0;
+	u64 dr7;
+	u64 dr6;
+	u64 cr2;
+	u64 g_pat;
+	u64 dbgctl;
+};
+
 typedef void (*test_guest_func)(struct svm_test *);
 
 u64 *npt_get_pte(u64 address);
-- 
2.20.1

