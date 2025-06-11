Return-Path: <kvm+bounces-49077-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 858A8AD5914
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 16:41:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E85CA1BC3386
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 14:40:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A10202BEC25;
	Wed, 11 Jun 2025 14:39:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="TQlEdrQd"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DAE02BD595;
	Wed, 11 Jun 2025 14:39:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749652785; cv=none; b=Qiw1p/yRLAiB8suDSUhUP3zf0r3G+uTy2Uyul3jM2lmeCgQVgaU3uRPtpxiwa29GlDGhmeWf0tmvpp1Vw2kIDgLSxbNp7DxFMHC0JmyOMrVq54CsneowIyNdOngyrZBmtoYrtQ4sI6udF9wEuUq12CMUNcA4w+/0Mv90h+EPojM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749652785; c=relaxed/simple;
	bh=WsomdLm8ml4c1Y0hcqRTbu8J/+zZxMNWJvjLs5P7AGo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lhv0E+KOJ93AlhLBUrx6/f3oZX+7kDaSMzxBMLoSdI5B2xBiB1TwA58Z8vtbQ6x08Zk18Exv655LsvwksVv7uNVcRy4kj1dx3QDn6qt5GN4jHgFk19bDtMGM54fOC9ldk/fPbgB4xYE9JFHq8XWJP52KvHt2F/FUKVn9PiuhxA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=TQlEdrQd; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 55BEdJmb000713;
	Wed, 11 Jun 2025 14:39:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=corp-2025-04-25; bh=Rihpw
	Y/OGMU7/euHmDRplxdxNijcth8OxqlWoZF3aJ4=; b=TQlEdrQdTJF4W/d4la4BT
	AwkaPLXoVP5tlVKkZeAGTUlh8PtHekmIgFleET3quZ9ZJg6y5X6coayTlv67AKFP
	n353MClH1mXiqP5APaLbmJtIBIZcuv4AE42AxH3fvPJWK/ugtr3iLwNGe2rWcGQK
	LqCE6K0URCV/2I2X+xxN+Ces0yKhgWTrpnv3C3lG3fj928OE4zRW3juKyGIunGjg
	fDe7w2FbVkwYBKbv/+Qt0a1hk6HU6MahY7lhpvkbPgoyd0iNtlxwUThjAIMC129L
	ZAT4W1Mft7H5vPHs9b+wwqabh3T1ZjFrHE9DSdSqAtvQfqxi44UATpTMjcJGPuUq
	g==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 474cbefggy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 11 Jun 2025 14:39:39 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 55BEUBoO021511;
	Wed, 11 Jun 2025 14:39:38 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 474bvb0csj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 11 Jun 2025 14:39:38 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 55BEda1o013641;
	Wed, 11 Jun 2025 14:39:37 GMT
Received: from ca-dev112.us.oracle.com (ca-dev112.us.oracle.com [10.129.136.47])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 474bvb0cr1-2;
	Wed, 11 Jun 2025 14:39:37 +0000
From: Alok Tiwari <alok.a.tiwari@oracle.com>
To: mst@redhat.com, jasowang@redhat.com, michael.christie@oracle.com,
        pbonzini@redhat.com, stefanha@redhat.com, eperezma@redhat.com,
        virtualization@lists.linux.dev, kvm@vger.kernel.org
Cc: alok.a.tiwari@oracle.com, darren.kenny@oracle.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] vhost-scsi: Improve error handling in vhost_scsi_make_nexus and tpg
Date: Wed, 11 Jun 2025 07:39:22 -0700
Message-ID: <20250611143932.2443796-2-alok.a.tiwari@oracle.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250611143932.2443796-1-alok.a.tiwari@oracle.com>
References: <20250611143932.2443796-1-alok.a.tiwari@oracle.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-06-11_05,2025-06-10_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999 bulkscore=0
 malwarescore=0 suspectscore=0 spamscore=0 phishscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2506110122
X-Proofpoint-GUID: yg6_qu5f86vFTsxjJLCwC99HToIjMVN4
X-Authority-Analysis: v=2.4 cv=BffY0qt2 c=1 sm=1 tr=0 ts=6849952b b=1 cx=c_pps a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17 a=6IFa9wvqVegA:10 a=yPCof4ZbAAAA:8 a=FKRWl_rJgknQzDKIOPAA:9 cc=ntf awl=host:13206
X-Proofpoint-ORIG-GUID: yg6_qu5f86vFTsxjJLCwC99HToIjMVN4
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjExMDEyMyBTYWx0ZWRfXwHWToEbyTeOs YQREjM88ZttM5vExwtMrszjbxwqO6Z8VC5W3orxWsvp+/dHbgyYwra5fbQkh28YxvW18xLBr+z9 zbE1DDLBcOws64lkVeA1WA/Pn7WdDtYcf0YUp9jVoLDUrC42ma59aTfHE8QzAdxFsHs1rwP6TuE
 WIqwQDpXgghoPhEzxeF1CGGJ72/W4AFn/eF91yQkkV5VebQbDEN3RIOoim/7s9j3V8eTFzztNwm /JDIZw0Zz8GuOZnx5zbnJMRNHtpuWbk4yEadq4fOC8HbZFU7Cu09GG8YMTdbT0U1QiUIi5staeU 4LFelKxwMPOB0dWBq07E1D6yI9cSdHkBewb5VKa7pIGJu17Wuuu2HBF6OWxPa7TBbeGRjN3bnH1
 LvBct9QUGMwEyPAtKSJfdCoMX9to/3vcaW0L4NAAqiIcIHTHw2unlp2EZcPblkdNi8kmGQZ1

Use PTR_ERR to return the actual error code when vhost_scsi_make_nexus
fails to create a session, instead of returning -ENOMEM.
This ensures more accurate error propagation.

Replace NULL with ERR_PTR(ret) in vhost_scsi_make_tpg to follow kernel
conventions for pointer-returning functions, allowing callers to use
IS_ERR and PTR_ERR for proper error handling.

Signed-off-by: Alok Tiwari <alok.a.tiwari@oracle.com>
---
 drivers/vhost/scsi.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index 508ff3b29f39..fd9e435d28bf 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -2594,6 +2594,7 @@ static int vhost_scsi_make_nexus(struct vhost_scsi_tpg *tpg,
 				const char *name)
 {
 	struct vhost_scsi_nexus *tv_nexus;
+	int ret;
 
 	mutex_lock(&tpg->tv_tpg_mutex);
 	if (tpg->tpg_nexus) {
@@ -2617,9 +2618,10 @@ static int vhost_scsi_make_nexus(struct vhost_scsi_tpg *tpg,
 					TARGET_PROT_DIN_PASS | TARGET_PROT_DOUT_PASS,
 					(unsigned char *)name, tv_nexus, NULL);
 	if (IS_ERR(tv_nexus->tvn_se_sess)) {
+		ret = PTR_ERR(tv_nexus->tvn_se_sess);
 		mutex_unlock(&tpg->tv_tpg_mutex);
 		kfree(tv_nexus);
-		return -ENOMEM;
+		return ret;
 	}
 	tpg->tpg_nexus = tv_nexus;
 
@@ -2810,7 +2812,7 @@ vhost_scsi_make_tpg(struct se_wwn *wwn, const char *name)
 	ret = core_tpg_register(wwn, &tpg->se_tpg, tport->tport_proto_id);
 	if (ret < 0) {
 		kfree(tpg);
-		return NULL;
+		return ERR_PTR(ret);
 	}
 	mutex_lock(&vhost_scsi_mutex);
 	list_add_tail(&tpg->tv_tpg_list, &vhost_scsi_list);
-- 
2.47.1


