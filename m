Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D53263859C
	for <lists+kvm@lfdr.de>; Fri, 25 Nov 2022 09:55:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229670AbiKYIz2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Nov 2022 03:55:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229612AbiKYIzZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Nov 2022 03:55:25 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 424AF31ED6;
        Fri, 25 Nov 2022 00:55:23 -0800 (PST)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AP7hYKt028857;
        Fri, 25 Nov 2022 08:55:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : content-transfer-encoding : mime-version; s=pp1;
 bh=yKRuacamC/zaV++38R2n1Rkm7n99IrLytfZ7OsL8M/c=;
 b=HzslMV6bMAAk6Cvte/mTrUq0+29E8o6oXxWQsVaKSIBpjeeQTFvkjbUjDVlAd5K4aKFN
 9QmYGHvz8BiTdRxadD0GYmlvl9W1Y3YbUHDZEF0ZbCmG+pp3CIzg2PEW93jul5qUcksV
 4hOfownUl5pz35ElCztGxx5Tf/E9G+JLq/7hvDVR9DgTzXbPgGW7kY6foYt2pwu/adjM
 oUdflmkEdtSx51j0tJ9JX4IAUeKdDfnGpX2bHV0Dhiw6E05p3k1mds8tfe5tp8ORga/k
 8A1uw1P0+ygQwo7ZkHmZYuFQ0YNCy2QO4tvQFYRk8gfJL4I9F5hoM4oerMdxVCW9KBvK UQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3m2sjs1jdh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 25 Nov 2022 08:55:22 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2AP8bPv2021845;
        Fri, 25 Nov 2022 08:55:22 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3m2sjs1jcu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 25 Nov 2022 08:55:22 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2AP8pUkq010014;
        Fri, 25 Nov 2022 08:55:20 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma04fra.de.ibm.com with ESMTP id 3kxps8xqf0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 25 Nov 2022 08:55:19 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2AP8mwK810748440
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 25 Nov 2022 08:48:58 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D91375204F;
        Fri, 25 Nov 2022 08:55:16 +0000 (GMT)
Received: from li-9fd7f64c-3205-11b2-a85c-df942b00d78d.ibm.com.com (unknown [9.171.63.115])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 6BF255204E;
        Fri, 25 Nov 2022 08:55:16 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        borntraeger@de.ibm.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org, imbrenda@linux.ibm.com
Subject: [GIT PULL 0/1] s390 fixes for 6.1-rc7/8
Date:   Fri, 25 Nov 2022 09:54:53 +0100
Message-Id: <20221125085454.16673-1-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.38.1
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: DcW-VDoHZwN1qQOjO9397T2UvcsxCuZq
X-Proofpoint-GUID: TJOHjzbwLKqt0ImMXr_j9e7V7dVopQ0A
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-25_02,2022-11-24_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 adultscore=0 mlxlogscore=671 spamscore=0 malwarescore=0 bulkscore=0
 impostorscore=0 mlxscore=0 clxscore=1015 priorityscore=1501 phishscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211250069
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Dear Paolo,

please pull Thomas' fix for VSIE.
We deem it to be low risk and it survived a day in our CI without any errors.
It's a bit late so let's see if it makes 6.1 or 6.2.


The following changes since commit eb7081409f94a9a8608593d0fb63a1aa3d6f95d8:

  Linux 6.1-rc6 (2022-11-20 16:02:16 -0800)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/kvms390/linux.git tags/kvm-s390-master-6.1-2

for you to fetch changes up to 0dd4cdccdab3d74bd86b868768a7dca216bcce7e:

  KVM: s390: vsie: Fix the initialization of the epoch extension (epdx) field (2022-11-24 14:43:17 +0100)

----------------------------------------------------------------
VSIE epdx shadowing fix

----------------------------------------------------------------
Thomas Huth (1):
      KVM: s390: vsie: Fix the initialization of the epoch extension (epdx) field

 arch/s390/kvm/vsie.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

Thomas Huth (1):
  KVM: s390: vsie: Fix the initialization of the epoch extension (epdx)
    field

 arch/s390/kvm/vsie.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

-- 
2.38.1

