Return-Path: <kvm+bounces-747-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1B09E7E2278
	for <lists+kvm@lfdr.de>; Mon,  6 Nov 2023 13:54:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4C32B1C20B3B
	for <lists+kvm@lfdr.de>; Mon,  6 Nov 2023 12:54:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2BC59262A2;
	Mon,  6 Nov 2023 12:54:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="bTUEg/PW"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F381E200B2
	for <kvm@vger.kernel.org>; Mon,  6 Nov 2023 12:54:10 +0000 (UTC)
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FB48112;
	Mon,  6 Nov 2023 04:54:08 -0800 (PST)
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3A6CGQuX003553;
	Mon, 6 Nov 2023 12:54:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=MB5zzyTKI3NQnXnkb7csPHpGCdQPKaVXi6iIQx/RL28=;
 b=bTUEg/PWr4cRzT6Trs8QiUHQ17qM3hl2M7lt1/dlO4ScDn1Jgn4r4ThypT+ZCagDsgR5
 /2sxvNqxaPt/yIlhWPdRdP660I2vLs33qjp8XtJOodfVXkOgW86nK1L5YpO77JOClkVh
 ZUKnbnNCVBvMgTFB3lcw0MT6n4XsGBwsyYy3LXLROis++0RcgpKYwVvbJQwhvgDzedzL
 pTBJ2Utwr4ngaoBIfiyUCncqfjYAOmKvv+gLgyRXv2e5OLU2MJID3MFhfFuuYSRKKKh4
 20gjfC7ZGR/DVMC6qcOAVSQRNFXzgzpCzq4UXgetRh7hn9txC5qzQ/yybXfijAn+fHH9 dg== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3u6v0cgndm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 06 Nov 2023 12:54:00 +0000
Received: from m0356517.ppops.net (m0356517.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3A6Cn7c4014273;
	Mon, 6 Nov 2023 12:53:59 GMT
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3u6v0cgnda-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 06 Nov 2023 12:53:59 +0000
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3A6AHcAJ016950;
	Mon, 6 Nov 2023 12:53:58 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 3u6301gqpw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 06 Nov 2023 12:53:58 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3A6CrtVL12386842
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 6 Nov 2023 12:53:55 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 747F820040;
	Mon,  6 Nov 2023 12:53:55 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 342382004B;
	Mon,  6 Nov 2023 12:53:55 +0000 (GMT)
Received: from t35lp63.lnxne.boe (unknown [9.152.108.100])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon,  6 Nov 2023 12:53:55 +0000 (GMT)
From: Nico Boehr <nrb@linux.ibm.com>
To: frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com,
        david@redhat.com, pbonzini@redhat.com, andrew.jones@linux.dev,
        lvivier@redhat.com
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [kvm-unit-tests PATCH v1 10/10] add make format
Date: Mon,  6 Nov 2023 13:51:06 +0100
Message-ID: <20231106125352.859992-11-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20231106125352.859992-1-nrb@linux.ibm.com>
References: <20231106125352.859992-1-nrb@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: es1FkEYpYr98geEir2AxQHBtm8ax_g08
X-Proofpoint-ORIG-GUID: jhqQgK9FUYgmB6eJfQR-d4KcEfP8hvFv
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-06_11,2023-11-02_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 lowpriorityscore=0
 suspectscore=0 adultscore=0 phishscore=0 spamscore=0 mlxlogscore=660
 clxscore=1015 impostorscore=0 malwarescore=0 priorityscore=1501
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2310240000 definitions=main-2311060104

Add target "format" to the makefile to format all source files with
clang-format.

This currently assumes all architectures want to opt-in to formatting
with clang-format. Maybe they don't want that, then we can move the
target to architecture-specific folders.

Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
---
 Makefile | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/Makefile b/Makefile
index 602910dda11b..b5509c74ad5b 100644
--- a/Makefile
+++ b/Makefile
@@ -147,3 +147,6 @@ tags:
 
 check-kerneldoc:
 	find . -name '*.[ch]' -exec scripts/kernel-doc -none {} +
+
+format:
+	find . -name '*.[ch]' ! -type l -exec clang-format -i {} +
-- 
2.41.0


