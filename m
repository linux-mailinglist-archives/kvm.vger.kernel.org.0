Return-Path: <kvm+bounces-37631-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5A3D2A2CBCB
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2025 19:46:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 458CC3AEF9B
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2025 18:46:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BCC8B1DE3D8;
	Fri,  7 Feb 2025 18:43:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ngGWZne0"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81CD21B415B;
	Fri,  7 Feb 2025 18:43:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738953788; cv=none; b=UAXqOx4tVsCvp0F1+xsxhCaWoCBJQ/7O5U63scP2ZQSIR7IA+B54NbkyUHswtfOPFb1gza0UYYxl994lID6/ZGlZtdcpIK1rb3ivbR7SpaEknyxBcfyk5ufy6AsoIb9kCf9GSBRjVh9AVqAcXT8s3wjfh/DGs+9Tx32ccF/kFiM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738953788; c=relaxed/simple;
	bh=fwr8OqvAlKugsufZvHpZOeNEgA7dt65mCk1pC0dH1Nk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TECUEjv9FU64Q9N1fR077F3Ohkfh8TASx9rYYXS6VS/V4SPk5LEgJUCZ93Yz9tEn3DavT3DfQedl2J+gSAd6lbLdXwYBILcQDnzPahiZ2GndFg7vo6RCVuZiTYNE52Lc7+lIopO2apnq6oiKC607o63bQIY8uMrBjeRtBG5WHz4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ngGWZne0; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 517HfrNw009275;
	Fri, 7 Feb 2025 18:43:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=corp-2023-11-20; bh=3NjNL
	hMvEyqe/yXAgspbGPylieUE1KvOmQHbOi6+uLk=; b=ngGWZne0VAfmZs0sBiowD
	zBTtIC3EozJ3CqfTWgJqRL0GZHEC3X/nqrU9FjVnMjl3rUt5R3VXa9a46n5qkgLd
	1UwLaeT84jkUU/ZTFu5vNXi3iliBFBtXlP0B6Km4RyUjO3VYYP1FTu9E5fy3PdeG
	+0BIlfQ3Mf/SeU39EjFsuFpuCWDbb0X/d/KHBmDJUA2/+FZjqfVdoqsVAETWbOt+
	HFguAPZFL0WrTkIRGTi+x6gEK03lEJM9meAE2tcQE2hySO+ALxafWWeJwSwRvU83
	jSB2sHfS0ocXEnjQLYhc7XDsCwsAICGdchmhvYTtvB+D9mqtC+2wPeg3l9QZWGca
	g==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 44mwwpjqsf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 07 Feb 2025 18:43:01 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 517Hbxg0022695;
	Fri, 7 Feb 2025 18:43:00 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 44j8ec86a4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 07 Feb 2025 18:43:00 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 517Idx9X037660;
	Fri, 7 Feb 2025 18:43:00 GMT
Received: from localhost.localdomain (ca-dev80.us.oracle.com [10.211.9.80])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 44j8ec8665-8;
	Fri, 07 Feb 2025 18:42:59 +0000
From: Dongli Zhang <dongli.zhang@oracle.com>
To: virtualization@lists.linux.dev, netdev@vger.kernel.org,
        kvm@vger.kernel.org
Cc: mst@redhat.com, jasowang@redhat.com, eperezma@redhat.com,
        michael.christie@oracle.com, pbonzini@redhat.com, stefanha@redhat.com,
        joao.m.martins@oracle.com, joe.jin@oracle.com, si-wei.liu@oracle.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH 7/9] vhost: add WARNING if log_num is more than limit
Date: Fri,  7 Feb 2025 10:41:51 -0800
Message-ID: <20250207184212.20831-8-dongli.zhang@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20250207184212.20831-1-dongli.zhang@oracle.com>
References: <20250207184212.20831-1-dongli.zhang@oracle.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-07_08,2025-02-07_03,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 phishscore=0 adultscore=0 malwarescore=0 bulkscore=0 suspectscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2501170000 definitions=main-2502070139
X-Proofpoint-ORIG-GUID: Aa41DM9V3T4iNcwENIKSysJOHJhVkliw
X-Proofpoint-GUID: Aa41DM9V3T4iNcwENIKSysJOHJhVkliw

Since long time ago, the only user of vq->log is vhost-net. The concern is
to add support for more devices (i.e. vhost-scsi or vsock) may reveals
unknown issue in the vhost API. Add a WARNING.

Suggested-by: Joao Martins <joao.m.martins@oracle.com>
Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
---
 drivers/vhost/vhost.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index db3b30aba940..8368370b40f7 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -2553,6 +2553,15 @@ static int get_indirect(struct vhost_virtqueue *vq,
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
@@ -2673,6 +2682,15 @@ int vhost_get_vq_desc(struct vhost_virtqueue *vq,
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


