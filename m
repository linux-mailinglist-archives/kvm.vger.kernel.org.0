Return-Path: <kvm+bounces-37096-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C3B09A2547E
	for <lists+kvm@lfdr.de>; Mon,  3 Feb 2025 09:36:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 539D21626E4
	for <lists+kvm@lfdr.de>; Mon,  3 Feb 2025 08:36:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C9F81FC101;
	Mon,  3 Feb 2025 08:36:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="bYTb9hyG"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A44C51D7E50
	for <kvm@vger.kernel.org>; Mon,  3 Feb 2025 08:36:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738571803; cv=none; b=RXjojhYbwGDkc2XlZTlWDB9EdPOmF8g0RG+6f3B/HBAduuzgUEqRnw9wD11jbO92cL4XVg+BnSdNPlpnXKxzv/MyN+YnjkQ+/ZUf7bBVcPKP1PO/zpto7PAW2Mc+PLofBK8rkqncPgURcG7hVKsb/ST8YyZIu2hJ0YTDjrcqXMo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738571803; c=relaxed/simple;
	bh=qqt7Q+//GI4rNMBXX4IRYsr3rE+Vmle6zFjPsDaJjPQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WTjf9e2GCDKnFntjwlfbCqBoRrTx03TlVrCpD+5/N7KOt5GHYrcyur9IHi8Y2pOAQdeQRqzP30Kq64BPO6m3/KcJmZLfjHeUDMlGeEHsu9iiiPN6HN1/Y4Y0pXPNZXzsx67DCL5wqae1AUF2pSTabP4xyZujnWzt2fdqxyWLf2s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=bYTb9hyG; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5137WuRV014569;
	Mon, 3 Feb 2025 08:36:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=rcBWNf3C389sJMalt
	KjoaLYkTg84hXHUImAs4E/eDTY=; b=bYTb9hyGsOp3yuOIfyBReMMzmMrKbi81u
	zqCslj+ROJnenK0AQ5/ZUTd2bG/7FCkMZCdqYM6o/7nDvyOZgQRRThJy92UM/qnJ
	VS/3oC41MLbcO1fP6VQtthsUJfOg+v1clVBHGbieNJczBE1XiOX4lo4p43/q6U0D
	vqzbLZxsblAV/BDEGsNyjCwCSuLZJoS1SjeKLrwfvuYMXTfGzrTTD2jbE+ZMntp1
	TQEOHPxfWQJx98aMz54cQ9850rKJ+hFnYB4HgoHkK5+8tgWR5ufiFiwIlcxshj7J
	Wk18S4HyOlaeFQ38T7twliNduJjWVFeVeBUhhJbkcTGXLhIFltB6g==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 44jsgng8qg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 03 Feb 2025 08:36:31 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5134kbe8021486;
	Mon, 3 Feb 2025 08:36:30 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 44j0n153g2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 03 Feb 2025 08:36:30 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5138aQGG54985064
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 3 Feb 2025 08:36:27 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id DE7F420040;
	Mon,  3 Feb 2025 08:36:26 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 676D02004B;
	Mon,  3 Feb 2025 08:36:26 +0000 (GMT)
Received: from t14-nrb.lan (unknown [9.171.84.16])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon,  3 Feb 2025 08:36:26 +0000 (GMT)
From: Nico Boehr <nrb@linux.ibm.com>
To: thuth@redhat.com, pbonzini@redhat.com, andrew.jones@linux.dev
Cc: kvm@vger.kernel.org, frankja@linux.ibm.com, imbrenda@linux.ibm.com,
        Nina Schoetterl-Glausch <nsg@linux.ibm.com>
Subject: [kvm-unit-tests GIT PULL 05/18] s390x: lib: Remove double include
Date: Mon,  3 Feb 2025 09:35:13 +0100
Message-ID: <20250203083606.22864-6-nrb@linux.ibm.com>
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
X-Proofpoint-GUID: UrbFlEDHy3NeaSj9q2E8NXjRIZ0AkyXl
X-Proofpoint-ORIG-GUID: UrbFlEDHy3NeaSj9q2E8NXjRIZ0AkyXl
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-03_03,2025-01-31_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=704 phishscore=0
 mlxscore=0 priorityscore=1501 clxscore=1015 adultscore=0 malwarescore=0
 impostorscore=0 lowpriorityscore=0 suspectscore=0 spamscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2501170000
 definitions=main-2502030068

From: Nina Schoetterl-Glausch <nsg@linux.ibm.com>

libcflat.h was included twice.

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
Signed-off-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
Link: https://lore.kernel.org/r/20241016180320.686132-2-nsg@linux.ibm.com
Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
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
2.47.1


