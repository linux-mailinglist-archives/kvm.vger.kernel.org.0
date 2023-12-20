Return-Path: <kvm+bounces-4921-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CD549819F58
	for <lists+kvm@lfdr.de>; Wed, 20 Dec 2023 13:53:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0C5BC1C22AFC
	for <lists+kvm@lfdr.de>; Wed, 20 Dec 2023 12:53:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BAEFF2576D;
	Wed, 20 Dec 2023 12:53:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="PMun4O18"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AF9225754;
	Wed, 20 Dec 2023 12:53:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353728.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3BKAg9f2015309;
	Wed, 20 Dec 2023 12:53:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=BWqsX3YXID+rpxJ8zvA26UBhBnUaEVMLLeznHICyurM=;
 b=PMun4O18/bhtkMg+ww3enXNpbYwTCiaQmGVGzuBWFA+dnvIkTDHrwKa9JMIIOK1X+L44
 9Hl3FP05nbk2gsostf5fQjLmu30LuKZXtjJIFh6XTJZulSflMcVuIanGvF6WB0RkCdkQ
 zOwGVPN4wWk4cFoz2ZxT/b8X9DjIMlPHDKuV4+bvGC2Pmm8EFPiSW4e33DC5CW604pdz
 Fq/clvJuxAYFYrDCCU56nQSteGpTU+EUimRWp6cUdv6szfqRNxYrVTads0WfjNPnQkyw
 eajiPsSIBHkgR9gke9NilJXcjdo24wLxoSY3TC+ktuqka7mkUUJH51xqfHATCwRCQfPg qg== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3v3xrbjwj4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 20 Dec 2023 12:53:24 +0000
Received: from m0353728.ppops.net (m0353728.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3BKBpFT5006561;
	Wed, 20 Dec 2023 12:53:23 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3v3xrbjwhh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 20 Dec 2023 12:53:23 +0000
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3BKA6vW9004856;
	Wed, 20 Dec 2023 12:53:22 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3v1pkyxja8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 20 Dec 2023 12:53:22 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3BKCrJDG43254104
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 20 Dec 2023 12:53:19 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 042972004B;
	Wed, 20 Dec 2023 12:53:19 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E6EF120043;
	Wed, 20 Dec 2023 12:53:18 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Wed, 20 Dec 2023 12:53:18 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 25651)
	id 88BF0E03E5; Wed, 20 Dec 2023 13:53:18 +0100 (CET)
From: Christian Borntraeger <borntraeger@linux.ibm.com>
To: KVM <kvm@vger.kernel.org>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Thomas Huth <thuth@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Marc Hartmayer <mhartmay@linux.ibm.com>
Subject: [PATCH v2] KVM: s390: vsie: fix race during shadow creation
Date: Wed, 20 Dec 2023 13:53:17 +0100
Message-ID: <20231220125317.4258-1-borntraeger@linux.ibm.com>
X-Mailer: git-send-email 2.41.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 0B6MWMXV_hQ9xi0E8v8C8dq2-Ik284_g
X-Proofpoint-GUID: C9CtnsnfGJfO3HfzZESPTeYUViS1-_kg
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.997,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-12-20_02,2023-12-14_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 lowpriorityscore=0 mlxlogscore=830 spamscore=0 mlxscore=0 suspectscore=0
 adultscore=0 priorityscore=1501 bulkscore=0 malwarescore=0 clxscore=1015
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2312200091

Right now it is possible to see gmap->private being zero in
kvm_s390_vsie_gmap_notifier resulting in a crash.  This is due to the
fact that we add gmap->private == kvm after creation:

static int acquire_gmap_shadow(struct kvm_vcpu *vcpu,
                               struct vsie_page *vsie_page)
{
[...]
        gmap = gmap_shadow(vcpu->arch.gmap, asce, edat);
        if (IS_ERR(gmap))
                return PTR_ERR(gmap);
        gmap->private = vcpu->kvm;

Let children inherit the private field of the parent.

Reported-by: Marc Hartmayer <mhartmay@linux.ibm.com>
Fixes: a3508fbe9dc6 ("KVM: s390: vsie: initial support for nested virtualization")
Cc: <stable@vger.kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Signed-off-by: Christian Borntraeger <borntraeger@linux.ibm.com>
---
v1->v2: let the child inherit private from parent instead of accessing
        the parent in the notifier
 arch/s390/kvm/vsie.c | 1 -
 arch/s390/mm/gmap.c  | 1 +
 2 files changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/s390/kvm/vsie.c b/arch/s390/kvm/vsie.c
index 8207a892bbe2..db9a180de65f 100644
--- a/arch/s390/kvm/vsie.c
+++ b/arch/s390/kvm/vsie.c
@@ -1220,7 +1220,6 @@ static int acquire_gmap_shadow(struct kvm_vcpu *vcpu,
 	gmap = gmap_shadow(vcpu->arch.gmap, asce, edat);
 	if (IS_ERR(gmap))
 		return PTR_ERR(gmap);
-	gmap->private = vcpu->kvm;
 	vcpu->kvm->stat.gmap_shadow_create++;
 	WRITE_ONCE(vsie_page->gmap, gmap);
 	return 0;
diff --git a/arch/s390/mm/gmap.c b/arch/s390/mm/gmap.c
index 6f96b5a71c63..8da39deb56ca 100644
--- a/arch/s390/mm/gmap.c
+++ b/arch/s390/mm/gmap.c
@@ -1691,6 +1691,7 @@ struct gmap *gmap_shadow(struct gmap *parent, unsigned long asce,
 		return ERR_PTR(-ENOMEM);
 	new->mm = parent->mm;
 	new->parent = gmap_get(parent);
+	new->private = parent->private;
 	new->orig_asce = asce;
 	new->edat_level = edat_level;
 	new->initialized = false;
-- 
2.41.0


