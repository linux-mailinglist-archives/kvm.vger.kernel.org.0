Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9D2741DA50
	for <lists+kvm@lfdr.de>; Thu, 30 Sep 2021 14:54:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351179AbhI3M4b (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Sep 2021 08:56:31 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:62764 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1351170AbhI3M4a (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 30 Sep 2021 08:56:30 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18UCUapQ028472;
        Thu, 30 Sep 2021 08:54:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : content-transfer-encoding : mime-version; s=pp1;
 bh=9YUqKBOGrZeaWpxlV7/jnQU90tB+qyCPlOJUSkm5kiQ=;
 b=Iu9OFJ8YIGA7AoymXC0BGisjZPWFZCAGDnhF0LAOgu/nlSF424POEG2vxqowL4sAd8ND
 P9S0X1yz/3gfPwomaUqSgAFj9dMBAU1aEoF76LzaYg2ZH6sG4PPrwZcZ/kDc0X9qLXxn
 zzxwKPN1ZSmqmXpHEFg1ZROBgk9vse985mwVnNI8voKpVhqfcPyUk2z4rQkQkRx99LO1
 iGRZJ+lyxLQmm43UFB/WuKZXcEgLzdPdY37Bu5HLvmGwdMyLW4bxY2Z23Q9l9+3QKA7K
 GGOvAhHI4l18lV1Xy1MQ2Ek/Hm2O2SrB53wtzC24l/dRbYFXcPWVq5QDE31Pm8A8QV35 ug== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bdda8rf88-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 30 Sep 2021 08:54:47 -0400
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 18UCVImd032312;
        Thu, 30 Sep 2021 08:54:47 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bdda8rf79-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 30 Sep 2021 08:54:47 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 18UCq9SG018375;
        Thu, 30 Sep 2021 12:54:44 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma03ams.nl.ibm.com with ESMTP id 3b9udakn2g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 30 Sep 2021 12:54:44 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 18UCnWrM59638148
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 30 Sep 2021 12:49:32 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F151F52051;
        Thu, 30 Sep 2021 12:54:40 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTPS id DC11252050;
        Thu, 30 Sep 2021 12:54:40 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 25651)
        id 7CA4AE07C6; Thu, 30 Sep 2021 14:54:40 +0200 (CEST)
From:   Christian Borntraeger <borntraeger@de.ibm.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     KVM <kvm@vger.kernel.org>, Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
Subject: [GIT PULL 0/1] KVM: s390: allow to compile without warning with W=1
Date:   Thu, 30 Sep 2021 14:54:39 +0200
Message-Id: <20210930125440.22777-1-borntraeger@de.ibm.com>
X-Mailer: git-send-email 2.31.1
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: qcXRfKzkeInHC9DdD7ToAJn7eTkr4qG5
X-Proofpoint-GUID: qac2m8AJ7HfAVuqo6mXSjwi7Tqtoe12G
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-30_04,2021-09-30_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=844 clxscore=1015
 impostorscore=0 suspectscore=0 bulkscore=0 phishscore=0 priorityscore=1501
 spamscore=0 mlxscore=0 adultscore=0 lowpriorityscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2109300079
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Paolo,

please pull for kvm/master a fix for W=1.

The following changes since commit 5c49d1850ddd3240d20dc40b01f593e35a184f38:

  KVM: VMX: Fix a TSX_CTRL_CPUID_CLEAR field mask issue (2021-09-27 11:25:40 -0400)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvms390/linux.git  tags/kvm-s390-master-5.15-1

for you to fetch changes up to 25b5476a294cd5f7c7730f334f6b400d30bb783d:

  KVM: s390: Function documentation fixes (2021-09-28 17:56:54 +0200)

----------------------------------------------------------------
KVM: s390: allow to compile without warning with W=1

----------------------------------------------------------------
Janosch Frank (1):
      KVM: s390: Function documentation fixes

 arch/s390/kvm/gaccess.c   | 12 ++++++++++++
 arch/s390/kvm/intercept.c |  4 +++-
 2 files changed, 15 insertions(+), 1 deletion(-)
