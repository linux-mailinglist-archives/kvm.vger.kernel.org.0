Return-Path: <kvm+bounces-57498-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7EDCCB56211
	for <lists+kvm@lfdr.de>; Sat, 13 Sep 2025 17:44:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CB3B2168FB9
	for <lists+kvm@lfdr.de>; Sat, 13 Sep 2025 15:44:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BD9682F3619;
	Sat, 13 Sep 2025 15:41:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="p+47StMQ"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CDE81DDDD
	for <kvm@vger.kernel.org>; Sat, 13 Sep 2025 15:41:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757778083; cv=none; b=hobMOKZsiJ6YXj2aFtTCTd1joDfhoWH3yT/arkCVFJgbkqWnjR27EPe1smnVJJNV3IVoaifVwDqZjJQyEwmSfbEl9vEsCfU9ZvtBITlNaaGLpyy0K3EUsZ+kUY/j9HcV7XvUh9iSShOH3CSDCURNPxvaMzZ2kzdxlf4OcnXTjRo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757778083; c=relaxed/simple;
	bh=9YNcDKbLqFAJWb2NwdOP/pYltlbdNyY7aeT8GX2nn28=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=SO8y6uBK5V8jFmLFjxz9U5KuiVkmKIGlv37y1BZ6JHUZe7U0tRW5m7nLC2s9Zb0CXjyZRtsVyT+cYAnLIqgc5RiVVvK8qiQ3xwHNqJmdxvGUsBdxIAUdfXx9VaZ8pqcXdsaIDOOs0eajjaSsswlopHFDKeaobBlVjN7+vpA1k48=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=p+47StMQ; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58D4KQBl003201;
	Sat, 13 Sep 2025 15:41:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=corp-2025-04-25; bh=duEkFTuiim7yr656vdSB2kH/y6Hjr
	VvMxqH74v06l90=; b=p+47StMQKtDbaiOOC9wNHm4iI3+tyILyUSpZDEA75mt24
	n49Li1HOLJ3a3+dDQMJGsk1LfFO791TvJPdGy8cf9mGmyT7dsZdA0nVEP3oUQmC9
	D9DahC738Arq8vLPzOW1TArPqhhcyDs/iafbYNmcaauGapVnLsr+KVkj5nLrWAM8
	dEnzR+EVpBRK/bLTz5kAbxJSXzzyNPFSI01dh7ybGzQZgasQ9fuiS9J8QJleP6x/
	psstzBUgwy/UolCM+lAKxYrnC9I31xwx7piKVLpv1M00wDuQW/ncq3gBW39PuH1C
	2YxeW31D/xIPBB++xjTg0DSDTbWCjdKjUT2odtzFw==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4950gbgbhn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 13 Sep 2025 15:41:11 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 58DCpW4m010926;
	Sat, 13 Sep 2025 15:41:10 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 494y29m2yp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 13 Sep 2025 15:41:10 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 58DFfAe5017140;
	Sat, 13 Sep 2025 15:41:10 GMT
Received: from ca-dev112.us.oracle.com (ca-dev112.us.oracle.com [10.129.136.47])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 494y29m2yf-1;
	Sat, 13 Sep 2025 15:41:10 +0000
From: Alok Tiwari <alok.a.tiwari@oracle.com>
To: michael.christie@oracle.com, pbonzini@redhat.com, stefanha@redhat.com,
        eperezma@redhat.com, mst@redhat.com, jasowang@redhat.com,
        virtualization@lists.linux.dev
Cc: alok.a.tiwari@oracle.com, kvm@vger.kernel.org
Subject: [PATCH] vhost-scsi: fix argument order in tport allocation error message
Date: Sat, 13 Sep 2025 08:40:53 -0700
Message-ID: <20250913154106.3995856-1-alok.a.tiwari@oracle.com>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-13_05,2025-09-12_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 adultscore=0
 mlxlogscore=999 spamscore=0 mlxscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2509130149
X-Proofpoint-GUID: opZhBGk6GXaDH4RoN5LrnB1EY409P980
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTEzMDAyNyBTYWx0ZWRfX6GW1HmdakNq+
 uWB9nFY7+RFZAAxeomt1Xuikaoephjgqrq0kHDBGPiZXsHVw4PdeFSbdmsJfv0gi095bgMVQAIW
 vFpo7413gFbmOZb74swv+ajOCJeGzNIyU1yhLR6W8/sxkqNemzRgwIHpO9YAaVZEc2G/3l6quoU
 MukNtf47rds2Nj2ZMTrkEg8xGB37UzbKSK/cKDVssplJ2o40FydZ5/+1WzQzbMKS7Xf32AF0I2V
 Q3ygQQnW67dwTSLstlovXzLjcX4aBz5lFSG0tz04ViHNH7EjqXn38QJEvxAeDtkHyrGB7tJCTeG
 fO7S+PJxBxU+V654gOye7MsTAY42AVvH+L4DCUWo+VE7Llpz6yK2keFMlT3JytvcwweCRLZWtUe
 0J+Z8+U3
X-Authority-Analysis: v=2.4 cv=QIloRhLL c=1 sm=1 tr=0 ts=68c59097 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=yJojWOMRYYMA:10 a=yPCof4ZbAAAA:8 a=8UqmF-xBEL7x54JPGKcA:9
 a=FjD-8dGO14Yd8gSk4-3N:22
X-Proofpoint-ORIG-GUID: opZhBGk6GXaDH4RoN5LrnB1EY409P980

The error log in vhost_scsi_make_tport() prints the arguments in the
wrong order, producing confusing output. For example, when creating a
target with a name in WWNN format such as "fc.port1234", the log
looks like:

  Emulated fc.port1234 Address: FCP, exceeds max: 64

Instead, the message should report the emulated protocol type first,
followed by the configfs name as:

  Emulated FCP Address: fc.port1234, exceeds max: 64

Fix the argument order so the error log is consistent and clear.

Signed-off-by: Alok Tiwari <alok.a.tiwari@oracle.com>
---
 drivers/vhost/scsi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index abf51332a5c5..98e4f68f4e3c 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -2884,7 +2884,7 @@ vhost_scsi_make_tport(struct target_fabric_configfs *tf,
 check_len:
 	if (strlen(name) >= VHOST_SCSI_NAMELEN) {
 		pr_err("Emulated %s Address: %s, exceeds"
-			" max: %d\n", name, vhost_scsi_dump_proto_id(tport),
+			" max: %d\n", vhost_scsi_dump_proto_id(tport), name,
 			VHOST_SCSI_NAMELEN);
 		kfree(tport);
 		return ERR_PTR(-EINVAL);
-- 
2.50.1


