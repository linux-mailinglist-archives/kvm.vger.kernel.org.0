Return-Path: <kvm+bounces-29020-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id C092F9A1123
	for <lists+kvm@lfdr.de>; Wed, 16 Oct 2024 20:04:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5FCDFB23E69
	for <lists+kvm@lfdr.de>; Wed, 16 Oct 2024 18:04:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B0B282141B4;
	Wed, 16 Oct 2024 18:03:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="HhQvXzet"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D065916DEAC;
	Wed, 16 Oct 2024 18:03:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729101812; cv=none; b=CxUoAg6vTKZEtAjq9IjY8WoFpAAHE5V+y0UhvhTyaLvQMSr7IrJLTYEfTOiSCSAiGGkd5I1hSDZ+yyM0cFcwJVwt/I0BiPt16CO88zc3XvCS6abuloXe0xLb4DWNwIOeXUKcjlcg93ge2s1nJvXYzCsA2dkTlKt8UuYOzJz23CM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729101812; c=relaxed/simple;
	bh=SusSZVj/OQEvLz/4DAZrbgzonCmBOgGKwLhMGv8Z2W0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A+IBxxMjOvPbC5vrNKb3MFCRQSsyElpAM2bkbaPOF/rxgpMtjH+SQNlKdWQr3LWEy3Rc8Gg60jD+PxDxdlA61j+ZpmiwwUhh+5e33n5XIaroyN5XwpiLzMg7nXHZPyM5t6tq7RZ3wquotBsKKafeUYlZi4hujR9b2ikRPx0dldw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=HhQvXzet; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49GFcjgF018031;
	Wed, 16 Oct 2024 18:03:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=nAwlhOeBlCK63f41n
	MwlawML4hTA7nxhcci1gtTPFcQ=; b=HhQvXzetgVSutLSOgkSnMfbJPIuFIGdJV
	3xtsYA3EsrR01KEGvB5xpzLj5e0WOSVqwLgLLmqRhA9BrJHN1fG/jzcontxQSML4
	tpFhuEzCZ9gFfD+BCNBTaigO3+5LMDdUyaGrbx4O2TADigsLDXDPjxQNmvq5Z7d7
	E4iPA95XP5pqvLuD5yN1fLwjQYG90ic6ccrx/oAcx6hGNYRSQjS+A9FkTki5qyKw
	nKtfRUPhmyxInKs/tApox4iPMgpgHFPLF12+M5Oarfir43KE6KepiNhA+Ab6XQi2
	1UiogBiFT/coDEca/W2gR+5i7rZcWNNHkqU1GM7v4YiHdpj8iD7iw==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 42af3t93kw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 16 Oct 2024 18:03:29 +0000 (GMT)
Received: from m0360083.ppops.net (m0360083.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 49GI3T1Z020005;
	Wed, 16 Oct 2024 18:03:29 GMT
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 42af3t93kn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 16 Oct 2024 18:03:29 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 49GHJ2EG002452;
	Wed, 16 Oct 2024 18:03:27 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4284emtt4y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 16 Oct 2024 18:03:27 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 49GI3OW752691238
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 16 Oct 2024 18:03:24 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 23E342004D;
	Wed, 16 Oct 2024 18:03:24 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id BA4242004B;
	Wed, 16 Oct 2024 18:03:23 +0000 (GMT)
Received: from tuxmaker.lnxne.boe (unknown [9.152.85.9])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 16 Oct 2024 18:03:23 +0000 (GMT)
From: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
To: =?UTF-8?q?Nico=20B=C3=B6hr?= <nrb@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
        Nicholas Piggin <npiggin@gmail.com>,
        David Hildenbrand <david@redhat.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, Thomas Huth <thuth@redhat.com>
Subject: [kvm-unit-tests PATCH v4 2/6] s390x: Add sie_is_pv
Date: Wed, 16 Oct 2024 20:03:13 +0200
Message-ID: <20241016180320.686132-3-nsg@linux.ibm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20241016180320.686132-1-nsg@linux.ibm.com>
References: <20241016180320.686132-1-nsg@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: uOftFxq74I22FFqfA4H-63XJVOzWln8f
X-Proofpoint-ORIG-GUID: 6OTqVbPOhtcYWdxGDgdNKL2viYVgX2VK
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 mlxlogscore=882
 bulkscore=0 impostorscore=0 malwarescore=0 clxscore=1015
 priorityscore=1501 spamscore=0 adultscore=0 phishscore=0 suspectscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2409260000 definitions=main-2410160115

Add a function to check if a guest VM is currently running protected.

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Nicholas Piggin <npiggin@gmail.com>
Signed-off-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
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
2.44.0


