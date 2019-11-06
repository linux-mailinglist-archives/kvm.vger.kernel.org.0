Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C600FF11C1
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2019 10:09:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728256AbfKFJJf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Nov 2019 04:09:35 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:45618 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727041AbfKFJJe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Nov 2019 04:09:34 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA6990N6090942;
        Wed, 6 Nov 2019 09:09:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id; s=corp-2019-08-05;
 bh=vtOUSXhJOWeZNpYZPR4dz6ez1tfCq89k9rogWBbRY90=;
 b=j2sxpBb/lPk6e1dqkColY5vG17mDQmIPt4iVQK1+2HUYK5wbbvi6oMc1BF3ahclFly3l
 E+eLHsmK/xeAnBrlQJGA5/1O8OrSPd3DT75xwFL914AdOK8ALKt5x8mqFR4frnMd7+z7
 qFKGRf82F909hXBBkpKrLrogskVGebi7mXWMPsXXfS5yQ4wSP/7j26UD2WXAOU+pArip
 b8RorxKwywk0k4PCn5tWZv953Mo/quv2oXWRr9ie3oI+WDuUzPOAlhfw47dAIrWO618A
 uBBFOBZtsPPDus3sqdggL9usJRw8C59LIym6ehNTTC8P+Xf2wW18qrXpK+7179CQe/Oh Cw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2w12erca4k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 06 Nov 2019 09:09:23 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA698rXT015312;
        Wed, 6 Nov 2019 09:09:22 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2w31631dsm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 06 Nov 2019 09:09:22 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xA699LR2006042;
        Wed, 6 Nov 2019 09:09:21 GMT
Received: from z2.cn.oracle.com (/10.182.71.218)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 06 Nov 2019 01:09:21 -0800
From:   Zhenzhong Duan <zhenzhong.duan@oracle.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, rkrcmar@redhat.com,
        rafael.j.wysocki@intel.com, joao.m.martins@oracle.com,
        mtosatti@redhat.com, Zhenzhong Duan <zhenzhong.duan@oracle.com>
Subject: [PATCH v2 0/4] misc fixes on halt-poll code both KVM and guest
Date:   Wed,  6 Nov 2019 17:08:48 +0800
Message-Id: <1573031332-2121-1-git-send-email-zhenzhong.duan@oracle.com>
X-Mailer: git-send-email 1.8.3.1
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9432 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1911060096
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9432 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1911060096
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patchset tries to fix below issues:

1. Admin could set halt_poll_ns to 0 at runtime to disable poll and kernel
behave just like the generic halt driver. Then If guest_halt_poll_grow_start
is set to 0 and guest_halt_poll_ns set to nonzero later, cpu_halt_poll_us will
never grow beyond 0. The first two patches fix this issue from both kvm and
guest side.

2. guest_halt_poll_grow_start and guest_halt_poll_ns could be adjusted at
runtime by admin, this could make a window where cpu_halt_poll_us jump out
of the boundary. the window could be long in some cases(e.g. guest_halt_poll_grow_start
is bumped and cpu_halt_poll_us is shrinking) The last two patches fix this
issue from both kvm and guest side.

3. The 4th patch also simplifies branch check code.

v2:
Rewrite the patches and drop unnecessory changes

Zhenzhong Duan (4):
  cpuidle-haltpoll: ensure grow start value is nonzero
  KVM: ensure grow start value is nonzero
  cpuidle-haltpoll: ensure cpu_halt_poll_us in right scope
  KVM: ensure vCPU halt_poll_us in right scope

 drivers/cpuidle/governors/haltpoll.c | 50 ++++++++++++++++++++++++-----------
 virt/kvm/kvm_main.c                  | 51 ++++++++++++++++++++++++------------
 2 files changed, 68 insertions(+), 33 deletions(-)

-- 
1.8.3.1

