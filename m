Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4611C1DF2AA
	for <lists+kvm@lfdr.de>; Sat, 23 May 2020 01:04:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731326AbgEVXEg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 May 2020 19:04:36 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:33734 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731172AbgEVXEf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 May 2020 19:04:35 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04MMvf1f092961;
        Fri, 22 May 2020 23:04:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding;
 s=corp-2020-01-29; bh=JDd24BPdU+v62tY3JmeAZX7WaTP05ObDjhEy0k0eGIk=;
 b=cIECRAGQbaMPcgmKLHTprCNoyi1++xmZlDT3NqhzE9P4i3LhN0q/Jm7qtDTK8grBgiYH
 Uu4JQd2nofwG6BfaqNstH5Mfg7Fl8HihJFEl5IwmW6KNtP0rJ6MjAXg6Zb1dBYXhbHql
 lTN5OXX5wT6EBmuHGuKWau7BRWp3Zn0/XUdV2kZprAqvxq9NZa8CY/qXRPveeUeR+40l
 03qmkW/QuG6Cbt8FhPPe/zz5zthNNtwxeoqEBCUA6L4/d9IRIpMdqj5iesF5o4v5/i9t
 y1gCmbYSFvtwjQU+Kg8Yo5mzsUp/Io6WfJpK3sV17PrL+effl2lnvyHO5cRpk7jdkmfv aw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 316qrvr1fm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 22 May 2020 23:04:32 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04MMwbFf032301;
        Fri, 22 May 2020 23:02:32 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 314gmbxt6b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 May 2020 23:02:32 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 04MN2V2G007578;
        Fri, 22 May 2020 23:02:31 GMT
Received: from ban25x6uut29.us.oracle.com (/10.153.73.29)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 22 May 2020 16:02:31 -0700
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com
Subject: [PATCH 0/4] KVM: nSVM: Check reserved bits in DR6, DR7 and EFER on vmrun of nested guests
Date:   Fri, 22 May 2020 18:19:50 -0400
Message-Id: <20200522221954.32131-1-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9629 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=782
 adultscore=0 phishscore=0 mlxscore=0 spamscore=0 suspectscore=1
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005220179
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9629 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 impostorscore=0
 malwarescore=0 cotscore=-2147483648 suspectscore=1 adultscore=0
 phishscore=0 clxscore=1015 priorityscore=1501 lowpriorityscore=0
 mlxlogscore=817 spamscore=0 bulkscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005220179
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Patch# 1: Moves the check for upper 32 reserved bits of DR6 to a new function.
Patch# 2: Adds the KVM checks for DR6[63:32] and DR7[64:32] reserved bits
Patch# 3: Adds kvm-unit-tests for DR6[63:32] and DR7[64:32] reserved bits and
	  reserved bits in EFER
Patch# 4: Removes the duplicate definition of 'vmcb' that sneaked via one of
	  my previous patches.


[PATCH 1/4] KVM: x86: Move the check for upper 32 reserved bits of
[PATCH 2/4] KVM: nSVM: Check that DR6[63:32] and DR7[64:32] are not
[PATCH 3/4] kvm-unit-tests: nSVM: Test that DR6[63:32], DR7[63:32]
[PATCH 4/4] kvm-unit-tests: x86: Remove duplicate instance of 'vmcb'

 arch/x86/kvm/svm/nested.c | 3 +++
 arch/x86/kvm/x86.c        | 2 +-
 arch/x86/kvm/x86.h        | 5 +++++
 3 files changed, 9 insertions(+), 1 deletion(-)

Krish Sadhukhan (2):
      KVM: x86: Move the check for upper 32 reserved bits of DR6 to separate fun
      KVM: nVMX: Check that DR6[63:32] and DR7[64:32] are not set on vmrun of ne
 x86/svm.c       |  1 -
 x86/svm.h       |  3 +++
 x86/svm_tests.c | 59 ++++++++++++++++++++++++++++++++++++++-------------------
 3 files changed, 42 insertions(+), 21 deletions(-)

Krish Sadhukhan (2):
      kvm-unit-tests: nSVM: Test that DR6[63:32], DR7[63:32] and EFER reserved b
      kvm-unit-tests: x86: Remove duplicate instance of 'vmcb'

