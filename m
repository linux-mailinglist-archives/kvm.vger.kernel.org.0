Return-Path: <kvm+bounces-29395-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B1F6D9AA1D3
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2024 14:08:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 59ACF1F24014
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2024 12:08:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E4ECE1A254E;
	Tue, 22 Oct 2024 12:06:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="E2JxGBSm"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4025A19F42D;
	Tue, 22 Oct 2024 12:06:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729598780; cv=none; b=dfFo4iKR8bd2gnAHu3AZuRdUIoSUtF5pJe/J8//iX8D7jL8KnV2hSOq1g3s5hOGkPP7NG3WglhBTYZzncC8iWB4Eskro5zapZvICCPONUCe7Hg/j2brWT5f4poyqQH//iApwGaYHBzrR2dwOE1WeWs8zXYEyNG9FFYTnQQEPyAs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729598780; c=relaxed/simple;
	bh=U/Q0FYgw4N+6bjm1hhWprnFA8/rbFYZFZJYh9pLBgaw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sVoaL5uSE3J5Asuki7TxJbSNa/fTmetmaCGh5c3TBOHFQZsi8rq0PsxQhRIqZ6RckwIoUql9EUjsebv6Gn8CtpWgBvFXtY69UwiTBfmSXcMd66IAZjXtdtEvd91/O8kZg9NLxqKAKHxgCHi26xF/PN60BofZ+I2Tuv0k4mO1/bs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=E2JxGBSm; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49M2HJjE009455;
	Tue, 22 Oct 2024 12:06:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=jQXWkkdtFT5Ju/qQ7
	OlEmvEzDIGx9EoKxIFEulkLuPc=; b=E2JxGBSmvFZUYtDhKKvIC0S34xzyjT778
	uCoe3VK8E8wTF6UoLEo7iXCxinz+NpDMIUVIzLhJRTIJ0iCGI7BUG0Y+NIcqWrHP
	5sCIM00cYgGGckTH4XXVMdLP8/iRA5i/izo+kwkKIt4Kj3RWVujJKCgAm4v8tXYe
	6PJdq5YqNxWHaijAWuPLUxT2ScFCpIHVZ/8CmI8VlMcuvufK/y9EWbLJDsonp+Oh
	oziZC+GdWCIfkGQsfaRUsXINXWXfU2CDyuOqoA6z04IkbnHI0p6lCY/0n4GAhCkv
	v89Iq/ovoxnR6gANQbilHYBwTF2deVKvw0elob05wkzsVmo/GfDkA==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 42c5hmeevw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 22 Oct 2024 12:06:14 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 49M90l4P028879;
	Tue, 22 Oct 2024 12:06:13 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 42cqfxk76d-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 22 Oct 2024 12:06:13 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 49MC69Qs57606480
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 22 Oct 2024 12:06:09 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8EAEC20040;
	Tue, 22 Oct 2024 12:06:09 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id EE3BE2004B;
	Tue, 22 Oct 2024 12:06:08 +0000 (GMT)
Received: from p-imbrenda.ibmuc.com (unknown [9.171.37.93])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 22 Oct 2024 12:06:08 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: borntraeger@de.ibm.com, nsg@linux.ibm.com, nrb@linux.ibm.com,
        frankja@linux.ibm.com, seiden@linux.ibm.com, hca@linux.ibm.com,
        agordeev@linux.ibm.com, gor@linux.ibm.com,
        gerald.schaefer@linux.ibm.com, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, david@redhat.com
Subject: [PATCH v4 07/11] s390/mm/gmap: Remove gmap_{en,dis}able()
Date: Tue, 22 Oct 2024 14:05:57 +0200
Message-ID: <20241022120601.167009-8-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241022120601.167009-1-imbrenda@linux.ibm.com>
References: <20241022120601.167009-1-imbrenda@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 1xcBIag9uTvRw696clqHxokYf2_bdjVt
X-Proofpoint-GUID: 1xcBIag9uTvRw696clqHxokYf2_bdjVt
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 clxscore=1015
 phishscore=0 impostorscore=0 priorityscore=1501 lowpriorityscore=0
 bulkscore=0 mlxscore=0 adultscore=0 mlxlogscore=827 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2409260000 definitions=main-2410220074

Remove gmap_enable(), gmap_disable(), and gmap_get_enabled() since they do
not have any users anymore.

Suggested-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Heiko Carstens <hca@linux.ibm.com>
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


