Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4518048E809
	for <lists+kvm@lfdr.de>; Fri, 14 Jan 2022 11:05:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240227AbiANKEC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Jan 2022 05:04:02 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:49500 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237537AbiANKEC (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 14 Jan 2022 05:04:02 -0500
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20E9rU3N017405;
        Fri, 14 Jan 2022 10:04:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=sg3TXSVfqjrM14IdX7dmR/Od6hvrPhGZKRO5di3LJws=;
 b=iQQlFCvxT4ZvWpDcTUaA3VXP22E7IhOmBCAwGvtB1u5pvBujTqWtYiF1p2pSVaY1+uAn
 Qv9BF3fePyffAXxwHPoyqytAjWWbHzV932EfNET4MWTiQ7CYgJ5ZizO0pFKy8qtS/KJ0
 g8HD/uWr1Exfl4ULfmBTOm0Ot51b6I3NQd1ztz1+5zErkw/Bjr2Ny/7v+9sdVTrtz4/x
 n9s5jU124wOX1ivYVHbUprd+xCzLeO8yrgz0n/dnPwcDIAm6TejnP2yZHQN5LC5vVI+A
 zmTSnqbksdlbUd+ujwhNXGtSJdsvmtIlYX9KkY51D2LnwKPPH3P/w0OU9LWXZrtLstqA qA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dk6xmg66x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Jan 2022 10:04:01 +0000
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20EA0Wlu005765;
        Fri, 14 Jan 2022 10:04:01 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dk6xmg66f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Jan 2022 10:04:00 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20E9vTdM017686;
        Fri, 14 Jan 2022 10:03:58 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma03fra.de.ibm.com with ESMTP id 3df28a282w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Jan 2022 10:03:58 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20E9slEc49873386
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 14 Jan 2022 09:54:47 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5543A11C054;
        Fri, 14 Jan 2022 10:03:55 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7F21B11C05B;
        Fri, 14 Jan 2022 10:03:54 +0000 (GMT)
Received: from linux6.. (unknown [9.114.12.104])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 14 Jan 2022 10:03:54 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        david@redhat.com, thuth@redhat.com, cohuck@redhat.com,
        nrb@linux.ibm.com
Subject: [kvm-unit-tests PATCH 0/5] s390x: Allocation and hosting environment detection fixes
Date:   Fri, 14 Jan 2022 10:02:40 +0000
Message-Id: <20220114100245.8643-1-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 0RdCb2IGUlHeUbRmwEyk1XN2w71R5Xzb
X-Proofpoint-ORIG-GUID: CvyhemeqNUcyzoU1ZzSVQJx6kdLwp7Kh
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-14_03,2022-01-14_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 impostorscore=0
 adultscore=0 mlxlogscore=999 suspectscore=0 spamscore=0 malwarescore=0
 bulkscore=0 priorityscore=1501 lowpriorityscore=0 phishscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2201140063
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

I took some time before Christmas to write a test runner for lpar
which automatically runs all tests and sends me the logs. It's based
on the zhmc library to control starting and stopping of the lpar and
works by having a menu entry for each kvm unit test.

This revealed a number of test fails when the tests are run under lpar
as there are a few differences:
   * lpars most often have a very high memory amount (upwards of 8GB)
     compared to our qemu env (256MB)
   * lpar supports diag308 subcode 2
   * lpar does not provide virtio devices

The higher memory amount leads to allocations crossing the 2GB or 4GB
border which made sclp and sigp calls fail that expect 31/32 bit
addresses.

Janosch Frank (5):
  lib: s390x: vm: Add kvm and lpar vm queries
  s390x: css: Skip if we're not run by qemu
  s390x: diag308: Only test subcode 2 under QEMU
  s390x: smp: Allocate memory in DMA31 space
  s390x: firq: Fix sclp buffer allocation

 lib/s390x/vm.c  | 39 +++++++++++++++++++++++++++++++++++++++
 lib/s390x/vm.h  | 23 +++++++++++++++++++++++
 s390x/css.c     | 10 +++++++++-
 s390x/diag308.c | 15 ++++++++++++++-
 s390x/firq.c    |  2 +-
 s390x/smp.c     |  4 ++--
 s390x/stsi.c    | 21 +--------------------
 7 files changed, 89 insertions(+), 25 deletions(-)

-- 
2.32.0

