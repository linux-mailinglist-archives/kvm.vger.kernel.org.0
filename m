Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 020A0B79CC
	for <lists+kvm@lfdr.de>; Thu, 19 Sep 2019 14:53:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390410AbfISMxI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Sep 2019 08:53:08 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:57428 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390407AbfISMxH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Sep 2019 08:53:07 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8JCnbjM192525;
        Thu, 19 Sep 2019 12:52:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2019-08-05;
 bh=lJgiKC7lFbl2F7BdBMLOkKGB5Q9KwyvK0fwuCh1ce3w=;
 b=qsXl9ONd5B3rhyXJG9BDVpABJ3ojVmH2UYb4CTSUzm5txKTqK6y+eNbhvWPg0Ly98aac
 oBthliYlG0vek7dUKK859hiqKjJ54GAsZhgVOxuEUzNcUqutYuf3jU7TGE6UwONaFbaH
 ACx4u38dAJj3MnIFsCBJe/g0v8yYNSz7+p3PLkIY4xi2nWUgaC/NTztVcMGKnuv9tIsf
 s8SIEbEhaFxXu/JMrVGQrf6XEWeVwFiMtAOuO5oLKpE5kBHI3ulRLpbXSKv5olrnNmha
 I2L5M4hfmnqFtPOKMjAHIzZonnmAuC7Izz2jg3jTk8B7OV5oEe69oK5M/7O4LTXz5M3O ww== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2v3vb4uqpt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 19 Sep 2019 12:52:34 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8JCn4Y2090503;
        Thu, 19 Sep 2019 12:52:34 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2v3vb5ksw6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 19 Sep 2019 12:52:34 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x8JCqXIr016880;
        Thu, 19 Sep 2019 12:52:33 GMT
Received: from spark.ravello.local (/213.57.127.2)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 19 Sep 2019 05:52:32 -0700
From:   Liran Alon <liran.alon@oracle.com>
To:     pbonzini@redhat.com, rkrcmar@redhat.com, kvm@vger.kernel.org
Cc:     sean.j.christopherson@intel.com, jmattson@google.com,
        vkuznets@redhat.com, Liran Alon <liran.alon@oracle.com>,
        Nikita Leshenko <nikita.leshchenko@oracle.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>
Subject: [PATCH kvm-unit-tests 2/8] x86: vmx: Prepare init_vmx() for VMX support on AP CPUs
Date:   Thu, 19 Sep 2019 15:52:05 +0300
Message-Id: <20190919125211.18152-3-liran.alon@oracle.com>
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

This is done as a prepartion for future patches that will add
ability for running VMX in CPUs other than BSP.

Reviewed-by: Nikita Leshenko <nikita.leshchenko@oracle.com>
Reviewed-by: Joao Martins <joao.m.martins@oracle.com>
Reviewed-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
Signed-off-by: Liran Alon <liran.alon@oracle.com>
---
 x86/vmx.c | 22 ++++++++++++++--------
 1 file changed, 14 insertions(+), 8 deletions(-)

diff --git a/x86/vmx.c b/x86/vmx.c
index d74365049eeb..a8d485c3bd09 100644
--- a/x86/vmx.c
+++ b/x86/vmx.c
@@ -1268,29 +1268,35 @@ static void init_vmx_caps(void)
 		ept_vpid.val = 0;
 }
 
-static void init_vmx(void)
+static void init_vmx(u64 *vmxon_region)
 {
 	ulong fix_cr0_set, fix_cr0_clr;
 	ulong fix_cr4_set, fix_cr4_clr;
 
-	vmxon_region = alloc_page();
-
-	vmcs_root = alloc_page();
-
 	fix_cr0_set =  rdmsr(MSR_IA32_VMX_CR0_FIXED0);
 	fix_cr0_clr =  rdmsr(MSR_IA32_VMX_CR0_FIXED1);
 	fix_cr4_set =  rdmsr(MSR_IA32_VMX_CR4_FIXED0);
 	fix_cr4_clr = rdmsr(MSR_IA32_VMX_CR4_FIXED1);
 
-	init_vmx_caps();
-
 	write_cr0((read_cr0() & fix_cr0_clr) | fix_cr0_set);
 	write_cr4((read_cr4() & fix_cr4_clr) | fix_cr4_set | X86_CR4_VMXE);
 
 	*vmxon_region = basic.revision;
+}
 
+static void alloc_bsp_vmx_pages(void)
+{
+	vmxon_region = alloc_page();
 	guest_stack = alloc_page();
 	guest_syscall_stack = alloc_page();
+	vmcs_root = alloc_page();
+}
+
+static void init_bsp_vmx(void)
+{
+	init_vmx_caps();
+	alloc_bsp_vmx_pages();
+	init_vmx(vmxon_region);
 }
 
 static void do_vmxon_off(void *data)
@@ -1932,7 +1938,7 @@ int main(int argc, const char *argv[])
 		printf("WARNING: vmx not supported, add '-cpu host'\n");
 		goto exit;
 	}
-	init_vmx();
+	init_bsp_vmx();
 	if (test_wanted("test_vmx_feature_control", argv, argc)) {
 		/* Sets MSR_IA32_FEATURE_CONTROL to 0x5 */
 		if (test_vmx_feature_control() != 0)
-- 
2.20.1

