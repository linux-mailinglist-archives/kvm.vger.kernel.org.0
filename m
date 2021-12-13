Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F46D47365E
	for <lists+kvm@lfdr.de>; Mon, 13 Dec 2021 22:06:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243079AbhLMVF7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Dec 2021 16:05:59 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:40708 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243069AbhLMVF6 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 13 Dec 2021 16:05:58 -0500
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1BDKEXi2016722;
        Mon, 13 Dec 2021 21:05:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : content-transfer-encoding : mime-version; s=pp1;
 bh=t3TWAAhOaLt9lFmNABzDUZi10DdmbDvX90M4umnZp/0=;
 b=GpM5Q2arpD3N2ecbm7oI6s1GQC9nHSEBDFwN0MDpJeLDuQyJEjogBeFW1KDG4SeWyE4E
 63Vurl3/2Fm/1OvfqA+Gz7PCfH0Tla0dXOrVT52muoW2T74myrpldgveJVSx4ZgdDYtG
 K2529psUdoPL1e9dvlKcGYXjIXvFHTbdFd7pwzactX4iTsds2WFkXI85DFXEfClue8ik
 Vu4tlmc69Ns+6JJMjZf2JqbWL9yFcgJcB2clQT1EOeLTZzBkYkyhoW+p/hlkvBheI6Af
 7+h71dT5WslRCthHd99Y/rI7v2gEbTL9TW7NFO7gHSEv/pfUMmCcyi/gzHZ5C55hCkUA HQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cx9r9eq3k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 13 Dec 2021 21:05:58 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1BDL5w05021751;
        Mon, 13 Dec 2021 21:05:58 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cx9r9eq2u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 13 Dec 2021 21:05:57 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1BDL2Spp007783;
        Mon, 13 Dec 2021 21:05:55 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma03ams.nl.ibm.com with ESMTP id 3cvkm98q0r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 13 Dec 2021 21:05:55 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1BDL5qcW46596528
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 Dec 2021 21:05:52 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E8893A404D;
        Mon, 13 Dec 2021 21:05:51 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DE124A4040;
        Mon, 13 Dec 2021 21:05:51 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Mon, 13 Dec 2021 21:05:51 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 4958)
        id 7DA95E03A3; Mon, 13 Dec 2021 22:05:51 +0100 (CET)
From:   Eric Farman <farman@linux.ibm.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Thomas Huth <thuth@redhat.com>
Cc:     Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, Eric Farman <farman@linux.ibm.com>
Subject: [RFC PATCH v5 0/1] s390x: Improvements to SIGP handling [KVM]
Date:   Mon, 13 Dec 2021 22:05:49 +0100
Message-Id: <20211213210550.856213-1-farman@linux.ibm.com>
X-Mailer: git-send-email 2.32.0
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: U9x44KCpdeX-_MNSCqa-OyaefrwBkXlL
X-Proofpoint-GUID: kbzfq52zXSaT7hZD3SOyXD3qS0d9VQx2
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-13_10,2021-12-13_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 clxscore=1015
 priorityscore=1501 bulkscore=0 phishscore=0 mlxlogscore=762 mlxscore=0
 adultscore=0 impostorscore=0 lowpriorityscore=0 spamscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2112130125
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Here is an update to the handling of SIGP between kernel and userspace.

As before, I'm looking at problems encountered when a SIGP order that is
processed in the kernel (for example, SIGP SENSE) is run concurrently
with another one is processed in userspace (for example, SIGP STOP).
Being able to provide an honest answer in the SIGP SENSE as to whether
the targeted VCPU is/not stopped is important to provide a consistent
answer while a guest OS is bringing its configuration online.

This version was suggested by David Hildenbrand on v3 [1], where we
examine the target vcpu for a pending STOP/RESTART IRQ while processing
a SIGP order in-kernel, and returning the CC2 if one is in-flight.

Unlike v2-v4 of this RFC, this solution requires no changes to userspace
to exploit a new interface, but a small change is made on the QEMU side
to keep the sequence of events in checks.

Thoughts?

[1] https://lore.kernel.org/r/858e4f2b-d601-a4f1-9e80-8f7838299c9a@redhat.com/

Previous RFCs:
v1: https://lore.kernel.org/r/20211008203112.1979843-1-farman@linux.ibm.com/
v2: https://lore.kernel.org/r/20211102194652.2685098-1-farman@linux.ibm.com/
v3: https://lore.kernel.org/r/20211110203322.1374925-1-farman@linux.ibm.com/
v4: https://lore.kernel.org/r/20211119213707.2363945-1-farman@linux.ibm.com/

Eric Farman (1):
  KVM: s390: Clarify SIGP orders versus STOP/RESTART

 arch/s390/kvm/interrupt.c |  7 +++++++
 arch/s390/kvm/kvm-s390.c  |  9 +++++++--
 arch/s390/kvm/kvm-s390.h  |  1 +
 arch/s390/kvm/sigp.c      | 28 ++++++++++++++++++++++++++++
 4 files changed, 43 insertions(+), 2 deletions(-)

-- 
2.32.0

