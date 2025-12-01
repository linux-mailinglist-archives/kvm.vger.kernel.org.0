Return-Path: <kvm+bounces-64997-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C86E7C9766E
	for <lists+kvm@lfdr.de>; Mon, 01 Dec 2025 13:54:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1BA553A7EBD
	for <lists+kvm@lfdr.de>; Mon,  1 Dec 2025 12:49:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 78564313E2C;
	Mon,  1 Dec 2025 12:45:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="iVwlcHrk"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3AEC313278;
	Mon,  1 Dec 2025 12:45:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764593121; cv=none; b=ZlPzakd8L9yV6GxqEJPK7OwYibRHQbzvC/jjVqjud6tpvzYkn9KCJOyfc/h9NAp5/x2FACit/qnTe6fzoxAmUr9hSuV47Dj4LuJZzle71FgzQQZvFhfbI8BwIR+CPMYDIwPyoCrO1ey/vqO3lrU53t0pSlc5msVUuHYLG2rX/R8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764593121; c=relaxed/simple;
	bh=YLo8Bo0DQ/Ont7cTzjxzLzijo+rgo94Aa+JxpeA6pZ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cEkoJmNF/J7jwGYnGkx+iol8bVwo/7PmGveXvLw9MSF+7PPI8HBWw8S71a72JkF2YO9eYXrxaqeJ+pxs5t4+S6v2sN96lrRhfZ7+GN6XiJMNfXJFJ6RzvK/kS9o36keogNGXKiHAaXwdkSNrm2cITbr7Bh7MXH8ZiQDPIcsR4UU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=iVwlcHrk; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5B17EJBn008240;
	Mon, 1 Dec 2025 12:45:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=uB+zxF0aoTqKRyuPD
	5pm8z2285pjtNC0hmjFYtMoYcs=; b=iVwlcHrkPbM5OU7zamXm/nr90SjIkKuu3
	lSjvdkyz3g+Fe5sDqVqKFYX8wW8GniXgV1vNv3itORIVk9J8Wntkw1ZetKSksnaQ
	lQZrz+hUIj+bgVUKRvUXWKpHlaLoNVri4KkHvRVAQHmAERU8YssfkJK+V6eplDA5
	pDTGx/i4JM5mxTHuhKN5QcUwGfKrQRa1vg8q5DJ+XNKDA7Oy5ATDtEqHA6kR5onp
	L0MshDVjzzrJ52bs99HNISsTPxzgPM3RxT4zRmBE0pKyStyUT9uk2SGPt0fZuH6z
	Lbj/ijFjhOWA52fFsSFTIAFrGegDO7pDZtIv3vVMfoEw2Cm43HIvA==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4aqrbfy56q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 01 Dec 2025 12:45:15 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5B1BndhO024045;
	Mon, 1 Dec 2025 12:45:14 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4arb5s6jrk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 01 Dec 2025 12:45:14 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5B1CjAZS61473024
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 1 Dec 2025 12:45:11 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id DCAD520040;
	Mon,  1 Dec 2025 12:45:10 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 66EA720043;
	Mon,  1 Dec 2025 12:45:10 +0000 (GMT)
Received: from li-9fd7f64c-3205-11b2-a85c-df942b00d78d.ibm.com.com (unknown [9.111.74.48])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon,  1 Dec 2025 12:45:10 +0000 (GMT)
From: Janosch Frank <frankja@linux.ibm.com>
To: pbonzini@redhat.com
Cc: kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        borntraeger@linux.ibm.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org, imbrenda@linux.ibm.com, hca@linux.ibm.com,
        Josephine Pfeiffer <hi@josie.lol>
Subject: [GIT PULL 04/10] KVM: s390: Replace sprintf with snprintf for buffer safety
Date: Mon,  1 Dec 2025 13:33:46 +0100
Message-ID: <20251201124334.110483-5-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251201124334.110483-1-frankja@linux.ibm.com>
References: <20251201124334.110483-1-frankja@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: JVBGWImEeR9KQ2tER1wZ3-H5L8QVgNUM
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTI5MDAxNiBTYWx0ZWRfX8K7JcA2DPGGA
 JsgfvdGwYOC/qXAEJ25sX8UPKPSdsTjq3OpnmQj6Dh3ek+vyeC7+TvFcKTgWSBJntsl96T00H9j
 OXaZs1y/rO8o4nBdEwreKkqPoI9p7kubsH98ya90b/6EFrBBWo4ePd8V3/5urk51xqKhljsCJ40
 APg/SDxrGv94Ob9azx0XrYIB95iX9n+7O8teA2DMfXOjZrXF4R5hBslkZPjar3grWdJGI6GXj+O
 6PX+ipLzk1p+wA7fzQg5GVjtLU26WZdP/xCsmpak8zIbDx0vzmlJS0+zBNVtd/SoOt5J6XquiOt
 7ieoRRjjyjl9D3VrOPG2ASs33XhlU4FtPLuhnbiimofc8g62QbpscOcxizB8aYAXzSk15mLpfmY
 qNdMyxhJYUJVBkqItBRP82O8FqSWAg==
X-Authority-Analysis: v=2.4 cv=UO7Q3Sfy c=1 sm=1 tr=0 ts=692d8ddb cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=wP3pNCr1ah4A:10 a=VkNPw1HP01LnGYTKEx00:22 a=VnNF1IyMAAAA:8
 a=0RBdyHoyBsQ1lLlGPqkA:9
X-Proofpoint-GUID: JVBGWImEeR9KQ2tER1wZ3-H5L8QVgNUM
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-28_08,2025-11-27_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 malwarescore=0 bulkscore=0 adultscore=0 priorityscore=1501
 impostorscore=0 spamscore=0 phishscore=0 clxscore=1015 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510240000 definitions=main-2511290016

From: Josephine Pfeiffer <hi@josie.lol>

Replace sprintf() with snprintf() when formatting debug names to prevent
potential buffer overflow. The debug_name buffer is 16 bytes, and while
unlikely to overflow with current PIDs, using snprintf() provides proper
bounds checking.

Signed-off-by: Josephine Pfeiffer <hi@josie.lol>
[frankja@linux.ibm.com: Fixed subject prefix]
Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 arch/s390/kvm/kvm-s390.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 677aa5c7d226..70ebc54b1bb1 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -3348,7 +3348,7 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 	if (!kvm->arch.sca)
 		goto out_err;
 
-	sprintf(debug_name, "kvm-%u", current->pid);
+	snprintf(debug_name, sizeof(debug_name), "kvm-%u", current->pid);
 
 	kvm->arch.dbf = debug_register(debug_name, 32, 1, 7 * sizeof(long));
 	if (!kvm->arch.dbf)
-- 
2.52.0


