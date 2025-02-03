Return-Path: <kvm+bounces-37099-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 713A0A25480
	for <lists+kvm@lfdr.de>; Mon,  3 Feb 2025 09:37:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0887C1626E4
	for <lists+kvm@lfdr.de>; Mon,  3 Feb 2025 08:37:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 94F661FCD1A;
	Mon,  3 Feb 2025 08:36:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Eq3Z4BDh"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F64B1FAC4F
	for <kvm@vger.kernel.org>; Mon,  3 Feb 2025 08:36:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738571804; cv=none; b=YV9QSE1iKWv6A5ivyUi5YT09MfpxkqqlrcoEcdM2XUTSO/j06pR0e6XWzwmV6Mt9R9WObubQ9XbhatvotbbH0tAIJcUqMdTBsWhVowQPHz6QsTZVdkV3fbGyecwRV7aykJgkR7y0Whjc4B6g/idPdHDliXH94/qjRxdIA+OiKMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738571804; c=relaxed/simple;
	bh=jXJTZPDaGAV7Vndo4A3F3OEuPthTyMAUtiSfH3DcI3k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cpObSoeOWEKHlt/JrPG6w9smckdlMPwSbTWLLNM2gwq/HbYTl66w0AEONXPr+zr6u0EQQTHfTYWp+OvLQKKFv0AYLcjbkBzXlODtaXmwuJy2AIPXk6UV2s3oXjrWoEsLUTA0NYev6MHEXIawxnQC4/5HO349W5KKmQdlA84YenE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=Eq3Z4BDh; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 51320hEX006186;
	Mon, 3 Feb 2025 08:36:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=VJzSOimljqkl73IS/
	NHN683jSVNW/XRPiOeLSsyJ1kw=; b=Eq3Z4BDh4coAsU4HyUwW1noyeVBeYjNF1
	s8igr/ZheX8+BurPCehOkaAuK+FL6UQxfseeRFSAaq25gfxVU33BQ6KYdld8+QXf
	NBbtQ9oy3fPFyKIqytqvElJQSoqOVm0sjYaXrFBcGAMaMVLnXBix2xm4/qTWaXvp
	w0g39g89w8qQTd1Iu4qJS1kwpji8W+JSen0QQX7IgEUcGF8Ey3RPU+b+toPtNB6m
	bBl0fYV72OYEIyi7qCkQdKNzwA3qKlzkNXDopyPrr2geIGu2sjTrx4D8+jfKm9vJ
	uU9CehW2Y8uouCCRxtmBxtYvAPI2rrx+0wYiaUzBjftLXTZiWX08g==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 44jmmy9ccy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 03 Feb 2025 08:36:32 +0000 (GMT)
Received: from m0353725.ppops.net (m0353725.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 5138U44V021907;
	Mon, 3 Feb 2025 08:36:32 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 44jmmy9cct-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 03 Feb 2025 08:36:32 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 51376jZB007158;
	Mon, 3 Feb 2025 08:36:31 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 44hxaydhh5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 03 Feb 2025 08:36:31 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5138aRRa42139998
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 3 Feb 2025 08:36:27 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 71BFF2004B;
	Mon,  3 Feb 2025 08:36:27 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id F299120043;
	Mon,  3 Feb 2025 08:36:26 +0000 (GMT)
Received: from t14-nrb.lan (unknown [9.171.84.16])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon,  3 Feb 2025 08:36:26 +0000 (GMT)
From: Nico Boehr <nrb@linux.ibm.com>
To: thuth@redhat.com, pbonzini@redhat.com, andrew.jones@linux.dev
Cc: kvm@vger.kernel.org, frankja@linux.ibm.com, imbrenda@linux.ibm.com,
        Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
        Nicholas Piggin <npiggin@gmail.com>
Subject: [kvm-unit-tests GIT PULL 06/18] s390x: Add sie_is_pv
Date: Mon,  3 Feb 2025 09:35:14 +0100
Message-ID: <20250203083606.22864-7-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250203083606.22864-1-nrb@linux.ibm.com>
References: <20250203083606.22864-1-nrb@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: dQyb7k0PYrnbasL6eIK8nF-28Y37ASgM
X-Proofpoint-ORIG-GUID: -Sh0BY8spWasISkY2X7N7o9YY2K83j6U
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-03_03,2025-01-31_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 malwarescore=0
 phishscore=0 impostorscore=0 priorityscore=1501 mlxscore=0
 lowpriorityscore=0 mlxlogscore=742 bulkscore=0 spamscore=0 adultscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2501170000 definitions=main-2502030068

From: Nina Schoetterl-Glausch <nsg@linux.ibm.com>

Add a function to check if a guest VM is currently running protected.

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Nicholas Piggin <npiggin@gmail.com>
Signed-off-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
Link: https://lore.kernel.org/r/20241016180320.686132-3-nsg@linux.ibm.com
Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
---
 lib/s390x/sie.h | 6 ++++++
 lib/s390x/sie.c | 4 ++--
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/lib/s390x/sie.h b/lib/s390x/sie.h
index c1724cf2..53cd767f 100644
--- a/lib/s390x/sie.h
+++ b/lib/s390x/sie.h
@@ -281,6 +281,12 @@ void sie_expect_validity(struct vm *vm);
 uint16_t sie_get_validity(struct vm *vm);
 void sie_check_validity(struct vm *vm, uint16_t vir_exp);
 void sie_handle_validity(struct vm *vm);
+
+static inline bool sie_is_pv(struct vm *vm)
+{
+	return vm->sblk->sdf == 2;
+}
+
 void sie_guest_sca_create(struct vm *vm);
 void sie_guest_create(struct vm *vm, uint64_t guest_mem, uint64_t guest_mem_len);
 void sie_guest_destroy(struct vm *vm);
diff --git a/lib/s390x/sie.c b/lib/s390x/sie.c
index 40936bd2..0fa915cf 100644
--- a/lib/s390x/sie.c
+++ b/lib/s390x/sie.c
@@ -59,7 +59,7 @@ void sie(struct vm *vm)
 	/* When a pgm int code is set, we'll never enter SIE below. */
 	assert(!read_pgm_int_code());
 
-	if (vm->sblk->sdf == 2)
+	if (sie_is_pv(vm))
 		memcpy(vm->sblk->pv_grregs, vm->save_area.guest.grs,
 		       sizeof(vm->save_area.guest.grs));
 
@@ -98,7 +98,7 @@ void sie(struct vm *vm)
 	/* restore the old CR 13 */
 	lctlg(13, old_cr13);
 
-	if (vm->sblk->sdf == 2)
+	if (sie_is_pv(vm))
 		memcpy(vm->save_area.guest.grs, vm->sblk->pv_grregs,
 		       sizeof(vm->save_area.guest.grs));
 }
-- 
2.47.1


