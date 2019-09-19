Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A48AB79D0
	for <lists+kvm@lfdr.de>; Thu, 19 Sep 2019 14:53:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390426AbfISMxM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Sep 2019 08:53:12 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:47022 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390421AbfISMxL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Sep 2019 08:53:11 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8JCnMDs150977;
        Thu, 19 Sep 2019 12:52:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2019-08-05;
 bh=yR/3L6I/MK1cQp7V3BAxxIdJ+4CObEwAFUUQTxSWvEs=;
 b=Th1qTpgUGv/6xColfVYP6buRe4yicD4utJUYXD53C5YIf8I1leAWP8Xh/02g/Djli/em
 U6ms8k+0YOZOJG+C80nulnFdHIxMZ8jj7T8NLnSfFXDH7+vF1xfCJEXscCk376DAGXpF
 vasrHb5SVSFmwinYqrcptjsa5/6K5W6eGL2S1qa/GwLNaX7sosmDQAxtgfS3UOjUj1LI
 n0/xx1rZhLcYs75DjLYy+Jg/iFr8SJjTR7+KM63rtmREnXuA8O6VcVZTpLDMltQJxYbn
 0fWZZzNdKEf++TSQfdtMEcVWNHElZEU70w3IF88SBvenCW2kpi+crTEQwKurvB23VRM4 3g== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2v3vb4kpvu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 19 Sep 2019 12:52:44 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8JCn0XU056507;
        Thu, 19 Sep 2019 12:52:43 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2v3vbg2e1c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 19 Sep 2019 12:52:43 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x8JCqhf3012384;
        Thu, 19 Sep 2019 12:52:43 GMT
Received: from spark.ravello.local (/213.57.127.2)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 19 Sep 2019 05:52:42 -0700
From:   Liran Alon <liran.alon@oracle.com>
To:     pbonzini@redhat.com, rkrcmar@redhat.com, kvm@vger.kernel.org
Cc:     sean.j.christopherson@intel.com, jmattson@google.com,
        vkuznets@redhat.com, Liran Alon <liran.alon@oracle.com>,
        Nikita Leshenko <nikita.leshchenko@oracle.com>,
        Joao Martins <joao.m.martins@oracle.com>
Subject: [PATCH kvm-unit-tests 6/8] x86: vmx: Expose util to enable VMX in MSR_IA32_FEATURE_CONTROL
Date:   Thu, 19 Sep 2019 15:52:09 +0300
Message-Id: <20190919125211.18152-7-liran.alon@oracle.com>
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
Signed-off-by: Liran Alon <liran.alon@oracle.com>
---
 x86/vmx.c | 22 ++++++++++++++--------
 x86/vmx.h |  1 +
 2 files changed, 15 insertions(+), 8 deletions(-)

diff --git a/x86/vmx.c b/x86/vmx.c
index 146734d334a1..b9328d9ca75c 100644
--- a/x86/vmx.c
+++ b/x86/vmx.c
@@ -1247,6 +1247,19 @@ static int init_vmcs(struct vmcs **vmcs)
 	return 0;
 }
 
+void enable_vmx(void)
+{
+	bool vmx_enabled =
+		rdmsr(MSR_IA32_FEATURE_CONTROL) &
+		FEATURE_CONTROL_VMXON_ENABLED_OUTSIDE_SMX;
+
+	if (!vmx_enabled) {
+		wrmsr(MSR_IA32_FEATURE_CONTROL,
+				FEATURE_CONTROL_VMXON_ENABLED_OUTSIDE_SMX |
+				FEATURE_CONTROL_LOCKED);
+	}
+}
+
 static void init_vmx_caps(void)
 {
 	basic.val = rdmsr(MSR_IA32_VMX_BASIC);
@@ -1932,7 +1945,6 @@ test_wanted(const char *name, const char *filters[], int filter_count)
 int main(int argc, const char *argv[])
 {
 	int i = 0;
-	bool vmx_enabled;
 
 	setup_vm();
 	smp_init();
@@ -1954,13 +1966,7 @@ int main(int argc, const char *argv[])
 		if (test_vmx_feature_control() != 0)
 			goto exit;
 	} else {
-		vmx_enabled = rdmsr(MSR_IA32_FEATURE_CONTROL) &
-			FEATURE_CONTROL_VMXON_ENABLED_OUTSIDE_SMX;
-		if (!vmx_enabled) {
-			wrmsr(MSR_IA32_FEATURE_CONTROL,
-				  FEATURE_CONTROL_VMXON_ENABLED_OUTSIDE_SMX |
-				  FEATURE_CONTROL_LOCKED);
-		}
+		enable_vmx();
 	}
 
 	if (test_wanted("test_vmxon", argv, argc)) {
diff --git a/x86/vmx.h b/x86/vmx.h
index fdc6f7171826..e47134e29e83 100644
--- a/x86/vmx.h
+++ b/x86/vmx.h
@@ -790,6 +790,7 @@ static inline bool invvpid(unsigned long type, u64 vpid, u64 gla)
 	return ret;
 }
 
+void enable_vmx(void);
 void init_vmx(u64 *vmxon_region);
 
 const char *exit_reason_description(u64 reason);
-- 
2.20.1

