Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8E9BFF73D4
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2019 13:26:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726927AbfKKM0p (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Nov 2019 07:26:45 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:40422 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726810AbfKKM0p (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Nov 2019 07:26:45 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xABCOPCK029593;
        Mon, 11 Nov 2019 12:26:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding;
 s=corp-2019-08-05; bh=r1rjcAgGAp5ZY3/IGNXNwWzPRleq75n5kBIEIXj0QQQ=;
 b=NR6i4N4OtzWbs/JtyaLFfuVypnSvE17e3PrXVg3akcIaMtRDg7g1qSQkNMrzmXnxuID8
 +cxO4KQ6MRdZIigtBMHk8BFCDNATU6QcWAOJGRct7O+g0bq9Wlpdd9PCI/Fe83LxuuAJ
 rjIn+OdO91a/1R8G9iOkm5AXkRTmElBiTs2lTlsMb+iDTuY4UfEGoSW0WE06iueySRi1
 sFcAWgB5XrLOknDWdMmy8pOGfdMZL69KejxcFGzXQnxkJuLmxzPHfj/yU+ngtfJ9cpq0
 tK3ZSAGZKirjARKhyjbztf7r86Qr1NoZXt2glLD6JXcqgn+v7FV5tV7vhlraao/Zr/3N +A== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2w5mvtes4y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 11 Nov 2019 12:26:38 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xABCNQSQ058167;
        Mon, 11 Nov 2019 12:26:37 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 2w67kkx1cw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 11 Nov 2019 12:26:37 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xABCQaQR004949;
        Mon, 11 Nov 2019 12:26:36 GMT
Received: from Lirans-MBP.Home (/79.182.207.213)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 11 Nov 2019 12:26:36 +0000
From:   Liran Alon <liran.alon@oracle.com>
To:     pbonzini@redhat.com, rkrcmar@redhat.com, kvm@vger.kernel.org
Cc:     sean.j.christopherson@intel.com, jmattson@google.com,
        vkuznets@redhat.com, Liran Alon <liran.alon@oracle.com>,
        Joao Martins <joao.m.martins@oracle.com>
Subject: [PATCH] KVM: SVM: Remove check if APICv enabled in SVM update_cr8_intercept() handler
Date:   Mon, 11 Nov 2019 14:26:21 +0200
Message-Id: <20191111122621.93151-1-liran.alon@oracle.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9437 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=891
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1910280000 definitions=main-1911110118
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9437 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=967 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1910280000
 definitions=main-1911110118
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This check is unnecessary as x86 update_cr8_intercept() which calls
this VMX/SVM specific callback already performs this check.

Reviewed-by: Joao Martins <joao.m.martins@oracle.com>
Signed-off-by: Liran Alon <liran.alon@oracle.com>
---
 arch/x86/kvm/svm.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index c5673bda4b66..8d729da932cc 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -5092,8 +5092,7 @@ static void update_cr8_intercept(struct kvm_vcpu *vcpu, int tpr, int irr)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 
-	if (svm_nested_virtualize_tpr(vcpu) ||
-	    kvm_vcpu_apicv_active(vcpu))
+	if (svm_nested_virtualize_tpr(vcpu))
 		return;
 
 	clr_cr_intercept(svm, INTERCEPT_CR8_WRITE);
-- 
2.20.1

