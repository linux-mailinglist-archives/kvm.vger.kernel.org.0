Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 782FB6D2A8
	for <lists+kvm@lfdr.de>; Thu, 18 Jul 2019 19:21:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727812AbfGRRVf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Jul 2019 13:21:35 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:62312 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727623AbfGRRVe (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 18 Jul 2019 13:21:34 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x6IHHXPN019604
        for <kvm@vger.kernel.org>; Thu, 18 Jul 2019 13:21:33 -0400
Received: from e06smtp03.uk.ibm.com (e06smtp03.uk.ibm.com [195.75.94.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2ttw16870j-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 18 Jul 2019 13:21:33 -0400
Received: from localhost
        by e06smtp03.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <pasic@linux.ibm.com>;
        Thu, 18 Jul 2019 18:21:31 +0100
Received: from b06avi18626390.portsmouth.uk.ibm.com (9.149.26.192)
        by e06smtp03.uk.ibm.com (192.168.101.133) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 18 Jul 2019 18:21:30 +0100
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x6IHLEx834013532
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 18 Jul 2019 17:21:14 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 946D6AE057;
        Thu, 18 Jul 2019 17:21:28 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4EB77AE059;
        Thu, 18 Jul 2019 17:21:28 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 18 Jul 2019 17:21:28 +0000 (GMT)
From:   Halil Pasic <pasic@linux.ibm.com>
To:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        Christoph Hellwig <hch@infradead.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
Cc:     Halil Pasic <pasic@linux.ibm.com>, Petr Tesarik <ptesarik@suse.cz>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>
Subject: [PATCH 1/1] s390/dma: provide proper ARCH_ZONE_DMA_BITS value
Date:   Thu, 18 Jul 2019 19:21:20 +0200
X-Mailer: git-send-email 2.17.1
X-TM-AS-GCONF: 00
x-cbid: 19071817-0012-0000-0000-00000334200E
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19071817-0013-0000-0000-0000216DA31D
Message-Id: <20190718172120.69947-1-pasic@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-18_08:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=631 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1907180182
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On s390 ZONE_DMA is up to 2G, i.e. ARCH_ZONE_DMA_BITS should be 31 bits.
The current value is 24 and makes __dma_direct_alloc_pages() take a
wrong turn first (but __dma_direct_alloc_pages() recovers then).

Let's correct ARCH_ZONE_DMA_BITS value and avoid wrong turns.

Signed-off-by: Halil Pasic <pasic@linux.ibm.com>
Reported-by: Petr Tesarik <ptesarik@suse.cz>
Fixes: c61e9637340e ("dma-direct: add support for allocation from
ZONE_DMA and ZONE_DMA32")
---
 arch/s390/include/asm/dma.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/s390/include/asm/dma.h b/arch/s390/include/asm/dma.h
index 6f26f35d4a71..3b0329665b13 100644
--- a/arch/s390/include/asm/dma.h
+++ b/arch/s390/include/asm/dma.h
@@ -10,6 +10,7 @@
  * by the 31 bit heritage.
  */
 #define MAX_DMA_ADDRESS         0x80000000
+#define ARCH_ZONE_DMA_BITS      31
 
 #ifdef CONFIG_PCI
 extern int isa_dma_bridge_buggy;
-- 
2.17.1

