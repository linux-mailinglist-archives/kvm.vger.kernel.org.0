Return-Path: <kvm+bounces-514-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 379707E0778
	for <lists+kvm@lfdr.de>; Fri,  3 Nov 2023 18:34:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 681E11C21081
	for <lists+kvm@lfdr.de>; Fri,  3 Nov 2023 17:34:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9D8BF21A10;
	Fri,  3 Nov 2023 17:34:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="UEwdZAzp"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB544219E7
	for <kvm@vger.kernel.org>; Fri,  3 Nov 2023 17:34:38 +0000 (UTC)
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7442F136;
	Fri,  3 Nov 2023 10:34:37 -0700 (PDT)
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3A3HYT3l013380;
	Fri, 3 Nov 2023 17:34:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=sGgNOwlVhZlYtE5+QhkGDW3azCEhR3HlhRVRiIoH4jY=;
 b=UEwdZAzpWHtEZsSsE0f3s4C0RpAL6QR5liFhmBEk0nGF4h7cqZpKQ/zEuzQ1T1kgYV+P
 DtFtRUK96orxNRHnmSay+3Gk/6kibQqHOrGSq5opoCqJ287a1atBxZWk3F+08w/XLF/0
 0sapJS8HLv9Fa8cjmUAxma4cEVfeiJj/MXJ8z6AjI4qTuLFjggaJ9R220j+4R4kzpaQC
 h2YPMGTxm4Xu+xh48qcCzOzoV/1jahOeNvHtEbTK1KmGUf8M2S26zm2zys4aD8JD7MR8
 OQzp8XDrdfmqcn7ksc7PJ2Q1GDLJaI0FKKw1C2gajTrMRv7okLFRA1HLgL8I9u0hi/7c LQ== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3u553r0d5p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 03 Nov 2023 17:34:35 +0000
Received: from m0356516.ppops.net (m0356516.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3A3HYVRE013423;
	Fri, 3 Nov 2023 17:34:34 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3u553r0cs5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 03 Nov 2023 17:34:34 +0000
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3A3F2lW5011548;
	Fri, 3 Nov 2023 17:30:17 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3u1e4mfc3d-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 03 Nov 2023 17:30:17 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3A3HUAtC18612762
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 3 Nov 2023 17:30:10 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id BAF882004F;
	Fri,  3 Nov 2023 17:30:10 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 749E72004B;
	Fri,  3 Nov 2023 17:30:10 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri,  3 Nov 2023 17:30:10 +0000 (GMT)
From: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
To: Alexander Gordeev <agordeev@linux.ibm.com>,
        Cornelia Huck <cornelia.huck@de.ibm.com>,
        Michael Mueller <mimu@linux.vnet.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        David Hildenbrand <dahi@linux.vnet.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>
Cc: Nina Schoetterl-Glausch <nsg@linux.ibm.com>, linux-kernel@vger.kernel.org,
        Sven Schnelle <svens@linux.ibm.com>, kvm@vger.kernel.org,
        David Hildenbrand <david@redhat.com>, linux-s390@vger.kernel.org
Subject: [PATCH 3/4] KVM: s390: cpu model: Use previously unused constant
Date: Fri,  3 Nov 2023 18:30:07 +0100
Message-Id: <20231103173008.630217-4-nsg@linux.ibm.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20231103173008.630217-1-nsg@linux.ibm.com>
References: <20231103173008.630217-1-nsg@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: fvxm4DdpCvAk0EVaJXMYdbAvxknqzbTC
X-Proofpoint-ORIG-GUID: u45ttFxhuK44a0HVVBEoyCo7tzKAqyI0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-03_16,2023-11-02_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0
 lowpriorityscore=0 suspectscore=0 mlxscore=0 mlxlogscore=999 clxscore=1015
 impostorscore=0 malwarescore=0 spamscore=0 phishscore=0 priorityscore=1501
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2310240000 definitions=main-2311030147

No point in defining a size for the mask if we're not going to use it.

Fixes: 9d8d578605b4 ("KVM: s390: use facilities and cpu_id per KVM")
Signed-off-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
---
 arch/s390/include/asm/kvm_host.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
index 427f9528a7b6..46fcd2f9dff8 100644
--- a/arch/s390/include/asm/kvm_host.h
+++ b/arch/s390/include/asm/kvm_host.h
@@ -811,7 +811,7 @@ struct s390_io_adapter {
 
 struct kvm_s390_cpu_model {
 	/* facility mask supported by kvm & hosting machine */
-	__u64 fac_mask[S390_ARCH_FAC_LIST_SIZE_U64];
+	__u64 fac_mask[S390_ARCH_FAC_MASK_SIZE_U64];
 	struct kvm_s390_vm_cpu_subfunc subfuncs;
 	/* facility list requested by guest (in dma page) */
 	__u64 *fac_list;
-- 
2.39.2


