Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1AD32B684D
	for <lists+kvm@lfdr.de>; Tue, 17 Nov 2020 16:10:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729555AbgKQPKa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Nov 2020 10:10:30 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:60692 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726883AbgKQPK3 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 17 Nov 2020 10:10:29 -0500
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AHF2uUh167402;
        Tue, 17 Nov 2020 10:10:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=4UVWN0xema4KXC/lfxhqQdaMvSajT9kvkS5R0Z2Brkw=;
 b=LgeCnxfbgci86UPTpmglTlLM8s28ZyqPoKLkZg46E6u7k7xAecOpObrreaxDMIaHaCh+
 hKxkreRO9xtYa/2AG0rBGHhHfLJ76yxKmLoxUUfl4Uapp3gR5pu0gK87XFQnHuuDOddY
 1iFIaYAz+LoCbJtvP8ao4YfjZo7zQNI0SbInuDDM6BMP890BndPyhOe2xfK36U8PjE4i
 1l+CWo5Q3RR2a229k4cBtWsliTTbjvL0LTbn+kiPkL8szRLU89n/OUlHadSup+gkxWUz
 nkX36SASrVnQ/+Aw5uI8rHETDzwuY65yUAW8s8uuLM45HK5AuRvkKinv4wvN22HAke3o lg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 34vd4q0a1k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 Nov 2020 10:10:28 -0500
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0AHF329q167937;
        Tue, 17 Nov 2020 10:10:28 -0500
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 34vd4q0a0p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 Nov 2020 10:10:28 -0500
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0AHF8UYb003198;
        Tue, 17 Nov 2020 15:10:26 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma04ams.nl.ibm.com with ESMTP id 34t6v8b1qp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 Nov 2020 15:10:26 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0AHFAN5w37683494
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Nov 2020 15:10:24 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DBB754C050;
        Tue, 17 Nov 2020 15:10:23 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C83D64C040;
        Tue, 17 Nov 2020 15:10:23 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Tue, 17 Nov 2020 15:10:23 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 25651)
        id 799F6E23AA; Tue, 17 Nov 2020 16:10:23 +0100 (CET)
From:   Christian Borntraeger <borntraeger@de.ibm.com>
To:     Janosch Frank <frankja@linux.vnet.ibm.com>
Cc:     KVM <kvm@vger.kernel.org>, Cornelia Huck <cohuck@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>
Subject: [PATCH 0/2] KVM: s390: memcg awareness
Date:   Tue, 17 Nov 2020 16:10:21 +0100
Message-Id: <20201117151023.424575-1-borntraeger@de.ibm.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-17_04:2020-11-17,2020-11-17 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 adultscore=0
 clxscore=1015 phishscore=0 mlxlogscore=730 priorityscore=1501 mlxscore=0
 lowpriorityscore=0 malwarescore=0 impostorscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011170109
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This got somehow lost.  (so this is kind of a v2)
KVM does have memcg awareness. Lets implement this also for s390kvm
and gmap.

Christian Borntraeger (2):
  KVM: s390: Add memcg accounting to KVM allocations
  s390/gmap: make gmap memcg aware

 arch/s390/kvm/guestdbg.c  |  8 ++++----
 arch/s390/kvm/intercept.c |  2 +-
 arch/s390/kvm/interrupt.c | 10 +++++-----
 arch/s390/kvm/kvm-s390.c  | 20 ++++++++++----------
 arch/s390/kvm/priv.c      |  4 ++--
 arch/s390/kvm/pv.c        |  6 +++---
 arch/s390/kvm/vsie.c      |  4 ++--
 arch/s390/mm/gmap.c       | 30 +++++++++++++++---------------
 8 files changed, 42 insertions(+), 42 deletions(-)

-- 
2.28.0

