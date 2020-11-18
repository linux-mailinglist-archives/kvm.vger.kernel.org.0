Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 534AD2B827D
	for <lists+kvm@lfdr.de>; Wed, 18 Nov 2020 18:02:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726680AbgKRRBY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Nov 2020 12:01:24 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:15314 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726298AbgKRRBY (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 18 Nov 2020 12:01:24 -0500
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AIGeYa1082509;
        Wed, 18 Nov 2020 12:01:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : content-transfer-encoding : mime-version; s=pp1;
 bh=fLEAwpnM6hxeIApYtU9wwTGDxTH5AZrFgzYJkh7t2ts=;
 b=YkNc8CKBF4p/8KQk0h9anXjdrm+peU70F7fFRlxEmqcDgY5g1CcUpUMTr8SwFIp8PZBD
 XxpS8NFjXhUnftii6KQ9I3h0fi//ovna6asM4a7AA2BJoZsqBQxkCy+fCaKcsVXrHHwK
 uv/ropteqWxnlvYXwmujPDhYdowgghz9HKSaAjeK6x1+X5TM5l7ruN8BGUm514agip+P
 5tXpbznMXBbhycH7dMKTob6PET/2LHTTb9w43r+bXo8UVHsVVgNl1PbI+17iM0hqrpYk
 JkDY8+/cQV+ro4d0qVzBNbKamur6xFer88rKCuHvz+OrMgqcpshHxzONK2b3dQjbFy47 KQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 34w4shf16k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 18 Nov 2020 12:01:22 -0500
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0AIGecK5082764;
        Wed, 18 Nov 2020 12:01:22 -0500
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0b-001b2d01.pphosted.com with ESMTP id 34w4shf15d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 18 Nov 2020 12:01:22 -0500
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0AIGo7dW024037;
        Wed, 18 Nov 2020 17:01:20 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma05fra.de.ibm.com with ESMTP id 34v69urume-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 18 Nov 2020 17:01:20 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0AIH1HAm58458440
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Nov 2020 17:01:17 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 845B54204B;
        Wed, 18 Nov 2020 17:01:17 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 71CD742042;
        Wed, 18 Nov 2020 17:01:17 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Wed, 18 Nov 2020 17:01:17 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 25651)
        id 2CCB8E01E9; Wed, 18 Nov 2020 18:01:17 +0100 (CET)
From:   Christian Borntraeger <borntraeger@de.ibm.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     KVM <kvm@vger.kernel.org>, Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>
Subject: [GIT PULL 0/2] KVM: s390: Fix for destroy page ultravisor call
Date:   Wed, 18 Nov 2020 18:01:14 +0100
Message-Id: <20201118170116.8239-1-borntraeger@de.ibm.com>
X-Mailer: git-send-email 2.28.0
X-TM-AS-GCONF: 00
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-18_04:2020-11-17,2020-11-18 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0
 lowpriorityscore=0 suspectscore=0 impostorscore=0 malwarescore=0
 spamscore=0 priorityscore=1501 adultscore=0 bulkscore=0 mlxlogscore=852
 clxscore=1015 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011180113
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Paolo,

one more fix for 5.10 in addition with an update of the MAINTAINERS
file. The uv.c file is mostly used by KVM and Heiko asked that we take
care of this patch.

The following changes since commit 6cbf1e960fa52e4c63a6dfa4cda8736375b34ccc:

  KVM: s390: remove diag318 reset code (2020-11-11 09:31:52 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvms390/linux.git  tags/kvm-s390-master-5.10-2

for you to fetch changes up to 735931f9a51ab09cf795721b37696b420484625f:

  MAINTAINERS: add uv.c also to KVM/s390 (2020-11-18 13:09:21 +0100)

----------------------------------------------------------------
KVM: s390: Fix for destroy page ultravisor call

- handle response code from older firmware
- add uv.c to KVM: s390/s390 maintainer list

----------------------------------------------------------------
Christian Borntraeger (2):
      s390/uv: handle destroy page legacy interface
      MAINTAINERS: add uv.c also to KVM/s390

 MAINTAINERS           | 1 +
 arch/s390/kernel/uv.c | 9 ++++++++-
 2 files changed, 9 insertions(+), 1 deletion(-)
