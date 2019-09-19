Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A399AB79CB
	for <lists+kvm@lfdr.de>; Thu, 19 Sep 2019 14:53:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390396AbfISMxB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Sep 2019 08:53:01 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:46674 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389585AbfISMxA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Sep 2019 08:53:00 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8JCndYC151146;
        Thu, 19 Sep 2019 12:52:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2019-08-05;
 bh=e2iJDhroKYhLvqIdq24XQuCMTOOmrlYdxxynevgpWpA=;
 b=m6o0Y66PD2ursS6KtT1A7iI+bP/vXkLcgifHFHqWQ7CbhLt5MnuyTZbTH3p5fTC0K/Fe
 pEvYJfg0qRlXieLEpGvwqsVwmkgkscnJHRxaTbEBT7pk9anMxi1SF0u0Uu7+vznDlpcV
 hZzdp++li5EJH5GB3R6rz7Z8LdMJXXayrxVWr3xgLsLbnsbsq6saHId+0aLGVfecMihB
 kJQXugZ6HGx7kYT6ifiuKwX2cqUS9zqF4vDD9p9LDUmvyVx5HbraodRg2iUX4zM2QCec
 f2f9ex6mLntEoBAzGkIEldSELT1JFY2Lj/0YOepUSpYYvfIHj6gfIgQ1sAC2TQFWF2x9 Zg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2v3vb4kpuw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 19 Sep 2019 12:52:37 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8JCn1P5155744;
        Thu, 19 Sep 2019 12:52:37 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2v3vbac32f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 19 Sep 2019 12:52:36 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x8JCqZLf016914;
        Thu, 19 Sep 2019 12:52:36 GMT
Received: from spark.ravello.local (/213.57.127.2)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 19 Sep 2019 05:52:35 -0700
From:   Liran Alon <liran.alon@oracle.com>
To:     pbonzini@redhat.com, rkrcmar@redhat.com, kvm@vger.kernel.org
Cc:     sean.j.christopherson@intel.com, jmattson@google.com,
        vkuznets@redhat.com, Liran Alon <liran.alon@oracle.com>,
        Nikita Leshenko <nikita.leshchenko@oracle.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>
Subject: [PATCH kvm-unit-tests 3/8] x86: vmx: Expose vmx_init() to be used on AP CPUs
Date:   Thu, 19 Sep 2019 15:52:06 +0300
Message-Id: <20190919125211.18152-4-liran.alon@oracle.com>
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

Reviewed-by: Nikita Leshenko <nikita.leshchenko@oracle.com>
Reviewed-by: Joao Martins <joao.m.martins@oracle.com>
Reviewed-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
Signed-off-by: Liran Alon <liran.alon@oracle.com>
---
 x86/vmx.c | 2 +-
 x86/vmx.h | 2 ++
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/x86/vmx.c b/x86/vmx.c
index a8d485c3bd09..10b0a423dd23 100644
--- a/x86/vmx.c
+++ b/x86/vmx.c
@@ -1268,7 +1268,7 @@ static void init_vmx_caps(void)
 		ept_vpid.val = 0;
 }
 
-static void init_vmx(u64 *vmxon_region)
+void init_vmx(u64 *vmxon_region)
 {
 	ulong fix_cr0_set, fix_cr0_clr;
 	ulong fix_cr4_set, fix_cr4_clr;
diff --git a/x86/vmx.h b/x86/vmx.h
index 75abf9a489dd..6127db3cfdd5 100644
--- a/x86/vmx.h
+++ b/x86/vmx.h
@@ -785,6 +785,8 @@ static inline bool invvpid(unsigned long type, u64 vpid, u64 gla)
 	return ret;
 }
 
+void init_vmx(u64 *vmxon_region);
+
 const char *exit_reason_description(u64 reason);
 void print_vmexit_info(void);
 void print_vmentry_failure_info(struct vmentry_failure *failure);
-- 
2.20.1

