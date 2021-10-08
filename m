Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B5B942724C
	for <lists+kvm@lfdr.de>; Fri,  8 Oct 2021 22:31:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242508AbhJHUdc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Oct 2021 16:33:32 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:15384 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231676AbhJHUd1 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 8 Oct 2021 16:33:27 -0400
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 198KRHCA022477;
        Fri, 8 Oct 2021 16:31:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=2nXIb1u4kqUeETeWflUlMEE7hZXglSDxhoEGVS8xNdQ=;
 b=n1icevd2190cYy7RyOQxq+gjGME3RQuZlChrbdj7CritlwdL14LlASY9s0cUDW9cTNdY
 kWHoPIMElTIcasMR0ie7wkXlQLXQvNjxDT47KbNyr9deVTRAQH88gwd9VVlPdRpqGKz2
 lfQOfWQfUf7TBpVp4WcwME28eeNh2CyfxWwUxTXQWSf7OWIOcTgfg0rZ09Dlolym4eOm
 xjFyZmbK1exSxLmkZ6uRlW+fiiqnvK3QNHct+UNlS34bIY5nRSfgQcgulEMirs8hX/Kc
 MD8zV1AJMpPghBmUoUA/hSW4HalhxNd6vrbhfRtS3kQm9kcb4I+i++nyW3QPtnnPmkZr Tg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bjvtd0cew-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 08 Oct 2021 16:31:31 -0400
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 198KTEfR030371;
        Fri, 8 Oct 2021 16:31:30 -0400
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bjvtd0ce8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 08 Oct 2021 16:31:30 -0400
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 198KMZW9007062;
        Fri, 8 Oct 2021 20:31:28 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma04fra.de.ibm.com with ESMTP id 3bef2b194r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 08 Oct 2021 20:31:28 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 198KVOWw23331190
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 8 Oct 2021 20:31:25 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CC462A405E;
        Fri,  8 Oct 2021 20:31:24 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B4434A4057;
        Fri,  8 Oct 2021 20:31:24 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Fri,  8 Oct 2021 20:31:24 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 4958)
        id 37CCFE0291; Fri,  8 Oct 2021 22:31:24 +0200 (CEST)
From:   Eric Farman <farman@linux.ibm.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        Eric Farman <farman@linux.ibm.com>
Subject: [RFC PATCH v1 0/6] Improvements to SIGP handling [KVM]
Date:   Fri,  8 Oct 2021 22:31:06 +0200
Message-Id: <20211008203112.1979843-1-farman@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: MQPAnh8QzpziDzpFoClm2B7SGideyjbk
X-Proofpoint-GUID: -Fi84ocyextRGjmg0EQyBJPyDa79Cclp
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-10-08_06,2021-10-07_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 lowpriorityscore=0
 suspectscore=0 impostorscore=0 phishscore=0 bulkscore=0 malwarescore=0
 spamscore=0 adultscore=0 mlxlogscore=999 priorityscore=1501 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2110080112
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

I'm cleaning up some of the SIGP code in KVM and QEMU,
and would like to propose the following changes.

Patch 1 is interesting and could use some discussion, in that
CZAM cannot be disabled with QEMU (it is present in the earliest
CPU models) but the CPU model interface _could_ allow userspace
to leave it out. On the other (other?) hand, since we are always
in z/Architecture, that wouldn't make much sense as there would
probably be some other interesting side effects.

Patch 6 isn't required, but as I was looking at the intersection
of KVM capabilities S390_USER_SIGP and MP_STATE for this,
I thought some footprints could be useful.

There is no dependency on QEMU code, however another series of
patches for QEMU will follow.

Eric Farman (6):
  KVM: s390: Simplify SIGP Set Arch handling
  KVM: s390: Reject SIGP when destination CPU is busy
  KVM: s390: Simplify SIGP Restart
  KVM: s390: Restart IRQ should also block SIGP
  KVM: s390: Give BUSY to SIGP SENSE during Restart
  KVM: s390: Add a routine for setting userspace CPU state

 arch/s390/include/asm/kvm_host.h |  1 +
 arch/s390/kvm/interrupt.c        |  7 +++
 arch/s390/kvm/kvm-s390.c         |  7 +--
 arch/s390/kvm/kvm-s390.h         | 10 ++++
 arch/s390/kvm/sigp.c             | 86 +++++++++++++++++++++++---------
 5 files changed, 85 insertions(+), 26 deletions(-)

-- 
2.25.1

