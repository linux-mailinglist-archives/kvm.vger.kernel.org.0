Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 417BF2D83A3
	for <lists+kvm@lfdr.de>; Sat, 12 Dec 2020 01:52:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437960AbgLLAvN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Dec 2020 19:51:13 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:42106 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2437958AbgLLAvM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Dec 2020 19:51:12 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BC0niHA166558;
        Sat, 12 Dec 2020 00:50:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding;
 s=corp-2020-01-29; bh=igKxMZyLu4/sV0lA9v0QTSehubi/Tj7ZO0Kl+RVJikM=;
 b=xPzhO1XEw7PcZ6c+gUdIiCgLy+IwCDx/t0OfQMKKpNfeBD09IewqPzBJIQWZ3eDMyJ+M
 4NbSBj3wX710kyyHgNKTmIdyWdOqGTZCsxb+/CityEMDCN1R++NbN8VnyA3mgg/HMFbI
 ZKbirmauk10hnAOJNr9849sUima9IcE+B//VBeBurBr87KuENXWJpaxnci3ExjtEvmHy
 iHTzc3+Yyk+DbC55F59S1hTaUPplTjOATkxsXQEKZhKYBwNtnzKWYOgjznkQHDp2ztFB
 CzCrhtT1PFy1iecR4oD+piSLwcTWQt0EBVkBYVz5wE2lWnRq9w/racY4+waegT+adxWM 6Q== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 35ckcb00ve-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sat, 12 Dec 2020 00:50:28 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BC0nsC3099681;
        Sat, 12 Dec 2020 00:50:27 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 35cjyqsb5f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 12 Dec 2020 00:50:27 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0BC0oQCi028640;
        Sat, 12 Dec 2020 00:50:26 GMT
Received: from nsvm-sadhukhan.osdevelopmeniad.oraclevcn.com (/100.100.230.216)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 11 Dec 2020 16:50:26 -0800
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, seanjc@google.com, jmattson@google.com
Subject: [PATCH 0/2 v5] KVM: nSVM: Check reserved values for 'Type' and invalid vectors in EVENTINJ
Date:   Sat, 12 Dec 2020 00:50:17 +0000
Message-Id: <20201212005019.6807-1-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9832 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=769 malwarescore=0
 phishscore=0 suspectscore=0 mlxscore=0 bulkscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012120004
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9832 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=783
 priorityscore=1501 mlxscore=0 suspectscore=0 adultscore=0 phishscore=0
 malwarescore=0 impostorscore=0 lowpriorityscore=0 clxscore=1015
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012120004
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

v4 -> v5:
	1. In patch# 1, the storage for the 'type' variable has been changed
	   back to u32.
	2. In patch# 1, the two 'if' conditions in the second check have been
	   merged into one.


[PATCH 1/2 v5] KVM: nSVM: Check reserved values for 'Type' and invalid
[PATCH 2/2 v5] nSVM: Test reserved values for 'Type' and invalid vectors in

 arch/x86/include/asm/svm.h |  4 ++++
 arch/x86/kvm/svm/nested.c  | 15 +++++++++++++++
 2 files changed, 19 insertions(+)

Krish Sadhukhan (1):
      KVM: nSVM: Check reserved values for 'Type' and invalid vectors in EVENTINJ

 x86/svm_tests.c | 38 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)

Krish Sadhukhan (1):
      nSVM: Test reserved values for 'Type' and invalid vectors in EVENTINJ

