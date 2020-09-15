Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E978426AD29
	for <lists+kvm@lfdr.de>; Tue, 15 Sep 2020 21:10:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727992AbgIOTKk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Sep 2020 15:10:40 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:59090 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727974AbgIOTFg (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 15 Sep 2020 15:05:36 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08FJ4xa3062413;
        Tue, 15 Sep 2020 15:05:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id; s=pp1;
 bh=3N1ir76TaMTroe2Z0iyhhmpI17QSxN5F7DswCeEgg2U=;
 b=G0hcZ8qMH29+ISBvKGhjH69bi5azkliZO1XUZqHmEyaW2z5niZUmkPlXB76AADROgsW2
 C1vQ5DjsWZAzJxSdDIW9qaoHdxwk/pLZ+B7YLqOIVVIh/PsHKdOW2QxtRxbgT7qe3pjA
 52RiOFchR6ITjNEeGB7tC/SUqL3jQDtwxrggQZcEkkUQUCvuOVEn+/g8kG0rTbRsDl/w
 1y0GGwza6+xKB9OAYO+IQDRHh/jL7FTgj5mQr5bpM1OKsea17G2h05Y6zCsrwz/Tq1qS
 I+zgTdVlPD72B8eDo1f0pR5g4JkKap2MOZsWfO8BzmLdt9+ef2CYZTI8wAfrcQPQtpsp ng== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33k1tdamhy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Sep 2020 15:05:25 -0400
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 08FJ5Oq2064403;
        Tue, 15 Sep 2020 15:05:24 -0400
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33k1tdamhr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Sep 2020 15:05:24 -0400
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 08FIuRga006636;
        Tue, 15 Sep 2020 19:05:23 GMT
Received: from b03cxnp08027.gho.boulder.ibm.com (b03cxnp08027.gho.boulder.ibm.com [9.17.130.19])
        by ppma04dal.us.ibm.com with ESMTP id 33gny982fb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Sep 2020 19:05:23 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp08027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 08FJ5IOu33293016
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Sep 2020 19:05:18 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3552D78066;
        Tue, 15 Sep 2020 19:05:22 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 819C87805E;
        Tue, 15 Sep 2020 19:05:21 +0000 (GMT)
Received: from oc4221205838.ibm.com (unknown [9.163.85.51])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Tue, 15 Sep 2020 19:05:21 +0000 (GMT)
From:   Matthew Rosato <mjrosato@linux.ibm.com>
To:     alex.williamson@redhat.com, cohuck@redhat.com
Cc:     pmorel@linux.ibm.com, schnelle@linux.ibm.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3] vfio iommu: Add dma available capability
Date:   Tue, 15 Sep 2020 15:05:17 -0400
Message-Id: <1600196718-23238-1-git-send-email-mjrosato@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-15_12:2020-09-15,2020-09-15 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 mlxlogscore=671
 phishscore=0 impostorscore=0 mlxscore=0 spamscore=0 bulkscore=0
 adultscore=0 lowpriorityscore=0 suspectscore=0 malwarescore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009150147
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Commit 492855939bdb ("vfio/type1: Limit DMA mappings per container") added
a limit to the number of concurrent DMA requests for a vfio container.
However, lazy unmapping in s390 can in fact cause quite a large number of
outstanding DMA requests to build up prior to being purged, potentially 
the entire guest DMA space.  This results in unexpected 'VFIO_MAP_DMA
failed: No space left on device' conditions seen in QEMU.

This patch proposes to provide the remaining number of allowable DMA 
requests via the VFIO_IOMMU_GET_INFO ioctl as a new capability.  A 
subsequent patchset to QEMU would collect this information and use it in 
s390 PCI support to tap the guest on the shoulder before overrunning the 
vfio limit.

Changes from v2:
- Typos / fixed stale comment block

Matthew Rosato (1):
  vfio iommu: Add dma available capability

 drivers/vfio/vfio_iommu_type1.c | 17 +++++++++++++++++
 include/uapi/linux/vfio.h       | 15 +++++++++++++++
 2 files changed, 32 insertions(+)

-- 
1.8.3.1

