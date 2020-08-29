Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17B002563D7
	for <lists+kvm@lfdr.de>; Sat, 29 Aug 2020 02:59:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726344AbgH2A7j (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Aug 2020 20:59:39 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:40434 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726219AbgH2A7i (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Aug 2020 20:59:38 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07T0xY5K132416;
        Sat, 29 Aug 2020 00:59:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=OsM/F1Qff/Rymr1twAoqUtJyYux9CumRm8lNWLoCYB8=;
 b=ZVqv65M2npa3huVC5992rq0O6O/f6CYIfLODMZEjh6kC/uk2xzfT0TTvPKAA5m+Mzpvr
 DUY8npXlK42tOxGfBiIN25UZuC5DBkRW/QKrDWgODC9gbiWw0U+Iyl4Obb3mtISPyE52
 TCUa3m4Jpc1bzs4tVEKM3YXbj5MkiyA20tYL3Gr6htDteFnc/UqkCKANEc/+5oECJBm/
 whIhk0wcXU7KtYOfrF4JFpW22lPziS8BBJO2PH4Z8ZdesDVjqqOwZkozwEXnbNBmFX7C
 0s2+XKW5X1MbFxcdZ9IbczvOcwCnwWo9of6dADOQycnxWI852RAkXKMuaDb/0umHVKoE Bw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 336ht3pqmk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sat, 29 Aug 2020 00:59:34 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07T0onp1147556;
        Sat, 29 Aug 2020 00:59:34 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 333ru3dq36-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 29 Aug 2020 00:59:34 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 07T0xXiK005716;
        Sat, 29 Aug 2020 00:59:33 GMT
Received: from nsvm-sadhukhan-1.osdevelopmeniad.oraclevcn.com (/100.100.230.216)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 28 Aug 2020 17:59:32 -0700
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com
Subject: [PATCH 2/2] KVM: SVM: Don't flush cache of SEV-encrypted pages if hardware enforces cache coherency across encryption domains
Date:   Sat, 29 Aug 2020 00:59:26 +0000
Message-Id: <20200829005926.5477-2-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.18.4
In-Reply-To: <20200829005926.5477-1-krish.sadhukhan@oracle.com>
References: <20200829005926.5477-1-krish.sadhukhan@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9727 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 adultscore=0
 phishscore=0 spamscore=0 bulkscore=0 mlxlogscore=999 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008290001
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9727 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0 malwarescore=0
 phishscore=0 priorityscore=1501 clxscore=1015 suspectscore=1 spamscore=0
 impostorscore=0 mlxscore=0 mlxlogscore=999 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008290002
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Some hardware implementations may enforce cache coherency across encryption
domains. In such cases, it's not required to flush SEV-encrypted pages off
cache lines.

Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
---
 arch/x86/kvm/svm/sev.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 402dc4234e39..c8ed8a62d5ef 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -384,7 +384,8 @@ static void sev_clflush_pages(struct page *pages[], unsigned long npages)
 	uint8_t *page_virtual;
 	unsigned long i;
 
-	if (npages == 0 || pages == NULL)
+	if ((cpuid_eax(SVM_SME_CPUID_FUNC) & (1u << 10)) || npages == 0 ||
+	    pages == NULL)
 		return;
 
 	for (i = 0; i < npages; i++) {
-- 
2.18.4

