Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A38BC433DD7
	for <lists+kvm@lfdr.de>; Tue, 19 Oct 2021 19:54:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234724AbhJSR4Z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Oct 2021 13:56:25 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:55594 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232148AbhJSR4Y (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 19 Oct 2021 13:56:24 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19JHFWjo027664;
        Tue, 19 Oct 2021 13:54:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=6x4dyi/EIPpRIQpzoTnkc63vdwAapa/hL9676ISFiJ8=;
 b=PDjnlubJIPaymDCbR6+7TMTXmzAdsJC2b0mL2uKhzeD3ryyM+8grcAZynegsGHLJ/hE2
 ewNGavEP5c3DOEl6ynWetR67CFqg4vyWfFlY2Gm8oHoVOmVkFAQS3XJfePP//O52kTnv
 izDMRO7pd7kP/nhJdUlICaysRazzKo7gIAPphdvKU4CdOIuq1WLmrfDhXve9uoIytRwR
 eHtCVSSWFKCNf+dcUg7Rh2J8Z7pjSBvPIsGvFC2vCLjmqE6jw9u0+7HX7rEb+jYmewW9
 8Il/RbcsCs0ijjGxcrZxkxzVh90YLbAJ/9L7C4yGqHAjQQiGOJ6pUtzcVAUXM5xZNWbg dA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bsww7ra3v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 19 Oct 2021 13:54:11 -0400
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 19JHrxIX011547;
        Tue, 19 Oct 2021 13:54:11 -0400
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bsww7ra35-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 19 Oct 2021 13:54:10 -0400
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 19JHrSkv008940;
        Tue, 19 Oct 2021 17:54:08 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma03fra.de.ibm.com with ESMTP id 3bqpc9jrk6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 19 Oct 2021 17:54:08 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 19JHs5GB63766834
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 Oct 2021 17:54:05 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2E555AE055;
        Tue, 19 Oct 2021 17:54:05 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 989B1AE045;
        Tue, 19 Oct 2021 17:54:04 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 19 Oct 2021 17:54:04 +0000 (GMT)
From:   Halil Pasic <pasic@linux.ibm.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Michael Mueller <mimu@linux.ibm.com>,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Halil Pasic <pasic@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Pierre Morel <pmorel@linux.ibm.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Niklas Schnelle <schnelle@linux.ibm.com>, farman@linux.ibm.com,
        kvm@vger.kernel.org
Subject: [PATCH 0/3] fixes for __airqs_kick_single_vcpu()  
Date:   Tue, 19 Oct 2021 19:53:58 +0200
Message-Id: <20211019175401.3757927-1-pasic@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: rq3h-2ZJOMLNh7ba_ZpUEwCkSQX4R7ba
X-Proofpoint-ORIG-GUID: mIuaHLXt9Mk3QLeLwsYJc3r1-ljuNzvi
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-19_02,2021-10-19_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 malwarescore=0
 bulkscore=0 suspectscore=0 spamscore=0 adultscore=0 impostorscore=0
 phishscore=0 clxscore=1015 mlxlogscore=967 priorityscore=1501
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110190103
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The three fixes aren't closely related. The first one is the
most imporant one. They can be picked separately. I deciced to send them
out together so that if reviewers see: hey there is more broken, they
can also see the fixes near by.

Halil Pasic (3):
  KVM: s390: clear kicked_mask before sleeping again
  KVM: s390: preserve deliverable_mask in __airqs_kick_single_vcpu
  KVM: s390: clear kicked_mask if not idle after set

 arch/s390/kvm/interrupt.c | 12 +++++++++---
 arch/s390/kvm/kvm-s390.c  |  3 +--
 2 files changed, 10 insertions(+), 5 deletions(-)


base-commit: 519d81956ee277b4419c723adfb154603c2565ba
-- 
2.25.1

