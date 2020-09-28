Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6551C27A87B
	for <lists+kvm@lfdr.de>; Mon, 28 Sep 2020 09:23:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726522AbgI1HXL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Sep 2020 03:23:11 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:54482 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725290AbgI1HXK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Sep 2020 03:23:10 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08S7Jtco168897;
        Mon, 28 Sep 2020 07:23:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id; s=corp-2020-01-29;
 bh=d7ZEO5jR7hJyMp821h2Wa5X71XbFJtbszhz+p47YXkc=;
 b=QCZtw2V7qj3icgc8fdhReaVM2kPsmXoaMmfrDWDOC06/jPV+g4yurEKxGzWj+woGFu4C
 iWWRL11uQL9wd/ebQsOzXVrCJqRCOm+EtxypSqJoVy7prMlB7s3iH3zLibB4vEWCY8+G
 eX/X3yYbfZ4QdPKBuAiFtZpwvcVgu7tCmXgFVbGtX0V4stvDPkbtyCHgiKDh6Jl3oTTe
 MQO2rRM9+hq7F/B68gNXPiA06dnoHNI0lReymd8tfg/MO/kFBnCaXF+Z1PtdhHIhWlrL
 JakL13vFCVSCez+eMGZPqPGsG8OKshb+p4lweuepcGwn27+Q9/ccW2OcrGRm4FvbLl/G nw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 33su5akgy4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 28 Sep 2020 07:23:07 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08S7KMiZ187025;
        Mon, 28 Sep 2020 07:21:06 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 33tfhvwkya-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 28 Sep 2020 07:21:06 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 08S7L6KR024050;
        Mon, 28 Sep 2020 07:21:06 GMT
Received: from nsvm-sadhukhan-1.osdevelopmeniad.oraclevcn.com (/100.100.230.216)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 28 Sep 2020 00:21:06 -0700
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com
Subject: [PATCH 0/4 v2] KVM: nSVM: Add checks for CR3 and CR4 reserved bits to svm_set_nested_state() and test CR3 non-MBZ reserved bits
Date:   Mon, 28 Sep 2020 07:20:39 +0000
Message-Id: <20200928072043.9359-1-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.18.4
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9757 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=591 bulkscore=0
 phishscore=0 malwarescore=0 adultscore=0 suspectscore=1 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009280061
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9757 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=597 suspectscore=1
 lowpriorityscore=0 spamscore=0 clxscore=1015 mlxscore=0 impostorscore=0
 malwarescore=0 phishscore=0 adultscore=0 bulkscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009280061
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

v1 -> v2:
	1. Patch# 2 has added checks for DR6, DR7 and EFER to
	   SVM_SET_NESTED_STATE path.
	2. Patch# 4 is a new addition. It has added missing checks for EFER
	   to nested_vmcb_checks().

[PATCH 1/4 v2] KVM: nSVM: CR3 MBZ bits are only 63:52
[PATCH 2/4 v2] KVM: nSVM: Add check for reserved bits for CR3, CR4, DR6,
[PATCH 3/4 v2] KVM: nSVM: Test non-MBZ reserved bits in CR3 in long mode
[PATCH 4/4 v2] KVM: nSVM: nested_vmcb_checks() needs to check all bits of

 arch/x86/kvm/svm/nested.c | 58 ++++++++++++++++++++++++++++-------------------
 arch/x86/kvm/svm/svm.h    |  2 +-
 2 files changed, 36 insertions(+), 24 deletions(-)

Krish Sadhukhan (3):
      KVM: nSVM: CR3 MBZ bits are only 63:52
      KVM: nSVM: Add check for reserved bits for CR3, CR4, DR6, DR7 and EFER to 
svm_set_nested_state()
      KVM: nSVM: nested_vmcb_checks() needs to check all bits of EFER

 x86/svm.h       |  3 ++-
 x86/svm_tests.c | 52 ++++++++++++++++++++++++++++++++++++++++++++++------
 2 files changed, 48 insertions(+), 7 deletions(-)

Krish Sadhukhan (1):
      KVM: nSVM: Test non-MBZ reserved bits in CR3 in long mode

