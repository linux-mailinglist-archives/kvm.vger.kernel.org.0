Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B600D2563C0
	for <lists+kvm@lfdr.de>; Sat, 29 Aug 2020 02:48:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726912AbgH2Asn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Aug 2020 20:48:43 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:57574 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726858AbgH2Asj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Aug 2020 20:48:39 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07T0U0uD071603;
        Sat, 29 Aug 2020 00:48:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=708udkJmuvBzBN+G7FJxjGzlQoGjWc2P1e/kMUoa7m0=;
 b=DGdiCPA4JJ72UfgHPVEKkb6wiS9zi4T2Qu0+jSbCy35LZ1qa7mjCcKGgyKnqNc/EdVEf
 iG3a5FVXmusP6MdHguHGi9eoTyE3ZigotTRBTkhHph/zbEmhivU3okKVz/Xr6PQbIGD0
 6leIhh5aOfIF/IsqHIy4vCJMIgSRET4U4FtsQ0GMN3Tu5iBUI71V7b5c7Ot7Mt/1tf/c
 0jWJNJCNKiP6E7UsEWPJsR3S1oO9CZRkCZd/RWZyuQytXzDI3kZG+acsZd3jnPwH1N6A
 DzJE02iqU1vbzSN4O9KTJvJ6qGSXv36BDmMfkh6LejsHNx09wa8dRyxgY5jXoMgYtl0g Lw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 333dbsemft-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sat, 29 Aug 2020 00:48:34 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07T0V0DB139422;
        Sat, 29 Aug 2020 00:48:34 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 333r9q8ae3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 29 Aug 2020 00:48:34 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 07T0mXAl030899;
        Sat, 29 Aug 2020 00:48:33 GMT
Received: from nsvm-sadhukhan-1.osdevelopmeniad.oraclevcn.com (/100.100.230.216)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 28 Aug 2020 17:48:33 -0700
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com
Subject: [PATCH 1/3] KVM: nSVM: CR3 MBZ bits are only 63:52
Date:   Sat, 29 Aug 2020 00:48:22 +0000
Message-Id: <20200829004824.4577-2-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.18.4
In-Reply-To: <20200829004824.4577-1-krish.sadhukhan@oracle.com>
References: <20200829004824.4577-1-krish.sadhukhan@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9727 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 bulkscore=0
 adultscore=0 spamscore=0 mlxlogscore=999 phishscore=0 suspectscore=1
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008290000
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9727 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 clxscore=1015
 priorityscore=1501 impostorscore=0 phishscore=0 malwarescore=0
 mlxlogscore=999 spamscore=0 mlxscore=0 lowpriorityscore=0 suspectscore=1
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008290000
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Commit 761e4169346553c180bbd4a383aedd72f905bc9a created a wrong mask for the
CR3 MBZ bits. According to APM vol 2, only the upper 12 bits are MBZ.

(Fixes 761e4169346553c180bbd4a383aedd72f905bc9a)

Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
---
 arch/x86/kvm/svm/svm.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index a798e1731709..c0d75b1e0664 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -345,7 +345,7 @@ static inline bool gif_set(struct vcpu_svm *svm)
 /* svm.c */
 #define MSR_CR3_LEGACY_RESERVED_MASK		0xfe7U
 #define MSR_CR3_LEGACY_PAE_RESERVED_MASK	0x7U
-#define MSR_CR3_LONG_RESERVED_MASK		0xfff0000000000fe7U
+#define MSR_CR3_LONG_MBZ_MASK			0xfff0000000000000U
 #define MSR_INVALID				0xffffffffU
 
 u32 svm_msrpm_offset(u32 msr);
-- 
2.18.4

