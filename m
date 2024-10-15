Return-Path: <kvm+bounces-28917-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D929999F306
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2024 18:44:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8CBB11F2169B
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2024 16:44:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E73A1F76C2;
	Tue, 15 Oct 2024 16:43:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="emPyMtaD"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08EDB1F76AE;
	Tue, 15 Oct 2024 16:43:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729010615; cv=none; b=AP4KJDnA/tS2xxxbDXJB6FygcFYxOC0/VfgGp7Ja0jpYaEPvC6Fp/nqSlsryYlrcZuvzYiS6dj6Qp789F44OCq9ZSiJtMCHQ/0dOM4yn9xnYH1AfK8KNFaLh4wMa+/tZaNb8lQ5nvR78H9KbBdwCbxnxFSNN++9AXzBGlFyU/eM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729010615; c=relaxed/simple;
	bh=28wM1qxewzfvNwL0+ykl/a4jcDIEgRX7sG0DD0vn/No=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JozlzrUnrbwM21xaEzoeN2g7+L/oqIsjjnur6TqjM5kAKJQCi0JFDlDSLfAls5ZOwTwk+ZqMmjCF6Et5WfRxeNFYQ9oSgHK6l74aTgcWjO6TcBcZx1iJA4FkhbdE8v/eZ7cOg7bWQWnQfTkfwXbEW3iYHvHrSVGAvMDbMwiKAdU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=emPyMtaD; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49FFoU9Y031440;
	Tue, 15 Oct 2024 16:43:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=SJpHHEjRWzFGDQeMj
	OuxfSFN2DEbe/pb15pnfE0bjyU=; b=emPyMtaDaNsXav3wxcUSHnTstBDPxgwBh
	jUX7D2y5/xrYKQ/1jDWktrJ3j1RSTLqmJq1HA8DxzKYzoOGVkN7DyI/1TqdllbYl
	eh7hYq6yN8h3R/JoKMnl4EgyFDMJdL7AadvbNTfHeo6uZCwUnUEMg8/ec7Ri8PB1
	aeDBMFfuhRithmogR+0HLE9XD/frdcYgSSmEpMeWQ4l0Af/HF2943MQCtgUtUc0z
	DZQoz7B39MFP9Q2XZWDjP8mdG+DkczxlCxZmjJt7WLKQzOvJ39iiqDDtifp/9RQI
	DfrvfE3tByWNN+0NvNQbivNpvUxuIbSRcboTEs+6nkMIzjDLI8Bzw==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 429ucwg8kx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 15 Oct 2024 16:43:32 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 49FE7Vka002473;
	Tue, 15 Oct 2024 16:43:32 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4284emmxax-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 15 Oct 2024 16:43:32 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 49FGhSpM50069774
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 15 Oct 2024 16:43:28 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2DFF420043;
	Tue, 15 Oct 2024 16:43:28 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 064CA2004E;
	Tue, 15 Oct 2024 16:43:28 +0000 (GMT)
Received: from p-imbrenda.boeblingen.de.ibm.com (unknown [9.152.224.66])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 15 Oct 2024 16:43:27 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: borntraeger@de.ibm.com, nsg@linux.ibm.com, nrb@linux.ibm.com,
        frankja@linux.ibm.com, seiden@linux.ibm.com, hca@linux.ibm.com,
        agordeev@linux.ibm.com, gor@linux.ibm.com,
        gerald.schaefer@linux.ibm.com, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: [PATCH v3 07/11] s390/mm/gmap: Remove gmap_{en,dis}able()
Date: Tue, 15 Oct 2024 18:43:22 +0200
Message-ID: <20241015164326.124987-8-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015164326.124987-1-imbrenda@linux.ibm.com>
References: <20241015164326.124987-1-imbrenda@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: Qi8ezuG3vi0fDN5plE30qjHRTkb9RQBY
X-Proofpoint-GUID: Qi8ezuG3vi0fDN5plE30qjHRTkb9RQBY
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 malwarescore=0
 mlxlogscore=801 spamscore=0 priorityscore=1501 impostorscore=0
 lowpriorityscore=0 suspectscore=0 bulkscore=0 adultscore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2409260000 definitions=main-2410150113

Remove gmap_enable(), gmap_disable(), and gmap_get_enabled() since they do
not have any users anymore.

Suggested-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 arch/s390/include/asm/gmap.h |  3 ---
 arch/s390/mm/gmap.c          | 31 -------------------------------
 2 files changed, 34 deletions(-)

diff --git a/arch/s390/include/asm/gmap.h b/arch/s390/include/asm/gmap.h
index 9725586f4259..64761c78f774 100644
--- a/arch/s390/include/asm/gmap.h
+++ b/arch/s390/include/asm/gmap.h
@@ -107,9 +107,6 @@ void gmap_remove(struct gmap *gmap);
 struct gmap *gmap_get(struct gmap *gmap);
 void gmap_put(struct gmap *gmap);
 
-void gmap_enable(struct gmap *gmap);
-void gmap_disable(struct gmap *gmap);
-struct gmap *gmap_get_enabled(void);
 int gmap_map_segment(struct gmap *gmap, unsigned long from,
 		     unsigned long to, unsigned long len);
 int gmap_unmap_segment(struct gmap *gmap, unsigned long to, unsigned long len);
diff --git a/arch/s390/mm/gmap.c b/arch/s390/mm/gmap.c
index a8746f71c679..329682655af2 100644
--- a/arch/s390/mm/gmap.c
+++ b/arch/s390/mm/gmap.c
@@ -281,37 +281,6 @@ void gmap_remove(struct gmap *gmap)
 }
 EXPORT_SYMBOL_GPL(gmap_remove);
 
-/**
- * gmap_enable - switch primary space to the guest address space
- * @gmap: pointer to the guest address space structure
- */
-void gmap_enable(struct gmap *gmap)
-{
-	get_lowcore()->gmap = (unsigned long)gmap;
-}
-EXPORT_SYMBOL_GPL(gmap_enable);
-
-/**
- * gmap_disable - switch back to the standard primary address space
- * @gmap: pointer to the guest address space structure
- */
-void gmap_disable(struct gmap *gmap)
-{
-	get_lowcore()->gmap = 0UL;
-}
-EXPORT_SYMBOL_GPL(gmap_disable);
-
-/**
- * gmap_get_enabled - get a pointer to the currently enabled gmap
- *
- * Returns a pointer to the currently enabled gmap. 0 if none is enabled.
- */
-struct gmap *gmap_get_enabled(void)
-{
-	return (struct gmap *)get_lowcore()->gmap;
-}
-EXPORT_SYMBOL_GPL(gmap_get_enabled);
-
 /*
  * gmap_alloc_table is assumed to be called with mmap_lock held
  */
-- 
2.47.0


