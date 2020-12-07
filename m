Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FBE82D19EF
	for <lists+kvm@lfdr.de>; Mon,  7 Dec 2020 20:46:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726744AbgLGTo2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Dec 2020 14:44:28 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:56404 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725822AbgLGTo1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Dec 2020 14:44:27 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B7JdqUu004059;
        Mon, 7 Dec 2020 19:43:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding;
 s=corp-2020-01-29; bh=dQzv5Yngcb2G7uGdsv+4ZRDkPEbGpTwdACNd/Um74SU=;
 b=cNFYRZeBTmflvcKvsafSBX6Ena+CB6i4TUnxfpidnZncpWHHoU5lbkJER7+YEzDyq72Y
 bICKeIEttcVoPvb4IUJL8j7kXWf7l4VQbJ+8mjhRmtjOLTeLqLaGOsQti6Q34Q67Xf1y
 FQrmWvx/t8IFjM2nMM2qsuNtALEplZErNor8F4qO60ej/mutGM2Q87BBRySV6cOnk7Us
 ofi2G8zmbOkWq1U5oQ77wExcLsoWSVWOPZ4VCWGe4tyASp1Z8gmf2HmkMHDIWZcMtA7j
 NtX7/RNfD89rzZYxeiCDUnHLZc6WjSohPHjhjMD8H2LKBeVrUM08ZWYitXnJmSfEco7B cg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 3581mqq6g7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 07 Dec 2020 19:43:42 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B7JeiB3044479;
        Mon, 7 Dec 2020 19:41:42 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 358ksmn0x5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 07 Dec 2020 19:41:42 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0B7JfeNO013137;
        Mon, 7 Dec 2020 19:41:41 GMT
Received: from nsvm-sadhukhan.osdevelopmeniad.oraclevcn.com (/100.100.230.216)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 07 Dec 2020 11:41:40 -0800
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com
Subject: [PATCH 0/2 v4] KVM: nSVM: Check reserved values for 'Type' and invalid vectors in EVENTINJ
Date:   Mon,  7 Dec 2020 19:41:27 +0000
Message-Id: <20201207194129.7543-1-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9828 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=940 suspectscore=1
 bulkscore=0 malwarescore=0 phishscore=0 mlxscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012070126
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9828 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 mlxlogscore=954
 clxscore=1015 malwarescore=0 priorityscore=1501 adultscore=0
 lowpriorityscore=0 phishscore=0 spamscore=0 impostorscore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012070126
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

v3 -> v4:
	1. Changed storage type of local variables, 'type' and 'vector' in
	   patch# 1, from u32 to u8.
	2. Fixed build breakage due to missing parentheses around logical
	   operators. The second check has also been split into two 'if-else'
	   conditionals.

[PATCH 1/2 v4] KVM: nSVM: Check reserved values for 'Type' and invalid
[PATCH 2/2 v4] nSVM: Test reserved values for 'Type' and invalid vectors in

 arch/x86/include/asm/svm.h |  4 ++++
 arch/x86/kvm/svm/nested.c  | 14 ++++++++++++++
 2 files changed, 18 insertions(+)

Krish Sadhukhan (1):
      KVM: nSVM: Check reserved values for 'Type' and invalid vectors in EVENTINJ

 x86/svm_tests.c | 38 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)

Krish Sadhukhan (1):
      nSVM: Test reserved values for 'Type' and invalid vectors in EVENTINJ

