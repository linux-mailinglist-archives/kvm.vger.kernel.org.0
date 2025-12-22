Return-Path: <kvm+bounces-66485-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 6958CCD6B90
	for <lists+kvm@lfdr.de>; Mon, 22 Dec 2025 17:54:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 84134307A9D0
	for <lists+kvm@lfdr.de>; Mon, 22 Dec 2025 16:51:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1497933373D;
	Mon, 22 Dec 2025 16:50:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Neh1A8Vt"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1014633290B;
	Mon, 22 Dec 2025 16:50:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766422248; cv=none; b=HJrWtqPZ6pdLQuEblGIAZlpNUxHVexQtrKbTs6l/ep0JI5Rae4rS/XGzHJ8Nxfus20ORjF8ni3rKXIkY58CgzYtiVWdw+xLZBVbZ7VrCD8yd6ZtfnMK7HcDHqOSXhnnztPfKfagIVrZgwxbDBXuP0iY5U7MWA7n2eagoVLpbg5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766422248; c=relaxed/simple;
	bh=KKJC+YnSQfRueC8R5pCG5k1inUq4VYQQ3SDb0JxrwfI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DE7+lxvLWh2m+AORcZxaWUUaoSuRiCm54O54RShRwuD9BkxHZ/9qiHED9fHSTJQtcBjsIpdsC/M6Qfv1tkQEAC61lLWIcVd230raRne/ZjDbT6kOwl7Jqe8VTNYTjdlZuG7ZuGw8HHtwYYvT6uD33TCP+0wux/bGzyQg4INgi4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=Neh1A8Vt; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5BM7CS4t002196;
	Mon, 22 Dec 2025 16:50:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=HX2NRnK5H2nIdD2i/
	6mgkh0Vo4qi+8ItWn9NM+weks8=; b=Neh1A8VtOd0sy7lht2Jl/ZMuaL3gvsakT
	rR7n5+pU3ks1FvUSgTqtxXxsBpqRVsTNrjl1P/iRzzc9eaYKQVAtyfSwMR2CZhOS
	zzFfbemSrD6zfbR0nLZbNGhskLmdk4MjW/ut7h9Mk+tLiT7gmN5hTrip8hvhSdFw
	7nLygNcmELebN35+7g371N1R8P7VjqEQvZqcRkHOJSD+/LKSjHzTxAvZWvM7FnOi
	9p7zKICqWCypzvSS1A0n0lV0ejr3XO0GGKxMUfbuSQYN9MKbBheyA+zV5Wa5JUuK
	JW/TfoYYYY3gl+7lFe8qIyS8dsAQyZNS3t7Sp24JRj4TrJdRgDiew==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4b5kh4968q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 22 Dec 2025 16:50:43 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5BMFUiE5001109;
	Mon, 22 Dec 2025 16:50:42 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4b664s7a5n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 22 Dec 2025 16:50:42 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5BMGocTZ41615864
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 22 Dec 2025 16:50:39 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C5BA420043;
	Mon, 22 Dec 2025 16:50:38 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9DE3B20040;
	Mon, 22 Dec 2025 16:50:37 +0000 (GMT)
Received: from p-imbrenda.ibmuc.com (unknown [9.111.79.149])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 22 Dec 2025 16:50:37 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        borntraeger@de.ibm.com, frankja@linux.ibm.com, nsg@linux.ibm.com,
        nrb@linux.ibm.com, seiden@linux.ibm.com, gra@linux.ibm.com,
        schlameuss@linux.ibm.com, hca@linux.ibm.com, svens@linux.ibm.com,
        agordeev@linux.ibm.com, gor@linux.ibm.com, david@redhat.com,
        gerald.schaefer@linux.ibm.com
Subject: [PATCH v6 03/28] s390: Make UV folio operations work on whole folio
Date: Mon, 22 Dec 2025 17:50:08 +0100
Message-ID: <20251222165033.162329-4-imbrenda@linux.ibm.com>
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
X-Authority-Analysis: v=2.4 cv=bulBxUai c=1 sm=1 tr=0 ts=694976e3 cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=wP3pNCr1ah4A:10 a=VkNPw1HP01LnGYTKEx00:22 a=VnNF1IyMAAAA:8
 a=56eYp6RrapUnXBmR778A:9
X-Proofpoint-ORIG-GUID: RBr-c5kDQXEgry7RpIWLrnHlUz4Ilnp_
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjIyMDE1NCBTYWx0ZWRfX5oeKI2N1W7mp
 pDp6tkvPAtMT31gKnvkBTqcaZpD0rIO6Oh/blDNlIN72INPOVr+XREvA6qpicvFkVAcozpNnA0a
 J7D3BZ/S8PzYkxVX3ws1RNRpu4pY1qRsT5OiiEjTgDVlDSWQfw3sKupIl1V/ETEMSdDhOjRwfHW
 jr1L/15lld6N3rqlUjXng68puL3P6I+I2pU5cZ3HCcpJD3bOtZJoSzjF4SiAzquxM2y+0uyru2d
 KP3Th8VOyntES4n6NMXw/3DsxYhRBMGCq4hKyllzqP5hisvCLGy6jNQJi0rphlkZ9hgD1TFY04u
 jJUmAlKveUbUnEAwStYyDcUj44XYGWNGIUtcOzE3N7JtdUsfYynFeeoClsHX7QA68wbgpPx63pH
 ALCURtZCoslfQSQ58ttak+OqHP4vDrtSp/R8GkyYRIlQaN6UEBbkk3L6Y5VfviC8DF9MzdraXli
 ku0tCAzmeY9WgV9T3RA==
X-Proofpoint-GUID: RBr-c5kDQXEgry7RpIWLrnHlUz4Ilnp_
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-22_02,2025-12-22_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 suspectscore=0 clxscore=1015 lowpriorityscore=0
 priorityscore=1501 spamscore=0 malwarescore=0 bulkscore=0 phishscore=0
 impostorscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2512120000
 definitions=main-2512220154

uv_destroy_folio() and uv_convert_from_secure_folio() should work on
all pages in the folio, not just the first one.

This was fine until now, but it will become a problem with upcoming
patches.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 arch/s390/kernel/uv.c | 22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/arch/s390/kernel/uv.c b/arch/s390/kernel/uv.c
index ed46950be86f..ca0849008c0d 100644
--- a/arch/s390/kernel/uv.c
+++ b/arch/s390/kernel/uv.c
@@ -134,14 +134,15 @@ static int uv_destroy(unsigned long paddr)
  */
 int uv_destroy_folio(struct folio *folio)
 {
+	unsigned long i;
 	int rc;
 
-	/* Large folios cannot be secure */
-	if (unlikely(folio_test_large(folio)))
-		return 0;
-
 	folio_get(folio);
-	rc = uv_destroy(folio_to_phys(folio));
+	for (i = 0; i < (1 << folio_order(folio)); i++) {
+		rc = uv_destroy(folio_to_phys(folio) + i * PAGE_SIZE);
+		if (rc)
+			break;
+	}
 	if (!rc)
 		clear_bit(PG_arch_1, &folio->flags.f);
 	folio_put(folio);
@@ -183,14 +184,15 @@ EXPORT_SYMBOL_GPL(uv_convert_from_secure);
  */
 int uv_convert_from_secure_folio(struct folio *folio)
 {
+	unsigned long i;
 	int rc;
 
-	/* Large folios cannot be secure */
-	if (unlikely(folio_test_large(folio)))
-		return 0;
-
 	folio_get(folio);
-	rc = uv_convert_from_secure(folio_to_phys(folio));
+	for (i = 0; i < (1 << folio_order(folio)); i++) {
+		rc = uv_convert_from_secure(folio_to_phys(folio) + i * PAGE_SIZE);
+		if (rc)
+			break;
+	}
 	if (!rc)
 		clear_bit(PG_arch_1, &folio->flags.f);
 	folio_put(folio);
-- 
2.52.0


