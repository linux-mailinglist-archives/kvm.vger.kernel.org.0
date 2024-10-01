Return-Path: <kvm+bounces-27770-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A534498BB54
	for <lists+kvm@lfdr.de>; Tue,  1 Oct 2024 13:36:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 50C591F21663
	for <lists+kvm@lfdr.de>; Tue,  1 Oct 2024 11:36:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E6F361BFE0B;
	Tue,  1 Oct 2024 11:36:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="eyMa8FEM"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87CF719DF53;
	Tue,  1 Oct 2024 11:36:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727782612; cv=none; b=M5BgqQPWukFFSs0UbaZa+HO3NEv+73areiMnjuKkelr+YVvdTVwbbfuviBPQu6qT6VlQxnrWpsgenQCVZeSTvaXqW3OCcc0zacXILyvKBpG8v+6gDxoiuQl5v+yDey3wCAsFhonXqT1LZUDPMNzhsmeOk+C84kyJWO18tmIXw1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727782612; c=relaxed/simple;
	bh=KtnwUbDlnTWrZb+5TISHm6XStVpESDiZeL6CpOZPMWY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=HKnUhBLFoz8uTWn8LkRDf0dSopyax+oMUK8QpLj74S1aYjZBIm0F9LtoS44sFHCMBljbSx2mXwe5xMyR4QvGlWz/bn/zQvFahJi6MpBs7x1/TxH0WyKvYbSdNyTAvd/FIw4FANg+TTGZRsbAcNRQBaWWoBtJK/KBThzOQK4ZKUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=eyMa8FEM; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4918lgCw014805;
	Tue, 1 Oct 2024 11:36:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from
	:to:cc:subject:date:message-id:mime-version
	:content-transfer-encoding; s=pp1; bh=+Bqk3DtHBhctA+KxcnFd10SbPo
	t620EatMuw5YL3J1Y=; b=eyMa8FEMrugqZlNJs/fbYSKpP7RNR/NcOWjd9AOe2t
	Qy94rWjpTmNAT7+pVU/bgGbOOJqI7yKMbPbGIXHDJG6dq6Ot2IffHnnnA5IhUmlL
	x9dJfbmPQC84m7H4BA68PUAX4TzL++1BNpjUwxZyc6JaCgoBrvP37ZBoblj+rBwU
	3+ia4y8CkPuGn4Qy5FpwkNz/JhWn2MfZZyykiJUZLzYaztunbKc72u0dTv2VHhoj
	wvIpHXAqQ2tILBYegEWrapkXDfy/XKO1qVeFXE5lrvqVTOmgtAp9dUmb+Hd7ATo9
	hmMj5ELHxb7APfVrkpRrI7lPXooQ6vfDZXJBW5uByZcg==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 420c5b9dcv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 01 Oct 2024 11:36:48 +0000 (GMT)
Received: from m0360083.ppops.net (m0360083.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 491BamSA004550;
	Tue, 1 Oct 2024 11:36:48 GMT
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 420c5b9dct-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 01 Oct 2024 11:36:48 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 491AZgbL002840;
	Tue, 1 Oct 2024 11:36:47 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 41xxu13pv9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 01 Oct 2024 11:36:47 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 491Bafh739059952
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 1 Oct 2024 11:36:41 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 59D6E20049;
	Tue,  1 Oct 2024 11:36:41 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2238F20040;
	Tue,  1 Oct 2024 11:36:41 +0000 (GMT)
Received: from p-imbrenda.boeblingen.de.ibm.com (unknown [9.152.224.66])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue,  1 Oct 2024 11:36:41 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: kvm@vger.kernel.org
Cc: nrb@linux.ibm.com, frankja@linux.ibm.com, borntraeger@de.ibm.com,
        david@redhat.com, thuth@redhat.com, linux-s390@vger.kernel.org
Subject: [kvm-unit-tests PATCH v1 1/1] s390x: edat: test 2G large page spanning end of memory
Date: Tue,  1 Oct 2024 13:36:40 +0200
Message-ID: <20241001113640.55210-1-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.46.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: fQUXkazznd97-_rjQnY_I1q8WQtSbxjI
X-Proofpoint-ORIG-GUID: 27tUoZKWg7jmwGwfoC2jGRMCrNTSUzBv
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-01_07,2024-09-30_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 bulkscore=0 priorityscore=1501 clxscore=1015 adultscore=0 mlxscore=0
 mlxlogscore=955 impostorscore=0 malwarescore=0 spamscore=0 phishscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2408220000 definitions=main-2410010075

Create a region 3 table with fc=1 (i.e. a 2G large page) mapping across the
end of memory.

Check that the part of the large page before the end of memory is accessible,
and the part that is after the end of memory is not.

Also fix a typo in the existing edat2 test.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 s390x/edat.c | 18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/s390x/edat.c b/s390x/edat.c
index 16138397..1f582efc 100644
--- a/s390x/edat.c
+++ b/s390x/edat.c
@@ -196,6 +196,8 @@ static void test_edat1(void)
 
 static void test_edat2(void)
 {
+	uint64_t mem_end, i;
+
 	report_prefix_push("edat2");
 	p[0] = 42;
 
@@ -206,7 +208,21 @@ static void test_edat2(void)
 	/* Prefixing should not work with huge pages, just like large pages */
 	report(!memcmp(0, VIRT(prefix_buf), LC_SIZE) &&
 		!memcmp(prefix_buf, VIRT(0), LC_SIZE),
-		"pmd, large, prefixing");
+		"pud, large, prefixing");
+
+	mem_end = get_ram_size();
+	if (mem_end >= BIT_ULL(REGION3_SHIFT)) {
+		report_skip("pud spanning end of memory");
+	} else {
+		for (i = 0; i < mem_end; i += PAGE_SIZE)
+			READ_ONCE(*(uint64_t *)VIRT(i));
+		for (i = mem_end; i < BIT_ULL(REGION3_SHIFT); i += PAGE_SIZE) {
+			expect_pgm_int();
+			READ_ONCE(*(uint64_t *)VIRT(i));
+			assert(clear_pgm_int() == PGM_INT_CODE_ADDRESSING);
+		}
+		report_pass("pud spanning end of memory");
+	}
 
 	report_prefix_pop();
 }
-- 
2.46.2


