Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 78A631A3BF6
	for <lists+kvm@lfdr.de>; Thu,  9 Apr 2020 23:30:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726973AbgDIVau (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Apr 2020 17:30:50 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:36656 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726867AbgDIVau (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Apr 2020 17:30:50 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 039LNqQZ133444;
        Thu, 9 Apr 2020 21:30:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=MKoaiJE892ogQi9MJkgkxyHIsK17J6JTkHiivbAxBmY=;
 b=P915doV1ZHqJfsq1FuIEpBmSZts5zY5W096kfiGt+NSG6UX5ExpMPmqgcR4awCh1YkfY
 0srVFQGBeL85IY3llLJ5k3/0hX56TxG6gdYDLUTVWa1WJvOSX6slTtHuzLm2C4X7pI4Z
 KQ0rtT0wM9F/0YY4fEpGZ1RR6MKpMmZJb/t/3vmi58suDJlWuWJuynnqX+xxWGxmZDwU
 vl5+wOnSwXEnmgfoJZ6/1X8I7Qus8cMfS4UW+RtNMsrID9WWUcIROB9ScrTMVZWPO8so
 V8dFTxc2wIl9TjvbCiDRhnell96KGxMvS18cP7CfWD4OS4WYIlxrhOWYx11PFdFPQKeY 7A== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 3091m13x9d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 09 Apr 2020 21:30:47 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 039LMolE003589;
        Thu, 9 Apr 2020 21:30:47 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 309ag5r05a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 09 Apr 2020 21:30:47 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 039LUkQT024388;
        Thu, 9 Apr 2020 21:30:46 GMT
Received: from ban25x6uut29.us.oracle.com (/10.153.73.29)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 09 Apr 2020 14:30:46 -0700
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com
Subject: [PATCH 1/3] KVM: nSVM: Check for CR0.CD and CR0.NW on VMRUN of nested guests
Date:   Thu,  9 Apr 2020 16:50:33 -0400
Message-Id: <20200409205035.16830-2-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200409205035.16830-1-krish.sadhukhan@oracle.com>
References: <20200409205035.16830-1-krish.sadhukhan@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9586 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=1 spamscore=0 malwarescore=0
 phishscore=0 mlxscore=0 bulkscore=0 mlxlogscore=959 suspectscore=1
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004090151
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9586 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999 mlxscore=0
 priorityscore=1501 phishscore=0 suspectscore=1 bulkscore=0
 lowpriorityscore=0 impostorscore=0 malwarescore=0 clxscore=1015
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004090151
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

According to section "Canonicalization and Consistency Checks" in APM vol. 2,
the following guest state combination is illegal:

	"CR0.CD is zero and CR0.NW is set"

Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
---
 arch/x86/kvm/svm/nested.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 90a1ca9..38e4c2b 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -207,6 +207,10 @@ static bool nested_vmcb_checks(struct vmcb *vmcb)
 	if ((vmcb->save.efer & EFER_SVME) == 0)
 		return false;
 
+	if (((vmcb->save.cr0 & X86_CR0_CD) == 0) &&
+	    (vmcb->save.cr0 & X86_CR0_NW))
+		return false;
+
 	if ((vmcb->control.intercept & (1ULL << INTERCEPT_VMRUN)) == 0)
 		return false;
 
-- 
1.8.3.1

