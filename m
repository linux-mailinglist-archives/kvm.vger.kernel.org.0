Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 673D8B79C8
	for <lists+kvm@lfdr.de>; Thu, 19 Sep 2019 14:52:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390285AbfISMw4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Sep 2019 08:52:56 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:57068 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389611AbfISMwz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Sep 2019 08:52:55 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8JCnNcQ192172;
        Thu, 19 Sep 2019 12:52:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2019-08-05;
 bh=GPM0gON8cO+0laMNOFmmLm7oLFNmncDUeC8XuWlpioc=;
 b=NMGULGaFwdrwGO/WYqLiN0kHToX4L1DJdap9pVzlM2lM7xcp6dIsIYazagL06hxhVih0
 A418m/YawBaZvfE36z9Gf7QO2bhBL9U51w1tRviAl3qkLR8/8mV8UrwjO93vGolJjoN8
 VVHnmSghZ8lFV7ZxDS0I1jhLpHfQq7zDxAIx7SIjl1niH00o+YmXFGrG90ZJ2H0QbILK
 R8Jwvvh5NbtroLl0/SK6ywfpY3/Hbr+UVoixSAGf2O1kTLh9zCy1B+B1at7CatzX2T1w
 gAZXAj+YNUibJKvJQ/3iKMs/aiP8L554u6SRyWYBekwROd+tK1lxDLIHFLNAlgGcqG18 MQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2v3vb4uqpe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 19 Sep 2019 12:52:32 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8JCmDTn178779;
        Thu, 19 Sep 2019 12:52:31 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 2v3vbs1ke3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 19 Sep 2019 12:52:31 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x8JCqUdN012185;
        Thu, 19 Sep 2019 12:52:30 GMT
Received: from spark.ravello.local (/213.57.127.2)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 19 Sep 2019 05:52:29 -0700
From:   Liran Alon <liran.alon@oracle.com>
To:     pbonzini@redhat.com, rkrcmar@redhat.com, kvm@vger.kernel.org
Cc:     sean.j.christopherson@intel.com, jmattson@google.com,
        vkuznets@redhat.com, Liran Alon <liran.alon@oracle.com>,
        Nikita Leshenko <nikita.leshchenko@oracle.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>
Subject: [PATCH kvm-unit-tests 1/8] x86: vmx: Refactor init of VMX caps to separate function
Date:   Thu, 19 Sep 2019 15:52:04 +0300
Message-Id: <20190919125211.18152-2-liran.alon@oracle.com>
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

This is done as a preparation to future patches that will
introduce ability to run VMX on CPUs other than BSP.

Reviewed-by: Nikita Leshenko <nikita.leshchenko@oracle.com>
Reviewed-by: Joao Martins <joao.m.martins@oracle.com>
Reviewed-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
Signed-off-by: Liran Alon <liran.alon@oracle.com>
---
 x86/vmx.c | 30 ++++++++++++++++++------------
 1 file changed, 18 insertions(+), 12 deletions(-)

diff --git a/x86/vmx.c b/x86/vmx.c
index 6079420db33a..d74365049eeb 100644
--- a/x86/vmx.c
+++ b/x86/vmx.c
@@ -1247,19 +1247,8 @@ static int init_vmcs(struct vmcs **vmcs)
 	return 0;
 }
 
-static void init_vmx(void)
+static void init_vmx_caps(void)
 {
-	ulong fix_cr0_set, fix_cr0_clr;
-	ulong fix_cr4_set, fix_cr4_clr;
-
-	vmxon_region = alloc_page();
-
-	vmcs_root = alloc_page();
-
-	fix_cr0_set =  rdmsr(MSR_IA32_VMX_CR0_FIXED0);
-	fix_cr0_clr =  rdmsr(MSR_IA32_VMX_CR0_FIXED1);
-	fix_cr4_set =  rdmsr(MSR_IA32_VMX_CR4_FIXED0);
-	fix_cr4_clr = rdmsr(MSR_IA32_VMX_CR4_FIXED1);
 	basic.val = rdmsr(MSR_IA32_VMX_BASIC);
 	ctrl_pin_rev.val = rdmsr(basic.ctrl ? MSR_IA32_VMX_TRUE_PIN
 			: MSR_IA32_VMX_PINBASED_CTLS);
@@ -1277,6 +1266,23 @@ static void init_vmx(void)
 		ept_vpid.val = rdmsr(MSR_IA32_VMX_EPT_VPID_CAP);
 	else
 		ept_vpid.val = 0;
+}
+
+static void init_vmx(void)
+{
+	ulong fix_cr0_set, fix_cr0_clr;
+	ulong fix_cr4_set, fix_cr4_clr;
+
+	vmxon_region = alloc_page();
+
+	vmcs_root = alloc_page();
+
+	fix_cr0_set =  rdmsr(MSR_IA32_VMX_CR0_FIXED0);
+	fix_cr0_clr =  rdmsr(MSR_IA32_VMX_CR0_FIXED1);
+	fix_cr4_set =  rdmsr(MSR_IA32_VMX_CR4_FIXED0);
+	fix_cr4_clr = rdmsr(MSR_IA32_VMX_CR4_FIXED1);
+
+	init_vmx_caps();
 
 	write_cr0((read_cr0() & fix_cr0_clr) | fix_cr0_set);
 	write_cr4((read_cr4() & fix_cr4_clr) | fix_cr4_set | X86_CR4_VMXE);
-- 
2.20.1

