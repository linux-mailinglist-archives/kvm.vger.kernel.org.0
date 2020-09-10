Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0D09263A94
	for <lists+kvm@lfdr.de>; Thu, 10 Sep 2020 04:35:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730478AbgIJCfM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Sep 2020 22:35:12 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:54860 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730810AbgIJCWk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Sep 2020 22:22:40 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08A2KFp9111269;
        Thu, 10 Sep 2020 02:22:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=dH1eyKokPie5jaucSlIsgc7o8VBDFSHCoFdd6+dKlY8=;
 b=aZW0G9Aj7TeUZAZ0TFyaY3OUf619RKxaQeWH5mh8NlXIsumYyCmvYotJ9RFcyON39Ffb
 tzUazpjJT3B/WPsL0f2itTaMKpJBrV+AivdYM3YTnXTKssx8xm8oQoH2pfdrT4kVDGEO
 z4t/WruSDGzOv3iz0B83/RnBfGcDhY56CxLmI8bIVwkDkD6T7D8WPqDqSyfTv4hwwPHU
 hh7SPsc2E2jZrhsiCC9+rLD3NVufTL0tPtFoa+3JGgVSqbL2LjjGuGbbofiraHoX43F+
 /E5HaKXb8sx4kPxyjq5Ckff+BymjcbcrzfNMgr6M7zIWYSwrPpZ9y/3+sj6USXkmptUV mw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 33c23r5ap6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 10 Sep 2020 02:22:31 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08A2JdoU187250;
        Thu, 10 Sep 2020 02:22:30 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 33dacme99k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 10 Sep 2020 02:22:30 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 08A2MURI002058;
        Thu, 10 Sep 2020 02:22:30 GMT
Received: from nsvm-sadhukhan-1.osdevelopmeniad.oraclevcn.com (/100.100.230.216)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 09 Sep 2020 19:22:30 -0700
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, thomas.lendacky@amd.com
Subject: [PATCH 3/3 v2] KVM: SVM: Don't flush cache of encrypted pages if hardware enforces cache coherenc
Date:   Thu, 10 Sep 2020 02:22:11 +0000
Message-Id: <20200910022211.5417-4-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.18.4
In-Reply-To: <20200910022211.5417-1-krish.sadhukhan@oracle.com>
References: <20200910022211.5417-1-krish.sadhukhan@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9739 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 bulkscore=0 phishscore=0 adultscore=0 suspectscore=1 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009100020
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9739 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 priorityscore=1501
 mlxlogscore=999 mlxscore=0 bulkscore=0 suspectscore=1 spamscore=0
 malwarescore=0 phishscore=0 lowpriorityscore=0 clxscore=1015
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009100020
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Some hardware implementations may enforce cache coherency across encryption
domains. In such cases, it's not required to flush encrypted pages off
cache lines.

Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
---
 arch/x86/kvm/svm/sev.c       | 3 ++-
 arch/x86/mm/pat/set_memory.c | 6 ++++--
 2 files changed, 6 insertions(+), 3 deletions(-)

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
diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.c
index d1b2a889f035..5e2c618cbe84 100644
--- a/arch/x86/mm/pat/set_memory.c
+++ b/arch/x86/mm/pat/set_memory.c
@@ -1999,7 +1999,8 @@ static int __set_memory_enc_dec(unsigned long addr, int numpages, bool enc)
 	/*
 	 * Before changing the encryption attribute, we need to flush caches.
 	 */
-	cpa_flush(&cpa, 1);
+	if (!this_cpu_has(X86_FEATURE_HW_CACHE_COHERENCY))
+		cpa_flush(&cpa, 1);
 
 	ret = __change_page_attr_set_clr(&cpa, 1);
 
@@ -2010,7 +2011,8 @@ static int __set_memory_enc_dec(unsigned long addr, int numpages, bool enc)
 	 * flushing gets optimized in the cpa_flush() path use the same logic
 	 * as above.
 	 */
-	cpa_flush(&cpa, 0);
+	if (!this_cpu_has(X86_FEATURE_HW_CACHE_COHERENCY))
+		cpa_flush(&cpa, 0);
 
 	return ret;
 }
-- 
2.18.4

