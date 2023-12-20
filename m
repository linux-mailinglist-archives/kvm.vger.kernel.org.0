Return-Path: <kvm+bounces-4908-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 381E781999A
	for <lists+kvm@lfdr.de>; Wed, 20 Dec 2023 08:34:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CC40E1F24DAE
	for <lists+kvm@lfdr.de>; Wed, 20 Dec 2023 07:34:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 41DA516434;
	Wed, 20 Dec 2023 07:34:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="FiCRL98J"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78ABD1CAB8;
	Wed, 20 Dec 2023 07:34:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353722.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3BK6DlFT014863;
	Wed, 20 Dec 2023 07:34:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=RAyJIrFEdM1E1zR7KhwABJaajTgwiicXjDICi085Y84=;
 b=FiCRL98JoC7a2OZ0bAdtI+GD/wlvTKj9ODhuMTw9Yqch2qplfCMkv3TumdJZOkUIrAgC
 8ilM6ZdM6/5ZSbvFZlAKUYk6mHEWUaHxfL0ojO/w0CwB5ufr/01bxgOUl7wSl99IR+u1
 Y21QKtLvjLSHR1z4mBFz/aVmT6ny8OaYMrQT9xrI3x1iMUyXSPw/izRLuF2Q9vLR122q
 pL1o1PXp5k6igzvykiN6KfsH3rmvul0eCRhy5mY9t/VzB9kTGH4/JEDRwtuqyMxbh8Ix
 1yjMhvlvrUutOOICeAHxMfYhfN0qxt5JAqpqjqzSTPrj0eTlthXWKhBVkQ42v8hzbcuo nQ== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3v3ttd9nme-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 20 Dec 2023 07:34:06 +0000
Received: from m0353722.ppops.net (m0353722.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3BK7Rw1x010535;
	Wed, 20 Dec 2023 07:34:06 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3v3ttd9nku-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 20 Dec 2023 07:34:06 +0000
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3BK7FKEP004792;
	Wed, 20 Dec 2023 07:34:05 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3v1pkyw6rc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 20 Dec 2023 07:34:05 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3BK7Y0I841353710
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 20 Dec 2023 07:34:02 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D4DB020043;
	Wed, 20 Dec 2023 07:34:00 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C2F1120040;
	Wed, 20 Dec 2023 07:34:00 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Wed, 20 Dec 2023 07:34:00 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 25651)
	id 86F2BE03E5; Wed, 20 Dec 2023 08:34:00 +0100 (CET)
From: Christian Borntraeger <borntraeger@linux.ibm.com>
To: KVM <kvm@vger.kernel.org>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Thomas Huth <thuth@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>
Subject: [PATCH] KVM: s390: vsie: fix race during shadow creation
Date: Wed, 20 Dec 2023 08:34:00 +0100
Message-ID: <20231220073400.257813-1-borntraeger@linux.ibm.com>
X-Mailer: git-send-email 2.41.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: gkYja45xLKjYBKrSzgtB9y3puMeIS2gf
X-Proofpoint-ORIG-GUID: OIoBNjeb5EMuqXDxGrTY2Udan2_R4W0B
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.997,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-12-20_02,2023-12-14_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=868 phishscore=0
 lowpriorityscore=0 impostorscore=0 adultscore=0 bulkscore=0 malwarescore=0
 suspectscore=0 mlxscore=0 priorityscore=1501 clxscore=1011 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311290000
 definitions=main-2312200050

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

Instead of tracking kvm in the shadow gmap, simply use the parent one.

Cc: David Hildenbrand <david@redhat.com>
Signed-off-by: Christian Borntraeger <borntraeger@linux.ibm.com>
---
 arch/s390/kvm/vsie.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/s390/kvm/vsie.c b/arch/s390/kvm/vsie.c
index 8207a892bbe2..6b06d8ec41b5 100644
--- a/arch/s390/kvm/vsie.c
+++ b/arch/s390/kvm/vsie.c
@@ -579,14 +579,17 @@ static int shadow_scb(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page)
 void kvm_s390_vsie_gmap_notifier(struct gmap *gmap, unsigned long start,
 				 unsigned long end)
 {
-	struct kvm *kvm = gmap->private;
 	struct vsie_page *cur;
 	unsigned long prefix;
 	struct page *page;
+	struct kvm *kvm;
 	int i;
 
 	if (!gmap_is_shadow(gmap))
 		return;
+
+	kvm = gmap->parent->private;
+
 	/*
 	 * Only new shadow blocks are added to the list during runtime,
 	 * therefore we can safely reference them all the time.
@@ -1220,7 +1223,6 @@ static int acquire_gmap_shadow(struct kvm_vcpu *vcpu,
 	gmap = gmap_shadow(vcpu->arch.gmap, asce, edat);
 	if (IS_ERR(gmap))
 		return PTR_ERR(gmap);
-	gmap->private = vcpu->kvm;
 	vcpu->kvm->stat.gmap_shadow_create++;
 	WRITE_ONCE(vsie_page->gmap, gmap);
 	return 0;
-- 
2.41.0


