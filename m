Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 946913F97FF
	for <lists+kvm@lfdr.de>; Fri, 27 Aug 2021 12:18:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244903AbhH0KSR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Aug 2021 06:18:17 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:8720 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S244857AbhH0KSQ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 27 Aug 2021 06:18:16 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17RA3awC090221
        for <kvm@vger.kernel.org>; Fri, 27 Aug 2021 06:17:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=h+XJS0O2VK81ak4qZU8h29PUmYbTsg+AHN215ko2/AA=;
 b=om7FzVoNuW3wywOMC54l2igbqFLkbq+KSgMETP2mJwPIJ/ABrZcjhxGBJG6S+NB01NsM
 9OPT2Kvvg0NCAUdmlbnBifJOq7Rs03lVJOmboaP8CBGRiAw2w+uXw8Ro2KETgHW5bKPR
 H2z9DPhX7Uqa5+YXuiIkV6C0+P0wkKmVgekuEylEAVBC66uFve0/2y4J+LDdEuvi99wu
 oG6tg9SH2R9/3s5SbOL3Ryluns0SvY99LDggDwewD3By1ybllLHXjCbLOyp/je8/3KCs
 iF4PG1IZlWVthRi7OHyLMnsvZ9+Jfz3tsz/RoYbnjYE+nE6dRzBVxSeSVuu/S89nWh87 rg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3apw1n216b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 27 Aug 2021 06:17:27 -0400
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 17RAHRxC157686
        for <kvm@vger.kernel.org>; Fri, 27 Aug 2021 06:17:27 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3apw1n215w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 27 Aug 2021 06:17:27 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 17RAD4HS004852;
        Fri, 27 Aug 2021 10:17:25 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma03ams.nl.ibm.com with ESMTP id 3ajs48ka8a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 27 Aug 2021 10:17:24 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 17RAHL2L57999730
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 27 Aug 2021 10:17:21 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A16194C044;
        Fri, 27 Aug 2021 10:17:21 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 55F9E4C040;
        Fri, 27 Aug 2021 10:17:21 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.164.230])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 27 Aug 2021 10:17:21 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, imbrenda@linux.ibm.com, drjones@redhat.com
Subject: [kvm-unit-tests PATCH 1/7] arm: virtio: move VIRTIO transport initialization inside virtio-mmio
Date:   Fri, 27 Aug 2021 12:17:14 +0200
Message-Id: <1630059440-15586-2-git-send-email-pmorel@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1630059440-15586-1-git-send-email-pmorel@linux.ibm.com>
References: <1630059440-15586-1-git-send-email-pmorel@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: AvI_EcN0zzop18Aby6WbmYckd90Xroxe
X-Proofpoint-GUID: hPU2ayeBW9F3EH_O7HijdhfFhvYm4qBf
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-27_03:2021-08-26,2021-08-27 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 adultscore=0
 malwarescore=0 mlxlogscore=999 mlxscore=0 spamscore=0 lowpriorityscore=0
 impostorscore=0 suspectscore=0 clxscore=1015 priorityscore=1501
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108270063
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

To be able to use different VIRTIO transport in the future we need
the initialisation entry call of the transport to be inside the
transport file and keep the VIRTIO level transport agnostic.

Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
---
 lib/virtio-mmio.c | 2 +-
 lib/virtio-mmio.h | 2 --
 lib/virtio.c      | 5 -----
 3 files changed, 1 insertion(+), 8 deletions(-)

diff --git a/lib/virtio-mmio.c b/lib/virtio-mmio.c
index e5e8f660..fb8a86a3 100644
--- a/lib/virtio-mmio.c
+++ b/lib/virtio-mmio.c
@@ -173,7 +173,7 @@ static struct virtio_device *virtio_mmio_dt_bind(u32 devid)
 	return &vm_dev->vdev;
 }
 
-struct virtio_device *virtio_mmio_bind(u32 devid)
+struct virtio_device *virtio_bind(u32 devid)
 {
 	return virtio_mmio_dt_bind(devid);
 }
diff --git a/lib/virtio-mmio.h b/lib/virtio-mmio.h
index 250f28a0..73ddbd23 100644
--- a/lib/virtio-mmio.h
+++ b/lib/virtio-mmio.h
@@ -60,6 +60,4 @@ struct virtio_mmio_device {
 	void *base;
 };
 
-extern struct virtio_device *virtio_mmio_bind(u32 devid);
-
 #endif /* _VIRTIO_MMIO_H_ */
diff --git a/lib/virtio.c b/lib/virtio.c
index 69054757..e10153b9 100644
--- a/lib/virtio.c
+++ b/lib/virtio.c
@@ -123,8 +123,3 @@ void *virtqueue_get_buf(struct virtqueue *_vq, unsigned int *len)
 
 	return ret;
 }
-
-struct virtio_device *virtio_bind(u32 devid)
-{
-	return virtio_mmio_bind(devid);
-}
-- 
2.25.1

