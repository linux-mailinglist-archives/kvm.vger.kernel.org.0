Return-Path: <kvm+bounces-29390-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id BE9F99AA1C3
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2024 14:07:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 489CEB22BEE
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2024 12:07:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B741119F121;
	Tue, 22 Oct 2024 12:06:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="YttzeOXZ"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19B0C19DF66;
	Tue, 22 Oct 2024 12:06:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729598776; cv=none; b=mcLeUSekAr9kKFJiV8XKNh1xpfXjHqxjbCyOnFP2ptk4DdY5/2D9LpymtqnITIB9y4jP8sAfu3428MJxD31Vokh5kfDEN80GSiB/CQYRlTWyG2VkQepJDZwWWWlHnKW7Pk1yc4OC8WUbnlOaoumMUmnoobAyDlPbI9Jh++610GM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729598776; c=relaxed/simple;
	bh=Y5FMepZoxGiJrpODOM+3gyu4NwjOwdk0gHSXaMccSD8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CvQ8hYDvVf2ZV1/WQOd0lfZF/02C3u55FR+oQrSbRDOEUIhu2yl1zcNiyLcbdVjIP3Go81NmlD0cdr9vog4aL5XqjlU6Q00Grg8HRwxtdz6AHpzHUjtLJRQ8+Magux/sCeOWK+Gwh1FjDSPAyswq6IJwyCN54FbngdHeLAE8ks0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=YttzeOXZ; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49M2HCnU029534;
	Tue, 22 Oct 2024 12:06:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=QyY9neWltee04QluT
	O2GfGfyxlN0Z79eG6W6IJi/hzg=; b=YttzeOXZcKMlWAmHcZPma+Wh0skMJlaPm
	khHa8qpYtIxyWGp7F+4MOLll8qOaQVRqLgioC8QSXbQhik0MhyVxlHnsdgm/oeQh
	nkpnFMQMSWN7z1k5DNYahTdLFPvNsXuKm9+y9D9NEgnbdr9zkjvZMola1ydW0aGE
	+v3F7UMdGD91o7je0Qo197hitCkVInPKIzxJO4w6u0hvvJEVBViBrXqHOccxw9Q+
	WfQoo/NBAJq8uvLZvPZV7BkuDklEHtta3FahxlnEk/GLcq+PmBjsnbfQ+7pKKgcZ
	z1thnjFWAtqgf9aUwecJ/xIRBPfskmK1yLyVYruCbk4kryKNWwlkA==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 42c5eudry2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 22 Oct 2024 12:06:11 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 49MAOb6l018605;
	Tue, 22 Oct 2024 12:06:10 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 42csajauax-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 22 Oct 2024 12:06:10 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 49MC67Dh18416082
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 22 Oct 2024 12:06:07 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5CEE620043;
	Tue, 22 Oct 2024 12:06:07 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C20A320040;
	Tue, 22 Oct 2024 12:06:06 +0000 (GMT)
Received: from p-imbrenda.ibmuc.com (unknown [9.171.37.93])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 22 Oct 2024 12:06:06 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: borntraeger@de.ibm.com, nsg@linux.ibm.com, nrb@linux.ibm.com,
        frankja@linux.ibm.com, seiden@linux.ibm.com, hca@linux.ibm.com,
        agordeev@linux.ibm.com, gor@linux.ibm.com,
        gerald.schaefer@linux.ibm.com, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, david@redhat.com
Subject: [PATCH v4 04/11] s390/mm/gmap: Fix __gmap_fault() return code
Date: Tue, 22 Oct 2024 14:05:54 +0200
Message-ID: <20241022120601.167009-5-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241022120601.167009-1-imbrenda@linux.ibm.com>
References: <20241022120601.167009-1-imbrenda@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 4in1kTelQOLqK7G99PyyB8Y_oDhKS6Px
X-Proofpoint-ORIG-GUID: 4in1kTelQOLqK7G99PyyB8Y_oDhKS6Px
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 adultscore=0 spamscore=0 suspectscore=0 phishscore=0 impostorscore=0
 mlxlogscore=889 mlxscore=0 bulkscore=0 priorityscore=1501 malwarescore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2409260000 definitions=main-2410220074

Errors in fixup_user_fault() were masked and -EFAULT was returned for
any error, including out of memory.

Fix this by returning the correct error code. This means that in many
cases the error code will be propagated all the way to userspace.

Suggested-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Heiko Carstens <hca@linux.ibm.com>
Acked-by: Alexander Gordeev <agordeev@linux.ibm.com>
---
 arch/s390/mm/gmap.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/arch/s390/mm/gmap.c b/arch/s390/mm/gmap.c
index f51ad948ba53..a8746f71c679 100644
--- a/arch/s390/mm/gmap.c
+++ b/arch/s390/mm/gmap.c
@@ -718,13 +718,12 @@ static int __gmap_fault(struct gmap *gmap, unsigned long gaddr, unsigned int fau
 	if (IS_ERR_VALUE(vmaddr))
 		return vmaddr;
 
-	if (fault_flags & FAULT_FLAG_RETRY_NOWAIT) {
+	if (fault_flags & FAULT_FLAG_RETRY_NOWAIT)
 		rc = fixup_user_fault_nowait(gmap->mm, vmaddr, fault_flags, &unlocked);
-		if (rc)
-			return rc;
-	} else if (fixup_user_fault(gmap->mm, vmaddr, fault_flags, &unlocked)) {
-		return -EFAULT;
-	}
+	else
+		rc = fixup_user_fault(gmap->mm, vmaddr, fault_flags, &unlocked);
+	if (rc)
+		return rc;
 	/*
 	 * In the case that fixup_user_fault unlocked the mmap_lock during
 	 * fault-in, redo __gmap_translate() to avoid racing with a
-- 
2.47.0


