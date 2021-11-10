Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20FAE44CAAF
	for <lists+kvm@lfdr.de>; Wed, 10 Nov 2021 21:33:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232854AbhKJUgW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Nov 2021 15:36:22 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:63614 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S232558AbhKJUgT (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 10 Nov 2021 15:36:19 -0500
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AAIlMwU010423;
        Wed, 10 Nov 2021 20:33:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : content-transfer-encoding : mime-version; s=pp1;
 bh=8xpW20Ka9IHDoHVZ093lB2bUsXlWv3s4cHNXxIacuNI=;
 b=ndvk/OgSKsf68d8xB9TdIgdUQvVu/0J03nrZ3enVLGI+d1mo6buJwJPYTfH4JfqrLoll
 6Cg4k4d1wNErgHWeE12e3zCauCHp2iTbfWbbnAId1a2vr+9KuM1MuvO5q1z5XxhYwyAf
 3J1tiVq/lMjh+VsveCXhlG7HFkPF++YZU2YOaDRKPPWd+46g7noHVIetO1AyyX7sOBFl
 65byLk2BaHpYPt0D23mQQiOisI6dSh6SkvC1/q50u58veuzPcdLSbwjTktsSUsRFNDJb
 KhMJLFK6EhUxEVElA//wc/Jyyhd7N9GXPZ5tODI6C+fejwquxoeVCqxGlKezKrfcmbzY hg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3c8knua7ak-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 10 Nov 2021 20:33:30 +0000
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1AAJY2lY003634;
        Wed, 10 Nov 2021 20:33:30 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3c8knua79x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 10 Nov 2021 20:33:30 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1AAKVMYN004148;
        Wed, 10 Nov 2021 20:33:28 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma01fra.de.ibm.com with ESMTP id 3c5hba4aqy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 10 Nov 2021 20:33:28 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1AAKQjHA47644972
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Nov 2021 20:26:45 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 258C1AE057;
        Wed, 10 Nov 2021 20:33:25 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 13897AE055;
        Wed, 10 Nov 2021 20:33:25 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Wed, 10 Nov 2021 20:33:25 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 4958)
        id AC0D1E02A5; Wed, 10 Nov 2021 21:33:24 +0100 (CET)
From:   Eric Farman <farman@linux.ibm.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Thomas Huth <thuth@redhat.com>
Cc:     Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, Eric Farman <farman@linux.ibm.com>
Subject: [RFC PATCH v3 0/2] s390x: Improvements to SIGP handling [KVM]
Date:   Wed, 10 Nov 2021 21:33:20 +0100
Message-Id: <20211110203322.1374925-1-farman@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: eHhRxwc9cIVeHSgr7IDf59P5LiTG1IIQ
X-Proofpoint-ORIG-GUID: w6vWBhYyDoeRb3yaLsHuphrZzO6TjN4o
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-10_12,2021-11-08_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 priorityscore=1501
 malwarescore=0 bulkscore=0 clxscore=1015 lowpriorityscore=0
 mlxlogscore=999 adultscore=0 phishscore=0 impostorscore=0 spamscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111100098
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

Version 2 of this series instructed the kernel to automatically flag
a vcpu busy for a SIGP order, and provided an IOCTL for userspace to
mark the order as completed (suggested here [1]). But now, the
suggestion is that the kernel shouldn't be marking the vcpu busy,
and userspace should be doing both sides of the operation [2].
So this version has two IOCTLs, tied to one capability.

As with v2, I've left the CAP/IOCTL definitions as a standalone
patch, so I see it easier when working with the QEMU code.
Ultimately this would be squashed together, and might have some
refit after the merge window anyway. 

I'll send the QEMU series shortly, which takes advantage of this.

Thoughts?

[1] https://lore.kernel.org/r/3e3b38d1-b338-0211-04ab-91f913c1f557@redhat.com/
[2] https://lore.kernel.org/r/7e98f659-32ac-9b4e-0ddd-958086732c8d@redhat.com/

Previous RFCs:
v1: https://lore.kernel.org/r/20211008203112.1979843-1-farman@linux.ibm.com/
v2: https://lore.kernel.org/r/20211102194652.2685098-1-farman@linux.ibm.com/

Eric Farman (2):
  Capability/IOCTL/Documentation
  KVM: s390: Extend the USER_SIGP capability

 Documentation/virt/kvm/api.rst   | 39 ++++++++++++++++++++++++++++++++
 arch/s390/include/asm/kvm_host.h |  2 ++
 arch/s390/kvm/kvm-s390.c         | 29 ++++++++++++++++++++++++
 arch/s390/kvm/kvm-s390.h         | 16 +++++++++++++
 arch/s390/kvm/sigp.c             | 10 ++++++++
 include/uapi/linux/kvm.h         |  5 ++++
 6 files changed, 101 insertions(+)

-- 
2.25.1

