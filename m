Return-Path: <kvm+bounces-20088-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8528A9107E8
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2024 16:17:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B4E201C21613
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2024 14:17:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A16A91AE0A5;
	Thu, 20 Jun 2024 14:17:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="bgtdjozk"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B92B1AD9F4;
	Thu, 20 Jun 2024 14:17:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718893038; cv=none; b=l8awc3A44qZRlYTrqX7+qO1Z+OiF5d97XmfNv4hkNFWsXtFnwCRAFdjcCyJflAb7im+JfQVA8W9ust1BcfxI1FJDvllWCo9iCRrq3U4uxLUmiVvScGpvzjoWWqzO/GKpQbHE2dTyb0cvQqOiENcUN7DwSU2WndT4Tk74vkdZMro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718893038; c=relaxed/simple;
	bh=6s0f4LnN/nltxozjmOmalCHRIrjHYE78BKI7JROLR/0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=sKGhdFAKXdx3tXeUtHitpgb0x61K0wQYSmhrqH359qn7R5z7AEHHQgK04s17elYLM8U7BANSfFfN79VOfVnWNgbJH/O4cyFF6Y1VeC7tUOiK2p2j8Tu9U2Afefsu3clTgmh7W9Qjju2p26vm7+ClYMJXDxUOuZgV5NE8jiR3nEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=bgtdjozk; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353723.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45KChqAv028774;
	Thu, 20 Jun 2024 14:17:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from
	:to:cc:subject:date:message-id:in-reply-to:references
	:mime-version:content-transfer-encoding; s=pp1; bh=RdSen22QYJg8Z
	pbu+FAoTU1FhfAmbp5otZs5W4EN8GI=; b=bgtdjozksmPd0JESDWJI7osAjBihK
	UuXC1qSyAm+KsYFdvVLe4gxjBV1vEPYjgCjeNs+sTHeIT7kPwxS3Lsh8DHYqjCbv
	lvQRWE2LGjfN+0NLz2mU2v1hzztvDyDHnnxC9m4r/GD6KAhdGx/tvPraLKWViApM
	Tx8SjX873DB6avCu68QNeGIgrC52whHafvUOxrLFuc2Nen8JeDBF+3Rfk23M1+Jq
	qTIBOcG6CfTOP+z6VbHVYi20XY/l5okEo7yLovsLDics4jft02rZ9J1WAnrwtY29
	Kx6XT+sEzc1XGwPTZOWMhTemBjl8UbQEqCBUvh2LQYQmagY2MVLsHMqPQ==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3yvg2s8yv9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 20 Jun 2024 14:17:09 +0000 (GMT)
Received: from m0353723.ppops.net (m0353723.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 45KEH9cX027020;
	Thu, 20 Jun 2024 14:17:09 GMT
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3yvg2s8yv7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 20 Jun 2024 14:17:09 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 45KD1d2T009433;
	Thu, 20 Jun 2024 14:17:08 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 3ysqgn6gev-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 20 Jun 2024 14:17:08 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 45KEH3VN22544686
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 20 Jun 2024 14:17:05 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id F1F6F2004E;
	Thu, 20 Jun 2024 14:17:02 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B16492004F;
	Thu, 20 Jun 2024 14:17:02 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 20 Jun 2024 14:17:02 +0000 (GMT)
From: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
To: Claudio Imbrenda <imbrenda@linux.ibm.com>,
        =?UTF-8?q?Nico=20B=C3=B6hr?= <nrb@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>
Cc: Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
        Thomas Huth <thuth@redhat.com>, Nicholas Piggin <npiggin@gmail.com>,
        kvm@vger.kernel.org, Andrew Jones <andrew.jones@linux.dev>,
        David Hildenbrand <david@redhat.com>, linux-s390@vger.kernel.org
Subject: [kvm-unit-tests PATCH v3 2/7] s390x: lib: Remove double include
Date: Thu, 20 Jun 2024 16:16:55 +0200
Message-Id: <20240620141700.4124157-3-nsg@linux.ibm.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20240620141700.4124157-1-nsg@linux.ibm.com>
References: <20240620141700.4124157-1-nsg@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: aPD2wXub83KCHUh9kS3C57a0XUAB9zIJ
X-Proofpoint-ORIG-GUID: uDsDrJ7PX9cWMGhCAoHEdVMZ2FEublYe
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-20_07,2024-06-20_04,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 mlxscore=0
 clxscore=1015 impostorscore=0 lowpriorityscore=0 malwarescore=0
 adultscore=0 suspectscore=0 bulkscore=0 phishscore=0 priorityscore=1501
 mlxlogscore=847 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2405170001 definitions=main-2406200099

libcflat.h was included twice.

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
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


