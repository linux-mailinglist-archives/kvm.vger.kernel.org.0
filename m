Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3E0B25C376
	for <lists+kvm@lfdr.de>; Thu,  3 Sep 2020 16:52:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729394AbgICOv7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Sep 2020 10:51:59 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:21452 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729212AbgICOOQ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 3 Sep 2020 10:14:16 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 083D3g9L035291;
        Thu, 3 Sep 2020 09:15:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=4qpPw2/GRlOatcNkFpg0D8lAaebK21qC3ebLj0yXURQ=;
 b=rKM0h88Z7knYC9kHo6/V1tYUgN9XZzCY5+hqtyfYlSaiunu/ouNiNCZahMt7sM74ZLcj
 zCgov1jvL9n5Rl+ATznSNSVFnSV+DLK5GVdtMt3gt/ArN+1y/EVgieM8S9WTWeGiBjfZ
 c2U5H5Ut9154O8fvoZYxUuN8T0L+3sV8fuSO+mgvpfoJ+DP2UR1b4cviBz/lppIxYPRy
 eG4GgKAJJTMQwlL1hNa4hNlk7Ow3Qv8RQsrl+T2ERVPZDnU7F5H/pMjikTYxP77Gm2Kr
 NCsL9CxzMPqzEnx5Pa3eutr96nY8Ak2fzGGj74mkbnimofKX8T7mb84qVkBn/KCxoTD3 6A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33ay61m499-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 03 Sep 2020 09:15:05 -0400
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 083D3l5F035634;
        Thu, 3 Sep 2020 09:15:04 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33ay61m481-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 03 Sep 2020 09:15:04 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 083D7QP0026017;
        Thu, 3 Sep 2020 13:15:02 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma03ams.nl.ibm.com with ESMTP id 337en8dv3q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 03 Sep 2020 13:15:02 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 083DExAk27197790
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 3 Sep 2020 13:14:59 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A5AAEAE051;
        Thu,  3 Sep 2020 13:14:59 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E3961AE053;
        Thu,  3 Sep 2020 13:14:58 +0000 (GMT)
Received: from linux01.pok.stglabs.ibm.com (unknown [9.114.17.81])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  3 Sep 2020 13:14:58 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     linux-s390@vger.kernel.org
Cc:     borntraeger@de.ibm.com, gor@linux.ibm.com, imbrenda@linux.ibm.com,
        kvm@vger.kernel.org, david@redhat.com
Subject: [PATCH 0/2] s390x: pv: Fixes and improvements
Date:   Thu,  3 Sep 2020 09:14:33 -0400
Message-Id: <20200903131435.2535-1-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-03_06:2020-09-03,2020-09-03 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 spamscore=0
 malwarescore=0 impostorscore=0 lowpriorityscore=0 suspectscore=1
 priorityscore=1501 phishscore=0 bulkscore=0 clxscore=1015 mlxlogscore=616
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009030122
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Using the destroy call instead of the export on a VM shutdown, we can
clear out a protected guest much faster.

The 3f exception can in fact be triggered by userspace and therefore
should not panic the whole system, but send a SIGSEGV to the culprit
process.

Janosch Frank (2):
  s390x: uv: Add destroy page call
  s390x: Add 3f program exception handler

 arch/s390/include/asm/uv.h   |  7 +++++++
 arch/s390/kernel/pgm_check.S |  2 +-
 arch/s390/kernel/uv.c        | 21 +++++++++++++++++++++
 arch/s390/mm/fault.c         | 23 +++++++++++++++++++++++
 arch/s390/mm/gmap.c          |  2 +-
 5 files changed, 53 insertions(+), 2 deletions(-)

-- 
2.25.1

