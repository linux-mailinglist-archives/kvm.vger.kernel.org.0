Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC2D6B79C9
	for <lists+kvm@lfdr.de>; Thu, 19 Sep 2019 14:53:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390310AbfISMw5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Sep 2019 08:52:57 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:46592 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390293AbfISMw5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Sep 2019 08:52:57 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8JCndYD151146;
        Thu, 19 Sep 2019 12:52:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2019-08-05;
 bh=b6j41riZbOO79A608VsM+KxEayDCIur5kteBhfLnWdg=;
 b=Fmb97kn+VD3wf5zJvPR9FBjucKghfofnE92V74QLip6+hVUOywu4DBC4cdqa30V585LC
 263vVx7iuUKN4/8dztmcD1IFbrD1+pp1BFm6bDhbtiuMPANE84+MvU3EPNOc0eu1R3wN
 MA9IbvcTXT12G69fVbwIQ52Vhq/AFvPkOrS9oFe9iulh072pBm70qC1/yP0Dhkf/0eby
 ffvRkyw236vywo91UDKmKZlqqw6S6B+aIhU0iz6C0f8YlGKTOpH26NkwT6E3sFQwawDi
 deOy0IYUp0/+5nmEUwTXsXTa/xp7eKxc5ycAE+SgpvfxByBu1JXpwiqDYE8mYDWa66YY lQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2v3vb4kpvb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 19 Sep 2019 12:52:40 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8JCoJ7A095519;
        Thu, 19 Sep 2019 12:52:39 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2v3vb5kt2w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 19 Sep 2019 12:52:39 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x8JCqcSk024213;
        Thu, 19 Sep 2019 12:52:38 GMT
Received: from spark.ravello.local (/213.57.127.2)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 19 Sep 2019 05:52:37 -0700
From:   Liran Alon <liran.alon@oracle.com>
To:     pbonzini@redhat.com, rkrcmar@redhat.com, kvm@vger.kernel.org
Cc:     sean.j.christopherson@intel.com, jmattson@google.com,
        vkuznets@redhat.com, Liran Alon <liran.alon@oracle.com>,
        Nikita Leshenko <nikita.leshchenko@oracle.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>
Subject: [PATCH kvm-unit-tests 4/8] x86: vmx: Support VMXON on AP CPUs VMX region
Date:   Thu, 19 Sep 2019 15:52:07 +0300
Message-Id: <20190919125211.18152-5-liran.alon@oracle.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190919125211.18152-1-liran.alon@oracle.com>
References: <20190919125211.18152-1-liran.alon@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9384 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=890
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1909190121
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9384 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=963 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1909190121
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Reviewed-by: Nikita Leshenko <nikita.leshchenko@oracle.com>
Reviewed-by: Joao Martins <joao.m.martins@oracle.com>
Reviewed-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
Signed-off-by: Liran Alon <liran.alon@oracle.com>
---
 x86/vmx.c | 25 ++++++++++++-------------
 x86/vmx.h |  9 +++++++--
 2 files changed, 19 insertions(+), 15 deletions(-)

diff --git a/x86/vmx.c b/x86/vmx.c
index 10b0a423dd23..4b839ea8cc66 100644
--- a/x86/vmx.c
+++ b/x86/vmx.c
@@ -38,7 +38,7 @@
 #include "smp.h"
 #include "apic.h"
 
-u64 *vmxon_region;
+u64 *bsp_vmxon_region;
 struct vmcs *vmcs_root;
 u32 vpid_cnt;
 void *guest_stack, *guest_syscall_stack;
@@ -693,7 +693,7 @@ static void test_vmclear(void)
 	       vmcs_clear(tmp_root) == 1);
 
 	/* Pass VMXON region */
-	tmp_root = (struct vmcs *)vmxon_region;
+	tmp_root = (struct vmcs *)bsp_vmxon_region;
 	report("test vmclear with vmxon region",
 	       vmcs_clear(tmp_root) == 1);
 
@@ -1286,7 +1286,7 @@ void init_vmx(u64 *vmxon_region)
 
 static void alloc_bsp_vmx_pages(void)
 {
-	vmxon_region = alloc_page();
+	bsp_vmxon_region = alloc_page();
 	guest_stack = alloc_page();
 	guest_syscall_stack = alloc_page();
 	vmcs_root = alloc_page();
@@ -1296,7 +1296,7 @@ static void init_bsp_vmx(void)
 {
 	init_vmx_caps();
 	alloc_bsp_vmx_pages();
-	init_vmx(vmxon_region);
+	init_vmx(bsp_vmxon_region);
 }
 
 static void do_vmxon_off(void *data)
@@ -1346,12 +1346,12 @@ static int test_vmx_feature_control(void)
 static int test_vmxon(void)
 {
 	int ret, ret1;
-	u64 *tmp_region = vmxon_region;
+	u64 *vmxon_region;
 	int width = cpuid_maxphyaddr();
 
 	/* Unaligned page access */
-	vmxon_region = (u64 *)((intptr_t)vmxon_region + 1);
-	ret1 = vmx_on();
+	vmxon_region = (u64 *)((intptr_t)bsp_vmxon_region + 1);
+	ret1 = _vmx_on(vmxon_region);
 	report("test vmxon with unaligned vmxon region", ret1);
 	if (!ret1) {
 		ret = 1;
@@ -1359,8 +1359,8 @@ static int test_vmxon(void)
 	}
 
 	/* gpa bits beyond physical address width are set*/
-	vmxon_region = (u64 *)((intptr_t)tmp_region | ((u64)1 << (width+1)));
-	ret1 = vmx_on();
+	vmxon_region = (u64 *)((intptr_t)bsp_vmxon_region | ((u64)1 << (width+1)));
+	ret1 = _vmx_on(vmxon_region);
 	report("test vmxon with bits set beyond physical address width", ret1);
 	if (!ret1) {
 		ret = 1;
@@ -1368,8 +1368,7 @@ static int test_vmxon(void)
 	}
 
 	/* invalid revision indentifier */
-	vmxon_region = tmp_region;
-	*vmxon_region = 0xba9da9;
+	*bsp_vmxon_region = 0xba9da9;
 	ret1 = vmx_on();
 	report("test vmxon with invalid revision identifier", ret1);
 	if (!ret1) {
@@ -1378,7 +1377,7 @@ static int test_vmxon(void)
 	}
 
 	/* and finally a valid region */
-	*vmxon_region = basic.revision;
+	*bsp_vmxon_region = basic.revision;
 	ret = vmx_on();
 	report("test vmxon with valid vmxon region", !ret);
 
@@ -1408,7 +1407,7 @@ static void test_vmptrld(void)
 	/* Pass VMXON region */
 	assert(!vmcs_clear(vmcs));
 	assert(!make_vmcs_current(vmcs));
-	tmp_root = (struct vmcs *)vmxon_region;
+	tmp_root = (struct vmcs *)bsp_vmxon_region;
 	report("test vmptrld with vmxon region",
 	       make_vmcs_current(tmp_root) == 1);
 	report("test vmptrld with vmxon region vm-instruction error",
diff --git a/x86/vmx.h b/x86/vmx.h
index 6127db3cfdd5..fdc6f7171826 100644
--- a/x86/vmx.h
+++ b/x86/vmx.h
@@ -660,13 +660,13 @@ extern union vmx_ctrl_msr ctrl_exit_rev;
 extern union vmx_ctrl_msr ctrl_enter_rev;
 extern union vmx_ept_vpid  ept_vpid;
 
-extern u64 *vmxon_region;
+extern u64 *bsp_vmxon_region;
 
 void vmx_set_test_stage(u32 s);
 u32 vmx_get_test_stage(void);
 void vmx_inc_test_stage(void);
 
-static int vmx_on(void)
+static int _vmx_on(u64 *vmxon_region)
 {
 	bool ret;
 	u64 rflags = read_rflags() | X86_EFLAGS_CF | X86_EFLAGS_ZF;
@@ -675,6 +675,11 @@ static int vmx_on(void)
 	return ret;
 }
 
+static int vmx_on(void)
+{
+	return _vmx_on(bsp_vmxon_region);
+}
+
 static int vmx_off(void)
 {
 	bool ret;
-- 
2.20.1

