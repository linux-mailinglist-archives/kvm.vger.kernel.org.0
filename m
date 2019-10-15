Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9169CD6CA9
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2019 02:53:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727279AbfJOAxC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Oct 2019 20:53:02 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:48286 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727011AbfJOAxB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Oct 2019 20:53:01 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9F0n4GE002652;
        Tue, 15 Oct 2019 00:52:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2019-08-05;
 bh=eWMhMty14R3cozIej3VCG5GfLIaGivNKIf39reWKLGM=;
 b=fX8TqrjFUIPU7USk7aJMFzbqXtfok4+QxEUcNa3ywrH/zASF6LTAYBfUHxxmuqd3Tdwy
 q3Xe89F6bhsmpZzdfa3RUZWdhJtT6ESNly/kgpG3kOYV4OA7H923YsKh6an8A81BvyH5
 ZMhNPXRHyLziHHQUnCW1ZBcfXQgJjKOleVwzsZ+u279/J5J8T/KDnpcHz/+mHpUgv48C
 8IyIShRSPg0FUSQPUNxjHSUxHm0IFwTCS69FkqiSpvpguq5HkLm3mXDmDJ4JpWqC61rJ
 ar8+nXnAS1j6ayzD0WQa6ORW+WZwKlFddiC3JQWQEveNhDdGoYEqDwMP3nU6JoAphi25 WQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2vk7fr4683-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Oct 2019 00:52:39 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9F0mo9N022227;
        Tue, 15 Oct 2019 00:52:38 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 2vkr9y6mta-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Oct 2019 00:52:38 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x9F0qbC9031000;
        Tue, 15 Oct 2019 00:52:37 GMT
Received: from ban25x6uut29.us.oracle.com (/10.153.73.29)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 15 Oct 2019 00:52:36 +0000
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, rkrcmar@redhat.com, jmattson@google.com
Subject: [PATCH 3/4] kvm-unit-test: nVMX: Test deferring of error from VM-entry MSR-load area
Date:   Mon, 14 Oct 2019 20:16:32 -0400
Message-Id: <20191015001633.8603-4-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191015001633.8603-1-krish.sadhukhan@oracle.com>
References: <20191015001633.8603-1-krish.sadhukhan@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9410 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=13 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910150007
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9410 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=13 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910150007
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

According to section "VM Entries" in Intel SDM vol 3C, VM-entry checks are
performed in a certain order. Checks on MSRs that are loaded on VM-entry
from VM-entry MSR-load area, should be done after verifying VMCS controls,
host-state area and guest-state area. As KVM relies on CPU hardware to
perform some of these checks, it defers VM-exit due to invalid VM-entry
MSR-load area to until after CPU hardware completes the earlier checks
and is ready to do VMLAUNCH/VMRESUME.

This patch tests the following VM-entry scenarios:
	i) Valid guest state and valid VM-entry MSR-load area
	ii) Invalid guest state and valid VM-entry MSR-load area
	iii) Invalid guest state and invalid VM-entry MSR-load area
	iv) Valid guest state and invalid VM-entry MSR-load area
	v) Guest MSRs are not loaded from VM-entry MSR-load area
	   when VM-entry fails due to invalid VM-entry MSR-load area.

This patch sets up the invalid guest state by writing a GUEST_PAT value which
is illegal according to section "Checks on Guest Control Registers, Debug
Registers, and MSRs" in Intel SDM vol 3C.

This patch sets up the invalid VM-entry MSR-load area in vmcs12, by creating
an MSR entry which is illegal according to section "Loading MSRs" in Intel
SDM vol 3C.

Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
Reviewed-by: Karl Heubaum <karl.heubaum@oracle.com>
---
 x86/vmx_tests.c | 119 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 119 insertions(+)

diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index 7d73ee3..d68f0c0 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -7282,6 +7282,124 @@ static void test_load_guest_pat(void)
 	test_pat(GUEST_PAT, "GUEST_PAT", ENT_CONTROLS, ENT_LOAD_PAT);
 }
 
+static void report_vm_entry_msr_load_test(const char *test, u32 xreason,
+					  u64 xqual, u64 field,
+					  const char * field_name)
+{
+	u32 reason = vmcs_read(EXI_REASON);
+	u64 qual = vmcs_read(EXI_QUALIFICATION);
+	u64 guest_rip;
+	u32 insn_len;
+
+	report("%s, %s %lx", (reason == xreason && qual == xqual), test,
+	    field_name, field);
+
+	guest_rip = vmcs_read(GUEST_RIP);
+	insn_len = vmcs_read(EXI_INST_LEN);
+	if (reason != (VMX_ENTRY_FAILURE | VMX_FAIL_MSR))
+		vmcs_write(GUEST_RIP, guest_rip + insn_len);
+}
+
+static u64 guest_msr_efer;
+
+static void invalid_vm_entry_msr_load_main(void)
+{
+	while (1) {
+		guest_msr_efer = rdmsr(MSR_EFER);
+		if (vmx_get_test_stage() != 2)
+			vmcall();
+		else
+			break;
+	}
+	asm volatile("fnop");
+}
+
+static void vmx_invalid_vm_entry_msr_load_test(void)
+{
+	void *msr_bitmap;
+	u32 ctrl_cpu0;
+	u64 guest_efer = vmcs_read(GUEST_EFER);
+	u64 efer_unmodified;
+	entry_msr_load = alloc_page();
+
+	/*
+	 * Set MSR bitmap so that we don't VM-exit on RDMSR
+	 */
+	msr_bitmap = alloc_page();
+	ctrl_cpu0 = vmcs_read(CPU_EXEC_CTRL0);
+	ctrl_cpu0 |= CPU_MSR_BITMAP;
+	vmcs_write(CPU_EXEC_CTRL0, ctrl_cpu0);
+	vmcs_write(MSR_BITMAP, (u64)msr_bitmap);
+
+	vmcs_set_bits(ENT_CONTROLS, ENT_LOAD_PAT);
+	vmx_set_test_stage(1);
+	test_set_guest(invalid_vm_entry_msr_load_main);
+
+	/*
+	 * Valid guest state and valid MSR-load area
+	 */
+	enter_guest();
+	efer_unmodified = guest_msr_efer;
+	report_guest_state_test("Valid guest state, valid MSR-load area",
+				 VMX_VMCALL, 0, "");
+
+	/*
+	 * Invalid guest state and valid MSR-load area.
+	 * We render the guest-state invalid by setting an illegal value
+	 * (according to SDM) in GUEST_PAT.
+	 */
+	vmcs_write(GUEST_PAT, 2);
+	enter_guest_with_invalid_guest_state();
+	report_guest_state_test("Invalid guest state, valid MSR-load area",
+				 VMX_FAIL_STATE | VMX_ENTRY_FAILURE, GUEST_PAT,
+				 "GUEST_PAT");
+
+	/*
+	 * Valid guest state and invalid MSR-load area. In VM-entry MSR-load
+	 * area, we are creating two entries: entry# 1 is valid while entry# 2
+	 * is invalid (as per Intel SDM). This will cause KVM to return an
+	 * Exit Qualification of 2 to us on VM-entry failure.
+	 */
+	vmcs_write(GUEST_PAT, 0);
+	vmcs_write(ENT_MSR_LD_CNT, 2);
+	entry_msr_load[0].index = MSR_EFER;
+	entry_msr_load[0].value = guest_efer ^ EFER_NX;
+	entry_msr_load[1].index = MSR_FS_BASE;
+	vmcs_write(ENTER_MSR_LD_ADDR, (u64) entry_msr_load);
+	enter_guest();
+	report_vm_entry_msr_load_test("Valid guest state, invalid MSR-load area",
+					VMX_ENTRY_FAILURE | VMX_FAIL_MSR, 2,
+					ENTER_MSR_LD_ADDR, "ENTER_MSR_LD_ADDR");
+
+	/*
+	 * Invalid guest state and invalid MSR-load area
+	 */
+	vmcs_write(GUEST_PAT, 2);
+	enter_guest_with_invalid_guest_state();
+	report_guest_state_test("Invalid guest state, invalid MSR-load area",
+				 VMX_FAIL_STATE | VMX_ENTRY_FAILURE, GUEST_PAT,
+				"GUEST_PAT");
+
+	/*
+	 * Let the guest finish execution
+	 */
+	vmcs_clear_bits(ENT_CONTROLS, ENT_LOAD_PAT);
+	vmcs_write(GUEST_PAT, 0);
+	entry_msr_load[0].index = MSR_IA32_TSC;
+	entry_msr_load[0].value = 0x11111;
+	vmcs_write(ENT_MSR_LD_CNT, 1);
+	vmx_set_test_stage(2);
+	enter_guest();
+
+	/*
+	 * Verify that MSR_EFER in guest was not loaded from our invalid
+	 * VM-entry MSR-load area
+	 */
+	report("Test invalid VM-entry MSR-load, actual: 0x%lx, expected: 0x%lx",
+		guest_msr_efer == efer_unmodified, guest_msr_efer,
+		efer_unmodified);
+}
+
 /*
  * Check that the virtual CPU checks the VMX Guest State Area as
  * documented in the Intel SDM.
@@ -9023,6 +9141,7 @@ struct vmx_test vmx_tests[] = {
 	TEST(vmx_controls_test),
 	TEST(vmx_host_state_area_test),
 	TEST(vmx_guest_state_area_test),
+	TEST(vmx_invalid_vm_entry_msr_load_test),
 	TEST(vmentry_movss_shadow_test),
 	/* APICv tests */
 	TEST(vmx_eoi_bitmap_ioapic_scan_test),
-- 
2.20.1

