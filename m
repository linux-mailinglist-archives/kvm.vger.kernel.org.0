Return-Path: <kvm+bounces-18761-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1A2A58FB1A3
	for <lists+kvm@lfdr.de>; Tue,  4 Jun 2024 14:00:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 550EF1C20F53
	for <lists+kvm@lfdr.de>; Tue,  4 Jun 2024 12:00:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D764E145348;
	Tue,  4 Jun 2024 12:00:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Y1QZiKCN"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DECA145B0C;
	Tue,  4 Jun 2024 11:59:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717502401; cv=none; b=NT8tA8I2JjZvLnHsfXwwnXPfvnmn1PAZqV4K5mFPOZNaFTv7A3sbnfTxliVBQuU4SAYw/UyIyf3L+DvxL+eC57mIG0DLWS1/RL5ahSLaW2K9a01Vu0LM1u65HoGNH11ePLukVHKijWL7yXIhrhFnx7mc1OJTt0OH1RWMJO5N8iY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717502401; c=relaxed/simple;
	bh=V56UO5c9spD1zbcJqXY8CjDPFIMuAXYnBf0opGCHPUo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dxi/KKUl/qT1FgE2uXBAn9OxewXQDKEZN0S/1S4o+6HWy3YD3HY2u2V/o1dX/D+rsy/muafmSMHmMSHdD0eBRZvUDE4vCuNyEcJrK4yIGAS8Sv8oAIw0FgUppl2ROQqkRPupJ8jEDzCLnigzFWc9P8jeeqpxlN1iBT79D1/LtS8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=Y1QZiKCN; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353722.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 454BoeoH027703;
	Tue, 4 Jun 2024 11:59:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc :
 content-transfer-encoding : date : from : in-reply-to : message-id :
 mime-version : references : subject : to; s=pp1;
 bh=nuyAy6vdil2V/59dkgudJ9K7wx8t47Ko+iwDqlNZfQQ=;
 b=Y1QZiKCN4vTmjfpQUVqLhFD6594kmnH3cJtsOqgosq2m+XgO5/+cJwdKWWLxDJ4bG43x
 Mh+bh72Pg/g82ZbirPs3WLCEUzn1fDlYLZ7FSsEAEDaDiv+Tm3ulfBi8MffBaBVQyJi3
 HeyExR/2EdDEKX/COKjZtQAYq883CV8x/ZbjAnLXBZFoNF8bzMP7Vf1u12bswhwLn3hx
 n9YDvF5ZC9xK2yUufHJMY8U/M4xzy0leLG72CB1ByCkV+v03U6LcltGOA7mLUEKABgGc
 6ANNkWtjnGeL2wj/xVQJQ1z3LozloVdF6ChKN19OJjr84gi4+jU/rGHbiWGWGMcjdVYQ aA== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3yj29qg2ex-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 04 Jun 2024 11:59:58 +0000
Received: from m0353722.ppops.net (m0353722.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 454BxvxZ012503;
	Tue, 4 Jun 2024 11:59:57 GMT
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3yj29qg2eu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 04 Jun 2024 11:59:57 +0000
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 4549PC1j031114;
	Tue, 4 Jun 2024 11:59:57 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3ygeypduka-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 04 Jun 2024 11:59:57 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 454BxpCX20447488
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 4 Jun 2024 11:59:53 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 649C22004D;
	Tue,  4 Jun 2024 11:59:51 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D501A2004B;
	Tue,  4 Jun 2024 11:59:50 +0000 (GMT)
Received: from li-1de7cd4c-3205-11b2-a85c-d27f97db1fe1.fritz.box (unknown [9.171.63.147])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue,  4 Jun 2024 11:59:50 +0000 (GMT)
From: Marc Hartmayer <mhartmay@linux.ibm.com>
To: <linux-s390@vger.kernel.org>, Thomas Huth <thuth@redhat.com>,
        Nicholas Piggin <npiggin@gmail.com>
Cc: <kvm@vger.kernel.org>, Janosch Frank <frankja@linux.ibm.com>,
        Nico Boehr <nrb@linux.ibm.com>, Steffen Eiden <seiden@linux.ibm.com>
Subject: [kvm-unit-tests PATCH v1 3/3] Revert "s390x: Specify program headers with flags to avoid linker warnings"
Date: Tue,  4 Jun 2024 13:59:32 +0200
Message-ID: <20240604115932.86596-4-mhartmay@linux.ibm.com>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240604115932.86596-1-mhartmay@linux.ibm.com>
References: <20240604115932.86596-1-mhartmay@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: q2C10yWq_966gkITX4TpKXGVmPLspRNF
X-Proofpoint-ORIG-GUID: wcn6pqZIAVd6tkaYnWNm6SizjaZL5t7A
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.12.28.16
 definitions=2024-06-04_05,2024-05-30_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0
 priorityscore=1501 lowpriorityscore=0 malwarescore=0 phishscore=0
 spamscore=0 impostorscore=0 mlxscore=0 bulkscore=0 suspectscore=0
 mlxlogscore=999 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2405010000 definitions=main-2406040097

From: Super User <root@t35lp69.lnxne.boe>

This reverts commit 9801dbbe9ea4591b2c32a51e5b29cb64502b93fb.

Signed-off-by: Marc Hartmayer <mhartmay@linux.ibm.com>
---
 s390x/snippets/c/flat.lds.S | 12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

diff --git a/s390x/snippets/c/flat.lds.S b/s390x/snippets/c/flat.lds.S
index 6b8ceb9e0dca..468b5f1eebe8 100644
--- a/s390x/snippets/c/flat.lds.S
+++ b/s390x/snippets/c/flat.lds.S
@@ -1,11 +1,5 @@
 #include <asm/asm-offsets.h>
 
-PHDRS
-{
-    text PT_LOAD FLAGS(5);
-    data PT_LOAD FLAGS(6);
-}
-
 SECTIONS
 {
 	.lowcore : {
@@ -35,7 +29,7 @@ SECTIONS
 		*(.init)
 		*(.text)
 		*(.text.*)
-	} :text
+	}
 	. = ALIGN(4K);
 	etext = .;
 	/* End text */
@@ -43,9 +37,9 @@ SECTIONS
 	.data : {
 		*(.data)
 		*(.data.rel*)
-	} :data
+	}
 	. = ALIGN(16);
-	.rodata : { *(.rodata) *(.rodata.*) } :data
+	.rodata : { *(.rodata) *(.rodata.*) }
 	. = ALIGN(16);
 	.bss : { *(.bss) }
 	/* End data */
-- 
2.34.1


