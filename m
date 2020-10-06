Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A32CE285212
	for <lists+kvm@lfdr.de>; Tue,  6 Oct 2020 21:07:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727007AbgJFTHJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Oct 2020 15:07:09 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:57522 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727002AbgJFTHJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Oct 2020 15:07:09 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 096IxRiZ088708;
        Tue, 6 Oct 2020 19:07:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=708udkJmuvBzBN+G7FJxjGzlQoGjWc2P1e/kMUoa7m0=;
 b=KpQv3zNSkeMp7sI5gCTTalhXiJSrjBikdOgL0LPig0Jhh9edmy/AaWrXHHTiJMPMJ0Mt
 MYBRILaBDr8yrPB5Ik4aRlMUWG1mq8yk+nWMYpxx9yS/AjKQkn+UkVGB6ZIm1FDTj7aK
 TD6ktCojLtaHouHB1sUbtYST+jMTGWp+/sYHRsc4WU1YSSutHOfKEL0vRBAY61s6I3be
 Pj/2GLBvcN/Wzetfm2QNxQkJgkM34DjHmFy/e7AAfqXIH8XO/nG3x/xwkiJL4dDo0ZZJ
 5IfR2WznrIWOcBOrLdg4KezIQsdNL85G7XASe9UU6k3NE8uiInRG5zBfxoajtKsvRIOB zw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 33xhxmwuqb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 06 Oct 2020 19:07:04 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 096J1BeH095817;
        Tue, 6 Oct 2020 19:07:04 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 33yyjg2kyx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 06 Oct 2020 19:07:03 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 096J72Y8025555;
        Tue, 6 Oct 2020 19:07:02 GMT
Received: from nsvm-sadhukhan-1.osdevelopmeniad.oraclevcn.com (/100.100.230.216)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 06 Oct 2020 12:07:02 -0700
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com,
        sean.j.christopherson@intel.com
Subject: [PATCH 1/4 v3] KVM: nSVM: CR3 MBZ bits are only 63:52
Date:   Tue,  6 Oct 2020 19:06:51 +0000
Message-Id: <20201006190654.32305-2-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.18.4
In-Reply-To: <20201006190654.32305-1-krish.sadhukhan@oracle.com>
References: <20201006190654.32305-1-krish.sadhukhan@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9766 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 adultscore=0 bulkscore=0
 phishscore=0 mlxlogscore=999 mlxscore=0 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010060123
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9766 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 bulkscore=0
 impostorscore=0 lowpriorityscore=0 suspectscore=1 phishscore=0
 mlxlogscore=999 adultscore=0 clxscore=1015 spamscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010060123
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

