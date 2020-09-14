Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5D8C2698BE
	for <lists+kvm@lfdr.de>; Tue, 15 Sep 2020 00:25:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726020AbgINWZk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Sep 2020 18:25:40 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:52872 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725961AbgINWZj (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 14 Sep 2020 18:25:39 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08EM0UJp122402;
        Mon, 14 Sep 2020 18:25:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id; s=pp1;
 bh=5rbfWMR2p4h3b9rCj7Ub2mMTTQZ7RB7yYIpWoyv870w=;
 b=S/ug4yqFzN/kQDfQOOKL9UzRD8Np9Vf8mfVRYD4I09fPj4IvtSg+ZpikMgw3TALW0xU6
 giHSX/TfmY/1Gn5CKy8J92bJt3gU5T+H/P03x+SVqpTTb8sjV4b8ItuiD2pD5jUjPE8C
 NgcaEoaUTHTNOa3oUIwhy7FIn46t5N+2zgUoC5rKlbcV0fJnNIC7NJpRWpS87p2yGFM2
 Z5ISWSS127U2Xmi4nten6SMgPmUBdFHTaTdvolkZFJ9KMWX6Weinvx1eiQUUtpQmHjZy
 FKxgPgke0lUkfmtPR3lEeWKJgCwszVl5bAvm4p2u9363fbh0l1QWURSEc6cH8C6gsurN Mg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33jgrmgu8d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 14 Sep 2020 18:25:38 -0400
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 08EM1QrE127462;
        Mon, 14 Sep 2020 18:25:38 -0400
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33jgrmgu88-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 14 Sep 2020 18:25:38 -0400
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 08EM2W7L026191;
        Mon, 14 Sep 2020 22:25:37 GMT
Received: from b01cxnp22035.gho.pok.ibm.com (b01cxnp22035.gho.pok.ibm.com [9.57.198.25])
        by ppma03dal.us.ibm.com with ESMTP id 33gny97rrh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 14 Sep 2020 22:25:37 +0000
Received: from b01ledav002.gho.pok.ibm.com (b01ledav002.gho.pok.ibm.com [9.57.199.107])
        by b01cxnp22035.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 08EMPao227722042
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 14 Sep 2020 22:25:36 GMT
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 97961124052;
        Mon, 14 Sep 2020 22:25:36 +0000 (GMT)
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4996B124054;
        Mon, 14 Sep 2020 22:25:35 +0000 (GMT)
Received: from oc4221205838.ibm.com (unknown [9.163.85.51])
        by b01ledav002.gho.pok.ibm.com (Postfix) with ESMTP;
        Mon, 14 Sep 2020 22:25:35 +0000 (GMT)
From:   Matthew Rosato <mjrosato@linux.ibm.com>
To:     alex.williamson@redhat.com, cohuck@redhat.com
Cc:     pmorel@linux.ibm.com, schnelle@linux.ibm.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2] vfio iommu: Add dma available capability
Date:   Mon, 14 Sep 2020 18:25:30 -0400
Message-Id: <1600122331-12181-1-git-send-email-mjrosato@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-14_09:2020-09-14,2020-09-14 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 clxscore=1015 mlxlogscore=651 bulkscore=0 suspectscore=0 impostorscore=0
 mlxscore=0 adultscore=0 spamscore=0 malwarescore=0 lowpriorityscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009140166
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

Changes from v1:
- Report dma_avail instead of the limit, which might not have been accurate
  anyway
- Text/naming changes throughout due to the above

Matthew Rosato (1):
  vfio iommu: Add dma available capability

 drivers/vfio/vfio_iommu_type1.c | 17 +++++++++++++++++
 include/uapi/linux/vfio.h       | 16 ++++++++++++++++
 2 files changed, 33 insertions(+)

-- 
1.8.3.1

