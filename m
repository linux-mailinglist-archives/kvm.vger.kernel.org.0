Return-Path: <kvm+bounces-1230-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 28AAD7E5C23
	for <lists+kvm@lfdr.de>; Wed,  8 Nov 2023 18:13:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D6F50281564
	for <lists+kvm@lfdr.de>; Wed,  8 Nov 2023 17:13:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D1F5B32C7C;
	Wed,  8 Nov 2023 17:12:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="G4jPMALe"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19300321B8
	for <kvm@vger.kernel.org>; Wed,  8 Nov 2023 17:12:41 +0000 (UTC)
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D0751BC3;
	Wed,  8 Nov 2023 09:12:40 -0800 (PST)
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3A8Gf8Y6019032;
	Wed, 8 Nov 2023 17:12:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=lA65AQ6LI0srspR/dH2FZve8z9ibKrJ4DcDXXG64Vis=;
 b=G4jPMALesj4Xq+nx/BWojIMH8kpzK4LlifVhLiOUgFrvIGFnrsaxCWgwTqBgZA5PkBvk
 CfC63lCNplxW5G5wB3OIJBB2s/zTS1/W58hIt0oSVZ3wlUOM9Zbf4rfQV9MiL5R3/CZn
 1MrDM5joGVvXfoWRXg2x4uT6u6n0ookb4tEG8GUFvfAIDysq4f3X9Vspuvl72OojmOvV
 NbSm6XiTdvjFQHklsHOUHZk/yso3nTXIfs7NWsO6omgHZ7oj7HCNOiAL20biBCFaRE+M
 M67xWn6VKBfz7B/DdKnLkwoUcumJtVSKssAGc/lq/NN+x7p3aT6X5IlHJfhhRqPinYuL TA== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3u8dxh1kwp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 08 Nov 2023 17:12:37 +0000
Received: from m0360083.ppops.net (m0360083.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3A8GfKaY019812;
	Wed, 8 Nov 2023 17:12:36 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3u8dxh1kuc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 08 Nov 2023 17:12:36 +0000
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3A8GNBX8014309;
	Wed, 8 Nov 2023 17:12:35 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3u7w21xa16-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 08 Nov 2023 17:12:35 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3A8HCWLn44434134
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 8 Nov 2023 17:12:32 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 197F520043;
	Wed,  8 Nov 2023 17:12:32 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id DC59A2005A;
	Wed,  8 Nov 2023 17:12:31 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed,  8 Nov 2023 17:12:31 +0000 (GMT)
From: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
To: Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>, Heiko Carstens <hca@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, Sven Schnelle <svens@linux.ibm.com>,
        kvm@vger.kernel.org
Subject: [PATCH v3 3/4] KVM: s390: cpu model: Use proper define for facility mask size
Date: Wed,  8 Nov 2023 18:12:28 +0100
Message-Id: <20231108171229.3404476-4-nsg@linux.ibm.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20231108171229.3404476-1-nsg@linux.ibm.com>
References: <20231108171229.3404476-1-nsg@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: OrdsHv5LkEAgzEgcHnjY4Cq4SKu9YdR2
X-Proofpoint-ORIG-GUID: FD4OhWDO5H_Cirz52WWXPdO2uesol7ei
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-08_05,2023-11-08_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 mlxscore=0
 spamscore=0 malwarescore=0 adultscore=0 impostorscore=0 suspectscore=0
 phishscore=0 priorityscore=1501 mlxlogscore=882 bulkscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311060000 definitions=main-2311080142

Use the previously unused S390_ARCH_FAC_MASK_SIZE_U64 instead of
S390_ARCH_FAC_LIST_SIZE_U64 for defining the fac_mask array.
Note that both values are the same, there is no functional change.

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
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


