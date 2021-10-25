Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8E82439037
	for <lists+kvm@lfdr.de>; Mon, 25 Oct 2021 09:19:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231280AbhJYHWL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Oct 2021 03:22:11 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:45214 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230183AbhJYHWJ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 25 Oct 2021 03:22:09 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19P5BhPA028015;
        Mon, 25 Oct 2021 03:19:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : content-transfer-encoding : mime-version; s=pp1;
 bh=AxXdYIV0grLQaasKpjsov7HaSdi4HENzJvXwZVAZEVY=;
 b=FlhnR5U38PXgN0MqFZl0ok57HBqkcaygB8DADwB/3xxPqtnA6gmA5fWlqwS50JODKMQD
 N0RbtuVba9m4+eftZ8nceZeg1OL3moMfrLy4Uh6ffjZ9jpkfRvI7LAc16NmTxETzTHu/
 XyD/f2nbY8h+U1OyjnJM5Vn5qblnsUNq6y4qC2fB+HdTJviHE9DJ3hVuxv40nw8I0Gl+
 lAQ+s7L/CUmnN/V4evYAfrN4pc/kBwvT5zBsUpwfTHcjq7tBr926prm38Lps3vE2kV9+
 Wc6+aK079FoWvE2amDnPv1B4shXsz22F0A8ow3mYkPXtVbtTg6blGMILDYcqYdfYkfuU xg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bvyfc32uu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 25 Oct 2021 03:19:47 -0400
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 19P6ravR020869;
        Mon, 25 Oct 2021 03:19:47 -0400
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bvyfc32u6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 25 Oct 2021 03:19:46 -0400
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 19P7Ijs9007761;
        Mon, 25 Oct 2021 07:19:44 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma06fra.de.ibm.com with ESMTP id 3bv9njhfps-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 25 Oct 2021 07:19:44 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 19P7Jew050004330
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 25 Oct 2021 07:19:41 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D77C8AE057;
        Mon, 25 Oct 2021 07:19:40 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C5350AE058;
        Mon, 25 Oct 2021 07:19:40 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Mon, 25 Oct 2021 07:19:40 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 25651)
        id 7BFC1E074D; Mon, 25 Oct 2021 09:19:40 +0200 (CEST)
From:   Christian Borntraeger <borntraeger@de.ibm.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     KVM <kvm@vger.kernel.org>, Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
Subject: [GIT PULL 0/2] KVM: s390: Fixes for 5.15
Date:   Mon, 25 Oct 2021 09:19:38 +0200
Message-Id: <20211025071940.43696-1-borntraeger@de.ibm.com>
X-Mailer: git-send-email 2.31.1
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: j7ObXps-PIOvk1rMWwFajNEyn3v9ts6j
X-Proofpoint-ORIG-GUID: nG0pWRLlGR9DVACkZA1B2Krz1FMUmRa5
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-25_02,2021-10-25_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 malwarescore=0
 adultscore=0 mlxlogscore=665 mlxscore=0 priorityscore=1501
 lowpriorityscore=0 clxscore=1015 impostorscore=0 spamscore=0
 suspectscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110250040
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Paolo,

The following changes since commit 25b5476a294cd5f7c7730f334f6b400d30bb783d:

  KVM: s390: Function documentation fixes (2021-09-28 17:56:54 +0200)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvms390/linux.git  tags/kvm-s390-master-5.15-2

for you to fetch changes up to 0e9ff65f455dfd0a8aea5e7843678ab6fe097e21:

  KVM: s390: preserve deliverable_mask in __airqs_kick_single_vcpu (2021-10-20 13:03:04 +0200)

----------------------------------------------------------------
KVM: s390: Fixes for interrupt delivery

Two bugs that might result in CPUs not woken up when interrupts are
pending.

----------------------------------------------------------------
Halil Pasic (2):
      KVM: s390: clear kicked_mask before sleeping again
      KVM: s390: preserve deliverable_mask in __airqs_kick_single_vcpu

 arch/s390/kvm/interrupt.c | 5 +++--
 arch/s390/kvm/kvm-s390.c  | 1 +
 2 files changed, 4 insertions(+), 2 deletions(-)
