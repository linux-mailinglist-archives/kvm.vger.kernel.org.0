Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37237285211
	for <lists+kvm@lfdr.de>; Tue,  6 Oct 2020 21:07:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727010AbgJFTHJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Oct 2020 15:07:09 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:57530 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727005AbgJFTHJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Oct 2020 15:07:09 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 096IxQOq088675;
        Tue, 6 Oct 2020 19:07:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id; s=corp-2020-01-29;
 bh=ndSK4g9KZoHOQRn8n6rYfB8krcATpjQavrXaq/WBQRQ=;
 b=mVAQDFa7oxkodt+nctOuWNww57z0WutnQeig/T4AUJJ0dnn7LWchMAFg6TKmXq6xAVsZ
 8pDSVoVTNH6aUe8fh0YcSYmt1lki3qTNnePSKEqVT4Z/0q7cssmI39FrLhMwKVDf/2rd
 eO8FqhnMc6rzb7X7LPsgRUZ0T23x2YWNZRaUAXlDufHZgrt19Y50zLxBaZSZaWjfogxV
 tRwpO54yX+i8Xb8vCnr1VgzOzVcf6AKqgqgb+ZS0CWBQZCtFwwbUXPpWwD836HcHU6hD
 LIk0lmXg2pcde1F49CtBc+43dsLfAc6iZrxQLIDPYp/OEg5mqOKItbb00D2lwtDBVONp Yw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 33xhxmwuqc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 06 Oct 2020 19:07:04 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 096J1HiI134063;
        Tue, 6 Oct 2020 19:07:04 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 33y2vnep17-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 06 Oct 2020 19:07:04 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 096J72Gu004242;
        Tue, 6 Oct 2020 19:07:02 GMT
Received: from nsvm-sadhukhan-1.osdevelopmeniad.oraclevcn.com (/100.100.230.216)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 06 Oct 2020 12:07:02 -0700
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com,
        sean.j.christopherson@intel.com
Subject: [PATCH 0/4 v3] KVM: nSVM: Add checks for CR3 and CR4 reserved bits to svm_set_nested_state() and test CR3 non-MBZ reserved bits
Date:   Tue,  6 Oct 2020 19:06:50 +0000
Message-Id: <20201006190654.32305-1-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.18.4
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9766 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=803
 malwarescore=0 suspectscore=1 spamscore=0 phishscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2010060123
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9766 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 bulkscore=0
 impostorscore=0 lowpriorityscore=0 suspectscore=1 phishscore=0
 mlxlogscore=822 adultscore=0 clxscore=1015 spamscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010060123
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

v2 -> v3:
	Patch# 2: The local variable "nested_vmcb_lma" in
		  nested_vmcb_check_cr3_cr4() has been removed.
	Patch# 3: Commit message has been enhanced to explain what the test
		  is doing and why, when testing the 1-setting of the
		  non-MBZ-reserved bits.
		  Also, the test for legacy-PAE mode has been added. Commit
		  header reflects this addition.


[PATCH 1/4 v3] KVM: nSVM: CR3 MBZ bits are only 63:52
[PATCH 2/4 v3] KVM: nSVM: Add check for reserved bits for CR3, CR4, DR6,
[PATCH 3/4 v3] nSVM: Test non-MBZ reserved bits in CR3 in long mode and
[PATCH 4/4 v3] KVM: nSVM: nested_vmcb_checks() needs to check all bits

 arch/x86/kvm/svm/nested.c | 52 ++++++++++++++++++++++++++---------------------
 arch/x86/kvm/svm/svm.h    |  2 +-
 2 files changed, 30 insertions(+), 24 deletions(-)

Krish Sadhukhan (3):
      KVM: nSVM: CR3 MBZ bits are only 63:52
      KVM: nSVM: Add check for reserved bits for CR3, CR4, DR6, DR7 and EFER to svm_set_nested_state()
      KVM: nSVM: nested_vmcb_checks() needs to check all bits of EFER

 x86/svm.h       |  4 +++-
 x86/svm_tests.c | 66 +++++++++++++++++++++++++++++++++++++++++++++++++++------
 2 files changed, 63 insertions(+), 7 deletions(-)

Krish Sadhukhan (1):
      nSVM: Test non-MBZ reserved bits in CR3 in long mode and legacy PAE mode

