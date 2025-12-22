Return-Path: <kvm+bounces-66490-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 1B9F3CD6BD0
	for <lists+kvm@lfdr.de>; Mon, 22 Dec 2025 18:02:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 180493002D3B
	for <lists+kvm@lfdr.de>; Mon, 22 Dec 2025 17:01:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 540FB33C52D;
	Mon, 22 Dec 2025 16:50:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="NY2elnUh"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEB7433A6EC;
	Mon, 22 Dec 2025 16:50:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766422254; cv=none; b=VUxCNTkqFfsRxv93PbQ/2Je4vQymbSBRVqCcTXJHxvBoK6Q9eJK/WoL/D2FX4l0H00y9D/zR0lUQkrPDjr12x8A62vTRmKOVT+ttnZuizWdas6gcO7vU2w+roBD7XHuImZxOU8zNMzm6bPteWgFxZDEF/GKzcZ14cDX8ZXwHb74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766422254; c=relaxed/simple;
	bh=9J579RODsBY3NHU28XOdCR6DAB1tRTgjQOLebDa/iz0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TfiiyouoIVYbYDY3svzVMou+dR8wGMAxe5U07moVfcJyGSb6ET4hHvUTqDlnXvZwGkQNASZbCmAWrId5cGJRSu3FY/2kmdamQ1VtqPyPOWPIIuKBjjeMsqsBLw6e0YxGjKTlM+lxV6ccWLA1WxGDgL3V4h67NVlu7CWZJUsA9C0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=NY2elnUh; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5BMDimLS011531;
	Mon, 22 Dec 2025 16:50:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=oOx4bRoIpElNi+6/4
	tyln67C51SNBcTtwkDt4dOQoUw=; b=NY2elnUhxukFvxeI0isrJjAX9Co8W9jmj
	72hnKt+RTf3I68O3hBH2vr1lo8/s6oddWPjFtxSiHk35QnPK15JpAe8BqZGKbfzm
	f2md2PzQ7mEsujUFJuxmcbNBUuJvD7g5ancyKpFDYfTft/pjP7WjksYqPPcnIDDE
	QohE6fcF+YwCEn32I62KnWilS4T9PCTZB/egiwft/r76p3CqReIU7CcxTIqufQfE
	IcMAMQDtdvhDuLSB1UrbO4F/9nTc0pAZqA/iOpJhiOQut6lMU6m7emXZijkkzZDW
	I6hdJw4JjOkyWzHXJf5wmBlLJjjOWxscAk7XHgOw7TVpi8T5oUz7A==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4b5j7e10yr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 22 Dec 2025 16:50:50 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5BME27sM027076;
	Mon, 22 Dec 2025 16:50:49 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4b6r93486n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 22 Dec 2025 16:50:49 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5BMGokfH54591806
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 22 Dec 2025 16:50:46 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 29B9D20043;
	Mon, 22 Dec 2025 16:50:46 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id BDFF420040;
	Mon, 22 Dec 2025 16:50:44 +0000 (GMT)
Received: from p-imbrenda.ibmuc.com (unknown [9.111.79.149])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 22 Dec 2025 16:50:44 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        borntraeger@de.ibm.com, frankja@linux.ibm.com, nsg@linux.ibm.com,
        nrb@linux.ibm.com, seiden@linux.ibm.com, gra@linux.ibm.com,
        schlameuss@linux.ibm.com, hca@linux.ibm.com, svens@linux.ibm.com,
        agordeev@linux.ibm.com, gor@linux.ibm.com, david@redhat.com,
        gerald.schaefer@linux.ibm.com
Subject: [PATCH v6 08/28] s390/mm: Warn if uv_convert_from_secure_pte() fails
Date: Mon, 22 Dec 2025 17:50:13 +0100
Message-ID: <20251222165033.162329-9-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251222165033.162329-1-imbrenda@linux.ibm.com>
References: <20251222165033.162329-1-imbrenda@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=G8YR0tk5 c=1 sm=1 tr=0 ts=694976ea cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=wP3pNCr1ah4A:10 a=VkNPw1HP01LnGYTKEx00:22 a=VnNF1IyMAAAA:8
 a=gEHK17p0qXyn9eJGjbgA:9
X-Proofpoint-ORIG-GUID: oCFdL7MaIBlkGnZk8jJ_vNBmpfnRIUz4
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjIyMDE1NCBTYWx0ZWRfXwxGry1/Ln++X
 atRNnCX12nlJZg42cYkA5ATxoK1dJm1cAdVWcg+8qEFRFpb7J7MPJFKWqh2fuAG6WAPx3AWcAnW
 xU9LqPAGc4na+fNqB9tpaKzenbOr0AxLUypvPHhag94Z4eTMvreJgisXHyAOjLUAXS1pAVnKB9l
 +48+8f1tvUHmQkubKZfM3r+uEkxqUfqfz9KOFjkaGOU6W34XFSpxgAfhzjPe1JEXr8z/mtW44is
 lb2QKbRVzqytebw4PPvXXrql2r13qLMVPbncNssrGy+b6tWZ4GAai5mqXRH5AS59ybdwDP2J7K2
 eGmdsUS50zB530b0afaIfm45ebB8hSLJvD6XARAaougctWnKqJzoIKEHIfx/xYP/O6kcMBzOwmG
 7BiGNOnMWkJ+5qyGQwfoUGEoU8uzRUzeglDouaG3QQL9TnJYHHr1gQH5SxB/YSEfeLbtPdRtcAV
 UBQIBtBN7LsZ5bgs2Ug==
X-Proofpoint-GUID: oCFdL7MaIBlkGnZk8jJ_vNBmpfnRIUz4
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-22_02,2025-12-22_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 bulkscore=0 clxscore=1015 adultscore=0 spamscore=0
 malwarescore=0 impostorscore=0 phishscore=0 suspectscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2512120000 definitions=main-2512220154

If uv_convert_from_secure_pte() fails, the page becomes unusable by the
host. The failure can only occour in case of hardware malfunction or a
serious KVM bug.

When the unusable page is reused, the system can have issues and
hang.

Print a warning to aid debugging such unlikely scenarios.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 arch/s390/include/asm/pgtable.h | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/arch/s390/include/asm/pgtable.h b/arch/s390/include/asm/pgtable.h
index 73c30b811b98..04335f5e7f47 100644
--- a/arch/s390/include/asm/pgtable.h
+++ b/arch/s390/include/asm/pgtable.h
@@ -1239,7 +1239,7 @@ static inline pte_t ptep_get_and_clear(struct mm_struct *mm,
 	res = ptep_xchg_lazy(mm, addr, ptep, __pte(_PAGE_INVALID));
 	/* At this point the reference through the mapping is still present */
 	if (mm_is_protected(mm) && pte_present(res))
-		uv_convert_from_secure_pte(res);
+		WARN_ON_ONCE(uv_convert_from_secure_pte(res));
 	return res;
 }
 
@@ -1257,7 +1257,7 @@ static inline pte_t ptep_clear_flush(struct vm_area_struct *vma,
 	res = ptep_xchg_direct(vma->vm_mm, addr, ptep, __pte(_PAGE_INVALID));
 	/* At this point the reference through the mapping is still present */
 	if (mm_is_protected(vma->vm_mm) && pte_present(res))
-		uv_convert_from_secure_pte(res);
+		WARN_ON_ONCE(uv_convert_from_secure_pte(res));
 	return res;
 }
 
@@ -1294,9 +1294,10 @@ static inline pte_t ptep_get_and_clear_full(struct mm_struct *mm,
 	/*
 	 * If something went wrong and the page could not be destroyed, or
 	 * if this is not a mm teardown, the slower export is used as
-	 * fallback instead.
+	 * fallback instead. If even that fails, print a warning and leak
+	 * the page, to avoid crashing the whole system.
 	 */
-	uv_convert_from_secure_pte(res);
+	WARN_ON_ONCE(uv_convert_from_secure_pte(res));
 	return res;
 }
 
-- 
2.52.0


