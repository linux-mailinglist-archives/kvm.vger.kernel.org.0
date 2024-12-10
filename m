Return-Path: <kvm+bounces-33405-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9EFDF9EADDE
	for <lists+kvm@lfdr.de>; Tue, 10 Dec 2024 11:20:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9724D164FD5
	for <lists+kvm@lfdr.de>; Tue, 10 Dec 2024 10:20:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 857C01DC99D;
	Tue, 10 Dec 2024 10:20:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="dku/HPVN"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13BBA13B59E;
	Tue, 10 Dec 2024 10:20:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733826029; cv=none; b=qrfYdts54I8sU5QJkjBGgvOCpADgkOmEii5EpQqvM+OFSJGiFMDftvo+szB821rwZmqDGMXDeQbBaYc7mOMgw5ENgCcGI4OBFiHMtWdfVG4yg3ygUKAFc/rbh4L1ReamNAkTSdunMexDBQcCXavl+xAa5iIptfc3JeVKymqUA4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733826029; c=relaxed/simple;
	bh=uS38OaZSre1uSIRUZ5pRDL5kxBMKXa5VlT15pztdn+k=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To; b=On1AY4UzO5s97OzibCy3C4011L6Dd6HJTBhdMw3rCn5LCf7IQ+ZGClReJXFELLgm2yakyngYpaRHqHFmJ3yxhADedE20VqvJPENVuMQxK/3jpntvT6cYQ08yKgRje6ffw2R7UnoRRwIE0acQKv3iCK6l9ROefRZsCioqSbMwL50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=dku/HPVN; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4BA7fNgT002984;
	Tue, 10 Dec 2024 10:20:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=sTT91U
	vEB0FYXlPOc8UsmqdGpRmtiii0LpZOwT5UTSE=; b=dku/HPVNe9VO2lR3n2pcS3
	2QOv9iw2tVRm9tOYZVgKxkAXorp0rtp9tNF6Y7dZLS5X2uvcrBWj8BgazodLOS4X
	2AFZLhefKQINCjYne1Tz4PScfE647zzzc92fn8D7i4g8nm+OX7xpyHZ82/kDJbvE
	QT8YOv2gRWj6uPKXBF6nlqtVGFVZzXhRRcqiMYLhPT3L4YwByapcSynO2rGmPUNA
	smsAZQVOCeT+6CrPAh1d2avxGDXkDdmQnkHGR0uMu+43qPuoO6xSqj73KhE2fYeP
	+6i3WNwcf+MP5ITExYoMvNTIgGrIQHUnhJFDZUActK84etkAP9eseg9IJxRqHPrA
	==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 43ccsjdfa3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 10 Dec 2024 10:20:25 +0000 (GMT)
Received: from m0353725.ppops.net (m0353725.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 4BAAKOSq032585;
	Tue, 10 Dec 2024 10:20:24 GMT
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 43ccsjdfa1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 10 Dec 2024 10:20:24 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 4BA9G725017369;
	Tue, 10 Dec 2024 10:20:24 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 43d3d1jry7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 10 Dec 2024 10:20:24 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 4BAAKKgd33882848
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 10 Dec 2024 10:20:20 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 788D320063;
	Tue, 10 Dec 2024 10:20:20 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5BB422005A;
	Tue, 10 Dec 2024 10:20:20 +0000 (GMT)
Received: from t14-nrb (unknown [9.155.202.61])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 10 Dec 2024 10:20:20 +0000 (GMT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 10 Dec 2024 11:20:20 +0100
Message-Id: <D67Y11RRNUJ4.3U17EAZFWQR6M@linux.ibm.com>
Cc: "David Hildenbrand" <david@redhat.com>, <kvm@vger.kernel.org>,
        "Nicholas
 Piggin" <npiggin@gmail.com>, <linux-s390@vger.kernel.org>
Subject: Re: [kvm-unit-tests PATCH v4 4/6] s390x: Add library functions for
 exiting from snippet
From: "Nico Boehr" <nrb@linux.ibm.com>
To: "Nina Schoetterl-Glausch" <nsg@linux.ibm.com>,
        "Claudio Imbrenda"
 <imbrenda@linux.ibm.com>,
        "Thomas Huth" <thuth@redhat.com>,
        "Janosch Frank"
 <frankja@linux.ibm.com>
X-Mailer: aerc 0.18.2
References: <20241016180320.686132-1-nsg@linux.ibm.com>
 <20241016180320.686132-5-nsg@linux.ibm.com>
In-Reply-To: <20241016180320.686132-5-nsg@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: SZPrQc0DzVdz9ht5O3y43UM-K6vsUPwE
X-Proofpoint-ORIG-GUID: 4bvwaUirU2w8u63fqzYzMA1KW0lrVU33
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 adultscore=0
 impostorscore=0 spamscore=0 lowpriorityscore=0 bulkscore=0 mlxlogscore=881
 mlxscore=0 priorityscore=1501 suspectscore=0 malwarescore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2411120000
 definitions=main-2412100074

On Wed Oct 16, 2024 at 8:03 PM CEST, Nina Schoetterl-Glausch wrote:
> It is useful to be able to force an exit to the host from the snippet,
> as well as do so while returning a value.
> Add this functionality, also add helper functions for the host to check
> for an exit and get or check the value.
> Use diag 0x44 and 0x9c for this.
> Add a guest specific snippet header file and rename snippet.h to reflect
> that it is host specific.
>
> Signed-off-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>

Hi Nina,

would you mind if I fix this up like this?

(copy-pasted so whitespace damage ahead)

diff --git a/lib/s390x/asm/arch_def.h b/lib/s390x/asm/arch_def.h
index 2dec7924..03adcd3c 100644
--- a/lib/s390x/asm/arch_def.h
+++ b/lib/s390x/asm/arch_def.h
@@ -510,11 +510,14 @@ static inline void diag44(void)
 	asm volatile("diag	0,0,0x44\n");
 }

-static inline void diag9c(uint64_t val)
+static inline void diag500(uint64_t val)
 {
-	asm volatile("diag	%[val],0,0x9c\n"
+	asm volatile(
+		"lgr	2,%[val]\n"
+		"diag	0,0,0x500\n"
 		:
 		: [val] "d"(val)
+		: "r2"
 	);
 }

diff --git a/lib/s390x/snippet-exit.h b/lib/s390x/snippet-exit.h
index f62f0068..3ed4c22c 100644
--- a/lib/s390x/snippet-exit.h
+++ b/lib/s390x/snippet-exit.h
@@ -19,16 +19,14 @@ static inline bool snippet_is_force_exit(struct vm *vm)

 static inline bool snippet_is_force_exit_value(struct vm *vm)
 {
-	return sie_is_diag_icpt(vm, 0x9c);
+	return sie_is_diag_icpt(vm, 0x500);
 }

 static inline uint64_t snippet_get_force_exit_value(struct vm *vm)
 {
-	struct kvm_s390_sie_block *sblk =3D vm->sblk;
-
 	assert(snippet_is_force_exit_value(vm));

-	return vm->save_area.guest.grs[sblk_ip_as_diag(sblk).r_1];
+	return vm->save_area.guest.grs[2];
 }

 static inline void snippet_check_force_exit_value(struct vm *vm, uint64_t =
value_exp)
diff --git a/s390x/snippets/lib/snippet-exit.h b/s390x/snippets/lib/snippet=
-exit.h
index 0b483366..ac00de3f 100644
--- a/s390x/snippets/lib/snippet-exit.h
+++ b/s390x/snippets/lib/snippet-exit.h
@@ -21,7 +21,7 @@ static inline void force_exit(void)
 static inline void force_exit_value(uint64_t val)
 {
 	mb(); /* host may read any memory written by the guest before */
-	diag9c(val);
+	diag500(val);
 	mb(); /* allow host to modify guest memory */
 }



