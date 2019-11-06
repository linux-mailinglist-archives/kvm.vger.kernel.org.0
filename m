Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 23EBFF157E
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2019 12:56:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730485AbfKFL4J (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Nov 2019 06:56:09 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:37270 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730120AbfKFL4I (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Nov 2019 06:56:08 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA6BsP9Q061515;
        Wed, 6 Nov 2019 11:55:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id; s=corp-2019-08-05;
 bh=vtOUSXhJOWeZNpYZPR4dz6ez1tfCq89k9rogWBbRY90=;
 b=ECBRyQrD0dB8jrv1x0LFRvrc3cO7pcmPZUyPQGkc0oeGvRC73YV890LmonDGPACREL6y
 YWlri1SAXf8V1f945+9v5YESTe5WG3i4AO7htghuicupNcHnHrQCUcUGOsDAdy8WoFJO
 cvu0V6LPTUpk3Z8d62q6LNGRk61MrH/UNilOktZ+mJCBMd67IrAbsjm+bHd3qGXvMd2R
 PasgF+xa0/w4FN0FSLu27OvmkKjZiryzze63TcnBDVgAvqWDlAVpFyfHQfsMRKROe0f8
 +AcOcxOQrVQYvfmie7U5TPGmuqQ0lOjdBmi3rIIUpE0jLb3avuFfEUxSwbGtOe3V7s5I NQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2w117u5p8d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 06 Nov 2019 11:55:41 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA6BsHBb051668;
        Wed, 6 Nov 2019 11:55:40 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2w31639sd8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 06 Nov 2019 11:55:40 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xA6Btda5021392;
        Wed, 6 Nov 2019 11:55:39 GMT
Received: from z2.cn.oracle.com (/10.182.71.218)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 06 Nov 2019 03:55:39 -0800
From:   Zhenzhong Duan <zhenzhong.duan@oracle.com>
To:     linux-kernel@vger.kernel.org
Cc:     pbonzini@redhat.com, rkrcmar@redhat.com,
        rafael.j.wysocki@intel.com, joao.m.martins@oracle.com,
        mtosatti@redhat.com, kvm@vger.kernel.org, linux-pm@vger.kernel.org,
        Zhenzhong Duan <zhenzhong.duan@oracle.com>
Subject: [PATCH RESEND v2 0/4] misc fixes on halt-poll code for both KVM and guest
Date:   Wed,  6 Nov 2019 19:54:58 +0800
Message-Id: <1573041302-4904-1-git-send-email-zhenzhong.duan@oracle.com>
X-Mailer: git-send-email 1.8.3.1
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9432 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1911060119
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9432 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1911060119
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

