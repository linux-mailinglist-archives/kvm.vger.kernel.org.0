Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C9F63F9843
	for <lists+kvm@lfdr.de>; Fri, 27 Aug 2021 12:51:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245004AbhH0Kv5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Aug 2021 06:51:57 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:18334 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S244998AbhH0Kv4 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 27 Aug 2021 06:51:56 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17RAYeex021253;
        Fri, 27 Aug 2021 06:50:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=7mbDcDn+MlPyFLz/8Gszh7vWTzqiYc3M9dMMY/Fc+ig=;
 b=fZ4AJbcKXSTkNfDHLXtC1ebyUL6fUHOxkd17ZzsG7FeoEbsXR0NIiygr44HqY1VwHzbv
 sauMnB3jP5pC3DL94ZAbmnqjy2m2rxECXT9BnCdSr1DKDs8VTvN7iv0TJQdoUV5yuNfC
 /JzqyB2+RGuT9W8dwDBD5GlzM3zTp+l+/llYL8P9ORxt5IWsyTePQV1ty1WhQPW8SiE0
 vyq1cLB6JgQhx2W3wvNH9LsMZYGyVlt/OJPk/A3cF41f0oXPS5m22/t15V4R2gu+/ByX
 wwxPvTewkKD5Id+O5CGZesaBu1M1tvliFqFyqMAemy48WHqBFLqFLR10sEX+g1/2ywRW Ig== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3apwpm9hea-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 27 Aug 2021 06:50:59 -0400
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 17RAnEfw081251;
        Fri, 27 Aug 2021 06:50:59 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3apwpm9hdj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 27 Aug 2021 06:50:59 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 17RAlj8X004901;
        Fri, 27 Aug 2021 10:50:56 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma04ams.nl.ibm.com with ESMTP id 3ajs493bf0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 27 Aug 2021 10:50:56 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 17RAoqXE51380710
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 27 Aug 2021 10:50:52 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C1E8011C08D;
        Fri, 27 Aug 2021 10:50:52 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5063811C066;
        Fri, 27 Aug 2021 10:50:52 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.164.230])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 27 Aug 2021 10:50:52 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, imbrenda@linux.ibm.com, drjones@redhat.com,
        qemu-s390x@nongnu.org, pasic@linux.ibm.com, borntraeger@de.ibm.com,
        richard.henderson@linaro.org, mst@redhat.com, qemu-devel@nongnu.org
Subject: [PATCH 1/2] virtio: Linux: Update of virtio_ids
Date:   Fri, 27 Aug 2021 12:50:49 +0200
Message-Id: <1630061450-18744-2-git-send-email-pmorel@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1630061450-18744-1-git-send-email-pmorel@linux.ibm.com>
References: <1630061450-18744-1-git-send-email-pmorel@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: LQoShVuGnUdr_j1VKVidlSTTAB-dPrZS
X-Proofpoint-GUID: xqCbOqo5rabwHEShRRQ5s_gqmyAbqChF
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-27_03:2021-08-26,2021-08-27 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 bulkscore=0
 impostorscore=0 mlxscore=0 phishscore=0 clxscore=1015 mlxlogscore=999
 suspectscore=0 adultscore=0 priorityscore=1501 malwarescore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108270066
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The virtio IDs depends on Linux tree...

Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
---
 include/standard-headers/linux/virtio_ids.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/standard-headers/linux/virtio_ids.h b/include/standard-headers/linux/virtio_ids.h
index 4fe842c3a3..bf61801eeb 100644
--- a/include/standard-headers/linux/virtio_ids.h
+++ b/include/standard-headers/linux/virtio_ids.h
@@ -55,6 +55,7 @@
 #define VIRTIO_ID_FS			26 /* virtio filesystem */
 #define VIRTIO_ID_PMEM			27 /* virtio pmem */
 #define VIRTIO_ID_MAC80211_HWSIM	29 /* virtio mac80211-hwsim */
+#define VIRTIO_ID_PONG			30 /* virtio pong */
 #define VIRTIO_ID_BT			40 /* virtio bluetooth */
 
 #endif /* _LINUX_VIRTIO_IDS_H */
-- 
2.25.1

