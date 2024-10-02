Return-Path: <kvm+bounces-27804-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 8CE6B98DA79
	for <lists+kvm@lfdr.de>; Wed,  2 Oct 2024 16:22:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 339A81F21AC1
	for <lists+kvm@lfdr.de>; Wed,  2 Oct 2024 14:22:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 88E041D2226;
	Wed,  2 Oct 2024 14:16:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="JxB5Mq83"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D14E01D0F70;
	Wed,  2 Oct 2024 14:16:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727878584; cv=none; b=EiWqxQ2ddGfu5CwWwvnBUioXohCZBLChmAINJzp8exLyxU1kDi9+Ok8jgdrLAuhPpCIeumBa134FnSUMuEUXoODaWgfLcLsYry/kG/uZkVgK8CkKqm5Ws0HLAdGtpwCU7JOLglahcEbkNv9LyxmhXTi2OdL6mSw8jX4vekAwPaY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727878584; c=relaxed/simple;
	bh=60AIUvEIO5ShnTtq9IwCjZTgsZLM713StqdUbqvB79M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rlrac1MfkjZLlqr+wMCzUmxIlRRkRngoOlUFuLGE9p+W/z4f8ckKV3QSvh0wxyN2PS3vrOuDKU15IgXYxYtDMTUA/zJ+5/0lzdKwrUwy57+zaGIZvGR/2X66nSKj16GHSy3ggKgmWQe1oywuBgOtKPpGLT7OeU21LjPle0M6fNs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=JxB5Mq83; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 492E3nbX028187;
	Wed, 2 Oct 2024 14:16:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from
	:to:cc:subject:date:message-id:in-reply-to:references
	:mime-version:content-transfer-encoding; s=pp1; bh=A7ZMEdNmTgiN7
	NsGdNH6Pv8P47YEkBKClc7VeU53JJg=; b=JxB5Mq83UjVcT9wphw9ntkKlYNeSt
	fpqs7kfobk7zBV5rSx/PaNo0LTUJwUPc57TJNxh6uniEkYE0JVMFtEVCOcGIfwlO
	MJ/XTG/GGTxOMnZvVB4EHqBErdT6JOAEJ33oWfz9aL+jd0GxOLYe6DbL31zfNjag
	6LXXNqvpGuehsuYjfhHiq83pz9ZZUo7p5geB2ljQ5AEkN7i84KOALD2OMDNtoCCV
	/C5x2b+QPOydgJt0LmWexMbsBH2fSWUsle30ob5HfxFGTe4yw+CT/2LOiqLq4t0v
	zQS73ElOjNMb5sXRVcX6EfNj6idM+5Qid7YXzjB1KpipKEUA/fRdmPn0A==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4217kv82dp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 02 Oct 2024 14:16:21 +0000 (GMT)
Received: from m0353729.ppops.net (m0353729.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 492EGLbx018353;
	Wed, 2 Oct 2024 14:16:21 GMT
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4217kv82dd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 02 Oct 2024 14:16:21 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 492BVeUc002356;
	Wed, 2 Oct 2024 14:16:20 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 41xxu1abyg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 02 Oct 2024 14:16:20 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 492EGGK344171634
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 2 Oct 2024 14:16:17 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D561520040;
	Wed,  2 Oct 2024 14:16:16 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 992362004D;
	Wed,  2 Oct 2024 14:16:16 +0000 (GMT)
Received: from t35lp63.lnxne.boe (unknown [9.152.108.100])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed,  2 Oct 2024 14:16:16 +0000 (GMT)
From: Nico Boehr <nrb@linux.ibm.com>
To: frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [kvm-unit-tests PATCH v3 1/2] s390x: edat: move LC_SIZE to arch_def.h
Date: Wed,  2 Oct 2024 16:15:54 +0200
Message-ID: <20241002141616.357618-2-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002141616.357618-1-nrb@linux.ibm.com>
References: <20241002141616.357618-1-nrb@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Sct7xCrlz7-wnX49Whn5u2aimbBHVEnp
X-Proofpoint-ORIG-GUID: J5fTcUqgqU0T78JX8JIA185ytliycGip
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-02_13,2024-09-30_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 impostorscore=0
 phishscore=0 mlxlogscore=999 adultscore=0 lowpriorityscore=0
 priorityscore=1501 clxscore=1011 spamscore=0 mlxscore=0 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2408220000 definitions=main-2410020099

struct lowcore is defined in arch_def.h and LC_SIZE is useful to other
tests as well, therefore move it to arch_def.h.

Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
---
 lib/s390x/asm/arch_def.h | 1 +
 s390x/edat.c             | 1 -
 2 files changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/s390x/asm/arch_def.h b/lib/s390x/asm/arch_def.h
index 745a33878de5..5574a45156a9 100644
--- a/lib/s390x/asm/arch_def.h
+++ b/lib/s390x/asm/arch_def.h
@@ -119,6 +119,7 @@ enum address_space {
 
 #define CTL2_GUARDED_STORAGE		(63 - 59)
 
+#define LC_SIZE	(2 * PAGE_SIZE)
 struct lowcore {
 	uint8_t		pad_0x0000[0x0080 - 0x0000];	/* 0x0000 */
 	uint32_t	ext_int_param;			/* 0x0080 */
diff --git a/s390x/edat.c b/s390x/edat.c
index 16138397017c..e664b09d9633 100644
--- a/s390x/edat.c
+++ b/s390x/edat.c
@@ -17,7 +17,6 @@
 
 #define PGD_PAGE_SHIFT (REGION1_SHIFT - PAGE_SHIFT)
 
-#define LC_SIZE	(2 * PAGE_SIZE)
 #define VIRT(x)	((void *)((unsigned long)(x) + (unsigned long)mem))
 
 static uint8_t prefix_buf[LC_SIZE] __attribute__((aligned(LC_SIZE)));
-- 
2.46.2


