Return-Path: <kvm+bounces-29017-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DBADA9A111B
	for <lists+kvm@lfdr.de>; Wed, 16 Oct 2024 20:03:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0F3741C20CE6
	for <lists+kvm@lfdr.de>; Wed, 16 Oct 2024 18:03:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 28931210C20;
	Wed, 16 Oct 2024 18:03:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="aYL4rq34"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE10516C687;
	Wed, 16 Oct 2024 18:03:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729101811; cv=none; b=ShweCUWtzoAGK3w3pdceq25KsR8kd1GaCHZ9gv4kqZak+a49cHG8Qdq+PuRwXPhL1sFBROds36uFlpu8fIae9PhTrbF7kkpYsu+ORykWP1b01+9XMXULPm67n7sJ5iz6DyvUDZQ3gRCtsNlzXuAcEgOiRkfJUkWr+w5hwOy4aYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729101811; c=relaxed/simple;
	bh=79KFaoumqZ7cj42rYHd/bP4QBS2zctffI5sl5Qqn2Xs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KniTCVeaezH5dXFuksQSeZ/PmNwDvL8UXorrrTMLNNLQdYyrKPfP3xGncCVMpF3yEwBmku/aF7mmn5aahN2WNhBUKmnKsrwCf4bErL/N41fE09aUjSeu313NqLa5PSlzY40rsynk8SIoePV1lVrlr1GfiYIrJgffNY6SrKPEHBE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=aYL4rq34; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49GGo2Sw027587;
	Wed, 16 Oct 2024 18:03:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=liuuKccCecQhEZUE3
	C4WUbtlMQFcpES2W+ZaJF4zahE=; b=aYL4rq34nnNvU60FfVPXMOoyl1r4hWdZ3
	jcnUkMabAvSqU15GAlaoxbYT4prs9Q3MJAuJg2r4SMzyB5c10Tuj0Ja5J6bbLxzL
	vU9luMB0X3PKilb9Vd2wL2wK5fCDtslrSdf3gMcv7F/BKtd/sMi5gvjChcM/rB57
	i2mOMHbabbzl6ugXNLY9TZp6XxRAcxutLopbSYxn+vjp7i0O/KnsKb9jJW0kQRPp
	vpr/Z0dOH8jbKIWC71VzS8UOe05dzheMfBhB4l7SLAVovWG4hxPb4VTSjnPnciH6
	cHbvEYBAUCQp4OxlD1AIq9TudALVoHxMF3crDgyi9rP3+gpTFuaLA==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 42ahbr09se-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 16 Oct 2024 18:03:28 +0000 (GMT)
Received: from m0353725.ppops.net (m0353725.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 49GI2QDN018570;
	Wed, 16 Oct 2024 18:03:27 GMT
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 42ahbr09sa-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 16 Oct 2024 18:03:27 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 49GEfwVJ005937;
	Wed, 16 Oct 2024 18:03:27 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4286512dqm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 16 Oct 2024 18:03:27 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 49GI3NFm35651840
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 16 Oct 2024 18:03:23 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9A0C820040;
	Wed, 16 Oct 2024 18:03:23 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 30EA52004B;
	Wed, 16 Oct 2024 18:03:23 +0000 (GMT)
Received: from tuxmaker.lnxne.boe (unknown [9.152.85.9])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 16 Oct 2024 18:03:23 +0000 (GMT)
From: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
To: Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        =?UTF-8?q?Nico=20B=C3=B6hr?= <nrb@linux.ibm.com>
Cc: Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
        Thomas Huth <thuth@redhat.com>, Nicholas Piggin <npiggin@gmail.com>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: [kvm-unit-tests PATCH v4 1/6] s390x: lib: Remove double include
Date: Wed, 16 Oct 2024 20:03:12 +0200
Message-ID: <20241016180320.686132-2-nsg@linux.ibm.com>
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
X-Proofpoint-GUID: AZyKa3oU_w-IYrFwk-VWms-sRtaNH7iP
X-Proofpoint-ORIG-GUID: kCEwJPaqE9mX1hPxvbgFqTspNkQh6G86
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 mlxlogscore=829
 clxscore=1015 adultscore=0 suspectscore=0 priorityscore=1501
 lowpriorityscore=0 malwarescore=0 mlxscore=0 phishscore=0 impostorscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2409260000 definitions=main-2410160115

libcflat.h was included twice.

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
Signed-off-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
---
 lib/s390x/sie.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/lib/s390x/sie.c b/lib/s390x/sie.c
index 28fbf146..40936bd2 100644
--- a/lib/s390x/sie.c
+++ b/lib/s390x/sie.c
@@ -14,7 +14,6 @@
 #include <sie.h>
 #include <asm/page.h>
 #include <asm/interrupt.h>
-#include <libcflat.h>
 #include <alloc_page.h>
 #include <vmalloc.h>
 #include <sclp.h>
-- 
2.44.0


