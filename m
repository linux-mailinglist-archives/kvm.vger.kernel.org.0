Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 044B22668B6
	for <lists+kvm@lfdr.de>; Fri, 11 Sep 2020 21:28:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725824AbgIKT2H (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Sep 2020 15:28:07 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:49600 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725783AbgIKT14 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Sep 2020 15:27:56 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08BJOb53175098;
        Fri, 11 Sep 2020 19:26:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=K8/t9UgmD6+8fSwrmt+fZmtLM6rk0AdTiVC/bwOyu1Y=;
 b=zfz6nCkI5FPkSE2f5QKElwn4BrbvzOXKnkk7JUIpRuIdnzqTHTPUYe7yS5vt4nlYS4F5
 IV86Ioll1CZoH9XK6zxom5fTnYdlGP9BtQih0aZcPjV9M2S9BisIXLpltRzOihYnVVzP
 sSnSF8kJcUwIcHo5nEqb6VYyl2oTdEjNiNJhUWfSOruKsmC2bGGJv9BYlrZF0XJrugxK
 xeTebqZ7p/N6xeRs+szHXBoFc84o7AkiCkKumV8HgQuHt35x5baqr8p0vwdFiuYn8RPW
 3sND1m+G8iMYjCMhsFLdRcKkHlF3THTPCzwrKh7hi5xwseJ1xWY10AjGTTMVS250SS0V dA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 33c2mmg2vm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 11 Sep 2020 19:26:32 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08BJQT5S052907;
        Fri, 11 Sep 2020 19:26:31 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 33cmm3y5b6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 11 Sep 2020 19:26:31 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 08BJQRCt009940;
        Fri, 11 Sep 2020 19:26:27 GMT
Received: from nsvm-sadhukhan-1.osdevelopmeniad.oraclevcn.com (/100.100.230.216)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 11 Sep 2020 12:26:27 -0700
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, x86@kernel.org,
        sean.j.christopherson@intel.com, vkuznets@redhat.com,
        wanpengli@tencent.com, joro@8bytes.org,
        dave.hansen@linux.intel.com, luto@kernel.org, peterz@infradead.org,
        linux-kernel@vger.kernel.org, hpa@zytor.com
Subject: [PATCH 4/4 v3] KVM: SVM: Don't flush cache if hardware enforces cache coherency across encryption domains
Date:   Fri, 11 Sep 2020 19:26:01 +0000
Message-Id: <20200911192601.9591-5-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.18.4
In-Reply-To: <20200911192601.9591-1-krish.sadhukhan@oracle.com>
References: <20200911192601.9591-1-krish.sadhukhan@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9741 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 suspectscore=1
 spamscore=0 mlxlogscore=880 adultscore=0 malwarescore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009110155
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9741 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 priorityscore=1501
 phishscore=0 adultscore=0 bulkscore=0 clxscore=1015 mlxlogscore=895
 malwarescore=0 suspectscore=1 lowpriorityscore=0 spamscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009110155
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In some hardware implementations, coherency between the encrypted and
unencrypted mappings of the same physical page in a VM is enforced. In such a
system, it is not required for software to flush the VM's page from all CPU
caches in the system prior to changing the value of the C-bit for the page.

Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
---
 arch/x86/kvm/svm/sev.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 402dc4234e39..8aa2209f2637 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -384,7 +384,8 @@ static void sev_clflush_pages(struct page *pages[], unsigned long npages)
 	uint8_t *page_virtual;
 	unsigned long i;
 
-	if (npages == 0 || pages == NULL)
+	if (this_cpu_has(X86_FEATURE_HW_CACHE_COHERENCY) || npages == 0 ||
+	    pages == NULL)
 		return;
 
 	for (i = 0; i < npages; i++) {
-- 
2.18.4

