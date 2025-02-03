Return-Path: <kvm+bounces-37101-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 13D03A25483
	for <lists+kvm@lfdr.de>; Mon,  3 Feb 2025 09:37:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A46F91882F7D
	for <lists+kvm@lfdr.de>; Mon,  3 Feb 2025 08:37:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3AD411FC7F0;
	Mon,  3 Feb 2025 08:36:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="fCR5BZwF"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDEFF1FBEBE
	for <kvm@vger.kernel.org>; Mon,  3 Feb 2025 08:36:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738571805; cv=none; b=ToRAOR7QywxbNPy1pyEfmngw+fsR4Ncc3hRfATiVJMhdNMBg6MHkWVZKwGlsL2ajcMxqn0znBO+NOMpuiqCQsUNea228p8st4KaaLswNWYIotMsRXJ7ODoedVneASmbN49ll7WeXZZn0XVPDikxMNwYZNbVlR/20UTBqMFzNvBE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738571805; c=relaxed/simple;
	bh=PvWBwnQzf6bjsqTtlGWffhqOJyCJLVuGFwuLkxEbtkc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FrHEzwMI72gFSUtzcVQwm2POmwvkjFmY6pvxRRn3bdKkEWa2iAIo7H/S7rdo0j+8BvSYeeUCZEvDtSM+g92r0FJALbcXC3Xy6f40tGWwAkbv6vU71EnFunK9vykhoskP0H1osumNw1yAogJ+FcMDZCa7rpzPlgNnb4wQqDL1ZvQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=fCR5BZwF; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 512Laijd007728;
	Mon, 3 Feb 2025 08:36:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=iteFu9D/6btoi3OKV
	/v3SGtDQ5/0ouyXUM7vkTyw1A8=; b=fCR5BZwFA4Og6vuscJnOyqzeYvJ1LDcpH
	0GHxrcnnbJeHtQNmnFKg8ehu6aj/Pr/rCEYYdx6H00tEwFzDQIvhIFAxiLwa7gHT
	/9F0vfh1NFoIr0jEgZRSPBGdfeeiQmGChKBRD8/BCNFUoFhSe8KKNfZxzaEDFFmR
	ALRJLzhqpK80ZbhP72BcjF/NHoIc5TTToCn4oNetXZKVE6rLNgykZ3Pgfktz+Soq
	HkL4napOk2SN/6Otl7U/FpeXoQz+DJhaQRrgwrYXnsI4mL6lfM53DBiL+YjcD9zm
	ME1FZAEhGAXwQobC34cpMf06J7rr1byRPhWs1E8TQaiZn5TaEXOow==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 44jayyba07-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 03 Feb 2025 08:36:30 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5134clwG005310;
	Mon, 3 Feb 2025 08:36:29 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 44j05jn69r-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 03 Feb 2025 08:36:29 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5138aPfi22872538
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 3 Feb 2025 08:36:25 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D14AB20040;
	Mon,  3 Feb 2025 08:36:25 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5BB6F20043;
	Mon,  3 Feb 2025 08:36:25 +0000 (GMT)
Received: from t14-nrb.lan (unknown [9.171.84.16])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon,  3 Feb 2025 08:36:25 +0000 (GMT)
From: Nico Boehr <nrb@linux.ibm.com>
To: thuth@redhat.com, pbonzini@redhat.com, andrew.jones@linux.dev
Cc: kvm@vger.kernel.org, frankja@linux.ibm.com, imbrenda@linux.ibm.com
Subject: [kvm-unit-tests GIT PULL 03/18] s390x: edat: move LC_SIZE to arch_def.h
Date: Mon,  3 Feb 2025 09:35:11 +0100
Message-ID: <20250203083606.22864-4-nrb@linux.ibm.com>
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
X-Proofpoint-GUID: ZmRsCLyvH3_p57IBHVbKHhdyN-6QfNSe
X-Proofpoint-ORIG-GUID: ZmRsCLyvH3_p57IBHVbKHhdyN-6QfNSe
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-03_03,2025-01-31_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0
 lowpriorityscore=0 mlxlogscore=999 adultscore=0 priorityscore=1501
 phishscore=0 impostorscore=0 malwarescore=0 mlxscore=0 bulkscore=0
 suspectscore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2501170000 definitions=main-2502030068

struct lowcore is defined in arch_def.h and LC_SIZE is useful to other
tests as well, therefore move it to arch_def.h.

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Link: https://lore.kernel.org/r/20241010071228.565038-2-nrb@linux.ibm.com
Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
---
 lib/s390x/asm/arch_def.h | 1 +
 s390x/edat.c             | 1 -
 2 files changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/s390x/asm/arch_def.h b/lib/s390x/asm/arch_def.h
index 745a3387..5574a451 100644
--- a/lib/s390x/asm/arch_def.h
+++ b/lib/s390x/asm/arch_def.h
@@ -119,6 +119,7 @@ enum address_space {
 
 #define CTL2_GUARDED_STORAGE		(63 - 59)
 
+#define LC_SIZE	(2 * PAGE_SIZE)
 struct lowcore {
 	uint8_t		pad_0x0000[0x0080 - 0x0000];	/* 0x0000 */
 	uint32_t	ext_int_param;			/* 0x0080 */
diff --git a/s390x/edat.c b/s390x/edat.c
index 1f582efc..89b9c2d3 100644
--- a/s390x/edat.c
+++ b/s390x/edat.c
@@ -17,7 +17,6 @@
 
 #define PGD_PAGE_SHIFT (REGION1_SHIFT - PAGE_SHIFT)
 
-#define LC_SIZE	(2 * PAGE_SIZE)
 #define VIRT(x)	((void *)((unsigned long)(x) + (unsigned long)mem))
 
 static uint8_t prefix_buf[LC_SIZE] __attribute__((aligned(LC_SIZE)));
-- 
2.47.1


