Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B401F2664B7
	for <lists+kvm@lfdr.de>; Fri, 11 Sep 2020 18:44:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726260AbgIKQoi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Sep 2020 12:44:38 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:43858 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726147AbgIKQoN (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 11 Sep 2020 12:44:13 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08BGUknW022796;
        Fri, 11 Sep 2020 12:44:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id; s=pp1;
 bh=nGeabmXdwEAjiTkbWCms3XrTmRW/raRtDCwHiINZh3s=;
 b=kivZljOTf4PdQD+hGHlfhh+ugPo3Zz7dascow4h4FpiOvUhf9Mb0mqWUx5kdP4MnlAGs
 MTHQNPSEsmXlTgekGfTNWJCtxm8g2fhismWKFolx55d2e+v0nZXySvX/I++Ds0zA9dyg
 LU7JsxO1D0F/mUcPii7vxgPCKRJ6inW6/pte7seTbfDho7JKOhFQ9c5z+EyyINVfF68G
 EAobckVyMaFAXfcLZlA+pqg6/Zk6JM11QGWx3tG5ULKOqasLerZgwnw8GQej+kWzvZMB
 y8w3HRDM7KUkVnIA9cSNGmM8VC9T12ZKoCxMggpcDCZr9e3XTCJpFScnujpT+Fu/FfAN zg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 33g99by7bn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 11 Sep 2020 12:44:10 -0400
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 08BGVTpI025006;
        Fri, 11 Sep 2020 12:44:10 -0400
Received: from ppma04wdc.us.ibm.com (1a.90.2fa9.ip4.static.sl-reverse.com [169.47.144.26])
        by mx0b-001b2d01.pphosted.com with ESMTP id 33g99by7bj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 11 Sep 2020 12:44:10 -0400
Received: from pps.filterd (ppma04wdc.us.ibm.com [127.0.0.1])
        by ppma04wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 08BGfbn1028239;
        Fri, 11 Sep 2020 16:44:10 GMT
Received: from b01cxnp23034.gho.pok.ibm.com (b01cxnp23034.gho.pok.ibm.com [9.57.198.29])
        by ppma04wdc.us.ibm.com with ESMTP id 33c2a9h6w9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 11 Sep 2020 16:44:10 +0000
Received: from b01ledav003.gho.pok.ibm.com (b01ledav003.gho.pok.ibm.com [9.57.199.108])
        by b01cxnp23034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 08BGi96D52166992
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 11 Sep 2020 16:44:09 GMT
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 88B71B2068;
        Fri, 11 Sep 2020 16:44:09 +0000 (GMT)
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 838DCB2064;
        Fri, 11 Sep 2020 16:44:07 +0000 (GMT)
Received: from oc4221205838.ibm.com (unknown [9.211.91.207])
        by b01ledav003.gho.pok.ibm.com (Postfix) with ESMTP;
        Fri, 11 Sep 2020 16:44:07 +0000 (GMT)
From:   Matthew Rosato <mjrosato@linux.ibm.com>
To:     alex.williamson@redhat.com, cohuck@redhat.com
Cc:     pmorel@linux.ibm.com, schnelle@linux.ibm.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] vfio iommu: Add dma limit capability
Date:   Fri, 11 Sep 2020 12:44:02 -0400
Message-Id: <1599842643-2553-1-git-send-email-mjrosato@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-11_08:2020-09-10,2020-09-11 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 bulkscore=0
 malwarescore=0 priorityscore=1501 adultscore=0 phishscore=0 suspectscore=0
 impostorscore=0 mlxlogscore=698 spamscore=0 mlxscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009110131
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

This patch proposes to provide the DMA limit via the VFIO_IOMMU_GET_INFO
ioctl as a new capability.  A subsequent patchset to QEMU would collect
this information and use it in s390 PCI support to tap the guest on the
shoulder before overrunning the vfio limit.

Matthew Rosato (1):
  vfio iommu: Add dma limit capability

 drivers/vfio/vfio_iommu_type1.c | 17 +++++++++++++++++
 include/uapi/linux/vfio.h       | 16 ++++++++++++++++
 2 files changed, 33 insertions(+)

-- 
1.8.3.1

