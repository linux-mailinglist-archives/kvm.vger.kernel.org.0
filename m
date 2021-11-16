Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 207A2453366
	for <lists+kvm@lfdr.de>; Tue, 16 Nov 2021 14:59:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236971AbhKPOBO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Nov 2021 09:01:14 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:41328 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236907AbhKPOBJ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 16 Nov 2021 09:01:09 -0500
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AGDn2oV024185;
        Tue, 16 Nov 2021 13:58:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=24XwgowMOe+H4X0KMG48GpSkoX9otXMm727Wk9MufcM=;
 b=BbbepXczo5GbNMrdvEfqAQmC5bR5EGDi7m7fWvPfkO+PrYNgT/ChjI5PCZ6yXlt9JfEY
 crfpxUw+nBu4wD1mWS8C4ZFG+BdJC8p+988j6c79TFO2oNnmJUkw1rCDZW3Ytk6IvsrQ
 DtcVFFQHujcoeFT+8bCu5vdMtbK5xJft8pYEc8YKVHs06eLVmqvYSEN0jetRc+uOJXzP
 13L5vHFcGf9awh6s6Zmw5m/ZHr1cbpL9K7FSuSZBdPe1gMROj6UzaWdLPgYp7QC7h8T3
 xUIz7Gd4YQuOJv+EJtXMOt1iwMsgeSeSAn4hT1wieM1mJLcsHCh7p5avtL0AVtWbxIEr dA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ccdus05rv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 16 Nov 2021 13:58:12 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1AGDnKjN024470;
        Tue, 16 Nov 2021 13:58:11 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ccdus05qf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 16 Nov 2021 13:58:11 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1AGDT6Rw031965;
        Tue, 16 Nov 2021 13:58:07 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma03ams.nl.ibm.com with ESMTP id 3ca50a02v6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 16 Nov 2021 13:58:07 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1AGDp8wf63963498
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 16 Nov 2021 13:51:08 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4A040AE072;
        Tue, 16 Nov 2021 13:58:04 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 37A6AAE06A;
        Tue, 16 Nov 2021 13:58:04 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Tue, 16 Nov 2021 13:58:04 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 25651)
        id DE412E04E9; Tue, 16 Nov 2021 14:58:03 +0100 (CET)
From:   Christian Borntraeger <borntraeger@linux.ibm.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
Cc:     KVM <kvm@vger.kernel.org>, Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>
Subject: [PATCH 1/1] MAINTAINERS: update email address of borntraeger
Date:   Tue, 16 Nov 2021 14:58:03 +0100
Message-Id: <20211116135803.119489-2-borntraeger@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211116135803.119489-1-borntraeger@linux.ibm.com>
References: <20211116135803.119489-1-borntraeger@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: wMaxGH3eSrpGFfZ_FnENYY3qHf7urITv
X-Proofpoint-ORIG-GUID: zy3h-sWPy-PllsAd3lzPtyIU7dGSP7yw
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-16_02,2021-11-16_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 mlxlogscore=984 priorityscore=1501 suspectscore=0 bulkscore=0 phishscore=0
 spamscore=0 mlxscore=0 malwarescore=0 impostorscore=0 clxscore=1015
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111160069
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

My borntraeger@de.ibm.com email is just a forwarder to the
linux.ibm.com address. Let us remove the extra hop to avoid
a potential source of errors.

While at it, add the relevant email addresses to mailmap.

Signed-off-by: Christian Borntraeger <borntraeger@linux.ibm.com>
---
 .mailmap    | 3 +++
 MAINTAINERS | 4 ++--
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/.mailmap b/.mailmap
index 14314e3c5d5e..6277bb27b4bf 100644
--- a/.mailmap
+++ b/.mailmap
@@ -71,6 +71,9 @@ Chao Yu <chao@kernel.org> <chao2.yu@samsung.com>
 Chao Yu <chao@kernel.org> <yuchao0@huawei.com>
 Chris Chiu <chris.chiu@canonical.com> <chiu@endlessm.com>
 Chris Chiu <chris.chiu@canonical.com> <chiu@endlessos.org>
+Christian Borntraeger <borntraeger@linux.ibm.com> <borntraeger@de.ibm.com>
+Christian Borntraeger <borntraeger@linux.ibm.com> <cborntra@de.ibm.com>
+Christian Borntraeger <borntraeger@linux.ibm.com> <borntrae@de.ibm.com>
 Christophe Ricard <christophe.ricard@gmail.com>
 Christoph Hellwig <hch@lst.de>
 Colin Ian King <colin.king@intel.com> <colin.king@canonical.com>
diff --git a/MAINTAINERS b/MAINTAINERS
index 7a2345ce8521..b9a09edb3efb 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -10445,7 +10445,7 @@ F:	arch/riscv/include/uapi/asm/kvm*
 F:	arch/riscv/kvm/
 
 KERNEL VIRTUAL MACHINE for s390 (KVM/s390)
-M:	Christian Borntraeger <borntraeger@de.ibm.com>
+M:	Christian Borntraeger <borntraeger@linux.ibm.com>
 M:	Janosch Frank <frankja@linux.ibm.com>
 R:	David Hildenbrand <david@redhat.com>
 R:	Claudio Imbrenda <imbrenda@linux.ibm.com>
@@ -16573,7 +16573,7 @@ F:	drivers/video/fbdev/savage/
 S390
 M:	Heiko Carstens <hca@linux.ibm.com>
 M:	Vasily Gorbik <gor@linux.ibm.com>
-M:	Christian Borntraeger <borntraeger@de.ibm.com>
+M:	Christian Borntraeger <borntraeger@linux.ibm.com>
 R:	Alexander Gordeev <agordeev@linux.ibm.com>
 L:	linux-s390@vger.kernel.org
 S:	Supported
-- 
2.31.1

