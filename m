Return-Path: <kvm+bounces-42548-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id EFBDAA79C25
	for <lists+kvm@lfdr.de>; Thu,  3 Apr 2025 08:37:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3957318957D2
	for <lists+kvm@lfdr.de>; Thu,  3 Apr 2025 06:35:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2EE441F4E25;
	Thu,  3 Apr 2025 06:32:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="UsWfHjIQ"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B51571EDA1F;
	Thu,  3 Apr 2025 06:32:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743661965; cv=none; b=fk+DQWVd2QoH7HBGvKofwH57stk6AOV6VEGOtYamG136ovYfB+LHTURL1d5a9eqe9S5e40yXceqfc98ZAtdg321b7dGEgBmd+N9pTC/BR1LYhQ3DGU1Ujq658Wo5sz00nadSvBXztrzS53eOkFtqilCS6+1XqDq3zvja+AvO0hw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743661965; c=relaxed/simple;
	bh=uztVkmR27RrLJhVMWS3gSB0GaN6dfxdSp88EyN2Ejg4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k8EfVyYwQp+a4rLg3jdRzZg2D+FlJ9lDwEkkg4V152QxfVYMscfuNutKoi6GzVpx7HkG1cpBKdnSB71VqNwkY5NjZqv9wjRva9FgoMgkNwoEClvMgz+CPdQs7Rc3fc8AmCi48BKDZCSvXYlJh+lSy876fSOvmesXxx7TfO/tXig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=UsWfHjIQ; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 532NMplT007992;
	Thu, 3 Apr 2025 06:32:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=corp-2023-11-20; bh=5M3Wb
	Ze0+PujfJxAkeePHj+l80RDxnrBCRw8iIzL62k=; b=UsWfHjIQckAEwNG6+gai2
	dqQleRDjPEIDpLuM1/ONn7qmrCCzPWd99XLKbhXEGsAmqbz9zPUZ+iTwGZS61HF0
	Fv4WVvo7uUIsb982qxQvnXjLaMX131vvYtWptmfTWOGYI1eUmTYmI1MTjXTWA1e7
	iP1l0w2lFqKKMi0iR6XwMwM8M+RTxCCsRkS0C8YRCes6JPOvcWJEF0fqsNzBb03Y
	MAM0batVs9zwdk4U9JYnFha8rZC7p9gvOTAl0ME8Gb1eARe4+j8alyHHcYR+hkKG
	FLOn+hV7/NCkwpFX540/lSicAifMr+PUgxGoW6P9zGOJ62Qtj8MOdfY9d9BD7/fY
	g==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 45p7n2cfsc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 03 Apr 2025 06:32:38 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5335wIZC002714;
	Thu, 3 Apr 2025 06:32:37 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 45pr8stj93-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 03 Apr 2025 06:32:37 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 5336WTxL032092;
	Thu, 3 Apr 2025 06:32:37 GMT
Received: from localhost.localdomain (ca-dev80.us.oracle.com [10.211.9.80])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 45pr8stj4h-10;
	Thu, 03 Apr 2025 06:32:37 +0000
From: Dongli Zhang <dongli.zhang@oracle.com>
To: virtualization@lists.linux.dev, kvm@vger.kernel.org,
        netdev@vger.kernel.org
Cc: mst@redhat.com, jasowang@redhat.com, michael.christie@oracle.com,
        pbonzini@redhat.com, stefanha@redhat.com, eperezma@redhat.com,
        joao.m.martins@oracle.com, joe.jin@oracle.com, si-wei.liu@oracle.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 9/9] vhost: add WARNING if log_num is more than limit
Date: Wed,  2 Apr 2025 23:29:54 -0700
Message-ID: <20250403063028.16045-10-dongli.zhang@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20250403063028.16045-1-dongli.zhang@oracle.com>
References: <20250403063028.16045-1-dongli.zhang@oracle.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1095,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-04-03_02,2025-04-02_03,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0
 mlxlogscore=999 mlxscore=0 phishscore=0 suspectscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2502280000 definitions=main-2504030033
X-Proofpoint-ORIG-GUID: kgS0KW0jpBbWJx7Er6dClfj_ZmUWpYwN
X-Proofpoint-GUID: kgS0KW0jpBbWJx7Er6dClfj_ZmUWpYwN

Since long time ago, the only user of vq->log is vhost-net. The concern is
to add support for more devices (i.e. vhost-scsi or vsock) may reveals
unknown issue in the vhost API. Add a WARNING.

Suggested-by: Joao Martins <joao.m.martins@oracle.com>
Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
---
 drivers/vhost/vhost.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index 494b3da5423a..b7d51d569646 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -2559,6 +2559,15 @@ static int get_indirect(struct vhost_virtqueue *vq,
 		if (access == VHOST_ACCESS_WO) {
 			*in_num += ret;
 			if (unlikely(log && ret)) {
+				/*
+				 * Since long time ago, the only user of
+				 * vq->log is vhost-net. The concern is to
+				 * add support for more devices (i.e.
+				 * vhost-scsi or vsock) may reveals unknown
+				 * issue in the vhost API. Add a WARNING.
+				 */
+				WARN_ON_ONCE(*log_num >= vq->dev->iov_limit);
+
 				log[*log_num].addr = vhost64_to_cpu(vq, desc.addr);
 				log[*log_num].len = vhost32_to_cpu(vq, desc.len);
 				++*log_num;
@@ -2679,6 +2688,15 @@ int vhost_get_vq_desc(struct vhost_virtqueue *vq,
 			 * increment that count. */
 			*in_num += ret;
 			if (unlikely(log && ret)) {
+				/*
+				 * Since long time ago, the only user of
+				 * vq->log is vhost-net. The concern is to
+				 * add support for more devices (i.e.
+				 * vhost-scsi or vsock) may reveals unknown
+				 * issue in the vhost API. Add a WARNING.
+				 */
+				WARN_ON_ONCE(*log_num >= vq->dev->iov_limit);
+
 				log[*log_num].addr = vhost64_to_cpu(vq, desc.addr);
 				log[*log_num].len = vhost32_to_cpu(vq, desc.len);
 				++*log_num;
-- 
2.39.3


