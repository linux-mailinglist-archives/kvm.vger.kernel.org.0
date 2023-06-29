Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB906742255
	for <lists+kvm@lfdr.de>; Thu, 29 Jun 2023 10:41:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232395AbjF2IlQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Jun 2023 04:41:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229936AbjF2Ik1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Jun 2023 04:40:27 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4D793AA1;
        Thu, 29 Jun 2023 01:35:04 -0700 (PDT)
Received: from pps.filterd (m0353728.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 35T8SqTt008779;
        Thu, 29 Jun 2023 08:35:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=TfNdltZ0iK1LnTzBgtKpzVxh65vdZxDQhX4cPSf+ixk=;
 b=N1SoSduNR/YlQc2A4RW2NDxYk4uiCKcw3N/SvF5nDSnj2T+aFUPpKm2SZTj0MTyB4gsT
 uI8fUWkdHcVq30+q2ajEVk3SsLrJd5F6oaqxnNs74Y4McjPjpQ8bjufX2d0p1S497bcl
 6Debs7KTm7bUBZGzDQFoiyvpI3/pTFSQL8CzG9qtJ90QefVlZOIHG6hXLGT/B9cTqzLR
 fKAvWllE6nW+s2b1V3IYQoaVvWjfkrmuk8ioF6xmITzoexXvONA+5LyKC9fElkgwIHFM
 xywJ2hUB/oKNsS6mh3KXNwRvpyi+a+VHWU2IdU6l6igEvOvVNq1L/cPEzkjjhcoPtGJ3 5g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rh6g0850a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 29 Jun 2023 08:35:04 +0000
Received: from m0353728.ppops.net (m0353728.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 35T8UDZl013030;
        Thu, 29 Jun 2023 08:35:03 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rh6g084yj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 29 Jun 2023 08:35:03 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 35T4RLnI032704;
        Thu, 29 Jun 2023 08:35:01 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
        by ppma03ams.nl.ibm.com (PPS) with ESMTPS id 3rdr4538ah-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 29 Jun 2023 08:35:01 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
        by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 35T8YwUH7864848
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Jun 2023 08:34:58 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0688E20043;
        Thu, 29 Jun 2023 08:34:58 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1B20520040;
        Thu, 29 Jun 2023 08:34:57 +0000 (GMT)
Received: from heavy.boeblingen.de.ibm.com (unknown [9.179.0.51])
        by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Thu, 29 Jun 2023 08:34:57 +0000 (GMT)
From:   Ilya Leoshkevich <iii@linux.ibm.com>
To:     Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>
Cc:     David Hildenbrand <david@redhat.com>,
        Sven Schnelle <svens@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jens Freimann <jfreimann@redhat.com>,
        Ilya Leoshkevich <iii@linux.ibm.com>
Subject: [PATCH 0/2] KVM: s390: interrupt: Fix stepping into interrupt handlers
Date:   Thu, 29 Jun 2023 10:32:03 +0200
Message-ID: <20230629083452.183274-1-iii@linux.ibm.com>
X-Mailer: git-send-email 2.41.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: RY2E3gd7Zl7i3yBrwbKmjBZyrCR6HhSX
X-Proofpoint-ORIG-GUID: RtXWtkUEBoR24RPnP9Ros5w5hLsr6VX8
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-06-28_14,2023-06-27_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=702
 priorityscore=1501 mlxscore=0 lowpriorityscore=0 clxscore=1011
 adultscore=0 phishscore=0 impostorscore=0 spamscore=0 suspectscore=0
 bulkscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2305260000 definitions=main-2306290075
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

I tried to compare the behavior of KVM and TCG by diffing instruction
traces, and found two issues in KVM related to stepping into interrupt
handlers.

I'm not very familiar with the KVM code base, so please let me know if
the fixes can be improved or if these problems need to be handled
completely differently.

Best regards,
Ilya

Ilya Leoshkevich (2):
  KVM: s390: interrupt: Fix stepping into interrupt handlers
  KVM: s390: interrupt: Fix stepping into program interrupt handlers

 arch/s390/kvm/intercept.c | 19 +++++++++++++++++--
 arch/s390/kvm/interrupt.c | 10 ++++++++++
 arch/s390/kvm/kvm-s390.c  |  4 ++--
 3 files changed, 29 insertions(+), 4 deletions(-)

-- 
2.41.0

