Return-Path: <kvm+bounces-20082-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 45A379107DB
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2024 16:17:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6659F1C20EED
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2024 14:17:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C34A61AD9D6;
	Thu, 20 Jun 2024 14:17:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="oXnzAfex"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC5561AD499;
	Thu, 20 Jun 2024 14:17:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718893036; cv=none; b=HzC6GOg5pDsXOdFherOH2Rn05Q5KS/yW4oiFP3ddkGuJXG0LKNxrvzipeZ9Q50XuaqfTR8OZD99E6mHjM4vH9MWGapXI0tIKwIYNK41+WJsB3r+k4uEKrVC9V0mr86FlxdyaHbGvv5ZA68yXsNehDhPZX0I0N3JiNCf/oQw731g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718893036; c=relaxed/simple;
	bh=TmMuRr8W3SjFtQudukPEkp/XUQff0qDDavNzHyogiOw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=hggEYZxoFQBdBLV2vt7rGCT8YMv+6Z6VXtRAbQiEAYjrEFIBnv8XEgwzXkddoI6KuB03bmmL04kxO1dQKzE1navAPNk5SzzPcpxXUjTHyDjzK7pObYyg2882r0nSrj9nH/rx8z8NS6BYv7dc3DiXO8tc9VxiKu9u0iq9lbz5cGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=oXnzAfex; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353724.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45KDvHZN021924;
	Thu, 20 Jun 2024 14:17:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from
	:to:cc:subject:date:message-id:in-reply-to:references
	:mime-version:content-transfer-encoding; s=pp1; bh=maQklBUJun5tn
	ZBBXefqmxTHQnD0x+WhqV1Ino1t/us=; b=oXnzAfexht/2vUWpXNKaSrKLLJH8U
	j32CCDA7rFWgSNAL1pklZX+j9TmiJnhA4BNajwKwXIUaV9oBPcPA/jpwnp8BB9JF
	2ROkCGr2S52b2p1X/nY4Mx6n285fYbwPQ15MYeDrfU+VbZegcw5p4ie0lFinhILP
	GwHZ0N/H2Tv4CcUJ7Vyoc4kTA49ba8x5abAuezkE6BMmPDWvVQ7OkZXp8CI6okvm
	E/vM5RoHsfy9CQAXxvQOed5H1hcTniPL4ohnRBaxBN2h4SLkLNRDjgbQgcqbr/ju
	Fwc7O0PW+5vg+D+DGqcowgTAtxoTCrRwo8rDM/mLdbny4x8NWLOPqofNg==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3yvndp83jx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 20 Jun 2024 14:17:10 +0000 (GMT)
Received: from m0353724.ppops.net (m0353724.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 45KEH9Io024281;
	Thu, 20 Jun 2024 14:17:09 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3yvndp83js-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 20 Jun 2024 14:17:09 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 45KCqsaB011010;
	Thu, 20 Jun 2024 14:17:09 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3yspsnpnqb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 20 Jun 2024 14:17:09 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 45KEH3jf26411602
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 20 Jun 2024 14:17:05 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 47CED2005A;
	Thu, 20 Jun 2024 14:17:03 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 11B792004F;
	Thu, 20 Jun 2024 14:17:03 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 20 Jun 2024 14:17:03 +0000 (GMT)
From: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
To: =?UTF-8?q?Nico=20B=C3=B6hr?= <nrb@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: Nina Schoetterl-Glausch <nsg@linux.ibm.com>, linux-s390@vger.kernel.org,
        Nicholas Piggin <npiggin@gmail.com>, kvm@vger.kernel.org,
        David Hildenbrand <david@redhat.com>,
        Andrew Jones <andrew.jones@linux.dev>, Thomas Huth <thuth@redhat.com>
Subject: [kvm-unit-tests PATCH v3 3/7] s390x: Add sie_is_pv
Date: Thu, 20 Jun 2024 16:16:56 +0200
Message-Id: <20240620141700.4124157-4-nsg@linux.ibm.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20240620141700.4124157-1-nsg@linux.ibm.com>
References: <20240620141700.4124157-1-nsg@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: ZaFh4BimmABHIKUEQGHW4XPCjeUJ3Z5s
X-Proofpoint-ORIG-GUID: 2KDpu9k3iAMYEw_ADRY7Ip2VWg9GBC46
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-20_07,2024-06-20_04,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 clxscore=1015
 bulkscore=0 mlxscore=0 suspectscore=0 malwarescore=0 phishscore=0
 mlxlogscore=805 spamscore=0 adultscore=0 lowpriorityscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2405170001 definitions=main-2406200099

Add a function to check if a guest VM is currently running protected.

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


