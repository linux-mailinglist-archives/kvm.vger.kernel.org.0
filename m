Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D4D2DB79CF
	for <lists+kvm@lfdr.de>; Thu, 19 Sep 2019 14:53:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390403AbfISMxK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Sep 2019 08:53:10 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:57446 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390407AbfISMxJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Sep 2019 08:53:09 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8JCnNIL192166;
        Thu, 19 Sep 2019 12:52:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2019-08-05;
 bh=pr1JiXa876O3hDWJGIRpTY8ic1nctXxGY7hHyRF7hk4=;
 b=KnTs8t67M96pbV/o9TSy27DhphBsqKI8G8JsfllHbMXF3bcKj1mbtnSkc7dDJZkHn6Df
 iUTviCgXaFvQTd6x994nlWnB5F1Ahx5ncP4LMUa5Pcw4gxX5PVdPcNEeUFWCaziEKCog
 ATrkRiSwlI74xYhCK+CEolITG0l/ndtYUiNsqPOG5f8gzNqlMO5iuzh5Gfz1QICRhy2K
 21Nvvj+j7DRu8DpdFlygHI3oOPGIx3tsuC3zs8w34Ak3yCFgMJGuzAMNND2d5xIVJ3TN
 Z2q8GY7i/ppHWv3710fbvNVqgab7StI8jG/8GKiugV9v0KCwx/7WdmwcOM/CUnEQrvZS Cg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2v3vb4uqr9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 19 Sep 2019 12:52:46 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8JCn4Zk156099;
        Thu, 19 Sep 2019 12:52:46 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 2v3vbac38v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 19 Sep 2019 12:52:46 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x8JCqjZs027419;
        Thu, 19 Sep 2019 12:52:45 GMT
Received: from spark.ravello.local (/213.57.127.2)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 19 Sep 2019 05:52:44 -0700
From:   Liran Alon <liran.alon@oracle.com>
To:     pbonzini@redhat.com, rkrcmar@redhat.com, kvm@vger.kernel.org
Cc:     sean.j.christopherson@intel.com, jmattson@google.com,
        vkuznets@redhat.com, Liran Alon <liran.alon@oracle.com>,
        Nikita Leshenko <nikita.leshchenko@oracle.com>,
        Joao Martins <joao.m.martins@oracle.com>
Subject: [PATCH kvm-unit-tests 7/8] x86: vmx: Allow tests to hand-over test-vmcs between CPUs
Date:   Thu, 19 Sep 2019 15:52:10 +0300
Message-Id: <20190919125211.18152-8-liran.alon@oracle.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190919125211.18152-1-liran.alon@oracle.com>
References: <20190919125211.18152-1-liran.alon@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9384 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=821
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1909190121
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9384 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=901 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1909190121
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

By exposing launched, test-vmcs can be hand-over between CPUs
by VMCLEAR test-vmcs and resetting launched to false.

Reviewed-by: Nikita Leshenko <nikita.leshchenko@oracle.com>
Reviewed-by: Joao Martins <joao.m.martins@oracle.com>
Signed-off-by: Liran Alon <liran.alon@oracle.com>
---
 x86/vmx.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/x86/vmx.h b/x86/vmx.h
index e47134e29e83..a8bc8472ed61 100644
--- a/x86/vmx.h
+++ b/x86/vmx.h
@@ -661,6 +661,7 @@ extern union vmx_ctrl_msr ctrl_enter_rev;
 extern union vmx_ept_vpid  ept_vpid;
 
 extern u64 *bsp_vmxon_region;
+extern bool launched;
 
 void vmx_set_test_stage(u32 s);
 u32 vmx_get_test_stage(void);
-- 
2.20.1

