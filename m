Return-Path: <kvm+bounces-16827-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 76A768BE21C
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 14:30:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 31A6528AF9F
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 12:30:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 79D8F15B991;
	Tue,  7 May 2024 12:29:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="rm7YHu/2"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C79C158A38;
	Tue,  7 May 2024 12:29:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715084996; cv=none; b=S9jkvmmkmuh2GAptW967ankWhOG1nTLGxmEMULWK6ja8tgUKaDqOemPQJB1qgPLjV1t3hFawLrwfplQcr7aviNkSvflDYQNaEpOUqTUzzB4Zb1n84X1LJ0VVm7weAuBgjvXHyY9QTBgb5eG3Dap4WS9pN8ZZZnBY+Of+D6YmqoY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715084996; c=relaxed/simple;
	bh=zAHe1IUHovaCbU6OjlueVt49fZmtkRXts7NoV5IczPs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XYEJAh64hdx3wvi7l/2NNHKRl52Qf/edsBPYCKOQWd/bupzxTlIVYTe1Dt0qiBISbZhPUoq7xK+g4d0UuYCiTKF0nL8CH2pXpDgV3sgaYe8kiWZFPMZCW4ITbr0b1wVEvicEe7jugmFWGmBsI5RfeVs8JFGSSPHoUX4IEUmwmrs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=rm7YHu/2; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 447CTED4002895;
	Tue, 7 May 2024 12:29:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=YV8AjjX0dJ7+H/bOjGDouEUu9rDMBYcwGvwnSsx2MzQ=;
 b=rm7YHu/2EuvGb8baN3sQBzPjaKhT8o2hpT6nXqZ5JjU2u9gDt1M6xuepJ/aVYrkfuW8h
 ynym2abSh5OdN9s8/1+UiV/h1avhM1dBe5w6qQZ/ZJpuF2c2Dhj1VSobQkSNeJiT71PB
 kEttQ40LMvC3c83WkAbKcX9tCCwu9eJnJ0Gn2wX6n+we7fKruCrktFfYmcUgHmyj+4nr
 gmyZ0J2/tMhQbkW61dhsDeZWETxziHGdN8xiRL7X9F8CEq6GRBegKdGHhcOMftZur7UA
 +TeVcAOjQKdW29nVlUjEThtfn3lABIvjagr5VblDBGr5qr2TlFIDBiLt363ylkNbouo1 IQ== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3xymbb002n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 07 May 2024 12:29:53 +0000
Received: from m0360072.ppops.net (m0360072.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 447CTqm0003655;
	Tue, 7 May 2024 12:29:52 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3xymbb002k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 07 May 2024 12:29:52 +0000
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 447BKlFm004759;
	Tue, 7 May 2024 12:29:52 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3xx5yh4nf9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 07 May 2024 12:29:52 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 447CTkI852298096
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 7 May 2024 12:29:48 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 65CB420043;
	Tue,  7 May 2024 12:29:46 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 150B02004E;
	Tue,  7 May 2024 12:29:46 +0000 (GMT)
Received: from m83lp52.lnxne.boe (unknown [9.152.108.100])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue,  7 May 2024 12:29:46 +0000 (GMT)
From: Christian Borntraeger <borntraeger@linux.ibm.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: KVM <kvm@vger.kernel.org>, Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Thomas Huth <thuth@redhat.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>
Subject: [GIT PULL 1/1] KVM: s390: Check kvm pointer when testing KVM_CAP_S390_HPAGE_1M
Date: Tue,  7 May 2024 14:29:45 +0200
Message-ID: <20240507122945.2571-2-borntraeger@linux.ibm.com>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240507122945.2571-1-borntraeger@linux.ibm.com>
References: <20240507122945.2571-1-borntraeger@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: fWR656KgzOWZaNgc84d4Fq2Ar-rvsSJ1
X-Proofpoint-ORIG-GUID: qGHd1l5VFlIRhP-PUK1dYIVqP2o3jxQP
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.11.176.26
 definitions=2024-05-07_06,2024-05-06_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=905
 priorityscore=1501 phishscore=0 lowpriorityscore=0 malwarescore=0
 suspectscore=0 adultscore=0 spamscore=0 mlxscore=0 clxscore=1011
 impostorscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2404010000 definitions=main-2405070086

From: Jean-Philippe Brucker <jean-philippe@linaro.org>

KVM allows issuing the KVM_CHECK_EXTENSION ioctl either on the /dev/kvm
fd or the VM fd. In the first case, kvm_vm_ioctl_check_extension() is
called with kvm==NULL. Ensure we don't dereference the pointer in that
case.

Fixes: 40ebdb8e59df ("KVM: s390: Make huge pages unavailable in ucontrol VMs")
Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Christian Borntraeger <borntraeger@linux.ibm.com>
Message-ID: <20240419160723.320910-2-jean-philippe@linaro.org>
Signed-off-by: Christian Borntraeger <borntraeger@linux.ibm.com>
---
 arch/s390/kvm/kvm-s390.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 5147b943a864..7721eb522f43 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -587,7 +587,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 		break;
 	case KVM_CAP_S390_HPAGE_1M:
 		r = 0;
-		if (hpage && !kvm_is_ucontrol(kvm))
+		if (hpage && !(kvm && kvm_is_ucontrol(kvm)))
 			r = 1;
 		break;
 	case KVM_CAP_S390_MEM_OP:
-- 
2.44.0


