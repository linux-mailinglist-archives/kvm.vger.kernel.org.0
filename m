Return-Path: <kvm+bounces-9855-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id CF6A58674AD
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 13:22:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6A56C1F2C41E
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 12:22:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF7A5604CB;
	Mon, 26 Feb 2024 12:22:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="C5V2eFUU"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D17591B27D;
	Mon, 26 Feb 2024 12:22:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708950141; cv=none; b=tGhIU6t9/PAT9duF0RCwOoelXoI4ygyEo6HlU/JwGtgwG8kbzoqiSrXtdqp1PqOg38ye1tynMDU5edt9vbfWq9ZvoUekvqfHiYWYAS1J0TJQuaGmbTFHnZYDGbepVCOS1Aj1857vCl8FAxURnoYXlsgZuQ/TOFvXg6ISZxRC9Kg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708950141; c=relaxed/simple;
	bh=QFPvDa2lxmo4YOn1ORSLR33cthEAeOK/nOOiHFx4OGM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WOmU4hpyC/MnNYvKLHslFWNZulwQZexlhIkon344Gr4zWDnSpCyqUxgyFvmHPVSFpDutMt6oC1rOproF1hKwj2nSf6wmcfQRn5QdwyFP+i/PDOsVON6CMjWt2VW8aIFU4cRRZnWyKNvH9nrY+yhsadQXpk8neuPMvWxD0VfONbc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=C5V2eFUU; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 41QBHxf8017101;
	Mon, 26 Feb 2024 12:22:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=VyO/Bn9rRziw5b+b8H3zbS3vRf3SyqHOy0xyWMtCGEA=;
 b=C5V2eFUU/Lq7vAdwpvXuel4JDv8yqamSRuALt99g9NF3N4qy9OwqZObrBmdyk03TY2BN
 Y/eOJpMwC/TZ9qZmLsFTNSaD1NXIRzQ3dQIjqZC82Y6adb6rnHQ+yDV/a9lpBeYBUwjb
 2yFcIYcEW5nGBJFn0LUGyLYI5x08AbJ0ji3s0ffq/ZHSZAbQXZXsQSOk3MOKvGBh4rpn
 IpRveIVroBU5xWAh3zEhvLDpqndONZA9ICmBLVcYfYJ28N0w8CUmYG8w3XL1VzNX25KH
 q4+mrdjM5Ughk0ycQubFA60s2fNlshNzn2n1uJVuEnR6qMhtsWMTge82V/ws49nvnAGw Hg== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3wgsmvharc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 26 Feb 2024 12:22:18 +0000
Received: from m0360083.ppops.net (m0360083.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 41QBJSSs022278;
	Mon, 26 Feb 2024 12:22:18 GMT
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3wgsmvhapt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 26 Feb 2024 12:22:18 +0000
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 41Q9x4uF023910;
	Mon, 26 Feb 2024 12:22:17 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 3wfw0k0jvx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 26 Feb 2024 12:22:17 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 41QCMBJW12255798
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 26 Feb 2024 12:22:13 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id ACB0120040;
	Mon, 26 Feb 2024 12:22:11 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id F111D2004B;
	Mon, 26 Feb 2024 12:22:10 +0000 (GMT)
Received: from li-9fd7f64c-3205-11b2-a85c-df942b00d78d.fritz.box (unknown [9.171.77.191])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 26 Feb 2024 12:22:10 +0000 (GMT)
From: Janosch Frank <frankja@linux.ibm.com>
To: pbonzini@redhat.com
Cc: kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        borntraeger@linux.ibm.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        seiden@linux.ibm.com, nsg@linux.ibm.com, farman@linux.ibm.com,
        agordeev@linux.ibm.com
Subject: [GIT PULL 3/3] KVM: s390: selftest: memop: Fix undefined behavior
Date: Mon, 26 Feb 2024 13:13:08 +0100
Message-ID: <20240226122059.58099-4-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240226122059.58099-1-frankja@linux.ibm.com>
References: <20240226122059.58099-1-frankja@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 64ySW8unw7eWraq9kQCf9cdKBuA1ykN9
X-Proofpoint-GUID: nBb8vMWyGElU3ko5lbyI1ziYHwOPO2ZD
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-02-26_09,2024-02-26_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 suspectscore=0
 lowpriorityscore=0 spamscore=0 mlxscore=0 mlxlogscore=999 bulkscore=0
 phishscore=0 impostorscore=0 malwarescore=0 priorityscore=1501
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2402260094

From: Nina Schoetterl-Glausch <nsg@linux.ibm.com>

If an integer's type has x bits, shifting the integer left by x or more
is undefined behavior.
This can happen in the rotate function when attempting to do a rotation
of the whole value by 0.

Fixes: 0dd714bfd200 ("KVM: s390: selftest: memop: Add cmpxchg tests")
Signed-off-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
Link: https://lore.kernel.org/r/20240111094805.363047-1-nsg@linux.ibm.com
Acked-by: Janosch Frank <frankja@linux.ibm.com>
Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Message-Id: <20240111094805.363047-1-nsg@linux.ibm.com>
---
 tools/testing/selftests/kvm/s390x/memop.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/testing/selftests/kvm/s390x/memop.c b/tools/testing/selftests/kvm/s390x/memop.c
index bb3ca9a5d731..4ec8d0181e8d 100644
--- a/tools/testing/selftests/kvm/s390x/memop.c
+++ b/tools/testing/selftests/kvm/s390x/memop.c
@@ -489,6 +489,8 @@ static __uint128_t rotate(int size, __uint128_t val, int amount)
 
 	amount = (amount + bits) % bits;
 	val = cut_to_size(size, val);
+	if (!amount)
+		return val;
 	return (val << (bits - amount)) | (val >> amount);
 }
 
-- 
2.43.2


