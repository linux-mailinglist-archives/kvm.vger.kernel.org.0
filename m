Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D05A527A874
	for <lists+kvm@lfdr.de>; Mon, 28 Sep 2020 09:21:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726564AbgI1HVM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Sep 2020 03:21:12 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:42314 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726465AbgI1HVL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Sep 2020 03:21:11 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08S7Jku8104719;
        Mon, 28 Sep 2020 07:21:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=708udkJmuvBzBN+G7FJxjGzlQoGjWc2P1e/kMUoa7m0=;
 b=ZWP9Qy6HK0dFFXmf6q+sydsjWk9bTm01puejcybLDCsASSLWzzkQgKsc9BSjRHG8zzmI
 a9g7a62HL2SDafwF2NE3Vp+ekD9pph+YnJb87pyhLJqmeCvCKLLqm5zLiIZfhvJSuCqu
 OLHu5opySJKh9EBnRa3cqMEzrU+yeVOkL3D1rkyC6U6FHL07hxG+IKBIhisKwGsnweZG
 X3B5WrMQf1JGU5Nj9gFqkBwyGcJeDl+5ulwxWNJ9bKWOQHmw7OeqdtlmtD0GMpRUleo0
 wZclkcOtwHOcRTPjp2UMU51rAuoQRTjNJZsgIajpY+NU/YiQ+WylXFSbcn3gsrhFF0Kn fA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 33swkkkdps-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 28 Sep 2020 07:21:08 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08S7Jg7w131604;
        Mon, 28 Sep 2020 07:21:07 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 33tfjujg4g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 28 Sep 2020 07:21:07 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 08S7L6DP024053;
        Mon, 28 Sep 2020 07:21:06 GMT
Received: from nsvm-sadhukhan-1.osdevelopmeniad.oraclevcn.com (/100.100.230.216)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 28 Sep 2020 00:21:06 -0700
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com
Subject: [PATCH 1/4 v2] KVM: nSVM: CR3 MBZ bits are only 63:52
Date:   Mon, 28 Sep 2020 07:20:40 +0000
Message-Id: <20200928072043.9359-2-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.18.4
In-Reply-To: <20200928072043.9359-1-krish.sadhukhan@oracle.com>
References: <20200928072043.9359-1-krish.sadhukhan@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9757 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 mlxscore=0
 phishscore=0 adultscore=0 bulkscore=0 mlxlogscore=999 suspectscore=1
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009280061
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9757 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 phishscore=0
 suspectscore=1 mlxlogscore=999 clxscore=1015 priorityscore=1501
 impostorscore=0 lowpriorityscore=0 bulkscore=0 spamscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009280061
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

