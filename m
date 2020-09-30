Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CCD327F457
	for <lists+kvm@lfdr.de>; Wed, 30 Sep 2020 23:45:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730842AbgI3Vpj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Sep 2020 17:45:39 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:42004 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730784AbgI3Vpj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Sep 2020 17:45:39 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08ULjYQi196239;
        Wed, 30 Sep 2020 21:45:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=Q3YZwD4OpTiN7pKwlexKBeQQgCz5FiYNxW7rOEfXbdE=;
 b=s7lJD+3ysahD9N398Ujb28LHeyxM93VbKmp4NcQa/nqW15jPBkTfEeSUOL69tzKOC40Z
 ZgS+waTyy+QfZgTHjMZH6OAEb5WULoVWws3gDzsIFB73iViNwJtgCjoUENFNBvxG4Swe
 Xsvd0y193h4eZ9s5Bw7i7uroEcc7B8c0DinJf/HvQqbmpAAbSrdXFInG20ipmmsgGWFy
 jkLLFqj9i3ezjrC8gRb8NBnI1kO/Fkzp7bl0vfyzX2R1YBTFomukH2TFKXzXwWIL2m5Z
 3gpr0O3fGzU1HpnLfVeQSXrVfd1SJhOophWzjdWRMRao1hPET1OAS/Q4BzcaTbbt1IZ0 +A== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 33sx9navgx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 30 Sep 2020 21:45:34 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08ULinND165183;
        Wed, 30 Sep 2020 21:45:34 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 33tfdunhqw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 30 Sep 2020 21:45:34 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 08ULjXFm005618;
        Wed, 30 Sep 2020 21:45:33 GMT
Received: from sadhukhan-nvmx.osdevelopmeniad.oraclevcn.com (/100.100.230.226)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 30 Sep 2020 14:45:33 -0700
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com,
        sean.j.christopherson@intel.com
Subject: [PATCH 3/3 v4] nVMX: Test vmentry of unrestricted (unpaged protected) nested guest
Date:   Wed, 30 Sep 2020 21:45:16 +0000
Message-Id: <20200930214516.20926-4-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.18.4
In-Reply-To: <20200930214516.20926-1-krish.sadhukhan@oracle.com>
References: <20200930214516.20926-1-krish.sadhukhan@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9760 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=998 phishscore=0
 adultscore=0 malwarescore=0 spamscore=0 mlxscore=0 bulkscore=0
 suspectscore=1 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009300175
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9760 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=996 suspectscore=1
 phishscore=0 mlxscore=0 lowpriorityscore=0 adultscore=0 clxscore=1015
 spamscore=0 impostorscore=0 malwarescore=0 bulkscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009300175
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

According to section "UNRESTRICTED GUESTS" in SDM vol 3c, if the
"unrestricted guest" secondary VM-execution control is set, guests can run
in unpaged protected mode or in real mode. This patch tests vmetnry of an
unrestricted guest in unpaged protected mode.

Co-developed-by: Jim Mattson <jmattson@google.com>
Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
---
 x86/vmx.c       |  2 +-
 x86/vmx.h       |  1 +
 x86/vmx_tests.c | 48 ++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 50 insertions(+), 1 deletion(-)

diff --git a/x86/vmx.c b/x86/vmx.c
index 07415b4..1a84a74 100644
--- a/x86/vmx.c
+++ b/x86/vmx.c
@@ -1699,7 +1699,7 @@ static void test_vmx_caps(void)
 }
 
 /* This function can only be called in guest */
-static void __attribute__((__used__)) hypercall(u32 hypercall_no)
+void __attribute__((__used__)) hypercall(u32 hypercall_no)
 {
 	u64 val = 0;
 	val = (hypercall_no & HYPERCALL_MASK) | HYPERCALL_BIT;
diff --git a/x86/vmx.h b/x86/vmx.h
index d1c2436..e29301e 100644
--- a/x86/vmx.h
+++ b/x86/vmx.h
@@ -895,6 +895,7 @@ bool ept_ad_bits_supported(void);
 void __enter_guest(u8 abort_flag, struct vmentry_result *result);
 void enter_guest(void);
 void enter_guest_with_bad_controls(void);
+void hypercall(u32 hypercall_no);
 
 typedef void (*test_guest_func)(void);
 typedef void (*test_teardown_func)(void *data);
diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index 22f0c7b..c35d162 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -8029,6 +8029,53 @@ static void vmx_guest_state_area_test(void)
 	enter_guest();
 }
 
+extern void unrestricted_guest_main(void);
+asm (".code32\n"
+	"unrestricted_guest_main:\n"
+	"vmcall\n"
+	"nop\n"
+	"mov $1, %edi\n"
+	"call hypercall\n"
+	".code64\n");
+
+static void setup_unrestricted_guest(void)
+{
+	vmcs_write(GUEST_CR0, vmcs_read(GUEST_CR0) & ~(X86_CR0_PG));
+	vmcs_write(ENT_CONTROLS, vmcs_read(ENT_CONTROLS) & ~ENT_GUEST_64);
+	vmcs_write(GUEST_EFER, vmcs_read(GUEST_EFER) & ~EFER_LMA);
+	vmcs_write(GUEST_RIP, virt_to_phys(unrestricted_guest_main));
+}
+
+static void unsetup_unrestricted_guest(void)
+{
+	vmcs_write(GUEST_CR0, vmcs_read(GUEST_CR0) | X86_CR0_PG);
+	vmcs_write(ENT_CONTROLS, vmcs_read(ENT_CONTROLS) | ENT_GUEST_64);
+	vmcs_write(GUEST_EFER, vmcs_read(GUEST_EFER) | EFER_LMA);
+	vmcs_write(GUEST_RIP, (u64) phys_to_virt(vmcs_read(GUEST_RIP)));
+	vmcs_write(GUEST_RSP, (u64) phys_to_virt(vmcs_read(GUEST_RSP)));
+}
+
+/*
+ * If "unrestricted guest" secondary VM-execution control is set, guests
+ * can run in unpaged protected mode.
+ */
+static void vmentry_unrestricted_guest_test(void)
+{
+	test_set_guest(unrestricted_guest_main);
+	setup_unrestricted_guest();
+	if (setup_ept(false))
+		test_skip("EPT not supported");
+	vmcs_write(CPU_EXEC_CTRL1, vmcs_read(CPU_EXEC_CTRL1) | CPU_URG);
+	test_guest_state("Unrestricted guest test", false, CPU_URG, "CPU_URG");
+
+	/*
+	 * Let the guest finish execution as a regular guest
+	 */
+	unsetup_unrestricted_guest();
+	vmcs_write(CPU_EXEC_CTRL1, vmcs_read(CPU_EXEC_CTRL1) & ~CPU_URG);
+	enter_guest();
+}
+
 static bool valid_vmcs_for_vmentry(void)
 {
 	struct vmcs *current_vmcs = NULL;
@@ -10234,6 +10281,7 @@ struct vmx_test vmx_tests[] = {
 	TEST(vmx_host_state_area_test),
 	TEST(vmx_guest_state_area_test),
 	TEST(vmentry_movss_shadow_test),
+	TEST(vmentry_unrestricted_guest_test),
 	/* APICv tests */
 	TEST(vmx_eoi_bitmap_ioapic_scan_test),
 	TEST(vmx_hlt_with_rvi_test),
-- 
2.18.4

