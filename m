Return-Path: <kvm+bounces-47892-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E7EF4AC6DB8
	for <lists+kvm@lfdr.de>; Wed, 28 May 2025 18:17:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CE7004E225C
	for <lists+kvm@lfdr.de>; Wed, 28 May 2025 16:17:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7483728CF7A;
	Wed, 28 May 2025 16:16:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="oNq48NfY"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED2602874E0;
	Wed, 28 May 2025 16:16:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748449014; cv=none; b=F/yo3bbyxPdA3BpUVvCUoLhiJ4xnsdhWIUVCHWxrHt5GzXMjzXEw7fUd1sJvvFgtviym4zzlYD6FhFMtqm2GFNQezXfQc45XE6/V8JApUzUqQQU9r+NVA7hdCWOU0DFCD+Y6MdNO9mbWTHRT0tX7SfitgQkcwYxhiKgBnWNwsDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748449014; c=relaxed/simple;
	bh=qqwoqiY+PkmxZAOOT5oERTLVKSgjAD1ubBoDHdJMh3A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BiyJ4PoZS517SDeeNXOK7STf4sIbENwPeb/WeoWohOMiyqpayULPCjm2aHOu3Ayp3KYfRot99wSns+kNbeGhEukyO/DEktssO0lPAnvglt7rgF08hVgwp96nMVK/mva/5qltEY3pFkFF0jvdky16nMHXz60xkTS7CVkLPjDyOUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=oNq48NfY; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54SE9lZm018466;
	Wed, 28 May 2025 16:16:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=9rbmBX28N8S1GsFFI
	k0mSVvSli42qcynagHl94Uh1wE=; b=oNq48NfY4AyEmqduwl+/iqDDWbCuuKQJT
	8NjuAQxDjtXAiVomwprgIvIxWTYcKCD8y/GcB+J0lqhUWpfDKvLttB+DuYKOO2CK
	PhN/En/2NUxdhgmxCKqtC5YzZBJYXZWxsrApeBHzO3wnTxP9SJFielpGEpnftLEi
	oNjU1msk7lKJBIgj0glYC9cAD/jP66fgWxLEKRyU89Dg8pKaB0TzPvo1h+ggoz9L
	NuQasaIRrK0IjP22mV8EQMR9qeG10ZiLBiHqkxiGOsPFs+yIIMhXqSoFNPCbtZRi
	FqUVU12hv3+ZlqakxXfnPUEUknyUUHPPioIUKX1QBsClB/m4YXueg==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 46x40hgpyj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 28 May 2025 16:16:50 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 54SEq9d9021346;
	Wed, 28 May 2025 16:16:49 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 46utnmr2g5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 28 May 2025 16:16:49 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 54SGGjve55443916
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 28 May 2025 16:16:45 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8ADF220049;
	Wed, 28 May 2025 16:16:45 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 372E520040;
	Wed, 28 May 2025 16:16:45 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.111.56.81])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 28 May 2025 16:16:45 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: pbonzini@redhat.com
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        borntraeger@de.ibm.com, david@redhat.com
Subject: [GIT PULL v1 1/7] s390/uv: Don't return 0 from make_hva_secure() if the operation was not successful
Date: Wed, 28 May 2025 18:16:30 +0200
Message-ID: <20250528161636.280717-2-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250528161636.280717-1-imbrenda@linux.ibm.com>
References: <20250528161636.280717-1-imbrenda@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTI4MDEzNCBTYWx0ZWRfX1+GNHBUppdwp SUFCAPGlWEA902CjvU0FQvusY7sLzVMR3ivbjTOfnskxKgeRRr+dYJIcQtoQoQ7NQGPtCCMyqGK HhO+j07NkjYukBEU2mHJBYiOaXy3/MMb44GdfFKlnNYgPEfPTHROHlOOroE9+03eJAWBsR60Rq2
 XID+xN5pQ192Z/V+fwUHix0iu/tTSp2iOQnfMaphtzuFuMjiC+oNRvoXzT9fCAWOfhsO6/jtrsQ ChvlwUdv5+fyo5SDVbcq/WKO8SYCH9sbmNI+8Md2h3oz6gItiuOk9q4DngEA6HHV16TtTOZBJlT oojXcuO1pUzLXJ9fkORM0y0A07mJNems5zwH9l1MFhzX3Oma0fSnQwZZf10G4qJoOHH7453iu66
 7Lw6ciR/5cESMUqZAKkMp4vmgC7JEsfgxNpIHBkzO4riqvAOVeCDe6YCuNYGb6njX7hOAq+U
X-Proofpoint-GUID: HNW834naVDyBENZrwviYekHpuNygMLea
X-Authority-Analysis: v=2.4 cv=WOd/XmsR c=1 sm=1 tr=0 ts=683736f2 cx=c_pps a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17 a=07g3GG6zAUHADp5N:21 a=dt9VzEwgFbYA:10 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8 a=VnNF1IyMAAAA:8 a=aOG7VxYrwdY-fDjLD2EA:9
X-Proofpoint-ORIG-GUID: HNW834naVDyBENZrwviYekHpuNygMLea
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-28_07,2025-05-27_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 spamscore=0
 bulkscore=0 lowpriorityscore=0 suspectscore=0 mlxlogscore=999
 impostorscore=0 clxscore=1015 malwarescore=0 priorityscore=1501
 adultscore=0 phishscore=0 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2505160000
 definitions=main-2505280134

From: David Hildenbrand <david@redhat.com>

If s390_wiggle_split_folio() returns 0 because splitting a large folio
succeeded, we will return 0 from make_hva_secure() even though a retry
is required. Return -EAGAIN in that case.

Otherwise, we'll return 0 from gmap_make_secure(), and consequently from
unpack_one(). In kvm_s390_pv_unpack(), we assume that unpacking
succeeded and skip unpacking this page. Later on, we run into issues
and fail booting the VM.

So far, this issue was only observed with follow-up patches where we
split large pagecache XFS folios. Maybe it can also be triggered with
shmem?

We'll cleanup s390_wiggle_split_folio() a bit next, to also return 0
if no split was required.

Fixes: d8dfda5af0be ("KVM: s390: pv: fix race when making a page secure")
Cc: stable@vger.kernel.org
Signed-off-by: David Hildenbrand <david@redhat.com>
Link: https://lore.kernel.org/r/20250516123946.1648026-2-david@redhat.com
Message-ID: <20250516123946.1648026-2-david@redhat.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 arch/s390/kernel/uv.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/s390/kernel/uv.c b/arch/s390/kernel/uv.c
index 9a5d5be8acf4..2cc3b599c7fe 100644
--- a/arch/s390/kernel/uv.c
+++ b/arch/s390/kernel/uv.c
@@ -393,8 +393,11 @@ int make_hva_secure(struct mm_struct *mm, unsigned long hva, struct uv_cb_header
 	folio_walk_end(&fw, vma);
 	mmap_read_unlock(mm);
 
-	if (rc == -E2BIG || rc == -EBUSY)
+	if (rc == -E2BIG || rc == -EBUSY) {
 		rc = s390_wiggle_split_folio(mm, folio, rc == -E2BIG);
+		if (!rc)
+			rc = -EAGAIN;
+	}
 	folio_put(folio);
 
 	return rc;
-- 
2.49.0


