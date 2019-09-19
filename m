Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B872B79CE
	for <lists+kvm@lfdr.de>; Thu, 19 Sep 2019 14:53:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390401AbfISMxI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Sep 2019 08:53:08 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:46892 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390402AbfISMxI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Sep 2019 08:53:08 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8JCnMsc150959;
        Thu, 19 Sep 2019 12:52:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2019-08-05;
 bh=BfbFOQhgQVFIXytUGWPysZKJ8YzqdrO8dYA/S6OR3VM=;
 b=dv0knNVI+aeDZNob1dbXZaW0qSZ0k4Eu0AJ9oFdLSRQEOOU/+A9XFEekOFCKmjwYDuW6
 DZwHj3DRxWYGVrv1L8utBgS7d07LheT9UYvxFckmfa5br19IdthzYNqhONGEUCAdRX8Y
 hCz0WRssg3KdJ4+hpqkhxNL8vs+C2uL4t9FKac7GCWl6bqf4Iy2nm/qsBJawMI4YH6CZ
 EyezjJrtjzhNUk1gT07akHwxDpbzNbzxIExwyxysBWig8LfHmI3ZwSDGduSJhq4fryNU
 LOYHrVXl0L/ey/o/bxLMLRtttzMdIIvCoT5ZTw0O9byjv0WjM6eo2fs8OzSwrNY0BBOs 0g== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2v3vb4kpwf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 19 Sep 2019 12:52:49 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8JCn0wL155679;
        Thu, 19 Sep 2019 12:52:48 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 2v3vbac3a7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 19 Sep 2019 12:52:48 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x8JCqltd012419;
        Thu, 19 Sep 2019 12:52:47 GMT
Received: from spark.ravello.local (/213.57.127.2)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 19 Sep 2019 05:52:47 -0700
From:   Liran Alon <liran.alon@oracle.com>
To:     pbonzini@redhat.com, rkrcmar@redhat.com, kvm@vger.kernel.org
Cc:     sean.j.christopherson@intel.com, jmattson@google.com,
        vkuznets@redhat.com, Liran Alon <liran.alon@oracle.com>,
        Nikita Leshenko <nikita.leshchenko@oracle.com>,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>
Subject: [PATCH kvm-unit-tests 8/8] x86: vmx: Test INIT processing during various CPU VMX states
Date:   Thu, 19 Sep 2019 15:52:11 +0300
Message-Id: <20190919125211.18152-9-liran.alon@oracle.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190919125211.18152-1-liran.alon@oracle.com>
References: <20190919125211.18152-1-liran.alon@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9384 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1909190121
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9384 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1909190121
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add vmx test to verify the functionality introduced by KVM commit:
4b9852f4f389 ("KVM: x86: Fix INIT signal handling in various CPU states").

The test verifies the following functionality:
1) An INIT signal received when CPU is in VMX operation
   is blocked until it exits VMX operation.
2) If there is an INIT signal pending when CPU is in
   VMX non-root mode, it result in VMExit with (reason == 3).
3) Exit from VMX non-root mode on VMExit do not clear
   pending INIT signal in LAPIC.
4) When CPU exits VMX operation, pending INIT signal in
   LAPIC is processed.

Note: The test is excluded from the "vmx" test-suite as
it ruins the execution environment of CPU1 because
during the test it process an INIT signal.

Reviewed-by: Nikita Leshenko <nikita.leshchenko@oracle.com>
Reviewed-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
Signed-off-by: Liran Alon <liran.alon@oracle.com>
---
 x86/unittests.cfg |  10 +++-
 x86/vmx_tests.c   | 145 ++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 154 insertions(+), 1 deletion(-)

diff --git a/x86/unittests.cfg b/x86/unittests.cfg
index 694ee3d42f3a..8156256146c3 100644
--- a/x86/unittests.cfg
+++ b/x86/unittests.cfg
@@ -227,7 +227,7 @@ extra_params = -cpu qemu64,+umip
 
 [vmx]
 file = vmx.flat
-extra_params = -cpu host,+vmx -append "-exit_monitor_from_l2_test -ept_access* -vmx_smp* -vmx_vmcs_shadow_test"
+extra_params = -cpu host,+vmx -append "-exit_monitor_from_l2_test -ept_access* -vmx_smp* -vmx_vmcs_shadow_test -vmx_init_signal_test"
 arch = x86_64
 groups = vmx
 
@@ -265,6 +265,14 @@ extra_params = -cpu host,+vmx -m 2048 -append vmx_apic_passthrough_thread_test
 arch = x86_64
 groups = vmx
 
+[vmx_init_signal_test]
+file = vmx.flat
+smp = 2
+extra_params = -cpu host,+vmx -m 2048 -append vmx_init_signal_test
+arch = x86_64
+groups = vmx
+timeout = 10
+
 [vmx_vmcs_shadow_test]
 file = vmx.flat
 extra_params = -cpu host,+vmx -append vmx_vmcs_shadow_test
diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index 096640a56891..962990e30d33 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -8219,6 +8219,150 @@ static void vmx_apic_passthrough_thread_test(void)
 	vmx_apic_passthrough(true);
 }
 
+static u64 init_signal_test_exit_reason;
+static bool init_signal_test_thread_continued;
+
+static void init_signal_test_thread(void *data)
+{
+	struct vmcs *test_vmcs = data;
+
+	/* Enter VMX operation (i.e. exec VMXON) */
+	u64 *ap_vmxon_region = alloc_page();
+	enable_vmx();
+	init_vmx(ap_vmxon_region);
+	_vmx_on(ap_vmxon_region);
+
+	/* Signal CPU have entered VMX operation */
+	vmx_set_test_stage(1);
+
+	/* Wait for BSP CPU to send INIT signal */
+	while (vmx_get_test_stage() != 2)
+		;
+
+	/*
+	 * Signal that we continue as usual as INIT signal
+	 * should be blocked while CPU is in VMX operation
+	 */
+	vmx_set_test_stage(3);
+
+	/* Wait for signal to enter VMX non-root mode */
+	while (vmx_get_test_stage() != 4)
+		;
+
+	/* Enter VMX non-root mode */
+	test_set_guest(v2_null_test_guest);
+	make_vmcs_current(test_vmcs);
+	enter_guest();
+	/* Save exit reason for BSP CPU to compare to expected result */
+	init_signal_test_exit_reason = vmcs_read(EXI_REASON);
+	/* VMCLEAR test-vmcs so it could be loaded by BSP CPU */
+	vmcs_clear(test_vmcs);
+	launched = false;
+	/* Signal that CPU exited to VMX root mode */
+	vmx_set_test_stage(5);
+
+	/* Wait for signal to exit VMX operation */
+	while (vmx_get_test_stage() != 6)
+		;
+
+	/* Exit VMX operation (i.e. exec VMXOFF) */
+	vmx_off();
+
+	/*
+	 * Exiting VMX operation should result in latched
+	 * INIT signal being processed. Therefore, we should
+	 * never reach the below code. Thus, signal to BSP
+	 * CPU if we have reached here so it is able to
+	 * report an issue if it happens.
+	 */
+	init_signal_test_thread_continued = true;
+}
+
+#define INIT_SIGNAL_TEST_DELAY	100000000ULL
+
+static void vmx_init_signal_test(void)
+{
+	struct vmcs *test_vmcs;
+
+	if (cpu_count() < 2) {
+		report_skip(__func__);
+		return;
+	}
+
+	/* VMCLEAR test-vmcs so it could be loaded by other CPU */
+	vmcs_save(&test_vmcs);
+	vmcs_clear(test_vmcs);
+
+	vmx_set_test_stage(0);
+	on_cpu_async(1, init_signal_test_thread, test_vmcs);
+
+	/* Wait for other CPU to enter VMX operation */
+	while (vmx_get_test_stage() != 1)
+		;
+
+	/* Send INIT signal to other CPU */
+	apic_icr_write(APIC_DEST_PHYSICAL | APIC_DM_INIT | APIC_INT_ASSERT,
+				   id_map[1]);
+	/* Signal other CPU we have sent INIT signal */
+	vmx_set_test_stage(2);
+
+	/*
+	 * Wait reasonable amount of time for INIT signal to
+	 * be received on other CPU and verify that other CPU
+	 * have proceed as usual to next test stage as INIT
+	 * signal should be blocked while other CPU in
+	 * VMX operation
+	 */
+	delay(INIT_SIGNAL_TEST_DELAY);
+	report("INIT signal blocked when CPU in VMX operation",
+		   vmx_get_test_stage() == 3);
+	/* No point to continue if we failed at this point */
+	if (vmx_get_test_stage() != 3)
+		return;
+
+	/* Signal other CPU to enter VMX non-root mode */
+	init_signal_test_exit_reason = -1ull;
+	vmx_set_test_stage(4);
+	/*
+	 * Wait reasonable amont of time for other CPU
+	 * to exit to VMX root mode
+	 */
+	delay(INIT_SIGNAL_TEST_DELAY);
+	if (vmx_get_test_stage() != 5) {
+		report("Pending INIT signal haven't resulted in VMX exit", false);
+		return;
+	}
+	report("INIT signal during VMX non-root mode result in exit-reason %s (%lu)",
+			init_signal_test_exit_reason == VMX_INIT,
+			exit_reason_description(init_signal_test_exit_reason),
+			init_signal_test_exit_reason);
+
+	/* Run guest to completion */
+	make_vmcs_current(test_vmcs);
+	enter_guest();
+
+	/* Signal other CPU to exit VMX operation */
+	init_signal_test_thread_continued = false;
+	vmx_set_test_stage(6);
+
+	/*
+	 * Wait reasonable amount of time for other CPU
+	 * to run after INIT signal was processed
+	 */
+	delay(INIT_SIGNAL_TEST_DELAY);
+	report("INIT signal processed after exit VMX operation",
+		   !init_signal_test_thread_continued);
+
+	/*
+	 * TODO: Send SIPI to other CPU to sipi_entry (See x86/cstart64.S)
+	 * to re-init it to kvm-unit-tests standard environment.
+	 * Somehow (?) verify that SIPI was indeed received.
+	 */
+
+	/* Report success */
+	report(__func__, 1);
+}
+
 enum vmcs_access {
 	ACCESS_VMREAD,
 	ACCESS_VMWRITE,
@@ -8629,6 +8773,7 @@ struct vmx_test vmx_tests[] = {
 	/* APIC pass-through tests */
 	TEST(vmx_apic_passthrough_test),
 	TEST(vmx_apic_passthrough_thread_test),
+	TEST(vmx_init_signal_test),
 	/* VMCS Shadowing tests */
 	TEST(vmx_vmcs_shadow_test),
 	/* Regression tests */
-- 
2.20.1

