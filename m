Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60F53457834
	for <lists+kvm@lfdr.de>; Fri, 19 Nov 2021 22:37:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235636AbhKSVkU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Nov 2021 16:40:20 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:21880 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235516AbhKSVkR (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 19 Nov 2021 16:40:17 -0500
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AJLI9Kq038703;
        Fri, 19 Nov 2021 21:37:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : content-transfer-encoding : mime-version; s=pp1;
 bh=iIMfxFyJHHB0Xt5kSkfNNtNrP8aeucoc382E5Jpswvs=;
 b=rtYninhMBesE3nNY+wAODip5RE+NtFwRcQZiRqM+oANWgN/Jm51107A3TdDMvJLjed4v
 7cjxsJSgzJ5MT2a6p3Y81qM56tIj37sx8/VVYi9/waj4tBZgQSJVDG+lbm3qhqHnjX2y
 +TY84P09UO+b/FSjJLxZrNE6ClLioEW/O4IxzmSel5ZU+2TTqmlf8dcG8kGkclGjkSpc
 qccQPIaeLLKT34P5YuyB8CEiqVQmblyhPbnffo6VXuY+puXyHSuBxdfn10beq0odI+IT
 JE5dzuxrLqlkQVsUdopcbkxaEkopfZ0QECa7C/0sbDs4mhHvx3zUOms9zk8mSEbdZm6m IQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cekqfra9c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 19 Nov 2021 21:37:15 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1AJLXfib027971;
        Fri, 19 Nov 2021 21:37:15 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cekqfra8r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 19 Nov 2021 21:37:14 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1AJLHpC1021077;
        Fri, 19 Nov 2021 21:37:12 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma04fra.de.ibm.com with ESMTP id 3ca50da4a0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 19 Nov 2021 21:37:12 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1AJLU8pd52494640
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 19 Nov 2021 21:30:08 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 40F105205A;
        Fri, 19 Nov 2021 21:37:09 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTPS id 2D8BC52059;
        Fri, 19 Nov 2021 21:37:09 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 4958)
        id DD491E0A39; Fri, 19 Nov 2021 22:37:08 +0100 (CET)
From:   Eric Farman <farman@linux.ibm.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Thomas Huth <thuth@redhat.com>
Cc:     Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, Eric Farman <farman@linux.ibm.com>
Subject: [RFC PATCH v4 0/2] s390x: Improvements to SIGP handling [KVM]
Date:   Fri, 19 Nov 2021 22:37:05 +0100
Message-Id: <20211119213707.2363945-1-farman@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Ncb3T28vKMSWYeIArSLGM-iPaSyRRlnZ
X-Proofpoint-ORIG-GUID: GHu-sl9_EVB4xmUyEFL8eMX3-bF5BhDi
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-19_15,2021-11-17_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0
 lowpriorityscore=0 malwarescore=0 mlxlogscore=999 adultscore=0
 suspectscore=0 bulkscore=0 impostorscore=0 priorityscore=1501
 clxscore=1015 phishscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2110150000 definitions=main-2111190114
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
Furthermore, there is a desire to be architecturally correct in this
space, where the Principles of Operation states lists of orders
that should return a CC2 (BUSY) when any of another list of orders
is being processed on the targeted CPU.

This version goes back to something similar to v2, in that there's
only a single IOCTL created. But unlike v2, userspace handles both the
"set" and "reset" sides of the equation, specifying the operations in
the payload sent via the IOCTL.

With this, I started considering that the kernel itself could mark the
cpu busy/ready as it relates to SIGP, such that a !USER_SIGP userspace
would be happy with matters too, but haven't quite gotten that working
to my liking.

I'll send the QEMU series shortly, which takes advantage of this.

Thoughts?

Previous RFCs:
v1: https://lore.kernel.org/r/20211008203112.1979843-1-farman@linux.ibm.com/
v2: https://lore.kernel.org/r/20211102194652.2685098-1-farman@linux.ibm.com/
v3: https://lore.kernel.org/r/20211110203322.1374925-1-farman@linux.ibm.com/

Eric Farman (2):
  Capability/IOCTL/Documentation
  KVM: s390: Introduce a USER_BUSY capability and IOCTL

 Documentation/virt/kvm/api.rst   | 22 ++++++++++++++++++
 arch/s390/include/asm/kvm_host.h |  2 ++
 arch/s390/kvm/kvm-s390.c         | 40 ++++++++++++++++++++++++++++++++
 arch/s390/kvm/kvm-s390.h         | 15 ++++++++++++
 arch/s390/kvm/sigp.c             |  3 +++
 include/uapi/linux/kvm.h         | 16 +++++++++++++
 6 files changed, 98 insertions(+)

-- 
2.25.1

