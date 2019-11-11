Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2437EF7426
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2019 13:37:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726834AbfKKMht (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Nov 2019 07:37:49 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:52528 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726810AbfKKMht (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Nov 2019 07:37:49 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xABCXsab036981;
        Mon, 11 Nov 2019 12:37:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding;
 s=corp-2019-08-05; bh=A/h2k5pYXiiPYsO4+8nBEWU9QH45SNQYUUhYsaX3vTc=;
 b=WgPY+vHQcc5CLbM/z3bPEdrmme9JjhinVfwCWb9IbNp5nhf1TiY5JdWEO/CF3v/F1L0v
 2hcy1LduioKaG3BZiqnwMqMMQEry3vF7+hcJH8XWdQPDx6VpvYhdAMO6VG2Ef5zrBkM6
 ij3lC01aVy5QAWa4CoXS4mQa52IqwXFgvLSMdS09B5DMyqUN3htCfJKbY5hgX19UkSA1
 /f223V9y/rOM8wARYNXXD8NFv8bnkGjH6EFW9AuwEfo7W13SqIpzeIfcPHNk3TMl0BYT
 GRn+aZJThAGPDFKMrcR9DNCw6WFqnI58Awt4GkrPT55TpFQjZ00vXht09yUml7xH70qZ AQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2w5mvtetp7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 11 Nov 2019 12:37:42 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xABCXe9x026203;
        Mon, 11 Nov 2019 12:37:41 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2w66yx989y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 11 Nov 2019 12:37:41 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xABCbejE010714;
        Mon, 11 Nov 2019 12:37:40 GMT
Received: from Lirans-MBP.Home (/79.182.207.213)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 11 Nov 2019 12:37:40 +0000
From:   Liran Alon <liran.alon@oracle.com>
To:     pbonzini@redhat.com, rkrcmar@redhat.com, kvm@vger.kernel.org
Cc:     sean.j.christopherson@intel.com, jmattson@google.com,
        vkuznets@redhat.com, Liran Alon <liran.alon@oracle.com>,
        Joao Martins <joao.m.martins@oracle.com>
Subject: [PATCH] x86: vmx: Verify L2 modification to L1 LAPIC TPR works when L0 use TPR threshold
Date:   Mon, 11 Nov 2019 14:37:26 +0200
Message-Id: <20191111123726.93391-1-liran.alon@oracle.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9437 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=794
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1910280000 definitions=main-1911110120
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9437 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=866 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1910280000
 definitions=main-1911110120
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Test aims to verify that the issue fixed by commit ("KVM: nVMX: Update
vmcs01 TPR_THRESHOLD if L2 changed L1 TPR") is indeed fixed.

Test performs the following steps:
1) Disable interrupts.
2) Raise TPR to high value and queue a pending interrupt in LAPIC by
issueing a self-IPI with lower priority.
3) Launch guest such that it is provided with passthrough access to
LAPIC.
4) Inside guest, disable interrupts and lower TPR to 0 and then exit guest.
5) Back on host, verify that indeed TPR was set to 0 and that enabling
interrupts indeed deliever pending interrupt in LAPIC.

Without above mentioned commit in L0, step (2) will cause L0 to raise
TPR-threshold to self-IPI vector priority and step (4) will *not* change
vmcs01 TPR-threshold to 0. This will result in infinite loop of VMExits
on TPR_BELOW_THRESHOLD every time L0 attempts to enter L1. Which will
cause test to hang and eventually fail on timeout.

Reviewed-by: Joao Martins <joao.m.martins@oracle.com>
Signed-off-by: Liran Alon <liran.alon@oracle.com>
---
 x86/unittests.cfg |  9 ++++++++-
 x86/vmx_tests.c   | 43 +++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 51 insertions(+), 1 deletion(-)

diff --git a/x86/unittests.cfg b/x86/unittests.cfg
index 5ecb9bba535b..fd3197455aa6 100644
--- a/x86/unittests.cfg
+++ b/x86/unittests.cfg
@@ -232,7 +232,7 @@ extra_params = -cpu qemu64,+umip
 
 [vmx]
 file = vmx.flat
-extra_params = -cpu host,+vmx -append "-exit_monitor_from_l2_test -ept_access* -vmx_smp* -vmx_vmcs_shadow_test -atomic_switch_overflow_msrs_test -vmx_init_signal_test"
+extra_params = -cpu host,+vmx -append "-exit_monitor_from_l2_test -ept_access* -vmx_smp* -vmx_vmcs_shadow_test -atomic_switch_overflow_msrs_test -vmx_init_signal_test -vmx_apic_passthrough_tpr_threshold_test"
 arch = x86_64
 groups = vmx
 
@@ -278,6 +278,13 @@ arch = x86_64
 groups = vmx
 timeout = 10
 
+[vmx_apic_passthrough_tpr_threshold_test]
+file = vmx.flat
+extra_params = -cpu host,+vmx -m 2048 -append vmx_apic_passthrough_tpr_threshold_test
+arch = x86_64
+groups = vmx
+timeout = 10
+
 [vmx_vmcs_shadow_test]
 file = vmx.flat
 extra_params = -cpu host,+vmx -append vmx_vmcs_shadow_test
diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index 4aebc3fe1ff9..b137fc5456b8 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -8343,6 +8343,48 @@ static void vmx_apic_passthrough_thread_test(void)
 	vmx_apic_passthrough(true);
 }
 
+static void vmx_apic_passthrough_tpr_threshold_guest(void)
+{
+	cli();
+	apic_set_tpr(0);
+}
+
+static bool vmx_apic_passthrough_tpr_threshold_ipi_isr_fired;
+static void vmx_apic_passthrough_tpr_threshold_ipi_isr(isr_regs_t *regs)
+{
+	vmx_apic_passthrough_tpr_threshold_ipi_isr_fired = true;
+	eoi();
+}
+
+static void vmx_apic_passthrough_tpr_threshold_test(void)
+{
+	int ipi_vector = 0xe1;
+
+	disable_intercept_for_x2apic_msrs();
+	vmcs_clear_bits(PIN_CONTROLS, PIN_EXTINT);
+
+	/* Raise L0 TPR-threshold by queueing vector in LAPIC IRR */
+	cli();
+	apic_set_tpr((ipi_vector >> 4) + 1);
+	apic_icr_write(APIC_DEST_SELF | APIC_DEST_PHYSICAL |
+			APIC_DM_FIXED | ipi_vector,
+			0);
+
+	test_set_guest(vmx_apic_passthrough_tpr_threshold_guest);
+	enter_guest();
+
+	report("TPR was zero by guest", apic_get_tpr() == 0);
+
+	/* Clean pending self-IPI */
+	vmx_apic_passthrough_tpr_threshold_ipi_isr_fired = false;
+	handle_irq(ipi_vector, vmx_apic_passthrough_tpr_threshold_ipi_isr);
+	sti();
+	asm volatile ("nop");
+	report("self-IPI fired", vmx_apic_passthrough_tpr_threshold_ipi_isr_fired);
+
+	report(__func__, 1);
+}
+
 static u64 init_signal_test_exit_reason;
 static bool init_signal_test_thread_continued;
 
@@ -9022,6 +9064,7 @@ struct vmx_test vmx_tests[] = {
 	/* APIC pass-through tests */
 	TEST(vmx_apic_passthrough_test),
 	TEST(vmx_apic_passthrough_thread_test),
+	TEST(vmx_apic_passthrough_tpr_threshold_test),
 	TEST(vmx_init_signal_test),
 	/* VMCS Shadowing tests */
 	TEST(vmx_vmcs_shadow_test),
-- 
2.20.1

