Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34990319B62
	for <lists+kvm@lfdr.de>; Fri, 12 Feb 2021 09:44:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230107AbhBLIl0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Feb 2021 03:41:26 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:45620 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S230206AbhBLIk1 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 12 Feb 2021 03:40:27 -0500
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 11C8W6MO156573;
        Fri, 12 Feb 2021 03:39:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id; s=pp1;
 bh=o6cejZ8DmI8Ug6OsLBpPZ6dJclSzOwfRxwbJ2SyiGVQ=;
 b=K7s/4v2O8LIMXcLruOA3tw+fG/2btj9OHM5//tNnrwakJpgJwYYdgaY2O26iQHy0xBZM
 ZC99rTiWDPkJCSwhSYbnXvpVLIpW5QTZzDnvnqo5bFZrrMLcSxTxaVQloJBwhi64XXaG
 +TB3bzBvgxmW61WX9e665Njw4BD3+A2h4rYJBDsj0iZkOLqcavpNNAyDs7TagAhGOU7X
 SElK4kIRai1ggq9OGISh7hq2GJ5WSxPR1Oh3s9WDb7IsxfrlHY2gGswapHFF+YpeUa/3
 vLevsUWjYNSgPx7hIQuLGLvPKEfMWE5jCApKgBrh2O7S6Lnl3O8D2z/Dl1A6YcMfxE9a Dg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 36nnbq2229-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 12 Feb 2021 03:39:43 -0500
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 11C8WQtZ158399;
        Fri, 12 Feb 2021 03:39:43 -0500
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0b-001b2d01.pphosted.com with ESMTP id 36nnbq2212-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 12 Feb 2021 03:39:43 -0500
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 11C8bYEr004263;
        Fri, 12 Feb 2021 08:39:41 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma06ams.nl.ibm.com with ESMTP id 36j94wnr8a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 12 Feb 2021 08:39:41 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 11C8dRY834275794
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 12 Feb 2021 08:39:28 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 432AF42041;
        Fri, 12 Feb 2021 08:39:38 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C6C664203F;
        Fri, 12 Feb 2021 08:39:37 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.28.9])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 12 Feb 2021 08:39:37 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, borntraeger@de.ibm.com,
        frankja@linux.ibm.com, cohuck@redhat.com, david@redhat.com,
        thuth@redhat.com, pmorel@linux.ibm.com
Subject: [PATCH v2 0/1] KVM: s390: diag9c forwarding
Date:   Fri, 12 Feb 2021 09:39:35 +0100
Message-Id: <1613119176-20864-1-git-send-email-pmorel@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-12_02:2021-02-12,2021-02-12 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 phishscore=0
 clxscore=1015 impostorscore=0 mlxscore=0 lowpriorityscore=0 spamscore=0
 bulkscore=0 suspectscore=0 mlxlogscore=953 priorityscore=1501 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102120060
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch will forward the yieldto hypercall (diag9c) if in the host
the target CPU is also not running. As we do not yet have performance
data (and recommendations) the default is turned off, but this can
be changed during runtime.

Pierre Morel (1):
  s390:kvm: diag9c forwarding

 Documentation/virt/kvm/s390-diag.rst | 33 ++++++++++++++++++++++++++++
 arch/s390/include/asm/kvm_host.h     |  1 +
 arch/s390/include/asm/smp.h          |  1 +
 arch/s390/kernel/smp.c               |  1 +
 arch/s390/kvm/diag.c                 | 31 +++++++++++++++++++++++---
 arch/s390/kvm/kvm-s390.c             |  6 +++++
 arch/s390/kvm/kvm-s390.h             |  8 +++++++
 7 files changed, 78 insertions(+), 3 deletions(-)

-- 
2.17.1

Changelog:

- more precise comments
  (Connie)

- Documentation
  (Janosch)
