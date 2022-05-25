Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2725533F5C
	for <lists+kvm@lfdr.de>; Wed, 25 May 2022 16:40:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244850AbiEYOkk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 May 2022 10:40:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244356AbiEYOki (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 May 2022 10:40:38 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CF73326E5;
        Wed, 25 May 2022 07:40:36 -0700 (PDT)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24PCviI3027497;
        Wed, 25 May 2022 14:40:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=LOjfOmlIzo06MRjwClmtDARWrWe2NyOJ++wkHJi3UJo=;
 b=pnX8nbyHxFDhRP6rZOXdTT/wlOar3L/Ope/LOeWWQzVnbEhe+xNieeLOiDlVlcv9wcYD
 I/Ibv+d5bEAAvEPEYiccc214qosylYBeGqjO3l2pVGUASNPdbTjtZr68P365eAxwjZmY
 qqurDRWRLfsD2IS5Md+MrUi9EJnPX1CzqNnrPdLqfEGieFzcYjrQKyDDfJFBatmTWwBh
 PV2K65GjvEL8XJ/d67ypJQTUnxsjdOIE2uqxF+0M5v+6RNcx3Y4wZyzulJ77f1bN+iLR
 2/4LP5BczOhBUTtjXaOYujxN4r+tMFB/vgZwSl+ELfY/9W4JLpVx7BtePhHKIpRmr+yj 4A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g9mx1ae20-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 25 May 2022 14:40:35 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 24PEIKOI030368;
        Wed, 25 May 2022 14:40:35 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g9mx1ae1a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 25 May 2022 14:40:35 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24PEZV9m021968;
        Wed, 25 May 2022 14:40:32 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma05fra.de.ibm.com with ESMTP id 3g93wds23w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 25 May 2022 14:40:32 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24PEQLMH47317400
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 May 2022 14:26:21 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AFBA411C04C;
        Wed, 25 May 2022 14:40:29 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9E8B711C04A;
        Wed, 25 May 2022 14:40:29 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Wed, 25 May 2022 14:40:29 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 4958)
        id 5B6B1E7925; Wed, 25 May 2022 16:40:29 +0200 (CEST)
From:   Eric Farman <farman@linux.ibm.com>
To:     Halil Pasic <pasic@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>
Cc:     Christian Borntraeger <borntraeger@linux.ibm.com>,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        Eric Farman <farman@linux.ibm.com>
Subject: [PATCH 1/1] MAINTAINERS: Update s390 virtio-ccw
Date:   Wed, 25 May 2022 16:40:28 +0200
Message-Id: <20220525144028.2714489-2-farman@linux.ibm.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220525144028.2714489-1-farman@linux.ibm.com>
References: <20220525144028.2714489-1-farman@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: o6Mbe76Rjvwvb6jlevt8QOWi3b4fD2qz
X-Proofpoint-ORIG-GUID: 4p1QLHWs_vgEdWoBvm8n7p15Xjd0zGdS
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-25_04,2022-05-25_02,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 suspectscore=0 bulkscore=0 phishscore=0 lowpriorityscore=0 clxscore=1011
 impostorscore=0 mlxlogscore=999 adultscore=0 mlxscore=0 malwarescore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2205250076
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add myself to the kernel side of virtio-ccw

Signed-off-by: Eric Farman <farman@linux.ibm.com>
---
 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 6618e9b91b6c..1d2c6537b834 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -20933,6 +20933,7 @@ F:	include/uapi/linux/virtio_crypto.h
 VIRTIO DRIVERS FOR S390
 M:	Cornelia Huck <cohuck@redhat.com>
 M:	Halil Pasic <pasic@linux.ibm.com>
+M:	Eric Farman <farman@linux.ibm.com>
 L:	linux-s390@vger.kernel.org
 L:	virtualization@lists.linux-foundation.org
 L:	kvm@vger.kernel.org
-- 
2.32.0

